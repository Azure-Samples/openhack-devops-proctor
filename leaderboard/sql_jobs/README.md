# SQL Job Flow

## NOTES
If using TestData.sql to generate your dataset, it is important to run the entire script and not just log message generation since the challenge start/end times and log message createddate are relate to execution time.

* De-dup Log Messages for challenges that have Scoring Enabled and a valid EndDateTime (default value is 9999-12-31 23:59:59.9999999 which means the challenge is still ongoing and not completed.)

### Calculate team downtime

```SQL
    UPDATE TEAMS SET DOWNTIMEMINUTES = DTSUM.DTM
    FROM  (
        SELECT DTCALC.TEAMNAME, DTCALC.TEAMID, SUM(DOWNTIMEMINUTES) DTM
        FROM (
            SELECT T.TEAMNAME AS [TEAMNAME],
                T.ID AS [TEAMID],
                CD.[NAME] AS [CHALLENGENAME],
                CD.[ID] AS [CHALLENGEDEFINITIONID],
                C.ID AS [CHALLENGEID],
                COUNT(DISTINCT L.TIMESLICE) AS DOWNTIMEMINUTES
            FROM CHALLENGES AS C WITH (NOLOCK)
            INNER JOIN TEAMS AS T WITH (NOLOCK)
                ON C.TEAMID = T.ID
            INNER JOIN CHALLENGEDEFINITIONS AS CD WITH (NOLOCK)
                ON C.CHALLENGEDEFINITIONID = CD.ID
            INNER JOIN LOGMESSAGES AS L WITH (NOLOCK)
                ON T.[TEAMNAME] = L.TEAMNAME
            WHERE L.CREATEDDATE >= C.STARTDATETIME
                AND L.CREATEDDATE <= C.ENDDATETIME
                AND C.ISCOMPLETED=1
                AND CD.SCOREENABLED = 1
            GROUP BY T.TEAMNAME, T.ID, CD.NAME, CD.[ID], C.ID
        ) DTCALC
        GROUP BY DTCALC.TEAMNAME, DTCALC.TEAMID) DTSUM
    WHERE TEAMS.ID = DTSUM.TEAMID
```

### Calculate Challenge Score

```SQL
    UPDATE CHALLENGES SET SCORE =
        CASE
            WHEN (SCORECALC.STARTINGSCORE - SCORECALC.DOWNTIMEMINUTES) < 0 THEN 0
            ELSE SCORECALC.STARTINGSCORE - SCORECALC.DOWNTIMEMINUTES
        END
    FROM (
        SELECT T.TEAMNAME AS [TEAMNAME],
            T.ID AS [TEAMID],
            CD.[NAME] AS [CHALLENGENAME],
            CD.[ID] AS [CHALLENGEDEFINITIONID],
            CD.MAXPOINTS AS [STARTINGSCORE],
            C.ID AS [CHALLENGEID],
            COUNT(DISTINCT L.TIMESLICE) AS DOWNTIMEMINUTES
        FROM CHALLENGES AS C WITH (NOLOCK)
        INNER JOIN TEAMS AS T WITH (NOLOCK)
            ON C.TEAMID = T.ID
        INNER JOIN CHALLENGEDEFINITIONS AS CD WITH (NOLOCK)
            ON C.CHALLENGEDEFINITIONID = CD.ID
        INNER JOIN LOGMESSAGES AS L WITH (NOLOCK)
            ON T.[TEAMNAME] = L.TEAMNAME
        WHERE L.CREATEDDATE >= C.STARTDATETIME
            AND L.CREATEDDATE <= C.ENDDATETIME
            AND C.ISCOMPLETED=1
            AND CD.SCOREENABLED = 1
        GROUP BY T.TEAMNAME, T.ID, CD.NAME, CD.ID, C.ID, CD.MAXPOINTS) SCORECALC
    WHERE CHALLENGES.ID = SCORECALC.CHALLENGEID
```

### Calculate Team Score

```SQL
    UPDATE TEAMS SET POINTS = TEAMSCORES.TEAMSCORE
    FROM (
        SELECT C.TEAMID AS [TEAMID],
            SUM(C.SCORE) AS [TEAMSCORE]
        FROM CHALLENGES AS C
        WHERE C.ISCOMPLETED = 1
        GROUP BY C.TEAMID) AS TEAMSCORES
    WHERE TEAMS.ID = TEAMSCORES.TEAMID
```

### Testing Process
* Run CreateLeaderboardDb.sql script to provision schema in database
* Run InitLeaderboard.sql to create challenge definitions
* Run TestData.sql to seed database with valid test data
* Run Azure function.  This function should run the three queries bove in this order:
    * **Calculate Team DownTime -> Calculate Challenge Score -> Calculate Team Score**
* You can then run these three queries to reset:
``` SQL
    delete from logmessages
    delete from challenges
    delete from teams
```
* Then run the function again to trigger an update and you will see all the scores get updated.

## Helpful Queries

