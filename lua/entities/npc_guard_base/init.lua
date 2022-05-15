AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:GuardInit()
	if(self.m_bActive == false) then
		self:SetNeutral(true)
		self.m_bDeactivated = true
	else self.m_bActive = true; self.cspIdleLoop:Play() end
end

function ENT:OnStandUp()
	self:PlayMovementSound()
	if(!self:IsActive()) then
		self.m_bDeactivated = nil
		self.m_bActive = true
	end
end

function ENT:Retreat()
	self:MoveToPos(self.m_posRetreat)
end

function ENT:OnFoundEnemy(iEnemies)
	self.m_bRetreating = nil
	self.m_nextRetreat = nil
	if(!self:IsActive()) then self:Reactivate() end
end

function ENT:KeyValueHandle(key,value)
	if(key == "startactive") then self.m_bActive = tobool(value) end
end

function ENT:Guarding() return self.m_bGuarding || false end

function ENT:Guard(posGuard,guardRadius,posRetreat,yawRetreat)
	self.m_bGuarding = true
	self.m_posGuard = posGuard
	self.m_guardRadius = guardRadius
	self.m_posRetreat = posRetreat || posGuard
	self.m_yawRetreat = yawRetreat
	self:SetBehavior(2,posGuard,guardRadius)
	if(!self:IsActive()) then return end
	self.m_nextRetreat = CurTime() +8
end

function ENT:PlayMovementSound() end

function ENT:StopMovementSound() end

function ENT:Reactivate()
	if(self.m_bActive) then return end
	self:PlayMovementSound()
	self:SetNeutral(false)
	self.m_bDeactivated = nil
	self.m_bActive = true
	self:EmitEventSound("GuardActivate")
	self:SLVPlayActivity(ACT_IDLE_AGITATED)
end

function ENT:IsActive() return self.m_bActive end

function ENT:Deactivate()
	if(!self.m_bActive) then return end
	self:SetNeutral(true)
	self:EmitEventSound("GuardDeactivate")
	self.m_bActive = false
	self:SLVPlayActivity(ACT_IDLE_RELAXED)
	self:StopMovementSound()
end

function ENT:InputHandle(cvar,activator,caller,data)
	if(cvar == "reactivate") then self:Reactivate()
	elseif(cvar == "deactivate") then self:Deactivate() end
end

function ENT:GuardStateChanged(old,new)
	if(!self:IsActive()) then
		if(new == NPC_STATE_ALERT || new == NPC_STATE_COMBAT) then
			self:Reactivate()
		end
		return
	elseif(self:Guarding() && (old == NPC_STATE_ALERT || old == NPC_STATE_COMBAT) && new != NPC_STATE_ALERT && new != NPC_STATE_COMBAT) then self.m_nextRetreat = CurTime() +8 end
end

function ENT:GuardThink()
	if(!self:IsActive()) then
		if(self.m_bDeactivated) then
			self:ResetSequence(self:LookupSequence("specialidle_deactivate"))
			self:SetCycle(1)
		end
		return
	end
	if(self:KnockedDown()) then return end
	if(self:Guarding() && (!self.IsInteracting || !self:IsInteracting())) then
		if(self.m_nextRetreat && CurTime() >= self.m_nextRetreat) then
			self.m_nextRetreat = nil
			self.m_bRetreating = true
			self:slvPlaySound("Deactivate")
		elseif(self.m_bRetreating) then
			if(self:NearestPoint(self.m_posRetreat):Distance(self.m_posRetreat) <= 50) then
				if(self.m_yawRetreat && math.abs(math.AngleDifference(self.m_yawRetreat,self:GetAngles().y)) > 5) then
					if(!self:IsMoving()) then
						local ang = Angle(0,self.m_yawRetreat,0)
						self:TurnDegree(3,ang)
					end
				else
					self.m_bRetreating = nil
					self:Deactivate()
				end
			elseif(!self.CurrentSchedule) then self:Retreat() end
		end
	end
end

function ENT:GuardEvent(event)
	if(string.find(event,"deactivate")) then
		self.m_bDeactivated = true
		return
	end
end