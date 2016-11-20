ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")				-- MEU's master include file, which is vital to make things work
ScriptCB_DoFile("ME5_setup_teams")			-- MEU's version of setup_teams.lua, also vital
ScriptCB_DoFile("ME5_ObjectiveConquest")	-- MEU's ObjectiveConquest script

-- Map-specific data fields
mapSize = "sm"						-- Size of the map. Used for determining unit counts.
EnvironmentType = "jungle"			-- Map's biome (essentially). Used for determining which camo textures to load.
onlineSideVar = "SSVxGTH"			-- Side variation to use in online matches.
onlineHeroSSV = "shep_engineer"		-- SSV hero to use in online matches.
onlineHeroGTH = "gethprime_me2"		-- GTH hero to use in online matches.
onlineHeroCOL = "colgeneral"		-- COL hero to use in online matches.
onlineHeroEVG = "gethprime_me3"		-- EVG hero to use in online matches.

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp3", "cp3_spawn"},
			{"cp4", "cp4_spawn"},
}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp3", "cp3_spawn"},
			{"cp4", "cp4_spawn"},
}

-- Randomize the teams' starting spawns
if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 1
	CIS = 2
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
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("conquest", heroSupportCPs)
	
end


---------------------------------------------------------------------------
-- FUNCTION:	ScriptInit
-- PURPOSE:	 This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:	   The name, 'ScriptInit' is a chosen convention, and each
--			  mission script must contain a version of this function, as
--			  it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
	-- Load our loadscreen
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\example.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2367)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1380)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1533)
	
	-- Perform various pre-game operations
	PreLoadStuff()
	
	SetMaxFlyHeight(30)
	SetMaxPlayerFlyHeight(30)
	
	AISnipeSuitabilityDist(60)
	SetAttackerSnipeRange(90)
	SetDefenderSnipeRange(150)
	
	-- Load the turrets
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	-- Load and set up the sides based on RandomSide
	Init_SideSetup()
	
	-- Load our map-specific sound lvl
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EXAMPLE_Streaming.lvl")
	
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
	SetMemoryPoolSize("FlagItem", 512)				-- Need to account for shield pickups
	SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
	SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 417)
	SetMemoryPoolSize("SoundSpaceRegion", 64)
	SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EXAMPLE.lvl", "EXAMPLE_conquest")
	SetDenseEnvironment("false")
	
	
	--  Sound Stats
	
	-- Open our map-specific ambient sound streams
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_EXAMPLE_Streaming.lvl",  "EXAMPLE_ambiance")

	-- Set up music stuff
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Music06()
		elseif ME5_SideVar == 2	then
			Music02()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music06()
	end
	
	-- Set up common sound stuff
	SoundFX()
	
	-- Camera Stats
	AddCameraShot(-0.370814, 0.035046, -0.923929, -0.087320, -71.966255, 23.668301, 27.930090);
	AddCameraShot(0.991073, 0.002392, 0.133299, -0.000322, 84.069084, 23.668301, -95.802574);
	
	-- Perform various post-load operations
	PostLoadStuff()
end