```SQL
--Check counts of messages per completed challenge
select t.teamname, cd.[name], count(*)
from challenges as c WITH (NOLOCK)
inner join teams as t WITH (NOLOCK) on c.teamid = t.id
inner join challengedefinitions as cd WITH (NOLOCK) on c.challengedefinitionid = cd.id
inner join logmessages as l WITH (NOLOCK) on t.[teamname] = l.teamname
where l.createddate >= c.startdatetime and l.createddate <= c.enddatetime and c.IsCompleted=1 and cd.ScoreEnabled = 1
group by t.teamname, cd.name

--Check distinct count for a challenge.
select t.teamname, cd.[name], count(distinct l.timeslice)
from challenges as c WITH (NOLOCK)
inner join teams as t WITH (NOLOCK) on c.teamid = t.id
inner join challengedefinitions as cd WITH (NOLOCK) on c.challengedefinitionid = cd.id
inner join logmessages as l WITH (NOLOCK) on t.[teamname] = l.teamname
where l.createddate >= c.startdatetime and l.createddate <= c.enddatetime and c.IsCompleted=1 and cd.ScoreEnabled = 1
group by t.teamname, cd.name
```

## Calculate Service Health
```SQL
SET NOCOUNT ON

DECLARE @TeamId nvarchar(128)
DECLARE @TeamName nvarchar(50)
DECLARE @ServiceType int
DECLARE @BadMinutes int
DECLARE @i INT =1
DECLARE @count INT
DECLARE @exist INT
DECLARE @Status nvarchar(12)

DECLARE @TTeams TABLE (
	RN INT IDENTITY(1,1),
	TeamId nvarchar(128),
	Teamname nvarchar(50))

DECLARE @TStatusCalc1 TABLE (
	RN INT IDENTITY(1,1),
	TeamId nvarchar(128),
	TeamName nvarchar(50),
	ServiceType int,
	BadMinutes int)

DECLARE @TServiceStatus TABLE (
	RN INT IDENTITY(1,1),
	TeamId nvarchar(128) NOT NULL,
	ServiceType int NOT NULL,
	Status nvarchar(12) NOT NULL)

 --Insert list of teams
 INSERT INTO @TTeams(TeamId, TeamName)
 SELECT Id, TeamName FROM Teams

 SELECT @count = COUNT(RN) FROM @TTeams
 WHILE (@i <= @count)
 BEGIN
	 SELECT @TeamId=TeamId, @TeamName=TeamName FROM @TTeams WHERE RN = @i
	 INSERT INTO @TServiceStatus(TeamId,ServiceType,Status) VALUES(@TeamId,1,'GREEN')
	 INSERT INTO @TServiceStatus(TeamId,ServiceType,Status) VALUES(@TeamId,2,'GREEN')
	 INSERT INTO @TServiceStatus(TeamId,ServiceType,Status) VALUES(@TeamId,3,'GREEN')
	 INSERT INTO @TServiceStatus(TeamId,ServiceType,Status) VALUES(@TeamId,4,'GREEN')
	 SELECT @i = @i + 1
 END

INSERT INTO @TStatusCalc1 (TeamId, TeamName, ServiceType, BadMinutes)
SELECT t.teamId, l.TeamName, l.Type, COUNT(DISTINCT l.Timeslice) AS BadMinutes
FROM LogMessages as l INNER JOIN @TTeams as t on l.TeamName = t.TeamName
WHERE l.CreatedDate >= DATEADD(minute, -5, DATEADD(mi, DATEDIFF(mi, 0, GETDATE()), 0))
	AND l.CreatedDate <= DATEADD(mi, DATEDIFF(mi, 0, GETDATE()), 0)
GROUP BY l.TeamName,t. TeamId, l.Type
ORDER BY l.TeamName, l.Type

SET @i = 1
SELECT @count = COUNT(RN) FROM @TStatusCalc1
 WHILE (@i <= @count)
 BEGIN
	 SELECT @TeamId=TeamId, @ServiceType=ServiceType, @BadMinutes=BadMinutes
	 FROM @TStatusCalc1
	 WHERE RN = @i

	 UPDATE @TServiceStatus SET [Status] = CASE @BadMinutes
	 	WHEN 2 THEN 'YELLOW'
	 	WHEN 1 THEN 'YELLOW'
	 	ELSE 'RED'
	 	END
	 WHERE TeamId=@TeamId AND ServiceType=@ServiceType

	 SELECT @i = @i + 1
 END

SET @i = 1
SELECT @count = COUNT(RN) FROM @TServiceStatus
 WHILE (@i <= @count)
 BEGIN
	 SELECT @TeamId=TeamId, @ServiceType=ServiceType, @Status=Status
	 FROM @TServiceStatus
	 WHERE RN = @i

	 SELECT @exist=COUNT(*) FROM ServiceStatus WHERE TeamId=@TeamId AND ServiceType=@ServiceType

	 IF @exist > 0
		 BEGIN
		 UPDATE ServiceStatus SET [Status] = @Status
		 WHERE TeamId=@TeamId AND ServiceType=@ServiceType
		 END
	 ELSE
	 	BEGIN
	 	INSERT INTO ServiceStatus  VALUES (@TeamId, @ServiceType, @Status)
	 	END
	 SELECT @i = @i + 1
 END


SELECT * FROM @TTeams
SELECT * FROM @TStatusCalc1
SELECT * FROM @TServiceStatus
SELECT * FROM ServiceStatus

```