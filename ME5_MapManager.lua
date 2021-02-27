-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Map Manager Script by Aaron Gilbert
-- Build 31203/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Dec 3, 2016
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  TODO: fill this in!
-- 
-- 
-- Usage: 
--  TODO: fill this in!
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_MapManager: Entered")

--=================================
-- MapManager
--=================================

---
-- This is a constructor for a MapManager object.
-- @param #bool bIsModMap					Whether or not this is a mod map (as opposed to a stock map). Used for scaling the gain of the "ambientenv" sound group. (default : `false`)
-- @param #string gameMode					Name of this mission's game mode. Possible values:  
-- 											 `"conquest"` : Conquest  
-- 											 `"1flag"` : 1-Flag CTF  
-- 											 `"ctf"` : 2-Flag CTF  
-- 											 `"tdm"` : Team Deathmatch  
-- 											 `"siege"` : Siege  
-- 											 `"survival"` : Survival  
-- 											 `"campaign"` : Campaign  
-- @param #string mapSize					Size of the map. Used for determining unit counts. Possible values:  
-- 											 `"xxs"` : Around 7 units per team  
-- 											 `"xs"` : Around 13 units per team  
-- 											 `"sm"` : Around 15 units per team  
-- 											 `"med"` : Around 23 units per team  
-- 											 `"lg"` : Around 28 units per team  
-- 											 `"xl"` : Around 34 units per team  
-- @param #string environmentType			Map's biome (essentially). Used for determining which camo textures to load. Possible values:  
-- 											 `"desert"` : Light-brown camo
-- 											 `"jungle"` : Dark-green camo  
-- 											 `"snow"` : Light-grey camo  
-- 											 `"urban"` : Dark-grey camo
-- @param #string musicVariation_SSVxGTH	Music variation to use for SSVxGTH matches. Possible values:  
-- 											 `"1"` : Various music from ME1 - notably Eden Prime and Therum  
-- 											 `"2"` : Collector attack music from ME2  
-- 											 `"3"` : Various music from ME1 - notably Noveria and Virmire  
-- 											 `"3_nov"` : Only the Noveria music used in `"3"`  
-- 											 `"3_vrm"` : Only the Virmire music used in `"3"`  
-- 											 `"4"` : Randomly-selected squadmate's music from ME2  
-- 											 `"4_1"` or `"4_samara"` : Samara's squadmate music from ME2  
-- 											 `"4_2"` or `"4_grunt"` : Grunt's squadmate music from ME2  
-- 											 `"4_3"` or `"4_tali"` : Tali's squadmate music from ME2  
-- 											 `"4_4"` or `"4_infiltration"` : The infiltration music from ME2  
-- 											 `"4_5"` or `"4_thane"` : Thane's squadmate music from ME2  
-- 											 `"4_6"` or `"4_jack"` : Jack's squadmate music from ME2  
-- 											 `"5"` : Collector music from ME2 and ME3 Leviathan DLC - notably the Horizon, Long Walk, Paragon Lost, and Mahavid Mines suites  
-- 											 `"5_1"` or `"5_longwalk"` : The Long Walk suite from ME2  
-- 											 `"5_2"` or `"5_horizon"` : Horizon suite from ME2  
-- 											 `"5_3"` or `"5_paragon"` : Paragon Lost suite from Mass Effect: Paragon Lost  
-- 											 `"5_4"` or `"5_mahavid"` : Mahavid Mines suite from ME3 Leviathan DLC  
-- 											 `"6"` : Overlord and Shadow Broker suites from the associated ME2 DLC  
-- 											 `"6_1"` or `"6_longwalk"` : Overlord suite from ME2 Overlord DLC  
-- 											 `"6_2"` or `"6_horizon"` : Shadow Broker suite from ME2 Lair of the Shadow Broker DLC  
-- 											 `"7"` : Cerberus music from ME3  
-- 											 `"8"` : Reaper music from ME3  
-- 											 `"9"` : Evolved Geth music, taken from Far Cry 3's OST  
-- @param #string musicVariation_SSVxCOL	Music variation to use for SSVxCOL matches. Possible values are the same as `musicVariation_SSVxGTH`.  
-- @param #string musicVariation_EVGxGTH	Music variation to use for EVGxGTH matches. Possible values are the same as `musicVariation_SSVxGTH`.  
-- @param #string musicVariation_EVGxCOL	Music variation to use for EVGxCOL matches. Possible values are the same as `musicVariation_SSVxGTH`.  
-- @param #string onlineSideVar				Side variation to use in online matches. Possible values:  
-- 											 `"SSVxGTH"` : Systems Alliance vs. Heretic Geth  
-- 											 `"SSVxCOL"` : Systems Alliance vs. Collectors  
-- 											 `"EVGxGTH"` : Evolved Geth vs. Heretic Geth  
-- 											 `"EVGxCOL"` : Evolved Geth vs. Collectors  
-- @param #string onlineHeroSSV				SSV hero to use in online matches. Possible values:  
-- 											 `"shep_soldier"` : Commander Shepard (Soldier)  
-- 											 `"shep_infiltrator"` : Commander Shepard (Infiltrator)  
-- 											 `"shep_engineer"` : Commander Shepard (Engineer)  
-- 											 `"shep_adept"` : Commander Shepard (Adept)  
-- 											 `"shep_sentinel"` : Commander Shepard (Sentinel)  
-- 											 `"shep_vanguard"` : Commander Shepard (Vanguard)  
-- 											 `"jack"` : Jack  
-- @param #string onlineHeroGTH				GTH hero to use in online matches. Possible values:  
-- 											 `"gethprime_me2"` : Geth Prime (ME2)  
-- 											 `"gethprime_me3"` : Geth Prime (ME3)  
-- @param #string onlineHeroCOL				COL hero to use in online matches. Possible values:  
-- 											 `"colgeneral"` : Harbinger  
-- @param #string onlineHeroEVG				EVG hero to use in online matches. Possible values:  
-- 											 `"gethprime_me2"` : Geth Prime (ME2)  
-- 											 `"gethprime_me3"` : Geth Prime (ME3)  
-- @param #table heroSupportCPs				2D table of AI hero spawns. Set to nil or leave blank to disable heroes. First column is CP names, second column is CP spawn path names.
-- @param #table allySpawnCPs				2D table of local ally spawns. Set to nil or leave blank to disable local allies. First column is CP names, second column is CP spawn path names.
-- @param #string artilleryTurObj			OPTIONAL: Name of the artillery turret object. Only specify this if you're using a custom artillery turret object.
-- @param #table artilleryNodes				OPTIONAL: 2D table listing nodes to strike at. Set to nil or leave blank to disable artillery strikes. First column is path names, 
-- 											 second column is path node IDs.
-- @param #float artilleryStrikeInitDelay	OPTIONAL: Length of time in seconds to wait before the first strike occurs. Set to 0 to disable initial delay completely. (default value : `60.0`)
-- @param #float artilleryStrikeDelay		OPTIONAL: The length of time in seconds to wait before each strike occurs. Value must be >= 10.0. (default value : `35.0`)
-- @param #string terrainType				OPTIONAL: Type of terrain in the map. Used for determining which artillery debris textures to load. Possible values:  
-- 											 `"dirt"`  
-- 											 `"snow"`  
-- 											 `"sand"`  
-- @param #bool bDebug						OPTIONAL: Whether or not to print/display debug messages.
-- @return									MapManager object and its values.
MapManager = {
	-- Fields that need to be specified on creation
	bIsModMap = false,					-- Whether or not this is a mod map (as opposed to a stock map). Used for scaling the gain of the "ambientenv" sound group.
	gameMode = nil,						-- This mission's game mode.
	mapSize = nil,						-- Size of the map. Used for determining unit counts.
	environmentType = nil,				-- Map's biome (essentially). Used for determining which camo textures to load.
	
	musicVariation_SSVxGTH = nil,		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = nil,		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = nil,		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = nil,		-- Music variation to use for EVGxCOL matches.
	musicVariation_SSVxRPR = nil,		-- Music variation to use for SSVxRPR matches.
	
	onlineSideVar = nil,				-- Side variation to use in online matches.
	onlineHeroSSV = nil,				-- SSV hero to use in online matches.
	onlineHeroGTH = nil,				-- GTH hero to use in online matches.
	onlineHeroCOL = nil,				-- COL hero to use in online matches.
	onlineHeroEVG = nil,				-- EVG hero to use in online matches.
	
	heroSupportCPs = nil,				-- AI hero spawns. First column is CP names, second column is CP spawn path names.
	allySpawnCPs = nil,					-- Local ally spawns. First column is CP names, second column is CP spawn path names.
	
	-- Optional fields
	artilleryTurObj = nil,				-- The name of the artillery turret object. Only specify this if you're using a custom artillery turret object.
	artilleryNodes = nil,				-- Two-dimensional array listing nodes to strike at. Set to nil or leave blank to disable artillery strikes. 
										--  First column is path names, second column is path node IDs.
	artilleryStrikeInitDelay = 60.0,	-- The length of time in seconds to wait before the first strike occurs. Set to 0 to disable initial delay completely. Default value: 60.0
	artilleryStrikeDelay = 35.0,		-- The length of time in seconds to wait before each strike occurs. Value must be >= 10.0. Default value: 35.0
	terrainType = nil,					-- Type of terrain in the map. Used for determining which artillery debris textures to load.
	
	bDebug = false,						-- Whether or not to print/display debug messages.
	
	-- Fields that are handled internally
	bAreHeroesEnabled = true,			-- Whether or not heroes are enabled.
	bAreLocalAlliesEnabled = true,		-- Whether or not local allies are enabled.
	bIsArtilleryEnabled = false,		-- Whether or not artillery strikes are enabled
	bIsArtilleryTurObjCustom = false,	-- Whether or not a custom artillery turret object has been specified
}


