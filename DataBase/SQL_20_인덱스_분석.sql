-- northwind database
-- https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs

SELECT *
  FROM EMPLOYEES;

-- DB 정보
EXEC sp_helpdb 'master';

-- 임시 테이블 만들자 ( 인덱스 테스트용)
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

-- 공간을 굉장히 비효율 적으로 사용하겠다는 설정
-- FILLFACTOR (리프 페이지 공간 1% 만 사용)
-- PAD_INDEX (FILLFACTOR 중간 페이지 적용)
create index Test_Index ON Test(LastName)
WITH (FILLFACTOR = 1, PAD_INDEX = ON)
GO

-- 인덱스 번호 찾기
SELECT index_id, name
 FROM sys.indexes
WHERE object_id = object_id('Test');

-- 2번 인덱스 정보 살펴보기
DBCC IND('master', 'Test', 2);

-- indexLevel 을보면
-- Root(2) -> Branch(1) -> Leaf(0)

/*
			              834(Leverling)
		          831(Dodsworth) 833(Leverling)
		828(Buchanan..) 830(Dodsworth..) 832(Leverling..)
Table[ {Page} {Page} {Page} {Page} .... ]
*/

-- HEAP RID([페이지 주소(4)][파일ID(2)][슬롯번호(2)] 조합한 ROW 식별자. 테이블에서 정보 추출)
DBCC PAGE('master', 1/*파일번호*/, 828/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('master', 1/*파일번호*/, 830/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('master', 1/*파일번호*/, 832/*페이지번호*/, 3/*출력옵션*/);

DBCC PAGE('master', 1/*파일번호*/, 831/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('master', 1/*파일번호*/, 833/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('master', 1/*파일번호*/, 834/*페이지번호*/, 3/*출력옵션*/);

-- Random Aceccess (한 건 읽기 위해 한 페이지씩 접근)
-- Bookmark Lookup (RID를 통해 행을 찾는다)