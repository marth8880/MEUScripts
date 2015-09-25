--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams") 

    --  Republic Attacking (attacker is always #1)
    local REP = 1
    local CIS = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2


function ScriptPostLoad()

	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "team1_capture", captureRegion = "team2_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    
	ctf:Start()
	
    EnableSPHeroRules()
    
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
    
    ReadDataFile("ingame.lvl")
    
   
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
    
    ReadDataFile("sound\\tan.lvl;tan1cw")

    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer", 
                             "rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_officer",
                             "cis_inf_sniper",
                             "cis_inf_engineer",
                             "cis_inf_droideka",
                             "cis_hero_grievous")
                             
                             
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser")         
                             
    SetupTeams{

        rep={
            team = REP,
            units = 32,
            reinforcements = 150,
            soldier = {"rep_inf_ep3_rifleman",9, 25},
            assault = {"rep_inf_ep3_rocketeer",1, 4},
            engineer = {"rep_inf_ep3_engineer",1, 4},
            sniper  = {"rep_inf_ep3_sniper",1, 4},
            officer = {"rep_inf_ep3_officer",1, 4},
            special = {"rep_inf_ep3_jettrooper",1, 4},
            
            
        },
        
        cis={
            team = CIS,
            units = 32,
            reinforcements = 150,
            soldier = {"cis_inf_rifleman",9, 25},
            assault = {"cis_inf_rocketeer",1, 4},
            engineer = {"cis_inf_engineer",1, 4},
            sniper = {"cis_inf_sniper",1, 4},
            officer = {"cis_inf_officer",1, 4},
            special = {"cis_inf_droideka",1, 4},
        }
    }
    
            --  Hero Setup Section  --

        SetHeroClass(REP, "rep_hero_yoda")
        SetHeroClass(CIS, "cis_hero_grievous")
   

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 4) -- special -> droidekas
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
    SetMemoryPoolSize("SoldierAnimation", 270)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("FlagItem", 2)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:T4E\\T4E.lvl", "T4E_conquest")
    ReadDataFile("dc:T4E\\T4E.lvl", "T4E_ctf")
    SetDenseEnvironment("false")




    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\tan.lvl",  "tan1")
    OpenAudioStream("sound\\tan.lvl",  "tan1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\tan.lvl",  "tan1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_tan_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_tan_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_tan_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_tan_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_tan_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_tan_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_tan_amb_victory")
    SetDefeatMusic (REP, "rep_tan_amb_defeat")
    SetVictoryMusic(CIS, "cis_tan_amb_victory")
    SetDefeatMusic (CIS, "cis_tan_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    --  Camera Stats
	AddCameraShot(-0.370814, 0.035046, -0.923929, -0.087320, -71.966255, 23.668301, 27.930090);
	AddCameraShot(0.991073, 0.002392, 0.133299, -0.000322, 84.069084, 23.668301, -95.802574);

end

