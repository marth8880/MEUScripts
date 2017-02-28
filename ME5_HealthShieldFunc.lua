-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Health/Shield Functionality Script by Aaron Gilbert
-- Build 40227/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 27, 2017
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This script contains various functions regarding health and shield pickup functionality.
-- 
-- 
-- Usage: 
--  Simply call Init_HealthFunc() or Init_ShieldFunc() anywhere in ScriptInit().
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_HealthShieldFunc: Entered")

---
-- Sets up event responses for health functionality.
-- 
function Init_HealthFunc()
	print("ME5_HealthShieldFunc.Init_HealthFunc(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_HealthFunc == 1 then
			print("ME5_HealthShieldFunc.Init_HealthFunc(): Configuring Health Functionality for AUTO-REGEN...")
			SetClassProperty("com_inf_default", "AddHealth", 4.0)
			
		elseif ME5_HealthFunc == 2 then
			print("ME5_HealthShieldFunc.Init_HealthFunc(): Configuring Health Functionality for PICKUPS...")
			SetClassProperty("com_inf_default", "NextDropItem", "-")
			SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_health")
			SetClassProperty("com_inf_default", "DropItemProbability", 0.2)
			
			SetClassProperty("com_hero_default", "NextDropItem", "-")
			SetClassProperty("com_hero_default", "DropItemClass", "com_item_powerup_health")
			SetClassProperty("com_hero_default", "DropItemProbability", 0.2)
			
		else
			print("ME5_HealthShieldFunc.Init_HealthFunc(): Error! ME5_HealthFunc setting is invalid! Defaulting to Health Functionality for AUTO-REGEN")
			SetClassProperty("com_inf_default", "AddHealth", 4.0)
		end
	else
		print("ME5_HealthShieldFunc.Init_HealthFunc(): Configuring Health Functionality for PICKUPS...")
		SetClassProperty("com_inf_default", "NextDropItem", "-")
		SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_health")
		SetClassProperty("com_inf_default", "DropItemProbability", 0.2)
		
		SetClassProperty("com_hero_default", "NextDropItem", "-")
		SetClassProperty("com_hero_default", "DropItemClass", "com_item_powerup_health")
		SetClassProperty("com_hero_default", "DropItemProbability", 0.2)
	end
end


---
-- Sets up event responses for shield functionality.
-- 
function Init_ShieldFunc()
	print("ME5_HealthShieldFunc.Init_ShieldFunc(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
			print("ME5_HealthShieldFunc.Init_ShieldFunc(): Configuring Shield Functionality for AUTO-REGEN...")
			--[[SetClassProperty("ssv_inf_default", "AddShield", 9.0)
			SetClassProperty("ssv_inf_default_sentinel", "AddShield", 18.0)
			
			SetClassProperty("gth_inf_default", "AddShield", 11.0)
			SetClassProperty("gth_inf_default_trooper", "AddShield", 15.0)
			
			SetClassProperty("col_inf_default", "AddShield", 12.0)]]
			
			--SetClassProperty("com_inf_default", "AddShield", 14.0)
			
		elseif ME5_ShieldFunc == 2 then
			print("ME5_HealthShieldFunc.Init_ShieldFunc(): Configuring Shield Functionality for PICKUPS...")
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
					print("ME5_HealthShieldFunc.Init_ShieldFunc(): Unit picked up flag")
					-- Exit immediately if there are incorrect values
					if not flag then return end
					if not character then return end
					
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
					end
				end
			)
		end
	else
		print("ME5_HealthShieldFunc.Init_ShieldFunc(): Configuring Shield Functionality for AUTO-REGEN...")
		--[[SetClassProperty("ssv_inf_default", "AddShield", 9.0)
		SetClassProperty("ssv_inf_default_sentinel", "AddShield", 18.0)
		
		SetClassProperty("gth_inf_default", "AddShield", 11.0)
		SetClassProperty("gth_inf_default_trooper", "AddShield", 15.0)
		
		SetClassProperty("col_inf_default", "AddShield", 12.0)]]
		
		--SetClassProperty("com_inf_default", "AddShield", 14.0)
	end
end


---
-- Sets up the event responses and logic for deferred shield regeneration.
-- 
function Init_DeferredShieldRegen()
	print("ME5_HealthShieldFunc.Init_DeferredShieldRegen(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldRegen == 0 then
			print("ME5_HealthShieldFunc.Init_DeferredShieldRegen(): Configuring Shield Regeneration for AUTOMATIC...")
		elseif ME5_ShieldRegen == 1 then
			print("ME5_HealthShieldFunc.Init_DeferredShieldRegen(): Configuring Shield Regeneration for DEFERRED...")
			
			--=================================
			-- Data Fields
			--=================================
			
			-- Shield regeneration parameters
			local shieldRegenValueMult = 4.25				-- What is the player's base AddShield value multiplied by?
			local shieldRegenSound = "none"					-- The sound property that plays when the player's shields start regenerating. Use "none" if no sound is desired.
			local shieldRegenPfx = "com_sfx_shieldregen"	-- Name of the particle effect to spawn on the player when their shields start regenerating. Use "none" if no particle effect is desired.
			
			-- Table of unit classes with regenerating shields. /class/ is the class's name, /addShield/ is the class's AddShield value, /regenDelay/ is the class's 
			--  shield regeneration delay. (this would be so much easier if Battlefront had a GetProperty() function :u)
			local shieldClasses = {
						{ class = "col_inf_guardian_shield", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "col_inf_guardian_online_shield", 		addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "gth_inf_trooper_shield", 				addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_rocketeer_shield", 				addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_sniper_shield", 					addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_machinist_shield", 				addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_hunter_shield", 					addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_shock_shield", 					addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_shock_online_shield", 			addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_inf_destroyer_shield", 				addShield = 14.0,	regenDelay = 3.2 }, 
						{ class = "gth_inf_juggernaut_shield", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "gth_inf_prime_shield", 					addShield = 22.0,	regenDelay = 3.4 }, 
						{ class = "gth_ev_inf_trooper_shield", 				addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_ev_inf_infiltrator_shield", 			addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_ev_inf_engineer_shield", 			addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_ev_inf_rocketeer_shield", 			addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_ev_inf_hunter_shield", 				addShield = 14.0,	regenDelay = 3.0 }, 
						{ class = "gth_ev_inf_pyro_shield", 				addShield = 14.0,	regenDelay = 3.2 }, 
						{ class = "gth_ev_inf_juggernaut_shield", 			addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "gth_ev_inf_juggernaut_online_shield",	addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_soldier_shield", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_infiltrator_shield", 			addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_engineer_shield", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_adept_shield", 					addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_sentinel_shield", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_vanguard_shield", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_cooper_soldier", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_cooper_infiltrator", 			addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_cooper_engineer", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_cooper_adept", 					addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_cooper_sentinel", 				addShield = 14.0,	regenDelay = 3.4 }, 
						{ class = "ssv_inf_cooper_vanguard", 				addShield = 14.0,	regenDelay = 3.4 }, }
			
			
			-- Shield break parameters
			local shieldRebreakDelayValue = 2.5					-- How many seconds must pass before shields can be re-broken? (this is so the player isn't constantly hearing the sounds)
			local shieldBreakSound = "unit_shields_break"		-- The sound property that plays when the player's shields are completely depleted. Use "none" if no sound is desired.
			local shieldBreakPfx = "none"						-- Name of the particle effect to spawn on the player when their shields break. Use "none" if no particle effect is desired.
			local shieldBreakCamShakeObj = "com_item_camshake"	-- The class name of the EntityMine object. Use "none" if camera shaking is not desired. If a valid name is 
																--  specified, the object's explosion shake properties will be utilized to simulate camera shaking when the 
																--  player's shields break.
			local bShieldBreakDucksBuses = true					-- Should the audio buses be briefly ducked when the player's shields are broken?
			local busDuckDuration = 1.0							-- How long in seconds should the audio buses be faded for when the player's shields are broken?
			local busDuckEndGain = 0.35							-- What is the end gain for the audio buses when they're ducked?
			local busDuckFadeDuration = 0.2						-- What is the duration in seconds of the bus duck fade?
			local busUnDuckFadeDuration = 0.7					-- What is the duration in seconds of the bus unduck fade?
			
			
			-- Miscellaneous parameters
			local bDebugMessagesEnabled = false		-- Should debug messages be enabled?
			local bDebugShowRegenTimer = false		-- Should the shieldRegenTimer be shown?
			local bDebugShowRebreakTimer = false	-- Should the shieldRebreakTimer be shown?
			
			
			-- Fields that are handled internally (don't change these or your computer will explode)
			local charUnit = nil				-- The player's character unit.
			local charPtr = nil					-- The player's unit entity pointer.
			local charClass = nil				-- The name of the player's class.
			local regenBaseValue = nil			-- What is the player's base AddShield value?
			local regenFinalValue = nil			-- What is the player's final AddShield value?
			local regenDelayValue = 3.0			-- How long in seconds does it take for shields to start regenerating?
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
			-- Timer that starts regeneration upon elapse.
			local shieldRegenTimer = FindTimer("fShieldRegenDelay_regenTimer")
			if not shieldRegenTimer then
				shieldRegenTimer = CreateTimer("fShieldRegenDelay_regenTimer")
				SetTimerValue(shieldRegenTimer, regenDelayValue)
				
				if bDebugShowRegenTimer == true then
					ShowTimer(shieldRegenTimer)
				end
			end
			
			
			-- Get or create a new shieldRebreakTimer (this ensures there's only one "fShieldRegenDelay_rebreakTimer" in the game at one time)
			-- Timer that allows shields to be re-broken upon elapse.
			local shieldRebreakTimer = FindTimer("fShieldRegenDelay_rebreakTimer")
			if not shieldRebreakTimer then
				shieldRebreakTimer = CreateTimer("fShieldRegenDelay_rebreakTimer")
				SetTimerValue(shieldRebreakTimer, shieldRebreakDelayValue)
				
				if bDebugShowRebreakTimer == true then
					ShowTimer(shieldRebreakTimer)
				end
			end
			
			
			--=================================
			-- Local Functions
			--=================================
			
			---
			-- Call this to attach a particle effect to a unit.
			-- @param #string effect	The name of the particle effect to attach.
			-- @param #object unit		The character unit to attach the particle effect to.
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
			-- Call this to shake the camera utilizing the explosion properties from an EntityMine `object`.
			-- @param #string object	The class name of the EntityMine object whose explosion properties we're utilizing.
			-- 
			local function ShakeCamera(object)
				-- Increment the object count
				camShakeObjCount = camShakeObjCount + 1
				
				-- Spawn the EntityMine object at the player's location
				CreateEntity(object, GetEntityMatrix(charUnit), "camshake_item_"..camShakeObjCount)
			end
			
			
			---
			-- Call this to start shield regeneration for `unit`.
			-- @param #object unit		The object to start the regeneration for.
			-- 
			local function StartRegeneration(unit)
				-- Prevent the function from being executed multiple times at once (because Battlefront's a timer whore)
				if bIsRegenStopped == false then return end
				
				-- Exit immediately if `unit` isn't specified
				if not unit then return end
				
				bIsRegenStopped = false
				
				-- Restart the shield break timer
				SetTimerValue(shieldRebreakTimer, shieldRebreakDelayValue)
				StartTimer(shieldRebreakTimer)
				
				
				if bDebugMessagesEnabled == true then
					print("ME5_HealthShieldFunc.Init_DeferredShieldRegen.StartRegeneration(): Starting shield regeneration")
					ShowMessageText("level.common.debug.shields_starting", ATT)
					ShowMessageText("level.common.debug.shields_starting", DEF)
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
			-- Call this to stop shield regeneration for `unit`.
			-- @param #object unit		The object to stop the regeneration for.
			-- 
			local function StopRegeneration(unit)
				-- Exit immediately if `unit` isn't specified
				if not unit then return end
				
				-- Reset the regen timer value
				SetTimerValue(shieldRegenTimer, regenDelayValue)
				
				-- Prevent the function from being executed multiple times at once (no seriously Battlefront, you have a problem)
				if bIsRegenStopped == true then return end
				
				bIsRegenStopped = true
				
				
				if bDebugMessagesEnabled == true then
					print("ME5_HealthShieldFunc.Init_DeferredShieldRegen.StopRegeneration(): Stopping shield regeneration")
					ShowMessageText("level.common.debug.shields_stopping", ATT)
					ShowMessageText("level.common.debug.shields_stopping", DEF)
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
			-- @return #bool			True if the buses are supposed to be ducked, false if not.
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
			-- @return #bool			True if the buses are supposed to be ducked, false if not.
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
			-- Call this to break the shields of `unit`.
			-- @param #object unit		The character unit whose shields we're breaking.
			-- 
			local function BreakShields(unit)
				print("ME5_HealthShieldFunc.Init_DeferredShieldRegen.BreakShields(): Entered")
				
				-- Exit immediately if `unit` isn't specified
				if not unit then return end
				
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
						if bDebugMessagesEnabled == true then
							print("ME5_HealthShieldFunc.Init_DeferredShieldRegen.playershieldschange(): playerHealthPercent, LH_playerHealthThreshold:", playerHealthPercent, LH_playerHealthThreshold)
							print("ME5_HealthShieldFunc.Init_DeferredShieldRegen.playershieldschange(): Low health sound activating, skipping bus ducking")
						end
					end
				else
					print("Shields can't be broken yet")
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
			    	-- Exit immediately if there are incorrect values
			    	if not character then return end
			    	
			    	-- Is the character human? (i.e. the player)
			        if character == 0 then
			        	charUnit = GetCharacterUnit(character)		-- Get the character's unit ID
			        	charPtr = GetEntityPtr(charUnit)			-- Get the character's pointer
			        	charClass = GetEntityClass(charPtr)			-- Get the character's class
						playerMaxHealth = GetObjectHealth(charPtr)	-- Get the character's max health
						
						--print("ME5_HealthShieldFunc.Init_DeferredShieldRegen.playerspawn(): playerMaxHealth:", playerMaxHealth)	-- Uncomment me for test output!
			        	
						-- Check if the player's class is one of the shield classes
						for i in pairs(shieldClasses) do
							-- Is the player a shield class?
							if charClass == FindEntityClass(shieldClasses[i]['class']) then
								bIsPlayerCorrectClass = true
								bShieldsCanBeBroken = true
								
								-- Turn off regeneration
								if bIsRegenStopped == true then
									SetProperty(charUnit, "AddShield", 0)
								end
								
								-- Calculate the player's AddShield value
								regenBaseValue = shieldClasses[i]['addShield']
								regenFinalValue = regenBaseValue * shieldRegenValueMult
								
								-- Get and set the player's regen delay value
								regenDelayValue = shieldClasses[i]['regenDelay']
								SetTimerValue(shieldRegenTimer, regenDelayValue)
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
					-- Exit immediately if there are incorrect values
					if not object then return end
				
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
					-- Exit immediately if there are incorrect values
					if not object then return end
					
					-- Is the player the affected object?
					if charUnit == GetEntityPtr(object) and bIsPlayerCorrectClass == true then
						
						-- Are the player's shields completely depleted?
						if shields <= 0 then
							
							-- Is the player still alive? (no, not you Eddie)
							if GetObjectHealth(object) > 0 then
								-- Break the player's shields
								BreakShields(object)
							end
						else
							--print("Shields aren't depleted")
						end
					else
						--print("Player is not the affected object")
						if bIsPlayerCorrectClass == false then
							--print("and the player is not the correct class")
						else
							--print("but the player is the correct class")
						end
					end
				end
			)
			
			-- When the player dies
			local playerdeath = OnObjectKill(
				function(player, killer)
					-- Exit immediately if there are incorrect values
					if not player then return end
				
					-- Is the player the affected object?
					if charUnit == GetEntityPtr(player) then
					
						StopTimer(shieldRegenTimer)
						
						-- Reset the timer's value
						SetTimerValue(shieldRegenTimer, regenDelayValue)
						bIsRegenStopped = false
					end
				end
			)
		end
	else
		print("ME5_HealthShieldFunc.Init_DeferredShieldRegen(): Configuring Shield Regeneration for AUTOMATIC...")
	end
	
	print("ME5_HealthShieldFunc.Init_DeferredShieldRegen(): Exited")
end


print("ME5_HealthShieldFunc: Exited")