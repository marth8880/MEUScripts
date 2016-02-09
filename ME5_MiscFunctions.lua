-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by A. Gilbert
-- Version 30206/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 06, 2016
-- Copyright (c) 2016 A. Gilbert.

-- About this script: The purpose of script is to create a list of 
-- various functions that are loaded in a map's mission script.


-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_MiscFunctions: Entered")
-- Performs various pre-game operations, such as loading of commonly used data files,
-- Carnage mode setup, HUD work, and running event response functions for features such as
-- kill sounds, Evolved Juggernaut's Power Drain, and shield pickups.
function PreLoadStuff()
		print("ME5_MiscFunctions.PreLoadStuff(): Entered")
	-- Load our custom loadscreen elements such as LEDs, etc.
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\common.lvl")
	
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
		SetAIDifficulty(-2, 2)
		SetTeamAggressiveness(CIS,(0.95))
		SetTeamAggressiveness(REP,(0.95))
	end
	
	if not ScriptCB_InMultiplayer() then
		if ME5_CarnageMode == 0 then
				print("ME5_MiscFunctions.PreLoadStuff(): Carnage Mode is DISABLED - deactivating weapon modifiers...")
		elseif ME5_CarnageMode == 1 then
				print("ME5_MiscFunctions.PreLoadStuff(): Carnage Mode is ENABLED - activating weapon modifiers...")
			ActivateBonus(REP, "team_bonus_advanced_blasters")
			ActivateBonus(CIS, "team_bonus_advanced_blasters")
		else
				print("ME5_MiscFunctions.PreLoadStuff(): Error! ME5_CarnageMode setting is invalid! Defaulting Carnage Mode setting to DISABLED")
		end
	else
			print("ME5_MiscFunctions.PreLoadStuff(): Carnage Mode is ENABLED (MULTIPLAYER) - activating weapon modifiers...")
		ActivateBonus(REP, "team_bonus_advanced_blasters")
		ActivateBonus(CIS, "team_bonus_advanced_blasters")
	end
	
	-- Load the appropriate CP icons based on faction variations
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
	if aspectRatio <= 1.4 then
			print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 4:3; loading scopes as such")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar43\\ar.lvl")
	elseif aspectRatio <= 1.63 and aspectRatio >= 1.5 then
			print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 16:10; loading scopes as such")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar1610\\ar.lvl")
	elseif aspectRatio <= 1.9 and aspectRatio >= 1.63 then
			print("ME5_MiscFunctions.PreLoadStuff(): Aspect Ratio is 16:9; loading scopes as such")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar169\\ar.lvl")
	else
			print("ME5_MiscFunctions.PreLoadStuff(): Error! Invalid aspect ratio ("..aspectRatio..")! Defaulting to workaround")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ar\\ar.lvl")
	end
	
	if ME5_CustomHUD == 1 then
			print("ME5_MiscFunctions.PreLoadStuff(): Loading custom HUD")
		
		-- Load the Myriad Pro fonts
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font.lvl")
		
		-- Load the Korataki fonts
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
		else
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud.lvl")
		end
		
		-- load weapons.lvl for the MEU HUD
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\weapons.lvl;hud_meu")
		
		-- hotfix that overrides the stock fonts with a "blank font"
		--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_text.lvl")
	else
    	-- load the stock ingame.lvl
    	ReadDataFile("ingame.lvl")
    	
		-- load weapons.lvl for the stock HUD
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\weapons.lvl;hud_stock")
		
		-- load the new onscreen pointer textures
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamehud.lvl")
	end

	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\ME5.lvl")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_Streaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_Common_NonStreaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_WPN_NonStreaming.lvl")
	
	fShieldPickup()
	fKillSound()
	--fLowHealthSound()
	fEvgJugPowerDrain()
end

-- Sets up event responses for shield pickups.
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
		
			OnFlagPickUp(
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
		else end
		
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
				else end
			end
		)]]
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

-- Runs the Juggernaut Squad functions (based on the faction combination) 
-- and low health functions. Also purges stock fonts if custom HUD is enabled.
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
		else end
	else
		if onlineSideVar == 1 then
			fGthJugSquad()
		elseif onlineSideVar == 3 then
			fEvgJugSquad()
		else end
	end
	
	fLowHealthSound()
	meu_lowhealth_postCall()
	
	if ME5_CustomHUD == 1 then
			print("ME5_MiscFunctions.PostLoadStuff(): Overwriting stock fonts with blank font")
		-- hotfix that overrides the stock fonts with a "blank font"
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_purge_text.lvl")
	else end
end

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

-- Sets up the event responses for kill sounds.
function fKillSound()
		print("ME5_MiscFunctions.fKillSound(): Entered")
	if not ScriptCB_InMultiplayer() then
		if ME5_KillSound == 0 then
				print("ME5_MiscFunctions.fKillSound(): Initializing kill sound setting for DISABLED...")
		elseif ME5_KillSound == 1 or ME5_KillSound == 2 then
				print("ME5_MiscFunctions.fKillSound(): Initializing kill sound setting for ENABLED...")
			local killsound = OnCharacterDeath(
				function(player,killer)
					--if not IsObjectAlive(player) then
						if killer and IsCharacterHuman(killer) then
								--print("fKillSound: Killer is human, enemy kill successful")
							ScriptCB_SndPlaySound("hud_player_kill")
						else
							--print("fKillSound: Killer is not human")
						end
					--else
						--print("fKillSound: Enemy is alive")
					--end
				end
			)
		else
				print("ME5_MiscFunctions.fKillSound(): Error! ME5_KillSound setting is invalid! Defaulting to kill sound setting for ENABLED")
			local killsound = OnCharacterDeath(
				function(player,killer)
					--if not IsObjectAlive(player) then
						if IsCharacterHuman(killer) then
								--print("fKillSound: Killer is human, enemy kill successful")
							ScriptCB_SndPlaySound("hud_player_kill")
						else
							--print("fKillSound: Killer is not human")
						end
					--else
						--print("fKillSound: Enemy is alive")
					--end
				end
			)
		end
	else
			print("ME5_MiscFunctions.fKillSound(): Initializing kill sound setting for DISABLED...")
	end
