using Microsoft.VisualStudio.TestTools.UnitTesting;
using Models;

namespace SharedLibrary.Test
{
    [TestClass]
    public class TeamTest
    {

        private Team GetSampleTeam()
        {
            var services = new Service[]
            {
                new Service {
                    Id = "0101",
                    Name = "Team01USER",
                    Uri = "https://www.microsoft.com",
                    CurrentStatus = false
                },
                new Service
                {
                    Id = "0102",
                    Name = "Team01TRIPS",
                    Uri = "https://www.microsoft.com",
                    CurrentStatus = true
                },
                new Service
                {
                    Id = "0103",
                    Name = "Team01POI",
                    Uri = "https://www.microsoft.com",
                    CurrentStatus = false
                }
            };


            // Update the same Id's Service
            var team = new Team
            {
                Id = "Team01",
                Services = services
            };
            return team;
        }
        [TestMethod]
        public void Update_Teams_Service_Normal()
        {

            var team = GetSampleTeam();

            var service01 = new Service
            {
                Id = "0101",
                Name = "Team01USER",
                Uri = "https://www.microsoft.com",
                CurrentStatus = true
            };

            team.UpdateService(service01);
            Assert.IsTrue(team.Services[0].CurrentStatus);

            var service03 = new Service
            {
                Id = "0103",
                Name = "Team01POI",
                Uri = "https://www.microsoft.com",
                CurrentStatus = true
            };
            team.UpdateService(service03);
            Assert.IsTrue(team.Services[2].CurrentStatus);
        }
        [TestMethod]
        [ExpectedException(typeof(System.InvalidOperationException))]
        public void Update_Teams_Service_New()
        {
            // If there is no Service match to the parameter. 
            // It should not happen in production
            // In this case, we throws Exception

            var team = GetSampleTeam();
            var service04 = new Service
            {
                Id = "0104",
                Name = "Team01SOME",
                Uri = "https://www.microsoft.com",
                CurrentStatus = true
            };
            team.UpdateService(service04);


        }
        [TestMethod]
        public void Availablity_Methods()
        {
            var team = GetSampleTeam();
            Assert.IsFalse(team.GetTotalStatus());
            var service01 = new Service
            {
                Id = "0101",
                Name = "Team01USER",
                Uri = "https://www.microsoft.com",
                CurrentStatus = true
            };

            team.UpdateService(service01);


            var service03 = new Service
            {
                Id = "0103",
                Name = "Team01POI",
                Uri = "https://www.microsoft.com",
                CurrentStatus = true
            };
            team.UpdateService(service03);
            Assert.IsTrue(team.GetTotalStatus());
        }
        
    }
}
