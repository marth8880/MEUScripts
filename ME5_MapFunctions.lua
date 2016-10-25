-----------------------------------------------------------------
-----------------------------------------------------------------
-- MASS EFFECT: UNIFICATION Master Script by A. Gilbert
-- Build 30318/06
-- Screen Names: Marth8880, GT-Marth8880, [GT] Marth8880, [GT] Bran
-- E-Mail: Marth8880@gmail.com
-- Mar 18, 2016
-- Copyright (c) 2016 A. Gilbert.
-- 
-- About this script: The purpose of script is to simplify the process 
-- of loading specific maps' functions such as that of disabling barriers, etc.
-- 
-- Usage:
-- Load the script using ScriptCB_DoFile() in your main mission script
-- Call whichever functions you need out of this script. Example:
-- 
-- VRM_DisablePlanningGraphArcs1()
-- 
-- The above example would load and then set up the Systems Alliance and Geth side
-- 
-- 
-- Legal Stuff:
-- Usage of this script is unauthorized without my prior consent. Contact me if you wish to use it.
-- Do not claim this script as your own. It may not be much, but I did spend some time writing it after all.
-- I am not responsible for any damages that might be incurred through the use of this script.
-- THIS SCRIPT IS NOT MADE, DISTRIBUTED, OR SUPPORTED BY LUCASARTS, A DIVISION OF LUCASFILM ENTERTAINMENT COMPANY LTD.
-----------------------------------------------------------------
-----------------------------------------------------------------
	print("ME5_MapFunctions: Entered")



--[[function VRM_DisablePlanningGraphArcs1()
	BlockPlanningGraphArcs("c2Connection59")
	BlockPlanningGraphArcs("c2Connection62")
	BlockPlanningGraphArcs("c2Connection62b")
	BlockPlanningGraphArcs("c2Connection63")
	BlockPlanningGraphArcs("c2Connection65")
	BlockPlanningGraphArcs("c2Connection67")
	BlockPlanningGraphArcs("c2Connection77")
	BlockPlanningGraphArcs("c2Connection77b")
	BlockPlanningGraphArcs("c2Connection78")
	BlockPlanningGraphArcs("c2Connection79")
	BlockPlanningGraphArcs("c2Connection82")
	BlockPlanningGraphArcs("c2Connection90")
end

function VRM_DisablePlanningGraphArcs2()
	BlockPlanningGraphArcs("c1Connection45")
	BlockPlanningGraphArcs("c1Connection50")
	BlockPlanningGraphArcs("c1Connection51")
	BlockPlanningGraphArcs("c1Connection52")
	BlockPlanningGraphArcs("c1Connection56")
	BlockPlanningGraphArcs("c1Connection59")
	BlockPlanningGraphArcs("c1Connection63")
	BlockPlanningGraphArcs("c1Connection64")
	BlockPlanningGraphArcs("c1Connection73")
	BlockPlanningGraphArcs("c1Connection77")
	BlockPlanningGraphArcs("c1Connection81")
	BlockPlanningGraphArcs("c1Connection82")
	BlockPlanningGraphArcs("c1Connection83")
	BlockPlanningGraphArcs("c1Connection84")
	BlockPlanningGraphArcs("c1Connection87")
	BlockPlanningGraphArcs("c1Connection88")
	BlockPlanningGraphArcs("c1Connection90")
	BlockPlanningGraphArcs("c1Connection95")
	BlockPlanningGraphArcs("c1Connection95b")
	BlockPlanningGraphArcs("c1Connection95c")
	BlockPlanningGraphArcs("c1Connection95d")
end]]

