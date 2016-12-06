-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by Aaron Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  The purpose of this script is to load configuration parameters set by the Config Tool and set variables based on 
--  existing files.
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_ConfigCheck: Entered")

-- The base path for all of the config files.
local path = "..\\..\\addon\\ME5\\data\\_LVL_PC\\cfg\\"

---
-- Checks the given setting and its value based on /setting/ and /value/.
-- @param #string setting	The name of the setting file to check.
-- @param #int value		The value of the setting to check for.
-- @return 					1 if setting's value is valid, 0 if invalid. Will also return 0 if one of the function parameters wasn't inputted.
-- 
local function CheckSetting(setting, value)
	
	-- Make sure all parameters have been inputted
	if not setting then
		print("ME5_ConfigCheck.CheckSetting(): WARNING: Argument #0 'setting' not set! Exiting function")
		return 0
	end
	if not value then
		print("ME5_ConfigCheck.CheckSetting(): WARNING: Argument #1 'value' not set! Exiting function")
		return 0
	end
	
	return ScriptCB_IsFileExist("..\\..\\addon\\ME5\\data\\_LVL_PC\\cfg\\"..setting.."_"..value)
end


print("ME5_ConfigCheck: Checking configuration parameters...")

-- ======================
--  AI HEROES
-- ======================
if CheckSetting("cfg_AIHeroes", 0) == 1 then
	print("ME5_ConfigCheck: AI Heroes are DISABLED")
	ME5_AIHeroes = 0
	
elseif CheckSetting("cfg_AIHeroes", 1) == 1 then
	print("ME5_ConfigCheck: AI Heroes are ENABLED")
	ME5_AIHeroes = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_AIHeroes flag not found or invalid! Defaulting to ENABLED")
	ME5_AIHeroes = 1
end


-- ======================
--  MENU INTERFACE STYLE
-- ======================
if CheckSetting("cfg_CustomGUIEnabled", 0) == 1 then
	print("ME5_ConfigCheck: Menu Interface Style is STAR WARS BATTLEFRONT II")
	ME5_CustomGUIEnabled = 0
	
elseif CheckSetting("cfg_CustomGUIEnabled", 1) == 1 then
	print("ME5_ConfigCheck: Menu Interface Style is MASS EFFECT: UNIFICATION")
	ME5_CustomGUIEnabled = 1
	
elseif CheckSetting("cfg_CustomGUIEnabled", 2) == 1 then
	print("ME5_ConfigCheck: Menu Interface Style is MASS EFFECT 3")
	ME5_CustomGUIEnabled = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_CustomGUIEnabled flag not found or invalid! Defaulting to MASS EFFECT: UNIFICATION")
	ME5_CustomGUIEnabled = 1
end


-- ======================
--  CUSTOM HUD
-- ======================
if CheckSetting("cfg_CustomHUD", 0) == 1 then
	print("ME5_ConfigCheck: Custom HUD is DISABLED")
	ME5_CustomHUD = 0
	
elseif CheckSetting("cfg_CustomHUD", 1) == 1 then
	print("ME5_ConfigCheck: Custom HUD is ENABLED")
	ME5_CustomHUD = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_CustomHUD flag not found or invalid! Defaulting to ENABLED")
	ME5_CustomHUD = 1
end


-- ======================
--  GAMEPLAY DIFFICULTY
-- ======================
if CheckSetting("cfg_Difficulty", 0) == 1 then
	print("ME5_ConfigCheck: Difficulty is CASUAL")
	ME5_Difficulty = 1
	
elseif CheckSetting("cfg_Difficulty", 1) == 1 then
	print("ME5_ConfigCheck: Difficulty is NORMAL")
	ME5_Difficulty = 2
	
elseif CheckSetting("cfg_Difficulty", 2) == 1 then
	print("ME5_ConfigCheck: Difficulty is VETERAN")
	ME5_Difficulty = 3
	
elseif CheckSetting("cfg_Difficulty", 3) == 1 then
	print("ME5_ConfigCheck: Difficulty is HARDCORE")
	ME5_Difficulty = 4
	
elseif CheckSetting("cfg_Difficulty", 4) == 1 then
	print("ME5_ConfigCheck: Difficulty is INSANITY")
	ME5_Difficulty = 5
	
else
	print("ME5_ConfigCheck: Error! ME5_Difficulty flag not found or invalid! Defaulting to VETERAN")
	ME5_Difficulty = 3
