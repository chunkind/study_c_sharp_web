namespace S01_NestedLoop
{
    class Player
    {
        public int playerId;
        // ...
    }

    class Salary
    {
        public int playerId;
        // ...
    }

    class Program
    {
        static void Main(string[] args)
        {
            Random rand = new Random();

            List<Player> players = new List<Player>();
            for(int i=0; i<1000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                players.Add(new Player() { playerId = i });
            }
            
            List<Salary> salaries = new List<Salary>();
            for (int i = 0; i < 1000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                salaries.Add(new Salary() { playerId = i });
            }

            // Q) ID가 players에도 있고, salaries에도 있는 정보를 추출?
            List<int> result = new List<int>();
            // Nested(내포하는) Loop(루프)
            // O(N^2)
            foreach (Player p in players)
            {
                foreach (Salary s in salaries)
                {
                    if(s.playerId == p.playerId)
                    {
                        result.Add(p.playerId);
                        break;
                    }
                }
            }
        }
    }
}