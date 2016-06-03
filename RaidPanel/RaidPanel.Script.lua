IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Script for RaidPanel
--==========================

SpellBookFrame = _G.SpellBookFrame
MAX_SKILLLINE_TABS = _G.MAX_SKILLLINE_TABS
BOOKTYPE_SPELL = _G.BOOKTYPE_SPELL

NUM_RAID_GROUPS = _G.NUM_RAID_GROUPS
MEMBERS_PER_RAID_GROUP = _G.MEMBERS_PER_RAID_GROUP

_IGASUI_HELPFUL_SPELL = {}

Toggle = {
	Message = L"Lock Raid Panel",
	Get = function()
		return not raidPanelMask.Visible
	end,
	Set = function (value)
		if value then
			raidPanelMask.Visible = false
			raidPanelConfig.Visible = false
		else
			if not InCombatLockdown() then
				raidPanelMask.Visible = true
				raidPanelConfig.Visible = true
			end
		end
	end,
	Update = function() end,
}

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
	if option and (option:lower() == "rp" or option:lower() == "raidpanel") then
		if InCombatLockdown() then return end

		info = info and info:lower()

		if info == "unlock" then
			raidPanelMask.Visible = true
		elseif info == "lock" then
			raidPanelMask.Visible = false
		else
			Log(2, "/iu rp unlock - unlock the raid panel.")
			Log(2, "/iu rp lock - lock the raid panel.")
		end

		return true
	end
end

