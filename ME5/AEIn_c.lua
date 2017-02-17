ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = 1

isModMap = 1
local bDebug = false
local mapDebug = false
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

MEUGameMode = 7

-- load the gametype script
ScriptCB_DoFile("ME5_Master")

MEUGameMode = meu_campaign

ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_MultiObjectiveContainer")
ScriptCB_DoFile("ME5_ObjectiveAssault")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_ObjectiveGoto")

MEUGameMode = meu_campaign

ScriptCB_DoFile("ME5_CinematicContainer")
ScriptCB_DoFile("ME5_CameraFunctions")
ScriptCB_DoFile("ME5_CombatManager")
--ScriptCB_DoFile("ME5_CinematicOverlayIFS")
ScriptCB_DoFile("Ambush")

mapSize = xs
EnvironmentType = 4
--[[onlineSideVar = SSVxGTH
onlineHeroSSV = shep_vanguard
onlineHeroGTH = gethprime_me2
onlineHeroCOL = colgeneral
onlineHeroEVG = gethprime_me3]]

REP = 1	-- The player's team.
CIS = 2	-- Team for the Geth Troopers and Rocketeers. Note: synonymous with teamID 'GethPawns'.
SQD = 3	-- Team for the player's squad.
GethHusks = 0	-- Team for the Husks. (DEPRECATED)
GethPawns = CIS	-- Team for the Geth Troopers and Rocketeers. Note: synonymous with teamID 'CIS'.
GethTacticals = 4	-- Team for the Geth Snipers and Hunters.
GethSpecials = 5	-- Team for the Geth Machinists and Shock Troopers.
GethHeavys = 6	-- Team for the Geth Destroyers and Juggernauts.
GethPrimes = 7	-- Team for the Geth Primes.

ATT = 1
DEF = 2

local playerLives = 10	-- The amount of lives the player has. A value of -1 denotes infinite lives.

local playerMaxHealth = nil	-- The player's max health for their current class.
local playerMinHealth = nil	-- The value to restore the player's health to after every combat zone.
local playerCurHealth = nil	-- The player's current health.

local playerHealthThreshold = 0.4	-- The percentage form of playerMinHealth. Must be > playerHealthThreshold in fLowHealthSound().
local playerHealthAddRate = 50		-- The amount of health that is restored to the player per second.

local squadDefenseBuff = nil	-- The multiplier for the player's squad's health/shields.
local enemyDefenseBuff = nil	-- The multiplier for the enemy units' health/shields.
local bossDefenseBuff = nil		-- The multiplier for the final boss.

local squadAggro = nil		-- The aggressiveness of the player's squad.
local enemyAggro = nil		-- The aggressiveness of the enemy units.
local bossAggro = nil		-- The aggressiveness of the final boss.

local bInCombat = false			-- Is the player currently in combat?
local currentZoneID = "none"	-- What is the name ID of the current combat zone?

local numCinematicShakes = 0		-- How many cinematic shakes have there been?
local camShakeCharUnit = nil		-- The player character unit.

local bConsoleWorkaround = true

SmartSpawn_curAllySpawn = nil
SmartSpawn_curEnemySpawn = nil


-- CASUAL
if ME5_Difficulty == 1 then
	squadDefenseBuff = 1.0
	enemyDefenseBuff = 1.0
	bossDefenseBuff = 1.0
	
	squadAggro = 0.89
	enemyAggro = 0.87
	bossAggro = 0.92
	
-- NORMAL
elseif ME5_Difficulty == 2 then
	squadDefenseBuff = 1.1
	enemyDefenseBuff = 1.25
	bossDefenseBuff = 1.25
	
	squadAggro = 0.90
	enemyAggro = 0.90
	bossAggro = 0.94
	
-- VETERAN
elseif ME5_Difficulty == 3 then
	squadDefenseBuff = 1.2
	enemyDefenseBuff = 1.5
	bossDefenseBuff = 1.5
	
	squadAggro = 0.91
	enemyAggro = 0.93
	bossAggro = 0.96
	
