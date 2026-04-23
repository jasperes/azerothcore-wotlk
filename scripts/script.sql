-- ====================================
-- CLASSIC
-- ====================================

-- tbc dungeons
UPDATE dungeon_access_template
SET min_level = 61
WHERE min_level = 55
AND comment IN (
    'The Shattered Halls',
    'The Blood Furnace',
    'Hellfire Ramparts',
    'The Steamvault',
    'The Underbog',
    'The Slave Pens',
    'Sethekk Halls',
    'Mana Tombs',
    'Auchenai Crypts'
);

-- wotlk dungeons
UPDATE dungeon_access_template SET min_level = 71 WHERE min_level = 65 AND comment ='Utgarde Keep';
UPDATE dungeon_access_template SET min_level = 71 WHERE min_level = 66 AND comment ='The Nexus';
UPDATE dungeon_access_template SET min_level = 71 WHERE min_level = 67 AND comment ='Azjol-Nerub';
UPDATE dungeon_access_template SET min_level = 71 WHERE min_level = 68 AND comment ='Ahn\'Kahet';
UPDATE dungeon_access_template SET min_level = 71 WHERE min_level = 69 AND comment ='Drak\'Tharon Keep';
UPDATE dungeon_access_template SET min_level = 71 WHERE min_level = 70 AND comment ='Violet Hold';

-- get the dark portal to spit you back out
DELETE FROM `areatrigger_teleport` WHERE `ID` = 4354;
INSERT INTO `areatrigger_teleport` VALUES (4354, 'Dark Portal To Outland', 0, -11883.2, -3206.1, -16.616, 0.1357);

-- delete the Northrend boats and NPCs
DELETE FROM `transports` WHERE `guid` IN (10, 11, 12, 17);
DELETE FROM `creature` WHERE `guid` IN (200017, 203491, 120786);

-- ====================================
-- TBC
-- ====================================

-- restore tbc dungeons
UPDATE dungeon_access_template
SET min_level = 55
WHERE min_level = 61
AND comment IN (
    'The Shattered Halls',
    'The Blood Furnace',
    'Hellfire Ramparts',
    'The Steamvault',
    'The Underbog',
    'The Slave Pens',
    'Sethekk Halls',
    'Mana Tombs',
    'Auchenai Crypts'
);

-- restore the original dark portal
DELETE FROM `areatrigger_teleport` WHERE `ID` = 4354;
INSERT INTO `areatrigger_teleport` VALUES
(4354, 'Dark Portal To Outland', 530, -248.149, 921.875, 84.3885, 1.58415);

-- ====================================
-- WOTLK
-- ====================================

-- voltar dk settings em world e bots

-- restore wotlk dungeons
UPDATE dungeon_access_template SET min_level = 65 WHERE min_level = 71 AND comment ='Utgarde Keep';
UPDATE dungeon_access_template SET min_level = 66 WHERE min_level = 71 AND comment ='The Nexus';
UPDATE dungeon_access_template SET min_level = 67 WHERE min_level = 71 AND comment ='Azjol-Nerub';
UPDATE dungeon_access_template SET min_level = 68 WHERE min_level = 71 AND comment ='Ahn\'Kahet';
UPDATE dungeon_access_template SET min_level = 69 WHERE min_level = 71 AND comment ='Drak\'Tharon Keep';
UPDATE dungeon_access_template SET min_level = 70 WHERE min_level = 71 AND comment ='Violet Hold';

-- restore the Northrend boats
DELETE FROM `transports` WHERE `guid` IN (10, 11, 12, 17);
INSERT INTO `transports` VALUES
(10, 181688, 'Menethil Harbor, Wetlands and Valgarde, Howling Fjord ("Northspear")', ''),
(11, 181689, 'Undercity, Tirisfal Glades and Vengeance Landing, Howling Fjord ("Zeppelin, Horde (Cloudkisser)")', ''),
(12, 186238, 'Orgrimmar, Durotar and Warsong Hold, Borean Tundra ("Zeppelin, Horde (The Mighty Wind)")', ''),
(17, 190536, 'Stormwing Harbor and Valiance Keep, Borean Tundra ("The Kraken")', '');

-- restore the Northrend NPCs
DELETE FROM `creature` WHERE `guid` IN (200017, 203491, 120786);
INSERT INTO `creature` VALUES
(200017, 36558, 650, 0, 0, 3, 1, 0, 0, 705.497, 583.944, 412.476, 0.698132, 999999, 0, 0, 50000, 0, 0, 0, 0, 0, '', 0),
(203491, 26537, 1, 0, 0, 1, 1, 24164, 1, 1174.13, -4152.37, 51.646, 3.33, 300, 0, 0, 2218, 0, 0, 0, 0, 0, '', 0),
(120786, 26548, 0, 0, 0, 1, 1, 24135, 1, -8302.65, 1401.96, 5.31355, 5.35816, 180, 0, 0, 1848, 0, 0, 0, 0, 0, '', 0);
