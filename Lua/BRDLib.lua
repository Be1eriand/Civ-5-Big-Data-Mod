-- BRDLib.lua
-- Author: Be1eriand
-- DateCreated: 07/12/2015
--------------------------------------------------------------

include("BRDLogger");
logger = LoggerType:new();
logger:setLevel(DEBUG);
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



function GetReplayType(type)

  if (type == "Score") then return "REPLAYDATASET_SCORE";
  elseif (type == "MilitaryMight") then return "REPLAYDATASET_MILITARYMIGHT";
  elseif (type == "Culture") then return "REPLAYDATASET_CULTUREPERTURN";
  elseif (type == "Happiness") then return "REPLAYDATASET_EXCESSHAPINESS";
  elseif (type == "Science") then return "REPLAYDATASET_SCIENCEPERTURN";
  elseif (type == "Land") then return "REPLAYDATASET_TOTALLAND";
  elseif (type == "Production") then return "REPLAYDATASET_PRODUCTIONPERTURN";
  elseif (type == "Population") then return "REPLAYDATASET_POPULATION";
  elseif (type == "GrossGPT") then return "REPLAYDATASET_GOLDPERTURN";
  elseif (type == "Treasury") then return "REPLAYDATASET_TOTALGOLD";
  elseif (type == "Food") then return "REPLAYDATASET_FOODPERTURN";
  elseif (type == "Cities") then return "REPLAYDATASET_CITYCOUNT";
  elseif (type == "SocialPolicies") then return "REPLAYDATASET_NUMBEROFPOLICIES";
  elseif (type == "Techs") then return "REPLAYDATASET_TECHSKNOWN";

  -- Types that are unique to Battle Royal Data Mod
  elseif (type == "Wonders") then return "BRDDATASET_WONDERS";
  elseif (type == "NetGPT") then return "BRDDATASET_NETGOLDPERTURN";
  elseif (type == "MilitarySeaMight") then return "BRDDATASET_MILITARYSEAMIGHT";
  elseif (type == "MilitaryAirMight") then return "BRDDATASET_MILITARYAIRMIGHT";
  elseif (type == "MilitaryLandMight") then return "BRDDATASET_MILITARYLANDMIGHT";
  elseif (type == "NumMilitary") then return "BRDDATASET_NUMMILITARY";
  elseif (type == "NumSeaMilitary") then return "BRDDATASET_NUMSEAMILITARY";
  elseif (type == "NumAirMilitary") then return "BRDDATASET_NUMAIRMILITARY";
  elseif (type == "NumLandMilitary") then return "BRDDATASET_NUMLANDMILITARY";
  end;

  return type;
end;

function escapeCSV(s)
	if string.find(s, '[,"]') then
		s = '"' .. string.gsub(s, '"', '""') .. '"'
	end
	return s
end

function toCSV(t)
	local s = ""
	local r = ""
	for item, value in pairs(t) do
		s = s .. "," .. escapeCSV(item)
		r = r .. "," .. escapeCSV(value)
	end
	return string.sub(s,2), string.sub(r,2) 
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

	local iPolicyBranch = pPolicyBranch.ID
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

		if (iCount > 0) then
			sPolicies = sPolicies .. " " .. Locale.ConvertTextKey(pPolicyBranch.Description) .. ": " .. iCount
		end
	end

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

	return text;
end;