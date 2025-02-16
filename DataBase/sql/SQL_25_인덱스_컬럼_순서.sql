USE master;

-- 복합 인덱스 컬럼 순서
-- Index(A, B, C)

-- NonClustered
--   1
-- 2 3 4

-- Clustered
--   1
-- 2 3 4

-- Heap Table [ {Page} {Page} ]

-- 북마크 룩업
-- 북마크를 최소화 하면 끝?? 당연히 그게 끝이 아니다 왜냐?
-- Leaf Page 탐색은 여전히 존재하기 때문

-- [레벨, 종족] 인덱스, (56, 휴먼) ? (56~60 휴먼) -> 인덱스 순서가 굉장히 영향을 준다

drop table TestOrders;

select *
 into TestOrders
 from Orders;

 


-- 더미 데이터를 엄청 늘린다 (830 * 1000) 
declare @i int = 1;
declare @emp int;
select @emp = max(EmployeeID) from Orders;

while (@i < 1000)
begin
	insert into TestOrders(CustomerID, EmployeeID, OrderDate)
	select customerid, @emp + @i, orderdate
	from Orders;
	set @i = @i + 1;
end


select count(*) from testorders;

create nonclustered index idx_emp_ord
on testorders(employeeid, orderdate);

create nonclustered index idx_ord_emp
on testOrders(orderdate, employeeid);

set statistics time on;
set statistics io on;
set statistics profile on;

-- 두개 비교 => 똑같다
-- = 이퀄은 크게 차이 안난다..
select * from testorders with(index(idx_emp_ord))
where employeeid = 1 and orderdate = convert(datetime, '19970101');
;
select * from testorders with(index(idx_ord_emp))
where employeeid = 1 and orderdate = convert(datetime, '19970101')
;

-- 범위로 찾는다면??? => 이제 차이가 난다...
select * from testorders with(index(idx_emp_ord))
where employeeid = 1 and orderdate between '19970101' and '19970103'
;
select * from testorders with(index(idx_ord_emp))
where employeeid = 1 and orderdate between '19970101' and '19970103'
;

-- 직접 보자
SELECT * FROM TestOrders ORDER BY EmployeeID, OrderDate;
SELECT * FROM TestOrders ORDER BY OrderDate, EmployeeID;


-- 결론: index(a, b, c)로 구성되었을 때, 선행에 between 사용 = 후행은 인덱스 사용 X
-- 그럼 between 같은 비교가 등장하면 인덱스 순서만 무조건 바꿔주면 될까? -> NO

-- Between 범위가 작을 때 -> IN-LIST로 대체하는 것을 고려
-- 성능 향상
select * from testorders with(index(idx_ord_emp))
where employeeid = 1 and orderdate IN ('19970101', '19970102', '19970103')
;

-- 얘는또 성능 저하
select * from testorders with(index(idx_emp_ord))
where employeeid = 1 and orderdate IN ('19970101', '19970102', '19970103')
;

-- 복합 컬럼 인덱스 (선행, 후행)순서가 영향을 줄수 있음
-- BETWEEN, 부등호(> <) 선행에 들어가면, 후행은인덱스 기능을 상실
-- BETWEEN 범위가 적으면 IN-LIST로 대체하면 좋은 경우도 있다 (선행에 BETWEEN)
-- 선행=, 후행 BETWEEN이라면, 아무런 문제가 없기 때문 IN-LIST X