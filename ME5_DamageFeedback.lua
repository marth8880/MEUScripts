-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Damage Feedback Script by Aaron Gilbert
-- Build 40216/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Feb 16, 2017
-- Copyright (c) 2017, Aaron Gilbert All rights reserved.
-- 
-- About:
--  This script contains various functions regarding player and enemy damage feedback.
-- 
-- 
-- Usage:
--  Simply call Init_PlayerDamageFeedback() or Init_HitMarkerSounds() anywhere in ScriptInit().
-- 
-- 
-- Legal:
--  This script is licensed under the BSD 3-Clause License. A copy of this license (as LICENSE.md) should have been included
--  with this script. If it wasn't, it can also be found here: https://www.w3.org/Consortium/Legal/2008/03-bsd-license.html
--  
--  THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_DamageFeedback: Entered")


--==========================
-- INITIALIZE TABLES
--==========================

-- TODO: make sure to update these tables when adding new weapons/units/vehicles!

-- Ballistic weapons.
local ballisticWeapons = {
				"col_weap_inf_rifle_col",
				"col_weap_inf_rifle_col_colgen",
				"col_weap_inf_rifle_col_shredder",
				"col_weap_inf_rifle_colcarbine",
				"col_weap_inf_rifle_colcarbine_colgen",
				"col_weap_inf_shotgun_pulse",
				"col_weap_inf_shouldercannon",
				
				"gth_weap_bldg_assaultdrone",
				"gth_weap_bldg_gethturret",
				"gth_weap_inf_heavy_spitfire",
				"gth_weap_inf_rifle_m76",
				"gth_weap_inf_rifle_m76_boss",
				"gth_weap_inf_rifle_pulse",
				"gth_weap_inf_shotgun_m23",
				"gth_weap_inf_shotgun_m27",
				"gth_weap_inf_shotgun_plasma",
				"gth_weap_inf_smg_pulse",
				"gth_weap_inf_sniper_javelin",
				"gth_weap_inf_sniper_m97",
				"gth_weap_walk_colussus_gun",
				
				"rpr_weap_inf_armcannon",
				"rpr_weap_inf_rifle_phaeston",
				
				"ssv_weap_fly_a61_gunship_gun",
				"ssv_weap_fly_a61_gunship_missile_launcher",
				"ssv_weap_inf_heavy_spitfire",
				"ssv_weap_inf_pistol_m3",
				"ssv_weap_inf_pistol_m3_armor",
				"ssv_weap_inf_pistol_m3_disruptor",
				"ssv_weap_inf_pistol_m3_incendiary",
				"ssv_weap_inf_pistol_m5",
				"ssv_weap_inf_pistol_m5_incendiary",
				"ssv_weap_inf_pistol_m6",
				"ssv_weap_inf_pistol_m77",
				"ssv_weap_inf_pistol_n7eagle",
				"ssv_weap_inf_pistol_n7eagle_armor",
				"ssv_weap_inf_pistol_n7eagle_incendiary",
				"ssv_weap_inf_rifle_m8",
				"ssv_weap_inf_rifle_m8_armor",
				"ssv_weap_inf_rifle_m8_disruptor",
				"ssv_weap_inf_rifle_m8_incendiary",
				"ssv_weap_inf_rifle_m15",
				"ssv_weap_inf_rifle_m76",
				"ssv_weap_inf_rifle_m96",
				"ssv_weap_inf_shotgun_m23",
				"ssv_weap_inf_shotgun_m23_armor",
				"ssv_weap_inf_shotgun_m23_disruptor",
				"ssv_weap_inf_shotgun_m23_incendiary",
				"ssv_weap_inf_shotgun_m27",
				"ssv_weap_inf_shotgun_m27_disruptor",
				"ssv_weap_inf_shotgun_n7crusader",
				"ssv_weap_inf_shotgun_n7crusader_incendiary",
				"ssv_weap_inf_shotgun_plasma",
				"ssv_weap_inf_smg_m4",
				"ssv_weap_inf_smg_m4_disruptor",
				"ssv_weap_inf_smg_m9",
				"ssv_weap_inf_smg_m9_armor",
				"ssv_weap_inf_smg_m9_disruptor",
				"ssv_weap_inf_smg_m9_incendiary",
				"ssv_weap_inf_smg_m12",
				"ssv_weap_inf_smg_m12_shepard",
				"ssv_weap_inf_smg_n7hurricane",
				"ssv_weap_inf_smg_n7hurricane_disruptor",
				"ssv_weap_inf_sniper_m92",
				"ssv_weap_inf_sniper_m92_armor",
				"ssv_weap_inf_sniper_m92_disruptor",
				"ssv_weap_inf_sniper_m92_incendiary",
				"ssv_weap_inf_sniper_m97",
				"ssv_weap_inf_sniper_m97_armor",
				"ssv_weap_inf_sniper_m97_disruptor",
				"ssv_weap_inf_sniper_m98",
				"ssv_weap_inf_sniper_m98b",
				"ssv_weap_inf_sniper_m98b_armor",
				"ssv_weap_inf_sniper_n7valiant",
				"ssv_weap_tread_mako_cannon",
				"ssv_weap_tread_mako_driver_cannon",
				"ssv_weap_tread_mako_gun",
				
				"tur_weap_bldg_mturret_cannon",
				"tur_weap_hoth_dishturret",
				"tur_weap_hoth_lasermortar_laser",
				"tur_weap_laser",
}

