use master;

-- �ε��� ���� ��� (Access)
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

-- �ε��� ����
exec sp_helpindex 'TestAccess';

-- �ε��� ��ȣ
select index_id, name
from sys.indexes
where object_id = object_id('TestAccess');

-- ��ȸ
dbcc ind('master', 'TestAccess', 1);
dbcc ind('master', 'TestAccess', 2);


-- ���� �б� -> ���� �����͸� ã�� ���� ���� ������ ��
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- INDEX SCAN = LEAF PAGE ���������� �˻�
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