ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveOneFlagCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "1flag",
	mapSize = "xl",
	environmentType = "snow",
	terrainFoleyGroup = "snow",
	
	-- In-game music
	musicVariation_SSVxGTH = "3_nov",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_vanguard",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {},
}
-- Initialize the MapManager
manager:Init()

-- Randomize which team is ATT/DEF
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

	--Capture the Flag for stand-alone multiplayer
                -- These set the flags geometry names.
                --GeometryName sets the geometry when hte flag is on the ground
                --CarriedGeometryName sets the geometry that appears over a player's head that is carrying the flag
        --[[SetProperty("flag1", "GeometryName", "com_icon_cis_flag")
        SetProperty("flag1", "CarriedGeometryName", "com_icon_cis_flag_carried")
        SetProperty("flag2", "GeometryName", "com_icon_republic_flag")
        SetProperty("flag2", "CarriedGeometryName", "com_icon_republic_flag_carried")]]

	--This makes sure the flag is colorized when it has been dropped on the ground
	--SetClassProperty("com_item_flag_carried", "DroppedColorize", 1)
	
   EnableSPHeroRules()
   SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
        --This is the actual objective setup
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "lag_capture2", captureRegionDEF = "lag_capture1",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, hideCPs = true, multiplayerRules = true,
                           capRegionDummyObjectATT = "lag_capture2", capRegionDummyObjectDEF = "lag_capture1",}
    ctf:Start()
	
	manager:Proc_ScriptPostLoad_End()
	
end

function ScriptInit()
     -- Designers, these two lines *MUST* be first!
    StealArtistHeap(550*1024)
	SetPS2ModelMemory(4130000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\NOV.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2183)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1291)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1406)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")

    SetMapNorthAngle(0)
    SetMaxFlyHeight(40)
    SetMaxPlayerFlyHeight(40)
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_NOV_Streaming.lvl")
	
	--  Level Stats
	ClearWalkers()
	AddWalkerType(0, 0) -- 3 droidekas (special case: 0 leg pairs)
	--AddWalkerType(1, 4) 
	--AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
	--AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
	local weaponCnt = 200
	SetMemoryPoolSize("Aimer", 30)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 373)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityHover", 0)
	SetMemoryPoolSize("EntityLight", 63)
	SetMemoryPoolSize("EntitySoundStream", 32)
	SetMemoryPoolSize("EntitySoundStatic", 10)
	SetMemoryPoolSize("Navigator", 50)
	SetMemoryPoolSize("Obstacle", 467)
	SetMemoryPoolSize("PathFollower", 50)
	SetMemoryPoolSize("PathNode", 200)
	SetMemoryPoolSize("SoldierAnimation", 403)
	SetMemoryPoolSize("SoundSpaceRegion", 34)
	SetMemoryPoolSize("TentacleSimulator", 0)
	SetMemoryPoolSize("TreeGridStack", 243)
	SetMemoryPoolSize("UnitAgent", 50)
	SetMemoryPoolSize("UnitController", 50)
	SetMemoryPoolSize("Weapon", weaponCnt)
	--SetMemoryPoolSize("EntityFlyer", 4)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\NOV.lvl", "NOV_ctf")
	SetDenseEnvironment("True")   
	AddDeathRegion("chasm_death")
     --SetStayInTurrets(1)
	
	--SetParticleLODBias(3000)
	--SetMaxCollisionDistance(1500)

    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_NOV_Streaming.lvl",  "NOV_ambiance")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_NOV_Streaming.lvl",  "NOV_ambiance")
	
	SoundFX()
	
    -- Camera Stats
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
	
	manager:Proc_ScriptInit_End()
end
