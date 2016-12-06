ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_MapFunctions")
ScriptCB_DoFile("ME5_MultiObjectiveContainer")
ScriptCB_DoFile("ME5_ObjectiveAssault")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_ObjectiveGoto")
ScriptCB_DoFile("ME5_ObjectiveCTF")
ScriptCB_DoFile("ME5_ObjectiveTDM")
ScriptCB_DoFile("Ambush")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	CD1 = 3;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;
	
function ScriptPostLoad()
	
	--This defines the CPs.  These need to happen first
	--[[KillObject("cp1_2")
	KillObject("cp2_2")
	KillObject("cp3_2")
	KillObject("cp4_2")
	KillObject("cp5_2")]]
	
	VRM_DisableBarriers1()
	
	SetClassProperty("ssv_inf_trooper", "MaxHealth", "640.0")
	SetClassProperty("ssv_inf_infiltrator", "MaxHealth", "540.0")
	SetClassProperty("ssv_inf_engineer", "MaxHealth", "540.0")
	SetClassProperty("ssv_inf_adept", "MaxHealth", "475.0")
	SetClassProperty("ssv_inf_sentinel", "MaxHealth", "510.0")
	SetClassProperty("ssv_inf_vanguard", "MaxHealth", "580.0")
	
	SetClassProperty("ssv_inf_trooper", "MaxShield", "460.0")
	SetClassProperty("ssv_inf_infiltrator", "MaxShield", "520.0")
	SetClassProperty("ssv_inf_engineer", "MaxShield", "585.0")
	SetClassProperty("ssv_inf_adept", "MaxShield", "620.0")
	SetClassProperty("ssv_inf_sentinel", "MaxShield", "620.0")
	SetClassProperty("ssv_inf_vanguard", "MaxShield", "750.0")
	
	SetClassProperty("ssv_inf_default", "AddShield", "13.0")
	
	SetClassProperty("gth_inf_trooper", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_rocketeer", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_sniper", "MaxHealth", "400.0")
	SetClassProperty("gth_inf_machinist", "MaxHealth", "430.0")
	SetClassProperty("gth_inf_shock", "MaxHealth", "600.0")
	SetClassProperty("gth_inf_hunter", "MaxHealth", "500.0")
	SetClassProperty("gth_inf_destroyer", "MaxHealth", "600.0")
	SetClassProperty("gth_inf_juggernaut", "MaxHealth", "700.0")
	SetClassProperty("gth_inf_prime", "MaxHealth", "700.0")
	
	SetClassProperty("gth_inf_trooper", "MaxShield", "500.0")
	SetClassProperty("gth_inf_rocketeer", "MaxShield", "500.0")
	SetClassProperty("gth_inf_sniper", "MaxShield", "470.0")
	SetClassProperty("gth_inf_machinist", "MaxShield", "700.0")
	SetClassProperty("gth_inf_shock", "MaxShield", "600.0")
	SetClassProperty("gth_inf_hunter", "MaxShield", "600.0")
	SetClassProperty("gth_inf_destroyer", "MaxShield", "775.0")
	SetClassProperty("gth_inf_juggernaut", "MaxShield", "775.0")
	SetClassProperty("gth_inf_prime", "MaxShield", "850.0")
	
	SetClassProperty("gth_inf_default", "AddShield", "15.0")
	
    ScriptCB_SetGameRules("campaign")
	--AllowAISpawn(1, true)
	
	
	timePop = CreateTimer("timePop")
	SetTimerValue(timePop, 5.0)
	
	Objective1aTimer = CreateTimer("Objective1aTimer")
	SetTimerValue(Objective1aTimer, 10)
		print("create timer 'Objective1aTimer'")
	
	OnFirstSpawn = OnCharacterSpawn(
		function(character)
			if character == 0 then
				--ShowPopup("level.vrm.hints.hints")
				ReleaseCharacterSpawn(OnFirstSpawn)
				OnFirstSpawn = nil
				
				ShowTimer(timePop)
				StartTimer(timePop)
                OnTimerElapse(
        			function(timer)
						StartObjectives()
						--ShowTimer(Objective1aTimer)
						--StartTimer(Objective1aTimer)
							print("start timer 'Objective1aTimer'")
            			ScriptCB_EnableCommandPostVO(0)
            			DestroyTimer(timer)
        			end,
        		timePop
        		)
			end
		end
	)
	
	
	-- Objective 1a -- 
	
	Objective1a = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, 
            text = "level.vrm.objectives.hacking.1a", 
            popupText = "level.vrm.objectives.hacking.1a_popup",
            showTeamPoints = false,
            AIGoalWeight = 1000.0}
        
    Objective1a:AddFlag{name = "data1", captureRegion = "data1_node",
            capRegionMarker = "rep_icon", capRegionMarkerScale = 3.0, 
            mapIcon = "flag_icon", mapIconScale = 2.0}
            
	
	Objective1a.OnStart = function(self)
		Data1Spawn = GetPathPoint("data1_spawn", 0) --gets the path point
		CreateEntity("vrm_flag_data", Data1Spawn, "data1") --spawns the disk
		SetProperty("data1", "AllowAIPickUp", 0)
		
		SetProperty("cpgth_h1", "Team", 2)
		SetProperty("cpgth_h2", "Team", 2)
		SetProperty("cpgth_h3", "Team", 2)
		SetProperty("cpgth_h4", "Team", 2)
		SetReinforcementCount(DEF, 50)
		
		Objective1a.att_obj1a_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		Objective1a.def_obj1a_aigoal = AddAIGoal(DEF, "Deathmatch", 200)
		Objective1a.att_obj1a_aigoal2 = AddAIGoal(ATT, "Defend", 300, 0)
		Objective1a.def_obj1a_aigoal2 = AddAIGoal(DEF, "Destroy", 300, 0)
		
	    ScriptCB_PlayInGameMusic("ssv_amb_06_mid")
    	ActivateRegion("data1_node")
    end
	
	Objective1a.OnPickup = function(self, flag)
		if IsCharacterHuman(flag.carrier) then
			MapAddEntityMarker("data1_node", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
			--ShowMessageText("level.vrm.obj.c2c", 1)
			
			
		end
	end
    
    Objective1a.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	MapRemoveEntityMarker("data1_node")
    	if self.winningTeam == DEF then
    		--ScriptCB_SndPlaySound("MYG_obj_16")
    	else
    		--play the win sound
	    	--ScriptCB_SndPlaySound("MYG_obj_14")
	    end
    end
	
	-- Objective 1b -- 

	Objective1bCP = CommandPost:New{name = "cpgth_h5"}
	Objective1b = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
			text = "level.vrm.objectives.hacking.1b", 
			popupText = "level.vrm.objectives.hacking.1b_popup",  
			AIGoalWeight = 0}
			
	Objective1b:AddCommandPost(Objective1bCP)
		print("add command post 'cpgth_h5'")
    
    Objective1b.OnStart = function(self)
		--OnTimerElapse(
			--function(timer)
				AICanCaptureCP("cpgth_h5", DEF, false)
				Objective1b.att_obj1b_aigoal = AddAIGoal(ATT, "Defend", 4000, "cpgth_h5")
				Objective1b.def_obj1b_aigoal = AddAIGoal(DEF, "Defend", 4000, "cpgth_h5")
				
				--AddHint("level.vrm.objectives.hacking.hints.upload_data")
				
				Objective1b.obj1b_h5_cTime = SetProperty("cpgth_h5", "CaptureTime", 15)
				Objective1b.obj1b_h5_nTime = SetProperty("cpgth_h5", "NeutralizeTime", 15)
				SetProperty("cpgth_h5", "CaptureRegion", "cpgth_h5_capture")
				--def_obj1b_tickets = SetReinforcementCount(DEF, 50)
				
				--DestroyTimer(timer)
			--end,
		--Objective1bTimer
		--)
    end
    
    Objective1b.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		if self.winningTeam == DEF then
			--ScriptCB_SndPlaySound("MYG_obj_15")
		else
			--ScriptCB_SndPlaySound("MYG_obj_03")
		end
		DeleteAIGoal(Objective1b.att_obj1b_aigoal)
		DeleteAIGoal(Objective1b.def_obj1b_aigoal)
	end
	
	
	--[[cpgth_h1 = "cpgth_h1"
	OnFinishCaptureTeam(
		function(cpgth_h1)
			SetProperty("cpgth_h1", "Team", 0)
			local def_obj1end_tickets = GetReinforcementCount(2)
			if def_obj1end_tickets == 0 then
				ScriptCB_PlayInGameMusic("ssv_amb_06_end")
			end
		end,
	1 -- team capturing the post
	)]]
	
	
	
