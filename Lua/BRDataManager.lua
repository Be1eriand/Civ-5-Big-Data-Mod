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
		for row in db.Query('CREATE TABLE BRDataCivTable(ID INTEGER PRIMARY KEY,PlayerID INTEGER, PlayerName TEXT,Alive TEXT,StrategicResources TEXT,LuxuryResources TEXT,BonusResources TEXT,Policies TEXT,ReligiousGold INTEGER,DiplomaticGold INTEGER)') do end;
		for row in db.Query('CREATE INDEX BRDataCivIndex on BRDataCivTable(PlayerID)') do end;
    end;

	if (tables["BRDataTable"] ~= true) then
		logger:debug("Creating Battle Royale Data table");
		for row in db.Query('CREATE TABLE BRDataTable(Turn INTEGER,PlayerID INTEGER,NetGPT INTEGER,GrossGPT INTEGER,Treasury INTEGER,MilitaryMight INTEGER,MilitarySeaMight INTEGER,MilitaryAirMight INTEGER,MilitaryLandMight INTEGER,NumMilitary INTEGER,NumSeaMilitary INTEGER,NumAirMilitary INTEGER,NumLandMilitary INTEGER,Score INTEGER,Happiness INTEGER,Science INTEGER,Techs INTEGER,Land INTEGER,Production INTEGER,Food INTEGER,SocialPolicies INTEGER,Culture INTEGER,Population INTEGER,Cities INTEGER,Wonders INTEGER,Faith INTEGER,Faithperturn INTEGER,TradeRoutesUsed INTEGER,GreatWorks INTEGER,CivsInfluenced INTEGER,TourismOutput INTEGER)') do end
		for row in db.Query('CREATE INDEX BRDataIndex on BRDataTable(Turn)') do end;
    end;

	if (tables["BRDCitiesTable"] ~= true) then
		logger:debug("Creating Battle Royale Data Cities table");
		for row in db.Query('CREATE TABLE BRDCitiesTable(CityID INTEGER PRIMARY KEY, City_Name	TEXT, Original_Owner INTEGER, Current_Owner INTEGER,Previous_Owner INTEGER,Founded INTEGER,Acquired INTEGER,Population INTEGER,GPT INTEGER,Science INTEGER,Production INTEGER,Food INTEGER,Culture INTEGER,Faith INTEGER)') do end
		for row in db.Query('CREATE INDEX BRDCitiesIndex on BRDCitiesTable(CityID,City_Name)') do end;
    end;

end;

InitBRD_database();

function StorePlayerData(pPlayer,turn)

	logger:debug("Saving Player data for " .. pPlayer:GetCivilizationDescription());

		local pTeam = Teams[pPlayer:GetTeam()];
		local PlayerData = {};

		PlayerData.PlayerID = pPlayer:GetID();
		PlayerData.NetGPT = pPlayer:CalculateGoldRate();
		PlayerData.GrossGPT = pPlayer: CalculateGrossGold();
		PlayerData.Treasury = pPlayer:GetGold();
		PlayerData.MilitaryMight = pPlayer:GetMilitaryMight();
		PlayerData.MilitarySeaMight = pPlayer:GetMilitarySeaMight();
		PlayerData.MilitaryAirMight = pPlayer:GetMilitaryAirMight();
		PlayerData.MilitaryLandMight = pPlayer:GetMilitaryLandMight();
		PlayerData.NumMilitary = pPlayer:GetNumMilitaryUnits();      
		PlayerData.NumSeaMilitary = pPlayer:GetNumMilitarySeaUnits();
		PlayerData.NumAirMilitary = pPlayer:GetNumMilitaryAirUnits();
		PlayerData.NumLandMilitary = pPlayer:GetNumMilitaryLandUnits();
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

function UpdateCivData(pPlayer)

	local CivData = {}

	CivData.PlayerID = pPlayer:GetID()
	CivData.PlayerName = pPlayer:GetCivilizationDescription()
	CivData.Alive = tostring(pPlayer:IsAlive())
	CivData.Policies = getNumCivPolicies(pPlayer)
	CivData.ReligiousGold = pPlayer:GetGoldPerTurnFromReligion()
	CivData.DiplomaticGold = pPlayer:GetGoldPerTurnFromDiplomacy()

	local PlayerResources = getPlayerResources(pPlayer);

	CivData.StrategicResources = PlayerResources["Strategic Resources"]
	CivData.LuxuryResources = PlayerResources["Luxury Resources"]
	CivData.BonusResources = PlayerResources["Bonus Resources"]

	for row in db.Query('INSERT OR REPLACE into BRDataCivTable(ID,PlayerID,PlayerName,Alive,StrategicResources,LuxuryResources,BonusResources,Policies,ReligiousGold,DiplomaticGold) VALUES((SELECT ID FROM BRDataCivTable where PlayerName ="'.. CivData.PlayerName ..'"),'.. CivData.PlayerID ..',"'.. CivData.PlayerName ..'","'.. CivData.Alive ..'","' .. CivData.StrategicResources.Total .. '","' .. CivData.LuxuryResources.Total .. '","' .. CivData.BonusResources.Total .. '","' .. CivData.Policies .. '","' .. CivData.ReligiousGold .. '","' .. CivData.DiplomaticGold .. '")') do end;

end;

function UpdateCityData(pCity)
	
	local CityData = {}
	CityData.CityName = pCity:GetName()
	
	logger:debug("Getting City data for " .. CityData.CityName);


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
	CityData.Puppet = pCity:IsPuppet()
	CityData.Science = pCity:GetYieldRate( YieldTypes.YIELD_SCIENCE );
	CityData.GPT = pCity:GetYieldRate( YieldTypes.YIELD_GOLD );
	CityData.Founded = pCity:GetGameTurnFounded();
	CityData.Acquired = pCity:GetGameTurnAcquired();

	for row in db.Query('INSERT OR REPLACE into BRDCitiesTable (CityID,City_Name,Original_Owner,Current_Owner,Previous_Owner,Founded,Acquired,Population,GPT,Science,Production,Food,Culture,Faith) VALUES((SELECT CityID FROM BRDCitiesTable where City_Name="'.. CityData.CityName ..'"), "'..CityData.CityName..'",'.. CityData.Original_Owner ..','.. CityData.Current_Owner ..','.. CityData.Previous_Owner ..','.. CityData.Founded.. ','.. CityData.Acquired ..','.. CityData.Population ..','.. CityData.GPT ..','.. CityData.Science ..','.. CityData.Production ..','.. CityData.Food ..','..CityData.Culture..','.. CityData.Faith ..')') do end;

end;


function StoreTurnData(turn)

	logger:debug("Saving Data for turn " .. turn);

	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	
		local pPlayer = Players[iPlayerLoop];

		if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
			UpdateCivData(pPlayer);
			StorePlayerData(pPlayer,turn);
			for pCity in pPlayer:Cities() do
				UpdateCityData(pCity);
			end;
		end;
	end;
end;

Events.SerialEventEndTurnDirty.Add(BRDEndTurn);