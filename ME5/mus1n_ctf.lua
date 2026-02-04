ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "ctf",
	mapSize = "med",
	environmentType = "urban",
	
	-- In-game music
	musicVariation_SSVxGTH = {"4","6"},
	musicVariation_SSVxCOL = "2",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "8",
	
	-- Online matches
	onlineSideVar = "EVGxCOL",
	onlineHeroSSV = "shep_engineer",
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

--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
     PlayAnimRise()
    UnblockPlanningGraphArcs("Connection74")
        DisableBarriers("1")
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
     
    OnObjectRespawnName(PlayAnimRise, "DingDong");
    OnObjectKillName(PlayAnimDrop, "DingDong");
 --Capture the Flag for stand-alone multiplayer
                -- These set the flags geometry names.
                --GeometryName sets the geometry when hte flag is on the ground
                --CarriedGeometryName sets the geometry that appears over a player's head that is carrying the flag
        SetProperty("FLAG1", "GeometryName", "com_icon_republic_flag")
        SetProperty("FLAG1", "CarriedGeometryName", "com_icon_republic_flag_carried")
        SetProperty("FLAG2", "GeometryName", "com_icon_cis_flag")
        SetProperty("FLAG2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
        SetClassProperty("com_item_flag", "DroppedColorize", 1)
    SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,  textATT = "game.modes.ctf", textDEF = "game.modes.ctf2",  multiplayerRules = true}
    ctf:AddFlag{name = "FLAG1", homeRegion = "FLAG1_HOME", captureRegion = "FLAG2_HOME",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "home2"}
    ctf:AddFlag{name = "FLAG2", homeRegion = "FLAG2_HOME", captureRegion = "FLAG1_HOME",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "Home"}
    ctf:Start()
    EnableSPHeroRules()
    
	manager:Proc_ScriptPostLoad_End()
	
end
-- START BRIDGEWORK!

-- OPEN
function PlayAnimDrop()
      PauseAnimation("lava_bridge_raise");    
      RewindAnimation("lava_bridge_drop");
      PlayAnimation("lava_bridge_drop");
        
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection82");
    BlockPlanningGraphArcs("Connection83");
    EnableBarriers("Bridge");
    
end
-- CLOSE
function PlayAnimRise()
      PauseAnimation("lava_bridge_drop");
      RewindAnimation("lava_bridge_raise");
      PlayAnimation("lava_bridge_raise");
            

        -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection82");
    UnblockPlanningGraphArcs("Connection83");
    DisableBarriers("Bridge");
end


function ScriptInit()
	-- Designers, these two lines *MUST* be first!
    StealArtistHeap(2048*2048)
	SetPS2ModelMemory(3600000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;mus1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2608)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1528)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1684)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_MUS_Streaming.lvl;mus1n")
	
    
    ClearWalkers()
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", 220)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 160)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 164)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("Music", 92)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", 40)
    SetMemoryPoolSize("PathNode", 200)
    SetMemoryPoolSize("SoldierAnimation", 368)
    SetMemoryPoolSize("TreeGridStack", 400)
    SetMemoryPoolSize("UnitAgent", 40)
    SetMemoryPoolSize("UnitController", 40)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    --AddDeathRegion("Sarlac01")
    
    SetMaxFlyHeight(84.16)
	SetMaxPlayerFlyHeight(90)
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
    
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\mus1.lvl", "MUS1_CTF")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;mus1")
     
    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_MUS_Streaming.lvl",  "mus1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_MUS_Streaming.lvl",  "mus1")
	
	SoundFX()


   	AddCameraShot(0.446393, -0.064402, -0.883371, -0.127445, -93.406929, 72.953865, -35.479401);
	
	AddCameraShot(-0.297655, 0.057972, -0.935337, -0.182169, -2.384067, 71.165306, 18.453350);
	
	AddCameraShot(0.972488, -0.098362, 0.210097, 0.021250, -42.577881, 69.453072, 4.454691);
	
	AddCameraShot(0.951592, -0.190766, -0.236300, -0.047371, -44.607018, 77.906273, 113.228661);
	
	AddCameraShot(0.841151, -0.105984, 0.526154, 0.066295, 109.567764, 77.906273, 7.873035);
	
	AddCameraShot(0.818472, -0.025863, 0.573678, 0.018127, 125.781593, 61.423031, 9.809184);
	
	AddCameraShot(-0.104764, 0.000163, -0.994496, -0.001550, -13.319855, 70.673264, 63.436607);
	
	AddCameraShot(0.971739, 0.102058, 0.211692, -0.022233, -5.680069, 68.543945, 57.904160);
	
	AddCameraShot(0.178437, 0.004624, -0.983610, 0.025488, -66.947433, 68.543945, 6.745875);

    AddCameraShot(-0.400665, 0.076364, -0896894, -0.170941, 96.201210, 79.913033, -58.604382)
	
	manager:Proc_ScriptInit_End()
end
