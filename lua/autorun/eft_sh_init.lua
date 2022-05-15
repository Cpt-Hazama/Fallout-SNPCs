if(!SLVBase_Fixed) then
	include("slvbase/slvbase.lua")
	if(!SLVBase_Fixed) then return end
end
local addon = "Extra Fallout"
if(SLVBase_Fixed.AddonInitialized(addon)) then return end
if(SERVER) then
	AddCSLuaFile("autorun/eft_sh_init.lua")
	AddCSLuaFile("autorun/slvbase/slvbase.lua")
	AddCSLuaFile("items/meta_inventory.lua")
	AddCSLuaFile("items/meta_item_fallout.lua")
end
include("items/meta_inventory.lua")
local items = {
	["0000080b"] = {
		value = 500,
		weight = 7,
		dmg = 11,
		name = "Chinese Assault Rifle",
		class = "ai_weapon_assaultrifle",
		model = "models/fallout/weapons/w_assaultrifle.mdl",
		holdType = "2ha",
		itemType = ITEM_TYPE_WEAPON
	},
	["0000434f"] = {
		value = 750,
		weight = 3,
		dmg = 22,
		name = "10mm Pistol",
		class = "weapon_10mmpistol",
		model = "models/fallout/weapons/w_10mmpistol.mdl",
		holdType = "1hp",
		itemType = ITEM_TYPE_WEAPON
	},
	["00004327"] = {
		value = 200,
		weight = 7,
		dmg = 6,
		name = "Combat Shotgun",
		class = "weapon_combatshotgun",
		model = "models/fallout/weapons/w_combatshotgun.mdl",
		holdType = "2hr",
		itemType = ITEM_TYPE_WEAPON
	},
	["00004336"] = {
		value = 1000,
		weight = 8,
		dmg = 23,
		name = "Laser Rifle",
		class = "weapon_laserrifle",
		model = "models/fallout/weapons/w_laserrifle.mdl",
		holdType = "2ha",
		itemType = ITEM_TYPE_WEAPON
	},
	["00004344"] = {
		value = 1799,
		weight = 8,
		dmg = 45,
		name = "Plasma Rifle",
		class = "weapon_plasmarifle",
		model = "models/fallout/weapons/w_plasmarifle.mdl",
		holdType = "2hr",
		itemType = ITEM_TYPE_WEAPON
	},
	["0000083b"] = {
		value = 75,
		weight = 3,
		dmg = 24,
		name = "Silver Sword",
		class = "weapon_sword",
		model = "models/darkmessiah/weapons/w_sword_silver.mdl",
		holdType = "2hm",
		itemType = ITEM_TYPE_WEAPON
	}
}
SLVBase_Fixed.AddDerivedAddon(addon,{tag = "Extra Fallout",GetItems = function() return items end})
if(SERVER) then
	Add_NPC_Class("CLASS_ANT")
	Add_NPC_Class("CLASS_FEV")
	Add_NPC_Class("CLASS_TRAUMA")
	Add_NPC_Class("CLASS_FLY")
	Add_NPC_Class("CLASS_ROBOT")
	Add_NPC_Class("CLASS_GECKO")
	Add_NPC_Class("CLASS_DEATHCLAW")
	Add_NPC_Class("CLASS_RODENT")
	Add_NPC_Class("CLASS_FERALGHOUL")
	Add_NPC_Class("CLASS_ANCHORAGE")
	Add_NPC_Class("CLASS_ARMY")
	Add_NPC_Class("CLASS_BOS")
	Add_NPC_Class("CLASS_ENCLAVE")
	Add_NPC_Class("CLASS_OUTCAST")
	Add_NPC_Class("CLASS_NUKA")
	Add_NPC_Class("CLASS_RADSCORPION")
	Add_NPC_Class("CLASS_MUTANT")
	Add_NPC_Class("CLASS_ALIEN")
	Add_NPC_Class("CLASS_RADROACH")
end

game.AddParticles("particles/flame_gargantua.pcf")
game.AddParticles("particles/flame_gojira.pcf")
game.AddParticles("particles/sporecarrier_glow.pcf")
game.AddParticles("particles/sporecarrier_radiation.pcf")
game.AddParticles("particles/magmalurk_flame.pcf")
game.AddParticles("particles/glowingone.pcf")
game.AddParticles("particles/radiation_shockwave.pcf")
game.AddParticles("particles/goregrenade.pcf")
game.AddParticles("particles/plasmapistol.pcf")
game.AddParticles("particles/flamer.pcf")
game.AddParticles("particles/mininuke.pcf")
for _, particle in ipairs({
		"flame_gargantua",
		"flame_gojira",
		"sporecarrier_glow",
		"sporecarrier_radiation",
		"magmalurk_flame",
		"glowingone_testA",
		"radiation_shockwave",
		"goregrenade_splash",
		"plasma_projectile_trail",
		"flamer",
		"plasma_muzzle_flash",
		"mininuke_explosion"
	}) do
	PrecacheParticleSystem(particle)
