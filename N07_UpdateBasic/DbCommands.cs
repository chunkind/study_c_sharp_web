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
        // 그런데 궁금한 점!
        // Update를 할 때 전체 수정을 하는 것일까? 수정사항이 있는 애들만 골라서 하는 것일까?
        // 1) SaveChanges 호출 할 때 -> 내부적으로 DetectChanges라는 호출
        // 2) DetectChange에서 -> 최초 Snapshot / 현재 Snapshot 비교

        /*
         
            SELECT TOP(2) GuildId, GuildName
            FROM [Guilds]
            WHERE GuildName = N'T1';

            SET NOCOUNT ON; -- Count 하지 않겠다.
            UPDATE [Guilds]
            SET GuildName = @p0
            WHERE GuildId = @p1;
            SELECT @@ROWCOUNT;
         
         */
        public static void UpdateTest()
        {
            using (AppDbContext db = new AppDbContext())
            {
                // Single :: 조건에 일치하는 하나의 요소 반환, 2개이상이면 예외
                // 최초
                var guild = db.Guilds.Single(g => g.GuildName == "T1");

                guild.GuildName = "DWG";
                // 현재

                db.SaveChanges();
            }
        }
    }
}