end


-- ======================
--  CARNAGE MODE
-- ======================
if CheckSetting("cfg_CarnageMode", 0) == 1 then
	print("ME5_ConfigCheck: Carnage Mode is DISABLED")
	ME5_CarnageMode = 0
	
elseif CheckSetting("cfg_CarnageMode", 1) == 1 then
	print("ME5_ConfigCheck: Carnage Mode is ENABLED")
	ME5_CarnageMode = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_CarnageMode flag not found or invalid! Defaulting to DISABLED")
	ME5_CarnageMode = 0
end


-- ======================
--  HEALTH FUNCTIONALITY
-- ======================
if CheckSetting("cfg_HealthFunc", 0) == 1 then
	print("ME5_ConfigCheck: Health Functionality is AUTO-REGEN")
	ME5_HealthFunc = 1
	
elseif CheckSetting("cfg_HealthFunc", 1) == 1 then
	print("ME5_ConfigCheck: Health Functionality is PICKUPS")
	ME5_HealthFunc = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_HealthFunc flag not found or invalid! Defaulting to AUTO-REGEN")
	ME5_HealthFunc = 1
end


-- ======================
--  SHIELD FUNCTIONALITY
-- ======================
if CheckSetting("cfg_ShieldFunc", 0) == 1 then
	print("ME5_ConfigCheck: Shield Functionality is REGEN")
	ME5_ShieldFunc = 1
	
elseif CheckSetting("cfg_ShieldFunc", 1) == 1 then
	print("ME5_ConfigCheck: Shield Functionality is PICKUPS")
	ME5_ShieldFunc = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_ShieldFunc flag not found or invalid! Defaulting to AUTO-REGEN")
	ME5_ShieldFunc = 1
end


-- ======================
--  SHIELD REGEN FUNCTIONALITY
-- ======================
if CheckSetting("cfg_ShieldRegen", 0) == 1 then
	print("ME5_ConfigCheck: Shield Regen Functionality (Player Only) is AUTOMATIC")
	ME5_ShieldRegen = 0
	
elseif CheckSetting("cfg_ShieldRegen", 1) == 1 then
	print("ME5_ConfigCheck: Shield Regen Functionality (Player Only) is DEFERRED")
	ME5_ShieldRegen = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_ShieldRegen flag not found or invalid! Defaulting to DEFERRED")
	ME5_ShieldRegen = 1
end


-- ======================
--  COLLECTOR HERO CLASS
-- ======================
if CheckSetting("cfg_HeroClassCOL", 0) == 1 then
	print("ME5_ConfigCheck: COL Hero Class is RANDOM")
	ME5_HeroClassCOL = math.random(1, MAX_COL_HERO_COUNT)
	
elseif CheckSetting("cfg_HeroClassCOL", 1) == 1 then
	print("ME5_ConfigCheck: COL Hero Class is HARBINGER")
	ME5_HeroClassCOL = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_HeroClassCOL flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassCOL = math.random(1, MAX_COL_HERO_COUNT)
end


-- ======================
--  EVOLVED GETH HERO CLASS
-- ======================
if CheckSetting("cfg_HeroClassEVG", 0) == 1 then
	print("ME5_ConfigCheck: EVG Hero Class is RANDOM")
	ME5_HeroClassEVG = math.random(1, MAX_EVG_HERO_COUNT)
	
elseif CheckSetting("cfg_HeroClassEVG", 1) == 1 then
	print("ME5_ConfigCheck: EVG Hero Class is GETH PRIME (ME2)")
	ME5_HeroClassEVG = 1
	
elseif CheckSetting("cfg_HeroClassEVG", 2) == 1 then
	print("ME5_ConfigCheck: EVG Hero Class is GETH PRIME (ME3)")
	ME5_HeroClassEVG = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_HeroClassEVG flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassEVG = math.random(1, MAX_EVG_HERO_COUNT)
end


-- ======================
--  HERETIC GETH HERO CLASS
-- ======================
if CheckSetting("cfg_HeroClassGTH", 0) == 1 then
	print("ME5_ConfigCheck: GTH Hero Class is RANDOM")
	ME5_HeroClassGTH = math.random(1, MAX_GTH_HERO_COUNT)
	
elseif CheckSetting("cfg_HeroClassGTH", 1) == 1 then
	print("ME5_ConfigCheck: GTH Hero Class is GETH PRIME (ME2)")
	ME5_HeroClassGTH = 1
	
