AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_SUPERMUTANT,CLASS_MUTANT)
end

ENT.sModel = "models/fallout/supermutant.mdl"
ENT.skName = "supermutant"
ENT.BoneRagdollMain = "Bip01"

ENT.HasMeleeAttack = false
ENT.fRangeDistance = 900
ENT.WeaponLists = {"ai_weapon_assaultrifle"}
ENT.WeaponEquip = "2haequip"
ENT.WeaponUnequip = "2haunequip"
-- ENT.WeaponRun = ACT_RUN_AIM
-- ENT.WeaponWalk = ACT_WALK_AIM
ENT.WeaponMuzzle = "muzzle"
ENT.WeaponFire = "2haattackloop"
ENT.WeaponReload = "2hareloada"

ENT.CollisionBounds = Vector(20,20,103)
ENT.iBloodType = BLOOD_COLOR_RED

ENT.m_bKnockDownable = true
ENT.sSoundDir = "npc/supermutant/"
ENT.m_tbSounds = {
	["Attack"] = "",
	["Death"] = "",
	["Pain"] = "",
	["Idle"] = "",
	["AlertIdle"] = "",
	["LostIdle"] = "",
	["NormalToAlert"] = "",
	["NormalToCombat"] = "",
	["CombatToNormal"] = "",
	["CombatToLost"] = "",
	["AlertToCombat"] = "",
	["AlertToNormal"] = "",
	["LostToCombat"] = "",
	["LostToNormal"] = "",
	["FootLeft"] = "foot/supermutant_foot_l0[1-3].mp3",
	["FootRight"] = "foot/supermutant_foot_r0[1-3].mp3"
}

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}
function ENT:OnWander()
	if CurTime() < self.nextAlertIdle || math.random(1,6) != 1 then return end
	local iState = self:GetState()
	local sound
	if iState == NPC_STATE_ALERT then sound = self:slvPlaySound("AlertIdle")
	elseif iState == NPC_STATE_LOST then sound = self:slvPlaySound("LostIdle") end
	if sound then
		self.nextAlertIdle = CurTime() +SoundDuration(sound) +math.Rand(6,12)
	end
end

function ENT:OnStateChanged(old, new)
	if(self:KnockedDown()) then return end
	if old == NPC_STATE_IDLE then
		if new == NPC_STATE_ALERT then self:slvPlaySound("NormalToAlert")
		elseif new == NPC_STATE_COMBAT then self:slvPlaySound("NormalToCombat") end
	elseif old == NPC_STATE_COMBAT then
		if new == NPC_STATE_IDLE then self:slvPlaySound("CombatToNormal")
		elseif new == NPC_STATE_LOST then self:slvPlaySound("CombatToLost") end
	elseif old == NPC_STATE_ALERT then
		if new == NPC_STATE_COMBAT then self:slvPlaySound("AlertToCombat")
		elseif new == NPC_STATE_IDLE then self:slvPlaySound("AlertToNormal") end
	elseif old == NPC_STATE_LOST then
		if new == NPC_STATE_COMBAT then self:slvPlaySound("LostToCombat")
		elseif new == NPC_STATE_IDLE then self:slvPlaySound("LostToNormal") end
	end
end

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return ang.r >= 0 && ACT_ROLL_RIGHT || ACT_ROLL_LEFT
end

function ENT:EventHandle(...)
	local event = select(1,...)
	local atk = select(2,...)
	local atk2 = select(3,...)
	if(event == "holster") then
		local wep = self:GetActiveWeapon()
		if(!wep:IsValid()) then return true end
		wep:slvPlaySound("Unequip")
		wep:SetNoDraw(true)
		return true
	end
	
	if(event == "2hm") then
		local dmg
		local ang
		local dist
		local lefta = string.find(atk,"lefta")
		local righta = !left && string.find(atk,"righta")
		local leftb = string.find(atk,"leftb")
		local rightb = !left && string.find(atk,"rightb")
		local power = string.find(atk,"power")
		local leftpower = string.find(atk,"leftpower")
		local rightpower = string.find(atk,"rightpower")
		local force
		return true
	end
	
	if(event == "swing") then
		return true
	end
	
	if(event == "mattack") then
		local dmg
		local ang
		local dist
		local lefta = string.find(atk,"lefta")
		local righta = !left && string.find(atk,"righta")
		local leftb = string.find(atk,"leftb")
		local rightb = !left && string.find(atk,"rightb")
		local power = string.find(atk,"power")
		local leftpower = string.find(atk,"leftpower")
		local rightpower = string.find(atk,"rightpower")
		local force
		return true
	end
end

function ENT:SelectWeaponMethods(enemy,dist,distPred,disp)
	if dist < self.fRangeDistance && !self:GunTraceBlocked() && self:GetActiveWeapon().PrimaryClip >= 0 && dist > 40 then
		-- self:RestartGesture(ACT_RANGE_ATTACK1)
		if(CurTime() < self:GetActiveWeapon():GetNextPrimaryFire()) then return end
		self:GetActiveWeapon():DoPrimaryAttack(ShootPos,ShootDir)
		self:PlayLayeredGesture(self.WeaponFire,2,1)
	end
end

local choose
function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			self:SelectWeaponMethods(enemy,dist,distPred,disp)
			if dist < 200 && CurTime() > self.NextRunT then
				self:Interrupt()
				self:MoveToPos(self:GetPos() +self:GetForward() *-500,true)
				self.NextRunT = CurTime() +math.random(1,2)
			end
			if(self.moveSideways) then
				if(CurTime() > self.moveSideways || dist > 120 || dist <= 40) then
					self.moveSideways = nil
					self.nextMoveSideways = CurTime() +math.random(2,5)
				else
					if math.random(1,2) == 1 then
						choose = false
					else
						choose = true
					end
					self:MoveToPosDirect(self:GetPos() +self:GetRight() *(self.moveDir == 0 && 1 || -1) *150,true,true)
					return
				end
			elseif(dist <= 350 && dist > 40) then
				if(CurTime() >= self.nextMoveSideways) then
					if(math.random(1,1) == 1) then
						if math.random(1,2) == 1 then
							choose = false
						else
							choose = true
						end
						self.moveSideways = CurTime() +math.Rand(2,3)
						self.moveDir = math.random(0,1)
						self:MoveToPosDirect(self:GetPos() +self:GetRight() *(self.moveDir == 0 && 1 || -1) *150,true,true)
						return
					else self.nextMoveSideways = CurTime() +math.random(3,5) end
				end
			end
			if(self.HasMeleeAttack && dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(self.MeleeAttack,true)
				return
			end
		end
		if(dist > self.fRangeDistance) then self.m_bGunWalk = false; self:ChaseEnemy(); return else self:FaceEnemy() end
		if(dist > 1000) then
			self.m_bGunWalk = true
			self:ChaseEnemy()
		end
	elseif(disp == D_FR) then
		self:Hide()
	end
end