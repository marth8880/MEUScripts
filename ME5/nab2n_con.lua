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
	mapSize = "med",
	environmentType = "urban",
	
	-- In-game music
	musicVariation_SSVxGTH = "4",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = {"8", "5_mahavid"},
	
	-- Online matches
	onlineSideVar = "SSVxRPR",
	onlineHeroSSV = "shep_soldier",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- Local ally spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1spawn"},
				{"cp2", "cp2spawn"},
				{"cp3", "cp3spawn"},
				{"cp4", "cp4spawn"},
				{"cp5", "cp5spawn"},
				{"cp6", "cp6spawn"},
	},
	-- AI hero spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1spawn"},
				{"cp2", "cp2spawn"},
				{"cp3", "cp3spawn"},
				{"cp4", "cp4spawn"},
				{"cp5", "cp5spawn"},
				{"cp6", "cp6spawn"},
	},
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"cp1spawn", 0},
				{"cp2spawn", 0},
				{"cp3spawn", 0},
				{"cp4spawn", 0},
				{"cp5spawn", 0},
				{"cp6spawn", 0},
	},
	terrainType = "dirt",
}
-- Initialize the MapManager
manager:Init()

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
	DisableBarriers("cambar1")
	DisableBarriers("cambar2")
	DisableBarriers("cambar3")
	DisableBarriers("turbar1")
	DisableBarriers("turbar2")
	DisableBarriers("turbar3")
	DisableBarriers("camveh")
    SetMapNorthAngle(180, 1)
    
    EnableSPHeroRules()
   
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "CP1"}
    cp2 = CommandPost:New{name = "CP2"}
    cp3 = CommandPost:New{name = "CP3"}
    cp4 = CommandPost:New{name = "CP4"}
    cp5 = CommandPost:New{name = "CP5"}
    cp6 = CommandPost:New{name = "CP6"}
    
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
    
	manager:Proc_ScriptPostLoad_End()
	
	KillObject("GuardCP")
	
end

function ScriptInit()
    StealArtistHeap(1200*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3100000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;nab2")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2619)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1547)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1730)
	
	manager:Proc_ScriptInit_Begin()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl", 
					"tur_bldg_laser")
				
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_NAB_Streaming.lvl;nab2n")


    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas with 0 leg pairs each
    AddWalkerType(1, 0) -- ATSTs
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 128)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntitySoundStatic", 44)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("Music", 92)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 552)
    SetMemoryPoolSize("PathFollower", 40)
    SetMemoryPoolSize("PathNode", 200)
    SetMemoryPoolSize("SoldierAnimation", 368)
    SetMemoryPoolSize("TreeGridStack", 400)
    SetMemoryPoolSize("UnitAgent", 40)
    SetMemoryPoolSize("UnitController", 40)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\nab2.lvl","naboo2_Conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;nab2")
    SetDenseEnvironment("true")
    --AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight(25)
	AISnipeSuitabilityDist(75)
	SetAttackerSnipeRange(90)
	SetDefenderSnipeRange(120)

    

    --  Sound
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_NAB_Streaming.lvl",  "nab2")
	
	SoundFX()
	
	
    --  Camera Stats
    --Nab2 Theed
    --Palace
    AddCameraShot(0.038177, -0.005598, -0.988683, -0.144973, -0.985535, 18.617458, -123.316505);
    AddCameraShot(0.993106, -0.109389, 0.041873, 0.004612, 6.576932, 24.040697, -25.576218);
    AddCameraShot(0.851509, -0.170480, 0.486202, 0.097342, 158.767715, 22.913860, -0.438658);
    AddCameraShot(0.957371, -0.129655, -0.255793, -0.034641, 136.933548, 20.207420, 99.608246);
    AddCameraShot(0.930364, -0.206197, 0.295979, 0.065598, 102.191856, 22.665434, 92.389435);
    AddCameraShot(0.997665, -0.068271, 0.002086, 0.000143, 88.042351, 13.869274, 93.643898);
    AddCameraShot(0.968900, -0.100622, 0.224862, 0.023352, 4.245263, 13.869274, 97.208542);
    AddCameraShot(0.007091, -0.000363, -0.998669, -0.051089, -1.309990, 16.247049, 15.925866);
    AddCameraShot(-0.274816, 0.042768, -0.949121, -0.147705, -55.505108, 25.990822, 86.987534);
    AddCameraShot(0.859651, -0.229225, 0.441156, 0.117634, -62.493008, 31.040747, 117.995369);
    AddCameraShot(0.703838, -0.055939, 0.705928, 0.056106, -120.401054, 23.573559, -15.484946);
    AddCameraShot(0.835474, -0.181318, -0.506954, -0.110021, -166.314774, 27.687098, -6.715797);
    AddCameraShot(0.327573, -0.024828, -0.941798, -0.071382, -109.700180, 15.415476, -84.413605);
    AddCameraShot(-0.400505, 0.030208, -0.913203, -0.068878, 82.372711, 15.415476, -42.439548);
	
	manager:Proc_ScriptInit_End()
    
end
