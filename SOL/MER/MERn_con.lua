ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
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
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "conquest",				-- The mission's game mode.
	mapSize = "sm",						-- Size of the map. Used for determining unit counts.
	environmentType = "urban",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "4",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "2",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	
	-- Online matches
	onlineSideVar = "SSVxGTH",			-- Faction combination to use in online matches.
	onlineHeroSSV = "shep_engineer",	-- SSV hero to use in online matches.
	onlineHeroGTH = "gethprime_me2",	-- GTH hero to use in online matches.
	onlineHeroCOL = "colgeneral",		-- COL hero to use in online matches.
	onlineHeroEVG = "gethprime_me3",	-- EVG hero to use in online matches.
	
	-- AI hero spawns (required). CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
	},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
	},
}
-- Initialize the MapManager
manager:Init()

REP = 2
CIS = 1

HuskTeam = 3

ATT = 1
DEF = 2


function ScriptPostLoad()
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    
    
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
    conquest:AddCommandPost(cp5)      
    
    conquest:Start()

    EnableSPHeroRules()

	SetClassProperty("ven_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("ven_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("ven_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("ven_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")

	SetObjectTeam("tur_bldg_chaingun_roof", CIS)
	SetObjectTeam("tur_bldg_chaingun_roof1", CIS)
	SetObjectTeam("tur_bldg_chaingun_roof2", REP)
	SetObjectTeam("tur_bldg_chaingun_roof3", REP)

	OnFinishCaptureName(
		function(post, holding)
			SetObjectTeam("tur_bldg_chaingun_roof", GetObjectTeam(post))
			SetObjectTeam("tur_bldg_chaingun_roof1", GetObjectTeam(post))
		end,
		"cp1"
	)

	OnFinishCaptureName(
		function(post, holding)
			SetObjectTeam("tur_bldg_chaingun_roof2", GetObjectTeam(post))
			SetObjectTeam("tur_bldg_chaingun_roof3", GetObjectTeam(post))
		end,
		"cp5"
	)
	
	-- Perform various post-load operations
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
    ReadDataFile("dc:Load\\load.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2563)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1509)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1658)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()

	AISnipeSuitabilityDist(60)
	SetAttackerSnipeRange(60)
	SetDefenderSnipeRange(110)
	
	SetMaxFlyHeight(50)
	SetMaxPlayerFlyHeight(50)
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	ReadDataFile("dc:SIDE\\sol.lvl",
					"sol_inf_astronaut")

	SetTeamName(4, "nasa")
	AddUnitClass(4, "sol_inf_astronaut", 4,4)
	SetUnitCount(4, 4)
	AddAIGoal(4, "Deathmatch", 100)
	
	SetTeamAsNeutral(ATT,4)
	SetTeamAsNeutral(4,ATT)
	SetTeamAsNeutral(DEF,4)
	SetTeamAsNeutral(4,DEF)
	SetTeamAsNeutral(HuskTeam,4)
	SetTeamAsNeutral(4,HuskTeam)

	ReadDataFile("dc:SIDE\\tur.lvl",
					"tur_bldg_chaingun_roof")
	
	ReadDataFile("dc:sound\\MER.lvl;MERcw")
	

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
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("RedOmniLight", 193)
    SetMemoryPoolSize("SoldierAnimation", 410)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:SOL\\MER.lvl", "MER_conquest")
    SetDenseEnvironment("false")
	
	-- ReadDataFile("dc:minimap.lvl;ven")
	
	
	--  Sound Stats
	
	-- Set up music
	if ME5_SolMapMusic == 0 then
		--ScriptCB_EnableHeroMusic(0)
		
		OpenAudioStream("dc:sound\\sol.lvl", "SOLgcw_music")
		OpenMusicStreams(1)

		SetAmbientMusic(REP, 1.0, "MER_amb_earworm",  0,1)
		SetAmbientMusic(CIS, 1.0, "MER_amb_earworm",  0,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
		
	elseif ME5_SolMapMusic == 1 then
		manager:Proc_ScriptInit_MusicSetup()
	end
	
	OpenAudioStream("dc:sound\\MER.lvl",  "MER_ambiance")
	OpenAudioStream("dc:sound\\MER.lvl",  "MER_ambiance")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)

    -- Camera Stats
	AddCameraShot(0.860834, -0.066550, -0.503015, -0.038887, -156.444336, 26.008068, 375.989807);
	AddCameraShot(0.415989, -0.029820, -0.906554, -0.064987, -121.549095, 26.008068, 223.142822);
	AddCameraShot(-0.327677, 0.024227, -0.941908, -0.069639, 57.638302, 32.931034, 172.352127);
	AddCameraShot(0.771404, -0.020699, -0.635780, -0.017060, -86.801491, 13.656008, 306.767334);
	AddCameraShot(0.789378, -0.064580, 0.608469, 0.049779, 18.768763, 13.656008, 316.177277);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
	
end
