AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.skName = "tunneler_queen"
ENT.UsePoison = true
ENT.CanUseRadiation = false
ENT.GlowEffects = false
ENT.ScaleExp = 2
function ENT:SubInit()
	self:SetSkin(1)
end