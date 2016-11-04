ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

mapSize = "sm"
EnvironmentType = "urban"
onlineSideVar = "SSVxCOL"
onlineHeroSSV = "shep_vanguard"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {}

if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 2
	CIS = 1
end

HuskTeam = 3

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
 
--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

        SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
		SetProperty ("com_item_vehicle_spawn", "SpawnCount",1)
		SetProperty ("com_item_vehicle_spawn1", "SpawnCount",0)
		SetProperty ("com_item_vehicle_spawn2", "SpawnCount",0)

--Capture the Flag for stand-alone multiplayer
                -- These set the flags geometry names.
                --GeometryName sets the geometry when hte flag is on the ground
                --CarriedGeometryName sets the geometry that appears over a player's head that is carrying the flag
        SetProperty("flag1", "GeometryName", "com_icon_cis_flag")
        SetProperty("flag1", "CarriedGeometryName", "com_icon_cis_flag_carried")
        SetProperty("flag2", "GeometryName", "com_icon_republic_flag")
        SetProperty("flag2", "CarriedGeometryName", "com_icon_republic_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
        SetClassProperty("com_item_flag_carried", "DroppedColorize", 1)

    --This is all the actual ctf objective setup

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "Team1FlagCapture", captureRegion = "Team2FlagCapture"}
    ctf:AddFlag{name = "flag2", homeRegion = "Team2FlagCapture", captureRegion = "Team1FlagCapture"}
    ctf:Start()

    
    EnableSPHeroRules()
	
	--[[if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			Music06_CTF()
			music01 = music06_start
			music02 = music06_mid
			music03 = music06_end
			musicTimerValue = 185
		elseif RandomSide == 2 then
			Music02_CTF()
			music01 = Mus02Start
			music02 = Mus02Mid
			music03 = Mus02End
			musicTimerValue = 120
		end
	else
		music01 = Mus02Start
		music02 = Mus02Mid
		music03 = Mus02End
		musicTimerValue = 120
	end
	
	ScriptCB_PlayInGameMusic(music01)
	
	CreateTimer("music_timer")
		SetTimerValue("music_timer", musicTimerValue)
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
				
				SetTimerValue("music_timer", musicTimerValue)
				StartTimer("music_timer")
			end,
			"music_timer"
		)]]
    
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("ctf", heroSupportCPs)
	
end

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     
     
    StealArtistHeap(550*1024)

	SetPS2ModelMemory(4130000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;pol1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2183)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1291)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1406)
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")

    SetMapNorthAngle(0)
    SetMaxFlyHeight(55)
    SetMaxPlayerFlyHeight (55)
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_POL_Streaming.lvl;pol1n")
	
    --  Level Stats
        ClearWalkers()
        AddWalkerType(0, 0) -- 3 droidekas (special case: 0 leg pairs)
        --   AddWalkerType(1, 4) 
        --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
        --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
        local weaponCnt = 200
        SetMemoryPoolSize("Aimer", 30)
        SetMemoryPoolSize("AmmoCounter", weaponCnt)
        SetMemoryPoolSize("BaseHint", 250)
        SetMemoryPoolSize("EnergyBar", weaponCnt)
        SetMemoryPoolSize("EntityHover", 0)
        SetMemoryPoolSize("EntityLight", 63)
        SetMemoryPoolSize("EntitySoundStream", 25)
        SetMemoryPoolSize("EntitySoundStatic", 10)
		SetMemoryPoolSize("FlagItem", 512)
        SetMemoryPoolSize("MountedTurret", 18)
        SetMemoryPoolSize("Navigator", 50)
        SetMemoryPoolSize("Obstacle", 400)
        SetMemoryPoolSize("PathFollower", 50)
        SetMemoryPoolSize("PathNode", 200)
        SetMemoryPoolSize("SoundSpaceRegion", 34)
        SetMemoryPoolSize("TentacleSimulator", 0)
        SetMemoryPoolSize("TreeGridStack", 180)
        SetMemoryPoolSize("UnitAgent", 50)
        SetMemoryPoolSize("UnitController", 50)
        SetMemoryPoolSize("Weapon", weaponCnt)
		SetMemoryPoolSize("EntityFlyer", 4)   

        SetMemoryPoolSize ("Asteroid", 100)

    SetSpawnDelay(10.0, 0.25)
     ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\pol1.lvl", "pol1_ctf")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;pol1")
     SetDenseEnvironment("True")   
     AddDeathRegion("deathregion1")
     --SetStayInTurrets(1)

