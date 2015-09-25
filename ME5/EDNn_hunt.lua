ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_ObjectiveTDM")
ScriptCB_DoFile("ME5_setup_teams")

    --  Empire Attacking (attacker is always #1)
    REP = 2
    CIS = 1
    --  These variables do not change
    ATT = 1
    DEF = 2


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------



function ScriptPostLoad()
WeatherMode = math.random(1,3)
weather()

	
    hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 3, textATT = "game.modes.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true}
    
    hunt.OnStart = function(self)
    	AddAIGoal(ATT, "Deathmatch", 1000)
    	AddAIGoal(DEF, "Deathmatch", 1000)
    end
   

	hunt:Start()

	AddDeathRegion("monorail")
	AddDeathRegion("ocean")
    
 end

function weather()

    if WeatherMode == 1 then
    ReadDataFile("dc:EDN\\spa_sky.lvl", "red")
    elseif WeatherMode == 2 then
    ReadDataFile("dc:EDN\\spa_sky.lvl", "red")
    elseif WeatherMode == 3 then
    ReadDataFile("dc:EDN\\spa_sky.lvl", "red")


end
end

function ScriptInit()
	if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    end
    
    -- Designers, these two lines *MUST* be first.
    --SetPS2ModelMemory(4500000)
    SetPS2ModelMemory(3300000)
    ReadDataFile("ingame.lvl")
    
    --  Empire Attacking (attacker is always #1)
REP = 1
CIS = 2
DES = 3
    --  These variables do not change
ATT = 1
DEF = 2

	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")


    SetMaxFlyHeight(60)
    SetMaxPlayerFlyHeight(60)
    SetGroundFlyerMap(0);

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
				"ssv_inf_soldier",
				"ssv_inf_infiltrator",
				"ssv_inf_adept",
				"ssv_inf_engineer",
				"ssv_inf_sentinel",
				"ssv_inf_vanguard")
                             
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\indoc.lvl",
                             "indoc_inf_husk")
                             

    SetupTeams{

        rep={
            team = REP,
            units = 15,
            reinforcements = -1,
            soldier = {"ssv_inf_engineer",8, 25},            
        },
        
        cis={
            team = CIS,
            units = 15,
            reinforcements = -1,
            soldier = {"indoc_inf_husk", 8, 25},
        }
    }


--Setting up Heros--

    
   
       --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", -2)
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 0) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 0) -- 2 atats with 2 leg pairs each

    SetMemoryPoolSize("Aimer", 90)
    SetMemoryPoolSize("AmmoCounter", 269)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("CommandWalker", 2)
    SetMemoryPoolSize("ConnectivityGraphFollower", 56)
    SetMemoryPoolSize("EnergyBar", 269)
	SetMemoryPoolSize("EntityCloth", 28)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityLight", 225)
    SetMemoryPoolSize("EntitySoundStatic", 16)
    SetMemoryPoolSize("EntitySoundStream", 5)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("MountedTurret", 46)
    SetMemoryPoolSize("Navigator", 63)
    SetMemoryPoolSize("Obstacle", 400)
  SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 268)
	SetMemoryPoolSize("RedOmniLight", 240)
    SetMemoryPoolSize("TreeGridStack", 329)
    SetMemoryPoolSize("UnitController", 63)
    SetMemoryPoolSize("UnitAgent", 63)
    SetMemoryPoolSize("Weapon", 269)

    ReadDataFile("EDN\\EDN.lvl", "EDN_hunt")
    --ReadDataFile("tan\\tan1.lvl", "tan1_obj")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")

    -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .75, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .5, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .25, 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    -- SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_hot_amb_hunt",  0,1)
    -- SetAmbientMusic(ALL, 0.9, "all_hot_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.1, "all_hot_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_hot_amb_hunt",  0,1)
    -- SetAmbientMusic(IMP, 0.9, "imp_hot_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.1, "imp_hot_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_hot_amb_victory")
    SetDefeatMusic (ALL, "all_hot_amb_defeat")
    SetVictoryMusic(IMP, "imp_hot_amb_victory")
    SetDefeatMusic (IMP, "imp_hot_amb_defeat")

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
	AddCameraShot(-0.343467, 0.042708, -0.931023, -0.115767, -8.370228, 7.682051, -68.327812);
	AddCameraShot(0.447841, -0.066177, -0.882082, -0.130344, -64.310715, 17.633507, 74.121971);
	AddCameraShot(0.921308, -0.158280, -0.350031, -0.060135, -104.089935, 19.899040, 41.774940);
	AddCameraShot(0.714986, -0.147160, -0.669443, -0.137786, -103.483871, 20.399969, 61.148930);
	AddCameraShot(-0.004849, 0.000026, -0.999974, -0.005416, -20.710209, 5.094892, -33.587643);
end
