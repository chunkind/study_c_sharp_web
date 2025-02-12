use master;

-- 인덱스 접근 방식 (Access)
-- Index Scan vs Index Seek

create table TestAccess
(
	id int not null,
	name nchar(50) not null,
	dummy nchar(1000) null
);
go

create clustered index TestAccess_CI
on TestAccess(id);
go

create nonclustered index TestAccess_NCI
on TestAccess(name);
go

drop index TestAccess.TestAccess_CI;

declare @i INT;
set @i = 1;

while (@i <= 500)
begin
	insert into TestAccess
	values (@i, 'Name' + convert(varchar, @i), 'Hello World' + convert(varchar, @i));
	set @i = @i + 1;
end

-- 인덱스 정보
exec sp_helpindex 'TestAccess';

-- 인덱스 번호
select index_id, name
from sys.indexes
where object_id = object_id('TestAccess');

-- 조회
dbcc ind('master', 'TestAccess', 1);
dbcc ind('master', 'TestAccess', 2);


-- 논리적 읽기 -> 실제 데이터를 찾기 위해 읽은 페이지 수
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- INDEX SCAN = LEAF PAGE 순차적으로 검색
select *
  from TestAccess;

-- INDEX SEEK = 
 SELECT *
   FROM TestAccess
WHERE ID = 104;

-- INDEX SEEK + KEY LOOKUP
SELECT *
  FROM TestAccess
WHERE name = 'name5';


-- INDEX SCAN + KEY LOOKUP
-- N * 2 + @
select top 5 *
 from TestAccess
 order by name;