
function SWEP:SetupWeaponHoldTypeForAI(t)
	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI[ACT_IDLE] 							= ACT_IDLE_PISTOL
	self.ActivityTranslateAI[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
	self.ActivityTranslateAI[ACT_WALK_AIM] 						= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI[ACT_RUN_AIM] 						= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ACT_RELOAD_LOW] 					= ACT_RELOAD_PISTOL_LOW
	self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_PISTOL_LOW
	self.ActivityTranslateAI[ACT_COVER_LOW] 					= ACT_COVER_PISTOL_LOW
	self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] 				= ACT_RANGE_AIM_PISTOL_LOW
	self.ActivityTranslateAI[ACT_GESTURE_RELOAD] 				= ACT_GESTURE_RELOAD_PISTOL
	if t == "grenade" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_STAND_AIM_GREN_FRAG
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_DOD_WALK_AIM_GREN_FRAG
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_DOD_RUN_AIM_GREN_FRAG
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_DOD_CROUCH_AIM_GREN_FRAG
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_DOD_PRONE_AIM_GREN_FRAG
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_MP_GESTURE_VC_HANDMOUTH_MELEE
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_MP_GESTURE_VC_HANDMOUTH_MELEE
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_GESTURE_RELOAD_GRENADE
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_GRENADE
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_MP_GESTURE_VC_HANDMOUTH_MELEE
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_HL2MP_IDLE_GRENADE
	elseif t == "melee" or t == "knife" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_HL2MP_IDLE_MELEE
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_MP_WALK_MELEE
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_MP_RUN_MELEE
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_JUMP_CROSSBOW
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_MP_CROUCHWALK_PRIMARY
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_READINESS_RELAXED_TO_STIMULATED_WALK // ACT_READINESS_STIMULATED_TO_RELAXED
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_READINESS_RELAXED_TO_STIMULATED
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_GESTURE_RANGE_ATTACK1_LOW
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_GESTURE_RANGE_ATTACK2_LOW
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_PHYSGUN
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_READINESS_STIMULATED_TO_RELAXED
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_HL2MP_IDLE_CROUCH_CROSSBOW
	elseif t == "pistol" or t == "revolver" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_STAND_AIM_PISTOL
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_MP_WALK_PRIMARY
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_MP_RUN_PRIMARY
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_MP_CROUCH_SECONDARY
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_MP_ATTACK_CROUCH_SECONDARY
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_PISTOL
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_GESTURE_RANGE_ATTACK_PISTOL_LOW
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_GESTURE_RELOAD_PISTOL
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_GESTURE_RELOAD_PISTOL
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_PISTOL
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_GESTURE_RANGE_ATTACK_PISTOL
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_HL2MP_JUMP_AR2
	elseif t == "physgun" or t == "slam" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_CROUCH_AIM_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_DOD_WALK_AIM_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_DOD_RUN_AIM_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_DOD_SPRINT_IDLE_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_DOD_RUN_IDLE_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_DOD_PRIMARYATTACK_BAR
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_DOD_PRIMARYATTACK_BAR
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_DOD_CROUCHWALK_AIM_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_DOD_WALK_AIM_BAZOOKA
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_DOD_STAND_IDLE_BAZOOKA
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_DOD_PRIMARYATTACK_BAR
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_SLAM_STICKWALL_DETONATE
	elseif t == "ar2" or t == "crossbow" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_DOD_STAND_AIM_C96
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_DOD_WALK_AIM_C96
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_DOD_RUN_AIM_C96
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_DOD_HS_IDLE_PSCHRECK
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_DOD_CROUCHWALK_AIM_C96
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_GESTURE_RELOAD_SMG1
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_GESTURE_RELOAD_SMG1
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_DOD_HS_CROUCH
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_DOD_HS_IDLE_BAZOOKA
	elseif t == "rpg" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_MP_ATTACK_STAND_PRIMARY
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_MP_WALK_SECONDARY
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_MP_RUN_SECONDARY
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_MP_CROUCH_PRIMARY
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_RUN_CROUCH
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_ML
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_GESTURE_RANGE_ATTACK_ML
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_GESTURE_RELOAD
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_MP_GRENADE1_DRAW
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_RPG
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_GESTURE_RANGE_ATTACK_ML
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_LAND
	elseif t == "melee2" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_HL2MP_IDLE
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_SHOTGUN_RELOAD_FINISH
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_SHOTGUN_PUMP
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_SMG2_TOAUTO
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_SMG2_FIRE2
		self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_SLAM_DETONATOR_HOLSTER
		self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_SLAM_DETONATOR_THROW_DRAW
		self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ]		 		= ACT_SLAM_STICKWALL_TO_THROW
		self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_SMG2_TOBURST
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_SMG2_DRAW2
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_SLAM_DETONATOR_HOLSTER
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_SMG2_DRYFIRE2
	elseif t == "smg" or t == "shotgun" or t == "smg1" then
		self.ActivityTranslateAI [ ACT_MP_STAND_IDLE ] 				= ACT_GESTURE_RANGE_ATTACK_AR2_GRENADE
		self.ActivityTranslateAI [ ACT_MP_WALK ] 						= ACT_GESTURE_RANGE_ATTACK_SMG2
		self.ActivityTranslateAI [ ACT_MP_RUN ] 						= ACT_GESTURE_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI [ ACT_MP_CROUCH_IDLE ] 				= ACT_GESTURE_RANGE_ATTACK_TRIPWIRE
		self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_GESTURE_RANGE_ATTACK_SLAM
		if t == "smg" or t == "smg1" then
			self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_IDLE_SMG1
		else
			self.ActivityTranslateAI [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_AR1
		end
		if t == "smg" or t == "smg1" then
			self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_IDLE_SMG1
		else
			self.ActivityTranslateAI [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] 	= ACT_GESTURE_RANGE_ATTACK_AR1
		end
		if t == "smg" or t == "smg1" then
			self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ] 	= ACT_IDLE_ANGRY_SMG1
		else
			self.ActivityTranslateAI [ ACT_MP_RELOAD_STAND ] 	= ACT_GESTURE_RANGE_ATTACK_AR2
		end
		if t == "smg" or t == "smg1" then
			self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ] 	= ACT_IDLE_ANGRY_SMG1
		else
			self.ActivityTranslateAI [ ACT_MP_RELOAD_CROUCH ] 	= ACT_GESTURE_RANGE_ATTACK_AR2
		end
		self.ActivityTranslateAI [ ACT_MP_JUMP ] 						= ACT_GESTURE_RANGE_ATTACK_THROW
		if t == "smg" or t == "smg1" then
			self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 	= ACT_IDLE_SMG1
		else
			self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 	= ACT_GESTURE_RANGE_ATTACK_AR1
		end
		self.ActivityTranslateAI [ ACT_MP_SWIM ] 						= ACT_MP_JUMP
		self.ActivityTranslateAI [ ACT_LAND ]							= ACT_GESTURE_MELEE_ATTACK_SWING
	end
	return
end

