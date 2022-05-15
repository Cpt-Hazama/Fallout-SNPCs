AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ENCLAVE,CLASS_ENCLAVE)
end

function ENT:SetupRelationship(entTgt)
	local faction = self:SLVGetFaction()
	if(faction == FACTION_NONE) then return end
	if(entTgt:IsPlayer()) then
		local faction = entTgt:SLVGetFaction()
		if(faction != FACTION_NONE && faction != self.Faction) then
			self:slvAddEntityRelationship(entTgt,D_HT,100)
			return true
		end
	end
end

function ENT:SubInit()
	self:SetSkin(3)
end

