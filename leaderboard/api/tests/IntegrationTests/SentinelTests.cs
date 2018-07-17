using System;
using Xunit;
using Sentinel.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc.Testing;
using Newtonsoft.Json;

namespace IntegrationTests
{
    public class SentinelIntegrationTests: IClassFixture<CustomWebApplicationFactory<Sentinel.Startup>>
    {
        private readonly CustomWebApplicationFactory<Sentinel.Startup> _factory;

        public SentinelIntegrationTests(CustomWebApplicationFactory<Sentinel.Startup> factory)
        {
            _factory = factory;
        }

        [Theory]
        [InlineData("/api/sentinel/team01")]
        public async Task GetLogMessagesAndReturnSuccess(string url)
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync(url);

            ILoggerFactory loggerFactory = new LoggerFactory()
                .AddDebug()
                .AddConsole();

            ILogger logger = loggerFactory.CreateLogger("Debug");
            logger.LogInformation("Status Code is {0}",response.StatusCode);

            // Asserts (Check status code, content type and actual response)
            response.EnsureSuccessStatusCode(); // Status Code 200-299
            Assert.Equal("application/json; charset=utf-8",
                response.Content.Headers.ContentType.ToString());

            //deserialize response to poi list
            List<LogMessage> msgs = JsonConvert.DeserializeObject<List<LogMessage>>(
                await response.Content.ReadAsStringAsync());

            //Check that 3 team entries are returned
            Assert.Equal(3,
            msgs.Count);
        }
    }
}