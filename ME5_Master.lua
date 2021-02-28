-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by Aaron Gilbert
-- Build 40404/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Apr 4, 2017
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About: 
--  This is MEU's master include script. It sets some global variables and loads the other scripts.
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_Master: Entered")

-- The build version. Valid settings are "production", "release"
MEU_BuildVer		= "production"
MEU_BuildNum		= "80219/07"
MEU_ReleaseNum		= "7"
MEU_VersionNum		= "1.4"

print("ME5_Master: Mass Effect: Unification is currently running on Build "..MEU_BuildNum..", Release "..MEU_ReleaseNum..", Version "..MEU_VersionNum)

print("ME5_Master: Performing garbage collection...")

ME5_AIHeroes			= nil
ME5_CarnageMode			= nil
ME5_CustomGUIEnabled	= nil
ME5_CustomHUD			= nil
ME5_Difficulty			= nil
ME5_FactionVO			= nil
ME5_HealthFunc			= nil
ME5_HeroClassCOL		= nil
ME5_HeroClassEVG		= nil
ME5_HeroClassGTH		= nil
ME5_HeroClassSSV		= nil
ME5_HitMarkerSound		= nil
ME5_KillSound			= nil
ME5_LowHealthSound		= nil
ME5_MapVarEDN			= nil
ME5_MapVarVRM			= nil
ME5_PlayerDmgSound		= nil
ME5_ShepardClass		= nil
ME5_ShepardGender		= nil
ME5_ShieldFunc			= nil
ME5_ShieldRegen			= nil
ME5_SideVar				= nil
ME5_SolMapMusic			= nil

gCurrentMapManager			= nil
gVoiceStream				= nil
bVoiceStreamKeepClosed		= false

-- Set to false if not already set
gLoadCooper = gLoadCooper or false

--mapSize				= nil
MEU_GameMode		= MEU_GameMode or nil
--environmentType		= nil
--onlineSideVar		= nil
--onlineHeroSSV		= nil
--onlineHeroGTH		= nil
--onlineHeroCOL		= nil
--onlineHeroEVG		= nil

xxs		= nil
xs		= nil
sm		= nil
med		= nil
lg		= nil
xl		= nil

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

rpr_inf_marauder		= nil
rpr_inf_banshee			= nil

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
DecidedCOLHeroClass	= nil
DecidedEVGHeroClass	= nil
DecidedGTHHeroClass	= nil
DecidedSSVHeroClass	= nil
MusicVariation		= nil

DecideMus02StartVar		= nil
DecideMus02MidVar		= nil
DecideMus02EndVar		= nil
DecideMus04Var			= nil
DecideMus05Var			= nil
DecideMus06Var			= nil


-- Declare constants
MAX_FACTION_COUNT			= 5		-- Number of factions.
MAX_SSV_HERO_COUNT			= 2		-- Number of Systems Alliance heroes.
MAX_GTH_HERO_COUNT			= 2		-- Number of Heretic Geth heroes.
MAX_COL_HERO_COUNT			= 1		-- Number of Collector heroes.
MAX_EVG_HERO_COUNT			= 2		-- Number of Evolved Geth heroes.
MAX_SHEP_CLASS_COUNT		= 6		-- Number of Shepard's unit classes.
MAX_SHEP_GENDER_COUNT		= 1		-- Number of Shepard's genders.

MAX_FLAG_ITEM_COUNT			= 512		-- Number of FlagItem entities.
MAX_PORTABLE_TURRET_COUNT	= 100		-- Number of PortableTurret entities.
NUM_RAVAGERS				= 0			-- Number of Ravager units.
BRUTE_KILL_HEALTH_REGEN		= 35		-- Amount of health to reheal a Brute by whenever it makes a kill.

UNIT_HEALTH_REGEN_RATE		= 4.0	-- Regen rate for auto-regenerating health.


-- Declare global enum variables
xxs	= 1
xs	= 2
sm	= 3
med	= 4
lg	= 5
xl	= 6

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
SSVxRPR	= 5

EnvTypeDesert	= 1
EnvTypeJungle	= 2
EnvTypeSnow		= 3
EnvTypeUrban	= 4

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

-- CP voice over strings
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


-- Load custom scripts, designer-specified globals & player stats points
if isLowG == 1 then
	ScriptCB_DoFile("ME5_globals_lowg")
else
	ScriptCB_DoFile("ME5_globals")
end
ScriptCB_DoFile("ME5_points")
ScriptCB_DoFile("ME5_ConfigCheck")
--ScriptCB_DoFile("ME5_HUD_LowHealth")
ScriptCB_DoFile("ME5_HealthShieldFunc")
ScriptCB_DoFile("ME5_DamageFeedback")
ScriptCB_DoFile("ME5_KillSounds")
ScriptCB_DoFile("ME5_LowHealthFeedback")
ScriptCB_DoFile("ME5_GethJuggernautFunc")
ScriptCB_DoFile("ME5_Weapons")
ScriptCB_DoFile("ME5_MapManager")
ScriptCB_DoFile("ME5_RandomSides")
ScriptCB_DoFile("ME5_AudioFunctions")
ScriptCB_DoFile("ME5_UtilityFunctions")
--ScriptCB_DoFile("ME5_LowHealthIFS")


-- HUD font stuff
if ME5_CustomHUD == 1 then
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\scr_hud_fontfix.lvl")
	ReadDataFile("common.lvl")
else
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\scr_hud_stockifs.lvl")
	ReadDataFile("common.lvl")
end


print("ME5_Master: Exited")