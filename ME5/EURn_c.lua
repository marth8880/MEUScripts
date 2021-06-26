ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
local bDebug = false
local mapDebug = false
gLoadCooper = true
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")

-- Override the faction combination set in the Config Tool
ME5_SideVar = 1

ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_MultiObjectiveContainer")
ScriptCB_DoFile("ME5_ObjectiveAssault")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("ME5_ObjectiveGoto")
ScriptCB_DoFile("ME5_CinematicContainer")
ScriptCB_DoFile("ME5_CameraManager")
ScriptCB_DoFile("ME5_CombatManager")
--ScriptCB_DoFile("ME5_CinematicOverlayIFS")
ScriptCB_DoFile("Ambush")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,
	gameMode = "campaign",
	mapSize = "xs",
	environmentType = "urban",
}
-- Initialize the MapManager
manager:Init()

-- Initialize teams
REP = 1	-- The player's team.
CIS = 2	-- Team for Geth Troopers and Rocketeers. Note: synonymous with teamID `GethPawns`.
SQD = 3	-- Team for the player's squad.
GethHusks = 0	-- Team for Husks. (DEPRECATED)
GethPawns = CIS	-- Team for Geth Troopers and Rocketeers. Note: synonymous with teamID `CIS`.
GethTacticals = 4	-- Team for Geth Snipers and Hunters.
GethSpecials = 5	-- Team for Geth Machinists and Shock Troopers.
GethHeavys = 6	-- Team for Geth Destroyers and Juggernauts.
GethPrimes = 7	-- Team for Geth Primes.

ATT = 1
DEF = 2

local playerLives = 10	-- The amount of lives the player has. A value of -1 denotes infinite lives.

local playerMaxHealth = nil	-- The player's max health for their current class.
local playerMinHealth = nil	-- The value to restore the player's health to after every combat zone.
local playerCurHealth = nil	-- The player's current health.

local playerHealthThreshold = 0.4	-- The percentage form of playerMinHealth. Must be > playerHealthThreshold in Init_LowHealthFeedback().
local playerHealthAddRate = 50		-- The amount of health that is restored to the player per second.

local squadDefenseBuff = nil	-- The multiplier for the player's squad's health/shields.
local enemyDefenseBuff = nil	-- The multiplier for the enemy units' health/shields.
local bossDefenseBuff = nil		-- The multiplier for the final boss.

local squadAggro = nil		-- The aggressiveness of the player's squad.
local enemyAggro = nil		-- The aggressiveness of the enemy units.
local bossAggro = nil		-- The aggressiveness of the final boss.

local bInCombat = false			-- Is the player currently in combat?
local currentZoneID = "none"	-- What is the name ID of the current combat zone?

local numCinematicShakes = 0		-- How many cinematic shakes have occurred?
local camShakeCharUnit = nil		-- The player character unit.

local bConsoleWorkaround = true

SmartSpawn_curAllySpawn = nil
SmartSpawn_curEnemySpawn = nil

GethPawns_Stats = {}
GethTacticals_Stats = {}
GethSpecials_Stats = {}
GethHeavys_Stats = {}
GethPrimes_Stats = {}


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

-- Table of all enemy deployable turrets.
enemyBuildingClasses = {	"gth_bldg_assaultdrone", 
							"gth_bldg_gethturret", 
							"gth_bldg_rocketdrone", 
							"gth_weap_inf_hexshield", 
							"gth_weap_inf_hexshield_jug", 
							"weap_tech_combatdronetur_incinerate", 
							"weap_tech_combatdronetur_rocket", 
							"weap_tech_combatdronetur_shock"}

-- Table of all door objects in sublevel 0.
doors_S0	= {  -- Hangar
				"hangar_doors_exit", 
				
				 -- Cargo Bay
				"cargo_doors_exit", 
				
				 -- Reception
				"reception_doors_enter", 
				"reception_doors_exit", 
				
				 -- Management
				"management_doors_enter", 
				"management_doors_exit", 
				
				 -- Power Control
				"power_doors_enter", 
				
				 -- Comms Control
				"comms_doors_enter" }

-- Table of all door objects in sublevel 1.
doors_S1	= {  -- Main Atrium
				"s1atrium_doors_enter", 
				"s1atrium_doors_exit", 
				
				 -- Marine Life Lab
				"s1biolab_doors_enter", 
				"s1biolab_doors_exit", 
				
				 -- Ice Samples Lab
				"icelab_doors_enter", 
				"icelab_doors_exit" }

-- Table of all door objects in sublevel 2.
doors_S2	= {  -- Main Atrium
				"s3atrium_doors_enter", 
				"s3atrium_doors_exit1", 
				"s3atrium_doors_exit2", 
				
				 -- Marine Life Lab
				"s3biolab_doors_enter", 
				--"s3biolab_doors_exit", 
				
				 -- Hydrothermal Energy Lab
				"energylab_doors_enter", 
				"energylab_doors_exit" }

-- Table of all door objects in sublevel 3.
doors_S3	= {  -- Main Atrium
				"s4atrium_doors_enter", 
				"s4atrium_doors_exit", 
				
				 -- Geomicrobiology Lab
				"geolab_doors_enter", 
				"geolab_doors_exit", 
				
				 -- Seismology Lab
				"seismolab_doors_enter", 
				"seismolab_doors_exit" }

-- Table of all door block objects in sublevel 0.
doorBlocks_S0	= {  -- Hangar
					"hangar_doors_exit_block", 
					
					 -- Cargo Bay
					"cargo_doors_exit_block", 
					
					 -- Reception
					"reception_doors_enter_block", 
					"reception_doors_exit_block", 
					
					 -- Management
					"management_doors_enter_block", 
					"management_doors_exit_block", 
					
					 -- Power Control
					"power_doors_enter_block", 
					
					 -- Comms Control
					"comms_doors_enter_block" }

-- Table of all door block objects in sublevel 1.
doorBlocks_S1	= {  -- Main Atrium
					"s1atrium_doors_enter_block", 
					"s1atrium_doors_exit_block", 
					
					 -- Marine Life Lab
					"s1biolab_doors_enter_block", 
					"s1biolab_doors_exit_block", 
					
					 -- Ice Samples Lab
					"icelab_doors_enter_block", 
					"icelab_doors_exit_block" }

-- Table of all door block objects in sublevel 2.
doorBlocks_S2	= {  -- Main Atrium
					"s3atrium_doors_enter_block", 
					"s3atrium_doors_exit1_block", 
					"s3atrium_doors_exit2_block", 
					
					 -- Marine Life Lab
					"s3biolab_doors_enter_block", 
					--"s3biolab_doors_exit_block", 
					
					 -- Hydrothermal Energy Lab
					"energylab_doors_enter_block", 
					"energylab_doors_exit_block" }

-- Table of all door block objects in sublevel 3.
doorBlocks_S3	= {  -- Main Atrium
					"s4atrium_doors_enter_block", 
					"s4atrium_doors_exit_block", 
					
					 -- Geomicrobiology Lab
					"geolab_doors_enter_block", 
					"geolab_doors_exit_block", 
					
					 -- Seismology Lab
					"seismolab_doors_enter_block", 
					"seismolab_doors_exit_block" }


---
-- Locks the doors, enables the barriers, and blocks the planning connections in given sublevel /sublevelID/.
-- @param #int sublevelID	The numerical ID of the sublevel to block.
-- 
function BlockCombatZoneExits(sublevelID)
	print("EURn_c.BlockCombatZoneExits("..sublevelID.."): Entered")
	
	if sublevelID == 0 then
		print("EURn_c.BlockCombatZoneExits(): Blocking barriers")
		
		-- Barriers
    	EnableBarriers("Bar_Hangar1")
    	EnableBarriers("Bar_Cargo1")
    	EnableBarriers("Bar_Reception1")
    	EnableBarriers("Bar_Reception1")
    	EnableBarriers("Bar_Management1")
    	EnableBarriers("Bar_Management2")
    	EnableBarriers("Bar_Comms1")
    	EnableBarriers("Bar_Power1")
		
		print("EURn_c.BlockCombatZoneExits(): Blocking planning graphs")
    	
    	-- Planning connections
    	BlockPlanningGraphArcs(1)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.BlockCombatZoneExits(): Locking doors")
		
		-- Lock all of the doors
		for i in pairs(doors_S0) do
			SetProperty(doors_S0[i], "IsLocked", "1")
		end
		
		-- Activate all of the door blocks
		for i in pairs(doorBlocks_S0) do
			SetProperty(doorBlocks_S0[i], "MaxHealth", 9999999999)
			SetProperty(doorBlocks_S0[i], "CurHealth", 9999999999)
		end
		
		print("EURn_c.BlockCombatZoneExits(): Done")
    	
	elseif sublevelID == 1 then
		print("EURn_c.BlockCombatZoneExits(): Blocking barriers")
		
		-- Barriers
    	EnableBarriers("Bar_S1Atrium1")
    	EnableBarriers("Bar_S1Atrium2")
    	EnableBarriers("Bar_S1Biolab1")
    	EnableBarriers("Bar_S1Biolab2")
    	EnableBarriers("Bar_Icelab1")
    	EnableBarriers("Bar_Icelab2")
		
		print("EURn_c.BlockCombatZoneExits(): Blocking planning graphs")
    	
    	-- Planning connections
    	BlockPlanningGraphArcs(2)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.BlockCombatZoneExits(): Locking doors")
		
		-- Lock all of the doors
		for i in pairs(doors_S1) do
			SetProperty(doors_S1[i], "IsLocked", "1")
		end
		
		-- Activate all of the door blocks
		for i in pairs(doorBlocks_S1) do
			SetProperty(doorBlocks_S1[i], "MaxHealth", 9999999999)
			SetProperty(doorBlocks_S1[i], "CurHealth", 9999999999)
		end
		
		print("EURn_c.BlockCombatZoneExits(): Done")
		
	elseif sublevelID == 2 then
		print("EURn_c.BlockCombatZoneExits(): Blocking barriers")
		
		-- Barriers
    	EnableBarriers("Bar_S3Atrium1")
    	EnableBarriers("Bar_S3Atrium2")
    	EnableBarriers("Bar_S3Biolab1")
    	EnableBarriers("Bar_Energylab1")
    	EnableBarriers("Bar_Energylab2")
		
		print("EURn_c.BlockCombatZoneExits(): Blocking planning graphs")
    	
    	-- Planning connections
    	BlockPlanningGraphArcs(3)
		
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.BlockCombatZoneExits(): Locking doors")
		
		-- Lock all of the doors
		for i in pairs(doors_S2) do
			SetProperty(doors_S2[i], "IsLocked", "1")
		end
		
		-- Activate all of the door blocks
		for i in pairs(doorBlocks_S2) do
			SetProperty(doorBlocks_S2[i], "MaxHealth", 9999999999)
			SetProperty(doorBlocks_S2[i], "CurHealth", 9999999999)
		end
		
		print("EURn_c.BlockCombatZoneExits(): Done")
		
	elseif sublevelID == 3 then
		print("EURn_c.BlockCombatZoneExits(): Blocking barriers")
		
		-- Barriers
    	EnableBarriers("Bar_S4Atrium1")
    	EnableBarriers("Bar_S4Atrium2")
    	EnableBarriers("Bar_Geolab1")
    	EnableBarriers("Bar_Geolab2")
    	EnableBarriers("Bar_Seismolab1")
    	EnableBarriers("Bar_Seismolab2")
    	EnableBarriers("Bar_Caves_Enter")
    	EnableBarriers("Bar_Caves1a")
    	EnableBarriers("Bar_Caves1b")
    	EnableBarriers("Bar_Caves1c")
    	EnableBarriers("Bar_Caves2a")
    	EnableBarriers("Bar_Caves2b")
    	EnableBarriers("Bar_Caves3a")
    	EnableBarriers("Bar_Caves3b")
    	EnableBarriers("Bar_CavesBoss")
		
		print("EURn_c.BlockCombatZoneExits(): Blocking planning graphs")
    	
    	-- Planning connections
    	BlockPlanningGraphArcs(4)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.BlockCombatZoneExits(): Locking doors")
		
		-- Lock all of the doors
		for i in pairs(doors_S3) do
			SetProperty(doors_S3[i], "IsLocked", "1")
		end
		
		-- Activate all of the door blocks
		for i in pairs(doorBlocks_S3) do
			SetProperty(doorBlocks_S3[i], "MaxHealth", 9999999999)
			SetProperty(doorBlocks_S3[i], "CurHealth", 9999999999)
		end
		
		print("EURn_c.BlockCombatZoneExits(): Done")
		
	else
		print("EURn_c.BlockCombatZoneExits(): Argument #0  sublevelID  out of range!")
	end
end

---
-- Unlocks the doors, disables the barriers, and unblocks the planning connections in given sublevel /sublevelID/.
-- @param #int sublevelID	The numerical ID of the sublevel to unblock.
-- 
function UnblockCombatZoneExits(sublevelID)
	print("EURn_c.UnblockCombatZoneExits("..sublevelID.."): Entered")
	
	if sublevelID == 0 then
		print("EURn_c.UnblockCombatZoneExits(): Unblocking barriers")
		
		-- Barriers
    	DisableBarriers("Bar_Hangar1")
    	DisableBarriers("Bar_Cargo1")
    	DisableBarriers("Bar_Reception1")
    	DisableBarriers("Bar_Reception1")
    	DisableBarriers("Bar_Management1")
    	DisableBarriers("Bar_Management2")
    	DisableBarriers("Bar_Comms1")
    	DisableBarriers("Bar_Power1")
		
		print("EURn_c.UnblockCombatZoneExits(): Unblocking planning graphs")
    	
    	-- Planning connections
    	UnblockPlanningGraphArcs(1)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.UnblockCombatZoneExits(): Unlocking doors")
		
		-- Unlock all of the doors
		for i in pairs(doors_S0) do
			SetProperty(doors_S0[i], "IsLocked", "0")
		end
		
		-- Deactivate all of the door blocks
		for i in pairs(doorBlocks_S0) do
			SetProperty(doorBlocks_S0[i], "CurHealth", 0)
		end
		
		print("EURn_c.UnblockCombatZoneExits(): Done")
    	
	elseif sublevelID == 1 then
		print("EURn_c.UnblockCombatZoneExits(): Unblocking barriers")
		
		-- Barriers
    	DisableBarriers("Bar_S1Atrium1")
    	DisableBarriers("Bar_S1Atrium2")
    	DisableBarriers("Bar_S1Biolab1")
    	DisableBarriers("Bar_S1Biolab2")
    	DisableBarriers("Bar_Icelab1")
    	DisableBarriers("Bar_Icelab2")
		
		print("EURn_c.UnblockCombatZoneExits(): Unblocking planning graphs")
    	
    	-- Planning connections
    	UnblockPlanningGraphArcs(2)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.UnblockCombatZoneExits(): Unlocking doors")
		
		-- Unlock all of the doors
		for i in pairs(doors_S1) do
			SetProperty(doors_S1[i], "IsLocked", "0")
		end
		
		-- Deactivate all of the door blocks
		for i in pairs(doorBlocks_S1) do
			SetProperty(doorBlocks_S1[i], "CurHealth", 0)
		end
		
		print("EURn_c.UnblockCombatZoneExits(): Done")
		
	elseif sublevelID == 2 then
		print("EURn_c.UnblockCombatZoneExits(): Unblocking barriers")
		
		-- Barriers
    	DisableBarriers("Bar_S3Atrium1")
    	DisableBarriers("Bar_S3Atrium2")
    	DisableBarriers("Bar_S3Biolab1")
    	DisableBarriers("Bar_Energylab1")
    	DisableBarriers("Bar_Energylab2")
		
		print("EURn_c.UnblockCombatZoneExits(): Unblocking planning graphs")
    	
    	-- Planning connections
    	UnblockPlanningGraphArcs(3)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.UnblockCombatZoneExits(): Unlocking doors")
		
		-- Unlock all of the doors
		for i in pairs(doors_S2) do
			SetProperty(doors_S2[i], "IsLocked", "0")
		end
		
		-- Deactivate all of the door blocks
		for i in pairs(doorBlocks_S2) do
			SetProperty(doorBlocks_S2[i], "CurHealth", 0)
		end
		
		print("EURn_c.UnblockCombatZoneExits(): Done")
		
	elseif sublevelID == 3 then
		print("EURn_c.UnblockCombatZoneExits(): Unblocking barriers")
		
		-- Barriers
    	DisableBarriers("Bar_S4Atrium1")
    	DisableBarriers("Bar_S4Atrium2")
    	DisableBarriers("Bar_Geolab1")
    	DisableBarriers("Bar_Geolab2")
    	DisableBarriers("Bar_Seismolab1")
    	DisableBarriers("Bar_Seismolab2")
    	DisableBarriers("Bar_Caves_Enter")
    	DisableBarriers("Bar_Caves1a")
    	DisableBarriers("Bar_Caves1b")
    	DisableBarriers("Bar_Caves1c")
    	DisableBarriers("Bar_Caves2a")
    	DisableBarriers("Bar_Caves2b")
    	DisableBarriers("Bar_Caves3a")
    	DisableBarriers("Bar_Caves3b")
    	DisableBarriers("Bar_CavesBoss")
		
		print("EURn_c.UnblockCombatZoneExits(): Unblocking planning graphs")
    	
    	-- Planning connections
    	UnblockPlanningGraphArcs(4)
		
		
		--==================
		-- DOOR STUFF
		--==================
		
		print("EURn_c.UnblockCombatZoneExits(): Unlocking doors")
		
		-- Unlock all of the doors
		for i in pairs(doors_S3) do
			SetProperty(doors_S3[i], "IsLocked", "0")
		end
		
		-- Deactivate all of the door blocks
		for i in pairs(doorBlocks_S3) do
			SetProperty(doorBlocks_S3[i], "CurHealth", 0)
		end
		
		print("EURn_c.UnblockCombatZoneExits(): Done")
		
	else
		print("EURn_c.UnblockCombatZoneExits(): Argument #0  sublevelID  out of range!")
	end
