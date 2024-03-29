--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

local __SCRIPT_NAME = "ME5_Objective";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

if not __OBJECTIVE_LUA__ then
__OBJECTIVE_LUA__ = 1

--
-- Base class for all mission objective types
--

if bStockFontLoaded == nil then
	-- Has the stock font been loaded?
	bStockFontLoaded = false
end

Objective = 
{
    --fields that need to be specified on creation
    teamATT = 1, 
    teamDEF = 2,
    text = nil,                 --the text that shows up for both teams. This overrides textATT and textDEF!
    textATT = nil,              --the text that shows up for the attackers
    textDEF = nil,              --the text that shows up for the defenders
	popupText = nil,			--the text that goes in the popup when the objective starts. if not defined, will not show a popup. only works if multiplayerRules == false
	multiplayerRules = false,	--if set to true, then the objective will be set up to use special multiplayer rules, otherwise
								--  will run with single player/coop rules.
    
    --optional fields
    timeLimit = 0,              --How long (in seconds) before the objective ends. If set to <= 0, then the timer is disabled
    timeLimitWinningTeam = 1,   --Indicates which team completes the objective when the time runs out
    
    --fields that are handled internally
    isComplete = false, winningTeam = 0,
    hideCPs = false,
    showTeamPoints = nil,
    AIGoalWeight = 1.0,
}

function Objective:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 
    return o
end

-- NOTE: added from ObjectiveConquest.lua - AG 30-NOV-2016
function Objective:GetOpposingTeam(team)
	if team == self.teamATT then
		return self.teamDEF
	else
		return self.teamATT
	end
end


--
-- DESIGNERS: Override this function when you want to customize extra behavior when an objective is activated
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function Objective:OnStart()

end

