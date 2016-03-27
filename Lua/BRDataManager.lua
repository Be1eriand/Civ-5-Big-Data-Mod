-- Battle Royale Data Manager
-- Author: Be1eriand
-- DateCreated: 07/12/2015
--------------------------------------------------------------

-- Data Manager file for Battle Royale Data Mod

include("BRDLib");
logger:info("Processing BRDataManger");

-- Single, persistent database connection
local db = Modding.OpenSaveData();

function InitBRD_database()

	local tables = {};
  
	if (db == nil) then
		logger:error("Database handle was not available. Cannot initialize our BRD tables.");
		return nil;
	end;
  
	for row in db.Query('SELECT name FROM sqlite_master WHERE type = "table"') do 
		tables[row.name] = true;
		logger:debug("Found table " .. row.name);
	end;
	
	if (tables["BRDataCivTable"] ~= true) then
		logger:debug("Creating Battle Royale Data Civ Table");
		for row in db.Query('CREATE TABLE BRDataCivTable(ID INTEGER PRIMARY KEY,PlayerID INTEGER, PlayerName TEXT,Alive TEXT,GoldenAge TEXT,Era TEXT,StrategicResources TEXT,LuxuryResources TEXT,BonusResources TEXT,Policies TEXT,ReligiousGold INTEGER,DiplomaticGold INTEGER,Denounced TEXT,AtWar TEXT,Friends TEXT)') do end;
		for row in db.Query('CREATE INDEX BRDataCivIndex on BRDataCivTable(PlayerID)') do end;
    end;

	Game:WriteCSV("BRDCivData.csv","Turn,PlayerID, PlayerName,Alive,GoldenAge,Era,StrategicResources,LuxuryResources,BonusResources,Policies,ReligiousGold,DiplomaticGold,Denounced,AtWar,Friends")

	if (tables["BRDataTable"] ~= true) then
		logger:debug("Creating Battle Royale Data table");
		for row in db.Query('CREATE TABLE BRDataTable(Turn INTEGER,PlayerID INTEGER,NetGPT INTEGER,GrossGPT INTEGER,Treasury INTEGER,MilitaryMight INTEGER,MilitarySeaMight INTEGER,MilitaryAirMight INTEGER,MilitaryLandMight INTEGER,NumMilitary INTEGER,NumSeaMilitary INTEGER,NumAirMilitary INTEGER,NumLandMilitary INTEGER,Score INTEGER,Happiness INTEGER,Science INTEGER,Techs INTEGER,Land INTEGER,Production INTEGER,Food INTEGER,SocialPolicies INTEGER,Culture INTEGER,Population INTEGER,Cities INTEGER,Wonders INTEGER,Faith INTEGER,Faithperturn INTEGER,TradeRoutesUsed INTEGER,GreatWorks INTEGER,CivsInfluenced INTEGER,TourismOutput INTEGER)') do end
		for row in db.Query('CREATE INDEX BRDataIndex on BRDataTable(Turn)') do end;
    end;

	Game:WriteCSV("BRData.csv","Turn,PlayerID,PlayerName,NetGPT,GrossGPT,Treasury,MilitaryMight,MilitarySeaMight,MilitaryAirMight,MilitaryLandMight,NumMilitary,NumSeaMilitary,NumAirMilitary,NumLandMilitary,Score,Happiness,Science,Techs,Land,Production,Food,SocialPolicies,Culture,Population,Cities,Wonders,Faith,Faithperturn,TradeRoutesUsed,GreatWorks,CivsInfluenced,TourismOutput");

	if (tables["BRDCitiesTable"] ~= true) then
		logger:debug("Creating Battle Royale Data Cities table");
		for row in db.Query('CREATE TABLE BRDCitiesTable(ID INTEGER PRIMARY KEY,City_Name TEXT, X INTEGER, Y INTEGER, Original_Owner INTEGER, Current_Owner INTEGER,Previous_Owner INTEGER,Founded INTEGER,Acquired INTEGER,Religion TEXT,Population INTEGER,GPT INTEGER,Science INTEGER,Production INTEGER,Food INTEGER,Culture INTEGER,Faith INTEGER)') do end
		for row in db.Query('CREATE INDEX BRDCitiesIndex on BRDCitiesTable(ID,City_Name)') do end;
    end;

	Game:WriteCSV("BRDCities.csv","Turn,City Name, X, Y, Original Owner, Current Owner,Previous Owner,Founded,Acquired,Religion,Population,GPT,Science,Production,Food,Culture,Faith");
	
	Game:WriteCSV("BRDReligion.csv","Turn,Religion Name,Founder,Holy City,Followers,Num of Cities");

	Game:WriteCSV("BRDCityFlips.csv","Turn,City Name,Previous Owner,New Owner,Population");

	Game:WriteCSV("BRDWonders.CSV","Turn,Owner,Wonder");