----
-- Creates a new MapManager.
--
function MapManager:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


----
-- Initializes the MapManager's data fields.
--
function MapManager:Init()
	-- Map-specific aesthetics
	if self.gameMode == nil then
		print("MapManager:Init(): WARNING: gameMode must be specified! Exiting function")
	return end
	if self.mapSize == nil then
		print("MapManager:Init(): WARNING: mapSize must be specified! Exiting function")
	return end
	if self.environmentType == nil then
		print("MapManager:Init(): WARNING: environmentType wasn't specified! Defaulting to Urban")
		self.environmentType = "urban"
	end
	
	-- Online multiplayer matches
	if self.onlineSideVar == nil then
		print("MapManager:Init(): WARNING: onlineSideVar wasn't specified! Defaulting to SSVxGTH")
		self.onlineSideVar = "SSVxGTH"
	end
	if self.onlineHeroSSV == nil then
		print("MapManager:Init(): WARNING: onlineHeroSSV wasn't specified! Defaulting to shep_soldier")
		self.onlineHeroSSV = "shep_soldier"
	end
	if self.onlineHeroGTH == nil then
		print("MapManager:Init(): WARNING: onlineHeroGTH wasn't specified! Defaulting to gethprime_me2")
		self.onlineHeroGTH = "gethprime_me2"
	end
	if self.onlineHeroCOL == nil then
		print("MapManager:Init(): WARNING: onlineHeroCOL wasn't specified! Defaulting to colgeneral")
		self.onlineHeroCOL = "colgeneral"
	end
	if self.onlineHeroEVG == nil then
		print("MapManager:Init(): WARNING: onlineHeroEVG wasn't specified! Defaulting to gethprime_me3")
		self.onlineHeroEVG = "gethprime_me3"
	end
	
	-- AI heroes and local allies
	if self.heroSupportCPs == {} or self.heroSupportCPs == nil then
		print("MapManager:Init(): WARNING: heroSupportCPs wasn't specified! Heroes will be disabled")
		self.bAreHeroesEnabled = false
	end
	if self.allySpawnCPs == {} or self.allySpawnCPs == nil then
		print("MapManager:Init(): WARNING: allySpawnCPs wasn't specified! Local allies will be disabled")
		self.bAreLocalAlliesEnabled = false
	end
	
	-- Auto-fill any empty fields
	self.musicVariation_SSVxGTH = self.musicVariation_SSVxGTH or "1"
	self.musicVariation_SSVxCOL = self.musicVariation_SSVxCOL or "2"
	self.musicVariation_EVGxGTH = self.musicVariation_EVGxGTH or "9"
	self.musicVariation_EVGxCOL = self.musicVariation_EVGxCOL or "9"
	self.musicVariation_SSVxRPR = self.musicVariation_SSVxRPR or "8"
	self.artilleryTurObj = self.artilleryTurObj or "artillery1"
	
	-- Artillery strikes
	if self.artilleryNodes ~= nil then
		-- Artillery strikes are a go
		self.bIsArtilleryEnabled = true
		
		-- Check if the artillery object is custom
		if self.artilleryTurObj ~= "artillery1" then
			self.bIsArtilleryTurObjCustom = true
		end
	end
	
	
	-- Notify the other scripts that we're the captain now
	gCurrentMapManager = self