-- COL ballistic weapons.
local ballisticWeapons_COL = {
				"col_weap_inf_rifle_col",
				"col_weap_inf_rifle_col_colgen",
				"col_weap_inf_rifle_col_shredder",
				"col_weap_inf_rifle_colcarbine",
				"col_weap_inf_rifle_colcarbine_colgen",
				"col_weap_inf_shotgun_pulse",
				"col_weap_inf_shouldercannon",
}

-- EVG ballistic weapons.
local ballisticWeapons_EVG = {
				"gth_weap_bldg_assaultdrone",
				"gth_weap_bldg_gethturret",
				"gth_weap_inf_heavy_ml77",
				"gth_weap_inf_heavy_ml77b",
				"gth_weap_inf_heavy_pulsecannon",
				"gth_weap_inf_heavy_spitfire",
				"gth_weap_inf_rifle_m76",
				"gth_weap_inf_rifle_m76_boss",
				"gth_weap_inf_rifle_pulse",
				"gth_weap_inf_shotgun_m23",
				"gth_weap_inf_shotgun_m27",
				"gth_weap_inf_shotgun_plasma",
				"gth_weap_inf_smg_pulse",
				"gth_weap_inf_sniper_javelin",
				"gth_weap_inf_sniper_m97",
				"gth_weap_walk_colussus_gun",
}

-- GTH ballistic weapons.
local ballisticWeapons_GTH = {
				"gth_weap_bldg_assaultdrone",
				"gth_weap_bldg_gethturret",
				"gth_weap_inf_heavy_distortion",
				"gth_weap_inf_heavy_ml77",
				"gth_weap_inf_heavy_ml77b",
				"gth_weap_inf_heavy_pulsecannon",
				"gth_weap_inf_heavy_scram",
				"gth_weap_inf_heavy_spitfire",
				"gth_weap_inf_rifle_m76",
				"gth_weap_inf_rifle_m76_boss",
				"gth_weap_inf_rifle_pulse",
				"gth_weap_inf_shotgun_m23",
				"gth_weap_inf_shotgun_m27",
				"gth_weap_inf_shotgun_plasma",
				"gth_weap_inf_smg_pulse",
				"gth_weap_inf_sniper_javelin",
				"gth_weap_inf_sniper_m97",
				"gth_weap_walk_colussus_gun",
}

-- RPR ballistic weapons.
local ballisticWeapons_RPR = {
				"rpr_weap_inf_rifle_armcannon",
				"rpr_weap_inf_rifle_phaeston",
				"rpr_weap_inf_ravager_cannons",
}

-- SSV ballistic weapons.
local ballisticWeapons_SSV = {
				"ssv_weap_inf_heavy_m100",
				"ssv_weap_inf_heavy_ml77",
				"ssv_weap_inf_heavy_ml77b",
				"ssv_weap_inf_heavy_spitfire",
				"ssv_weap_inf_pistol_m3_incendiary",
				"ssv_weap_inf_pistol_m5",
				"ssv_weap_inf_pistol_m6",
				"ssv_weap_inf_rifle_m8_disruptor",
				"ssv_weap_inf_shotgun_m23_incendiary",
				"ssv_weap_inf_shotgun_m27",
				"ssv_weap_inf_smg_m4",
				"ssv_weap_inf_smg_m9_disruptor",
				"ssv_weap_inf_smg_m12",
				"ssv_weap_inf_sniper_m92_armor",
}

-- SSV hero ballistic weapons.
local ballisticWeapons_SSV_hero = {}

