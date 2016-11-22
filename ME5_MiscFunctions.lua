-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Miscellaneous Functions Script by Aaron Gilbert
-- Build 31104/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Nov 4, 2016
-- Copyright (c) 2016, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This script contains various functions that are loaded in a map's mission script.
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_MiscFunctions: Entered")
	
---
-- Performs various pre-game operations, such as loading commonly used data files,
-- Carnage mode setup, HUD work, and running event response functions for features such as
-- kill sounds, Evolved Juggernaut's Power Drain, and shield pickups.
-- 
function PreLoadStuff()
	print("ME5_MiscFunctions.PreLoadStuff(): Entered")
	
	-- Load our custom loadscreen elements such as progress bar LEDs, tip box elements, etc.
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\common.lvl")
	
	-- What is the difficulty set to in the Config Tool?
	if not ScriptCB_InMultiplayer() then
		if ME5_Difficulty == 1 then
			print("ME5_MiscFunctions.PreLoadStuff(): Initializing difficulty parameters for CASUAL...")
			SetAIDifficulty(1, -1)
			SetTeamAggressiveness(CIS,(0.63))
			SetTeamAggressiveness(REP,(0.63))
			
		elseif ME5_Difficulty == 2 then
			print("ME5_MiscFunctions.PreLoadStuff(): Initializing difficulty parameters for NORMAL...")
			SetAIDifficulty(0, 0)
			SetTeamAggressiveness(CIS,(0.73))
			SetTeamAggressiveness(REP,(0.73))
			
		elseif ME5_Difficulty == 3 then
			print("ME5_MiscFunctions.PreLoadStuff(): Initializing difficulty parameters for VETERAN...")
			SetAIDifficulty(-1, 1)
			SetTeamAggressiveness(CIS,(0.83))
			SetTeamAggressiveness(REP,(0.83))
			
		elseif ME5_Difficulty == 4 then
			print("ME5_MiscFunctions.PreLoadStuff(): Initializing difficulty parameters for HARDCORE...")
			SetAIDifficulty(-2, 2)
			SetTeamAggressiveness(CIS,(0.93))
			SetTeamAggressiveness(REP,(0.93))
			
		elseif ME5_Difficulty == 5 then
			print("ME5_MiscFunctions.PreLoadStuff(): Initializing difficulty parameters for INSANITY...")
			SetAIDifficulty(-3, 3)
			SetTeamAggressiveness(CIS,(1.0))
			SetTeamAggressiveness(REP,(1.0))
			
		else
			print("ME5_MiscFunctions.PreLoadStuff(): Error! ME5_Difficulty setting is invalid! Defaulting to difficulty parameters for HARDCORE")
			SetAIDifficulty(-2, 2)
			SetTeamAggressiveness(CIS,(0.93))
			SetTeamAggressiveness(REP,(0.93))
		end
	else
		print("ME5_MiscFunctions.PreLoadStuff(): Initializing difficulty parameters for MULTIPLAYER...")
		-- NOTE: Apply a difficulty setting located between Hardcore and Insanity
		SetAIDifficulty(-2, 2)
		SetTeamAggressiveness(CIS,(0.95))
		SetTeamAggressiveness(REP,(0.95))
	end
	
	-- What is Carnage Mode set to in the Config Tool?
	if not ScriptCB_InMultiplayer() then
		if ME5_CarnageMode == 0 then
			print("ME5_MiscFunctions.PreLoadStuff(): Carnage Mode is DISABLED, deactivating weapon modifiers...")
		elseif ME5_CarnageMode == 1 then
			print("ME5_MiscFunctions.PreLoadStuff(): Carnage Mode is ENABLED, activating weapon modifiers...")
			ActivateBonus(REP, "team_bonus_advanced_blasters")
			ActivateBonus(CIS, "team_bonus_advanced_blasters")
		else
			print("ME5_MiscFunctions.PreLoadStuff(): Error! ME5_CarnageMode setting is invalid! Defaulting Carnage Mode setting to DISABLED")
		end
	else
		print("ME5_MiscFunctions.PreLoadStuff(): Carnage Mode is ENABLED (MULTIPLAYER), activating weapon modifiers...")
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
		end
	else
		if onlineSideVar == "SSVxGTH" or onlineSideVar == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif onlineSideVar == "SSVxCOL" or onlineSideVar == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		elseif onlineSideVar == "EVGxGTH" or onlineSideVar == 3 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif onlineSideVar == "EVGxCOL" or onlineSideVar == 4 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
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
		print("ME5_MiscFunctions.PreLoadStuff():", "Width: "..screenWidth, "Height: "..screenHeight..", Aspect Ratio: "..aspectRatio)
	
	
	--==========================
	-- START HUD WORK
	--==========================
	
	-- Is the custom HUD enabled in the Config Tool?
	if ME5_CustomHUD == 1 then
			print("ME5_MiscFunctions.PreLoadStuff(): Loading custom HUD")
		
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
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxGTH")
			elseif ME5_SideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxCOL")
			elseif ME5_SideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxGTH")
			elseif ME5_SideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxCOL")
			end
		else
			if onlineSideVar == "SSVxGTH" or onlineSideVar == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxGTH")
			elseif onlineSideVar == "SSVxCOL" or onlineSideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxCOL")
			elseif onlineSideVar == "EVGxGTH" or onlineSideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxGTH")
			elseif onlineSideVar == "EVGxCOL" or onlineSideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxCOL")
			end
		end
    	
    	-- Purge the stock HUD mshs
    	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_msh.lvl")
    	
    	-- Load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
		
		-- Purge the stock HUD textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_bmp.lvl")
		
		-- Load the new custom HUD and the objective screen text based on the game mode
		-- What is the active game mode? (NOTE: This is set near the beginning of each game mode's objective script)
		if MEU_GameMode == "meu_1flag" or MEU_GameMode == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_1flag")
		elseif MEU_GameMode == "meu_con" or MEU_GameMode == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_con")
		elseif MEU_GameMode == "meu_ctf" or MEU_GameMode == 3 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_ctf")
		elseif MEU_GameMode == "meu_siege" or MEU_GameMode == 4 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_siege")
		elseif MEU_GameMode == "meu_surv" or MEU_GameMode == 5 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_surv")
		elseif MEU_GameMode == "meu_tdm" or MEU_GameMode == 6 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_tdm")
		elseif MEU_GameMode == "meu_campaign" or MEU_GameMode == 7 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_campaign")
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
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxGTH")
			elseif ME5_SideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxCOL")
			elseif ME5_SideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxGTH")
			elseif ME5_SideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxCOL")
			end
		else
			if onlineSideVar == "SSVxGTH" or onlineSideVar == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxGTH")
			elseif onlineSideVar == "SSVxCOL" or onlineSideVar == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_SSVxCOL")
			elseif onlineSideVar == "EVGxGTH" or onlineSideVar == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxGTH")
			elseif onlineSideVar == "EVGxCOL" or onlineSideVar == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl;ingame_EVGxCOL")
			end
		end
    	
    	-- Load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
    	
		-- Load weapons.lvl for the stock HUD
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\weapons.lvl;hud_stock")
		
		-- Load the new onscreen pointer textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamehud.lvl")
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
		print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 4:3, loading scopes as such")
		if (MEU_GameMode == "meu_con" or "meu_siege") or (MEU_GameMode == 2 or 4) then
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is Conquest or Siege ("..MEU_GameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar43\\ar.lvl;conquest")
		else
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar43\\ar.lvl")
		end
		
	elseif aspectRatioStr == "16:10" then
		print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 16:10, loading scopes as such")
		if (MEU_GameMode == "meu_con" or "meu_siege") or (MEU_GameMode == 2 or 4) then
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is Conquest or Siege ("..MEU_GameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar1610\\ar.lvl;conquest")
		else
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar1610\\ar.lvl")
		end
		
	elseif aspectRatioStr == "16:9" then
		print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 16:9, loading scopes as such")
		if (MEU_GameMode == "meu_con" or "meu_siege") or (MEU_GameMode == 2 or 4) then
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is Conquest or Siege ("..MEU_GameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar169\\ar.lvl;conquest")
		else
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar169\\ar.lvl")
		end
		
	else
		print("ME5_MiscFunctions.PreLoadStuff(): Error! Invalid aspect ratio ("..aspectRatio..")! Defaulting to workaround")
		
		if (MEU_GameMode == "meu_con" or "meu_siege") or (MEU_GameMode == 2 or 4) then
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is Conquest or Siege ("..MEU_GameMode.."), also loading CP objective markers")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar.lvl;conquest")
		else
			print("ME5_MiscFunctions.PreLoadStuff(): Game mode is not Conquest or Siege")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar.lvl")
		end
	end
	
	-- Is this a non-conquest/non-siege match?
	if (MEU_GameMode ~= "meu_con") and (MEU_GameMode ~= "meu_siege") and (MEU_GameMode ~= 2) and (MEU_GameMode ~= 4) then
		-- Load the normal objective marker icons
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_obj_marker.lvl")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_obj_marker.lvl")
	end
	
	--==========================
	-- END HUD WORK
	--==========================
	
	
	--==========================
	-- START SOUND WORK
	--==========================
	
	-- Load master sound LVL, includes sound property templates, etc.
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl")
	
	-- [DEPRECATED 31-OCT-2013] Load music sound LVL, includes all music stuff
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_Streaming.lvl")
	
	-- Load hero music sound LVL, includes all hero music
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl")
	
	-- Load voice over sound LVL, includes all streamable voice overs, excludes pain/death chatter
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl")
	
	
	---
	-- Load common sound LVL, includes many common sounds such as foley, explosions, prop sfx, etc. Also load weapon sound LVL, includes all weapon sounds.
	-- @param #int factionVariation		The index of the faction variation whose sounds we're loading.
	local function LoadFactionSounds(factionVariation)	-- TODO: finish setting up hero sounds
		
		-- ===============================
		-- ALLIANCE VS. HERETIC GETH
		-- ===============================
		if factionVariation == SSVxGTH then
			print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Faction combination is SSVxGTH, loading associated common/wpn sound files")
			
			if string.find(SSVHeroClass, "shepard") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading SHEPARD data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Shepard_NonStreaming.lvl")
				
			elseif (string.find(SSVHeroClass, "cooper") or (loadCooper and loadCooper == true)) then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading COOPER data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Cooper_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "jack") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading JACK data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Jack_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "legion") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading LEGION data files...")
				
				
			elseif string.find(SSVHeroClass, "samara") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading SAMARA data files...")
				
			else
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading normal data files...")
				
			end
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_SSV_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- ALLIANCE VS. COLLECTORS
		-- ===============================
		elseif factionVariation == SSVxCOL then
			print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Faction combination is SSVxCOL, loading associated common/wpn sound files")
			
			if string.find(SSVHeroClass, "shepard") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading SHEPARD data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Shepard_NonStreaming.lvl")
				
			elseif (string.find(SSVHeroClass, "cooper") or (loadCooper and loadCooper == true)) then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading COOPER data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Cooper_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "jack") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading JACK data files...")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_Jack_NonStreaming.lvl")
				
			elseif string.find(SSVHeroClass, "legion") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading LEGION data files...")
				
				
			elseif string.find(SSVHeroClass, "samara") then
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading SAMARA data files...")
				
			else
				print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Loading normal data files...")
				
			end
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_SSV_SSV_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- EVOLVED GETH VS. HERETIC GETH
		-- ===============================
		elseif factionVariation == EVGxGTH then
			print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Faction combination is EVGxGTH, loading associated common/wpn sound files")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
			
		-- ===============================
		-- EVOLVED GETH VS. COLLECTORS
		-- ===============================
		elseif factionVariation == EVGxCOL then
			print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Faction combination is EVGxCOL, loading associated common/wpn sound files")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
			
		else
			print("ME5_MiscFunctions.PreLoadStuff.LoadFactionSounds(): Faction combination is invalid, loading common/wpn sound files for EVGxCOL as workaround")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
			
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_COL_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_GTH_NonStreaming.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
		end
	end
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			LoadFactionSounds(1)
		elseif ME5_SideVar == 2 then
			LoadFactionSounds(2)
		elseif ME5_SideVar == 3 then
			LoadFactionSounds(3)
		elseif ME5_SideVar == 4 then
			LoadFactionSounds(4)
		end
	else
		if onlineSideVar == "SSVxGTH" or onlineSideVar == 1 then
			LoadFactionSounds(1)
		elseif onlineSideVar == "SSVxCOL" or onlineSideVar == 2 then
			LoadFactionSounds(2)
		elseif onlineSideVar == "EVGxGTH" or onlineSideVar == 3 then
			LoadFactionSounds(3)
		elseif onlineSideVar == "EVGxCOL" or onlineSideVar == 4 then
			LoadFactionSounds(4)
		end
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
end