end


---
-- Call this at the beginning of ScriptInit (but after the loadscreen line and any ParticleTransformer memory pool lines).  
-- 
-- Performs various pre-game operations, such as loading commonly used data files,
-- Carnage mode setup, HUD work, and running event response functions for features such as
-- kill sounds, Evolved Juggernaut's Power Drain, and shield pickups.
-- 
function MapManager:Proc_ScriptInit_Begin()
	print("MapManager:Proc_ScriptInit_Begin(): Entered")
	
	-- Load our custom loadscreen elements such as progress bar LEDs, tip box elements, etc.
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\common.lvl")
	
	--Init_HeroMusic()
	
	-- What is the difficulty set to in the Config Tool?
	if not ScriptCB_InMultiplayer() then
		if ME5_Difficulty == 1 then
			print("MapManager:Proc_ScriptInit_Begin(): Initializing difficulty parameters for CASUAL...")
			SetAIDifficulty(1, -1)
			SetTeamAggressiveness(CIS,(0.63))
			SetTeamAggressiveness(REP,(0.63))
			
		elseif ME5_Difficulty == 2 then
			print("MapManager:Proc_ScriptInit_Begin(): Initializing difficulty parameters for NORMAL...")
			SetAIDifficulty(0, 0)
			SetTeamAggressiveness(CIS,(0.73))
			SetTeamAggressiveness(REP,(0.73))
			
		elseif ME5_Difficulty == 3 then
			print("MapManager:Proc_ScriptInit_Begin(): Initializing difficulty parameters for VETERAN...")
			SetAIDifficulty(-1, 1)
			SetTeamAggressiveness(CIS,(0.83))
			SetTeamAggressiveness(REP,(0.83))
			
		elseif ME5_Difficulty == 4 then
			print("MapManager:Proc_ScriptInit_Begin(): Initializing difficulty parameters for HARDCORE...")
			SetAIDifficulty(-2, 2)
			SetTeamAggressiveness(CIS,(0.93))
			SetTeamAggressiveness(REP,(0.93))
			
		elseif ME5_Difficulty == 5 then
			print("MapManager:Proc_ScriptInit_Begin(): Initializing difficulty parameters for INSANITY...")
			SetAIDifficulty(-3, 3)
			SetTeamAggressiveness(CIS,(1.0))
			SetTeamAggressiveness(REP,(1.0))
			
		else
			print("MapManager:Proc_ScriptInit_Begin(): Error! ME5_Difficulty setting is invalid! Defaulting to difficulty parameters for HARDCORE")
			SetAIDifficulty(-2, 2)
			SetTeamAggressiveness(CIS,(0.93))
			SetTeamAggressiveness(REP,(0.93))
		end
	else
		print("MapManager:Proc_ScriptInit_Begin(): Initializing difficulty parameters for MULTIPLAYER...")
		-- NOTE: Apply a difficulty setting located between Hardcore and Insanity
		SetAIDifficulty(-2, 2)
		SetTeamAggressiveness(CIS,(0.95))
		SetTeamAggressiveness(REP,(0.95))
	end
	
	-- What is Carnage Mode set to in the Config Tool?
	if not ScriptCB_InMultiplayer() then
		if ME5_CarnageMode == 0 then
			print("MapManager:Proc_ScriptInit_Begin(): Carnage Mode is DISABLED, deactivating weapon modifiers...")
		elseif ME5_CarnageMode == 1 then
			print("MapManager:Proc_ScriptInit_Begin(): Carnage Mode is ENABLED, activating weapon modifiers...")
			ActivateBonus(REP, "team_bonus_advanced_blasters")
			ActivateBonus(CIS, "team_bonus_advanced_blasters")
		else
			print("MapManager:Proc_ScriptInit_Begin(): Error! ME5_CarnageMode setting is invalid! Defaulting Carnage Mode setting to DISABLED")
		end
	else
		print("MapManager:Proc_ScriptInit_Begin(): Carnage Mode is ENABLED (MULTIPLAYER), activating weapon modifiers...")
		ActivateBonus(REP, "team_bonus_advanced_blasters")
		ActivateBonus(CIS, "team_bonus_advanced_blasters")
	end
	
	-- Load the appropriate faction CP icons
	-- Which faction variation is active?
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif ME5_SideVar == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		elseif ME5_SideVar == 3	then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif ME5_SideVar == 4	then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		elseif ME5_SideVar == 5	then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		end
	else
		if self.onlineSideVar == "SSVxGTH" or self.onlineSideVar == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif self.onlineSideVar == "SSVxCOL" or self.onlineSideVar == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		elseif self.onlineSideVar == "EVGxGTH" or self.onlineSideVar == 3 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif self.onlineSideVar == "EVGxCOL" or self.onlineSideVar == 4 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		elseif self.onlineSideVar == "SSVxRPR" or self.onlineSideVar == 5 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		end
	end
	
	-- Load our custom shell stuff
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\common.lvl")
	
	-- What is the shell style set to in the Config Tool?
	if ME5_CustomGUIEnabled == 1 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\me5shell.lvl")
	elseif ME5_CustomGUIEnabled == 2 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\me3shell.lvl")
	end
	
	-- Load localization
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\corebase.lvl")
	
	
	-- Get the player's aspect ratio so we can load the proper sniperscope sizes
	local screenWidth, screenHeight = ScriptCB_GetScreenInfo()
	local aspectRatio = screenWidth / screenHeight
	print("MapManager:Proc_ScriptInit_Begin():", "Width: "..screenWidth, "Height: "..screenHeight..", Aspect Ratio: "..aspectRatio)
	
	
	--==========================
	-- START HUD WORK
	--==========================
	
	-- Is the custom HUD enabled in the Config Tool?
	if ME5_CustomHUD == 1 then
		print("MapManager:Proc_ScriptInit_Begin(): Loading custom HUD")
		
		-- Load the Myriad Pro fonts
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font.lvl")
		
		-- Load the Korataki fonts
		-- Is the player screen's width greater than or equal to 1440?
		if screenWidth >= 1440 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_large.lvl")
		else
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_small.lvl")
		end
		
		-- Load MEU's ingame.lvl
		if not ScriptCB_InMultiplayer() then
			if ME5_SideVar == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxGTH.lvl")
			elseif ME5_SideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxCOL.lvl")
			elseif ME5_SideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxGTH.lvl")
			elseif ME5_SideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxCOL.lvl")
			elseif ME5_SideVar == 5 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxRPR.lvl")
			end
		else
			if self.onlineSideVar == "SSVxGTH" or self.onlineSideVar == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxGTH.lvl")
			elseif self.onlineSideVar == "SSVxCOL" or self.onlineSideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxCOL.lvl")
			elseif self.onlineSideVar == "EVGxGTH" or self.onlineSideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxGTH.lvl")
			elseif self.onlineSideVar == "EVGxCOL" or self.onlineSideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxCOL.lvl")
			elseif self.onlineSideVar == "SSVxRPR" or self.onlineSideVar == 5 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxRPR.lvl")
			end
		end
    	
    	-- Purge the stock HUD mshs
    	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_msh.lvl")
    	
    	-- Load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
		
		-- Purge the stock HUD textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_bmp.lvl")
		
		-- Purge the stock objective markers
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_obj_marker.lvl;stock")
		
		-- Load the new custom HUD and the objective screen text based on the game mode
		-- What is the active game mode? (NOTE: This is set near the beginning of each game mode's objective script)
		if self.gameMode == "1flag" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_1flag.lvl")
		elseif self.gameMode == "conquest" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_con.lvl")
		elseif self.gameMode == "ctf" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_ctf.lvl")
		elseif self.gameMode == "siege" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_siege.lvl")
		elseif self.gameMode == "survival" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_surv.lvl")
		elseif self.gameMode == "tdm" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_tdm.lvl")
		elseif self.gameMode == "campaign" then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_mode_campaign.lvl")
		else
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
		end
		
		-- Load weapons.lvl for the MEU HUD
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\weapons.lvl;hud_meu")
		
		-- Hotfix that overrides the stock fonts with a "blank font"
		--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_text.lvl")
	else
		-- Load MEU's ingame.lvl
		if not ScriptCB_InMultiplayer() then
			if ME5_SideVar == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxGTH.lvl")
			elseif ME5_SideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxCOL.lvl")
			elseif ME5_SideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxGTH.lvl")
			elseif ME5_SideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxCOL.lvl")
			elseif ME5_SideVar == 5 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxRPR.lvl")
			end
		else
			if self.onlineSideVar == "SSVxGTH" or self.onlineSideVar == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxGTH.lvl")
			elseif self.onlineSideVar == "SSVxCOL" or self.onlineSideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxCOL.lvl")
			elseif self.onlineSideVar == "EVGxGTH" or self.onlineSideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxGTH.lvl")
			elseif self.onlineSideVar == "EVGxCOL" or self.onlineSideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_EVGxCOL.lvl")
			elseif self.onlineSideVar == "SSVxRPR" or self.onlineSideVar == 5 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame_SSVxRPR.lvl")
			end
		end
    	
    	-- Load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
    	
		-- Load weapons.lvl for the stock HUD
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\weapons.lvl;hud_stock")
		
		-- Load the new onscreen pointer textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamehud.lvl")
	
		-- Is the game mode conquest or siege?
		if self.gameMode == "conquest" or self.gameMode == "siege" then
			-- Purge the stock objective markers
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_obj_marker.lvl;stock")
			
			-- Load the Conquest objective markers
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_stock_conquest.lvl")
		end
	end
	
	
	-- Calculate the aspect ratio
	if aspectRatio <= 1.4 then
		aspectRatioStr = "4:3"
	elseif aspectRatio <= 1.63 and aspectRatio >= 1.5 then
		aspectRatioStr = "16:10"
	elseif aspectRatio <= 1.9 and aspectRatio >= 1.63 then
		aspectRatioStr = "16:9"
	end
	
	-- What is the aspect ratio of the player's display?
	if aspectRatioStr == "4:3" then
		print("MapManager:Proc_ScriptInit_Begin(): Aspect Ratio is 4:3, loading scopes as such")
		if self.gameMode == "conquest" or self.gameMode == "siege" then
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is Conquest or Siege ("..self.gameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar43\\ar.lvl;conquest")
		else
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar43\\ar.lvl")
		end
		
	elseif aspectRatioStr == "16:10" then
		print("MapManager:Proc_ScriptInit_Begin(): Aspect Ratio is 16:10, loading scopes as such")
		if self.gameMode == "conquest" or self.gameMode == "siege" then
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is Conquest or Siege ("..self.gameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar1610\\ar.lvl;conquest")
		else
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar1610\\ar.lvl")
		end
		
	elseif aspectRatioStr == "16:9" then
		print("MapManager:Proc_ScriptInit_Begin(): Aspect Ratio is 16:9, loading scopes as such")
		if self.gameMode == "conquest" or self.gameMode == "siege" then
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is Conquest or Siege ("..self.gameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar169\\ar.lvl;conquest")
		else
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar169\\ar.lvl")
		end
		
	else
		print("MapManager:Proc_ScriptInit_Begin(): Error! Invalid aspect ratio ("..aspectRatio..")! Defaulting to workaround")
		if self.gameMode == "conquest" or self.gameMode == "siege" then
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is Conquest or Siege ("..self.gameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar.lvl;conquest")
		else
			print("MapManager:Proc_ScriptInit_Begin(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar.lvl")
		end
	end
	
	-- Is this a non-conquest/non-siege match?
	if self.gameMode ~= "conquest" and self.gameMode ~= "siege" then
		-- Purge the Conquest objective marker icons
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_obj_marker.lvl")
		
		-- Load the normal objective marker icons
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_obj_marker_stock.lvl")
	end
	
	--==========================
	-- END HUD WORK
	--==========================
	
	
	--==========================
	-- START SOUND WORK
	--==========================
	
	-- Load master sound LVL, includes sound property templates, buses, etc.
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl")
	
	-- [DEPRECATED 31-OCT-2013] Load music sound LVL, includes all music stuff
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_Streaming.lvl")
	
	-- Load hero music sound LVL, includes all hero music
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl")
	
	-- Load voice over sound LVL, includes all streamable voice overs, excludes pain/death chatter
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl")
	
	
	---
	-- Loads common sound LVL, includes many common sounds such as foley, explosions, prop sfx, etc. Also loads weapon sound LVL, includes all weapon sounds.
	-- @param factionVariation		The name or ID of the faction variation whose sounds we're loading.
	local function LoadFactionSounds(factionVariation)	-- TODO: finish setting up hero sounds
		
		-- ===============================
		-- ALLIANCE VS. HERETIC GETH
		-- ===============================
		if factionVariation == 1 or factionVariation == "SSVxGTH" then
			print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Faction combination is SSVxGTH, loading associated common/wpn sound files")
			
			if string.find(SSVHeroClass, "shepard") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading SHEPARD data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Shepard_NonStreaming.lvl")
				
			elseif (string.find(SSVHeroClass, "cooper") or (gLoadCooper and gLoadCooper == true)) then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading COOPER data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Cooper_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "jack") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading JACK data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Jack_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "legion") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading LEGION data files...")
				
				
			elseif string.find(SSVHeroClass, "samara") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading SAMARA data files...")
				
			else
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading normal data files...")
				
			end
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_SSV_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- ALLIANCE VS. COLLECTORS
		-- ===============================
		elseif factionVariation == 2 or factionVariation == "SSVxCOL" then
			print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Faction combination is SSVxCOL, loading associated common/wpn sound files")
			
			if string.find(SSVHeroClass, "shepard") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading SHEPARD data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Shepard_NonStreaming.lvl")
				
			elseif (string.find(SSVHeroClass, "cooper") or (gLoadCooper and gLoadCooper == true)) then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading COOPER data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Cooper_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "jack") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading JACK data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Jack_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "legion") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading LEGION data files...")
				
				
			elseif string.find(SSVHeroClass, "samara") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading SAMARA data files...")
				
			else
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading normal data files...")
				
			end
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_SSV_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- EVOLVED GETH VS. HERETIC GETH
		-- ===============================
		elseif factionVariation == 3 or factionVariation == "EVGxGTH" then
			print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Faction combination is EVGxGTH, loading associated common/wpn sound files")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- EVOLVED GETH VS. COLLECTORS
		-- ===============================
		elseif factionVariation == 4 or factionVariation == "EVGxCOL" then
			print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Faction combination is EVGxCOL, loading associated common/wpn sound files")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- ALLIANCE VS. REAPERS
		-- ===============================
		elseif factionVariation == 5 or factionVariation == "SSVxRPR" then
			print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Faction combination is SSVxRPR, loading associated common/wpn sound files")
			
			if string.find(SSVHeroClass, "shepard") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading SHEPARD data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Shepard_NonStreaming.lvl")
				
			elseif (string.find(SSVHeroClass, "cooper") or (gLoadCooper and gLoadCooper == true)) then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading COOPER data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Cooper_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "jack") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading JACK data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Jack_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "legion") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading LEGION data files...")
				
				
			elseif string.find(SSVHeroClass, "samara") then
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading SAMARA data files...")
				
			else
				print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Loading normal data files...")
				
			end
			
			-- ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_RPR_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_SSV_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_RPR_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_RPR_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
		else
			print("MapManager:Proc_ScriptInit_Begin.LoadFactionSounds(): Faction combination is invalid, loading common/wpn sound files for EVGxCOL as workaround")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
		end
	end
	
	if not ScriptCB_InMultiplayer() then
		LoadFactionSounds(ME5_SideVar)
	else
		LoadFactionSounds(self.onlineSideVar)
	end
	
	--==========================
	-- END SOUND WORK
	--==========================
	
	-- Call exterior functions
	Init_HealthFunc()
	Init_ShieldFunc()
	Init_DeferredShieldRegen()
	Init_KillSounds()
	--Init_LowHealthFeedback()
	Init_EvolvedJuggernautPowerDrain()
	Init_Weapon_Charge()
	Init_Weapon_DOT()
	
	
	if self.bIsArtilleryEnabled == true then
		if self.terrainType == "dirt" then
			print("MapManager:Proc_ScriptInit_Begin(): Loading artillery textures for dirt")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_dirt.lvl")
			
		elseif self.terrainType == "snow" then
			print("MapManager:Proc_ScriptInit_Begin(): Loading artillery textures for snow")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_snow.lvl")
			
		elseif self.terrainType == "sand" then	-- it gets everywhere
			print("MapManager:Proc_ScriptInit_Begin(): Loading artillery textures for sand")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery_sand.lvl")
		end
	end 
