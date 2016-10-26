-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Random Sides Script by A. Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: The purpose of script is to simplify the process 
-- of loading the mod's sides.
-- 
-- 
-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_RandomSides: Entered")

-- Calls the functions necessary for the chosen faction combination (based on int var, ME5_SideVar). No params required.
function Init_SideSetup()
	if not ScriptCB_InMultiplayer() then
		if ME5_SideVar == 1 then
			Setup_SSVxGTH()
		elseif ME5_SideVar == 2 then
			Setup_SSVxCOL()
		elseif ME5_SideVar == 3 then
			Setup_EVGxGTH()
		elseif ME5_SideVar == 4 then
			Setup_EVGxCOL()
		end
	else
		if onlineSideVar == 1 then
			Setup_SSVxGTH()
		elseif onlineSideVar == 2 then
			Setup_SSVxCOL()
		elseif onlineSideVar == 3 then
			Setup_EVGxGTH()
		elseif onlineSideVar == 4 then
			Setup_EVGxCOL()
		end
	end
end

function Setup_SSVxGTH()
	LoadSSV()
	LoadGTH()
	
	if mapSize == 1 then
			print("ME5_RandomSides.Setup_SSVxGTH(): Map size is xxs")
		Setup_SSVxGTH_xxs()
	elseif mapSize == 2 then
			print("ME5_RandomSides.Setup_SSVxGTH(): Map size is xs")
		Setup_SSVxGTH_xs()
	elseif mapSize == 3 then
			print("ME5_RandomSides.Setup_SSVxGTH(): Map size is sm")
		Setup_SSVxGTH_sm()
	elseif mapSize == 4 then
			print("ME5_RandomSides.Setup_SSVxGTH(): Map size is med")
		Setup_SSVxGTH_med()
	elseif mapSize == 5 then
			print("ME5_RandomSides.Setup_SSVxGTH(): Map size is lg")
		Setup_SSVxGTH_lg()
	else
		print("ME5_RandomSides.Setup_SSVxGTH(): ALL YOUR MAP SIZE ARE BELONG TO US!!")
	end
	
	if ScriptCB_InMultiplayer() then
		if onlineHeroSSV == 1 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online SSV hero is Shepard Soldier")
			SetHeroClass(REP, "ssv_hero_shepard_soldier")
		elseif onlineHeroSSV == 2 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online SSV hero is Shepard Infiltrator")
			SetHeroClass(REP, "ssv_hero_shepard_infiltrator")
		elseif onlineHeroSSV == 3 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online SSV hero is Shepard Engineer")
			SetHeroClass(REP, "ssv_hero_shepard_engineer")
		elseif onlineHeroSSV == 4 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online SSV hero is Shepard Adept")
			SetHeroClass(REP, "ssv_hero_shepard_adept")
		elseif onlineHeroSSV == 5 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online SSV hero is Shepard Sentinel")
			SetHeroClass(REP, "ssv_hero_shepard_sentinel")
		elseif onlineHeroSSV == 6 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online SSV hero is Shepard Vanguard")
			SetHeroClass(REP, "ssv_hero_shepard_vanguard")
		end
		
		if onlineHeroGTH == 1 then
				print("ME5_RandomSides.Setup_SSVxGTH(): Online GTH hero is ME2 Geth Prime")
			SetHeroClass(CIS, "gth_hero_prime_me2")
		end
	end
	
	--[[if REP == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.ssv"
	elseif REP == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.ssv"
	end
	
	if CIS == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.gth"
	elseif CIS == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.gth"
	end]]
end

function Setup_SSVxCOL()
	LoadSSV()
	LoadCOL()
	
	if mapSize == 1 then
			print("ME5_RandomSides.Setup_SSVxCOL(): Map size is xxs")
		Setup_SSVxCOL_xxs()
	elseif mapSize == 2 then
			print("ME5_RandomSides.Setup_SSVxCOL(): Map size is xs")
		Setup_SSVxCOL_xs()
	elseif mapSize == 3 then
			print("ME5_RandomSides.Setup_SSVxCOL(): Map size is sm")
		Setup_SSVxCOL_sm()
	elseif mapSize == 4 then
			print("ME5_RandomSides.Setup_SSVxCOL(): Map size is med")
		Setup_SSVxCOL_med()
	elseif mapSize == 5 then
			print("ME5_RandomSides.Setup_SSVxCOL(): Map size is lg")
		Setup_SSVxCOL_lg()
	else
		print("ME5_RandomSides.Setup_SSVxCOL(): ALL YOUR MAP SIZE ARE BELONG TO US!!")
	end
	
	if ScriptCB_InMultiplayer() then
		if onlineHeroSSV == 1 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online SSV hero is Shepard Soldier")
			SetHeroClass(REP, "ssv_hero_shepard_soldier")
		elseif onlineHeroSSV == 2 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online SSV hero is Shepard Infiltrator")
			SetHeroClass(REP, "ssv_hero_shepard_infiltrator")
		elseif onlineHeroSSV == 3 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online SSV hero is Shepard Engineer")
			SetHeroClass(REP, "ssv_hero_shepard_engineer")
		elseif onlineHeroSSV == 4 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online SSV hero is Shepard Adept")
			SetHeroClass(REP, "ssv_hero_shepard_adept")
		elseif onlineHeroSSV == 5 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online SSV hero is Shepard Sentinel")
			SetHeroClass(REP, "ssv_hero_shepard_sentinel")
		elseif onlineHeroSSV == 6 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online SSV hero is Shepard Vanguard")
			SetHeroClass(REP, "ssv_hero_shepard_vanguard")
		end
		
		if onlineHeroCOL == 1 then
				print("ME5_RandomSides.Setup_SSVxCOL(): Online COL hero is Harby")
			SetHeroClass(CIS, "col_hero_harbinger")
		end
	end
	
	--[[if REP == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.ssv"
	elseif REP == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.ssv"
	end
	
	if CIS == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.col"
	elseif CIS == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.col"
	end]]
end

function Setup_EVGxGTH()
	LoadEVGxGTH()
	
	if mapSize == 1 then
			print("ME5_RandomSides.Setup_EVGxGTH(): Map size is xxs")
		Setup_EVGxGTH_xxs()
	elseif mapSize == 2 then
			print("ME5_RandomSides.Setup_EVGxGTH(): Map size is xs")
		Setup_EVGxGTH_xs()
	elseif mapSize == 3 then
			print("ME5_RandomSides.Setup_EVGxGTH(): Map size is sm")
		Setup_EVGxGTH_sm()
	elseif mapSize == 4 then
			print("ME5_RandomSides.Setup_EVGxGTH(): Map size is med")
		Setup_EVGxGTH_med()
	elseif mapSize == 5 then
			print("ME5_RandomSides.Setup_EVGxGTH(): Map size is lg")
		Setup_EVGxGTH_lg()
	else
		print("ME5_RandomSides.Setup_EVGxGTH(): ALL YOUR MAP SIZE ARE BELONG TO US!!")
	end
	
	if ScriptCB_InMultiplayer() then
		if onlineHeroEVG == 1 then
				print("ME5_RandomSides.Setup_EVGxGTH(): Online EVG hero is Geth Prime")
			SetHeroClass(REP, "gth_hero_prime_me3")
		end
		
		if onlineHeroGTH == 1 then
				print("ME5_RandomSides.Setup_EVGxGTH(): Online GTH hero is ME2 Geth Prime")
			SetHeroClass(CIS, "gth_hero_prime_me2")
		end
	end
	
	--[[if REP == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.ssv"
	elseif REP == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.ssv"
	end
	
	if CIS == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.gth"
	elseif CIS == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.gth"
	end]]
end

function Setup_EVGxCOL()
	LoadEVG()
	LoadCOL()
	
	if mapSize == 1 then
			print("ME5_RandomSides.Setup_EVGxCOL(): Map size is xxs")
		Setup_EVGxCOL_xxs()
	elseif mapSize == 2 then
			print("ME5_RandomSides.Setup_EVGxCOL(): Map size is xs")
		Setup_EVGxCOL_xs()
	elseif mapSize == 3 then
			print("ME5_RandomSides.Setup_EVGxCOL(): Map size is sm")
		Setup_EVGxCOL_sm()
	elseif mapSize == 4 then
			print("ME5_RandomSides.Setup_EVGxCOL(): Map size is med")
		Setup_EVGxCOL_med()
	elseif mapSize == 5 then
			print("ME5_RandomSides.Setup_EVGxCOL(): Map size is lg")
		Setup_EVGxCOL_lg()
	else
		print("ME5_RandomSides.Setup_EVGxCOL(): ALL YOUR MAP SIZE ARE BELONG TO US!!")
	end
	
	if ScriptCB_InMultiplayer() then
		if onlineHeroEVG == 1 then
				print("ME5_RandomSides.Setup_EVGxCOL(): Online EVG hero is Geth Prime")
			SetHeroClass(REP, "gth_hero_prime_me3")
		end
		
		if onlineHeroCOL == 1 then
				print("ME5_RandomSides.Setup_EVGxCOL(): Online COL hero is Harby")
			SetHeroClass(CIS, "col_hero_harbinger")
		end
	end
	
	--[[if REP == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.ssv"
	elseif REP == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.ssv"
	end
	
	if CIS == 1 then
		team1ticketstring = "level.common.events.con.ticketboost.gth"
	elseif CIS == 2 then
		team2ticketstring = "level.common.events.con.ticketboost.gth"
	end]]
end

