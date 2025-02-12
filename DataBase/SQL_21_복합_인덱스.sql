
-- 주문 상세 정보를 살펴보자
select *
 from [Order Details]
;

-- 임시 테스트 테이블을 만들고 데이터 복사한다.
select *
  into TestOrderDetails
 from [Order Details];

select *
  from TestOrderDetails;

-- 복합 인덱스 추가
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

-- 따라서 인덱스(A, B) 사용중이라면 인덱스(A) 없어도 무방
-- 하지만 B로도 검색이 필요하면 -> 인덱스(B)는 별도로 걸어줘야 함

-- 인덱스는 데이터가 추가/갱신/삭제 유지되어야 함
-- 데이터 50개를 강제로 넣어보자.
-- 1) 10248/11 10387/24

DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248, 100 + @i, 10, 1, 0);
	SET @i = @i + 1;
END

-- INDEX 정보
DBCC IND('master', 'TestOrderDetails', 2);

/*
          773
770 [785] 772 774 775 761 784
*/

DBCC PAGE('master', 1, 770, 3);
DBCC PAGE('master', 1, 785, 3);
-- 결론: 페이지 여유 공간이 없다면 -> 페이지 분할(SPLIT) 발생

-- 가공 테스트
select LastName
into TestEmployees
from Employees;

select * from TestEmployees;

-- 인덱스 추가
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

-- 오늘의 결론
-- 복합 인덱스(A, B)를 사용할 때 순서 주의 (A->B 순서 검색)
-- 인덱스 사용 시, 데이터 추가로 인해 페이지 여유 공간이 없으면 SPLIT
-- 키 가공할 때 주의!