end

--OBJECTIVE SEQUENCER

function StartObjectives()
	objectiveSequence = MultiObjectiveContainer:New{ delayVictoryTime = 6.0 }
    objectiveSequence:AddObjectiveSet(Objective1a)
    objectiveSequence:AddObjectiveSet(Objective1b)
    objectiveSequence:Start()
end

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm1.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
	manager:Proc_ScriptInit_Begin()
   
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight (30)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl;ME5n")
	ReadDataFile("sound\\kas.lvl;kas2cw")
	
	Load_SSV()
	Load_GTH()
	SetupTeams{
		rep = {
			team = REP,
			units = 4,
			reinforcements = -1,
			soldier  = { "ssv_inf_soldier",1, 4},
			sniper  = { "ssv_inf_infiltrator",0, 4},
			adept = { "ssv_inf_adept",1, 4},
			engineer   = { "ssv_inf_engineer",0, 4},
			sentinel = { "ssv_inf_sentinel",1, 4},
			vanguard = { "ssv_inf_vanguard",0, 4},	
	        
		},
		
		cis = {
			team = CIS,
			units = 10,
			reinforcements = -1,
			soldier  = { "gth_inf_trooper",15, 15},
			--assault  = { "gth_inf_rocketeer",1, 4},
			--sniper = { "gth_inf_sniper",1, 4},
			--engineer = { "gth_inf_machinist",1, 4},
			--hunter   = { "gth_inf_hunter",1, 3},
			--shock  = { "gth_inf_shock",1, 3},
			--destroyer = { "gth_inf_destroyer",1, 2},
			--juggernaut = { "gth_inf_juggernaut",1, 5},
		}
		}
	
	
	
	--SetTeamName(2, CIS)
	--AddUnitClass(2, "gth_inf_trooper", 15)
	--SetUnitCount(2, 10)
	
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
	local dataCount = 5
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
	SetMemoryPoolSize("FlagItem", dataCount)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 128)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Music", 72)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathFollower", 128)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 274)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:VRM\\VRM.lvl", "VRM_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_campaign")
	
	SetDenseEnvironment("true")
	
	
    --  Sound

    --[[voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)]]
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5_ambiance")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    OpenAudioStream("sound\\kas.lvl",  "kas")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")

	SSVWorldVO()
	GTHWorldVO()
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	SoundFX()


--OpeningSatelliteShot
	AddCameraShot(0.993613, -0.112590, -0.007516, -0.000852, -144.671204, 12.469149, 105.698982);
	AddCameraShot(0.003597, -0.000253, -0.997521, -0.070274, -144.042343, 12.469149, 64.159500);
	AddCameraShot(0.583016, -0.093302, -0.796945, -0.127537, -190.497482, 12.469149, 81.069817);
	AddCameraShot(0.615988, -0.086602, 0.775356, 0.109007, -97.931252, 12.469149, 71.429901);
	AddCameraShot(0.900297, -0.099467, -0.421196, -0.046535, -191.081924, 12.469149, 159.755737);
	AddCameraShot(0.943805, -0.094135, 0.315250, 0.031443, -95.917686, 12.469149, 164.284882);
	AddCameraShot(0.039136, -0.004479, -0.992743, -0.113616, -145.351196, 12.469149, 7.593871);

end

