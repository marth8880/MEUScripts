ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
if not ScriptCB_InMultiplayer() then
	RandomLayout = math.random(1,2)
else
end

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_setup_teams") 
ScriptCB_DoFile("ME5_RandomSides")
ScriptCB_DoFile("ME5_MapFunctions")
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;
	
function ScriptPostLoad()	   
	
	if not ScriptCB_InMultiplayer() then
		--This defines the CPs.  These need to happen first
		if RandomLayout == 1 then
			KillObject("cp1_2")
			KillObject("cp2_2")
			KillObject("cp3_2")
			KillObject("cp4_2")
			KillObject("cp5_2")
			
			--VRM_DisablePlanningGraphArcs1()
			VRM_DisableBarriers1()
			
			cp1 = CommandPost:New{name = "cp1_1"}
			cp2 = CommandPost:New{name = "cp2_1"}
			cp3 = CommandPost:New{name = "cp3_1"}
			cp4 = CommandPost:New{name = "cp4_1"}
			cp5 = CommandPost:New{name = "cp5_1"}
			
		elseif RandomLayout == 2 then
			KillObject("cp1_1")
			KillObject("cp2_1")
			KillObject("cp3_1")
			KillObject("cp4_1")
			KillObject("cp5_1")
			
			--VRM_DisablePlanningGraphArcs2()
			VRM_DisableBarriers2()
			
			cp1 = CommandPost:New{name = "cp1_2"}
			cp2 = CommandPost:New{name = "cp2_2"}
			cp3 = CommandPost:New{name = "cp3_2"}
			cp4 = CommandPost:New{name = "cp4_2"}
			cp5 = CommandPost:New{name = "cp5_2"}
			
		end
	else
		KillObject("cp1_2")
		KillObject("cp2_2")
		KillObject("cp3_2")
		KillObject("cp4_2")
		KillObject("cp5_2")
		
		VRM_DisableBarriers1()
		
		cp1 = CommandPost:New{name = "cp1_1"}
		cp2 = CommandPost:New{name = "cp2_1"}
		cp3 = CommandPost:New{name = "cp3_1"}
		cp4 = CommandPost:New{name = "cp4_1"}
		cp5 = CommandPost:New{name = "cp5_1"}
	end
	
	
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
    
    conquest:Start()

    EnableSPHeroRules()
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Conquest", 1000)
	AddAIGoal(1, "Deathmatch", 400)
	AddAIGoal(2, "Conquest", 1000)
	AddAIGoal(2, "Deathmatch", 400)
	
	
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			SetProperty("cp1_1", "CaptureTime", 20)
			SetProperty("cp2_1", "CaptureTime", 20)
			SetProperty("cp3_1", "CaptureTime", 20)
			SetProperty("cp4_1", "CaptureTime", 20)
			SetProperty("cp5_1", "CaptureTime", 20)
			SetProperty("cp1_1", "NeutralizeTime", 30)
			SetProperty("cp2_1", "NeutralizeTime", 30)
			SetProperty("cp3_1", "NeutralizeTime", 30)
			SetProperty("cp4_1", "NeutralizeTime", 30)
			SetProperty("cp5_1", "NeutralizeTime", 30)
		elseif RandomLayout == 2 then
			SetProperty("cp1_2", "CaptureTime", 20)
			SetProperty("cp2_2", "CaptureTime", 20)
			SetProperty("cp3_2", "CaptureTime", 20)
			SetProperty("cp4_2", "CaptureTime", 20)
			SetProperty("cp5_2", "CaptureTime", 20)
			SetProperty("cp1_2", "NeutralizeTime", 30)
			SetProperty("cp2_2", "NeutralizeTime", 30)
			SetProperty("cp3_2", "NeutralizeTime", 30)
			SetProperty("cp4_2", "NeutralizeTime", 30)
			SetProperty("cp5_2", "NeutralizeTime", 30)
		end
	else
		SetProperty("cp1_1", "CaptureTime", 20)
		SetProperty("cp2_1", "CaptureTime", 20)
		SetProperty("cp3_1", "CaptureTime", 20)
		SetProperty("cp4_1", "CaptureTime", 20)
		SetProperty("cp5_1", "CaptureTime", 20)
		SetProperty("cp1_1", "NeutralizeTime", 30)
		SetProperty("cp2_1", "NeutralizeTime", 30)
		SetProperty("cp3_1", "NeutralizeTime", 30)
		SetProperty("cp4_1", "NeutralizeTime", 30)
		SetProperty("cp5_1", "NeutralizeTime", 30)
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
    
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm1.lvl")
		elseif RandomLayout == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm2.lvl")
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm1.lvl")
	end
	
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
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_VRM_Streaming.lvl")
	ReadDataFile("sound\\kas.lvl;kas2cw")
	ReadDataFile("SIDE\\rep.lvl",
							"rep_inf_ep3_rocketeer",
							"rep_inf_ep3_engineer",
							"rep_inf_ep3_rifleman",
							"rep_inf_ep3_sniper",
							"rep_inf_ep3_officer",
							"rep_inf_ep3_jettrooper")
	ReadDataFile("SIDE\\cis.lvl",
							"cis_inf_droideka",
							"cis_inf_engineer",
							"cis_inf_officer",
							"cis_inf_rifleman",
							"cis_inf_rocketeer",
							"cis_inf_sniper")
    
	SetupTeams{
		rep = {
			team = REP,
			units = 17,
			reinforcements = 150,
			soldier  = { "rep_inf_ep3_rifleman",9, 25},
			assault  = { "rep_inf_ep3_rocketeer",2, 4},
			engineer = { "rep_inf_ep3_engineer",1, 4},
			sniper   = { "rep_inf_ep3_sniper",3, 4},
			officer = {"rep_inf_ep3_officer",1, 4},
			special = { "rep_inf_ep3_jettrooper",1, 4},
	        
		},
		cis = {
			team = CIS,
			units = 17,
			reinforcements = 150,
			soldier  = { "cis_inf_rifleman",9, 25},
			assault  = { "cis_inf_rocketeer",2, 4},
			engineer = { "cis_inf_engineer",1, 4},
			sniper   = { "cis_inf_sniper",3, 4},
			officer = {"cis_inf_officer",1, 4},
			special = { "cis_inf_droideka",1, 4},
		}
	}
	
	SetAIDifficulty(-2, 3)
	
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
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
    --SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 128)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Music", 74)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathFollower", 128)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("RedOmniLight", 180)
	SetMemoryPoolSize("SoldierAnimation", 274)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:VRM\\VRM.lvl", "VRM_conquest")
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_conquest1")
		elseif RandomLayout == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_conquest2")
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRM.lvl", "VRM_conquest1")
	end
	
	SetDenseEnvironment("true")
	SetAIViewMultiplier(0.6)
	
	
    --  Sound

	voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "wok_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   
    AudioStreamAppendSegments("sound\\global.lvl", "wok_unit_vo_quick", voiceQuick) 

    OpenAudioStream("sound\\global.lvl",  "cw_music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_VRM_Streaming.lvl",  "VRM_ambiance")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    OpenAudioStream("sound\\kas.lvl",  "kas")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetAmbientMusic(REP, 1.0, "rep_kas_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_kas_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_kas_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_kas_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_kas_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_kas_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_kas_amb_victory")
    SetDefeatMusic (REP, "rep_kas_amb_defeat")
    SetVictoryMusic(CIS, "cis_kas_amb_victory")
    SetDefeatMusic (CIS, "cis_kas_amb_defeat")

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--OpeningSatelliteShot
	if not ScriptCB_InMultiplayer() then
		if RandomLayout == 1 then
			AddCameraShot(0.993613, -0.112590, -0.007516, -0.000852, -144.671204, 12.469149, 105.698982);
			AddCameraShot(0.003597, -0.000253, -0.997521, -0.070274, -144.042343, 12.469149, 64.159500);
			AddCameraShot(0.583016, -0.093302, -0.796945, -0.127537, -190.497482, 12.469149, 81.069817);
			AddCameraShot(0.615988, -0.086602, 0.775356, 0.109007, -97.931252, 12.469149, 71.429901);
			AddCameraShot(0.900297, -0.099467, -0.421196, -0.046535, -191.081924, 12.469149, 159.755737);
			AddCameraShot(0.943805, -0.094135, 0.315250, 0.031443, -95.917686, 12.469149, 164.284882);
			AddCameraShot(0.039136, -0.004479, -0.992743, -0.113616, -145.351196, 12.469149, 7.593871);
		elseif RandomLayout == 2 then	
			AddCameraShot(-0.002603, 0.000291, -0.993826, -0.110921, -143.897095, 3.996937, 63.976448);
			AddCameraShot(0.988029, -0.062941, -0.140561, -0.008954, -178.127380, 3.329980, 160.339279);
			AddCameraShot(0.994183, -0.100278, 0.039100, 0.003944, -111.153236, 3.329980, 160.421097);
			AddCameraShot(-0.154437, 0.015577, -0.982893, -0.099139, -139.302277, 3.329980, 11.938937);
			AddCameraShot(0.029739, -0.001928, -0.997462, -0.064662, -144.570724, 4.141372, 47.818638);
			AddCameraShot(0.268598, -0.033939, -0.955060, -0.120677, -151.530655, 4.141372, 76.839523);
			AddCameraShot(-0.202531, 0.021344, -0.973651, -0.102609, -138.926117, 4.141372, 72.072609);
		end
	else
		AddCameraShot(0.993613, -0.112590, -0.007516, -0.000852, -144.671204, 12.469149, 105.698982);
		AddCameraShot(0.003597, -0.000253, -0.997521, -0.070274, -144.042343, 12.469149, 64.159500);
		AddCameraShot(0.583016, -0.093302, -0.796945, -0.127537, -190.497482, 12.469149, 81.069817);
		AddCameraShot(0.615988, -0.086602, 0.775356, 0.109007, -97.931252, 12.469149, 71.429901);
		AddCameraShot(0.900297, -0.099467, -0.421196, -0.046535, -191.081924, 12.469149, 159.755737);
		AddCameraShot(0.943805, -0.094135, 0.315250, 0.031443, -95.917686, 12.469149, 164.284882);
		AddCameraShot(0.039136, -0.004479, -0.992743, -0.113616, -145.351196, 12.469149, 7.593871);
	end

end

