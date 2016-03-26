-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by A. Gilbert
-- Version 30325/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 25, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: The purpose of script is to load configuration
-- parameters set by the config tool and set variables based on existing files.
-- 
-- 
-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_ConfigCheck: Entered")
	print("ME5_ConfigCheck: Checking configuration parameters...")

-- The base path for all of the config files.
local path = "..\\..\\addon\\ME5\\data\\_LVL_PC\\cfg\\"

-- ======================
--  AI HEROES
-- ======================
if ScriptCB_IsFileExist(path.."cfg_AIHeroes_0") == 1 then
		print("ME5_ConfigCheck: AI Heroes are DISABLED")
	ME5_AIHeroes = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_AIHeroes_1") == 1 then
		print("ME5_ConfigCheck: AI Heroes are ENABLED")
	ME5_AIHeroes = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_AIHeroes flag not found or invalid! Defaulting to ENABLED")
	ME5_AIHeroes = 1
end


-- ======================
--  SHELL UI
-- ======================
if ScriptCB_IsFileExist(path.."cfg_CustomGUIEnabled_0") == 1 then
		print("ME5_ConfigCheck: Shell Style is CLASSIC")
	ME5_CustomGUIEnabled = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_CustomGUIEnabled_1") == 1 then
		print("ME5_ConfigCheck: Shell Style is MASS EFFECT: UNIFICATION")
	ME5_CustomGUIEnabled = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_CustomGUIEnabled_2") == 1 then
		print("ME5_ConfigCheck: Shell Style is MASS EFFECT 3")
	ME5_CustomGUIEnabled = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_CustomGUIEnabled flag not found or invalid! Defaulting to MASS EFFECT: UNIFICATION")
	ME5_CustomGUIEnabled = 1
end


-- ======================
--  IN-GAME HUD
-- ======================
if ScriptCB_IsFileExist(path.."cfg_CustomHUD_0") == 1 then
		print("ME5_ConfigCheck: Custom HUD is DISABLED")
	ME5_CustomHUD = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_CustomHUD_1") == 1 then
		print("ME5_ConfigCheck: Custom HUD is ENABLED")
	ME5_CustomHUD = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_CustomHUD flag not found or invalid! Defaulting to ENABLED")
	ME5_CustomHUD = 1
end


-- ======================
--  GAMEPLAY DIFFICULTY
-- ======================
if ScriptCB_IsFileExist(path.."cfg_Difficulty_0") == 1 then
		print("ME5_ConfigCheck: Difficulty is CASUAL")
	ME5_Difficulty = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_Difficulty_1") == 1 then
		print("ME5_ConfigCheck: Difficulty is NORMAL")
	ME5_Difficulty = 2
	
elseif ScriptCB_IsFileExist(path.."cfg_Difficulty_2") == 1 then
		print("ME5_ConfigCheck: Difficulty is VETERAN")
	ME5_Difficulty = 3
	
elseif ScriptCB_IsFileExist(path.."cfg_Difficulty_3") == 1 then
		print("ME5_ConfigCheck: Difficulty is HARDCORE")
	ME5_Difficulty = 4
	
elseif ScriptCB_IsFileExist(path.."cfg_Difficulty_4") == 1 then
		print("ME5_ConfigCheck: Difficulty is INSANITY")
	ME5_Difficulty = 5
	
else
		print("ME5_ConfigCheck: Error! ME5_Difficulty flag not found or invalid! Defaulting to HARDCORE")
	ME5_Difficulty = 3
end


-- ======================
--  CARNAGE MODE
-- ======================
if ScriptCB_IsFileExist(path.."cfg_CarnageMode_0") == 1 then
		print("ME5_ConfigCheck: Carnage Mode is DISABLED")
	ME5_CarnageMode = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_CarnageMode_1") == 1 then
		print("ME5_ConfigCheck: Carnage Mode is ENABLED")
	ME5_CarnageMode = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_CarnageMode flag not found or invalid! Defaulting to DISABLED")
	ME5_CarnageMode = 0
end


-- ======================
--  HEALTH FUNCTIONALITY
-- ======================
if ScriptCB_IsFileExist(path.."cfg_HealthFunc_0") == 1 then
		print("ME5_ConfigCheck: Health Functionality is AUTO-REGEN")
	ME5_HealthFunc = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_HealthFunc_1") == 1 then
		print("ME5_ConfigCheck: Health Functionality is PICKUPS")
	ME5_HealthFunc = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_HealthFunc flag not found or invalid! Defaulting to AUTO-REGEN")
	ME5_HealthFunc = 1
end