function SSVxGTH_PostLoad(spawns)
	if not ScriptCB_InMultiplayer() then
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			
			for cp in ipairs(spawns) do
				print("ME5_MiscFunctions.SSVxGTH_PostLoad(): Setting hero spawn cp, path = ", spawns[cp][1], spawns[cp][2])
				herosupport:AddSpawnCP(spawns[cp][1], spawns[cp][2])
			end
			
			herosupport:Start()
		end
	end
end

function SSVxCOL_PostLoad(spawns)
	if not ScriptCB_InMultiplayer() then
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, SSVHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, SSVHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			
			for cp in ipairs(spawns) do
				print("ME5_MiscFunctions.SSVxCOL_PostLoad(): Setting hero spawn cp, path = ", spawns[cp][1], spawns[cp][2])
				herosupport:AddSpawnCP(spawns[cp][1], spawns[cp][2])
			end
			
			herosupport:Start()
		end
	end
end

function EVGxGTH_PostLoad(spawns)
	if not ScriptCB_InMultiplayer() then
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, GTHHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, GTHHeroClass)
			
			for cp in ipairs(spawns) do
				print("ME5_MiscFunctions.EVGxGTH_PostLoad(): Setting hero spawn cp, path = ", spawns[cp][1], spawns[cp][2])
				herosupport:AddSpawnCP(spawns[cp][1], spawns[cp][2])
			end
			
			herosupport:Start()
		end
	end
