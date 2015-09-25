ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = sm
EnvironmentType = 1
onlineSideVar = EVGxCOL
onlineHeroSSV = shep_adept
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3

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
			herosupport:AddSpawnCP("cp1","CP1SPAWN")
			herosupport:AddSpawnCP("cp2","CP2SPAWN")
			herosupport:AddSpawnCP("cp3","CP3Spawn")
			herosupport:AddSpawnCP("cp4","CP4Spawn")
			herosupport:AddSpawnCP("cp5","CP5Spawn")
			herosupport:Start()
		else end
	else end
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
			herosupport:AddSpawnCP("cp1","CP1SPAWN")
			herosupport:AddSpawnCP("cp2","CP2SPAWN")
			herosupport:AddSpawnCP("cp3","CP3Spawn")
			herosupport:AddSpawnCP("cp4","CP4Spawn")
			herosupport:AddSpawnCP("cp5","CP5Spawn")
			herosupport:Start()
		else end
	else end
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
			herosupport:AddSpawnCP("cp1","CP1SPAWN")
			herosupport:AddSpawnCP("cp2","CP2SPAWN")
			herosupport:AddSpawnCP("cp3","CP3Spawn")
			herosupport:AddSpawnCP("cp4","CP4Spawn")
			herosupport:AddSpawnCP("cp5","CP5Spawn")
			herosupport:Start()
		else end
	else end
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
			herosupport:AddSpawnCP("cp1","CP1SPAWN")
			herosupport:AddSpawnCP("cp2","CP2SPAWN")
			herosupport:AddSpawnCP("cp3","CP3Spawn")
			herosupport:AddSpawnCP("cp4","CP4Spawn")
			herosupport:AddSpawnCP("cp5","CP5Spawn")
			herosupport:Start()
		else end
	else end
end

---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()
	cp1 = CommandPost:New{name = "cp1"}
	cp2 = CommandPost:New{name = "cp2"}
	cp3 = CommandPost:New{name = "cp3"}
	cp4 = CommandPost:New{name = "cp4"}
	cp5 = CommandPost:New{name = "cp5"}
	
	--This sets up the actual objective.	This needs to happen after cp's are defined
	conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
	
	--This adds the CPs to the objective.	This needs to happen after the objective is set up
	conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)
	conquest:AddCommandPost(cp4)
	conquest:AddCommandPost(cp5)
	
	
	SetProperty("cp1", "AllyPath", "CP1SPAWN")
	SetProperty("cp2", "AllyPath", "CP2SPAWN")
	SetProperty("cp3", "AllyPath", "CP3Spawn")
	SetProperty("cp4", "AllyPath", "CP4Spawn")
	SetProperty("cp5", "AllyPath", "CP5Spawn")
	
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
		else end
	else
		EVGxCOL_PostLoad()
	end
	
	conquest:Start()

	EnableSPHeroRules()
	
	KillObject("NPCCP1")
	KillObject("NPCCP2")
	
	PostLoadStuff()
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
    StealArtistHeap(700*1024)   -- steal from art heap
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4087000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;tat3")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2206)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1302)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1420)
	
	PreLoadStuff()
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl;tat3n")

	
	SetSpawnDelay(10.0, 0.25)

	--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 0) -- Droidekas
	AddWalkerType(1, 0)
	AddWalkerType(2, 0)
	-- Memory settings ---------------------------------------------------------------------
	local weaponCnt = 190
	SetMemoryPoolSize("ActiveRegion", 8)
	SetMemoryPoolSize("Aimer", 10)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 105)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 17)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityLight", 141)
	SetMemoryPoolSize("EntitySoundStatic", 8)
	SetMemoryPoolSize("EntitySoundStream", 20)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 50)
	SetMemoryPoolSize("MountedTurret", 1)
	SetMemoryPoolSize("Navigator", 35)
	SetMemoryPoolSize("Obstacle", 200)
	SetMemoryPoolSize("PathNode", 196)
	SetMemoryPoolSize("PathFollower", 35)
	SetMemoryPoolSize("RedOmniLight", 146) 
	SetMemoryPoolSize("SoldierAnimation", 345)
	SetMemoryPoolSize("SoundSpaceRegion", 80)
	SetMemoryPoolSize("TentacleSimulator", 12)
	SetMemoryPoolSize("TreeGridStack", 75)
	SetMemoryPoolSize("UnitAgent", 35)
	SetMemoryPoolSize("UnitController", 35)
	SetMemoryPoolSize("Weapon", weaponCnt)
	----------------------------------------------------------------------------------------

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tat3.lvl", "tat3_con")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tat3")
	SetDenseEnvironment("true")
	--AddDeathRegion("Sarlac01")
	
	SetMaxFlyHeight(90)
	SetMaxPlayerFlyHeight(90)
	AISnipeSuitabilityDist(50)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(80)
	
	

	--	Sound Stats
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music04()
			elseif RandomSide == 2 then
				Music02()
			elseif RandomSide == 3 then
				Music09()
			elseif RandomSide == 4 then
				Music09()
			end
		elseif ME5_SideVar == 1 then
			Music04()
		elseif ME5_SideVar == 2 then
			Music02()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music09()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl",	"tat3")
	
	SoundFX()

	--	Camera Stats
	--Tat 3 - Jabbas' Palace
	AddCameraShot(0.685601, -0.253606, -0.639994, -0.236735, -65.939224, -0.176558, 127.400444)
	AddCameraShot(0.786944, 0.050288, -0.613719, 0.039218, -80.626396, 1.175180, 133.205551)
	AddCameraShot(0.997982, 0.061865, -0.014249, 0.000883, -65.227898, 1.322798, 123.976990)
	AddCameraShot(-0.367869, -0.027819, -0.926815, 0.070087, -19.548307, -5.736280, 163.360519)
	AddCameraShot(0.773980, -0.100127, -0.620077, -0.080217, -61.123989, -0.629283, 176.066025)
	AddCameraShot(0.978189, 0.012077, 0.207350, -0.002560, -88.388947, 5.674968, 153.745255)
	AddCameraShot(-0.144606, -0.010301, -0.986935, 0.070304, -106.872772, 2.066469, 102.783096)
	AddCameraShot(0.926756, -0.228578, -0.289446, -0.071390, -60.819584, -2.117482, 96.400620)
	AddCameraShot(0.873080, 0.134285, 0.463274, -0.071254, -52.071609, -8.430746, 67.122437)
	AddCameraShot(0.773398, -0.022789, -0.633236, -0.018659, -32.738083, -7.379394, 81.508003)
	AddCameraShot(0.090190, 0.005601, -0.993994, 0.061733, -15.379695, -9.939115, 72.110054)
	AddCameraShot(0.971737, -0.118739, -0.202524, -0.024747, -16.591295, -1.371236, 147.933029)
	AddCameraShot(0.894918, 0.098682, -0.432560, 0.047698, -20.577391, -10.683214, 128.752563)
end
