namespace S05_Merge
{
    class Player
    {
        public int playerId;
    }

    class Salary
    {
        public int playerId;
    }
    // 41 % 10 = 1 (key)
    // 51 % 10 = 1 (key)
    // 41? -> 1 (key)

    // HashTable [0 List] [1 List] [2 List] [3] [4] [5] [6] [7] [8] [9]
    // 공간을 내주고 속도를 얻는다.
    // 동일한 값 => 동일한 Bucket (YES)
    // 동일한 Bucket => 동일한 값 (NO)

    // chunkind / 김밥맨
    // chunkind / Hash(김밥맨) => 'fi2igjaief'
    class HashTable
    {
        int _bucketCount;
        List<int>[] _buckets;

        public HashTable(int bucketCount = 100)
        {
            _bucketCount = bucketCount;
            _buckets = new List<int>[bucketCount];
            for (int i = 0; i < bucketCount; i++)
                _buckets[i] = new List<int>();
        }

        public void Add(int value)
        {
            int key = value % _bucketCount;
            _buckets[key].Add(value);
        }

        public bool Find(int value)
        {
            int key = value & _bucketCount;
            //_buckets[key].Contains(value);
            foreach(int v in _buckets[key])
            {
                if (v == value)
                    return true;
            }

            return false;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Random rand = new Random();

            List<Player> players = new List<Player>();
            for(int i=0; i<10000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                players.Add(new Player { playerId = i });
            }

            List<Salary> salaries = new List<Salary>();
            for (int i = 0; i < 10000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                salaries.Add(new Salary { playerId = i });
            }

            // TEMP HashTable
            //Dictionary<int, Salary> hash = new Dictionary<int, Salary>();
            HashTable hash = new HashTable();
            foreach (Salary s in salaries)
                //hash.Add(s.playerId, s);
                hash.Add(s.playerId);

            List<int> result = new List<int>();
            foreach(Player p in players)
            {
                //if(hash.ContainsKey(p.playerId))
                if(hash.Find(p.playerId))
                    result.Add(p.playerId);
            }
        }
    }
}