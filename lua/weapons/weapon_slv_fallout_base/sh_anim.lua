
local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_DOD_STAND_AIM_GREN_FRAG,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER
}

--[[---------------------------------------------------------
   Name: SetWeaponHoldType
   Desc: Sets up the translation table, to translate from normal 
			standing idle pose, to holding weapon pose.
-----------------------------------------------------------]]
function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	-- local index = ActIndex[ t ]
	
	if ( t == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		-- index = ActIndex[ t ]
	end
	
	-- print(t)

	self.ActivityTranslate = {}
	if t == "grenade" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_STAND_AIM_GREN_FRAG
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_DOD_WALK_AIM_GREN_FRAG
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_DOD_RUN_AIM_GREN_FRAG
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_DOD_CROUCH_AIM_GREN_FRAG
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_DOD_PRONE_AIM_GREN_FRAG
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_MP_GESTURE_VC_HANDMOUTH_MELEE
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_MP_GESTURE_VC_HANDMOUTH_MELEE
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_GESTURE_RELOAD_GRENADE
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_GRENADE
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_MP_GESTURE_VC_HANDMOUTH_MELEE
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_HL2MP_IDLE_GRENADE
	elseif t == "melee" or t == "knife" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_HL2MP_IDLE_MELEE
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_MP_WALK_MELEE
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_MP_RUN_MELEE
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_JUMP_CROSSBOW
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_MP_CROUCHWALK_PRIMARY
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_READINESS_RELAXED_TO_STIMULATED_WALK // ACT_READINESS_STIMULATED_TO_RELAXED
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_READINESS_RELAXED_TO_STIMULATED
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_GESTURE_RANGE_ATTACK1_LOW
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_GESTURE_RANGE_ATTACK2_LOW
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_PHYSGUN
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_READINESS_STIMULATED_TO_RELAXED
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
	elseif t == "pistol" or t == "revolver" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_STAND_AIM_PISTOL
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_MP_WALK_PRIMARY
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_MP_RUN_PRIMARY
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_MP_CROUCH_SECONDARY
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_MP_ATTACK_CROUCH_SECONDARY
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_PISTOL
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_GESTURE_RANGE_ATTACK_PISTOL_LOW
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_GESTURE_RELOAD_PISTOL
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_GESTURE_RELOAD_PISTOL
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_PISTOL
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_GESTURE_RANGE_ATTACK_PISTOL
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_HL2MP_JUMP_AR2
	elseif t == "physgun" or t == "slam" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_CROUCH_AIM_BAZOOKA
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_DOD_WALK_AIM_BAZOOKA
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_DOD_RUN_AIM_BAZOOKA
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_DOD_SPRINT_IDLE_BAZOOKA
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_DOD_RUN_IDLE_BAZOOKA
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_DOD_PRIMARYATTACK_BAR
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_DOD_PRIMARYATTACK_BAR
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_DOD_CROUCHWALK_AIM_BAZOOKA
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_DOD_WALK_AIM_BAZOOKA
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_DOD_STAND_IDLE_BAZOOKA
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_DOD_PRIMARYATTACK_BAR
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_SLAM_STICKWALL_DETONATE
	elseif t == "ar2" or t == "crossbow" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_STAND_AIM_C96
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_DOD_WALK_AIM_C96
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_DOD_RUN_AIM_C96
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_DOD_HS_IDLE_PSCHRECK
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_DOD_CROUCHWALK_AIM_C96
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_GESTURE_RELOAD_SMG1
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_GESTURE_RELOAD_SMG1
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_DOD_HS_CROUCH
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_DOD_HS_IDLE_BAZOOKA
	elseif t == "rpg" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_MP_ATTACK_STAND_PRIMARY
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_MP_WALK_SECONDARY
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_MP_RUN_SECONDARY
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_MP_CROUCH_PRIMARY
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_RUN_CROUCH
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_ML
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_GESTURE_RANGE_ATTACK_ML
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_GESTURE_RELOAD
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_MP_GRENADE1_DRAW
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_RPG
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_GESTURE_RANGE_ATTACK_ML
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_LAND
	elseif t == "melee2" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_HL2MP_IDLE
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_SHOTGUN_RELOAD_FINISH
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_SHOTGUN_PUMP
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_SMG2_TOAUTO
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_SMG2_FIRE2
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_SLAM_DETONATOR_HOLSTER
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_SLAM_DETONATOR_THROW_DRAW
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_SLAM_STICKWALL_TO_THROW
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_SMG2_TOBURST
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_SMG2_DRAW2
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_SLAM_DETONATOR_HOLSTER
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_SMG2_DRYFIRE2
	elseif t == "smg" or t == "shotgun" or t == "smg1" then
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_GESTURE_RANGE_ATTACK_AR2_GRENADE
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_GESTURE_RANGE_ATTACK_SMG2
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_GESTURE_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_GESTURE_RANGE_ATTACK_TRIPWIRE
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_GESTURE_RANGE_ATTACK_SLAM
		if t == "smg" or t == "smg1" then
			self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_IDLE_SMG1
		else
			self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_AR1
		end
		if t == "smg" or t == "smg1" then
			self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_IDLE_SMG1
		else
			self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_AR1
		end
		if t == "smg" or t == "smg1" then
			self.ActivityTranslate [ ACT_MP_RELOAD_STAND ] 	= ACT_IDLE_ANGRY_SMG1
		else
			self.ActivityTranslate [ ACT_MP_RELOAD_STAND ] 	= ACT_GESTURE_RANGE_ATTACK_AR2
		end
		if t == "smg" or t == "smg1" then
			self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ] 	= ACT_IDLE_ANGRY_SMG1
		else
			self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ] 	= ACT_GESTURE_RANGE_ATTACK_AR2
		end
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_GESTURE_RANGE_ATTACK_THROW
		if t == "smg" or t == "smg1" then
			self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 	= ACT_IDLE_SMG1
		else
			self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 	= ACT_GESTURE_RANGE_ATTACK_AR1
		end
		self.ActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslate [ ACT_LAND ]							= ACT_GESTURE_MELEE_ATTACK_SWING
	end
	
	-- "normal" jump animation doesn't exist
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_MP_JUMP
	end

	self:SetupWeaponHoldTypeForAI( t )