if string.find(SSVHeroClass, "shepard_soldier") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_rifle_m76",
					"ssv_weap_inf_sniper_n7valiant",
	}
	
elseif string.find(SSVHeroClass, "shepard_infiltrator") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_pistol_n7eagle_armor",
					"ssv_weap_inf_smg_n7hurricane_disruptor",
					"ssv_weap_inf_sniper_m98b_armor",
	}
	
elseif string.find(SSVHeroClass, "shepard_engineer") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_shotgun_plasma",
					"ssv_weap_inf_smg_n7hurricane",
	}
	
elseif string.find(SSVHeroClass, "shepard_adept") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_pistol_n7eagle",
					"ssv_weap_inf_smg_n7hurricane",
	}
	
elseif string.find(SSVHeroClass, "shepard_sentinel") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_pistol_m77",
					"ssv_weap_inf_smg_n7hurricane",
	}
	
elseif string.find(SSVHeroClass, "shepard_vanguard") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_heavy_spitfire",
					"ssv_weap_inf_pistol_n7eagle_incendiary",
					"ssv_weap_inf_shotgun_n7crusader_incendiary",
	}
	
elseif (string.find(SSVHeroClass, "cooper") or (gLoadCooper and gLoadCooper == true)) then
	if IsCampaign() then
		ballisticWeapons_SSV_hero = {
						"ssv_weap_inf_pistol_m3_armor",
						--"ssv_weap_inf_pistol_m3_incendiary",
						--"ssv_weap_inf_pistol_m5",
						--"ssv_weap_inf_pistol_m6",
						"ssv_weap_inf_rifle_m8_disruptor",
						--"ssv_weap_inf_shotgun_m23_incendiary",
						"ssv_weap_inf_shotgun_m27_disruptor",
						--"ssv_weap_inf_smg_m4",
						"ssv_weap_inf_smg_m4_disruptor",
						--"ssv_weap_inf_smg_m9_disruptor",
						--"ssv_weap_inf_smg_m12",
						--"ssv_weap_inf_sniper_m92_armor",
						"ssv_weap_inf_sniper_m97_armor",
		}
	else
		if string.find(SSVHeroClass, "soldier") then
			ballisticWeapons_SSV_hero = {
							"ssv_weap_inf_rifle_m8_disruptor",
							"ssv_weap_inf_shotgun_m27_disruptor",
							"ssv_weap_inf_sniper_m97_armor",
			}
			
		elseif string.find(SSVHeroClass, "infiltrator") then
			ballisticWeapons_SSV_hero = {
							"ssv_weap_inf_pistol_m3_armor",
							--"ssv_weap_inf_smg_m9_disruptor",
							--"ssv_weap_inf_sniper_m92_armor",
			}
			
		elseif string.find(SSVHeroClass, "engineer") then
			ballisticWeapons_SSV_hero = {
							"ssv_weap_inf_shotgun_m27_disruptor",
							"ssv_weap_inf_smg_m4_disruptor",
			}
			
		elseif string.find(SSVHeroClass, "adept") then
			ballisticWeapons_SSV_hero = {
							--"ssv_weap_inf_pistol_m5",
							--"ssv_weap_inf_smg_m4",
			}
			
		elseif string.find(SSVHeroClass, "sentinel") then
			ballisticWeapons_SSV_hero = {
							--"ssv_weap_inf_pistol_m6",
							--"ssv_weap_inf_smg_m12",
			}
			
		elseif string.find(SSVHeroClass, "vanguard") then
			ballisticWeapons_SSV_hero = {
							--"ssv_weap_inf_pistol_m3_incendiary",
							--"ssv_weap_inf_shotgun_m23_incendiary",
			}
		end
	end
	
elseif string.find(SSVHeroClass, "jack") then
	ballisticWeapons_SSV_hero = {
					"ssv_weap_inf_pistol_n7eagle",
					"ssv_weap_inf_shotgun_plasma",
	}
	
elseif string.find(SSVHeroClass, "legion") then
	
	
elseif string.find(SSVHeroClass, "samara") then
	
	
end

-- Turret ballistic weapons.
local ballisticWeapons_TUR = {
				"tur_weap_bldg_mturret_cannon",
				"tur_weap_hoth_dishturret",
				"tur_weap_hoth_lasermortar_laser",
				"tur_weap_laser",
}

-- Vehicle ballistic weapons (for vehicles that any team can pilot).
local ballisticWeapons_VEH = {
				"ssv_weap_fly_a61_gunship_gun",
				"ssv_weap_fly_a61_gunship_missile_launcher",
				"ssv_weap_tread_mako_cannon",
				"ssv_weap_tread_mako_driver_cannon",
				"ssv_weap_tread_mako_gun",
}