--asteroids start!
SetParticleLODBias(3000)
SetMaxCollisionDistance(1500)     
--    FillAsteroidPath("pathas01", 10, "pol1_prop_asteroid_01", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas01", 20, "pol1_prop_asteroid_02", 40, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas02", 10, "pol1_prop_asteroid_01", 10, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas03", 10, "pol1_prop_asteroid_02", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas04", 5, "pol1_prop_asteroid_02", 2, 1.0,0.0,0.0, -1.0,0.0,0.0);      

-- asteroids end!

    --  Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Music04_CTF()
		elseif ME5_SideVar == 2 then
			Music02_CTF()
		elseif ME5_SideVar == 3	then
			Music06_CTF()
		elseif ME5_SideVar == 4	then
			Music09_CTF()
		end
	else
		Music02_CTF()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_POL_Streaming.lvl",  "pol1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_POL_Streaming.lvl",  "pol1")
	
	SoundFX()


    --  Camera Stats
    --Tat 1 - Dune Sea
    --Crawler
    AddCameraShot(0.461189, -0.077838, -0.871555, -0.147098, 85.974007, 30.694353, -66.900795);
    AddCameraShot(0.994946, -0.100380, -0.002298, -0.000232, 109.076401, 27.636383, -10.235785);
    AddCameraShot(0.760383, 0.046402, 0.646612, -0.039459, 111.261696, 27.636383, 46.468048);
    AddCameraShot(-0.254949, 0.066384, -0.933546, -0.243078, 73.647552, 32.764030, 50.283028);
    AddCameraShot(-0.331901, 0.016248, -0.942046, -0.046116, 111.003563, 28.975283, 7.051458);
    AddCameraShot(0.295452, -0.038140, -0.946740, -0.122217, 19.856682, 36.399086, -9.890361);
    AddCameraShot(0.958050, -0.115837, -0.260254, -0.031467, -35.103737, 37.551651, 109.466576);
    AddCameraShot(-0.372488, 0.036892, -0.922789, -0.091394, -77.487892, 37.551651, 40.861832);
    AddCameraShot(0.717144, -0.084845, -0.686950, -0.081273, -106.047691, 36.238495, 60.770439);
    AddCameraShot(0.452958, -0.104748, -0.862592, -0.199478, -110.553474, 40.972584, 37.320778);
    AddCameraShot(-0.009244, 0.001619, -0.984956, -0.172550, -57.010258, 30.395561, 5.638251);
    AddCameraShot(0.426958, -0.040550, -0.899315, -0.085412, -87.005966, 30.395561, 19.625088);
    AddCameraShot(0.153632, -0.041448, -0.953179, -0.257156, -111.955055, 36.058708, -23.915501);
    AddCameraShot(0.272751, -0.002055, -0.962055, -0.007247, -117.452736, 17.298250, -58.572723);
    AddCameraShot(0.537097, -0.057966, -0.836668, -0.090297, -126.746666, 30.472836, -148.353333);
    AddCameraShot(-0.442188, 0.081142, -0.878575, -0.161220, -85.660973, 29.013374, -144.102219);
    AddCameraShot(-0.065409, 0.011040, -0.983883, -0.166056, -84.789032, 29.013374, -139.568787);
    AddCameraShot(0.430906, -0.034723, -0.898815, -0.072428, -98.038002, 47.662624, -128.643265);
    AddCameraShot(-0.401462, 0.047050, -0.908449, -0.106466, 77.586563, 47.662624, -147.517365);
    AddCameraShot(-0.269503, 0.031284, -0.956071, -0.110983, 111.260330, 16.927542, -114.045715);
    AddCameraShot(-0.338119, 0.041636, -0.933134, -0.114906, 134.970169, 26.441256, -82.282082);
	
	PostLoadStuff()


end