end


---
-- Sets the path /spawnPathName/ that the player and allied teams should respawn at.
-- @param #string spawnPathName		The name of the path to spawn at.
-- 
function SetRespawnPoint(spawnPathName)

	local pathName = spawnPathName
	
	-- Quit function if pathName is nil
	if pathName == nil then
		print("EURn_c.SetRespawnPoint(): Failed! Argument #0  spawnPathName  cannot be nil!")
	return end
	
	print("EURn_c.SetRespawnPoint(): Setting player respawn point to "..pathName)
	
	SetProperty("cp1", "SpawnPath", pathName)
	SetProperty("cp1", "AllyPath", pathName)
end


---
-- Sets the path /spawnPathName/ that the player should respawn at.
-- @param #string spawnPathName		The name of the path to spawn at.
-- 
function SetRespawnPointPlayer(spawnPathName)

	local pathName = spawnPathName
	
	-- Quit function if pathName is nil
	if pathName == nil then
		print("EURn_c.SetRespawnPoint(): Failed! Argument #0  spawnPathName  cannot be nil!")
	return end
	
	print("EURn_c.SetRespawnPoint(): Setting player respawn point to "..pathName)
	
	SetProperty("cp1", "SpawnPath", pathName)
end


---
-- Sets the path /spawnPathName/ that allied teams should respawn at.
-- @param #string spawnPathName		The name of the path to spawn at.
-- 
function SetRespawnPointSquad(spawnPathName)

	local pathName = spawnPathName
	
	-- Quit function if pathName is nil
	if pathName == nil then
		print("EURn_c.SetRespawnPoint(): Failed! Argument #0  spawnPathName  cannot be nil!")
	return end
	
	print("EURn_c.SetRespawnPoint(): Setting player respawn point to "..pathName)
	
	SetProperty("cp1", "AllyPath", pathName)
end