--
-- DESIGNERS: Override this function when you want to customize extra behavior when an objective is finished
--  (ask a lua coder if you need help with this...it's really pretty easy)
--
function Objective:OnComplete(winningTeam)

end


--
-- Call this to notify the C++ code that the objective exists, and wants to be added to the list of selectable objectives
--
function Objective:AddToDisplayableList()
	PrintLog("AddToDisplayableList(): Entered")
    if self.text then
		--Kind of kludgy, but for campaign the designers will use self.text
		--to uniquely ID the objective. So all this does is set up an objective for
		--the attacking team (the human players are always on teamATT in the campaign)
        AddMissionObjective(self.teamATT, self.text, self.popupText)
    else
        if self.textATT then
            AddMissionObjective(self.teamATT, self.textATT, self.popupText)
        end
        
        if self.textDEF then
            AddMissionObjective(self.teamDEF, self.textDEF, self.popupText)
        end
    end
end

function Objective:AddHint(hintText)
	PrintLog("AddHint(): Entered")
	self.hints = self.hints or {}	
	table.insert(self.hints, hintText)
end


function Objective:GetGameTimeLimit()
	return 0
end

function Objective:GameOptionsTimeLimitUp()
end

--
-- Call this to activate the objective after you have created an instance of the objective (using Objective:New)
--
function Objective:Start()
	PrintLog("Start(): Entered")
    --initialize values for data fields (even if they don't exist)
    self.teamATT = self.teamATT or 1
    self.teamDEF = self.teamDEF or 2
    self.isComplete = false
    self.winningTeam = self.teamDEF
    self.timeLimit = self.timeLimit or 0
    self.timeLimitWinningTeam = self.timeLimitWinningTeam or self.teamATT
    self.AIGoalWeight = self.AIGoalWeight or 1.0
    
    SetFlagGameplayType("none")
    
	if self.multiplayerRules then
		self.usingGameOptionsTimeLimit = self:GetGameTimeLimit()
		if ( self.usingGameOptionsTimeLimit ~= 0 ) then
			self.timeLimit = self.usingGameOptionsTimeLimit
		end
	else
		self.usingGameOptionsTimeLimit = 0
	end
    
    if self.hideCPs then
        -- turn off the command posts display on the minimap
        MapHideCommandPosts()
    end
	
	--activate all the mission hints for this objective
	if self.hints then
		for i, hintText in self.hints do
			AddMissionHint(hintText)
		end
	end
    
    if not self.container then
        --If there's a container, then the container will handle this logic.
        --Otherwise, we need to handle it ourselves.
        self:AddToDisplayableList()
        ClearAIGoals(self.teamATT)
        ClearAIGoals(self.teamDEF)
    end
    
    if self.showTeamPoints then
        ShowTeamPoints(self.teamATT, true)
        ShowTeamPoints(self.teamDEF, true)
    end
    
    
    --notify the c++ code that the objective exists
    if self.text then
        ActivateObjective(self.text)
    else
        if self.textATT then
            ActivateObjective(self.textATT)
        end
        
        if self.textDEF then
            ActivateObjective(self.textDEF)
        end
    end
	
	--show the popup for singleplayer/co-op
	if not self.multiplayerRules and self.popupText then
		ShowObjectiveTextPopup(self.popupText)
	end
	
    if self.timeLimit > 0 then
        --get or create a new loseTimer (this ensures there's only one "loseTimer" in the game at one time)
        self.loseTimer = FindTimer("loseTimer")
        if not self.loseTimer then
            self.loseTimer = CreateTimer("loseTimer")
        end
        
        --start ticking down the time
        SetTimerValue(self.loseTimer, self.timeLimit)
        StartTimer(self.loseTimer)
        ShowTimer(self.loseTimer)
    end
    
    --=================================
    --Event Responses
    --=================================
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "gth_ann_"
		elseif ME5_SideVar == 2 then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "col_gen_"
		elseif ME5_SideVar == 3	then
			rep_sndcue	= "evg_prm_"
			cis_sndcue	= "gth_ann_"
		elseif ME5_SideVar == 4	then
			rep_sndcue	= "evg_prm_"
			cis_sndcue	= "col_gen_"
		elseif ME5_SideVar == 5	then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "col_gen_"
		elseif ME5_SideVar == 6	then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "cer_ann_"
		end
	else
		if gCurrentMapManager.onlineSideVar == "SSVxGTH" then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "gth_ann_"
		elseif gCurrentMapManager.onlineSideVar == "SSVxCOL" then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "col_gen_"
		elseif gCurrentMapManager.onlineSideVar == "EVGxGTH" then
			rep_sndcue	= "evg_prm_"
			cis_sndcue	= "gth_ann_"
		elseif gCurrentMapManager.onlineSideVar == "EVGxCOL" then
			rep_sndcue	= "evg_prm_"
			cis_sndcue	= "col_gen_"
		elseif gCurrentMapManager.onlineSideVar == "SSVxRPR" then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "col_gen_"
		elseif gCurrentMapManager.onlineSideVar == "SSVxCER" then
			rep_sndcue	= "ssv_adm_"
			cis_sndcue	= "cer_ann_"
		end
	end
    
	if not self.container then
		--reduce reinforcement count on character death
		OnCharacterDeath(
			function (character, killer)
				local charTeam = GetCharacterTeam(character)
				if GetReinforcementCount(charTeam) > 0 then
					AddReinforcements(charTeam, -1)
				end
			end
		)
		
		--If a team runs out of reinforcements, they lose right away.
		--If you want to disable the reinforcement countdown,
		--call SetReinforcementCount(teamID, -1)
		OnTicketCountChange(
			function (team, count)
				if count <= 0 then
					-- Complete the objective for the opposing team instead of calling MissionDefeat - AG 30-NOV-2016
					self:Complete(self:GetOpposingTeam(team))
					--MissionDefeat(team)
				end
			end
		)
	end
	
    --if we have a loseTimer, make one of the teams complete the objective when it runs out
    if self.loseTimer then
        OnTimerElapse(
            function(timer)
                if self.isComplete then
                    return
                end
                
                if self.usingGameOptionsTimeLimit ~= 0 then
					self:GameOptionsTimeLimitUp()
					
					--[[if ME5_CustomHUD == 1 then
						if bStockFontLoaded == false then
							bStockFontLoaded = true
								PrintLog("Loading hud_font_stock.lvl...")
							-- hotfix that reloads the stock fonts in the stats screen
							ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
						end
					end]]
                else
					self:Complete(self.timeLimitWinningTeam)
					
					--[[if ME5_CustomHUD == 1 then
						if bStockFontLoaded == false then
							bStockFontLoaded = true
								PrintLog("Loading hud_font_stock.lvl...")
							-- hotfix that reloads the stock fonts in the stats screen
							ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
						end
					end]]
				end
            end,
            self.loseTimer
        )
    end
    
    --callback for overriding startup behavior
    self:OnStart()
end


--
-- If a container is set, then it takes over some of the logic that occurs when an objective is completed,
--  which allows for more complicated completion logic (like concurrent objectives and chains of objectives).
--  See: MultiObjectiveContainer.lua for details
--
function Objective:SetContainer(container)
	PrintLog("SetContainer(): Entered")
    self.container = container
end


--
-- Call this to finish the objective. First, it looks to see if it has a container, then lets the container
--  handle the logic, otherwise will set the MissionVictory on its own
--
function Objective:Complete(winningTeam)
	PrintLog("Complete(): Entered")
    if self.isComplete then return end
                    
    --unhide the CPs
    MapHideCommandPosts(false)
    
    self.isComplete = true
    self.winningTeam = winningTeam
    
    if self.loseTimer then
		ShowTimer(nil)
		DestroyTimer(self.loseTimer)
		self.loseTimer = nil
    end
    
    --clean up all the AIGoals for this objective
    if self.AIGoals then
        for i, goalPtr in ipairs(self.AIGoals) do
            DeleteAIGoal(goalPtr)
        end
    end
	
	--play a little ditty
	if not self.multiplayerRules then
		BroadcastVoiceOver("meu_objComplete", self.winningTeam)
	end
    
	--delay the actual objective end by a smidge to allow time for the ditty to finish playing
	--(since the designers tend to call other voiceovers from OnComplete)
	self.dittyTimer = FindTimer("dittyTimer")
	if not self.dittyTimer then
		self.dittyTimer = CreateTimer("dittyTimer")
	end
	SetTimerValue(self.dittyTimer, 1.0)
	StartTimer(self.dittyTimer)
	self.dittyTimerResponse = OnTimerElapse(
		function(timer)
			--update the objective's state in the c++ code
			if self.text then
				CompleteObjective(self.text)
			else
				if self.textATT then
					CompleteObjective(self.textATT)
				end
				
				if self.textDEF then
					CompleteObjective(self.textDEF)
				end
			end
			
			if self.container then
				self.container:NotifyObjectiveComplete(self)
			else
				-- Play a short VO narration if we're not a campaign mission 
				-- TODO: need to add VOs for SSVxRPR and SSVxCER
				if gCurrentMapManager.gameMode ~= "campaign" then
					-- Set the VO to use for each team
					if not ScriptCB_InMultiplayer() then
						if ME5_SideVar == 1 then
							rep_sndcue	= "ssv_adm_"
							cis_sndcue	= "gth_ann_"
						elseif ME5_SideVar == 2 then
							rep_sndcue	= "ssv_adm_"
							cis_sndcue	= "col_gen_"
						elseif ME5_SideVar == 3	then
							rep_sndcue	= "evg_prm_"
							cis_sndcue	= "gth_ann_"
						elseif ME5_SideVar == 4	then
							rep_sndcue	= "evg_prm_"
							cis_sndcue	= "col_gen_"
						end
					else
						if gCurrentMapManager.onlineSideVar == "SSVxGTH" then
							rep_sndcue	= "ssv_adm_"
							cis_sndcue	= "gth_ann_"
						elseif gCurrentMapManager.onlineSideVar == "SSVxCOL" then
							rep_sndcue	= "ssv_adm_"
							cis_sndcue	= "col_gen_"
						elseif gCurrentMapManager.onlineSideVar == "EVGxGTH" then
							rep_sndcue	= "evg_prm_"
							cis_sndcue	= "gth_ann_"
						elseif gCurrentMapManager.onlineSideVar == "EVGxCOL" then
							rep_sndcue	= "evg_prm_"
							cis_sndcue	= "col_gen_"
						end
					end
					
					-- Play the appropriate narration for each team
					if winningTeam == CIS then
						BroadcastVoiceOver( rep_sndcue.."com_report_defeat", REP )
						BroadcastVoiceOver( cis_sndcue.."com_report_victory", CIS )
					elseif winningTeam == REP then
						BroadcastVoiceOver( rep_sndcue.."com_report_victory", REP )
						BroadcastVoiceOver( cis_sndcue.."com_report_defeat", CIS )
					end
					
					-- TODO: consider using AudioStreamComplete instead of a pre-set timer (see MultiObjectiveContainer.lua for how)
					-- Allow enough time for the VO to fully play
					missionEndingNarrationTimer = CreateTimer("missionEndingNarrationTimer")
					SetTimerValue("missionEndingNarrationTimer", 6.0)	-- 1.5
					StartTimer("missionEndingNarrationTimer")
					OnTimerElapse(
						function(timer)
							ScriptCB_SndBusFade("music", 0.0, 1.0)
							-- FINISH HIM.
							MissionVictory(winningTeam)
							DestroyTimer("missionEndingNarrationTimer")
						end,
					"missionEndingNarrationTimer"
					)
				else
					ScriptCB_SndBusFade("music", 0.0, 1.0)
					MissionVictory(winningTeam)
				end
			end
			
			self:OnComplete(winningTeam)
			
			StopTimer(self.dittyTimer)

			PrintLog("release self.dittyTimerResponse")
			ReleaseTimerElapse(self.dittyTimerResponse)
			self.dittyTimerResponse = nil
		end,
		self.dittyTimer
	)
end



end --if not __OBJECTIVE_LUA__

PrintLog("Exited")