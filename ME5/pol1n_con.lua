ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = med
EnvironmentType = 4
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_vanguard
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3

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

function SSVxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("CP1Con","CP1SpawnPathCon")
			herosupport:AddSpawnCP("CP2Con","CP2SpawnPathCon")
			herosupport:AddSpawnCP("CP3Con","CP3SpawnPathCon")
			herosupport:AddSpawnCP("CP4Con","CP4SpawnPathCon")
			herosupport:AddSpawnCP("CP5Con","CP5SpawnPathCon")
			herosupport:AddSpawnCP("CP6Con","CP6SpawnPathCon")
			herosupport:Start()
		else end
	else end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("CP1Con","CP1SpawnPathCon")
			herosupport:AddSpawnCP("CP2Con","CP2SpawnPathCon")
			herosupport:AddSpawnCP("CP3Con","CP3SpawnPathCon")
			herosupport:AddSpawnCP("CP4Con","CP4SpawnPathCon")
			herosupport:AddSpawnCP("CP5Con","CP5SpawnPathCon")
			herosupport:AddSpawnCP("CP6Con","CP6SpawnPathCon")
			herosupport:Start()
		else end
	else end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("CP1Con","CP1SpawnPathCon")
			herosupport:AddSpawnCP("CP2Con","CP2SpawnPathCon")
			herosupport:AddSpawnCP("CP3Con","CP3SpawnPathCon")
			herosupport:AddSpawnCP("CP4Con","CP4SpawnPathCon")
			herosupport:AddSpawnCP("CP5Con","CP5SpawnPathCon")
			herosupport:AddSpawnCP("CP6Con","CP6SpawnPathCon")
			herosupport:Start()
		else end
	else end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("CP1Con","CP1SpawnPathCon")
			herosupport:AddSpawnCP("CP2Con","CP2SpawnPathCon")
			herosupport:AddSpawnCP("CP3Con","CP3SpawnPathCon")
			herosupport:AddSpawnCP("CP4Con","CP4SpawnPathCon")
			herosupport:AddSpawnCP("CP5Con","CP5SpawnPathCon")
			herosupport:AddSpawnCP("CP6Con","CP6SpawnPathCon")
			herosupport:Start()
		else end
	else end
end

