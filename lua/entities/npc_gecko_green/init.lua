AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.skName = "gecko_green"
ENT.AllowSpitAttack  = true

function ENT:SubInit()
	self:SetSkin(3)
end

function ENT:GenerateInventory()
	self:AddToInventory("0011b9ae")
	if(math.random(1,3) == 1) then self:AddToInventory("0100F84B") end
	if(math.random(1,5) == 1) then self:AddToInventory("0100F848") end
end