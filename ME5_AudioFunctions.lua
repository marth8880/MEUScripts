-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Audio Functions Script by Aaron Gilbert
-- Build 31129/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Nov 29, 2016
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  The purpose of this script is to simplify the process of loading music and setting global sound parameters.
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_AudioFunctions: Entered")

---
-- Opens music streams based on `variation`.
-- @param #int variation	The numeric ID of the music variation we're loading.
-- 
function OpenMusicStreams(variation)
	if variation == 1 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 01")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_01_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_01_Streaming.lvl", "ME5n_music_01")
		
	elseif variation == 2 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 02")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_02_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_02_Streaming.lvl", "ME5n_music_02")
		
	elseif variation == 3 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 03")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_03_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_03_Streaming.lvl", "ME5n_music_03")
		
	elseif variation == 4 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 04")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_04_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_04_Streaming.lvl", "ME5n_music_04")
		
	elseif variation == 5 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 05")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_05_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_05_Streaming.lvl", "ME5n_music_05")
		
	elseif variation == 6 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 06")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_06_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_06_Streaming.lvl", "ME5n_music_06")
		
	elseif variation == 7 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 07")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_07_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_07_Streaming.lvl", "ME5n_music_07")
		
	elseif variation == 8 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 08")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_08_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_08_Streaming.lvl", "ME5n_music_08")
		
	elseif variation == 9 then
		print("ME5_AudioFunctions.OpenMusicStreams(): Loading Music Variation 09")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_09_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_09_Streaming.lvl", "ME5n_music_09")
		
	else
		print("ME5_AudioFunctions.OpenMusicStreams(): Error! No Music Variation is decided!")
	end
	print("ME5_AudioFunctions.OpenMusicStreams(): Loading hero music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl", "ME5n_music_h")
end

