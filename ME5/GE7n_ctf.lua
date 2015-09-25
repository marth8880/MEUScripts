-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ObjectiveCTF")

REP = 1;
CIS = 2;

ATT = REP;
DEF = CIS;


function ScriptPostLoad()

  BlockPlanningGraphArcs("Connection48")
  BlockPlanningGraphArcs("Connection50")
  BlockPlanningGraphArcs("Connection56")
  BlockPlanningGraphArcs("Connection58")
  BlockPlanningGraphArcs("Connection59")
  BlockPlanningGraphArcs("Connection109")
  
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )

  SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
  SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
  SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
  SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

  SetClassProperty("com_item_flag", "DroppedColorize", 1)
    
   ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "team1_capture", captureRegion = "team2_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    
	ctf:Start()
	
  EnableSPHeroRules()
  
  AddDeathRegion("dr1")
         
  BlockPlanningGraphArcs("Connection48")
  BlockPlanningGraphArcs("Connection50")
  BlockPlanningGraphArcs("Connection58")
  BlockPlanningGraphArcs("Connection59")
  BlockPlanningGraphArcs("Connection109")
    
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
    
    ReadDataFile("dc:Load\\common.lvl")
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
    
    ReadDataFile("sound\\yav.lvl;yav1cw")    
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep2_rifleman",
                             "rep_inf_ep2_rocketeer",
                             "rep_inf_ep2_engineer",
                             "rep_inf_ep2_sniper",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep2_jettrooper",
                             "rep_hero_anakin",
                             "rep_walk_oneman_atst")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_inf_droideka",
                             "cis_hero_darthmaul",
                             "cis_hover_aat")
                             
    ReadDataFile("SIDE\\tur.lvl", 
    			                   "tur_bldg_laser",
                             "tur_bldg_beam",
                             "tur_bldg_mortar",
                             "tur_bldg_geoturret")          
                             
	SetupTeams{
		rep = {
			team = REP,
			units = 20,
			reinforcements = 150,
			soldier  = { "rep_inf_ep2_rifleman",9, 25},
			assault  = { "rep_inf_ep2_rocketeer",1, 4},
			engineer = { "rep_inf_ep2_engineer",1, 4},
			sniper   = { "rep_inf_ep2_sniper",1, 4},
			officer = {"rep_inf_ep3_officer",1, 4},
			special = { "rep_inf_ep2_jettrooper",1, 4},
	        
		},
		cis = {
			team = CIS,
			units = 20,
			reinforcements = 150,
			soldier  = { "cis_inf_rifleman",9, 25},
			assault  = { "cis_inf_rocketeer",1, 4},
			engineer = { "cis_inf_engineer",1, 4},
			sniper   = { "cis_inf_sniper",1, 4},
			officer = {"cis_inf_officer",1, 4},
			special = { "cis_inf_droideka",1, 4},
		}
	}
     
    SetHeroClass(CIS, "cis_hero_darthmaul")
    SetHeroClass(REP, "rep_hero_anakin")
   
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 5) -- 1x2 (1 pair of legs)
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
	  SetMemoryPoolSize("FlagItem", 2)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:GE7\\GE7.lvl", "GE7_ctf")
    SetDenseEnvironment("false")

    ------ Sound ------
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")

    SetAmbientMusic(REP, 1.0, "rep_yav_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_yav_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_yav_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_yav_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_yav_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_yav_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_yav_amb_victory")
    SetDefeatMusic (REP, "rep_yav_amb_defeat")
    SetVictoryMusic(CIS, "cis_yav_amb_victory")
    SetDefeatMusic (CIS, "cis_yav_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    SetAttackingTeam(ATT)

    ------ OpeningSateliteShot ------
		AddCameraShot(-0.347880, 0.038874, -0.930938, -0.104028, 66.435631, 11.032948, 52.811352);
    AddCameraShot(0.521041, 0.067458, 0.843819, -0.109248, 28.376871, 11.123616, 35.530045);
	  AddCameraShot(0.899533, 0.095364, -0.423942, 0.044944, -46.051346, 14.026678, 5.547310);
	  AddCameraShot(0.987645, 0.046299, 0.149546, -0.007010, -15.153394, 2.704909, 76.413383);
	  
end