-- Loads the appropriate data files for the Systems Alliance faction.
function LoadSSV(loadCooper)
	print("ME5_RandomSides.LoadSSV(): Entered")
	
	if not loadCooper then
		loadCooper = false
	end
	
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
				"ssv_fly_a61_gunship",
				"ssv_inf_soldier",
				"ssv_inf_infiltrator",
				"ssv_inf_adept",
				"ssv_inf_engineer",
				"ssv_inf_sentinel",
				"ssv_inf_vanguard",
				"ssv_inf_drone_combat",
				"ssv_hero_jack",
				"ssv_hero_legion",
				"ssv_hero_samara",
				"ssv_hero_shepard",
				"ssv_hero_shepard_soldier",
				"ssv_hero_shepard_infiltrator",
				"ssv_hero_shepard_engineer",
				"ssv_hero_shepard_adept",
				"ssv_hero_shepard_sentinel",
				"ssv_hero_shepard_vanguard",
				"ssv_tread_mako",
				"weap_tech_combatdrone_ssv_rigged")]]
	
	if (string.find(SSVHeroClass, "shepard") and (loadCooper == false)) then
		print("ME5_RandomSides.LoadSSV(): Loading SHEPARD data files...")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_Shepard_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading sounds")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading meshes/textures")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Char.lvl", "units", "shepard")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Misc.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading unit/weapon classes")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_SSV.lvl", "units", "shepard")
		
		
	elseif (string.find(SSVHeroClass, "cooper") or (loadCooper == true)) then
		print("ME5_RandomSides.LoadSSV(): Loading COOPER data files...")
		--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_Cooper_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading sounds")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading meshes/textures")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Char.lvl", "units", "cooper")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Misc.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading unit/weapon classes")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_SSV.lvl", "units", "cooper")
		
		
	elseif (string.find(SSVHeroClass, "jack") and (loadCooper == false)) then
		print("ME5_RandomSides.LoadSSV(): Loading JACK data files...")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_Jack_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading sounds")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading meshes/textures")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Char.lvl", "units", "jack")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Misc.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading unit/weapon classes")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_SSV.lvl", "units", "jack")
		
		
	elseif (string.find(SSVHeroClass, "legion") and (loadCooper == false)) then
		print("ME5_RandomSides.LoadSSV(): Loading LEGION data files...")
		--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_Legion_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading sounds")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading meshes/textures")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Char.lvl", "units", "legion")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Misc.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading unit/weapon classes")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_SSV.lvl", "units", "legion")
		
		
	elseif (string.find(SSVHeroClass, "samara") and (loadCooper == false)) then
		print("ME5_RandomSides.LoadSSV(): Loading SAMARA data files...")
		--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_Samara_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading sounds")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_NonStreaming.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading meshes/textures")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Char.lvl", "units", "samara")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Misc.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading unit/weapon classes")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_SSV.lvl", "units", "samara")
	else
		print("ME5_RandomSides.LoadSSV(): Loading normal data files...")
		print("ME5_RandomSides.LoadSSV(): Loading meshes/textures")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Char.lvl", "units")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_SSV_Misc.lvl")
		
		print("ME5_RandomSides.LoadSSV(): Loading unit/weapon classes")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_SSV.lvl", "units")
	end
	
	if EnvironmentType == EnvTypeDesert then
		print("ME5_RandomSides.LoadSSV(): Loading SSV environment type Desert")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv_desert.lvl")
		
	elseif EnvironmentType == EnvTypeJungle then
		print("ME5_RandomSides.LoadSSV(): Loading SSV environment type Jungle")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv_jungle.lvl")
		
	elseif EnvironmentType == EnvTypeSnow then
		print("ME5_RandomSides.LoadSSV(): Loading SSV environment type Snow")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv_snow.lvl")
		
	elseif EnvironmentType == EnvTypeUrban then
		print("ME5_RandomSides.LoadSSV(): Loading SSV environment type Urban")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv_urban.lvl")
	else
		print("ME5_RandomSides.LoadSSV(): No environment type specified... Defaulting to SSV Urban instead")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv_urban.lvl")
	end
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
			print("ME5_RandomSides.LoadSSV(): Configuring SSV Shield Functionality for AUTO-REGEN...")
			
			ssv_inf_soldier		= "ssv_inf_soldier_shield"
			if IsCampaign() then
				ssv_inf_infiltrator	= "ssv_inf_infiltrator_shield_campaign"
			else
				ssv_inf_infiltrator	= "ssv_inf_infiltrator_shield"
			end
			ssv_inf_adept		= "ssv_inf_adept_shield"
			ssv_inf_engineer	= "ssv_inf_engineer_shield"
			ssv_inf_sentinel	= "ssv_inf_sentinel_shield"
			ssv_inf_vanguard	= "ssv_inf_vanguard_shield"
		elseif ME5_ShieldFunc == 2 then
			print("ME5_RandomSides.LoadSSV(): Configuring SSV Shield Functionality for PICKUPS...")
			
			ssv_inf_soldier		= "ssv_inf_soldier"
			if IsCampaign() then
				ssv_inf_infiltrator	= "ssv_inf_infiltrator_campaign"
			else
				ssv_inf_infiltrator	= "ssv_inf_infiltrator"
			end
			ssv_inf_adept		= "ssv_inf_adept"
			ssv_inf_engineer	= "ssv_inf_engineer"
			ssv_inf_sentinel	= "ssv_inf_sentinel"
			ssv_inf_vanguard	= "ssv_inf_vanguard"
		else
			print("ME5_RandomSides.LoadSSV(): Error! ME5_ShieldFunc setting is invalid! Defaulting to SSV Shield Functionality for AUTO-REGEN")
			
			ssv_inf_soldier		= "ssv_inf_soldier_shield"
			if IsCampaign() then
				ssv_inf_infiltrator	= "ssv_inf_infiltrator_shield_campaign"
			else
				ssv_inf_infiltrator	= "ssv_inf_infiltrator_shield"
			end
			ssv_inf_adept		= "ssv_inf_adept_shield"
			ssv_inf_engineer	= "ssv_inf_engineer_shield"
			ssv_inf_sentinel	= "ssv_inf_sentinel_shield"
			ssv_inf_vanguard	= "ssv_inf_vanguard_shield"
		end
	else
		print("ME5_RandomSides.LoadSSV(): Configuring SSV Shield Functionality for AUTO-REGEN...")
		
		ssv_inf_soldier		= "ssv_inf_soldier_shield"
		ssv_inf_infiltrator	= "ssv_inf_infiltrator_shield"
		ssv_inf_adept		= "ssv_inf_adept_shield"
		ssv_inf_engineer	= "ssv_inf_engineer_shield"
		ssv_inf_sentinel	= "ssv_inf_sentinel_shield"
		ssv_inf_vanguard	= "ssv_inf_vanguard_shield"
	end
	
	print("ME5_RandomSides.LoadSSV(): Loading localization")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coressv.lvl")
	
	print("ME5_RandomSides.LoadSSV(): Exited")
end

function LoadSSVspa()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
				"ssv_inf_pilot",
				"ssv_fly_recon",
				"ssv_fly_fighter",
				"ssv_fly_bomber")
				
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coressv.lvl")
end

-- Loads the appropriate data files for the Heretic Geth faction.
function LoadGTH()
	print("ME5_RandomSides.LoadGTH(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	print("ME5_RandomSides.LoadGTH(): Loading sounds")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_GTH_NonStreaming.lvl")
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
				"gth_hero_prime_me2",
				"gth_inf_trooper",
				"gth_inf_rocketeer",
				"gth_inf_sniper",
				"gth_inf_machinist",
				"gth_inf_hunter",
				"gth_inf_shock",
				"gth_inf_shock_online",
				"gth_inf_destroyer",
				"gth_inf_juggernaut")]]
	
	print("ME5_RandomSides.LoadGTH(): Loading meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Misc.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Prime.lvl")
	
	--print("ME5_RandomSides.LoadGTH(): Loading particle effects")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_GTH_Misc.lvl")
	
	print("ME5_RandomSides.LoadGTH(): Loading unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_GTH.lvl;CON_GTH_her")
	
	print("ME5_RandomSides.LoadGTH(): Loading Husk meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_INDOC_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_INDOC_Misc.lvl")
	
	print("ME5_RandomSides.LoadGTH(): Loading Husk unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_INDOC.lvl")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
			print("ME5_RandomSides.LoadGTH(): Configuring GTH Shield Functionality for AUTO-REGEN...")
			gth_inf_trooper			= "gth_inf_trooper_shield"
			gth_inf_rocketeer		= "gth_inf_rocketeer_shield"
			gth_inf_sniper			= "gth_inf_sniper_shield"
			gth_inf_machinist		= "gth_inf_machinist_shield"
			if IsCampaign() then
				gth_inf_hunter	= "gth_inf_hunter_shield_campaign"
			else
				gth_inf_hunter	= "gth_inf_hunter_shield"
			end
			gth_inf_hunter			= "gth_inf_hunter_shield"
			gth_inf_shock			= "gth_inf_shock_shield"
			gth_inf_shock_online	= "gth_inf_shock_online_shield"
			gth_inf_destroyer		= "gth_inf_destroyer_shield"
			gth_inf_juggernaut		= "gth_inf_juggernaut_shield"
			gth_inf_prime			= "gth_inf_prime_shield"
			
		elseif ME5_ShieldFunc == 2 then
			print("ME5_RandomSides.LoadGTH(): Configuring GTH Shield Functionality for PICKUPS...")
			gth_inf_trooper			= "gth_inf_trooper"
			gth_inf_rocketeer		= "gth_inf_rocketeer"
			gth_inf_sniper			= "gth_inf_sniper"
			gth_inf_machinist		= "gth_inf_machinist"
			if IsCampaign() then
				gth_inf_hunter	= "gth_inf_hunter_campaign"
			else
				gth_inf_hunter	= "gth_inf_hunter"
			end
			gth_inf_shock			= "gth_inf_shock"
			gth_inf_shock_online	= "gth_inf_shock_online"
			gth_inf_destroyer		= "gth_inf_destroyer"
			gth_inf_juggernaut		= "gth_inf_juggernaut"
			gth_inf_prime			= "gth_inf_prime"
			
		else
			print("ME5_RandomSides.LoadGTH(): Error! ME5_ShieldFunc setting is invalid! Defaulting to GTH Shield Functionality for AUTO-REGEN")
			gth_inf_trooper			= "gth_inf_trooper_shield"
			gth_inf_rocketeer		= "gth_inf_rocketeer_shield"
			gth_inf_sniper			= "gth_inf_sniper_shield"
			gth_inf_machinist		= "gth_inf_machinist_shield"
			if IsCampaign() then
				gth_inf_hunter	= "gth_inf_hunter_shield_campaign"
			else
				gth_inf_hunter	= "gth_inf_hunter_shield"
			end
			gth_inf_shock			= "gth_inf_shock_shield"
			gth_inf_shock_online	= "gth_inf_shock_online_shield"
			gth_inf_destroyer		= "gth_inf_destroyer_shield"
			gth_inf_juggernaut		= "gth_inf_juggernaut_shield"
			gth_inf_prime			= "gth_inf_prime_shield"
			
		end
	else
		print("ME5_RandomSides.LoadGTH(): Configuring GTH Shield Functionality for AUTO-REGEN...")
		gth_inf_trooper			= "gth_inf_trooper_shield"
		gth_inf_rocketeer		= "gth_inf_rocketeer_shield"
		gth_inf_sniper			= "gth_inf_sniper_shield"
		gth_inf_machinist		= "gth_inf_machinist_shield"
		if IsCampaign() then
			gth_inf_hunter	= "gth_inf_hunter_shield_campaign"
		else
			gth_inf_hunter	= "gth_inf_hunter_shield"
		end
		gth_inf_shock			= "gth_inf_shock_shield"
		gth_inf_shock_online	= "gth_inf_shock_online_shield"
		gth_inf_destroyer		= "gth_inf_destroyer_shield"
		gth_inf_juggernaut		= "gth_inf_juggernaut_shield"
		gth_inf_prime			= "gth_inf_prime_shield"
	end
	
	print("ME5_RandomSides.LoadGTH(): Loading localization")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coregth.lvl")
	
	print("ME5_RandomSides.LoadGTH(): Exited")
