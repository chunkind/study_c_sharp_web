
-- �ֹ� �� ������ ���캸��
select *
 from [Order Details]
;

-- �ӽ� �׽�Ʈ ���̺��� ����� ������ �����Ѵ�.
select *
  into TestOrderDetails
 from [Order Details];

select *
  from TestOrderDetails;

-- ���� �ε��� �߰�
create index Index_TestOrderDetails
on TestOrderDetails(OrderId, ProductId);

-- (OrderId, ProductId) ? OrderId? ProductId?
-- INDEX SCAN (INDEX FULL SCAN) -> BAD
-- INDEX SEEK -> GOOD


select *
  from TestOrderDetails
  --where ProductId = 11 and orderId = 10248 -- GOODS
  --where OrderID = 10248 and ProductId = 11 -- GOODS
  --where orderId = 10248 --> GOODS
  where productId = 11 --> BAD
  ;

DBCC IND('master', 'TestOrderDetails', 2);

/*
          773
770 772 774 775 761 784
*/
DBCC PAGE('master', 1, 770, 3);

-- ���� �ε���(A, B) ������̶�� �ε���(A) ��� ����
-- ������ B�ε� �˻��� �ʿ��ϸ� -> �ε���(B)�� ������ �ɾ���� ��

-- �ε����� �����Ͱ� �߰�/����/���� �����Ǿ�� ��
-- ������ 50���� ������ �־��.
-- 1) 10248/11 10387/24

DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248, 100 + @i, 10, 1, 0);
	SET @i = @i + 1;
END

-- INDEX ����
DBCC IND('master', 'TestOrderDetails', 2);

/*
          773
770 [785] 772 774 775 761 784
*/

DBCC PAGE('master', 1, 770, 3);
DBCC PAGE('master', 1, 785, 3);
-- ���: ������ ���� ������ ���ٸ� -> ������ ����(SPLIT) �߻�

-- ���� �׽�Ʈ
select LastName
into TestEmployees
from Employees;

select * from TestEmployees;

-- �ε��� �߰�
create index Index_TestEmployees
on TestEmployees(LastName);

-- INDEX SCAN -> BAD
SELECT *
  FROM TestEmployees
WHERE SUBSTRING(LastName, 1, 2) = 'Bu';


-- INDEX SEEK -> GOODS
SELECT *
  FROM TestEmployees
WHERE LastName LIKE 'Bu%';

-- ������ ���
-- ���� �ε���(A, B)�� ����� �� ���� ���� (A->B ���� �˻�)
-- �ε��� ��� ��, ������ �߰��� ���� ������ ���� ������ ������ SPLIT
-- Ű ������ �� ����!