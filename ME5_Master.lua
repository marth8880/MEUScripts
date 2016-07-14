-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by A. Gilbert
-- Version 30707/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Jul 12, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: The purpose of script is to set some global 
-- variables and load the other scripts.
-- 
-- 
-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it. 
-- Do not claim this script as your own. I did spend time writing it after all. I cannot be held  
-- accountable for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_Master: Entered")
	
	-- The build version. Valid settings are "production", "release"
	MEU_BuildVer		= "production"
	MEU_BuildNum		= 30712
	MEU_ReleaseNum		= 6
	MEU_VersionNum		= 1.21
	
	print("ME5_Master: Mass Effect: Unification is currently running on Build "..MEU_BuildNum.."/0"..MEU_ReleaseNum..", Release "..MEU_ReleaseNum..", Version "..MEU_VersionNum)
	
	print("ME5_Master: Performing garbage collection...")
	
	ME5_AIHeroes			= nil
	ME5_CustomGUIEnabled	= nil
	ME5_CustomHUD			= nil
	ME5_Difficulty			= nil
	ME5_HealthFunc			= nil
	ME5_ShieldFunc			= nil
	ME5_ShieldRegen			= nil
	ME5_HeroClassCOL		= nil
	ME5_HeroClassEVG		= nil
	ME5_HeroClassGTH		= nil
	ME5_HeroClassSSV		= nil
	ME5_ShepardClass		= nil
	ME5_ShepardGender		= nil
	ME5_SideVar				= nil
	ME5_SolMapMusic			= nil
	ME5_FactionVO			= nil
	ME5_LowHealthSound		= nil
	ME5_KillSound			= nil
	ME5_PlayerDmgSound		= nil
	
	mapSize				= nil
	MEUGameMode			= MEUGameMode or nil
	EnvironmentType		= nil
	onlineSideVar		= nil
	onlineHeroSSV		= nil
	onlineHeroGTH		= nil
	onlineHeroCOL		= nil
	onlineHeroEVG		= nil
	isTDM				= false
	
	xxs		= nil
	xs		= nil
	sm		= nil
	med		= nil
	lg		= nil
	
	meu_1flag		= nil
	meu_con			= nil
	meu_ctf			= nil
	meu_siege		= nil
	meu_surv		= nil
	meu_tdm			= nil
	meu_campaign	= nil
	
	SSVxGTH		= nil
	SSVxCOL		= nil
	EVGxGTH		= nil
	EVGxCOL		= nil
	
	shep_soldier		= nil
	shep_infiltrator	= nil
	shep_engineer		= nil
	shep_adept			= nil
	shep_sentinel		= nil
	shep_vanguard		= nil
	
	coop_soldier		= nil
	coop_infiltrator	= nil
	coop_engineer		= nil
	coop_adept			= nil
	coop_sentinel		= nil
	coop_vanguard		= nil
	
	gethprime_me2	= nil
	gethprime_me3	= nil
	
	colgeneral	= nil
	
	ssv_inf_soldier		= nil
	ssv_inf_infiltrator	= nil
	ssv_inf_adept		= nil
	ssv_inf_engineer	= nil
	ssv_inf_sentinel	= nil
	ssv_inf_vanguard	= nil
	
	gth_inf_trooper			= nil
	gth_inf_rocketeer		= nil
	gth_inf_sniper			= nil
	gth_inf_machinist		= nil
	gth_inf_hunter			= nil
	gth_inf_shock			= nil
	gth_inf_shock_online	= nil
	gth_inf_destroyer		= nil
	gth_inf_juggernaut		= nil
	
	col_inf_guardian		= nil
	col_inf_guardian_online	= nil
	
	gth_ev_inf_trooper		= nil
	gth_ev_inf_infiltrator	= nil
	gth_ev_inf_rocketeer	= nil
	gth_ev_inf_engineer		= nil
	gth_ev_inf_hunter		= nil
	gth_ev_inf_pyro			= nil
	gth_ev_inf_juggernaut	= nil
	
	snd_REP_cpCapture_ally	= nil
	snd_REP_cpCapture_enemy	= nil
	snd_REP_cpLost_ally		= nil
	snd_REP_cpLost_enemy	= nil
	
	snd_CIS_cpCapture_ally	= nil
	snd_CIS_cpCapture_enemy	= nil
	snd_CIS_cpLost_ally		= nil
	snd_CIS_cpLost_enemy	= nil
	
	snd_SSV_cpCapture_ally	= nil
	snd_SSV_cpCapture_enemy	= nil
	snd_SSV_cpLost_ally		= nil
	snd_SSV_cpLost_enemy	= nil

	snd_GTH_cpCapture_ally	= nil
	snd_GTH_cpCapture_enemy	= nil
	snd_GTH_cpLost_ally		= nil
	snd_GTH_cpLost_enemy	= nil

	snd_COL_cpCapture_ally	= nil
	snd_COL_cpCapture_enemy	= nil
	snd_COL_cpLost_ally		= nil
	snd_COL_cpLost_enemy	= nil
	
	snd_EVG_cpCapture_ally	= nil
	snd_EVG_cpCapture_enemy	= nil
	snd_EVG_cpLost_ally		= nil
	snd_EVG_cpLost_enemy	= nil
	
	shieldDropCnt		= nil
	team1ticketstring	= nil
	team2ticketstring	= nil
	ssvEngCnt			= nil
	BroShepClass		= nil
	SSVHeroClass		= nil
	GTHHeroClass		= nil
	COLHeroClass		= nil
	EVGHeroClass		= nil
	DecideCOLHeroClass	= nil
	DecideEVGHeroClass	= nil
	DecideGTHHeroClass	= nil
	DecideSSVHeroClass	= nil
	MusicVariation		= nil
	
	DecideMus02StartVar		= nil
	DecideMus02MidVar		= nil
	DecideMus02EndVar		= nil
	DecideMus04Var			= nil
	DecideMus05Var			= nil
	DecideMus06Var			= nil
	
	-- Load custom scripts, designer-specified globals & player stats points
	if isLowG == 1 then
		ScriptCB_DoFile("ME5_globals_lowg")
	else
		ScriptCB_DoFile("ME5_globals")
	end
	ScriptCB_DoFile("ME5_points")
	ScriptCB_DoFile("ME5_ConfigCheck")
	--ScriptCB_DoFile("ME5_HUD_LowHealth")
	ScriptCB_DoFile("ME5_MiscFunctions")
	ScriptCB_DoFile("ME5_RandomSides")
	ScriptCB_DoFile("ME5_AudioFunctions")
	ScriptCB_DoFile("ME5_UtilityFunctions")
	--ScriptCB_DoFile("ME5_LowHealthIFS")
	
	if ME5_CustomHUD == 1 then
		-- HUD font stuff
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\scr_hud_fontfix.lvl")
		ReadDataFile("common.lvl")
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\scr_hud_stockifs.lvl")
		ReadDataFile("common.lvl")
	end

