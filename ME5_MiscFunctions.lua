-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Miscellaneous Functions Script by A. Gilbert
-- Version 30614/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Jun 14, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: The purpose of script is to create a list of 
-- various functions that are loaded in a map's mission script.
-- 
-- 
-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
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
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
			elseif RandomSide == 2 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
			elseif RandomSide == 3 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
			elseif RandomSide == 4 then
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
			end
		elseif ME5_SideVar == 1 then
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
		else end
	else
		if onlineSideVar == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif onlineSideVar == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		elseif onlineSideVar == 3 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif onlineSideVar == 4 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingameevg.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		else end
	end
	
	-- Load our custom shell stuff
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\common.lvl")
	
	-- What is the shell style set to in the Config Tool?
	if ME5_CustomGUIEnabled == 1 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\me5shell.lvl")
	elseif ME5_CustomGUIEnabled == 2 then
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\me3shell.lvl")
	else end
	
	-- Load localization
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\corebase.lvl")
	
	
	-- Get the player's aspect ratio so we can load the proper sniperscope sizes
	local screenWidth, screenHeight = ScriptCB_GetScreenInfo()
	local aspectRatio = screenWidth / screenHeight
		print("ME5_MiscFunctions.PreLoadStuff():", "Width: "..screenWidth, "Height: "..screenHeight..", Aspect Ratio: "..aspectRatio)
	
	-- What is the aspect ratio of the player's display?
	if aspectRatio <= 1.4 then
			print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 4:3, loading scopes as such")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar43\\ar.lvl")
	elseif aspectRatio <= 1.63 and aspectRatio >= 1.5 then
			print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 16:10, loading scopes as such")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar1610\\ar.lvl")
	elseif aspectRatio <= 1.9 and aspectRatio >= 1.63 then
			print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 16:9, loading scopes as such")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar169\\ar.lvl")
	else
			print("ME5_MiscFunctions.PreLoadStuff(): Error! Invalid aspect ratio ("..aspectRatio..")! Defaulting to workaround")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar.lvl")
	end
	
	
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
    	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
    	
    	-- Purge the stock HUD mshs
    	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_msh.lvl")
    	
    	-- Load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
		
		-- Purge the stock HUD textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_bmp.lvl")
		
		-- Load the new custom HUD and the objective screen text based on the game mode
		-- What is the active game mode? (NOTE: This is set near the beginning of each game mode's objective script)
		if MEUGameMode == meu_1flag then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_1flag")
		elseif MEUGameMode == meu_con then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_con")
		elseif MEUGameMode == meu_ctf then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_ctf")
		elseif MEUGameMode == meu_siege then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_siege")
		elseif MEUGameMode == meu_surv then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_surv")
		elseif MEUGameMode == meu_tdm then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl;hud_mode_tdm")
		elseif MEUGameMode == meu_campaign then
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
    	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingame.lvl")
    	
    	-- Load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
    	
		-- Load weapons.lvl for the stock HUD
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\weapons.lvl;hud_stock")
		
		-- Load the new onscreen pointer textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamehud.lvl")
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
	
	-- Load common sound LVL, includes many common sounds such as foley, explosions, prop sfx, etc.
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
	
	-- Load weapon sound LVL, includes all weapon sounds
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
	
	--==========================
	-- END SOUND WORK
	--==========================
	
	-- Call exterior functions
	fShieldPickup()
	fShieldRegenDelay()
	fKillSound()
	--fLowHealthSound()
	fEvgJugPowerDrain()
end

---
-- Sets up event responses for shield pickups.
-- 
function fShieldPickup()
		print("ME5_MiscFunctions.fShieldPickup(): Entered")
	--[[if not ScriptCB_InMultiplayer() then
		testcheckhumanspawn = OnCharacterSpawn(
			function(player)
				if IsCharacterHuman(player) then
					Iamhuman = GetEntityPtr(GetCharacterUnit(player))
				end
			end
		)
		
		shieldRegenTimerCount = 0
		
		ShieldRegenDelayStop = OnObjectDamage(
			function(object, damager)
				local playerHealth = GetObjectHealth(object)
				if Iamhuman == GetEntityPtr(object) and playerHealth > 0 then
					shieldRegenTimerCount = shieldRegenTimerCount + 1
						print("ShieldDelay: Character damaged")
						print(GetEntityPtr(object))
					
					StopTimer("shieldRegenTimer")
					DestroyTimer("shieldRegenTimer")

					SetProperty(object, "AddShield", "0.0")
					
					CreateTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						SetTimerValue("shieldRegenTimer" .. shieldRegenTimerCount, 5)
						ShowTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						StartTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						OnTimerElapse(
							function(timer)
									print("ShieldDelay: Regenerating shields")
								SetProperty(object, "AddShield", "50.0")
								ShowMessageText("level.common.events.debug.shieldregen")   -- debug text

								local shieldPfx = CreateEffect("com_sfx_pickup_shield")
								local charPos = GetEntityMatrix(object)
								AttachEffectToMatrix(shieldPfx, charPos)

								DestroyTimer("shieldRegenTimer" .. shieldRegenTimerCount)
							end,
						"shieldRegenTimer" .. shieldRegenTimerCount
					)
				end
			end
		)
	else
	
	OnHumanSpawn = OnCharacterSpawn(
		function(player)
			if IsCharacterHuman(player) then
					print("OnHumanSpawn: Human spawned")
				--local charTeam = GetCharacterTeam(player)
				local charIndex = GetTeamMember(REP, 0)
				local charPtr = GetCharacterUnit(player)
				SetAIDamageThreshold(charPtr, 0.5)
			end
		end
	)]]
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
				print("ME5_MiscFunctions.fShieldPickup(): Configuring Shield Functionality for AUTO-REGEN...")
			--[[SetClassProperty("ssv_inf_default", "AddShield", 9.0)
			SetClassProperty("ssv_inf_default_sentinel", "AddShield", 18.0)
			
			SetClassProperty("gth_inf_default", "AddShield", 11.0)
			SetClassProperty("gth_inf_default_trooper", "AddShield", 15.0)
			
			SetClassProperty("col_inf_default", "AddShield", 12.0)]]
			
			--SetClassProperty("com_inf_default", "AddShield", 14.0)
			
		elseif ME5_ShieldFunc == 2 then
				print("ME5_MiscFunctions.fShieldPickup(): Configuring Shield Functionality for PICKUPS...")
				------------------------------------------------
				-- DON'T FORGET TO UPDATE MULTIPLAYER VERSION --
				------------------------------------------------
			SetClassProperty("com_inf_default", "NextDropItem", "-")
			SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_shields")
			SetClassProperty("com_inf_default", "DropItemProbability", 0.3)
			
			SetClassProperty("com_hero_default", "NextDropItem", "-")
			SetClassProperty("com_hero_default", "DropItemClass", "com_item_powerup_shields")
			SetClassProperty("com_hero_default", "DropItemProbability", 0.3)
			
			shieldDropCnt = 0	-- debug variable used to count # times item is dropped
		
			local itempickup = OnFlagPickUp(
				function(flag, character)
						print("ShieldRegen: Unit picked up flag")
					local charPtr = GetCharacterUnit(character)
					
					if GetEntityClass(flag) == FindEntityClass("com_item_powerup_shields") then
							--ShowMessageText("level.common.events.debug.shieldregen")	-- debug text
						--SetProperty(charPtr, "AddShield", 175)
						
						KillObject(flag)
						
						local curShields = GetObjectShield(charPtr)
							print("ShieldRegen: Unit's current shields: "..curShields)
						local newShields = curShields + 150
						
						local isHeroMsg = "ShieldRegen: Unit is hero class; no shields added"
						if GetEntityClass(charPtr) == FindEntityClass("col_hero_harbinger") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("gth_hero_prime_me2") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("gth_hero_prime_me3") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_ashley") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_jack") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_kaidan") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_legion") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_samara") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_shepard_adept") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_shepard_engineer") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_shepard_infiltrator") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_shepard_sentinel") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_shepard_soldier") then
							print(isHeroMsg)
						elseif GetEntityClass(charPtr) == FindEntityClass("ssv_hero_shepard_vanguard") then
							print(isHeroMsg)
						else
							SetProperty(charPtr, "CurShield", newShields)
								print("ShieldRegen: Unit's new shields: "..newShields)
						
							shieldDropCnt = shieldDropCnt + 1
								print("ShieldRegen: Shield drop count: "..shieldDropCnt)
						end
						
						local shieldPfx = CreateEffect("com_sfx_pickup_shield")
						local charPos = GetEntityMatrix(charPtr)
						AttachEffectToMatrix(shieldPfx, charPos)
						
						--[[local shieldTimer = CreateTimer("shieldTimer")
						SetTimerValue(shieldTimer, 1)
						StartTimer(shieldTimer)
						local shield_timer = OnTimerElapse(
							function(timer)
									print("ShieldRegen: Shield regen complete")
									ShowMessageText("level.common.events.debug.noregen")	-- debug text
								SetProperty(charPtr, "AddShield", 0)
								
								DestroyTimer(timer)
							end,
						shieldTimer
						)]]
					end
				end
			)
		end
		
		if ME5_HealthFunc == 1 then
				print("ME5_MiscFunctions.fShieldPickup(): Configuring Health Functionality for AUTO-REGEN...")
			SetClassProperty("com_inf_default", "AddHealth", 4.0)
		elseif ME5_HealthFunc == 2 then
				print("ME5_MiscFunctions.fShieldPickup(): Configuring Health Functionality for PICKUPS...")
			SetClassProperty("com_inf_default", "NextDropItem", "-")
			SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_health")
			SetClassProperty("com_inf_default", "DropItemProbability", 0.2)
			
			SetClassProperty("com_hero_default", "NextDropItem", "-")
			SetClassProperty("com_hero_default", "DropItemClass", "com_item_powerup_health")
			SetClassProperty("com_hero_default", "DropItemProbability", 0.2)
		else
				print("ME5_MiscFunctions.fShieldPickup(): Error! ME5_ShieldFunc setting is invalid! Defaulting to Health Functionality for AUTO-REGEN")
			SetClassProperty("com_inf_default", "AddHealth", 4.0)
		end
	else
			print("ME5_MiscFunctions.fShieldPickup(): Configuring Shield Functionality for AUTO-REGEN...")
		--[[SetClassProperty("ssv_inf_default", "AddShield", 9.0)
		SetClassProperty("ssv_inf_default_sentinel", "AddShield", 18.0)
		
		SetClassProperty("gth_inf_default", "AddShield", 11.0)
		SetClassProperty("gth_inf_default_trooper", "AddShield", 15.0)
		
		SetClassProperty("col_inf_default", "AddShield", 12.0)]]
		
		--SetClassProperty("com_inf_default", "AddShield", 14.0)
		
			print("ME5_MiscFunctions.fShieldPickup(): Configuring Health Functionality for PICKUPS...")
		SetClassProperty("com_inf_default", "NextDropItem", "-")
		SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_health")
		SetClassProperty("com_inf_default", "DropItemProbability", 0.2)
		
		SetClassProperty("com_hero_default", "NextDropItem", "-")
		SetClassProperty("com_hero_default", "DropItemClass", "com_item_powerup_health")
		SetClassProperty("com_hero_default", "DropItemProbability", 0.2)
	end
	--end
	
	
	
	--[[humantable = {}
	humantotal = 0

	testcheckhumanspawn = OnCharacterSpawn(
		function(player)
			if IsCharacterHuman(player) then
				humantable[humantotal] = GetEntityPtr(GetCharacterUnit(player))
					print(humantable[humantotal])
				humantotal = humantotal + 1
			end
		end
	)

	ShieldRegenDelayStop = OnObjectDamage(
		function(object, damager)
			iterateplayer = 0
			while iterateplayer <= humantotal do
				if humantable[iterateplayer] == GetEntityPtr(object) then            
					shieldRegenTimerCount = 5
						print("ShieldDelay: Character damaged")
						print(GetEntityPtr(object))
						print(iterateplayer)
						print(humantotal)

					SetProperty(object, "AddShield", "0.0")

					CreateTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						SetTimerValue("shieldRegenTimer" .. shieldRegenTimerCount, 5)
						ShowTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						StartTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						OnTimerElapse(
							function(timer)
									print("ShieldDelay: Regenerating shields")
								SetProperty(object, "AddShield", "50.0")
								ShowMessageText("level.common.events.debug.shieldregen")   -- debug text

								local shieldPfx = CreateEffect("com_sfx_pickup_shield")
								local charPos = GetEntityMatrix(object)
								AttachEffectToMatrix(shieldPfx, charPos)

								DestroyTimer("shieldRegenTimer" .. shieldRegenTimerCount)
							end,
						"shieldRegenTimer" .. shieldRegenTimerCount
					)
				end
			iterateplayer = iterateplayer + 1
			end
		end
	)]]
	
	
	
	--[[shieldRegenTimerCount = 0
		
		ShieldRegenDelay = OnObjectDamage(
			function(object, damager)
				if IsCharacterHuman(object) then
						print("ShieldDelay: Character damaged")
					shieldRegenTimerCount = shieldRegenTimerCount + 1
					
					SetProperty(object, "AddShield", "0.0")
					
					CreateTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						SetTimerValue("shieldRegenTimer" .. shieldRegenTimerCount, 5)
						ShowTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						StartTimer("shieldRegenTimer" .. shieldRegenTimerCount)
						OnTimerElapse(
							function(timer)
									print("ShieldDelay: Regenerating shields")
								SetProperty(object, "AddShield", "50.0")
								--ShowMessageText("level.common.events.debug.shieldregen")	-- debug text
								
								local shieldPfx = CreateEffect("com_sfx_pickup_shield")
								local charPos = GetEntityMatrix(object)
								AttachEffectToMatrix(shieldPfx, charPos)
								
								DestroyTimer("shieldRegenTimer" .. shieldRegenTimerCount)
							end,
						"shieldRegenTimer" .. shieldRegenTimerCount
					)
				end
			end
		)]]
