if(!SLVBase_Fixed) then
	include("slvbase/slvbase.lua")
	if(!SLVBase_Fixed) then return end
end
local addon = "Fallout"
if(SLVBase_Fixed.AddonInitialized(addon)) then return end
if(SERVER) then
	AddCSLuaFile("autorun/flt_sh_init.lua")
	AddCSLuaFile("autorun/slvbase/slvbase.lua")
end
SLVBase_Fixed.AddDerivedAddon(addon,{tag = "Fallout"})
if(SERVER) then
	Add_NPC_Class("CLASS_ROBOT")
	Add_NPC_Class("CLASS_MIRELURK")
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

SLVBase_Fixed.InitLua("flt_init")

local Category = "Fallout"
SLVBase_Fixed.AddNPC(Category,"Gecko","npc_gecko")
SLVBase_Fixed.AddNPC(Category,"Golden Gecko","npc_gecko_golden")
SLVBase_Fixed.AddNPC(Category,"Fire Gecko","npc_gecko_fire")
SLVBase_Fixed.AddNPC(Category,"Green Gecko","npc_gecko_green")
SLVBase_Fixed.AddNPC(Category,"Gojira","npc_gecko_gojira")

SLVBase_Fixed.AddNPC(Category,"Spore Carrier","npc_sporecarrier")
SLVBase_Fixed.AddNPC(Category,"Trog","npc_streettrog")
SLVBase_Fixed.AddNPC(Category,"Tunneler","npc_tunneler")
SLVBase_Fixed.AddNPC(Category,"Tunneler Queen","npc_tunneler_queen")

SLVBase_Fixed.AddNPC(Category,"Mirelurk","npc_mirelurk")
SLVBase_Fixed.AddNPC(Category,"Nukalurk","npc_nukalurk")
SLVBase_Fixed.AddNPC(Category,"Swamplurk","npc_swamplurk")
SLVBase_Fixed.AddNPC(Category,"Magmalurk","npc_magmalurk")

SLVBase_Fixed.AddNPC(Category,"Deathclaw","npc_deathclaw")
SLVBase_Fixed.AddNPC(Category,"Deathclaw Alphamale","npc_deathclaw_alphamale")
SLVBase_Fixed.AddNPC(Category,"Deathclaw Baby","npc_deathclaw_baby")
SLVBase_Fixed.AddNPC(Category,"Deathclaw Mother","npc_deathclaw_mother")

SLVBase_Fixed.AddNPC(Category,"Giant Mantis","npc_mantis")
SLVBase_Fixed.AddNPC(Category,"Giant Mantis Nymph","npc_mantis_nymph")

SLVBase_Fixed.AddNPC(Category,"Giant Rat","npc_giantrat")

SLVBase_Fixed.AddNPC(Category,"Cazador","npc_cazador")

SLVBase_Fixed.AddNPC(Category,"Feral Ghoul","npc_ghoulferal")
SLVBase_Fixed.AddNPC(Category,"Glowing One","npc_ghoulferal_glowingone")
SLVBase_Fixed.AddNPC(Category,"Swamp Ghoul","npc_ghoulferal_swamp")
SLVBase_Fixed.AddNPC(Category,"Feral Ghoul Roamer","npc_ghoulferal_roamer")
SLVBase_Fixed.AddNPC(Category,"Feral Ghoul Reaver","npc_ghoulferal_reaver")
SLVBase_Fixed.AddNPC(Category,"Feral Ghoul ","npc_ghoulferal_jumpsuit")
SLVBase_Fixed.AddNPC(Category,"Glowing One ","npc_ghoulferal_jumpsuit_gl")

SLVBase_Fixed.AddNPC(Category,"Feral Trooper Ghoul","npc_ghoulferal_trooper")
SLVBase_Fixed.AddNPC(Category,"Glowing Feral Trooper Ghoul","npc_ghoulferal_trooper_gl")

SLVBase_Fixed.AddNPC(Category,"Vault Security Guard","npc_ghoulferal_security")
SLVBase_Fixed.AddNPC(Category,"Vault Security Officer","npc_ghoulferal_security_gl")

SLVBase_Fixed.AddNPC(Category,"Mr Handy","npc_mrhandy")
SLVBase_Fixed.AddNPC(Category,"Army Gutsy","npc_mrgutsy_army")
SLVBase_Fixed.AddNPC(Category,"Winter Gutsy","npc_mrgutsy_anchorage")
SLVBase_Fixed.AddNPC(Category,"Enclave Gutsy","npc_mrgutsy_enclave")
SLVBase_Fixed.AddNPC(Category,"Outcast Gutsy","npc_mrgutsy_outcast")
SLVBase_Fixed.AddNPC(Category,"Andy","npc_mrhandy_andy")
SLVBase_Fixed.AddNPC(Category,"Nuka Handy","npc_mrhandy_nuka")
SLVBase_Fixed.AddNPC(Category,"Brotherhood Gutsy","npc_mrgutsy_bos")