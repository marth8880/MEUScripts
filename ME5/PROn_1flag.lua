ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveOneFlagCTF")

	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
	ColHuskTeam = 3;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;

function ScriptPostLoad()

	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )
	
	print("start 1flag objective")
    --This sets up the actual objective.  This needs to happen after cp's are defined
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
                           captureLimit = 10, flag = "1flag_flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "1flag_homeregion",
                           captureRegionATT = "1flag_team_capture", captureRegionDEF = "1flag_team_capture",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true}
    ctf:Start()
	print("end 1flag objective")
	
    EnableSPHeroRules()
	
	SetClassProperty("com_item_flag", "LifeSpan", 5.0)
	
	AddAIGoal(1, "Defend", 700, "1flag_team_capture")
	AddAIGoal(2, "Defend", 700, "1flag_team_capture")
	AddAIGoal(1, "Defend", 400, "1flag_homeregion")
	AddAIGoal(2, "Defend", 400, "1flag_homeregion")
	AddAIGoal(1, "Deathmatch", 300)
	AddAIGoal(2, "Deathmatch", 300)
	
	--[[Music06_CTF()
	music01 = music06_start
	music02 = music06_mid
	music03 = music06_end
	
	ScriptCB_PlayInGameMusic(music01)
	
	CreateTimer("music_timer")
		SetTimerValue("music_timer", 185)
		StartTimer("music_timer")
		--ShowTimer("music_timer")
		OnTimerElapse(
			function(timer)
				RandomMusic = math.random(1,3)
				
				if RandomMusic == 1 then
						print("execute music variation 1")
					ScriptCB_PlayInGameMusic(music01)
				elseif RandomMusic == 2 then
						print("execute music variation 2")
					ScriptCB_PlayInGameMusic(music02)
				elseif RandomMusic == 3 then
						print("execute music variation 3")
					ScriptCB_PlayInGameMusic(music03)
				end
				
				SetTimerValue("music_timer", 185)
				StartTimer("music_timer")
			end,
			"music_timer"
		)]]
    
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\pro.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
	PreLoadStuff()
	
	EnvironmentType = EnvTypeUrban
	
    SetMaxFlyHeight(16)
    SetMaxPlayerFlyHeight(16)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	
	LoadSSV()
	LoadGTH()
	Setup_SSVxGTH_xs()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
	else
		SetHeroClass(REP, "ssv_hero_shepard_vanguard")
	end
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl")
	--ReadDataFile("sound\\kas.lvl;kas2cw")
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 240
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 22)
	SetMemoryPoolSize("EntityFlyer", 7)
    SetMemoryPoolSize("EntityHover", 8)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 16)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("MountedTurret", 25)
	SetMemoryPoolSize("Navigator", 49)
    SetMemoryPoolSize("Obstacle", 760)
	SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("SoundSpaceRegion", 46)
    SetMemoryPoolSize("TreeGridStack", 500)
	SetMemoryPoolSize("UnitAgent", 49)
	SetMemoryPoolSize("UnitController", 49)
	SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("FlagItem", 512)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:PRO\\PRO.lvl", "PRO_conquest")
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\PRO.lvl", "PRO_1flag")
    SetDenseEnvironment("false")
	
	
    --  Sound
    
	
    SSVWorldVO()
	GTHWorldVO()

    Music03_CTF()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")

    SoundFX()


-- Opening Satellite Shots
	AddCameraShot(0.978525, -0.037464, 0.202548, 0.007755, 25.577356, 5.990258, -14.311792);
	AddCameraShot(-0.227115, 0.008059, -0.973222, -0.034536, 26.382149, 5.990258, -122.364380);
	AddCameraShot(0.013350, -0.001503, -0.993636, -0.111838, -7.550848, 2.605920, -82.578865);
	AddCameraShot(0.447179, 0.042278, -0.889478, 0.084095, -5.463669, 4.427572, -117.635323);
	AddCameraShot(0.005516, 0.001051, -0.982325, 0.187099, 10.208848, 0.576734, -125.363136);
end

