ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = "lg"
environmentType = "jungle"
onlineSideVar = "SSVxGTH"
onlineHeroSSV = "shep_engineer"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

--  CIS Attacking (attacker is always #1)
--SupportSSV = 4

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
	
	SetProperty("cp1", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp1", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp2", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp3", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp4", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp1", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp1", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	SetProperty("cp2", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	SetProperty("cp3", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	SetProperty("cp4", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	
	SetProperty("cp1", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp2", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp3", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp4", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp1", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp2", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp3", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp4", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp1", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp2", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp3", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp4", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp1", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
	SetProperty("cp2", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
	SetProperty("cp3", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
	SetProperty("cp4", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
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
	
	SetProperty("cp1", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_SSV_cpCapture_ally)
	SetProperty("cp1", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp2", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp3", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp4", "VO_Rep_RepLost", snd_SSV_cpLost_ally)
	SetProperty("cp1", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_SSV_cpCapture_enemy)
	SetProperty("cp1", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	SetProperty("cp2", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	SetProperty("cp3", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
	SetProperty("cp4", "VO_Rep_CisLost", snd_SSV_cpLost_enemy)
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end
	
	SetProperty("cp1", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp1", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp2", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp3", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp4", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp1", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp1", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	SetProperty("cp2", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	SetProperty("cp3", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	SetProperty("cp4", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	
	SetProperty("cp1", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp2", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp3", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp4", "VO_Cis_CisCapture", snd_GTH_cpCapture_ally)
	SetProperty("cp1", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp2", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp3", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp4", "VO_Cis_CisLost", snd_GTH_cpLost_ally)
	SetProperty("cp1", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp2", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp3", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp4", "VO_Cis_RepCapture", snd_GTH_cpCapture_enemy)
	SetProperty("cp1", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
	SetProperty("cp2", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
	SetProperty("cp3", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
	SetProperty("cp4", "VO_Cis_RepLost", snd_GTH_cpLost_enemy)
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("cp1","cp1_spawn")
			herosupport:AddSpawnCP("cp2","cp2_spawn")
			herosupport:AddSpawnCP("cp3","cp3_spawn")
			herosupport:AddSpawnCP("cp4","cp4_spawn")
			herosupport:Start()
		end
	end
	
	SetProperty("cp1", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp2", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp3", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp4", "VO_Rep_RepCapture", snd_EVG_cpCapture_ally)
	SetProperty("cp1", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp2", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp3", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp4", "VO_Rep_RepLost", snd_EVG_cpLost_ally)
	SetProperty("cp1", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp2", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp3", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp4", "VO_Rep_CisCapture", snd_EVG_cpCapture_enemy)
	SetProperty("cp1", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	SetProperty("cp2", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	SetProperty("cp3", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
	SetProperty("cp4", "VO_Rep_CisLost", snd_EVG_cpLost_enemy)
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
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				SSVxGTH_PostLoad()
			elseif RandomSide == 2 then
				SSVxCOL_PostLoad()
			elseif RandomSide == 3 then
				EVGxGTH_PostLoad()
			elseif RandomSide == 4 then
				EVGxCOL_PostLoad()
			end
		elseif ME5_SideVar == 1 then
			SSVxGTH_PostLoad()
		elseif ME5_SideVar == 2 then
			SSVxCOL_PostLoad()
		elseif ME5_SideVar == 3 then
			EVGxGTH_PostLoad()
		elseif ME5_SideVar == 4 then
			EVGxCOL_PostLoad()
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
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\vrm1.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1291)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)
    AISnipeSuitabilityDist(120)
	SetAttackerSnipeRange(90)
	SetDefenderSnipeRange(150)
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_VRM_Streaming.lvl")
	
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
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
	SetMemoryPoolSize("FlagItem", 512)
    --SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 128)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Music", 99)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathFollower", 128)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("RedOmniLight", 180)
	SetMemoryPoolSize("SoldierAnimation", 348)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\VRC.lvl", "VRC_conquest")
	
	SetDenseEnvironment("false")

    --  Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music03()
			elseif RandomSide == 2 then
				Music05()
			elseif RandomSide == 3 then
				Music09()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music03()
		elseif ME5_SideVar == 2	then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		end
	else
		Music03()
	end
	
	
	
	SoundFX()


--OpeningSatelliteShot
	AddCameraShot(0.993613, -0.112590, -0.007516, -0.000852, -144.671204, 12.469149, 105.698982);
	AddCameraShot(0.003597, -0.000253, -0.997521, -0.070274, -144.042343, 12.469149, 64.159500);
	AddCameraShot(0.583016, -0.093302, -0.796945, -0.127537, -190.497482, 12.469149, 81.069817);
	AddCameraShot(0.615988, -0.086602, 0.775356, 0.109007, -97.931252, 12.469149, 71.429901);
	AddCameraShot(0.900297, -0.099467, -0.421196, -0.046535, -191.081924, 12.469149, 159.755737);
	AddCameraShot(0.943805, -0.094135, 0.315250, 0.031443, -95.917686, 12.469149, 164.284882);
	AddCameraShot(0.039136, -0.004479, -0.992743, -0.113616, -145.351196, 12.469149, 7.593871);
	
	manager:Proc_ScriptInit_End()
	
end