function OnLoad(self)
	_DB = _Addon._DB.RaidPanel or {}
	_DBChar = _Addon._DBChar.RaidPanel or {}
	_Addon._DB.RaidPanel = _DB
	_Addon._DBChar.RaidPanel = _DBChar

	-- Load location
	if _DBChar.Location then
		raidPanel.Location = _DBChar.Location
	end

	-- Load disable settings
	_DBChar.DisableElement = _DBChar.DisableElement or {}
	_DisableElement = _DBChar.DisableElement
	raidpanelMenuArray:Each(function(self)
		self.Checked = not _DisableElement[self.ElementName]

		raidPanel:Each(UpdateConfig4UnitFrame, self)
		raidPetPanel:Each(UpdateConfig4UnitFrame, self)
	end)

	-- Load raid panel settings
	_DBChar.RaidPanelSet = _DBChar.RaidPanelSet or {}
	_RaidPanelSet = _DBChar.RaidPanelSet

	_DBChar.RaidPetPanelSet = _DBChar.RaidPetPanelSet or {}
	_RaidPetPanelSet = _DBChar.RaidPetPanelSet

	_DBChar.RaidDeadPanelSet = _DBChar.RaidDeadPanelSet or {}
	_RaidDeadPanelSet = _DBChar.RaidDeadPanelSet

	-- Default settings
	if not next(_RaidPanelSet) then
		_RaidPanelSet.ShowRaid = true
		_RaidPanelSet.ShowParty = true
		_RaidPanelSet.ShowPlayer = true
		_RaidPanelSet.ShowSolo = true
		_RaidPanelSet.GroupBy = "GROUP"
		_RaidPanelSet.SortBy = "INDEX"
		_RaidPanelSet.Orientation = "VERTICAL"
	end

	if not next(_RaidPetPanelSet) then
		_RaidPetPanelSet.ShowRaid = true
		_RaidPetPanelSet.ShowParty = true
		_RaidPetPanelSet.ShowPlayer = true
		_RaidPetPanelSet.ShowSolo = true
		_RaidPetPanelSet.GroupBy = "GROUP"
		_RaidPetPanelSet.SortBy = "INDEX"
		_RaidPetPanelSet.Orientation = "HORIZONTAL"
	end

	if not next(_RaidDeadPanelSet) then
		_RaidDeadPanelSet.ShowRaid = true
		_RaidDeadPanelSet.ShowParty = false
		_RaidDeadPanelSet.ShowPlayer = false
		_RaidDeadPanelSet.ShowSolo = false
		_RaidDeadPanelSet.GroupBy = "GROUP"
		_RaidDeadPanelSet.SortBy = "INDEX"
		_RaidDeadPanelSet.Orientation = "HORIZONTAL"
	end

	if _DBChar.RaidPanelActivated == nil then
		_DBChar.RaidPanelActivated = true
	end

	if _DBChar.RaidPetPanelActivated == nil then
		_DBChar.RaidPetPanelActivated = true
	end

	if _DBChar.RaidPetPanelDeactivateInRaid == nil then
		_DBChar.RaidPetPanelDeactivateInRaid = true
	end

	if _DBChar.RaidDeadPanelActivated == nil then
		_DBChar.RaidDeadPanelActivated = false
	end

	if _DBChar.PetPanelLocation == nil then
		_DBChar.PetPanelLocation = "RIGHT"
	end

	if _DBChar.ElementWidth then
		raidPanel.ElementWidth = _DBChar.ElementWidth
		raidPetPanel.ElementWidth = _DBChar.ElementWidth
		raidDeadPanel.ElementWidth = _DBChar.ElementWidth
	end

	mnuRaidPanelSetWidth.Text = L"Width : " .. tostring(raidPanel.ElementWidth)

	if _DBChar.ElementHeight then
		raidPanel.ElementHeight = _DBChar.ElementHeight
		raidPetPanel.ElementHeight = _DBChar.ElementHeight
		raidDeadPanel.ElementHeight = _DBChar.ElementHeight
	end

	mnuRaidPanelSetHeight.Text = L"Height : " .. tostring(raidPanel.ElementHeight)

	_DBChar.PowerHeight = _DBChar.PowerHeight or 3
	mnuRaidPanelSetPowerHeight.Text = L"Power Height : " .. tostring(_DBChar.PowerHeight)

	-- Load Config
	SetLocation(_DBChar.PetPanelLocation)
	if _DBChar.PetPanelLocation == "BOTTOM" then
		mnuRaidPetPanelLocationBottom.Checked = true
	else
		mnuRaidPetPanelLocationRight.Checked = true
	end

	for k, v in pairs(_RaidPanelSet) do
		if k == "Orientation" then
			SetOrientation(raidPanel, v)
		else
			raidPanel[k] = v
		end
	end
	for k, v in pairs(_RaidPetPanelSet) do
		if k == "Orientation" then
			SetOrientation(raidPetPanel, v)
		else
			raidPetPanel[k] = v
		end
	end
	for k, v in pairs(_RaidDeadPanelSet) do
		if k == "Orientation" then
			SetOrientation(raidDeadPanel, v)
		else
			raidDeadPanel[k] = v
		end
	end
	raidpanelPropArray:Each(function(self)
		if self.ConfigValue then
			self.Checked = (self.UnitPanel[self.ConfigName] == self.ConfigValue)
		else
			self.Checked = self.UnitPanel[self.ConfigName]
		end
	end)
	mnuRaidPetPanelDeactivateInRaid.Checked = _DBChar.RaidPetPanelDeactivateInRaid
	mnuRaidPanelActivated.Checked = _DBChar.RaidPanelActivated
	mnuRaidPetPanelActivated.Checked = _DBChar.RaidPetPanelActivated
	mnuRaidDeadPanelActivated.Checked = _DBChar.RaidDeadPanelActivated

	-- Filter Settings
	_DBChar.GroupFilter = _DBChar.GroupFilter or {}
	_DBChar.ClassFilter = _DBChar.ClassFilter or {}
	_DBChar.RoleFilter = _DBChar.RoleFilter or {}
	_GroupFilter = _DBChar.GroupFilter
	_ClassFilter = _DBChar.ClassFilter
	_RoleFilter = _DBChar.RoleFilter

	raidPanel.GroupFilter = _GroupFilter
	raidPanel.ClassFilter = _ClassFilter
	raidPanel.RoleFilter = _RoleFilter

	groupFilterArray:Each(function(self)
		for _, v in ipairs(_GroupFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)
	classFilterArray:Each(function(self)
		for _, v in ipairs(_ClassFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)
	roleFilterArray:Each(function(self)
		for _, v in ipairs(_RoleFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)

	-- Filter for dead
	_DBChar.DeadGroupFilter = _DBChar.DeadGroupFilter or {}
	_DBChar.DeadClassFilter = _DBChar.DeadClassFilter or {}
	_DBChar.DeadRoleFilter = _DBChar.DeadRoleFilter or {}
	_DeadGroupFilter = _DBChar.DeadGroupFilter
	_DeadClassFilter = _DBChar.DeadClassFilter
	_DeadRoleFilter = _DBChar.DeadRoleFilter

	raidDeadPanel.GroupFilter = _DeadGroupFilter
	raidDeadPanel.ClassFilter = _DeadClassFilter
	raidDeadPanel.RoleFilter = _DeadRoleFilter

	groupDeadFilterArray:Each(function(self)
		for _, v in ipairs(_DeadGroupFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)
	classDeadFilterArray:Each(function(self)
		for _, v in ipairs(_DeadClassFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)
	roleDeadFilterArray:Each(function(self)
		for _, v in ipairs(_DeadRoleFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)

	-- Debuff filter
	_DB.DebuffSpellList = nil
	_DB.DebuffBlackList = _DB.DebuffBlackList or {}

	_DebuffBlackList = _DB.DebuffBlackList

	-- Default true
	if _DB.DebuffRightMouseRemove == nil then
		_DB.DebuffRightMouseRemove = true
	end

	if _DB.ShowDebuffTooltip == nil then
		_DB.ShowDebuffTooltip = true
	end

	mnuRaidPanelDebuffRightMouseRemove.Checked = _DB.DebuffRightMouseRemove
	mnuRaidPanelDebuffShowTooltip.Checked = _DB.ShowDebuffTooltip

	-- System Events
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")

	_LoadingConfig = GetSpecialization() or 1
	if _DBChar[_LoadingConfig] then
		_IGASUI_SPELLHANDLER:Import(_DBChar[_LoadingConfig])
	end

	mnuRaidPanelSetUseClassColor.Checked = _DBChar.ElementUseClassColor
	UpdateHealthBar4UseClassColor()

	raidPanel:InitWithCount(25)
	raidPanel.Activated = _DBChar.RaidPanelActivated

	raidPetPanel:InitWithCount(10)
	raidPetPanel.DeactivateInRaid = _DBChar.RaidPetPanelDeactivateInRaid
	raidPetPanel.Activated = _DBChar.RaidPetPanelActivated

	raidDeadPanel:InitWithCount(10)
	raidDeadPanel.Activated = _DBChar.RaidDeadPanelActivated
end

function OnEnable(self)
	self:SecureHook("SpellButton_UpdateButton")
	LEARNED_SPELL_IN_TAB(self)

	Task.NoCombatCall(function()
		self:RegisterEvent("GROUP_ROSTER_UPDATE")

		_G.CompactRaidFrameContainer:UnregisterAllEvents()
		_G.CompactRaidFrameContainer:Hide()
		_G.CompactRaidFrameManager:UnregisterAllEvents()
		--_G.CompactRaidFrameManager:Show()

		local button

		for i=1, 8 do
			button = _G["CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarker"..i]
			button:GetNormalTexture():SetDesaturated(false)
			button:SetAlpha(1)
			button:Enable()
		end

		button = _G["CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerRemove"]
		button:GetNormalTexture():SetDesaturated(false)
		button:SetAlpha(1)
		button:Enable()

		button = _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll
		button:SetAlpha(1)
		button:Enable()

		button = _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck
		button:SetAlpha(1)
		button:Enable()

		return GROUP_ROSTER_UPDATE(self)
	end)
end

function GROUP_ROSTER_UPDATE(self)
	Task.NoCombatCall(function()
		if IsInGroup() then
			_G.CompactRaidFrameManager:Show()
		else
			_G.CompactRaidFrameManager:Hide()
		end
	end)
end

function PLAYER_REGEN_DISABLED(self)
	if raidPanelMask.Visible then
		raidPanelMask.Visible = false
		raidPanelConfig.Visible = false
		raidPanel:StopMovingOrSizing()
		raidPanel.Movable = false
	end
	if chkMode.Checked then
		chkMode.Checked = false
		Masks:Each(UpdateMaskButton)
	end
end

function SpellButton_UpdateButton(self)
	UpdateMaskButton(Masks[self:GetID()])
	if withPanel.Target then
		withPanel.Target = nil
		withPanel.Visible = false
	end
end

function UpdateMaskButton(self)
	if chkMode.Checked then
		self:RefreshBindingKey()
	else
		self.Visible = false
	end
end

function PLAYER_SPECIALIZATION_CHANGED(self)
	local now = GetSpecialization() or 1
	if now ~= _LoadingConfig then
		_DBChar[_LoadingConfig] = _IGASUI_SPELLHANDLER:Export()
		_LoadingConfig = now

		if _DBChar[now] then
			_IGASUI_SPELLHANDLER:Import(_DBChar[now])
		end
	end
	LEARNED_SPELL_IN_TAB(self)
end

function LEARNED_SPELL_IN_TAB(self)
	wipe(_IGASUI_HELPFUL_SPELL)
	for i = 1, MAX_SKILLLINE_TABS do
	    local name, texture, offset, numEntries, isGuild, offspecID = GetSpellTabInfo(i)

	    if not name then
	        break
	    end

	    if not isGuild and offspecID == 0 then
	        for index = offset + 1, offset + numEntries do
	            local skillType, spellId = GetSpellBookItemInfo(index, BOOKTYPE_SPELL)
	            local isPassive = IsPassiveSpell(index, BOOKTYPE_SPELL)
	            local isHelpful = IsHelpfulSpell(index, BOOKTYPE_SPELL)
	            local name = GetSpellInfo(spellId)

	            if not isPassive and isHelpful then
	            	_IGASUI_HELPFUL_SPELL[spellId] = true
	            	_IGASUI_HELPFUL_SPELL[name] = true
	            end
	        end
	    end
	end
end

function PLAYER_LOGOUT(self)
	local spec = GetSpecialization() or 1

	_DBChar[spec] = _IGASUI_SPELLHANDLER:Export()
end

--------------------
-- Script Handler
--------------------
_Updating = false

function chkMode:OnValueChanged()
	if self.Checked and not _Updating then
		_Updating = true
		_IGASUI_SPELLHANDLER:BeginUpdate()
	end
	withPanel.Visible = false
	Masks:Each(UpdateMaskButton)
end

function chkMode:OnHide()
	withPanel.Visible = false
	self.Checked = false
	if _Updating then
		_Updating = false
		_IGASUI_SPELLHANDLER:CommitUpdate()
	end
end

function raidPanelMask:OnMoveFinished()
	_DBChar.Location = raidPanel.Location
end

function raidPanelMask:OnShow()
	Toggle.Update()
end

function raidPanelMask:OnHide()
	Toggle.Update()
end

function chkTarget:OnValueChanged()
	if self.Checked then
		chkFocus.Checked = false
	end
	if withPanel.Target then
		withPanel.Target.With = chkTarget.Checked and "target" or chkFocus.Checked and "focus" or nil
		withPanel.Target:SetBindingKey(withPanel.Target.BindKey)
	end
end

function chkFocus:OnValueChanged()
	if self.Checked then
		chkTarget.Checked = false
	end
	if withPanel.Target then
		withPanel.Target.With = chkTarget.Checked and "target" or chkFocus.Checked and "focus" or nil
		withPanel.Target:SetBindingKey(withPanel.Target.BindKey)
	end
end

function raidPanel:OnElementAdd(unitframe)
	raidpanelMenuArray:Each(UpdateConfig4MenuBtn, unitframe)
	if iPowerBar then
		unitframe:AddElement(iPowerBar, "south", _DBChar.PowerHeight, "px")
	end
end

function raidPetPanel:OnElementAdd(unitframe)
	raidpanelMenuArray:Each(UpdateConfig4MenuBtn, unitframe)
end

function mnuRaidPanelSetWidth:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the element's width(px)", "ic") or nil)

	if value and value > 10 then
		_DBChar.ElementWidth = value
		raidPanel.ElementWidth = value
		raidPetPanel.ElementWidth = value
		raidDeadPanel.ElementWidth = value

		self.Text = L"Width : " .. tostring(value)

		if raidPanelMask.Visible then
			raidPanelMask:SetSize(raidPanel:GetSize())
		end
	end
end

function mnuRaidPanelSetHeight:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the element's height(px)", "ic") or nil)

	if value and value > _DBChar.PowerHeight then
		_DBChar.ElementHeight = value
		raidPanel.ElementHeight = value
		raidPetPanel.ElementHeight = value
		raidDeadPanel.ElementHeight = value

		self.Text = L"Height : " .. tostring(value)

		if raidPanelMask.Visible then
			raidPanelMask:SetSize(raidPanel:GetSize())
		end
	end
end

function mnuRaidPanelSetPowerHeight:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the power bar's height(px)", "ic") or nil)

	if value and value > 0 and value < raidPanel.ElementHeight then
		_DBChar.PowerHeight = value

		if iPowerBar then
			raidPanel:Each(function (self)
				self:AddElement(iPowerBar, "south", _DBChar.PowerHeight, "px")
			end)
		end

		self.Text = L"Power Height : " .. tostring(_DBChar.PowerHeight)
	end
end

function mnuRaidPanelSetUseClassColor:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar.ElementUseClassColor = self.Checked

		UpdateHealthBar4UseClassColor()
	end
end

function raidpanelMenuArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		_DisableElement[self[index].ElementName] = not self[index].Checked

		raidPanel:Each(UpdateConfig4UnitFrame, self[index])
		raidPetPanel:Each(UpdateConfig4UnitFrame, self[index])
	end
end

function raidpanelPropArray:OnCheckChanged(index)
	if raidPanelConfig.Visible and (self[index].Checked or not self[index].ConfigValue) then
		if self[index].ConfigName == "Orientation" then
			SetOrientation(self[index].UnitPanel, self[index].ConfigValue)
		else
			self[index].UnitPanel[self[index].ConfigName] = self[index].ConfigValue or self[index].Checked
		end

		-- keep set
		if self[index].UnitPanel == raidPanel then
			_RaidPanelSet[self[index].ConfigName] = raidPanel[self[index].ConfigName]
		elseif self[index].UnitPanel == raidPetPanel then
			_RaidPetPanelSet[self[index].ConfigName] = raidPetPanel[self[index].ConfigName]
		elseif self[index].UnitPanel == raidDeadPanel then
			_RaidDeadPanelSet[self[index].ConfigName] = raidDeadPanel[self[index].ConfigName]
		end
	end
end

function mnuRaidPanelActivated:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar.RaidPanelActivated = self.Checked

		raidPanel.Activated = _DBChar.RaidPanelActivated
	end
end

function mnuRaidPetPanelActivated:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar.RaidPetPanelActivated = self.Checked

		raidPetPanel.Activated = _DBChar.RaidPetPanelActivated
	end
end

function mnuRaidPetPanelDeactivateInRaid:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar.RaidPetPanelDeactivateInRaid = self.Checked

		raidPetPanel.DeactivateInRaid = _DBChar.RaidPetPanelDeactivateInRaid
	end
end

function mnuRaidDeadPanelActivated:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar.RaidDeadPanelActivated = self.Checked

		raidDeadPanel.Activated = _DBChar.RaidDeadPanelActivated
	end
end

function mnuRaidPetPanelLocationRight:OnCheckChanged()
	if raidPanelConfig.Visible and self.Checked then
		SetLocation("RIGHT")
	end
end

function mnuRaidPetPanelLocationBottom:OnCheckChanged()
	if raidPanelConfig.Visible and self.Checked then
		SetLocation("BOTTOM")
	end
end

function groupFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_GroupFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_GroupFilter, filter.FilterValue)
			end
		end

		raidPanel.GroupFilter = _GroupFilter

		raidPanel:Refresh()
	end
end

function classFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_ClassFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_ClassFilter, filter.FilterValue)
			end
		end

		raidPanel.ClassFilter = _ClassFilter

		raidPanel:Refresh()
	end
end

function roleFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_RoleFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_RoleFilter, filter.FilterValue)
			end
		end

		raidPanel.RoleFilter = _RoleFilter

		raidPanel:Refresh()
	end
end

function groupDeadFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_DeadGroupFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_DeadGroupFilter, filter.FilterValue)
			end
		end

		raidDeadPanel.GroupFilter = _DeadGroupFilter

		raidDeadPanel:Refresh()
	end
end

function classDeadFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_DeadClassFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_DeadClassFilter, filter.FilterValue)
			end
		end

		raidDeadPanel.ClassFilter = _DeadClassFilter

		raidDeadPanel:Refresh()
	end
end

function roleDeadFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_DeadRoleFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_DeadRoleFilter, filter.FilterValue)
			end
		end

		raidDeadPanel.RoleFilter = _DeadRoleFilter

		raidDeadPanel:Refresh()
	end