-- HARDCORE
elseif ME5_Difficulty == 4 then
	squadDefenseBuff = 1.3
	enemyDefenseBuff = 1.75
	bossDefenseBuff = 1.75
	
	squadAggro = 0.92
	enemyAggro = 0.96
	bossAggro = 0.98
	
-- INSANITY
elseif ME5_Difficulty == 5 then
	squadDefenseBuff = 1.4
	enemyDefenseBuff = 2.0
	bossDefenseBuff = 2.0
	
	squadAggro = 0.93
	enemyAggro = 0.99
	bossAggro = 1.00

-- DEFAULT (used if ME5_Difficulty is invalid)
else
	squadDefenseBuff = 1.1
	enemyDefenseBuff = 1.25
	bossDefenseBuff = 1.25
	
	squadAggro = 0.90
	enemyAggro = 0.90
	bossAggro = 0.94
end


-- Table of all allied teams.
allyTeams	= { REP, 
				SQD }

-- Table of all enemy teams.
enemyTeams	= { GethPawns, 
				GethTacticals, 
				GethSpecials, 
				GethHeavys, 
				GethPrimes }

enemyBuildingClasses = {	"gth_bldg_assaultdrone", 
							"gth_bldg_gethturret", 
							"gth_bldg_rocketdrone", 
							"gth_weap_inf_hexshield", 
							"gth_weap_inf_hexshield_jug", 
							"weap_tech_combatdronetur_incinerate", 
							"weap_tech_combatdronetur_rocket", 
							"weap_tech_combatdronetur_shock"}


---
-- Call this to check if the input /object/ matches one of the classes in /enemyBuildingClasses/.
-- @param #object object The object data to check.
-- @return #bool True, object is not an enemy building. False, object is an enemy building.
function IsObjectUnit(object)
	--print("EXAMPLEn_c.IsObjectUnit(): Entered")
	
	print("EXAMPLEn_c.IsObjectUnit(): Object class name:", GetEntityClass(object))
	
	for i in pairs(enemyBuildingClasses) do
		-- Is the object an enemy building?
		if GetEntityClass(object) == FindEntityClass(enemyBuildingClasses[i]) then
			print("EXAMPLEn_c.IsObjectUnit(): Object is an enemy building!")
			return false
		else
			print("EXAMPLEn_c.IsObjectUnit(): Object is NOT an enemy building!")
			return true
		end
	end
end