end


---
-- Call this where the normal side setup stuff is called in ScriptInit.  
-- 
-- Calls the functions necessary for the chosen faction combination (based on int var, ME5_SideVar). No params required.
-- 
function MapManager:Proc_ScriptInit_SideSetup()
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Setup_SSVxGTH()
		elseif ME5_SideVar == 2 then
			Setup_SSVxCOL()
		elseif ME5_SideVar == 3 then
			Setup_EVGxGTH()
		elseif ME5_SideVar == 4 then
			Setup_EVGxCOL()
		elseif ME5_SideVar == 5 then
			Setup_SSVxRPR()
		end
	else
		if self.onlineSideVar == "SSVxGTH" or self.onlineSideVar == 1 then
			Setup_SSVxGTH()
		elseif self.onlineSideVar == "SSVxCOL" or self.onlineSideVar == 2 then
			Setup_SSVxCOL()
		elseif self.onlineSideVar == "EVGxGTH" or self.onlineSideVar == 3 then
			Setup_EVGxGTH()
		elseif self.onlineSideVar == "EVGxCOL" or self.onlineSideVar == 4 then
			Setup_EVGxCOL()
		elseif self.onlineSideVar == "SSVxRPR" or self.onlineSideVar == 5 then
			Setup_SSVxRPR()
		end
	end
