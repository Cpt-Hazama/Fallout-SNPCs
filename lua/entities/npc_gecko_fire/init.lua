AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GECKO
ENT.skName = "gecko_fire"
ENT.AllowFireAttack = true
ENT.bIgnitable = false

function ENT:SubInit()
	self:SetSkin(1)
	self:SetBodygroup(6,1)
	self:SetBodygroup(7,1)
end

function ENT:OnLimbLost(hitbox,entCap,dmg)
	if(hitbox == HITBOX_HEAD) then
		entCap:SetBodygroup(1,1)
		self:SetBodygroup(6,0)
	end
end

function ENT:GenerateInventory()
	self:AddToInventory("0011b9ae")
	if(math.random(1,3) == 1) then self:AddToInventory("0013b2b7") end
	if(math.random(1,5) == 1) then self:AddToInventory("0015E5BE") end
end