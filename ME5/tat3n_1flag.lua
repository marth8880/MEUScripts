ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveOneFlagCTF")

mapSize = "sm"
EnvironmentType = "desert"
onlineSideVar = "SSVxGTH"
onlineHeroSSV = "shep_adept"
onlineHeroGTH = "gethprime_me2"
onlineHeroCOL = "colgeneral"
onlineHeroEVG = "gethprime_me3"

-- AI hero spawns. CP name, CP spawn path name
heroSupportCPs = {}

-- Local ally spawns. CP name, CP spawn path name
allySpawnCPs = {}

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
-- FUNCTION:	ScriptInit
-- PURPOSE:	This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:		The name, 'ScriptInit' is a chosen convention, and each
--			mission script must contain a version of this function, as
--			it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptPostLoad()
	--This is the actual objective setup
	ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
							textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
							captureLimit = 5, flag = "1flag_flag", flagIcon = "flag_icon", 
							flagIconScale = 3.0, homeRegion = "1flag_capture2",
							captureRegionATT = "1flag_capture1", captureRegionDEF = "1flag_capture2",
							capRegionWorldATT = "1flag_effect2", capRegionWorldDEF = "1flag_effect1",
							capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
							capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
	ctf:Start()
--	KillObject("carbonite")
	EnableSPHeroRules()
	
			--[[Music06_CTF()
			music01 = music06_start
			music02 = music06_mid
			music03 = music06_end
			musicTimerValue = 185
	
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
    
	
	AddAIGoal(HuskTeam, "Deathmatch", 100)
	
	SetAllySpawns(allySpawnCPs)
	Init_SidesPostLoad("1flag", heroSupportCPs)
	
	KillObject("NPCCP2")
end

function ScriptInit()
    StealArtistHeap(720*1024)   -- steal from art heap
    
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4086000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;tat3")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2206)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1302)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1420)
	
	PreLoadStuff()
	
    Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl;tat3n")
	

	SetSpawnDelay(10.0, 0.25)

	local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 15)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 110)
    SetMemoryPoolSize("Combo::Condition", 100)
    SetMemoryPoolSize("Combo::State", 160)
    SetMemoryPoolSize("Combo::Transition", 100) -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityLight", 132)
	SetMemoryPoolSize("EntitySoundStatic", 3)
	SetMemoryPoolSize("EntitySoundStream", 12)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 40)
	SetMemoryPoolSize("MountedTurret", 0)
	SetMemoryPoolSize("Music", 99)
	SetMemoryPoolSize("Navigator", 35)
	SetMemoryPoolSize("Obstacle", 202)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("PathFollower", 35)
	SetMemoryPoolSize("RedOmniLight", 140)
	SetMemoryPoolSize("SoldierAnimation", 350)
	SetMemoryPoolSize("SoundSpaceRegion", 80)
	SetMemoryPoolSize("TreeGridStack", 100)
	SetMemoryPoolSize("UnitAgent", 35)
	SetMemoryPoolSize("UnitController", 35)
	SetMemoryPoolSize("Weapon", weaponCnt)

	--	Level Stats
	ClearWalkers()

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tat3.lvl", "tat3_1flag")
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
		if ME5_SideVar == 1 then
			Music04_CTF()
		elseif ME5_SideVar == 2 then
			Music02_CTF()
		elseif ME5_SideVar == 3	then
			Music09_CTF()
		elseif ME5_SideVar == 4	then
			Music09_CTF()
		end
	else
		Music04_CTF()
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
	
	PostLoadStuff()

end