--==========================
-- MERGE TABLES
--==========================

-- Merge the SSV hero table with the SSV table
if table.getn(ballisticWeapons_SSV_hero) > 0 then
	for i in ipairs(ballisticWeapons_SSV_hero) do
		table.insert(ballisticWeapons_SSV, ballisticWeapons_SSV_hero[i])
	end
end

-- Merge the TUR table with each faction's table
if table.getn(ballisticWeapons_TUR) > 0 then
	for i in ipairs(ballisticWeapons_TUR) do
		table.insert(ballisticWeapons_COL, ballisticWeapons_TUR[i])
		table.insert(ballisticWeapons_EVG, ballisticWeapons_TUR[i])
		table.insert(ballisticWeapons_GTH, ballisticWeapons_TUR[i])
		table.insert(ballisticWeapons_RPR, ballisticWeapons_TUR[i])
		table.insert(ballisticWeapons_SSV, ballisticWeapons_TUR[i])
	end
end

-- Merge the VEH table with each faction's table
if table.getn(ballisticWeapons_VEH) > 0 then
	for i in ipairs(ballisticWeapons_VEH) do
		table.insert(ballisticWeapons_COL, ballisticWeapons_VEH[i])
		table.insert(ballisticWeapons_EVG, ballisticWeapons_VEH[i])
		table.insert(ballisticWeapons_GTH, ballisticWeapons_VEH[i])
		table.insert(ballisticWeapons_RPR, ballisticWeapons_VEH[i])
		table.insert(ballisticWeapons_SSV, ballisticWeapons_VEH[i])
	end
end


--==========================
-- FUNCTIONS
--==========================