---
-- Various music from ME1 - notably Eden Prime and Therum.
-- 
function Music01()
	OpenMusicStreams(1)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		SetAmbientMusic(REP, 1.0, "ssv_amb_01_start",  0,1)
		SetAmbientMusic(REP, 0.9, "ssv_amb_01_mid",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_01_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_01_start",  0,1)
		SetAmbientMusic(CIS, 0.9, "ssv_amb_01_mid",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_01_end",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_01_ctf",  0,1)
		SetAmbientMusic(REP, 0.6, "ssv_amb_01_ctf",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_01_ctf",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_01_ctf",  0,1)
		SetAmbientMusic(CIS, 0.6, "ssv_amb_01_ctf",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_01_ctf",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Collector attack music from ME2.
-- 
function Music02()
	OpenMusicStreams(2)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		local decideStart = math.random(1,3)
		local decideMid = math.random(1,3)
		local decideEnd = math.random(1,2)
		
		local musicStart, musicMid, musicEnd
		
		if decideStart == 1 then
				print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing THE ATTACK")
			musicStart = "ssv_amb_02a_start"
		elseif decideStart == 2 then
				print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing THE NORMANDY ATTACKED")
			musicStart = "ssv_amb_02b_start"
		elseif decideStart == 3 then
				print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing CRASH LANDING")
			musicStart = "ssv_amb_02c_start"
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music02Start variation is loaded! D: :runaway:")
			musicStart = "ssv_amb_02_start"
		end
		
		if decideMid == 1 then
				print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing THE ATTACK")
			musicMid = "ssv_amb_02a_mid"
		elseif decideMid == 2 then
				print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing THE NORMANDY ATTACKED")
			musicMid = "ssv_amb_02b_mid"
		elseif decideMid == 3 then
				print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing CRASH LANDING")
			musicMid = "ssv_amb_02c_mid"
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music02Mid variation is loaded! D: :runaway:")
			musicMid = "ssv_amb_02_mid"
		end
		
		if decideEnd == 1 then
				print("ME5_AudioFunctions: Deciding Music02End variation... Choosing THE ATTACK")
			musicEnd = "ssv_amb_02a_end"
		elseif decideEnd == 2 then
				print("ME5_AudioFunctions: Deciding Music02End variation... Choosing JUMP DRIVE")
			musicEnd = "ssv_amb_02b_end"
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music02End variation is loaded! D: :runaway:")
			musicEnd = "ssv_amb_02_end"
		end
		
		SetAmbientMusic(REP, 1.0, musicStart,  0,1)
		SetAmbientMusic(REP, 0.9, musicMid,    1,1)
		SetAmbientMusic(REP, 0.3, musicEnd,    2,1)
		SetAmbientMusic(CIS, 1.0, musicStart,  0,1)
		SetAmbientMusic(CIS, 0.9, musicMid,    1,1)
		SetAmbientMusic(CIS, 0.3, musicEnd,    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_02_ctf",  0,1)
		SetAmbientMusic(REP, 0.6, "ssv_amb_02_ctf",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_02_ctf",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_02_ctf",  0,1)
		SetAmbientMusic(CIS, 0.6, "ssv_amb_02_ctf",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_02_ctf",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Various music from ME1 - notably Noveria and Virmire. 
-- @param #string variation		Determines music variation to use, or random if unspecified. Possible values:  
-- 								 `"nov"` : Noveria  
-- 								 `"vrm"` : Virmire  
function Music03(variation)
	OpenMusicStreams(3)
	
	local musicStart = "ssv_amb_03_start"
	local musicMid = "ssv_amb_03_mid"
	local musicEnd = "ssv_amb_03_end"
	local musicCTF = "ssv_amb_03_ctf"
	
	-- Append the specific variation to use if specified
	if variation then
		print("ME5_AudioFunctions: Deciding Music03 variation... Choosing "..string.upper(variation))
		
		variation = string.lower(variation)
		
		musicStart = (musicStart.."_"..variation)
		musicMid = (musicMid.."_"..variation)
		--musicEnd = (musicEnd.."_"..variation)
		musicCTF = (musicCTF.."_"..variation)
	end
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		SetAmbientMusic(REP, 1.0, musicStart,  0,1)
		SetAmbientMusic(REP, 0.9, musicMid,    1,1)
		SetAmbientMusic(REP, 0.3, musicEnd,    2,1)
		SetAmbientMusic(CIS, 1.0, musicStart,  0,1)
		SetAmbientMusic(CIS, 0.9, musicMid,    1,1)
		SetAmbientMusic(CIS, 0.3, musicEnd,    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, musicCTF,  0,1)
		SetAmbientMusic(REP, 0.6, musicCTF,    1,1)
		SetAmbientMusic(REP, 0.3, musicCTF,    2,1)
		SetAmbientMusic(CIS, 1.0, musicCTF,  0,1)
		SetAmbientMusic(CIS, 0.6, musicCTF,    1,1)
		SetAmbientMusic(CIS, 0.3, musicCTF,    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Squadmate music from ME2.
-- @param #string variation		Determines music variation to use, or random if unspecified. Possible values:  
-- 								 `"1"` or `"samara"` : Samara  
-- 								 `"2"` or `"grunt"` : Grunt  
-- 								 `"3"` or `"tali"` : Tali  
-- 								 `"4"` or `"infiltration"` : Infiltration  
-- 								 `"5"` or `"thane"` : Thane  
-- 								 `"6"` or `"jack"` : Jack
function Music04(variation)
	OpenMusicStreams(4)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		local decideVar
		
		if not variation then
			decideVar = math.random(1,6)
		else
			print("ME5_AudioFunctions: "..string.upper(variation).." was specified")
			
			variation = string.lower(variation)
			
			if variation == "1" or variation == "samara" then
				decideVar = 1
			elseif variation == "2" or variation == "grunt" then
				decideVar = 2
			elseif variation == "3" or variation == "tali" then
				decideVar = 3
			elseif variation == "4" or variation == "infiltration" then
				decideVar = 4
			elseif variation == "5" or variation == "thane" then
				decideVar = 5
			elseif variation == "6" or variation == "jack" then
				decideVar = 6
			end
		end
		
		if decideVar == 1 then
				print("ME5_AudioFunctions: Deciding Music04 variation... Choosing SAMARA")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04a_start",  0,1)
			SetAmbientMusic(REP, 0.8, "ssv_amb_04a_mid",    1,1)
			SetAmbientMusic(REP, 0.35, "ssv_amb_04a_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04a_start",  0,1)
			SetAmbientMusic(CIS, 0.8, "ssv_amb_04a_mid",    1,1)
			SetAmbientMusic(CIS, 0.35, "ssv_amb_04a_end",    2,1)
		elseif decideVar == 2 then
				print("ME5_AudioFunctions: Deciding Music04 variation... Choosing GRUNT")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04b_start",  0,1)
			SetAmbientMusic(REP, 0.8, "ssv_amb_04b_mid",    1,1)
			SetAmbientMusic(REP, 0.35, "ssv_amb_04b_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04b_start",  0,1)
			SetAmbientMusic(CIS, 0.8, "ssv_amb_04b_mid",    1,1)
			SetAmbientMusic(CIS, 0.35, "ssv_amb_04b_end",    2,1)
		elseif decideVar == 3 then
				print("ME5_AudioFunctions: Deciding Music04 variation... Choosing TALI")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04c_start",  0,1)
			SetAmbientMusic(REP, 0.8, "ssv_amb_04c_mid",    1,1)
			SetAmbientMusic(REP, 0.35, "ssv_amb_04c_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04c_start",  0,1)
			SetAmbientMusic(CIS, 0.8, "ssv_amb_04c_mid",    1,1)
			SetAmbientMusic(CIS, 0.35, "ssv_amb_04c_end",    2,1)
		elseif decideVar == 4 then
				print("ME5_AudioFunctions: Deciding Music04 variation... Choosing INFILTRATION")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04d_start",  0,1)
			SetAmbientMusic(REP, 0.8, "ssv_amb_04d_mid",    1,1)
			SetAmbientMusic(REP, 0.35, "ssv_amb_04d_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04d_start",  0,1)
			SetAmbientMusic(CIS, 0.8, "ssv_amb_04d_mid",    1,1)
			SetAmbientMusic(CIS, 0.35, "ssv_amb_04d_end",    2,1)
		elseif decideVar == 5 then
				print("ME5_AudioFunctions: Deciding Music04 variation... Choosing THANE")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04e_start",  0,1)
			SetAmbientMusic(REP, 0.85, "ssv_amb_04e_mid",    1,1)
			SetAmbientMusic(REP, 0.4, "ssv_amb_04e_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04e_start",  0,1)
			SetAmbientMusic(CIS, 0.8, "ssv_amb_04e_mid",    1,1)
			SetAmbientMusic(CIS, 0.35, "ssv_amb_04e_end",    2,1)
		elseif decideVar == 6 then
				print("ME5_AudioFunctions: Deciding Music04 variation... Choosing JACK")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04f_start",  0,1)
			SetAmbientMusic(REP, 0.85, "ssv_amb_04f_mid",    1,1)
			SetAmbientMusic(REP, 0.4, "ssv_amb_04f_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04f_start",  0,1)
			SetAmbientMusic(CIS, 0.85, "ssv_amb_04f_mid",    1,1)
			SetAmbientMusic(CIS, 0.4, "ssv_amb_04f_end",    2,1)
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music04 variation is loaded! D: :runaway:")
			SetAmbientMusic(REP, 1.0, "ssv_amb_04_start",  0,1)
			SetAmbientMusic(REP, 0.8, "ssv_amb_04_mid",    1,1)
			SetAmbientMusic(REP, 0.35, "ssv_amb_04_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_04_start",  0,1)
			SetAmbientMusic(CIS, 0.8, "ssv_amb_04_mid",    1,1)
			SetAmbientMusic(CIS, 0.35, "ssv_amb_04_end",    2,1)
		end
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_04_ctf",  0,1)
		SetAmbientMusic(REP, 0.6, "ssv_amb_04_ctf",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_04_ctf",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_04_ctf",  0,1)
		SetAmbientMusic(CIS, 0.6, "ssv_amb_04_ctf",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_04_ctf",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Collector music from ME2 - notably the Horizon, Long Walk, Paragon Lost, and Mahavid Mines suites.
-- @param #string variation		Determines music variation to use, or random if unspecified. Possible values:  
-- 								 `"1"` or `"longwalk"` : The Long Walk  
-- 								 `"2"` or `"horizon"` : Horizon  
-- 								 `"3"` or `"paragon"` : Paragon Lost  
-- 								 `"4"` or `"mahavid"` : Mahavid Mines  
function Music05(variation)
	OpenMusicStreams(5)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		local decideVar
		
		if not variation then
			decideVar = math.random(1,4)
		else
			print("ME5_AudioFunctions: "..string.upper(variation).." was specified")
			
			variation = string.lower(variation)
			
			if variation == "1" or variation == "longwalk" then
				decideVar = 1
			elseif variation == "2" or variation == "horizon" then
				decideVar = 2
			elseif variation == "3" or variation == "paragon" then
				decideVar = 3
			elseif variation == "4" or variation == "mahavid" then
				decideVar = 4
			end
		end
		
		if decideVar == 1 then
				print("ME5_AudioFunctions: Deciding Music05 variation... Choosing THE LONG WALK")
			SetAmbientMusic(REP, 1.0, "ssv_amb_05a_start",  0,1)
			SetAmbientMusic(REP, 0.65, "ssv_amb_05a_mid",    1,1)
			SetAmbientMusic(REP, 0.4, "ssv_amb_05a_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_05a_start",  0,1)
			SetAmbientMusic(CIS, 0.65, "ssv_amb_05a_mid",    1,1)
			SetAmbientMusic(CIS, 0.4, "ssv_amb_05a_end",    2,1)
		elseif decideVar == 2 then
				print("ME5_AudioFunctions: Deciding Music05 variation... Choosing HORIZON")
			SetAmbientMusic(REP, 1.0, "ssv_amb_05b_start",  0,1)
			SetAmbientMusic(REP, 0.9, "ssv_amb_05b_mid",    1,1)
			SetAmbientMusic(REP, 0.4, "ssv_amb_05b_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_05b_start",  0,1)
			SetAmbientMusic(CIS, 0.9, "ssv_amb_05b_mid",    1,1)
			SetAmbientMusic(CIS, 0.4, "ssv_amb_05b_end",    2,1)
		elseif decideVar == 3 then
				print("ME5_AudioFunctions: Deciding Music05 variation... Choosing PARAGON LOST")
			SetAmbientMusic(REP, 1.0, "ssv_amb_05c_start",  0,1)
			SetAmbientMusic(REP, 0.9, "ssv_amb_05c_mid",    1,1)
			SetAmbientMusic(REP, 0.55, "ssv_amb_05c_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_05c_start",  0,1)
			SetAmbientMusic(CIS, 0.9, "ssv_amb_05c_mid",    1,1)
			SetAmbientMusic(CIS, 0.55, "ssv_amb_05c_end",    2,1)
		elseif decideVar == 4 then
				print("ME5_AudioFunctions: Deciding Music05 variation... Choosing MAHAVID MINES SUITE")
			SetAmbientMusic(REP, 1.0, "ssv_amb_05d_start",  0,1)
			SetAmbientMusic(REP, 0.85, "ssv_amb_05d_mid",    1,1)
			SetAmbientMusic(REP, 0.3, "ssv_amb_05d_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_05d_start",  0,1)
			SetAmbientMusic(CIS, 0.85, "ssv_amb_05d_mid",    1,1)
			SetAmbientMusic(CIS, 0.3, "ssv_amb_05d_end",    2,1)
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music05 variation is loaded! D: :runaway:")
			SetAmbientMusic(REP, 1.0, "ssv_amb_05a_start",  0,1)
			SetAmbientMusic(REP, 0.65, "ssv_amb_05a_mid",    1,1)
			SetAmbientMusic(REP, 0.4, "ssv_amb_05a_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_05a_start",  0,1)
			SetAmbientMusic(CIS, 0.65, "ssv_amb_05a_mid",    1,1)
			SetAmbientMusic(CIS, 0.4, "ssv_amb_05a_end",    2,1)
		end
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_05_ctf",  0,1)
		SetAmbientMusic(REP, 0.6, "ssv_amb_05_ctf",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_05_ctf",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_05_ctf",  0,1)
		SetAmbientMusic(CIS, 0.6, "ssv_amb_05_ctf",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_05_ctf",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Overlord and Shadow Broker suites from ME2.
-- @param #string variation		Determines music variation to use, or random if unspecified. Possible values:  
-- 								 `"1"` or `"overlord"` : Overlord  
-- 								 `"2"` or `"shadowbroker"` : Shadow Broker  
function Music06(variation)
	OpenMusicStreams(6)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		local decideVar
		
		if not variation then
			decideVar = math.random(1,2)
		else
			print("ME5_AudioFunctions: "..string.upper(variation).." was specified")
			
			variation = string.lower(variation)
			
			if variation == "1" or variation == "overlord" then
				decideVar = 1
			elseif variation == "2" or variation == "shadowbroker" then
				decideVar = 2
			end
		end
		
		if decideVar == 1 then
				print("ME5_AudioFunctions: Deciding Music06 variation... Choosing OVERLORD")
			SetAmbientMusic(REP, 1.0, "ssv_amb_06a_start",  0,1)
			SetAmbientMusic(REP, 0.75, "ssv_amb_06a_mid",    1,1)
			SetAmbientMusic(REP, 0.5, "ssv_amb_06a_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_06a_start",  0,1)
			SetAmbientMusic(CIS, 0.75, "ssv_amb_06a_mid",    1,1)
			SetAmbientMusic(CIS, 0.5, "ssv_amb_06a_end",    2,1)
		elseif decideVar == 2 then
				print("ME5_AudioFunctions: Deciding Music06 variation... Choosing SHADOW BROKER")
			SetAmbientMusic(REP, 1.0, "ssv_amb_06b_start",  0,1)
			SetAmbientMusic(REP, 0.9, "ssv_amb_06b_mid",    1,1)
			SetAmbientMusic(REP, 0.5, "ssv_amb_06b_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_06b_start",  0,1)
			SetAmbientMusic(CIS, 0.9, "ssv_amb_06b_mid",    1,1)
			SetAmbientMusic(CIS, 0.5, "ssv_amb_06b_end",    2,1)
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music06 variation is loaded! D: :runaway:")
			SetAmbientMusic(REP, 1.0, "ssv_amb_06_start",  0,1)
			SetAmbientMusic(REP, 0.7, "ssv_amb_06_mid",    1,1)
			SetAmbientMusic(REP, 0.5, "ssv_amb_06_end",    2,1)
			SetAmbientMusic(CIS, 1.0, "ssv_amb_06_start",  0,1)
			SetAmbientMusic(CIS, 0.7, "ssv_amb_06_mid",    1,1)
			SetAmbientMusic(CIS, 0.5, "ssv_amb_06_end",    2,1)
		end
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_06_ctf",  0,1)
		SetAmbientMusic(REP, 0.6, "ssv_amb_06_ctf",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_06_ctf",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_06_ctf",  0,1)
		SetAmbientMusic(CIS, 0.6, "ssv_amb_06_ctf",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_06_ctf",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Cerberus music from ME3.
-- 
function Music07()
	OpenMusicStreams(7)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		SetAmbientMusic(REP, 1.0, "ssv_amb_07_start",  0,1)
		SetAmbientMusic(REP, 0.75, "ssv_amb_07_mid",    1,1)
		SetAmbientMusic(REP, 0.25, "ssv_amb_07_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_07_start",  0,1)
		SetAmbientMusic(CIS, 0.75, "ssv_amb_07_mid",    1,1)
		SetAmbientMusic(CIS, 0.25, "ssv_amb_07_end",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_07_start",  0,1)
		SetAmbientMusic(REP, 0.75, "ssv_amb_07_mid",    1,1)
		SetAmbientMusic(REP, 0.25, "ssv_amb_07_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_07_start",  0,1)
		SetAmbientMusic(CIS, 0.75, "ssv_amb_07_mid",    1,1)
		SetAmbientMusic(CIS, 0.25, "ssv_amb_07_end",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Reaper music from ME3.
-- 
function Music08()
	OpenMusicStreams(8)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		SetAmbientMusic(REP, 1.0, "ssv_amb_08_start",  0,1)
		SetAmbientMusic(REP, 0.7, "ssv_amb_08_mid",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_08_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_08_start",  0,1)
		SetAmbientMusic(CIS, 0.7, "ssv_amb_08_mid",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_08_end",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_08_start",  0,1)
		SetAmbientMusic(REP, 0.7, "ssv_amb_08_mid",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_08_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_08_start",  0,1)
		SetAmbientMusic(CIS, 0.7, "ssv_amb_08_mid",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_08_end",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Evolved Geth music, taken from Far Cry 3's OST.
-- 
function Music09()
	OpenMusicStreams(9)
	
	if gCurrentMapManager.gameMode ~= "1flag" and gCurrentMapManager.gameMode ~= "ctf" then
		local decideStart = math.random(1,4)
		local decideMid = math.random(1,3)
		local decideEnd = math.random(1,2)
		
		local musicStart, musicMid, musicEnd
		
		if decideStart == 1 then
				print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION A")
			musicStart = "ssv_amb_09_start_a"
		elseif decideStart == 2 then
				print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION B")
			musicStart = "ssv_amb_09_start_b"
		elseif decideStart == 3 then
				print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION C")
			musicStart = "ssv_amb_09_start_c"
		elseif decideStart == 4 then
				print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION D")
			musicStart = "ssv_amb_09_start_d"
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music09Start variation is loaded! D: :runaway:")
			musicStart = "ssv_amb_09_start"
		end
		
		if decideMid == 1 then
				print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION A")
			musicMid = "ssv_amb_09_mid_a"
		elseif decideMid == 2 then
				print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION B")
			musicMid = "ssv_amb_09_mid_b"
		elseif decideMid == 3 then
				print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION C")
			musicMid = "ssv_amb_09_mid_c"
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music09Mid variation is loaded! D: :runaway:")
			musicMid = "ssv_amb_09_mid"
		end
		
		if decideEnd == 1 then
				print("ME5_AudioFunctions: Deciding Music09End variation... Choosing FAR CRY 3 VARIATION A")
			musicEnd = "ssv_amb_09_end_a"
		elseif decideEnd == 2 then
				print("ME5_AudioFunctions: Deciding Music09End variation... Choosing FAR CRY 3 VARIATION B")
			musicEnd = "ssv_amb_09_end_b"
		else
				print("ME5_AudioFunctions: Uh oh! Incorrect Music09End variation is loaded! D: :runaway:")
			musicEnd = "ssv_amb_09_end"
		end
		
		SetAmbientMusic(REP, 1.00, musicStart,  0,1)
		SetAmbientMusic(REP, 0.70, musicMid,    1,1)
		SetAmbientMusic(REP, 0.35, musicEnd,    2,1)
		SetAmbientMusic(CIS, 1.00, musicStart,  0,1)
		SetAmbientMusic(CIS, 0.70, musicMid,    1,1)
		SetAmbientMusic(CIS, 0.35, musicEnd,    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	else
		SetAmbientMusic(REP, 1.0, "ssv_amb_09_ctf",  0,1)
		SetAmbientMusic(REP, 0.6, "ssv_amb_09_ctf",    1,1)
		SetAmbientMusic(REP, 0.3, "ssv_amb_09_ctf",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_09_ctf",  0,1)
		SetAmbientMusic(CIS, 0.6, "ssv_amb_09_ctf",    1,1)
		SetAmbientMusic(CIS, 0.3, "ssv_amb_09_ctf",    2,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	end
end

---
-- Sets up common world VO for the Systems Alliance.
-- 
function SSVWorldVO()
	if not IsCampaign() then
		SetBleedingVoiceOver(REP, REP, "ssv_adm_com_report_us_bleeding", 1)
		SetBleedingVoiceOver(REP, CIS, "ssv_adm_com_report_enemy_bleeding", 1)
		
		SetLowReinforcementsVoiceOver(REP, REP, "ssv_adm_com_report_defeat_imm", 0.1, 1)
		SetLowReinforcementsVoiceOver(REP, CIS, "ssv_adm_com_report_victory_imm", 0.1, 1)
	end
	
	SetOutOfBoundsVoiceOver(REP, "ssv_adm_com_report_hiatus")
end

---
-- Sets up common world VO for the Heretic Geth.
-- 
function GTHWorldVO()
	if not IsCampaign() then
		SetBleedingVoiceOver(CIS, REP, "gth_ann_com_report_enemy_bleeding", 1)
		SetBleedingVoiceOver(CIS, CIS, "gth_ann_com_report_us_bleeding", 1)
	end
	
	SetOutOfBoundsVoiceOver(CIS, "gth_ann_com_report_hiatus")
end

---
-- Sets up common world VO for the Collectors.
-- 
function COLWorldVO()
	if not IsCampaign() then
		SetBleedingVoiceOver(CIS, REP, "col_gen_com_report_enemy_bleeding", 1)
		SetBleedingVoiceOver(CIS, CIS, "col_gen_com_report_us_bleeding", 1)
		
		SetLowReinforcementsVoiceOver(CIS, CIS, "col_gen_com_report_defeat_imm", 0.1, 1)
		SetLowReinforcementsVoiceOver(CIS, REP, "col_gen_com_report_victory_imm", 0.1, 1)
	end
	
	SetOutOfBoundsVoiceOver(CIS, "col_gen_com_report_hiatus")
end

---
-- Sets up common world VO for the Evolved Geth.
-- 
function EVGWorldVO()
	if not IsCampaign() then
		SetBleedingVoiceOver(REP, REP, "evg_prm_com_report_us_bleeding", 1)
		SetBleedingVoiceOver(REP, CIS, "evg_prm_com_report_enemy_bleeding", 1)
	end
	
	SetOutOfBoundsVoiceOver(REP, "evg_prm_com_report_hiatus")
end

---
-- Call this to open the voice audio streams.
function OpenVoiceStreams(bCalledFromLowHealth)
	print("ME5_AudioFunctions.OpenVoiceStreams(): Entered")
	
	bCalledFromLowHealth = bCalledFromLowHealth or false
	
	-- If we were called from the low health script, only open streams if low health sound isn't playing
	if bCalledFromLowHealth == true and LH_bIsLowHealthSoundPlaying == true then
		print("ME5_AudioFunctions.OpenVoiceStreams(): ERROR! Can't open voice streams while low health sound is playing!")
		return false
	end
	
	-- Get the world ID in case we're a campaign map
	local world = string.lower(GetWorldFilename())
	
	gVoiceStream = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "vo_quick_streaming")
	AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "vo_slow_streaming", gVoiceStream)
	
	-- Append campaign VOs
	if world == "eur" then
		AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "eur_objective_vo_slow", gVoiceStream)
	end
	
	AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "global_objective_vo_quick", gVoiceStream)
	--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "lowhealth_streaming", gVoiceStream)
	
	print("ME5_AudioFunctions.OpenVoiceStreams(): gVoiceStream index:", gVoiceStream)
	
	return true
end

---
-- Call this to close the voice audio streams.
-- 
function CloseVoiceStreams()
	print("ME5_AudioFunctions.CloseVoiceStreams(): Entered")
	
	if gVoiceStream ~= nil then
		StopAudioStream(gVoiceStream, 1)
		gVoiceStream = nil
	else
		print("ME5_AudioFunctions.CloseVoiceStreams(): gVoiceStream is nil! Value:", gVoiceStream)
	end
end

---
-- Perform various sound-related operations, such as loading common VO streams, setting common sound parameters, etc.
-- 
function SoundFX()
    OpenVoiceStreams()
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			SSVWorldVO()
			GTHWorldVO()
		elseif ME5_SideVar == 2 then
			SSVWorldVO()
			COLWorldVO()
		elseif ME5_SideVar == 3 then
			EVGWorldVO()
			GTHWorldVO()
		elseif ME5_SideVar == 4 then
			EVGWorldVO()
			COLWorldVO()
		else
			print("ME5_AudioFunctions.SoundFX(): Error! ME5_SideVar setting is invalid! Attempting to load all VOs... (This can only go horribly)")
			SSVWorldVO()
			GTHWorldVO()
			COLWorldVO()
		end
	else
		if gCurrentMapManager.onlineSideVar == "SSVxGTH" then
			SSVWorldVO()
			GTHWorldVO()
		elseif gCurrentMapManager.onlineSideVar == "SSVxCOL" then
			SSVWorldVO()
			COLWorldVO()
		elseif gCurrentMapManager.onlineSideVar == "EVGxGTH" then
			EVGWorldVO()
			GTHWorldVO()
		elseif gCurrentMapManager.onlineSideVar == "EVGxCOL" then
			EVGWorldVO()
			COLWorldVO()
		end
	end
	
	if IsCampaign() then
		local world = string.lower(GetWorldFilename())
		
		if world == "eur" then
			ScriptCB_SetSpawnDisplayGain(0.75, 1.0)
		end
	else
		ScriptCB_SetSpawnDisplayGain(0.35, 1.0)	-- 0.5, 2.5
	end
	ScriptCB_SetDopplerFactor(3.0)
	--SetBleedingRepeatTime(50)	-- 30
	
	ScaleSoundParameter("weapons",			"Gain", 0.82)	-- 0.82
	ScaleSoundParameter("weapons_distant",	"Gain", 0.82)	-- 0.82
	ScaleSoundParameter("weapons_sniper",	"Gain", 1.0)
	ScaleSoundParameter("unit_weapon",	"Gain", 0.8)
	ScaleSoundParameter("unit_stats",	"Gain", 1.0)
	ScaleSoundParameter("Ordnance",				"Gain", 0.84)
	ScaleSoundParameter("Ordnance_large",		"Gain", 1.0)
	ScaleSoundParameter("Ordnance_grenade",		"Gain", 0.8)
	
	-- Player damage sounds
	if ME5_PlayerDmgSound == 2 then
		ScaleSoundParameter("Ordnance_playerdmg",	"Gain", 0.5)
	elseif ME5_PlayerDmgSound == 1 then
		ScaleSoundParameter("Ordnance_playerdmg",	"Gain", 0.25)
	elseif ME5_PlayerDmgSound == 0 then
		ScaleSoundParameter("Ordnance_playerdmg",	"Gain", 0.0)
	end
	
	-- Hit marker sounds
	if ME5_HitMarkerSound == 2 then
		ScaleSoundParameter("Ordnance_hitmarker",	"Gain", 1.0)
	elseif ME5_HitMarkerSound == 1 then
		ScaleSoundParameter("Ordnance_hitmarker",	"Gain", 0.5)
	elseif ME5_HitMarkerSound == 0 then
		ScaleSoundParameter("Ordnance_hitmarker",	"Gain", 0.0)
	end
	
	-- Shepard omni-blade shout sounds
	if ME5_ShepardGender == 1 then
		-- Male
		ScaleSoundParameter("omniblade_broShep",	"Gain", 1.0)
		ScaleSoundParameter("omniblade_femShep",	"Gain", 0.0)
	elseif ME5_ShepardGender == 2 then
		-- Female
		ScaleSoundParameter("omniblade_broShep",	"Gain", 0.0)
		ScaleSoundParameter("omniblade_femShep",	"Gain", 1.0)
	end
	ScaleSoundParameter("Explosion",	"Gain", 0.9)
	ScaleSoundParameter("vehicles",	"Gain", 0.8)
	ScaleSoundParameter("body_movement",	"Gain", 0.8)
	ScaleSoundParameter("vehicle_foley",	"Gain", 0.8)
	ScaleSoundParameter("Collision",		"Gain", 0.8)
	ScaleSoundParameter("props",		"Gain", 0.88)
	ScaleSoundParameter("ambientenv",	"Gain", 0.8)
	ScaleSoundParameter("ssv_vo",	"Gain", 0.7)
	ScaleSoundParameter("gth_vo",	"Gain", 0.8)
	ScaleSoundParameter("col_vo",	"Gain", 0.8)
	ScaleSoundParameter("evg_vo",	"Gain", 0.99)
	ScaleSoundParameter("ssv_inf_pain_vo",	"Gain", 0.80)
	ScaleSoundParameter("gth_inf_pain_vo",	"Gain", 0.65)
	ScaleSoundParameter("col_inf_pain_vo",	"Gain", 0.75)
	ScaleSoundParameter("evg_inf_pain_vo",	"Gain", 0.99)
	--ScaleSoundParameter("Music",	"Gain", 0.9)
	
	-- Map ambience
	if gCurrentMapManager.bIsModMap == true then
		ScaleSoundParameter("ambientenv",	"Gain", 0.95)
	else
		ScaleSoundParameter("ambientenv",	"Gain", 0.45)
	end
	
	-- Faction announcer VOs
	if ME5_FactionVO == 1 then
		ScaleSoundParameter("ssv_vo_slow",	"Gain", 0.5)
		ScaleSoundParameter("gth_vo_slow",	"Gain", 0.5)
		ScaleSoundParameter("col_vo_slow",	"Gain", 0.5)
		ScaleSoundParameter("evg_vo_slow",	"Gain", 0.5)
	elseif ME5_FactionVO == 0 then
		ScaleSoundParameter("ssv_vo_slow",	"Gain", 0.0)
		ScaleSoundParameter("gth_vo_slow",	"Gain", 0.0)
		ScaleSoundParameter("col_vo_slow",	"Gain", 0.0)
		ScaleSoundParameter("evg_vo_slow",	"Gain", 0.0)
	end
	
	-- Kill sounds
	if ME5_KillSound == 1 then
		ScaleSoundParameter("objectives_killsound",	"Gain", 0.5)
	end
	
	
	SetSoundEffect("ScopeDisplayAmbient",  "me5_sniper_scope_ambient")
    SetSoundEffect("ScopeDisplayZoomIn",  "me5_sniper_scope_zoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "me5_sniper_scope_zoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "me5_shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "me5_shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "me5_shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "me5_shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "me5_shell_menu_exit")
end

---
-- Mutes the specified audio bus.
-- @param #string busID			The name of the audio bus to mute.
-- 
function MuteAudioBus(busID)
	if busID == nil then
		print("ME5_AudioFunctions.MuteAudioBus(): Error! busID must be specified!")
	return end
	
	ScriptCB_SndBusFade(busID, 0.0, 0.0)
end

---
-- Unmutes the specified audio bus.
-- @param #string busID			The name of the audio bus to unmute.
-- @param #float originalGain	The original gain of the audio bus.
-- 
function UnmuteAudioBus(busID, originalGain)
	if busID == nil then
		print("ME5_AudioFunctions.UnmuteAudioBus(): Error! busID must be specified!")
	return end
	
	if originalGain == nil then
		print("ME5_AudioFunctions.UnmuteAudioBus(): Error! originalGain must be specified!")
	return end
	
	ScriptCB_SndBusFade(busID, 0.0, originalGain)
end


print("ME5_AudioFunctions: Exited")