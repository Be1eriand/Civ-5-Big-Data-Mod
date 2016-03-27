-- BRDLib.lua
-- Author: Be1eriand
-- DateCreated: 07/12/2015
--------------------------------------------------------------

include("BRDLogger");
logger = LoggerType:new();
logger:setLevel(INFO);
logger:debug("Processing BRDLib");

function BRDModID()
  return "Battle Royale Big Data Mod";
end;

function BRDModVersion()
  return 1;
end;

function BRDModGUID()
  return "1076dc5d-a665-4db9-a3eb-a10d235316c1";
end;


-- Open a persistent connection to the user database.

local modUserData = Modding.OpenUserData(BRDModID(), BRDModVersion());

function escapeCSV(s)
	
	if type(s) == "string" then
		if string.find(s, '[,"]') then
			s = '"' .. string.gsub(s, '"', '""') .. '"'
		end
	elseif type(s) == "boolean" then
		if s == true then
			s = "True"
		else 
			s = "False"
		end
	end

	return s
end

function getPlayer(PlayerID)

	local s = ""
	if PlayerID == -1 then
		s = "None"
	else
		local pPlayer = Players[PlayerID];
		s = pPlayer:GetCivilizationShortDescription();
	end

	return s
end

function CityDataToCSV(CD)
	
	local s = escapeCSV(CD.Turn)

	s = s .. "," .. escapeCSV(CD.CityName)
	s = s .. "," .. escapeCSV(CD.X)
	s = s .. "," .. escapeCSV(CD.Y)
	s = s .. "," .. escapeCSV(getPlayer(CD.Original_Owner))
	s = s .. "," .. escapeCSV(getPlayer(CD.Current_Owner))
	s = s .. "," .. escapeCSV(getPlayer(CD.Previous_Owner))
	s = s .. "," .. escapeCSV(CD.Founded)
	s = s .. "," .. escapeCSV(CD.Acquired)
	s = s .. "," .. escapeCSV(CD.Religion)
	s = s .. "," .. escapeCSV(CD.Population)
	s = s .. "," .. escapeCSV(CD.GPT)
	s = s .. "," .. escapeCSV(CD.Science)
	s = s .. "," .. escapeCSV(CD.Production)
	s = s .. "," .. escapeCSV(CD.Food)
	s = s .. "," .. escapeCSV(CD.Culture)
	s = s .. "," .. escapeCSV(CD.Faith)

	logger:debug(s)

	Game:WriteCSV("BRDCities.CSV",s)
end

function CivDataToCSV(CD)
	
	local s = escapeCSV(CD.Turn)

	s = s .. "," .. escapeCSV(CD.PlayerID)
	s = s .. "," .. escapeCSV(CD.PlayerName)
	s = s .. "," .. escapeCSV(CD.Alive)
	s = s .. "," .. escapeCSV(CD.GoldenAge)
	s = s .. "," .. escapeCSV(CD.Era)
	s = s .. "," .. escapeCSV(CD.StrategicResources.Total)
	s = s .. "," .. escapeCSV(CD.LuxuryResources.Total)
	s = s .. "," .. escapeCSV(CD.BonusResources.Total)
	s = s .. "," .. escapeCSV(CD.Policies)
	s = s .. "," .. escapeCSV(CD.ReligiousGold)
	s = s .. "," .. escapeCSV(CD.DiplomaticGold)
	s = s .. "," .. escapeCSV(CD.Denounced)
	s = s .. "," .. escapeCSV(CD.AtWar)
	s = s .. "," .. escapeCSV(CD.Friends)

	logger:debug(s)

	Game:WriteCSV("BRDCivData.csv",s)
end

