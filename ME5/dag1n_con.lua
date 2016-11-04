ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = "med"
EnvironmentType = "jungle"
onlineSideVar = "SSVxGTH"
onlineHeroSSV = "shep_infiltrator"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp3", "cp3_spawn"},
			{"cp4", "cp4_spawn"},
			{"cp5", "cp5_spawn"},
			{"cp6", "cp6_spawn"},
}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp3", "cp3_spawn"},
			{"cp4", "cp4_spawn"},
			{"cp5", "cp5_spawn"},
			{"cp6", "cp6_spawn"},
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

	EnableSPHeroRules()
    
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("conquest", heroSupportCPs)
	
end
 
function ScriptInit()
    StealArtistHeap(256*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(2497152 + 65536 * 0)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;dag1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2190)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1413)
	
    PreLoadStuff()
    
	SetMaxFlyHeight(20)
	SetMaxPlayerFlyHeight(20)
	AISnipeSuitabilityDist(40)
	SetAttackerSnipeRange(50)
	SetDefenderSnipeRange(100)
	
	
    Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DAG_Streaming.lvl;dag1n")
	
    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    --  AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
    --  AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --  AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 203
    SetMemoryPoolSize("Aimer", 9)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 1)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 10)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 219)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("SoldierAnimation", 402)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 200)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\dag1.lvl", "dag1_conquest", "dag1_cw") -- *****
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;dag1")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.35)
    --AddDeathRegion("deathregion")
    --SetStayInTurrets(1)

    --  Sound
    
	
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Music01()
		elseif ME5_SideVar == 2 then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music01()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_DAG_Streaming.lvl",   "dag1")
	
	SoundFX()
	
    --  Camera Stats
    AddCameraShot(0.953415, -0.062787, 0.294418, 0.019389, 20.468771, 3.780040, -110.412453);
    AddCameraShot(0.646125, -0.080365, 0.753185, 0.093682, 41.348438, 5.688061, -52.695042);
    AddCameraShot(-0.442911, 0.055229, -0.887986, -0.110728, 39.894440, 9.234127, -59.177147);
    AddCameraShot(-0.038618, 0.006041, -0.987228, -0.154444, 28.671711, 10.001163, 128.892181);
	
	PostLoadStuff()
end
