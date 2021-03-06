-----------------------------------------
-- Designer for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

_HeadList = Array()

-----------------------------------------
-- Menu
-----------------------------------------
_Menu = DropDownList("Menu", IGAS.UIParent.IGAS_IFActionHandler_Manager)
_Menu.MultiSelect = true

_MenuClose = _Menu:AddMenuButton(L"Close Menu")

_MenuMap = _Menu:AddMenuButton(L"Action Map")
_ListActionMap = List("LstActionMap", _MenuMap)
_ListActionMap:SetList({
	L"None",
	L"Main Bar",
	L"Bar 1",
	L"Bar 2",
	L"Bar 3",
	L"Bar 4",
	L"Bar 5",
	L"Bar 6",
	L"Pet Bar",
	L"Stance Bar",
})
_ListActionMap.Width = 150
_ListActionMap.Height = 250
_ListActionMap.Visible = false
_MenuMap.DropDownList = _ListActionMap

_MenuLock = _Menu:AddMenuButton(L"Global Style", L"Lock Action")
_MenuLock.IsCheckButton = true

_MenuScale = _Menu:AddMenuButton(L"Bar Style", L"Scale")
_ListScale = List("LstScale", _MenuScale)
local key, item = {}, {}
for i = 1, 20 do
	key[i] = i/10
	item[i] = tostring(key[i])
end
_ListScale.Keys = key
_ListScale.Items = item
_ListScale.Width = 150
_ListScale.Height = 250
_ListScale.Visible = false
_MenuScale.DropDownList = _ListScale

_MenuMarginX = _Menu:AddMenuButton(L"Bar Style", L"Horizontal Margin")
_ListMarginX = List("LstMarginX", _MenuMarginX)
local key, item = {}, {}
for i = 1, 33 do
	key[i] = 17 - i
	item[i] = tostring(key[i])
end
_ListMarginX.Keys = key
_ListMarginX.Items = item
_ListMarginX.Width = 150
_ListMarginX.Height = 250
_ListMarginX.Visible = false
_MenuMarginX.DropDownList = _ListMarginX

_MenuMarginY = _Menu:AddMenuButton(L"Bar Style", L"Vertical Margin")
_ListMarginY = List("LstMarginY", _MenuMarginY)
local key, item = {}, {}
for i = 1, 33 do
	key[i] = 17 - i
	item[i] = tostring(key[i])
end
_ListMarginY.Keys = key
_ListMarginY.Items = item
_ListMarginY.Width = 150
_ListMarginY.Height = 250
_ListMarginY.Visible = false
_MenuMarginY.DropDownList = _ListMarginY

_MenuAutoHide = _Menu:AddMenuButton(L"Bar Style", L"Auto Hide")
_MenuAutoHide:ActiveThread("OnClick")

_MenuAlwaysShowGrid = _Menu:AddMenuButton(L"Bar Style", L"Always Show Grid")
_MenuAlwaysShowGrid.IsCheckButton = true

_MenuUseDown = _Menu:AddMenuButton(L"Global Style", L"Use mouse down")
_MenuUseDown.IsCheckButton = true

_MenuPopupDuration = _Menu:AddMenuButton(L"Global Style", L"Popup Duration")
_MenuPopupDuration:ActiveThread("OnClick")

_MenuKeyBinding = _Menu:AddMenuButton(L"Key Binding")

_MenuFreeMode = _Menu:AddMenuButton(L"Free Mode")
_MenuFreeMode.IsCheckButton = true

_MenuManual = _Menu:AddMenuButton(L"Manual Move&Resize")

_MenuSwap = _Menu:AddMenuButton(L"Swap Pop-up action")
_MenuSwap.IsCheckButton = true

_MenuAutoGenerate = _Menu:AddMenuButton(L"Auto generate popup actions")
_MenuAutoGenerate:ActiveThread("OnClick")

_MenuSaveSet = _Menu:AddMenuButton(L"Save & Load", L"Save Settings")
_ListSaveSet = List("LstSaveSet", _MenuSaveSet)
_ListSaveSet.Width = 150
_ListSaveSet.Height = 250
_ListSaveSet.Visible = false
_MenuSaveSet.DropDownList = _ListSaveSet

