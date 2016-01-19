-- Battle Royale Data Init
-- Author: Be1eriand
-- DateCreated: 07/12/2015
--------------------------------------------------------------

-- Init file for Battle Royale Data Mod.
-- Setting up the main shared table for the mod
MapModData.BattleRoyaleData = {}
include("BRDLib")
logger:info("Initialising");


-- Data manager for Battle Royale Data.
ContextPtr:LoadNewContext("BRDataManager")

-- Main UI context for the Battle Royale Data Mod GUI.

MapModData.BattleRoyaleData.BRDScreenContext = ContextPtr:LoadNewContext("BRDOptions");
MapModData.BattleRoyaleData.BRDScreenContext:SetHide(true);


-- Load the UI hooks for Battle Royale Data
ContextPtr:LoadNewContext("BRDHooks");