function VRM_DisableBarriers1()
	DisableBarriers("c2Barrier225")
	DisableBarriers("c2Barrier226")
	DisableBarriers("c2Barrier227")
	DisableBarriers("c2Barrier228")
	DisableBarriers("c2Barrier229")
	DisableBarriers("c2Barrier230")
	DisableBarriers("c2Barrier231")
	DisableBarriers("c2Barrier232")
	DisableBarriers("c2Barrier233")
	DisableBarriers("c2Barrier234")
	DisableBarriers("c2Barrier235")
	DisableBarriers("c2Barrier236")
	DisableBarriers("c2Barrier237")
	DisableBarriers("c2Barrier238")
	DisableBarriers("c2Barrier239")
	DisableBarriers("c2Barrier240")
	DisableBarriers("c2Barrier241")
	DisableBarriers("c2Barrier242")
	DisableBarriers("c2Barrier243")
	DisableBarriers("c2Barrier244")
	DisableBarriers("c2Barrier245")
	DisableBarriers("c2Barrier246")
	DisableBarriers("c2Barrier247")
	DisableBarriers("c2Barrier248")
	DisableBarriers("c2Barrier249")
	DisableBarriers("c2Barrier250")
	DisableBarriers("c2Barrier251")
	DisableBarriers("c2Barrier252")
	DisableBarriers("c2Barrier253")
	DisableBarriers("c2Barrier254")
	DisableBarriers("c2Barrier255")
	DisableBarriers("c2Barrier256")
	DisableBarriers("c2Barrier257")
	DisableBarriers("c2Barrier258")
	DisableBarriers("c2Barrier259")
	DisableBarriers("c2Barrier260")
	DisableBarriers("c2Barrier261")
	DisableBarriers("c2Barrier262")
	DisableBarriers("c2Barrier263")
	DisableBarriers("c2Barrier264")
	DisableBarriers("c2Barrier265")
	DisableBarriers("c2Barrier266")
	DisableBarriers("c2Barrier267")
	DisableBarriers("c2Barrier268")
	DisableBarriers("c2Barrier269")
	DisableBarriers("c2Barrier270")
	DisableBarriers("c2Barrier271")
	DisableBarriers("c2Barrier272")
	DisableBarriers("c2Barrier273")
	DisableBarriers("c2Barrier274")
	DisableBarriers("c2Barrier275")
	DisableBarriers("c2Barrier276")
	DisableBarriers("c2Barrier277")
	DisableBarriers("c2Barrier278")
	DisableBarriers("c2Barrier279")
	DisableBarriers("c2Barrier280")
	DisableBarriers("c2Barrier281")
	DisableBarriers("c2Barrier282")
	DisableBarriers("c2Barrier283")
	DisableBarriers("c2Barrier284")
	DisableBarriers("c2Barrier285")
	DisableBarriers("c2Barrier286")
	DisableBarriers("c2Barrier287")
	DisableBarriers("c2Barrier288")
	DisableBarriers("c2Barrier289")
	DisableBarriers("c2Barrier290")
	DisableBarriers("c2Barrier291")
	DisableBarriers("c2Barrier292")
	DisableBarriers("c2Barrier293")
	DisableBarriers("c2Barrier294")
	DisableBarriers("c2Barrier295")
	DisableBarriers("c2Barrier296")
	DisableBarriers("c2Barrier297")
	DisableBarriers("c2Barrier298")
	DisableBarriers("c2Barrier299")
	DisableBarriers("c2Barrier300")
	DisableBarriers("c2Barrier301")
	DisableBarriers("c2Barrier302")
	DisableBarriers("c2Barrier303")
	DisableBarriers("c2Barrier304")
	DisableBarriers("c2Barrier305")
	DisableBarriers("c2Barrier306")
	DisableBarriers("c2Barrier307")
	DisableBarriers("c2Barrier308")
	DisableBarriers("c2Barrier309")
	DisableBarriers("c2Barrier310")
	DisableBarriers("c2Barrier311")
	DisableBarriers("c2Barrier312")
	DisableBarriers("c2Barrier313")
	DisableBarriers("c2Barrier314")
	DisableBarriers("c2Barrier315")
	DisableBarriers("c2Barrier316")
	DisableBarriers("c2Barrier317")
	DisableBarriers("c2Barrier345")
	DisableBarriers("c2Barrier346")
	DisableBarriers("c2Barrier347")
	DisableBarriers("c2Barrier348")
	DisableBarriers("c2Barrier349")
	--[[DisableBarriers("c2Barrier350")
	DisableBarriers("c2Barrier351")
	DisableBarriers("c2Barrier352")
	DisableBarriers("c2Barrier353")
	DisableBarriers("c2Barrier354")
	DisableBarriers("c2Barrier355")
	DisableBarriers("c2Barrier356")
	DisableBarriers("c2Barrier357")
	DisableBarriers("c2Barrier358")
	DisableBarriers("c2Barrier359")
	DisableBarriers("c2Barrier360")
	DisableBarriers("c2Barrier361")
	DisableBarriers("c2Barrier362")
	DisableBarriers("c2Barrier363")
	DisableBarriers("c2Barrier364")
	DisableBarriers("c2Barrier365")]]
	DisableBarriers("c2Barrier366")
	DisableBarriers("c2Barrier367")
	DisableBarriers("c2Barrier368")
	DisableBarriers("c2Barrier369")
	DisableBarriers("c2Barrier370")
	DisableBarriers("c2Barrier371")
	DisableBarriers("c2Barrier372")
	DisableBarriers("c2Barrier373")
	DisableBarriers("c2Barrier374")
	DisableBarriers("c2Barrier375")
	DisableBarriers("c2Barrier376")
	DisableBarriers("c2Barrier377")
	DisableBarriers("c2Barrier378")
	DisableBarriers("c2Barrier379")
	DisableBarriers("c2Barrier380")
	DisableBarriers("c2Barrier381")
	DisableBarriers("c2Barrier382")
	DisableBarriers("c2Barrier383")
	DisableBarriers("c2Barrier384")
	DisableBarriers("c2Barrier385")
	DisableBarriers("c2Barrier386")
	DisableBarriers("c2Barrier387")
	DisableBarriers("c2Barrier388")
	DisableBarriers("c2Barrier389")
	DisableBarriers("c2Barrier390")
	DisableBarriers("c2Barrier391")
	DisableBarriers("c2Barrier392")
	DisableBarriers("c2Barrier393")
	DisableBarriers("c2Barrier394")
	DisableBarriers("c2Barrier395")
	DisableBarriers("c2Barrier396")
	DisableBarriers("c2Barrier397")
	DisableBarriers("c2Barrier398")
	DisableBarriers("c2Barrier399")
	DisableBarriers("c2Barrier400")
	DisableBarriers("c2Barrier401")
	DisableBarriers("c2Barrier402")
	DisableBarriers("c2Barrier403")
	DisableBarriers("c2Barrier447")
	DisableBarriers("c2Barrier447b")
	DisableBarriers("c2Barrier447c")
	DisableBarriers("c2Barrier447d")
