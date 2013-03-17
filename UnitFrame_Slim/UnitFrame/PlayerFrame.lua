-----------------------------------------
-- Player Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmPlayer = iUnitFrame("IGAS_UI_PlayerFrame")
frmPlayer:SetPoint("TOPLEFT", 40, 0)
frmPlayer:SetSize(200, 36)
frmPlayer.Unit = "player"

-- Hidden Mana
frmPlayer:InsertElement(frmPlayer.iPowerBar, iHiddenManaBar, "south", 6, "px")

-- Class Power & Combo
frmPlayer:AddElement(iClassPower)
frmPlayer.iClassPower.Height = 6
frmPlayer.iClassPower:SetPoint("BOTTOMLEFT", frmPlayer, "TOPLEFT", 0, 4)
frmPlayer.iClassPower:SetPoint("BOTTOMRIGHT", frmPlayer, "TOPRIGHT", 0, 4)

-- Eclipse
if select(2, UnitClass("player")) == "DRUID" then
	frmPlayer:AddElement(iEclipseBar)
	frmPlayer.iEclipseBar.Height = 6
	frmPlayer.iEclipseBar:SetPoint("BOTTOMLEFT", frmPlayer, "TOPLEFT", 0, 4)
	frmPlayer.iEclipseBar:SetPoint("BOTTOMRIGHT", frmPlayer, "TOPRIGHT", 0, 4)
end

-- Rune Bar
if select(2, UnitClass("player")) == "DEATHKNIGHT" then
	frmPlayer:AddElement(iRuneBar)
	frmPlayer.iRuneBar.Height = 6
	frmPlayer.iRuneBar:SetPoint("BOTTOMLEFT", frmPlayer, "TOPLEFT", 0, 4)
	frmPlayer.iRuneBar:SetPoint("BOTTOMRIGHT", frmPlayer, "TOPRIGHT", 0, 4)
end

-- Totem
frmPlayer:AddElement(TotemBar)
frmPlayer.TotemBar:SetPoint("BOTTOM", frmPlayer, "TOP", 0, 4)

-- Combat Icon
frmPlayer:AddElement(CombatIcon)
frmPlayer.CombatIcon:SetPoint("CENTER", frmPlayer, "TOPLEFT")

-- Pvp Icon
frmPlayer:AddElement(PvpIcon)
frmPlayer.PvpIcon:SetPoint("CENTER", frmPlayer, "RIGHT", 12, 0)

-- Power Text
frmPlayer:AddElement(iPlayerPowerText)
frmPlayer.iPlayerPowerText:SetPoint("RIGHT", frmPlayer.iPowerBar, "LEFT", -4, 0)

-- Stagger
if select(2, UnitClass("player")) == "MONK" then
	frmPlayer:AddElement(iStaggerBar)
	frmPlayer.iStaggerBar:SetAllPoints(frmPlayer.iHealthBar)
end
