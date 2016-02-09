ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

mapSize = lg
EnvironmentType = 1
onlineSideVar = SSVxCOL
onlineHeroSSV = shep_soldier
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

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

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

function ScriptPostLoad()

    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	AddDeathRegion("deathregion2")
	AddDeathRegion("deathregion3")
    ctf:AddFlag{name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
	ctf:Start()
    EnableSPHeroRules()
    
    AddDeathRegion("deathregion")
	AddDeathRegion("deathregion4")
	AddDeathRegion("deathregion5")
	
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
	
end

function ScriptInit()
	StealArtistHeap(800*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3350000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;geo1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2248)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1341)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1492)
	
    PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
    

    --SetTeamAggressiveness(CIS, 1.0)
    --SetTeamAggressiveness(REP, 1.0)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_GEO_Streaming.lvl;geo1n")

    --  Level Stats

    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 55)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 5)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 0)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 10)
	SetMemoryPoolSize("Music", 78)
	SetMemoryPoolSize("Navigator", 57)
    SetMemoryPoolSize("Obstacle", 425)
    SetMemoryPoolSize("PathFollower", 57)
    SetMemoryPoolSize("PathNode", 100)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("SoldierAnimation", 345)
    
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", 57)
    SetMemoryPoolSize("UnitController", 57)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)


    --  Attacker Stats
    
    --teamATT = ConquestTeam:New{team = ATT}
    --teamATT:AddBleedThreshold(21, 0.75)
    --teamATT:AddBleedThreshold(11, 2.25)
    --teamATT:AddBleedThreshold(1, 3.0)
    --teamATT:Init()
    --SetTeamAsEnemy(ATT,3)

    --  Defender Stats
    
    --teamDEF = ConquestTeam:New{team = DEF}
    --teamDEF:AddBleedThreshold(21, 0.75)
    --teamDEF:AddBleedThreshold(11, 2.25)
    --teamDEF:AddBleedThreshold(1, 3.0)
    --teamDEF:Init()
    --SetTeamAsFriend(DEF,3)

    --  Local Stats
    --[[SetTeamName(3, "locals")
    AddUnitClass(3, "geo_inf_geonosian", 7)
    SetUnitCount(3, 7)
    SetTeamAsFriend(3, DEF)]]
    --SetTeamName(4, "locals")
    --AddUnitClass(4, "rep_inf_jedimale",1)
    --AddUnitClass(4, "rep_inf_jedimaleb",1)
    --AddUnitClass(4, "rep_inf_jedimaley",1)
    --SetUnitCount(4, 3)
    --SetTeamAsFriend(4, ATT)

    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\geo1.lvl", "geo1_ctf")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;geo1")

    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(120)



    --  Birdies
    --SetNumBirdTypes(1)
    --SetBirdType(0.0,10.0,"dragon")
    --SetBirdFlockMinHeight(90.0)

    --  Sound
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music03_CTF()
			elseif RandomSide == 2 then
				Music05_CTF()
			elseif RandomSide == 3 then
				Music09_CTF()
			elseif RandomSide == 4 then
				Music09_CTF()
			end
		elseif ME5_SideVar == 1 then
			Music03_CTF()
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
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_GEO_Streaming.lvl",  "geo1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_GEO_Streaming.lvl",  "geo1")
	
	SoundFX()


    --ActivateBonus(CIS, "SNEAK_ATTACK")
    --ActivateBonus(REP, "SNEAK_ATTACK")

    SetAttackingTeam(ATT)

    --Opening Satalite Shot
    --Geo
    --Mountain
    AddCameraShot(0.996091, 0.085528, -0.022005, 0.001889, -6.942698, -59.197201, 26.136919)
    --Wrecked Ship
    AddCameraShot(0.906778, 0.081875, -0.411906, 0.037192, 26.373968, -59.937874, 122.553581)
    --War Room  
    --AddCameraShot(0.994219, 0.074374, 0.077228, -0.005777, 90.939568, -49.293945, -69.571136)
	
	PostLoadStuff()
end

