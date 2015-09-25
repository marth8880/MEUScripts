function meu_lowhealth_postCall(this)
	AddIFScreen(ifs_lowhealth_vignette,"ifs_lowhealth_vignette")

	meu_lowhealth_scr_rspwn = CreateTimer("meu_lowhealth_scr_rspwn")
	SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
	
	elapse_lowhealth = OnTimerElapse(
		function(timer)
			StopTimer(meu_lowhealth_scr_rspwn)
			ifs_lowhealth_vignette.TimerType = false
			ScriptCB_PushScreen("ifs_lowhealth_vignette")
		end,
	meu_lowhealth_scr_rspwn
	)
	
	spawn_lowhealth = OnCharacterSpawn(
		function(player)
			if IsCharacterHuman(player) and ifs_lowhealth_vignette.TimerMngr > 0 then
				SetTimerValue(meu_lowhealth_scr_rspwn, 0.5)
				StartTimer(meu_lowhealth_scr_rspwn)
			end
		end
	)
	
	-- TEST
	--	death_lowhealth = OnCharacterDeath(
	--		function(player, killer)
	--			if IsCharacterHuman(killer) then
	--				ScriptCB_PushScreen("blue_horse")
	--			end
	--		end
	--	)
	
end