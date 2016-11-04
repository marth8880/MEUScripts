ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	CD1 = 3;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;
	
function ScriptPostLoad()

	cp1 = CommandPost:New{name = "cp1"}
	cp2 = CommandPost:New{name = "cp2"}
	cp3 = CommandPost:New{name = "cp3"}
	cp4 = CommandPost:New{name = "cp4"}
	
	
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
	conquest:AddCommandPost(cp4)
    
    conquest:Start()

    EnableSPHeroRules()
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Conquest", 1000)
	AddAIGoal(2, "Conquest", 1000)
	
	SetProperty("cp1", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp2", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp3", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp4", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp1", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp2", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp3", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp4", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp1", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp2", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp3", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp4", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp1", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp2", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp3", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp4", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	
	SetProperty("cp1", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
	SetProperty("cp2", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
	SetProperty("cp3", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
	SetProperty("cp4", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
	SetProperty("cp1", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
	SetProperty("cp2", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
	SetProperty("cp3", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
	SetProperty("cp4", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
	SetProperty("cp1", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
	SetProperty("cp2", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
	SetProperty("cp3", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
	SetProperty("cp4", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
	SetProperty("cp1", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
	SetProperty("cp2", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
	SetProperty("cp3", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
	SetProperty("cp4", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
	
	if not ScriptCB_InMultiplayer() then
		DecideShepClass()
	else
			print("decide shepard::soldier")
		SetHeroClass(REP, "ssv_hero_shepard_soldier")
	end
    
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
	PreLoadStuff()
   
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
	ReadDataFile("sound\\kam.lvl;kam1cw")
	
	Load_SSV()
	Load_GTH()
	Setup_SSVxGTH_med()
			print("Load/setup SSV versus GTH")
	
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 32)
    SetMemoryPoolSize("EntitySoundStatic", 32)
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
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRC.lvl", "VRC_campaign")
	
	SetDenseEnvironment("false")
	
	
    --  Sound
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5_ambiance")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")

	SetBleedingVoiceOver(REP, REP, "ssv_adm_com_report_us_bleeding", 1)
	SetBleedingVoiceOver(REP, CIS, "ssv_adm_com_report_enemy_bleeding",   1)

	SetOutOfBoundsVoiceOver(REP, "ssv_adm_com_report_hiatus")
	
	Music03()
	
	SetBleedingVoiceOver(CIS, REP, "gth_ann_com_report_enemy_bleeding",   1)
	SetBleedingVoiceOver(CIS, CIS, "gth_ann_com_report_us_bleeding", 1)
	
	SetOutOfBoundsVoiceOver(CIS, "gth_ann_com_report_hiatus")
	
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