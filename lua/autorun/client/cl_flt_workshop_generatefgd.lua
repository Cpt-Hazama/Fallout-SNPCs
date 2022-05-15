// Since garry doesn't allow uploading txt-files to the workshop, we'll have to create them when the addon is initialized.
// Stupid as hell, but there's no other way.

file.CreateDir("wrench")
file.CreateDir("wrench/fgd")

local f = "wrench/fgd/fallout.txt"
if(file.Exists(f,"DATA")) then return end
file.Write(f,[[@include "base.fgd"
@BaseClass base(BaseNPC) color(0 200 200) = BaseNPCSlv
[
	
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/cazadore.mdl") = npc_cazador : "Cazador"
[
	health(integer) : "Health" : 160 : 
        "Health of this NPC. " +
	"Default: 160"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/deathclaw.mdl") = npc_deathclaw : "Deathclaw"
[
	health(integer) : "Health" : 400 : 
        "Health of this NPC. " +
	"Default: 400"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/deathclaw_alphamale.mdl") = npc_deathclaw_alphamale : "Deathclaw Alphamale"
[
	health(integer) : "Health" : 850 : 
        "Health of this NPC. " +
	"Default: 850"
]

@NPCClass base(BaseNPCSlv) studio("models/skyrim/deathclaw_baby.mdl") = npc_deathclaw_baby : "Deathclaw Baby"
[
	health(integer) : "Health" : 240 : 
        "Health of this NPC. " +
	"Default: 240"
]

@NPCClass base(BaseNPCSlv) studio("models/skyrim/deathclaw_mother.mdl") = npc_deathclaw_mother : "Deathclaw Mother"
[
	health(integer) : "Health" : 650 : 
        "Health of this NPC. " +
	"Default: 650"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/gecko.mdl") = npc_gecko : "Gecko"
[
	health(integer) : "Health" : 140 : 
        "Health of this NPC. " +
	"Default: 140"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/gecko.mdl") = npc_gecko_fire : "Fire Gecko"
[
	health(integer) : "Health" : 300 : 
        "Health of this NPC. " +
	"Default: 300"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/gojira.mdl") = npc_gecko_gojira : "Gojira"
[
	health(integer) : "Health" : 3000 : 
        "Health of this NPC. " +
	"Default: 3000"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/gecko.mdl") = npc_gecko_golden : "Golden Gecko"
[
	health(integer) : "Health" : 220 : 
        "Health of this NPC. " +
	"Default: 220"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/gecko.mdl") = npc_gecko_green : "Green Gecko"
[
	health(integer) : "Health" : 260 : 
        "Health of this NPC. " +
	"Default: 260"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal.mdl") = npc_ghoulferal : "Feral Ghoul"
[
	health(integer) : "Health" : 80 : 
        "Health of this NPC. " +
	"Default: 80"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal.mdl") = npc_ghoulferal_glowingone : "Glowing One"
[
	health(integer) : "Health" : 300 : 
        "Health of this NPC. " +
	"Default: 300"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal_jumpsuit.mdl") = npc_ghoulferal_jumpsuit : "Feral Ghoul"
[
	health(integer) : "Health" : 80 : 
        "Health of this NPC. " +
	"Default: 80"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal_jumpsuit.mdl") = npc_ghoulferal_jumpsuit_gl : "Glowing One"
[
	health(integer) : "Health" : 300 : 
        "Health of this NPC. " +
	"Default: 300"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulreaver.mdl") = npc_ghoulferal_reaver : "Feral Ghoul Reaver"
[
	health(integer) : "Health" : 450 : 
        "Health of this NPC. " +
	"Default: 450"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoularmored.mdl") = npc_ghoulferal_roamer : "Feral Ghoul Roamer"
[
	health(integer) : "Health" : 220 : 
        "Health of this NPC. " +
	"Default: 220"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal_vaultarmor.mdl") = npc_ghoulferal_security : "Vault Security Guard"
[
	health(integer) : "Health" : 280 : 
        "Health of this NPC. " +
	"Default: 280"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal_vaultarmor.mdl") = npc_ghoulferal_security_gl : "Vault Security Officer"
[
	health(integer) : "Health" : 600 : 
        "Health of this NPC. " +
	"Default: 600"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal.mdl") = npc_ghoulferal_swamp : "Swamp Ghoul"
[
	health(integer) : "Health" : 120 : 
        "Health of this NPC. " +
	"Default: 120"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal_trooper.mdl") = npc_ghoulferal_trooper : "Feral Trooper Ghoul"
[
	health(integer) : "Health" : 320 : 
        "Health of this NPC. " +
	"Default: 320"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/ghoulferal_trooper.mdl") = npc_ghoulferal_trooper_gl : "Glowing Feral Trooper Ghoul"
[
	health(integer) : "Health" : 480 : 
        "Health of this NPC. " +
	"Default: 480"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/giantrat.mdl") = npc_giantrat : "Giant Rat"
[
	health(integer) : "Health" : 32 : 
        "Health of this NPC. " +
	"Default: 32"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/mantis.mdl") = npc_mantis : "Mantis"
[
	health(integer) : "Health" : 25 : 
        "Health of this NPC. " +
	"Default: 25"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/mantis_nymph.mdl") = npc_mantis_nymph : "Mantis Nymph"
[
	health(integer) : "Health" : 8 : 
        "Health of this NPC. " +
	"Default: 8"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/mirelurk.mdl") = npc_mirelurk : "Mirelurk"
[
	health(integer) : "Health" : 200 : 
        "Health of this NPC. " +
	"Default: 200"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/mirelurk_hunter.mdl") = npc_mirelurk_hunter : "Mirelurk Hunter"
[
	health(integer) : "Health" : 250 : 
        "Health of this NPC. " +
	"Default: 250"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/magmalurk.mdl") = npc_magmalurk : "Magmalurk"
[
	health(integer) : "Health" : 2000 : 
        "Health of this NPC. " +
	"Default: 2000"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/mirelurk_hunter.mdl") = npc_nukalurk : "Nukalurk"
[
	health(integer) : "Health" : 250 : 
        "Health of this NPC. " +
	"Default: 250"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/mirelurk_hunter.mdl") = npc_swamplurk : "Swamplurk"
[
	health(integer) : "Health" : 250 : 
        "Health of this NPC. " +
	"Default: 250"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/streettrog.mdl") = npc_streettrog : "Street Trog"
[
	health(integer) : "Health" : 210 : 
        "Health of this NPC. " +
	"Default: 210"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/sporecarrier.mdl") = npc_sporecarrier : "Spore Carrier"
[
	health(integer) : "Health" : 420 : 
        "Health of this NPC. " +
	"Default: 420"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/tunneler.mdl") = npc_tunneler : "Tunneler"
[
	health(integer) : "Health" : 480 : 
        "Health of this NPC. " +
	"Default: 480"
]

@NPCClass base(BaseNPCSlv) studio("models/fallout/tunneler.mdl") = npc_tunneler_queen : "Tunneler Queen"
[
	health(integer) : "Health" : 560 : 
        "Health of this NPC. " +
	"Default: 560"
]

@PointClass base(Targetname,Parentname,Angles) studio("models/fallout/clutter/tunnelermound.mdl") = obj_tunnelermound : "Tunneler Mound"
[
	maxnpcs(integer) : "Maximum NPCs alive" : 3 : 
        "The maximum amount of tunnelers allowed to be active at a time." +
	queenchance(float) : "Queen Chance" : 0.25 : 
        "The chance for a queen to spawn (0-1)." +
	spawnratemin(float) : "Minimum Spawn Time" : 3 : 
        "Minimum time before the next tunneler spawns." +
	spawnratemax(float) : "Maximum Spawn Time" : 8 : 
        "Maximum time before the next tunneler spawns." +	
	totalnpcs(integer) : "Amount of NPCs" : 4 : 
        "Amount of tunnelers to spawn before the mound is depleted." +	
	squad(string) : "Squad" : "" : 
        "The squad the tunnelers should be asigned to when spawned." +	
	radius(float) : "Trigger Radius" : 800 : 
        "The mound will start spawning tunnelers if a player is within this radius." +	
]
]])