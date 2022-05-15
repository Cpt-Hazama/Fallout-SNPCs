AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_BLOATFLY,CLASS_BLOATFLY)
end
ENT.sModel = "models/fallout/blowfly.mdl"
ENT.fRangeDistance = 1600
ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/bloatfly/"
ENT.skName = "bloatfly"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = false
ENT.CollisionBounds = Vector(20,20,135)
ENT.bFlinchOnDamage = false
ENT.CanSpit = true
ENT.m_tbSounds = {
	["Range"] = "blowfly_attack01.mp3",
	["Death"] = "blowfly_death0[1-2].mp3",
	["Pain"] = "blowfly_injured0[1-2].mp3",
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextSpitAttack = 0
	self.moveaway = false
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
local att = self:GetAttachment(self:LookupAttachment("projectile"))
		if(!att) then return true end
		local vTarget
		if(self:SLV_IsPossesed()) then
			vTarget = self:GetPossessor():GetPossessionEyeTrace().HitPos
			local dir = (vTarget -att.Pos):GetNormal()
			vTarget = att.Pos +dir *math.min(att.Pos:Distance(vTarget),1000)
		else vTarget = self:GetPredictedEnemyPosition(0.8) || (att.Pos +self:GetForward() *500) end
		local entSpit = ents.Create("obj_spit")
		entSpit:SetPos(att.Pos)
		entSpit:SetEntityOwner(self)
		entSpit:SetDamage(23)
		entSpit:SetModel("models/fallout/bloatflydart.mdl")
		entSpit:DrawShadow(true)
		entSpit:SetNoDraw(false)
		entSpit:SetHitSound("npc/blowfly/blowfly_attackdart01.mp3")
		entSpit.OnHit = function(entSpit,ent,dist)
			if(ent:IsPlayer()) then if(ent.AddEffect) then ent:AddEffect("AnimalPoison",true,0.2,24,2,self) end end
		end
		entSpit:Spawn()
		entSpit:Activate()
		local eta = entSpit:SetArcVelocity(att.Pos,vTarget,1500,self:GetForward(),0.65,VectorRand() *0.0125)
		return true
	end
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			if(self.CanSpit && CurTime() >= self.nextSpitAttack && dist <= self.fRangeDistance) then
				self.nextSpitAttack = CurTime() +math.Rand(0.2,2)
				self:SLVPlayActivity(ACT_RANGE_ATTACK1,true)
				return
			end
			if(dist <= 160) then
				self.moveaway = true
				local pos = self:GetPos() +(self:GetPos() -enemy:GetPos()):GetNormal() *120
				if util.IsInWorld(pos) then
					self:GoToPos(pos)
				end
				return
			-- else
				-- self.moveaway = false
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end