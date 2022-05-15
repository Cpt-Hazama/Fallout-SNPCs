AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ROACH,CLASS_RADROACH)
end
ENT.sModel = "models/fallout/radroach.mdl"
ENT.fMeleeDistance = 45
ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/radroach/"
ENT.skName = "radroach"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = true
ENT.CollisionBounds = Vector(25,25,35)
ENT.m_tbSounds = {
	["Melee"] = "roach_attack0[1-3].mp3",
	["Death"] = "roach_death0[1-3].mp3",
	["Idle"] = "roach_idle0[1-3].mp3",
	["FootLeft"] = "foot/roach_foot_l0[1-3].mp3",
	["FootRight"] = "foot/roach_foot_r0[1-3].mp3"
}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM)
	self:SetHullSizeNormal()
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:SelectGetUpActivity()
	return ACT_ROLL_LEFT
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local skDmg = GetConVarNumber("sk_radroach_dmg_slash")
		local force
		local ang
		local atk = select(2,...)
		if(atk == "left") then
			force = Vector(50,0,0)
			ang = Angle(-20,0,0)
		elseif(atk == "leftjump") then
			force = Vector(50,0,0)
			ang = Angle(-50,0,0)
		end
		self:slvPlaySound("Melee")
		self:DealMeleeDamage(dist,skDmg,ang,force,DMG_CRUSH,nil,true,nil,fcHit)
		return true
	end
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end