end;

InitBRD_database();

function StorePlayerData(iPlayerLoop,turn)

	local pPlayer = Players[iPlayerLoop];

	logger:debug("Saving Player data for " .. pPlayer:GetCivilizationDescription());

		local pTeam = Teams[pPlayer:GetTeam()];
		local PlayerData = {};

		PlayerData.Turn = turn;
		PlayerData.PlayerName = pPlayer:GetCivilizationShortDescription();
		PlayerData.PlayerID = pPlayer:GetID();
		PlayerData.NetGPT = pPlayer:CalculateGoldRate();
		PlayerData.GrossGPT = pPlayer: CalculateGrossGold();
		PlayerData.Treasury = pPlayer:GetGold();
		PlayerData.Score = pPlayer:GetScore();
		PlayerData.Happiness = pPlayer:GetExcessHappiness();           
		PlayerData.Science = pPlayer:GetScience();           
		PlayerData.Techs = pTeam:GetTeamTechs():GetNumTechsKnown(); 
		PlayerData.Land = pPlayer:GetNumPlots();              
		PlayerData.Production = pPlayer:CalculateTotalYield(YieldTypes.YIELD_PRODUCTION); 
		PlayerData.Food = pPlayer:CalculateTotalYield(YieldTypes.YIELD_FOOD);                 
		PlayerData.SocialPolicies = pPlayer:GetNumPolicies();              
		PlayerData.Culture = pPlayer:GetTotalJONSCulturePerTurn(); 
		PlayerData.Population = pPlayer:GetRealPopulation(); 
		PlayerData.Cities = pPlayer:GetNumCities();           
		PlayerData.Wonders = pPlayer:GetNumWorldWonders();               
		PlayerData.Faith = pPlayer:GetFaith();             
		PlayerData.Faithperturn = pPlayer:GetFaithPerTurnFromCities() + pPlayer:GetFaithPerTurnFromMinorCivs() + pPlayer:GetFaithPerTurnFromReligion();    
		PlayerData.TradeRoutesUsed = pPlayer:GetNumInternationalTradeRoutesUsed();     
		PlayerData.GreatWorks = pPlayer:GetNumGreatWorks();          
		PlayerData.CivsInfluenced = pPlayer:GetNumCivsInfluentialOn();           
		PlayerData.TourismOutput = pPlayer:GetTourism();

		PlayerData.MilitaryMight = pPlayer:GetMilitaryMight();
		PlayerData.NumMilitary = pPlayer:GetNumMilitaryUnits();

		PlayerData.MilitarySeaMight = pPlayer:GetMilitarySeaMight();
		PlayerData.MilitaryAirMight = pPlayer:GetMilitaryAirMight();
		PlayerData.MilitaryLandMight = pPlayer:GetMilitaryLandMight();
		PlayerData.NumSeaMilitary = pPlayer:GetNumMilitarySeaUnits();
		PlayerData.NumAirMilitary = pPlayer:GetNumMilitaryAirUnits();
		PlayerData.NumLandMilitary = pPlayer:GetNumMilitaryLandUnits();

		DataToCSV(PlayerData);

		for row in db.Query('INSERT INTO BRDataTable VALUES('.. turn .. ',' .. PlayerData.PlayerID .. ',' .. PlayerData.NetGPT .. ',' .. PlayerData.GrossGPT .. ',' .. PlayerData.Treasury .. ',' .. PlayerData.MilitaryMight .. ',' .. PlayerData.MilitarySeaMight .. ',' .. PlayerData.MilitaryAirMight .. ',' .. PlayerData.MilitaryLandMight .. ',' .. PlayerData.NumMilitary .. ',' .. PlayerData.NumSeaMilitary .. ',' .. PlayerData.NumAirMilitary .. ',' .. PlayerData.NumLandMilitary .. ',' .. PlayerData.Score .. ',' .. PlayerData.Happiness .. ',' .. PlayerData.Science .. ',' .. PlayerData.Techs .. ',' .. PlayerData.Land .. ',' .. PlayerData.Production .. ',' .. PlayerData.Food .. ',' .. PlayerData.SocialPolicies .. ',' .. PlayerData.Culture .. ',' .. PlayerData.Population .. ',' .. PlayerData.Cities .. ',' .. PlayerData.Wonders .. ',' .. PlayerData.Faith .. ',' .. PlayerData.Faithperturn .. ',' .. PlayerData.TradeRoutesUsed .. ',' .. PlayerData.GreatWorks .. ',' .. PlayerData.CivsInfluenced .. ',' .. PlayerData.TourismOutput .. ')') do end;
