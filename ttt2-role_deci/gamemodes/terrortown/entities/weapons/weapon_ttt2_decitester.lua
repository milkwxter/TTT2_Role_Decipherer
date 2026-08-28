if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "weapon_tttbase"

if CLIENT then
	SWEP.ViewModelFOV = 78
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "WH-B3 Minitester",
		desc = "deci_minitester_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_decitester"
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = nil

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "pistol"

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 9999
SWEP.Primary.DefaultClip = 1111
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.AllowDrop = false

-- remove on death or drop (no one else should use this)
function SWEP:OnDrop()
	self:Remove()
end

-- make sure weapon values line up with convars
function SWEP:Initialize()
	-- TODO: logic
	return
end

function SWEP:PrimaryAttack()
	-- check how many uses are left
	
	-- check if we are ready to use
	
	-- try to find player we are aiming at
	
	-- TODO: logic
	return
end
