using Microsoft.Azure.Documents.Client;
using Models;
using Services;
using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.Threading.Tasks;

namespace Services
{

    public interface ITeamService
    {

    }
    /// <summary>
    /// Service for implement Service logic for the backend. 
    /// </summary>
    public class TeamService :ITeamService
    {
        private IDocumentService service;
        public TeamService(IDocumentService service)
        {
            this.service = service;
        }

        public async Task<TimeSpan> GetDowntimeAsync(string teamId)
        {
            var statusHistories = await this.service.GetDocumentsAsync<StatusHistory>(
               (query) =>
               {
                   return query.Where(f => f.TeamId == teamId);
               }
                );
            return StatusHistory.GetServiceDowntimeTotal(statusHistories);

        }

        public async Task<int> QueryDowntimeAsync(string teamId)
        {
            var client = service.GetClient();
           
            return client.CreateDocumentQuery<DowntimeRecord>(
                UriFactory.CreateDocumentCollectionUri(service.GetDatabaseId(), typeof(DowntimeRecord).Name))
                .Where<DowntimeRecord>(r => r.TeamId == teamId)
                .Sum<DowntimeRecord>(r => r.Count);
        }

    }
}
