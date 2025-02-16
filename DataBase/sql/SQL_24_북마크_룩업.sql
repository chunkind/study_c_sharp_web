use master;

-- 북마크 룩업

-- Index Scan vs Index Seek
-- Index Scan이 항상 나쁜 것은 아니고
-- Index Seek가 항상 좋은 것은 아니다.
-- 인덱스를 활용하는데 어떻게 느릴 수가 있을가?

-- NonClustered
--     1
-- 2 3 4 5 6



-- Clustered
--     1
-- 2 3 4 5 6


-- Heap Table [ {Page} {Page} ]
-- Clustered의 경우 Index Seek가 느릴 수가 없다.
-- NonClustered의 경우, 데이터가 Leaf Page에 없다.
-- 따라서 한 번 더 타고 가야함
	-- 1) RID -> Heap Table (Bookmark Lookup)
	-- 2) Key -> Clustered

SELECT *
  INTO TestOrders
  FROM Orders;

SELECT * FROM TestOrders;

-- 논클러스터 인덱스 추가
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- 인덱스 번호
SELECT index_id, name
FROM sys.indexes
where object_id = object_id('TestOrders');

-- 조회
DBCC IND('master', 'TestOrders', 2);
/*
	    838
	835 837 839
	Heap Table [ {Page} {Page} ]
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- 기본 탐색을 해보자
SELECT *
  FROM TestOrders
WHERE CustomerID = 'QUICK';

-- 강제로 인덱스를 이용하게 해보자.
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

-- 룩업을 줄이기위한 몸부림.. 28번 룩업시도해서 8번 찾음..
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- 논클러스터 인덱스 삭제
DROP INDEX TestOrders.Orders_Index01;

-- 개선된 복합 논클러스터 인덱스 추가
-- Covered Index
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID, ShipVia);

-- 룩업을 줄이기위한 몸부림..
-- 8번 룩업시도해서 8번 꽝없이 찾음..
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;


-- Q) 그럼 조건1 AND 조건2 필요하면, 무조건 INDEX(조건1, 조건2)를 추가해주면 장땡?
-- A) NO! 꼭 그렇지는 않다. DML(INSERT, UPDATE, DELETE) 작업 부하가 증가된다.


-- 논클러스터 인덱스 삭제
DROP INDEX TestOrders.Orders_Index01;

-- Look Up을 줄이기위한 몸부림 2탄
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID) INCLUDE(ShipVia); --> 데이터 순서는 안바꾸겠지만 힌트를 주겠다.

-- NonClustered
--     1
-- 2[(data1(shipVia=3), data2(shipVia=2), ... data28)] 3 4 5 6

-- 8번 룩업시도해서 8번 꽝없이 찾음..
SELECT *
  FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- 위와 같은 눈물겨운 노력에도 답이 없다면..
-- Clustered Index 활용을 고려할 수 있다.
-- But! Clustered Index는 테이블당 1개만 사용 할 수 있다.

-- 결론 --
-- NonClustered Index가 악영향을 주는경우?
	-- 북마크 룩업이 심각한 부하를 야기할 때
-- 대안?
	-- 옵션 1) Covered Index (검색할 모든 컬럼을 포함하겠다)
	-- 옵션 2) Index에다 Include로 힌트를 남긴다.
	-- 옵션 3) Clustered 고려 (단, 1번만 사용할 수 있는 궁극기) -> NonClustered 악영향을 줄수 있음
