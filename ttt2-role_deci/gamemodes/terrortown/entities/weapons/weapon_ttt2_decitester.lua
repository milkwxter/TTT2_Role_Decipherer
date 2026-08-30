if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")
SWEP.Base = "weapon_tttbase"

local DECITESTER_ERROR_NOT_PLAYER = 0
local DECITESTER_ERROR_LOST_TARGET = 1
local DECITESTER_ERROR_NO_USES = 2

local DECITESTER_IDLE = 0
local DECITESTER_BUSY = 1

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

local sounds = {
    empty = Sound("Weapon_SMG1.Empty"),
    beep = Sound("buttons/button17.wav"),
    hum = Sound("items/nvg_on.wav"),
    zap = Sound("ambient/energy/zap7.wav"),
    scanned = Sound("items/smallmedkit1.wav"),
}

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = nil
SWEP.notBuyable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "slam"

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 9999
SWEP.Primary.DefaultClip = 1111
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.AllowDrop = false

SWEP.TimeToDecipherRole = 4

if SERVER then
	-- remove on death or drop (no one else should use this)
	function SWEP:OnDrop()
		self:Remove()
	end
	
	-- make sure weapon values line up with convars
	function SWEP:Initialize()
		self:SetNWInt("decitester_max_uses", GetConVar("ttt2_decipherer_max_uses"):GetInt() or 0)
		return
	end
	
	-- networked variables
	function SWEP:SetState(state)
        self:SetNWInt("decitester_state", state or DECITESTER_IDLE)
    end

    function SWEP:SetStartTime(time)
        self:SetNWFloat("decitester_start_time", time or 0)
    end

    function SWEP:SetScanTime(time)
        self:SetNWFloat("decitester_revive_time", time or 0)
    end
	
	-- easy reset to beginning
	function SWEP:Reset()
		self.decitestTarget = nil
        self:SetState(DECITESTER_IDLE)
    end
	
	-- error handling
	function SWEP:Message(type)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		self:PlaySound("zap")
		self:SetNextPrimaryFire(CurTime() + 0.5)
		
		if type == DECITESTER_ERROR_NOT_PLAYER then
            LANG.Msg(owner, "TRANSLATE: not a player!", nil, MSG_MSTACK_WARN)
		elseif type == DECITESTER_ERROR_LOST_TARGET then
			LANG.Msg(owner, "TRANSLATE: lost the target!", nil, MSG_MSTACK_WARN)
		elseif type == DECITESTER_ERROR_NO_USES then
			LANG.Msg(owner, "TRANSLATE: no more uses!", nil, MSG_MSTACK_WARN)
		end
	end
	
	-- fun sounds
	function SWEP:PlaySound(soundName)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		owner:EmitSound(sounds[soundName])
	end
	
	function SWEP:StopSound(soundName)
        local owner = self:GetOwner()
		if not IsValid(owner) then return end
        owner:StopSound(sounds[soundName])
    end
	
	-- actual logic
	function SWEP:PrimaryAttack()
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		-- check how many uses are left
		if self:GetMaxUses() <= 0 then
			self:Message(DECITESTER_ERROR_NO_USES)
			return
		end
		
		local trace = owner:GetEyeTrace(MASK_SHOT_HULL)
        local distance = trace.StartPos:Distance(trace.HitPos)
        local ent = trace.Entity
		
		if distance > 100 then
			self:Message(DECITESTER_ERROR_NOT_PLAYER)
			return
		end
		
		if not ent:IsPlayer() then
			self:Message(DECITESTER_ERROR_NOT_PLAYER)
			return
		end
		
		-- little server var
        self.decitestTarget = ent
		
		-- start the scan for think function
		self:SetState(DECITESTER_BUSY)
		self:SetStartTime(CurTime())
        self:SetScanTime(self.TimeToDecipherRole)
        self:PlaySound("hum")
	end
	
	function SWEP:Think()
		if self:GetState() ~= DECITESTER_BUSY then return end
		
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		local target = self.decitestTarget
		if not IsValid(target) then return end
		
		if CurTime() >= self:GetStartTime() + self.TimeToDecipherRole - 0.01 then
            target:Kill() -- TODO EPOP
			self:SetState(DECITESTER_IDLE)
        elseif not IsValid(owner) or not IsValid(target)
			or not owner:KeyDown(IN_ATTACK)
			or not owner:GetEyeTrace(MASK_SHOT_HULL).Entity:IsPlayer() then
			
			print(owner)
			print(target)
			
			-- time to reset
			self:StopSound("hum")
            self:Reset()
            self:Message(DECITESTER_ERROR_LOST_TARGET)
        end
	end
end

-- do not play sound when swep is empty
function SWEP:DryFire()
    return false
end

function SWEP:GetState()
    return self:GetNWInt("decitester_state", DECITESTER_IDLE)
end

function SWEP:GetMaxUses()
    return self:GetNWInt("decitester_max_uses", 0)
end

function SWEP:GetStartTime()
    return self:GetNWFloat("decitester_start_time", 0)
end

function SWEP:GetScanTime()
    return self:GetNWFloat("decitester_scan_time", 0)
end

if CLIENT then
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("Hold to scan player")
        BaseClass.Initialize(self)
    end
	
	function SWEP:PrimaryAttack() end
	
	local colorDetectiveBlue = Color(75, 104, 169, 255)
	hook.Add("TTTRenderEntityInfo", "ttt2_decitester_display_info", function(tData)
        local ent = tData:GetEntity()
        local client = LocalPlayer()
        local activeWeapon = client:GetActiveWeapon()

        -- has to be a player
        if not ent:IsPlayer() then return end

        -- player has to hold a decitester
        if not IsValid(activeWeapon) or activeWeapon:GetClass() ~= "weapon_ttt2_decitester" then return end

        -- ent has to be in usable range
        if tData:GetEntityDistance() > 100 then return end

        tData:AddDescriptionLine(
            LANG.GetParamTranslation(
                "ttt2_label_decipherer_hold_key_to_scan",
                { key = Key("+attack", "LEFT MOUSE") }
            ),
            colorDetectiveBlue
        )

        tData:SetOutlineColor(colorDetectiveBlue)
    end)
end