elseif CheckSetting("cfg_HeroClassGTH", 2) == 1 then
	print("ME5_ConfigCheck: GTH Hero Class is GETH PRIME (ME3)")
	ME5_HeroClassGTH = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_HeroClassGTH flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassGTH = math.random(1, MAX_GTH_HERO_COUNT)
end


-- ======================
--  ALLIANCE HERO CLASS
-- ======================
if CheckSetting("cfg_HeroClassSSV", 0) == 1 then
	print("ME5_ConfigCheck: SSV Hero Class is RANDOM")
	ME5_HeroClassSSV = math.random(1, MAX_SSV_HERO_COUNT)
	
elseif CheckSetting("cfg_HeroClassSSV", 1) == 1 then
	print("ME5_ConfigCheck: SSV Hero Class is SHEPARD")
	ME5_HeroClassSSV = 1
	
elseif CheckSetting("cfg_HeroClassSSV", 2) == 1 then
	print("ME5_ConfigCheck: SSV Hero Class is JACK")
	ME5_HeroClassSSV = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_HeroClassSSV flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassSSV = math.random(1, MAX_SSV_HERO_COUNT)
end


-- ======================
--  SHEPARD CLASS
-- ======================
if CheckSetting("cfg_ShepardClass", 0) == 1 then
	print("ME5_ConfigCheck: Shepard Class is RANDOM")
	ME5_ShepardClass = math.random(1, MAX_SHEP_CLASS_COUNT)
	
elseif CheckSetting("cfg_ShepardClass", 1) == 1 then
	print("ME5_ConfigCheck: Shepard Class is SOLDIER")
	ME5_ShepardClass = 1
	
elseif CheckSetting("cfg_ShepardClass", 2) == 1 then
	print("ME5_ConfigCheck: Shepard Class is INFILTRATOR")
	ME5_ShepardClass = 2
	
elseif CheckSetting("cfg_ShepardClass", 3) == 1 then
	print("ME5_ConfigCheck: Shepard Class is ENGINEER")
	ME5_ShepardClass = 3
	
elseif CheckSetting("cfg_ShepardClass", 4) == 1 then
	print("ME5_ConfigCheck: Shepard Class is ADEPT")
	ME5_ShepardClass = 4
	
elseif CheckSetting("cfg_ShepardClass", 5) == 1 then
	print("ME5_ConfigCheck: Shepard Class is SENTINEL")
	ME5_ShepardClass = 5
	
elseif CheckSetting("cfg_ShepardClass", 6) == 1 then
	print("ME5_ConfigCheck: Shepard Class is VANGUARD")
	ME5_ShepardClass = 6
	
else
	print("ME5_ConfigCheck: Error! ME5_ShepardClass flag not found or invalid! Defaulting to RANDOM")
	ME5_ShepardClass = math.random(1, MAX_SHEP_CLASS_COUNT)
end


-- ======================
--  SHEPARD GENDER
-- ======================
if CheckSetting("cfg_ShepardGender", 0) == 1 then
	print("ME5_ConfigCheck: Shepard Gender is RANDOM")
	ME5_ShepardGender = math.random(1, MAX_SHEP_GENDER_COUNT)
	
elseif CheckSetting("cfg_ShepardGender", 1) == 1 then
	print("ME5_ConfigCheck: Shepard Gender is MALE")
	ME5_ShepardGender = 1
	
elseif CheckSetting("cfg_ShepardGender", 2) == 1 then
	print("ME5_ConfigCheck: Shepard Gender is FEMALE")
	ME5_ShepardGender = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_ShepardGender flag not found or invalid! Defaulting to RANDOM")
	ME5_ShepardGender = math.random(1, MAX_SHEP_GENDER_COUNT)
end


-- ======================
--  SIDE VARIATION
-- ======================
if CheckSetting("cfg_SideVar", 0) == 1 then
	print("ME5_ConfigCheck: Side Variation is RANDOM")
	ME5_SideVar = math.random(1, MAX_FACTION_COUNT)
	
elseif CheckSetting("cfg_SideVar", 1) == 1 then
	print("ME5_ConfigCheck: Side Variation is SSVxGTH")
	ME5_SideVar = 1
	
elseif CheckSetting("cfg_SideVar", 2) == 1 then
	print("ME5_ConfigCheck: Side Variation is SSVxCOL")
	ME5_SideVar = 2
	
