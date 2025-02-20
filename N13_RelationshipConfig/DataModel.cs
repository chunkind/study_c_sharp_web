using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MMO_EFCore
{
    // 오늘의 주제 : Configuration

    // A) Convention (관례) :: 우선순위 3
    // - 각종 형식과 이름 등을 정해진 규칙에 맞게 만들면, EF Core에서 앞에서 처리
    // - 쉽고 빠르지만, 모든 경우를 처리할 수는 없다.
    // B) Data Annotation (데이터 주석) :: 우선순위 2
    // - class/property 등에 Attribute를붙여 추가 정보
    // C) Fluent Api (직접 정의) :: 우선순위 1
    // - OnModelCreating에서 그냥 직접 설정을 정의해서 만드는 '귀찮은' 방식
    // - 하지만 활용 범위는 가장 넓다.


    // Entity 클래스 이름 = 테이블 이름 = Item
    [Table("Item")]
    public class Item
    {
        public bool SoftDeleted { get; set; }

        // 이름Id -> PK
        public int ItemId { get; set; }
        public int TemplateId { get; set; }
        public DateTime CreateDate { get; set; }

        // 다른 클래스 참조 -> FK (Navigational Property)
        //public int OwnerId { get; set; }
        //[ForeignKey("OwnerId")]
        // 1) Null
        //public int OwnerId { get; set; }
        // 2) Nullable
        public int? OwnerId { get; set; }
        public Player Owner { get; set; }
    }


    // 클래스 이름 = 테이블 이름 = Player
    [Table("Player")]
    public class Player
    {
        // 이름 Id -> PK
        public int PlayerId { get; set; }

        [Required]
        [MaxLength(20)]
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

    // DTO (Data Transfer Object)
    public class GuildDto
    {
        public int GuildId { get; set; }
        public string Name { get; set;}
        public int MemberCount { get; set;}
    }
}
