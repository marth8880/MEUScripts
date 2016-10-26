-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Kill Sounds Script by A. Gilbert
-- Build 31025/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Oct 25, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: This script contains various functions 
-- regarding kill sounds.
-- 
-- Usage: Simply call Init_HealthFunc() anywhere in ScriptInit().
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

print("ME5_KillSounds: Entered")

---
-- Sets up the event responses for kill sounds.
-- 
function Init_KillSounds()
	print("ME5_KillSounds.Init_KillSounds(): Entered")
	
	if not ScriptCB_InMultiplayer() then
		if ME5_KillSound == 0 then
			print("ME5_KillSounds.Init_KillSounds(): Initializing kill sound setting for DISABLED...")
		else
			print("ME5_KillSounds.Init_KillSounds(): Initializing kill sound setting for ENABLED...")
			
			local enemydeath = OnCharacterDeath(
				function(player, killer)
					if killer and IsCharacterHuman(killer) then
						local playerTeam = GetCharacterTeam(player)
						local killerTeam = GetCharacterTeam(killer)
						
						-- Was the killed unit's team different from the killer's?
						if playerTeam ~= killerTeam then
							-- Is this not a campaign?
							if not IsCampaign() then
								ScriptCB_SndPlaySound("hud_player_kill")
							else
								local world = string.lower(GetWorldFilename())
								
								-- Are we on Europa?
								if world == "eur" then
									-- Is the victim team not the squad team?
									if playerTeam ~= 3 then
										ScriptCB_SndPlaySound("hud_player_kill")
									end
								end
							end
						end
					end
				end
			)
		end
	else
		print("ME5_KillSounds.Init_KillSounds(): Initializing kill sound setting for DISABLED...")
	end
end


print("ME5_KillSounds: Exited")