elseif CheckSetting("cfg_SideVar", 3) == 1 then
	print("ME5_ConfigCheck: Side Variation is EVGxGTH")
	ME5_SideVar = 3
	
elseif CheckSetting("cfg_SideVar", 4) == 1 then
	print("ME5_ConfigCheck: Side Variation is EVGxCOL")
	ME5_SideVar = 4
	
else
	print("ME5_ConfigCheck: Error! ME5_SideVar flag not found or invalid! Defaulting to RANDOM")
	ME5_SideVar = math.random(1, MAX_FACTION_COUNT)
end


-- ======================
--  EDEN PRIME WEATHER
-- ======================
if not ScriptCB_InMultiplayer() then
	if CheckSetting("cfg_MapVarEDN", 0) == 1 then
		print("ME5_ConfigCheck: Eden Prime Weather is RANDOM")
		ME5_MapVarEDN = math.random(1,3)
		
	elseif CheckSetting("cfg_MapVarEDN", 1) == 1 then
		print("ME5_ConfigCheck: Eden Prime Weather is STORMY")
		ME5_MapVarEDN = 1
		
	elseif CheckSetting("cfg_MapVarEDN", 2) == 1 then
		print("ME5_ConfigCheck: Eden Prime Weather is CLOUDY")
		ME5_MapVarEDN = 2
		
	elseif CheckSetting("cfg_MapVarEDN", 3) == 1 then
		print("ME5_ConfigCheck: Eden Prime Weather is NIGHT")
		ME5_MapVarEDN = 3
		
	else
		print("ME5_ConfigCheck: Error! ME5_MapVarEDN flag not found or invalid! Defaulting to RANDOM")
		ME5_MapVarEDN = math.random(1,3)
	end
else
	print("ME5_ConfigCheck: Eden Prime Weather is CLOUDY")
	ME5_MapVarEDN = 2
end


-- ======================
--  VIRMIRE PLAY AREA
-- ======================
if not ScriptCB_InMultiplayer() then
	if CheckSetting("cfg_MapVarVRM", 0) == 1 then
		print("ME5_ConfigCheck: Virmire Play Area is RANDOM")
		ME5_MapVarVRM = math.random(1,2)
		
	elseif CheckSetting("cfg_MapVarVRM", 1) == 1 then
		print("ME5_ConfigCheck: Virmire Play Area is UPPER LEVEL")
		ME5_MapVarVRM = 1
		
	elseif CheckSetting("cfg_MapVarVRM", 2) == 1 then
		print("ME5_ConfigCheck: Virmire Play Area is LOWER LEVEL")
		ME5_MapVarVRM = 2
		
	else
		print("ME5_ConfigCheck: Error! ME5_MapVarVRM flag not found or invalid! Defaulting to RANDOM")
		ME5_MapVarVRM = math.random(1,2)
	end
else
	print("ME5_ConfigCheck: Virmire Play Area is UPPER LEVEL")
	ME5_MapVarVRM = 1
end


-- ======================
--  SOL MAP MUSIC
-- ======================
if CheckSetting("cfg_SolMapMusic", 0) == 1 then
	print("ME5_ConfigCheck: 'Sol Map Pack' Map Music is AMBIENT SOUNDSCAPE")
	ME5_SolMapMusic = 0
	
elseif CheckSetting("cfg_SolMapMusic", 1) == 1 then
	print("ME5_ConfigCheck: 'Sol Map Pack' Map Music is MASS EFFECT")
	ME5_SolMapMusic = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_SolMapMusic flag not found or invalid! Defaulting to AMBIENT SOUNDSCAPE")
	ME5_SolMapMusic = 0
end


-- ======================
--  FACTION ANNOUNCER VO
-- ======================
if CheckSetting("cfg_FactionVO", 0) == 1 then
	print("ME5_ConfigCheck: Faction Announcer VO is DISABLED")
	ME5_FactionVO = 0
	
elseif CheckSetting("cfg_FactionVO", 1) == 1 then
	print("ME5_ConfigCheck: Faction Announcer VO is QUIET")
	ME5_FactionVO = 1
	
elseif CheckSetting("cfg_FactionVO", 2) == 1 then
	print("ME5_ConfigCheck: Faction Announcer VO is LOUD")
	ME5_FactionVO = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_FactionVO flag not found or invalid! Defaulting to LOUD")
	ME5_FactionVO = 2