end


---
-- Call this directly after the memory pools are set.
-- 
-- Sets "global" memory pools such as `FlagItem`, `EntityPortableTurret`, and `MountedTurret`.
-- 
function MapManager:Proc_ScriptInit_MemoryPoolInit()
	print("MapManager:Proc_ScriptInit_MemoryPoolInit(): Entered")
	
	AddWalkerType(0, NUM_RAVAGERS)  -- number of ravagers
	
	-- Need to account for (carried) flags
	if self.gameMode == "1flag" or self.gameMode == "ctf" then
		SetMemoryPoolSize("EntityCloth", 4)
	end
	SetMemoryPoolSize("FlagItem", MAX_FLAG_ITEM_COUNT)
	SetMemoryPoolSize("EntityPortableTurret", MAX_PORTABLE_TURRET_COUNT)
	SetMemoryPoolSize("MountedTurret", MAX_PORTABLE_TURRET_COUNT)
end


---
-- Call this where the normal music setup stuff is called in ScriptInit.  
-- 
-- Calls the functions that load the music.
-- 
function MapManager:Proc_ScriptInit_MusicSetup()
	print("MapManager:Proc_ScriptInit_MusicSetup(): Entered")
	
	-- The music variation to set up
	local variation = nil
	
	-- What's the faction combination for this map?
	if ME5_SideVar == 1 or (ScriptCB_InMultiplayer() and self.onlineSideVar == "SSVxGTH") then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Variation is SSVxGTH")
		variation = self.musicVariation_SSVxGTH
		
	elseif ME5_SideVar == 2 or (ScriptCB_InMultiplayer() and self.onlineSideVar == "SSVxCOL") then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Variation is SSVxCOL")
		variation = self.musicVariation_SSVxCOL
		
	elseif ME5_SideVar == 3 or (ScriptCB_InMultiplayer() and self.onlineSideVar == "EVGxGTH") then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Variation is EVGxGTH")
		variation = self.musicVariation_EVGxGTH
		
	elseif ME5_SideVar == 4 or (ScriptCB_InMultiplayer() and self.onlineSideVar == "EVGxCOL") then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Variation is EVGxCOL")
		variation = self.musicVariation_EVGxCOL
		
	elseif ME5_SideVar == 5 or (ScriptCB_InMultiplayer() and self.onlineSideVar == "SSVxRPR") then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Variation is SSVxRPR")
		variation = self.musicVariation_SSVxRPR
	end
	
	-- If the specified variation is a table, randomly pick one of the cells to use
	if type(variation) == "table" then
		if not ScriptCB_InMultiplayer() then
			print("MapManager:Proc_ScriptInit_MusicSetup(): Music variation detected as table! Randomly picking one of the cells...")
			
			-- Quit if the table is empty
			if table.getn(variation) <= 0 then
				print("MapManager:Proc_ScriptInit_MusicSetup(): WARNING: Table cannot be empty! Exiting function")
			return end
			
			-- Otherwise, randomly pick one of the cells
			local decide = math.random(1,table.getn(variation))
			
			-- Set the variation to the chosen one, which was supposed to destroy the sith, not join them
			print("MapManager:Proc_ScriptInit_MusicSetup(): Going with variation "..decide)
			variation = variation[decide]
		else
			-- Go with the first cell if we're in a multiplayer match
			variation = variation[1]
		end
	end
	
	variation = string.lower(variation)
	
	print("MapManager:Proc_ScriptInit_MusicSetup(): Value of variation is "..variation)
	
	-- Set the music to use based on the first character in the string
	if string.sub(variation,1,1) == "1" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music01")
		Music01()
		
	elseif string.sub(variation,1,1) == "2" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music02")
		Music02()
		
	elseif string.sub(variation,1,1) == "3" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music03")
		if string.len(variation) > 1 then
			-- Set up the specified music variation
			Music03(string.sub(variation,3))
		else
			Music03()
		end
		
	elseif string.sub(variation,1,1) == "4" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music04")
		if string.len(variation) > 1 then
			-- Set up the specified music variation
			Music04(string.sub(variation,3))
		else
			Music04()
		end
		
	elseif string.sub(variation,1,1) == "5" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music05")
		if string.len(variation) > 1 then
			-- Set up the specified music variation
			Music05(string.sub(variation,3))
		else
			Music05()
		end
		
	elseif string.sub(variation,1,1) == "6" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music06")
		if string.len(variation) > 1 then
			-- Set up the specified music variation
			Music06(string.sub(variation,3))
		else
			Music06()
		end
		
	elseif string.sub(variation,1,1) == "7" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music07")
		Music07()
		
	elseif string.sub(variation,1,1) == "8" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music08")
		Music08()
		
	elseif string.sub(variation,1,1) == "9" then
		print("MapManager:Proc_ScriptInit_MusicSetup(): Going with Music09")
		Music09()
	else
		-- An invalid variation was selected, so default to variation 1
		Music01()
	end