end

function EVGxCOL_PostLoad(spawns)
	if not ScriptCB_InMultiplayer() then
		if ME5_AIHeroes == 0 then
			SetHeroClass(REP, EVGHeroClass)
			SetHeroClass(CIS, COLHeroClass)
		elseif ME5_AIHeroes == 1 then
			herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(REP, EVGHeroClass)
			herosupport:SetHeroClass(CIS, COLHeroClass)
			
			for cp in ipairs(spawns) do
				print("ME5_MiscFunctions.EVGxCOL_PostLoad(): Setting hero spawn cp, path = ", spawns[cp][1], spawns[cp][2])
				herosupport:AddSpawnCP(spawns[cp][1], spawns[cp][2])
			end
			
			herosupport:Start()
		end
	end
end


---
-- Performs various postload operations relating to the sides, such as setting up AI hero support based on the game mode.
-- @param #string gameMode		The mission's game mode. Acceptable values are "conquest", "1flag", "ctf", "siege", "survival", "campaign".
-- @param #table spawns			Two-dimensional array containing CPs and their spawn paths to pass to the AI hero support script. SYNTAX: CP name (string), CP spawn path name (string)
-- 
function Init_SidesPostLoad(gameMode, spawns)
	local mode = string.lower(gameMode)
	
	if mode == "conquest" or mode == "siege" then
		if not ScriptCB_InMultiplayer() then
			if ME5_SideVar == 1 then
				SSVxGTH_PostLoad(spawns)
			elseif ME5_SideVar == 2 then
				SSVxCOL_PostLoad(spawns)
			elseif ME5_SideVar == 3 then
				EVGxGTH_PostLoad(spawns)
			elseif ME5_SideVar == 4 then
				EVGxCOL_PostLoad(spawns)
			end
		else
			if onlineSideVar == SSVxGTH then
				SSVxGTH_PostLoad(spawns)
			elseif onlineSideVar == SSVxCOL then
				SSVxCOL_PostLoad(spawns)
			elseif onlineSideVar == EVGxGTH then
				EVGxGTH_PostLoad(spawns)
			elseif onlineSideVar == EVGxCOL then
				EVGxCOL_PostLoad(spawns)
			else
				SSVxGTH_PostLoad(spawns)
			end
		end
	end
