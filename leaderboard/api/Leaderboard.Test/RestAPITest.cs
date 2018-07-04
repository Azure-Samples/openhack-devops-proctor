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

namespace Leaderboard.Test
{
    [TestClass]
    public class RestAPITest
    {
        //private IContainer InjectMocks(object[] mocks)
        //{
        //    var builder = new ContainerBuilder();
        //    foreach(var mock in mocks) {
        //        builder.RegisterInstance(mock).AsImplementedInterfaces();
        //    }
        //    return builder.Build();
        //}

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
            messagingServiceMock.Setup(c => c.SendMessageAsync(inputJson)).Returns(Task.FromResult(""));


            builder.RegisterInstance(documentServiceMock.Object).As<IDocumentService>();
            builder.RegisterInstance(messagingServiceMock.Object).As<IMessagingService>();
            RestAPI.Container = builder.Build();
            
            // Create a mock of HttpRequest
            Mock<HttpRequest> requestMock = new Mock<HttpRequest>();
            // Create a test data 
            requestMock.Setup(c => c.Body).Returns(new MemoryStream(System.Text.Encoding.ASCII.GetBytes(inputJson)));
            // Create a mock of TraceWriter
            Mock<ILogger> writerMock = new Mock<ILogger>();
           // writerMock.Setup(c => c.LogInformation(It.IsAny<string>(), null));

            var response = RestAPI.ReportStatus(requestMock.Object, writerMock.Object);

            messagingServiceMock.Verify(c => c.SendMessageAsync(inputJson));

        }
    }
}
