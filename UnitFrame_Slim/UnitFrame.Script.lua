-----------------------------------------
-- Script for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.UnitFrame"

_LockMode = true

Toggle = {
	Message = L"Lock Unit Frame",
	Get = function()
		return _LockMode
	end,
	Set = function (value)
		_LockMode = value

		if not _LockMode then
			for _, frm in ipairs(arUnit) do
				if frm ~= frmPlayer then
					frm:UnregisterUnitWatch()
				end
			end
			IFMovable._ModeOn(_IGASUI_UNITFRAME_GROUP)
			IFResizable._ModeOn(_IGASUI_UNITFRAME_GROUP)
		else
			IFMovable._ModeOff(_IGASUI_UNITFRAME_GROUP)
			IFResizable._ModeOff(_IGASUI_UNITFRAME_GROUP)
			for _, frm in ipairs(arUnit) do
				if frm ~= frmPlayer then
					frm:RegisterUnitWatch()
				end
			end
		end

		Toggle.Update()
	end,
	Update = function() end,
}

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
	if option and (option:lower() == "uf" or option:lower() == "unitframe") then
		if InCombatLockdown() then return end

		info = info and info:lower()

		if info == "unlock" then
			Toggle.Set(true)
		elseif info == "lock" then
			Toggle.Set(false)
		else
			Log(2, "/iu uf unlock - unlock the unit frames.")
			Log(2, "/iu uf lock - lock the unit frames.")
		end

		return true
	elseif option and (option:lower() == "show" or option:lower() == "hide") then
		if info then
			if not info:match("%d$") then
				info = info .. "%d*"
			end
			local visible = (option:lower() == "show")

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				if visible then
					for i = 1, #arUnit do
						if arUnit[i].OldUnit and arUnit[i].OldUnit:match(info) then
							_DB.HideUnit[arUnit[i].OldUnit] = nil

							arUnit[i].Unit = arUnit[i].OldUnit
							arUnit[i].OldUnit = nil

							arUnit[i].IFMovable = true
							arUnit[i].IFResizable = true
						end
					end
				else
					for i = 1, #arUnit do
						if arUnit[i].Unit and arUnit[i].Unit:match(info) then
							_DB.HideUnit[arUnit[i].Unit] = true

							arUnit[i].OldUnit = arUnit[i].Unit
							arUnit[i].Unit = nil

							arUnit[i].IFMovable = false
							arUnit[i].IFResizable = false
						end
					end
				end
			end)
		else
			Log(2, "/iu show|hide unit - show or hide unit's frame")
		end

		return true
	end
end

_HiddenFrame = CreateFrame("Frame")
_HiddenFrame:Hide()

function HideBlzUnitFrame(self)
	self:UnregisterAllEvents()
	self:Hide()

	self:SetParent(_HiddenFrame)

	if self.healthbar then
		self.healthbar:UnregisterAllEvents()
	end

	if self.manabar then
		self.manabar:UnregisterAllEvents()
	end

	if self.spellbar then
		self.spellbar:UnregisterAllEvents()
	end

	if self.powerBarAlt then
		self.powerBarAlt:UnregisterAllEvents()
	end
end

function OnEnable(self)
	--HideBlzUnitFrame(_G.PlayerFrame)
	HideBlzUnitFrame(_G.PetFrame)
	HideBlzUnitFrame(_G.PartyMemberFrame1)
	HideBlzUnitFrame(_G.PartyMemberFrame2)
	HideBlzUnitFrame(_G.PartyMemberFrame3)
	HideBlzUnitFrame(_G.PartyMemberFrame4)
	HideBlzUnitFrame(_G.TargetFrame)
	HideBlzUnitFrame(_G.ComboFrame)
	HideBlzUnitFrame(_G.FocusFrame)
	HideBlzUnitFrame(_G.RuneFrame)
	HideBlzUnitFrame(_G.CastingBarFrame)
	HideBlzUnitFrame(_G.Boss1TargetFrame)
	HideBlzUnitFrame(_G.Boss2TargetFrame)
	HideBlzUnitFrame(_G.Boss3TargetFrame)
	HideBlzUnitFrame(_G.Boss4TargetFrame)
	HideBlzUnitFrame(_G.Boss5TargetFrame)

	_M:SecureHook("ShowPartyFrame")
end

function ShowPartyFrame()
	IFNoCombatTaskHandler._RegisterNoCombatTask(HidePartyFrame)
end

function OnLoad(self)
	_DB = _Addon._DB.UnitFrame or {}
	_Addon._DB.UnitFrame = _DB

	-- Convert old save data
	for i = 1, #arUnit do
		if _DB[i] then
			_DB[arUnit[i].Unit] = _DB[i]
			_DB[i] = nil
		end
	end

	for i = 1, #arUnit do
		local db = _DB[arUnit[i].Unit]

		if db and db.Size then
			arUnit[i].Size = db.Size
		end
		if db and db.Location then
			arUnit[i].Location = db.Location
		end
	end

	-- Hide no need unitframe
	_DB.HideUnit = _DB.HideUnit or {}
	for i = 1, #arUnit do
		if _DB.HideUnit[arUnit[i].Unit] then
			arUnit[i].OldUnit = arUnit[i].Unit
			arUnit[i].Unit = nil

			arUnit[i].IFMovable = false
			arUnit[i].IFResizable = false
		end
	end

	-- Fix for PETBATTLES taint error
	if _G.FRAMELOCK_STATES and _G.FRAMELOCK_STATES.PETBATTLES then
		wipe(_G.FRAMELOCK_STATES.PETBATTLES)
	end
end

--------------------
-- Script Handler
--------------------
function arUnit:OnPositionChanged(i)
	if arUnit[i].Unit then
		_DB[arUnit[i].Unit] = _DB[arUnit[i].Unit] or {}
		_DB[arUnit[i].Unit].Location = arUnit[i].Location
	end
end

function arUnit:OnSizeChanged(i)
	if arUnit[i].Unit then
		_DB[arUnit[i].Unit] = _DB[arUnit[i].Unit] or {}
		_DB[arUnit[i].Unit].Size = arUnit[i].Size
	end
end

