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
	mapSize = "xs",
	environmentType = "urban",
	
	-- In-game music
	musicVariation_SSVxGTH = "3_vrm",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
	onlineHeroSSV = "shep_vanguard",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1con_spawn"},
				{"cp2", "cp2con_spawn"},
				{"cp3", "cp3con_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1con_spawn"},
				{"cp2", "cp2con_spawn"},
				{"cp3", "cp3con_spawn"},
	},
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
    
function ScriptPostLoad()
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", textDEF = "game.modes.con2", 
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    
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
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\pro.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	manager:Proc_ScriptInit_Begin()
   
    SetMaxFlyHeight(16)
    SetMaxPlayerFlyHeight(16)
	AISnipeSuitabilityDist(55)
	SetAttackerSnipeRange(75)
	SetDefenderSnipeRange(100)
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl")

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
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 16)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 87)
    SetMemoryPoolSize("Music", 89)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 474)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\PRO.lvl", "PRO_conquest")
    SetDenseEnvironment("false")
	
	
	--  Sound Stats
    
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")

	SoundFX()
	
	-- Opening Satellite Shots
	AddCameraShot(0.978525, -0.037464, 0.202548, 0.007755, 25.577356, 5.990258, -14.311792);		-- south corner
	AddCameraShot(-0.227115, 0.008059, -0.973222, -0.034536, 26.382149, 5.990258, -122.364380);		-- north corner
	-- AddCameraShot(0.013350, -0.001503, -0.993636, -0.111838, -7.550848, 2.605920, -82.578865);		-- bunker
	AddCameraShot(0.459203, 0.042688, -0.883496, 0.082130, -19.666098, 7.762414, -125.828354);		-- towers wide
	AddCameraShot(-0.428738, -0.031436, -0.900465, 0.066023, 20.310499, 2.323809, -157.813171);		-- skyway tower interior

	manager:Proc_ScriptInit_End()
end