end

-- Loads the appropriate data files for the Collectors faction.
function LoadCOL()
	print("ME5_RandomSides.LoadCOL(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	print("ME5_RandomSides.LoadCOL(): Loading sounds")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_COL_NonStreaming.lvl")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_INDOC_NonStreaming.lvl")
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\col.lvl",
				"col_inf_drone",
				"col_inf_assassin",
				"col_inf_guardian",
				"col_inf_guardian_online",
				"col_inf_scion",
				"col_hero_harbinger",
				"col_fly_oculus")]]
	
	print("ME5_RandomSides.LoadCOL(): Loading meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_COL_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_COL_Misc.lvl")
	
	print("ME5_RandomSides.LoadCOL(): Loading unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_COL.lvl")
	
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\indoc.lvl",
				"indoc_inf_husk",
				"indoc_inf_abomination")]]
	
	print("ME5_RandomSides.LoadCOL(): Loading Husk meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_INDOC_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_INDOC_Misc.lvl")
	
	print("ME5_RandomSides.LoadCOL(): Loading Husk unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_INDOC.lvl")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
				print("ME5_RandomSides.LoadCOL(): Configuring COL Shield Functionality for AUTO-REGEN...")
			col_inf_guardian		= "col_inf_guardian_shield"
			col_inf_guardian_online	= "col_inf_guardian_online_shield"
		elseif ME5_ShieldFunc == 2 then
				print("ME5_RandomSides.LoadCOL(): Configuring COL Shield Functionality for PICKUPS...")
			col_inf_guardian		= "col_inf_guardian"
			col_inf_guardian_online	= "col_inf_guardian_online"
		else
				print("ME5_RandomSides.LoadCOL(): Error! ME5_ShieldFunc setting is invalid! Defaulting to COL Shield Functionality for AUTO-REGEN")
			col_inf_guardian		= "col_inf_guardian_shield"
			col_inf_guardian_online	= "col_inf_guardian_online_shield"
		end
	else
			print("ME5_RandomSides.LoadCOL(): Configuring COL Shield Functionality for AUTO-REGEN...")
		col_inf_guardian		= "col_inf_guardian_shield"
		col_inf_guardian_online	= "col_inf_guardian_online_shield"
	end
	
	print("ME5_RandomSides.LoadCOL(): Loading Collector Ship meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\colship.lvl")
	
	print("ME5_RandomSides.LoadCOL(): Loading localization")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\corecol.lvl")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
	
	print("ME5_RandomSides.LoadCOL(): Exited")
end

-- Loads the appropriate data files for the Heretic Geth and Evolved Geth factions.
function LoadEVGxGTH()
	print("ME5_RandomSides.LoadEVGxGTH(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	print("ME5_RandomSides.LoadEVGxGTH(): Loading sounds")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_GTH_NonStreaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EVG_NonStreaming.lvl")
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
				"gth_hero_prime_me2",
				"gth_inf_trooper",
				"gth_inf_rocketeer",
				"gth_inf_sniper",
				"gth_inf_machinist",
				"gth_inf_hunter",
				"gth_inf_shock",
				"gth_inf_shock_online",
				"gth_inf_destroyer",
				"gth_inf_juggernaut")]]
	
	print("ME5_RandomSides.LoadEVGxGTH(): Loading meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Misc.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Prime.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_EVG_Char.lvl")
	
	--print("ME5_RandomSides.LoadEVGxGTH(): Loading particle effects")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_GTH_Misc.lvl")
	
	print("ME5_RandomSides.LoadEVGxGTH(): Loading unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_GTH.lvl;CON_GTH_her")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_GTH.lvl;CON_GTH_evo")
	
	print("ME5_RandomSides.LoadEVGxGTH(): Loading Husk meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_INDOC_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_INDOC_Misc.lvl")
	
	print("ME5_RandomSides.LoadEVGxGTH(): Loading Husk unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_INDOC.lvl")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
				print("ME5_RandomSides.LoadEVGxGTH(): Configuring GTHxEVG Shield Functionality for AUTO-REGEN...")
			gth_inf_trooper			= "gth_inf_trooper_shield"
			gth_inf_rocketeer		= "gth_inf_rocketeer_shield"
			gth_inf_sniper			= "gth_inf_sniper_shield"
			gth_inf_machinist		= "gth_inf_machinist_shield"
			gth_inf_hunter			= "gth_inf_hunter_shield"
			gth_inf_shock			= "gth_inf_shock_shield"
			gth_inf_shock_online	= "gth_inf_shock_online_shield"
			gth_inf_destroyer		= "gth_inf_destroyer_shield"
			gth_inf_juggernaut		= "gth_inf_juggernaut_shield"
			gth_inf_prime			= "gth_inf_prime_shield"
			
			gth_ev_inf_trooper				= "gth_ev_inf_trooper_shield"
			gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator_shield"
			gth_ev_inf_engineer				= "gth_ev_inf_engineer_shield"
			gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer_shield"
			gth_ev_inf_hunter				= "gth_ev_inf_hunter_shield"
			gth_ev_inf_pyro					= "gth_ev_inf_pyro_shield"
			gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut_shield"
			gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online_shield"
		elseif ME5_ShieldFunc == 2 then
				print("ME5_RandomSides.LoadEVGxGTH(): Configuring GTHxEVG Shield Functionality for PICKUPS...")
			gth_inf_trooper			= "gth_inf_trooper"
			gth_inf_rocketeer		= "gth_inf_rocketeer"
			gth_inf_sniper			= "gth_inf_sniper"
			gth_inf_machinist		= "gth_inf_machinist"
			gth_inf_hunter			= "gth_inf_hunter"
			gth_inf_shock			= "gth_inf_shock"
			gth_inf_shock_online	= "gth_inf_shock_online"
			gth_inf_destroyer		= "gth_inf_destroyer"
			gth_inf_juggernaut		= "gth_inf_juggernaut"
			gth_inf_prime			= "gth_inf_prime"
			
			gth_ev_inf_trooper				= "gth_ev_inf_trooper"
			gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator"
			gth_ev_inf_engineer				= "gth_ev_inf_engineer"
			gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer"
			gth_ev_inf_hunter				= "gth_ev_inf_hunter"
			gth_ev_inf_pyro					= "gth_ev_inf_pyro"
			gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut"
			gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online"
		else
				print("ME5_RandomSides.LoadEVGxGTH(): Error! ME5_ShieldFunc setting is invalid! Defaulting to GTHxEVG Shield Functionality for AUTO-REGEN")
			gth_inf_trooper			= "gth_inf_trooper_shield"
			gth_inf_rocketeer		= "gth_inf_rocketeer_shield"
			gth_inf_sniper			= "gth_inf_sniper_shield"
			gth_inf_machinist		= "gth_inf_machinist_shield"
			gth_inf_hunter			= "gth_inf_hunter_shield"
			gth_inf_shock			= "gth_inf_shock_shield"
			gth_inf_shock_online	= "gth_inf_shock_online_shield"
			gth_inf_destroyer		= "gth_inf_destroyer_shield"
			gth_inf_juggernaut		= "gth_inf_juggernaut_shield"
			gth_inf_prime			= "gth_inf_prime_shield"
			
			gth_ev_inf_trooper				= "gth_ev_inf_trooper_shield"
			gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator_shield"
			gth_ev_inf_engineer				= "gth_ev_inf_engineer_shield"
			gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer_shield"
			gth_ev_inf_hunter				= "gth_ev_inf_hunter_shield"
			gth_ev_inf_pyro					= "gth_ev_inf_pyro_shield"
			gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut_shield"
			gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online_shield"
		end
	else
			print("ME5_RandomSides.LoadEVGxGTH(): Configuring GTH Shield Functionality for AUTO-REGEN...")
		gth_inf_trooper			= "gth_inf_trooper_shield"
		gth_inf_rocketeer		= "gth_inf_rocketeer_shield"
		gth_inf_sniper			= "gth_inf_sniper_shield"
		gth_inf_machinist		= "gth_inf_machinist_shield"
		gth_inf_hunter			= "gth_inf_hunter_shield"
		gth_inf_shock			= "gth_inf_shock_shield"
		gth_inf_shock_online	= "gth_inf_shock_online_shield"
		gth_inf_destroyer		= "gth_inf_destroyer_shield"
		gth_inf_juggernaut		= "gth_inf_juggernaut_shield"
		gth_inf_prime			= "gth_inf_prime_shield"
			
		gth_ev_inf_trooper				= "gth_ev_inf_trooper_shield"
		gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator_shield"
		gth_ev_inf_engineer				= "gth_ev_inf_engineer_shield"
		gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer_shield"
		gth_ev_inf_hunter				= "gth_ev_inf_hunter_shield"
		gth_ev_inf_pyro					= "gth_ev_inf_pyro_shield"
		gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut_shield"
		gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online_shield"
	end
	
	print("ME5_RandomSides.LoadEVGxGTH(): Loading localization")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coreevg.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coregth.lvl")
	
	print("ME5_RandomSides.LoadEVGxGTH(): Exited")
