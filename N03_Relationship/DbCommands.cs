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
                foreach(Item item in db.Items.AsNoTracking().Include(i=>i.Owner))
                {
                    Console.WriteLine($"TemplateId({item.TemplateId}) Owner({item.Owner.Name}) Created({item.CreateDate})");
                }
            }
        }

        public static void ShowItems()
        {
            Console.WriteLine("플레이어 이름 입력하세요.");
            Console.Write("> ");
            string name = Console.ReadLine();

            //using (var db = new AppDbContext())
            //{
            //    foreach(Player player in db.Players.AsNoTracking().Where(p=>p.Name == name).Include(p=>p.Items))
            //    {
            //        // 1:N 관계여도 자동으로 로딩되는게 아니다. => Include 를 해줘야 함
            //        foreach(Item item in player.Items)
            //        {
            //            Console.WriteLine($"{item.TemplateId}");
            //        }
            //    }
            //}

        }
    }
}
