-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Low Health Feedback Script by Aaron Gilbert
-- Build 40318/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 18, 2017
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

local __SCRIPT_NAME = "ME5_LowHealthFeedback";
local debug = true

local function PrintLog(...)
	if debug == true then
		print("["..__SCRIPT_NAME.."]", unpack(arg));
	end
end

PrintLog("Entered")

---
-- Sets up the event responses for low health feedback.
-- 
function Init_LowHealthFeedback()	-- TODO: fix low health vignette
	PrintLog("Init_LowHealthFeedback(): Entered")
	if not ScriptCB_InMultiplayer() then
		if ME5_LowHealthSound == 0 then
			PrintLog("Init_LowHealthFeedback(): Initializing low health sound setting for DISABLED...")
		elseif ME5_LowHealthSound == 1 then
			PrintLog("Init_LowHealthFeedback(): Initializing low health sound setting for ENABLED...")
			
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
			
			-- These fields are handled internally
			
			LH_bIsLowHealthSoundPlaying = false		-- Is the low health sound playing?
			LH_bIsLowHealthSoundStopping = false	-- Is the low health sound stopping?
			LH_bSoundCanBeRestarted = true			-- Can the low health sound be restarted?
			local Iamhuman = nil					-- Pointer for human player
			local bIsFreshSpawn = true				-- Is this a fresh spawn? (if the player simply changed their class at a CP, it is not)
			local bIsPlayerCorrectClass = false		-- Is the player the correct class?
			local bIsPlayerSynthClass = false		-- Is the player a synthetic class?
			local bIsSpawnScreenActive = false		-- Is the spawn screen active?
			local lowhealthStreamIndex = nil		-- Index of low health sound stream
			local timerCount	= 0					-- Number of timers that exist
			local playerCurHealth = 0				-- Player's current health value
			local playerMaxHealth = 0				-- Player's maximum health value
			
			-- External values
			
			LH_playerHealthThreshold = 0.35			-- Under what health percentage should the low health sound be active?
			local soundDuration = 7.0				-- Duration of the low health sound in seconds
			local soundRestartWaitTime = 30.0		-- Duration of time that must elapse between each play of the sound
			local busEndGain	= 0.15				-- End gain for audio bus
			local busFadeTime	= 1.0				-- Duration of bus fade in seconds
			local synthClasses = {					-- Synthetic classes
				"gth_inf_destroyer",
				"gth_inf_hunter",
				"gth_inf_juggernaut",
				"gth_inf_machinist",
				"gth_inf_rocketeer",
				"gth_inf_shock",
				"gth_inf_sniper",
				"gth_inf_trooper",
				"gth_inf_destroyer_shield",
				"gth_inf_hunter_shield",
				"gth_inf_juggernaut_shield",
				"gth_inf_machinist_shield",
				"gth_inf_rocketeer_shield",
				"gth_inf_shock_shield",
				"gth_inf_sniper_shield",
				"gth_inf_trooper_shield",
				"gth_ev_inf_trooper",
				"gth_ev_inf_infiltrator",
				"gth_ev_inf_engineer",
				"gth_ev_inf_rocketeer",
				"gth_ev_inf_hunter",
				"gth_ev_inf_pyro",
				"gth_ev_inf_juggernaut",
				"gth_ev_inf_trooper_shield",
				"gth_ev_inf_infiltrator_shield",
				"gth_ev_inf_engineer_shield",
				"gth_ev_inf_rocketeer_shield",
				"gth_ev_inf_hunter_shield",
				"gth_ev_inf_pyro_shield",
				"gth_ev_inf_juggernaut_shield" 
			}
			local ignoreClasses = {					-- Unit classes to ignore (mostly just heroes)
				"gth_hero_prime_me2",
				"gth_hero_prime_me3",
				"ssv_hero_jack",					-- don't let hero units have the effect either
				"ssv_hero_shepard_soldier"..shepardGenderSuffix,
				"ssv_hero_shepard_infiltrator"..shepardGenderSuffix,
				"ssv_hero_shepard_engineer"..shepardGenderSuffix,
				"ssv_hero_shepard_adept"..shepardGenderSuffix,
				"ssv_hero_shepard_sentinel"..shepardGenderSuffix,
				"ssv_hero_shepard_vanguard"..shepardGenderSuffix,
				"col_hero_harbinger",
				"cer_hero_kaileng",
				"rpr_hero_banshee"
			}
			
			-- Timers
			
			local stopLowHealthSound_Timer = CreateTimer("stopLowHealthSound_Timer")
			SetTimerValue(stopLowHealthSound_Timer, busFadeTime*2)
			--ShowTimer(stopLowHealthSound_Timer)
			
			local lowHealthChangeGate_Timer = CreateTimer("lowHealthChangeGate_Timer")
			SetTimerValue(lowHealthChangeGate_Timer, 0.5)
			--ShowTimer(lowHealthChangeGate_Timer)
			
			lowHealthDuration_Timer = CreateTimer("lowHealthDuration_Timer")
			SetTimerValue(lowHealthDuration_Timer, soundDuration)
			
			lowHealthRestartGate_Timer = CreateTimer("lowHealthRestartGate_Timer")
			SetTimerValue(lowHealthRestartGate_Timer, soundRestartWaitTime)
			
			
			--[[local loopLowHealthSound_Timer = CreateTimer("loopLowHealthSound_Timer")
			local loopLowHealthSound_TimerElapse = nil
			local loopTimerValue = nil]]
			
			--local classCount = 0
			
			--local lowHealthSoundTimer = CreateTimer("lowHealthSoundTimer")

			-- Make the screen
			--[[AddIFScreen(ifs_lowhealth_vignette,"ifs_lowhealth_vignette")
			
			meu_lowhealth_scr_rspwn = CreateTimer("meu_lowhealth_scr_rspwn")
			SetTimerValue(meu_lowhealth_scr_rspwn, 1)
			meu_lowhealth_timer_elapse = OnTimerElapse(
				function(timer)
					PrintLog("Init_LowHealthFeedback: Timer 'meu_lowhealth_scr_rspwn' has elapsed")
					PrintLog("Init_LowHealthFeedback: Stopping timer...")
					
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
			function StartLowHealthSound(type)
				PrintLog("Init_LowHealthFeedback.StartLowHealthSound(): Entered")
				
				-- Exit if the sound's already playing
				if LH_bIsLowHealthSoundPlaying == true then
					PrintLog("Init_LowHealthFeedback.StopLowHealthSound(): WARNING! Low health sound is already playing! Exiting")
					return false
				end
				
				-- Type must be specified
				if not type then return end
				
				-- Don't allow the sound to be restarted until the restartgate has elapsed (which isn't started until the sound has stopped)
				LH_bSoundCanBeRestarted = false
				
				-- Start the countdown to stop the low health sound
				SetTimerValue(lowHealthDuration_Timer, soundDuration)
				StartTimer(lowHealthDuration_Timer)
				--ShowTimer(lowHealthDuration_Timer)	-- DEBUG
				
				
				local streamID = nil
				local segmentID = nil
				local gain = 1.0
				
				-- Which type of being is the player's character?
				if type == "organic" then
					streamID = "organic_lowhealth_streaming"
					segmentID = "heartbeat_segment"
					gain = 1.0
					loopTimerValue = 1.876
					
				elseif type == "synthetic" then
					streamID = "synthetic_lowhealth_streaming"
					segmentID = "synthetic_segment"
					gain = 0.6
					loopTimerValue = 6.005
				end
				
				if streamID == nil then return end
				if segmentID == nil then return end
				
				--ShowMessageText("level.common.debug.lowhealth_starting")	-- DEBUG
				
				-- If we've made it this far, flag the low health sound as playing
				LH_bIsLowHealthSoundPlaying = true
				
				-- Make room for the low health stream
				CloseVoiceStreams(true)
				
				PrintLog("Init_LowHealthFeedback.StartLowHealthSound(): Starting low health sounds")
				PrintLog("Init_LowHealthFeedback.StartLowHealthSound(): streamID, segmentID, gain:", streamID, segmentID, gain)
				
				-- Play low health sound stream
				lowHealthStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "lowhealth_streaming")
				PrintLog("Init_LowHealthFeedback.StartLowHealthSound(): lowHealthStream index:", lowHealthStream)
				
				lowhealthStreamIndex = PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", 
														streamID, segmentID, gain, "lowhealth", lowHealthStream)
				
				--lowhealthStreamIndex = PlayAudioStreamUsingProperties("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "organic_lowhealth_streaming", 1)
				--lowhealthStreamIndex = PlayAudioStreamUsingProperties("lowhealth_streaming", "organic_lowhealth_streaming", 1)
				PrintLog("Init_LowHealthFeedback.StartLowHealthSound(): lowhealthStreamIndex index:", lowHealthStream)
				
				-- Start the loop timer to workaround the worldspace bug
				--[[SetTimerValue(loopLowHealthSound_Timer, loopTimerValue * 3)
				--StartTimer(loopLowHealthSound_Timer)
				--ShowTimer(loopLowHealthSound_Timer)	-- DEBUG
				
				loopLowHealthSound_TimerElapse = OnTimerElapse(
					function(timer)
						PrintLog("Init_LowHealthFeedback.loopLowHealthSound_TimerElapse(): Entered")
						StopAudioStream(lowhealthStreamIndex, 0)
						lowhealthStreamIndex = PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", 
																streamID, segmentID, gain, "lowhealth", lowHealthStream)
						
						SetTimerValue(loopLowHealthSound_Timer, loopTimerValue * 3)
						StartTimer(loopLowHealthSound_Timer)
					end,
				"loopLowHealthSound_Timer"
				)]]
				
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
			-- @param #bool bSkipTimer		OPTIONAL : True to stop the sound immediately without fading out the buses, false to wait for the buses to fade out (default : false)
			-- 
			function StopLowHealthSound(bSkipTimer)
				PrintLog("Init_LowHealthFeedback.StopLowHealthSound(): Entered")
				
				bSkipTimer = bSkipTimer or false
				
				-- Exit if the sound's not already playing
				if LH_bIsLowHealthSoundPlaying == false then
					PrintLog("Init_LowHealthFeedback.StopLowHealthSound(): WARNING! Low health sound isn't playing! Exiting")
					return false
				end
				
				-- Start the restartgate timer
				SetTimerValue(lowHealthRestartGate_Timer, soundRestartWaitTime)
				StartTimer(lowHealthRestartGate_Timer)
				--ShowTimer(lowHealthRestartGate_Timer)	-- DEBUG
				
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
				
				if bSkipTimer == false then
					-- Stop and close the low health stream after the audio buses have finished fading
					SetTimerValue(stopLowHealthSound_Timer, busFadeTime*2)
					StartTimer(stopLowHealthSound_Timer)
				else
					-- Only attempt to stop the stream if it's been started (prevents crashes, because Pandemic apparently didn't know how to include error-handling worth a damn)
					if lowhealthStreamIndex ~= nil then
						--StopTimer(loopLowHealthSound_Timer)
						
						StopAudioStream(lowhealthStreamIndex, 1)
						lowhealthStreamIndex = nil
					else
						PrintLog("Init_LowHealthFeedback.stopLowHealthSound_TimerElapse(): WARNING! lowhealthStreamIndex is nil! Value:", lowhealthStreamIndex)
					end
					
					-- If we've made it this far, flag the low health sound as not playing and no longer stopping
					LH_bIsLowHealthSoundPlaying = false
					LH_bIsLowHealthSoundStopping = false
					
					-- Reopen the voice streams
					OpenVoiceStreams(true)
				end
			end
			
			
			--===============================
			-- Event Responses
			--===============================
			
			-- When the audio buses have finished fading out
			local stopLowHealthSound_TimerElapse = OnTimerElapse(
				function(timer)
					PrintLog("Init_LowHealthFeedback.stopLowHealthSound_TimerElapse(): Entered")
					
					--ShowMessageText("level.common.debug.lowhealth_stopped")	-- DEBUG
					
					-- Only attempt to stop the stream if it's been started (prevents crashes, because Pandemic apparently didn't know how to include error-handling worth a damn)
					if lowhealthStreamIndex ~= nil then
						--StopTimer(loopLowHealthSound_Timer)
						
						StopAudioStream(lowhealthStreamIndex, 1)
						lowhealthStreamIndex = nil
					else
						PrintLog("Init_LowHealthFeedback.stopLowHealthSound_TimerElapse(): WARNING! lowhealthStreamIndex is nil! Value:", lowhealthStreamIndex)
					end
					
					-- If we've made it this far, flag the low health sound as not playing and no longer stopping
					LH_bIsLowHealthSoundPlaying = false
					LH_bIsLowHealthSoundStopping = false
					
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
			
			-- When the delay to stop the low health sound has elapsed
			local lowHealthChangeGate_TimerElapse = OnTimerElapse(
				function(timer)
					PrintLog("Init_LowHealthFeedback.lowHealthChangeGate_TimerElapse(): Entered")
					
					--ShowMessageText("level.common.debug.lowhealth_elapsegate")	-- DEBUG
					
					PrintLog("Init_LowHealthFeedback.lowHealthChangeGate_TimerElapse(): Stopping low health sound")
					StopLowHealthSound()
					
					-- Make sure the timer doesn't try to restart itself or anything
					StopTimer(lowHealthChangeGate_Timer)
				end,
			"lowHealthChangeGate_Timer"
			)
			
			-- When the low health sound has been playing for the maximum allowed time
			local lowHealthDuration_TimerElapse = OnTimerElapse(
				function(timer)
					PrintLog("Init_LowHealthFeedback.lowHealthDuration_TimerElapse(): Entered")
					
					--ShowMessageText("level.common.debug.lowhealth_durationelapse")	-- DEBUG
					
					PrintLog("Init_LowHealthFeedback.lowHealthDuration_TimerElapse(): Stopping low health sound")
					StopLowHealthSound()
					
					-- Make sure the timer doesn't try to restart itself or anything
					StopTimer(lowHealthDuration_Timer)
				end,
			"lowHealthDuration_Timer"
			)
			
			-- When the right amount of time has passed after the low health sound has finished playing
			local lowHealthRestartGate_TimerElapse = OnTimerElapse(
				function(timer)
					PrintLog("Init_LowHealthFeedback.lowHealthRestartGate_TimerElapse(): Entered")
					
					--ShowMessageText("level.common.debug.lowhealth_restartgate")	-- DEBUG
					
					PrintLog("Init_LowHealthFeedback.lowHealthRestartGate_TimerElapse(): Stopping low health sound")
					LH_bSoundCanBeRestarted = true
					
					-- Make sure the timer doesn't try to restart itself or anything
					StopTimer(lowHealthRestartGate_Timer)
				end,
			"lowHealthRestartGate_Timer"
			)
			
			-- When the player spawns or changes their class
			local playerspawn = OnCharacterSpawn(
				function(player)
					-- Exit immediately if there are incorrect values
					if not player then return end
					
					if IsCharacterHuman(player) then
						PrintLog("Init_LowHealthFeedback.playerspawn(): Player spawned")
						
						--[[if bIsFreshSpawn == true then
							bIsFreshSpawn = false]]
							Iamhuman = GetEntityPtr(GetCharacterUnit(player))
							if Iamhuman == nil then
								PrintLog("playerspawn: Iamhuman was nil, exiting function")
								return
							end
							playerCurHealth, playerMaxHealth = GetObjectHealth(Iamhuman)
						--[[else
							Iamhuman = GetEntityPtr(GetCharacterUnit(player))
						end]]
						
						--PrintLog("Init_LowHealthFeedback.playerspawn(): playerMaxHealth:", playerMaxHealth)	-- Uncomment me for test output!
						
						--if not ifs_lowhealth_vignette.TimerMngr == nil then
							--[[if gIsGreaterThan0 > 0 then
								PrintLog("Init_LowHealthFeedback: gIsGreaterThan0 is "..gIsGreaterThan0)
								
								SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
								StartTimer(meu_lowhealth_scr_rspwn)
							else
								PrintLog("Init_LowHealthFeedback: ELSE gIsGreaterThan0 is "..gIsGreaterThan0)
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
							--PrintLog("Init_LowHealthFeedback(): isSoundPlaying is true, setting to false")
							
							LH_bIsLowHealthSoundPlaying = false
							
							-- Remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							StopLowHealthSound()
						end]]
					end
				end
			)
			
			-- When the player's health changes (affected by AddHealth too)
			local playerhealthchange = OnHealthChange(
				function(object, health)
					-- Exit immediately if there are incorrect values
					if not object then return end
					if bVoiceStreamKeepClosed == true then
						PrintLog("Init_LowHealthFeedback.playerhealthchange(): bVoiceStreamKeepClosed is true, can't play low health sound")
						return
					end
					
					-- Was the damaged object a human player?
					if Iamhuman == GetEntityPtr(object) then
						
						-- Is the player alive? Make sure we don't fade in the low health 
						--  sound if the player's corpse receives damage after having died
						if IsObjectAlive(object) == true then
							--PrintLog("Init_LowHealthFeedback.playerhealthchange(): Player health changed")
							--PrintLog("Init_LowHealthFeedback.playerhealthchange(): Player health ratio is "..playerHealthPercent)
								
							-- What is the player's current health?
							playerCurHealth, playerMaxHealth = GetObjectHealth(object)
							
							if playerMaxHealth <= 0 then
								playerMaxHealth = 300
							end
							
							-- What's the player's current health percentage?
							local playerHealthPercent = playerCurHealth / playerMaxHealth
							
							--PrintLog("Init_LowHealthFeedback.playerhealthchange():    playerMaxHealth, playerCurHealth:", playerMaxHealth, playerCurHealth)	-- Uncomment me for test output!
							--PrintLog("Init_LowHealthFeedback.playerhealthchange():    playerHealthPercent, LH_playerHealthThreshold:", playerHealthPercent, LH_playerHealthThreshold)
							
							-- Is the player's health low enough to activate the low health sound?
							if playerHealthPercent < LH_playerHealthThreshold then
								--PrintLog("Init_LowHealthFeedback: Player's health is "..playerCurHealth)
								
								--PrintLog("Init_LowHealthFeedback.playerhealthchange(): Stopping health change gate")
								--ShowMessageText("level.common.debug.lowhealth_stopgate")	-- DEBUG
								StopTimer(lowHealthChangeGate_Timer)
								
								if LH_bIsLowHealthSoundPlaying == false then
									PrintLog("Init_LowHealthFeedback.playerhealthchange(): isSoundPlaying is false, setting to true")
									
									--LH_bIsLowHealthSoundPlaying = true
									--classCount = 0
									
									-- Is the player the correct class?
									if bIsPlayerCorrectClass == true then
										--PrintLog("Init_LowHealthFeedback: Player is correct class")
										
										-- Activate our ifs screen
										--ScriptCB_PushScreen("ifs_lowhealth_vignette")
										
										-- Play heartbeat sound stream
										if bIsPlayerCorrectClass == true then
											if LH_bSoundCanBeRestarted == true then
												PrintLog("Init_LowHealthFeedback.playerhealthchange(): Starting low health sound")
												
												if bIsPlayerSynthClass == false then
													StartLowHealthSound("organic")
												else
													StartLowHealthSound("synthetic")
												end
											else
												PrintLog("Init_LowHealthFeedback.playerhealthchange(): Low health sound can't be played again yet!")
											end
										end
									else
										--PrintLog("Init_LowHealthFeedback: Player is wrong class")
									end
								end
							else
								-- Is the low health sound playing?
								if LH_bIsLowHealthSoundPlaying == true and LH_bIsLowHealthSoundStopping == false then
									PrintLog("Init_LowHealthFeedback: isSoundPlaying is true, setting to false")
									
									LH_bIsLowHealthSoundStopping = true
									
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
						--PrintLog("Init_LowHealthFeedback.playerdeath(): Player died, resetting buses and variables")
						
						--if LH_bIsLowHealthSoundPlaying == true then
							-- Deactivate the low health sound
							--LH_bIsLowHealthSoundPlaying = false
							
							-- remove our ifs screen
							--ifs_lowhealth_vignette.Timer = 10
							--ifs_lowhealth_vignette.TimerType = true
							
							bIsFreshSpawn = true
							
							-- Stop the duration and restartgate timers if they're running
							StopTimer(lowHealthDuration_Timer)
							LH_bSoundCanBeRestarted = true
							StopTimer(lowHealthRestartGate_Timer)
							
							-- Stop the low health sound since the player's dead anyways
							PrintLog("Init_LowHealthFeedback.playerdeath(): Stopping low health sound")
							StopLowHealthSound()
						--end
					end
				end
			)
		end
	else
		PrintLog("Init_LowHealthFeedback(): Initializing low health sound setting for DISABLED...")
	end
end


PrintLog("Exited")