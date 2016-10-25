--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Objective")

if bStockFontLoaded == nil then
	-- Has the stock font been loaded?
	bStockFontLoaded = false
end

MEUGameMode = meu_siege

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
	
	-- optional values
	ticketsATT = nil,
	ticketsDEF = nil,
	bleedRateMultiplier = 1.5,
	
	-- internal values
	defaultBleedRate = 1.05,			--how many units will be lost per second	-- 0.7777777777
	defeatTimerSeconds = 40,		--how long the defeat timer lasts after capping all the CPs
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
	
	--do all the error checking we can on the cp
	assert(cp.name, "WARNING: no name supplied for the command post")
	cp.name = string.lower(cp.name)
			
	self.commandPosts[cp.name] = cp
	
	--keep a running tally of the bleedValue relative to each team
	if not self.totalBleedValue then
		self.totalBleedValue = {}
		self.totalBleedValue[self.teamATT] = 0
		self.totalBleedValue[self.teamDEF] = 0
	end
	
	-- If it's a captureable CP,
	if not string.find(cp.name, "permacp") then
		-- Set the bleed values all to 1
		SetProperty(cp.name, "ValueBleed_Alliance",	1)
		SetProperty(cp.name, "ValueBleed_CIS",		1)
		SetProperty(cp.name, "ValueBleed_Empire",	1)
		SetProperty(cp.name, "ValueBleed_Republic",	1)
		
		-- Add the bleed value to the total bleed points
		self.totalBleedValue[self.teamATT] = self.totalBleedValue[self.teamATT] + GetCommandPostBleedValue(cp.name, self.teamATT)
		self.totalBleedValue[self.teamDEF] = self.totalBleedValue[self.teamDEF] + GetCommandPostBleedValue(cp.name, self.teamDEF)
	end
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
	local team1pts = GetReinforcementCount(1)
	local team2pts = GetReinforcementCount(2)
	if ( team1pts > team2pts ) then
		MissionVictory(1)
	elseif ( team1pts < team2pts ) then
		MissionVictory(2)
	else
		--tied, so victory for both
		MissionVictory({1,2})
	end
end

function ObjectiveConquest:Start()
	--===============================
	-- Local functions
	--===============================
	
	
	local UpdateBleedRate = function(team)
		local bleedPoints = nil			-- The total number of CPs the other team owns
		local bleedSteps = nil			-- The number of levels of bleeding
		local curBleedStep = nil		-- The current bleed level
		
		--count up the total bleedPoints (bleedPoints only count if they're on a CP owned by a different team)
		bleedPoints = 0
		for i, cp in pairs(self.commandPosts) do
			local cpTeam = GetObjectTeam(cp.name)
			if cpTeam == self:GetOpposingTeam(team) then
				if not string.find(cp.name, "permacp") then
--					print("cp.name:", cp.name, "bleedPoints:", GetCommandPostBleedValue(cp.name, cpTeam))			--uncomment me for test output!
				end
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
			--start bleeding when the team's bleed points are greater than half the total points
			if bleedPoints > (self.totalBleedValue[team] / 2.0) then
				--bleedRate = self.defaultBleedRate
				
				bleedSteps = (self.totalBleedValue[team] - math.floor(self.totalBleedValue[team] / 2))
				curBleedStep = bleedPoints - math.floor(self.totalBleedValue[team] / 2)
				
				bleedRate = (curBleedStep / bleedSteps) * self.bleedRateMultiplier
			end
		end
		
--		print()
--		print("team:", team, "totalbleedpts:", self.totalBleedValue[team])									--uncomment me for test output!
--		print("team:", team, "bleedPoints:", bleedPoints, "bleedRate:", bleedRate)							--uncomment me for test output!
--		print("team:", team, "bleedSteps:", bleedSteps, "curBleedStep:", curBleedStep)						--uncomment me for test output!
--		print()
	
		--setup the bleedrate display (i.e. how fast the score flashes in the HUD)
		SetBleedRate(team, bleedRate)
		
		if bleedRate > 0.0 then
			--start bleeding reinforcements
			StopTimer(self.bleedTimer[team])
			SetTimerValue(self.bleedTimer[team], 1.0)
			SetTimerRate(self.bleedTimer[team], bleedRate)
			StartTimer(self.bleedTimer[team])
			
			
			
			if not ScriptCB_InMultiplayer() then
				if ME5_SideVar == 1 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."gth")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					end
				elseif ME5_SideVar == 2 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."col")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					end
				elseif ME5_SideVar == 3 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."gth")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."evg")
					end
				elseif ME5_SideVar == 4 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."col")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."evg")
					end
				end
			else
				if onlineSideVar == 1 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."gth")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					end
				elseif onlineSideVar == 2 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."col")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."ssv")
					end
				elseif onlineSideVar == 3 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."gth")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."evg")
					end
				elseif onlineSideVar == 4 then
					if team == REP then
						ShowMessageText("level.common.events.siege.control_".."col")
					elseif team == CIS then
						ShowMessageText("level.common.events.siege.control_".."evg")
					end
				end
			end
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
				--[[SetTimerValue(self.defeatTimer, self.defeatTimerSeconds)
				StartTimer(self.defeatTimer)
				
				--tell the C++ code about the defeat/victory timer (which will display it on the HUD)
				SetDefeatTimer(self.defeatTimer, self:GetOpposingTeam(self.winningTeam))
				SetVictoryTimer(self.defeatTimer, self.winningTeam)]]
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
--				if GetReinforcementCount(team) > GetNumTeamMembersAlive(team) then
					--tick off a reinforcement when the timer elapses, and start it up again
					if GetReinforcementCount(team) > 0 then
						AddReinforcements(team, -1)
					end
					SetTimerValue(timer, GetTimerValue(timer) + 1.0)
					StartTimer(timer)					
