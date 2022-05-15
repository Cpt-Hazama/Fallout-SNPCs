AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GECKO
ENT.skName = "gecko_golden"

function ENT:SubInit()
	self:SetSkin(2)
end

function ENT:GenerateInventory()
	self:AddToInventory("0011b9ae")
	if(math.random(1,3) == 1) then self:AddToInventory("0013b2b6") end
	if(math.random(1,5) == 1) then self:AddToInventory("0015E5BF") end
end

function ENT:DealAttackDamage(dist,dmg,ang,force)
	return self:DealMeleeDamage(dist,dmg,ang,force,DMG_RADIATION,nil,true,nil,function(ent,dmg)
		if(ent:IsPlayer()) then
			ent:Irradiate(ent,2)
		end
	end)
end

function ENT:OnRagdollDeath(dmginfo)
	local ragdoll = self:GetRagdollEntity()
	if(!IsValid(ragdoll)) then return end
	local entRAD = ents.Create("point_radiation")
	entRAD:SetEntityOwner(self)
	entRAD:SetPos(ragdoll:GetPos())
	entRAD:SetRAD(math.random(7,9))
	entRAD:SetEmissionDistance(120)
	entRAD:SetLife(8)
	entRAD:SetParent(ragdoll)
	entRAD:Spawn()
	entRAD:Activate()
	ragdoll:DeleteOnRemove(entRAD)
end