---
-- Sets up the event responses for the player damage sounds.
-- 
function Init_PlayerDamageFeedback()
	print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		local Iamhuman = nil					-- Pointer for human player.
		local bIsDamagerCorrectClass = false	-- Is the damager the correct class?
		local damagerFaction = "none"			-- Which faction is the damager from?
		
		-- COL unit classes.
		local colClasses = {
						"col_inf_assassin",
						"col_inf_drone",
						"col_inf_guardian",
						"col_inf_guardian_shield",
						"col_inf_scion",
						
						"col_hero_harbinger",
		}
		
		-- GTH unit classes.
		local gthClasses = {
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
						"gth_ev_inf_juggernaut_shield",
						
						"gth_hero_prime_me2",
						"gth_hero_prime_me3",
		}
		
		-- INDOC unit classes.
		local indocClasses = {
						"indoc_inf_abomination",
						"indoc_inf_husk",
		}
		
		-- RPR unit classes.
		local rprClasses = {
			"rpr_inf_cannibal",
			"rpr_inf_marauder",
			"rpr_inf_ravager",
			"rpr_inf_brute",
			"rpr_inf_banshee",
		}
		
		-- SSV unit classes.
		local ssvClasses = {
						"ssv_inf_adept",
						"ssv_inf_engineer",
						"ssv_inf_infiltrator",
						"ssv_inf_infiltrator_campaign",
						"ssv_inf_sentinel",
						"ssv_inf_soldier",
						"ssv_inf_vanguard",
						"ssv_inf_adept_shield",
						"ssv_inf_engineer_shield",
						"ssv_inf_infiltrator_shield",
						"ssv_inf_infiltrator_shield_campaign",
						"ssv_inf_sentinel_shield",
						"ssv_inf_soldier_shield",
						"ssv_inf_vanguard_shield",
						
						"ssv_inf_cooper_adept",
						"ssv_inf_cooper_engineer",
						"ssv_inf_cooper_infiltrator",
						"ssv_inf_cooper_sentinel",
						"ssv_inf_cooper_soldier",
						"ssv_inf_cooper_vanguard",
						
						"ssv_hero_shepard_soldier",
						"ssv_hero_shepard_infiltrator",
						"ssv_hero_shepard_engineer",
						"ssv_hero_shepard_adept",
						"ssv_hero_shepard_sentinel",
						"ssv_hero_shepard_vanguard",
						
						"ssv_hero_jack",
		}
		
		
		--==========================
		-- LOCAL FUNCTIONS
		--==========================
		
		local function PlayDamageSound()
			--print("ME5_DamageFeedback.Init_PlayerDamageFeedback.PlayDamageSound(): Playing damage sound")
			
			local randSnd = math.random(0,10)
			ScriptCB_SndPlaySound("player_damage_layered_"..randSnd)
		end
		
		
		--==========================
		-- EVENT RESPONSES
		--==========================
		
		-- When the player spawns
		local playerspawn = OnCharacterSpawn(
			function(player)
				if IsCharacterHuman(player) then
					--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Player spawned")
					Iamhuman = GetEntityPtr(GetCharacterUnit(player))
				end
			end
		)
		
		-- When the player loses health
		local playerdamage = OnObjectDamage(
			function(object, damager)
				-- Abort if the damager or object is nil
				if not damager then return end
				if not object then return end
				if GetCharacterUnit(damager) == nil then return end
				
				-- Was the damaged object the player?
				if Iamhuman == GetEntityPtr(object) then
					if GetCharacterUnit(damager) then
						-- The damager's pointer
						--local charPtr = GetEntityPtr(GetCharacterUnit(damager))
						--local charClass = GetEntityClass(charPtr)
						local damagerTeam = GetCharacterTeam(damager)
						local damagerWeapon = GetObjectLastHitWeaponClass(object)
						
						
						-- Determine the damager's faction
						if ME5_SideVar == 1 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "SSVxGTH") then
							if damagerTeam == REP then
								damagerFaction = "ssv"
							elseif damagerTeam == CIS then
								damagerFaction = "gth"
							end
							
						elseif ME5_SideVar == 2 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "SSVxCOL") then
							if damagerTeam == REP then
								damagerFaction = "ssv"
							elseif damagerTeam == CIS then
								damagerFaction = "col"
							end
							
						elseif ME5_SideVar == 3 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "EVGxGTH") then
							if damagerTeam == REP then
								damagerFaction = "evg"
							elseif damagerTeam == CIS then
								damagerFaction = "gth"
							end
							
						elseif ME5_SideVar == 4 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "EVGxCOL") then
							if damagerTeam == REP then
								damagerFaction = "evg"
							elseif damagerTeam == CIS then
								damagerFaction = "col"
							end
							
						elseif ME5_SideVar == 5 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "SSVxRPR") then
							if damagerTeam == REP then
								damagerFaction = "ssv"
							elseif damagerTeam == CIS then
								damagerFaction = "rpr"
							end
						end
						
						
						-- Which team is the damager from?
						if damagerFaction == "col" then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Damager is from team COL")
							--ShowMessageText("level.common.debug.damager_col")
							
							-- For each weapon class
							for i=1, table.getn(ballisticWeapons_COL) do
								-- Was the weapon used a valid ballistic weapon?
								if damagerWeapon == ballisticWeapons_COL[i] then
									-- Play the player damage sound
									PlayDamageSound()
									break
								end
							end
							
						elseif damagerFaction == "evg" then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Damager is from team EVG")
							--ShowMessageText("level.common.debug.damager_evg")
							
							-- For each weapon class
							for i=1, table.getn(ballisticWeapons_EVG) do
								-- Was the weapon used a valid ballistic weapon?
								if damagerWeapon == ballisticWeapons_EVG[i] then
									-- Play the player damage sound
									PlayDamageSound()
									break
								end
							end
							
						elseif damagerFaction == "gth" then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Damager is from team GTH")
							--ShowMessageText("level.common.debug.damager_gth")
							
							-- For each weapon class
							for i=1, table.getn(ballisticWeapons_GTH) do
								-- Was the weapon used a valid ballistic weapon?
								if damagerWeapon == ballisticWeapons_GTH[i] then
									-- Play the player damage sound
									PlayDamageSound()
									break
								end
							end
							
						elseif damagerFaction == "rpr" then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Damager is from team INDOC")
							--ShowMessageText("level.common.debug.damager_indoc")
							
							-- For each weapon class
							for i=1, table.getn(ballisticWeapons_RPR) do
								-- Was the weapon used a valid ballistic weapon?
								if damagerWeapon == ballisticWeapons_RPR[i] then
									-- Play the player damage sound
									PlayDamageSound()
									break
								end
							end
							
						elseif damagerFaction == "ssv" then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Damager is from team SSV")
							--ShowMessageText("level.common.debug.damager_ssv")
							
							-- For each weapon class
							for i=1, table.getn(ballisticWeapons_SSV) do
								-- Was the weapon used a valid ballistic weapon?
								if damagerWeapon == ballisticWeapons_SSV[i] then
									-- Play the player damage sound if the damager weapon wasn't incendiary
									PlayDamageSound()
									break
								end
							end
							
						end
					end
				end
			end
		)
		
	end