end

-- Sets up the event responses for low health sounds.
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
			ScriptCB_SndBusFade("lowhealth", 0.0, 0.0)
			
			local isSoundPlaying = false
			local isPlayerCorrectClass = false
			local isSpawnScreenActive = false
			local timerCount	= 0
			local busEndGain	= 0.15
			local busFadeTime	= 1.0
			local playerHealthThreshold = 0.35
			local playerMaxHealth = 0
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
			
			OnCharacterSpawn(
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
						
						for i=1, table.getn(synthClasses) do
							-- check if the player is an organic class
							if GetEntityClass(Iamhuman) == FindEntityClass( synthClasses[i] ) then
								isPlayerCorrectClass = false
							else
								isPlayerCorrectClass = true
							end
							
							if isPlayerCorrectClass == false then break end
						end
						
						-- silence the heartbeat if it's playing
						if isSoundPlaying == true then
								--print("fLowHealthSound: isSoundPlaying is true, setting to false")
							isSoundPlaying = false
							
							-- remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true

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
			
			local lowhealthsound = OnHealthChange(
				function(object, health)
					local playerCurHealth = GetObjectHealth(object)
					if playerMaxHealth <= 0 then
						playerMaxHealth = 300
					end
					local playerHealthPercent = playerCurHealth / playerMaxHealth
					if Iamhuman == GetEntityPtr(object) then
							--print("fLowHealthSound: Player health changed")
							--print("fLowHealthSound: Player health ratio is "..playerHealthPercent)
						if playerHealthPercent < playerHealthThreshold then
								--print("fLowHealthSound: Player's health is "..playerCurHealth)
							if isSoundPlaying == false then
									--print("fLowHealthSound: isSoundPlaying is false, setting to true")
								isSoundPlaying = true
								--classCount = 0
								
								if isPlayerCorrectClass == true then
										--print("fLowHealthSound: Player is correct class")
									-- activate our ifs screen
									--ScriptCB_PushScreen("ifs_lowhealth_vignette")

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
							if isSoundPlaying == true then
									--print("fLowHealthSound: isSoundPlaying is true, setting to false")
								isSoundPlaying = false
								
								-- remove our ifs screen
								--ifs_lowhealth_vignette.Timer = 10
								--ifs_lowhealth_vignette.TimerType = true

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
			
			local lowhealthplayerdeath = OnCharacterDeath(
				function(player,killer)
					if IsCharacterHuman(player) then
							--print("fLowHealthSound: Player died, resetting buses and variables")
						--if isSoundPlaying == true then
							isSoundPlaying = false
							
							-- remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							ScriptCB_SndBusFade("main",				busFadeTime, 1.0)
							ScriptCB_SndBusFade("soundfx",			busFadeTime, 0.7)
							ScriptCB_SndBusFade("battlechatter",	busFadeTime, 1.0)
							ScriptCB_SndBusFade("music",			busFadeTime, 1.0)
							ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.7)
							ScriptCB_SndBusFade("ambience",			busFadeTime, 0.7)
							ScriptCB_SndBusFade("voiceover",		busFadeTime, 0.8)
							ScriptCB_SndBusFade("lowhealth",		1.0, 0.0)
						--end
					else end
				end
			)
		else
		end
	else
			print("ME5_MiscFunctions.fLowHealthSound(): Initializing low health sound setting for DISABLED...")
	end
end

-- Sets up the event responses for the Evolved Juggernaut's Power Drain ability.
function fEvgJugPowerDrain()
		print("ME5_MiscFunctions.fEvgJugPowerDrain(): Entered")
	OnObjectDamage(
		function( object, damager )
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
						local curShields = GetObjectShield(charPtr)	-- get the Juggernaut's current shields
						local addShields = 50	-- amount of shields to add
						local maxShields = 1140	-- Juggernaut's MaxShield value in its ODF
							print("fEvgJugPowerDrain: Unit's current shields: "..curShields)
						
						-- only regenerate if the current shields are less than the max shields
						if curShields < maxShields then
							local newShields = curShields + addShields	-- find out the Juggernaut's final total shields value
							
							SetProperty( charPtr, "CurShield", newShields )	-- apply the shields change
								print("fEvgJugPowerDrain: Unit's new shields: "..newShields)
							
							-- error-handling: if the Juggernaut's current shields are over the limit
							if newShields > maxShields then
									print("fEvgJugPowerDrain: Unit's shields are over the MaxShield limit at "..newShields.."... Resetting to "..maxShields)
								SetProperty( charPtr, "CurShield", maxShields )	-- reset the Juggernaut's shields to its maximum value
							else end
						else end
					else
						print("fEvgJugPowerDrain: Object team is not CIS")
					end
				else end
			--else end
		end
	)
end

---
-- Interaction logic function.
-- This function contains all of the event responses and logic pertaining to the player's Interact weapon in campaigns.
-- @param #object object The object hit by the player's Interact weapon.
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