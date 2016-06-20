--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Objective")
ScriptCB_DoFile("ME5_SoundEvent_ctf")

MEUGameMode = meu_1flag

--=============================
-- ObjectiveCTF
--  Handles the logic for a capture the flag game
--=============================
ObjectiveOneFlagCTF = Objective:New
{ 
    -- required external values
    captureLimit = 5,
    flag = "noname",    
    homeRegion = nil,
    captureRegionATT = nil,
    captureRegionDEF = nil,
	capRegionDummyObjectATT = nil,		--need dummy objects so we can add an in-HUD marker (regions can't be marked in the HUD currently...it's a long story)
	capRegionDummyObjectDEF = nil,
    
    -- optional external values
	flagIcon = "hud_target_flag_onscreen",
    flagIconScale = 3.0,
	capRegionMarkerATT = "hud_objective_icon_circle",
    capRegionMarkerDEF = "hud_objective_icon_circle",
	capRegionMarkerScaleATT = 3.0,
    capRegionMarkerScaleDEF = 3.0,
    enemyFlagMessage = "game.oneflag.enemy.",
    friendFlagMessage = "game.oneflag.friend.",
}


-- DESIGNERS: Override this function if necessary
function ObjectiveOneFlagCTF:OnCapture(flag, carrier)

end

function ObjectiveOneFlagCTF:OnTaken(flag, carrier)

end

    
-- Get game time limit as set in game options menu, if any.  0 if none.
function ObjectiveOneFlagCTF:GetGameTimeLimit()
	return ScriptCB_GetCTFMaxTimeLimit()
end

function ObjectiveOneFlagCTF:GameOptionsTimeLimitUp()
	local team1pts = GetTeamPoints(1)
	local team2pts = GetTeamPoints(2)
	if ( team1pts > team2pts ) then
		MissionVictory(1)
	elseif ( team1pts < team2pts ) then
		MissionVictory(2)
	else	
		--tied, so victory for both
		MissionVictory({1,2})
	end
end


