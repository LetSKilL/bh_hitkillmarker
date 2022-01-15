local khm_default = {
    hm_enabled = 1,

    hm_ply = 1,
    hm_ply_r = 255,
    hm_ply_g = 0,
    hm_ply_b = 0,
    hm_ply_a = 188,

    hm_npc = 1,
    hm_npc_r = 200,
    hm_npc_g = 162,
    hm_npc_b = 200,
    hm_npc_a = 188,

    hm_ply_offset = 50,
    hm_ply_width = 10,
    hm_ply_height = 80,
    hm_ply_speed = 0.1,

    hm_npc_use_ply = 1,
    hm_npc_offset = 50,
    hm_npc_width = 10,
    hm_npc_height = 80,
    hm_npc_speed = 0.1,

    hm_test = 0,
    hm_test_npc = 0,

    km_enabled = 1,
    km_test = 0,
    km_test_npc = 0,

    km_ply = 1,
    km_npc = 1,

    km_npc_r = 200,
    km_npc_g = 162,
    km_npc_b = 200,
    km_npc_a = 188,

    km_ply_r = 255,
    km_ply_g = 0,
    km_ply_b = 0,
    km_ply_a = 188,

    km_npc_use_ply = 1,
    km_npc_speed = 0.1,
    km_npc_size = 600,
    km_npc_offset = 20,
    km_npc_width = 3,

    km_ply_speed = 0.1,
    km_ply_size = 600,
    km_ply_offset = 20,
    km_ply_width = 3
}

for k,v in pairs(khm_default) do
    if !ConVarExists(k) then
        CreateConVar(k, v, FCVAR_ARCHIVE)
    end
end

hook.Add( "AddToolMenuCategories", "CustomCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "BH Hit/Kill Markers", "Hit/Kill Markers" )
end )

