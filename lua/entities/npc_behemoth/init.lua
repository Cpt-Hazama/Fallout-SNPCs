AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_SUPERMUTANT,CLASS_MUTANT)
end
ENT.sModel = "models/fallout/supermutant_behemoth.mdl"
ENT.fMeleeDistance = 140
ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/supermutant_behemoth/"
ENT.skName = "behemoth"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = true
ENT.CollisionBounds = Vector(80,80,210)
ENT.m_tbSounds = {
	["Melee"] = "supermutantbehemoth_attack0[1-3].mp3",
	["Death"] = "supermutantbehemoth_death0[1-2].mp3",
	["Pain"] = "supermutantbehemoth_injured0[1-2].mp3",
	["FootLeft"] = "foot/supermutantbehemoth_foot_l0[1-2].mp3",
	["FootRight"] = "foot/supermutantbehemoth_foot_r0[1-2].mp3"
}

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_CHEST] = ACT_FLINCH_CHEST,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self:SetBodygroup(1,math.random(0,3))
	-- if math.random(1,2) == 1 then
		-- self:SetBodygroup(2,0)
		-- self.HasHydrant = false
	-- else
		self:SetBodygroup(2,1)
		self.HasHydrant = true
	-- end
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	-- if(event == "lfoot") then
		-- util.ScreenShake(self:GetPos(),85,85,0.4,1500)
		-- return true
	-- end
	-- if(event == "rfoot") then
		-- util.ScreenShake(self:GetPos(),85,85,0.4,1500)
		-- return true
	-- end
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local skDmg
		local force
		local ang
		local fin
		if self.HasHydrant == true then
			fin = "smash"
		else
			fin = "slash"
		end
		local atk = select(2,...)
		if(atk == "leftdown_a") then
			force = Vector(50,0,0)
			ang = Angle(0,50,0)
			skDmg = GetConVarNumber("sk_behemoth_dmg_" .. fin)
		elseif(atk == "leftdown_b") then
			force = Vector(50,0,0)
			ang = Angle(0,80,0)
			skDmg = GetConVarNumber("sk_behemoth_dmg_" .. fin)
		elseif(atk == "rightdown_a") then
			force = Vector(50,0,0)
			ang = Angle(0,-50,0)
			skDmg = GetConVarNumber("sk_behemoth_dmg_" .. fin)
		elseif(atk == "rightdown_b") then
			force = Vector(180,0,20)
			ang = Angle(0,-80,0)
			skDmg = GetConVarNumber("sk_behemoth_dmg_" .. fin)
		end
		self:slvPlaySound("Melee")
		sound.Play(self.sSoundDir .. "supermutantbehemoth_attackmelee0" .. math.random(1,3) .. ".mp3",self:GetPos(),85,100)
		self:DealMeleeDamage(dist,skDmg,ang,force,DMG_CRUSH,nil,true,nil,fcHit)
		return true
	end
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG) then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
	end
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_RANGE_ATTACK2,false,fcDone)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_RANGE_ATTACK2,true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end