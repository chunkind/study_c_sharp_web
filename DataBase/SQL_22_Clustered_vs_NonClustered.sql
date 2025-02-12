use master;

-- �ε��� ����
-- Clustered(���� ����) vs Non-Clustered(����)

-- Clustered
	-- Leaf Page = Data Page
	-- �����ʹ� Clustered Index Ű ������ ����

-- Non-Clusteed ? (��� Clustered Index ������ ���� �ٸ��� ����)
-- 1) Clustered Index�� ���� ���
	-- Clustered Index�� ������ �����ʹ� Heap Table�̶�� ���� ����
	-- Heap RID -> Heap Table�� ���� ������ ����

-- 2) Clustered Index�� �ִ� ���
	-- Heap Table�� ����. Leaf Table�� ���� �����Ͱ� �ִ�.
	-- Clustered Index�� ���� Ű ���� ��� �ִ´�.

-- �ӽ� �׽�Ʈ ���̺��� ����� ������ ����
SELECT *
  INTO TestOrderDetails
FROM [Order Details];


drop table TestOrderDetails;


-- �ε��� �߰�
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- �ε��� ����
EXEC sp_helpindex 'TestOrderDetails';

-- �ε��� ��ȣ ã��
select index_id, name
from sys.indexes
where object_id = object_id('TestOrderDetails');

-- ��ȸ
-- PageType 1(DATA PAGE) 2(INDEX PAGE)
DBCC IND('master', 'TestOrderDetails', 2);

/*
          792
766 784 793 794 795 796 
Heap RID ([������ �ּ�(4)][����ID(2)][����(2)] ROW)
Heap Table[ {Page} {Page} {Page} {Page} ]
*/
DBCC PAGE('master', 1, 766, 3);

-- Clustered �ε��� �߰�
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

EXEC sp_helpindex 'TestOrderDetails';

-- CLUSTERED INDEX
DBCC IND('master', 'TestOrderDetails', 1);