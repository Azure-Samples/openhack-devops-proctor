namespace Simulator.DataStore.Stores
{
    using Simulator.DataObjects;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading.Tasks;

    public class UserStore : BaseStore//, IBaseStore<User>
    {
        public UserStore(string EndPoint)
        {
            base.InitializeStore(EndPoint);

        }
        public async Task<User> GetItemAsync(string id)
        {
            User user = null;
            HttpResponseMessage response = await Client.GetAsync($"/api/user/{id}");
            if (response.IsSuccessStatusCode)
            {
                response.Content.Headers.ContentType.MediaType = "application/json";
                user = await response.Content.ReadAsAsync<User>();
            }
            return user;
        }

        public async Task<List<User>> GetItemsAsync()
        {
            List<User> users = null;
            HttpResponseMessage response = await Client.GetAsync("api/user/");
            if (response.IsSuccessStatusCode)
            {
                response.Content.Headers.ContentType.MediaType = "application/json";
                users = await response.Content.ReadAsAsync<List<User>>();
            }
            return users;
        }

        
    }
}