---
-- Restores the player's health until the health threshold is reached.
-- 
function RestorePlayerHealth()
		print("EXAMPLEn_c.RestorePlayerHealth(): Entered")
		
	local charPtr = GetCharacterUnit(0)
	local entPtr = GetEntityPtr(charPtr)
			
	-- What is the player's current health?
	playerCurHealth = GetObjectHealth(entPtr)
	
	-- How often in seconds will we check the player's health?
	local checkInterval = 0.5
	
	
	if playerCurHealth < playerMinHealth then
		-- Start restoring the player's health
		SetProperty(charPtr, "AddHealth", playerHealthAddRate)
		
		-- Our timer for checking the player's health
		local checkTimer = CreateTimer("checkTimer")
		SetTimerValue(checkTimer, checkInterval)
		--ShowTimer(checkTimer)
		
		StartTimer(checkTimer)
		
		-- Check the player's health every half of a second since we don't have an update function :(
		local checkTimerElapse = OnTimerElapse(
			function(timer)
				-- Update the player's health
				playerCurHealth = GetObjectHealth(entPtr)
				
				print("EXAMPLEn_c.RestorePlayerHealth(): playerCurHealth:", playerCurHealth)
				
				-- Is the player's health still low?
				if playerCurHealth < playerMinHealth then
					-- Restart the timer
					SetTimerValue(checkTimer, checkInterval)
					StartTimer(checkTimer)
				else
					print("EXAMPLEn_c.RestorePlayerHealth(): Threshold surpassed, stopping restoration")
					
					-- Stop the timer
					StopTimer(checkTimer)
					
					-- Stop restoring health
					SetProperty(charPtr, "AddHealth", 0)
					
					DestroyTimer(checkTimer)
				end
			end,
		"checkTimer"
		)
	end
end


---
-- Prints and returns the variable /playerCurHealth/.
-- @return The player's current health from /playerCurHealth/.
-- 
function GetPlayerCurHealth()
	print("EXAMPLEn_c.GetPlayerCurHealth(): playerCurHealth:", playerCurHealth)
	return playerCurHealth
end


---
-- Prints and returns the variable /playerMinHealth/.
-- @return The player's minimum health from /playerMinHealth/.
-- 
function GetPlayerMinHealth()
	print("EXAMPLEn_c.GetPlayerCurHealth(): playerMinHealth:", playerMinHealth)
	return playerMinHealth
end


---
-- Prints and returns the variable /playerMaxHealth/.
-- @return The player's maximum health from /playerMaxHealth/.
-- 
function GetPlayerMaxHealth()
	print("EXAMPLEn_c.GetPlayerCurHealth(): playerMaxHealth:", playerMaxHealth)
	return playerMaxHealth
end



function ScriptPostLoad()
	
    EnableSPScriptedHeroes()
    ScriptCB_EnableHeroMusic(0)
    
    SetClassProperty(gth_inf_trooper, "MaxHealth", 230*enemyDefenseBuff)
    SetClassProperty(gth_inf_trooper, "MaxShields", 520*enemyDefenseBuff)
    SetClassProperty(gth_inf_trooper, "MaxSpeed", "3.69")
    SetClassProperty(gth_inf_trooper, "MaxStrafeSpeed", "3.69")
    
    SetClassProperty(gth_inf_rocketeer, "MaxHealth", 250*enemyDefenseBuff)
    SetClassProperty(gth_inf_rocketeer, "MaxShields", 480*enemyDefenseBuff)
    SetClassProperty(gth_inf_rocketeer, "MaxSpeed", "3.69")
    SetClassProperty(gth_inf_rocketeer, "MaxStrafeSpeed", "3.69")
    
    SetClassProperty(gth_inf_sniper, "MaxHealth", 230*enemyDefenseBuff)
    SetClassProperty(gth_inf_sniper, "MaxShields", 500*enemyDefenseBuff)
    SetClassProperty(gth_inf_sniper, "MaxSpeed", "3.69")
    SetClassProperty(gth_inf_sniper, "MaxStrafeSpeed", "3.69")
    
    SetClassProperty(gth_inf_machinist, "MaxHealth", 230*enemyDefenseBuff)
    SetClassProperty(gth_inf_machinist, "MaxShields", 660*enemyDefenseBuff)
    SetClassProperty(gth_inf_machinist, "MaxSpeed", "3.69")
    SetClassProperty(gth_inf_machinist, "MaxStrafeSpeed", "3.69")
    
    SetClassProperty(gth_inf_shock, "MaxHealth", 400*enemyDefenseBuff)
    SetClassProperty(gth_inf_shock, "MaxShields", 550*enemyDefenseBuff)
    SetClassProperty(gth_inf_shock, "MaxSpeed", "3.105")
    SetClassProperty(gth_inf_shock, "MaxStrafeSpeed", "3.105")
    
    SetClassProperty(gth_inf_hunter, "MaxHealth", 300*enemyDefenseBuff)
    SetClassProperty(gth_inf_hunter, "MaxShields", 720*enemyDefenseBuff)
    SetClassProperty(gth_inf_hunter, "MaxSpeed", "3.15")
    SetClassProperty(gth_inf_hunter, "MaxStrafeSpeed", "3.15")
    
    SetClassProperty(gth_inf_destroyer, "MaxHealth", 700*enemyDefenseBuff)
    SetClassProperty(gth_inf_destroyer, "MaxShields", 720*enemyDefenseBuff)
    SetClassProperty(gth_inf_destroyer, "MaxSpeed", "2.295")
    SetClassProperty(gth_inf_destroyer, "MaxStrafeSpeed", "2.295")
    
    SetClassProperty(gth_inf_juggernaut, "MaxHealth", 900*enemyDefenseBuff)
    SetClassProperty(gth_inf_juggernaut, "MaxShields", 840*enemyDefenseBuff)
    SetClassProperty(gth_inf_juggernaut, "MaxSpeed", "2.16")
    SetClassProperty(gth_inf_juggernaut, "MaxStrafeSpeed", "2.16")
    
    SetClassProperty(gth_inf_prime, "MaxHealth", 2500*bossDefenseBuff)
    SetClassProperty(gth_inf_prime, "MaxShields", 3000*bossDefenseBuff)
    SetClassProperty(gth_inf_prime, "MaxSpeed", "2.20")
    SetClassProperty(gth_inf_prime, "MaxStrafeSpeed", "2.20")


    ScriptCB_SetGameRules("campaign")


    onfirstspawn = OnCharacterSpawn(
    function(character)
        if IsCharacterHuman(character) then
            ReleaseCharacterSpawn(onfirstspawn)
            onfirstspawn = nil
            ObjStart_timer = CreateTimer("ObjStart_timer")
            SetTimerValue(ObjStart_timer, 1)
            StartTimer(ObjStart_timer)
            CountDown = OnTimerElapse(
            function()
                BeginObjectives() 
                ReleaseTimerElapse(CountDown)
            end,
            ObjStart_timer
            )
        end
    end)

	--==========================
	-- CAPTURE THE BEACH
	--==========================

	--sets objective 
	Objective1CP = CommandPost:New{name = "beach_cp"}
	Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.aei.objectives.1", popupText = "level.aei.objectives.1_popup"}
	Objective1:AddCommandPost(Objective1CP)


	--tells what happens on start of your objective
	Objective1.OnStart = function(self)

	--sets AI-goal
	Ambush("squad_spawn", 10, SQD)
	Ambush("geth_beach_spawn", 16, GethPawns)
	AICanCaptureCP("beach_cp", SQD, false)
	AIGoalSQD = AddAIGoal(SQD, "Defend", 100, "beach_cp")
	AIGoalGethPawns = AddAIGoal(GethPawns, "Defend", 10, "beach_cp")
    	MapAddEntityMarker("beach_cp", "hud_objective_icon", 3.0, 1, "YELLOW", true)

	end

	-- says what happens after the objective is complete
	Objective1.OnComplete = function(self)

	DeleteAIGoal(AIGoalSQD)
    	MapRemoveEntityMarker("beach_cp")
	SetProperty("beach_cp", "CaptureRegion", "")
        ShowMessageText("game.objectives.complete", ATT)

	end

    function BeginObjectives()  
    	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 2.0}

    	objectiveSequence:AddObjectiveSet(Objective1)
    	objectiveSequence:Start() 

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
    
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\eur.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	PreLoadStuff()
	
	-- Player's squad's aggressiveness
	SetTeamAggressiveness(3, (squadAggro))
	
	-- The enemies' aggressiveness
	SetTeamAggressiveness(2, (enemyAggro))
	SetTeamAggressiveness(4, (enemyAggro))
	SetTeamAggressiveness(5, (enemyAggro))
	SetTeamAggressiveness(6, (enemyAggro))
	SetTeamAggressiveness(7, (enemyAggro))
	
	SetMinFlyHeight(-300)
	SetMinPlayerFlyHeight(-300)
    SetMaxFlyHeight(300)
    SetMaxPlayerFlyHeight(300)
    
	AISnipeSuitabilityDist(40)
	SetAttackerSnipeRange(35)
	SetDefenderSnipeRange(45)
    
    --
    -- Sides setup begin
    --
    
	LoadSSV(true)
	LoadGTH()
	
	
	SetupTeams{
		-- Player classes
		
		rep = {
			team = REP,
			units = 1,
			reinforcements = playerLives,
			soldier  = { "ssv_inf_cooper_soldier",0, 1},
			sniper  = { "ssv_inf_cooper_infiltrator",0, 1},
			adept = { "ssv_inf_cooper_adept",0, 1},
			engineer   = { "ssv_inf_cooper_engineer",0, 1},
			sentinel = { "ssv_inf_cooper_sentinel",0, 1},
			vanguard = { "ssv_inf_cooper_vanguard",0, 1},
		},
		
		-- Player squad team classes
		
		sqd = {
			team = SQD,
			units = 10,
			reinforcements = -1,
			soldier  = { ssv_inf_soldier,4},
			sniper  = { ssv_inf_infiltrator,1},
			adept = { ssv_inf_adept,1},
			engineer   = { ssv_inf_engineer,2},
			sentinel = { ssv_inf_sentinel,1},
			vanguard = { ssv_inf_vanguard,1},
		},
	    
	    -- Geth classes
		
		--[[husks = {
			team = GethHusks,
			units = 100,
			reinforcements = -1,
			soldier = { "indoc_inf_husk",9, 12},
		},]]
		
		pawns = {
			team = GethPawns,
			units = 16,
			reinforcements = -1,
			soldier = { gth_inf_trooper,7},		-- 9, 12
			rocketeer = { gth_inf_rocketeer,3},	-- 5, 8
			sniper = { gth_inf_sniper,5},	-- 9, 16
			hunter = { gth_inf_hunter,1},	-- 7, 14
		},
		
		tacticals = {
			team = GethTacticals,
			units = 100,
			reinforcements = -1,
			sniper = { gth_inf_sniper,9, 60},	-- 9, 16
			hunter = { gth_inf_hunter,7, 60},	-- 7, 14
		},
		
		specials = {
			team = GethSpecials,
			units = 100,
			reinforcements = -1,
			engineer = { gth_inf_machinist,5, 60},	-- 5, 12
			shock = { gth_inf_shock,7, 60},			-- 7, 15
		},
		
		heavys = {
			team = GethHeavys,
			units = 100,
			reinforcements = -1,
			destroyer = { gth_inf_destroyer,7, 60},		-- 7, 14
			juggernaut = { gth_inf_juggernaut,5, 60},	-- 5, 12
		},
		
		primes = {
			team = GethPrimes,
			units = 100,
			reinforcements = -1,
			prime = { gth_inf_prime,2, 2},	-- 2, 2
		}
	}
	
	SetTeamName(SQD, "rep")
    
    -- Team relationships
    
    SetTeamAsFriend(REP, SQD)
	SetTeamAsFriend(SQD, REP)
	
