using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

namespace Batch
{
    public static class SqlJobFlow
    {
        private static SqlConnection connection;

        static SqlJobFlow()
        {
            try
            {
                var connectionString = Environment.GetEnvironmentVariable("SqlConnectionString");
                connection = new SqlConnection(connectionString);
                connection.Open();
            } catch (SqlException e)
            {
                Console.Error.WriteLine("Error! while establishing connection with SQL database. Please check the sqlConnectionString or the firewall setting on your SQL Server.");
                throw e;
            }
        }

        [FunctionName("SqlJobFlow")]
        public static void Run([TimerTrigger("0 */1 * * * *")]TimerInfo myTimer, ILogger log)
        {

            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
            var sw = new Stopwatch();
            sw.Start();
            int rowAffected = ExecuteQuery(GetCalculateTeamDowntimeSQL(), connection);
            sw.Stop();
            log.LogInformation($"CalculateTeamDownTime: {rowAffected} rows in {sw.ElapsedMilliseconds.ToString()} ms.");
            sw.Restart();
            rowAffected = ExecuteQuery(GetCalculateChallangeScoreSQL(), connection);
            sw.Stop();
            log.LogInformation($"CalculateChallangeScoreSQL: {rowAffected} rows in {sw.ElapsedMilliseconds.ToString()} ms.");
            sw.Restart();
            rowAffected = ExecuteQuery(GetCalculateTeamScoreSQL(), connection);
            sw.Stop();
            log.LogInformation($"CalculateTeamScoreSQL: {rowAffected} rows in {sw.ElapsedMilliseconds.ToString()} ms.");

        }

        private static int ExecuteQuery(string query, SqlConnection connection)
        {
            var command =  new SqlCommand(query, connection);
            return command.ExecuteNonQuery();
            
        }

        private static string GetCalculateTeamDowntimeSQL()
        {
            return @"UPDATE TEAMS SET DOWNTIMEMINUTES = DTSUM.DTM
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
            ";
        }

        private static string GetCalculateChallangeScoreSQL()
        {
            return @"UPDATE CHALLENGES SET SCORE =
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
            ";
        }

        private static string GetCalculateTeamScoreSQL()
        {
            return @"UPDATE TEAMS SET POINTS = TEAMSCORES.TEAMSCORE
    FROM (
        SELECT C.TEAMID AS [TEAMID],
            SUM(C.SCORE) AS [TEAMSCORE]
        FROM CHALLENGES AS C
        WHERE C.ISCOMPLETED = 1
        GROUP BY C.TEAMID) AS TEAMSCORES
    WHERE TEAMS.ID = TEAMSCORES.TEAMID
            ";
        }


    }


}
