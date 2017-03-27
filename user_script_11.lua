print("user_script_meu: Entered")


-- Taking over MissionVictory, so we can reload the stock fonts
if MissionVictory then
	-- Store the original function
	print("user_script_meu: Listening on MissionVictory() calls")
	MEU_MissionVictory = MissionVictory
	
	-- Make the new function
	MissionVictory = function(...)
		print("user_script_meu.MissionVictory(): Entered")
		
		-- The team(s) to give the victory to
		local team = arg[1]
		
		if bStockFontLoaded == nil then
			-- Has the stock font been loaded?
			bStockFontLoaded = false
		end
		
		-- Is the custom HUD enabled?
		if ME5_CustomHUD == 1 then
			print("user_script_meu.MissionVictory(): Custom HUD is enabled")
			
			-- Has the stock font already been loaded?
			--if bStockFontLoaded == false then
				--bStockFontLoaded = true
				
				print("user_script_meu.MissionVictory(): Loading hud_font_stock.lvl...")
				
				-- Reload the stock fonts in the stats screen
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
			--end
		end
		
		-- Forward the call to the original function
		MEU_MissionVictory( unpack(arg) )
	end
else
	print("user_script_meu: WARNING: Cannot listen on MissionVictory()")
end


-- Taking over MissionDefeat, so we can reload the stock fonts
if MissionDefeat then
	-- Store the original function
	print("user_script_meu: Listening on MissionDefeat() calls")
	MEU_MissionDefeat = MissionDefeat
	
	-- Make the new function
	MissionDefeat = function(...)
		-- The team(s) to give the defeat to
		local team = arg[1]
		
		if bStockFontLoaded == nil then
			-- Has the stock font been loaded?
			bStockFontLoaded = false
		end
		
		-- Is the custom HUD enabled?
		if ME5_CustomHUD == 1 then
			-- Has the stock font already been loaded?
			if bStockFontLoaded == false then
				bStockFontLoaded = true
				
				print("user_script_meu.MissionDefeat(): Loading hud_font_stock.lvl...")
				
				-- Reload the stock fonts in the stats screen
				ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\hud_font_stock.lvl")
			end
		end
		
		-- Forward the call to the original function
		MEU_MissionDefeat( unpack(arg) )
	end
else
	print("user_script_meu: WARNING: Cannot listen on MissionDefeat()")
end


print("user_script_meu: Exited")