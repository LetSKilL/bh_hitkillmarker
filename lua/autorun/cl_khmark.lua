if SERVER then return end

local dmg_leafs = {0,0,0, 0,0,0, 0,0,0, 0,0,0} --every 30*
local dmg_leafs_npc = {false,false,false, false,false,false, false,false,false, false,false,false}
local dmg_cur_leaf = 1
local dmg_last = CurTime()

local kill_lines = {0,0,0,0,0}
local kill_lines_npc = {false, false, false, false, false}

local function DrawDamageInd()
    for k, fract in ipairs(dmg_leafs) do
        if fract > 0 then
            local col = Color(0,0,0)
            if dmg_leafs_npc[k] then
                col = Color(GetConVar("hm_npc_r"):GetInt(),GetConVar("hm_npc_g"):GetInt(),GetConVar("hm_npc_b"):GetInt(),GetConVar("hm_npc_a"):GetInt() * fract)
            else
                col = Color(GetConVar("hm_ply_r"):GetInt(),GetConVar("hm_ply_g"):GetInt(),GetConVar("hm_ply_b"):GetInt(),GetConVar("hm_ply_a"):GetInt() * fract)
            end
            if GetConVar("hm_npc_use_ply"):GetBool() then
                local size = GetConVar("hm_ply_height"):GetInt() * (1-fract)
                local offset = GetConVar("hm_ply_offset"):GetInt()

                local xx = (offset+size*0.5) * math.sin(math.rad(30*k)) - (offset+size*0.5) * math.cos(math.rad(30*k))
                local yy = (offset+size*0.5) * math.cos(math.rad(30*k)) + (offset+size*0.5) * math.sin(math.rad(30*k))  

                draw.NoTexture()
                surface.SetDrawColor(col)
                surface.DrawTexturedRectRotated(ScrW()*0.5 + xx, ScrH()*0.5 + yy, GetConVar("hm_ply_width"):GetInt(), size, -45 + 30 * k)

                dmg_leafs[k] = Lerp(GetConVar("hm_ply_speed"):GetFloat(), dmg_leafs[k], -0.2)
            else
                if dmg_leafs_npc[k] then
                    local size = GetConVar("hm_npc_height"):GetInt() * (1-fract)
                    local offset = GetConVar("hm_npc_offset"):GetInt()

                    local xx = (offset+size*0.5) * math.sin(math.rad(30*k)) - (offset+size*0.5) * math.cos(math.rad(30*k))
                    local yy = (offset+size*0.5) * math.cos(math.rad(30*k)) + (offset+size*0.5) * math.sin(math.rad(30*k))  

                    draw.NoTexture()
                    surface.SetDrawColor(col)
                    surface.DrawTexturedRectRotated(ScrW()*0.5 + xx, ScrH()*0.5 + yy, GetConVar("hm_npc_width"):GetInt(), size, -45 + 30 * k)

                    dmg_leafs[k] = Lerp(GetConVar("hm_npc_speed"):GetFloat(), dmg_leafs[k], -0.2)
                else
                    local size = GetConVar("hm_ply_height"):GetInt() * (1-fract)
                    local offset = GetConVar("hm_ply_offset"):GetInt()
    
                    local xx = (offset+size*0.5) * math.sin(math.rad(30*k)) - (offset+size*0.5) * math.cos(math.rad(30*k))
                    local yy = (offset+size*0.5) * math.cos(math.rad(30*k)) + (offset+size*0.5) * math.sin(math.rad(30*k))  
    
                    draw.NoTexture()
                    surface.SetDrawColor(col)
                    surface.DrawTexturedRectRotated(ScrW()*0.5 + xx, ScrH()*0.5 + yy, GetConVar("hm_ply_width"):GetInt(), size, -45 + 30 * k)
    
                    dmg_leafs[k] = Lerp(GetConVar("hm_ply_speed"):GetFloat(), dmg_leafs[k], -0.2)
                end
            end

            if dmg_leafs[k] < 0 and dmg_leafs_npc[k] then
                dmg_leafs_npc[k] = false
            end
        end
    end

    if dmg_last + 2 < CurTime() then
        dmg_cur_leaf = dmg_cur_leaf + 1
        if dmg_cur_leaf > #dmg_leafs then
            dmg_cur_leaf = 1
        end

        dmg_last = dmg_last + 0.2
    end

    for k, fract in ipairs(kill_lines) do
        if fract > 0 then
            local fullsize = GetConVar("km_ply_size"):GetInt()
            local col = Color(0,0,0)
            if kill_lines_npc[k] then
                col = Color(GetConVar("hm_npc_r"):GetInt(),GetConVar("hm_npc_g"):GetInt(),GetConVar("hm_npc_b"):GetInt(),GetConVar("hm_npc_a"):GetInt() * fract)
            else
                col = Color(GetConVar("hm_ply_r"):GetInt(),GetConVar("hm_ply_g"):GetInt(),GetConVar("hm_ply_b"):GetInt(),GetConVar("hm_ply_a"):GetInt() * fract)
            end
            
            local offset = fullsize*0.25 - 0.5*fullsize* (1-fract)
            local size = fullsize*math.min(1-fract, 0.5)*2 - fullsize*(math.max(1-fract, 0.5))

            local xx = -offset + GetConVar("km_ply_offset"):GetInt() * (-1 + 2*(k%2)) * math.floor(k/2) * math.min(k-1, 1)
            local yy = offset + GetConVar("km_ply_offset"):GetInt() * (-1 + 2*(k%2)) * math.floor(k/2) * math.min(k-1, 1)
            
            draw.NoTexture()
            surface.SetDrawColor(col)
            surface.DrawTexturedRectRotated(ScrW()*0.5 - xx, ScrH()*0.5 - yy, size, 3, 225)

            kill_lines[k] = Lerp(0.1, fract, -0.2)
        end
    end
end

local hm_test_timer = 0.3

hook.Add("HUDPaint", "bh_sb_HitKillMarker", function()
    if GetConVar("hm_test"):GetBool() then
        dmg_cur_leaf = 1
        dmg_leafs = {dmg_leafs[1],1,0.9, 0.8,0.7,0.6, 0.5,0.4,0.3, 0.2,0.1,0}

        if GetConVar("hm_test_npc"):GetBool() then
            dmg_leafs_npc = {true,true,true, true,true,true, true,true,true, true,true,true}
        else
            dmg_leafs_npc = {false,false,false, false,false,false, false,false,false, false,false,false}
        end

        if dmg_leafs[1] <= 0 then
            if hm_test_timer > 0 then
                hm_test_timer = hm_test_timer - FrameTime()
            else
                dmg_leafs[1] = 1
                hm_test_timer = 0.3
            end
        end
    end
    DrawDamageInd()
end)

net.Receive("bh_sb_dmgind", function ()
    local dmg = net.ReadUInt(32)
    local _isnpc = net.ReadBool()

    if dmg == 4294967295 then
        for k,v in ipairs(kill_lines) do
            if v <= 0 then
                kill_lines[k] = 1
                kill_lines_npc[k] = _isnpc
                return
            end
        end
    else
        if (_isnpc and !GetConVar("hm_npc"):GetBool()) or (!_isnpc and !GetConVar("hm_ply"):GetBool()) then return end
        dmg_cur_leaf = dmg_cur_leaf + 1
        if dmg_cur_leaf > #dmg_leafs then
            dmg_cur_leaf = 1
        end

        dmg_leafs[dmg_cur_leaf] = 1
        dmg_leafs_npc[dmg_cur_leaf] = _isnpc
        dmg_last = CurTime()
    end
end)

include("config.lua")
