-----------------------------------------
-- Name Label for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- iNameLabel
-- @type class
-- @name iNameLabel
-----------------------------------------------
class "iNameLabel"
	inherit "NameLabel"
	extend "IFThreat"

	_TARGET_TEMPLATE = FontColor.RED .. ">>" .. FontColor.CLOSE .. "%s" .. FontColor.RED .. "<<" .. FontColor.CLOSE

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetText(self, text)
		self.__iNameLabelText = text or ""
		UpdateText(self)
	end

	function GetText(self)
		return self.__iNameLabelText
	end

	function UpdateText(self)
		if self.ThreatLevel >=2 then
			Super.SetText(self, _TARGET_TEMPLATE:format(self.__iNameLabelText or ""))
		else
			Super.SetText(self, self.__iNameLabelText)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ThreatLevel
	property "ThreatLevel" {
		Set = function(self, value)
			self.__iNameLabelThreatLevel = value
			UpdateText(self)
		end,
		Get = function(self)
			return self.__iNameLabelThreatLevel or 0
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iNameLabel(...)
		local label = Super(...)

		label.UseClassColor = true

		return label
	end
endclass "iNameLabel"

-----------------------------------------------
--- IFINameLabel
-- @type interface
-- @name IFINameLabel
-----------------------------------------------
interface "IFINameLabel"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFINameLabel(self)
		self:AddElement(iNameLabel)
		self.iNameLabel:SetPoint("TOPLEFT")
		self.iNameLabel:SetPoint("TOPRIGHT")

		self.iNameLabel.UseClassColor = true
		self.iNameLabel.DrawLayer = "BORDER"
    end
endinterface "IFINameLabel"

partclass "iRaidUnitFrame"
	extend "IFINameLabel"
endclass "iRaidUnitFrame"
