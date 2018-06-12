using Microsoft.VisualStudio.TestTools.UnitTesting;
using Models;
using System.Threading.Tasks;

namespace SharedLibrary.Test
{
    [TestClass]
    public class TeamTest
    {

        private Service GetUserSample(bool currentStatus)
        {
            return new Service
            {
                id = "0101",
                Name = "Team01USER",
                Uri = "https://www.microsoft.com",
                CurrentStatus = currentStatus
            };
        }
        private Service GetTripSample(bool currentStatus)
        {
            return new Service
            {
                id = "0102",
                Name = "Team01TRIPS",
                Uri = "https://www.microsoft.com",
                CurrentStatus = currentStatus
            };
        }

        private Service GetPOISample(bool currentStatus)
        {
            return new Service
            {
                id = "0103",
                Name = "Team01POI",
                Uri = "https://www.microsoft.com",
                CurrentStatus = currentStatus
            };
        }

        private Team GetSampleTeam()
        {
            var services = new Service[]
            {
                GetUserSample(false),
                GetTripSample(true),
                GetPOISample(false)
            };


            // Update the same Id's Service
            var team = new Team
            {
                id = "Team01",
                Services = services,
                CurrentState = true
            };
            return team;
        }
        [TestMethod]
        public void Update_Teams_Service_Normal()
        {

            var team = GetSampleTeam();
            var service01 = GetUserSample(true);

            team.UpdateService(service01);
            Assert.IsTrue(team.Services[0].CurrentStatus);

            var service03 = GetPOISample(true);

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
                id = "0104",
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
            var service01 = GetUserSample(true);

            team.UpdateService(service01);


            var service03 = GetPOISample(true);
            team.UpdateService(service03);
            Assert.IsTrue(team.GetTotalStatus());
        }

        [TestMethod]
        public async Task CurrentStatus_MethodAsync()
        {
            var team = GetSampleTeam();
            var executed = false;
            await team.UpdateCurrentStateWithFunctionAsync(() =>  
            {
                // You can update the history in here 
                executed = true;
                return Task.CompletedTask;
            });

            // In this case, the Action will be executed. CurrentState and currentState from service is different. 
            Assert.IsFalse(team.CurrentState);
            Assert.IsTrue(executed);

            // This time team.CurrentState becomes false. 
            executed = false;
            await team.UpdateCurrentStateWithFunctionAsync(() =>
            {
                executed = true;
                return Task.CompletedTask;
            });
            // If the CurrentState is the same as current state, do nothing. 
            Assert.IsFalse(team.CurrentState);
            Assert.IsFalse(executed);

            // Update The CurrentStates to be true
            var service01 = GetUserSample(true);

            team.UpdateService(service01);

            var service03 = GetPOISample(true);
            team.UpdateService(service03);

            executed = false;
            await team.UpdateCurrentStateWithFunctionAsync(() =>
            {
                executed = true;
                return Task.CompletedTask;
            });
            // If the CurrentState is the same as current state, do nothing. 
            Assert.IsTrue(team.CurrentState);
            Assert.IsTrue(executed);

        }
    }
}