end ;

local turnTracker = Game.GetGameTurn();

function BRDEndTurn()

  local thisTurn = Game.GetGameTurn();
  
  if (turnTracker ~= thisTurn) then
    logger:debug("Turn change detected: thisTurn = " .. thisTurn .. ", turnTracker = " .. turnTracker);

    if (thisTurn - turnTracker ~= 1) then
      logger:error("Uh oh! It looks like we may have skipped a turn: thisTurn = " .. thisTurn .. ", turnTracker = " .. turnTracker);
    end;

	StoreTurnData(thisTurn);

    turnTracker = thisTurn;
  end;

end;

function UpdateCivData(iPlayerLoop)

	local CivData = {}
	local pPlayer = Players[iPlayerLoop];

	CivData.Turn = Game.GetGameTurn()
	CivData.PlayerID = pPlayer:GetID()
	CivData.PlayerName = pPlayer:GetCivilizationShortDescription()
	CivData.Alive = tostring(pPlayer:IsAlive())
	CivData.Policies = getNumCivPolicies(pPlayer)
	CivData.ReligiousGold = pPlayer:GetGoldPerTurnFromReligion()
	CivData.DiplomaticGold = pPlayer:GetGoldPerTurnFromDiplomacy()
	CivData.Denounced = PlayersWeHaveDenounced(pPlayer)
	CivData.AtWar = PlayersAtWar(pPlayer)
	CivData.Friends = PlayersFriends(pPlayer)
	CivData.Era = Locale.ConvertTextKey(GameInfo.Eras[pPlayer:GetCurrentEra()].Description)
	CivData.GoldenAge = tostring(pPlayer:IsGoldenAge())

	logger:debug("Current Era : " .. CivData.Era);
	logger:debug("Golden Age : " .. CivData.GoldenAge);
	logger:debug("We have denouced :" .. CivData.Denounced);
	logger:debug("We are at war with :" .. CivData.AtWar);
	logger:debug("We are friends with :" .. CivData.Friends);

	local PlayerResources = getPlayerResources(pPlayer);

	CivData.StrategicResources = PlayerResources["Strategic Resources"]
	CivData.LuxuryResources = PlayerResources["Luxury Resources"]
	CivData.BonusResources = PlayerResources["Bonus Resources"]

	logger:debug("Strategic Resources: " .. CivData.StrategicResources.Total)
	logger:debug("Luxury Resources: " .. CivData.LuxuryResources.Total)
	logger:debug("Bonus Resources: " .. CivData.BonusResources.Total)

	CivDataToCSV(CivData);

	for row in db.Query('INSERT OR REPLACE into BRDataCivTable(ID,PlayerID,PlayerName,Alive,GoldenAge,Era,StrategicResources,LuxuryResources,BonusResources,Policies,ReligiousGold,DiplomaticGold,Denounced,AtWar,Friends) VALUES((SELECT ID FROM BRDataCivTable where PlayerID ="'.. CivData.PlayerID ..'"),'.. CivData.PlayerID ..',"'.. CivData.PlayerName ..'","'.. CivData.Alive ..'","'.. CivData.GoldenAge ..'","'.. CivData.Era ..'","' .. CivData.StrategicResources.Total .. '","' .. CivData.LuxuryResources.Total .. '","' .. CivData.BonusResources.Total .. '","' .. CivData.Policies .. '","' .. CivData.ReligiousGold .. '","' .. CivData.DiplomaticGold .. '","'.. CivData.Denounced ..'","' .. CivData.AtWar .. '","' .. CivData.Friends ..'")') do end;

