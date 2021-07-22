ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,
	gameMode = "ctf",
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
	REP = 1
	CIS = 2
end

HuskTeam = 3

ATT = 1
DEF = 2

function ScriptPostLoad()

	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
		print("start ctf objective")
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "ctf_team1_capture", captureRegion = "ctf_team2_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "ctf_team2_capture"}
    ctf:AddFlag{name = "flag2", homeRegion = "ctf_team2_capture", captureRegion = "ctf_team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "ctf_team1_capture"}
		print("end ctf objective")
	ctf:Start()
	
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
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
					
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl")
	
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 240
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityFlyer", 7)
    SetMemoryPoolSize("EntityHover", 8)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 16)
    SetMemoryPoolSize("EntitySoundStatic", 20)
	SetMemoryPoolSize("Navigator", 49)
    SetMemoryPoolSize("Obstacle", 760)
	SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("SoundSpaceRegion", 46)
    SetMemoryPoolSize("TreeGridStack", 500)
	SetMemoryPoolSize("UnitAgent", 49)
	SetMemoryPoolSize("UnitController", 49)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\PRO.lvl", "PRO_ctf")
    SetDenseEnvironment("false")
	
	
    --  Sound
    
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_PRO_Streaming.lvl",  "PRO_ambiance")

    SoundFX()


-- Opening Satellite Shots
	AddCameraShot(-0.489337, 0.030371, -0.869892, -0.053990, 22.389414, 3.153875, -52.420540);		-- center objective
	AddCameraShot(-0.359212, 0.004421, -0.933175, -0.011485, 20.875534, 2.910979, -158.157776);		-- south garage
	AddCameraShot(0.987578, -0.029607, 0.154247, 0.004624, 14.952700, 2.910979, 63.121727);			-- north garage
	AddCameraShot(0.012174, -0.002110, -0.985229, -0.170794, -2.479260, 10.699486, -125.009254);	-- south overlook
	AddCameraShot(0.990913, -0.134439, 0.004056, 0.000550, -2.734958, 10.699486, 30.288927);		-- north overlook
	
	manager:Proc_ScriptInit_End()
end
