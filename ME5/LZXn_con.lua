ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")

isModMap = 1

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")

-- 
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved. 
-- 

-- load the gametype script 
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = lg
EnvironmentType = EnvTypeSnow
onlineSideVar = SSVxGTH
onlineHeroSSV = shep_infiltrator
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp3", "cp3_spawn"},
			{"cp4", "cp4_spawn"},
			{"cp5", "cp5_spawn"},
			{"cp6", "cp6_spawn"},
			{"cp7", "cp7_spawn"},
			{"cp8", "cp8_spawn"},
}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp3", "cp3_spawn"},
			{"cp4", "cp4_spawn"},
			{"cp5", "cp5_spawn"},
			{"cp6", "cp6_spawn"},
			{"cp7", "cp7_spawn"},
			{"cp8", "cp8_spawn"},
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

function ScriptPostLoad()
	
    --This defines the CPs.  These need to happen first 
    cp1 = CommandPost:New{name = "cp1"} 
    cp2 = CommandPost:New{name = "cp2"} 
    cp3 = CommandPost:New{name = "cp3"} 
    cp4 = CommandPost:New{name = "cp4"} 
    cp5 = CommandPost:New{name = "cp5"} 
    cp6 = CommandPost:New{name = "cp6"} 
    cp7 = CommandPost:New{name = "cp7"} 
    cp8 = CommandPost:New{name = "cp8"} 
	
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
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
	
    conquest:Start()
	
    EnableSPHeroRules()

	SetProperty("cp1", "HUDIndex", 7)	-- 7
	SetProperty("cp2", "HUDIndex", 1)	-- 1
	SetProperty("cp3", "HUDIndex", 5)	-- 4
	SetProperty("cp4", "HUDIndex", 3)	-- 6
	SetProperty("cp5", "HUDIndex", 6)	-- 5
	SetProperty("cp6", "HUDIndex", 2)	-- 2
	SetProperty("cp7", "HUDIndex", 8)	-- 8
	SetProperty("cp8", "HUDIndex", 4)	-- 3
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Conquest", 100)
	AddAIGoal(2, "Conquest", 100)
    
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("conquest", heroSupportCPs)
	
	CP1Node = GetPathPoint("cp1_spawn", 0) --gets the path point
	CP2Node = GetPathPoint("cp2_spawn", 0)
	CP3Node = GetPathPoint("cp3_spawn", 0)
	CP4Node = GetPathPoint("cp4_spawn", 0)
	CP5Node = GetPathPoint("cp5_spawn", 0)
	CP6Node = GetPathPoint("cp6_spawn", 0)
	CP7Node = GetPathPoint("cp7_spawn", 0)
	CP8Node = GetPathPoint("cp8_spawn", 0)
	
	--[[CreateTimer("artGameTimer")
	SetTimerValue("artGameTimer", 720)
	StartTimer("artGameTimer")
	OnTimerElapse(
		function(timer)]]
			--local team1pts = GetReinforcementCount(1)
			--if team1pts >= 100 then
				artMatrices = { CP1Node, CP2Node, CP3Node, CP4Node, CP5Node, CP6Node, CP7Node, CP8Node }
				goingthroughturrets = 0
				
				artInitTimer = CreateTimer("artInitTimer")
				SetTimerValue("artInitTimer", 20.0)
				StartTimer("artInitTimer")
				--ShowTimer("artInitTimer")
				OnTimerElapse(
					function(timer)
						goingthroughturrets = goingthroughturrets + 1
						if goingthroughturrets == 9 then
							goingthroughturrets = 1
						end
						
						SetEntityMatrix( "artillery1", artMatrices[goingthroughturrets])
						--ShowMessageText("level.common.events.surv.artillery.msg"..goingthroughturrets)
							print("hot1n_surv: Artillery transitioning to matrix: "..goingthroughturrets)					
						SetTimerValue("artInitTimer", 20.0)
						StartTimer("artInitTimer")
					end,
				"artInitTimer"
				)
			--else
			--end
			
			--[[DestroyTimer(Timer)
		end,
	"artGameTimer"
	)]]
	
	AddDeathRegion("deathregion")
	
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

   --tell the game to load our loading image 
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\lzx.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2399)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1403)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1547)
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_snow.lvl")
	
    SetMaxFlyHeight(96)
    SetMaxPlayerFlyHeight(96)
	AISnipeSuitabilityDist(165)
	SetAttackerSnipeRange(130)
	SetDefenderSnipeRange(200)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser",
					"tur_bldg_hoth_dishturret")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LZX_Streaming.lvl")

    --  Level Stats 
    ClearWalkers()
    local weaponCnt = 1024 
	SetMemoryPoolSize("Aimer", 75) 
	SetMemoryPoolSize("AmmoCounter", weaponCnt) 
	SetMemoryPoolSize("BaseHint", 1024) 
	SetMemoryPoolSize("EnergyBar", weaponCnt) 
	SetMemoryPoolSize("EntityCloth", 0) 
	SetMemoryPoolSize("EntityFlyer", 0) 
	SetMemoryPoolSize("EntityHover", 32) 
	SetMemoryPoolSize("EntityLight", 200) 
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FlagItem", 512)	-- do not alter
	SetMemoryPoolSize("MountedTurret", 32) 
	SetMemoryPoolSize("Music", 99)
	SetMemoryPoolSize("Navigator", 128) 
	SetMemoryPoolSize("Obstacle", 1024) 
	SetMemoryPoolSize("RedOmniLight", 239) 
	SetMemoryPoolSize("PathNode", 1024) 
	SetMemoryPoolSize("SoldierAnimation", 382)
	SetMemoryPoolSize("SoundSpaceRegion", 64) 
	SetMemoryPoolSize("TreeGridStack", 1024) 
	SetMemoryPoolSize("UnitAgent", 128) 
	SetMemoryPoolSize("UnitController", 128) 
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\LZX\\data\\_LVL_PC\\LZX\\LZX.lvl", "LZX_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\LZX_AMB.lvl")	-- loads the soundstream region and the minimap
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery.lvl")
	SetDenseEnvironment("false")
	
	
	--  Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Music03()
		elseif ME5_SideVar == 2 then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music03()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LZX_Streaming.lvl",  "LZX_ambiance")
	
	SoundFX()

--OpeningSateliteShot 
   AddCameraShot(-0.276930, -0.006705, -0.960585, 0.023256, 91.842682, 14.668467, 84.243149); 
   AddCameraShot(0.811569, -0.051904, 0.580760, 0.037143, 130.966812, 14.082601, 34.935509); 
   AddCameraShot(0.284131, -0.009807, -0.958165, -0.033073, -39.626015, 14.090186, 117.456718); 
   AddCameraShot(0.661070, -0.102405, -0.734542, -0.113787, 96.750153, 23.179926, 146.376358); 
   AddCameraShot(0.977186, -0.004879, -0.212328, -0.001060, -81.759819, 5.994357, 69.543793); 
	
	PostLoadStuff()
end 
