-- 1. SSMS 입문
SELECT TOP (1000) [lahmanID]
    ,[playerID]
    ,[managerID]
    ,[hofID]
    ,[birthYear]
    ,[birthMonth]
    ,[birthDay]
    ,[birthCountry]
    ,[birthState]
    ,[birthCity]
    ,[deathYear]
    ,[deathMonth]
    ,[deathDay]
    ,[deathCountry]
    ,[deathState]
    ,[deathCity]
    ,[nameFirst]
    ,[nameLast]
    ,[nameNote]
    ,[nameGiven]
    ,[nameNick]
    ,[weight]
    ,[height]
    ,[bats]
    ,[throws]
    ,[debut]
    ,[finalGame]
    ,[college]
    ,[lahman40ID]
    ,[lahman45ID]
    ,[retroID]
    ,[holtzID]
    ,[bbrefID]
FROM [BaseballData].[dbo].[players]
;

select * from dbo.players;

SELECT * FROM DBO.PLAYERS;