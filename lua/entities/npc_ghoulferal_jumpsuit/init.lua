AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GHOUL
local BodyCaps = {
	["models/fallout/ghoulferal_bodycap_head.mdl"] = {
		bones = {"Bip01 Head","Bip01 Head2"},
		boneCap = "Bip01 Head",
		att = "bodycap_head",
		bodygroup = 0,
		hitbox = HITBOX_HEAD
	},
	["models/fallout/ghoulferal_jumpsuit_bodycap_leftleg.mdl"] = {
		bones = {"Bip01 L Thigh","Bip01 L Calf","Bip01 L Foot"},
		boneCap = "Bip01 L Calf",
		att = "bodycap_leftleg",
		bodygroup = 1,
		hitbox = HITBOX_LEFTLEG
	},
	["models/fallout/ghoulferal_jumpsuit_bodycap_rightleg.mdl"] = {
		bones = {"Bip01 R Calf","Bip01 R Foot"},
		boneCap = "Bip01 R Calf",
		att = "bodycap_rightleg",
		bodygroup = 2,
		hitbox = HITBOX_RIGHTLEG
	},
	["models/fallout/ghoulferal_bodycap_leftarm.mdl"] = {
		bones = {"Bip01 L UpperArm","Bip01 L Forearm","Bip01 L ForeTwist","Bip01 LUpArmTwist"},
		boneCap = "Bip01 L Forearm",
		att = "bodycap_leftarm",
		bodygroup = 3,
		hitbox = HITBOX_LEFTARM
	},
	["models/fallout/ghoulferal_bodycap_rightarm.mdl"] = {
		bones = {"Bip01 R UpperArm","Bip01 R Forearm","Bip01 R ForeTwist","Bip01 RUpArmTwist"},
		boneCap = "Bip01 R Forearm",
		att = "bodycap_rightarm",
		bodygroup = 4,
		hitbox = HITBOX_RIGHTARM
	}
}

function ENT:GetBodyCaps() return BodyCaps end

ENT.sModel = "models/fallout/ghoulferal_jumpsuit.mdl"
function ENT:SubInit()
	local skin = math.random(0,2)
	if(skin == 2) then skin = 3 end
	self:SetSkin(skin)
end