namespace S04_Merge
{
    class Player : IComparable<Player>
    {
        public int playerId;

        public int CompareTo(Player? other)
        {
            if(playerId == other.playerId)
                return 0;
            return (playerId > other.playerId) ? 1 : -1;
        }
    }

    class Salary : IComparable<Salary>
    {
        public int playerId;

        public int CompareTo(Salary? other)
        {
            if (playerId == other.playerId)
                return 0;
            return (playerId > other.playerId) ? 1 : -1;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            List<Player> players = new List<Player>();
            players.Add(new Player() { playerId = 0 });
            players.Add(new Player() { playerId = 9 });
            players.Add(new Player() { playerId = 1 });
            players.Add(new Player() { playerId = 4 });
            players.Add(new Player() { playerId = 5 });
            
            List<Salary> salaries = new List<Salary>();
            salaries.Add(new Salary() { playerId = 0 });
            salaries.Add(new Salary() { playerId = 5 });
            salaries.Add(new Salary() { playerId = 0 });
            salaries.Add(new Salary() { playerId = 2 });
            salaries.Add(new Salary() { playerId = 9 });

            // 1 단계) Sort(이미 정렬되어 있으면 Skip)
            // O(N * Log(N))
            players.Sort();
            salaries.Sort();

            // One - To - Many (players는 중복이 없다)
            // 2 단계) Merge
            // outer [0, 1, 3, 4, 9] -> N
            // inner [0, 0, 2, 5, 9] -> N

            // index 커서
            int p = 0;
            int s = 0;

            // O(N + M)
            List<int> result = new List<int>();
            while (p < players.Count && s < salaries.Count)
            {
                if (players[p].playerId == salaries[s].playerId)
                {
                    result.Add(players[p].playerId); // 성공!
                    s++;
                }
                else if (players[p].playerId < salaries[s].playerId)
                {
                    p++;
                }
                else
                {
                    s++;
                }
            }

            // Many - To - Many (players는 중복이 있다)
            // outer [0, 0, 0, 0, 0] -> N
            // inner [0, 0, 0, 0, 0] -> N
            // O(N * M)
        }
    }
}