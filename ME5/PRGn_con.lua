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
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1con"}
    cp2 = CommandPost:New{name = "cp2con"}
    cp3 = CommandPost:New{name = "cp3con"}
    cp4 = CommandPost:New{name = "cp4con"}
    cp5 = CommandPost:New{name = "cp5con"}
    cp6 = CommandPost:New{name = "cp6con"}
    
    
    
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
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    
    conquest:Start()

    EnableSPHeroRules()
	
	SetProperty("cp1con", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp2con", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp3con", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp4con", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp5con", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp6con", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp1con", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp2con", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp3con", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp4con", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp5con", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp6con", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	
	SetProperty("cp1con", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp2con", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp3con", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp4con", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp5con", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp6con", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
	SetProperty("cp1con", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp2con", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp3con", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp4con", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp5con", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	SetProperty("cp6con", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
	
	if not ScriptCB_InMultiplayer() then
		DecideShepClass()
	else
			print("decide shepard::infiltrator")
		SetHeroClass(REP, "ssv_hero_shepard_infiltrator")
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\ME5n.lvl")
	manager:Proc_ScriptInit_Begin()
    
   
    SetMaxFlyHeight(150)
    SetMaxPlayerFlyHeight (150)
    
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
	Setup_SSVxGTH_lg()
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
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:PRG\\PRG.lvl", "PRG_conquest")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\PRG.lvl", "PRG_conquest")
    SetDenseEnvironment("false")




    --  Sound
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5n_music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ME5_ambiance")
	OpenAudioStream("sound\\kam.lvl",  "kam1")
	OpenAudioStream("sound\\kam.lvl",  "kam1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "col_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "gth_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl",  "ssv_unit_vo_quick")

	SetBleedingVoiceOver(REP, REP, "ssv_adm_com_report_us_bleeding", 1)
	SetBleedingVoiceOver(REP, CIS, "ssv_adm_com_report_enemy_bleeding",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
	SetOutOfBoundsVoiceOver(REP, "ssv_adm_com_report_hiatus")

	Music01()
	
	SoundFX()


--OpeningSateliteShot
    AddCameraShot(0.908386, -0.209095, -0.352873, -0.081226, -45.922508, -19.114113, 77.022636);

    AddCameraShot(-0.481173, 0.024248, -0.875181, -0.044103, 14.767292, -30.602322, -144.506851);
    AddCameraShot(0.999914, -0.012495, -0.004416, -0.000055, 1.143253, -33.602314, -76.884430);
    AddCameraShot(0.839161, 0.012048, -0.543698, 0.007806, 19.152437, -49.802273, 24.337317);
    AddCameraShot(0.467324, 0.006709, -0.883972, 0.012691, 11.825212, -49.802273, -7.000720);
    AddCameraShot(0.861797, 0.001786, -0.507253, 0.001051, -11.986043, -59.702248, 23.263165);
    AddCameraShot(0.628546, -0.042609, -0.774831, -0.052525, 20.429928, -48.302277, 9.771714);
    AddCameraShot(0.765213, -0.051873, 0.640215, 0.043400, 57.692474, -48.302277, 16.540724);
    AddCameraShot(0.264032, -0.015285, -0.962782, -0.055734, -16.681797, -42.902290, 129.553268);
    AddCameraShot(-0.382320, 0.022132, -0.922222, -0.053386, 20.670977, -42.902290, 135.513001);
end

