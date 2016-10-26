-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Damage Feedback Script by A. Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: This script contains various functions 
-- regarding player and enemy damage feedback.
-- 
-- Usage: Simply call Init_PlayerDamageFeedback() or Init_HitMarkerSounds() 
-- anywhere in ScriptInit().
-- 
-- 
-- Legal Stuff:
-- You are welcome to use this script in your custom-made mods and maps so long as they are not being rented or sold.
-- If you use this script, please credit me in the readme of the project you used it in.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- You may edit this script as you need in order to make it work with your own map or mod.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------

print("ME5_DamageFeedback: Entered")

---
-- Sets up the event responses for the player damage sounds.
-- 
function Init_PlayerDamageFeedback()
	print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Entered")
	
	local Iamhuman = nil					-- Pointer for human player.
	local bIsDamagerCorrectClass = false	-- Is the damager the correct class?
	local damagerFaction = "none"			-- Which faction is the damager from?
	
	-- COL ballistic weapons.
	local ballisticWeapons_COL = {
					"col_weap_inf_rifle_col",
					"col_weap_inf_rifle_col_shredder",
					"col_weap_inf_rifle_colcarbine",
					"col_weap_inf_shotgun_pulse",
					"col_weap_inf_shouldercannon",
					
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- GTH ballistic weapons.
	local ballisticWeapons_GTH = {
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
					
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- INDOC ballistic weapons.
	local ballisticWeapons_INDOC = {
					"indoc_weap_inf_armcannon",
					"indoc_weap_inf_rifle_phaeston",
					
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- SSV ballistic weapons.
	local ballisticWeapons_SSV = {
					"ssv_weap_fly_a61_gunship_gun",
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
					"tur_weap_laser" }
	
	-- Turret ballistic weapons.
	local ballisticWeapons_TUR = {
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- COL unit classes.
	local colClasses = {
					"col_inf_assassin",
					"col_inf_drone",
					"col_inf_guardian",
					"col_inf_guardian_shield",
					"col_inf_guardian_online",
					"col_inf_guardian_online_shield",
					"col_inf_scion",
					
					"col_hero_harbinger" }
	
	-- GTH unit classes.
	local gthClasses = {
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
					"gth_hero_prime_me3" }
	
	-- INDOC unit classes.
	local indocClasses = {
					"indoc_inf_abomination",
					"indoc_inf_cannibal",
					"indoc_inf_husk",
					"indoc_inf_marauder" }
	
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
					
					"ssv_hero_jack" }
	
	
	
	local function PlayDamageSound()
		--print("ME5_DamageFeedback.Init_PlayerDamageFeedback.PlayDamageSound(): Playing damage sound")
		
		local randSnd = math.random(0,10)
		ScriptCB_SndPlaySound("player_damage_layered_"..randSnd)
	end
	
	
	
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
			
			-- Was the damaged object the player?
			if Iamhuman == GetEntityPtr(object) then
				if not GetCharacterUnit(damager) == nil then
					-- The damager's pointer
					local charPtr = GetEntityPtr(GetCharacterUnit(damager))
					local charClass = GetEntityClass(charPtr)
					local damagerWeapon = GetObjectLastHitWeaponClass(object)
					
					
					-- Immediately abort if the weapon was incendiary
					if not string.find(damagerWeapon, "incendiary") then
					
						-- Only proceed if damager isn't correct class
						if bIsDamagerCorrectClass == false then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback.playerdamage_COL(): Player isn't correct class, proceeding")
							
							-- For each COL class,
							for i=1, table.getn(colClasses) do
								-- Is the damager one of them?
								if charClass == FindEntityClass( colClasses[i] ) then
									bIsDamagerCorrectClass = true
									damagerFaction = "col"
								else
									bIsDamagerCorrectClass = false
								end
								
								-- Break out of the loop if correct class
								if bIsDamagerCorrectClass == true then break end
							end
						end
						
						-- Only proceed if damager isn't correct class
						if bIsDamagerCorrectClass == false then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback.playerdamage_GTH(): Player isn't correct class, proceeding")
							
							-- For each GTH class,
							for j=1, table.getn(gthClasses) do
								-- Is the damager one of them?
								if charClass == FindEntityClass( gthClasses[j] ) then
									bIsDamagerCorrectClass = true
									damagerFaction = "gth"
								else
									bIsDamagerCorrectClass = false
								end
								
								-- Break out of the loop if correct class
								if bIsDamagerCorrectClass == true then break end
							end
						end
						
						-- Only proceed if damager isn't correct class
						if bIsDamagerCorrectClass == false then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback.playerdamage_INDOC(): Player isn't correct class, proceeding")
							
							-- For each INDOC class,
							for k=1, table.getn(indocClasses) do
								-- Is the damager one of them?
								if charClass == FindEntityClass( indocClasses[k] ) then
									bIsDamagerCorrectClass = true
									damagerFaction = "indoc"
								else
									bIsDamagerCorrectClass = false
								end
								
								-- Break out of the loop if correct class
								if bIsDamagerCorrectClass == true then break end
							end
						end
						
						-- Only proceed if damager isn't correct class
						if bIsDamagerCorrectClass == false then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback.playerdamage_SSV(): Player isn't correct class, proceeding")
							
							-- For each SSV class,
							for m=1, table.getn(ssvClasses) do
								-- Is the damager one of them?
								if charClass == FindEntityClass( ssvClasses[m] ) then
									bIsDamagerCorrectClass = true
									damagerFaction = "ssv"
								else
									bIsDamagerCorrectClass = false
								end
								
								-- Break out of the loop if correct class
								if bIsDamagerCorrectClass == true then break end
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
							
						elseif damagerFaction == "indoc" then
							--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): Damager is from team INDOC")
							--ShowMessageText("level.common.debug.damager_indoc")
							
							-- For each weapon class
							for i=1, table.getn(ballisticWeapons_INDOC) do
								-- Was the weapon used a valid ballistic weapon?
								if damagerWeapon == ballisticWeapons_INDOC[i] then
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
				else
					--print("ME5_DamageFeedback.Init_PlayerDamageFeedback(): GetCharacterUnit(damager) is nil")		-- uncomment me for test output!
				end
			end
		end
	)
end


---
-- Sets up the event responses for the hit marker sounds.
-- 
function Init_HitMarkerSounds()
	print("ME5_DamageFeedback.Init_HitMarkerSounds(): Entered")
	
	local Iamhuman = nil					-- Pointer for human player.
	local bIsDamagerCorrectClass = false	-- Is the damager the correct class?
	local damagerFaction = "none"			-- Which faction is the damager from?
	local weaponType = "normal"				-- The weapon type. ("normal", "sniper", "shotgun", "gps")
	local bIsIncendiary = false				-- Is the weapon incendiary?
	
	-- COL ballistic weapons.
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
					
					"indoc_weap_inf_armcannon",
					"indoc_weap_inf_rifle_phaeston",
					
					"ssv_weap_fly_a61_gunship_gun",
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
					"tur_weap_laser" }
	
	-- COL ballistic weapons.
	local ballisticWeapons_COL = {
					"col_weap_inf_rifle_col",
					"col_weap_inf_rifle_col_colgen",
					"col_weap_inf_rifle_col_shredder",
					"col_weap_inf_rifle_colcarbine",
					"col_weap_inf_rifle_colcarbine_colgen",
					"col_weap_inf_shotgun_pulse",
					"col_weap_inf_shouldercannon",
					
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- GTH ballistic weapons.
	local ballisticWeapons_GTH = {
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
					
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- INDOC ballistic weapons.
	local ballisticWeapons_INDOC = {
					"indoc_weap_inf_armcannon",
					"indoc_weap_inf_rifle_phaeston",
					
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- SSV ballistic weapons.
	local ballisticWeapons_SSV = {
					"ssv_weap_fly_a61_gunship_gun",
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
					"tur_weap_laser" }
	
	-- Turret ballistic weapons.
	local ballisticWeapons_TUR = {
					"tur_weap_bldg_mturret_cannon",
					"tur_weap_hoth_dishturret",
					"tur_weap_hoth_lasermortar_laser",
					"tur_weap_laser" }
	
	-- COL unit classes.
	local colClasses = {
					"col_inf_assassin",
					"col_inf_drone",
					"col_inf_guardian",
					"col_inf_guardian_shield",
					"col_inf_guardian_online",
					"col_inf_guardian_online_shield",
					"col_inf_scion",
					
					"col_hero_harbinger" }
	
	-- GTH unit classes.
	local gthClasses = {
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
					"gth_hero_prime_me3" }
	
	-- INDOC unit classes.
	local indocClasses = {
					"indoc_inf_abomination",
					"indoc_inf_cannibal",
					"indoc_inf_husk",
					"indoc_inf_marauder" }
	
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
					
					"ssv_hero_jack" }
	
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
					"gth_ev_inf_juggernaut_online",
					"gth_ev_inf_pyro_shield",
					"gth_ev_inf_juggernaut_shield",
					"gth_ev_inf_juggernaut_online_shield",
					"gth_hero_prime_me2",
					"gth_hero_prime_me3",
					
					-- Buildings
					"tur_bldg_chaingun_roof",
					"tur_bldg_chaingun_tripod",
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
					"ssv_hero_jack" }
	
	
	
	---
	-- @param #string type	The type of impact sounds to play ("armor" or "normal").
	-- 
	local function PlayDamageSound(type)
		--print("ME5_DamageFeedback.Init_HitMarkerSounds.PlayDamageSound(): Playing damage sound")
		
		if bIsIncendiary == false then
			local randSnd = math.random(0,10)
			
			-- What is the surface type?
			if type == "armor" then
				--print("Playing armor sound")
				
				-- What is the weapon type?
				if weaponType == "sniper" then
					print("Weapon is sniper")
					ScriptCB_SndPlaySound("enemy_armor_sniper_impact")
				elseif weaponType == "shotgun" then
					ScriptCB_SndPlaySound("enemy_armor_shotgun_impact")
				elseif weaponType == "gps" then
					ScriptCB_SndPlaySound("enemy_armor_gps_impact_layered")
				else
					ScriptCB_SndPlaySound("enemy_damage_armor_layered_"..randSnd)
				end
				
			elseif type == "normal" then
				--print("Playing normal sound")
				
				if weaponType == "sniper" then
					print("Weapon is sniper")
					ScriptCB_SndPlaySound("enemy_normal_sniper_impact")
				elseif weaponType == "shotgun" then
					ScriptCB_SndPlaySound("enemy_normal_shotgun_impact")
				elseif weaponType == "gps" then
					ScriptCB_SndPlaySound("enemy_normal_gps_impact_layered")
				else
					ScriptCB_SndPlaySound("enemy_damage_normal_layered_"..randSnd)
				end
			end
		end
	end
	
	
	
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
			
			-- Abort if the damager is nil
			if GetCharacterUnit(damager) == nil then
				--print("Damager is nil")
				return
			end
			
			-- Was the damager the player?
			if IsCharacterHuman(damager) then
				--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage(): Damager is the player")
				
				local playerPtr = GetEntityPtr(GetCharacterUnit(damager))	-- Damager's pointer.
				local playerClass = GetEntityClass(playerPtr)				-- Damager's class.
				local damagerWeapon = GetObjectLastHitWeaponClass(object)	-- Damager's weapon class.
				
				local objectPtr = GetEntityPtr(object)				-- Damaged object's pointer.
				local objectClass = GetEntityClass(objectPtr)		-- Damaged object's class.
				local bIsObjectArmorClass = false					-- Is the damaged object an armored class?
				
				
				--[[if objectClass == FindEntityClass("ssv_tread_mako") then
					print("Damaged object is the Mako")
				end]]
				
				
				-- TODO: determine what to do with incendiary weapons
				-- Is the damager weapon incendiary?
				if string.find(damagerWeapon, "incendiary") then
					bIsIncendiary = true
				else
					bIsIncendiary = false
				end
				
				
				-- Immediately abort if the weapon was incendiary
				if bIsIncendiary == false then
				
					-- Detect and set the damager weapon type
					if string.find(damagerWeapon, "sniper") then
						--print("Weapon is sniper rifle")
						weaponType = "sniper"
					elseif string.find(damagerWeapon, "shotgun_plasma") then
						--print("Weapon is GPS")
						weaponType = "gps"
					elseif string.find(damagerWeapon, "shotgun") then
						--print("Weapon is shotgun")
						weaponType = "shotgun"
					else
						weaponType = "normal"
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
				
					-- Only proceed if damager isn't correct class
					if bIsDamagerCorrectClass == false then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_COL(): Player isn't correct class, proceeding")
						
						-- For each COL class,
						for i=1, table.getn(colClasses) do
							-- Is the damager one of them?
							if playerClass == FindEntityClass( colClasses[i] ) then
								bIsDamagerCorrectClass = true
								damagerFaction = "col"
							else
								bIsDamagerCorrectClass = false
							end
							
							-- Break out of the loop if correct class
							if bIsDamagerCorrectClass == true then
								--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_COL(): Player is correct class")
								break 
							end
						end
					end
					
					-- Only proceed if damager isn't correct class
					if bIsDamagerCorrectClass == false then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_GTH(): Player isn't correct class, proceeding")
						
						-- For each GTH class,
						for j=1, table.getn(gthClasses) do
							-- Is the damager one of them?
							if playerClass == FindEntityClass( gthClasses[j] ) then
								bIsDamagerCorrectClass = true
								damagerFaction = "gth"
							else
								bIsDamagerCorrectClass = false
							end
							
							-- Break out of the loop if correct class
							if bIsDamagerCorrectClass == true then
								--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_GTH(): Player is correct class")
								break 
							end
						end
					end
					
					-- Only proceed if damager isn't correct class
					if bIsDamagerCorrectClass == false then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_INDOC(): Player isn't correct class, proceeding")
						
						-- For each INDOC class,
						for k=1, table.getn(indocClasses) do
							-- Is the damager one of them?
							if playerClass == FindEntityClass( indocClasses[k] ) then
								bIsDamagerCorrectClass = true
								damagerFaction = "indoc"
							else
								bIsDamagerCorrectClass = false
							end
							
							-- Break out of the loop if correct class
							if bIsDamagerCorrectClass == true then
								--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_INDOC(): Player is correct class")
								break 
							end
						end
					end
					
					-- Only proceed if damager isn't correct class
					if bIsDamagerCorrectClass == false then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_SSV(): Player isn't correct class, proceeding")
						
						-- For each SSV class,
						for m=1, table.getn(ssvClasses) do
							-- Is the damager one of them?
							if playerClass == FindEntityClass( ssvClasses[m] ) then
								bIsDamagerCorrectClass = true
								damagerFaction = "ssv"
							else
								bIsDamagerCorrectClass = false
							end
							
							-- Break out of the loop if correct class
							if bIsDamagerCorrectClass == true then
								--print("ME5_DamageFeedback.Init_HitMarkerSounds.enemydamage_SSV(): Player is correct class")
								break 
							end
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
								-- Play the player damage sound
								if bIsObjectArmorClass == true then
									PlayDamageSound("armor")
								else
									PlayDamageSound("normal")
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
								-- Play the player damage sound
								if bIsObjectArmorClass == true then
									PlayDamageSound("armor")
								else
									PlayDamageSound("normal")
								end
								break
							end
						end
						
					elseif damagerFaction == "indoc" then
						--print("ME5_DamageFeedback.Init_HitMarkerSounds(): Damager is from team INDOC")
						--ShowMessageText("level.common.debug.damager_indoc")
						
						-- For each weapon class
						for i=1, table.getn(ballisticWeapons_INDOC) do
							-- Was the weapon used a valid ballistic weapon?
							if damagerWeapon == ballisticWeapons_INDOC[i] then
								-- Play the player damage sound
								if bIsObjectArmorClass == true then
									PlayDamageSound("armor")
								else
									PlayDamageSound("normal")
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
								-- Play the player damage sound if the damager weapon wasn't incendiary
								if bIsObjectArmorClass == true then
									PlayDamageSound("armor")
								else
									PlayDamageSound("normal")
								end
								break
							end
						end
					end
					
				end
			end
		end
	)
end


print("ME5_DamageFeedback: Exited")