function DataToCSV(CD)
	
	local s = escapeCSV(CD.Turn)

	s = s .. "," .. escapeCSV(CD.PlayerID)
	s = s .. "," .. escapeCSV(CD.PlayerName)
	s = s .. "," .. escapeCSV(CD.NetGPT)
	s = s .. "," .. escapeCSV(CD.GrossGPT)
	s = s .. "," .. escapeCSV(CD.Treasury)
	s = s .. "," .. escapeCSV(CD.MilitaryMight)
	s = s .. "," .. escapeCSV(CD.MilitarySeaMight)
	s = s .. "," .. escapeCSV(CD.MilitaryAirMight)
	s = s .. "," .. escapeCSV(CD.MilitaryLandMight)
	s = s .. "," .. escapeCSV(CD.NumMilitary)
	s = s .. "," .. escapeCSV(CD.NumSeaMilitary)
	s = s .. "," .. escapeCSV(CD.NumAirMilitary)
	s = s .. "," .. escapeCSV(CD.NumLandMilitary)
	s = s .. "," .. escapeCSV(CD.Score)
	s = s .. "," .. escapeCSV(CD.Happiness)
	s = s .. "," .. escapeCSV(CD.Science)
	s = s .. "," .. escapeCSV(CD.Techs)
	s = s .. "," .. escapeCSV(CD.Land)
	s = s .. "," .. escapeCSV(CD.Production)
	s = s .. "," .. escapeCSV(CD.Food)
	s = s .. "," .. escapeCSV(CD.SocialPolicies)
	s = s .. "," .. escapeCSV(CD.Culture)
	s = s .. "," .. escapeCSV(CD.Population)
	s = s .. "," .. escapeCSV(CD.Cities)
	s = s .. "," .. escapeCSV(CD.Wonders)
	s = s .. "," .. escapeCSV(CD.Faith)
	s = s .. "," .. escapeCSV(CD.Faithperturn)
	s = s .. "," .. escapeCSV(CD.TradeRoutesUsed)
	s = s .. "," .. escapeCSV(CD.GreatWorks)
	s = s .. "," .. escapeCSV(CD.CivsInfluenced)
	s = s .. "," .. escapeCSV(CD.TourismOutput)

	logger:debug(s)

	Game:WriteCSV("BRData.csv",s)
end

function ReligionDataToCSV(RD)
	
	local s = escapeCSV(RD.Turn)

	s = s .. "," .. escapeCSV(RD.Name)
	s = s .. "," .. escapeCSV(RD.Founder)
	s = s .. "," .. escapeCSV(RD.HolyCity)
	s = s .. "," .. escapeCSV(RD.Followers)
	s = s .. "," .. escapeCSV(RD.NumCities)

	Game:WriteCSV("BRDReligion.csv",s)

end

function CityFlipToCSV(CF)

	local s = escapeCSV(CF.Turn)

	s = s .. "," .. escapeCSV(CF.CityName)
	s = s .. "," .. escapeCSV(CF.PreviousPlayerName)
	s = s .. "," .. escapeCSV(CF.NewPlayerName)
	s = s .. "," .. escapeCSV(CF.Population)

	Game:WriteCSV("BRDCityFlips.csv",s)

end

function WonderDataToCSV(WD)

	local s = escapeCSV(WD.Turn)

	s = s .. "," .. escapeCSV(WD.Owner)
	s = s .. "," .. escapeCSV(WD.Wonder)

	Game:WriteCSV("BRDWonders.CSV",s)

end

function getBRDataOption(option)
  local rowname = "option-" .. option;
  local value = modUserData.GetValue(rowname);
  logger:trace("Retrieved option " .. rowname .. " = " .. tostring(value));
  return value;
end;

function setBRDataOption(option, value)
  local rowname = "option-" .. option;
  logger:trace("Setting " .. rowname .. " to " .. tostring(value));
  modUserData.SetValue(rowname, value);
end;

