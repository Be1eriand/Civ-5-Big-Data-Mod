-- BRDataOptions
-- Author: Be1eriand
-- DateCreated: 12/13/2015
--------------------------------------------------------------
MapModData.BattleRoyaleData = {};
include("BRDLib");
logger:info("Processing BRDOptions");


function ShowHideHandler(bIsHide, bIsInit)
	if(not bIsHide) then
		UpdateOptions();
	end
end
ContextPtr:SetShowHideHandler(ShowHideHandler);
Controls.BRDOptionBox:SetHide(true);

function UpdateOptions()
	local bOn = false;
	if (getBRDataOption("WhosWinning") ==1) then
		bOn = true;
	end;
	Controls.WhosWinningCheckbox:SetCheck(bOn);

	bOn = false;
		if (getBRDataOption("GoldenAge") ==1) then
		bOn = true;
	end;
	Controls.GoldenAgeCheckbox:SetCheck(bOn);

	bOn = false;
		if (getBRDataOption("NaturalWonder") ==1) then
		bOn = true;
	end;
	Controls.NaturalWonderCheckbox:SetCheck(bOn);

	bOn = false;
	if (getBRDataOption("WorldCongress") ==1) then
		bOn = true;
	end;
	Controls.WorldCongressCheckbox:SetCheck(bOn);

end;

function OnClose()
  Controls.BRDOptionBox:SetHide(true);
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnClose);

function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
            OnClose();
            return true;
        end
    end
end
ContextPtr:SetInputHandler(InputHandler);

function OnWhosWinningCheckbox(bIsChecked)
	setBRDataOption("WhosWinning", bIsChecked)
end;
Controls.WhosWinningCheckbox:RegisterCheckHandler(OnWhosWinningCheckbox);

function OnGoldenAgeCheckbox(bIsChecked)
	setBRDataOption("GoldenAge", bIsChecked)
end;
Controls.GoldenAgeCheckbox:RegisterCheckHandler(OnGoldenAgeCheckbox);

function OnNaturalWonderCheckbox(bIsChecked)
	setBRDataOption("NaturalWonder", bIsChecked)
end;
Controls.NaturalWonderCheckbox:RegisterCheckHandler(OnNaturalWonderCheckbox);

function OnWorldCongressCheckbox(bIsChecked)
	setBRDataOption("WorldCongress", bIsChecked)
end;
Controls.WorldCongressCheckbox:RegisterCheckHandler(OnWorldCongressCheckbox);

function onBRDoptions()
	local hidden = Controls.BRDOptionBox:IsHidden();
	Controls.BRDOptionBox:SetHide(not hidden);
end

Controls.OptionButton:RegisterCallback(Mouse.eLClick, onBRDoptions);