function ScriptPostLoad()
	--[[SetObjectTeam("CP1Con", 0)
	SetObjectTeam("CP2Con", 0)
	SetObjectTeam("CP3Con", 0)
	SetObjectTeam("CP4Con", 0)]]
	
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "CP1Con"}
    cp2 = CommandPost:New{name = "CP2Con"}
    cp3 = CommandPost:New{name = "CP3Con"}
    cp4 = CommandPost:New{name = "CP4Con"}
    cp5 = CommandPost:New{name = "CP5Con"}
    cp6 = CommandPost:New{name = "CP6Con"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", textDEF = "game.modes.con2", 
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    
    conquest:Start()
 
     --PlayAnimLock01Open();

    OnObjectRespawnName(PlayAnimLock01Open, "LockCon01");
    OnObjectKillName(PlayAnimLock01Close, "LockCon01");
 
    EnableSPHeroRules()
	
	SetProperty("CP1Con", "AllyPath", "CP1SpawnPathCon")
	SetProperty("CP2Con", "AllyPath", "CP2SpawnPathCon")
	SetProperty("CP3Con", "AllyPath", "CP3SpawnPathCon")
	SetProperty("CP4Con", "AllyPath", "CP4SpawnPathCon")
	SetProperty("CP5Con", "AllyPath", "CP5SpawnPathCon")
	SetProperty("CP6Con", "AllyPath", "CP6SpawnPathCon")
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				SSVxGTH_PostLoad()
			elseif RandomSide == 2 then
				SSVxCOL_PostLoad()
			elseif RandomSide == 3 then
				EVGxGTH_PostLoad()
			elseif RandomSide == 4 then
				EVGxCOL_PostLoad()
			end
		elseif ME5_SideVar == 1 then
			SSVxGTH_PostLoad()
		elseif ME5_SideVar == 2 then
			SSVxCOL_PostLoad()
		elseif ME5_SideVar == 3 then
			EVGxGTH_PostLoad()
		elseif ME5_SideVar == 4 then
			EVGxCOL_PostLoad()
		else end
	else
		SSVxCOL_PostLoad()
	end
	
	SetProperty("CP1Con", "NeutralizeTime", 40)
	SetProperty("CP1Con", "CaptureTime", 35)
	SetProperty("CP2Con", "NeutralizeTime", 40)
	SetProperty("CP2Con", "CaptureTime", 35)
	SetProperty("CP3Con", "NeutralizeTime", 40)
	SetProperty("CP3Con", "CaptureTime", 35)
	SetProperty("CP4Con", "NeutralizeTime", 40)
	SetProperty("CP4Con", "CaptureTime", 35)
	SetProperty("CP5Con", "NeutralizeTime", 40)
	SetProperty("CP5Con", "CaptureTime", 35)
	SetProperty("CP6Con", "NeutralizeTime", 40)
	SetProperty("CP6Con", "CaptureTime", 35)
	
end
 
 --START DOOR WORK!

-- OPEN
function PlayAnimLock01Open()
      PauseAnimation("Airlockclose");    
      RewindAnimation("Airlockopen");
      PlayAnimation("Airlockopen");
        
    -- allow the AI to run across it
    --UnblockPlanningGraphArcs("Connection122");
    --DisableBarriers("BridgeBarrier");
    
end
-- CLOSE
function PlayAnimLock01Close()
      PauseAnimation("Airlockopen");
      RewindAnimation("Airlockclose");
      PlayAnimation("Airlockclose");
            
    -- prevent the AI from running across it
    --BlockPlanningGraphArcs("Connection122");
    --EnableBarriers("BridgeBarrier");
      
end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(600*1024)
    SetPS2ModelMemory(4100000)
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
        --   AddWalkerType(1, 3) 
        --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
        --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
        local weaponCnt = 200
        SetMemoryPoolSize ("Aimer", 60)
        SetMemoryPoolSize ("AmmoCounter", weaponCnt)
        SetMemoryPoolSize ("BaseHint", 245)
        SetMemoryPoolSize ("EnergyBar", weaponCnt)
        SetMemoryPoolSize ("EntityCloth", 17)
        SetMemoryPoolSize ("EntityHover",4)
        SetMemoryPoolSize ("EntitySoundStatic", 9)
		SetMemoryPoolSize("FlagItem", 512)
        SetMemoryPoolSize ("MountedTurret", 18)
        SetMemoryPoolSize ("Music", 80)
        SetMemoryPoolSize ("Navigator", 45)
        SetMemoryPoolSize ("Obstacle", 390)
        SetMemoryPoolSize ("PathFollower", 45)
        SetMemoryPoolSize ("PathNode", 128)
		SetMemoryPoolSize ("SoldierAnimation", 334)
        SetMemoryPoolSize ("SoundSpaceRegion", 34)
        SetMemoryPoolSize ("TentacleSimulator", 0)
        SetMemoryPoolSize ("TreeGridStack", 180)
        SetMemoryPoolSize ("UnitAgent", 45)
        SetMemoryPoolSize ("UnitController", 45)
        SetMemoryPoolSize ("Weapon", weaponCnt)
		SetMemoryPoolSize("EntityFlyer", 4)   

        SetMemoryPoolSize ("Asteroid", 100)

    SetSpawnDelay(10.0, 0.25)
     ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\pol1.lvl", "pol1_Conquest")
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
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music04()
			elseif RandomSide == 2 then
				Music02()
			elseif RandomSide == 3 then
				Music06()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music04()
		elseif ME5_SideVar == 2 then
			Music02()
		elseif ME5_SideVar == 3	then
			Music06()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music02()
	end
	
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
