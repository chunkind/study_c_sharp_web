use master;

-- 인덱스 종류
-- Clustered(영한 사전) vs Non-Clustered(색인)

-- Clustered
	-- Leaf Page = Data Page
	-- 데이터는 Clustered Index 키 순서로 정렬

-- Non-Clusteed ? (사실 Clustered Index 유무에 따라서 다르게 동작)
-- 1) Clustered Index가 없는 경우
	-- Clustered Index가 없으면 데이터는 Heap Table이라는 곳에 저장
	-- Heap RID -> Heap Table에 접근 데이터 추출

-- 2) Clustered Index가 있는 경우
	-- Heap Table이 없음. Leaf Table에 실제 데이터가 있다.
	-- Clustered Index의 실제 키 값을 들고 있는다.

-- 임시 테스트 테이블을 만들고 데이터 복사
SELECT *
  INTO TestOrderDetails
FROM [Order Details];


drop table TestOrderDetails;


-- 인덱스 추가
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- 인덱스 정보
EXEC sp_helpindex 'TestOrderDetails';

-- 인덱스 번호 찾기
select index_id, name
from sys.indexes
where object_id = object_id('TestOrderDetails');

-- 조회
-- PageType 1(DATA PAGE) 2(INDEX PAGE)
DBCC IND('master', 'TestOrderDetails', 2);

/*
          792
766 784 793 794 795 796 
Heap RID ([페이지 주소(4)][파일ID(2)][슬롯(2)] ROW)
Heap Table[ {Page} {Page} {Page} {Page} ]
*/
DBCC PAGE('master', 1, 766, 3);

-- Clustered 인덱스 추가
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

EXEC sp_helpindex 'TestOrderDetails';

-- CLUSTERED INDEX
DBCC IND('master', 'TestOrderDetails', 1);