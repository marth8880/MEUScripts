ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,4)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

mapSize = lg
EnvironmentType = 3
onlineSideVar = SSVxGTH
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
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			herosupport:AddSpawnCP("CP3","CP3_SpawnPath")
			herosupport:AddSpawnCP("CP4","CP4_SpawnPath")
			herosupport:AddSpawnCP("CP5","CP5_SpawnPath")
			herosupport:AddSpawnCP("CP6","CP6_SpawnPath")
			herosupport:Start()
		else end
	else end
end

function SSVxCOL_PostLoad()
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
		DecideGTHHeroClass()
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			herosupport:AddSpawnCP("CP3","CP3_SpawnPath")
			herosupport:AddSpawnCP("CP4","CP4_SpawnPath")
			herosupport:AddSpawnCP("CP5","CP5_SpawnPath")
			herosupport:AddSpawnCP("CP6","CP6_SpawnPath")
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
			herosupport:AddSpawnCP("CP3","CP3_SpawnPath")
			herosupport:AddSpawnCP("CP4","CP4_SpawnPath")
			herosupport:AddSpawnCP("CP5","CP5_SpawnPath")
			herosupport:AddSpawnCP("CP6","CP6_SpawnPath")
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
			herosupport:AddSpawnCP("CP3","CP3_SpawnPath")
			herosupport:AddSpawnCP("CP4","CP4_SpawnPath")
			herosupport:AddSpawnCP("CP5","CP5_SpawnPath")
			herosupport:AddSpawnCP("CP6","CP6_SpawnPath")
			herosupport:Start()
		else end
	else end
end

function ScriptPostLoad()

	AddDeathRegion("fall")
	DisableBarriers("atat")
	DisableBarriers("bombbar")

    --CP SETUP for CONQUEST
--    SetProperty("shield", "MaxHealth", 222600.0)
--  	SetProperty("shield", "CurHealth", 222600.0)
    SetObjectTeam("CP3", 1)
    SetObjectTeam("CP6", 1)
    KillObject("CP7")
 
    EnableSPHeroRules()
    
    cp1 = CommandPost:New{name = "CP3"}
    cp2 = CommandPost:New{name = "CP4"}
    cp3 = CommandPost:New{name = "CP5"}
    cp4 = CommandPost:New{name = "CP6"}
--    cp5 = CommandPost:New{name = "CP7"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
--    conquest:AddCommandPost(cp5)
    
    conquest:Start()
	
	
	SetProperty("CP3", "AllyPath", "CP3_SpawnPath")
	SetProperty("CP4", "AllyPath", "CP4_SpawnPath")
	SetProperty("CP5", "AllyPath", "CP5_SpawnPath")
	SetProperty("CP6", "AllyPath", "CP6_SpawnPath")
	
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
		SSVxGTH_PostLoad()
	end
	
	SetProperty("VehicleSpawn_8", "ClassCisATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "ClassCisDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "ClassRepATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "ClassRepDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "SpawnTime", "20.0")
	SetProperty("VehicleSpawn_9", "ClassCisATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "ClassCisDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "ClassRepATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "ClassRepDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "SpawnTime", "20.0")
    
--    KillObject("shield");
	
	ShieldGenNode = GetPathPoint("CP2_SpawnPath", 3) --gets the path point
	CP3Node = GetPathPoint("CP3_SpawnPath", 6)
	CP4Node = GetPathPoint("CP4_SpawnPath", 0)
	CP5Node = GetPathPoint("CP5_SpawnPath", 1)
	--CP5Node = GetPathPoint("Path 13", 0)
	CP6Node = GetPathPoint("CP6_SpawnPath", 3)
	
	--[[CreateTimer("artGameTimer")
	SetTimerValue("artGameTimer", 720)
	StartTimer("artGameTimer")
	OnTimerElapse(
		function(timer)]]
			--local team1pts = GetReinforcementCount(1)
			--if team1pts >= 100 then
				artMatrices = { ShieldGenNode, CP3Node, CP4Node, CP5Node, CP6Node }
				goingthroughturrets = 0			
				
				artInitTimer = CreateTimer("artInitTimer")
				SetTimerValue("artInitTimer", 20.0)
				StartTimer("artInitTimer")
				--ShowTimer("artInitTimer")
				OnTimerElapse(
					function(timer)
						goingthroughturrets = goingthroughturrets + 1
						if goingthroughturrets == 6 then
							goingthroughturrets = 1
						end
						
						SetEntityMatrix( "artillery1", artMatrices[goingthroughturrets])
						--ShowMessageText("level.common.events.surv.artillery.msg"..goingthroughturrets)
							print("hot1n_con: Artillery transitioning to matrix: "..goingthroughturrets)
						SetTimerValue("artInitTimer", 20.0)
						StartTimer("artInitTimer")
					end,
				"artInitTimer"
				)
			--else
			--end
			
			--[[DestroyTimer(Timer)
		end,
	"artGameTimer"
	)]]
	
	PostLoadStuff()
	
 end

function ScriptInit()
	if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    end
    
    -- Designers, these two lines *MUST* be first.
    --SetPS2ModelMemory(4500000)
    SetPS2ModelMemory(3300000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;hot1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2202)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1305)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1665)
	
	PreLoadStuff()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_snow.lvl")

    --SetAttackingTeam(ATT)


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    SetGroundFlyerMap(1);
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_hoth_dishturret",
					"tur_bldg_hoth_lasermortar")
	
	Init_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl;hot1n")
	
	
	--  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 0) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	local weaponCnt = 250
    SetMemoryPoolSize("Aimer", 80)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 175)
    SetMemoryPoolSize("CommandWalker", 0)
    SetMemoryPoolSize("ConnectivityGraphFollower", 56)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 41)
	SetMemoryPoolSize("EntityHover", 15) --11
    SetMemoryPoolSize("EntityFlyer", 10)
    SetMemoryPoolSize("EntityLight", 110)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("EntitySoundStream", 12)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("MountedTurret", 38)
    SetMemoryPoolSize("Music", 78)
    SetMemoryPoolSize("Navigator", 63)
    SetMemoryPoolSize("Obstacle", 479)
	--SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoldierAnimation", 368)
    SetMemoryPoolSize("TreeGridStack", 349)
    SetMemoryPoolSize("UnitController", 63)
    SetMemoryPoolSize("UnitAgent", 63)
    SetMemoryPoolSize("Weapon", weaponCnt)

    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\hot1.lvl", "hoth_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;hot1")
    --ReadDataFile("tan\\tan1.lvl", "tan1_obj")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
	AISnipeSuitabilityDist(110)
	SetAttackerSnipeRange(130)
	SetDefenderSnipeRange(190)
    AddDeathRegion("Death")


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
		elseif ME5_SideVar == 2 then
			Music05()
		elseif ME5_SideVar == 3	then
			Music09()
		elseif ME5_SideVar == 4	then
			Music09()
		else end
	else
		Music03()
	end
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl",  "hot1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl",  "hot1")
	
	SoundFX()
	ScaleSoundParameter("ambientenv",	"Gain", 0.75)


    --  Camera Stats
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Battlefield
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)


end