end

-- Loads the appropriate data files for the Evolved Geth faction.
function LoadEVG()
	print("ME5_RandomSides.LoadEVG(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	print("ME5_RandomSides.LoadEVG(): Loading sounds")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_EVG_NonStreaming.lvl")
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
				"gth_hero_prime_me2",
				"gth_inf_trooper",
				"gth_inf_rocketeer",
				"gth_inf_sniper",
				"gth_inf_machinist",
				"gth_inf_hunter",
				"gth_inf_shock",
				"gth_inf_shock_online",
				"gth_inf_destroyer",
				"gth_inf_juggernaut")]]
	
	print("ME5_RandomSides.LoadEVG(): Loading meshes/textures")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_EVG_Char.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Misc.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\GFX_GTH_Prime.lvl")
	
	--print("ME5_RandomSides.LoadEVG(): Loading particle effects")
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_GTH_Misc.lvl")
	
	print("ME5_RandomSides.LoadEVG(): Loading unit/weapon classes")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_GTH.lvl;CON_GTH_evo")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_ShieldFunc == 1 then
				print("ME5_RandomSides.LoadEVG(): Configuring EVG Shield Functionality for AUTO-REGEN...")
			gth_ev_inf_trooper				= "gth_ev_inf_trooper_shield"
			gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator_shield"
			gth_ev_inf_engineer				= "gth_ev_inf_engineer_shield"
			gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer_shield"
			gth_ev_inf_hunter				= "gth_ev_inf_hunter_shield"
			gth_ev_inf_pyro					= "gth_ev_inf_pyro_shield"
			gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut_shield"
			gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online_shield"
		elseif ME5_ShieldFunc == 2 then
				print("ME5_RandomSides.LoadEVG(): Configuring EVG Shield Functionality for PICKUPS...")
			gth_ev_inf_trooper				= "gth_ev_inf_trooper"
			gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator"
			gth_ev_inf_engineer				= "gth_ev_inf_engineer"
			gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer"
			gth_ev_inf_hunter				= "gth_ev_inf_hunter"
			gth_ev_inf_pyro					= "gth_ev_inf_pyro"
			gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut"
			gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online"
		else
				print("ME5_RandomSides.LoadEVG(): Error! ME5_ShieldFunc setting is invalid! Defaulting to EVG Shield Functionality for AUTO-REGEN")
			gth_ev_inf_trooper				= "gth_ev_inf_trooper_shield"
			gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator_shield"
			gth_ev_inf_engineer				= "gth_ev_inf_engineer_shield"
			gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer_shield"
			gth_ev_inf_hunter				= "gth_ev_inf_hunter_shield"
			gth_ev_inf_pyro					= "gth_ev_inf_pyro_shield"
			gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut_shield"
			gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online_shield"
		end
	else
			print("ME5_RandomSides.LoadEVG(): Configuring EVG Shield Functionality for AUTO-REGEN...")
		gth_ev_inf_trooper				= "gth_ev_inf_trooper_shield"
		gth_ev_inf_infiltrator			= "gth_ev_inf_infiltrator_shield"
		gth_ev_inf_engineer				= "gth_ev_inf_engineer_shield"
		gth_ev_inf_rocketeer			= "gth_ev_inf_rocketeer_shield"
		gth_ev_inf_hunter				= "gth_ev_inf_hunter_shield"
		gth_ev_inf_pyro					= "gth_ev_inf_pyro_shield"
		gth_ev_inf_juggernaut			= "gth_ev_inf_juggernaut_shield"
		gth_ev_inf_juggernaut_online	= "gth_ev_inf_juggernaut_online_shield"
	end
	
	print("ME5_RandomSides.LoadEVG(): Loading localization")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coreevg.lvl")
	
	print("ME5_RandomSides.LoadEVG(): Exited")
end

-- Loads the appropriate data files for the Eclipse faction.
function LoadECL()
	print("ME5_RandomSides.LoadECL(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
				"gth_inf_rocketeer")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\eclipse.lvl",
				"eclipse_inf_commando",
    			"eclipse_inf_engineer",
    			"eclipse_inf_heavy",
				"eclipse_inf_LOKI",
    			"eclipse_inf_operative",
				"eclipse_inf_trooper",
				"eclipse_inf_vanguard",
				"eclipse_inf_YMIR")
				
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coreecl.lvl")
	
	print("ME5_RandomSides.LoadECL(): Exited")
end

-- Loads the appropriate data files for the Reaper Forces faction.
function LoadRPR()
	print("ME5_RandomSides.LoadRPR(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_INDOC_NonStreaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\indoc.lvl",
				"indoc_inf_husk",
				"indoc_inf_abomination",
				"indoc_inf_cannibal",
				"indoc_inf_marauder")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\col.lvl",
				"col_inf_scion")
				
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\corerpr.lvl")
	
	print("ME5_RandomSides.LoadRPR(): Exited")
end

-- Loads the appropriate data files for the Cerberus faction.
function LoadCER()
	print("ME5_RandomSides.LoadCER(): Entered")
	
	--SetAIDifficulty(-3, 3)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\cer.lvl",
				"cer_inf_trooper",
				"cer_inf_nemesis",
				"cer_inf_engineer",
				"cer_inf_centurion",
				"cer_inf_phantom")
				
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\corecer.lvl")
	
	print("ME5_RandomSides.LoadCER(): Exited")
end

--[[function ObjectiveSurvival_125tick()
		print("ME5_RandomSides: ObjectiveSurvival_125tick()")
		local ObjectiveSurvivalDebugStr = "ME5_RandomSides: Changing ticket counts to 100 for Survival..."
	if ObjectiveSurvivalHasRan == 1 then
		SetReinforcementCount(1, 125)
		SetReinforcementCount(2, 125)
			print(ObjectiveSurvivalDebugStr)
	else 
		print("ME5_RandomSides: BY THE GODDESS, WHAT ON THESSIA IS HAPPENING")
	end
end]]

