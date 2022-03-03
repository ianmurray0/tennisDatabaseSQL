use TennisModelling;

-- Drop tables before creating them.
DROP TABLE IF EXISTS MATCH;
DROP TABLE IF EXISTS TOURNAMENT;
DROP TABLE IF EXISTS IN_PLAY_STATISTICS;
DROP TABLE IF EXISTS PLAYER;
--DROP TABLE IF EXISTS IN_PLAY_DATA;

-- Methods for creating each table.

-- Table for each individual player
CREATE TABLE PLAYER(
    [PLAYER_ID] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PLAYER_NAME] [VARCHAR](50) NOT NULL,
    [PLAYER_ELO] INT,
    [PLAYER_PRIMARY_HAND] [VARCHAR](5)
);

-- Table for the in-play data output from parser
CREATE TABLE IN_PLAY_DATA(
    [IN_PLAY_DATA_ID] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IN_PLAY_DATA_KEY] [VARCHAR](100),
    [IN_PLAY_DATA_SET_NUMBER] [INT],
    [IN_PLAY_DATA_PLAYER_ONE_GAMES_WON] [INT] NOT NULL,
    [IN_PLAY_DATA_PLAYER_TWO_GAMES_WON] [INT] NOT NULL,
    [IN_PLAY_DATA_SET_WINNER] [INT],
    [IN_PLAY_DATA_GAME_NUMBER] [INT],
    [IN_PLAY_DATA_GAME_WINNER] [INT],
    [IN_PLAY_DATA_POINT_NUMBER] [INT],
    [IN_PLAY_DATA_POINT_WINNER] [INT],
    [IN_PLAY_DATA_POINT_SERVER] [INT],
    [IN_PLAY_DATA_SCORE] [VARCHAR](10)
);

-- Potential need for this table later, will provide the stats from each match
CREATE TABLE IN_PLAY_STATISTICS(
    IN_PLAY_DATA_KEY [VARCHAR](100) NOT NULL PRIMARY KEY,
    PLAYER_ONE INT NOT NULL,
    PLAYER_TWO INT NOT NULL,
    --FOREIGN KEY (IN_PLAY_DATA_KEY) REFERENCES IN_PLAY_DATA(IN_PLAY_DATA_KEY)
);

-- Table for each tournament
CREATE TABLE TOURNAMENT(
    TOURNAMENT_ID INT NOT NULL PRIMARY KEY,
    TOURNAMENT_NAME [VARCHAR](50) NOT NULL
);

-- Table for every match, refernces the ids of the players, the tounament, and the match data
CREATE TABLE MATCH(
    MATCH_ID INT PRIMARY KEY,
    TOURNAMENT_ID INT,
    PLAYER_ONE_ID INT,
    PLAYER_TWO_ID INT,
    IN_PLAY_DATA_KEY [VARCHAR](100),
    --FOREIGN KEY (IN_PLAY_DATA_KEY) REFERENCES IN_PLAY_DATA(IN_PLAY_DATA_KEY),
    FOREIGN KEY (TOURNAMENT_ID) REFERENCES TOURNAMENT(TOURNAMENT_ID),
    FOREIGN KEY (PLAYER_ONE_ID) REFERENCES PLAYER(PLAYER_ID),
    FOREIGN KEY (PLAYER_TWO_ID) REFERENCES PLAYER(PLAYER_ID)
);

-- Procedures to populate data

-- procedure to Populate Player Table when primary hand not provided
DROP PROCEDURE IF EXISTS SP_PLAYER_NAME_ADD;
GO
CREATE PROCEDURE SP_PLAYER_NAME_ADD
    @P_NAME VARCHAR(50)
AS 
    INSERT INTO [PLAYER]([PLAYER_NAME])
    SELECT @P_NAME
    WHERE 
        NOT EXISTS (SELECT [PLAYER_ID] FROM [PLAYER] WHERE [PLAYER_NAME] = @P_NAME);
GO

-- procedure to Populate Player Table when name and primary hand provided
DROP PROCEDURE IF EXISTS SP_PLAYER_NAME_HAND_ADD;
GO
CREATE PROCEDURE SP_PLAYER_NAME_HAND_ADD
    @P_NAME VARCHAR(50),
    @P_PRIMARY_HAND VARCHAR(5)
AS 
    INSERT INTO [PLAYER]([PLAYER_NAME],[PLAYER_PRIMARY_HAND])
    SELECT @P_NAME, @P_PRIMARY_HAND
    WHERE 
        NOT EXISTS (SELECT [PLAYER_ID] FROM [PLAYER] WHERE [PLAYER_NAME] = @P_NAME);
GO

-- Procedure to Populate In_Play_Data
DROP PROCEDURE IF EXISTS [SP_IN_PLAY_DATA_ADD]
GO
CREATE PROCEDURE [SP_IN_PLAY_DATA_ADD]
    @IPD_KEY VARCHAR(100),
    @IPD_SET_NUMBER INT,
    @IPD_PLAYER_ONE_GAMES_WON INT,
    @IPD_PLAYER_TWO_GAMES_WON INT,
    @IPD_SET_WINNER INT,
    @IPD_GAME_NUMBER INT,
    @IPD_GAME_WINNER INT,
    @IPD_POINT_NUMBER INT,
    @IPD_POINT_WINNER INT,
    @IPD_POINT_SERVER INT,
    @IPD_SCORE VARCHAR(10)
AS
BEGIN 
    INSERT INTO [IN_PLAY_DATA]([IN_PLAY_DATA_KEY], [IN_PLAY_DATA_SET_NUMBER], [IN_PLAY_DATA_PLAYER_ONE_GAMES_WON], [IN_PLAY_DATA_PLAYER_TWO_GAMES_WON],[IN_PLAY_DATA_SET_WINNER], 
    [IN_PLAY_DATA_GAME_NUMBER], [IN_PLAY_DATA_GAME_WINNER], [IN_PLAY_DATA_POINT_NUMBER], [IN_PLAY_DATA_POINT_WINNER], [IN_PLAY_DATA_POINT_SERVER],[IN_PLAY_DATA_SCORE])
    SELECT
        @IPD_KEY,
        @IPD_SET_NUMBER,
        @IPD_PLAYER_ONE_GAMES_WON,
        @IPD_PLAYER_TWO_GAMES_WON,
        @IPD_SET_WINNER,
        @IPD_GAME_NUMBER,
        @IPD_GAME_WINNER,
        @IPD_POINT_NUMBER,
        @IPD_POINT_WINNER,
        @IPD_POINT_SERVER,
        @IPD_SCORE
    WHERE
        NOT EXISTS (SELECT [IN_PLAY_DATA_KEY] FROM [IN_PLAY_DATA] WHERE [IN_PLAY_DATA_KEY] = @IPD_KEY)
END
GO

-- CREATES VIEW TO VIEW PLAYER TABLE
DROP VIEW IF EXISTS V_PLAYER;
GO
CREATE VIEW V_PLAYER
AS
SELECT * FROM [PLAYER];
GO

-- populate tables by calling stored procedures
-- PLAYER TABLE
EXEC SP_PLAYER_NAME_ADD "Roger Federer";
EXEC SP_PLAYER_NAME_ADD "Rafael Nadal";
EXEC SP_IN_PLAY_DATA_ADD "test", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10; 

--SHOW OUTPUT
SELECT * FROM IN_PLAY_DATA;