--cbRandomTest = ScriptCB_random()
--print("ME5_Master.cbRandomTest: Output = "..cbRandomTest)


	-- Declare global info variables
		xxs	= 1
		xs	= 2
		sm	= 3
		med	= 4
		lg	= 5
		
		meu_1flag		= 1
		meu_con			= 2
		meu_ctf			= 3
		meu_siege		= 4
		meu_surv		= 5
		meu_tdm			= 6
		meu_campaign	= 7
		
		SSVxGTH	= 1
		SSVxCOL	= 2
		EVGxGTH	= 3
		EVGxCOL	= 4
		
		shep_soldier	 = 1
		shep_infiltrator = 2
		shep_engineer	 = 3
		shep_adept		 = 4
		shep_sentinel	 = 5
		shep_vanguard	 = 6
		
		gethprime_me2	= 1
		gethprime_me3	= 2
		
		colgeneral	= 1
		
		gethprime_me3	= 1
		
		snd_SSV_cpCapture_ally	= "ssv_adm_com_report_captured_commandpost"
		snd_SSV_cpCapture_enemy	= "ssv_adm_com_report_enemyCaptured_commandpost"
		snd_SSV_cpLost_ally		= "ssv_adm_com_report_lost_commandpost"
		snd_SSV_cpLost_enemy	= "ssv_adm_com_report_enemyLost_commandpost"

		snd_GTH_cpCapture_ally	= "gth_ann_com_report_captured_commandpost"
		snd_GTH_cpCapture_enemy	= "gth_ann_com_report_enemyCaptured_commandpost"
		snd_GTH_cpLost_ally		= "gth_ann_com_report_lost_commandpost"
		snd_GTH_cpLost_enemy	= "gth_ann_com_report_enemyLost_commandpost"

		snd_COL_cpCapture_ally	= "col_gen_com_report_captured_commandpost"
		snd_COL_cpCapture_enemy	= "col_gen_com_report_enemyCaptured_commandpost"
		snd_COL_cpLost_ally		= "col_gen_com_report_lost_commandpost"
		snd_COL_cpLost_enemy	= "col_gen_com_report_enemyLost_commandpost"
		
		snd_EVG_cpCapture_ally	= "evg_prm_com_report_captured_commandpost"
		snd_EVG_cpCapture_enemy	= "evg_prm_com_report_enemyCaptured_commandpost"
		snd_EVG_cpLost_ally		= "evg_prm_com_report_lost_commandpost"
		snd_EVG_cpLost_enemy	= "evg_prm_com_report_enemyLost_commandpost"


	print("ME5_Master: Exited")