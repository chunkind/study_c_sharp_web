using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MMO_EFCore
{
    // 클래스 이름 = 테이블 이름 = Item
    [Table("Item")]
    public class Item
    {
        // 이름Id -> PK
        public int ItemId { get; set; }
        public int TemplateId { get; set; }
        public DateTime CreateDate { get; set; }

        // 다른 클래스 참조 -> FK (Navigational Property)
        //public int OwnerId { get; set; }
        [ForeignKey("OwnerId")]
        public Player Owner { get; set; }
    }


    // 클래스 이름 = 테이블 이름 = Player
    [Table("Player")]
    public class Player
    {
        // 이름 Id -> PK
        public int PlayerId { get; set; }
        public string Name { get; set; }

        // 1:N
        //public ICollection<Item> Items { get; set; }

        // 1:1
        //public int ItemId { get; set; }
        public Item Item { get; set; }
        public Guild Guild { get; set; }
    }

    [Table("Guild")]
    public class Guild
    {
        public int GuildId { get; set; }
        public string GuildName { get; set; }
        public ICollection<Player> Members { get; set; }
    }

    //new
    // DTO (Data Transfer Object)
    public class GuildDto
    {
        public string Name { get; set;}
        public int MemberCount { get; set;}
    }
}
