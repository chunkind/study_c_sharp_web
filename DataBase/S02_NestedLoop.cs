namespace S02_NestedLoop
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

            //List<Salary> salaries = new List<Salary>();
            Dictionary<int, Salary> salaries = new Dictionary<int, Salary>();
            for (int i = 0; i < 1000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                //salaries.Add(new Salary() { playerId = i });
                salaries.Add(i, new Salary() { playerId = i });
            }

            // Q) ID가 players에도 있고, salaries에도 있는 정보를 추출?
            List<int> result = new List<int>();
            // Nested(내포하는) Loop(루프)

            // NL은 안에 포문이 중요하다
            // 해쉬로 하면 더 빠르다!
            // O(N^2 -> N
            foreach (Player p in players)
            {
                //foreach (Salary s in salaries)
                //{
                //    if(s.playerId == p.playerId)
                //    {
                //        result.Add(p.playerId);
                //        break;
                //    }
                //}

                Salary s = null;
                if(salaries.TryGetValue(p.playerId, out s))
                    result.Add(p.playerId);
            }
        }
    }
}