end


-- ======================
--  LOW HEALTH SOUND
-- ======================
if CheckSetting("cfg_LowHealthSound", 0) == 1 then
	print("ME5_ConfigCheck: 'Low Health' Feedback Sounds are DISABLED")
	ME5_LowHealthSound = 0
	
elseif CheckSetting("cfg_LowHealthSound", 1) == 1 then
	print("ME5_ConfigCheck: 'Low Health' Feedback Sounds are ENABLED")
	ME5_LowHealthSound = 1
	
else
	print("ME5_ConfigCheck: Error! ME5_LowHealthSound flag not found or invalid! Defaulting to ENABLED")
	ME5_LowHealthSound = 1
end


-- ======================
--  KILL SOUND
-- ======================
if CheckSetting("cfg_KillSound", 0) == 1 then
	print("ME5_ConfigCheck: 'Enemy Killed' Feedback Sounds are DISABLED")
	ME5_KillSound = 0
	
elseif CheckSetting("cfg_KillSound", 1) == 1 then
	print("ME5_ConfigCheck: 'Enemy Killed' Feedback Sounds are QUIET")
	ME5_KillSound = 1
	
elseif CheckSetting("cfg_KillSound", 2) == 1 then
	print("ME5_ConfigCheck: 'Enemy Killed' Feedback Sounds are LOUD")
	ME5_KillSound = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_KillSound flag not found or invalid! Defaulting to LOUD")
	ME5_KillSound = 2
end


-- ======================
--  PLAYER DAMAGE SOUNDS
-- ======================
if CheckSetting("cfg_PlayerDmgSound", 0) == 1 then
	print("ME5_ConfigCheck: 'Player Damaged' Feedback Sounds are DISABLED")
	ME5_PlayerDmgSound = 0
	
elseif CheckSetting("cfg_PlayerDmgSound", 1) == 1 then
	print("ME5_ConfigCheck: 'Player Damaged' Feedback Sounds are QUIET")
	ME5_PlayerDmgSound = 1
	
elseif CheckSetting("cfg_PlayerDmgSound", 2) == 1 then
	print("ME5_ConfigCheck: 'Player Damaged' Feedback Sounds are LOUD")
	ME5_PlayerDmgSound = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_PlayerDmgSound flag not found or invalid! Defaulting to LOUD")
	ME5_PlayerDmgSound = 2
end


-- ======================
--  HIT MARKER SOUNDS
-- ======================
if CheckSetting("cfg_HitMarkerSound", 0) == 1 then
	print("ME5_ConfigCheck: Hit Marker Sounds are DISABLED")
	ME5_HitMarkerSound = 0
	
elseif CheckSetting("cfg_HitMarkerSound", 1) == 1 then
	print("ME5_ConfigCheck: Hit Marker Sounds are QUIET")
	ME5_HitMarkerSound = 1
	
elseif CheckSetting("cfg_HitMarkerSound", 2) == 1 then
	print("ME5_ConfigCheck: Hit Marker Sounds are LOUD")
	ME5_HitMarkerSound = 2
	
else
	print("ME5_ConfigCheck: Error! ME5_HitMarkerSound flag not found or invalid! Defaulting to LOUD")
	ME5_HitMarkerSound = 2
end

print("ME5_ConfigCheck: Checking configuration parameters... Done!")


-- Call the AI hero support script if AI heroes are enabled
if ME5_AIHeroes == 1 then
	ScriptCB_DoFile("ME5_AIHeroSupport")
end

-- Determines Shepard's class.
function DecideShepClass()
	if ME5_ShepardClass == 1 then
		print("ME5_ConfigCheck.DecideShepClass(): Deciding BroShep class... SOLDIER")
		SSVHeroClass = "ssv_hero_shepard_soldier"
		
	elseif ME5_ShepardClass == 2 then
		print("ME5_ConfigCheck.DecideShepClass(): Deciding BroShep class... INFILTRATOR")
		SSVHeroClass = "ssv_hero_shepard_infiltrator"
		
	elseif ME5_ShepardClass == 3 then
		print("ME5_ConfigCheck.DecideShepClass(): Deciding BroShep class... ENGINEER")
		SSVHeroClass = "ssv_hero_shepard_engineer"
		
	elseif ME5_ShepardClass == 4 then
		print("ME5_ConfigCheck.DecideShepClass(): Deciding BroShep class... ADEPT")
		SSVHeroClass = "ssv_hero_shepard_adept"
		
	elseif ME5_ShepardClass == 5 then
		print("ME5_ConfigCheck.DecideShepClass(): Deciding BroShep class... SENTINEL")
		SSVHeroClass = "ssv_hero_shepard_sentinel"
		
	elseif ME5_ShepardClass == 6 then
		print("ME5_ConfigCheck.DecideShepClass(): Deciding BroShep class... VANGUARD")
		SSVHeroClass = "ssv_hero_shepard_vanguard"
	else
		print("ME5_ConfigCheck.DecideShepClass(): Error! ME5_ShepardClass is invalid! Defaulting to SOLDIER")
		SSVHeroClass = "ssv_hero_shepard_soldier"
	end
