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

        
        public async Task<Service> GetServiceAsync(string serviceId)
        {
            var query = client.CreateDocumentQuery<Service>(
                UriFactory.CreateDocumentCollectionUri(databaseId, "Service"))
                .Where(f => f.Id == serviceId)
                .AsEnumerable<Service>();  
            return query.FirstOrDefault<Service>();
        }

        // History Section

        // Team Section

    }
}