--
-- Initialize the capture objective
--
function ObjectiveOneFlagCTF:Start()
    --=============================
    -- local functions
    --============================= 
    local GetOpposingTeam = function(team)
        if team == self.teamATT then
            return self.teamDEF
        else
            return self.teamATT
        end
    end
    self.showTeamPoints = true
    
    local FlagMessage = function(friendTeam, message)
        if self.friendFlagMessage then
            ShowMessageText(self.friendFlagMessage .. message, friendTeam)
			
        end
		local opposingTeam = GetOpposingTeam(friendTeam)
        if self.enemyFlagMessage then
            ShowMessageText(self.enemyFlagMessage .. message, opposingTeam)
        end
		
		local missionTime = ScriptCB_GetMissionTime()
		local timeSinceLastPlayed = missionTime - self.lastVOPlayTime
		if timeSinceLastPlayed > 3.0 then
			SoundEvent_BroadcastVO( message, friendTeam, opposingTeam )
			self.lastVOPlayTime = missionTime
		end
    end
	
	local AddMarkers = function(team, bPulseFlag, bPulseCapRegion)
		local capRegion
		local capRegionMarker
		local capRegionMarkerScale
		local capRegionDummyObject
		if team == self.teamATT then
			capRegion = self.captureRegionATT
			capRegionMarker = self.capRegionMarkerATT
			capRegionMarkerScale = self.capRegionMarkerScaleATT
			capRegionDummyObject = self.capRegionDummyObjectATT
		elseif team == self.teamDEF then
			capRegion = self.captureRegionDEF
			capRegionMarker = self.capRegionMarkerDEF
			capRegionMarkerScale = self.capRegionMarkerScaleDEF
			capRegionDummyObject = self.capRegionDummyObjectDEF
		else
			return
		end
		
		if bPulseFlag then
			--show an in-hud marker for the flag
			MapAddEntityMarker(self.flag, self.flagIcon, self.flagIconScale, team, "YELLOW", true, false, true, true)			
		else
			MapRemoveEntityMarker(self.flag)
		end		
		
			
		if capRegionDummyObject then			
			if bPulseCapRegion then
				--show an in-hud marker for the region
				MapAddEntityMarker(capRegionDummyObject, capRegionMarker, capRegionMarkerScale, team, "YELLOW", bPulseCapRegion, false, bPulseCapRegion)
			else
				MapRemoveEntityMarker(capRegionDummyObject)
			end			
		else
			if bPulseCapRegion then
				--show the region on the map only
				MapAddRegionMarker(GetRegion(capRegion), capRegionMarker, capRegionMarkerScale,
									team, "YELLOW", true, false, true)
			else
				MapRemoveRegionMarker(GetRegion(capRegion))
			end
		end
	end
	
	local UpdateMarkerPulses = function()
        if not self.flagIcon then
            return end
    
        if self.carrier then
			local carrierTeam = GetCharacterTeam(self.carrier)
			local otherTeam = GetOpposingTeam(carrierTeam)
			
            --for the carrier team, turn on the pulsey on the cap region, turn it off for the flag
 			AddMarkers(carrierTeam, false, true)
								
			--for the other team, turn off the pulsey on the flag, and turn off the pulsey for the cap region
			AddMarkers(otherTeam, false, false)
        else
			--for both teams, turn the pulsey on the flag, and turn off the pulsey for the cap region
			AddMarkers(self.teamATT, true, false)
			AddMarkers(self.teamDEF, true, false)
        end 
    end

    
    local CaptureFlag = function(carrierTeam)
        AddFlagCapturePoints(GetFlagCarrier(self.flag))
        FlagMessage(carrierTeam, "captured")
        AddTeamPoints(carrierTeam, 1)
		
		self:OnCapture(self.flag, self.carrier)
		self.carrier = nil
		
        KillObject(self.flag)
    end
    
	--==========
	-- Set the number of guys in the level to number in game options
	--==========
	ScriptCB_SetNumBots(ScriptCB_GetCTFNumBots())
    
    --===============================
    -- Initialization logic
    --===============================   
    --initialize the base objective data first-----
    Objective.Start(self)
    
    -- initialize internal values------------------
	self.lastVOPlayTime = -100000.0
	
	--just in case a player is already standing right where the flag spawns in...
	self.carrier = GetFlagCarrier(self.flag)
	if self.carrier then
		UpdateMarkerPulses()
		FlagMessage(GetCharacterTeam(self.carrier), "taken")
		self:OnTaken(self.flag, self.carrier)
	end

    -- set AI goals
    local flagPtr = GetObjectPtr(self.flag)
    assert(flagPtr, "ERROR: flag "..self.flag.." does not exist in the map")
    self.AIGoals = {}
    if self.AIGoalWeight > 0.0 then
        table.insert(self.AIGoals, AddAIGoal(self.teamATT, "CTFOffense", 100*self.AIGoalWeight, self.captureRegionATT, flagPtr))
        table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "CTFOffense", 100*self.AIGoalWeight, self.captureRegionDEF, flagPtr))
    end            
    
    ActivateRegion(self.captureRegionATT)
    ActivateRegion(self.captureRegionDEF)
	
    UpdateMarkerPulses(self.flag)
    
    if self.multiplayerRules then
        self.captureLimit = ScriptCB_GetCTFCaptureLimit()
        SetReinforcementCount(self.teamATT, -1)
		SetReinforcementCount(self.teamDEF, -1)
        SetFlagGameplayType("1flag")		--let C++ know that we're running 1flag at the moment
    else
    	SetFlagGameplayType("campaign")
    end

    if(self.homeRegion) then
        SetProperty(self.flag, "HomeRegion", self.homeRegion)
        ActivateRegion(self.homeRegion)
    end
            
    
    --=======================================
    -- Event responses
    --=======================================   
    
    -- flag reset to starting position
    OnFlagReset(
        function (flagPtr)
            if self.isComplete then return end
                    
            local flagName = GetEntityName(flagPtr)
            
            if self.flag ~= flagName then
                return
            end
            
            -- set as not moved
            self.carrier = nil
            
            -- force enter-region event for anyone in the home region
            if self.homeRegion then
                DeactivateRegion(self.homeRegion)
                ActivateRegion(self.homeRegion)
            end
			
			UpdateMarkerPulses(self.flag)
        end
        )
    
    
    OnFlagPickUp(
        function(flagPtr, carrierObj)
            if self.isComplete then return end
                    
            local flagName = GetEntityName(flagPtr)
            
            if self.flag ~= flagName then
				assert("self.flag:", self.flag, " does not equal flagName:", flagName, " (don't forget flags cant have capitals in their names!)")
                return
            end
            
            local carrierTeam = GetCharacterTeam(carrierObj)
            self.carrier = carrierObj
            
            --if the flag is in its capture region, cap the flag
            if IsCharacterInRegion(carrierObj, self.captureRegion) and CanCharacterInteractWithFlag(carrierObj) then
                CaptureFlag(carrierTeam)
            else
                FlagMessage(carrierTeam, "taken")
            end
			
			UpdateMarkerPulses(self.flag)
        end
        )
        
        
    OnFlagDrop(
        function(flagPtr, carrierObj)
            if self.isComplete then return end
                    
            local flagName = GetEntityName(flagPtr)
            
            if self.flag ~= flagName then
                return
            end
			
			self.carrier = nil
            
            FlagMessage(GetCharacterTeam(carrierObj), "dropped")
			
			UpdateMarkerPulses(self.flag)
        end
        )
    
            
    --when a carrier enters the attacker's capture region
    OnEnterRegion(
        function(region, character)
            if self.isComplete then return end
			
			if not CanCharacterInteractWithFlag(character) then return end
                
            if self.carrier == character then
                local carrierTeam = GetCharacterTeam(character)
                if carrierTeam == self.teamATT then
                    CaptureFlag(self.teamATT)
                end
            end
        end,
        self.captureRegionATT
        )
        
    --when a carrier enters the defender's capture region
    OnEnterRegion(
        function(region, character)
            if self.isComplete then return end
			
			if not CanCharacterInteractWithFlag(character) then return end
			
			--just to be safe...
			self.carrier = GetFlagCarrier(self.flag)		
                
            if self.carrier == character then
                local carrierTeam = GetCharacterTeam(character)
                if carrierTeam == self.teamDEF then
                    CaptureFlag(self.teamDEF)
                end
            end
        end,
        self.captureRegionDEF
        )
        
    -- team points change
    OnTeamPointsChange(
        function (team, points)
            if self.isComplete then return end
                
            if points >= self.captureLimit then
            	--SetFlagGameplayType("none")	-- moved to objective:start
                self:Complete(team)
            end
        end
        )       
	