end


---
-- Call this at the end of ScriptInit.  
-- 
-- Runs the Juggernaut Squad functions (based on the faction combination) and low health functions. Also purges stock fonts if custom HUD is enabled.
-- 
function MapManager:Proc_ScriptInit_End()
	print("MapManager:Proc_ScriptInit_End(): Entered")
	
	if self.bIsArtilleryEnabled == true and self.bIsArtilleryTurObjCustom == false then
		-- Load the artillery turret
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\artillery.lvl")
	end
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Init_JuggernautSquads_GTH()
		elseif ME5_SideVar == 3 then
			Init_JuggernautSquads_EVG()
		end
	else
		if self.onlineSideVar == "SSVxGTH" or self.onlineSideVar == 1 then
			Init_JuggernautSquads_GTH()
		elseif self.onlineSideVar == "EVGxGTH" or self.onlineSideVar == 3 then
			Init_JuggernautSquads_EVG()
		end
	end
	
	Init_LowHealthFeedback()
	if ME5_PlayerDmgSound > 0 then
		Init_PlayerDamageFeedback()
	end
	if ME5_HitMarkerSound > 0 then
		Init_HitMarkerSounds()
	end
	--meu_lowhealth_postCall()
	
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\camshake.lvl")
	
	if ME5_CustomHUD == 1 then
		print("MapManager:Proc_ScriptInit_End(): Overwriting stock fonts with blank font")
		-- Hotfix that overrides the stock fonts with a "blank font"
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_text.lvl")
	end