end


---
-- Sets the local ally spawns.
-- @param #table spawns		Two-dimensional array containing CPs and their spawn paths to have local allies spawn at. SYNTAX: CP object name (string), CP spawn path name (string)
-- 
function SetAllySpawns(spawns)
	if spawns == {} then return end
	
	for cp in ipairs(spawns) do
		print("ME5_MiscFunctions.SetAllySpawns(): Setting ally spawn cp, path = ", spawns[cp][1], spawns[cp][2])
		SetProperty(spawns[cp][1], "AllyPath", spawns[cp][2])
	end
end


---
-- Sets up artillery strikes.
-- @param #string artilleryTurObj	The name of the artillery turret object.
-- @param #table strikeNodes		Two-dimensional array listing nodes to strike at. SYNTAX: path name (string), path node ID (integer)
-- @param #float strikeInitDelay	OPTIONAL: The length of time in seconds to wait before the first strike occurs. Set to 0 to disable initial delay completely. Default value: 20.0
-- 
function Init_ArtilleryStrikes(artilleryTurObj, strikeNodes, strikeInitDelay)
	-- Is the artillery turret object name set? If not, print an error message and exit the function
	if artilleryTurObj == nil then
		print("ME5_MiscFunctions.Init_ArtilleryStrikes(): WARNING: artilleryTurObj must be specified! Exiting function")
		return
	end
	-- Are the artillery strike nodes set? If not, print an error message and exit the function
	if strikeNodes == nil then
		print("ME5_MiscFunctions.Init_ArtilleryStrikes(): WARNING: strikeNodes must be specified! Exiting function")
		return
	end
	
	
	-- Init data fields 
	local strikeInitDelay = strikeInitDelay or 20.0
	local strikeDelay = 20.0
	local artilleryStrikeNodes = {}
	local curNode = 0
	
	local artilleryStrikeDelay_Timer = nil
	local artilleryStrikeDelay_TimerElapse = nil
	local artilleryStrikeInitDelay_Timer = nil
	local artilleryStrikeInitDelay_TimerElapse = nil
	
	
	ShuffleTable(strikeNodes)
	
	-- Choose the first node randomly
	if not ScriptCB_InMultiplayer() then
		curNode = math.random(1, table.getn(strikeNodes)) - 1
	else
		curNode = 0
	end
	
	-- Extract path points from artilleryStrikeNodes
	for i in ipairs(strikeNodes) do
		print("strikeNodes:", strikeNodes[i][1], strikeNodes[i][2])
		artilleryStrikeNodes[i] = GetPathPoint(strikeNodes[i][1], strikeNodes[i][2])
	end
	
	
	local function MoveToNextNode()
		-- Increment node
		curNode = curNode + 1
		if curNode == (table.getn(artilleryStrikeNodes) + 1) then
			curNode = 1
		end
		print("ME5_MiscFunctions.Init_ArtilleryStrikes(): Artillery transitioning to node: "..curNode.." ("..strikeNodes[curNode][1]..")")
		
		-- Move turret to next node
		SetEntityMatrix(artilleryTurObj, artilleryStrikeNodes[curNode])
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
		SetTimerValue(artilleryStrikeDelay_Timer, strikeDelay)
		--ShowTimer(artilleryStrikeDelay_Timer)	-- Uncomment me for test output!
	end
	
	--SetClassProperty("com_weap_bldg_artillery1_shell", "ReloadTime", strikeDelayStr)
	
	
	-- Has the initial strike delay been set?
	if strikeInitDelay > 0 then
		SetClassProperty("com_bldg_artillery1", "AutoFire", "0")
	
		-- Get or create a new artilleryStrikeInitDelay_Timer (this ensures there's only one "artilleryStrikeInitDelay_Timer" in the game at one time)
		artilleryStrikeInitDelay_Timer = FindTimer("artilleryStrikeInitDelay_Timer")
		if not artilleryStrikeInitDelay_Timer then
			artilleryStrikeInitDelay_Timer = CreateTimer("artilleryStrikeInitDelay_Timer")
			SetTimerValue(artilleryStrikeInitDelay_Timer, strikeInitDelay)
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
			SetTimerValue("artilleryStrikeDelay_Timer", strikeDelay)
			StartTimer("artilleryStrikeDelay_Timer")
		end,
	"artilleryStrikeDelay_Timer"
	)
