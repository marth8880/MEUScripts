--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

local __SCRIPT_NAME = "ME5_ObjectiveCTF";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

ScriptCB_DoFile("ME5_Objective")
ScriptCB_DoFile("ME5_SoundEvent_ctf")

if bStockFontLoaded == nil then
	-- Has the stock font been loaded?
	bStockFontLoaded = false
end

MEU_GameMode = "meu_ctf"

--=============================
-- CaptureFlag
--  Prototype for a captureable flag in the game world
--=============================
CaptureFlag = 
{
    -- required external fields:
    name = nil,					-- Name of the flag object in the level     
    captureRegion = nil,        -- Name of the region where the flag needs to be carried to be captured. Should never be set to nil
	
	-- optional external fields:
	homeRegion = nil,           					-- Name of the region where the flag will respawn back to. If nil, then it never respawns.
    capRegionMarker = "hud_objective_icon_circle",  -- Name of the icon used to mark the capture point on the mini-map
    capRegionMarkerScale = 3.0, 					-- How big the capRegionMarker should be on the minimap
	capRegionDummyObjectATT = nil,					--need dummy objects so we can add an in-HUD marker (regions can't be marked in the HUD currently...it's a long story)
	capRegionDummyObjectDEF = nil,
    mapIcon = "hud_target_flag_onscreen",           -- Texture name of the icon that appears on the map 
    mapIconScale = 3.0,         					-- How big to draw the map icon
}

function CaptureFlag:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 
    return o
end

--=============================
-- ObjectiveCTF
--  Handles the logic for a capture the flag game
--=============================
ObjectiveCTF = Objective:New
{ 
    -- external values
    captureLimit = 5,
    neutralFlagMessage = "game.flag.neutral.",
    enemyFlagMessage = "game.flag.enemy.",
    friendFlagMessage = "game.flag.friend.",
	capRegionMarker = "hud_objective_icon_circle",
	capRegionMarkerScale = 3.0,
	capRegionDummyObjectATT = nil,		--need dummy objects so we can add an in-HUD marker (regions can't be marked in the HUD currently...it's a long story)
	capRegionDummyObjectDEF = nil,
}


--
-- Add a flag to the game
--  Caller should send AddFlag() a table that corresponds to the CaptureFlag prototype (seen above)
--
function ObjectiveCTF:AddFlag(flagParams)
    -- make sure we have a table to add the flag to
    self.flags = self.flags or {}
	
	--error check the params
    assert(flagParams.name, "ERROR: no name specified for the flag!")
	assert(flagParams.captureRegion, "ERROR: flag missing capture region name")
	assert(GetRegion(flagParams.captureRegion), "ERROR: capture region for a flag does not exist in map")
	if flagParams.homeRegion == "" then
		flagParams.homeRegion = nil		--because designers sometimes use "" to specify no home region
	end
	if flagParams.homeRegion and not GetRegion(flagParams.homeRegion) then
        --NOTE: it *is* valid to have a nil homeRegion
        assert(false, "WARNING: Home region for a flag does not exist in map!") end
    flagParams.name = string.lower(flagParams.name)
    assert(flagParams.regionDummyObject, "WARNING: no dummy object specified for the flag! (this is used to mark the flag's capture region on the HUD)")
	
	-- add a new flag to the list of flags
    self.flags[flagParams.name] = CaptureFlag:New(flagParams)
    
end


-- DESIGNERS: Override these functions if necessary
function ObjectiveCTF:OnCapture(flag)

end

function ObjectiveCTF:OnReturn(flag)

end

function ObjectiveCTF:OnPickup(flag)

end

function ObjectiveCTF:OnDrop(flag)

end

function ObjectiveCTF:OnReset(flag)

end

-- Get game time limit as set in game options menu, if any.  0 if none.
function ObjectiveCTF:GetGameTimeLimit()
	return ScriptCB_GetCTFMaxTimeLimit()
end

function ObjectiveCTF:GameOptionsTimeLimitUp()
	local teamATTpts = GetTeamPoints(teamATT)
	local teamDEFpts = GetTeamPoints(teamDEF)
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