function Setup_SSVxGTH_xxs()
		print("ME5_RandomSides.Setup_SSVxGTH_xxs(): Entered")
	--Setup_SSVxGTH_xxs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 7,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,2, 3},
			sniper  = { ssv_inf_infiltrator,1, 3},
			adept = { ssv_inf_adept,1, 3},
			engineer   = { ssv_inf_engineer,1, 3},
			sentinel = { ssv_inf_sentinel,1, 3},
			vanguard = { ssv_inf_vanguard,1, 3},	
		},
		
		cis = {
			team = CIS,
			units = 6,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,1, 6},
			assault  = { gth_inf_rocketeer,1, 4},
			sniper = { gth_inf_sniper,1, 4},
			engineer = { gth_inf_machinist,1, 4},
			hunter   = { gth_inf_hunter,1, 3},
			shock  = { gth_inf_shock,1, 3},
			destroyer = { gth_inf_destroyer,1, 2},
			juggernaut = { gth_inf_juggernaut,1, 2},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 7,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,2, 3},
			sniper  = { ssv_inf_infiltrator,1, 3},
			adept = { ssv_inf_adept,1, 3},
			engineer   = { ssv_inf_engineer,1, 3},
			sentinel = { ssv_inf_sentinel,1, 3},
			vanguard = { ssv_inf_vanguard,1, 3},	
		},
		
		cis = {
			team = CIS,
			units = 6,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,1, 6},
			assault  = { gth_inf_rocketeer,1, 4},
			sniper = { gth_inf_sniper,1, 4},
			engineer = { gth_inf_machinist,1, 4},
			hunter   = { gth_inf_hunter,1, 3},
			shock  = { gth_inf_shock_online,1, 3},
			destroyer = { gth_inf_destroyer,1, 2},
			juggernaut = { gth_inf_juggernaut,1, 2},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 1)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxCOL_xxs()
		print("ME5_RandomSides.Setup_SSVxCOL_xxs(): Entered")
	--Setup_SSVxCOL_xxs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVCOL_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
			rep = {
			team = REP,
			units = 6,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,1, 8},
			sniper  = { ssv_inf_infiltrator,1, 8},
			adept = { ssv_inf_adept,1, 8},
			engineer   = { ssv_inf_engineer,1, 8},
			sentinel = { ssv_inf_sentinel,1, 8},
			vanguard = { ssv_inf_vanguard,1, 8},	
		},
		
		cis = {
			team = CIS,
			units = 5,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",2, 25},
			assault  = { "col_inf_assassin",1, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian,1, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	else
		SetupTeams{
			rep = {
			team = REP,
			units = 6,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,1, 8},
			sniper  = { ssv_inf_infiltrator,1, 8},
			adept = { ssv_inf_adept,1, 8},
			engineer   = { ssv_inf_engineer,1, 8},
			sentinel = { ssv_inf_sentinel,1, 8},
			vanguard = { ssv_inf_vanguard,1, 8},	
		},
		
		cis = {
			team = CIS,
			units = 5,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",2, 25},
			assault  = { "col_inf_assassin",1, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian_online,1, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 2)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--SetHeroClass(CIS, "col_hero_harbinger")
end

function Setup_EVGxGTH_xxs()
		print("ME5_RandomSides.Setup_EVGxGTH_xxs(): Entered")
	--Setup_SSVxGTH_xxs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 7,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,1, 6},
			sniper = { gth_ev_inf_infiltrator,1, 4},
			assault  = { gth_ev_inf_rocketeer,1, 4},
			engineer = { gth_ev_inf_engineer,1, 4},
			hunter   = { gth_ev_inf_hunter,1, 3},
			destroyer = { gth_ev_inf_pyro,1, 2},
			juggernaut = { gth_ev_inf_juggernaut,1, 2},
		},
		
		cis = {
			team = CIS,
			units = 6,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,1, 6},
			assault  = { gth_inf_rocketeer,1, 4},
			sniper = { gth_inf_sniper,1, 4},
			engineer = { gth_inf_machinist,1, 4},
			hunter   = { gth_inf_hunter,1, 3},
			shock  = { gth_inf_shock,1, 3},
			destroyer = { gth_inf_destroyer,1, 2},
			juggernaut = { gth_inf_juggernaut,1, 2},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 7,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,1, 6},
			sniper = { gth_ev_inf_infiltrator,1, 4},
			assault  = { gth_ev_inf_rocketeer,1, 4},
			engineer = { gth_ev_inf_engineer,1, 4},
			hunter   = { gth_ev_inf_hunter,1, 3},
			destroyer = { gth_ev_inf_pyro,1, 2},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 2},
		},
		
		cis = {
			team = CIS,
			units = 6,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,1, 6},
			assault  = { gth_inf_rocketeer,1, 4},
			sniper = { gth_inf_sniper,1, 4},
			engineer = { gth_inf_machinist,1, 4},
			hunter   = { gth_inf_hunter,1, 3},
			shock  = { gth_inf_shock_online,1, 3},
			destroyer = { gth_inf_destroyer,1, 2},
			juggernaut = { gth_inf_juggernaut,1, 2},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 1)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_EVGxCOL_xxs()
		print("ME5_RandomSides.Setup_EVGxCOL_xxs(): Entered")
	--Setup_SSVxGTH_xxs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 7,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,1, 6},
			sniper = { gth_ev_inf_infiltrator,1, 4},
			assault  = { gth_ev_inf_rocketeer,1, 4},
			engineer = { gth_ev_inf_engineer,1, 4},
			hunter   = { gth_ev_inf_hunter,1, 3},
			destroyer = { gth_ev_inf_pyro,1, 2},
			juggernaut = { gth_ev_inf_juggernaut,1, 2},
		},
		
		cis = {
			team = CIS,
			units = 8,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",3, 25},
			assault  = { "col_inf_assassin",2, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian,2, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 7,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,1, 6},
			sniper = { gth_ev_inf_infiltrator,1, 4},
			assault  = { gth_ev_inf_rocketeer,1, 4},
			engineer = { gth_ev_inf_engineer,1, 4},
			hunter   = { gth_ev_inf_hunter,1, 3},
			destroyer = { gth_ev_inf_pyro,1, 2},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 2},
		},
		
		cis = {
			team = CIS,
			units = 8,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",3, 25},
			assault  = { "col_inf_assassin",2, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian_online,2, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 2)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxGTH_xs()
		print("ME5_RandomSides.Setup_SSVxGTH_xs(): Entered")
	--Setup_SSVxGTH_xs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,2, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,2, 8},
			engineer   = { ssv_inf_engineer,2, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},
		},
		
		cis = {
			team = CIS,
			units = 11,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,2, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,1, 8},
			engineer = { gth_inf_machinist,1, 8},
			hunter   = { gth_inf_hunter,2, 6},
			shock  = { gth_inf_shock,1, 6},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,2, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,2, 8},
			engineer   = { ssv_inf_engineer,2, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},
		},
		
		cis = {
			team = CIS,
			units = 11,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,2, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,1, 8},
			engineer = { gth_inf_machinist,1, 8},
			hunter   = { gth_inf_hunter,2, 6},
			shock  = { gth_inf_shock_online,1, 6},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 2)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 2)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxCOL_xs()
		print("ME5_RandomSides.Setup_SSVxCOL_xs(): Entered")
	--Setup_SSVxCOL_xs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVCOL_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,2, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,2, 8},
			engineer   = { ssv_inf_engineer,2, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},
		},
		
		cis = {
			team = CIS,
			units = 11,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",4, 25},
			assault  = { "col_inf_assassin",3, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian,2, 14},
			scion  = { "col_inf_scion",2, 3},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,2, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,2, 8},
			engineer   = { ssv_inf_engineer,2, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},
		},
		
		cis = {
			team = CIS,
			units = 11,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",4, 25},
			assault  = { "col_inf_assassin",3, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian_online,2, 14},
			scion  = { "col_inf_scion",2, 3},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 2)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--SetHeroClass(CIS, "col_hero_harbinger")
end

