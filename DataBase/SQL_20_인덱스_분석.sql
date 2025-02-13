-- northwind database
-- https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs

SELECT *
  FROM EMPLOYEES;

-- DB ����
EXEC sp_helpdb 'master';

-- �ӽ� ���̺� ������ ( �ε��� �׽�Ʈ��)
CREATE TABLE Test
(
	EmployeeID INT NOT NULL,
	LastName NVARCHAR(20) NULL,
	FirstName NVARCHAR(20) NULL,
	HireDate DATETIME NULL,
);
GO

insert into Test
select EmployeeID, LastName, FirstName, HireDate
from Employees;


select * from Test;

-- ������ ������ ��ȿ�� ������ ����ϰڴٴ� ����
-- FILLFACTOR (���� ������ ���� 1% �� ���)
-- PAD_INDEX (FILLFACTOR �߰� ������ ����)
create index Test_Index ON Test(LastName)
WITH (FILLFACTOR = 1, PAD_INDEX = ON)
GO

-- �ε��� ��ȣ ã��
SELECT index_id, name
 FROM sys.indexes
WHERE object_id = object_id('Test');

-- 2�� �ε��� ���� ���캸��
DBCC IND('master', 'Test', 2);

-- indexLevel ������
-- Root(2) -> Branch(1) -> Leaf(0)

/*
			              834(Leverling)
		          831(Dodsworth) 833(Leverling)
		828(Buchanan..) 830(Dodsworth..) 832(Leverling..)
Table[ {Page} {Page} {Page} {Page} .... ]
*/

-- HEAP RID([������ �ּ�(4)][����ID(2)][���Թ�ȣ(2)] ������ ROW �ĺ���. ���̺��� ���� ����)
DBCC PAGE('master', 1/*���Ϲ�ȣ*/, 828/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('master', 1/*���Ϲ�ȣ*/, 830/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('master', 1/*���Ϲ�ȣ*/, 832/*��������ȣ*/, 3/*��¿ɼ�*/);

DBCC PAGE('master', 1/*���Ϲ�ȣ*/, 831/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('master', 1/*���Ϲ�ȣ*/, 833/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('master', 1/*���Ϲ�ȣ*/, 834/*��������ȣ*/, 3/*��¿ɼ�*/);

-- Random Aceccess (�� �� �б� ���� �� �������� ����)
-- Bookmark Lookup (RID�� ���� ���� ã�´�)