end

-- Default hold pos is the pistol
SWEP:SetWeaponHoldType( "normal" )

local acts = {
	["1gt"] = {
		[ACT_IDLE] = ACT_DOD_STAND_AIM_GREN_FRAG,
		[ACT_WALK] = ACT_DOD_WALK_AIM_GREN_FRAG,
		[ACT_RUN] = ACT_DOD_RUN_AIM_GREN_FRAG
	},
	["2ha"] = {
		[ACT_IDLE] = ACT_DOD_STAND_AIM_C96,
		[ACT_WALK] = ACT_DOD_WALK_AIM_C96,
		[ACT_RUN] = ACT_DOD_RUN_AIM_C96
	},
	["2hh"] = {
		[ACT_IDLE] = ACT_SLAM_STICKWALL_IDLE,
		[ACT_WALK] = ACT_SLAM_STICKWALL_ATTACH2,
		[ACT_RUN] = ACT_SLAM_STICKWALL_ATTACH
	},
	["2hl"] = {
		[ACT_IDLE] = ACT_MP_ATTACK_STAND_PRIMARY,
		[ACT_WALK] = ACT_MP_WALK_SECONDARY,
		[ACT_RUN] = ACT_MP_RUN_SECONDARY
	},
	["2hm"] = {
		[ACT_IDLE] = ACT_HL2MP_IDLE,
		[ACT_WALK] = ACT_SHOTGUN_RELOAD_FINISH,
		[ACT_RUN] = ACT_SHOTGUN_PUMP,
		[ACT_MELEE_ATTACK2] = ACT_MELEE_ATTACK2
	},
	["2hr"] = {
		[ACT_IDLE] = ACT_GESTURE_RANGE_ATTACK_AR2_GRENADE,
		[ACT_WALK] = ACT_GESTURE_RANGE_ATTACK_SMG2,
		[ACT_RUN] = ACT_GESTURE_RANGE_ATTACK_SMG1_LOW
	}
}

function SWEP:TranslateFalloutActivity(act)
	local itemID = self.itemID
	local data = self.m_itemData[itemID]
	local holdType = data.holdType
	if(holdType && acts[holdType] && acts[holdType][act]) then act = acts[holdType][act] end
	local owner = self:GetOwner()
	return IsValid(owner) && owner:TranslateActivity(act) || act
end

local gestures = {
	["1gt"] = {
		[ACT_DISARM] = ACT_GESTURE_RANGE_ATTACK2,
	},
	["2ha"] = {
		[ACT_DISARM] = ACT_DOD_HS_IDLE,
		[ACT_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_AR1
	},
	["2hh"] = {
		[ACT_DISARM] = ACT_SLAM_STICKWALL_ND_DRAW,
		[ACT_RANGE_ATTACK1] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
	},
	["2hl"] = {
		[ACT_DISARM] = ACT_ITEM_THROW,
		[ACT_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_ML
	},
	["2hm"] = {
		[ACT_DISARM] = ACT_SMG2_TOBURST,
		[ACT_MELEE_ATTACK1] = ACT_GESTURE_MELEE_ATTACK2
	},
	["2hr"] = {
		[ACT_DISARM] = ACT_GESTURE_RANGE_ATTACK_SMG1,
		[ACT_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_AR1,
		[ACT_RANGE_ATTACK2] = ACT_IDLE_SMG1,
		[ACT_RELOAD] = ACT_IDLE_ANGRY_SMG1,
	}
}

function SWEP:TranslateGesture(act)
	local itemID = self.itemID
	local data = self.m_itemData[itemID]
	local holdType = data.holdType
	if(holdType && gestures[holdType] && gestures[holdType][act]) then act = gestures[holdType][act] end
	local owner = self:GetOwner()
	return IsValid(owner) && owner:TranslateGesture(act) || act
end

--[[---------------------------------------------------------
   Name: weapon:TranslateActivity( )
   Desc: Translate a player's Activity into a weapon's activity
		 So for example, ACT_HL2MP_RUN becomes ACT_HL2MP_RUN_PISTOL
		 Depending on how you want the player to be holding the weapon
-----------------------------------------------------------]]
function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then
		if ( self.ActivityTranslateAI[ act ] ) then
			return self.ActivityTranslateAI[ act ]
		end
		return -1
	end

	if ( self.ActivityTranslate[ act ] != nil ) then
		return self.ActivityTranslate[ act ]
	end
	
	return -1

end
