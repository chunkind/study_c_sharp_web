using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using MMO_EFCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace N02_CRUD
{
    public class DbCommands
    {
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
            var player = new Player()
            {
                Name = "chunkind"
            };

            List<Item> items = new List<Item>()
            {
                new Item()
                {
                    TemplateId = 101,
                    CreateDate = DateTime.Now,
                    Owner = player
                },
                new Item()
                {
                    TemplateId = 102,
                    CreateDate = DateTime.Now,
                    Owner = player
                },
                new Item()
                {
                    TemplateId = 103,
                    CreateDate = DateTime.Now,
                    Owner = new Player() { Name = "Faker" }
                }
            };

            db.items.AddRange(items);
            db.SaveChanges();
        }

        public static void ReadAll()
        {
            using (var db = new AppDbContext())
            {
                // AsNoTracking : ReadOnly << Tracking Snapshot 이라고 데이터 변경 탐지하는 기능 때문
                foreach(Item item in db.items.AsNoTracking().Include(i=>i.Owner))
                {
                    Console.WriteLine($"TemplateId({item.TemplateId}) Owner({item.Owner.Name}) Created({item.CreateDate})");
                }
            }
        }

        // 특정 플레이어가 소지한 아이템들의 CreateDate를 수정
        public static void UpdateDate()
        {
            Console.WriteLine("Input Player Name");
            Console.WriteLine("> ");
            string name = Console.ReadLine();

            using (var db = new AppDbContext())
            {
                var items = db.items.Include(i => i.Owner)
                    .Where(i => i.Owner.Name == name);

                foreach (Item item in items)
                {
                    item.CreateDate = DateTime.Now;
                }

                db.SaveChanges();
            }

            ReadAll();
        }

        public static void DeleteItem()
        {
            Console.WriteLine("Input Player Name");
            Console.WriteLine("> ");
            string name = Console.ReadLine();

            using (var db = new AppDbContext())
            {
                var items = db.items.Include(i => i.Owner)
                    .Where(i => i.Owner.Name == name);

                db.items.RemoveRange(items);

                db.SaveChanges();
            }

            ReadAll();
        }
    }
}
