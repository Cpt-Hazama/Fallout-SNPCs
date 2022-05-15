AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_GHOUL,CLASS_GHOUL)
end
ENT.sModel = "models/fallout/ghoulferal_ravager.mdl"
ENT.CanUseGrenade = true
ENT.CanUseRadiation = true
ENT.CanRegenHealth = true
ENT.skName = "ghoulferal_ravager"
function ENT:GetBodyCaps() end
function ENT:SubInit()
	local pat = "glowingone_testc"
	ParticleEffectAttach(pat,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("grenade"))
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	if(self.CanUseGrenade) then
		self:SLVPlayActivity(ACT_ARM,true)
		self.bInSchedule = true
		return
	end
	fcDone(true)
end

function ENT:_PossReload(entPossessor,fcDone)
	if(self.CanUseRadiation) then
		self:SLVPlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
		return
	end
	fcDone(true)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end