using System;
using Models;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Newtonsoft.Json;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.IO;
using Microsoft.Azure.Documents.Linq;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;

namespace CLI
{
    class Program
    {
        private static string EndpointUri;
        private static string PrimaryKey;
        private static string DatabaseId;
        private static int NumberOfChallenges;
        private static DocumentClient client;

        private static DateTime StartTime;
        private static DateTime EndTime;

        static Program() {

            // Read config from Environment Variables 
            EndpointUri = Environment.GetEnvironmentVariable("COSMOSDB_ENDPOINT_URL");
            PrimaryKey = Environment.GetEnvironmentVariable("COSMOSDB_PRIMARY_KEY");
            DatabaseId = Environment.GetEnvironmentVariable("COSMOSDB_DATABASE_ID");
            NumberOfChallenges = int.Parse(Environment.GetEnvironmentVariable("NUMBER_OF_CHALLENGES"));

            StartTime = DateTime.Parse(Environment.GetEnvironmentVariable("OPENHACK_START_TIME"));
            EndTime = DateTime.Parse(Environment.GetEnvironmentVariable("OPENHACK_END_TIME"));

        }

        private async Task InitializeAsync()
        {
            var sw = new System.Diagnostics.Stopwatch();
            sw.Start();

            try
            {
                await client.DeleteDatabaseAsync(UriFactory.CreateDatabaseUri(DatabaseId));
                // If database does not exist, it throws DocumentClientException.
            }
            catch (DocumentClientException e)
            {
                if (e.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    // This is expected. Do nothing.
                }
                else
                {
                    throw new InvalidOperationException("Delete document error: ", e);
                }

            }
            sw.Stop();
            Console.WriteLine($"---- Delete Database {sw.ElapsedMilliseconds} msec");
            sw.Restart();

            Console.WriteLine("Database: Leaderboard is created.");
            await client.CreateDatabaseIfNotExistsAsync(new Database { Id = DatabaseId });
            sw.Stop();
            Console.WriteLine($"---- Create Database {sw.ElapsedMilliseconds} msec");

            // Team Collection creation 

            sw.Restart();
            var teamCollection = new DocumentCollection();
            teamCollection.Id = typeof(Team).Name;
            teamCollection.PartitionKey.Paths.Add("/id");
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
                teamCollection, new RequestOptions { OfferThroughput = 2500 });
            sw.Stop();
            Console.WriteLine($"---- Create Collection Team {sw.ElapsedMilliseconds} msec");

            // Service Collection creation

            sw.Restart();
            var serviceCollection = new DocumentCollection();
            serviceCollection.Id = typeof(Service).Name;
            serviceCollection.PartitionKey.Paths.Add("/id");
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
                serviceCollection , new RequestOptions { OfferThroughput = 2500 } );
            sw.Stop();
            Console.WriteLine($"---- Create Collection Service {sw.ElapsedMilliseconds} msec");
            sw.Restart();