-- ======================
--  SHIELDS FUNCTIONALITY
-- ======================
if ScriptCB_IsFileExist(path.."cfg_ShieldFunc_0") == 1 then
		print("ME5_ConfigCheck: Shields Functionality is AUTO-REGEN")
	ME5_ShieldFunc = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_ShieldFunc_1") == 1 then
		print("ME5_ConfigCheck: Shields Functionality is PICKUPS")
	ME5_ShieldFunc = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_ShieldFunc flag not found or invalid! Defaulting to AUTO-REGEN")
	ME5_ShieldFunc = 1
end


-- ======================
--  DEFERRED SHIELD REGENERATION
-- ======================
if ScriptCB_IsFileExist(path.."cfg_ShieldRegen_0") == 1 then
		print("ME5_ConfigCheck: Deferred Shield Regeneration is DISABLED")
	ME5_ShieldRegen = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_ShieldRegen_1") == 1 then
		print("ME5_ConfigCheck: Deferred Shield Regeneration is ENABLED")
	ME5_ShieldRegen = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_ShieldRegen flag not found or invalid! Defaulting to ENABLED")
	ME5_ShieldRegen = 1
end


-- ======================
--  COLLECTOR HERO CLASS
-- ======================
if ScriptCB_IsFileExist(path.."cfg_HeroClassCOL_0") == 1 then
		print("ME5_ConfigCheck: COL Hero Class is RANDOM")
	ME5_HeroClassCOL = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_HeroClassCOL_1") == 1 then
		print("ME5_ConfigCheck: COL Hero Class is HARBINGER")
	ME5_HeroClassCOL = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_HeroClassCOL flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassCOL = 0
end


-- ======================
--  EVOLVED GETH HERO CLASS
-- ======================
if ScriptCB_IsFileExist(path.."cfg_HeroClassEVG_0") == 1 then
		print("ME5_ConfigCheck: EVG Hero Class is RANDOM")
	ME5_HeroClassEVG = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_HeroClassEVG_1") == 1 then
		print("ME5_ConfigCheck: EVG Hero Class is GETH PRIME (ME2)")
	ME5_HeroClassEVG = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_HeroClassEVG_2") == 1 then
		print("ME5_ConfigCheck: EVG Hero Class is GETH PRIME (ME3)")
	ME5_HeroClassEVG = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_HeroClassEVG flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassEVG = 0
end


-- ======================
--  HERETIC GETH HERO CLASS
-- ======================
if ScriptCB_IsFileExist(path.."cfg_HeroClassGTH_0") == 1 then
		print("ME5_ConfigCheck: GTH Hero Class is RANDOM")
	ME5_HeroClassGTH = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_HeroClassGTH_1") == 1 then
		print("ME5_ConfigCheck: GTH Hero Class is GETH PRIME (ME2)")
	ME5_HeroClassGTH = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_HeroClassGTH_2") == 1 then
		print("ME5_ConfigCheck: GTH Hero Class is GETH PRIME (ME3)")
	ME5_HeroClassGTH = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_HeroClassGTH flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassGTH = 0
end


-- ======================
--  ALLIANCE HERO CLASS
-- ======================
if ScriptCB_IsFileExist(path.."cfg_HeroClassSSV_0") == 1 then
		print("ME5_ConfigCheck: SSV Hero Class is RANDOM")
	ME5_HeroClassSSV = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_HeroClassSSV_1") == 1 then
		print("ME5_ConfigCheck: SSV Hero Class is SHEPARD")
	ME5_HeroClassSSV = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_HeroClassSSV flag not found or invalid! Defaulting to RANDOM")
	ME5_HeroClassSSV = 0
end


-- ======================
--  SHEPARD CLASS
-- ======================
if ScriptCB_IsFileExist(path.."cfg_ShepardClass_0") == 1 then
		print("ME5_ConfigCheck: Shepard Class is RANDOM")
	ME5_ShepardClass = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardClass_1") == 1 then
		print("ME5_ConfigCheck: Shepard Class is SOLDIER")
	ME5_ShepardClass = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardClass_2") == 1 then
		print("ME5_ConfigCheck: Shepard Class is INFILTRATOR")
	ME5_ShepardClass = 2
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardClass_3") == 1 then
		print("ME5_ConfigCheck: Shepard Class is ENGINEER")
	ME5_ShepardClass = 3
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardClass_4") == 1 then
		print("ME5_ConfigCheck: Shepard Class is ADEPT")
	ME5_ShepardClass = 4
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardClass_5") == 1 then
		print("ME5_ConfigCheck: Shepard Class is SENTINEL")
	ME5_ShepardClass = 5
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardClass_6") == 1 then
		print("ME5_ConfigCheck: Shepard Class is VANGUARD")
	ME5_ShepardClass = 6
	
else
		print("ME5_ConfigCheck: Error! ME5_ShepardClass flag not found or invalid! Defaulting to RANDOM")
	ME5_ShepardClass = 0
