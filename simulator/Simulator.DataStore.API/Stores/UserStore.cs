namespace ApiClient.Controllers
{
    using ApiClient.DataObjects;
    using ApiClient.DataStore.Abstractions;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading.Tasks;

    public class UserStore : BaseStore, IBaseStore<User>
    {
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

        public async Task<User> CreateItemAsync(User item)
        {
            HttpResponseMessage response = await Client.PostAsJsonAsync<User>("api/user", item);
            response.EnsureSuccessStatusCode();
            if (response.IsSuccessStatusCode)
            {
                response.Content.Headers.ContentType.MediaType = "application/json";
                item = await response.Content.ReadAsAsync<User>();
            }
            return item;
        }

        public async Task<bool> UpdateItemAsync(User item)
        {
            HttpResponseMessage response = await Client.PatchAsJsonAsync($"api/user/{item.Id}", item);
            response.EnsureSuccessStatusCode();
            if (response.IsSuccessStatusCode)
                response.Content.Headers.ContentType.MediaType = "application/json";
            return true;
        }

        public async Task<bool> DeleteItemAsync(User item)
        {
            HttpResponseMessage response = await Client.DeleteAsync($"api/user/{item.Id}");
            response.EnsureSuccessStatusCode();
            if (response.IsSuccessStatusCode)
                response.Content.Headers.ContentType.MediaType = "application/json";
            return true;
        }
    }
}