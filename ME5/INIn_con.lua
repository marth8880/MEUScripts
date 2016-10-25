ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,2)

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = sm
EnvironmentType = EnvTypeDesert
onlineSideVar = SSVxGTH
onlineHeroSSV = shep_infiltrator
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
	
	--  REP Attacking (attacker is always #1)
	REP = 2;
	CIS = 1;
	ColHuskTeam = 3;
	--  These variables do not change
	ATT = 1;
	DEF = 2;
	
	
function SSVxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end

	SetProperty("cp1", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp1", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp2", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp3", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp4", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp1", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp1", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp2", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp3", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp4", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)

	SetProperty("cp1", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp2", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp3", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp4", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp1", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp2", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp3", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp4", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp1", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp2", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp3", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp4", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp1", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp2", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp3", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp4", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")

			herosupport:Start()
		end
	end

	SetProperty("cp1", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp1", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp2", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp3", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp4", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)

	SetProperty("cp1", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp1", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp2", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp3", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp4", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
end


function ScriptPostLoad()	   


	--This defines the CPs.  These need to happen first
	cp1 = CommandPost:New{name = "cp1"}
	cp2 = CommandPost:New{name = "cp2"}
	cp3 = CommandPost:New{name = "cp3"}
	cp4 = CommandPost:New{name = "cp4"}
	
	
	
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
	
	conquest:Start()
	
	EnableSPHeroRules()

	SetProperty("cp1", "AllyPath", "cp1_spawn")
	SetProperty("cp2", "AllyPath", "cp2_spawn")
	SetProperty("cp3", "AllyPath", "cp3_spawn")
	SetProperty("cp4", "AllyPath", "cp4_spawn")

	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				SSVxGTH_PostLoad()
			elseif RandomSide == 2 then
				SSVxCOL_PostLoad()
			end
		elseif ME5_SideVar == 1 then
			SSVxGTH_PostLoad()
		elseif ME5_SideVar == 2 then
			SSVxCOL_PostLoad()
		end
	else
		SSVxGTH_PostLoad()
	end
	
	
	CP1Node = GetPathPoint("cp1_spawn", 0) --gets the path point
	CP2Node = GetPathPoint("cp2_spawn", 0)
	CP3Node = GetPathPoint("cp3_spawn", 0)
	CP4Node = GetPathPoint("cp4_spawn", 0)

	artMatrices = { CP1Node, CP2Node, CP3Node, CP4Node }
	goingthroughturrets = 0

	artInitTimer = CreateTimer("artInitTimer")
	SetTimerValue("artInitTimer", 20.0)
	StartTimer("artInitTimer")
	--ShowTimer("artInitTimer") LEAVE COMMENTED
	OnTimerElapse(
		function(timer)
			goingthroughturrets = goingthroughturrets + 1
			if goingthroughturrets == 5 then
				goingthroughturrets = 1
			end

			SetEntityMatrix( "artillery1", artMatrices[goingthroughturrets])
			--ShowMessageText("level.common.events.surv.artillery.msg"..goingthroughturrets) LEAVE COMMENTED
			--  print("hot1n_surv: Artillery transitioning to matrix: "..goingthroughturrets)               
			SetTimerValue("artInitTimer", 20.0)
			--StartTimer("artInitTimer")
		end,
		"artInitTimer"
	)


	ClearAIGoals(1)
	ClearAIGoals(2)
	ClearAIGoals(3)
	AddAIGoal(1, "Conquest", 1000)
	AddAIGoal(2, "Conquest", 1000)
	AddAIGoal(ColHuskTeam, "Deathmatch", 100)
	
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
	StealArtistHeap(2048*2048)

	--ReadDataFile("dc:Load\\me5_load1.lvl")

	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2559)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1513)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1699)

	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_dirt.lvl")


	SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)

	Init_SideSetup()

	--ReadDataFile("..\\..\\addon\\PIO\\data\\_LVL_PC\\sound\\pio.lvl;pion")

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
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
	SetMemoryPoolSize("EntityHover", 32)
	SetMemoryPoolSize("EntityLight", 200)
	SetMemoryPoolSize("EntitySoundStream", 4)
	SetMemoryPoolSize("EntitySoundStatic", 32)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
	SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 207)
	SetMemoryPoolSize("SoundSpaceRegion", 64)
	SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\INI.lvl", "INI_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery.lvl")
	SetDenseEnvironment("false")
	
	
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music01()
			elseif RandomSide == 2 then
				Music05()
			end
		elseif ME5_SideVar == 1 then
			Music01()
		elseif ME5_SideVar == 2 then
			Music05()
		end
	else
		Music01()
	end
	
	--OpenAudioStream("..\\..\\addon\\PIO\\data\\_LVL_PC\\Sound\\pio.lvl",  "pio_ambiance")
	
	SoundFX()
	
	
	--OpeningSateliteShot
	AddCameraShot(0.908386, -0.209095, -0.352873, -0.081226, -45.922508, -19.114113, 77.022636);
	AddCameraShot(-0.481173, 0.024248, -0.875181, -0.044103, 14.767292, -30.602322, -144.506851);
	AddCameraShot(0.999914, -0.012495, -0.004416, -0.000055, 1.143253, -33.602314, -76.884430);
	AddCameraShot(0.839161, 0.012048, -0.543698, 0.007806, 19.152437, -49.802273, 24.337317);
	AddCameraShot(0.467324, 0.006709, -0.883972, 0.012691, 11.825212, -49.802273, -7.000720);
	AddCameraShot(0.861797, 0.001786, -0.507253, 0.001051, -11.986043, -59.702248, 23.263165);
	AddCameraShot(0.628546, -0.042609, -0.774831, -0.052525, 20.429928, -48.302277, 9.771714);
	AddCameraShot(0.765213, -0.051873, 0.640215, 0.043400, 57.692474, -48.302277, 16.540724);
	AddCameraShot(0.264032, -0.015285, -0.962782, -0.055734, -16.681797, -42.902290, 129.553268);
	AddCameraShot(-0.382320, 0.022132, -0.922222, -0.053386, 20.670977, -42.902290, 135.513001);
end