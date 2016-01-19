-- BRDHooks.lua
-- Author: Be1eriand
-- DateCreated: 07/12/2015
--------------------------------------------------------------
include("BRDLib");
logger:info("Processing BRDHooks");

function OnDiplomaticCornerPopup()
	 UIManager:PushModal(MapModData.BattleRoyaleData.BRDScreenContext)
end;

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  table.insert(additionalEntries, {
    text=Locale.ConvertTextKey("BRD Options"), 
    call=OnDiplomaticCornerPopup
  })
end

LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()