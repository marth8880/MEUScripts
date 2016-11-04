ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = "lg"
EnvironmentType = "jungle"
onlineSideVar = "SSVxCOL"
onlineHeroSSV = "shep_infiltrator"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp4", "cp4_spawn"},
			{"cp5", "cp5_spawn"},
			{"cp6", "cp6_spawn"},
			{"cp10", "cp10_spawn"},
}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {
			{"cp1", "cp1_spawn"},
			{"cp2", "cp2_spawn"},
			{"cp4", "cp4_spawn"},
			{"cp5", "cp5_spawn"},
			{"cp6", "cp6_spawn"},
			{"cp10", "cp10_spawn"},
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
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()
	cp1 = CommandPost:New{name = "CP1"}
	cp2 = CommandPost:New{name = "CP2"}
	cp4 = CommandPost:New{name = "CP4"}
	cp5 = CommandPost:New{name = "CP5"}
	cp6 = CommandPost:New{name = "CP6"}
	cp10 = CommandPost:New{name = "CP10"}
	
	--This sets up the actual objective.	This needs to happen after cp's are defined
	conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
	
	--This adds the CPs to the objective.	This needs to happen after the objective is set up
	conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp4)
	conquest:AddCommandPost(cp5)
	conquest:AddCommandPost(cp6)
	conquest:AddCommandPost(cp10)
	
	conquest:Start()
	
	EnableSPHeroRules()
    
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("conquest", heroSupportCPs)
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
	StealArtistHeap(1150*1024)
	
	-- Designers, these two lines *MUST* be first.
	SetPS2ModelMemory(2460000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;end1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2581)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1449)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1606)
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_dirt.lvl")

    SetMemoryPoolSize("Music", 99)
	
	SetWorldExtents(1277.3)

	SetMaxFlyHeight(43)
	SetMaxPlayerFlyHeight(43)
	AISnipeSuitabilityDist(130)
	SetAttackerSnipeRange(150)
	SetDefenderSnipeRange(185)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_END_Streaming.lvl;end1n")
	
	--[[	Ewoks
	ReadDataFile("SIDE\\ewk.lvl",
				"ewk_inf_basic")
	
	SetTeamName(3, "locals")
	AddUnitClass(3, "ewk_inf_trooper", 3)
	AddUnitClass(3, "ewk_inf_repair", 3)
	SetUnitCount(3, 6)
	
	SetTeamAsFriend(3,ATT)
	SetTeamAsEnemy(3,DEF)
	SetTeamAsFriend(ATT, 3)
	SetTeamAsEnemy(DEF, 3)
	--]]

	--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 0) -- droidekas(special case: 0 leg pairs)
	AddWalkerType(1, 0) -- ATSTs (1 leg pair)
	AddWalkerType(2, 0) -- spider walkers with 2 leg pairs each
	AddWalkerType(3, 0) -- attes with 3 leg pairs each
	
	local weaponCnt = 240
	SetMemoryPoolSize("ActiveRegion", 4)
	SetMemoryPoolSize("Aimer", 27)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 100)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 9) -- 3xATST + rocket upgrade
	SetMemoryPoolSize("EntityHover", 9)
	SetMemoryPoolSize("EntityLight", 23)
	SetMemoryPoolSize("EntityMine", 8)
	SetMemoryPoolSize("EntitySoundStatic", 95)
	SetMemoryPoolSize("EntitySoundStream", 12)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("MountedTurret", 6)
	SetMemoryPoolSize("Navigator", 39)
	SetMemoryPoolSize("Obstacle", 937)
	SetMemoryPoolSize("PathFollower", 39)
	SetMemoryPoolSize("PathNode", 100)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoldierAnimation", 401)
	SetMemoryPoolSize("SoundSpaceRegion", 6)
	SetMemoryPoolSize("TentacleSimulator", 14)
	SetMemoryPoolSize("TreeGridStack", 692)
	SetMemoryPoolSize("UnitAgent", 46)
	SetMemoryPoolSize("UnitController", 48)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\end1.lvl", "end1_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;end1")
	SetDenseEnvironment("true")
	AddDeathRegion("deathregion")
	SetStayInTurrets(1)

	--	Sound
	
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
		Music05()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_END_Streaming.lvl",  "end1")
	
	SoundFX()

	SetAttackingTeam(ATT)

	--Endor
	--Shield Bunker
	AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
	--Village
	AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
	--Village
	AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
	
	PostLoadStuff()
end
