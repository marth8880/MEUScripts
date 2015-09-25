ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

mapSize = lg
EnvironmentType = 1
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_adept
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3

if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 2
	CIS = 1
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

--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	--Switch the flag appearance(s) for CW vs GCW
    SetProperty("ctf_flag1", "GeometryName", "com_icon_cis_flag")
    SetProperty("ctf_flag1", "CarriedGeometryName", "com_icon_cis_flag_carried")

    SetProperty("ctf_flag2", "GeometryName", "com_icon_republic_flag")
    SetProperty("ctf_flag2", "CarriedGeometryName", "com_icon_republic_flag_carried")
	
	--Set up all the CTF objective stuff 
	ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,	textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", multiplayerRules = true, hideCPs = true}
	ctf:AddFlag{name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	ctf:AddFlag{name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}

	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )

	ctf:Start()
	
	KillObject("CP1")
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	KillObject("CP7")
	KillObject("CP8")
	
	AddAIGoal(3, "Deathmatch", 100)
	
	--[[if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			music01 = "ssv_amb_03_start"
			music02 = "ssv_amb_03_mid"
			music03 = "ssv_amb_03_end"
			musicTimerValue = 180
		elseif RandomSide == 2 then
			Music05_CTF()
			music01 = music05_start
			music02 = music05_mid
			music03 = music05_end
			musicTimerValue = 130
		end
	else
		Music05_CTF()
		music01 = music05_start
		music02 = music05_mid
		music03 = music05_end
		musicTimerValue = 130
	end
	
	ScriptCB_PlayInGameMusic(music01)
	
	CreateTimer("music_timer")
		SetTimerValue("music_timer", musicTimerValue)
		StartTimer("music_timer")
		--ShowTimer("music_timer")
		OnTimerElapse(
			function(timer)
				RandomMusic = math.random(1,3)
				
				if RandomMusic == 1 then
						print("execute music variation 1")
					ScriptCB_PlayInGameMusic(music01)
				elseif RandomMusic == 2 then
						print("execute music variation 2")
					ScriptCB_PlayInGameMusic(music02)
				elseif RandomMusic == 3 then
						print("execute music variation 3")
					ScriptCB_PlayInGameMusic(music03)
				end
				
				SetTimerValue("music_timer", musicTimerValue)
				StartTimer("music_timer")
			end,
			"music_timer"
		)]]
	
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
	
	KillObject("jawa_cp")
	
	PostLoadStuff()
	
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
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(2048*1024)
    SetPS2ModelMemory(2097152 + 65536 * 6)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;tat2")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2541)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1494)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1645)
	
	PreLoadStuff()
	
    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(140)
	
	SetAIVehicleNotifyRadius(7)
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret",
					"tur_bldg_tat_barge")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_TAT2_Streaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl;tat2n")
	
	-- Jawas --------------------------
	--[[SetTeamName (3, "locals")
	AddUnitClass (3, "tat_inf_jawa", 7)
	SetUnitCount (3, 7)
	SetTeamAsFriend(3,ATT)
	SetTeamAsFriend(3,DEF)
	SetTeamAsFriend(ATT,3)
	SetTeamAsFriend(DEF,3)]]
	-----------------------------------

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 30)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 379)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 20)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 788)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("SoldierAnimation", 405)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tat2.lvl", "tat2_ctf")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tat2")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_TAT2_Streaming.lvl",  "TAT_ambiance")
	
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
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl",  "tat2")
	
	SoundFX()


    SetAttackingTeam(ATT)

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end