using Microsoft.Azure.Documents.Client;
using Models;
using System;
using System.Collections.Generic;
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
            var docUri = UriFactory.CreateDocumentUri(databaseId, typeof(T).Name, id);
            var doc = await client.ReadDocumentAsync<T>(docUri);
            return doc.Document;

            //    var uri = UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name);
            //    var query = client.CreateDocumentQuery<T>(
            //        uri,
            //        new FeedOptions { EnableCrossPartitionQuery = true })
            //        .Where(f => f.Id == id)
            //        .AsEnumerable<T>();
            //    List<T> list = new List<T>();
            //   foreach (var i in query)
            //    {
            //        list.Add(i);
            //    }
            //    //            var result = query.FirstOrDefault<T>();
            //    var list2 = list;
            //    return list.FirstOrDefault<T>();
            //
        }

        public async Task<IList<T>> GetDocumentsAsync<T>(string id) where T :IDocument
        {
            var query = client.CreateDocumentQuery<T>(
                UriFactory.CreateDocumentCollectionUri(databaseId, typeof(T).Name),
                new FeedOptions { MaxItemCount = -1, EnableCrossPartitionQuery = true })
                .Where(f => f.Id == id);           
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