end

function fHeadshotKill()
		print("ME5_MiscFunctions.fHeadshotKill(): Entered")
	--[[HeadshotHeadExplode = OnObjectHeadshot(
		function(object, killer)
				print("fHeadshotKill: Headshot")
			ShowMessageText("level.common.events.debug.headshot")	-- debug text
			
			if not IsObjectAlive(object) then
					print("fHeadshotKill: Unit is dead")
				ShowMessageText("level.common.events.debug.headshotkill")	-- debug text
				
				--local headPfx = CreateEffect("com_sfx_headexplode")
				--local charPos = GetEntityMatrix(object)
				--AttachEffectToMatrix(headPfx, charPos)
			end
		end
	)]]
	
	--[[HeadshotHeadExplode = OnCharacterDeath(
		function(player, killer)
				print("fHeadshotKill: Unit is dead")
					ShowMessageText("level.common.events.debug.headshotkill")	-- debug text
			if OnObjectHeadshot(player) then
					print("fHeadshotKill: Headshot")
						ShowMessageText("level.common.events.debug.headshot")	-- debug text
				local headshot2fx = CreateEffect("com_sfx_headexplode")
				local charPos = GetEntityMatrix(player)
				AttachEffectToObject(headshot2fx, charPos)
			end
		end
	)]] 

	
	--[[OnCharacterDeathTeam(
		function (OnObjectHeadshot)
				print("fHeadshotKill: Headshot")
			local headPfx = CreateEffect("com_sfx_headexplode")
			local charPos = GetEntityMatrix(object)
			AttachEffectToMatrix(headPfx, charPos)
		end,
	2)
	
	OnCharacterDeath(
		function (ObjectHeadshot)
				print("fHeadshotKill: Headshot")
			ShowMessageText("level.common.events.debug.headshot")	-- debug text
			
			local headshot2fx = CreateEffect("com_sfx_headexplode") 
			local charPos = GetEntityMatrix(object) 
			AttachEffectToObject(headshot2fx, character)
		end
	)]]