            // History Collection creation
            var historyCollection = new DocumentCollection();
            historyCollection.Id = typeof(History).Name;
            historyCollection.PartitionKey.Paths.Add("/ServiceId");
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
    historyCollection, new RequestOptions { OfferThroughput = 2500 });
            sw.Stop();
            Console.WriteLine($"---- Create Collection History {sw.ElapsedMilliseconds} msec");

            sw.Restart();
            // Openhack Collection creation
            var openhackCollection = new DocumentCollection();
            openhackCollection.Id = typeof(Openhack).Name;
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
    openhackCollection);
            sw.Stop();
            Console.WriteLine($"---- Create Collection Openhack {sw.ElapsedMilliseconds} msec");

            sw.Restart();
            // StatusHistory Collection creation
            var statusHistoryCollection = new DocumentCollection();
            statusHistoryCollection.Id = typeof(StatusHistory).Name;
            statusHistoryCollection.PartitionKey.Paths.Add("/TeamId");
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
    statusHistoryCollection, new RequestOptions { OfferThroughput = 2500 });
            sw.Stop();
            Console.WriteLine($"---- Create Collection StatusHistory {sw.ElapsedMilliseconds} msec");

            sw.Restart();
            // DowntimeRecord Collection creation
            var downtimeReportCollection = new DocumentCollection();
            downtimeReportCollection.Id = typeof(DowntimeRecord).Name;
            downtimeReportCollection.PartitionKey.Paths.Add("/TeamId");
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
                downtimeReportCollection, new RequestOptions { OfferThroughput = 2500 });
            sw.Stop();
            Console.WriteLine($"---- Create Collection downtimeReport {sw.ElapsedMilliseconds} msec");

            sw.Restart();
            // DowntimeSummary
            var downtimeSummaryCollection = new DocumentCollection();
            downtimeSummaryCollection.Id = typeof(DowntimeSummary).Name;
            await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(DatabaseId),
    downtimeSummaryCollection);
            sw.Stop();
            Console.WriteLine($"---- Create Collection DowntimeSummary {sw.ElapsedMilliseconds} msec");
        }

        /// <summary>
        /// Create a seed data for Team, Services, History
        /// </summary>
        /// <returns></returns>
        private async Task CreateDatabaseSeedsAsync()
        {

            var sw = new System.Diagnostics.Stopwatch();
            sw.Start();

            // Create a Openhack document
            await createOpenHackAsync();

            var serviceConfigJson = System.IO.File.ReadAllText("team_service_config.json");
            var serviceConfig = JObject.Parse(serviceConfigJson);
            var teams = new Team[] { };
            var tasks = new List<Task>();
            var teamNum = 0;
            foreach (var element in serviceConfig)
            {
                teamNum++;
                var endpoint = element.Value.Value<JToken>("endpoint");
                var team = new Team
                {
                    id = element.Key,
                    Name = element.Key,
                    Challenges = GetInitialChallenges(),
                    Services = new Service[] {
                        new Service {
                            id = $"{element.Key}user"
                        },
                        new Service {
                            id = $"{element.Key}trips"
                        },
                        new Service {
                            id = $"{element.Key}poi"
                        }
                    },
                    Score = 0                
                };
                var services = new Service[]
                {
                    new Service
                    {
                        id = $"{team.id}user",
                        Name = $"{team.Name}user",
                        Uri = $"{endpoint}/user"
                    },
                    new Service
                    {
                        id = $"{team.id}trips",
                        Name = $"{team.Name}trips",
                        Uri = $"{endpoint}/trips"
                    },
                    new Service
                    {
                        id = $"{team.id}poi",
                        Name = $"{team.Name}poi",
                        Uri = $"{endpoint}/poi"
                    }
                };
                var histories = new History[] { };
                tasks.Add(createTeamServicesAndHistories(team, services, histories));
            }
            await Task.WhenAll(tasks);
            sw.Stop();
            Console.WriteLine($"---- Initial Documents({teamNum}) setup finished. {sw.ElapsedMilliseconds} msec");
        }


        private Challenge[] inititalChallenges;

        private Challenge[] GetInitialChallenges()
        {
            if (inititalChallenges != null) return inititalChallenges;

            this.inititalChallenges = new Challenge[NumberOfChallenges];

            for (int i = 0; i < NumberOfChallenges; i++)
            {
                var newId = String.Format("{0:D2}", i);
                var challenge = new Challenge
                {
                    id = newId,
                    Status = ChallengeStatus.NotStarted.ToString()
                };
                this.inititalChallenges[i] = challenge;
            }

            return inititalChallenges;
        }
        private async Task QueryAsync()
        {
            var sw = new System.Diagnostics.Stopwatch();
            sw.Start();
            Console.WriteLine("Finish Seeding!");
            // finially Query The database 
            await dumpAllData<Team>();
            sw.Stop();
            Console.WriteLine($"---- Query Team {sw.ElapsedMilliseconds} msec");
            sw.Restart();
            await dumpAllData<Service>();
            sw.Stop();
            Console.WriteLine($"---- Query Service {sw.ElapsedMilliseconds} msec");
            sw.Restart();
            await dumpAllData<History>();
            sw.Stop();
            Console.WriteLine($"---- Query History {sw.ElapsedMilliseconds} msec");

            //var oneTeam = await FirstOrDefaultAsync("10");
            var oneTeam = await QuerySample("10");
            sw.Stop();
            Console.WriteLine($"---- Query Team by Id {sw.ElapsedMilliseconds} msec");
            sw.Restart();
            oneTeam = await QuerySample("10");
            sw.Stop();
            Console.WriteLine($"---- Query Team twice by Id {sw.ElapsedMilliseconds} msec");
            sw.Restart();
            oneTeam = await QuerySample("11");
            sw.Stop();
            Console.WriteLine($"---- Query Team three times by Id {sw.ElapsedMilliseconds} msec");
        }

        private async Task<Team> QuerySample(string key)
        {
            var sw = new System.Diagnostics.Stopwatch();
            sw.Start();
            var query = client.CreateDocumentQuery<Team>(
                UriFactory.CreateDocumentCollectionUri(DatabaseId, "Team"),
                $"SELECT * FROM c WHERE c.id = '{key}'",
                new FeedOptions
                {
                    PopulateQueryMetrics = true,
                }).AsDocumentQuery();
            sw.Stop();
            Console.WriteLine($"---- CreqteQuery {sw.ElapsedMilliseconds} msec");
            sw.Restart();
            var result = await query.ExecuteNextAsync<Team>();
            sw.Stop();
            Console.WriteLine($"---- ExecuteNextAsync {sw.ElapsedMilliseconds} msec");
            var metrics = result.QueryMetrics;
            Console.WriteLine("Team Query");
            foreach(KeyValuePair<string, QueryMetrics> pair in metrics)
            {
                Console.WriteLine(JsonConvert.SerializeObject(pair, Formatting.Indented));

            }
            return result.FirstOrDefault();
                
        }

        private async Task<Team> FirstOrDefaultAsync(string key) 
        {
            var query = client.CreateDocumentQuery<Team>(
                UriFactory.CreateDocumentCollectionUri(DatabaseId, "Team"))
                .Where(f => f.id == key)
                .AsEnumerable();
            return query.FirstOrDefault<Team>();
        }

        private async Task dumpAllData<T>()
        {
            var query = client.CreateDocumentQuery<T>(
    UriFactory.CreateDocumentCollectionUri(DatabaseId, typeof(T).Name));

            foreach (var document in query)
            {
                Console.WriteLine(JsonConvert.SerializeObject(document, Formatting.Indented));
            }
        }

        private async Task createTeamServicesAndHistories(Team team, Service[] services, History[] histories)
        {
            var tasks = new Task[] { };
            foreach(var service in services)
            {
                tasks.Append<Task>(CreateDocumentAsync<Service>(DatabaseId, service));
            }
            foreach(var history in histories)
            {
                tasks.Append<Task>(CreateDocumentAsync<History>(DatabaseId, history));
            }
            await Task.WhenAll(tasks);
            await CreateDocumentAsync<Team>(DatabaseId, team);
        }

        private async Task createOpenHackAsync()
        {
            var openhack = new Openhack
            {
                StartTime = StartTime,
                EndTime = EndTime
            };

            await client.CreateDocumentAsync(
                UriFactory.CreateDocumentCollectionUri(DatabaseId, "Openhack"), 
                openhack);
      }

        private async Task CreateDocumentAsync<T>(string databaseName, T document) 
        {
            await client.CreateDocumentAsync(UriFactory.CreateDocumentCollectionUri(databaseName, typeof(T).Name), document);
        }
    
        private async Task CreateTeamDocumentIfNotExists<T>(string databaseName, T document) where T: IDocument
        {
            try
            {
                var uri = UriFactory.CreateDocumentUri(databaseName, typeof(T).Name, document.id);
                await client.ReadDocumentAsync(uri);
            } catch (DocumentClientException de)
            {
                if (de.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    await client.CreateDocumentAsync(UriFactory.CreateDocumentCollectionUri(databaseName, typeof(T).Name), document);
                }
                else
                {
                    throw new InvalidOperationException("Create document error: ", de);
                }
            }
        }



        static void Main(string[] args)
        {
            try
            {
                var sw = new System.Diagnostics.Stopwatch();
                sw.Start();
                using (client = new DocumentClient(new Uri(EndpointUri), PrimaryKey))
                {
                    sw.Stop();
                    Console.WriteLine($"---- Client Creation {sw.ElapsedMilliseconds} msec");
                    var p = new Program();
                    p.InitializeAsync().Wait();
                    p.CreateDatabaseSeedsAsync().Wait();
                    // If you want to seed sample data, enable this.
                    // p.SampleDataSeeds().Wait();
                    p.QueryAsync().Wait();
                }
            } catch (DocumentClientException de)
            {
                Console.WriteLine("{0} error occured: {1}, Message: {2}", de.StatusCode, de.Message, de?.GetBaseException()?.Message);
            } catch (Exception e)
            {
                var baseException = e.GetBaseException();
                Console.WriteLine($"Error: {e.Message}, Message: {baseException.Message}");
            }
            finally
            {
                Console.WriteLine("All Data seeding has been successful!");
                Console.WriteLine($"Please have a look {EndpointUri}");
                // Console.ReadKey();
            }
        }
    }
}