---
-- Sets up the combat zone /zoneID/.
-- @param #string combatZoneID		The name ID of the zone to set up.
-- @param #string combatMusicID		The music ID to start playing. Use "none" if no music change desired.
-- 
function SetupCombatZoneInit(combatZoneID, combatMusicID)
		print("EURn_c.SetupCombatZoneInit(): Entered")
	if not InCombat() then
		-- Make sure we can't be called again while already in a WaveSequence
		bInCombat = true
		
		local zoneID = combatZoneID
		local musicID = combatMusicID
		bDebug = mapDebug
		
		print("EURn_c.SetupCombatZoneInit(): Setting up combat zone "..zoneID)
		
		-- Is debug enabled?
		if bDebug == true then
			ShowMessageText("level.EUR.debug.comzone_entered", REP)
			ShowMessageText("level.EUR.debug.comzone_spawning", REP)
		end
		
		-- Was a value entered for combatMusicID?
		if musicID ~= "none" then
			-- Start playing combat music
			ScriptCB_PlayInGameMusic(musicID)
		else
			print("EURn_c.SetupCombatZoneInit(): combatMusicID not specified! Continuing...")
		end
		
		ClearAIGoals(SQD)
		AddAIGoal(SQD, "Deathmatch", 100)
		
		
		if zoneID == "S0_Hangar" then
			
			SmartSpawner = SmartSpawn:New{ regionName = "cz_s0_hangar", allySpawnIn = "ps_s0_hangar", allySpawnOut = "ps_s0_hangar", 
																		enemySpawnIn = "es_s0_hangar", enemySpawnOut = "es_s0_hangar",
																		bDebug = mapDebug }
			
			Wave_1 = CombatWave:New{ team = GethPawns,	numDudes = 2, spawnValue = 2 }
			Wave_2 = CombatWave:New{ team = GethPawns,	numDudes = 2, spawnValue = 2 }
			Wave_3 = CombatWave:New{ team = GethPawns,	numDudes = 2, spawnValue = 2 }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddSmartSpawn(SmartSpawner)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(0)
			
			ResetTeamMemberLocations(SQD, "ps_s0_hangar")
			
		elseif zoneID == "S0_CargoBay" then
			
			SmartSpawner = SmartSpawn:New{ regionName = "cz_s0_cargo", allySpawnIn = "ps_s0_cargo", allySpawnOut = "ps_s0_cargo", 
																		enemySpawnIn = "es_s0_cargo", enemySpawnOut = "es_s0_cargo",
																		bDebug = mapDebug }
			
			Wave_1 = CombatWave:New{ team = GethPawns,	numDudes = 4, spawnValue = 2 }
			Wave_2 = CombatWave:New{ team = GethPawns,	numDudes = 3, spawnValue = 3 }
			Wave_3 = CombatWave:New{ team = GethPawns,	numDudes = 3, spawnValue = 3 }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddSmartSpawn(SmartSpawner)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(0)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s0_cargo")
			
		elseif zoneID == "S0_Reception" then
			
			SmartSpawner = SmartSpawn:New{ regionName = "cz_s0_reception", allySpawnIn = "ps_s0_reception", allySpawnOut = "ps_s0_reception", 
																		enemySpawnIn = "es_s0_reception", enemySpawnOut = "es_s0_reception",
																		bDebug = mapDebug }
			
			Wave_1 = CombatWave:New{ team = GethPawns,	numDudes = 4, spawnValue = 2 }
			Wave_2 = CombatWave:New{ team = GethPawns,	numDudes = 3, spawnValue = 3 }
			Wave_3 = CombatWave:New{ team = GethPawns,	numDudes = 3, spawnValue = 3 }
			Wave_4 = CombatWave:New{ team = GethPawns,	numDudes = 2, spawnValue = 2 }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddSmartSpawn(SmartSpawner)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(0)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s0_reception")
			
		elseif zoneID == "S0_Management" then
			
			SmartSpawner = SmartSpawn:New{ regionName = "cz_s0_management", allySpawnIn = "ps_s0_management_in", allySpawnOut = "ps_s0_management_out", 
																		enemySpawnIn = "es_s0_management_in", enemySpawnOut = "es_s0_management_out",
																		bDebug = mapDebug }
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2 }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3 }
			Wave_3 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3 }
			Wave_4 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 2 }
			Wave_5 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 2 }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddSmartSpawn(SmartSpawner)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(0)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s0_management_in")
			
		elseif zoneID == "S0_PowerControl" then
			
			SmartSpawner = SmartSpawn:New{ regionName = "cz_s0_power", allySpawnIn = "ps_s0_power_in", allySpawnOut = "ps_s0_power_out", 
																		enemySpawnIn = "es_s0_power_in", enemySpawnOut = "es_s0_power_out",
																		bDebug = mapDebug }
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 6, spawnValue = 3 }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3 }
			Wave_3 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3 }
			Wave_4 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3 }
			Wave_5 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 3 }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddSmartSpawn(SmartSpawner)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(0)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s0_power_in")
			
		elseif zoneID == "S0_CommsControl" then
			
			SmartSpawner = SmartSpawn:New{ regionName = "cz_s0_comms", allySpawnIn = "ps_s0_comms_in", allySpawnOut = "ps_s0_comms_out", 
																		enemySpawnIn = "es_s0_comms_in", enemySpawnOut = "es_s0_comms_out",
																		bDebug = mapDebug }
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s0_comms" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s0_comms" }
			Wave_3 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s0_comms" }
			Wave_4 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s0_comms" }
			Wave_5 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 2, spawnPath = "es_s0_comms" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddSmartSpawn(SmartSpawner)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(0)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s0_comms_in")
			
		elseif zoneID == "S1_MainAtrium" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 5, spawnValue = 2, spawnPath = "es_s1_atrium" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_atrium" }
			Wave_3 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_atrium" }
			Wave_4 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_atrium" }
			Wave_5 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_atrium" }
			Wave_6 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_atrium" }
			Wave_7 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_atrium" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(1)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s1_atrium")
			
		elseif zoneID == "S1_MarineLifeLab" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 5, spawnValue = 2, spawnPath = "es_s1_biolab_1" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2, spawnPath = "es_s1_biolab_1" }
			Wave_3 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_1" }
			Wave_4 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_1" }
			Wave_5 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_1" }
			Wave_6 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_2" }
			Wave_7 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_1" }
			Wave_8 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_2" }
			Wave_9 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_biolab_1" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:AddWave(Wave_8)
			CombatSequence:AddWave(Wave_9)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(1)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s1_biolab")
			
		elseif zoneID == "S1_IceSamplesLab" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2, spawnPath = "es_s1_icelab" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_icelab" }
			Wave_3 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_icelab" }
			Wave_4 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_icelab" }
			Wave_5 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_icelab" }
			Wave_6 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s1_icelab" }
			Wave_7 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s1_icelab" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(1)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s1_icelab")
			
		elseif zoneID == "S3_MainAtrium" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 5, spawnValue = 3, spawnPath = "es_s3_atrium_1" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 2, spawnPath = "es_s3_atrium_1" }
			Wave_3 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_1" }
			Wave_4 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_1" }
			Wave_5 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_2" }
			Wave_6 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_1" }
			Wave_7 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_2" }
			Wave_8 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_1" }
			Wave_9 = CombatWave:New{ team = GethHeavys,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_atrium_1" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:AddWave(Wave_8)
			CombatSequence:AddWave(Wave_9)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(2)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s3_atrium")
			
		elseif zoneID == "S3_MarineLifeLab" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2, spawnPath = "es_s3_biolab_1" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2, spawnPath = "es_s3_biolab_1" }
			Wave_3 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_biolab_1" }
			Wave_4 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_biolab_1" }
			Wave_5 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_biolab_2" }
			Wave_6 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_biolab_1" }
			Wave_7 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_biolab_1" }
			Wave_8 = CombatWave:New{ team = GethHeavys,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_biolab_1" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:AddWave(Wave_8)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(2)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s3_biolab")
			
		elseif zoneID == "S3_EnergyLab" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2, spawnPath = "es_s3_energylab_1" }
			Wave_2 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_energylab_1" }
			Wave_3 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_energylab_1" }
			Wave_4 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_energylab_1" }
			Wave_5 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_energylab_2" }
			Wave_6 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s3_energylab_2" }
			Wave_7 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s3_energylab_1" }
			Wave_8 = CombatWave:New{ team = GethHeavys,		numDudes = 2, spawnValue = 3, spawnPath = "es_s3_energylab_2" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:AddWave(Wave_8)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(2)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s3_energylab")
			
		elseif zoneID == "S4_MainAtrium" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 4, spawnValue = 2, spawnPath = "es_s4_atrium_1" }
			Wave_2 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_atrium_1" }
			Wave_3 = CombatWave:New{ team = GethPawns,		numDudes = 3, spawnValue = 3, spawnPath = "es_s4_atrium_1" }
			Wave_4 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_atrium_1" }
			Wave_5 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_atrium_1" }
			Wave_6 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_atrium_1" }
			Wave_7 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_atrium_1" }
			Wave_8 = CombatWave:New{ team = GethHeavys,		numDudes = 2, spawnValue = 2, spawnPath = "es_s4_atrium_1" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:AddWave(Wave_8)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s3_atrium")
			
		elseif zoneID == "S4_SeismoLab" then
			
			Wave_1 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 2, spawnPath = "es_s4_seismolab_1" }
			Wave_2 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_seismolab_1" }
			Wave_3 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_seismolab_1" }
			Wave_4 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_seismolab_1" }
			Wave_5 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_seismolab_1" }
			Wave_6 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_seismolab_1" }
			Wave_7 = CombatWave:New{ team = GethHeavys,		numDudes = 2, spawnValue = 2, spawnPath = "es_s4_seismolab_1" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s4_seismolab")
			
		elseif zoneID == "S4_GeoLab" then
			
			Wave_1 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			Wave_2 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			Wave_3 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			Wave_4 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			Wave_5 = CombatWave:New{ team = GethTacticals,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			Wave_6 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			Wave_7 = CombatWave:New{ team = GethHeavys,		numDudes = 3, spawnValue = 3, spawnPath = "es_s4_geolab_1" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:AddWave(Wave_3)
			CombatSequence:AddWave(Wave_4)
			CombatSequence:AddWave(Wave_5)
			CombatSequence:AddWave(Wave_6)
			CombatSequence:AddWave(Wave_7)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			ResetTeamMemberLocations(SQD, "ps_s4_geolab")
			
		elseif zoneID == "S4_Caves_1a" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 1, spawnPath = "es_s4_caves_1a" }
			Wave_2 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_caves_1a" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			--ResetTeamMemberLocations(SQD, "ps_s4_caves")
			
		elseif zoneID == "S4_Caves_1b" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 1, spawnPath = "es_s4_caves_1b" }
			Wave_2 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_caves_1b" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			--ResetTeamMemberLocations(SQD, "ps_s4_caves")
			
		elseif zoneID == "S4_Caves_1c" then
			
			Wave_1 = CombatWave:New{ team = GethPawns,		numDudes = 2, spawnValue = 1, spawnPath = "es_s4_caves_1c" }
			Wave_2 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_caves_1c" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			--ResetTeamMemberLocations(SQD, "ps_s4_caves")
			
		elseif zoneID == "S4_Caves_2" then
			
			Wave_1 = CombatWave:New{ team = GethTacticals,	numDudes = 2, spawnValue = 2, spawnPath = "es_s4_caves_2" }
			Wave_2 = CombatWave:New{ team = GethSpecials,	numDudes = 3, spawnValue = 3, spawnPath = "es_s4_caves_2" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			--ResetTeamMemberLocations(SQD, "ps_s4_caves")
			
		elseif zoneID == "S4_Caves_3" then
			
			Wave_1 = CombatWave:New{ team = GethSpecials,	numDudes = 2, spawnValue = 2, spawnPath = "es_s4_caves_3" }
			Wave_2 = CombatWave:New{ team = GethHeavys,		numDudes = 3, spawnValue = 3, spawnPath = "es_s4_caves_3" }
			
			CombatSequence = WaveSequence:New{ bDebug = mapDebug }
			CombatSequence:AddWave(Wave_1)
			CombatSequence:AddWave(Wave_2)
			CombatSequence:Start()
			
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			--ResetTeamMemberLocations(SQD, "ps_s4_caves")
			
		elseif zoneID == "S4_Caves_Boss" then
			
			BlockCombatZoneExits(3)
			
			-- Reset the player's squad
			--ResetTeamMemberLocations(SQD, "ps_s4_caves")
			
		else
			print("EURn_c.SetupCombatZoneInit(): Argument #0  combatZoneID  invalid!")
		end
		
		CombatSequence.OnComplete = function(self)
			ReleaseCombatZone(zoneID)
		end
	end
end


---
-- This is called when all the enemies in combat zone /combatZoneID/ are dead.
-- @param #string combatZoneID The name ID of the zone to release.
-- 
function ReleaseCombatZone(combatZoneID)
	print("EURn_c.ReleaseCombatZone(): Entered")
	
	if currentZoneID == "none" then
		print("EURn_c.ReleaseCombatZone(): Warning, there's no active combat zone! Exiting function")
		return
	end
	
	local zoneID = combatZoneID
	
	print("EURn_c.ReleaseCombatZone(): Releasing combat zone "..zoneID)
	print("EURn_c.ReleaseCombatZone(): Incrementing numCombatZonesCleared to "..numCombatZonesCleared+1)
		
	numCombatZonesCleared = numCombatZonesCleared + 1
	
	bInCombat = false
	
	-- Only restore player health if they're alive
	if GetNumTeamMembersAlive(REP) > 0 then
		-- Restore the player's health
		RestorePlayerHealth()
	else
		print("EURn_c.ReleaseCombatZone(): Player isn't alive! Not restoring player health")
	end
	
	ClearAIGoals(SQD)
	AddAIGoal(SQD, "Defend", 100, 0)
	
	-- Which combat zone are we releasing? Complete the objective based on the answer
	if zoneID == "S0_Hangar" then
		Objective2b:Complete(ATT)
		
	elseif zoneID == "S0_CargoBay" then
		Objective3a:Complete(ATT)
		
	elseif zoneID == "S0_Reception" then
		Objective3b:Complete(ATT)
		
	elseif zoneID == "S0_Management" then
		Objective3c:Complete(ATT)
		
	elseif zoneID == "S0_PowerControl" then
		Objective3d:Complete(ATT)
		
	elseif zoneID == "S0_CommsControl" then
		Objective3e:Complete(ATT)
		
	elseif zoneID == "S1_MainAtrium" then
		Objective4a:Complete(ATT)
		
	elseif zoneID == "S1_MarineLifeLab" then
		Objective4b:Complete(ATT)
		
	elseif zoneID == "S1_IceSamplesLab" then
		Objective4c:Complete(ATT)
		
	elseif zoneID == "S3_MainAtrium" then
		Objective5a:Complete(ATT)
		
	elseif zoneID == "S3_MarineLifeLab" then
		Objective5b:Complete(ATT)
		
	elseif zoneID == "S3_EnergyLab" then
		Objective5c:Complete(ATT)
		
	elseif zoneID == "S4_MainAtrium" then
		Objective6a:Complete(ATT)
		
	elseif zoneID == "S4_SeismoLab" then
		Objective6b:Complete(ATT)
		
	elseif zoneID == "S4_GeoLab" then
		Objective6c:Complete(ATT)
	
	elseif zoneID == "S4_Caves_3" then
		ActivateRegion("cz_s4_caves_boss")
		
	elseif zoneID == "S4_Caves_Boss" then
		Objective7:Complete(ATT)
		
	end
	
	-- Make sure this function can't recalled until another combat zone is entered
	currentZoneID = "none"
end


---
-- Starts and sets up the event logic for combat zone /combatZoneID/.
-- @param #string combatZoneID The name of the zone ID to set up.
-- @param #string combatMusicID The music ID to start playing. Use "none" if no music change desired.
-- 

--[[function StartCombatZone(combatZoneID, combatMusicID)
	print("EURn_c.StartCombatZone(\""..combatZoneID.."\", \""..combatMusicID.."\"): Entered")
	
	if not InCombat() then
		local zoneID = combatZoneID
		local musicID = combatMusicID
		
		print("EURn_c.StartCombatZone(): Starting combat zone "..zoneID)
		
		
		-- Is debug enabled?
		if bDebug == true then
			ShowMessageText("level.EUR.debug.comzone_entered", REP)
			ShowMessageText("level.EUR.debug.comzone_spawning", REP)
		end
		
		-- Was a value entered for combatMusicID?
		if musicID ~= "none" then
			-- Start playing combat music
			ScriptCB_PlayInGameMusic(musicID)
		else
			print("EURn_c.StartCombatZone(): combatMusicID not specified! Continuing...")
		end
	end
end]]


---
-- Call this to check if the input /object/ matches one of the classes in /enemyBuildingClasses/.
-- @param #object object The object data to check.
-- @return #bool True, object is not an enemy building. False, object is an enemy building.
function IsObjectUnit(object)
	--print("EURn_c.IsObjectUnit(): Entered")
	
	print("EURn_c.IsObjectUnit(): Object class name:", GetEntityClass(object))
	
	for i in pairs(enemyBuildingClasses) do
		-- Is the object an enemy building?
		if GetEntityClass(object) == FindEntityClass(enemyBuildingClasses[i]) then
			print("EURn_c.IsObjectUnit(): Object is an enemy building!")
			return false
		else
			print("EURn_c.IsObjectUnit(): Object is NOT an enemy building!")
			return true
		end
	end
end


---
-- Begins regenerating the player's health until the health threshold is reached. (it's not perfect, but it works (usually (sometimes (never (okay sometimes)))))
-- 
function RestorePlayerHealth()
	print("EURn_c.RestorePlayerHealth(): Entered")
	
	local charUnit = GetCharacterUnit(0)	-- The player's character unit ID.
	local charPtr = GetEntityPtr(charUnit)	-- The player's entity pointer.
			
	-- What is the player's current health?
	playerCurHealth = GetObjectHealth(charPtr)
	
	-- How often in seconds will we check the player's health?
	local checkInterval = 0.5
	
	-- Is the player's health under the minimum health threshold?
	if playerCurHealth < playerMinHealth then
		-- Start restoring the player's health
		SetProperty(charUnit, "AddHealth", playerHealthAddRate)
		
		-- Our timer for checking the player's health
		local checkTimer = CreateTimer("checkTimer")
		SetTimerValue(checkTimer, checkInterval)
		--ShowTimer(checkTimer)
		
		StartTimer(checkTimer)
		
		-- Check the player's health every half of a second since we don't have an update function :(
		local checkTimerElapse = OnTimerElapse(
			function(timer)
				-- Update the player's health
				playerCurHealth = GetObjectHealth(charPtr)
				
				print("EURn_c.RestorePlayerHealth(): playerCurHealth:", playerCurHealth)
				
				-- Is the player's health still low?
				if playerCurHealth < playerMinHealth then
					-- Restart the timer
					SetTimerValue(checkTimer, checkInterval)
					StartTimer(checkTimer)
				else
					print("EURn_c.RestorePlayerHealth(): Threshold surpassed, stopping restoration")
					
					-- Stop the timer
					StopTimer(checkTimer)
					
					-- Stop restoring health
					if ME5_HealthFunc == 1 then
						SetProperty(charUnit, "AddHealth", UNIT_HEALTH_REGEN_RATE)
					elseif ME5_HealthFunc == 2 then
						SetProperty(charUnit, "AddHealth", 0)
					else
						SetProperty(charUnit, "AddHealth", UNIT_HEALTH_REGEN_RATE)
					end
					
					DestroyTimer(checkTimer)
				end
			end,
		"checkTimer"
		)
	end
end


---
-- Call this to push a set of subtitles based on /subtitleID/.
-- @param #string subtitleID The string ID of the subtitle set to push.
-- 
function PushSubtitleSet(subtitleID)
	print("EURn_c.PushSubtitle(): Entered")
	
	if subtitleID == nil then
		print("EURn_c.PushSubtitle(): Error! subtitleID must be specified!")
		return
	end
	
	-- The localization path to get the key from
	local baseKey = "level.eur.subtitles."
	
	-- The number of lines in each subtitle set
	local brief_1a_sets = 3
	local brief_1b_sets = 4
	local brief_2a_sets = 4
	local brief_2b_sets = 3
	local brief_2c_sets = 3
	local brief_2d_sets = 1
	local brief_3a_sets = 1
	local brief_3b_sets = 4
	local brief_3c_sets = 2
	local brief_3d_sets = 2
	local brief_4a_sets = 2
	local brief_4b_sets = 2
	local brief_4c_sets = 1
	
	-- "Enumerator" for the list of sets (no really why doesn't Lua support actual enums...or integer incrementing...or a decent for-loop syntax)
	local brief_1a = 0
	local brief_1b = 1
	local brief_2a = 2
	local brief_2b = 3
	local brief_2c = 4
	local brief_2d = 5
	local brief_3a = 6
	local brief_3b = 7
	local brief_3c = 8
	local brief_3d = 9
	local brief_4a = 10
	local brief_4b = 11
	local brief_4c = 12
	
	-- The current set of subtitles
	local curSet = nil
	
	-- The number of subtitle lines in the curSet
	local numLines = nil
	
	
	-- Which subtitle set are we pushing?
	if subtitleID == "brief_1a" then
		curSet = brief_1a
		numLines = brief_1a_sets
		
	elseif subtitleID == "brief_1b" then
		curSet = brief_1b
		numLines = brief_1b_sets
		
	elseif subtitleID == "brief_2a" then
		curSet = brief_2a
		numLines = brief_2a_sets
		
	elseif subtitleID == "brief_2b" then
		curSet = brief_2b
		numLines = brief_2b_sets
		
	elseif subtitleID == "brief_2c" then
		curSet = brief_2c
		numLines = brief_2c_sets
		
	elseif subtitleID == "brief_2d" then
		curSet = brief_2d
		numLines = brief_2d_sets
		
	elseif subtitleID == "brief_3a" then
		curSet = brief_3a
		numLines = brief_3a_sets
		
	elseif subtitleID == "brief_3b" then
		curSet = brief_3b
		numLines = brief_3b_sets
		
	elseif subtitleID == "brief_3c" then
		curSet = brief_3c
		numLines = brief_3c_sets
		
	elseif subtitleID == "brief_3d" then
		curSet = brief_3d
		numLines = brief_3d_sets
		
	elseif subtitleID == "brief_4a" then
		curSet = brief_4a
		numLines = brief_4a_sets
		
	elseif subtitleID == "brief_4b" then
		curSet = brief_4b
		numLines = brief_4b_sets
		
	elseif subtitleID == "brief_4c" then
		curSet = brief_4c
		numLines = brief_4c_sets
	end
	
	
	-- The current subtitle line
	local curLine = 1
	
	print("EURn_c.PushSubtitle(): curLine, numLines:", curLine, numLines)
	
	local pushDelayTimer = CreateTimer("pushDelayTimer")
	SetTimerValue(pushDelayTimer, 0.25)
	StartTimer(pushDelayTimer)
	
	local pushDelayElapse = OnTimerElapse(
		function(timer)
			
			local key = "level.eur.subtitles."..subtitleID.."_"..curLine
			print("EURn_c.PushSubtitleSet(): key:", key)
			print("EURn_c.PushSubtitleSet(): subtitleID:", subtitleID)
			print("EURn_c.PushSubtitleSet(): curLine:", curLine)
			
			ShowMessageText(key)
			
			-- Have all the sets been shown?
			if curLine >= numLines then
				DestroyTimer(pushDelayTimer)
				ReleaseTimerElapse(pushDelayElapse)
			else
				curLine = curLine + 1
				
				-- Restart the timer
				SetTimerValue(pushDelayTimer, 0.25)
				StartTimer(pushDelayTimer)
			end
			
		end,
	pushDelayTimer
	)
	
end


---
-- Prints and returns the variable /playerCurHealth/.
-- @return The player's current health from /playerCurHealth/.
-- 
function GetPlayerCurHealth()
	print("EURn_c.GetPlayerCurHealth(): playerCurHealth:", playerCurHealth)
	return playerCurHealth
end


---
-- Prints and returns the variable /playerMinHealth/.
-- @return The player's minimum health from /playerMinHealth/.
-- 
function GetPlayerMinHealth()
	print("EURn_c.GetPlayerCurHealth(): playerMinHealth:", playerMinHealth)
	return playerMinHealth
end


---
-- Prints and returns the variable /playerMaxHealth/.
-- @return The player's maximum health from /playerMaxHealth/.
-- 
function GetPlayerMaxHealth()
	print("EURn_c.GetPlayerCurHealth(): playerMaxHealth:", playerMaxHealth)
	return playerMaxHealth
end


---
-- Returns and optionally sets the combat state.
-- @param #bool newState	Combat state. True, player is in combat, false if not.
-- @return #bool			The combat state from /bInCombat/.
-- 
function InCombat(newState)
	
	-- Only set combat state if a new value is input
	if newState then
		bInCombat = newState
	end
	
	return bInCombat
end


---
-- Call this to shake the camera.
-- @param #float shakeAmount	The amount to shake the camera.
-- @param #float shakeLength	The length of time in seconds of the shake.
-- @param #float shakeDelay		OPTIONAL: The length of time in seconds to wait before initiating the shake.
-- @param #string shakeSound	OPTIONAL: The name of the sound property to play when the shake is initiated.
-- @return #int					Returns 1 if the shake was successful, or 0 if it was unsuccessful.
-- 
function CinematicShakeCamera(shakeAmount, shakeLength, shakeDelay)
	if (shakeAmount == nil or shakeAmount <= 0) then
		print("EURn_c.CinematicShakeCamera(): WARNING: shakeAmount must be specified and greater than 0!")
		return 0
	end
	if (shakeLength == nil or shakeLength <= 0) then
		print("EURn_c.CinematicShakeCamera(): WARNING: shakeLength must be specified and greater than 0!")
		return 0
	end
	
	-- Initialize optional fields
	shakeDelay = shakeDelay or 0
	shakeSound = shakeSound or "none"
	
	print("EURn_c.CinematicShakeCamera("..shakeAmount..", "..shakeLength..", "..shakeDelay.."): Entered")
	
	local function DoShake()
		-- Start shaking
		SetClassProperty("eur_cinematic_rumble", "MinShakeAmt", shakeAmount)
		SetClassProperty("eur_cinematic_rumble", "MaxShakeAmt", shakeAmount)
		SetClassProperty("eur_cinematic_rumble", "MinShakeLen", shakeLength)
		SetClassProperty("eur_cinematic_rumble", "MaxShakeLen", shakeLength)
		SetClassProperty("eur_cinematic_rumble", "SoundName", " ")
		--SetClassProperty("eur_cinematic_rumble", "MinInterval", shakeLength+0.1)
		--SetClassProperty("eur_cinematic_rumble", "MaxInterval", shakeLength+0.1)
		
		if shakeSound ~= "none" then
			ScriptCB_SndPlaySound(shakeSound)
		end
		
		-- Timer to control shaking
		local cinematicShakeTimer = CreateTimer("cinematicShakeTimer_"..numCinematicShakes)
		SetTimerValue(cinematicShakeTimer, shakeLength+0.1)
		StartTimer(cinematicShakeTimer)
		
		local cinematicShakeTimerElapse = OnTimerElapse(
			function(timer)
				print("EURn_c.CinematicShakeCamera: Stopping shaking")
				
				-- Stop shaking
				SetClassProperty("eur_cinematic_rumble", "MinShakeAmt", 0.0)
				SetClassProperty("eur_cinematic_rumble", "MaxShakeAmt", 0.0)
				SetClassProperty("eur_cinematic_rumble", "MinShakeLen", 0.01)
				SetClassProperty("eur_cinematic_rumble", "MaxShakeLen", 0.01)
				--SetClassProperty("eur_cinematic_rumble", "MinInterval", 0.2)
				--SetClassProperty("eur_cinematic_rumble", "MaxInterval", 0.2)
				SetClassProperty("eur_cinematic_rumble", "SoundName", " ")
				
				DestroyTimer(timer)
				ReleaseTimerElapse(cinematicShakeTimerElapse)
			end,
		cinematicShakeTimer
		)
	end
	
	-- Was a valid shakeDelay value entered?
	if (shakeDelay and shakeDelay > 0) then
		-- Timer to control shake delay
		local cinematicShakeDelayTimer = CreateTimer("cinematicShakeDelayTimer_"..numCinematicShakes)
		SetTimerValue(cinematicShakeDelayTimer, shakeDelay)
		StartTimer(cinematicShakeDelayTimer)
		
		local cinematicShakeDelayTimerElapse = OnTimerElapse(
			function(timer)
				DoShake()
				
				DestroyTimer(timer)
				ReleaseTimerElapse(cinematicShakeDelayTimerElapse)
			end,
		cinematicShakeDelayTimer
		)
	else
		DoShake()
	end
	
	-- Make sure we don't somehow reuse an old shake timer
	numCinematicShakes = numCinematicShakes + 1
	
end


---
-- Call this to change whether or not the squad can kill enemies.
-- @param #bool canKill		True, squad can kill enemies. False, squad cannot kill enemies.
-- 
function SetSquadCanKillEnemies(canKill)	-- TODO: fix function tbh
	if canKill then return end
	
	-- Reset the stats tables to make room for new data
	if canKill == false then
		GethPawns_Stats = {}
		GethTacticals_Stats = {}
		GethSpecials_Stats = {}
		GethHeavys_Stats = {}
		GethPrimes_Stats = {}
	end
	
	for curTeam in ipairs(enemyTeams) do
		local teamSize = GetTeamSize(curTeam)
		if teamSize > 0 then
			print()
			print("SetSquadCanKillEnemies(): curTeam:", enemyTeams[curTeam])
			
			if canKill == false then
				print("SetSquadCanKillEnemies(): Making units invincible")
			else
				print("SetSquadCanKillEnemies(): Making units killable")
			end
			
			for curMember = 0, teamSize-1 do
				local charIndex = GetTeamMember(curTeam, curMember)
				local charUnit = GetCharacterUnit(charIndex)
				
				if canKill == false then
					-- Store the unit's current health and shields in a table
					local charHealth = GetObjectHealth(charUnit)
					local charShields = GetObjectShield(charUnit)
					
					if curTeam == GethPawns then
						GethPawns_Stats[curMember] = charHealth
						--GethPawns_Stats[curMember][2] = charShields
						
					elseif curTeam == GethTacticals then
						GethTacticals_Stats[curMember] = charHealth
						--GethTacticals_Stats[curMember][2] = charShields
						
					elseif curTeam == GethSpecials then
						GethSpecials_Stats[curMember] = charHealth
						--GethSpecials_Stats[curMember][2] = charShields
						
					elseif curTeam == GethHeavys then
						GethHeavys_Stats[curMember] = charHealth
						--GethHeavys_Stats[curMember][2] = charShields
						
					elseif curTeam == GethPrimes then
						GethPrimes_Stats[curMember] = charHealth
						--GethPrimes_Stats[curMember][2] = charShields
					end
					
					print("SetSquadCanKillEnemies(): curMember, charHealth, charShields:", curMember, charHealth, charShields)
					
					-- Make the unit invincible
					--SetProperty(charUnit, "CurHealth", 9999999)
					--SetProperty(charUnit, "CurShield", 9999999)
					
				else
					local charHealth, charShields
					
					if curTeam == GethPawns then
						charHealth = GethPawns_Stats[curMember]
						--charShields = GethPawns_Stats[curMember][2]
						
					elseif curTeam == GethTacticals then
						charHealth = GethTacticals_Stats[curMember]
						--charShields = GethTacticals_Stats[curMember][2]
						
					elseif curTeam == GethSpecials then
						charHealth = GethSpecials_Stats[curMember]
						--charShields = GethSpecials_Stats[curMember][2]
						
					elseif curTeam == GethHeavys then
						charHealth = GethHeavys_Stats[curMember]
						--charShields = GethHeavys_Stats[curMember][2]
						
					elseif curTeam == GethPrimes then
						charHealth = GethPrimes_Stats[curMember]
						--charShields = GethPrimes_Stats[curMember][2]
					end
					
					print("SetSquadCanKillEnemies(): curMember, charHealth, charShields:", curMember, charHealth, charShields)
					
					--SetProperty(charUnit, "CurHealth", charHealth)
					--SetProperty(charUnit, "CurShield", charShields)
				end
			end
		end
	end
end


---
-- Call this to unblock an elevator's doors.
-- @param #int id	The numeric ID of the elevator whose doors we are unblocking.
-- 
function UnblockElevatorDoors(id)
	if id == nil then
		print("EURn_c.UnblockElevatorDoors(): id wasn't specified! Exiting function")
		return
	end
	
	-- Open the entrance doors to the elevator
	SetProperty("elevator_s"..id.."_doors_fake", "CurHealth", 0)
	KillObject("elevator_s"..id.."_doors_block")
end


---
-- Call this to set up the campaign's various timers.
-- 
function SetupTimers()
	print("EURn_c.SetupTimers(): Entered")
	
	-- Spawn delay timer
	spawnDelayTimer = CreateTimer("spawnDelayTimer")
	SetTimerValue(spawnDelayTimer, 4)
	
	-- Elevator timer
	ElevatorTimer = CreateTimer("elevatorTimer")
	SetTimerValue(ElevatorTimer, 25)
	
	-- Elevator doors timer
	ElevatorDoorsTimer = CreateTimer("elevatorDoorsTimer")
	SetTimerValue(ElevatorDoorsTimer, 1.5)
	
end


function ScriptPostLoad()
	ScriptCB_SetGameRules("campaign")
	AllowAISpawn(REP, false)	-- Only the player can spawn from REP team
	AllowAISpawn(SQD, false)	-- Squad isn't allowed to spawn before the player's first spawn
	--[[AllowAISpawn(2, false)
	AllowAISpawn(3, false)
	AllowAISpawn(4, false)
	AllowAISpawn(5, false)
	AllowAISpawn(6, false)
	AllowAISpawn(7, false)]]
	SetReinforcementCount(CIS, -1)
	
	
	SetProperty("hangar_console", "MaxHealth", 9999999999)
	SetProperty("hangar_console", "AddHealth", 0)
	SetProperty("hangar_console", "CurHealth", 0)
	SetProperty("hangar_console", "AINoRepair", "1")
	KillObject("hangar_console")
	
	SetProperty("comms_console", "MaxHealth", 9999999999)
	SetProperty("comms_console", "AddHealth", 0)
	SetProperty("comms_console", "CurHealth", 0)
	SetProperty("comms_console", "AINoRepair", "1")
	KillObject("comms_console")
	
	DisableBarriers("HangarEnter")
	
	-- Pre-block the first combat zone's exits
	BlockCombatZoneExits(0)
	
    EnableSPScriptedHeroes()
    ScriptCB_EnableHeroMusic(0)
    
    
    print("EURn_c.ScriptPostLoad(): Setting unit movement speeds and multiplying health/shield values by enemyDefenseBuff...")
    
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
    
    print("EURn_c.ScriptPostLoad(): Multiplying unit health/shield values by enemyDefenseBuff... DONE")
    
    
	-- Player's squad follows the player out of the shuttle.
	ClearAIGoals(SQD)
	AddAIGoal(SQD, "Defend", 100, GetObjectPtr("squad_firstspawn_goto"))
    
    SetRespawnPointPlayer("ps_start_shuttle")
    SetRespawnPointSquad("ps_start_shuttle_ext")
    
    -- Set up all of the timers
    SetupTimers()
    
    
    -- Whenever the player spawns
	playerspawn = OnCharacterSpawn(
		function(character)
			if IsCharacterHuman(character) then
				--BeginScreenTransition(0, 0.5, 0.7, 1.5, "FADE", "FADE")
				
				-- Store the player's health
				local charPtr = GetEntityPtr(GetCharacterUnit(character))
				
				-- Store the player's starting health
				playerMaxHealth = GetObjectHealth(charPtr)
				
				-- Set the value that the player's health will restore to after each combat zone
				playerMinHealth = playerMaxHealth * playerHealthThreshold
				
				print("EURn_c.playerstartinghealth: playerMaxHealth:", playerMaxHealth)
				print("EURn_c.playerstartinghealth: playerMinHealth:", playerMinHealth)
				
				
				-- Re-allow the squad to kill enemies
				SetSquadCanKillEnemies(true)
			end
		end
	)
	
	-- Whenever the player dies
	playerdeath = OnCharacterDeath(
		function(character)
			if IsCharacterHuman(character) then
				-- Prevent the squad from being able to kill enemies
				SetSquadCanKillEnemies(false)
			end
		end
	)
	
	
	-- When the player's lost their final life
	playerdefeat = OnTicketCountChange(
		function(team, count)
			-- Is the player out of lives?
			if team == ATT and count <= 0 then
				BroadcastVoiceOver("EUR_obj_defeat", ATT)
				
				-- Prevent squad team from spawning and then murder them lmao
				AllowAISpawn(SQD, false)
				KillUnits({SQD}, true)
			end
		end
	)
	
	
	--==========================
	-- FIRST SPAWN
	--==========================
    
    -- Play spawn menu music
    ScriptCB_PlayInGameMusic("eur_amb_01a_briefing")
	        	
	--SetRespawnPointPlayer("ps_start_shuttle2")	-- DEBUG
	
    onfirstspawn = OnCharacterSpawn(
	    function(character)
	        if character == 0 then
	            ReleaseCharacterSpawn(onfirstspawn)
	            onfirstspawn = nil
	            
	            camShakeCharUnit = GetCharacterUnit(character)
	        	
	        	BeginOpeningCinematic()
	        	--UnblockCombatZoneExits(0)	-- DEBUG
	            
	            ScriptCB_EnableCommandPostVO(0)
	            
	            -- The number of combat zones that have been cleared
	            numCombatZonesCleared = 0
	            
	            -- Allow the player's squad to spawn
	            AllowAISpawn(SQD, false)
	        end
	    end
    )
	
	
	--==========================
	-- FIND THE STATION ENTRANCE
	--==========================
    
	-- Objective 1: Find the station entrance
	Objective1 = ObjectiveGoto:New{TeamATT = ATT, TeamDEF = DEF, 
									   text = "level.eur.objectives.1", 
									   popupText = "level.eur.objectives.1_popup",
									   regionName = "station_goto", mapIcon = "hud_objective_icon_circle",  AIGoalWeight = 0}
	
	Objective1.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_1", ATT)
        MapAddEntityMarker("station_goto_marker", "hud_objective_icon", 3.0, ATT, "YELLOW", true)
	end
	
	Objective1.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
    			
		MapRemoveEntityMarker("station_goto_marker")
	end
	
	
	--==========================
	-- ACTIVATE HANGAR CONSOLE
	--==========================
    
	-- Objective 2a: Activate the console
    Objective2a = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.2a", 
                                     popupText = "level.eur.objectives.2a_popup", 
                                     multiplayerRules = false }
	
	Objective2a.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_2a", ATT)
		
		SetProperty("hangar_console", "MaxHealth", 999999)
		SetProperty("hangar_console", "AddHealth", 0)
		SetProperty("hangar_console", "CurHealth", 0)
		
        MapAddEntityMarker("hangar_console", "hud_objective_icon", 3.0, ATT, "YELLOW", true)
    	local CZ_Hangar = OnObjectRepairName(
    		function(objPtr, characterId)
    			-- Test output
    			print("EURn_c.CZ_Hangar: Activated console")
    			
				-- Is debug enabled?
				if bDebug == true then
    				ShowMessageText("level.EUR.interactions.test.received")
    			end
    			
    			-- Activate the mass effect field
    			RewindAnimation("hangar_mefield_activate")
    			PlayAnimation("hangar_mefield_activate")
    			
    			EnableBarriers("HangarEnter")
    			
    			-- Play interaction sound
    			ScriptCB_SndPlaySound("eur_console_interact")
    			
    			-- Remove objective marker
    			MapRemoveEntityMarker("hangar_console")
    			
    			
    			Objective2a:Complete(ATT)
    			
    			-- Disable this combat zone's trigger
    			ReleaseObjectRepair(CZ_Hangar)
    			CZ_Hangar = nil
    		end,
    	"hangar_console"
    	)
	end
	
	Objective2a.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
	end
	
	
	--==========================
	-- COMBAT ZONE : S0 -- HANGAR
	--==========================
	
	-- Objective 2b: Secure the hangar
    Objective2b = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.2b", 
                                     popupText = "level.eur.objectives.2b_popup", 
                                     multiplayerRules = false }
	
	Objective2b.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_2b", ATT)
		
		-- This combat zone's string ID
		currentZoneID = "S0_Hangar"
		
		-- Set up init params for combat zone
		--SetupCombatZoneInit(currentZoneID)
		
		-- Start combat zone
		SetupCombatZoneInit(currentZoneID, "eur_amb_01_combat")
		
		-- Update the player's respawn point
		SetRespawnPoint("ps_s0_hangar")
	end
	
	Objective2b.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_01b_explore")
		
		
		local Obj3a_DelayTimer = CreateTimer("Obj3a_DelayTimer")
		SetTimerValue(Obj3a_DelayTimer, 3)
		StartTimer(Obj3a_DelayTimer)
		
		-- Wait a bit before letting the player proceed to the Cargo Bay
		local Obj3a_DelayTimerElapse = OnTimerElapse(
			function(timer)
				-- Allow the player to leave
				UnblockCombatZoneExits(0)
				
				DestroyTimer(timer)
				ReleaseTimerElapse(Obj3a_DelayTimerElapse)
			end,
		Obj3a_DelayTimer
		)
	end
	
	
	--==========================
	-- COMBAT ZONE : S0 -- CARGO BAY
	--==========================
	
	-- Objective 3a: Secure the cargo bay
    Objective3a = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.3", 
                                     popupText = "level.eur.objectives.3_popup", 
                                     multiplayerRules = false }
	
	Objective3a.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_3", ATT)
		
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s0_cargo")
		
    	local CZ_CargoBay = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_CargoBay: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S0_CargoBay"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_01_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s0_cargo")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_CargoBay)
    				CZ_CargoBay = nil
    				
    				DeactivateRegion("cz_s0_cargo")
    			end
    		end,
    	"cz_s0_cargo"
    	)
	end
	
	Objective3a.OnComplete = function(self)
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_01b_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(0)
	end
	
	--==========================
	-- COMBAT ZONE : S0 -- RECEPTION
	--==========================
	
	-- Objective 3b: Secure the reception
    Objective3b = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.3b", 
                                     multiplayerRules = false }
	
	Objective3b.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s0_reception")
		
    	local CZ_Reception = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Reception: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S0_Reception"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_01_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s0_reception")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_Reception)
    				CZ_Reception = nil
    			end
    		end,
    	"cz_s0_reception"
    	)
	end
	
	Objective3b.OnComplete = function(self)
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_01b_explore")
		
		DeactivateRegion("cz_s0_reception")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(0)
	end
	
	
	--==========================
	-- COMBAT ZONE : S0 -- MANAGEMENT
	--==========================
	
	-- Objective 3c: Secure the management
    Objective3c = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.3c", 
                                     multiplayerRules = false }
	
	Objective3c.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s0_management")
		
    	local CZ_Management = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Management: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S0_Management"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_01_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s0_management_in")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_Management)
    				CZ_Management = nil
    			end
    		end,
    	"cz_s0_management"
    	)
	end
	
	Objective3c.OnComplete = function(self)
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_01b_explore")
		
		DeactivateRegion("cz_s0_management")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(0)
	end
	
	
	--==========================
	-- COMBAT ZONE : S0 -- POWER CONTROL
	--==========================
	
	-- Objective 3d: Secure the power control
    Objective3d = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.3d", 
                                     multiplayerRules = false }
	
	Objective3d.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s0_power")
		
    	local CZ_PowerControl = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_PowerControl: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S0_PowerControl"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_01_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s0_power_in")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_PowerControl)
    				CZ_PowerControl = nil
    			end
    		end,
    	"cz_s0_power"
    	)
	end
	
	Objective3d.OnComplete = function(self)
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_01b_explore")
		
		DeactivateRegion("cz_s0_power")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(0)
	end
	
	
	--==========================
	-- COMBAT ZONE : S0 -- COMMS CONTROL
	--==========================
	
	-- Objective 3e: Secure the comms control
    Objective3e = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.3e", 
                                     multiplayerRules = false }
	
	Objective3e.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s0_comms")
		
    	local CZ_CommsControl = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_CommsControl: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S0_CommsControl"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_01_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s0_comms_in")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_CommsControl)
    				CZ_CommsControl = nil
    				
    				-- Workaround in case the player manages to activate the console before this objective ends
    				Objective3e_ConsoleWorkaround = OnObjectRepairName(
			    		function(objPtr, characterId)
			    			if bConsoleWorkaround == true then
								SetProperty("comms_console", "CurHealth", 0)
				    			KillObject("comms_console")
			    			end
			    		end,
			    	"comms_console"
			    	)
    			end
    		end,
    	"cz_s0_comms"
    	)
	end
	
	Objective3e.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		bConsoleWorkaround = false
		
		DeactivateRegion("cz_s0_comms")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_01b_explore")
    
	    -- Allow the player to leave
		UnblockCombatZoneExits(0)
		
		ReleaseObjectRepair(Objective3e_ConsoleWorkaround)
		Objective3e_ConsoleWorkaround = nil
	end
	
	
	--==========================
	-- COMBAT ZONE : S0 -- Override lockdown
	--==========================
	
	-- Objective 3f: Override lockdown
    Objective3f = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.3f", 
                                     popupText = "level.eur.objectives.3f_popup", 
                                     multiplayerRules = false }
	
	Objective3f.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_3f", ATT)
		
		SetProperty("comms_console", "MaxHealth", 999999)
		SetProperty("comms_console", "AddHealth", 0)
		SetProperty("comms_console", "CurHealth", 0)
		
        MapAddEntityMarker("comms_console", "hud_objective_icon", 3.0, ATT, "YELLOW", true)
    	local CZ_CommsControl_Lockdown = OnObjectRepairName(
    		function(objPtr, characterId)
    			-- Test output
    			print("EURn_c.CZ_CommsControl_Lockdown: Activated console")
    			
				-- Is debug enabled?
				if bDebug == true then
    				ShowMessageText("level.EUR.interactions.test.received")
    			end
    			
    			-- Play interaction sound
    			ScriptCB_SndPlaySound("eur_console_interact")
    			
    			-- Remove objective marker
    			MapRemoveEntityMarker("comms_console")
    			
    			Objective3f:Complete(ATT)
    			
    			-- Disable this combat zone's trigger
    			ReleaseObjectRepair(CZ_CommsControl_Lockdown)
    			CZ_CommsControl_Lockdown = nil
    		end,
    	"comms_console"
    	)
	end
	
	Objective3f.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		-- Switch back to exploration music
		-- FIX: this doesn't need to (and shouldn't) happen as long as the previous objective plays the music on completion
		--ScriptCB_PlayInGameMusic("eur_amb_explore_01a")
    
	    -- Allow the player to leave
		UnblockCombatZoneExits(0)
		
		UnblockElevatorDoors(0)
		
		-- Update the player's respawn point
		SetRespawnPoint("ps_s1_start")
		
		-- Elevator work
		ActivateRegion("elevator_s0_trigger")
		S0_Elevator = OnEnterRegion(
			function(region, player)
				if IsCharacterHuman(player) then
					print("EURn_c.S0_Elevator: Entered region")
					
					
					--===========================
					-- DEMO TIMER START
					--===========================
					
					DeactivateRegion("elevator_s0_trigger")
					
					local demoTimer = CreateTimer("demoTimer")
					SetTimerValue(demoTimer, 10)
					ShowTimer(demoTimer)
					StartTimer(demoTimer)
					
					local demoTimerElapse = OnTimerElapse(
						function(timer)
							--print("EURn_c: Loading hud_font_stock.lvl...")
							-- hotfix that reloads the stock fonts in the stats screen
							--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
							
							ReleaseTimerElapse(demoTimerElapse)
							DestroyTimer(demoTimer)
							
							ScriptCB_SndBusFade("music", 0.0, 1.0)
							MissionVictory(ATT)
						end,
					"demoTimer"
					)
					
					--===========================
					-- DEMO TIMER END
					--===========================
					
					
					--[[SetProperty("elevator_s0_doors_block", "CurHealth", 0)
					
					-- Start the elevator sequence (car & doors)
					PlayAnimation("elevator_s0_car")
					
					
					--===========================
					-- ELEVATOR TIMER START
					--===========================
					
					local elevatorTimer_S0 = CreateTimer("elevatorTimer_S0")
					SetTimerValue(elevatorTimer_S0, 10)
					StartTimer(elevatorTimer_S0)
					
					local elevatorTimerElapse_S0 = OnTimerElapse(
						function(timer)
							-- Switch to next sublevel's exploration music
							ScriptCB_PlayInGameMusic("eur_amb_02_explore")
							
							ReleaseTimerElapse(elevatorTimerElapse_S0)
							DestroyTimer(elevatorTimer_S0)
						end,
					"elevatorTimer_S0"
					)
					
					--===========================
					-- ELEVATOR TIMER END
					--===========================
					
					
					-- Disable the elevator trigger
					ReleaseEnterRegion(S0_Elevator)
					S0_Elevator = nil
					
					DeactivateRegion("elevator_s0_trigger")]]
				end
			end,
		"elevator_s0_trigger"
		)
	end
	
	
	--==========================
	-- COMBAT ZONE : S1 -- MAIN ATRIUM
	--==========================
	
	-- Objective 4a: Secure the main atrium
    Objective4a = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.4", 
                                     popupText = "level.eur.objectives.4_popup", 
                                     multiplayerRules = false }
	
	Objective4a.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_4", ATT)
		
	    -- Allow the player to enter
		UnblockCombatZoneExits(1)
		
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s1_atrium")
		
    	local CZ_MainAtrium = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_MainAtrium: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S1_MainAtrium"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_02_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s1_atrium")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_MainAtrium)
    				CZ_MainAtrium = nil
    			end
    		end,
    	"cz_s1_atrium"
    	)
	end
	
	Objective4a.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s1_atrium")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_02_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(1)
	end
	
	
	--==========================
	-- COMBAT ZONE : S1 -- MARINE LIFE LAB
	--==========================
	
	-- Objective 4b: Secure the marine life lab
    Objective4b = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.4b", 
                                     multiplayerRules = false }
	
	Objective4b.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s1_biolab")
		
    	local CZ_MarineLifeLab = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_MarineLifeLab: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S1_MarineLifeLab"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_02_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s1_biolab")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_MarineLifeLab)
    				CZ_MarineLifeLab = nil
    			end
    		end,
    	"cz_s1_biolab"
    	)
	end
	
	Objective4b.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s1_biolab")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_02_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(1)
	end
	
	
	--==========================
	-- COMBAT ZONE : S1 -- ICE SAMPLES LAB
	--==========================
	
	-- Objective 4c: Secure the ice samples lab
    Objective4c = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.4c", 
                                     multiplayerRules = false }
	
	Objective4c.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s1_icelab")
		
    	local CZ_IceSamplesLab = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_IceSamplesLab: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S1_IceSamplesLab"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_02_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s1_icelab")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_IceSamplesLab)
    				CZ_IceSamplesLab = nil
    			end
    		end,
    	"cz_s1_icelab"
    	)
	end
	
	Objective4c.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s1_icelab")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_02_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(1)
		
		UnblockElevatorDoors(1)
		
		-- Update the player's respawn point
		SetRespawnPoint("ps_s3_start")
		
		-- Elevator work
		ActivateRegion("elevator_s1_trigger")
		S1_Elevator = OnEnterRegion(
			function(region, player)
				if IsCharacterHuman(player) then
					print("EURn_c.S1_Elevator: Entered region")
					
					SetProperty("elevator_s1_doors_block", "CurHealth", 0)
					
					-- Start the elevator sequence (car & doors)
					PlayAnimation("elevator_s1_car")
					
					-- Switch to next sublevel's exploration music
					ScriptCB_PlayInGameMusic("eur_amb_03_explore")
					
					
					--===========================
					-- ELEVATOR TIMER START
					--===========================
					
					local elevatorTimer_S1 = CreateTimer("elevatorTimer_S1")
					SetTimerValue(elevatorTimer_S1, 10)
					StartTimer(elevatorTimer_S1)
					
					local elevatorTimerElapse_S1 = OnTimerElapse(
						function(timer)
							-- Switch to next sublevel's exploration music
							--ScriptCB_PlayInGameMusic("eur_amb_03_explore")
							
							ReleaseTimerElapse(elevatorTimerElapse_S1)
							DestroyTimer(elevatorTimer_S1)
						end,
					"elevatorTimer_S1"
					)
					
					--===========================
					-- ELEVATOR TIMER END
					--===========================
					
					
					-- Disable the elevator trigger
					ReleaseEnterRegion(S1_Elevator)
					S1_Elevator = nil
					
					DeactivateRegion("elevator_s1_trigger")
				end
			end,
		"elevator_s1_trigger"
		)
	end
	
	
	--==========================
	-- COMBAT ZONE : S3 -- MAIN ATRIUM
	--==========================
	
	-- Objective 5a: Secure the main atrium
    Objective5a = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.5", 
                                     popupText = "level.eur.objectives.5_popup", 
                                     multiplayerRules = false }
	
	Objective5a.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_5", ATT)
		
	    -- Allow the player to enter
		UnblockCombatZoneExits(2)
		
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s3_atrium")
		
    	local CZ_MainAtrium = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_MainAtrium: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S3_MainAtrium"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_03_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s3_atrium")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_MainAtrium)
    				CZ_MainAtrium = nil
    			end
    		end,
    	"cz_s3_atrium"
    	)
	end
	
	Objective5a.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s3_atrium")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_03_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(2)
	end
	
	
	--==========================
	-- COMBAT ZONE : S3 -- MARINE LIFE LAB
	--==========================
	
	-- Objective 5b: Secure the marine life lab
    Objective5b = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.5b", 
                                     multiplayerRules = false }
	
	Objective5b.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s3_biolab")
		
    	local CZ_MarineLifeLab = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_MarineLifeLab: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S3_MarineLifeLab"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_03_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s3_biolab")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_MarineLifeLab)
    				CZ_MarineLifeLab = nil
    			end
    		end,
    	"cz_s3_biolab"
    	)
	end
	
	Objective5b.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s3_biolab")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_03_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(2)
	end
	
	
	--==========================
	-- COMBAT ZONE : S3 -- HYDROTHERMAL ENERGY LAB
	--==========================
	
	-- Objective 5c: Secure the ice samples lab
    Objective5c = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.5c", 
                                     multiplayerRules = false }
	
	Objective5c.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s3_energylab")
		
    	local CZ_EnergyLab = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_EnergyLab: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S3_EnergyLab"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_03_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s3_energylab")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_EnergyLab)
    				CZ_EnergyLab = nil
    			end
    		end,
    	"cz_s3_energylab"
    	)
	end
	
	Objective5c.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s3_energylab")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_03_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(2)
		
		UnblockElevatorDoors(3)
		
		-- Update the player's respawn point
		SetRespawnPoint("ps_s4_start")
		
		-- Elevator work
		ActivateRegion("elevator_s3_trigger")
		S3_Elevator = OnEnterRegion(
			function(region, player)
				if IsCharacterHuman(player) then
					print("EURn_c.S3_Elevator: Entered region")
					
					SetProperty("elevator_s3_doors_block", "CurHealth", 0)
					
					-- Start the elevator sequence (car & doors)
					PlayAnimation("elevator_s3_car")
					
					-- Switch to next sublevel's exploration music
					ScriptCB_PlayInGameMusic("eur_amb_04_explore")
					
					
					--===========================
					-- ELEVATOR TIMER START
					--===========================
					
					local elevatorTimer_S3 = CreateTimer("elevatorTimer_S3")
					SetTimerValue(elevatorTimer_S3, 10)
					StartTimer(elevatorTimer_S3)
					
					local elevatorTimerElapse_S3 = OnTimerElapse(
						function(timer)
							-- Switch to next sublevel's exploration music
							--ScriptCB_PlayInGameMusic("eur_amb_04_explore")
							
							ReleaseTimerElapse(elevatorTimerElapse_S3)
							DestroyTimer(elevatorTimer_S3)
						end,
					"elevatorTimer_S3"
					)
					
					--===========================
					-- ELEVATOR TIMER END
					--===========================
					
					
					-- Disable the elevator trigger
					ReleaseEnterRegion(S3_Elevator)
					S3_Elevator = nil
					
					DeactivateRegion("elevator_s3_trigger")
				end
			end,
		"elevator_s3_trigger"
		)
	end
	
	
	--==========================
	-- COMBAT ZONE : S4 -- MAIN ATRIUM
	--==========================
	
	-- Objective 6a: Secure the main atrium
    Objective6a = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.6", 
                                     popupText = "level.eur.objectives.6_popup", 
                                     multiplayerRules = false }
	
	Objective6a.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_6", ATT)
		
	    -- Allow the player to enter
		UnblockCombatZoneExits(3)
		
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s4_atrium")
		
    	local CZ_MainAtrium = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_MainAtrium: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_MainAtrium"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_04_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_atrium")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_MainAtrium)
    				CZ_MainAtrium = nil
    			end
    		end,
    	"cz_s4_atrium"
    	)
	end
	
	Objective6a.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s4_atrium")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_04_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(3)
	end
	
	
	--==========================
	-- COMBAT ZONE : S4 -- SEISMOLOGY LAB
	--==========================
	
	-- Objective 6b: Secure the seismology lab
    Objective6b = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.6b", 
                                     multiplayerRules = false }
	
	Objective6b.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s4_seismolab")
		
    	local S4_SeismoLab = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.S4_SeismoLab: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_SeismoLab"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_04_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_seismolab")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(S4_SeismoLab)
    				S4_SeismoLab = nil
    			end
    		end,
    	"cz_s4_seismolab"
    	)
	end
	
	Objective6b.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s4_seismolab")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_04_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(3)
	end
	
	
	--==========================
	-- COMBAT ZONE : S4 -- GEOMICROBIOLOGY LAB
	--==========================
	
	-- Objective 6c: Secure the geomicrobiology lab
    Objective6c = Objective:New{teamATT = ATT, teamDEF = DEF, 
                                     text = "level.eur.objectives.6c", 
                                     multiplayerRules = false }
	
	Objective6c.OnStart = function(self)
		-- Set up the trigger for the combat zone
		ActivateRegion("cz_s4_geolab")
		
    	local CZ_GeoLab = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_GeoLab: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_GeoLab"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone
    				SetupCombatZoneInit(currentZoneID, "eur_amb_04_combat")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_geolab")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_GeoLab)
    				CZ_GeoLab = nil
    			end
    		end,
    	"cz_s4_geolab"
    	)
	end
	
	Objective6c.OnComplete = function(self)
		--BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		
		DeactivateRegion("cz_s4_geolab")
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_04_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(3)
	end
	
	
	--==========================
	-- COMBAT ZONE : S4 -- ARTIFACT
	--==========================
	
 	GethPrimeTarget = TargetType:New{classname = gth_inf_prime, killLimit = 1, icon = "hud_objective_icon_circle", killedByPlayer = true}
	
	Objective7 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
									  text = "level.eur.objectives.7", 
									  popupText = "level.eur.objectives.7_popup", 
									  AIGoalWeight = 0}
	Objective7:AddTarget(GethPrimeTarget)
	
	Objective7.OnStart = function(self)
		BroadcastVoiceOver("EUR_obj_7", ATT)
		
		-- Switch back to exploration music
		--ScriptCB_PlayInGameMusic("eur_amb_04_explore")
		
		ActivateRegion("cz_s4_caves_1a")
		ActivateRegion("cz_s4_caves_1b")
		ActivateRegion("cz_s4_caves_1c")
		ActivateRegion("cz_s4_caves_2")
		ActivateRegion("cz_s4_caves_3")
		
		
		-- Set up the trigger for the Objective7a VO
		ActivateRegion("obj_7a_vo")
		
		local Obj_7a_VO = OnEnterRegion(
			function(region, player)
				if IsCharacterHuman(player) then
					BroadcastVoiceOver("EUR_obj_7a", ATT)
					
					DeactivateRegion("obj_7a_vo")
					ReleaseEnterRegion(Obj_7a_VO)
				end
			end,
		"obj_7a_vo"
		)
		
		-- Set up the trigger for Caves.1a
    	local CZ_Caves_1a = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Caves_1a: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_Caves_1a"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone (AND NO COMBAT MUSIC)
    				SetupCombatZoneInit(currentZoneID, "none")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_caves_1a")
    				
    				ResetTeamMemberLocations(SQD, "ps_s4_caves_1a")
    				
    				-- The player can only trigger 1 of the 3 first zones
    				ReleaseEnterRegion(CZ_Caves_1a)
    				ReleaseEnterRegion(CZ_Caves_1b)
    				ReleaseEnterRegion(CZ_Caves_1c)
    				CZ_Caves_1a = nil
    				CZ_Caves_1b = nil
    				CZ_Caves_1c = nil
    				
    				DeactivateRegion("cz_s4_caves_1a")
    				DeactivateRegion("cz_s4_caves_1b")
    				DeactivateRegion("cz_s4_caves_1c")
    			end
    		end,
    	"cz_s4_caves_1a"
    	)
		
		-- Set up the trigger for Caves.1b
    	local CZ_Caves_1b = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Caves_1b: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_Caves_1b"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone (AND NO COMBAT MUSIC)
    				SetupCombatZoneInit(currentZoneID, "none")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_caves_1b")
    				
    				ResetTeamMemberLocations(SQD, "ps_s4_caves_1b")
    				
    				-- The player can only trigger 1 of the 3 first zones
    				ReleaseEnterRegion(CZ_Caves_1a)
    				ReleaseEnterRegion(CZ_Caves_1b)
    				ReleaseEnterRegion(CZ_Caves_1c)
    				CZ_Caves_1a = nil
    				CZ_Caves_1b = nil
    				CZ_Caves_1c = nil
    				
    				DeactivateRegion("cz_s4_caves_1a")
    				DeactivateRegion("cz_s4_caves_1b")
    				DeactivateRegion("cz_s4_caves_1c")
    			end
    		end,
    	"cz_s4_caves_1b"
    	)
		
		-- Set up the trigger for Caves.1c
    	local CZ_Caves_1c = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Caves_1c: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_Caves_1c"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone (AND NO COMBAT MUSIC)
    				SetupCombatZoneInit(currentZoneID, "none")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_caves_1c")
    				
    				ResetTeamMemberLocations(SQD, "ps_s4_caves_1c")
    				
    				-- The player can only trigger 1 of the 3 first zones
    				ReleaseEnterRegion(CZ_Caves_1a)
    				ReleaseEnterRegion(CZ_Caves_1b)
    				ReleaseEnterRegion(CZ_Caves_1c)
    				CZ_Caves_1a = nil
    				CZ_Caves_1b = nil
    				CZ_Caves_1c = nil
    				
    				DeactivateRegion("cz_s4_caves_1a")
    				DeactivateRegion("cz_s4_caves_1b")
    				DeactivateRegion("cz_s4_caves_1c")
    			end
    		end,
    	"cz_s4_caves_1c"
    	)
		
		-- Set up the trigger for Caves.2
    	local CZ_Caves_2 = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Caves_2: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_Caves_2"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone (AND NO COMBAT MUSIC)
    				SetupCombatZoneInit(currentZoneID, "none")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_caves_2")
    				
    				ResetTeamMemberLocations(SQD, "ps_s4_caves_2")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_Caves_2)
    				CZ_Caves_2 = nil
    				
    				DeactivateRegion("cz_s4_caves_2")
    			end
    		end,
    	"cz_s4_caves_2"
    	)
		
		-- Set up the trigger for Caves.3
    	local CZ_Caves_3 = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Caves_3: Entered region")
    				
    				-- This combat zone's string ID
    				currentZoneID = "S4_Caves_3"
    				
    				-- Set up init params for combat zone
    				--SetupCombatZoneInit(currentZoneID)
    				
    				-- Start combat zone (AND NO COMBAT MUSIC)
    				SetupCombatZoneInit(currentZoneID, "none")
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_caves_3")
    				
    				ResetTeamMemberLocations(SQD, "ps_s4_caves_3")
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_Caves_3)
    				CZ_Caves_3 = nil
    				
    				DeactivateRegion("cz_s4_caves_3")
    			end
    		end,
    	"cz_s4_caves_3"
    	)
		
		-- Set up the trigger for Caves.Boss
    	local CZ_Caves_Boss = OnEnterRegion(
    		function(region, player)
    			if IsCharacterHuman(player) then
    				print("EURn_c.CZ_Caves_Boss: Entered region")
    				
    				-- Start playing the boss music
					ScriptCB_PlayInGameMusic("eur_amb_04_boss")
    				
    				-- Block the exits
    				BlockCombatZoneExits(3)
    				
    				-- Update the player's respawn point
    				SetRespawnPoint("ps_s4_boss")
    				
    				ResetTeamMemberLocations(SQD, "ps_s4_boss")
    				
    				ClearAIGoals(SQD)
    				AddAIGoal(SQD, "Deathmatch", 100)
    				
    				
    				Ambush("es_s4_caves_boss", 1, GethPrimes, 0.25)
    				Ambush("es_s4_caves_boss", 2, GethPawns)
    				
    				gethPawnCount = 4
    				gethSpecialCount = 4
    				
    				-- When each Geth Pawn dies
    				local GethKill = OnCharacterDeath(
    					function(player, killer)
    						
    						-- Which team did the victim belong to?
    						if GetCharacterTeam(player) == GethPawns then
	    						gethPawnCount = gethPawnCount - 1
	    						
	    						-- How many Geth Pawns are remaining?
	    						if gethPawnCount == 2 then
	    							Ambush("es_s4_caves_boss", 2, GethPawns)
	    						elseif gethPawnCount <= 0 then
	    							Ambush("es_s4_caves_boss", 2, GethSpecials)
	    						end
	    						
	    					elseif GetCharacterTeam(player) == GethSpecials then
	    						gethSpecialCount = gethSpecialCount - 1
	    						
	    						-- How many Geth Specials are remaining?
	    						if gethSpecialCount == 2 then
	    							Ambush("es_s4_caves_boss", 2, GethSpecials)
	    						elseif gethSpecialCount <= 0 then
	    							ReleaseCharacterDeath(GethKill)
	    						end
	    					end
    					end
    				)
    				
    				local BossKill = OnCharacterDeathClass(
    					function(player, killer)
    						if GetCharacterTeam(player) == GethPrimes then
    							-- Complete the objective
    							Objective7:Complete(ATT)
    							
    							ReleaseCharacterDeath(BossKill)
    						end
    					end,
    				gth_inf_prime
    				)
    				
    				
    				-- Disable this combat zone's trigger
    				ReleaseEnterRegion(CZ_Caves_Boss)
    				CZ_Caves_Boss = nil
    				
    				DeactivateRegion("cz_s4_caves_boss")
    			end
    		end,
    	"cz_s4_caves_boss"
    	)
	end
	
	Objective7.OnComplete = function(self)
		BroadcastVoiceOver("EUR_obj_victory", ATT)
		
		-- Switch back to exploration music
		ScriptCB_PlayInGameMusic("eur_amb_04_explore")
		
		-- Allow the player to leave
		UnblockCombatZoneExits(3)
	end
	
	
	DisableAIAutoBalance()
	
	
	-- Add debug functions to Fake Console
	if MEU_BuildVer == "production" then
		-- tell v1.3 to expect custom FC commands
		SupportsCustomFCCommands = true
		
		-- make sure we don't wipe out someone else's custom commands
		local moreCommands = nil
		if AddFCCommands ~= nil then
			moreCommands = AddFCCommands 
		end
		
		-- v1.3 will automatically call this for you at the proper times
		AddFCCommands = function()
			-- Add your custom commands here using ff_AddCommand() as show below
			
			-- attempts to teleport all enemy AI units to player 0's location
			ff_AddCommand(
				"Release Combat Zone",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					ReleaseCombatZone(currentZoneID)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Combat Zone Exits (0)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockCombatZoneExits(0)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Combat Zone Exits (1)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockCombatZoneExits(1)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Combat Zone Exits (2)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockCombatZoneExits(2)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Combat Zone Exits (3)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockCombatZoneExits(3)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Elevator Doors (0)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockElevatorDoors(0)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Elevator Doors (1)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockElevatorDoors(1)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Unblock Elevator Doors (3)",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					UnblockElevatorDoors(3)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Open Shuttle Door",		-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					OpenShuttleDoor()
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Squad Can Kill Enemies (true)",	-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					SetSquadCanKillEnemies(true)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			ff_AddCommand(
				"Squad Can Kill Enemies (false)",	-- name of the command
				nil,						-- command description.  If nil, defaults to mods.fakeconsole.description.<name without spaces> (example: mods.fakeconsole.description.MyEnemyAITeleport)
				function()					-- this function does whatever it is you want your command to do
					SetSquadCanKillEnemies(false)
				end,
				function()					 -- this function returns true when you want the command displayed in the FC menu
					return not ScriptCB_InNetGame()	--only shows command in singleplayer
				end
			)	-- end of ff_AddCommand's parameters
			
			
			-- process someone else's custom FC commands
			if moreCommands ~= nil then
				return moreCommands()
			end
		end
	end
    