end

---
-- Sets up the event responses and logic for deferred shield regeneration.
-- 
function fShieldRegenDelay()
	print("ME5_MiscFunctions.fShieldRegenDelay(): Entered")
	
	--=================================
	-- Data Fields
	--=================================
	
	-- Shield regeneration parameters
	local shieldRegenDelayValue = 5.0	-- How long in seconds does it take for shields to start regenerating?
	local shieldRegenValueMult = 3.0	-- What is the player's base AddShield value multiplied by?
	local shieldRegenSound = "none"		-- The sound property that plays when the player's shields start regenerating. Use "none" if no sound is desired.
	local shieldRegenPfx = "none"		-- Name of the particle effect to attach to the player when their shields start regenerating. Use "none" if no particle effect is desired.
	
	-- Table of unit classes with regenerating shields. /class/ is the class's name, /addShield/ is the class's AddShield value.
	local shieldClasses = {
				{ class = "col_inf_guardian_shield", 				addShield = 14.0 }, 
				{ class = "col_inf_guardian_online_shield", 		addShield = 14.0 }, 
				{ class = "gth_inf_trooper_shield", 				addShield = 14.0 }, 
				{ class = "gth_inf_rocketeer_shield", 				addShield = 14.0 }, 
				{ class = "gth_inf_sniper_shield", 					addShield = 14.0 }, 
				{ class = "gth_inf_machinist_shield", 				addShield = 14.0 }, 
				{ class = "gth_inf_hunter_shield", 					addShield = 14.0 }, 
				{ class = "gth_inf_shock_shield", 					addShield = 14.0 }, 
				{ class = "gth_inf_shock_online_shield", 			addShield = 14.0 }, 
				{ class = "gth_inf_destroyer_shield", 				addShield = 14.0 }, 
				{ class = "gth_inf_juggernaut_shield", 				addShield = 14.0 }, 
				{ class = "gth_inf_prime_shield", 					addShield = 22.0 }, 
				{ class = "gth_ev_inf_trooper_shield", 				addShield = 14.0 }, 
				{ class = "gth_ev_inf_infiltrator_shield", 			addShield = 14.0 }, 
				{ class = "gth_ev_inf_engineer_shield", 			addShield = 14.0 }, 
				{ class = "gth_ev_inf_rocketeer_shield", 			addShield = 14.0 }, 
				{ class = "gth_ev_inf_hunter_shield", 				addShield = 14.0 }, 
				{ class = "gth_ev_inf_pyro_shield", 				addShield = 14.0 }, 
				{ class = "gth_ev_inf_juggernaut_shield", 			addShield = 14.0 }, 
				{ class = "gth_ev_inf_juggernaut_online_shield",	addShield = 14.0 }, 
				{ class = "ssv_inf_soldier_shield", 				addShield = 14.0 }, 
				{ class = "ssv_inf_infiltrator_shield", 			addShield = 14.0 }, 
				{ class = "ssv_inf_engineer_shield", 				addShield = 14.0 }, 
				{ class = "ssv_inf_adept_shield", 					addShield = 14.0 }, 
				{ class = "ssv_inf_sentinel_shield", 				addShield = 14.0 }, 
				{ class = "ssv_inf_vanguard_shield", 				addShield = 14.0 }, 
				{ class = "ssv_inf_cooper_soldier", 				addShield = 14.0 }, 
				{ class = "ssv_inf_cooper_infiltrator", 			addShield = 14.0 }, 
				{ class = "ssv_inf_cooper_engineer", 				addShield = 14.0 }, 
				{ class = "ssv_inf_cooper_adept", 					addShield = 14.0 }, 
				{ class = "ssv_inf_cooper_sentinel", 				addShield = 14.0 }, 
				{ class = "ssv_inf_cooper_vanguard", 				addShield = 14.0 }, }
	
	
	-- Shield break parameters
	local shieldRebreakDelayValue = 2.5					-- How many seconds must pass before shields can be re-broken?
	local shieldBreakSound = "unit_shields_break"		-- The sound property that plays when the player's shields are completely depleted. Use "none" if no sound is desired.
	local shieldBreakPfx = "none"						-- Name of the particle effect to attach to the player when their shields break. Use "none" if no particle effect is desired.
	local shieldBreakCamShakeObj = "com_item_camshake"	-- The class name of the EntityMine object. Use "none" if camera shaking is not desired. If a valid name is 
														--  specified, the object's explosion shake properties will be utilized to simulate camera shaking when the 
														--  player's shields break.
	local bShieldBreakDucksBuses = true					-- Should the audio buses be briefly ducked when the player's shields are broken?
	local busDuckDuration = 1.0							-- How long in seconds should the audio buses be faded for when the player's shields are broken?
	local busDuckEndGain = 0.35							-- What is the end gain for the audio buses when they're ducked?
	local busDuckFadeDuration = 0.2						-- What is the duration in seconds of the bus duck fade?
	local busUnDuckFadeDuration = 0.7					-- What is the duration in seconds of the bus unduck fade?
	
	
	-- Miscellaneous parameters
	local bDebugEnabled = false			-- Should debug messages be enabled, and the delay timer be shown?
	
	
	-- Fields that are handled internally
	local charUnit = nil				-- The player's character unit.
	local charPtr = nil					-- The player's unit entity pointer.
	local charClass = nil				-- The name of the player's class.
	local regenBaseValue = nil			-- What is the player's base AddShield value?
	local regenFinalValue = nil			-- What is the player's final AddShield value?
	local bIsRegenStopped = false		-- Is shield regeneration currently stopped?
	local bIsRegenTimerStarted = false	-- Is the shieldRegenTimer currently started?
	local bIsPlayerCorrectClass = false	-- Is the player a class with shields?
	local playerMaxHealth = 0			-- What is the player's health when they spawn?
	local camShakeObjCount = 0			-- How many camshake objects have been spawned?
	local bShieldsCanBeBroken = true	-- Can the shields be re-broken yet?
	
	
	--=================================
	-- Persistent Timers
	--=================================
	
	-- Get or create a new shieldRegenTimer (this ensures there's only one "fShieldRegenDelay_regenTimer" in the game at one time)
	local shieldRegenTimer = FindTimer("fShieldRegenDelay_regenTimer")
	if not shieldRegenTimer then
		shieldRegenTimer = CreateTimer("fShieldRegenDelay_regenTimer")
		SetTimerValue(shieldRegenTimer, shieldRegenDelayValue)
		
		--ShowTimer(shieldRegenTimer)	-- Uncomment me for test output!
	end
	
	
	-- Get or create a new shieldRebreakTimer (this ensures there's only one "fShieldRegenDelay_rebreakTimer" in the game at one time)
	local shieldRebreakTimer = FindTimer("fShieldRegenDelay_rebreakTimer")
	if not shieldRebreakTimer then
		shieldRebreakTimer = CreateTimer("fShieldRegenDelay_rebreakTimer")
		SetTimerValue(shieldRebreakTimer, shieldRebreakDelayValue)
		
		--ShowTimer(shieldRebreakTimer)	-- Uncomment me for test output!
	end
	
	
	--=================================
	-- Local Functions
	--=================================
	
	---
	-- Call this to start shield regeneration for /unit/.
	-- @param #object unit The object to start the regeneration for.
	-- 
	local function StartRegeneration(unit)
		-- Prevent the function from being executed multiple times at once
		if bIsRegenStopped == false then return end
		
		bIsRegenStopped = false
		
		-- Restart the shield break timer
		SetTimerValue(shieldRebreakTimer, shieldRebreakDelayValue)
		StartTimer(shieldRebreakTimer)
		
		
		if bDebugEnabled == true then
			print("ME5_MiscFunctions.fShieldRegenDelay.StartRegeneration(): Starting shield regeneration")
			ShowMessageText("level.common.debug.shields_starting", REP)
			ShowMessageText("level.common.debug.shields_starting", CIS)
		end
		
		-- Are we supposed to play a sound?
		if shieldRegenSound ~= "none" then
			ScriptCB_SndPlaySound(shieldRegenSound)
		end
		
		-- Are we supposed to spawn a particle effect?
		if shieldRegenPfx ~= "none" then
			PlayParticleEffectOnUnit(shieldRegenPfx, unit)
		end
		
		-- Turn regeneration back on
		SetProperty(unit, "AddShield", regenFinalValue)
	end
	
	
	---
	-- Call this to stop shield regeneration for /unit/.
	-- @param #object unit The object to stop the regeneration for.
	-- 
	local function StopRegeneration(unit)
		-- Reset the regen timer value
		SetTimerValue(shieldRegenTimer, shieldRegenDelayValue)
		
		-- Prevent the function from being executed multiple times at once
		if bIsRegenStopped == true then return end
		
		bIsRegenStopped = true
		
		
		if bDebugEnabled == true then
			print("ME5_MiscFunctions.fShieldRegenDelay.StopRegeneration(): Stopping shield regeneration")
			ShowMessageText("level.common.debug.shields_stopping", REP)
			ShowMessageText("level.common.debug.shields_stopping", CIS)
		end
		
		-- Reset the shield break timer
		StopTimer(shieldRebreakTimer)
		SetTimerValue(shieldRebreakTimer, shieldRebreakDelayValue)
		
		-- Turn off regeneration
		SetProperty(unit, "AddShield", 0)
		
		-- Start the delay timer
		StartTimer(shieldRegenTimer)
	
		-- When the shield regen timer elapses
		local shieldRegenTimerElapse = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(shieldRegenTimerElapse)
				StopTimer(shieldRegenTimer)
				
				StartRegeneration(unit)
			end, 
		shieldRegenTimer
		)
	end
	
	
	---
	-- Call this to duck (fade) all of the audio buses (excluding lowhealth). Only has an effect if the low health sound isn't playing.
	-- @return #bool True if the buses are supposed to be ducked, false if not.
	-- 
	local function DuckBuses()
		-- Are the audio buses supposed to be ducked when the shields break?
		if bShieldBreakDucksBuses == true then
		
			-- Is the low health sound not playing?
			if LH_bIsLowHealthSoundPlaying == false then
				-- Fade all of the appropriate audio buses
				ScriptCB_SndBusFade("main",				busDuckFadeDuration, busDuckEndGain)
				ScriptCB_SndBusFade("soundfx",			busDuckFadeDuration, busDuckEndGain)
				ScriptCB_SndBusFade("battlechatter",	busDuckFadeDuration, busDuckEndGain)
				ScriptCB_SndBusFade("music",			busDuckFadeDuration, 0.6)	-- Don't duck the music buses as much
				ScriptCB_SndBusFade("ingamemusic",		busDuckFadeDuration, 0.6)
				ScriptCB_SndBusFade("ambience",			busDuckFadeDuration, busDuckEndGain)
				ScriptCB_SndBusFade("voiceover",		busDuckFadeDuration, busDuckEndGain)
			end
			
			return true
		else
			return false
		end
	end
	
	
	---
	-- Call this to unduck (unfade) all of the audio buses (excluding lowhealth). Only has an effect if the low health sound isn't playing.
	-- @return #bool True if the buses are supposed to be ducked, false if not.
	-- 
	local function UnDuckBuses()
		-- Are the audio buses supposed to be ducked when the shields break?
		if bShieldBreakDucksBuses == true then
			
			-- Is the low health sound not playing?
			if LH_bIsLowHealthSoundPlaying == false then
				-- Unfade all of the audio buses
				ScriptCB_SndBusFade("main",				busUnDuckFadeDuration, 1.0)
				ScriptCB_SndBusFade("soundfx",			busUnDuckFadeDuration, 0.7)
				ScriptCB_SndBusFade("battlechatter",	busUnDuckFadeDuration, 1.0)
				ScriptCB_SndBusFade("music",			busUnDuckFadeDuration, 1.0)
				ScriptCB_SndBusFade("ingamemusic",		busUnDuckFadeDuration, 0.7)
				ScriptCB_SndBusFade("ambience",			busUnDuckFadeDuration, 0.7)
				ScriptCB_SndBusFade("voiceover",		busUnDuckFadeDuration, 0.8)
			end
			
			return true
		else
			return false
		end
	end
	
	
	---
	-- Call this to attach a particle /effect/ to /unit/.
	-- @param #string effect The name of the particle effect to attach.
	-- @param #object unit The character unit to attach the particle effect to.
	--  
	local function PlayParticleEffectOnUnit(effect, unit)
		-- Instantiate the particle effect
		local pfx = CreateEffect(effect)
		
		-- Store the unit's location
		local location = GetEntityMatrix(unit)
		
		-- And move/attach the particle effect to that location
		AttachEffectToMatrix(pfx, location)
	end
	
	
	---
	-- Call this to shake the camera utilizing the explosion properties from /object/.
	-- @param #string object The class name of the EntityMine object whose explosion properties we're utilizing.
	-- 
	local function ShakeCamera(object)
		-- Increment the object count
		camShakeObjCount = camShakeObjCount + 1
		
		-- Spawn the EntityMine object at the player's location
		CreateEntity(object, GetEntityMatrix(charUnit), "camshake_item_"..camShakeObjCount)
	end
	
	
	---
	-- Call this to break the shields of /unit/.
	-- @param #object unit The character unit whose shields we're breaking.
	-- 
	local function BreakShields(unit)
		-- Are the player's shields able to be re-broken yet?
		if bShieldsCanBeBroken == true then
			
			bShieldsCanBeBroken = false
			
			-- Are we supposed to play a sound?
			if shieldBreakSound ~= "none" then
				ScriptCB_SndPlaySound(shieldBreakSound)
			end
			
			-- Are we supposed to spawn a particle effect?
			if shieldBreakPfx ~= "none" then
				PlayParticleEffectOnUnit(shieldBreakPfx, unit)
			end
			
			-- Are we supposed to shake the camera?
			if shieldBreakCamShakeObj ~= "none" then
				ShakeCamera(shieldBreakCamShakeObj)
			end
			
						
			-- What is the player's current health?
			local playerCurHealth = GetObjectHealth(unit)
			
			if playerMaxHealth <= 0 then
				playerMaxHealth = 300
			end
			
			-- What's the player's current health percentage?
			local playerHealthPercent = playerCurHealth / playerMaxHealth
			
			-- Is the low health sound not activating?
			if playerHealthPercent >= LH_playerHealthThreshold then
			
				-- Fade the audio buses briefly
				DuckBuses()
				
				-- Create a temp timer that'll unfade the buses after a short amount of time
				local busTimer = CreateTimer("fShieldRegenDelay_busTimer")
				SetTimerValue(busTimer, 1.15)
				StartTimer(busTimer)
				
				-- Bus timer elapse
				local busTimerElapse = OnTimerElapse(
					function(timer)
						-- Unfade the buses
						UnDuckBuses()
						
						-- Garbage collection
						ReleaseTimerElapse(busTimerElapse)
						DestroyTimer(busTimer)
					end,
				busTimer
				)
			else
				if bDebugEnabled == true then
					print("ME5_MiscFunctions.fShieldRegenDelay.playershieldschange(): playerHealthPercent, LH_playerHealthThreshold:", playerHealthPercent, LH_playerHealthThreshold)
					print("ME5_MiscFunctions.fShieldRegenDelay.playershieldschange(): Low health sound activating, skipping bus ducking")
				end
			end
		end
	end
	
	
	--=================================
	-- Event Responses
	--=================================
	
	-- When the shield rebreak timer elapses
	local shieldRebreakTimerElapse = OnTimerElapse(
		function(timer)
			StopTimer(shieldRebreakTimer)
			
			bShieldsCanBeBroken = true
		end, 
	shieldRebreakTimer
	)
	
	-- When the player spawns
    local playerspawn = OnCharacterSpawn(
	    function(character)
	    	-- Is the character human?
	        if character == 0 then
	        	charUnit = GetCharacterUnit(character)
	        	charPtr = GetEntityPtr(charUnit)
	        	charClass = GetEntityClass(charPtr)
				playerMaxHealth = GetObjectHealth(charPtr)	-- TODO: This might become an issue if CharacterSpawn also applies to changing classes at CPs.
	        	
				-- For each shield class,
				for i in pairs(shieldClasses) do
					-- Is the player a shield class?
					if charClass == FindEntityClass(shieldClasses[i]['class']) then
						bIsPlayerCorrectClass = true
						
						-- Calculate the player's AddShield value
						regenBaseValue = shieldClasses[i]['addShield']
						regenFinalValue = regenBaseValue * shieldRegenValueMult
					else
						bIsPlayerCorrectClass = false
					end
					
					-- Break out of the loop if correct class
					if bIsPlayerCorrectClass == true then break end
				end
	        end
	    end
    )
	
	-- When the player is damaged
	local playerdamage = OnObjectDamage(
		function(object, damager)
		
			-- Is the player the affected object?
			if charUnit == GetEntityPtr(object) and bIsPlayerCorrectClass == true then
			
				-- Stop shield regeneration
				StopRegeneration(object)
			end
		end
	)
	
	-- When the player's shields are altered (except from AddShield, of course)
	local playershieldschange = OnShieldChange(
		function(object, shields)
			
			-- Is the player the affected object?
			if charUnit == GetEntityPtr(object) and bIsPlayerCorrectClass == true then
				
				-- Are the player's shields completely depleted?
				if shields <= 0 then
				
					-- Break the player's shields
					BreakShields(object)
				end
			end
		end
	)
	
	-- When the player dies
	local playerdeath = OnObjectKill(
		function(player, killer)
		
			-- Is the player the affected object?
			if charUnit == GetEntityPtr(player) then
			
				StopTimer(shieldRegenTimer)
				
				-- Reset the timer's value
				SetTimerValue(shieldRegenTimer, shieldRegenDelayValue)
				bIsRegenStopped = false
			end
		end
	)
	
	print("ME5_MiscFunctions.fShieldRegenDelay(): Exited")
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
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				fGthJugSquad()
			elseif RandomSide == 3 then
				fEvgJugSquad()
			end
		elseif ME5_SideVar == 1 then
			fGthJugSquad()
		elseif ME5_SideVar == 3 then
			fEvgJugSquad()
		end
	else
		if onlineSideVar == 1 then
			fGthJugSquad()
		elseif onlineSideVar == 3 then
			fEvgJugSquad()
		end
	end
	
	fLowHealthSound()
	fPlayerDamageSound()
	--meu_lowhealth_postCall()
	
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\camshake.lvl")
	
	if ME5_CustomHUD == 1 then
			print("ME5_MiscFunctions.PostLoadStuff(): Overwriting stock fonts with blank font")
		-- Hotfix that overrides the stock fonts with a "blank font"
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_text.lvl")
	end
end

---
-- Sets up the event responses for Heretic Geth Juggernaut squads.
-- 
function fGthJugSquad()
	print("ME5_MiscFunctions.fGthJugSquad(): Entered")
	
	local players = {}
	local goals = {}
	local count = 0
	local addgoal = OnCharacterSpawn(
		function(player)
			if GetCharacterClass(player) == 7 and GetCharacterTeam(player) == CIS then -- replace 4 with the index of your commander, starting with 0
				local seen = false
				for i = 1,count do
					if players[i] == player then
						seen = true
						goals[i] = AddAIGoal(CIS, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight too
					end
				end
				if not seen then
					count = count + 1
					players[count] = player
					goals[count] = AddAIGoal(CIS, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight too
				end
			end
		end
	)
	
	local removegoal = OnCharacterDeath(
		function(player,killer)
			for j = 1,count do
				if players[i] == player and not goals[i] == nil then
					DeleteAIGoal(goals[i])
					goals[i] = nil
				end
			end
		end
	)
end

---
-- Sets up the event responses for Evolved Geth Juggernaut squads.
-- 
function fEvgJugSquad()
	print("ME5_MiscFunctions.fEvgJugSquad(): Entered")
	
	local players = {}
	local goals = {}
	local count = 0
	local addgoal = OnCharacterSpawn(
		function(player)
			if GetCharacterClass(player) == 6 and GetCharacterTeam(player) == REP then -- replace 4 with the index of your commander, starting with 0
				local seen = false
				for i = 1,count do
					if players[i] == player then
						seen = true
						goals[i] = AddAIGoal(REP, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight too
					end
				end
				if not seen then
					count = count + 1
					players[count] = player
					goals[count] = AddAIGoal(REP, "Follow", 8, GetCharacterUnit(player)) -- or "Follow" if you want them to follow very closely, and change the weight
				end
			end
		end
	)
	
	local removegoal = OnCharacterDeath(
		function(player,killer)
			for j = 1,count do
				if players[i] == player and not goals[i] == nil then
					DeleteAIGoal(goals[i])
					goals[i] = nil
				end
			end
		end
	)
end

---
-- Sets up the event responses for kill sounds.
-- 
function fKillSound()
	print("ME5_MiscFunctions.fKillSound(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_KillSound == 0 then
			print("ME5_MiscFunctions.fKillSound(): Initializing kill sound setting for DISABLED...")
		else
			print("ME5_MiscFunctions.fKillSound(): Initializing kill sound setting for ENABLED...")
			
			local enemydeath = OnCharacterDeath(
				function(player, killer)
					if killer and IsCharacterHuman(killer) then
						local playerTeam = GetCharacterTeam(player)
						local killerTeam = GetCharacterTeam(killer)
						
						-- Was the killed unit's team different from the killer's?
						if playerTeam ~= killerTeam then
							-- Is this not a campaign?
							if not IsCampaign() then
								ScriptCB_SndPlaySound("hud_player_kill")
							else
								local world = string.lower(GetWorldFilename())
								
								-- Are we on Europa?
								if world == "eur" then
									-- Is the victim team not the squad team?
									if playerTeam ~= 3 then
										ScriptCB_SndPlaySound("hud_player_kill")
									end
								end
							end
						end
					end
				end
			)
		end
	else
		print("ME5_MiscFunctions.fKillSound(): Initializing kill sound setting for DISABLED...")
	end
end

---
-- Sets up the event responses for the player damage sounds.
-- 
function fPlayerDamageSound()
	print("ME5_MiscFunctions.fPlayerDamageSound(): Entered")
	
	local Iamhuman = nil					-- Pointer for human player.
	local bIsDamagerCorrectClass = false	-- Is the damager the correct class?
	local damagerFaction = "none"			-- Which faction is the damager from?
	
	-- COL ballistic weapons.
	local ballisticWeapons_COL = {
					"col_weap_inf_rifle_col",
					"col_weap_inf_rifle_col_shredder",
					"col_weap_inf_rifle_colcarbine",
					"col_weap_inf_shotgun_pulse",
					"col_weap_inf_shouldercannon" }
	
	-- GTH ballistic weapons.
	local ballisticWeapons_GTH = {
					"gth_weap_bldg_assaultdrone",
					"gth_weap_bldg_gethturret",
					"gth_weap_inf_heavy_spitfire",
					"gth_weap_inf_rifle_m76",
					"gth_weap_inf_rifle_m76_boss",
					"gth_weap_inf_rifle_pulse",
					"gth_weap_inf_shotgun_m23",
					"gth_weap_inf_shotgun_m27",
					"gth_weap_inf_shotgun_plasma",
					"gth_weap_inf_smg_pulse",
					"gth_weap_inf_sniper_javelin",
					"gth_weap_inf_sniper_m97",
					"gth_weap_walk_colussus_gun" }
	
	-- INDOC ballistic weapons.
	local ballisticWeapons_INDOC = {
					"indoc_weap_inf_armcannon",
					"indoc_weap_inf_rifle_phaeston" }
	
	-- SSV ballistic weapons.
	local ballisticWeapons_SSV = {
					"ssv_weap_fly_a61_gunship_gun",
					"ssv_weap_inf_heavy_spitfire",
					"ssv_weap_inf_pistol_m3",
					"ssv_weap_inf_pistol_m3_armor",
					"ssv_weap_inf_pistol_m3_disruptor",
					"ssv_weap_inf_pistol_m3_incendiary",
					"ssv_weap_inf_pistol_m5",
					"ssv_weap_inf_pistol_m5_incendiary",
					"ssv_weap_inf_pistol_m6",
					"ssv_weap_inf_pistol_n7eagle",
					"ssv_weap_inf_pistol_n7eagle_armor",
					"ssv_weap_inf_rifle_m8",
					"ssv_weap_inf_rifle_m8_armor",
					"ssv_weap_inf_rifle_m8_disruptor",
					"ssv_weap_inf_rifle_m8_incendiary",
					"ssv_weap_inf_rifle_m15",
					"ssv_weap_inf_rifle_m76",
					"ssv_weap_inf_rifle_m96",
					"ssv_weap_inf_shotgun_m23",
					"ssv_weap_inf_shotgun_m23_armor",
					"ssv_weap_inf_shotgun_m23_disruptor",
					"ssv_weap_inf_shotgun_m23_incendiary",
					"ssv_weap_inf_shotgun_m27",
					"ssv_weap_inf_shotgun_m27_disruptor",
					"ssv_weap_inf_shotgun_n7crusader",
					"ssv_weap_inf_shotgun_n7crusader_incendiary",
					"ssv_weap_inf_shotgun_plasma",
					"ssv_weap_inf_smg_m4",
					"ssv_weap_inf_smg_m4_disruptor",
					"ssv_weap_inf_smg_m9",
					"ssv_weap_inf_smg_m9_armor",
					"ssv_weap_inf_smg_m9_disruptor",
					"ssv_weap_inf_smg_m9_incendiary",
					"ssv_weap_inf_smg_m12",
					"ssv_weap_inf_smg_n7hurricane",
					"ssv_weap_inf_smg_n7hurricane_disruptor",
					"ssv_weap_inf_sniper_m92",
					"ssv_weap_inf_sniper_m92_armor",
					"ssv_weap_inf_sniper_m92_disruptor",
					"ssv_weap_inf_sniper_m92_incendiary",
					"ssv_weap_inf_sniper_m97",
					"ssv_weap_inf_sniper_m97_armor",
					"ssv_weap_inf_sniper_m97_disruptor",
					"ssv_weap_inf_sniper_m98",
					"ssv_weap_inf_sniper_m98b",
					"ssv_weap_inf_sniper_m98b_armor",
					"ssv_weap_inf_sniper_n7valiant",
					"ssv_weap_tread_mako_cannon",
					"ssv_weap_tread_mako_driver_cannon",
					"ssv_weap_tread_mako_gun" }
	
	-- COL unit classes.
	local colClasses = {
					"col_inf_assassin",
					"col_inf_drone",
					"col_inf_guardian",
					"col_inf_guardian_shield",
					"col_inf_guardian_online",
					"col_inf_guardian_online_shield",
					"col_inf_scion",
					
					"col_hero_harbinger" }
	
	-- GTH unit classes.
	local gthClasses = {
					"gth_inf_destroyer",
					"gth_inf_hunter",
					"gth_inf_juggernaut",
					"gth_inf_machinist",
					"gth_inf_rocketeer",
					"gth_inf_shock",
					"gth_inf_shock_online",
					"gth_inf_sniper",
					"gth_inf_trooper",
					"gth_inf_destroyer_shield",
					"gth_inf_hunter_shield",
					"gth_inf_juggernaut_shield",
					"gth_inf_machinist_shield",
					"gth_inf_rocketeer_shield",
					"gth_inf_shock_shield",
					"gth_inf_shock_online_shield",
					"gth_inf_sniper_shield",
					"gth_inf_trooper_shield",
					"gth_ev_inf_trooper",
					"gth_ev_inf_infiltrator",
					"gth_ev_inf_engineer",
					"gth_ev_inf_rocketeer",
					"gth_ev_inf_hunter",
					"gth_ev_inf_pyro",
					"gth_ev_inf_juggernaut",
					"gth_ev_inf_juggernaut_online",
					"gth_ev_inf_trooper_shield",
					"gth_ev_inf_infiltrator_shield",
					"gth_ev_inf_engineer_shield",
					"gth_ev_inf_rocketeer_shield",
					"gth_ev_inf_hunter_shield",
					"gth_ev_inf_pyro_shield",
					"gth_ev_inf_juggernaut_shield",
					"gth_ev_inf_juggernaut_online_shield",
					
					"gth_hero_prime_me2",
					"gth_hero_prime_me3" }
	
	-- INDOC unit classes.
	local indocClasses = {
					"indoc_inf_abomination",
					"indoc_inf_cannibal",
					"indoc_inf_husk",
					"indoc_inf_marauder" }
	
	-- SSV unit classes.
	local ssvClasses = {
					"ssv_inf_adept",
					"ssv_inf_engineer",
					"ssv_inf_infiltrator",
					"ssv_inf_infiltrator_campaign",
					"ssv_inf_sentinel",
					"ssv_inf_soldier",
					"ssv_inf_vanguard",
					"ssv_inf_adept_shield",
					"ssv_inf_engineer_shield",
					"ssv_inf_infiltrator_shield",
					"ssv_inf_infiltrator_shield_campaign",
					"ssv_inf_sentinel_shield",
					"ssv_inf_soldier_shield",
					"ssv_inf_vanguard_shield",
					
					"ssv_inf_cooper_adept",
					"ssv_inf_cooper_engineer",
					"ssv_inf_cooper_infiltrator",
					"ssv_inf_cooper_sentinel",
					"ssv_inf_cooper_soldier",
					"ssv_inf_cooper_vanguard",
					
					"ssv_hero_shepard_soldier",
					"ssv_hero_shepard_infiltrator",
					"ssv_hero_shepard_engineer",
					"ssv_hero_shepard_adept",
					"ssv_hero_shepard_sentinel",
					"ssv_hero_shepard_vanguard" }
	
	
	
	-- When the player spawns
	local playerspawn = OnCharacterSpawn(
		function(player)
			if IsCharacterHuman(player) then
				--print("ME5_MiscFunctions.fPlayerDamageSound(): Player spawned")
				Iamhuman = GetEntityPtr(GetCharacterUnit(player))
			end
		end
	)
	
	-- When the player loses health
	local playerdamage = OnObjectDamage(	-- TODO: FINISH COMPLETING THIS
		function(object, damager)
			
			-- Was the damaged object the player?
			if Iamhuman == GetEntityPtr(object) then
				-- The damager's pointer
				local charPtr = GetEntityPtr(GetCharacterUnit(damager))
				local charClass = GetEntityClass(charPtr)
				
				-- Only proceed if damager isn't correct class
				if bIsDamagerCorrectClass == false then
					
					-- For each COL class,
					for i=1, table.getn(colClasses) do
						-- Is the damager one of them?
						if charClass == FindEntityClass( colClasses[i] ) then
							bIsDamagerCorrectClass = true
							damagerFaction = "col"
						else
							bIsDamagerCorrectClass = false
						end
						
						-- Break out of the loop if correct class
						if bIsDamagerCorrectClass == true then break end
					end
				end
				
				-- Only proceed if damager isn't correct class
				if bIsDamagerCorrectClass == false then
					-- For each GTH class,
					for j=1, table.getn(gthClasses) do
						-- Is the damager one of them?
						if charClass == FindEntityClass( gthClasses[j] ) then
							bIsDamagerCorrectClass = true
							damagerFaction = "gth"
						else
							bIsDamagerCorrectClass = false
						end
						
						-- Break out of the loop if correct class
						if bIsDamagerCorrectClass == true then break end
					end
				end
				
				-- Only proceed if damager isn't correct class
				if bIsDamagerCorrectClass == false then
					-- For each INDOC class,
					for k=1, table.getn(indocClasses) do
						-- Is the damager one of them?
						if charClass == FindEntityClass( indocClasses[k] ) then
							bIsDamagerCorrectClass = true
							damagerFaction = "indoc"
						else
							bIsDamagerCorrectClass = false
						end
						
						-- Break out of the loop if correct class
						if bIsDamagerCorrectClass == true then break end
					end
				end
				
				-- Only proceed if damager isn't correct class
				if bIsDamagerCorrectClass == false then
					-- For each SSV class,
					for m=1, table.getn(ssvClasses) do
						-- Is the damager one of them?
						if charClass == FindEntityClass( ssvClasses[m] ) then
							bIsDamagerCorrectClass = true
							damagerFaction = "ssv"
						else
							bIsDamagerCorrectClass = false
						end
						
						-- Break out of the loop if correct class
						if bIsDamagerCorrectClass == true then break end
					end
				end
				
				
				
				-- Which team is the damager from?
				if damagerFaction == "col" then
					--print("ME5_MiscFunctions.fPlayerDamageSound(): Damager is from team COL")
					--ShowMessageText("level.common.debug.damager_col")
					
					-- For each weapon class
					for i=1, table.getn(ballisticWeapons_COL) do
						-- Was the weapon used a valid ballistic weapon?
						if GetObjectLastHitWeaponClass(object) == ballisticWeapons_COL[i] then
							local randSnd = math.random(0,10)
							ScriptCB_SndPlaySound("player_damage_layered_"..randSnd)
							
							break
						end
					end
					
				elseif damagerFaction == "gth" then
					--print("ME5_MiscFunctions.fPlayerDamageSound(): Damager is from team GTH")
					--ShowMessageText("level.common.debug.damager_gth")
					
					-- For each weapon class
					for i=1, table.getn(ballisticWeapons_GTH) do
						-- Was the weapon used a valid ballistic weapon?
						if GetObjectLastHitWeaponClass(object) == ballisticWeapons_GTH[i] then
							local randSnd = math.random(0,10)
							ScriptCB_SndPlaySound("player_damage_layered_"..randSnd)
							
							break
						end
					end
					
				elseif damagerFaction == "indoc" then
					--print("ME5_MiscFunctions.fPlayerDamageSound(): Damager is from team INDOC")
					--ShowMessageText("level.common.debug.damager_indoc")
					
					-- For each weapon class
					for i=1, table.getn(ballisticWeapons_INDOC) do
						-- Was the weapon used a valid ballistic weapon?
						if GetObjectLastHitWeaponClass(object) == ballisticWeapons_INDOC[i] then
							local randSnd = math.random(0,10)
							ScriptCB_SndPlaySound("player_damage_layered_"..randSnd)
							
							break
						end
					end
					
				elseif damagerFaction == "ssv" then
					--print("ME5_MiscFunctions.fPlayerDamageSound(): Damager is from team SSV")
					--ShowMessageText("level.common.debug.damager_ssv")
					
					-- For each weapon class
					for i=1, table.getn(ballisticWeapons_SSV) do
						-- Was the weapon used a valid ballistic weapon?
						if GetObjectLastHitWeaponClass(object) == ballisticWeapons_SSV[i] then
							local randSnd = math.random(0,10)
							ScriptCB_SndPlaySound("player_damage_layered_"..randSnd)
							
							break
						end
					end
					
				end
			end
		end
	)
end

---
-- Sets up the event responses for low health sounds.
-- 
function fLowHealthSound()	-- TODO: fix low health vignette
		print("ME5_MiscFunctions.fLowHealthSound(): Entered")
	if not ScriptCB_InMultiplayer() then
		if ME5_LowHealthSound == 0 then
				print("ME5_MiscFunctions.fLowHealthSound(): Initializing low health sound setting for DISABLED...")
		elseif ME5_LowHealthSound == 1 then
				print("ME5_MiscFunctions.fLowHealthSound(): Initializing low health sound setting for ENABLED...")
			
			--===============================
			-- Initialization logic
			--===============================
			--ScriptCB_SndPlaySound("organic_lowhealth_property")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl")
			
			lowHealthStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "lowhealth_streaming")
			--PlayAudioStreamUsingProperties("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "organic_lowhealth_streaming", 1)
			
			PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", 
								"organic_lowhealth_streaming", "heartbeat_segment", 1.0, "lowhealth", lowHealthStream)
			
			-- Initial lowhealth bus fade
			ScriptCB_SndBusFade("lowhealth", 0.0, 0.0)
			
			LH_bIsLowHealthSoundPlaying = false	-- Is the low health sound playing?
			LH_playerHealthThreshold = 0.35		-- Under what health percentage should the low health sound be active?
			local Iamhuman = nil				-- Pointer for human player.
			local bIsPlayerCorrectClass = false	-- Is the player the correct class?
			local bIsSpawnScreenActive = false	-- Is the spawn screen active?
			local timerCount	= 0				-- How many timers exist?
			local busEndGain	= 0.15			-- What is the end gain for the audio bus?
			local busFadeTime	= 1.0			-- What is the duration of the bus fade?
			local playerMaxHealth = 0			-- What is the player's health when they spawn?
			local synthClasses = {
					"gth_inf_destroyer",
					"gth_inf_hunter",
					"gth_inf_juggernaut",
					"gth_inf_machinist",
					"gth_inf_rocketeer",
					"gth_inf_shock",
					"gth_inf_shock_online",
					"gth_inf_sniper",
					"gth_inf_trooper",
					"gth_inf_destroyer_shield",
					"gth_inf_hunter_shield",
					"gth_inf_juggernaut_shield",
					"gth_inf_machinist_shield",
					"gth_inf_rocketeer_shield",
					"gth_inf_shock_shield",
					"gth_inf_shock_online_shield",
					"gth_inf_sniper_shield",
					"gth_inf_trooper_shield",
					"gth_ev_inf_trooper",
					"gth_ev_inf_infiltrator",
					"gth_ev_inf_engineer",
					"gth_ev_inf_rocketeer",
					"gth_ev_inf_hunter",
					"gth_ev_inf_pyro",
					"gth_ev_inf_juggernaut",
					"gth_ev_inf_juggernaut_online",
					"gth_ev_inf_trooper_shield",
					"gth_ev_inf_infiltrator_shield",
					"gth_ev_inf_engineer_shield",
					"gth_ev_inf_rocketeer_shield",
					"gth_ev_inf_hunter_shield",
					"gth_ev_inf_pyro_shield",
					"gth_ev_inf_juggernaut_shield",
					"gth_ev_inf_juggernaut_online_shield",
					"gth_hero_prime_me2",
					"gth_hero_prime_me3",
					"ssv_hero_shepard_soldier",	-- don't let hero units have the effect either
					"ssv_hero_shepard_infiltrator",
					"ssv_hero_shepard_engineer",
					"ssv_hero_shepard_adept",
					"ssv_hero_shepard_sentinel",
					"ssv_hero_shepard_vanguard",
					"col_hero_harbinger" }
			--local classCount = 0
			
			--local lowHealthSoundTimer = CreateTimer("lowHealthSoundTimer")

			-- Make the screen
			--[[AddIFScreen(ifs_lowhealth_vignette,"ifs_lowhealth_vignette")
			
			meu_lowhealth_scr_rspwn = CreateTimer("meu_lowhealth_scr_rspwn")
			SetTimerValue(meu_lowhealth_scr_rspwn, 1)
			meu_lowhealth_timer_elapse = OnTimerElapse(
				function(timer)
						print("fLowHealthSound: Timer 'meu_lowhealth_scr_rspwn' has elapsed")
						print("fLowHealthSound: Stopping timer...")
					StopTimer(meu_lowhealth_scr_rspwn)
					ifs_lowhealth_vignette.TimerType = false
					ScriptCB_PushScreen("ifs_lowhealth_vignette")
				end,
			meu_lowhealth_scr_rspwn
			)]]
			
			
			--===============================
			-- Event responses
			--===============================
			
			--[[local testcheckhumanchangeclass = OnCharacterChangeClass(
				function(player)
					if IsCharacterHuman(player) then
							print("fLowHealthSound: testcheckhumanchangeclass()")
						if isSpawnScreenActive == false then
							isSpawnScreenActive = true
						elseif isSpawnScreenActive == true then
							isSpawnScreenActive = false
						end
						
						if ifs_lowhealth_vignette.TimerMngr > 0 and isSpawnScreenActive == false then
								print("fLowHealthSound: Starting timer 'meu_lowhealth_scr_rspwn'")
							
							meu_lowhealth_scr_rspwn_..timerCount = CreateTimer("meu_lowhealth_scr_rspwn")
							SetTimerValue(meu_lowhealth_scr_rspwn_..timerCount, 0.5)
							StartTimer(meu_lowhealth_scr_rspwn_..timerCount)
							OnTimerElapse(
								function(timer)
										print("fLowHealthSound: Timer 'meu_lowhealth_scr_rspwn_"..timerCount.."' has elapsed")
										print("fLowHealthSound: Stopping timer...")
									StopTimer(meu_lowhealth_scr_rspwn_..timerCount)
									ifs_lowhealth_vignette.TimerType = false
									ScriptCB_PushScreen("ifs_lowhealth_vignette")
									DestroyTimer(meu_lowhealth_scr_rspwn_..timerCount)
								end,
							meu_lowhealth_scr_rspwn_..timerCount
							)
							
							SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
							StartTimer(meu_lowhealth_scr_rspwn)
						end
					end
				end
			)]]
			
			-- When the player spawns
			local playerspawn = OnCharacterSpawn(
				function(player)
					if IsCharacterHuman(player) then
							--print("fLowHealthSound: Player spawned")
						Iamhuman = GetEntityPtr(GetCharacterUnit(player))
						playerMaxHealth = GetObjectHealth(Iamhuman)
							--print("fLowHealthSound: Player's max health is "..playerMaxHealth)
						
						--if not ifs_lowhealth_vignette.TimerMngr == nil then
							--[[if gIsGreaterThan0 > 0 then
									print("fLowHealthSound: gIsGreaterThan0 is "..gIsGreaterThan0)
								SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
								StartTimer(meu_lowhealth_scr_rspwn)
							else
								print("fLowHealthSound: ELSE gIsGreaterThan0 is "..gIsGreaterThan0)
							end]]
						--end
						
						-- For each synthetic class,
						for i=1, table.getn(synthClasses) do
							-- Is the player a non-synthetic class?
							if GetEntityClass(Iamhuman) == FindEntityClass( synthClasses[i] ) then
								bIsPlayerCorrectClass = false
							else
								bIsPlayerCorrectClass = true
							end
							
							-- Break out of the loop if wrong class
							if bIsPlayerCorrectClass == false then break end
						end
						
						-- Is the low health sound playing?
						if LH_bIsLowHealthSoundPlaying == true then
								--print("ME5_MiscFunctions.fLowHealthSound(): isSoundPlaying is true, setting to false")
							LH_bIsLowHealthSoundPlaying = false
							
							-- Remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							-- Unfade all of the audio buses
							ScriptCB_SndBusFade("main",				busFadeTime, 1.0)
							ScriptCB_SndBusFade("soundfx",			busFadeTime, 0.7)
							ScriptCB_SndBusFade("battlechatter",	busFadeTime, 1.0)
							ScriptCB_SndBusFade("music",			busFadeTime, 1.0)
							ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.7)
							ScriptCB_SndBusFade("ambience",			busFadeTime, 0.7)
							ScriptCB_SndBusFade("voiceover",		busFadeTime, 0.8)
							ScriptCB_SndBusFade("lowhealth",		1.0, 0.0, 1.0)
						end
					end
				end
			)
			
			-- When the player is damaged
			local playerhealthchange = OnHealthChange(
				function(object, health)
					-- Was the damaged object a human player?
					if Iamhuman == GetEntityPtr(object) then
							--print("fLowHealthSound: Player health changed")
							--print("fLowHealthSound: Player health ratio is "..playerHealthPercent)
							
						-- What is the player's current health?
						local playerCurHealth = GetObjectHealth(object)
						
						if playerMaxHealth <= 0 then
							playerMaxHealth = 300
						end
						
						-- What's the player's current health percentage?
						local playerHealthPercent = playerCurHealth / playerMaxHealth
						
						-- Is the player's health low enough to activate the low health sound?
						if playerHealthPercent < LH_playerHealthThreshold then
								--print("fLowHealthSound: Player's health is "..playerCurHealth)
							if LH_bIsLowHealthSoundPlaying == false then
									--print("fLowHealthSound: isSoundPlaying is false, setting to true")
								LH_bIsLowHealthSoundPlaying = true
								--classCount = 0
								
								-- Is the player the correct class?
								if bIsPlayerCorrectClass == true then
										--print("fLowHealthSound: Player is correct class")
									
									-- Activate our ifs screen
									--ScriptCB_PushScreen("ifs_lowhealth_vignette")
									
									-- Fade all of the appropriate audio buses
									ScriptCB_SndBusFade("main",				busFadeTime, busEndGain)
									ScriptCB_SndBusFade("soundfx",			busFadeTime, busEndGain)
									ScriptCB_SndBusFade("battlechatter",	busFadeTime, busEndGain)
									ScriptCB_SndBusFade("music",			busFadeTime, 0.6)
									ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.6)
									ScriptCB_SndBusFade("ambience",			busFadeTime, busEndGain)
									ScriptCB_SndBusFade("voiceover",		busFadeTime, busEndGain)
									ScriptCB_SndBusFade("lowhealth",		1.0, 1.0, 0.0)
								else
									--print("fLowHealthSound: Player is wrong class")
								end
							end
						else
							-- Is the low health sound playing?
							if LH_bIsLowHealthSoundPlaying == true then
									--print("fLowHealthSound: isSoundPlaying is true, setting to false")
								
								-- If it's playing, deactivate it
								LH_bIsLowHealthSoundPlaying = false
								
								-- Remove our ifs screen
								--ifs_lowhealth_vignette.Timer = 10
								--ifs_lowhealth_vignette.TimerType = true
								
								-- Fade all of the appropriate audio buses
								ScriptCB_SndBusFade("main",				busFadeTime, 1.0)
								ScriptCB_SndBusFade("soundfx",			busFadeTime, 0.7)
								ScriptCB_SndBusFade("battlechatter",	busFadeTime, 1.0)
								ScriptCB_SndBusFade("music",			busFadeTime, 1.0)
								ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.7)
								ScriptCB_SndBusFade("ambience",			busFadeTime, 0.7)
								ScriptCB_SndBusFade("voiceover",		busFadeTime, 0.8)
								ScriptCB_SndBusFade("lowhealth",		1.0, 0.0, 1.0)
							end
						end
					end
				end
			)
			
			-- When the player dies
			local playerdeath = OnCharacterDeath(
				function(player, killer)
					if IsCharacterHuman(player) then
							--print("fLowHealthSound: Player died, resetting buses and variables")
						--if isSoundPlaying == true then
							
							-- Deactivate the low health sound
							LH_bIsLowHealthSoundPlaying = false
							
							-- remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							-- Fade all of the appropriate audio buses
							ScriptCB_SndBusFade("main",				busFadeTime, 1.0)
							ScriptCB_SndBusFade("soundfx",			busFadeTime, 0.7)
							ScriptCB_SndBusFade("battlechatter",	busFadeTime, 1.0)
							ScriptCB_SndBusFade("music",			busFadeTime, 1.0)
							ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.7)
							ScriptCB_SndBusFade("ambience",			busFadeTime, 0.7)
							ScriptCB_SndBusFade("voiceover",		busFadeTime, 0.8)
							ScriptCB_SndBusFade("lowhealth",		1.0, 0.0)
						--end
					end
				end
			)
		end
	else
		print("ME5_MiscFunctions.fLowHealthSound(): Initializing low health sound setting for DISABLED...")
	end