end

---
-- Runs the Juggernaut Squad functions (based on the faction combination) and low health functions. Also purges stock fonts if custom HUD is enabled.
-- 
function PostLoadStuff()
	print("ME5_MiscFunctions.PostLoadStuff(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Init_JuggernautSquads_GTH()
		elseif ME5_SideVar == 3 then
			Init_JuggernautSquads_EVG()
		end
	else
		if onlineSideVar == "SSVxGTH" or onlineSideVar == 1 then
			Init_JuggernautSquads_GTH()
		elseif onlineSideVar == "EVGxGTH" or onlineSideVar == 3 then
			Init_JuggernautSquads_EVG()
		end
	end
	
	Init_LowHealthFeedback()
	Init_PlayerDamageFeedback()
	if ME5_HitMarkerSound > 0 then
		Init_HitMarkerSounds()
	end
	--meu_lowhealth_postCall()
	
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\camshake.lvl")
	
	if ME5_CustomHUD == 1 then
		print("ME5_MiscFunctions.PostLoadStuff(): Overwriting stock fonts with blank font")
		-- Hotfix that overrides the stock fonts with a "blank font"
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_text.lvl")
	end
end

---
-- Interaction logic function.
-- This function contains all of the event responses and logic pertaining to the player's Interact weapon in campaigns.
-- @param #object object The object hit by the player's Interact weapon.
-- 
function DoInteraction(object)
		print("ME5_MiscFunctions.DoInteraction(): Entered")
	
	local objectPtr = GetEntityPtr(object)
	local objectName = GetEntityName(object)
	
	print("ME5_MiscFunctions.DoInteraction(): EntityPtr:", objectPtr)
	print("ME5_MiscFunctions.DoInteraction(): EntityName:", objectName)
	
end

---
-- Interaction weapon function.
-- This function contains the event triggers for the player's Interact weapon in campaigns.
-- 
function InteractWeapon()
	print("ME5_MiscFunctions.InteractWeapon(): Entered")
	
	-- Since this is a Lua weapon...
	OnObjectDamage(
		function( object, damager )
		
			-- Was the Interact weapon used?
			if GetObjectLastHitWeaponClass(object) == "weap_inf_interact" then
				print("ME5_MiscFunctions.InteractWeapon(): Object hit")
			
				-- Only objects can be affected!
				if GetObjectTeam(object) == 0 then
					print("ME5_MiscFunctions.InteractWeapon(): Object team is 0")
					
					-- Test output
					ShowMessageText("level.EUR.interactions.test.received")
					
					-- Do the interaction
					DoInteraction(object)
					
				else
					print("ME5_MiscFunctions.InteractWeapon(): Object team is not 0!")
				end
			end
		end
	)
	
	print("ME5_MiscFunctions.InteractWeapon(): Exited")
end

function PostInitStuff()
		print("ME5_MiscFunctions.PostInitStuff(): Entered")
		local PostInitStuffDebug = "ME5_MiscFunctions.PostInitStuff(): Changing ticket counts for ObjectiveSurvival..."
	if ObjectiveSurvivalHasRan == 1 then
		if Setup_SSVxGTH_sm == 1 or Setup_SSVxCOL_sm == 1 or Setup_SSVxGTH_xs == 1 or Setup_SSVxCOL_xs == 1 or Setup_SSVxGTH_xxs == 1 then
				print(PostInitStuffDebug)
			SetReinforcementCount(1, 100)
			SetReinforcementCount(2, 100)
		elseif Setup_SSVxGTH_med == 1 or Setup_SSVxCOL_med == 1 then
				print(PostInitStuffDebug)
			SetReinforcementCount(1, 125)
			SetReinforcementCount(2, 125)
		elseif Setup_SSVxGTH_lg == 1 or Setup_SSVxCOL_lg == 1 then
				print(PostInitStuffDebug)
			SetReinforcementCount(1, 150)
			SetReinforcementCount(2, 150)
		else
			print("ME5_MiscFunctions.PostInitStuff(): BY THE GODDESS, WHAT ON THESSIA IS HAPPENING")
		end
	else 
		print("ME5_MiscFunctions.PostInitStuff(): BY THE GODDESS, WHAT ON THESSIA IS HAPPENING")
	end
end


print("ME5_MiscFunctions: Exited")