end

SLVBase_Fixed.InitLua("eft_init")

local Category = "Fallout" // 39 Whopping SNPCs
SLVBase_Fixed.AddNPC(Category,"Albino Radscorpion","npc_albinoradscorpion")
-- SLVBase_Fixed.AddNPC(Category,"Army Protectron","npc_armyprotectron")
SLVBase_Fixed.AddNPC(Category,"Army Sentrybot","npc_armysentrybot")
SLVBase_Fixed.AddNPC(Category,"Bark Radscorpion","npc_barkradscorpion")
SLVBase_Fixed.AddNPC(Category,"Behemoth","npc_behemoth")
SLVBase_Fixed.AddNPC(Category,"Bloatfly","npc_bloatfly")
-- SLVBase_Fixed.AddNPC(Category,"Brahmin","npc_brahmin")
SLVBase_Fixed.AddNPC(Category,"Centaur","npc_centaur")
SLVBase_Fixed.AddNPC(Category,"Corpse Fly","npc_corpsefly")
-- SLVBase_Fixed.AddNPC(Category,"Dog","npc_dog")
-- SLVBase_Fixed.AddNPC(Category,"Dogmeat","npc_dogmeat")
-- SLVBase_Fixed.AddNPC(Category,"Enclave Protectron","npc_enclaveprotectron")
SLVBase_Fixed.AddNPC(Category,"Enclave Sentrybot","npc_enclavesentrybot")
-- SLVBase_Fixed.AddNPC(Category,"Factory Protectron","npc_factoryprotectron")
SLVBase_Fixed.AddNPC(Category,"Failed FEV Subject","npc_fevsubject")
SLVBase_Fixed.AddNPC(Category,"Feral Ghoul Ravager","npc_ghoulferal_ravager")
SLVBase_Fixed.AddNPC(Category,"Giant Fire Ant","npc_fireant")
SLVBase_Fixed.AddNPC(Category,"Giant Ant","npc_giantant")
-- SLVBase_Fixed.AddNPC(Category,"Giant Fire Ant Queen","npc_fireantqueen")
-- SLVBase_Fixed.AddNPC(Category,"Giant Ant Queen","npc_giantantqueen")
SLVBase_Fixed.AddNPC(Category,"Glow Radscorpion","npc_glowradscorpion")
SLVBase_Fixed.AddNPC(Category,"Glowroach","npc_glowroach")
SLVBase_Fixed.AddNPC(Category,"Liberty Prime","npc_libertyprime")
SLVBase_Fixed.AddNPC(Category,"Mirelurk Hunter","npc_mirelurk_hunter")
-- SLVBase_Fixed.AddNPC(Category,"Mirelurk King","npc_mirelurkking")
-- SLVBase_Fixed.AddNPC(Category,"Molerat","npc_molerat")
-- SLVBase_Fixed.AddNPC(Category,"Nuka Protectron","npc_nukaprotectron")
SLVBase_Fixed.AddNPC(Category,"Nuka Radscorpion","npc_nukaradscorpion")
SLVBase_Fixed.AddNPC(Category,"Nukaroach","npc_nukaroach")
-- SLVBase_Fixed.AddNPC(Category,"Outcast Protectron","npc_outcastprotectron")
SLVBase_Fixed.AddNPC(Category,"Outcast Sentrybot","npc_outcastsentrybot")
-- SLVBase_Fixed.AddNPC(Category,"Pack Brahmin","npc_packbrahmin")
-- SLVBase_Fixed.AddNPC(Category,"Protectron","npc_protectron")
SLVBase_Fixed.AddNPC(Category,"Radroach","npc_radroach")
SLVBase_Fixed.AddNPC(Category,"Radscorpion","npc_radscorpion")
SLVBase_Fixed.AddNPC(Category,"Sentrybot","npc_sentrybot")
-- SLVBase_Fixed.AddNPC(Category,"Super Mutant","npc_supermutant")
SLVBase_Fixed.AddNPC(Category,"Support Drone","npc_supportdrone")
-- SLVBase_Fixed.AddNPC(Category,"Swamplurk Queen","npc_swamplurkqueen")
-- SLVBase_Fixed.AddNPC(Category,"Y-17 Trauma Harness","npc_traumaharness")
-- SLVBase_Fixed.AddNPC(Category,"Vicious Dog","npc_viciousdog")
-- SLVBase_Fixed.AddNPC(Category,"Water Brahmin","npc_waterbrahmin")
SLVBase_Fixed.AddNPC(Category,"Winter Sentrybot","npc_wintersentrybot")
-- SLVBase_Fixed.AddNPC(Category,"Yao Guai","npc_yaoguai")

list.Add("NPCUsableWeapons",{class = "weapon_laserrifle",title = "Laser Rifle"})
list.Add("NPCUsableWeapons",{class = "weapon_combatshotgun",title = "Combat Shotgun"})
list.Add("NPCUsableWeapons",{class = "weapon_plasmarifle",title = "Plasma Rifle"})