using Microsoft.Azure.Documents.Client;
using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public class DocumentService
    {
        private static DocumentClient client = new DocumentClient(
    new Uri(
        System.Environment.GetEnvironmentVariable("CosmosDBEndpointUri")),
        System.Environment.GetEnvironmentVariable("CosmosDBPrimaryKey"));

        private static string databaseId = Environment.GetEnvironmentVariable("CosmosDBDatabaseId");

        // Generics Section

        public async Task CreateDocumentAsync<T>(T document)
        {
            await client.CreateDocumentAsync(UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name), document);
        }

        public async Task UpdateDocumentAsync<T>(T document)
        {
            await client.UpsertDocumentAsync(UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name), document);
        }

        
        public async Task<T> GetServiceAsync<T>(string id) where T :IDocument
        {
            var query = client.CreateDocumentQuery<T>(
                UriFactory.CreateDocumentCollectionUri(databaseId, nameof(T)))
                .Where(f => f.Id == id)
                .AsEnumerable<T>();  
            return query.FirstOrDefault<T>();
        }

        // History Section

        // Team Section

    }
}
