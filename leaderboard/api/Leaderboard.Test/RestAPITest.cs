using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Autofac;
using Moq;
using Services;
using SharedLibrary;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs.Host;
using Models;
using Newtonsoft.Json;
using System.IO;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc;

namespace Leaderboard.Test
{
    [TestClass]
    public class RestAPITest
    {

        [TestMethod]
        public async Task TestReportStatusNormalCaseAsync()
        {

            var builder = new ContainerBuilder();

            var inputServiceId = "Team01POI";
            var input = new DowntimeReport
            {
                TeamId = "Team01",
                ServiceId = inputServiceId,
                Date = new DateTime(2018, 10, 10, 10, 10, 0),
                Status = false,
                StatusCode = 404
            };
            var inputJson = JsonConvert.SerializeObject(input);
            
            // Inject a mock of IDocumentService 
            Mock<IDocumentService> documentServiceMock = new Mock<IDocumentService>();
            documentServiceMock.Setup(c => c.GetServiceAsync<Service>(inputServiceId)).Returns(Task.FromResult(new Service
            {
                CurrentStatus = false
            }));
            documentServiceMock.Setup(c => c.CreateDocumentAsync<History>(input.GetHistory())).Returns(Task.FromResult("")); // do nothing

            Mock<IMessagingService> messagingServiceMock = new Mock<IMessagingService>();
            messagingServiceMock.Setup(c => c.SendMessageAsync(inputJson)).Returns(Task.FromResult("")).Verifiable();


            builder.RegisterInstance(documentServiceMock.Object).As<IDocumentService>();
            builder.RegisterInstance(messagingServiceMock.Object).As<IMessagingService>();
            RestAPI.Container = builder.Build();
            
            // Create a mock of HttpRequest
            Mock<HttpRequest> requestMock = new Mock<HttpRequest>();
            // Create a test data 
            requestMock.Setup(c => c.Body).Returns(new MemoryStream(System.Text.Encoding.ASCII.GetBytes(inputJson)));
            // Create a mock of TraceWriter
            Mock<ILogger> writerMock = new Mock<ILogger>();
            var response = await RestAPI.ReportStatus(requestMock.Object, writerMock.Object);

            messagingServiceMock.Verify();

        }

        [TestMethod]
        public async Task TestReportStatusFailureCaseAsync()
        {
            var builder = new ContainerBuilder();

            var inputServiceId = "Team01POI";
            var input = new DowntimeReport
            {
                TeamId = "Team01",
                ServiceId = inputServiceId,
                Date = new DateTime(2018, 10, 10, 10, 15, 0),
                Status = true,
                StatusCode = 200
            };
            var inputJson = JsonConvert.SerializeObject(input);

            // Inject a mock of IDocumentService 
            Mock<IDocumentService> documentServiceMock = new Mock<IDocumentService>();
            documentServiceMock.Setup(c => c.GetServiceAsync<Service>(inputServiceId)).Returns(Task.FromResult(new Service
            {
                CurrentStatus = false
            }));

            Mock<Team> teamMock = new Mock<Team>();
            teamMock.Setup(c => c.UpdateService(It.IsAny<Service>())); 

            documentServiceMock.Setup(c => c.GetServiceAsync<Team>("Team01")).Returns(Task.FromResult(teamMock.Object));
            documentServiceMock.Setup(c => c.UpdateDocumentAsync<Team>(It.IsAny<Team>())).Returns(Task.FromResult(""));    

            documentServiceMock.Setup(c => c.CreateDocumentAsync<History>(input.GetHistory())).Returns(Task.FromResult("")); // do nothing

            Mock<IMessagingService> messagingServiceMock = new Mock<IMessagingService>();
            messagingServiceMock.Setup(c => c.SendMessageAsync(It.IsAny<string>())).Throws<AssertInconclusiveException>();


            builder.RegisterInstance(documentServiceMock.Object).As<IDocumentService>();
            builder.RegisterInstance(messagingServiceMock.Object).As<IMessagingService>();
            RestAPI.Container = builder.Build();

            // Create a mock of HttpRequest
            Mock<HttpRequest> requestMock = new Mock<HttpRequest>();
            // Create a test data 
            requestMock.Setup(c => c.Body).Returns(new MemoryStream(System.Text.Encoding.ASCII.GetBytes(inputJson)));
            // Create a mock of TraceWriter
            Mock<ILogger> writerMock = new Mock<ILogger>();

            var response = await RestAPI.ReportStatus(requestMock.Object, writerMock.Object);
            Assert.AreEqual(response.GetType(), typeof(OkObjectResult));
        }

        [TestMethod]
        public async Task TestGetTeamStatusNormalCaseAsync()
        {
            var builder = new ContainerBuilder();
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IDocumentService> documentServiceMock = new Mock<IDocumentService>();

            Openhack openhack = new Openhack
            {
                StartTime = new DateTime(2018, 10, 10, 10, 0, 0),
                EndTime = new DateTime(2018, 10, 12, 12, 0, 0)
            };
            Team[] teams = new Team[]
            {
                new Team()
                {
                    id = "Team01",
                    Name = "Team01"
                },
                new Team()
                {
                    id = "Team02",
                    Name = "Team02"
                }
            };
            var team01DowntimeSummary = new DowntimeSummary[] {
                new DowntimeSummary()
                {
                    TeamId = "Team01",
                    Downtime = 60
                }
            };
            var team02DowntimeSummary = new DowntimeSummary[] {
                new DowntimeSummary()
                {
                    TeamId = "Team02",
                    Downtime = 90
                }
            };
            documentServiceMock.Setup(c => c.GetDocumentAsync<Openhack>()).Returns(Task.FromResult<Openhack>(openhack));


        }
    }
}
