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

        /*
         * Relationship
         * - Principal Entity (주요 -> Player)
         * - Dependent Entity (의존적 -> FK 포함하는 쪽 -> Item)
         * 
         * 오늘의 주제 : 
         * Q) Dependent 데이터가 Principal 데이터 없이 존재 할 수 있을까?
         * - 1) 주인이 없는 아이템은 불가능!
         * - 2) 주인이 없는 아이템도 가능! (ex. 로그 차원에서)
         * 
         * 그러면 2 케이스 어떻게 구분해서 설정할까?
         * 답은 Nullable ! int?
         * FK 그냥 int로 설정하면 1번, Nullable으로 설정하면 2번 
         */
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

        // 1) FK가 Nullable이 아니라면
        // - Player가 지워지면, FK로 해당 Player 참조하는 Item도 같이 삭제됨
        // 2) FK가 Nullable이라면
        // - Player가 지워지더라도, FK로 해당 Player 참조하는 Item은 그대로
        public static void Test()
        {
            ShowItems();

            Console.WriteLine("Input Delete PlayerId");
            Console.Write(" > ");
            int id = int.Parse(Console.ReadLine());

            using(AppDbContext db = new AppDbContext())
            {
                Player player = db.Players
                    .Include(p=>p.Item) // Nullable일때 Include를 빼먹으면?? 에러남..
                    .Single(p=>p.PlayerId == id);

                db.Players.Remove(player);
                db.SaveChanges();
            }

            Console.WriteLine("--- Test Complete! ---");

            ShowItems();
        }
    }
}