end

-----------------------------------------------------
-- Sound cues for events
if not ScriptCB_InMultiplayer() then
	if ME5_SideVar == 0 then
		if RandomSide == 1 then
			CTF_SoundEvents_Var = 1
		elseif RandomSide == 2 then
			CTF_SoundEvents_Var = 2
		elseif RandomSide == 3 then
			CTF_SoundEvents_Var = 3
		elseif RandomSide == 4 then
			CTF_SoundEvents_Var = 4
		end
	elseif ME5_SideVar == 1 then
		CTF_SoundEvents_Var = 1
	elseif ME5_SideVar == 2 then
		CTF_SoundEvents_Var = 2
	elseif ME5_SideVar == 3	then
		CTF_SoundEvents_Var = 3
	elseif ME5_SideVar == 4	then
		CTF_SoundEvents_Var = 4
	end
else
	if onlineSideVar == 1 then
		CTF_SoundEvents_Var = 1
	elseif onlineSideVar == 2 then
		CTF_SoundEvents_Var = 2
	elseif onlineSideVar == 3 then
		CTF_SoundEvents_Var = 3
	elseif onlineSideVar == 4 then
		CTF_SoundEvents_Var = 4
	end
end

if CTF_SoundEvents_Var == 1 then
	gSoundEventsCTF_src = {
		all = {
			returned_att			= "all_allFlag_returned",
			returned_def			= "all_impFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},
		imp = {
			returned_att			= "imp_impFlag_returned",
			returned_def			= "imp_allFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},  
		rep = {
			taken_att				= "ssv_adm_com_report_pickup_flag",
			taken_def				= "ssv_adm_com_report_enemyPickup_flag",
			dropped_att				= "ssv_adm_com_report_drop_flag",
			dropped_def				= "ssv_adm_com_report_enemyDrop_flag",
			
			returned_att			= "rep_repFlag_returned",
			returned_def			= "rep_cisFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
		cis = {
			taken_att				= "gth_ann_com_report_pickup_flag",
			taken_def				= "gth_ann_com_report_enemyPickup_flag",
			dropped_att				= "gth_ann_com_report_drop_flag",
			dropped_def				= "gth_ann_com_report_enemyDrop_flag",
			
			returned_att			= "cis_cisFlag_returned",
			returned_def			= "cis_repFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
	}
elseif CTF_SoundEvents_Var == 2 then
	gSoundEventsCTF_src = {
		all = {
			returned_att			= "all_allFlag_returned",
			returned_def			= "all_impFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},
		imp = {
			returned_att			= "imp_impFlag_returned",
			returned_def			= "imp_allFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},  
		rep = {
			taken_att				= "ssv_adm_com_report_pickup_flag",
			taken_def				= "ssv_adm_com_report_enemyPickup_flag",
			dropped_att				= "ssv_adm_com_report_drop_flag",
			dropped_def				= "ssv_adm_com_report_enemyDrop_flag",
			
			returned_att			= "rep_repFlag_returned",
			returned_def			= "rep_cisFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
		cis = {
			taken_att				= "col_gen_com_report_pickup_flag",
			taken_def				= "col_gen_com_report_enemyPickup_flag",
			dropped_att				= "col_gen_com_report_drop_flag",
			dropped_def				= "col_gen_com_report_enemyDrop_flag",
			
			returned_att			= "cis_cisFlag_returned",
			returned_def			= "cis_repFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
	}
elseif CTF_SoundEvents_Var == 3 then
	gSoundEventsCTF_src = {
		all = {
			returned_att			= "all_allFlag_returned",
			returned_def			= "all_impFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},
		imp = {
			returned_att			= "imp_impFlag_returned",
			returned_def			= "imp_allFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},  
		rep = {
			taken_att				= "evg_prm_com_report_pickup_flag",
			taken_def				= "evg_prm_com_report_enemyPickup_flag",
			dropped_att				= "evg_prm_com_report_drop_flag",
			dropped_def				= "evg_prm_com_report_enemyDrop_flag",
			
			returned_att			= "rep_repFlag_returned",
			returned_def			= "rep_cisFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
		cis = {
			taken_att				= "gth_ann_com_report_pickup_flag",
			taken_def				= "gth_ann_com_report_enemyPickup_flag",
			dropped_att				= "gth_ann_com_report_drop_flag",
			dropped_def				= "gth_ann_com_report_enemyDrop_flag",
			
			returned_att			= "cis_cisFlag_returned",
			returned_def			= "cis_repFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
	}
elseif CTF_SoundEvents_Var == 4 then
	gSoundEventsCTF_src = {
		all = {
			returned_att			= "all_allFlag_returned",
			returned_def			= "all_impFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},
		imp = {
			returned_att			= "imp_impFlag_returned",
			returned_def			= "imp_allFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
			
			taken_att				= "common_flagAction_pickup",
			taken_def				= "common_flagAction_pickup",
			dropped_att				= "common_flagAction_drop",
			dropped_def				= "common_flagAction_drop",
		},  
		rep = {
			taken_att				= "evg_prm_com_report_pickup_flag",
			taken_def				= "evg_prm_com_report_enemyPickup_flag",
			dropped_att				= "evg_prm_com_report_drop_flag",
			dropped_def				= "evg_prm_com_report_enemyDrop_flag",
			
			returned_att			= "rep_repFlag_returned",
			returned_def			= "rep_cisFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
		cis = {
			taken_att				= "col_gen_com_report_pickup_flag",
			taken_def				= "col_gen_com_report_enemyPickup_flag",
			dropped_att				= "col_gen_com_report_drop_flag",
			dropped_def				= "col_gen_com_report_enemyDrop_flag",
			
			returned_att			= "cis_cisFlag_returned",
			returned_def			= "cis_repFlag_returned",
			captured_att			= "common_flagAction_score",
			captured_def			= "common_flagAction_score",
		},
	}
end