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


## Helpful Queries

```SQL
select t.teamname, cd.[name], count(*)
from challenges as c WITH (NOLOCK)
inner join teams as t WITH (NOLOCK) on c.teamid = t.id
inner join challengedefinitions as cd WITH (NOLOCK) on c.challengedefinitionid = cd.id
inner join logmessages as l WITH (NOLOCK) on t.[teamname] = l.teamname
where l.createddate >= c.startdatetime and l.createddate <= c.enddatetime and c.IsCompleted=1 and cd.ScoreEnabled = 1
group by t.teamname, cd.name

select t.teamname, cd.[name], count(distinct l.timeslice)
from challenges as c WITH (NOLOCK)
inner join teams as t WITH (NOLOCK) on c.teamid = t.id
inner join challengedefinitions as cd WITH (NOLOCK) on c.challengedefinitionid = cd.id
inner join logmessages as l WITH (NOLOCK) on t.[teamname] = l.teamname
where l.createddate >= c.startdatetime and l.createddate <= c.enddatetime and c.IsCompleted=1 and cd.ScoreEnabled = 1
group by t.teamname, cd.name
```