end;

function UpdateCityData(pCity)
	
	local CityData = {}
	CityData.CityName = pCity:GetName()
	
	logger:debug("Getting City data for " .. CityData.CityName);
	logger: debug("City ID: " .. pCity:GetID());

	CityData.Turn = Game.GetGameTurn();
	CityData.X = pCity:GetX();
	CityData.Y = pCity:GetY();
	CityData.Current_Owner = pCity:GetOwner();
	CityData.Faith = pCity:GetFaithPerTurn();
	CityData.Food = pCity:GetYieldRate(YieldTypes.YIELD_FOOD)
	CityData.Happiness = pCity:GetHappiness()
	CityData.Culture = pCity:GetJONSCulturePerTurn()
	CityData.Previous_Owner = pCity:GetPreviousOwner()
	CityData.Population = pCity:GetPopulation()
	CityData.Original_Owner = pCity:GetOriginalOwner()
	CityData.Production = pCity:GetYieldRate( YieldTypes.YIELD_PRODUCTION );
	CityData.Real_Population = pCity:GetRealPopulation()
	CityData.Puppet = tostring(pCity:IsPuppet())
	CityData.Science = pCity:GetYieldRate( YieldTypes.YIELD_SCIENCE );
	CityData.GPT = pCity:GetYieldRate( YieldTypes.YIELD_GOLD );
	CityData.Founded = pCity:GetGameTurnFounded();
	CityData.Acquired = pCity:GetGameTurnAcquired();
	CityData.Plots = pCity:GetNumCityPlots();
	if pCity:GetReligiousMajority() == -1 then
		CityData.Religion = "";
	else
		CityData.Religion = Locale.ConvertTextKey(Game.GetReligionName(pCity:GetReligiousMajority()));
	end;
	
	logger:debug("Religion ID: " .. pCity:GetReligiousMajority());

	CityDataToCSV(CityData);

	for row in db.Query('INSERT OR REPLACE into BRDCitiesTable (ID,City_Name,X,Y,Original_Owner,Current_Owner,Previous_Owner,Founded,Acquired,Religion,Population,GPT,Science,Production,Food,Culture,Faith) VALUES((SELECT ID FROM BRDCitiesTable where City_Name="'.. CityData.CityName ..'"),"'..CityData.CityName..'","'.. CityData.X ..'","'.. CityData.Y ..'",'.. CityData.Original_Owner ..','.. CityData.Current_Owner ..','.. CityData.Previous_Owner ..','.. CityData.Founded.. ','.. CityData.Acquired ..',"'.. CityData.Religion ..'",'.. CityData.Population ..','.. CityData.GPT ..','.. CityData.Science ..','.. CityData.Production ..','.. CityData.Food ..','..CityData.Culture..','.. CityData.Faith ..')') do end;

end;

function UpdateReligionData(pPlayer)

	local eReligion = pPlayer:GetReligionCreatedByPlayer();

	logger:debug("Saving Religion Data" .. Game.GetReligionName(eReligion))

	local ReligionData = {}

	ReligionData.Turn = Game.GetGameTurn();
	ReligionData.Name = Locale.ConvertTextKey(Game.GetReligionName(eReligion));

	local HolyCity = Game.GetHolyCityForReligion(eReligion, pPlayer:GetID());

	ReligionData.Founder = pPlayer:GetCivilizationDescription();
	ReligionData.HolyCity = HolyCity:GetName();
	ReligionData.Followers = Game.GetNumFollowers(eReligion);
	ReligionData.NumCities = Game.GetNumCitiesFollowing(eReligion);

	ReligionDataToCSV(ReligionData)

