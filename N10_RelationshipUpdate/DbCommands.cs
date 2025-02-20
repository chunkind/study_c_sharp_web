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

        public static void ShowItems()
        {
            using (AppDbContext db = new AppDbContext())
            {
                foreach (var item in db.Items.Include(i => i.Owner).ToList())
                {
                    if (item.Owner == null)
                        Console.WriteLine($"ItemId({item.ItemId}) TemplateId({item.TemplateId}) Owner(0)");
                    else
                        Console.WriteLine($"ItemId({item.ItemId}) TemplateId({item.TemplateId}) OwnerId({item.Owner.PlayerId}) Owner({item.Owner.Name})");
                }
            }
        }

        // Update Relationship 1v1
        public static void Update_1v1()
        {
            ShowItems();

            Console.WriteLine("Input ItemSwitch PlayerId");
            Console.Write(" > ");
            int id = int.Parse(Console.ReadLine());

            using(AppDbContext db = new AppDbContext())
            {
                Player player = db.Players
                    .Include(p=>p.Item) // Nullable일때 Include를 빼먹으면?? 에러남..
                    .Single(p=>p.PlayerId == id);

                if(player.Item != null)
                {
                    player.Item.TemplateId = 888;
                    player.Item.CreateDate = DateTime.Now;
                }

                //player.Item = new Item()
                //{
                //    TemplateId = 777,
                //    CreateDate = DateTime.Now,
                //};
                
                db.SaveChanges();
            }

            Console.WriteLine("--- Test Complete! ---");

            ShowItems();
        }

        public static void ShowGuild()
        {
            using (AppDbContext db = new AppDbContext())
            {
                foreach (var guild in db.Guilds.Include(i => i.Members).ToList())
                {
                    Console.WriteLine($"GuildId({guild.GuildId}) GuildName({guild.GuildName}) MemberCount({guild.Members.Count})");
                }
            }
        }

        // Update Relationship 1vM
        public static void Update_1vM()
        {
            ShowItems();

            Console.WriteLine("Input GuildId");
            Console.Write(" > ");
            int id = int.Parse(Console.ReadLine());

            using (AppDbContext db = new AppDbContext())
            {
                Guild guild = db.Guilds
                    //.Include(p => p.Members) // Nullable일때 Include를 빼먹으면?? 에러남..
                    .Single(p => p.GuildId == id);

                // Includes 안했을때 에러
                /*guild.Members.Add(new Player()
                {
                    Name = "Dopa"
                });*/
                // Include 빼고 테스트: 도파가 길드아이디 1로 추가됐다... -> 그런데 이건 우연의 일치이지 정상적인게 아님..
                // Include 넣고 테스트: 케리아만 길드에 가입된다. 나머지애들은 없어짐..
                /*guild.Members = new List<Player>()
                {
                    new Player() { Name = "Dopa" }
                    //new Player() { Name = "Keria" }
                };*/
                // 이렇게해야 길드에 추가되는것이다.
                guild.Members.Add(new Player { Name = "Pyosik" });

                db.SaveChanges();
            }

            Console.WriteLine("--- Test Complete! ---");

            ShowItems();
        }
    }
}
