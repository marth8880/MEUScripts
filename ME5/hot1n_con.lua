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
	environmentType = "snow",
	
	-- In-game music
	musicVariation_SSVxGTH = "3_nov",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "5_mahavid",
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
	onlineHeroSSV = "shep_adept",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"CP3", "CP3_SpawnPath"},
				{"CP4", "CP4_SpawnPath"},
				{"CP5", "CP5_SpawnPath"},
				{"CP6", "CP6_SpawnPath"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"CP3", "CP3_SpawnPath"},
				{"CP4", "CP4_SpawnPath"},
				{"CP5", "CP5_SpawnPath"},
				{"CP6", "CP6_SpawnPath"},
	},
	
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"CP3_SpawnPath", 9},
				{"CP4_SpawnPath", 0},
				--{"CP5_SpawnPath", 1},
				{"CP6_SpawnPath", 3},
				{"artilleryNodes", 0},
	},
	terrainType = "snow",
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

function ScriptPostLoad()

	AddDeathRegion("fall")
	DisableBarriers("atat")
	DisableBarriers("bombbar")

    --CP SETUP for CONQUEST
--    SetProperty("shield", "MaxHealth", 222600.0)
--  	SetProperty("shield", "CurHealth", 222600.0)
    SetObjectTeam("CP3", 1)
    SetObjectTeam("CP6", 1)
    KillObject("CP7")
 
    EnableSPHeroRules()
    
    cp1 = CommandPost:New{name = "CP3"}
    cp2 = CommandPost:New{name = "CP4"}
    cp3 = CommandPost:New{name = "CP5"}
    cp4 = CommandPost:New{name = "CP6"}
--    cp5 = CommandPost:New{name = "CP7"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
--    conquest:AddCommandPost(cp5)
    
    conquest:Start()
	
	manager:Proc_ScriptPostLoad_End()
	
end

function ScriptInit()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;hot1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2540)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1305)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1665)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")

    --SetAttackingTeam(ATT)


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    SetGroundFlyerMap(1);
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_hoth_dishturret",
					"tur_bldg_hoth_lasermortar")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl;hot1n")
	
	
	--  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 0) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 0) -- 2 atats with 2 leg pairs each

	local weaponCnt = 250
    SetMemoryPoolSize("Aimer", 80)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 175)
    SetMemoryPoolSize("CommandWalker", 0)		-- TODO: probably remove this tbh
    SetMemoryPoolSize("ConnectivityGraphFollower", 56)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityHover", 15) --11
    SetMemoryPoolSize("EntityFlyer", 10)
    SetMemoryPoolSize("EntityLight", 110)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("EntitySoundStream", 12)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("Music", 78)
    SetMemoryPoolSize("Navigator", 63)
    SetMemoryPoolSize("Obstacle", 479)
	--SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoldierAnimation", 433)
    SetMemoryPoolSize("TreeGridStack", 349)
    SetMemoryPoolSize("UnitController", 63)
    SetMemoryPoolSize("UnitAgent", 63)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\hot1.lvl", "hoth_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;hot1")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    
	AISnipeSuitabilityDist(110)
	SetAttackerSnipeRange(130)
	SetDefenderSnipeRange(190)
    AddDeathRegion("Death")


    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl",  "hot1")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl",  "hot1")
	
	SoundFX()
	ScaleSoundParameter("ambientenv",	"Gain", 0.75)


    --  Camera Stats
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Battlefield
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)
    
	manager:Proc_ScriptInit_End()
end
