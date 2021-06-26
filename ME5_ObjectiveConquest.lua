--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Objective")

local __SCRIPT_NAME = "ME5_ObjectiveConquest";
local debug = false

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

if bStockFontLoaded == nil then
	-- Has the stock font been loaded?
	bStockFontLoaded = false
end

MEU_GameMode = "meu_con"

CommandPostCaptureState = {
	Idle = 0,
	Neutralizing = 1,
	Capturing = 2,
}

--=============================
-- CommandPost
--	Class representing a specific CP, allowing some measure of customization
--	of what happens at each post when it is captured
--=============================
CommandPost =
{
	-- fields that need to be specified when calling New()
	name = "noname",			--name of the CP
	
	-- Overridable functions
	OnCapture = function()
		--override me to customize behavior when the command post is captured
	end,
}

function CommandPost:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--=============================
-- ObjectiveConquest
--	Handles the logic for a conquest game (A.K.A. capture the command posts)
--=============================
ObjectiveConquest = Objective:New
{
	-- external values
	icon = "hud_objective_icon_circle",
	
	-- internal values
	-- defaultBleedRate = 0.3333333333,			--how many units will be lost per second
	defaultBleedRate = 0.4444444444,			--how many units will be lost per second
	defeatTimerSeconds = 40,		--how long the defeat timer lasts after capping the all the CPs
	
	bCanShowCaptureMessage = true,
	numMsgDelayTimers = 0,
	bShowCPMarkers = true,
}

function ObjectiveConquest:GetOpposingTeam(team)
	if team == self.teamATT then
		return self.teamDEF
	else
		return self.teamATT
	end
end


function ObjectiveConquest:AddCommandPost(cp)
	--make sure we have a table to add the cp to
	self.commandPosts = self.commandPosts or {}
	self.commandPostStates = self.commandPostStates or {}
	self.commandPostAbortedNeutralize = self.commandPostAbortedNeutralize or {}
	
	--do all the error checking we can on the cp
	assert(cp.name, "WARNING: no name supplied for the command post")
	cp.name = string.lower(cp.name)
	
	self.commandPosts[cp.name] = cp
	self.commandPostStates[cp.name] = CommandPostCaptureState.Idle
	self.commandPostAbortedNeutralize[cp.name] = 0
	
	--keep a running tally of the bleedValue relative to each team
	if not self.totalBleedValue then
		self.totalBleedValue = {}
		self.totalBleedValue[self.teamATT] = 0
		self.totalBleedValue[self.teamDEF] = 0
	end
	self.totalBleedValue[self.teamATT] = self.totalBleedValue[self.teamATT] + GetCommandPostBleedValue(cp.name, self.teamATT)
	self.totalBleedValue[self.teamDEF] = self.totalBleedValue[self.teamDEF] + GetCommandPostBleedValue(cp.name, self.teamDEF)
end


--Add a threshold value for bleeding. Basically
function ObjectiveConquest:AddBleedThreshold(team, threshold, rate)
	--assert(team == self.teamATT or team == self.teamDEF, "invalid team!")
	
	if not self.bleedRates then
		--initialize the bleedRates two-dimensional array
		self.bleedRates = {}
		self.bleedRates[self.teamATT] = {}
		self.bleedRates[self.teamDEF] = {}
	end
	
	self.bleedRates[team][threshold] = rate
end

-- Get game time limit as set in game options menu, if any.  0 if none.
function ObjectiveConquest:GetGameTimeLimit()
	return ScriptCB_GetCONMaxTimeLimit()
end

function ObjectiveConquest:GameOptionsTimeLimitUp()
	local teamATTpts = GetReinforcementCount(teamATT)
	local teamDEFpts = GetReinforcementCount(teamDEF)
	if ( teamATTpts > teamDEFpts ) then
		self:Complete(teamATT)
	elseif ( teamATTpts < teamDEFpts ) then
		self:Complete(teamDEF)
	else
		ScriptCB_SndBusFade("music", 0.0, 1.0)
		--tied, so victory for both
		MissionVictory({1,2})
	end
end

