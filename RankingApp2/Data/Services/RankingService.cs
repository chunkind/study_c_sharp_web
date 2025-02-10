using SharedData.Models;
using RankingApp2.Data;
using Newtonsoft.Json;
using System.Text;
using System.Collections.Generic;

namespace RankingApp2.Data.Services
{
    public class RankingService
    {
        HttpClient _httpClient;

        public RankingService(HttpClient client)
        {
            _httpClient = client;
        }

        // Create
        public async Task<GameResult> AddGameResult(GameResult gameResult)
        {
            string jsonStr = JsonConvert.SerializeObject(gameResult);
            var context = new StringContent(jsonStr, Encoding.UTF8, "application/json");
            var result = await _httpClient.PostAsync("api/ranking", context);

            if (result.IsSuccessStatusCode == false)
                throw new Exception("AddGameResult Failed");

            var resultContent = await result.Content.ReadAsStringAsync();
            GameResult resGameResult = JsonConvert.DeserializeObject<GameResult>(resultContent);
            return resGameResult;
        }

        // Read
        public async Task<List<GameResult>> GetGameResultsAsync()
        {
            var result = await _httpClient.GetAsync("api/ranking");

            var resultContent = await result.Content.ReadAsStringAsync();
            List<GameResult> resGameResults = JsonConvert.DeserializeObject<List<GameResult>>(resultContent);
            return resGameResults;
        }

        // Update
        public async Task<bool> UpdateGameResult(GameResult gameResult)
        {
            string jsonStr = JsonConvert.SerializeObject(gameResult);
            var context = new StringContent(jsonStr, Encoding.UTF8, "application/json");
            var result = await _httpClient.PutAsync("api/ranking", context);

            if (result.IsSuccessStatusCode == false)
                throw new Exception("AddGameResult Failed");

            return true;
        }

        // Delete
        public async Task<bool> DeleteGameResult(GameResult gameResult)
        {
            var result = await _httpClient.DeleteAsync($"api/ranking/{gameResult.Id}");

            if (result.IsSuccessStatusCode == false)
                throw new Exception("AddGameResult Failed");

            return true;
        }
    }
}
