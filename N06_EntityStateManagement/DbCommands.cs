using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using MMO_EFCore;
using N05_DataTransferObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace N02_CRUD
{
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

        // 주제: State(상태)
        // 0) Detached (No Traking ! 추적되지 않는 상태. Save Changes를 해도 존재를 모름)
        // 1) Unchanged (BD에는 이미 있고, 딱히 수정사항도 없었음. Save Changes를 해도 아무 것도 X)
        // 2) Deleted (DB에는 아직 있지만, 삭제되어야 함. Save Changes로 DB에 적용)
        // 3) Modified (DB에는 있고, 클라에서 수정된 상태. Save Chages로 DB에 적용)
        // 4) Added (DB에는 아직 없음, SaveChanges로 DB에 적용)

        // SaveChanges 호출하면 어떤 일이?
        // 1) 추가된 객체들의 상태가 Unchanged로 바뀜
        // 2) SQL Identity로 PK를 관리
        // -- 데이터 추가 후 ID를 받아와서 객체의 ID property를 채워준다.
        // - Relationship 참고해서, FK 세팅 및 객체 참조 연결

        // 이미 존재하는 사용자를 연동하려면?
        // 1) Tranked Instance (추적되고 있는 객체)를 얻어와서
        // 2) 데이터 연결

        public static void CreateTestData(AppDbContext db)
        {
            var chunkind = new Player(){ Name = "Chunkind" };
            var faker = new Player() { Name = "Faker" };
            var deft = new Player() { Name = "Deft" };

            //new
            //EntityState state = db.Entry(chunkind).State;
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

            //new
            // 2) Added
            //Console.WriteLine(db.Entry(chunkind).State);
            //Console.WriteLine(chunkind.PlayerId);

            db.SaveChanges();

            //new2
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

            //new
            // 3) Unchanged
            //Console.WriteLine(chunkind.PlayerId);
            //Console.WriteLine(db.Entry(chunkind).State);
        }

    }
}
