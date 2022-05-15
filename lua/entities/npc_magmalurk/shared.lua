ENT.Base = "npc_mirelurk"
ENT.Type = "ai"

ENT.PrintName = "Magmalurk"
ENT.Category		= "Fallout NPCs"

if(CLIENT) then
	language.Add("npc_magmalurk","Magmalurk")
	local mat = Material("effects/magmalurk_hotglow")
	function ENT:Initialize()
		-- self:DrawModel()
		-- local ent = self
		-- local ragdoll = self:GetNetworkedEntity("ragdoll")
		-- if(ragdoll:IsValid()) then ent = ragdoll end
		-- cam.Start3D(EyePos(),EyeAngles())
			-- render.SetBlend(0.3)
			-- render.MaterialOverride(mat)
				-- ent:DrawModel()
			-- render.MaterialOverride(0)
			-- render.SetBlend(1)
		-- cam.End3D()

		local iIndex = self:EntIndex()
		hook.Add("RenderScreenspaceEffects", "Effect_ShockroachPlasmaOverlay" .. iIndex, function()
			if !IsValid(self) then
				hook.Remove("RenderScreenspaceEffects", "Effect_ShockroachPlasmaOverlay" .. iIndex)
				return
			end
			local ent = self
			local ragdoll = self:GetNetworkedEntity("ragdoll")
			if(ragdoll:IsValid()) then ent = ragdoll end
			if !IsValid(ent) then return end
			cam.Start3D(EyePos(),EyeAngles())
				if util.IsValidModel(ent:GetModel()) then
					render.SetBlend(0.8)
					render.MaterialOverride(mat)
					ent:DrawModel()
					render.MaterialOverride(0)
					render.SetBlend(1)
				end
			cam.End3D()
		end)
	end
end

