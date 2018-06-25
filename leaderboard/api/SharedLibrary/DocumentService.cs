using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Microsoft.Extensions.Configuration;
using Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public interface IDocumentService
    {
        Task CreateDocumentAsync<T>(T document);
        Task UpdateDocumentAsync<T>(T document);

        Task<T> GetDocumentAsync<T>();
        Task<IList<T>> GetAllDocumentsAsync<T>();
        Task<T> GetServiceAsync<T>(string id) where T : IDocument;
        Task<IList<T>> GetDocumentsAsync<T>(string id) where T : IDocument;
        Task<IList<T>> GetDocumentsAsync<T>(Func<IOrderedQueryable<T>, IQueryable<T>> queryFunction);
        /// <summary>
        /// GetClient Retruns DocumentDB Client
        /// The configuration is set by Environment Variables or appsettings.json
        /// If there is no configuration on the Environment Variables, it search appsettings.json
        /// Currently, we support CosmosDBEndpointUri, CosmosDBPrimaryKey, CosmosDBDatabaseId
        /// </summary>
        /// <returns></returns>
        DocumentClient GetClient();
        /// <summary>
        /// RemoveCollectionIfExists remove Collection if exists. 
        /// </summary>
        /// <typeparam name="T">Model class for the target collection</typeparam>
        /// <returns></returns>
        Task RemoveCollectionIfExists<T>();
        /// <summary>
        /// CreateCollectionIfExists create a collection if exists. If you want to create collection with PratitionKey, 
        /// Please add parameter of partitionKey and offerThroughput. Otherwise, you can execute this method without parameters.
        /// </summary>
        /// <typeparam name="T">Model class for the target collection</typeparam>
        /// <param name="partitionKey">Optional: PartitionKey</param>
        /// <param name="offerThroughput">Optional: offerThroughput</param>
        /// <returns></returns>
        Task CreateCollectionIfNotExists<T>(string partitionKey = "", int offerThroughput = 0);


        Task<IList<T>> QueryBySQLAsync<T>(string sql, string collectionName);
        }


    public class DocumentService : IDocumentService
    {
        private static DocumentClient client = null;

        private static string databaseId = null;

        private const string CONFIG_FILE = "appsettings.json";

        static DocumentService()
        {

            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory());


            if (File.Exists(CONFIG_FILE))
            {
                builder.AddJsonFile(CONFIG_FILE);
            }

            builder.AddEnvironmentVariables();

            var configration = builder.Build();


            var cosmosDBEndpointUri = configration["CosmosDBEndpointUri"];
            var cosmosDBPrimaryKey = configration["CosmosDBPrimaryKey"];
            databaseId = configration["CosmosDBDatabaseId"];


           
            client = new DocumentClient(new Uri(cosmosDBEndpointUri), cosmosDBPrimaryKey);

        }

        /// <summary>
        /// GetClient Retruns DocumentDB Client
        /// The configuration is set by Environment Variables or appsettings.json
        /// Environment Variables has higher priority.
        /// Currently, we support CosmosDBEndpointUri, CosmosDBPrimaryKey, CosmosDBDatabaseId
        /// </summary>
        /// <returns></returns>
        public DocumentClient GetClient()
        {
            return client;
        }


        // Generics Section

        public async Task CreateDocumentAsync<T>(T document)
        {
            await client.CreateDocumentAsync(UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name), document);
        }

        public async Task UpdateDocumentAsync<T>(T document)
        {
            await client.UpsertDocumentAsync(UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name), document);
        }

        public async Task<IList<T>> GetAllDocumentsAsync<T>()
        {
            var query = client.CreateDocumentQuery<T>(
                UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name))
                .AsEnumerable<T>();
            return query.ToList<T>();
        }

        public async Task<T> GetDocumentAsync<T>()
        {
            var query = client.CreateDocumentQuery<T>(
            UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name))
            .AsEnumerable<T>();
            return query.FirstOrDefault<T>();
        }


        public async Task<T> GetServiceAsync<T>(string id) where T : IDocument
        {
            //var docUri = UriFactory.CreateDocumentUri(databaseId, typeof(T).Name, id);
            //var doc = await client.ReadDocumentAsync<T>(docUri, new RequestOptions { PartitionKey = new PartitionKey("id") });
            //return doc.Document;

            var uri = UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name);
            var query = client.CreateDocumentQuery<T>(
                uri,
                new FeedOptions { EnableCrossPartitionQuery = true })
                .Where(f => f.id == id)
                .AsEnumerable<T>();
            return query.FirstOrDefault<T>();

        }

        public async Task<IList<T>> GetDocumentsAsync<T>(string id) where T :IDocument
        {
            var query = client.CreateDocumentQuery<T>(
                UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name),
                new FeedOptions { MaxItemCount = -1, EnableCrossPartitionQuery = true })
                .Where(f => f.id == id);           
            return query.ToList<T>();
        }

        public async Task<IList<T>> GetDocumentsAsync<T>(Func<IOrderedQueryable<T>, IQueryable<T>> queryFunction)
        {
            var queryBase = client.CreateDocumentQuery<T>(
                UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name));
            var query = queryFunction(queryBase);
            return query.ToList<T>();
        }

        public async Task<IList<T>> QueryBySQLAsync<T>(string sql, string collectionName)
        {
            var query = client.CreateDocumentQuery<T>(
                UriFactory.CreateDocumentCollectionUri(databaseId, collectionName));
            return query.ToList<T>();
        }

        public async Task RemoveCollectionIfExists<T>() {
            try
            {
                await client.DeleteDocumentCollectionAsync(
                    UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name));
            } catch (DocumentClientException de)
            {
                if (de.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    // There is no document. Just ignore since this method is IfExists.
                    // https://docs.microsoft.com/en-us/dotnet/api/microsoft.azure.documents.client.documentclient.deletedocumentcollectionasync?view=azure-dotnet
                }
                else
                {
                    throw de;
                }
            }
        }

        public async Task CreateCollectionIfNotExists<T>(string partitionKey = "", int offerThroughput = 0)
        {
            var downtimeReportCollection = new DocumentCollection();
            downtimeReportCollection.Id = typeof(T).Name;
            if (!string.IsNullOrEmpty(partitionKey))
            {
                // Collection with PratitionKey
                downtimeReportCollection.PartitionKey.Paths.Add(partitionKey);
                await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(databaseId),
                        downtimeReportCollection, new RequestOptions { OfferThroughput = offerThroughput });
            }
            else
            {
                // Collection without PartitionKey
                await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(databaseId),
                    downtimeReportCollection);
            }
        }              
    }
}
