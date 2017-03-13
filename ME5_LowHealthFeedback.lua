-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Low Health Feedback Script by Aaron Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This script contains various functions regarding low health feedback.
-- 
-- 
-- Usage: 
--  Simply call Init_LowHealthFeedback() anywhere in ScriptPostLoad().
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_LowHealthFeedback: Entered")

---
-- Sets up the event responses for low health feedback.
-- 
function Init_LowHealthFeedback()	-- TODO: fix low health vignette
	print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): Entered")
	if not ScriptCB_InMultiplayer() then
		if ME5_LowHealthSound == 0 then
			print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): Initializing low health sound setting for DISABLED...")
		elseif ME5_LowHealthSound == 1 then
			print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): Initializing low health sound setting for ENABLED...")
			
			--===============================
			-- Initialization logic
			--===============================
			--ScriptCB_SndPlaySound("organic_lowhealth_property")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl")
			
			--lowHealthStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "lowhealth_streaming")
			--PlayAudioStreamUsingProperties("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "organic_lowhealth_streaming", 1)
			
			-- Initial lowhealth bus fade
			ScriptCB_SndBusFade("lowhealth", 0.0, 0.0)
			
			-- Play heartbeat sound stream
			--[[PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", 
								"organic_lowhealth_streaming", "heartbeat_segment", 1.0, "lowhealth", lowHealthStream)]]
			
			LH_bIsLowHealthSoundPlaying = false	-- Is the low health sound playing?
			LH_playerHealthThreshold = 0.35		-- Under what health percentage should the low health sound be active?
			local Iamhuman = nil				-- Pointer for human player
			local bIsFreshSpawn = true			-- Is this a fresh spawn? (if the player simply changed their class at a CP, it is not)
			local bIsPlayerCorrectClass = false	-- Is the player the correct class?
			local bIsPlayerSynthClass = false	-- Is the player a synthetic class?
			local bIsSpawnScreenActive = false	-- Is the spawn screen active?
			local lowhealthStreamIndex = nil	-- Index of low health sound stream
			local timerCount	= 0				-- Number of timers that exist
			local busEndGain	= 0.15			-- End gain for audio bus
			local busFadeTime	= 1.0			-- Duration of bus fade in seconds
			local playerCurHealth = 0			-- Player's current health value
			local playerMaxHealth = 0			-- Player's maximum health value
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
					"gth_ev_inf_juggernaut_online_shield" }
			local ignoreClasses = {
					"gth_hero_prime_me2",
					"gth_hero_prime_me3",
					"ssv_hero_jack",					-- don't let hero units have the effect either
					"ssv_hero_shepard_soldier",
					"ssv_hero_shepard_infiltrator",
					"ssv_hero_shepard_engineer",
					"ssv_hero_shepard_adept",
					"ssv_hero_shepard_sentinel",
					"ssv_hero_shepard_vanguard",
					"col_hero_harbinger" }
			
			local stopLowHealthSound_Timer = CreateTimer("stopLowHealthSound_Timer")
			SetTimerValue(stopLowHealthSound_Timer, busFadeTime*2)
			ShowTimer(stopLowHealthSound_Timer)
			
			local lowHealthChangeGate_Timer = CreateTimer("lowHealthChangeGate_Timer")
			SetTimerValue(lowHealthChangeGate_Timer, 0.5)
			--ShowTimer(lowHealthChangeGate_Timer)
			
			--local classCount = 0
			
			--local lowHealthSoundTimer = CreateTimer("lowHealthSoundTimer")

			-- Make the screen
			--[[AddIFScreen(ifs_lowhealth_vignette,"ifs_lowhealth_vignette")
			
			meu_lowhealth_scr_rspwn = CreateTimer("meu_lowhealth_scr_rspwn")
			SetTimerValue(meu_lowhealth_scr_rspwn, 1)
			meu_lowhealth_timer_elapse = OnTimerElapse(
				function(timer)
					print("Init_LowHealthFeedback: Timer 'meu_lowhealth_scr_rspwn' has elapsed")
					print("Init_LowHealthFeedback: Stopping timer...")
					
					StopTimer(meu_lowhealth_scr_rspwn)
					ifs_lowhealth_vignette.TimerType = false
					ScriptCB_PushScreen("ifs_lowhealth_vignette")
				end,
			meu_lowhealth_scr_rspwn
			)]]
			
			
			--===============================
			-- Local Functions
			--===============================
			
			---
			-- Call this to start playing the low health sound stream.
			-- @param #string type		Type of being whose low health sound stream we're playing ("organic" or "synthetic")
			-- 
			local function StartLowHealthSound(type)
				--print()
				print("Init_LowHealthFeedback.StartLowHealthSound(): Entered")
				
				-- Exit if the sound's already playing
				if LH_bIsLowHealthSoundPlaying == true then
					print("Init_LowHealthFeedback.StopLowHealthSound(): ERROR! Low health sound is already playing! Exiting")
					return false
				end
				
				-- Type must be specified
				if not type then return end
				
				local streamID = nil
				local segmentID = nil
				local gain = 1.0
				
				-- Which type of being is the player's character?
				if type == "organic" then
					streamID = "organic_lowhealth_streaming"
					segmentID = "heartbeat_segment"
					gain = 1.0
					
				elseif type == "synthetic" then
					streamID = "synthetic_lowhealth_streaming"
					segmentID = "synthetic_segment"
					gain = 0.6
				end
				
				if streamID == nil then return end
				if segmentID == nil then return end
				
				--ShowMessageText("level.common.debug.lowhealth_starting")	-- DEBUG
				
				-- If we've made it this far, flag the low health sound as playing
				LH_bIsLowHealthSoundPlaying = true
				
				-- Make room for the low health stream
				CloseVoiceStreams(true)
				
				--print("Init_LowHealthFeedback.StartLowHealthSound(): Starting low health sounds")
				
				-- Play low health sound stream
				lowHealthStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "lowhealth_streaming")
				print("Init_LowHealthFeedback.StartLowHealthSound(): lowHealthStream index:", lowHealthStream)
				
				lowhealthStreamIndex = PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", 
														streamID, segmentID, gain, "lowhealth", lowHealthStream)
				print("Init_LowHealthFeedback.StartLowHealthSound(): lowhealthStreamIndex index:", lowHealthStream)
				
				-- Fade all of the appropriate audio buses
				ScriptCB_SndBusFade("main",				busFadeTime, busEndGain)
				ScriptCB_SndBusFade("soundfx",			busFadeTime, busEndGain)
				ScriptCB_SndBusFade("battlechatter",	busFadeTime, busEndGain)
				ScriptCB_SndBusFade("music",			busFadeTime, 0.6)
				ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.6)
				ScriptCB_SndBusFade("ambience",			busFadeTime, busEndGain)
				ScriptCB_SndBusFade("voiceover",		busFadeTime, busEndGain)
				ScriptCB_SndBusFade("lowhealth",		1.0, 1.0, 0.0)
			end
			
			---
			-- Call this to stop playing the low health sound stream.
			-- 
			local function StopLowHealthSound()
				--print()
				print("Init_LowHealthFeedback.StopLowHealthSound(): Entered")
				
				-- Exit if the sound's not already playing
				if LH_bIsLowHealthSoundPlaying == false then
					print("Init_LowHealthFeedback.StopLowHealthSound(): ERROR! Low health sound isn't playing! Exiting")
					return false
				end
				
				--LH_bIsLowHealthSoundPlaying = false
				
				--ShowMessageText("level.common.debug.lowhealth_stopping")	-- DEBUG
				
				-- Unfade all of the audio buses
				ScriptCB_SndBusFade("main",				busFadeTime, 1.0)
				ScriptCB_SndBusFade("soundfx",			busFadeTime, 0.7)
				ScriptCB_SndBusFade("battlechatter",	busFadeTime, 1.0)
				ScriptCB_SndBusFade("music",			busFadeTime, 1.0)
				ScriptCB_SndBusFade("ingamemusic",		busFadeTime, 0.7)
				ScriptCB_SndBusFade("ambience",			busFadeTime, 0.7)
				ScriptCB_SndBusFade("voiceover",		busFadeTime, 0.8)
				ScriptCB_SndBusFade("lowhealth",		1.0, 0.0, 1.0)
				
				-- Stop and close the low health stream after the audio buses have finished fading
				SetTimerValue(stopLowHealthSound_Timer, busFadeTime*2)
				StartTimer(stopLowHealthSound_Timer)
			end
			
			
			--===============================
			-- Event Responses
			--===============================
			
			local stopLowHealthSound_TimerElapse = OnTimerElapse(
				function(timer)
					print("Init_LowHealthFeedback.stopLowHealthSound_TimerElapse(): Entered")
					
					--ShowMessageText("level.common.debug.lowhealth_stopped")	-- DEBUG
					
					-- Only attempt to stop the stream if it's been started (prevents crashes, because Pandemic apparently didn't know how to include error-handling worth a damn)
					if lowhealthStreamIndex ~= nil then
						StopAudioStream(lowhealthStreamIndex, 1)
						lowhealthStreamIndex = nil
					else
						print("Init_LowHealthFeedback.stopLowHealthSound_TimerElapse(): WARNING! lowhealthStreamIndex is nil! Value:", lowhealthStreamIndex)
					end
					
					-- If we've made it this far, flag the low health sound as not playing
					LH_bIsLowHealthSoundPlaying = false
					
					-- Reopen the voice streams
					OpenVoiceStreams(true)
					
					-- Make sure the timer doesn't try to restart itself or anything
					StopTimer(stopLowHealthSound_Timer)
					
					-- Garbage collection
					--DestroyTimer(timer)
					--stopLowHealthSound_Timer = nil
					
					--ReleaseTimerElapse(stopLowHealthSound_TimerElapse)
					--stopLowHealthSound_TimerElapse = nil
				end,
			"stopLowHealthSound_Timer"
			)
			
			local lowHealthChangeGate_TimerElapse = OnTimerElapse(
				function(timer)
					print("Init_LowHealthFeedback.lowHealthChangeGate_TimerElapse(): Entered")
					
					--ShowMessageText("level.common.debug.lowhealth_elapsegate")	-- DEBUG
					
					--print("Init_LowHealthFeedback.lowHealthChangeGate_TimerElapse(): Stopping low health sound")
					StopLowHealthSound()
					
					-- Make sure the timer doesn't try to restart itself or anything
					StopTimer(lowHealthChangeGate_Timer)
				end,
			"lowHealthChangeGate_Timer"
			)
			
			-- When the player spawns or changes their class
			local playerspawn = OnCharacterSpawn(
				function(player)
					-- Exit immediately if there are incorrect values
					if not player then return end
					
					if IsCharacterHuman(player) then
						--print()
						--print("Init_LowHealthFeedback.playerspawn(): Player spawned")
						
						--[[if bIsFreshSpawn == true then
							bIsFreshSpawn = false]]
							Iamhuman = GetEntityPtr(GetCharacterUnit(player))
							playerCurHealth, playerMaxHealth = GetObjectHealth(Iamhuman)
						--[[else
							Iamhuman = GetEntityPtr(GetCharacterUnit(player))
						end]]
						
						--print("Init_LowHealthFeedback.playerspawn(): playerMaxHealth:", playerMaxHealth)	-- Uncomment me for test output!
						
						--if not ifs_lowhealth_vignette.TimerMngr == nil then
							--[[if gIsGreaterThan0 > 0 then
								print("Init_LowHealthFeedback: gIsGreaterThan0 is "..gIsGreaterThan0)
								
								SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
								StartTimer(meu_lowhealth_scr_rspwn)
							else
								print("Init_LowHealthFeedback: ELSE gIsGreaterThan0 is "..gIsGreaterThan0)
							end]]
						--end
						
						-- For each hero class,
						for i=1, table.getn(ignoreClasses) do
							-- Is the player a hero class?
							if GetEntityClass(Iamhuman) == FindEntityClass( ignoreClasses[i] ) then
								bIsPlayerCorrectClass = false
							else
								bIsPlayerCorrectClass = true
							end
							
							-- Break out of the loop if wrong class
							if bIsPlayerCorrectClass == false then break end
						end
						
						-- For each synthetic class,
						for i=1, table.getn(synthClasses) do
							-- Is the player a synthetic class?
							if GetEntityClass(Iamhuman) == FindEntityClass( synthClasses[i] ) then
								bIsPlayerSynthClass = true
							else
								bIsPlayerSynthClass = false
							end
							
							-- Break out of the loop if synth class
							if bIsPlayerSynthClass == true then break end
						end
						
						-- Is the low health sound playing?
						--[[if LH_bIsLowHealthSoundPlaying == true then
							--print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): isSoundPlaying is true, setting to false")
							
							LH_bIsLowHealthSoundPlaying = false
							
							-- Remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							StopLowHealthSound()
						end]]
					end
				end
			)
			
			-- When the player is damaged
			local playerhealthchange = OnHealthChange(
				function(object, health)
					-- Exit immediately if there are incorrect values
					if not object then return end
					
					-- Was the damaged object a human player?
					if Iamhuman == GetEntityPtr(object) then
						
						-- Is the player alive? Make sure we don't fade in the low health 
						--  sound if the player's corpse receives damage after having died
						if IsObjectAlive(object) == true then
							--print("Init_LowHealthFeedback.playerhealthchange(): Player health changed")
							--print("Init_LowHealthFeedback: Player health ratio is "..playerHealthPercent)
								
							-- What is the player's current health?
							playerCurHealth, playerMaxHealth = GetObjectHealth(object)
							
							if playerMaxHealth <= 0 then
								playerMaxHealth = 300
							end
							
							-- What's the player's current health percentage?
							local playerHealthPercent = playerCurHealth / playerMaxHealth
							
							--print("Init_LowHealthFeedback.playerhealthchange():    playerMaxHealth, playerCurHealth:", playerMaxHealth, playerCurHealth)	-- Uncomment me for test output!
							--print("Init_LowHealthFeedback.playerhealthchange():    playerHealthPercent, LH_playerHealthThreshold:", playerHealthPercent, LH_playerHealthThreshold)
							
							-- Is the player's health low enough to activate the low health sound?
							if playerHealthPercent < LH_playerHealthThreshold then
								--print("Init_LowHealthFeedback: Player's health is "..playerCurHealth)
								
								--print("Init_LowHealthFeedback.playerhealthchange(): Stopping health change gate")
								--ShowMessageText("level.common.debug.lowhealth_stopgate")	-- DEBUG
								StopTimer(lowHealthChangeGate_Timer)
								
								if LH_bIsLowHealthSoundPlaying == false then
									--print("Init_LowHealthFeedback: isSoundPlaying is false, setting to true")
									
									--LH_bIsLowHealthSoundPlaying = true
									--classCount = 0
									
									-- Is the player the correct class?
									if bIsPlayerCorrectClass == true then
										--print("Init_LowHealthFeedback: Player is correct class")
										
										-- Activate our ifs screen
										--ScriptCB_PushScreen("ifs_lowhealth_vignette")
										
										-- Play heartbeat sound stream
										if bIsPlayerCorrectClass == true then
											--print("Init_LowHealthFeedback.playerhealthchange(): Starting low health sound")
											if bIsPlayerSynthClass == false then
												StartLowHealthSound("organic")
											else
												StartLowHealthSound("synthetic")
											end
										end
									else
										--print("Init_LowHealthFeedback: Player is wrong class")
									end
								end
							else
								-- Is the low health sound playing?
								if LH_bIsLowHealthSoundPlaying == true then
									--print("Init_LowHealthFeedback: isSoundPlaying is true, setting to false")
									
									-- If it's playing, deactivate it
									--LH_bIsLowHealthSoundPlaying = false
									
									-- Remove our ifs screen
									--ifs_lowhealth_vignette.Timer = 10
									--ifs_lowhealth_vignette.TimerType = true
									
									SetTimerValue(lowHealthChangeGate_Timer, 0.5)
									StartTimer(lowHealthChangeGate_Timer)
								end
							end
						end
					end
				end
			)
			
			-- When the player dies
			local playerdeath = OnCharacterDeath(
				function(player, killer)
					-- Exit immediately if there are incorrect values
					if not player then return end
					--if not killer then return end
					
					if IsCharacterHuman(player) then
						--print("Init_LowHealthFeedback: Player died, resetting buses and variables")
						
						--if LH_bIsLowHealthSoundPlaying == true then
							-- Deactivate the low health sound
							--LH_bIsLowHealthSoundPlaying = false
							
							-- remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							bIsFreshSpawn = true
							
							--print("Init_LowHealthFeedback.playerdeath(): Stopping low health sound")
							StopLowHealthSound()
						--end
					end
				end
			)
		end
	else
		print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): Initializing low health sound setting for DISABLED...")
	end
end


print("ME5_LowHealthFeedback: Exited")