end

function BeginObjectivesTimer()
	beginobjectivestimer = CreateTimer("beginobjectivestimer")
	OnTimerElapse(BeginObjectives, beginobjectivestimer)
	SetTimerValue(beginobjectivestimer, 12)
	StartTimer(beginobjectivestimer)
end

function BeginObjectives()
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6}
	objectiveSequence:AddObjectiveSet(Objective1)
	objectiveSequence:AddObjectiveSet(Objective2a)
	objectiveSequence:AddObjectiveSet(Objective2b)
	objectiveSequence:AddObjectiveSet(Objective3a)
	objectiveSequence:AddObjectiveSet(Objective3b)
	objectiveSequence:AddObjectiveSet(Objective3c)
	objectiveSequence:AddObjectiveSet(Objective3d)
	objectiveSequence:AddObjectiveSet(Objective3e)
	objectiveSequence:AddObjectiveSet(Objective3f)
	objectiveSequence:AddObjectiveSet(Objective4a)
	objectiveSequence:AddObjectiveSet(Objective4b)
	objectiveSequence:AddObjectiveSet(Objective4c)
	objectiveSequence:AddObjectiveSet(Objective5a)
	objectiveSequence:AddObjectiveSet(Objective5b)
	objectiveSequence:AddObjectiveSet(Objective5c)
	objectiveSequence:AddObjectiveSet(Objective6a)
	objectiveSequence:AddObjectiveSet(Objective6b)
	objectiveSequence:AddObjectiveSet(Objective6c)
	objectiveSequence:AddObjectiveSet(Objective7)
	
	objectiveSequence:Start()
