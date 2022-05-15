AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_RADSCORPION,CLASS_RADSCORPION)
end
ENT.sModel = "models/fallout/barkscorpion.mdl"
ENT.skName = "bark_radscorpion"
ENT.CollisionBounds = Vector(30,30,40)

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local dmg
		local dist
		local ang,force
		local atk = select(2,...)
		local left = string.find(atk,"left")
		local right = !left && string.find(atk,"right")
		local power = string.find(atk,"power")
		local usep = false
		if(power) then
			force = Vector(260,0,0)
			if(left || right) then
				dmg = 22
				if(left) then ang = Angle(4,34,0)
				else ang = Angle(4,-34,0) end
			else
				usep = true
				dmg = 14
				ang = Angle(-25,0,0)
			end
			local forward = string.find(atk,"forward")
			if(!forward) then dist = self.fMeleeDistance
			else dist = 80 usep = true end
		else
			dist = self.fMeleeDistance
			force = Vector(180,0,0)
			dmg = 14
			if(left) then ang = Angle(2,25,0)
			else ang = Angle(2,-25,0) end
		end
		local fcHit
		force = force *self.ForceMultiplier
		if usep == false then
			self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,nil,nil,fcHit)
		else
			self:DealMeleeDamage(dist,dmg,ang,force,DMG_ACID,nil,true,nil,function(ent,dmginfo) self:Poison(ent) end)
		end
		return true
	end
end

function ENT:Poison(ent)
	if(ent:IsPlayer()) then ent:ConCommand("play fx/fx_poison_stinger.mp3") end
	local tm = "npcpoison" .. self:EntIndex() .. "_" .. ent:EntIndex()
	timer.Create(tm,0.5,5,function()
		if(!ent:IsValid() || !ent:Alive()) then timer.Remove(tm)
		else
			local attacker
			if(self:IsValid()) then attacker = self
			else attacker = ent end
			local dmg = DamageInfo()
			dmg:SetDamageType(DMG_NERVEGAS)
			dmg:SetDamage(2)
			dmg:SetAttacker(attacker)
			dmg:SetInflictor(attacker)
			dmg:SetDamagePosition(ent:GetPos() +ent:OBBCenter())
			ent:TakeDamageInfo(dmg)
		end
	end)
end