--				else
--					--disallow bleeding when a team gets really low on reinforcements (so the team
--					--doesn't run entirely out of units due to bleedrate, as per designer request)
--					SetBleedRate(team, 0.0)		-- TODO: probably remove this bleed-blocker
--					StopTimer(timer)
--				end
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
			if not IsCampaign() then
				local playerTeam = GetCharacterTeam(0)
				local otherTeam = (3 - playerTeam)
				
				-- Only attach marker to non-permacps
				if GetEntityClass(postPtr) == FindEntityClass("com_bldg_controlzone") then
					-- If playerTeam owns the post, add a blue marker for playerTeam and a red marker for otherTeam
					if GetObjectTeam(postPtr) == playerTeam then
						MapRemoveEntityMarker(postPtr, playerTeam)
						MapRemoveEntityMarker(postPtr, otherTeam)
						
						MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, playerTeam, "BLUE", true, false, false, true)
						MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, otherTeam, "RED", true, false, false, true)
						
						
					-- If otherTeam owns the post, add a blue marker for otherTeam and a red marker for playerTeam
					elseif GetObjectTeam(postPtr) == otherTeam then
						MapRemoveEntityMarker(postPtr, playerTeam)
						MapRemoveEntityMarker(postPtr, otherTeam)
						
						MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, playerTeam, "RED", true, false, false, true)
						MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, otherTeam, "BLUE", true, false, false, true)
						
						
					-- If neither team owns the post, add a white marker for both teams
					else
						MapRemoveEntityMarker(postPtr, playerTeam)
						MapRemoveEntityMarker(postPtr, otherTeam)
						
						MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, playerTeam, "WHITE", true, false, false, true)
						MapAddEntityMarker(postPtr, "hud_objective_icon", 0.75, otherTeam, "WHITE", true, false, false, true)
					end
				end
			end
		end
	end
	
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
			
		end
	else
		if onlineSideVar == 1 then
			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
			
			snd_CIS_cpCapture_ally	= snd_GTH_cpCapture_ally
			snd_CIS_cpCapture_enemy	= snd_GTH_cpCapture_enemy
			snd_CIS_cpLost_ally		= snd_GTH_cpLost_ally
			snd_CIS_cpLost_enemy	= snd_GTH_cpLost_enemy
			
		elseif onlineSideVar == 2 then
			snd_REP_cpCapture_ally	= snd_SSV_cpCapture_ally
			snd_REP_cpCapture_enemy	= snd_SSV_cpCapture_enemy
			snd_REP_cpLost_ally		= snd_SSV_cpLost_ally
			snd_REP_cpLost_enemy	= snd_SSV_cpLost_enemy
			
			snd_CIS_cpCapture_ally	= snd_COL_cpCapture_ally
			snd_CIS_cpCapture_enemy	= snd_COL_cpCapture_enemy
			snd_CIS_cpLost_ally		= snd_COL_cpLost_ally
			snd_CIS_cpLost_enemy	= snd_COL_cpLost_enemy
			
		elseif onlineSideVar == 3 then
			snd_REP_cpCapture_ally	= snd_EVG_cpCapture_ally
			snd_REP_cpCapture_enemy	= snd_EVG_cpCapture_enemy
			snd_REP_cpLost_ally		= snd_EVG_cpLost_ally
			snd_REP_cpLost_enemy	= snd_EVG_cpLost_enemy
			
			snd_CIS_cpCapture_ally	= snd_GTH_cpCapture_ally
			snd_CIS_cpCapture_enemy	= snd_GTH_cpCapture_enemy
			snd_CIS_cpLost_ally		= snd_GTH_cpLost_ally
			snd_CIS_cpLost_enemy	= snd_GTH_cpLost_enemy
			
		elseif onlineSideVar == 4 then
			snd_REP_cpCapture_ally	= snd_EVG_cpCapture_ally
			snd_REP_cpCapture_enemy	= snd_EVG_cpCapture_enemy
			snd_REP_cpLost_ally		= snd_EVG_cpLost_ally
			snd_REP_cpLost_enemy	= snd_EVG_cpLost_enemy
			
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
		
		SetProperty(cp.name, "NeutralizeTime",	12.0)
		SetProperty(cp.name, "CaptureTime",	3.0)	-- 8.0
    		
		UpdatePostMapMarker(cp.name)
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
	
	--initialize ticket counts
	if mapSize == xxs then
		self.ticketsATT = self.ticketsATT or 200
		self.ticketsDEF = self.ticketsDEF or 200
	elseif mapSize == xs then
		self.ticketsATT = self.ticketsATT or 250
		self.ticketsDEF = self.ticketsDEF or 250
	elseif mapSize == sm then
		self.ticketsATT = self.ticketsATT or 300
		self.ticketsDEF = self.ticketsDEF or 300
	elseif mapSize == med then
		self.ticketsATT = self.ticketsATT or 350
		self.ticketsDEF = self.ticketsDEF or 350
	elseif mapSize == lg then
		self.ticketsATT = self.ticketsATT or 400
		self.ticketsDEF = self.ticketsDEF or 400
	else
		self.ticketsATT = self.ticketsATT or 325
		self.ticketsDEF = self.ticketsDEF or 325
	end
	
	SetReinforcementCount(ATT, self.ticketsATT)
	SetReinforcementCount(DEF, self.ticketsDEF)
	
	
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
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Conquest", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Conquest", 100*self.AIGoalWeight))
	end
	
	--do an initial update on the state
	UpdateState()
	
	--=======================================
	-- Event responses
	--=======================================
	-- command post captures
	OnFinishCapture(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
						
			UpdatePostMapMarker(postPtr)
			UpdateState()
		end
		)
		
	-- command post neutralize
	OnFinishNeutralize(
		function (postPtr)				
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
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
			if team == CIS and count == 20 then				
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
	
	--[[CreateTimer("team1ticket_timer")
		SetTimerValue("team1ticket_timer", 20)
			team1ticket_flagged = 0
		ShowTimer("team1ticket_timer")
		OnTimerElapse(
			function(timer)
				team1ticket_flagged = 0
			end,
			"team1ticket_timer"
		)
	
	CreateTimer("team2ticket_timer")
		SetTimerValue("team2ticket_timer", 20)
			team2ticket_flagged = 0
		ShowTimer("team2ticket_timer")
		OnTimerElapse(
			function(timer)
				team2ticket_flagged = 0
			end,
			"team2ticket_timer"
		)]]
	
	-- These add reinforcements for CP captures
	--[[OnFinishCaptureTeam(
		function(post)
			local team1ticketcount = GetReinforcementCount(1)
			local team2ticketcount = GetReinforcementCount(2)
			local team2ticketquotient = GetReinforcementCount(2)
			local team1ticketbonus = team2ticketquotient / 2
			if team1ticketcount < 50 then
				if team2ticketcount > team1ticketcount then
					AddReinforcements(1, team1ticketbonus)
					ShowMessageText(team1ticketstring)
				else
					AddReinforcements(1, 0)
				end
			end
		end,
	1 -- Team number for the ticket bonus
	)
	
	OnFinishCaptureTeam(
		function(post)
			local team2ticketcount = GetReinforcementCount(2)
			local team1ticketcount = GetReinforcementCount(1)
			local team1ticketquotient = GetReinforcementCount(1)
			local team2ticketbonus = team1ticketquotient / 2
			if team2ticketcount < 50 then
				if team1ticketcount > team2ticketcount then
					AddReinforcements(2, team2ticketbonus)
					ShowMessageText(team2ticketstring)
				else
					AddReinforcements(2, 0)
				end
			end
		end,
	2 -- Team number for the ticket bonus
	)]]
	
	SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 20)
	SetClassProperty("com_bldg_controlzone", "CaptureTime", 20)
end

function ObjectiveConquest:Complete(winningTeam)
	if not self.multiplayerRules then
		--remove all the cp markers
		for i, cp in pairs(self.commandPosts) do
			MapRemoveEntityMarker(cp.name)
		end
		
		if ME5_CustomHUD == 1 then
			if bStockFontLoaded == false then
				bStockFontLoaded = true
					print("ME5_ObjectiveBFConquest: Loading hud_font_stock.lvl...")
				-- hotfix that reloads the stock fonts in the stats screen
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
			end
		end
	end
	
	--then call the default objective complete method
	Objective.Complete(self, winningTeam)
end
