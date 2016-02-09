-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by A. Gilbert
-- Version 30206/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 06, 2016
-- Copyright (c) 2016 A. Gilbert.

-- About this script: The purpose of script is to simplify the process 
-- of loading music and setting global sound parameters.


-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_AudioFunctions: Entered")
function SFL_Turrets()
		print("ME5_AudioFunctions: SFL_Turrets()")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_TUR_b_NonStreaming.lvl")
end

function SFL_SSV_vt()
		print("ME5_AudioFunctions: SFL_SSV_vt()")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_v_t_NonStreaming.lvl")
end

function SFL_SSV_vf()
		print("ME5_AudioFunctions: SFL_SSV_vf()")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_v_f_NonStreaming.lvl")
end

-- Opens music streams based on int var, MusicVaration.
function OpenMusicStreams()
	if MusicVariation == 1 then
			print("ME5_AudioFunctions: Loading Music Variation 01")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_01_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_01_Streaming.lvl", "ME5n_music_01")
		
		--local musicVar = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_01_Streaming.lvl", "ME5n_music_01")
		--AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl", "ME5n_music_h", musicVar)
	elseif MusicVariation == 2 then
			print("ME5_AudioFunctions: Loading Music Variation 02")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_02_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_02_Streaming.lvl", "ME5n_music_02")
	elseif MusicVariation == 3 then
			print("ME5_AudioFunctions: Loading Music Variation 03")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_03_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_03_Streaming.lvl", "ME5n_music_03")
	elseif MusicVariation == 4 then
			print("ME5_AudioFunctions: Loading Music Variation 04")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_04_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_04_Streaming.lvl", "ME5n_music_04")
	elseif MusicVariation == 5 then
			print("ME5_AudioFunctions: Loading Music Variation 05")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_05_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_05_Streaming.lvl", "ME5n_music_05")
	elseif MusicVariation == 6 then
			print("ME5_AudioFunctions: Loading Music Variation 06")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_06_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_06_Streaming.lvl", "ME5n_music_06")
	elseif MusicVariation == 7 then
			print("ME5_AudioFunctions: Loading Music Variation 07")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_07_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_07_Streaming.lvl", "ME5n_music_07")
	elseif MusicVariation == 8 then
			print("ME5_AudioFunctions: Loading Music Variation 08")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_08_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_08_Streaming.lvl", "ME5n_music_08")
	elseif MusicVariation == 9 then
			print("ME5_AudioFunctions: Loading Music Variation 08")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_09_Streaming.lvl")
		OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_09_Streaming.lvl", "ME5n_music_09")
	else
			print("ME5_AudioFunctions: Error! No Music Variation is decided!")
		--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_Streaming.lvl")
		--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_Streaming.lvl", "ME5n_music")
	end
		print("ME5_AudioFunctions: Loading hero music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl", "ME5n_music_h")
end

function OpenHeroStreams()
		print("ME5_AudioFunctions: Loading hero music")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_MUS_h_Streaming.lvl", "ME5n_music_h")
end

-- Mostly music from ME1.
function Music01()
	MusicVariation = 1
	
	OpenMusicStreams()
	
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
end

function SetMusic(musicID, isCTF)
	if musicID == 1 then
		if isCTF == 0 or isCTF == false then
			Music01()
		elseif isCTF == 1 or isCTF == true then
			Music01_CTF()
		else end
	else end
end

-- Mostly music from ME1. CTF version.
function Music01_CTF()
	MusicVariation = 1
	
	OpenMusicStreams()
	
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

