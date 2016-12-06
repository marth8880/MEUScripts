ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,
	gameMode = "conquest",
	mapSize = "sm",
	environmentType = "desert",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
	onlineHeroSSV = "shep_infiltrator",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns (required). CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
	},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
	},
	
	-- Artillery strike path nodes (required only if artillery strikes are desired). Path name, path node ID
	artilleryNodes = {
				{"cp1_spawn", 0},
				{"cp2_spawn", 0},
				{"cp3_spawn", 0},
				{"cp4_spawn", 0},
	},
	terrainType = "dirt",
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


function ScriptPostLoad()
	
	--This defines the CPs.  These need to happen first
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
	
	manager:Proc_ScriptPostLoad_End()
	
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
	StealArtistHeap(2048*2048)

	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\INI.lvl")

	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2559)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1513)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1699)

	manager:Proc_ScriptInit_Begin()
	
	
	SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)

	manager:Proc_ScriptInit_SideSetup()

	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_INI_Streaming.lvl")

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
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
	SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 207)
	SetMemoryPoolSize("SoundSpaceRegion", 64)
	SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\INI.lvl", "INI_conquest")
	SetDenseEnvironment("false")
	
	
	-- Sound
	
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_INI_Streaming.lvl",  "INI_ambiance")
	
	manager:Proc_ScriptInit_MusicSetup()
	
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