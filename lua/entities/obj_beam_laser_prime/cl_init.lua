include('shared.lua')

local matBeam = Material("cable/physbeam.vmt") // cable/redlaser
-- local matBeam = Material("sprites/strider_bluebeam.vmt")

ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:Initialize()
	local iIndex = self:EntIndex()
	hook.Add("RenderScreenspaceEffects", "Effect_LaserBeam" .. iIndex, function()
		if !IsValid(self) then
			hook.Remove("RenderScreenspaceEffects", "Effect_LaserBeam" .. iIndex)
			return
		end
		
		local Owner = self:GetOwner()
		if !IsValid(Owner) then return end
		local posDest = self:GetNetworkedVector("dest")
		if posDest:Length() == 0 then return end
		local posStart = Owner:GetAttachment(Owner:LookupAttachment("eye")).Pos
		cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial(matBeam)
			local TexOffset = CurTime() *-2.0
			render.DrawBeam(posStart, posDest, 18, TexOffset *-0.4, TexOffset *-0.4 +posStart:Distance(posDest) /256, Color(255,255,255,255))
		cam.End3D()
	end)
end

function ENT:Think()
end

function ENT:Draw()
end

function ENT:IsTranslucent()
	return true
end