--
-- Initialize the capture objective
--
function ObjectiveCTF:Start()
	
	--carriedFlagsNum = 0
	
    --=============================
    -- local functions
    --=============================
    --
    -- gets the opposite team from what you passed in
    --
    local GetOpposingTeam = function(team)
        if team == self.teamATT then
            return self.teamDEF
        else
            return self.teamATT
        end
    end    
       
    --
    -- message generator
    --
    local FlagMessage = function(flag, message)
		if not self.multiplayerRules then return end	--ignore flag messages in single player
		
        local flagTeam = GetObjectTeam(flag.name)
        if flagTeam == 0 then
            if self.neutralFlagMessage then
                --broadcast a neutral message to everyone
                ShowMessageText(self.neutralFlagMessage .. message)
            end
        else
            --setup "friendTeam" to be the flag's team, and "enemyTeam" to be the other team
            local friendTeam = flagTeam
            local enemyTeam = GetOpposingTeam(friendTeam)
                
            --send appropriate localized messages to each team
            if self.friendFlagMessage then
                ShowMessageText(self.friendFlagMessage .. message, friendTeam)
            end
            if self.enemyFlagMessage then
                ShowMessageText(self.enemyFlagMessage .. message, enemyTeam)
            end
			
			local missionTime = ScriptCB_GetMissionTime()
			local timeSinceLastPlayed = missionTime - self.lastVOPlayTime
			--if self.multiplayerRules and (timeSinceLastPlayed > 3.0) then
				-- I think brad is working under a different model than I am
				-- For me, the attacking team is the one taking the flag (and of opposite team of the flag)
				SoundEvent_BroadcastVO( message, enemyTeam, friendTeam )
				self.lastVOPlayTime = missionTime
			--end
        end
    end
    
    
    local UpdateMarkerPulses = function(flag)
        if not flag.mapIcon then
            return end
            
        local flagTeam = GetObjectTeam(flag.name)
        local carrierTeam = 0
        if flagTeam ~= 0 then
            carrierTeam = GetOpposingTeam(flagTeam)
        end
		
		PrintLog("updating markers for flag:", flag.name)
        if flag.carrier then
			PrintLog("flag carrier")
            --no marker on the flag, yes marker on the capture region
 			MapRemoveEntityMarker(flag.name)
            MapAddRegionMarker(GetRegion(flag.captureRegion), flag.capRegionMarker, 4.0,
                                carrierTeam, "YELLOW", false, false, true)
            MapAddEntityMarker(flag.regionDummyObject, self.capRegionMarker, self.capRegionMarkerScale, carrierTeam, "YELLOW", true, false, true)
        else
			PrintLog("no carrier")
            --yes marker on the flag, no marker on the capture region
            MapAddEntityMarker(flag.name, flag.mapIcon, 4.0, carrierTeam, "YELLOW", true, false, true, true)     
            MapRemoveRegionMarker(GetRegion(flag.captureRegion))
            MapRemoveEntityMarker(flag.regionDummyObject)
        end 
    end
    
    
    local CaptureFlag = function(flag, carrierTeam)
        self:OnCapture(flag)
        local flagPtr = GetObjectPtr(flag.name)
        AddFlagCapturePoints(GetFlagCarrier(flag.name))
        flag.carrier = nil
        UpdateMarkerPulses(flag)
        FlagMessage(flag, "captured")
        AddTeamPoints(carrierTeam, 1)
        KillObject(flagPtr)
		--carriedFlagsNum = carriedFlagsNum - 1
		--ShowMessageText("game.flag.flagnum_"..carriedFlagsNum)
    end
        
        
    local ReturnFlag = function(flag, carrierTeam)
        self:OnReturn(flag)
        local flagPtr = GetObjectPtr(flag.name)
        flag.carrier = nil
        UpdateMarkerPulses(flag)
        FlagMessage(flag, "returned")
        KillObject(flagPtr)
		print( "------------ SHOULD HAVE PLAYED RETURN VO" )
		--carriedFlagsNum = carriedFlagsNum - 1
		--ShowMessageText("game.flag.flagnum_"..carriedFlagsNum)
    end
    
	--==========
	-- Set the number of guys in the level to number in game options
	--==========
	ScriptCB_SetNumBots(ScriptCB_GetCTFNumBots())
    
    
    --===============================
    -- Initialization logic
    --===============================
	--showTeamPoints defaults to true in multiplayer mode if the designer doesn't specify it
    if self.showTeamPoints == nil and self.multiplayerRules then
    	self.showTeamPoints = true
    else
		self.showTeamPoints = false
	end
	
    --initialize the base objective data
    Objective.Start(self)
    
    -- initialize internal values
    self.flags = self.flags or {}
	
	self.lastVOPlayTime = -10000.0
    
    -- error checking
    numFlags = 0
    for i, f in pairs(self.flags) do
        numFlags = numFlags + 1
    end
    if(numFlags == 0) then
        assert(false, "ERROR: no flags were added to the objective")
        return
    end

	if self.multiplayerRules then
		self.captureLimit = ScriptCB_GetCTFCaptureLimit()
		SetReinforcementCount(self.teamATT, -1)
		SetReinforcementCount(self.teamDEF, -1)
		SetFlagGameplayType("2flag")
	else
		SetFlagGameplayType("campaign")
	end
	

	--make sure the flags are colored properly when they're dropped
	SetClassProperty("com_item_flag", "DroppedColorize", 1)
        
    -- activate map markers, set region properties on the c++ objects, activate the regions, etc..
    self.AIGoals = {}
    for i, flag in pairs(self.flags) do
        local flagPtr = GetObjectPtr(flag.name)
        assert(flagPtr, "ERROR: flag "..flag.name.." does not exist in the map")
        local flagTeam = GetObjectTeam(flag.name)
        
        --Add AI Goals
		if self.AIGoalWeight > 0.0 then
			table.insert(self.AIGoals, AddAIGoal(GetOpposingTeam( flagTeam ), "CTFOffense", 70*self.AIGoalWeight, flag.captureRegion, flagPtr))
			if flag.homeRegion then
				table.insert(self.AIGoals, AddAIGoal(flagTeam, "CTFDefense", 30*self.AIGoalWeight, flagPtr))
			else
				--if a flag has no home region, we can't put it in traditional CTFDefense mode, but we can put
				--it in generic "Defend this object" mode, so they'll put up a parameter around the flag
				--and shoot anyone who gets near
				table.insert(self.AIGoals, AddAIGoal(flagTeam, "Defend", 30*self.AIGoalWeight, flag.name))
			end
		end
        
        ActivateRegion(flag.captureRegion)
        
        --always display two solid markers: one for the flag and one for the capture region
        local displayTeam = 0
        if flagTeam ~= 0 then
            displayTeam = GetOpposingTeam(flagTeam)
        end
        
        --initialize the "pulse" effect
        UpdateMarkerPulses(flag)
        
        if(flag.homeRegion) then
            SetProperty(i, "HomeRegion", flag.homeRegion)
            ActivateRegion(flag.homeRegion)
        end
        
        --SetProperty(flagPtr, "AllowTeamPickup", 0)      --disallow teammates from picking up their own flags
		
		--just in case the player is standing right where the flag spawns when the objective starts...
		flag.carrier = GetFlagCarrier(flag.name)
		if flag.carrier then
			UpdateMarkerPulses(flag)
			FlagMessage(flag, "taken")
			self:OnPickup(flag)
		end
    end	
        
    
    --=======================================
    -- Event responses
    --=======================================
    
    -- flag reset to starting position
    OnFlagReset(
        function (flagPtr)
            if self.isComplete then return end
			
            local flagName = GetEntityName(flagPtr)
            local flag = self.flags[flagName]
			
			if not flag then return end							--this particular flag is not part of this goal
            
            -- set as not moved
            flag.carrier = nil
            
            -- force enter-region event for anyone in the home region
            if flag.homeRegion then
                DeactivateRegion(flag.homeRegion)
                ActivateRegion(flag.homeRegion)
            end
            UpdateMarkerPulses(flag)
			self:OnReset(flag)
        end
        )
    
    
    OnFlagPickUp(
        function(flagPtr, carrierObj)
            if self.isComplete then return end
                
            local flagName = GetEntityName(flagPtr)
            local flag = self.flags[flagName]			
			if not flag then return end							--this particular flag is not part of this goal			
            local carrierTeam = GetCharacterTeam(carrierObj)
			
            flag.carrier = carrierObj
            --local charPtr = GetCharacterUnit(flag.carrier)
			
			--carriedFlagsNum = carriedFlagsNum + 1
			--ShowMessageText("game.flag.flagnum_"..carriedFlagsNum)
            
            
            if GetObjectTeam(flag.name) == carrierTeam then
                --if the flag is in its home region, return it to the stand
                --if flag.homeRegion and IsCharacterInRegion(carrierObj, flag.homeRegion) then
                    ReturnFlag(flag, carrierTeam)
                --end
            else
				--[[if carrierTeam == 1 then
					destroycarriergoal2 = AddAIGoal(GetOpposingTeam(carrierTeam), "Destroy", 60, charPtr)
				elseif carrierTeam == 2 then
					destroycarriergoal1 = AddAIGoal(GetOpposingTeam(carrierTeam), "Destroy", 60, charPtr)
				end]]
				
                --if the flag is in its capture region, cap the flag
                if IsCharacterInRegion(carrierObj, flag.captureRegion) and CanCharacterInteractWithFlag(carrierObj) then
					--PrintLog("carrierObj:", carrierObj)
					--PrintLog("inside OnFlagPickUp()")
					--if carriedFlagsNum < 2 then
						CaptureFlag(flag, carrierTeam)
					--[[else
						ShowMessageText("game.flag.blocked", carrierTeam)
						
						local i = 0
						i = i + 1
						local flagBlockCheckTimer = CreateTimer("flagBlockCheckTimer_"..i)
						SetTimerValue(flagBlockCheckTimer, 1)
						StartTimer(flagBlockCheckTimer)
						ShowTimer(flagBlockCheckTimer)
						OnTimerElapse(
							function(timer)
								if IsCharacterInRegion(carrier, flag.captureRegion) and CanCharacterInteractWithFlag(carrier) then
									if not carriedFlagsNum < 2 then
										SetTimerValue(flagBlockCheckTimer, 1)
										StartTimer(flagBlockCheckTimer)
									else
										CaptureFlag(flag, carrierTeam)
										DestroyTimer(flagBlockCheckTimer)
									end
								else
								end
							end,
						flagBlockCheckTimer
						)
					end]]
				end
            end
            
            UpdateMarkerPulses(flag)            
            FlagMessage(flag, "taken")
			
			--play a little ditty in campaign mode
			if not self.multiplayerRules then
				BroadcastVoiceOver("common_objComplete")
			end
			
			ScriptCB_SndPlaySound("common_flagAction_pickup")
			
			self:OnPickup(flag)
        end
        )
        
        
    OnFlagDrop(
        function(flagPtr, carrierObj)
            if self.isComplete then return end
                
            local flagName = GetEntityName(flagPtr)
            local flag = self.flags[flagName]
			if not flag then return end							--this particular flag is not part of this goal	
            local carrierTeam = GetCharacterTeam(carrierObj)
            
            flag.carrier = nil
			
			--carriedFlagsNum = carriedFlagsNum - 1
			--ShowMessageText("game.flag.flagnum_"..carriedFlagsNum)
			
			--[[if carrierTeam == 1 then
				DeleteAIGoal(destroycarriergoal2)
			elseif carrierTeam == 2 then
				DeleteAIGoal(destroycarriergoal1)
			end]]
			
			ScriptCB_SndPlaySound("common_flagAction_drop")
            
            UpdateMarkerPulses(flag)            
            FlagMessage(flag, "dropped")
			self:OnDrop(flag)
        end
        )
    
    
    for i, flag in pairs(self.flags) do
        if(flag.homeRegion) then
            OnEnterRegion(
                --when a carrier enters the flag's home region...
                function(region, carrier)
                    if self.isComplete then return end
                        
                    --check to see if he's carrying this flag, and if the flag's home region
                    --corresponds to this region
                    for i, f in pairs(self.flags) do
                        if f.carrier == carrier and string.lower(f.homeRegion) == string.lower(GetRegionName(region)) then
                            local flagPtr = GetObjectPtr(f.name)
                            local flagTeam = GetObjectTeam(f.name)
                            local carrierTeam = GetCharacterTeam(carrier)
                            if flagTeam == carrierTeam then
                                ReturnFlag(f, carrierTeam)
                            end
                        end
                    end
                end,
                flag.homeRegion
                )
        end
            
        OnEnterRegion(
            --when a carrier enters the flag's capture region...
            function(region, carrier)
                if self.isComplete then return end
                
                if not CanCharacterInteractWithFlag(carrier) then return end
                    
                --check to see if he's carrying this flag and is on an enemy team, and
                --the flag's capture region corresponds to this region
                for i, f in pairs(self.flags) do
                    if f.carrier == carrier and string.lower(f.captureRegion) == string.lower(GetRegionName(region)) then
                        local flagPtr = GetObjectPtr(f.name)
                        local flagTeam = GetObjectTeam(f.name)
                        local carrierTeam = GetCharacterTeam(carrier)
                        
                        if flagTeam ~= carrierTeam then
							--PrintLog("in OnEnterRegion()")
							
							--if carriedFlagsNum < 2 then
								CaptureFlag(f, carrierTeam)
							--[[else
								ShowMessageText("game.flag.blocked", carrierTeam)
								
								local i = 0
								i = i + 1
								local flagBlockCheckTimer = CreateTimer("flagBlockCheckTimer_"..i)
								SetTimerValue(flagBlockCheckTimer, 1)
								StartTimer(flagBlockCheckTimer)
								ShowTimer(flagBlockCheckTimer)
								OnTimerElapse(
									function(timer)
										if IsCharacterInRegion(carrier, flag.captureRegion) and CanCharacterInteractWithFlag(carrier) then
											if not carriedFlagsNum < 2 then
												SetTimerValue(flagBlockCheckTimer, 1)
												StartTimer(flagBlockCheckTimer)
											else
												CaptureFlag(flag, carrierTeam)
												DestroyTimer(flagBlockCheckTimer)
											end
										else
										end
									end,
								flagBlockCheckTimer
								)
							end]]
                        end
                    end
                end
            end,
            flag.captureRegion
            )
    end
        
    -- team points change
    OnTeamPointsChange(
        function (team, points)
            if self.isComplete then return end
                    
            if points >= self.captureLimit then
				for i, flag in pairs(self.flags) do
					MapRemoveRegionMarker(flag.captureRegion)
					MapRemoveEntityMarker(flag.name)
				end
				--SetFlagGameplayType("none")	-- moved to objective:start
				self:Complete(team)
            end
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
	
end

-- TODO: need to add lines for SSVxRPR and SSVxCER
if not ScriptCB_InMultiplayer() then
	if ME5_SideVar == 1 then
		CTF_SoundEvents_Var = 1
	elseif ME5_SideVar == 2 then
		CTF_SoundEvents_Var = 2
	elseif ME5_SideVar == 3	then
		CTF_SoundEvents_Var = 3
	elseif ME5_SideVar == 4	then
		CTF_SoundEvents_Var = 4
	end
else
	if gCurrentMapManager.onlineSideVar == "SSVxGTH" or gCurrentMapManager.onlineSideVar == 1 then
		CTF_SoundEvents_Var = 1
	elseif gCurrentMapManager.onlineSideVar == "SSVxCOL" or gCurrentMapManager.onlineSideVar == 2 then
		CTF_SoundEvents_Var = 2
	elseif gCurrentMapManager.onlineSideVar == "EVGxGTH" or gCurrentMapManager.onlineSideVar == 3 then
		CTF_SoundEvents_Var = 3
	elseif gCurrentMapManager.onlineSideVar == "EVGxCOL" or gCurrentMapManager.onlineSideVar == 4 then
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

PrintLog("Exited")