--	SetTeamAsFriend(GethHusks, GethPawns)
--	SetTeamAsFriend(GethHusks, GethTacticals)
--	SetTeamAsFriend(GethHusks, GethSpecials)
--	SetTeamAsFriend(GethHusks, GethHeavys)
--	SetTeamAsFriend(GethHusks, GethPrimes)
--	SetTeamAsFriend(GethPawns, GethHusks)
	SetTeamAsFriend(GethPawns, GethTacticals)
	SetTeamAsFriend(GethPawns, GethSpecials)
	SetTeamAsFriend(GethPawns, GethHeavys)
	SetTeamAsFriend(GethPawns, GethPrimes)
--	SetTeamAsFriend(GethTacticals, GethHusks)
	SetTeamAsFriend(GethTacticals, GethPawns)
	SetTeamAsFriend(GethTacticals, GethSpecials)
	SetTeamAsFriend(GethTacticals, GethHeavys)
	SetTeamAsFriend(GethTacticals, GethPrimes)
--	SetTeamAsFriend(GethSpecials, GethHusks)
	SetTeamAsFriend(GethSpecials, GethPawns)
	SetTeamAsFriend(GethSpecials, GethTacticals)
	SetTeamAsFriend(GethSpecials, GethHeavys)
	SetTeamAsFriend(GethSpecials, GethPrimes)
