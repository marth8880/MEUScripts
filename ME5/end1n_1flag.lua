ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveOneFlagCTF")

mapSize = lg
EnvironmentType = 2
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_infiltrator
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
	else end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
	else end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
	else end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
	else end
end

---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()

	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )
	
	ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
							textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
							captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
							flagIconScale = 3.0, homeRegion = "team1_capture",
							capRegionWorldATT = "com_bldg_ctfbase", capRegionWorldDEF = "com_bldg_ctfbase1",
							captureRegionATT = "team1_capture", captureRegionDEF = "team2_capture",
							capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
							capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
	
	ctf:Start()
	
	EnableSPHeroRules()
	
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
		SSVxCOL_PostLoad()
	end
	
	PostLoadStuff()
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
	StealArtistHeap(2048*1024)
	
	-- Designers, these two lines *MUST* be first.
	SetPS2ModelMemory(2460000)
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;end1")
	
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
	AddWalkerType(0, 0) -- 8 droidekas(special case: 0 leg pairs)
	AddWalkerType(1, 0) -- 8 droidekas(special case: 0 leg pairs)
	AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
	AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
	
	local weaponCnt = 220
	SetMemoryPoolSize("ActiveRegion", 4)
	SetMemoryPoolSize("Aimer", 27)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 100)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityHover", 9)
	SetMemoryPoolSize("EntityLight", 25)
	SetMemoryPoolSize("EntitySoundStatic", 95)
	SetMemoryPoolSize("EntitySoundStream", 4)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("MountedTurret", 6)
	SetMemoryPoolSize("Navigator", 39)
	SetMemoryPoolSize("Obstacle", 937)
	SetMemoryPoolSize("PathFollower", 39)
	SetMemoryPoolSize("PathNode", 100)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoldierAnimation", 401)
	SetMemoryPoolSize("SoundSpaceRegion", 6)
	SetMemoryPoolSize("TreeGridStack", 587)
	SetMemoryPoolSize("UnitAgent", 39)
	SetMemoryPoolSize("UnitController", 39)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	--	Attacker Stats
	SetTeamAsFriend(ATT, 3)


	--	Defender Stats
	SetTeamAsEnemy(DEF, 3)

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\end1.lvl", "end1_1flag")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;end1")
	SetDenseEnvironment("true")
	AddDeathRegion("deathregion")
	SetStayInTurrets(1)


	--	Movies
	--	SetVictoryMovie(ALL, "all_end_victory")
	--	SetDefeatMovie(ALL, "imp_end_victory")
	--	SetVictoryMovie(IMP, "imp_end_victory")
	--	SetDefeatMovie(IMP, "all_end_victory")

	--	Sound
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music01_CTF()
			elseif RandomSide == 2 then
				Music05_CTF()
			elseif RandomSide == 3 then
				Music09_CTF()
			elseif RandomSide == 4 then
				Music09_CTF()
			end
		elseif ME5_SideVar == 1 then
			Music01_CTF()
		elseif ME5_SideVar == 2 then
			Music05_CTF()
		elseif ME5_SideVar == 3	then
			Music09_CTF()
		elseif ME5_SideVar == 4	then
			Music09_CTF()
		else end
	else
		Music05_CTF()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_YAV_Streaming.lvl",	"yav1")
	
	SoundFX()
	
    SetAttackingTeam(ATT)

	--Endor
	--Shield Bunker
	AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
	--Village
	AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
	--Village
	AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
end