end

-- Determines the Systems Alliance's hero unit.
function DecideSSVHeroClass()
	if ME5_HeroClassSSV == 1 then
		print("ME5_ConfigCheck.DecideSSVHeroClass(): Deciding SSV hero class... SHEPARD")
		DecideShepClass()
		
	elseif ME5_HeroClassSSV == 2 then
		print("ME5_ConfigCheck.DecideSSVHeroClass(): Deciding SSV hero class... JACK")
		SSVHeroClass = "ssv_hero_jack"
		
	--[[elseif ME5_HeroClassSSV == 3 then
		print("ME5_ConfigCheck.DecideSSVHeroClass(): Deciding SSV hero class... SAMARA")
		SSVHeroClass = "ssv_hero_samara"
		
	elseif ME5_HeroClassSSV == 4 then
		print("ME5_ConfigCheck.DecideSSVHeroClass(): Deciding SSV hero class... LEGION")
		SSVHeroClass = "ssv_hero_legion"]]
	else
		print("ME5_ConfigCheck.DecideSSVHeroClass(): Error! ME5_HeroClassSSV value is invalid! Defaulting to SHEPARD")
		DecideShepClass()
	end
end

-- Determines the Heretic Geth's hero unit.
function DecideGTHHeroClass()
	if ME5_HeroClassGTH == 1 then
		print("ME5_ConfigCheck.DecideGTHHeroClass(): Deciding GTH hero class... GETH PRIME (ME2)")
		GTHHeroClass = "gth_hero_prime_me2"
		
	elseif ME5_HeroClassGTH == 2 then
		print("ME5_ConfigCheck.DecideGTHHeroClass(): Deciding GTH hero class... GETH PRIME (ME3)")
		GTHHeroClass = "gth_hero_prime_me3"
		
	else
		print("ME5_ConfigCheck.DecideGTHHeroClass(): Error! ME5_HeroClassGTH value is invalid! Defaulting to GETH PRIME (ME2)")
		GTHHeroClass = "gth_hero_prime_me2"
	end
end

-- Determines the Collectors' hero unit.
function DecideCOLHeroClass()
	if ME5_HeroClassCOL == 1 then
		print("ME5_ConfigCheck.DecideCOLHeroClass(): Deciding COL hero class... HARBINGER")
		COLHeroClass = "col_hero_harbinger"
	else
		print("ME5_ConfigCheck.DecideCOLHeroClass(): Error! ME5_HeroClassCOL value is invalid! Defaulting to HARBINGER")
		COLHeroClass = "col_hero_harbinger"
	end
end

-- Determines the Evolved Geth's hero unit.
function DecideEVGHeroClass()
	if ME5_HeroClassEVG == 1 then
		print("ME5_ConfigCheck.DecideEVGHeroClass(): Deciding EVG hero class... GETH PRIME (ME2)")
		EVGHeroClass = "gth_hero_prime_me2"
	elseif ME5_HeroClassEVG == 2 then
		print("ME5_ConfigCheck.DecideEVGHeroClass(): Deciding EVG hero class... GETH PRIME (ME3)")
		EVGHeroClass = "gth_hero_prime_me3"
	else
		print("ME5_ConfigCheck.DecideEVGHeroClass(): Error! ME5_HeroClassEVG value is invalid! Defaulting to GETH PRIME (ME3)")
		EVGHeroClass = "gth_hero_prime_me3"
	end
end

if not ScriptCB_InMultiplayer() then
	DecideSSVHeroClass()
	DecideGTHHeroClass()
	DecideCOLHeroClass()
	DecideEVGHeroClass()
end

print("ME5_ConfigCheck: Exited")