function getPlayerResources(pPlayer)

	local PlayerResources = {}

	PlayerResources["Strategic Resources"] = {}
	PlayerResources["Luxury Resources"] = {}
	PlayerResources["Bonus Resources"] = {}

	PlayerResources["Strategic Resources"].Total = ""
	PlayerResources["Strategic Resources"].Export = ""
	PlayerResources["Strategic Resources"].Import = ""

	PlayerResources["Luxury Resources"].Total = ""
	PlayerResources["Luxury Resources"].Export = ""
	PlayerResources["Luxury Resources"].Import = ""

	PlayerResources["Bonus Resources"].Total = ""
	PlayerResources["Bonus Resources"].Export = ""
	PlayerResources["Bonus Resources"].Import = ""

	for resource in GameInfo.Resources() do
		local iResource = resource.ID
		local iTotal = pPlayer:GetNumResourceTotal(iResource, true)
		local iExport = pPlayer:GetResourceExport(iResource)
		local iImport = pPlayer:GetResourceImport(iResource)

		if (iTotal > 0) or (iExport> 0) or (iImport > 0)then
			
			if(Game.GetResourceUsageType(iResource) == ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC) then
				PlayerResources["Strategic Resources"].Total = PlayerResources["Strategic Resources"].Total .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iTotal
				PlayerResources["Strategic Resources"].Export = PlayerResources["Strategic Resources"].Export .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iExport
				PlayerResources["Strategic Resources"].Import = PlayerResources["Strategic Resources"].Import .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iImport
			end;

			if(Game.GetResourceUsageType(iResource) == ResourceUsageTypes.RESOURCEUSAGE_LUXURY) then
				PlayerResources["Luxury Resources"].Total = PlayerResources["Luxury Resources"].Total .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iTotal
				PlayerResources["Luxury Resources"].Export = PlayerResources["Luxury Resources"].Export .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iExport
				PlayerResources["Luxury Resources"].Import = PlayerResources["Luxury Resources"].Import .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iImport
			end;

			if(Game.GetResourceUsageType(iResource) == ResourceUsageTypes.RESOURCEUSAGE_BONUS) then
				PlayerResources["Bonus Resources"].Total = PlayerResources["Bonus Resources"].Total .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iTotal
				PlayerResources["Bonus Resources"].Export = PlayerResources["Bonus Resources"].Export .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iExport
				PlayerResources["Bonus Resources"].Import = PlayerResources["Bonus Resources"].Import .. " " .. Locale.ConvertTextKey(resource.Description) .. " : " .. iImport
			end;
		end;

	end;

	return PlayerResources;
end;

function getNumPolicyBranch(pPlayer, pPolicyBranch)
	
	local iCount = 0

	for pPolicy in GameInfo.Policies() do
		local iPolicy = pPolicy.ID

		if (pPolicy.PolicyBranchType == pPolicyBranch.Type) then
			if (pPlayer:HasPolicy(iPolicy)) then
				iCount = iCount + 1;
			end
		end
	end

	return iCount

end;

function getNumCivPolicies(pPlayer)

	local sPolicies = ""

	for pPolicyBranch in GameInfo.PolicyBranchTypes() do
		local iCount = 0

		iCount = getNumPolicyBranch(pPlayer, pPolicyBranch)

		if (iCount > 0)then
			sPolicies = sPolicies .. " " .. Locale.ConvertTextKey(pPolicyBranch.Description) .. ": " .. iCount
		end
	end

	logger:debug(sPolicies)

	return sPolicies
end;

function PlayersWeHaveDenounced(pPlayer)

	local text = "";

	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do

		pOtherPlayer = Players[iPlayerLoop];

		if (pPlayer:IsDenouncedPlayer(iPlayerLoop)) then

			text = text .. " " .. pOtherPlayer:GetCivilizationShortDescription() .. ":"

			if(pPlayer.GetDenouncedPlayerCounter ~= nil) then
				local turnsLeft = GameDefines.DENUNCIATION_EXPIRATION_TIME - pPlayer:GetDenouncedPlayerCounter(iOtherPlayer);
				text = text .. turnsLeft;
			end

		end;
	end;

	if text == "" then
		text = "None"
	end;

	return text;
end;

function PlayersAtWar(pPlayer)

	local iTeam = pPlayer:GetTeam();
	local pTeam = Teams[iTeam];
	local text = "";

	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do

		local pOtherPlayer = Players[iPlayerLoop];
		local iOtherTeam = pOtherPlayer:GetTeam();
		local pOtherTeam = Teams[iOtherTeam];

		if (pTeam:IsAtWar(iOtherTeam)) then
			text = text .. " " .. pOtherPlayer:GetCivilizationShortDescription()
		end;
	end;

	if text == "" then
		text = "None"
	end;

	return text;
end;

function PlayersFriends(pPlayer)

	local iTeam = pPlayer:GetTeam();
	local pTeam = Teams[iTeam];

	local text = "";

	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do

		pOtherPlayer = Players[iPlayerLoop];

		if (pPlayer:IsDoF(iPlayerLoop)) then

			text = text .. " " .. pOtherPlayer:GetCivilizationShortDescription() .. ":"

			if(pPlayer.GetDenouncedPlayerCounter ~= nil) then
				local turnsLeft = GameDefines.DOF_EXPIRATION_TIME - pPlayer:GetDoFCounter(iPlayerLoop);
				text = text .. turnsLeft;
			end

		end;
	end;

	if text == "" then
		text = "None"
	end;

	return text;
end;