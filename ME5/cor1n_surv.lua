ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
RandomSide = math.random(1,2)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveSurvival")

--  CIS Attacking (attacker is always #1)
REP = 2;
CIS = 1;

--  These variables do not change
ATT = 1;
DEF = 2;

--SupportTeams_SSV()


 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------

function ScriptPostLoad()

	    AddDeathRegion("death")
	    AddDeathRegion("death1")
	    AddDeathRegion("death2")
	    AddDeathRegion("death3")
	    AddDeathRegion("death4")




    	SetProperty ("LibCase1","MaxHealth",1000)
    	SetProperty ("LibCase2","MaxHealth",1000)
    	SetProperty ("LibCase3","MaxHealth",1000)
    	SetProperty ("LibCase4","MaxHealth",1000)
    	SetProperty ("LibCase5","MaxHealth",1000)
    	SetProperty ("LibCase6","MaxHealth",1000)
    	SetProperty ("LibCase7","MaxHealth",1000)
    	SetProperty ("LibCase8","MaxHealth",1000)
    	SetProperty ("LibCase9","MaxHealth",1000)
    	SetProperty ("LibCase10","MaxHealth",1000)
    	SetProperty ("LibCase11","MaxHealth",1000)
    	SetProperty ("LibCase12","MaxHealth",1000)
    	SetProperty ("LibCase13","MaxHealth",1000)
    	SetProperty ("LibCase14","MaxHealth",1000)


    	SetProperty ("LibCase1","CurHealth",1000)
    	SetProperty ("LibCase2","CurHealth",1000)
    	SetProperty ("LibCase3","CurHealth",1000)
    	SetProperty ("LibCase4","CurHealth",1000)
    	SetProperty ("LibCase5","CurHealth",1000)
    	SetProperty ("LibCase6","CurHealth",1000)
    	SetProperty ("LibCase7","CurHealth",1000)
    	SetProperty ("LibCase8","CurHealth",1000)
    	SetProperty ("LibCase9","CurHealth",1000)
    	SetProperty ("LibCase10","CurHealth",1000)
    	SetProperty ("LibCase11","CurHealth",1000)
    	SetProperty ("LibCase12","CurHealth",1000)
    	SetProperty ("LibCase13","CurHealth",1000)
    	SetProperty ("LibCase14","CurHealth",1000)



    	EnableSPHeroRules()
    	
    	DisableBarriers("SideDoor1")
        DisableBarriers("MainLibraryDoors")
        DisableBarriers("SideDoor2")
        DisableBarriers("SIdeDoor3")
        DisableBarriers("ComputerRoomDoor1")
        DisableBarriers("StarChamberDoor1")
        DisableBarriers("StarChamberDoor2")
        DisableBarriers("WarRoomDoor1")
        DisableBarriers("WarRoomDoor2")
        DisableBarriers("WarRoomDoor3") 
        PlayAnimation("DoorOpen01")
        PlayAnimation("DoorOpen02") 
            
            
                    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    survival = ObjectiveSurvival:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.surv", 
                                     textDEF = "game.modes.surv2",
                                     multiplayerRules = true}
	
	
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    survival:AddCommandPost(cp1)
    survival:AddCommandPost(cp2)
    survival:AddCommandPost(cp3)
    survival:AddCommandPost(cp4)
    survival:AddCommandPost(cp5)
    survival:AddCommandPost(cp6)
    
    survival:Start()
	
	SetProperty("cp1", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp2", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp3", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp4", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp5", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp6", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("cp1", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp2", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp3", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp4", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp5", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("cp6", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	
	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			SetProperty("cp1", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("cp2", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("cp3", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("cp4", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("cp5", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("cp6", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("cp1", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("cp2", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("cp3", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("cp4", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("cp5", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("cp6", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			
			SetProperty("cp1", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("cp2", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("cp3", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("cp4", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("cp5", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("cp6", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("cp1", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("cp2", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("cp3", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("cp4", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("cp5", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("cp6", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("cp1", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("cp2", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("cp3", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("cp4", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("cp5", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("cp6", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("cp1", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("cp2", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("cp3", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("cp4", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("cp5", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("cp6", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
		elseif RandomSide == 2 then
			--[[herosupport = AIHeroSupport:New{AIATTHeroHealth = 3000, AIDEFHeroHealth = 3000, gameMode = "NonConquest",}
			herosupport:SetHeroClass(CIS, "col_hero_harbinger")
			herosupport:AddSpawnCP("cp1","CP1SpawnPath")
			herosupport:AddSpawnCP("cp2","CP2SpawnPath")
			herosupport:AddSpawnCP("cp3","CP3SpawnPath")
			herosupport:AddSpawnCP("cp4","CP4SpawnPath")
			herosupport:AddSpawnCP("cp5","CP5SpawnPath")
			herosupport:AddSpawnCP("cp6","CP6SpawnPath")
			herosupport:Start()]]
			
			SetProperty("cp1", "VO_Rep_CisCapture", "ssv_adm_com_report_colCaptured_commandpost")
			SetProperty("cp2", "VO_Rep_CisCapture", "ssv_adm_com_report_colCaptured_commandpost")
			SetProperty("cp3", "VO_Rep_CisCapture", "ssv_adm_com_report_colCaptured_commandpost")
			SetProperty("cp4", "VO_Rep_CisCapture", "ssv_adm_com_report_colCaptured_commandpost")
			SetProperty("cp5", "VO_Rep_CisCapture", "ssv_adm_com_report_colCaptured_commandpost")
			SetProperty("cp6", "VO_Rep_CisCapture", "ssv_adm_com_report_colCaptured_commandpost")
			SetProperty("cp1", "VO_Rep_CisLost", "ssv_adm_com_report_colLost_commandpost")
			SetProperty("cp2", "VO_Rep_CisLost", "ssv_adm_com_report_colLost_commandpost")
			SetProperty("cp3", "VO_Rep_CisLost", "ssv_adm_com_report_colLost_commandpost")
			SetProperty("cp4", "VO_Rep_CisLost", "ssv_adm_com_report_colLost_commandpost")
			SetProperty("cp5", "VO_Rep_CisLost", "ssv_adm_com_report_colLost_commandpost")
			SetProperty("cp6", "VO_Rep_CisLost", "ssv_adm_com_report_colLost_commandpost")
		end
	else
		SetProperty("cp1", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
		SetProperty("cp2", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
		SetProperty("cp3", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
		SetProperty("cp4", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
		SetProperty("cp5", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
		SetProperty("cp6", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
		SetProperty("cp1", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
		SetProperty("cp2", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
		SetProperty("cp3", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
		SetProperty("cp4", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
		SetProperty("cp5", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
		SetProperty("cp6", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
		
		SetProperty("cp1", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
		SetProperty("cp2", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
		SetProperty("cp3", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
		SetProperty("cp4", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
		SetProperty("cp5", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
		SetProperty("cp6", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
		SetProperty("cp1", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
		SetProperty("cp2", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
		SetProperty("cp3", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
		SetProperty("cp4", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
		SetProperty("cp5", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
		SetProperty("cp6", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
		SetProperty("cp1", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
		SetProperty("cp2", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
		SetProperty("cp3", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
		SetProperty("cp4", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
		SetProperty("cp5", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
		SetProperty("cp6", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
		SetProperty("cp1", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
		SetProperty("cp2", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
		SetProperty("cp3", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
		SetProperty("cp4", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
		SetProperty("cp5", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
		SetProperty("cp6", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
	end
	
	--Drones_SSV()
	
	end

function ScriptInit()
    -- Designers, these two lines *MUST* be first.
   
    SetPS2ModelMemory(4056000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;cor1")
	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
		elseif RandomSide == 2 then
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
			ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamecol.lvl")
		end
	else
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
		ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
	end
	PreLoadStuff()
    
    SetMapNorthAngle(180, 1)
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight (25)
    AISnipeSuitabilityDist(30)
    
    
    
    SetMemoryPoolSize("Music", 103)
	
    SFL_Turrets()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl", 
					"tur_bldg_laser")
					
	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			Load_SSV()
			Load_GTH()
			Setup_SSVxGTH_med()
			DecideSSVHeroClass()
			team2ticketstring = "level.common.events.con.ticketboost.ssv"
			team1ticketstring = "level.common.events.con.ticketboost.gth"
		elseif RandomSide == 2 then
			Load_SSV()
			Load_COL()
			Setup_SSVxCOL_med()
			DecideSSVHeroClass()
			team2ticketstring = "level.common.events.con.ticketboost.ssv"
			team1ticketstring = "level.common.events.con.ticketboost.col"
		end
	else
		Load_SSV()
		Load_GTH()
		Setup_SSVxGTH_med()
		SetHeroClass(REP, "ssv_hero_shepard_engineer")
		team2ticketstring = "level.common.events.con.ticketboost.ssv"
		team1ticketstring = "level.common.events.con.ticketboost.gth"
	end
	ReadDataFile("sound\\cor.lvl;cor1cw")
	--SupportTeamSetup_SSV()
    
	--  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)  -- number of droidekas

	local weaponCnt = 225
	local guyCnt = 50
	SetMemoryPoolSize("Aimer", 23)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 250)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 18)
	SetMemoryPoolSize("EntitySoundStream", 14)
	SetMemoryPoolSize("EntitySoundStatic", 45)
	SetMemoryPoolSize("MountedTurret", 13)
	SetMemoryPoolSize("Navigator", guyCnt)
	SetMemoryPoolSize("Obstacle", 393)
	SetMemoryPoolSize("PathFollower", guyCnt)
	SetMemoryPoolSize("PathNode", 384)
	SetMemoryPoolSize("SoldierAnimation", 324)
	SetMemoryPoolSize("SoundSpaceRegion", 26)
	SetMemoryPoolSize("TentacleSimulator", 0)
	SetMemoryPoolSize("TreeGridStack", 150)
	SetMemoryPoolSize("UnitAgent", guyCnt)
	SetMemoryPoolSize("UnitController", guyCnt)
	SetMemoryPoolSize("Weapon", weaponCnt)

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\cor1.lvl","cor1_Conquest")
	SetDenseEnvironment("True")
		 -- SetMaxFlyHeight(25)
	 --SetMaxPlayerFlyHeight (25)
	AddDeathRegion("DeathRegion1")
	
	PostInitStuff()

    --  Sound Stats

	if not ScriptCB_InMultiplayer() then
		if RandomSide == 1 then
			Music06()
			
			SSVWorldVO()
			GTHWorldVO()
		elseif RandomSide == 2 then
			Music02()
			
			SSVWorldVO()
			COLWorldVO()
		end
	else
		Music06()
		
		SSVWorldVO()
		GTHWorldVO()
	end
	
	OpenAudioStream("sound\\cor.lvl",  "cor1")
	
	SoundFX()
	
	
    --  Camera Stats
    --Tat 1 - Dune Sea
	AddCameraShot(0.419938, 0.002235, -0.907537, 0.004830, -15.639358, 5.499980, -176.911179);
	AddCameraShot(0.994506, 0.104463, -0.006739, 0.000708, 1.745251, 5.499980, -118.700668);
	AddCameraShot(0.008929, -0.001103, -0.992423, -0.122538, 1.366768, 16.818106, -114.422173);
	AddCameraShot(0.761751, -0.117873, -0.629565, -0.097419, 59.861904, 16.818106, -81.607773);
	AddCameraShot(0.717110, -0.013583, 0.696703, 0.013197, 98.053314, 11.354497, -85.857857);
	AddCameraShot(0.360958, -0.001053, -0.932577, -0.002721, 69.017578, 18.145807, -56.992413);
	AddCameraShot(-0.385976, 0.014031, -0.921793, -0.033508, 93.111061, 18.145807, -20.164375);
	AddCameraShot(0.695468, -0.129569, -0.694823, -0.129448, 27.284357, 18.145807, -12.377695);
	AddCameraShot(0.009002, -0.000795, -0.996084, -0.087945, 1.931320, 13.356332, -16.410583);
	AddCameraShot(0.947720, -0.145318, 0.280814, 0.043058, 11.650738, 16.955814, 28.359180);
	AddCameraShot(0.686380, -0.127550, 0.703919, 0.130810, -30.096384, 11.152356, -63.235146);
	AddCameraShot(0.937945, -0.108408, 0.327224, 0.037821, -43.701199, 8.756138, -49.974789);
	AddCameraShot(0.531236, -0.079466, -0.834207, -0.124787, -62.491230, 10.305247, -120.102989);
	AddCameraShot(0.452286, -0.179031, -0.812390, -0.321572, -50.015198, 15.394646, -114.879379);
	AddCameraShot(0.927563, -0.243751, 0.273918, 0.071982, 26.149965, 26.947924, -46.834148);

end


