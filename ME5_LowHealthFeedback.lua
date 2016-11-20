-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Low Health Feedback Script by A. Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016 A. Gilbert.
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
			
			lowHealthStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "lowhealth_streaming")
			--PlayAudioStreamUsingProperties("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", "organic_lowhealth_streaming", 1)
			
			-- Initial lowhealth bus fade
			ScriptCB_SndBusFade("lowhealth", 0.0, 0.0)
			
			-- Play heartbeat sound stream
			PlayAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LowHealth_Streaming.lvl", 
								"organic_lowhealth_streaming", "heartbeat_segment", 1.0, "lowhealth", lowHealthStream)
			
			LH_bIsLowHealthSoundPlaying = false	-- Is the low health sound playing?
			LH_playerHealthThreshold = 0.35		-- Under what health percentage should the low health sound be active?
			local Iamhuman = nil				-- Pointer for human player.
			local bIsPlayerCorrectClass = false	-- Is the player the correct class?
			local bIsSpawnScreenActive = false	-- Is the spawn screen active?
			local timerCount	= 0				-- How many timers exist?
			local busEndGain	= 0.15			-- What is the end gain for the audio bus?
			local busFadeTime	= 1.0			-- What is the duration of the bus fade?
			local playerMaxHealth = 0			-- What is the player's health when they spawn?
			local ignoreClasses = {
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
					"ssv_hero_jack",					-- don't let hero units have the effect either
					"ssv_hero_shepard_soldier",
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
						print("Init_LowHealthFeedback: Timer 'meu_lowhealth_scr_rspwn' has elapsed")
						print("Init_LowHealthFeedback: Stopping timer...")
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
							print("Init_LowHealthFeedback: testcheckhumanchangeclass()")
						if isSpawnScreenActive == false then
							isSpawnScreenActive = true
						elseif isSpawnScreenActive == true then
							isSpawnScreenActive = false
						end
						
						if ifs_lowhealth_vignette.TimerMngr > 0 and isSpawnScreenActive == false then
								print("Init_LowHealthFeedback: Starting timer 'meu_lowhealth_scr_rspwn'")
							
							meu_lowhealth_scr_rspwn_..timerCount = CreateTimer("meu_lowhealth_scr_rspwn")
							SetTimerValue(meu_lowhealth_scr_rspwn_..timerCount, 0.5)
							StartTimer(meu_lowhealth_scr_rspwn_..timerCount)
							OnTimerElapse(
								function(timer)
										print("Init_LowHealthFeedback: Timer 'meu_lowhealth_scr_rspwn_"..timerCount.."' has elapsed")
										print("Init_LowHealthFeedback: Stopping timer...")
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
			
			-- When the player spawns or changes their class
			local playerspawn = OnCharacterSpawn(
				function(player)
					if IsCharacterHuman(player) then
						--print("Init_LowHealthFeedback: Player spawned")
						
						Iamhuman = GetEntityPtr(GetCharacterUnit(player))
						playerMaxHealth = GetObjectHealth(Iamhuman)
						
						--print("ME5_LowHealthFeedback.Init_LowHealthFeedback.playerspawn(): playerMaxHealth:", playerMaxHealth)	-- Uncomment me for test output!
						
						--if not ifs_lowhealth_vignette.TimerMngr == nil then
							--[[if gIsGreaterThan0 > 0 then
								print("Init_LowHealthFeedback: gIsGreaterThan0 is "..gIsGreaterThan0)
								
								SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
								StartTimer(meu_lowhealth_scr_rspwn)
							else
								print("Init_LowHealthFeedback: ELSE gIsGreaterThan0 is "..gIsGreaterThan0)
							end]]
						--end
						
						-- For each synthetic class,
						for i=1, table.getn(ignoreClasses) do
							-- Is the player a non-synthetic class?
							if GetEntityClass(Iamhuman) == FindEntityClass( ignoreClasses[i] ) then
								bIsPlayerCorrectClass = false
							else
								bIsPlayerCorrectClass = true
							end
							
							-- Break out of the loop if wrong class
							if bIsPlayerCorrectClass == false then break end
						end
						
						-- Is the low health sound playing?
						if LH_bIsLowHealthSoundPlaying == true then
							--print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): isSoundPlaying is true, setting to false")
							
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
						
						-- Is the player alive? Make sure we don't fade in the low health 
						--  sound if the player's corpse receives damage after having died
						if IsObjectAlive(object) == true then
							--print("Init_LowHealthFeedback: Player health changed")
							--print("Init_LowHealthFeedback: Player health ratio is "..playerHealthPercent)
								
							-- What is the player's current health?
							local playerCurHealth = GetObjectHealth(object)
							
							if playerMaxHealth <= 0 then
								playerMaxHealth = 300
							end
							
							-- What's the player's current health percentage?
							local playerHealthPercent = playerCurHealth / playerMaxHealth
							
							--[[print("ME5_LowHealthFeedback.Init_LowHealthFeedback.playerhealthchange():    playerMaxHealth, playerCurHealth, playerHealthPercent:", 
							playerMaxHealth, playerCurHealth, playerHealthPercent)]]	-- Uncomment me for test output!
							
							-- Is the player's health low enough to activate the low health sound?
							if playerHealthPercent < LH_playerHealthThreshold then
								--print("Init_LowHealthFeedback: Player's health is "..playerCurHealth)
								
								if LH_bIsLowHealthSoundPlaying == false then
									--print("Init_LowHealthFeedback: isSoundPlaying is false, setting to true")
									
									LH_bIsLowHealthSoundPlaying = true
									--classCount = 0
									
									-- Is the player the correct class?
									if bIsPlayerCorrectClass == true then
											--print("Init_LowHealthFeedback: Player is correct class")
										
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
										--print("Init_LowHealthFeedback: Player is wrong class")
									end
								end
							else
								-- Is the low health sound playing?
								if LH_bIsLowHealthSoundPlaying == true then
									--print("Init_LowHealthFeedback: isSoundPlaying is true, setting to false")
									
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
				end
			)
			
			-- When the player dies
			local playerdeath = OnCharacterDeath(
				function(player, killer)
					if IsCharacterHuman(player) then
						--print("Init_LowHealthFeedback: Player died, resetting buses and variables")
						
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
		print("ME5_LowHealthFeedback.Init_LowHealthFeedback(): Initializing low health sound setting for DISABLED...")
	end
end


print("ME5_LowHealthFeedback: Exited")