end

--------------------
-- Tool function
--------------------
function AddType4Config(type, text)
	local name = System.Reflector.GetNameSpaceName(type)
	local btn = raidPanelConfig:AddMenuButton(L"Indicator", text)

	btn.IsCheckButton = true
	btn.ElementName = name
	btn.ElementType = type

	raidpanelMenuArray:Insert(btn)
end

function UpdateConfig4UnitFrame(unitframe, mnuBtn)
	local ele = unitframe:GetElement(mnuBtn.ElementType)
	if ele then ele.Activated = mnuBtn.Checked end
end

function UpdateConfig4MenuBtn(mnuBtn, unitframe)
	return UpdateConfig4UnitFrame(unitframe, mnuBtn)
end

function SetOrientation(self, value)
	self.Orientation = value

	if self.Orientation == "HORIZONTAL" then
		self.RowCount = NUM_RAID_GROUPS
		self.ColumnCount = MEMBERS_PER_RAID_GROUP
	else
		self.ColumnCount = NUM_RAID_GROUPS
		self.RowCount = MEMBERS_PER_RAID_GROUP
	end
end

function SetLocation(value)
	_DBChar.PetPanelLocation = value

	Task.NoCombatCall(function()
		if value == "RIGHT" then
			raidPetPanel:ClearAllPoints()
			raidPetPanel:SetPoint("TOPLEFT", raidPanel, "TOPRIGHT")

			raidDeadPanel:ClearAllPoints()
			raidDeadPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")
		elseif value == "BOTTOM" then
			raidPetPanel:ClearAllPoints()
			raidPetPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")

			raidDeadPanel:ClearAllPoints()
			raidDeadPanel:SetPoint("TOPLEFT", raidPetPanel, "BOTTOMLEFT")
		end
	end)
end

function UpdateHealthBar4UseClassColor()
	local flag = _DBChar.ElementUseClassColor
	raidPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = flag
	end)
	raidPetPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = flag
	end)
	raidDeadPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = flag
	end)
end

--------------------
-- Load elements menu
--------------------
local order = {}

for _, ele in pairs(Config.Elements) do
	if ele.Locale and ele.Index then
		order[ele.Index] = ele
	end
end

for _, ele in ipairs(order) do
	AddType4Config(ele.Type, ele.Locale)
end

order = nil
