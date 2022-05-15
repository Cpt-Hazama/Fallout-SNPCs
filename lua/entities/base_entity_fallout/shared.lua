
ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

function ENT:GetBaseClass(class)
	class = class || self.Base
	local base = self.BaseClass
	while(base && base.ClassName != class) do base = base.BaseClass end
	return base
end