function ObjectiveConquest:Start()
	
	if gCurrentMapManager.gameMode == "tdm" then
		print("ME5_ObjectiveConquest: Game mode is TDM, hiding CP HUD markers")
		bShowCPMarkers = false
	else
		print("ME5_ObjectiveConquest: Game mode is not TDM, showing CP HUD markers")
		bShowCPMarkers = true
	end
	
	--===============================
	-- Local functions
	--===============================
	
	
	local UpdateBleedRate = function(team)
		--count up the total bleedPoints (bleedPoints only count if they're on a CP owned by a different team)
		local bleedPoints = 0
		for i, cp in pairs(self.commandPosts) do
			local cpTeam = GetObjectTeam(cp.name)
			if cpTeam == self:GetOpposingTeam(team) then
				--print("cp.name:", cp.name, "bleedPoints:", GetCommandPostBleedValue(cp.name, cpTeam))			--uncomment me for test output!
				bleedPoints = bleedPoints + GetCommandPostBleedValue(cp.name, cpTeam)
			end
		end
		
		
		--set the bleed rate based on the total accumulated bleedPoints
		local bleedRate = 0.0		
		if self.bleedRates and self.bleedRates[team] then
			--look through the unsorted list for the highest threshold that bleedPoints is higher than
			local highestThresholdSoFar = 0
			for threshold, rate in pairs(self.bleedRates[team]) do
				if bleedPoints >= threshold and threshold > highestThresholdSoFar then
					bleedRate = rate
					highestThresholdSoFar = threshold
				end
			end
		else
			--default bleeding rule is to start bleeding when the team's bleed points are greater
			--than half the total points
			if bleedPoints > (self.totalBleedValue[team] / 2.0) then
				bleedRate = self.defaultBleedRate
			end
		end
		
		--print("totalbleedpts:", self.totalBleedValue[team])													--uncomment me for test output!
		--print("team:", team, "bleedPoints:", bleedPoints, "bleedRate:", bleedRate)							--uncomment me for test output!
	
		--setup the bleedrate display (i.e. how fast the score flashes in the HUD)
		SetBleedRate(team, bleedRate)
		
		if bleedRate > 0.0 then
			--start bleeding reinforcements
			StopTimer(self.bleedTimer[team])
			SetTimerValue(self.bleedTimer[team], 1.0)
			SetTimerRate(self.bleedTimer[team], bleedRate)
			StartTimer(self.bleedTimer[team])
			
			
			
			--[[if not ScriptCB_InMultiplayer() then
				if ME5_SideVar == 1 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."gth")
					end
				elseif ME5_SideVar == 2 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."col")
					end
				end
			else
				if gCurrentMapManager.onlineSideVar == "SSVxGTH" or gCurrentMapManager.onlineSideVar == 1 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."gth")
					end
				elseif gCurrentMapManager.onlineSideVar == "SSVxCOL" or gCurrentMapManager.onlineSideVar == 2 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."col")
					end
				end
			end]]
		else
			--stop bleeding reinforcements
			StopTimer(self.bleedTimer[team])
		end
	end
	
	
	--turns off the timers and resets the winningTeam number
	local DisableWinnerDoodads = function()
		self.winningTeam = 0
		StopTimer(self.defeatTimer)

		--hide the timers (HACK: this way of displaying the lose timer should be updated to use new HUD code)
		SetDefeatTimer(nil, self.teamATT)
		SetVictoryTimer(nil, self.teamATT)
		SetDefeatTimer(nil, self.teamDEF)
		SetVictoryTimer(nil, self.teamDEF)
	end
	
	
	local UpdateState = function()
		if self.multiplayerRules then
			UpdateBleedRate(self.teamDEF)
			UpdateBleedRate(self.teamATT)
		end	
	
		--check to see if one team (the winningTeam) has all the CPs
		self.winningTeam = 0
		for i, cp in pairs(self.commandPosts) do
			--NOTE: destroyed CP's aren't supposed to count against the win/loss accounting
			if IsObjectAlive(cp.name) then
				local cpTeam = GetObjectTeam(cp.name)
				
				if cpTeam == 0 then
					--can't have a winner if one of the CPs is still neutral
					DisableWinnerDoodads()
					return
				elseif self.winningTeam == 0 then
					--start tracking this team that might be winning
					self.winningTeam = cpTeam
				elseif self.winningTeam ~= cpTeam then
					--there is no winner, since we just found two CP's that don't match
					DisableWinnerDoodads()
					return
				end
			end
		end
				
		if self.winningTeam ~= 0 then
			if self.disallowDefensiveVictory and self.winningTeam ~= self.teamATT then
				return
			end
			
			if self.multiplayerRules then
				--start the defeat timer to end the game in a few seconds
				SetTimerValue(self.defeatTimer, self.defeatTimerSeconds)
				StartTimer(self.defeatTimer)
				
				--tell the C++ code about the defeat/victory timer (which will display it on the HUD)
				SetDefeatTimer(self.defeatTimer, self:GetOpposingTeam(self.winningTeam))
				SetVictoryTimer(self.defeatTimer, self.winningTeam)
			else
				--end the objective immediately
				self:Complete(self.winningTeam)
			end
		end
	end
	
	
	local InitBleedTimer = function(team)
		self.bleedTimer[team] = CreateTimer("bleed" .. team)
		
		OnTimerElapse(
			function (timer)				
				if GetReinforcementCount(team) > GetNumTeamMembersAlive(team) then
					--tick off a reinforcement when the timer elapses, and start it up again
					if GetReinforcementCount(team) > 0 then
						AddReinforcements(team, -1)
					end
					SetTimerValue(timer, GetTimerValue(timer) + 1.0)
					StartTimer(timer)					
				else
					--disallow bleeding when a team gets really low on reinforcements (so the team
					--doesn't run entirely out of units due to bleedrate, as per designer request)
					SetBleedRate(team, 0.0)
					StopTimer(timer)
				end
			end,
			self.bleedTimer[team]
			)
	end
	
	
	local InitDefeatTimer = function()
		self.defeatTimer = CreateTimer("defeat")
		SetTimerRate(self.defeatTimer, 1.0)
		
		OnTimerElapse(
			function (timer)
				StopTimer(timer)
				SetReinforcementCount(self:GetOpposingTeam(self.winningTeam), 0)
				self:Complete(self.winningTeam)
			end,
			self.defeatTimer
		)
	end
	
	
	local UpdatePostMapMarker = function(postPtr)
    	if not ScriptCB_InMultiplayer() then
			if not IsCampaign() and bShowCPMarkers == true then
				local playerTeam = GetCharacterTeam(0)
				local otherTeam = (3 - playerTeam)
				
				local pulseSize = false
				
				if self.commandPostStates[GetEntityName(postPtr)] == CommandPostCaptureState.Idle then
					pulseSize = false
				elseif self.commandPostStates[GetEntityName(postPtr)] == CommandPostCaptureState.Neutralizing then
					pulseSize = true
				elseif self.commandPostStates[GetEntityName(postPtr)] == CommandPostCaptureState.Capturing then
					pulseSize = true
				end
				
				-- If playerTeam owns the post, add a blue marker for playerTeam and a red marker for otherTeam
				if GetObjectTeam(postPtr) == playerTeam then
					MapRemoveEntityMarker(postPtr, playerTeam)
					MapRemoveEntityMarker(postPtr, otherTeam)
					
					MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, playerTeam, "BLUE", true, false, pulseSize)
					MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, otherTeam, "RED", true, false, pulseSize)
					
					
				-- If otherTeam owns the post, add a blue marker for otherTeam and a red marker for playerTeam
				elseif GetObjectTeam(postPtr) == otherTeam then
					MapRemoveEntityMarker(postPtr, playerTeam)
					MapRemoveEntityMarker(postPtr, otherTeam)
					
					MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, playerTeam, "RED", true, false, pulseSize)
					MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, otherTeam, "BLUE", true, false, pulseSize)
					
					
				-- If neither team owns the post, add a white marker for both teams
				else
					MapRemoveEntityMarker(postPtr, playerTeam)
					MapRemoveEntityMarker(postPtr, otherTeam)
					
					MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, playerTeam, "WHITE", true, false, pulseSize)
					MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, otherTeam, "WHITE", true, false, pulseSize)
				end
			end
		end
	end
	
	
	local function ShowCaptureMessage(postPtr)
		--print("ShowCaptureMessage(): Entered")
		if self.bCanShowCaptureMessage == false then return end
		
		if self.bCanShowCaptureMessage == true then
			-- Don't allow another capture message to be shown for a little bit
			self.bCanShowCaptureMessage = false
			SetTimerValue(self.postCaptureMsgBufferTimer, 3.0)
			StartTimer(self.postCaptureMsgBufferTimer)
			
			local msgDelayValue = 0.05					-- Duration in seconds to delay the message displaying which CP was captured
			local postName = GetEntityName(postPtr)		-- Name of the post that was captured
			local postTeam = GetObjectTeam(postName)	-- Captured post's team
			local playerTeam = GetCharacterTeam(0)		-- Player's team
			local msgContext = nil						-- Who captured the post from the player's perspective ("ally" or "enemy")
			local messageStr = nil
			
			if string.lower(GetWorldFilename()) == "vrm" then
				postName = string.sub(postName,1,3)
			end
			
			-- Does the captured post now belong to the player's team?
			if playerTeam == postTeam then
				msgContext = "ally"		-- "Allied forces have captured the..."
			else
				msgContext = "enemy"	-- "Enemy forces have captured the..."
			end
			
			-- Show first message
			ShowMessageText("level.common.events.con.post.captured_"..msgContext)
			
			-- Short delay before showing second message displaying which CP was captured
			--[[self.numMsgDelayTimers = self.numMsgDelayTimers + 1
			local postCaptureMsgDelayTimer = CreateTimer("postCaptureMsgDelayTimer"..self.numMsgDelayTimers)
			
			SetTimerValue(postCaptureMsgDelayTimer, msgDelayValue)
			StartTimer(postCaptureMsgDelayTimer)
			local postCaptureMsgDelayTimerElapse = OnTimerElapse(
				function(timer)]]
					messageStr = "level."..GetWorldFilename().."."..postName
					print("ShowCaptureMessage(): messageStr = ", messageStr)
					
					ShowMessageText(messageStr)
					
					--[[DestroyTimer(timer)
					postCaptureMsgDelayTimer = nil
					postCaptureMsgDelayTimerElapse = nil
					ReleaseTimerElapse(postCaptureMsgDelayTimerElapse)
				end,
			postCaptureMsgDelayTimer
			)]]
		end
	end
	
	
	if gCurrentMapManager.gameMode ~= "tdm" then
    	if not ScriptCB_InMultiplayer() then
    		if ME5_SideVar == 1 then
    			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_GTH_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_GTH_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_GTH_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_GTH_cpLost_enemy
    			
    		elseif ME5_SideVar == 2 then
    			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
    			
    		elseif ME5_SideVar == 3 then
    			snd_REP_cpCapture_ally	= snd_EVG_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_EVG_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_EVG_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_EVG_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_GTH_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_GTH_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_GTH_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_GTH_cpLost_enemy
    			
    		elseif ME5_SideVar == 4 then
    			snd_REP_cpCapture_ally	= snd_EVG_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_EVG_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_EVG_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_EVG_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
    			
    		elseif ME5_SideVar == 5 then
    			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
    			
    		end
    	else
    		if gCurrentMapManager.onlineSideVar == "SSVxGTH" or gCurrentMapManager.onlineSideVar == 1 then
    			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_GTH_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_GTH_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_GTH_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_GTH_cpLost_enemy
    			
    		elseif gCurrentMapManager.onlineSideVar == "SSVxCOL" or gCurrentMapManager.onlineSideVar == 2 then
    			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
    			
    		elseif gCurrentMapManager.onlineSideVar == "EVGxGTH" or gCurrentMapManager.onlineSideVar == 3 then
    			snd_REP_cpCapture_ally	= snd_EVG_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_EVG_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_EVG_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_EVG_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_GTH_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_GTH_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_GTH_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_GTH_cpLost_enemy
    			
    		elseif gCurrentMapManager.onlineSideVar == "EVGxCOL" or gCurrentMapManager.onlineSideVar == 4 then
    			snd_REP_cpCapture_ally	= snd_EVG_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_EVG_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_EVG_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_EVG_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
    			
    		elseif gCurrentMapManager.onlineSideVar == "SSVxRPR" or gCurrentMapManager.onlineSideVar == 5 then
    			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
    			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
    			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
    			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
    			
    			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
    			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
    			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
    			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
    			
    		end
    	end
    	
    	for i, cp in pairs(self.commandPosts) do
    		SetProperty(cp.name, "VO_Rep_RepCapture",	snd_REP_cpCapture_ally)
    		SetProperty(cp.name, "VO_Rep_CisCapture",	snd_REP_cpCapture_enemy)
    		SetProperty(cp.name, "VO_Rep_RepLost",		snd_REP_cpLost_ally)
    		SetProperty(cp.name, "VO_Rep_CisLost",		snd_REP_cpLost_enemy)
    		
    		SetProperty(cp.name, "VO_Cis_CisCapture",	snd_CIS_cpCapture_ally)
    		SetProperty(cp.name, "VO_Cis_RepCapture",	snd_CIS_cpCapture_enemy)
    		SetProperty(cp.name, "VO_Cis_CisLost",		snd_CIS_cpLost_ally)
    		SetProperty(cp.name, "VO_Cis_RepLost",		snd_CIS_cpLost_enemy)
    		
    		UpdatePostMapMarker(cp.name)
    	end
	
		if gCurrentMapManager.mapSize == "sm" or 
		   gCurrentMapManager.mapSize == "xs" or 
		   gCurrentMapManager.mapSize == "xxs" then
			SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 20)
			SetClassProperty("com_bldg_controlzone", "CaptureTime", 15)
		else
			SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 15)
			SetClassProperty("com_bldg_controlzone", "CaptureTime", 10)
		end
	end
	
	--==========
	-- Set the number of guys in the level to number in game options
	--==========
	ScriptCB_SetNumBots(ScriptCB_GetCONNumBots())

	--===============================
	-- Initialization logic
	--===============================	
	--initialize the base objective data first
	Objective.Start(self)
	
	--initialize internal values
	self.commandPosts = self.commandPosts or {}
	
	self.bleedTimer = {}
	InitBleedTimer(self.teamATT)
	InitBleedTimer(self.teamDEF)
	
	InitDefeatTimer()
	
	if self.multiplayerRules then
		self.disallowDefensiveVictory = false
	else
		self.disallowDefensiveVictory = true		--in single player/co-op, the defense can't win by capping all the CPs
	end
	
	numCPs = 0
	for i, cp in pairs(self.commandPosts) do
		if not self.multiplayerRules then
			MapAddEntityMarker(cp.name, self.icon, 4.0, self.teamATT, "YELLOW", true)
		end
		numCPs = numCPs + 1
	end
	if(numCPs == 0) then
		print ("ERROR: no valid CommandPosts were added to the ObjectiveConquest")
		return
	end	
	
	--set AI goals
	self.AIGoals = {}
	if self.AIGoalWeight > 0.0 then
		if gCurrentMapManager.gameMode == "conquest" then
			table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Conquest", 100*self.AIGoalWeight))
			table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Conquest", 100*self.AIGoalWeight))
		elseif gCurrentMapManager.gameMode == "tdm" then
			table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Deathmatch", 100*self.AIGoalWeight))
			table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Deathmatch", 100*self.AIGoalWeight))
		else
			print("ME5_ObjectiveConquest: ERROR! MapManager was given invalid gameMode value! Value is `"..gCurrentMapManager.gameMode..
				"`, should be `conquest` or `tdm`. Defaulting to Deathmatch goals")
			table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Deathmatch", 100*self.AIGoalWeight))
			table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Deathmatch", 100*self.AIGoalWeight))
		end
	end
	
	-- Create timers for CP capture messages
	self.postCaptureMsgBufferTimer = CreateTimer("postCaptureMsgBufferTimer")
	--ShowTimer(self.postCaptureMsgBufferTimer)		-- uncomment me for test output!
	
	--do an initial update on the state
	UpdateState()
	
	--=======================================
	-- Event responses
	--=======================================
	
	-- command post capture message buffer timer
	self.postCaptureMsgBufferTimerElapse = OnTimerElapse(
		function(timer)
			self.bCanShowCaptureMessage = true
		end,
		self.postCaptureMsgBufferTimer
	)
	
	OnBeginNeutralize(
		function(postPtr, holding)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			PrintLog("OnBeginNeutralize:", GetEntityName(postPtr), table.getn(holding))
			
			if debug == true and table.getn(holding) > 0 then
				tprint(holding)
			end
			
			self.commandPostAbortedNeutralize[GetEntityName(postPtr)] = 0
			
			self.commandPostStates[GetEntityName(postPtr)] = CommandPostCaptureState.Neutralizing
			
			UpdatePostMapMarker(postPtr)
		end
	)
	
	OnAbortNeutralize(
		function(postPtr, holding)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			-- OnAbortNeutralize gets spammed when initially called, so need to make sure that doesn't happen
			if self.commandPostAbortedNeutralize[GetEntityName(postPtr)] == 1 then return end
			
			PrintLog("OnAbortNeutralize:", GetEntityName(postPtr), table.getn(holding))
			
			if debug == true and table.getn(holding) > 0 then
				tprint(holding)
			end
			
			self.commandPostAbortedNeutralize[GetEntityName(postPtr)] = 1
			if table.getn(holding) == 0 then
				self.commandPostStates[GetEntityName(postPtr)] = CommandPostCaptureState.Idle
			end
			
			UpdatePostMapMarker(postPtr)
		end
	)
	
	-- command post neutralize
	OnFinishNeutralize(
		function(postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			PrintLog("OnFinishNeutralize:", GetEntityName(postPtr))
			
			self.commandPostStates[GetEntityName(postPtr)] = CommandPostCaptureState.Idle
			
			UpdatePostMapMarker(postPtr)
			UpdateState()
		end
	)
	
	OnBeginCapture(
		function(postPtr, holding)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			PrintLog("OnBeginCapture:", GetEntityName(postPtr), table.getn(holding))
			
			if debug == true and table.getn(holding) > 0 then
				tprint(holding)
			end
			
			self.commandPostStates[GetEntityName(postPtr)] = CommandPostCaptureState.Capturing
			
			UpdatePostMapMarker(postPtr)
		end
	)
	
	OnAbortCapture(
		function(postPtr, holding)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			PrintLog("OnAbortCapture:", GetEntityName(postPtr), table.getn(holding))
			
			if debug == true and table.getn(holding) > 0 then
				tprint(holding)
			end
			
			if table.getn(holding) == 0 then
				self.commandPostStates[GetEntityName(postPtr)] = CommandPostCaptureState.Idle
			end
			
			UpdatePostMapMarker(postPtr)
		end
	)
	
	-- command post captures
	OnFinishCapture(
		function(postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			PrintLog("OnFinishCapture:", GetEntityName(postPtr))
			
			self.commandPostStates[GetEntityName(postPtr)] = CommandPostCaptureState.Idle
			
			ShowCaptureMessage(postPtr)
			UpdatePostMapMarker(postPtr)
			UpdateState()
		end
	)
	
	-- command post spawn
	OnCommandPostRespawn(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			UpdatePostMapMarker(postPtr)
			UpdateState()
		end
	)
	
	-- command post kill
	OnCommandPostKill(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			if not self.multiplayerRules then
				MapRemoveEntityMarker(postPtr, self.teamATT)
			end
			
			UpdateState()
		end
	)
	
	-- spawn block for Husks -- 
	OnTicketCountChange(
		function (team, count)
			if team == CIS and count <= 20 then
					print("ME5_ObjectiveConquest: Blocking HuskTeam spawn")
				AllowAISpawn(3, false)
			end
		end
	)
	
	-- player spawn
	OnCharacterSpawn(
		function (player)
			if IsCharacterHuman(player) then
				-- Update all of the post markers
		    	for i, cp in pairs(self.commandPosts) do
		    		UpdatePostMapMarker(cp.name)
		    	end
			end
		end
	)
	
end

function ObjectiveConquest:Complete(winningTeam)
	print("ObjectiveConquest:Complete(): Entered")
	
	if not self.multiplayerRules then
		--remove all the cp markers
		for i, cp in pairs(self.commandPosts) do
			MapRemoveEntityMarker(cp.name)
		end
	end
	
	--then call the default objective complete method
	Objective.Complete(self, winningTeam)
end