hook.Add( "PopulateToolMenu", "CustomMenuSettings", function()
	spawnmenu.AddToolMenuOption( "Utilities", "BH Hit/Kill Markers", "HMark", "Hit marker", "", "", function( panel )
        panel:ClearControls()

        panel:CheckBox("Enabled?", "hm_enabled")
        panel:CheckBox("Test mode", "hm_test")
        panel:CheckBox("NPC test", "hm_test_npc")

        panel:CheckBox("Player hitmarkers", "hm_ply")
        panel:CheckBox("NPC hitmarkers", "hm_npc")

        panel:Help("Player hit color")
        local ply_hit_color = vgui.Create("DColorMixer", panel)
        ply_hit_color:SetPalette(true)  			
        ply_hit_color:SetAlphaBar(true) 			
        ply_hit_color:SetWangs(true) 				
        ply_hit_color:SetColor(Color(GetConVar("hm_ply_r"):GetInt(),GetConVar("hm_ply_g"):GetInt(),GetConVar("hm_ply_b"):GetInt(),GetConVar("hm_ply_a"):GetInt())) 	-- Set the default color
        ply_hit_color:SetConVarA("hm_ply_a")
        ply_hit_color:SetConVarR("hm_ply_r")
        ply_hit_color:SetConVarG("hm_ply_g")
        ply_hit_color:SetConVarB("hm_ply_b")

        panel:AddItem(ply_hit_color)

        panel:Help("NPC hit color")
        local npc_hit_color = vgui.Create("DColorMixer", panel)
        npc_hit_color:SetPalette(true)  			
        npc_hit_color:SetAlphaBar(true) 			
        npc_hit_color:SetWangs(true) 				
        npc_hit_color:SetColor(Color(GetConVar("hm_npc_r"):GetInt(),GetConVar("hm_npc_g"):GetInt(),GetConVar("hm_npc_b"):GetInt(),GetConVar("hm_npc_a"):GetInt())) 	-- Set the default color
        npc_hit_color:SetConVarA("hm_npc_a")
        npc_hit_color:SetConVarR("hm_npc_r")
        npc_hit_color:SetConVarG("hm_npc_g")
        npc_hit_color:SetConVarB("hm_npc_b")

        panel:AddItem(npc_hit_color)

        panel:Help("Player hitmarker appearance")
        panel:NumSlider("Screen center offset", "hm_ply_offset", 0, 500, 2)
        panel:NumSlider("Width", "hm_ply_width", 0, 50, 2)
        panel:NumSlider("Height (size)", "hm_ply_height", 0, 200, 2)
        panel:NumSlider("Animation speed", "hm_ply_speed", 0, 1)

        panel:Help("NPC hitmarker appearance")
        panel:CheckBox("Use player hitmarker settings", "hm_npc_use_ply")
        panel:NumSlider("Screen center offset", "hm_npc_offset", 0, 500, 2)
        panel:NumSlider("Width", "hm_npc_width", 0, 50, 2)
        panel:NumSlider("Height (size)", "hm_npc_height", 0, 200, 2)
        panel:NumSlider("Animation speed", "hm_npc_speed", 0, 1)
    end )

    spawnmenu.AddToolMenuOption( "Utilities", "BH Hit/Kill Markers", "KMark", "Kill marker", "", "", function( panel )
        panel:CheckBox("Enable", "km_enabled")
        panel:CheckBox("Test mode", "km_test")
        panel:CheckBox("NPC test", "km_test_npc")

        panel:CheckBox("Player kill markers", "km_ply")
        panel:CheckBox("NPC kill markers", "km_npc")

        panel:Help("Player kill color")
        local ply_hit_color = vgui.Create("DColorMixer", panel)
        ply_hit_color:SetPalette(true)  			
        ply_hit_color:SetAlphaBar(true) 			
        ply_hit_color:SetWangs(true) 				
        ply_hit_color:SetColor(Color(GetConVar("km_ply_r"):GetInt(),GetConVar("km_ply_g"):GetInt(),GetConVar("km_ply_b"):GetInt(),GetConVar("km_ply_a"):GetInt())) 	-- Set the default color
        ply_hit_color:SetConVarA("km_ply_a")
        ply_hit_color:SetConVarR("km_ply_r")
        ply_hit_color:SetConVarG("km_ply_g")
        ply_hit_color:SetConVarB("km_ply_b")

        panel:AddItem(ply_hit_color)

        panel:Help("NPC kill color")
        local npc_hit_color = vgui.Create("DColorMixer", panel)
        npc_hit_color:SetPalette(true)  			
        npc_hit_color:SetAlphaBar(true) 			
        npc_hit_color:SetWangs(true) 				
        npc_hit_color:SetColor(Color(GetConVar("km_npc_r"):GetInt(),GetConVar("km_npc_g"):GetInt(),GetConVar("km_npc_b"):GetInt(),GetConVar("km_npc_a"):GetInt())) 	-- Set the default color
        npc_hit_color:SetConVarA("km_npc_a")
        npc_hit_color:SetConVarR("km_npc_r")
        npc_hit_color:SetConVarG("km_npc_g")
        npc_hit_color:SetConVarB("km_npc_b")

        panel:AddItem(npc_hit_color)

        panel:Help("Player kill marker appearence")
        panel:NumSlider("Animation speed", "km_ply_speed", 0, 1)
        panel:NumSlider("Size", "km_ply_size", 0, 2000)
        panel:NumSlider("Width", "km_ply_width", 0, 50)
        panel:NumSlider("Space between lines", "km_ply_offset", 0, 200)

        panel:Help("NPC kill marker appearence")
        panel:CheckBox("Use player killmarker settings", "km_npc_use_ply")
        panel:NumSlider("Animation speed", "km_npc_speed", 0, 1)
        panel:NumSlider("Size", "km_npc_size", 0, 2000)
        panel:NumSlider("Width", "km_npc_width", 0, 50)
        panel:NumSlider("Space between lines", "km_npc_offset", 0, 200)
    end)
end )
