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

    }


    public class DocumentService : IDocumentService
    {
        private static DocumentClient client = null;

        private static string databaseId = null;

        static DocumentService()
        {
            var cosmosDBEndpointUri = System.Environment.GetEnvironmentVariable("CosmosDBEndpointUri");
            var cosmosDBPrimaryKey = System.Environment.GetEnvironmentVariable("CosmosDBPrimaryKey");
            databaseId = Environment.GetEnvironmentVariable("CosmosDBDatabaseId");

            // In case of E2E testing, you can use appsettings.json for the testing. 
            if (string.IsNullOrEmpty(cosmosDBEndpointUri) || string.IsNullOrEmpty(cosmosDBPrimaryKey) || string.IsNullOrEmpty(databaseId)) {
                var builder = new ConfigurationBuilder()
                    .SetBasePath(Directory.GetCurrentDirectory())
                    .AddJsonFile("appsettings.json");
                var configration = builder.Build();
                cosmosDBEndpointUri = configration["CosmosDBEndpointUri"];
                cosmosDBPrimaryKey = configration["CosmosDBPrimaryKey"];
                databaseId = configration["CosmosDBDatabaseId"];
            }
            client = new DocumentClient(new Uri(cosmosDBEndpointUri), cosmosDBPrimaryKey);

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

        // History Section

        // Team Section

    }
}