end

---
-- Sets up the event responses for the Evolved Juggernaut's Power Drain ability.
-- 
function fEvgJugPowerDrain()
	print("ME5_MiscFunctions.fEvgJugPowerDrain(): Entered")
	
	local enemydamage = OnObjectDamage(
		function(object, damager)
			--local dmgrPtr = GetEntityPtr(GetCharacterUnit(damager))
			--print(object)
			--print(damager)
			--print(dmgrPtr)
			--if IsCharacterHuman(dmgrPtr) then
				if GetObjectLastHitWeaponClass(object) == "weap_tech_powerdrain" then
					local charPtr = GetCharacterUnit(damager)
					
					-- make it so shields can be extracted only from enemies
					if GetObjectTeam(object) ~= GetObjectTeam(charPtr) then
						print("fEvgJugPowerDrain: Object team is CIS")
						
						-- Get the Juggernaut's current shields
						local curShields = GetObjectShield(charPtr)
						local addShields = 50	-- Amount of shields to add
						local maxShields = 1140	-- Juggernaut's MaxShield value in its ODF
						
						print("fEvgJugPowerDrain: Unit's current shields: "..curShields)
						
						-- Only regenerate if the current shields are less than the max shields
						if curShields < maxShields then
							-- Calculate the Juggernaut's final total shields value
							local newShields = curShields + addShields
							
							-- Apply the shields change
							SetProperty( charPtr, "CurShield", newShields )
							print("fEvgJugPowerDrain: Unit's new shields: "..newShields)
							
							-- Are the Juggernaut's current shields over the limit?
							if newShields > maxShields then
									print("fEvgJugPowerDrain: Unit's shields are over the MaxShield limit at "..newShields.."... Resetting to "..maxShields)
								SetProperty( charPtr, "CurShield", maxShields )	-- reset the Juggernaut's shields to its maximum value
							end
						end
					else
						print("fEvgJugPowerDrain: Object team is not CIS")
					end
				end
			--end
		end
	)
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