end

function VRM_DisableBarriers2()
	DisableBarriers("c1Barrier0")
	DisableBarriers("c1Barrier1")
	DisableBarriers("c1Barrier10")
	DisableBarriers("c1Barrier11")
	DisableBarriers("c1Barrier12")
	DisableBarriers("c1Barrier13")
	DisableBarriers("c1Barrier14")
	DisableBarriers("c1Barrier15")
	DisableBarriers("c1Barrier16")
	DisableBarriers("c1Barrier2")
	DisableBarriers("c1Barrier21")
	DisableBarriers("c1Barrier22")
	DisableBarriers("c1Barrier23")
	DisableBarriers("c1Barrier24")
	DisableBarriers("c1Barrier25")
	DisableBarriers("c1Barrier26")
	DisableBarriers("c1Barrier27")
	DisableBarriers("c1Barrier28")
	DisableBarriers("c1Barrier29")
	DisableBarriers("c1Barrier3")
	DisableBarriers("c1Barrier30")
	DisableBarriers("c1Barrier31")
	DisableBarriers("c1Barrier32")
	DisableBarriers("c1Barrier33")
	DisableBarriers("c1Barrier34")
	DisableBarriers("c1Barrier35")
	DisableBarriers("c1Barrier36")
	DisableBarriers("c1Barrier37")
	DisableBarriers("c1Barrier38")
	DisableBarriers("c1Barrier39")
	DisableBarriers("c1Barrier4")
	DisableBarriers("c1Barrier40")
	DisableBarriers("c1Barrier41")
	DisableBarriers("c1Barrier42")
	DisableBarriers("c1Barrier43")
	DisableBarriers("c1Barrier44")
	DisableBarriers("c1Barrier45")
	DisableBarriers("c1Barrier46")
	DisableBarriers("c1Barrier47")
	DisableBarriers("c1Barrier48")
	DisableBarriers("c1Barrier49")
	DisableBarriers("c1Barrier5")
	DisableBarriers("c1Barrier50")
	DisableBarriers("c1Barrier51")
	DisableBarriers("c1Barrier52")
	DisableBarriers("c1Barrier53")
	DisableBarriers("c1Barrier54")
	DisableBarriers("c1Barrier55")
	DisableBarriers("c1Barrier56")
	DisableBarriers("c1Barrier57")
	DisableBarriers("c1Barrier58")
	DisableBarriers("c1Barrier59")
	--DisableBarriers("c1Barrier6")
	DisableBarriers("c1Barrier60")
	DisableBarriers("c1Barrier61")
	DisableBarriers("c1Barrier62")
	DisableBarriers("c1Barrier63")
	DisableBarriers("c1Barrier64")
	DisableBarriers("c1Barrier65")
	DisableBarriers("c1Barrier66")
	DisableBarriers("c1Barrier67")
	DisableBarriers("c1Barrier68")
	DisableBarriers("c1Barrier69")
	DisableBarriers("c1Barrier7")
	DisableBarriers("c1Barrier70")
	DisableBarriers("c1Barrier71")
	DisableBarriers("c1Barrier72")
	DisableBarriers("c1Barrier73")
	DisableBarriers("c1Barrier74")
	DisableBarriers("c1Barrier75")
	DisableBarriers("c1Barrier76")
	DisableBarriers("c1Barrier77")
	DisableBarriers("c1Barrier78")
	DisableBarriers("c1Barrier79")
	DisableBarriers("c1Barrier8")
	DisableBarriers("c1Barrier80")
	DisableBarriers("c1Barrier81")
	DisableBarriers("c1Barrier82")
	DisableBarriers("c1Barrier83")
	DisableBarriers("c1Barrier84")
	DisableBarriers("c1Barrier85")
	DisableBarriers("c1Barrier318")
	DisableBarriers("c1Barrier319")
	DisableBarriers("c1Barrier320")
	DisableBarriers("c1Barrier321")
	DisableBarriers("c1Barrier322")
	DisableBarriers("c1Barrier323")
	DisableBarriers("c1Barrier324")
	DisableBarriers("c1Barrier325")
	DisableBarriers("c1Barrier326")
	DisableBarriers("c1Barrier327")
	DisableBarriers("c1Barrier328")
	DisableBarriers("c1Barrier329")
	DisableBarriers("c1Barrier330")
	DisableBarriers("c1Barrier331")
	DisableBarriers("c1Barrier332")
	DisableBarriers("c1Barrier333")
	DisableBarriers("c1Barrier334")
	DisableBarriers("c1Barrier335")
	DisableBarriers("c1Barrier336")
	DisableBarriers("c1Barrier337")
	DisableBarriers("c1Barrier338")
	DisableBarriers("C1Barrier339")
	DisableBarriers("c1Barrier340")
	DisableBarriers("c1Barrier341")
	DisableBarriers("c1Barrier342")
	DisableBarriers("c1Barrier343")
	DisableBarriers("c1Barrier344")
	DisableBarriers("c1Barrier388")
	DisableBarriers("c1Barrier389")
	DisableBarriers("c1Barrier390")
	DisableBarriers("c1Barrier391")
	DisableBarriers("c1Barrier392")
	DisableBarriers("c1Barrier393")
	DisableBarriers("c1Barrier394")
	DisableBarriers("c1Barrier395")
	DisableBarriers("c1Barrier396")
	DisableBarriers("c1Barrier397")
	DisableBarriers("c1Barrier398")
	DisableBarriers("c1Barrier399")
	DisableBarriers("c1Barrier400")
	DisableBarriers("c1Barrier401")
	DisableBarriers("c1Barrier402")
	DisableBarriers("c1Barrier403")
	DisableBarriers("c1Barrier404")
	DisableBarriers("c1Barrier405")
	DisableBarriers("c1Barrier406")
	DisableBarriers("c1Barrier407")
	DisableBarriers("c1Barrier408")
	DisableBarriers("c1Barrier409")
	DisableBarriers("c1Barrier410")
	DisableBarriers("c1Barrier411")
	DisableBarriers("c1Barrier412")
	DisableBarriers("c1Barrier447")
	DisableBarriers("c1Barrier447b")
	DisableBarriers("c1Barrier447c")
	--DisableBarriers("c1Barrier447d")
	DisableBarriers("c1Barrier448")
	--DisableBarriers("c1Barrier448b")
	DisableBarriers("c1Barrier449")
	DisableBarriers("c1Barrier450")
	DisableBarriers("c1Barrier451")
	DisableBarriers("c1Barrier452")
	DisableBarriers("c1Barrier453")
	DisableBarriers("c1Barrier454")
	DisableBarriers("c1Barrier526")
	DisableBarriers("c1Barrier527")
	DisableBarriers("c1Barrier528")
end
	print("ME5_MapFunctions: Exited")