end


---
-- Call this at the end of ScriptPostLoad.
-- 
function MapManager:Proc_ScriptPostLoad_End()
	-- Set up local ally spawns if enabled
	if self.bAreLocalAlliesEnabled == true then
		self:Init_AllySpawns()
	end
	self:Init_SidesPostLoad()
	
	-- Are artillery strikes a go? If so, set them up
	if self.bIsArtilleryEnabled == true then
		self:Init_ArtilleryStrikes()
	end
end

function MapManager:Init_SidesPostLoad_SSVxGTH()
	if self.bAreHeroesEnabled == true then
		if not ScriptCB_InMultiplayer() then
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				SetHeroClass(CIS, GTHHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				herosupport:SetHeroClass(CIS, GTHHeroClass)
				
				for cp in ipairs(self.heroSupportCPs) do
					print("ME5_MapManager.Init_SidesPostLoad_SSVxGTH(): Setting hero spawn cp, path = ", self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
					herosupport:AddSpawnCP(self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
				end
				
				herosupport:Start()
			end
		end
	end
	
	if self.bAreLocalAlliesEnabled == true then
		if HuskTeam then
			-- Add a new goal for the HuskTeam
			AddAIGoal(HuskTeam, "Deathmatch", 100)
		end
	end
end

function MapManager:Init_SidesPostLoad_SSVxCOL()
	if self.bAreHeroesEnabled == true then
		if not ScriptCB_InMultiplayer() then
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				SetHeroClass(CIS, COLHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				herosupport:SetHeroClass(CIS, COLHeroClass)
				
				for cp in ipairs(self.heroSupportCPs) do
					print("ME5_MapManager.Init_SidesPostLoad_SSVxCOL(): Setting hero spawn cp, path = ", self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
					herosupport:AddSpawnCP(self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
				end
				
				herosupport:Start()
			end
		end
	end
	
	if self.bAreLocalAlliesEnabled == true then
		if HuskTeam then
			-- Add a new goal for the HuskTeam
			AddAIGoal(HuskTeam, "Deathmatch", 100)
		end
	end
end

function MapManager:Init_SidesPostLoad_EVGxGTH()
	if self.bAreHeroesEnabled == true then
		if not ScriptCB_InMultiplayer() then
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, EVGHeroClass)
				SetHeroClass(CIS, GTHHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, EVGHeroClass)
				herosupport:SetHeroClass(CIS, GTHHeroClass)
				
				for cp in ipairs(self.heroSupportCPs) do
					print("ME5_MapManager.Init_SidesPostLoad_EVGxGTH(): Setting hero spawn cp, path = ", self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
					herosupport:AddSpawnCP(self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
				end
				
				herosupport:Start()
			end
		end
	end
	
	if self.bAreLocalAlliesEnabled == true then
		if HuskTeam then
			-- Add a new goal for the HuskTeam
			AddAIGoal(HuskTeam, "Deathmatch", 100)
		end
	end
end

function MapManager:Init_SidesPostLoad_EVGxCOL()
	if self.bAreHeroesEnabled == true then
		if self.heroSupportCPs ~= nil and self.heroSupportCPs ~= {} then
			if not ScriptCB_InMultiplayer() then
				if ME5_AIHeroes == 0 then
					SetHeroClass(REP, EVGHeroClass)
					SetHeroClass(CIS, COLHeroClass)
				elseif ME5_AIHeroes == 1 then
					herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
					herosupport:SetHeroClass(REP, EVGHeroClass)
					herosupport:SetHeroClass(CIS, COLHeroClass)
					
					for cp in ipairs(self.heroSupportCPs) do
						print("ME5_MapManager.Init_SidesPostLoad_EVGxCOL(): Setting hero spawn cp, path = ", self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
						herosupport:AddSpawnCP(self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
					end
					
					herosupport:Start()
				end
			end
		end
	end
	
	if self.bAreLocalAlliesEnabled == true then
		if HuskTeam then
			-- Add a new goal for the HuskTeam
			AddAIGoal(HuskTeam, "Deathmatch", 100)
		end
	end
end

function MapManager:Init_SidesPostLoad_SSVxRPR()
	if self.bAreHeroesEnabled == true then
		if not ScriptCB_InMultiplayer() then
			if ME5_AIHeroes == 0 then
				SetHeroClass(REP, SSVHeroClass)
				-- SetHeroClass(CIS, RPRHeroClass)
			elseif ME5_AIHeroes == 1 then
				herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
				herosupport:SetHeroClass(REP, SSVHeroClass)
				-- herosupport:SetHeroClass(CIS, RPRHeroClass)
				
				for cp in ipairs(self.heroSupportCPs) do
					print("ME5_MapManager.Init_SidesPostLoad_SSVxRPR(): Setting hero spawn cp, path = ", self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
					herosupport:AddSpawnCP(self.heroSupportCPs[cp][1], self.heroSupportCPs[cp][2])
				end
				
				herosupport:Start()
			end
		end
	end
	
	if self.bAreLocalAlliesEnabled == true then
		if HuskTeam then
			-- Add a new goal for the HuskTeam
			AddAIGoal(HuskTeam, "Deathmatch", 100)
		end
	end
end


---
-- Performs various postload operations relating to the sides, such as setting up AI hero support based on the game mode.
-- @param #string gameMode		The mission's game mode. Acceptable values are "conquest", "1flag", "ctf", "siege", "survival", "campaign".
-- @param #table spawns			Two-dimensional array containing CPs and their spawn paths to pass to the AI hero support script. SYNTAX: CP name (string), CP spawn path name (string)
-- 
function MapManager:Init_SidesPostLoad()
	local mode = string.lower(self.gameMode)
	
	if mode == "conquest" or mode == "siege" then
		if not ScriptCB_InMultiplayer() then
			if ME5_SideVar == 1 then
				self:Init_SidesPostLoad_SSVxGTH()
			elseif ME5_SideVar == 2 then
				self:Init_SidesPostLoad_SSVxCOL()
			elseif ME5_SideVar == 3 then
				self:Init_SidesPostLoad_EVGxGTH()
			elseif ME5_SideVar == 4 then
				self:Init_SidesPostLoad_EVGxCOL()
			elseif ME5_SideVar == 5 then
				self:Init_SidesPostLoad_SSVxRPR()
			end
		else
			if self.onlineSideVar == "SSVxGTH" then
				self:Init_SidesPostLoad_SSVxGTH()
			elseif self.onlineSideVar == "SSVxCOL" then
				self:Init_SidesPostLoad_SSVxCOL()
			elseif self.onlineSideVar == "EVGxGTH" then
				self:Init_SidesPostLoad_EVGxGTH()
			elseif self.onlineSideVar == "EVGxCOL" then
				self:Init_SidesPostLoad_EVGxCOL()
			elseif self.onlineSideVar == "SSVxRPR" then
				self:Init_SidesPostLoad_SSVxRPR()
			end
		end
	end
end


---
-- Initializes the local ally spawns.
-- 
function MapManager:Init_AllySpawns()
	print("MapManager.Init_AllySpawns(): Entered")
	for cp in ipairs(self.allySpawnCPs) do
		print("MapManager:Init_AllySpawns(): Setting ally spawn cp, path = ", self.allySpawnCPs[cp][1], self.allySpawnCPs[cp][2])
		SetProperty(self.allySpawnCPs[cp][1], "AllyPath", self.allySpawnCPs[cp][2])
	end
end


---
-- Sets up artillery strikes.
-- 
function MapManager:Init_ArtilleryStrikes()
	-- Init data fields
	local artilleryStrikeNodes = {}
	local curNode = 0
	
	local artilleryStrikeDelay_Timer = nil
	local artilleryStrikeDelay_TimerElapse = nil
	local artilleryStrikeInitDelay_Timer = nil
	local artilleryStrikeInitDelay_TimerElapse = nil
	
	if self.artilleryStrikeDelay < 10.0 then
		print("MapManager:Init_ArtilleryStrikes(): WARNING! Value of `artilleryStrikeDelay` ("..self.artilleryStrikeDelay..") must be >= 10.0! Resetting to default value of 20.0")
		self.artilleryStrikeDelay = 35.0
	end
	
	
	ShuffleTable(self.artilleryNodes)
	
	-- Choose the first node randomly
	if not ScriptCB_InMultiplayer() then
		curNode = math.random(1, table.getn(self.artilleryNodes)) - 1
	else
		curNode = 0
	end
	
	-- Extract path points from artilleryStrikeNodes
	for i in ipairs(self.artilleryNodes) do
		print("artilleryNodes:", self.artilleryNodes[i][1], self.artilleryNodes[i][2])
		artilleryStrikeNodes[i] = GetPathPoint(self.artilleryNodes[i][1], self.artilleryNodes[i][2])
	end
	
	
	local function MoveToNextNode()
		-- Increment node
		curNode = curNode + 1
		if curNode == (table.getn(artilleryStrikeNodes) + 1) then
			curNode = 1
		end
		print("MapManager:Init_ArtilleryStrikes(): Artillery transitioning to node: "..curNode.." ("..self.artilleryNodes[curNode][1]..")")
		
		-- Move turret to next node
		SetEntityMatrix(self.artilleryTurObj, artilleryStrikeNodes[curNode])
	end
	
	-- Do the initial move
	MoveToNextNode()
	
	
	--=============================
	-- TIMERS
	--=============================
	
	-- Get or create a new artilleryStrikeDelay_Timer (this ensures there's only one "artilleryStrikeDelay_Timer" in the game at one time)
	artilleryStrikeDelay_Timer = FindTimer("artilleryStrikeDelay_Timer")
	if not artilleryStrikeDelay_Timer then
		artilleryStrikeDelay_Timer = CreateTimer("artilleryStrikeDelay_Timer")
		SetTimerValue(artilleryStrikeDelay_Timer, self.artilleryStrikeDelay)
		--ShowTimer(artilleryStrikeDelay_Timer)	-- Uncomment me for test output!
	end
	
	--SetClassProperty("com_weap_bldg_artillery1_shell", "ReloadTime", strikeDelayStr)
	
	
	-- Has the initial strike delay been set?
	if self.artilleryStrikeInitDelay > 0 then
		SetClassProperty("com_bldg_artillery1", "AutoFire", "0")
	
		-- Get or create a new artilleryStrikeInitDelay_Timer (this ensures there's only one "artilleryStrikeInitDelay_Timer" in the game at one time)
		artilleryStrikeInitDelay_Timer = FindTimer("artilleryStrikeInitDelay_Timer")
		if not artilleryStrikeInitDelay_Timer then
			artilleryStrikeInitDelay_Timer = CreateTimer("artilleryStrikeInitDelay_Timer")
			SetTimerValue(artilleryStrikeInitDelay_Timer, self.artilleryStrikeInitDelay)
			--ShowTimer(artilleryStrikeInitDelay_Timer)	-- Uncomment me for test output!
		end
		
		StartTimer("artilleryStrikeInitDelay_Timer")
		
		-- Initial strike delay timer elapse
		artilleryStrikeInitDelay_TimerElapse = OnTimerElapse(
			function(timer)
				SetClassProperty("com_bldg_artillery1", "AutoFire", "1")
				
				--ShowTimer(nil)
				StartTimer("artilleryStrikeDelay_Timer")
				
				DestroyTimer(timer)
				ReleaseTimerElapse(artilleryStrikeInitDelay_TimerElapse)
			end,
		"artilleryStrikeInitDelay_Timer"
		)
	else
		SetClassProperty("com_bldg_artillery1", "AutoFire", "1")
		StartTimer("artilleryStrikeDelay_Timer")
	end
	
	
	-- Strike delay timer elapse
	artilleryStrikeDelay_TimerElapse = OnTimerElapse(
		function(timer)
			MoveToNextNode()
			
			-- Reset timer
			SetTimerValue("artilleryStrikeDelay_Timer", self.artilleryStrikeDelay)
			StartTimer("artilleryStrikeDelay_Timer")
		end,
	"artilleryStrikeDelay_Timer"
	)
end

print("ME5_MapManager: Exited")