end

function OpenShuttleDoor()
	-- Open the shuttle's door
	ScriptCB_SndPlaySound("kodiak_shuttle_door_open")
	
	PauseAnimation("shuttle_door")
	RewindAnimation("shuttle_door")
	PlayAnimation("shuttle_door")
end

function BeginOpeningCinematic()
	print("EURn_c.BeginOpeningCinematic: Entered")
	
	local briefingVO = {
							"EUR_brief_1a", 
							"EUR_brief_1b", 
							"EUR_brief_2a", 
							"EUR_brief_2b", 
							"EUR_brief_2c", 
							"EUR_brief_2d", 
							"EUR_brief_3a", 
							"EUR_brief_3b", 
							"EUR_brief_3c", 
							"EUR_brief_3d", 
							"EUR_brief_4a", 
							"EUR_brief_4b", 
							"EUR_brief_4c", 
						}
	
	local voDurations = {
							9.5, 	-- 1a
							10.5, 	-- 1b
							12.0, 	-- 2a
							7.5, 	-- 2b
							7.5, 	-- 2c
							2.0, 	-- 2d
							4.0, 	-- 3a
							11.5, 	-- 3b
							4.5, 	-- 3c
							6.0, 	-- 3d
							5.5, 	-- 4a
							7.0, 	-- 4b
							3.0,	-- 4c
						}
	
	---
	-- Call this to play the briefing VO based on index /id/ in the array /briefingVO/.
	-- 
	local function PlayVO(id)
		BroadcastVoiceOver(briefingVO[id], ATT)
	end
	
	-- cam_brief_cooper_1	=	40
	-- cam_brief_cmdr_1		=	50
	-- cam_brief_cmdr_2		=	45
	-- cam_brief_side_1		=	45
	-- cam_brief_squad_1	=	45
	
	-- Intro
	ShotIntro1 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_shuttles_intro", shotDuration = 13.0, startFOV = 40}
	
	-- Opening statements
	Shot1a = CameraShot:New{cameraClassName = "eur_prop_camera_side_1", cameraObj = "cam_brief_side_1", shotDuration = voDurations[1], startFOV = 45}
	Shot1b = CameraShot:New{cameraClassName = "eur_prop_camera_side_1", cameraObj = "cam_brief_side_1", shotDuration = voDurations[2], startFOV = 45}
	
	-- Mission context
	Shot2a = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_1", cameraObj = "cam_brief_cmdr_1", shotDuration = voDurations[3], startFOV = 50}
	Shot2b = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_1", cameraObj = "cam_brief_cmdr_1", shotDuration = voDurations[4], startFOV = 50}
	Shot2c = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_1", cameraObj = "cam_brief_cmdr_1", shotDuration = voDurations[5], startFOV = 50}
	Shot2d = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_1", cameraObj = "cam_brief_cmdr_1", shotDuration = voDurations[6], startFOV = 50}
	
	-- Objectives
	Shot3a = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_2", cameraObj = "cam_brief_cmdr_2", shotDuration = voDurations[7], startFOV = 45}
	Shot3b = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_2", cameraObj = "cam_brief_cmdr_2", shotDuration = voDurations[8], startFOV = 45}
	Shot3c = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_2", cameraObj = "cam_brief_cmdr_2", shotDuration = voDurations[9], startFOV = 45}
	Shot3d = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_2", cameraObj = "cam_brief_cmdr_2", shotDuration = voDurations[10], startFOV = 45}
	
	-- Closing statements
	Shot4a = CameraShot:New{cameraClassName = "eur_prop_camera_squad_1", cameraObj = "cam_brief_squad_1", shotDuration = voDurations[11], startFOV = 45}
	Shot4b = CameraShot:New{cameraClassName = "eur_prop_camera_squad_1", cameraObj = "cam_brief_squad_1", shotDuration = voDurations[12], startFOV = 45}
	Shot4c = CameraShot:New{cameraClassName = "eur_prop_camera_cmdr_1", cameraObj = "cam_brief_cmdr_1", shotDuration = voDurations[13], startFOV = 50}
	
	-- Shuttles sighting
	ShotShuttles1a = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_shuttles_flying_1", shotDuration = 4.0, startFOV = 50, zoomFOV = 20, zoomTime = 2.0}
	
	-- GARDIAN turrets
	ShotTurrets1 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_shuttles_turrets", shotDuration = 7.0, startFOV = 60}
	
	-- Shuttles ambush
	ShotShuttles1b = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_shuttles_flying_2", shotDuration = 7.45, startFOV = 60}	-- shotDuration changed from 8.0 to 7.45 (-0.55) -- 5-28-2016
	
	-- Shuttle landing
	ShotShuttles2a = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_shuttles_ground_2", shotDuration = 3.5, startFOV = 60}
	ShotShuttles2b = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_shuttles_ground_1", shotDuration = 5.65, startFOV = 50}
	
	
	ShotIntro1.OnStart = function(self)
		
		-- Play the intro animation
		RewindAnimation("shuttles_intro")
		PlayAnimation("shuttles_intro")
		
		-- Play the music stinger
		ScriptCB_PlayInGameMusic("eur_sting_01_intro")
		
		local flybySoundTimer = CreateTimer("flybySoundTimer")
		SetTimerValue(flybySoundTimer, 5.25)
		StartTimer(flybySoundTimer)
		
		flybySoundTimerElapse = OnTimerElapse(
			function(timer)
				ScriptCB_SndPlaySound("kodiak_shuttles_flyby")
				CinematicShakeCamera(0.1, 0.6, 1.42)
				
				ReleaseTimerElapse(flybySoundTimerElapse)
				DestroyTimer(flybySoundTimer)
			end,
		flybySoundTimer
		)
	end
	
	Shot1a.OnStart = function(self)
		PlayVO(1)
		
		ScriptCB_PlayInGameMusic("eur_amb_01b_briefing")
		
		RewindAnimation("shuttle_cin_shot1")
		PlayAnimation("shuttle_cin_shot1")
		
		--PushSubtitleSet("brief_1a")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_1a_1")
		ShowMessageText("level.eur.subtitles.brief_1a_2")
		ShowMessageText("level.eur.subtitles.brief_1a_3")
	end
	
	Shot1b.OnStart = function(self)
		PlayVO(2)
		--PushSubtitleSet("brief_1b")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_1b_1")
		ShowMessageText("level.eur.subtitles.brief_1b_2")
		ShowMessageText("level.eur.subtitles.brief_1b_3")
		ShowMessageText("level.eur.subtitles.brief_1b_4")
	end
	
	Shot2a.OnStart = function(self)
		PlayVO(3)
		
		PauseAnimation("shuttle_cin_shot1")
		
		--PushSubtitleSet("brief_2a")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_2a_1")
		ShowMessageText("level.eur.subtitles.brief_2a_2")
		ShowMessageText("level.eur.subtitles.brief_2a_3")
		ShowMessageText("level.eur.subtitles.brief_2a_4")
	end
	
	Shot2b.OnStart = function(self)
		PlayVO(4)
		--PushSubtitleSet("brief_2b")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_2b_1")
		ShowMessageText("level.eur.subtitles.brief_2b_2")
		ShowMessageText("level.eur.subtitles.brief_2b_3")
	end
	
	Shot2c.OnStart = function(self)
		PlayVO(5)
		--PushSubtitleSet("brief_2c")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_2c_1")
		ShowMessageText("level.eur.subtitles.brief_2c_2")
		ShowMessageText("level.eur.subtitles.brief_2c_3")
	end
	
	Shot2d.OnStart = function(self)
		PlayVO(6)
		--PushSubtitleSet("brief_2d")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_2d_1")
	end
	
	Shot3a.OnStart = function(self)
		PlayVO(7)
		--PushSubtitleSet("brief_3a")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_3a_1")
		
		-- Play the sounds for the map layout hologram
		ScriptCB_SndPlaySound("hologram_maplayout_sequence")
		--BroadcastVoiceOver("hologram_maplayout_sequence", ATT)
		
		-- Play the animation for the map layout hologram
		RewindAnimation("hologram_enter")
		PlayAnimation("hologram_enter")
	end
	
	Shot3b.OnStart = function(self)
		PlayVO(8)
		--PushSubtitleSet("brief_3b")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_3b_1")
		ShowMessageText("level.eur.subtitles.brief_3b_2")
		ShowMessageText("level.eur.subtitles.brief_3b_3")
		ShowMessageText("level.eur.subtitles.brief_3b_4")
	end
	
	Shot3c.OnStart = function(self)
		PlayVO(9)
		--PushSubtitleSet("brief_3c")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_3c_1")
		ShowMessageText("level.eur.subtitles.brief_3c_2")
	end
	
	Shot3d.OnStart = function(self)
		PlayVO(10)
		--PushSubtitleSet("brief_3d")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_3d_1")
		ShowMessageText("level.eur.subtitles.brief_3d_2")
	end
	
	Shot3d.OnComplete = function(self)
		PauseAnimation("hologram_enter")
		RewindAnimation("hologram_exit")
		PlayAnimation("hologram_exit")
	end
	
	Shot4a.OnStart = function(self)
		PlayVO(11)
		
		RewindAnimation("shuttle_cin_shot3")
		PlayAnimation("shuttle_cin_shot3")
		
		--PushSubtitleSet("brief_4a")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_4a_1")
		ShowMessageText("level.eur.subtitles.brief_4a_2")
		
		StartTimer(musicStingerAmbushTimer)
	end
	
	Shot4b.OnStart = function(self)
		PlayVO(12)
		--PushSubtitleSet("brief_4b")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_4b_1")
		ShowMessageText("level.eur.subtitles.brief_4b_2")
	end
	
	Shot4c.OnStart = function(self)
		PlayVO(13)
		
		--PauseAnimation("shuttle_cin_shot3")
		
		--PushSubtitleSet("brief_4c")
		ShowMessageText("level.eur.subtitles.newline")
		ShowMessageText("level.eur.subtitles.brief_4c_1")
	end
	
	ShotShuttles1a.OnStart = function(self)
		
		-- Spawn the spacedust pfx near the shuttles
		spacedustPfx = CreateEffect("eur_sfx_spacedust")
		AttachEffectToMatrix(spacedustPfx, GetPathPoint("spacedust_pfx", 0))
		
		
		RewindAnimation("shuttles_ambush")
		PlayAnimation("shuttles_ambush")
		
		RewindAnimation("shuttle_ambush_spin")
		PlayAnimation("shuttle_ambush_spin")
		
		--ScriptCB_SndPlaySound("kodiak_shuttle_ambush")
		--BroadcastVoiceOver("kodiak_shuttle_ambush", ATT)
		
		print("EURn_c.openingCinematicSequence.OnComplete(): Opening prop ambient stream...")
		ambientPropStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_prop_ambiance")
		
		print("EURn_c.openingCinematicSequence.OnComplete(): Opening prop ambient stream... Result = "..ambientPropStream)
		
		
		print("EURn_c.openingCinematicSequence.OnComplete(): Playing prop ambient stream...")
		play_ambientPropStream = PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl", 
						"kodiak_shuttle_ambush", "eur_shuttle_ambush", 1.0, "cinematicfx", ambientPropStream)
		
		--BroadcastVoiceOver("kodiak_shuttle_ambush", ATT)
		
		print("EURn_c.openingCinematicSequence.OnComplete(): Playing prop ambient stream... Result = "..play_ambientPropStream)
		
	end
	
	ShotTurrets1.OnStart = function(self)
		
		PauseAnimation("shuttles_ambush")
		PauseAnimation("shuttle_ambush_spin")
		
		local tur1FireCount = 0		-- How many times has turret 1 fired?
		local tur2FireCount = 0		-- How many times has turret 2 fired?
		local turFireCountMax = 3	-- How many times should the turrets fire?
		
		
		--------------------------
		-- FUNCTIONS
		--------------------------
		
		---
		-- Call this to fire one of the GARDIAN turrets based on /id/.
		-- @param #int id The turret to fire (either 0 or 1).
		local function FireTurret(id)
			-- Create the particle effect...
			local turPfx = CreateEffect("com_sfx_gardianturret_discharge")
			local turPfxPos = GetPathPoint("turrets_pfx", id)
			
			-- ...and attach it to its position
			AttachEffectToMatrix(turPfx, turPfxPos)
			
			-- Play the fire sound
			ScriptCB_SndPlaySound("gardian_laser_fire_layered")
		end
		
		
		--------------------------
		-- TIMERS
		--------------------------
		
		-- Delay before the turrets begin aiming
		local tursAimDelayTimer = CreateTimer("tursAimDelayTimer")
		SetTimerValue(tursAimDelayTimer, 0.5)
		
		-- The time it takes the turrets to aim
		local tursAimTimer = CreateTimer("tursAimTimer")
		SetTimerValue(tursAimTimer, 1.75)
		
		-- Delay before turret 1 fires
		local tur1FireDelayTimer = CreateTimer("tur1FireDelayTimer")
		SetTimerValue(tur1FireDelayTimer, 0.5)
		
		-- Delay before turret 2 fires
		local tur2FireDelayTimer = CreateTimer("tur2FireDelayTimer")
		SetTimerValue(tur2FireDelayTimer, 0.6)
		
		
		-- Begin sequence
		StartTimer(tursAimDelayTimer)
		
		
		--------------------------
		-- EVENT RESPONSES
		--------------------------
		
		-- Aim the turrets after a small delay
		local tursAimDelayTimerElapse = OnTimerElapse(
			function(timer)
				-- Aim the turrets
        		RewindAnimation("turrets_aim")
        		PlayAnimation("turrets_aim")
				
    			-- Play the aim sound
    			ScriptCB_SndPlaySound("gardian_turrets_aim_layered")
				
				-- Time the aim animation
				StartTimer(tursAimTimer)
				
				-- Garbage collection
				ReleaseTimerElapse(tursAimDelayTimerElapse)
				DestroyTimer(timer)
			end,
		tursAimDelayTimer
		)
		
		-- Start firing at the shuttles
		local tursAimTimerElapse = OnTimerElapse(
			function(timer)
				-- Begin firing sequence
				StartTimer(tur1FireDelayTimer)
				StartTimer(tur2FireDelayTimer)
				
				-- Garbage collection
				ReleaseTimerElapse(tursAimTimerElapse)
				DestroyTimer(timer)
			end,
		tursAimTimer
		)
		
		-- Fire turret 1 at the shuttles
		local tur1FireDelayTimerElapse = OnTimerElapse(
			function(timer)
				-- Increment the fire count
				tur1FireCount = tur1FireCount + 1
				
				-- Fire the turret
				FireTurret(0)
				
				
				-- Has this turret fired all 3 shots?
				if tur1FireCount >= turFireCountMax then
					-- Garbage collection
					DestroyTimer(timer)
					ReleaseTimerElapse(tur1FireDelayTimerElapse)
				else
    				-- If not, fire again
    				SetTimerValue(tur1FireDelayTimer, 1.5)
    				StartTimer(tur1FireDelayTimer)
				end
			end,
		tur1FireDelayTimer
		)
		
		-- Fire turret 2 at the shuttles
		local tur2FireDelayTimerElapse = OnTimerElapse(
			function(timer)
				-- Increment the fire count
				tur2FireCount = tur2FireCount + 1
				
				-- Fire the turret
				FireTurret(1)
				
				
				-- Has this turret fired all 3 shots?
				if tur2FireCount >= turFireCountMax then
					-- Garbage collection
					ReleaseTimerElapse(tur2FireDelayTimerElapse)
					DestroyTimer(timer)
				else
    				-- If not, fire again
    				SetTimerValue(tur2FireDelayTimer, 1.6)
    				StartTimer(tur2FireDelayTimer)
				end
			end,
		tur2FireDelayTimer
		)
	end
	
	ShotTurrets1.OnComplete = function(self)
		
		-- Resume animations at 4.0 secs in 
		PlayAnimation("shuttles_ambush")
		PlayAnimation("shuttle_ambush_spin")
		
		-- Timer for the shuttles_ambush animation
		ShuttlesAmbushTimer = CreateTimer("ShuttlesAmbushTimer")
		SetTimerValue(ShuttlesAmbushTimer, 20.0)
		StartTimer(ShuttlesAmbushTimer)
		
		-- When the shuttles_ambush timer elapses
		ShuttlesAmbushTimerElapse = OnTimerElapse(
			function(timer)
				PauseAnimation("shuttles_ambush")
				
				ReleaseTimerElapse(ShuttlesAmbushTimerElapse)
				DestroyTimer(ShuttlesAmbushTimer)
			end,
		ShuttlesAmbushTimer
		)
		
		
		-- Shuttle1 destruction timer
		local shuttle1DestTimer = CreateTimer("shuttle1DestTimer")
		SetTimerValue(shuttle1DestTimer, 3.5)
		
		-- Start countdown to destroy shuttle1
		StartTimer(shuttle1DestTimer)
		
		local shuttle1DestElapse = OnTimerElapse(
			function(timer)
				print("shuttle1DestElapse: Destroying shuttle")
				--PauseAnimation("shuttle_ambush_spin")
				
				local expPfx = CreateEffect("com_sfx_shuttle_explosion")
				local pfxPos = GetPathPoint("shuttle_pfx", 1)
				
				ScriptCB_SndPlaySound("kodiak_shuttle_1_explosion")
				
				-- Spawn the explosion pfx at shuttle2's associated path node
				AttachEffectToMatrix(expPfx, pfxPos)
				
				-- Kill shuttle1 manually to trigger the deathanimation
				SetProperty("shuttledest_1", "CurHealth", 0)
				
				-- Shake the camera
				CinematicShakeCamera(0.5, 0.35)
				
				DestroyTimer(shuttle1DestTimer)
				ReleaseTimerElapse(shuttle1DestElapse)
			end,
		shuttle1DestTimer
		)
		
		
		-- Shuttle2 destruction timer
		local shuttle2DestTimer = CreateTimer("shuttle2DestTimer")
		SetTimerValue(shuttle2DestTimer, 1.0)
		
		-- Start countdown to destroy shuttle2
		StartTimer(shuttle2DestTimer)
		
		local shuttle2DestElapse = OnTimerElapse(
			function(timer)
				print("shuttle2DestElapse: Destroying shuttle")
				
				local expPfx = CreateEffect("com_sfx_shuttle_explosion")
				local pfxPos = GetPathPoint("shuttle_pfx", 0)
				
				ScriptCB_SndPlaySound("kodiak_shuttle_2_explosion")
				
				-- Spawn the explosion pfx at shuttle2's associated path node
				AttachEffectToMatrix(expPfx, pfxPos)
				
				-- Trigger shuttle2's damage pfx
				SetProperty("shuttledest_2", "CurHealth", 800000)
				
				-- Shake the camera
				CinematicShakeCamera(0.5, 0.35)
				
				DestroyTimer(shuttle2DestTimer)
				ReleaseTimerElapse(shuttle2DestElapse)
			end,
		shuttle2DestTimer
		)
	end
	
	ShotShuttles1b.OnStart = function(self)
		
	end
	
	ShotShuttles1b.OnComplete = function(self)
		-- Remove the spacedust pfx from the game world
		RemoveEffect(spacedustPfx)
		
		-- Disable shuttle2's damage pfx
		SetProperty("shuttledest_2", "CurHealth", 10000)
	end
	
	ShotShuttles2a.OnStart = function(self)
		
		shuttleDustTimer = CreateTimer("shuttleDustTimer")
		SetTimerValue(shuttleDustTimer, 2.0)
		StartTimer(shuttleDustTimer)
		
		shuttleLandDustTimerElapse = OnTimerElapse(
			function(timer)
				-- Spawn dust pfx at shuttle landing spot
				shuttleLandPfx = CreateEffect("com_sfx_shuttle_dustwake")
				AttachEffectToMatrix(shuttleLandPfx, GetPathPoint("shuttledust_pfx", 0))
				
				ReleaseTimerElapse(shuttleLandDustTimerElapse)
				shuttleLandDustTimerElapse = nil
			end,
		shuttleDustTimer
		)
		
	end
	
	ShotShuttles2a.OnComplete = function(self)
		
	end
	
	ShotShuttles2b.OnStart = function(self)
		-- Stop emitting dust pfx
		RemoveEffect(shuttleLandPfx)
	end
	
	ShotShuttles2b.OnComplete = function(self)
		
	end
	
	
	--========================
	-- TRANSITIONS START
	--========================
	
	ShotTransition0 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 50}
	ShotTransition1 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 50}
	ShotTransition2 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 45}
	ShotTransition3 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 45}
	ShotTransition4 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 40}
	ShotTransition5a = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 60}
	ShotTransition5b = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 60}
	ShotTransition6 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 60}
	ShotTransition7 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 60}
	ShotTransition8 = CameraShot:New{cameraClassName = "eur_prop_camera", cameraObj = "cam_transition", shotDuration = 0.02, startFOV = 60}
	
	--========================
	-- TRANSITIONS END
	--========================
	
	
	openingCinematicSequence = CinematicContainer:New{pathName = "ps_start_shuttle"}
	openingCinematicSequence:AddShot(ShotIntro1)
	openingCinematicSequence:AddShot(ShotTransition0)
	openingCinematicSequence:AddShot(Shot1a)
	openingCinematicSequence:AddShot(Shot1b)
	openingCinematicSequence:AddShot(ShotTransition1)
	openingCinematicSequence:AddShot(Shot2a)
	openingCinematicSequence:AddShot(Shot2b)
	openingCinematicSequence:AddShot(Shot2c)
	openingCinematicSequence:AddShot(Shot2d)
	openingCinematicSequence:AddShot(ShotTransition2)
	openingCinematicSequence:AddShot(Shot3a)
	openingCinematicSequence:AddShot(Shot3b)
	openingCinematicSequence:AddShot(Shot3c)
	openingCinematicSequence:AddShot(Shot3d)
	openingCinematicSequence:AddShot(ShotTransition3)
	openingCinematicSequence:AddShot(Shot4a)
	openingCinematicSequence:AddShot(Shot4b)
	openingCinematicSequence:AddShot(ShotTransition4)
	openingCinematicSequence:AddShot(Shot4c)
	openingCinematicSequence:AddShot(ShotTransition5a)
	openingCinematicSequence:AddShot(ShotShuttles1a)
	openingCinematicSequence:AddShot(ShotTransition5b)
	openingCinematicSequence:AddShot(ShotTurrets1)
	openingCinematicSequence:AddShot(ShotTransition6)
	openingCinematicSequence:AddShot(ShotShuttles1b)
	openingCinematicSequence:AddShot(ShotTransition7)
	openingCinematicSequence:AddShot(ShotShuttles2a)
	openingCinematicSequence:AddShot(ShotTransition8)
	openingCinematicSequence:AddShot(ShotShuttles2b)
	
	openingCinematicSequence.OnStart = function(self)
		--AddIFScreen(ifs_cinematic_overlay,"ifs_cinematic_overlay")
		--ScriptCB_PushScreen("ifs_cinematic_overlay")
		--ifs_cinematic_overlay.Container = openingCinematicSequence
		
		-- Mute the weaponfoley audio bus
		MuteAudioBus("weaponfoley")
		
		-- 'Ambush' music stinger timer
		musicStingerAmbushTimer = CreateTimer("musicStingerAmbushTimer")
		SetTimerValue(musicStingerAmbushTimer, 12.3)	-- Originally 12.617, offset by -0.317 seconds
		musicStingerAmbushTimerElapse = OnTimerElapse(
			function(timer)
				-- Play the music stinger
				ScriptCB_PlayInGameMusic("eur_sting_02_ambush")
				
				DestroyTimer(timer)
				ReleaseTimerElapse(musicStingerAmbushTimerElapse)
			end,
		musicStingerAmbushTimer
		)
	end
	
	openingCinematicSequence.OnComplete = function(self)
		--ifs_cinematic_overlay.PullScreen()
		
		-- Unmute the weaponfoley audio bus
		UnmuteAudioBus("weaponfoley", 0.7)
		
		-- Switch music tracks
        ScriptCB_PlayInGameMusic("eur_amb_01a_explore")
        
        -- Allow squad AI to spawn
		AllowAISpawn(SQD, true)
		
		-- Open the shuttle's door
		ScriptCB_SndPlaySound("kodiak_shuttle_door_open")
		PauseAnimation("shuttle_door")
		RewindAnimation("shuttle_door")
		PlayAnimation("shuttle_door")
		
		ActivateRegion("shuttle_exit")
		ShuttleExitTrigger = OnEnterRegion(
			function(region, player)
				if IsCharacterHuman(player) then
					ReleaseEnterRegion(ShuttleExitTrigger)
					ShuttleExitTrigger = nil
					
					-- Player's squad defends the player after exiting the shuttle.
					ClearAIGoals(SQD)
					AddAIGoal(SQD, "Defend", 100, 0)
					
					
					-- Close the shuttle's door
					ScriptCB_SndPlaySound("kodiak_shuttle_door_close")
					SetProperty("shuttle_takeoff", "CurHealth", 0)
					
					local doorCloseTimer = CreateTimer("shuttle_door_close_timer")
					SetTimerValue(doorCloseTimer, 2.0)
					StartTimer(doorCloseTimer)
					
					local doorCloseTimerElapse = OnTimerElapse(
						function(timer)
							RewindAnimation("shuttle_takeoff")
							PlayAnimation("shuttle_takeoff")
							
							ScriptCB_SndPlaySound("kodiak_shuttle_takeoff")
							--BroadcastVoiceOver("kodiak_shuttle_takeoff", ATT)
							
							-- Spawn thruster pfx
							local thruster_1 = CreateEffect("com_sfx_shuttle_thruster_start")
							local thruster_1_pos = GetPathPoint("takeoff_pfx", 0)
							
							local thruster_2 = CreateEffect("com_sfx_shuttle_thruster_start")
							local thruster_2_pos = GetPathPoint("takeoff_pfx", 1)
							
							local thruster_3 = CreateEffect("com_sfx_shuttle_thruster_start")
							local thruster_3_pos = GetPathPoint("takeoff_pfx", 2)
							
							local thruster_4 = CreateEffect("com_sfx_shuttle_thruster_start")
							local thruster_4_pos = GetPathPoint("takeoff_pfx", 3)
							
							AttachEffectToMatrix(thruster_1, thruster_1_pos)
							AttachEffectToMatrix(thruster_2, thruster_2_pos)
							AttachEffectToMatrix(thruster_3, thruster_3_pos)
							AttachEffectToMatrix(thruster_4, thruster_4_pos)
							
							
							-- Spawn dust pfx at shuttle landing spot
							shuttleTakeoffPfx = CreateEffect("com_sfx_shuttle_dustwake")
							AttachEffectToMatrix(shuttleTakeoffPfx, GetPathPoint("shuttledust_pfx", 0))
							
							SetTimerValue(shuttleDustTimer, 2.5)
							StartTimer(shuttleDustTimer)
							
							shuttleTakeoffDustTimerElapse = OnTimerElapse(
								function(timer)
									-- Stop emitting dust pfx
									RemoveEffect(shuttleTakeoffPfx)
									
									DestroyTimer(timer)
									ReleaseTimerElapse(shuttleTakeoffDustTimerElapse)
									shuttleDustTimer = nil
									shuttleTakeoffDustTimerElapse = nil
								end,
							shuttleDustTimer
							)
							
				            -- Start the objectives delay
				        	BeginObjectivesTimer()
							
							
							ReleaseTimerElapse(doorCloseTimerElapse)
							DestroyTimer(timer)
						end,
					doorCloseTimer
					)
		        	
				end
			end,
		"shuttle_exit"
		)
		
		
		local streamTimer = CreateTimer("streamTimer")
		SetTimerValue(streamTimer, 5)
		--ShowTimer(streamTimer)
		StartTimer(streamTimer)
		
		local streamTimerElapse = OnTimerElapse(
			function(timer)
				-- Close the prop stream
				print("EURn_c.openingCinematicSequence.OnComplete(): Closing prop stream")
				StopAudioStream(ambientPropStream, 1)
				
				-- Open the second ambient stream
				print("EURn_c.openingCinematicSequence.OnComplete(): Opening second ambient stream...")
				ambientStream2 = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
				
				print("EURn_c.openingCinematicSequence.OnComplete(): Opening second ambient stream... Result = "..ambientStream2)
				
				DestroyTimer(timer)
				ReleaseTimerElapse(streamTimerElapse)
			end,
		streamTimer
		)
		
	end
	
	openingCinematicSequence:Start()
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
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\eur.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2188)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1293)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1409)
	
	manager:Proc_ScriptInit_Begin()
	
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
    
	Load_SSV(gLoadCooper)
	Load_GTH()
	
	
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
			units = 4,
			reinforcements = -1,
			soldier  = { ssv_inf_soldier,1, 1},
			sniper  = { ssv_inf_infiltrator,1, 1},
			adept = { ssv_inf_adept,1, 1},
			engineer   = { ssv_inf_engineer,1, 1},
			sentinel = { ssv_inf_sentinel,1, 1},
			vanguard = { ssv_inf_vanguard,1, 1},
		},
	    
	    -- Geth classes
		
		--[[husks = {
			team = GethHusks,
			units = 100,
			reinforcements = -1,
			soldier = { "indoc_inf_husk",9, 12},
		},]]
		
		neu = {
			team = GethPawns,
			units = 100,
			reinforcements = -1,
			soldier = { gth_inf_trooper,9, 60},		-- 9, 12
			rocketeer = { gth_inf_rocketeer,5, 60},	-- 5, 8
		},
		
		neutral = {
			team = GethTacticals,
			units = 100,
			reinforcements = -1,
			sniper = { gth_inf_sniper,9, 60},	-- 9, 16
			hunter = { gth_inf_hunter,7, 60},	-- 7, 14
		},
		
		all = {
			team = GethSpecials,
			units = 100,
			reinforcements = -1,
			engineer = { gth_inf_machinist,5, 60},	-- 5, 12
			shock = { gth_inf_shock,7, 60},			-- 7, 15
		},
		
		alliance = {
			team = GethHeavys,
			units = 100,
			reinforcements = -1,
			destroyer = { gth_inf_destroyer,7, 60},		-- 7, 14
			juggernaut = { gth_inf_juggernaut,5, 60},	-- 5, 12
		},
		
		empire = {
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
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl")
	
	
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
    SetMemoryPoolSize("SoundSpaceRegion", 24)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\EUR.lvl", "EUR_campaign")
    SetDenseEnvironment("true")
    --AddDeathRegion("deathregion")
	
	
    -- Sound
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl")
	
	musicStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl",  "ME5n_music_EUR")
	--stingerStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl",  "ME5n_stingers_EUR")
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl", "ME5n_music_EUR", stingerStream)
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_EUR_Streaming.lvl", "ME5n_stingers_EUR", musicStream)
	
	ambientStream1 = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	--ambientStream2 = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl", "EUR_prop_ambiance", ambientStream)
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EUR_Streaming.lvl",  "EUR_ambiance")
	
	SetVictoryMusic(REP, "eur_amb_01_victory")
	SetDefeatMusic (REP, "eur_amb_01_defeat")
	SetVictoryMusic(CIS, "eur_amb_01_victory")
	SetDefeatMusic (CIS, "eur_amb_01_defeat")
	
	SetAttackingTeam(ATT)
	
    SoundFX()
	
	
	-- Opening satellite shots
	AddCameraShot(-0.461276, -0.061869, -0.877234, 0.117716, -51.108570, 127.905670, 150.074707);
	
	manager:Proc_ScriptInit_End()
end