end

function UpdateWonderData(pPlayer)
	
	local WonderData = {}

	WonderData.Turn = Game.GetGameTurn();
	WonderData.Owner = pPlayer:GetCivilizationDescription();


	for pBuilding in GameInfo.Buildings() do
		local iBuilding = pBuilding.ID;
					
		local pBuildingClass = GameInfo.BuildingClasses[pBuilding.BuildingClass];
		if (pBuildingClass.MaxGlobalInstances > 0) then
			if (pPlayer:CountNumBuildings(iBuilding) > 0) then
				WonderData.Wonder = Locale.ConvertTextKey(pBuilding.Description);
				logger:debug(WonderData.Wonder);
				WonderDataToCSV(WonderData);
			end
		end
	end

end

function StoreTurnData(turn)

	logger:debug("Saving Data for turn " .. turn);

	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	
		local pPlayer = Players[iPlayerLoop];

		if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
			StorePlayerData(iPlayerLoop,turn);
			UpdateCivData(iPlayerLoop);
			UpdateWonderData(pPlayer);
			if (pPlayer:HasCreatedReligion()) then
				UpdateReligionData(pPlayer);
			end
			for pCity in pPlayer:Cities() do
				UpdateCityData(pCity);
			end;
		end;
	end;

end;

Events.SerialEventEndTurnDirty.Add(BRDEndTurn);

function SaveCityFlips(iOldOwner, bIsCapital, iX, iY, iNewOwner, iPop, bConquest)
	
	local CityFlip = {}

	local pNewOwner = Players[iNewOwner];
	local pOldOwner = Players[iOldOwner];
	local pCity = Map.GetPlot(iX, iY):GetPlotCity();

	CityFlip.NewPlayerName = pNewOwner:GetCivilizationShortDescription()
	CityFlip.PreviousPlayerName = pOldOwner:GetCivilizationShortDescription()
	CityFlip.Turn = Game.GetGameTurn(); 
	CityFlip.CityName = pCity:GetName()
	CityFlip.Population = pCity:GetPopulation();


	logger:debug("New Player Name: " .. CityFlip.NewPlayerName)
	logger:debug("Old Player Name: " .. CityFlip.PreviousPlayerName)
	logger:debug( CityFlip.CityName .. " has flipped")
	logger:debug("Population: " .. CityFlip.Population)

	CityFlipToCSV(CityFlip);

end

GameEvents.CityCaptureComplete.Add(SaveCityFlips)

function ResearchAgreementData(notificationIdx,notificationType,toolTip,summary,gameValue,extraGameData)

	if (notificationType == 1319111517) and (summary == "New Research Agreement") then -- NOTIFICATION_DIPLOMACY_DECLARATION
		Game:WriteCSV("BRDResearchAgreement.txt","Turn " .. Game.GetGameTurn() .. ": " .. toolTip)

		logger:debug("Notification Index: " .. notificationIdx)
		logger:debug("Notification Type: " .. notificationType)
		logger:debug("Tooltip: " .. toolTip)
		logger:debug("Summary: " .. summary)
		logger:debug("Game Value: " .. gameValue)
		logger:debug("Extra Game Data: " .. extraGameData)
	end
end

Events.NotificationAdded.Add(ResearchAgreementData)

function SaveWonderData(notificationIdx,notificationType,toolTip,summary,gameValue,extraGameData)

	if (notificationType == 2091697919 ) then -- NOTIFICATION_WONDER_COMPLETED
		Game:WriteCSV("BRDWonder.txt", "Turn " .. Game.GetGameTurn() .. ": " .. summary)
		Game:WriteCSV("BRDWonder.txt", "Turn " .. Game.GetGameTurn() .. ": " .. toolTip)
		
		logger:debug("Notification Index: " .. notificationIdx)
		logger:debug("Notification Type: " .. notificationType)
		logger:debug("Tooltip: " .. toolTip)
		logger:debug("Summary: " .. summary)
		logger:debug("Game Value: " .. gameValue)
		logger:debug("Extra Game Data: " .. extraGameData)
	end

end

Events.NotificationAdded.Add(SaveWonderData)