--	SetTeamAsFriend(GethHeavys, GethHusks)
	SetTeamAsFriend(GethHeavys, GethPawns)
	SetTeamAsFriend(GethHeavys, GethTacticals)
	SetTeamAsFriend(GethHeavys, GethSpecials)
	SetTeamAsFriend(GethHeavys, GethPrimes)
--	SetTeamAsFriend(GethPrimes, GethHusks)
	SetTeamAsFriend(GethPrimes, GethPawns)
	SetTeamAsFriend(GethPrimes, GethTacticals)
	SetTeamAsFriend(GethPrimes, GethSpecials)
	SetTeamAsFriend(GethPrimes, GethHeavys)
	
--	SetTeamAsEnemy(REP, GethHusks)
	SetTeamAsEnemy(REP, GethPawns)
	SetTeamAsEnemy(REP, GethTacticals)
	SetTeamAsEnemy(REP, GethSpecials)
	SetTeamAsEnemy(REP, GethHeavys)
	SetTeamAsEnemy(REP, GethPrimes)
--	SetTeamAsEnemy(SQD, GethHusks)
	SetTeamAsEnemy(SQD, GethPawns)
	SetTeamAsEnemy(SQD, GethTacticals)
	SetTeamAsEnemy(SQD, GethSpecials)
	SetTeamAsEnemy(SQD, GethHeavys)
	SetTeamAsEnemy(SQD, GethPrimes)
	