end


-- ======================
--  SHEPARD GENDER
-- ======================
if ScriptCB_IsFileExist(path.."cfg_ShepardGender_0") == 1 then
		print("ME5_ConfigCheck: Shepard Gender is RANDOM")
	ME5_ShepardGender = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardGender_1") == 1 then
		print("ME5_ConfigCheck: Shepard Gender is MALE")
	ME5_ShepardGender = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_ShepardGender_2") == 1 then
		print("ME5_ConfigCheck: Shepard Gender is FEMALE")
	ME5_ShepardGender = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_ShepardGender flag not found or invalid! Defaulting to RANDOM")
	ME5_ShepardGender = 0
end


-- ======================
--  SIDE VARIATION
-- ======================
if ScriptCB_IsFileExist(path.."cfg_SideVar_0") == 1 then
		print("ME5_ConfigCheck: Side Variation is RANDOM")
	ME5_SideVar = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_SideVar_1") == 1 then
		print("ME5_ConfigCheck: Side Variation is SSVxGTH")
	ME5_SideVar = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_SideVar_2") == 1 then
		print("ME5_ConfigCheck: Side Variation is SSVxCOL")
	ME5_SideVar = 2
	
elseif ScriptCB_IsFileExist(path.."cfg_SideVar_3") == 1 then
		print("ME5_ConfigCheck: Side Variation is EVGxGTH")
	ME5_SideVar = 3
	
elseif ScriptCB_IsFileExist(path.."cfg_SideVar_4") == 1 then
		print("ME5_ConfigCheck: Side Variation is EVGxCOL")
	ME5_SideVar = 4
	
else
		print("ME5_ConfigCheck: Error! ME5_SideVar flag not found or invalid! Defaulting to RANDOM")
	ME5_SideVar = 0
end


-- ======================
--  SOL MAP MUSIC
-- ======================
if ScriptCB_IsFileExist(path.."cfg_SolMapMusic_0") == 1 then
		print("ME5_ConfigCheck: Sol Map Music is SOL")
	ME5_SolMapMusic = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_SolMapMusic_1") == 1 then
		print("ME5_ConfigCheck: Sol Map Music is MASS EFFECT")
	ME5_SolMapMusic = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_SolMapMusic flag not found or invalid! Defaulting to SOL")
	ME5_SolMapMusic = 0
end


-- ======================
--  FACTION ANNOUNCER VO
-- ======================
if ScriptCB_IsFileExist(path.."cfg_FactionVO_0") == 1 then
		print("ME5_ConfigCheck: Faction Announcer VO is DISABLED")
	ME5_FactionVO = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_FactionVO_1") == 1 then
		print("ME5_ConfigCheck: Faction Announcer VO is QUIET")
	ME5_FactionVO = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_FactionVO_2") == 1 then
		print("ME5_ConfigCheck: Faction Announcer VO is LOUD")
	ME5_FactionVO = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_FactionVO flag not found or invalid! Defaulting to LOUD")
	ME5_FactionVO = 2
end


-- ======================
--  LOW HEALTH SOUND
-- ======================
if ScriptCB_IsFileExist(path.."cfg_LowHealthSound_0") == 1 then
		print("ME5_ConfigCheck: Low Health Sound is DISABLED")
	ME5_LowHealthSound = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_LowHealthSound_1") == 1 then
		print("ME5_ConfigCheck: Low Health Sound is ENABLED")
	ME5_LowHealthSound = 1
	
else
		print("ME5_ConfigCheck: Error! ME5_LowHealthSound flag not found or invalid! Defaulting to ENABLED")
	ME5_LowHealthSound = 1
end


-- ======================
--  KILL SOUND
-- ======================
if ScriptCB_IsFileExist(path.."cfg_KillSound_0") == 1 then
		print("ME5_ConfigCheck: Kill Sound is DISABLED")
	ME5_KillSound = 0
	
elseif ScriptCB_IsFileExist(path.."cfg_KillSound_1") == 1 then
		print("ME5_ConfigCheck: Kill Sound is QUIET")
	ME5_KillSound = 1
	
elseif ScriptCB_IsFileExist(path.."cfg_KillSound_2") == 1 then
		print("ME5_ConfigCheck: Kill Sound is LOUD")
	ME5_KillSound = 2
	
else
		print("ME5_ConfigCheck: Error! ME5_KillSound flag not found or invalid! Defaulting to LOUD")
	ME5_KillSound = 2
end


print("ME5_ConfigCheck: Checking configuration parameters... Done!")


if ME5_AIHeroes == 1 then
	ScriptCB_DoFile("ME5_AIHeroSupport")
end

	print("ME5_ConfigCheck: Exited")