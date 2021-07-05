ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "conquest",
	mapSize = "lg",
	environmentType = "desert",
	
	-- In-game music
	musicVariation_SSVxGTH = "3",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = {"8", "5_mahavid"},
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_soldier",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
				{"cp8", "cp8_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
				{"cp8", "cp8_spawn"},
	},
	
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"cp1_spawn", 0},
				{"cp2_spawn", 0},
				{"cp3_spawn", 0},
				{"cp4_spawn", 0},
				{"cp6_spawn", 0},
				{"cp7_spawn", 0},
				{"cp8_spawn", 0},
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
	REP = 1
	CIS = 2
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

function ScriptPostLoad()
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    cp8 = CommandPost:New{name = "cp8"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.conquest", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    
    conquest:Start()
    
    EnableSPHeroRules()
    
    AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    AddDeathRegion("deathregion3")
    AddDeathRegion("deathregion4")
    AddDeathRegion("deathregion5")
    
	manager:Proc_ScriptPostLoad_End()
    
end
 
function ScriptInit()
    StealArtistHeap(800*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3500000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;geo1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2248)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1341)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1492)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_GEO_Streaming.lvl;geo1n")
	
    --  Level Stats

    ClearWalkers()
    -- SetMemoryPoolSize("EntityWalker", -1)
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponcnt = 240
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponcnt)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("CommandWalker", 1)		-- TODO: probably remove this tbh
    SetMemoryPoolSize("EnergyBar", weaponcnt)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityHover", 16)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 12)
	SetMemoryPoolSize("Music", 78)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 100)
	SetMemoryPoolSize("SoldierAnimation", 371)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponcnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)

    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\geo1.lvl", "geo1_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;geo1")

    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(120)
	
	
	
    --  Sound
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_GEO_Streaming.lvl",  "geo1")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_GEO_Streaming.lvl",  "geo1")
	
	SoundFX()


    --ActivateBonus(CIS, "SNEAK_ATTACK")
    --ActivateBonus(REP, "SNEAK_ATTACK")

    SetAttackingTeam(ATT)

    --Opening Satalite Shot
    --Geo
    --Mountain
    AddCameraShot(0.996091, 0.085528, -0.022005, 0.001889, -6.942698, -59.197201, 26.136919)
    --Wrecked Ship
    AddCameraShot(0.906778, 0.081875, -0.411906, 0.037192, 26.373968, -59.937874, 122.553581)
    --War Room  
    --AddCameraShot(0.994219, 0.074374, 0.077228, -0.005777, 90.939568, -49.293945, -69.571136)
	
	manager:Proc_ScriptInit_End()
end