_MenuLoadSet = _Menu:AddMenuButton(L"Save & Load", L"Load Settings")
_ListLoadSet = List("LstLoadSet", _MenuLoadSet)
_ListLoadSet.Width = 150
_ListLoadSet.Height = 250
_ListLoadSet.Visible = false
_MenuLoadSet.DropDownList = _ListLoadSet

_MenuSave = _Menu:AddMenuButton(L"Save & Load", L"Save Layout")
_ListSave = List("LstSave", _MenuSave)
_ListSave.Width = 150
_ListSave.Height = 250
_ListSave.Visible = false
_MenuSave.DropDownList = _ListSave

_MenuLoad = _Menu:AddMenuButton(L"Save & Load", L"Load Layout")
_ListLoad = List("LstLoad", _MenuLoad)
_ListLoad.Width = 150
_ListLoad.Height = 250
_ListLoad.Visible = false
_MenuLoad.DropDownList = _ListLoad

_MenuBarSave = _Menu:AddMenuButton(L"Save & Load", L"Save action bar's layout")
_ListBarSave = List("LstBarSave", _MenuBarSave)
_ListBarSave.Width = 150
_ListBarSave.Height = 250
_ListBarSave.Visible = false
_MenuBarSave.DropDownList = _ListBarSave

_MenuBarLoad = _Menu:AddMenuButton(L"Save & Load", L"Apply action bar's layout")
_ListBarLoad = List("LstBarLoad", _MenuBarLoad)
_ListBarLoad.Width = 150
_ListBarLoad.Height = 250
_ListBarLoad.Visible = false
_MenuBarLoad.DropDownList = _ListBarLoad

_MenuHideBlz = _Menu:AddMenuButton(L"Global Style", L"Hidden MainMenuBar")
_MenuHideBlz.IsCheckButton = true

_MenuDelete = _Menu:AddMenuButton(L"Delete Bar")
_MenuDelete:ActiveThread("OnClick")

_MenuNew = _Menu:AddMenuButton(L"New Bar")
_MenuNew:ActiveThread("OnClick")

_MenuNoGCD = _Menu:AddMenuButton(L"Global Style", L"Hide Global cooldown")
_MenuNoGCD.IsCheckButton = true

_MenuColorBar = _Menu:AddMenuButton(L"Global Style", L"Color the action button")

_MenuColorToggle = _MenuColorBar:AddMenuButton(L"Enable")
_MenuColorToggle:ActiveThread("OnClick")

_MenuColorOOM = _MenuColorBar:AddMenuButton(L"Lack of resource")
_MenuColorOOM.IsColorPicker = true

_MenuColorOOR = _MenuColorBar:AddMenuButton(L"Out of range")
_MenuColorOOR.IsColorPicker = true

_MenuColorUnusable = _MenuColorBar:AddMenuButton(L"Unusable for other reason")
_MenuColorUnusable.IsColorPicker = true

_MenuCDLabel = _Menu:AddMenuButton(L"Global Style", L"Use cooldown label")

_MenuCDLabelToggle = _MenuCDLabel:AddMenuButton(L"Enable")
_MenuCDLabelToggle:ActiveThread("OnClick")

_MenuSowAutoGenBlackList = _Menu:AddMenuButton(L"Global Style", L"Show item black list")

_MenuModifyAnchorPoints = _Menu:AddMenuButton(L"Bar Style", L"Modify AnchorPoints")
_MenuModifyAnchorPoints:ActiveThread("OnClick")

-----------------------------------
-- Auto-gen Item Black List
-----------------------------------
_AutoGenBlackListForm = Form("IGAS_UI_AutoGen_Black_List")
_AutoGenBlackListForm.Caption = L"Auto-gen item black list"
_AutoGenBlackListForm.Message = L"Double click to remove"
_AutoGenBlackListForm:SetSize(300, 400)
_AutoGenBlackListForm:Hide()

_AutoGenBlackListList = List("List", _AutoGenBlackListForm)
_AutoGenBlackListList:SetPoint("TOPLEFT", 4, -26)
_AutoGenBlackListList:SetPoint("BOTTOMRIGHT", -4, 26)
_AutoGenBlackListList.ShowTooltip = true