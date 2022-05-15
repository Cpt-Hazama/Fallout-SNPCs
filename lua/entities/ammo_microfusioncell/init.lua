
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.AmmoType = "Microfusion Cell"
ENT.AmmoPickup = 24
ENT.MaxAmmo = -1
ENT.model = "models/fallout/ammo/microfusioncell.mdl"

function ENT:SpawnFunction(pl, tr)
	if !tr.Hit then return end
	local pos = tr.HitPos
	local ang = tr.HitNormal:Angle() +Angle(90,0,0)
	local ent = ents.Create("ammo_microfusioncell")
	ent:SetPos(pos +Vector(0,0,1))
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	return ent
end