--	SetTeamAsEnemy(GethHusks, REP)
--	SetTeamAsEnemy(GethHusks, SQD)
	SetTeamAsEnemy(GethPawns, REP)
	SetTeamAsEnemy(GethPawns, SQD)
	SetTeamAsEnemy(GethTacticals, REP)
	SetTeamAsEnemy(GethTacticals, SQD)
	SetTeamAsEnemy(GethSpecials, REP)
	SetTeamAsEnemy(GethSpecials, SQD)
	SetTeamAsEnemy(GethHeavys, REP)
	SetTeamAsEnemy(GethHeavys, SQD)
	SetTeamAsEnemy(GethPrimes, REP)
	SetTeamAsEnemy(GethPrimes, SQD)
	
	--
	-- Sides setup end
	--
	
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1217)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 87)
    SetMemoryPoolSize("Music", 89)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 410)
    SetMemoryPoolSize("SoundSpaceRegion", 100)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:AEI\\AEI.lvl", "AEI_campaign")
    SetDenseEnvironment("true")
    --AddDeathRegion("deathregion")
	
	
    -- Sound
    
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl")
	
	--musicStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl",  "ME5n_music_EUR")
	--stingerStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl",  "ME5n_stingers_EUR")
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl", "ME5n_music_EUR", stingerStream)
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl", "ME5n_stingers_EUR", musicStream)
	
	--ambientStream1 = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	--ambientStream2 = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl", "EUR_prop_ambiance", ambientStream)
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	
	SetVictoryMusic(REP, "eur_amb_01_victory")
	SetDefeatMusic (REP, "eur_amb_01_defeat")
	SetVictoryMusic(CIS, "eur_amb_01_victory")
	SetDefeatMusic (CIS, "eur_amb_01_defeat")
	
	SetAttackingTeam(ATT)
	
    SoundFX()
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl")
	
	
	-- Opening satellite shots
	AddCameraShot(-0.461276, -0.061869, -0.877234, 0.117716, -51.108570, 127.905670, 150.074707);
	
	PostLoadStuff()
end