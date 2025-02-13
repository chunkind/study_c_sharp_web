use master;

-- �ϸ�ũ ���

-- Index Scan vs Index Seek
-- Index Scan�� �׻� ���� ���� �ƴϰ�
-- Index Seek�� �׻� ���� ���� �ƴϴ�.
-- �ε����� Ȱ���ϴµ� ��� ���� ���� ������?

-- NonClustered
--     1
-- 2 3 4 5 6



-- Clustered
--     1
-- 2 3 4 5 6


-- Heap Table [ {Page} {Page} ]
-- Clustered�� ��� Index Seek�� ���� ���� ����.
-- NonClustered�� ���, �����Ͱ� Leaf Page�� ����.
-- ���� �� �� �� Ÿ�� ������
	-- 1) RID -> Heap Table (Bookmark Lookup)
	-- 2) Key -> Clustered

SELECT *
  INTO TestOrders
  FROM Orders;

SELECT * FROM TestOrders;

-- ��Ŭ������ �ε��� �߰�
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- �ε��� ��ȣ
SELECT index_id, name
FROM sys.indexes
where object_id = object_id('TestOrders');

-- ��ȸ
DBCC IND('master', 'TestOrders', 2);
/*
	    838
	835 837 839
	Heap Table [ {Page} {Page} ]
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- �⺻ Ž���� �غ���
SELECT *
  FROM TestOrders
WHERE CustomerID = 'QUICK';

-- ������ �ε����� �̿��ϰ� �غ���.
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

-- ����� ���̱����� ���θ�.. 28�� ����õ��ؼ� 8�� ã��..
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- ��Ŭ������ �ε��� ����
DROP INDEX TestOrders.Orders_Index01;

-- ������ ���� ��Ŭ������ �ε��� �߰�
-- Covered Index
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID, ShipVia);

-- ����� ���̱����� ���θ�..
-- 8�� ����õ��ؼ� 8�� �ξ��� ã��..
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;


-- Q) �׷� ����1 AND ����2 �ʿ��ϸ�, ������ INDEX(����1, ����2)�� �߰����ָ� �嶯?
-- A) NO! �� �׷����� �ʴ�. DML(INSERT, UPDATE, DELETE) �۾� ���ϰ� �����ȴ�.


-- ��Ŭ������ �ε��� ����
DROP INDEX TestOrders.Orders_Index01;

-- Look Up�� ���̱����� ���θ� 2ź
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID) INCLUDE(ShipVia); --> ������ ������ �ȹٲٰ����� ��Ʈ�� �ְڴ�.

-- NonClustered
--     1
-- 2[(data1(shipVia=3), data2(shipVia=2), ... data28)] 3 4 5 6

-- 8�� ����õ��ؼ� 8�� �ξ��� ã��..
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- ���� ���� �����ܿ� ��¿��� ���� ���ٸ�..
-- Clustered Index Ȱ���� ����� �� �ִ�.
-- But! Clustered Index�� ���̺�� 1���� ��� �� �� �ִ�.

-- ��� --
-- NonClustered Index�� �ǿ����� �ִ°��?
	-- �ϸ�ũ ����� �ɰ��� ���ϸ� �߱��� ��
-- ���?
	-- �ɼ� 1) Covered Index (�˻��� ��� �÷��� �����ϰڴ�)
	-- �ɼ� 2) Index���� Include�� ��Ʈ�� �����.
	-- �ɼ� 3) Clustered ��� (��, 1���� ����� �� �ִ� �ñر�) -> NonClustered �ǿ����� �ټ� ����
