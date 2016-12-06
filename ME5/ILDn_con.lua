ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,2) 

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = "sm"
environmentType = "jungle"
onlineSideVar = "SSVxGTH"
onlineHeroSSV = "shep_soldier"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
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
	
	DisableBarriers("Barrier192")
	DisableBarriers("Barrier193") 
	DisableBarriers("Barrier194") 
	DisableBarriers("Barrier195")  
	
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
	
	AddDeathRegion("dr1")
	
	SetProperty("cp1", "AllyPath", "cp1_spawn")
	SetProperty("cp2", "AllyPath", "cp2_spawn")
	SetProperty("cp3", "AllyPath", "cp3_spawn")
	SetProperty("cp4", "AllyPath", "cp4_spawn")
	
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
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;common")
	
	manager:Proc_ScriptInit_Begin()
	
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser")
	
	manager:Proc_ScriptInit_SideSetup()
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_GE7_Streaming.lvl")
	
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
    SetMemoryPoolSize("EntitySoundStream", 32)
    SetMemoryPoolSize("EntitySoundStatic", 32)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\GE7.lvl", "GE7_conquest")
    SetDenseEnvironment("false")
	
	
    --  Sound Stats
    
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_GE7_Streaming.lvl",  "GE7_ambiance")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music04()
			elseif RandomSide == 2 then
				Music02()
			end
		elseif ME5_SideVar == 1 then
			Music04()
		elseif ME5_SideVar == 2 then
			Music02()
		end
	else
		Music04()
	end
	
	SoundFX()
	
	-- Opening Satellite Shot
	AddCameraShot(0.521041, 0.067458, 0.843819, -0.109248, 28.376871, 11.123616, 35.530045);
	AddCameraShot(0.899533, 0.095364, -0.423942, 0.044944, -46.051346, 14.026678, 5.547310);
	AddCameraShot(-0.347880, 0.038874, -0.930938, -0.104028, 66.435631, 11.032948, 52.811352);
	AddCameraShot(0.987645, 0.046299, 0.149546, -0.007010, -15.153394, 2.704909, 76.413383);
end