function Setup_EVGxGTH_xs()
		print("ME5_RandomSides.Setup_EVGxGTH_xs(): Entered")
	--Setup_SSVxGTH_xs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,3, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,1, 8},
			hunter   = { gth_ev_inf_hunter,2, 6},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 10,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,2, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,1, 8},
			engineer = { gth_inf_machinist,1, 8},
			hunter   = { gth_inf_hunter,1, 6},
			shock  = { gth_inf_shock,1, 6},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,3, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,1, 8},
			hunter   = { gth_ev_inf_hunter,2, 6},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 10,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,2, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,1, 8},
			engineer = { gth_inf_machinist,1, 8},
			hunter   = { gth_inf_hunter,1, 6},
			shock  = { gth_inf_shock_online,1, 6},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 1)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_EVGxCOL_xs()
		print("ME5_RandomSides.Setup_EVGxCOL_xs(): Entered")
	--Setup_SSVxGTH_xs = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,3, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,1, 8},
			hunter   = { gth_ev_inf_hunter,2, 6},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 12,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",4, 25},
			assault  = { "col_inf_assassin",3, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian,3, 14},
			scion  = { "col_inf_scion",2, 3},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 13,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,3, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,1, 8},
			hunter   = { gth_ev_inf_hunter,2, 6},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 12,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",2, 8},
			soldier  = { "col_inf_drone",4, 25},
			assault  = { "col_inf_assassin",3, 7},
			-- special = { "indoc_inf_abomination",2, 8},
			support  = { col_inf_guardian_online,3, 14},
			scion  = { "col_inf_scion",2, 3},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 2)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 1)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxECL_xs()
		print("Load/setup SSV versus ECL - level mode:xs")
	
	--SetTeamAggressiveness(CIS,(0.96))
	--SetTeamAggressiveness(REP,(0.99))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 10,
		reinforcements = 150,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 10,
		reinforcements = 150,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 2},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_GTHxECL_xs()
		print("Load/setup GTH versus ECL - level mode:xs")
	
	--SetTeamAggressiveness(REP,(0.96))
	--SetTeamAggressiveness(CIS,(0.99))
	
	SetupTeams{
	cis = {
		team = CIS,
		units = 13,
		reinforcements = 150,
		soldier  = { gth_inf_trooper,9, 20},
		assault  = { gth_inf_rocketeer,3, 8},
		sniper = { gth_inf_sniper,3, 8},
		engineer = { gth_inf_machinist,3, 8},
		hunter   = { gth_inf_hunter,5, 6},
		shock  = { gth_inf_shock,4, 6},
		destroyer = { gth_inf_destroyer,2, 4},
		juggernaut = { gth_inf_juggernaut,1, 4},
	},
	
	imp = {
		team = REP,
		units = 10,
		reinforcements = 150,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 2},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxRPR_xs()
		print("Load/setup SSV versus RPR - level mode:xs")
	
	--SetTeamAggressiveness(REP,(0.99))
	--SetTeamAggressiveness(CIS,(0.96))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 10,
		reinforcements = 150,
		soldier  = { ssv_inf_soldier,2, 8},
		sniper  = { ssv_inf_infiltrator,2, 8},
		adept = { ssv_inf_adept,2, 8},
		engineer   = { ssv_inf_engineer,2, 8},
		sentinel = { ssv_inf_sentinel,2, 8},
		vanguard = { ssv_inf_vanguard,2, 8},
	},
	
	imp = {
		team = CIS,
		units = 10,
		reinforcements = 150,
		husk  = { "indoc_inf_husk",7, 12},
		soldier  = { "indoc_inf_cannibal",9, 16},
		assault  = { "indoc_inf_marauder",6, 10},
		support = { "indoc_inf_abomination",4, 8},
		scion = { "col_inf_scion",1, 4},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxCER_xs()
		print("Load/setup SSV versus CER - level mode:xs")
	
	--SetTeamAggressiveness(REP,(0.99))
	--SetTeamAggressiveness(CIS,(0.99))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 10,
		reinforcements = 150,
		soldier  = { ssv_inf_soldier,2, 8},
		sniper  = { ssv_inf_infiltrator,2, 8},
		adept = { ssv_inf_adept,2, 8},
		engineer   = { ssv_inf_engineer,2, 8},
		sentinel = { ssv_inf_sentinel,2, 8},
		vanguard = { ssv_inf_vanguard,2, 8},
	},
	
	imp = {
		team = CIS,
		units = 10,
		reinforcements = 150,
		soldier  = { "cer_inf_trooper",8, 12},
		sniper  = { "cer_inf_nemesis",6, 9},
		engineer = { "cer_inf_engineer",6, 9},
		officer   = { "cer_inf_centurion",5, 8},
		special   = { "cer_inf_phantom",3, 6},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxGTH_sm()
		print("ME5_RandomSides.Setup_SSVxGTH_sm(): Entered")
	--Setup_SSVxGTH_sm = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 15,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,3, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,3, 8},
			engineer   = { ssv_inf_engineer,3, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},	
		},
		
		cis = {
			team = CIS,
			units = 15,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,4, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,1, 9},
			hunter   = { gth_inf_hunter,2, 7},
			shock  = { gth_inf_shock,2, 7},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 15,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,3, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,3, 8},
			engineer   = { ssv_inf_engineer,3, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},	
		},
		
		cis = {
			team = CIS,
			units = 15,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,4, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,1, 9},
			hunter   = { gth_inf_hunter,2, 7},
			shock  = { gth_inf_shock_online,2, 7},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 3)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 3)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxCOL_sm()
		print("ME5_RandomSides.Setup_SSVxCOL_sm(): Entered")
	--Setup_SSVxCOL_sm = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVCOL_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
			rep = {
			team = REP,
			units = 15,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,3, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,3, 8},
			engineer   = { ssv_inf_engineer,3, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},	
		},
		
		cis = {
			team = CIS,
			units = 13,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",3, 8},
			soldier  = { "col_inf_drone",5, 25},
			assault  = { "col_inf_assassin",3, 7},
			-- special = { "indoc_inf_abomination",3, 8},
			support  = { col_inf_guardian,3, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	else
		SetupTeams{
			rep = {
			team = REP,
			units = 15,
			reinforcements = 150,
			soldier  = { ssv_inf_soldier,3, 8},
			sniper  = { ssv_inf_infiltrator,2, 8},
			adept = { ssv_inf_adept,3, 8},
			engineer   = { ssv_inf_engineer,3, 8},
			sentinel = { ssv_inf_sentinel,2, 8},
			vanguard = { ssv_inf_vanguard,2, 8},	
		},
		
		cis = {
			team = CIS,
			units = 13,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",3, 8},
			soldier  = { "col_inf_drone",5, 25},
			assault  = { "col_inf_assassin",3, 7},
			-- special = { "indoc_inf_abomination",3, 8},
			support  = { col_inf_guardian_online,3, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 3)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 2)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--SetHeroClass(CIS, "col_hero_harbinger")
end

function Setup_EVGxGTH_sm()
		print("ME5_RandomSides.Setup_EVGxGTH_sm(): Entered")
	--Setup_SSVxGTH_sm = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 17,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,5, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,2, 9},
			hunter   = { gth_ev_inf_hunter,3, 7},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 13,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,3, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,1, 9},
			hunter   = { gth_inf_hunter,1, 7},
			shock  = { gth_inf_shock,2, 7},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 17,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,5, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,2, 9},
			hunter   = { gth_ev_inf_hunter,3, 7},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 13,
			reinforcements = 150,
			soldier  = { gth_inf_trooper,3, 20},
			assault  = { gth_inf_rocketeer,2, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,1, 9},
			hunter   = { gth_inf_hunter,1, 7},
			shock  = { gth_inf_shock_online,2, 7},
			destroyer = { gth_inf_destroyer,1, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 2)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 2)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_EVGxCOL_sm()
		print("ME5_RandomSides.Setup_EVGxCOL_sm(): Entered")
	--Setup_SSVxGTH_sm = 1
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 17,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,5, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,2, 9},
			hunter   = { gth_ev_inf_hunter,3, 7},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 16,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",3, 8},
			soldier  = { "col_inf_drone",6, 25},
			assault  = { "col_inf_assassin",4, 7},
			-- special = { "indoc_inf_abomination",3, 8},
			support  = { col_inf_guardian,3, 14},
			scion  = { "col_inf_scion",2, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 17,
			reinforcements = 150,
			soldier  = { gth_ev_inf_trooper,5, 20},
			sniper = { gth_ev_inf_infiltrator,3, 8},
			rocketeer  = { gth_ev_inf_rocketeer,2, 8},
			engineer = { gth_ev_inf_engineer,2, 9},
			hunter   = { gth_ev_inf_hunter,3, 7},
			destroyer = { gth_ev_inf_pyro,1, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 16,
			reinforcements = 150,
			-- husk  = { "indoc_inf_husk",3, 8},
			soldier  = { "col_inf_drone",6, 25},
			assault  = { "col_inf_assassin",4, 7},
			-- special = { "indoc_inf_abomination",3, 8},
			support  = { col_inf_guardian_online,3, 14},
			scion  = { "col_inf_scion",2, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 3)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 2)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxECL_sm()
		print("Load/setup SSV versus ECL - level mode:sm")
	
	--SetTeamAggressiveness(CIS,(0.96))
	--SetTeamAggressiveness(REP,(0.99))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 16,
		reinforcements = 150,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 16,
		reinforcements = 150,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 2},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_GTHxECL_sm()
		print("Load/setup GTH versus ECL - level mode:sm")
	
	--SetTeamAggressiveness(REP,(0.96))
	--SetTeamAggressiveness(CIS,(0.99))
	
	SetupTeams{
	cis = {
		team = CIS,
		units = 19,
		reinforcements = 150,
		soldier  = { gth_inf_trooper,9, 20},
		assault  = { gth_inf_rocketeer,3, 8},
		sniper = { gth_inf_sniper,3, 8},
		engineer = { gth_inf_machinist,3, 9},
		hunter   = { gth_inf_hunter,5, 7},
		shock  = { gth_inf_shock,4, 7},
		destroyer = { gth_inf_destroyer,2, 4},
		juggernaut = { gth_inf_juggernaut,1, 4},
	},
	
	imp = {
		team = REP,
		units = 16,
		reinforcements = 150,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 2},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxRPR_sm()
		print("Load/setup SSV versus RPR - level mode:sm")
	
	--SetTeamAggressiveness(REP,(0.99))
	--SetTeamAggressiveness(CIS,(0.96))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 16,
		reinforcements = 150,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 16,
		reinforcements = 150,
		husk  = { "indoc_inf_husk",7, 12},
		soldier  = { "indoc_inf_cannibal",9, 16},
		assault  = { "indoc_inf_marauder",6, 10},
		support = { "indoc_inf_abomination",4, 8},
		scion = { "col_inf_scion",1, 4},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxCER_sm()
		print("Load/setup SSV versus CER - level mode:sm")
	
	--SetTeamAggressiveness(REP,(0.99))
	--SetTeamAggressiveness(CIS,(0.99))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 16,
		reinforcements = 150,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 16,
		reinforcements = 150,
		soldier  = { "cer_inf_trooper",8, 12},
		sniper  = { "cer_inf_nemesis",6, 9},
		engineer = { "cer_inf_engineer",6, 9},
		officer   = { "cer_inf_centurion",5, 8},
		special   = { "cer_inf_phantom",3, 6},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxGTH_med()
		print("ME5_RandomSides.Setup_SSVxGTH_med(): Entered")
	--Setup_SSVxGTH_med = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 22,
			reinforcements = 175,
			soldier  = { ssv_inf_soldier,4, 8},
			sniper  = { ssv_inf_infiltrator,3, 8},
			adept = { ssv_inf_adept,4, 8},
			engineer   = { ssv_inf_engineer,4, 8},
			sentinel = { ssv_inf_sentinel,4, 8},
			vanguard = { ssv_inf_vanguard,3, 8},	
		},
		
		cis = {
			team = CIS,
			units = 23,
			reinforcements = 175,
			soldier  = { gth_inf_trooper,6, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,3, 10},
			hunter   = { gth_inf_hunter,3, 8},
			shock  = { gth_inf_shock,3, 8},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 22,
			reinforcements = 175,
			soldier  = { ssv_inf_soldier,4, 8},
			sniper  = { ssv_inf_infiltrator,3, 8},
			adept = { ssv_inf_adept,4, 8},
			engineer   = { ssv_inf_engineer,4, 8},
			sentinel = { ssv_inf_sentinel,4, 8},
			vanguard = { ssv_inf_vanguard,3, 8},	
		},
		
		cis = {
			team = CIS,
			units = 23,
			reinforcements = 175,
			soldier  = { gth_inf_trooper,6, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,3, 10},
			hunter   = { gth_inf_hunter,3, 8},
			shock  = { gth_inf_shock_online,3, 8},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 4)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 4)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
	--ObjectiveSurvival_125tick()
end

function Setup_SSVxCOL_med()
		print("ME5_RandomSides.Setup_SSVxCOL_med(): Entered")
	--Setup_SSVxCOL_med = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVCOL_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 22,
			reinforcements = 175,
			soldier  = { ssv_inf_soldier,4, 8},
			sniper  = { ssv_inf_infiltrator,3, 8},
			adept = { ssv_inf_adept,4, 8},
			engineer   = { ssv_inf_engineer,4, 8},
			sentinel = { ssv_inf_sentinel,4, 8},
			vanguard = { ssv_inf_vanguard,3, 8},	
		},
		
		cis = {
			team = CIS,
			units = 19,
			reinforcements = 175,
			-- husk  = { "indoc_inf_husk",4, 8},
			soldier  = { "col_inf_drone",9, 25},
			assault  = { "col_inf_assassin",5, 7},
			-- special = { "indoc_inf_abomination",4, 8},
			support  = { col_inf_guardian,4, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 22,
			reinforcements = 175,
			soldier  = { ssv_inf_soldier,4, 8},
			sniper  = { ssv_inf_infiltrator,3, 8},
			adept = { ssv_inf_adept,4, 8},
			engineer   = { ssv_inf_engineer,4, 8},
			sentinel = { ssv_inf_sentinel,4, 8},
			vanguard = { ssv_inf_vanguard,3, 8},	
		},
		
		cis = {
			team = CIS,
			units = 19,
			reinforcements = 175,
			-- husk  = { "indoc_inf_husk",4, 8},
			soldier  = { "col_inf_drone",9, 25},
			assault  = { "col_inf_assassin",5, 7},
			-- special = { "indoc_inf_abomination",4, 8},
			support  = { col_inf_guardian_online,4, 14},
			scion  = { "col_inf_scion",1, 2},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 4)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 3)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--SetHeroClass(CIS, "col_hero_harbinger")
end

function Setup_EVGxGTH_med()
		print("ME5_RandomSides.Setup_EVGxGTH_med(): Entered")
	--Setup_SSVxGTH_med = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 26,
			reinforcements = 175,
			soldier  = { gth_ev_inf_trooper,7, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 10},
			hunter   = { gth_ev_inf_hunter,4, 8},
			destroyer = { gth_ev_inf_pyro,2, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 22,
			reinforcements = 175,
			soldier  = { gth_inf_trooper,5, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,3, 10},
			hunter   = { gth_inf_hunter,3, 8},
			shock  = { gth_inf_shock,3, 8},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 26,
			reinforcements = 175,
			soldier  = { gth_ev_inf_trooper,7, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 10},
			hunter   = { gth_ev_inf_hunter,4, 8},
			destroyer = { gth_ev_inf_pyro,2, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 22,
			reinforcements = 175,
			soldier  = { gth_inf_trooper,5, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,2, 8},
			engineer = { gth_inf_machinist,3, 10},
			hunter   = { gth_inf_hunter,3, 8},
			shock  = { gth_inf_shock_online,3, 8},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 3)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 3)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
	--ObjectiveSurvival_125tick()
