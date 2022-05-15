local ConVars = {}
//LASER PISTOL
ConVars["sk_laserpistol_dmg"] = 12

//LASER RIFLE
ConVars["sk_laserrifle_dmg"] = 27

//COMBAT SHOTGUN
ConVars["sk_combatshotgun_dmg"] = 9

// LIBERTY PRIME
ConVars["sk_libertyprime_health"] = 50000
ConVars["sk_libertyprime_dmg_laser"] = 94
ConVars["sk_libertyprime_dmg_bomb"] = 10000
ConVars["sk_libertyprime_dmg_foot"] = 800

// CENTAUR
ConVars["sk_centaur_health"] = 200
ConVars["sk_centaur_dmg_slash"] = 15
ConVars["sk_centaur_dmg_power"] = 18

// RADSCORPION
ConVars["sk_radscorpion_health"] = 300
ConVars["sk_radscorpion_dmg_slash"] = 14
ConVars["sk_radscorpion_dmg_tail"] = 23
ConVars["sk_radscorpion_dmg_strike"] = 25

// MIRELURK HUNTER
ConVars["sk_mirelurk_hunter_health"] = 250
ConVars["sk_mirelurk_hunter_dmg_slash"] = 12
ConVars["sk_mirelurk_hunter_dmg_slash_power"] = 18
ConVars["sk_mirelurk_hunter_dmg_strike"] = 23

// SUPPORT DRONE
ConVars["sk_support_drone_health"] = 400
ConVars["sk_support_drone_dmg_slash"] = 21
ConVars["sk_support_drone_dmg_power"] = 25

// SENTRYBOT
--[[
Silverlan: tbh, I don't remember. I probably either played it as a gesture, or created a separate movement animation with it added over it
--]]
ConVars["sk_sentrybot_health"] = 500
ConVars["sk_sentrybot_dmg_bullet"] = 7

// ALBINO RADSCORPION
ConVars["sk_albino_radscorpion_health"] = 750
ConVars["sk_albino_radscorpion_dmg_slash"] = 29
ConVars["sk_albino_radscorpion_dmg_tail"] = 41
ConVars["sk_albino_radscorpion_dmg_strike"] = 42

// BARK RADSCORPION
ConVars["sk_bark_radscorpion_health"] = 125
ConVars["sk_bark_radscorpion_dmg_slash"] = 9
ConVars["sk_bark_radscorpion_dmg_tail"] = 14
ConVars["sk_bark_radscorpion_dmg_strike"] = 15

// BEHEMOTH
ConVars["sk_behemoth_health"] = 1000
ConVars["sk_behemoth_dmg_hand"] = 25
ConVars["sk_behemoth_dmg_slash"] = 54
ConVars["sk_behemoth_dmg_smash"] = 78

// BLOATFLY
ConVars["sk_bloatfly_health"] = 50

// RADROACH
ConVars["sk_radroach_health"] = 45
ConVars["sk_radroach_dmg_slash"] = 8

// FERAL GHOUL RAVAGER
ConVars["sk_ghoulferal_ravager_health"] = 700
ConVars["sk_ghoulferal_ravager_dmg_slash"] = 20
ConVars["sk_ghoulferal_ravager_dmg_slash_power"] = 30
ConVars["sk_ghoulferal_ravager_dmg_grenade"] = 30
ConVars["sk_ghoulferal_ravager_dmg_radiation"] = 45
ConVars["sk_ghoulferal_ravager_health_regen_rate"] = 5

// TRAUMA HARNESS
ConVars["sk_trauma_health"] = 200
ConVars["sk_trauma_dmg_katana"] = 32

// SUPER MUTANT
ConVars["sk_supermutant_health"] = 400
ConVars["sk_supermutant_dmg_fist"] = 20

// FAILED FEV SUBJECT
ConVars["sk_fev_health"] = 500
ConVars["sk_fev_dmg_fist"] = 24

// GIANT ANT
ConVars["sk_giantant_health"] = 500
ConVars["sk_giantant_dmg_slash"] = 24
ConVars["sk_giantant_dmg_flame"] = 5

for k, v in pairs(ConVars) do
	CreateConVar(k,v,FCVAR_ARCHIVE)
end