end


---
-- Sets up the event responses for the hit marker sounds.
-- 
function Init_HitMarkerSounds()
	print("ME5_DamageFeedback.Init_HitMarkerSounds(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		local Iamhuman = nil					-- Pointer for human player.
		local bIsDamagerCorrectClass = false	-- Is the damager the correct class?
		local damagerFaction = "none"			-- Which faction is the damager from?
		local weaponType = 1					-- The weapon type. (1 = "normal", 2 = "sniper", 3 = "shotgun", 4 = "gps")
		local bIsIncendiary = false				-- Is the weapon incendiary?
		
		-- COL unit classes.
		local colClasses = {
						"col_inf_assassin",
						"col_inf_drone",
						"col_inf_guardian",
						"col_inf_guardian_shield",
						"col_inf_scion",
						
						"col_hero_harbinger",
		}
		
		-- GTH unit classes.
		local gthClasses = {
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
						"gth_ev_inf_juggernaut_shield",
						
						"gth_hero_prime_me2",
						"gth_hero_prime_me3",
		}
		
		-- INDOC unit classes.
		local indocClasses = {
						"indoc_inf_abomination",
						"indoc_inf_husk",
		}
		
		-- RPR unit classes.
		local rprClasses = {
						"rpr_inf_cannibal",
						"rpr_inf_marauder",
						"rpr_inf_ravager",
						"rpr_inf_brute",
						"rpr_inf_banshee",
		}
		
		-- SSV unit classes.
		local ssvClasses = {
						"ssv_inf_adept",
						"ssv_inf_engineer",
						"ssv_inf_infiltrator",
						"ssv_inf_infiltrator_campaign",
						"ssv_inf_sentinel",
						"ssv_inf_soldier",
						"ssv_inf_vanguard",
						"ssv_inf_adept_shield",
						"ssv_inf_engineer_shield",
						"ssv_inf_infiltrator_shield",
						"ssv_inf_infiltrator_shield_campaign",
						"ssv_inf_sentinel_shield",
						"ssv_inf_soldier_shield",
						"ssv_inf_vanguard_shield",
						
						"ssv_inf_cooper_adept",
						"ssv_inf_cooper_engineer",
						"ssv_inf_cooper_infiltrator",
						"ssv_inf_cooper_sentinel",
						"ssv_inf_cooper_soldier",
						"ssv_inf_cooper_vanguard",
						
						"ssv_hero_shepard_soldier",
						"ssv_hero_shepard_infiltrator",
						"ssv_hero_shepard_engineer",
						"ssv_hero_shepard_adept",
						"ssv_hero_shepard_sentinel",
						"ssv_hero_shepard_vanguard",
						
						"ssv_hero_jack",
		}
		
		-- Armored classes.
		local armorClasses = {
						-- Units
						"col_inf_scion",
						"gth_inf_destroyer",
						"gth_inf_juggernaut",
						"gth_inf_destroyer_shield",
						"gth_inf_juggernaut_shield",
						"gth_ev_inf_pyro",
						"gth_ev_inf_juggernaut",
						"gth_ev_inf_pyro_shield",
						"gth_ev_inf_juggernaut_shield",
						"gth_hero_prime_me2",
						"gth_hero_prime_me3",
						"rpr_inf_ravager",
						"rpr_inf_brute",
						"rpr_inf_banshee",
						
						-- Buildings
						"hoth_bldg_shieldgenerator",
						--"tur_bldg_chaingun_roof",
						--"tur_bldg_chaingun_tripod",
						"tur_bldg_hoth_dishturret",
						"tur_bldg_hoth_lasermortar",
						"tur_bldg_laser",
						"tur_bldg_mturret",
						"tur_bldg_recoilless_lg",
						"tur_bldg_tat_barge",
						"tur_bldg_tower",
						
						-- Vehicles & Deployable Turrets
						"gth_bldg_assaultdrone",
						"gth_bldg_gethturret",
						"gth_bldg_rocketdrone",
						"gth_walk_colussus",
						"ssv_fly_a61_gunship",
						"ssv_tread_mako",
		}
		
		
		--==========================
		-- LOCAL FUNCTIONS
		--==========================
		
		---
		-- @param #string type	The type of impact sounds to play ("armor" or "normal").
		-- 
		local function PlayDamageSound(type)
			--print("ME5_DamageFeedback.Init_HitMarkerSounds.PlayDamageSound(): Playing damage sound")
			
			--if bIsIncendiary == false then
				local randSnd = math.random(0,10)
				
				-- What is the surface type?
				if type == "armor" then
					--print("Playing armor sound")
					
					-- What is the weapon type?
					if weaponType == 2 then
						ScriptCB_SndPlaySound("enemy_armor_sniper_impact")
					elseif weaponType == 3 then
						ScriptCB_SndPlaySound("enemy_armor_shotgun_impact")
					elseif weaponType == 4 then
						ScriptCB_SndPlaySound("enemy_armor_gps_impact_layered")
					else
						ScriptCB_SndPlaySound("enemy_damage_armor_layered_"..randSnd)
					end
					
				elseif type == "normal" then
					--print("Playing normal sound")
					
					if weaponType == 2 then
						ScriptCB_SndPlaySound("enemy_normal_sniper_impact")
					elseif weaponType == 3 then
						ScriptCB_SndPlaySound("enemy_normal_shotgun_impact")
					elseif weaponType == 4 then
						ScriptCB_SndPlaySound("enemy_normal_gps_impact_layered")
					else
						ScriptCB_SndPlaySound("enemy_damage_normal_layered_"..randSnd)
					end
					
				elseif type == "shield" then
					--print("Playing shield sound")
					
					if weaponType == 2 then
						ScriptCB_SndPlaySound("enemy_shield_sniper_impact")
					elseif weaponType == 3 then
						ScriptCB_SndPlaySound("enemy_shield_shotgun_impact")
					elseif weaponType == 4 then
						ScriptCB_SndPlaySound("enemy_shield_gps_impact_layered")
					else
						ScriptCB_SndPlaySound("enemy_damage_shield_layered_"..randSnd)
					end
				end
			--end
		end
		
		
		--==========================
		-- EVENT RESPONSES
		--==========================
		
		-- When the player spawns
		local playerspawn = OnCharacterSpawn(
			function(player)
				if IsCharacterHuman(player) then
					--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Player spawned")
					Iamhuman = GetEntityPtr(GetCharacterUnit(player))
					
					-- Reset class
					bIsDamagerCorrectClass = false
				end
			end
		)
		
		-- When an enemy is damaged
		local enemydamage = OnObjectDamage(
			function(object, damager)
				-- Abort if the damager or object is nil
				if not damager then return end
				if not object then return end
				if GetCharacterUnit(damager) == nil then return end
				
				-- Was the damager the player?
				if IsCharacterHuman(damager) then
					--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage(): Damager is the player")
					
					--local playerPtr = GetEntityPtr(GetCharacterUnit(damager))	-- Damager's pointer.
					--local playerClass = GetEntityClass(playerPtr)				-- Damager's class.
					local damagerTeam = GetCharacterTeam(damager)				-- Damager's team.
					local damagerWeapon = GetObjectLastHitWeaponClass(object)	-- Damager's weapon class.
					
					local objectPtr = GetEntityPtr(object)				-- Damaged object's pointer.
					local objectClass = GetEntityClass(objectPtr)		-- Damaged object's class.
					local bIsObjectArmorClass = false					-- Is the damaged object an armored class?
					
					
					--[[if objectClass == FindEntityClass("ssv_tread_mako") then
						print("Damaged object is the Mako")
					end]]
					
					-- Exit immediately if any fields are wrong
					if not damagerTeam then return end
					if damagerTeam <= 0 then return end
					if not damagerWeapon then return end
					if not objectClass then return end
					
					
					-- Detect and set the damager weapon type
					if string.sub(damagerWeapon,14,19) == "sniper" then
						--print("Weapon is sniper rifle")
						weaponType = 2
					elseif string.sub(damagerWeapon,14,27) == "shotgun_plasma" then
						--print("Weapon is GPS")
						weaponType = 4
					elseif string.sub(damagerWeapon,14,20) == "shotgun" then
						--print("Weapon is shotgun")
						weaponType = 3
					else
						weaponType = 1
					end
					--print("Damager weapon: "..damagerWeapon)
					
					-- Check if the object is an armored class
					for i in ipairs(armorClasses) do
						-- Is the object one of them?
						if objectClass == FindEntityClass( armorClasses[i] ) then
							bIsObjectArmorClass = true
							break
						else
							bIsObjectArmorClass = false
						end
					end
					
					-- Determine the damager's faction
					if ME5_SideVar == 1 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "SSVxGTH") then
						if damagerTeam == REP then
							damagerFaction = "ssv"
						elseif damagerTeam == CIS then
							damagerFaction = "gth"
						end
						
					elseif ME5_SideVar == 2 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "SSVxCOL") then
						if damagerTeam == REP then
							damagerFaction = "ssv"
						elseif damagerTeam == CIS then
							damagerFaction = "col"
						end
						
					elseif ME5_SideVar == 3 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "EVGxGTH") then
						if damagerTeam == REP then
							damagerFaction = "evg"
						elseif damagerTeam == CIS then
							damagerFaction = "gth"
						end
						
					elseif ME5_SideVar == 4 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "EVGxCOL") then
						if damagerTeam == REP then
							damagerFaction = "evg"
						elseif damagerTeam == CIS then
							damagerFaction = "col"
						end
						
					elseif ME5_SideVar == 5 or (ScriptCB_InMultiplayer() and gCurrentMapManager.onlineSideVar == "SSVxRPR") then
						if damagerTeam == REP then
							damagerFaction = "ssv"
						elseif damagerTeam == CIS then
							damagerFaction = "rpr"
						end
					end
					
					
					-- Which team is the damager from?
					if damagerFaction == "col" then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Damager is from team COL")
						--ShowMessageText("level.common.debug.damager_col")
						
						-- For each weapon class
						for i=1, table.getn(ballisticWeapons_COL) do
							-- Was the weapon used a valid ballistic weapon?
							if damagerWeapon == ballisticWeapons_COL[i] then
								if GetObjectShield(object) < MIN_SHIELDS_DMG_FEEDBACK then
									-- Play the player damage sound
									if bIsObjectArmorClass == true then
										PlayDamageSound("armor")
									else
										PlayDamageSound("normal")
									end
								else
									PlayDamageSound("shield")
								end
								break
							end
						end
						
					elseif damagerFaction == "evg" then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Damager is from team EVG")
						--ShowMessageText("level.common.debug.damager_evg")
						
						-- For each weapon class
						for i=1, table.getn(ballisticWeapons_EVG) do
							-- Was the weapon used a valid ballistic weapon?
							if damagerWeapon == ballisticWeapons_EVG[i] then
								if GetObjectShield(object) < MIN_SHIELDS_DMG_FEEDBACK then
									-- Play the player damage sound
									if bIsObjectArmorClass == true then
										PlayDamageSound("armor")
									else
										PlayDamageSound("normal")
									end
								else
									PlayDamageSound("shield")
								end
								break
							end
						end
						
					elseif damagerFaction == "gth" then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Damager is from team GTH")
						--ShowMessageText("level.common.debug.damager_gth")
						
						-- For each weapon class
						for i=1, table.getn(ballisticWeapons_GTH) do
							-- Was the weapon used a valid ballistic weapon?
							if damagerWeapon == ballisticWeapons_GTH[i] then
								if GetObjectShield(object) < MIN_SHIELDS_DMG_FEEDBACK then
									-- Play the player damage sound
									if bIsObjectArmorClass == true then
										PlayDamageSound("armor")
									else
										PlayDamageSound("normal")
									end
								else
									PlayDamageSound("shield")
								end
								break
							end
						end
						
					elseif damagerFaction == "rpr" then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Damager is from team RPR")
						--ShowMessageText("level.common.debug.damager_indoc")
						
						-- For each weapon class
						for i=1, table.getn(ballisticWeapons_RPR) do
							-- Was the weapon used a valid ballistic weapon?
							if damagerWeapon == ballisticWeapons_RPR[i] then
								if GetObjectShield(object) < MIN_SHIELDS_DMG_FEEDBACK then
									-- Play the player damage sound
									if bIsObjectArmorClass == true then
										PlayDamageSound("armor")
									else
										PlayDamageSound("normal")
									end
								else
									PlayDamageSound("shield")
								end
								break
							end
						end
						
					elseif damagerFaction == "ssv" then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Damager is from team SSV")
						--ShowMessageText("level.common.debug.damager_ssv")
						
						-- For each weapon class
						for i=1, table.getn(ballisticWeapons_SSV) do
							-- Was the weapon used a valid ballistic weapon?
							if damagerWeapon == ballisticWeapons_SSV[i] then
								if GetObjectShield(object) < MIN_SHIELDS_DMG_FEEDBACK then
									-- Play the player damage sound
									if bIsObjectArmorClass == true then
										PlayDamageSound("armor")
									else
										PlayDamageSound("normal")
									end
								else
									PlayDamageSound("shield")
								end
								break
							end
						end
					end
				end
			end
		)
		
	end
end


print("ME5_DamageFeedback: Exited")