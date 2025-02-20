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
                //foreach (var item in db.Items.Include(i => i.Owner).ToList())
                foreach (var item in db.Items.Include(i => i.Owner).IgnoreQueryFilters().ToList())
                {
                    if(item.SoftDeleted)
                    {
                        Console.WriteLine($"DELETED - ItemId({item.ItemId}) TemplateId({item.TemplateId})");
                    }
                    else
                    {
                        if (item.Owner == null)
                            Console.WriteLine($"ItemId({item.ItemId}) TemplateId({item.TemplateId}) Owner(0)");
                        else
                            Console.WriteLine($"ItemId({item.ItemId}) TemplateId({item.TemplateId}) OwnerId({item.Owner.PlayerId}) Owner({item.Owner.Name})");
                    }
                }
            }
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

    }
}
