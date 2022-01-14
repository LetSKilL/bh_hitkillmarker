if CLIENT then return end

AddCSLuaFile("config.lua")
util.AddNetworkString("bh_sb_dmgind")

local function dmgtake(ent, dmginfo, took)
    if !took then return end
    if (ent:IsNPC() or ent:IsPlayer()) and dmginfo:GetAttacker():IsPlayer() then
        net.Start("bh_sb_dmgind")
        net.WriteUInt(math.Clamp(dmginfo:GetDamage(), 0, 4294967294), 32) --Expanded to 32 bits for sandbox
        net.WriteBool(ent:IsNPC())
        net.Send(dmginfo:GetAttacker())
    end
end

hook.Add("PostEntityTakeDamage", "bhunt_damageind", dmgtake)

local function killind(vic, atk, infl)
    if !atk:IsPlayer() then return end

    net.Start("bh_sb_dmgind")
    net.WriteUInt(4294967295, 32)
    net.WriteBool(vic:IsNPC())
    net.Send(atk)
end

hook.Add("PlayerDeath", "bhunt_killind_ply", killind)
hook.Add("OnNPCKilled", "bhunt_killind_npc", killind)