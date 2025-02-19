using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using MMO_EFCore;
using N05_DataTransferObject;
using Newtonsoft.Json;

namespace N02_CRUD
{
    // State(상태)
    // 0) Detached (No Traking ! 추적되지 않는 상태. Save Changes를 해도 존재를 모름)
    // 1) Unchanged (BD에는 이미 있고, 딱히 수정사항도 없었음. Save Changes를 해도 아무 것도 X)
    // 2) Deleted (DB에는 아직 있지만, 삭제되어야 함. Save Changes로 DB에 적용)
    // 3) Modified (DB에는 있고, 클라에서 수정된 상태. Save Chages로 DB에 적용)
    // 4) Added (DB에는 아직 없음, SaveChanges로 DB에 적용)
    public class DbCommands
    {
        // 초기화 하는데 시간이 좀 걸림
        public static void InitializeDB(bool forceReset = false)
        {
            using (AppDbContext db = new AppDbContext())
            {
                if (!forceReset && (db.GetService<IDatabaseCreator>() as RelationalDatabaseCreator).Exists())
                    return;

                db.Database.EnsureDeleted();
                db.Database.EnsureCreated();

                CreateTestData(db);
                Console.WriteLine("DB Initialized");
            }

            // using 쓰면 안해도됨
            //db.Dispose();
        }

        public static void CreateTestData(AppDbContext db)
        {
            var chunkind = new Player(){ Name = "Chunkind" };
            var faker = new Player() { Name = "Faker" };
            var deft = new Player() { Name = "Deft" };

            // 1) Detached
            Console.WriteLine(db.Entry(chunkind).State);

            List<Item> items = new List<Item>()
            {
                new Item()
                {
                    TemplateId = 101,
                    CreateDate = DateTime.Now,
                    Owner = chunkind
                },
                new Item()
                {
                    TemplateId = 102,
                    CreateDate = DateTime.Now,
                    Owner = faker
                },
                new Item()
                {
                    TemplateId = 103,
                    CreateDate = DateTime.Now,
                    Owner = deft
                }
            };

            Guild guild = new Guild()
            {
                GuildName = "T1",
                Members = new List<Player>() { chunkind, faker, deft }
            };

            db.Items.AddRange(items);
            db.Guilds.Add(guild);

            db.SaveChanges();

            {
                var owner = db.Players.Where(p => p.Name == "chunkind").First();

                Item item = new Item()
                {
                    TemplateId = 300,
                    CreateDate = DateTime.Now,
                    Owner = owner
                };
                db.Items.Add(item);

                db.SaveChanges();
            }

        }

        // Update 3단계
        // 1) Tracked Entity를 얻어 온다
        // 2) Entity 클래스의 property를 변경 (set)
        // 3) SaveChanges 호출!

        // 오늘의 주제: (Connected vs Disconnected) Update
        // Disconnected : Update 단계가 한 번에 쭉~ 일어나지 않고, 끊기는 경우
        // (REST API 등)
        // 처리하는 2가지 방법
        // 1) Reload 방식. 필요한 정보만 보내서, 1-2-3 Step
        // 2) Full Update 방식. 모든 정보를 다 보내고 받아서, 아예 Entity를 다시 만들고 통으로 Update

        public static void ShowGuilds()
        {
            using (AppDbContext db = new AppDbContext())
            {
                //db.Guilds.MapGuildToDto().ToList();
                // 위에 처럼 리스트로 추출해도 되지만 바로해도 된다.
                foreach (var guild in db.Guilds.MapGuildToDto())
                {
                    Console.WriteLine($"GuildId({guild.GuildId}) GuildName({guild.Name}) MemberCount({guild.MemberCount})");
                }
            }
        }

        // 장점: 최소한의 정보로 Update 가능
        // 단점: Read를 두번 한다.
        public static void UpdateByReload()
        {
            ShowGuilds();

            // 외부에서 수정 원하는 데이터의 ID / 정보 넘겨줬다고 가정.
            Console.WriteLine("Input GuildId");
            Console.Write(" > ");
            int id = int.Parse(Console.ReadLine());
            Console.WriteLine("Input GuildName");
            Console.Write(" > ");
            string name = Console.ReadLine();

            using (AppDbContext db = new AppDbContext())
            {
                Guild guild = db.Find<Guild>(id);
                guild.GuildName = name;
                db.SaveChanges();
            }

            Console.WriteLine("--- Update Complete ---");
            ShowGuilds();
        }

        public static string MakeUpdateJsonStr()
        {
            var jsonStr = "{\"GuildId\":1, \"GuildName\":\"Hello\", \"Members\":null}";
            return jsonStr;
        }

        // 장점 : DB에 다시 Read할 필요 없이 바로 Update
        // 단점 : 모든 정보 필요, 보안 문제 (상대를 신용할때 사용)
        public static void UpdateByFull()
        {
            ShowGuilds();

            string jsonStr = MakeUpdateJsonStr();
            Guild guild = JsonConvert.DeserializeObject<Guild>(jsonStr);

            /*Guild guild = new Guild()
            {
                GuildId = 1,
                GuildName = "TestGuild"
            };*/
            
            using (AppDbContext db = new AppDbContext())
            {
                db.Guilds.Update(guild);
                db.SaveChanges();
            }

            Console.WriteLine("--- Update Complete ---");
            ShowGuilds();
        }
    }
}
