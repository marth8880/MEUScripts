ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)

isModMap = 1
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

mapSize = sm
EnvironmentType = 2
onlineSideVar = SSVxGTH
onlineHeroSSV = shep_engineer
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
	end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideCOLHeroClass()
	end
end

function EVGxGTH_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideGTHHeroClass()
	end
end

function EVGxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideEVGHeroClass()
		DecideCOLHeroClass()
	end
end

function ScriptPostLoad()

	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
		print("start ctf objective")
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "ctf_team1_capture", captureRegion = "ctf_team2_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "ctf_team2_capture", captureRegion = "ctf_team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
		print("end ctf objective")
	ctf:Start()
	
    EnableSPHeroRules()
	
	--[[Music06_CTF()
	music01 = music06_start
	music02 = music06_mid
	music03 = music06_end
	
	ScriptCB_PlayInGameMusic(music01)
	
	CreateTimer("music_timer")
		SetTimerValue("music_timer", 185)
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
				
				SetTimerValue("music_timer", 185)
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\pro.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2367)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1380)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1533)
	
	PreLoadStuff()
	
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)
	AISnipeSuitabilityDist(35)
	SetAttackerSnipeRange(45)
	SetDefenderSnipeRange(70)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	Init_SideSetup()
	
	-- TODO: create sound LVL 
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_T4E_Streaming.lvl")
	
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
    SetMemoryPoolSize("SoldierAnimation", 270)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\T4E.lvl", "T4E_ctf")
    SetDenseEnvironment("false")
	
	
    --  Sound
    
    -- TODO: create sound streams
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_T4E_Streaming.lvl",  "T4E_ambiance")
    
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				Music06_CTF()
			elseif RandomSide == 2 then
				Music02_CTF()
			elseif RandomSide == 3 then
				Music06_CTF()
			elseif RandomSide == 4 then
				Music09_CTF()
			end
		elseif ME5_SideVar == 1 then
			Music06_CTF()
		elseif ME5_SideVar == 2 then
			Music02_CTF()
		elseif ME5_SideVar == 3	then
			Music06_CTF()
		elseif ME5_SideVar == 4	then
			Music09_CTF()
		end
	else
		Music03_CTF()
	end

    SoundFX()
    
    --  Camera Stats
	AddCameraShot(-0.370814, 0.035046, -0.923929, -0.087320, -71.966255, 23.668301, 27.930090);
	AddCameraShot(0.991073, 0.002392, 0.133299, -0.000322, 84.069084, 23.668301, -95.802574);
	
	PostLoadStuff()
end
