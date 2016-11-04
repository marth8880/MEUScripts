ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = "med"
EnvironmentType = "urban"
onlineSideVar = "EVGxCOL"
onlineHeroSSV = "shep_engineer"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {
			{"cp1", "cp1spawn"},
			{"cp2", "cp2spawn"},
			{"cp3", "cp3spawn"},
			{"cp4", "cp4spawn"},
			{"cp5", "cp5spawn"},
			{"cp6", "path37"},
}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {
			{"cp1", "cp1spawn"},
			{"cp2", "cp2spawn"},
			{"cp3", "cp3spawn"},
			{"cp4", "cp4spawn"},
			{"cp5", "cp5spawn"},
			{"cp6", "path37"},
}

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
    UnblockPlanningGraphArcs("Connection74")
        DisableBarriers("1")
        --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
 
     PlayAnimRise()
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
     
    OnObjectRespawnName(PlayAnimRise, "DingDong");
    OnObjectKillName(PlayAnimDrop, "DingDong");
    EnableSPHeroRules()
    
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("conquest", heroSupportCPs)
	
 end
 --START BRIDGEWORK!

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
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	
    --SetTeamAggressiveness(REP, 0.95)
    --SetTeamAggressiveness(CIS, 0.95)
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
	
	SetMemoryPoolSize("Combo",4)              -- should be ~ 2x number of jedi classes
	SetMemoryPoolSize("Combo::State",48)      -- should be ~12x #Combo
	SetMemoryPoolSize("Combo::Transition",54) -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Combo::Condition",54)  -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Combo::Attack",48)     -- should be ~8-12x #Combo
	SetMemoryPoolSize("Combo::DamageSample",580)  -- should be ~8-12x #Combo::Attack
	SetMemoryPoolSize("Combo::Deflect",4)     -- should be ~1x #combo
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_MUS_Streaming.lvl;mus1n")

    --  Level Stats
    ClearWalkers()
    local unitCnt = 64
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", weaponCnt)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 160)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 164)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 32)
    SetMemoryPoolSize("Music", 92)
    SetMemoryPoolSize("Navigator", unitCnt)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", unitCnt)
    SetMemoryPoolSize("PathNode", 200)
    SetMemoryPoolSize("SoldierAnimation", 368)
    SetMemoryPoolSize("TreeGridStack", 400)
    SetMemoryPoolSize("UnitAgent", unitCnt)
    SetMemoryPoolSize("UnitController", unitCnt)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\mus1.lvl", "MUS1_CONQUEST")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;mus1")

    SetDenseEnvironment("false")
    --AddDeathRegion("Sarlac01")
        SetMaxFlyHeight(90)
SetMaxPlayerFlyHeight(90)


    --  Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Music06()
		elseif ME5_SideVar == 2 then
			Music02()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music09()
	end
	
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
	
	PostLoadStuff()
end