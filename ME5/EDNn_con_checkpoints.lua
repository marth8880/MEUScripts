ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,2) 

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_RandomSides")

mapSize = "sm"
EnvironmentType = "jungle"
onlineSideVar = "SSVxGTH"
onlineHeroSSV = "shep_soldier"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"

	--  Empire Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    ColHuskTeam = 3
    --  These variables do not change
    ATT = 1
    DEF = 2


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
			herosupport:AddSpawnCP("cp5","cp5_spawn")
			herosupport:AddSpawnCP("cp6","cp6_spawn")
			herosupport:Start()
		end
	end
	
	SetProperty("cp1", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp5", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp6", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp1", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp2", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp3", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp4", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp5", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp6", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp1", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp5", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp6", "VO_Rep_CisCapture", snd_SSV_cpCapture_GTH)
	SetProperty("cp1", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp2", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp3", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp4", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp5", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	SetProperty("cp6", "VO_Rep_CisLost", snd_SSV_cpLost_GTH)
	
	SetProperty("cp1", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp2", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp3", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp4", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp5", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp6", "VO_Cis_CisCapture", snd_GTH_cpCapture_GTH)
	SetProperty("cp1", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp2", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp3", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp4", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp5", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp6", "VO_Cis_CisLost", snd_GTH_cpLost_GTH)
	SetProperty("cp1", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp2", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp3", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp4", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp5", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp6", "VO_Cis_RepCapture", snd_GTH_cpCapture_SSV)
	SetProperty("cp1", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp2", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp3", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp4", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp5", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
	SetProperty("cp6", "VO_Cis_RepLost", snd_GTH_cpLost_SSV)
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
			herosupport:AddSpawnCP("cp5","cp5_spawn")
			herosupport:AddSpawnCP("cp6","cp6_spawn")
			herosupport:Start()
		end
	end
	
	SetProperty("cp1", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp5", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp6", "VO_Rep_RepCapture", snd_SSV_cpCapture_SSV)
	SetProperty("cp1", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp2", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp3", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp4", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp5", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	SetProperty("cp6", "VO_Rep_RepLost", snd_SSV_cpLost_SSV)
	
	SetProperty("cp1", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp5", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp6", "VO_Rep_CisCapture", snd_SSV_cpCapture_COL)
	SetProperty("cp1", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp2", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp3", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp4", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp5", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
	SetProperty("cp6", "VO_Rep_CisLost", snd_SSV_cpLost_COL)
end
    
function ScriptPostLoad() 
--WeatherMode = math.random(1,3)
--weather()
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    
    
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

	SetProperty("cp1", "AllyPath", "cp1_spawn")
	SetProperty("cp2", "AllyPath", "cp2_spawn")
	SetProperty("cp3", "AllyPath", "cp3_spawn")
	SetProperty("cp4", "AllyPath", "cp4_spawn")
	SetProperty("cp5", "AllyPath", "cp5_spawn")
	SetProperty("cp6", "AllyPath", "cp6_spawn")
	
	AddAIGoal(ColHuskTeam, "Deathmatch", 100)
	
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
    
    conquest:Start()

    EnableSPHeroRules()
	
	ClearAIGoals(1)
	ClearAIGoals(2)
	AddAIGoal(1, "Conquest", 400)
	--AddAIGoal(1, "Defend", 100, "cp1_capture")
	AddAIGoal(2, "Conquest", 400)

    AddDeathRegion("monorail")
    AddDeathRegion("ocean")
    
end

--[[function weather()
	if WeatherMode == 1 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "red")
	elseif WeatherMode == 2 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
	elseif WeatherMode == 3 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "night")
	end
end]]


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
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(256*1024)
    SetPS2ModelMemory(2097152 + 65536 * 10)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\edn.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2551)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1316)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1691)
	
	PreLoadStuff()
	
	SetMaxFlyHeight(23)
	SetMaxPlayerFlyHeight(23)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser")
	
	Init_SideSetup()
	
	--SetTeamAggressiveness(CIS,(0.97))
	--SetTeamAggressiveness(REP,(0.99))
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EDN_Streaming.lvl")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 23)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 325)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("EntityHover", 1)
    SetMemoryPoolSize("EntitySoundStream", 16)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Music", 99)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 667)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 382)
	SetMemoryPoolSize("SoundSpaceRegion", 96)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
	WeatherMode = math.random(1,3)
	if not ScriptCB_InMultiplayer() then
		if WeatherMode == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "red")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_red")
			
			SetDenseEnvironment("false")
		elseif WeatherMode == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_day")
			
			SetNumBirdTypes(1)
			SetBirdType(0,1.0,"bird")
			SetBirdFlockMinHeight(50);
			
			SetDenseEnvironment("false")
		elseif WeatherMode == 3 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "night")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_night")
			
			SetDenseEnvironment("true")
			SetAIViewMultiplier(0.65)
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\SKY\\spa_sky.lvl", "blue")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EDN.lvl", "EDN_conquest_day")
		
		SetNumBirdTypes(1)
		SetBirdType(0,1.0,"bird")
		SetBirdFlockMinHeight(50);
		
		SetDenseEnvironment("false")
	end


    --  Sound Stats
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_EDN_Streaming.lvl",  "EDN_ambiance")
	
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
	
	SoundFX()

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(-0.343467, 0.042708, -0.931023, -0.115767, -8.370228, 7.682051, -68.327812);
	AddCameraShot(0.447841, -0.066177, -0.882082, -0.130344, -64.310715, 17.633507, 74.121971);
	AddCameraShot(0.921308, -0.158280, -0.350031, -0.060135, -104.089935, 19.899040, 41.774940);
	AddCameraShot(0.714986, -0.147160, -0.669443, -0.137786, -103.483871, 20.399969, 61.148930);
	AddCameraShot(-0.004849, 0.000026, -0.999974, -0.005416, -20.710209, 5.094892, -33.587643);
end
