namespace Simulator.DataStore.Stores
{
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;

    public class BaseStore//<T> : IBaseStore<T> where T : class, IBaseDataObject, new()
    {
        public string EndPoint { get; set; }
        public HttpClient Client { get; set; }
        public DateTime DateTime { get; set; }

        public Task InitializeStore(string EndPoint)
        {
            Client = new HttpClient();
            Client.BaseAddress = new Uri(EndPoint);
            Client.DefaultRequestHeaders.Accept.Clear();
            Client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            DateTime = DateTime.UtcNow;

            return Task.CompletedTask;
        }

        //public Task<T> GetItemAsync(string id)
        //{
        //    throw new NotImplementedException();
        //}

        //public Task<List<T>> GetItemsAsync()
        //{
        //    throw new NotImplementedException();
        //}

        //public Task<T> CreateItemAsync(T item)
        //{
        //    throw new NotImplementedException();
        //}

        //public Task<bool> UpdateItemAsync(T item)
        //{
        //    throw new NotImplementedException();
        //}

        //public Task<bool> DeleteItemAsync(T item)
        //{
        //    throw new NotImplementedException();
        //}
    }
}