-- Collector attack music from ME2.
function Music02()
	MusicVariation = 2
	
	OpenMusicStreams()
	DecideMus02StartVar = math.random(1,3)
	DecideMus02MidVar = math.random(1,3)
	DecideMus02EndVar = math.random(1,2)
	
	if DecideMus02StartVar == 1 then
			print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing THE ATTACK")
		Mus02Start = "ssv_amb_02a_start"
	elseif DecideMus02StartVar == 2 then
			print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing THE NORMANDY ATTACKED")
		Mus02Start = "ssv_amb_02b_start"
	elseif DecideMus02StartVar == 3 then
			print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing CRASH LANDING")
		Mus02Start = "ssv_amb_02c_start"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music02Start variation is loaded! D: :runaway:")
		Mus02Start = "ssv_amb_02_start"
	end
	
	if DecideMus02MidVar == 1 then
			print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing THE ATTACK")
		Mus02Mid = "ssv_amb_02a_mid"
	elseif DecideMus02MidVar == 2 then
			print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing THE NORMANDY ATTACKED")
		Mus02Mid = "ssv_amb_02b_mid"
	elseif DecideMus02MidVar == 3 then
			print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing CRASH LANDING")
		Mus02Mid = "ssv_amb_02c_mid"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music02Mid variation is loaded! D: :runaway:")
		Mus02Mid = "ssv_amb_02_mid"
	end
	
	if DecideMus02EndVar == 1 then
			print("ME5_AudioFunctions: Deciding Music02End variation... Choosing THE ATTACK")
		Mus02End = "ssv_amb_02a_end"
	elseif DecideMus02EndVar == 2 then
			print("ME5_AudioFunctions: Deciding Music02End variation... Choosing JUMP DRIVE")
		Mus02End = "ssv_amb_02b_end"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music02End variation is loaded! D: :runaway:")
		Mus02End = "ssv_amb_02_end"
	end
	
	SetAmbientMusic(REP, 1.0, Mus02Start,  0,1)
	SetAmbientMusic(REP, 0.9, Mus02Mid,    1,1)
	SetAmbientMusic(REP, 0.3, Mus02End,    2,1)
	SetAmbientMusic(CIS, 1.0, Mus02Start,  0,1)
	SetAmbientMusic(CIS, 0.9, Mus02Mid,    1,1)
	SetAmbientMusic(CIS, 0.3, Mus02End,    2,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
end

-- Collector attack music from ME2. CTF version.
function Music02_CTF()
	MusicVariation = 2
	
	OpenMusicStreams()
	--[[DecideMus02StartVar = math.random(1,3)
	DecideMus02MidVar = math.random(1,3)
	DecideMus02EndVar = math.random(1,2)
	
	if DecideMus02StartVar == 1 then
			print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing THE ATTACK")
		Mus02Start = "ssv_amb_02a_start"
	elseif DecideMus02StartVar == 2 then
			print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing THE NORMANDY ATTACKED")
		Mus02Start = "ssv_amb_02b_start"
	elseif DecideMus02StartVar == 3 then
			print("ME5_AudioFunctions: Deciding Music02Start variation... Choosing CRASH LANDING")
		Mus02Start = "ssv_amb_02c_start"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music02Start variation is loaded! D: :runaway:")
		Mus02Start = "ssv_amb_02_start"
	end
	
	if DecideMus02MidVar == 1 then
			print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing THE ATTACK")
		Mus02Mid = "ssv_amb_02a_mid"
	elseif DecideMus02MidVar == 2 then
			print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing THE NORMANDY ATTACKED")
		Mus02Mid = "ssv_amb_02b_mid"
	elseif DecideMus02MidVar == 3 then
			print("ME5_AudioFunctions: Deciding Music02Mid variation... Choosing CRASH LANDING")
		Mus02Mid = "ssv_amb_02c_mid"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music02Mid variation is loaded! D: :runaway:")
		Mus02Mid = "ssv_amb_02_mid"
	end
	
	if DecideMus02EndVar == 1 then
			print("ME5_AudioFunctions: Deciding Music02End variation... Choosing THE ATTACK")
		Mus02End = "ssv_amb_02a_end"
	elseif DecideMus02EndVar == 2 then
			print("ME5_AudioFunctions: Deciding Music02End variation... Choosing JUMP DRIVE")
		Mus02End = "ssv_amb_02b_end"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music02End variation is loaded! D: :runaway:")
		Mus02End = "ssv_amb_02_end"
	end]]
	
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

function Music03()
	MusicVariation = 3
	
	OpenMusicStreams()
	
	SetAmbientMusic(REP, 1.0, "ssv_amb_03_start",  0,1)
	SetAmbientMusic(REP, 0.9, "ssv_amb_03_mid",    1,1)
	SetAmbientMusic(REP, 0.3, "ssv_amb_03_end",    2,1)
	SetAmbientMusic(CIS, 1.0, "ssv_amb_03_start",  0,1)
	SetAmbientMusic(CIS, 0.9, "ssv_amb_03_mid",    1,1)
	SetAmbientMusic(CIS, 0.3, "ssv_amb_03_end",    2,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
end

function Music03_CTF()
	MusicVariation = 3
	
	OpenMusicStreams()
	
	SetAmbientMusic(REP, 1.0, "ssv_amb_03_ctf",  0,1)
	SetAmbientMusic(REP, 0.6, "ssv_amb_03_ctf",    1,1)
	SetAmbientMusic(REP, 0.3, "ssv_amb_03_ctf",    2,1)
	SetAmbientMusic(CIS, 1.0, "ssv_amb_03_ctf",  0,1)
	SetAmbientMusic(CIS, 0.6, "ssv_amb_03_ctf",    1,1)
	SetAmbientMusic(CIS, 0.3, "ssv_amb_03_ctf",    2,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
end

-- Squadmate music from ME2. Optional argument int 'variation' determines variation to use, or random if unspecified.
-- @param #int variation test
function Music04(variation)
	MusicVariation = 4
	
	OpenMusicStreams()
	
	if not variation then
		DecideMus04Var = math.random(1,6)
	end
	
	if DecideMus04Var == 1 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing SAMARA")
		SetAmbientMusic(REP, 1.0, "ssv_amb_04a_start",  0,1)
		SetAmbientMusic(REP, 0.8, "ssv_amb_04a_mid",    1,1)
		SetAmbientMusic(REP, 0.35, "ssv_amb_04a_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_04a_start",  0,1)
		SetAmbientMusic(CIS, 0.8, "ssv_amb_04a_mid",    1,1)
		SetAmbientMusic(CIS, 0.35, "ssv_amb_04a_end",    2,1)
	elseif DecideMus04Var == 2 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing GRUNT")
		SetAmbientMusic(REP, 1.0, "ssv_amb_04b_start",  0,1)
		SetAmbientMusic(REP, 0.8, "ssv_amb_04b_mid",    1,1)
		SetAmbientMusic(REP, 0.35, "ssv_amb_04b_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_04b_start",  0,1)
		SetAmbientMusic(CIS, 0.8, "ssv_amb_04b_mid",    1,1)
		SetAmbientMusic(CIS, 0.35, "ssv_amb_04b_end",    2,1)
	elseif DecideMus04Var == 3 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing TALI")
		SetAmbientMusic(REP, 1.0, "ssv_amb_04c_start",  0,1)
		SetAmbientMusic(REP, 0.8, "ssv_amb_04c_mid",    1,1)
		SetAmbientMusic(REP, 0.35, "ssv_amb_04c_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_04c_start",  0,1)
		SetAmbientMusic(CIS, 0.8, "ssv_amb_04c_mid",    1,1)
		SetAmbientMusic(CIS, 0.35, "ssv_amb_04c_end",    2,1)
	elseif DecideMus04Var == 4 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing INFILTRATION")
		SetAmbientMusic(REP, 1.0, "ssv_amb_04d_start",  0,1)
		SetAmbientMusic(REP, 0.8, "ssv_amb_04d_mid",    1,1)
		SetAmbientMusic(REP, 0.35, "ssv_amb_04d_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_04d_start",  0,1)
		SetAmbientMusic(CIS, 0.8, "ssv_amb_04d_mid",    1,1)
		SetAmbientMusic(CIS, 0.35, "ssv_amb_04d_end",    2,1)
	elseif DecideMus04Var == 5 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing THANE")
		SetAmbientMusic(REP, 1.0, "ssv_amb_04e_start",  0,1)
		SetAmbientMusic(REP, 0.85, "ssv_amb_04e_mid",    1,1)
		SetAmbientMusic(REP, 0.4, "ssv_amb_04e_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_04e_start",  0,1)
		SetAmbientMusic(CIS, 0.8, "ssv_amb_04e_mid",    1,1)
		SetAmbientMusic(CIS, 0.35, "ssv_amb_04e_end",    2,1)
	elseif DecideMus04Var == 6 then
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
end

function Music04_CTF()
	MusicVariation = 4
	
	OpenMusicStreams()
	--[[DecideMus04Var = math.random(1,6)
	
	if DecideMus04Var == 1 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing SAMARA")
		music04_start = "ssv_amb_04a_start"
		music04_mid = "ssv_amb_04a_mid"
		music04_end = "ssv_amb_04a_end"
	elseif DecideMus04Var == 2 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing GRUNT")
		music04_start = "ssv_amb_04b_start"
		music04_mid = "ssv_amb_04b_mid"
		music04_end = "ssv_amb_04b_end"
	elseif DecideMus04Var == 3 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing TALI")
		music04_start = "ssv_amb_04a_start"
		music04_mid = "ssv_amb_04c_mid"
		music04_end = "ssv_amb_04c_end"
	elseif DecideMus04Var == 4 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing INFILTRATION")
		music04_start = "ssv_amb_04d_start"
		music04_mid = "ssv_amb_04d_mid"
		music04_end = "ssv_amb_04d_end"
	elseif DecideMus04Var == 5 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing THANE")
		music04_start = "ssv_amb_04e_start"
		music04_mid = "ssv_amb_04e_mid"
		music04_end = "ssv_amb_04e_end"
	elseif DecideMus04Var == 6 then
			print("ME5_AudioFunctions: Deciding Music04 variation... Choosing JACK")
		music04_start = "ssv_amb_04f_start"
		music04_mid = "ssv_amb_04f_mid"
		music04_end = "ssv_amb_04f_end"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music04 variation is loaded! D: :runaway:")
		music04_start = "ssv_amb_04_start"
		music04_mid = "ssv_amb_04_mid"
		music04_end = "ssv_amb_04_end"
	end]]
	
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

function Music05()
	MusicVariation = 5
	
	OpenMusicStreams()
	DecideMus05Var = math.random(1,4)
	
	if DecideMus05Var == 1 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing THE LONG WALK")
		SetAmbientMusic(REP, 1.0, "ssv_amb_05a_start",  0,1)
		SetAmbientMusic(REP, 0.65, "ssv_amb_05a_mid",    1,1)
		SetAmbientMusic(REP, 0.4, "ssv_amb_05a_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_05a_start",  0,1)
		SetAmbientMusic(CIS, 0.65, "ssv_amb_05a_mid",    1,1)
		SetAmbientMusic(CIS, 0.4, "ssv_amb_05a_end",    2,1)
	elseif DecideMus05Var == 2 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing COLLECTOR FEVER")
		SetAmbientMusic(REP, 1.0, "ssv_amb_05b_start",  0,1)
		SetAmbientMusic(REP, 0.9, "ssv_amb_05b_mid",    1,1)
		SetAmbientMusic(REP, 0.4, "ssv_amb_05b_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_05b_start",  0,1)
		SetAmbientMusic(CIS, 0.9, "ssv_amb_05b_mid",    1,1)
		SetAmbientMusic(CIS, 0.4, "ssv_amb_05b_end",    2,1)
	elseif DecideMus05Var == 3 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing PARAGON LOST")
		SetAmbientMusic(REP, 1.0, "ssv_amb_05c_start",  0,1)
		SetAmbientMusic(REP, 0.9, "ssv_amb_05c_mid",    1,1)
		SetAmbientMusic(REP, 0.55, "ssv_amb_05c_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_05c_start",  0,1)
		SetAmbientMusic(CIS, 0.9, "ssv_amb_05c_mid",    1,1)
		SetAmbientMusic(CIS, 0.55, "ssv_amb_05c_end",    2,1)
	elseif DecideMus05Var == 4 then
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
end

function Music05_CTF()
	MusicVariation = 5
	
	OpenMusicStreams()
	--[[DecideMus05Var = math.random(1,4)
	
	if DecideMus05Var == 1 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing THE LONG WALK")
		music05_start = "ssv_amb_05a_start"
		music05_mid = "ssv_amb_05a_mid"
		music05_end = "ssv_amb_05a_end"
	elseif DecideMus05Var == 2 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing COLLECTOR FEVER")
		music05_start = "ssv_amb_05b_start"
		music05_mid = "ssv_amb_05b_mid"
		music05_end = "ssv_amb_05b_end"
	elseif DecideMus05Var == 3 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing PARAGON LOST")
		music05_start = "ssv_amb_05c_start"
		music05_mid = "ssv_amb_05c_mid"
		music05_end = "ssv_amb_05c_end"
	elseif DecideMus05Var == 3 then
			print("ME5_AudioFunctions: Deciding Music05 variation... Choosing MAHAVID MINES SUITE")
		music05_start = "ssv_amb_05d_start"
		music05_mid = "ssv_amb_05d_mid"
		music05_end = "ssv_amb_05d_end"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music05 variation is loaded! D: :runaway:")
		music05_start = "ssv_amb_05_start"
		music05_mid = "ssv_amb_05_mid"
		music05_end = "ssv_amb_05_end"
	end]]
	
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

function Music06()
	MusicVariation = 6
	
	OpenMusicStreams()
	DecideMus06Var = math.random(1,2)
	
	if DecideMus06Var == 1 then
			print("ME5_AudioFunctions: Deciding Music06 variation... Choosing OVERLORD")
		SetAmbientMusic(REP, 1.0, "ssv_amb_06a_start",  0,1)
		SetAmbientMusic(REP, 0.75, "ssv_amb_06a_mid",    1,1)
		SetAmbientMusic(REP, 0.5, "ssv_amb_06a_end",    2,1)
		SetAmbientMusic(CIS, 1.0, "ssv_amb_06a_start",  0,1)
		SetAmbientMusic(CIS, 0.75, "ssv_amb_06a_mid",    1,1)
		SetAmbientMusic(CIS, 0.5, "ssv_amb_06a_end",    2,1)
	elseif DecideMus06Var == 2 then
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
end

function Music06_CTF()
	MusicVariation = 6
	
	OpenMusicStreams()
	--[[DecideMus06Var = math.random(1,2)
	
	if DecideMus05Var == 1 then
			print("ME5_AudioFunctions: Deciding Music06 variation... Choosing OVERLORD")
		music06_start = "ssv_amb_06a_start"
		music06_mid = "ssv_amb_06a_mid"
		music06_end = "ssv_amb_06a_end"
	elseif DecideMus05Var == 2 then
			print("ME5_AudioFunctions: Deciding Music06 variation... Choosing SHADOW BROKER")
		music06_start = "ssv_amb_06b_start"
		music06_mid = "ssv_amb_06b_mid"
		music06_end = "ssv_amb_06b_end"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music06 variation is loaded! D: :runaway:")
		music06_start = "ssv_amb_06_start"
		music06_mid = "ssv_amb_06_mid"
		music06_end = "ssv_amb_06_end"
	end]]
	
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

function Music07()
	MusicVariation = 7
	
	OpenMusicStreams()
	
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

function Music08()
	MusicVariation = 8
	
	OpenMusicStreams()
	
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

function Music09()
	MusicVariation = 9
	
	OpenMusicStreams()
	DecideMus09StartVar = math.random(1,4)
	DecideMus09MidVar = math.random(1,3)
	DecideMus09EndVar = math.random(1,2)
	
	if DecideMus09StartVar == 1 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION A")
		Mus09Start = "ssv_amb_09_start_a"
	elseif DecideMus09StartVar == 2 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION B")
		Mus09Start = "ssv_amb_09_start_b"
	elseif DecideMus09StartVar == 3 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION C")
		Mus09Start = "ssv_amb_09_start_c"
	elseif DecideMus09StartVar == 4 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION D")
		Mus09Start = "ssv_amb_09_start_d"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music09Start variation is loaded! D: :runaway:")
		Mus09Start = "ssv_amb_09_start"
	end
	
	if DecideMus09MidVar == 1 then
			print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION A")
		Mus09Mid = "ssv_amb_09_mid_a"
	elseif DecideMus09MidVar == 2 then
			print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION B")
		Mus09Mid = "ssv_amb_09_mid_b"
	elseif DecideMus09MidVar == 3 then
			print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION C")
		Mus09Mid = "ssv_amb_09_mid_c"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music09Mid variation is loaded! D: :runaway:")
		Mus09Mid = "ssv_amb_09_mid"
	end
	
	if DecideMus09EndVar == 1 then
			print("ME5_AudioFunctions: Deciding Music09End variation... Choosing FAR CRY 3 VARIATION A")
		Mus09End = "ssv_amb_09_end_a"
	elseif DecideMus09EndVar == 2 then
			print("ME5_AudioFunctions: Deciding Music09End variation... Choosing FAR CRY 3 VARIATION B")
		Mus09End = "ssv_amb_09_end_b"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music09End variation is loaded! D: :runaway:")
		Mus09End = "ssv_amb_09_end"
	end
	
	SetAmbientMusic(REP, 1.00, Mus09Start,  0,1)
	SetAmbientMusic(REP, 0.70, Mus09Mid,    1,1)
	SetAmbientMusic(REP, 0.35, Mus09End,    2,1)
	SetAmbientMusic(CIS, 1.00, Mus09Start,  0,1)
	SetAmbientMusic(CIS, 0.70, Mus09Mid,    1,1)
	SetAmbientMusic(CIS, 0.35, Mus09End,    2,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
end

function Music09_CTF()
	MusicVariation = 9
	
	OpenMusicStreams()
	--[[DecideMus09StartVar = math.random(1,4)
	DecideMus09MidVar = math.random(1,3)
	DecideMus09EndVar = math.random(1,2)
	
	if DecideMus09StartVar == 1 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION A")
		Mus09Start = "ssv_amb_09_start_a"
	elseif DecideMus09StartVar == 2 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION B")
		Mus09Start = "ssv_amb_09_start_b"
	elseif DecideMus09StartVar == 3 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION C")
		Mus09Start = "ssv_amb_09_start_c"
	elseif DecideMus09StartVar == 4 then
			print("ME5_AudioFunctions: Deciding Music09Start variation... Choosing FAR CRY 3 VARIATION D")
		Mus09Start = "ssv_amb_09_start_d"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music09Start variation is loaded! D: :runaway:")
		Mus09Start = "ssv_amb_09_start"
	end
	
	if DecideMus09MidVar == 1 then
			print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION A")
		Mus09Mid = "ssv_amb_09_mid_a"
	elseif DecideMus09MidVar == 2 then
			print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION B")
		Mus09Mid = "ssv_amb_09_mid_b"
	elseif DecideMus09MidVar == 3 then
			print("ME5_AudioFunctions: Deciding Music09Mid variation... Choosing FAR CRY 3 VARIATION C")
		Mus09Mid = "ssv_amb_09_mid_c"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music09Mid variation is loaded! D: :runaway:")
		Mus09Mid = "ssv_amb_09_mid"
	end
	
	if DecideMus09EndVar == 1 then
			print("ME5_AudioFunctions: Deciding Music09End variation... Choosing FAR CRY 3 VARIATION A")
		Mus09End = "ssv_amb_09_end_a"
	elseif DecideMus09EndVar == 2 then
			print("ME5_AudioFunctions: Deciding Music09End variation... Choosing FAR CRY 3 VARIATION B")
		Mus09End = "ssv_amb_09_end_b"
	else
			print("ME5_AudioFunctions: Uh oh! Incorrect Music09End variation is loaded! D: :runaway:")
		Mus09End = "ssv_amb_09_end"
	end]]
	
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

function SSVWorldVO()
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "vo_streaming")
	
	SetBleedingVoiceOver(REP, REP, "ssv_adm_com_report_us_bleeding", 1)
	SetBleedingVoiceOver(REP, CIS, "ssv_adm_com_report_enemy_bleeding", 1)
	
	SetLowReinforcementsVoiceOver(REP, REP, "ssv_adm_com_report_defeat_imm", .1, 1)
	SetLowReinforcementsVoiceOver(REP, CIS, "ssv_adm_com_report_victory_imm", .1, 1)
	
	SetOutOfBoundsVoiceOver(REP, "ssv_adm_com_report_hiatus")
end

function GTHWorldVO()
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_GTH_Streaming.lvl", "gth_vo_streaming")
	
	SetBleedingVoiceOver(CIS, REP, "gth_ann_com_report_enemy_bleeding", 1)
	SetBleedingVoiceOver(CIS, CIS, "gth_ann_com_report_us_bleeding", 1)
	
	SetOutOfBoundsVoiceOver(CIS, "gth_ann_com_report_hiatus")
end

function COLWorldVO()
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_COL_Streaming.lvl", "col_vo_streaming")
	
	SetBleedingVoiceOver(CIS, REP, "col_gen_com_report_enemy_bleeding", 1)
	SetBleedingVoiceOver(CIS, CIS, "col_gen_com_report_us_bleeding", 1)
	
	SetLowReinforcementsVoiceOver(CIS, CIS, "col_gen_com_report_defeat_imm", .1, 1)
	SetLowReinforcementsVoiceOver(CIS, REP, "col_gen_com_report_victory_imm", .1, 1)
	
	SetOutOfBoundsVoiceOver(CIS, "col_gen_com_report_hiatus")
end

function EVGWorldVO()
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "vo_streaming")
	
	--OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_GTH_Streaming.lvl", "gth_vo_streaming")
	
	SetBleedingVoiceOver(REP, REP, "evg_prm_com_report_us_bleeding", 1)
	SetBleedingVoiceOver(REP, CIS, "evg_prm_com_report_enemy_bleeding", 1)
	
	SetOutOfBoundsVoiceOver(REP, "evg_prm_com_report_hiatus")
end

function SoundFX()
    voiceQuick = OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "vo_quick_streaming")
    AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "vo_slow_streaming", voiceQuick)
    --AudioStreamAppendSegments("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_vo_Streaming.lvl", "lowhealth_streaming", voiceQuick)
	
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 0 then
			if RandomSide == 1 then
				SSVWorldVO()
				GTHWorldVO()
			elseif RandomSide == 2 then
				SSVWorldVO()
				COLWorldVO()
			elseif RandomSide == 3 then
				EVGWorldVO()
				GTHWorldVO()
			elseif RandomSide == 4 then
				EVGWorldVO()
				COLWorldVO()
			end
		elseif ME5_SideVar == 1 then
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
				print("ME5_MiscFunctions: Error! ME5_SideVar setting is invalid! Attempting to load all VOs... (This can only go horribly)")
			SSVWorldVO()
			GTHWorldVO()
			COLWorldVO()
		end
	else
		if onlineSideVar == 1 then
			SSVWorldVO()
			GTHWorldVO()
		elseif onlineSideVar == 2 then
			SSVWorldVO()
			COLWorldVO()
		elseif onlineSideVar == 3 then
			EVGWorldVO()
			GTHWorldVO()
		elseif onlineSideVar == 4 then
			EVGWorldVO()
			COLWorldVO()
		else end
	end
	
	ScriptCB_SetSpawnDisplayGain(0.35, 1.0)	-- 0.5, 2.5
	ScriptCB_SetDopplerFactor(3.0)
	--SetBleedingRepeatTime(50)	-- 30
	
	ScaleSoundParameter("weapons",	"Gain", 0.82)
	ScaleSoundParameter("weapons_distant",	"Gain", 0.82)
	ScaleSoundParameter("weapons_sniper",	"Gain", 1.0)
	ScaleSoundParameter("unit_weapon",	"Gain", 0.8)
	ScaleSoundParameter("Ordnance",	"Gain", 0.84)
	ScaleSoundParameter("Ordnance_large",	"Gain", 1.0)
	ScaleSoundParameter("Ordnance_grenade",	"Gain", 0.8)
	ScaleSoundParameter("Explosion",	"Gain", 0.9)
	ScaleSoundParameter("vehicles",	"Gain", 0.8)
	ScaleSoundParameter("body_movement",	"Gain", 0.8)
	ScaleSoundParameter("vehicle_foley",	"Gain", 0.8)
	ScaleSoundParameter("Collision",	"Gain", 0.8)
	ScaleSoundParameter("props",	"Gain", 0.88)
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
	if isModMap == 1 then
		ScaleSoundParameter("ambientenv",	"Gain", 0.95)
	else
		ScaleSoundParameter("ambientenv",	"Gain", 0.45)
	end
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
	else end
	if ME5_KillSound == 1 then
		ScaleSoundParameter("objectives_killsound",	"Gain", 0.5)
	else end
	
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
	
	-- Create a text document in the folder I mentioned and name it "TESTwhat.txt"

		--[[local testfile = assert(io.open("TESTwhat.txt", "r"))
		local testioinput = testfile:read("*all")
		testfile:close()
		print("ZeroEngineSuckageLevel: " .. testioinput)]]
end
	print("ME5_AudioFunctions: Exited")