end

function Setup_EVGxCOL_med()
		print("ME5_RandomSides.Setup_EVGxCOL_med(): Entered")
	--Setup_SSVxGTH_med = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 26,
			reinforcements = 175,
			soldier  = { gth_ev_inf_trooper,7, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 10},
			hunter   = { gth_ev_inf_hunter,4, 8},
			destroyer = { gth_ev_inf_pyro,2, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 22,
			reinforcements = 175,
			-- husk  = { "indoc_inf_husk",4, 8},
			soldier  = { "col_inf_drone",8, 25},
			assault  = { "col_inf_assassin",6, 7},
			-- special = { "indoc_inf_abomination",4, 8},
			support  = { col_inf_guardian,5, 14},
			scion  = { "col_inf_scion",2, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 26,
			reinforcements = 175,
			soldier  = { gth_ev_inf_trooper,7, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 10},
			hunter   = { gth_ev_inf_hunter,4, 8},
			destroyer = { gth_ev_inf_pyro,2, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 22,
			reinforcements = 175,
			-- husk  = { "indoc_inf_husk",4, 8},
			soldier  = { "col_inf_drone",8, 25},
			assault  = { "col_inf_assassin",6, 7},
			-- special = { "indoc_inf_abomination",4, 8},
			support  = { col_inf_guardian_online,5, 14},
			scion  = { "col_inf_scion",2, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 4)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 3)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 1)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
	--ObjectiveSurvival_125tick()
end

function Setup_SSVxECL_med()
		print("Load/setup SSV versus ECL - level mode:med")
	
	--SetTeamAggressiveness(CIS, 0.96)
	--SetTeamAggressiveness(REP, 0.99)
	
	SetupTeams{
	rep = {
		team = REP,
		units = 24,
		reinforcements = 175,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 24,
		reinforcements = 175,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 3},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_GTHxECL_med()
		print("Load/setup GTH versus ECL - level mode:med")
	
	--SetTeamAggressiveness(REP, 0.96)
	--SetTeamAggressiveness(CIS, 0.99)
	
	SetupTeams{
	cis = {
		team = CIS,
		units = 26,
		reinforcements = 175,
		soldier  = { gth_inf_trooper,9, 20},
		assault  = { gth_inf_rocketeer,3, 8},
		sniper = { gth_inf_sniper,3, 8},
		engineer = { gth_inf_machinist,3, 10},
		hunter   = { gth_inf_hunter,5, 8},
		shock  = { gth_inf_shock,4, 8},
		destroyer = { gth_inf_destroyer,2, 4},
		juggernaut = { gth_inf_juggernaut,1, 4},
	},
	
	imp = {
		team = REP,
		units = 24,
		reinforcements = 175,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 3},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxRPR_med()
		print("Load/setup SSV versus RPR - level mode:med")
	
	--SetTeamAggressiveness(REP, 0.99)
	--SetTeamAggressiveness(CIS, 0.96)
	
	SetupTeams{
	rep = {
		team = REP,
		units = 25,
		reinforcements = 175,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 26,
		reinforcements = 175,
		husk  = { "indoc_inf_husk",7, 12},
		soldier  = { "indoc_inf_cannibal",9, 16},
		assault  = { "indoc_inf_marauder",6, 10},
		support = { "indoc_inf_abomination",4, 8},
		scion = { "col_inf_scion",2, 4},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxCER_med()
		print("Load/setup SSV versus CER - level mode:med")
	
	--SetTeamAggressiveness(REP, 0.99)
	--SetTeamAggressiveness(CIS, 0.99)
	
	SetupTeams{
	rep = {
		team = REP,
		units = 25,
		reinforcements = 175,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 25,
		reinforcements = 175,
		soldier  = { "cer_inf_trooper",8, 12},
		sniper  = { "cer_inf_nemesis",6, 9},
		engineer = { "cer_inf_engineer",6, 9},
		officer   = { "cer_inf_centurion",5, 8},
		special   = { "cer_inf_phantom",4, 7},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxGTH_lg()
		print("ME5_RandomSides.Setup_SSVxGTH_lg(): Entered")
	--Setup_SSVxGTH_lg = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 29,
			reinforcements = 200,
			soldier  = { ssv_inf_soldier,5, 8},
			sniper  = { ssv_inf_infiltrator,5, 8},
			adept = { ssv_inf_adept,5, 8},
			engineer   = { ssv_inf_engineer,5, 8},
			sentinel = { ssv_inf_sentinel,5, 8},
			vanguard = { ssv_inf_vanguard,4, 8},	
		},
		
		cis = {
			team = CIS,
			units = 26,
			reinforcements = 200,
			soldier  = { gth_inf_trooper,7, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,3, 8},
			engineer = { gth_inf_machinist,3, 12},
			hunter   = { gth_inf_hunter,4, 10},
			shock  = { gth_inf_shock,3, 10},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 29,
			reinforcements = 200,
			soldier  = { ssv_inf_soldier,5, 8},
			sniper  = { ssv_inf_infiltrator,5, 8},
			adept = { ssv_inf_adept,5, 8},
			engineer   = { ssv_inf_engineer,5, 8},
			sentinel = { ssv_inf_sentinel,5, 8},
			vanguard = { ssv_inf_vanguard,4, 8},	
		},
		
		cis = {
			team = CIS,
			units = 26,
			reinforcements = 200,
			soldier  = { gth_inf_trooper,7, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,3, 8},
			engineer = { gth_inf_machinist,3, 12},
			hunter   = { gth_inf_hunter,4, 10},
			shock  = { gth_inf_shock_online,3, 10},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 6)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 6)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxCOL_lg()
		print("ME5_RandomSides.Setup_SSVxCOL_lg(): Entered")
	--Setup_SSVxCOL_lg = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVCOL_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 27,
			reinforcements = 200,
			soldier  = { ssv_inf_soldier,5, 8},
			sniper  = { ssv_inf_infiltrator,4, 8},
			adept = { ssv_inf_adept,5, 8},
			engineer   = { ssv_inf_engineer,5, 8},
			sentinel = { ssv_inf_sentinel,4, 8},
			vanguard = { ssv_inf_vanguard,4, 8},	
		},
		
		cis = {
			team = CIS,
			units = 22,
			reinforcements = 200,
			-- husk  = { "indoc_inf_husk",5, 8},
			soldier  = { "col_inf_drone",9, 25},
			assault  = { "col_inf_assassin",7, 10},
			-- special = { "indoc_inf_abomination",5, 8},
			support  = { col_inf_guardian,4, 14},
			scion  = { "col_inf_scion",2, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 27,
			reinforcements = 200,
			soldier  = { ssv_inf_soldier,5, 8},
			sniper  = { ssv_inf_infiltrator,4, 8},
			adept = { ssv_inf_adept,5, 8},
			engineer   = { ssv_inf_engineer,5, 8},
			sentinel = { ssv_inf_sentinel,4, 8},
			vanguard = { ssv_inf_vanguard,4, 8},	
		},
		
		cis = {
			team = CIS,
			units = 22,
			reinforcements = 200,
			-- husk  = { "indoc_inf_husk",5, 8},
			soldier  = { "col_inf_drone",9, 25},
			assault  = { "col_inf_assassin",7, 10},
			-- special = { "indoc_inf_abomination",5, 8},
			support  = { col_inf_guardian_online,4, 14},
			scion  = { "col_inf_scion",2, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 6)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 4)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 2)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--SetHeroClass(CIS, "col_hero_harbinger")
end

function Setup_EVGxGTH_lg()
		print("ME5_RandomSides.Setup_EVGxGTH_lg(): Entered")
	--Setup_SSVxGTH_lg = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 30,
			reinforcements = 200,
			soldier  = { gth_ev_inf_trooper,9, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 12},
			hunter   = { gth_ev_inf_hunter,5, 10},
			destroyer = { gth_ev_inf_pyro,3, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 24,
			reinforcements = 200,
			soldier  = { gth_inf_trooper,6, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,3, 8},
			engineer = { gth_inf_machinist,3, 12},
			hunter   = { gth_inf_hunter,3, 10},
			shock  = { gth_inf_shock,3, 10},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 30,
			reinforcements = 200,
			soldier  = { gth_ev_inf_trooper,9, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 12},
			hunter   = { gth_ev_inf_hunter,5, 10},
			destroyer = { gth_ev_inf_pyro,3, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},	
		},
		
		cis = {
			team = CIS,
			units = 24,
			reinforcements = 200,
			soldier  = { gth_inf_trooper,6, 20},
			assault  = { gth_inf_rocketeer,3, 8},
			sniper = { gth_inf_sniper,3, 8},
			engineer = { gth_inf_machinist,3, 12},
			hunter   = { gth_inf_hunter,3, 10},
			shock  = { gth_inf_shock_online,3, 10},
			destroyer = { gth_inf_destroyer,2, 4},
			juggernaut = { gth_inf_juggernaut,1, 4},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 4)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 4)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_EVGxCOL_lg()
		print("ME5_RandomSides.Setup_EVGxCOL_lg(): Entered")
	--Setup_SSVxGTH_lg = 1
	ssvEngCnt = 8
	
	--ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSVGTH_NonStreaming.lvl")
	if not ScriptCB_InMultiplayer() then
		SetupTeams{
		rep = {
			team = REP,
			units = 30,
			reinforcements = 200,
			soldier  = { gth_ev_inf_trooper,9, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 12},
			hunter   = { gth_ev_inf_hunter,5, 10},
			destroyer = { gth_ev_inf_pyro,3, 4},
			juggernaut = { gth_ev_inf_juggernaut,1, 4},
		},
		
		cis = {
			team = CIS,
			units = 24,
			reinforcements = 200,
			-- husk  = { "indoc_inf_husk",5, 8},
			soldier  = { "col_inf_drone",9, 25},
			assault  = { "col_inf_assassin",7, 10},
			-- special = { "indoc_inf_abomination",5, 8},
			support  = { col_inf_guardian,5, 14},
			scion  = { "col_inf_scion",3, 6},
		}
		}
	else
		SetupTeams{
		rep = {
			team = REP,
			units = 30,
			reinforcements = 200,
			soldier  = { gth_ev_inf_trooper,9, 20},
			sniper = { gth_ev_inf_infiltrator,5, 8},
			rocketeer  = { gth_ev_inf_rocketeer,4, 8},
			engineer = { gth_ev_inf_engineer,3, 12},
			hunter   = { gth_ev_inf_hunter,5, 10},
			destroyer = { gth_ev_inf_pyro,3, 4},
			juggernaut = { gth_ev_inf_juggernaut_online,1, 4},	
		},
		
		cis = {
			team = CIS,
			units = 24,
			reinforcements = 200,
			-- husk  = { "indoc_inf_husk",5, 8},
			soldier  = { "col_inf_drone",9, 25},
			assault  = { "col_inf_assassin",7, 10},
			-- special = { "indoc_inf_abomination",5, 8},
			support  = { col_inf_guardian_online,5, 14},
			scion  = { "col_inf_scion",3, 6},
		}
		}
	end
	
	SetTeamName(HuskTeam, CIS)
	SetTeamIcon(HuskTeam, "cis_icon")
	SetUnitCount(HuskTeam, 6)
	AddUnitClass(HuskTeam, "indoc_inf_husk", 4)
	AddUnitClass(HuskTeam, "indoc_inf_abomination", 2)
	
	SetTeamAsEnemy(REP,HuskTeam)
	SetTeamAsEnemy(HuskTeam,REP)
	SetTeamAsFriend(CIS,HuskTeam)
	SetTeamAsFriend(HuskTeam,CIS)
	
	--[[if not ScriptCB_InMultiplayer() then
		SetHeroClass(CIS, "gth_hero_prime_me2")
	end]]
end

function Setup_SSVxECL_lg()
		print("Load/setup SSV versus ECL - level mode:lg")
	
	--SetTeamAggressiveness(CIS,(0.96))
	--SetTeamAggressiveness(REP,(0.99))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 30,
		reinforcements = 200,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 27,
		reinforcements = 200,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 3},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_GTHxECL_lg()
		print("Load/setup GTH versus ECL - level mode:lg")
	
	--SetTeamAggressiveness(REP,(0.96))
	--SetTeamAggressiveness(CIS,(0.99))
	
	SetupTeams{
	cis = {
		team = CIS,
		units = 30,
		reinforcements = 200,
		soldier  = { gth_inf_trooper,9, 20},
		assault  = { gth_inf_rocketeer,3, 8},
		sniper = { gth_inf_sniper,3, 8},
		engineer = { gth_inf_machinist,3, 12},
		hunter   = { gth_inf_hunter,5, 10},
		shock  = { gth_inf_shock,4, 10},
		destroyer = { gth_inf_destroyer,2, 4},
		juggernaut = { gth_inf_juggernaut,1, 4},
	},
	
	imp = {
		team = REP,
		units = 27,
		reinforcements = 200,
		LOKI = { "eclipse_inf_LOKI",4, 12},
		soldier  = { "eclipse_inf_trooper",6, 10},
		engineer  = { "eclipse_inf_engineer",5, 7},
		adept = { "eclipse_inf_vanguard",4, 6},
		heavy   = { "eclipse_inf_heavy",3, 6},
		operative = { "eclipse_inf_operative",2, 5},
		commando = { "eclipse_inf_commando",1, 3},
		YMIR = { "eclipse_inf_YMIR",1, 3},
	}
	}
	
	-- SetHeroClass(CIS, heroECL)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxRPR_lg()
		print("Load/setup SSV versus RPR - level mode:lg")
	
	--SetTeamAggressiveness(REP,(0.99))
	--SetTeamAggressiveness(CIS,(0.96))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 31,
		reinforcements = 200,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 32,
		reinforcements = 200,
		husk  = { "indoc_inf_husk",7, 12},
		soldier  = { "indoc_inf_cannibal",9, 16},
		assault  = { "indoc_inf_marauder",6, 10},
		support = { "indoc_inf_abomination",4, 8},
		scion = { "col_inf_scion",2, 4},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxCER_lg()
		print("Load/setup SSV versus CER - level mode:lg")
	
	--SetTeamAggressiveness(REP,(0.99))
	--SetTeamAggressiveness(CIS,(0.99))
	
	SetupTeams{
	rep = {
		team = REP,
		units = 32,
		reinforcements = 200,
		soldier  = { ssv_inf_soldier,3, 8},
		sniper  = { ssv_inf_infiltrator,3, 8},
		adept = { ssv_inf_adept,3, 8},
		engineer   = { ssv_inf_engineer,3, 8},
		sentinel = { ssv_inf_sentinel,3, 8},
		vanguard = { ssv_inf_vanguard,3, 8},	
	},
	
	imp = {
		team = CIS,
		units = 32,
		reinforcements = 200,
		soldier  = { "cer_inf_trooper",8, 12},
		sniper  = { "cer_inf_nemesis",6, 9},
		engineer = { "cer_inf_engineer",6, 9},
		officer   = { "cer_inf_centurion",5, 8},
		special   = { "cer_inf_phantom",5, 8},
	}
	}
	
	-- SetHeroClass(CIS, heroGTH)
	-- SetHeroClass(REP, heroSSV)
end

function Setup_SSVxSUN_spa()
	SetupTeams{
	rep = {
		team = REP,
		units = 32,
		reinforcements = -1,
		pilot    = { "ssv_inf_pilot",32},
		
	},
	cis = {
		team = CIS,
		units = 32,
		reinforcements = -1,
		pilot    = { "ssv_inf_pilot",32},
	}
	}
end

--[[function HuskTeam_COL()
	SupportTeamSSV = 3;
end

function SupportTeams_GTH()
	SupportTeamGTH1 = 4;
end]]

--[[function HuskTeam_COLxGTH()
	HuskTeam_COL()
	SupportTeams_GTH()
end

function SupportTeamSetup_SSV()
	SetTeamName(SupportSSV, "SupportSSV")
	SetTeamIcon(SupportSSV, "rep_icon")
	SetUnitCount(SupportSSV, 23)
	AddUnitClass(SupportSSV, "weap_tech_combatdrone_ssv_rigged", 23)
	
	SetTeamAsNeutral(REP,SupportSSV)
	SetTeamAsNeutral(SupportSSV,REP)
	SetTeamAsEnemy(CIS,SupportSSV)
	SetTeamAsEnemy(SupportSSV,CIS)
end

function SupportTeamSetup_GTH()
	SetTeamName(4, "SupportGTH1")
	SetTeamIcon(4, "cis_icon")
	SetUnitCount(4, 1)
	AddUnitClass(4, "weap_tech_combatdrone_gth_rigged", 1)
	
	SetTeamAsFriend(CIS,4)
	SetTeamAsFriend(4,CIS)
	SetTeamAsEnemy(REP,4)
	SetTeamAsEnemy(4,REP)
end

function SupportTeamSetup_SSVxGTH()
	SupportTeamSetup_SSV()
	SupportTeamSetup_GTH()
end]]

function Drones_SSV()
	-- Setup the team that will spawn in ScriptInit(), include the SetTeamAsFriend() stuff
	-- Add this code into ScriptPostLoad() once for each team that can spawn stuff (changing a couple of variables each time)
	-- Add an AIGoal for the spawned team somewhere in ScriptPostLoad() so the spawned character will actually do something
	
	TroopSpawnerWeapon = "weap_tech_combatdrone_ssv"
	local droneID = 0
	
	OnCharacterDispenseControllableTeam(
		function(character, controlled)
			if GetEntityClass(controlled) == GetEntityClassPtr(TroopSpawnerWeapon) then
					print("Drones_SSV(): Current spawner team size = "..GetTeamSize(REP))
				
				droneID = droneID + 1
					print("Drones_SSV(): Current droneID = "..droneID)
				
				local droneIndex = GetTeamMember(SupportSSV, droneID)
				local droneUnit = GetCharacterUnit(droneIndex) -- currently unused
				local spawnerPos = GetEntityMatrix(GetCharacterUnit(character))
				SetEntityMatrix(droneIndex, spawnerPos)
				
				if droneID >= GetTeamSize(REP) then
					droneID = 0
						print("Drones_SSV(): droneID limit of "..GetTeamSize(REP).." was reached; resetting counter")
				end
			end
		end,
	REP
	)
	
	--[[TroopSpawnerWeapon = "weap_tech_combatdrone_ssv"
	
	OnCharacterDispenseControllableTeam(
		function(character,controlled)
			if GetEntityClass(controlled) == GetEntityClassPtr(TroopSpawnerWeapon) then
				local SupportSSV = 3
				local teamSize = GetTeamSize(SupportSSV)
				--SupportGoal1a = AddAIGoal(SupportSSV, "Follow", 100, 0)
				--SupportGoal1b = AddAIGoal(SupportSSV, "Defend", 300, 0)
				SupportGoal1c = AddAIGoal(SupportSSV, "Deathmatch", 500)
				for i = 0, 0 do		-- for i = 0, teamSize-1 do
					local characterIndex = GetTeamMember(SupportSSV, i)
					local charUnit = GetCharacterUnit(characterIndex)
					if not charUnit then
						local destination = GetEntityMatrix(GetCharacterUnit(character))
						SpawnCharacter(characterIndex,destination)
					end
				end
			end
		end,
	REP
	)]]
end

function Drones_GTH()
	
end

function Drones_SSVxGTH()
	Drones_SSV()
	Drones_GTH()
end


print("ME5_RandomSides: Exited")