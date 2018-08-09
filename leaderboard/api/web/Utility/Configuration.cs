using Microsoft.Extensions.Configuration;

namespace Sentinel.Utility
{
    public static class SentinelConfiguration
    {
        public static string GetConnectionString(IConfiguration configuration)
        {
            var SQL_USER = configuration.GetSection("SQL_USER").Value;
            var SQL_PASSWORD = configuration.GetSection("SQL_PASSWORD").Value;
            var SQL_SERVER = configuration.GetSection("SQL_SERVER").Value;
            var SQL_DBNAME = configuration.GetSection("SQL_DBNAME").Value;

            var connectionString = configuration["ConnectionStrings:Leaderboard"];

            connectionString = connectionString.Replace("[SQL_USER]", SQL_USER);
            connectionString = connectionString.Replace("[SQL_PASSWORD]", SQL_PASSWORD);
            connectionString = connectionString.Replace("[SQL_SERVER]", SQL_SERVER);
            connectionString = connectionString.Replace("[SQL_DBNAME]", SQL_DBNAME);

            return connectionString;
        }

        public static string GetSecretKey(IConfiguration configuration)
        {
            var SECRET_KEY = configuration.GetValue(typeof(string),"SECRET_KEY","changeMe2SecureValue");

            return SECRET_KEY.ToString();

        }
        public static string GetUri(IConfiguration configuration)
        {
            var WEB_PORT = configuration.GetValue(typeof(string),"WEB_PORT","8080");
            var WEB_SERVER_BASE_URI = configuration.GetValue(typeof(string), "WEB_SERVER_BASE_URI", "http://localhost");

            return WEB_SERVER_BASE_URI + ":" + WEB_PORT;
        }
    }
}