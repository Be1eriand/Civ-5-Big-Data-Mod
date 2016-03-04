-- Battle Royale Data Init
-- Author: Be1eriand
-- DateCreated: 07/12/2015
--------------------------------------------------------------

-- Init file for Battle Royale Data Mod.
-- Setting up the main shared table for the mod
include("BRDLib")
logger:info("Initialising");


-- Data manager for Battle Royale Data.
ContextPtr:LoadNewContext("BRDataManager")
