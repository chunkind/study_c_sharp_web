USE master;

-- Hash(해시) 조인

drop table TestOrders;

select * 
 into TestOrders FROM Orders;

select *
 into TestCustomers from Customers;

select * from TestOrders; -- 830
select * from TestCustomers; -- 91

-- hash
select *
from TestOrders as o
 inner join TestCustomers as c
   on o.CustomerID = c.CustomerID
   ;

-- NL (inner 테이블에 인덱스가 없다)
select *
from TestOrders as o
 inner join TestCustomers as c
   on o.CustomerID = c.CustomerID
   option (force order, loop join)
   ;

-- Merge(outer, inner 모두 sort => many-to-many)
select *
from TestOrders as o
 inner join TestCustomers as c
   on o.CustomerID = c.CustomerID
   option (force order, merge join)
   ;

-- HASH
-- 데이터가 작은쪽을 hash 테이블로 만들어준다.
select *
from TestOrders as o
 inner join TestCustomers as c
   on o.CustomerID = c.CustomerID
   ;

-- 결론
-- Hash 조인
-- 1) 정렬이 필요하지 않다 -> 데이터가 너무 많아서 Merge가 부담스러울 때, Hash가 대안이 될 수 있음
-- 2) 인덱스 유무에 영향을 받지 않는다 *****
	-- NL/Merge에 비해 확실한 장점!!
	-- HashTable 만드는 비용을 무시하면 안 됨(수행빈도가 많으면 -> 결국 Index)
-- 3) 랜덤 엑세스 위주로 수행되지 않는다.
-- 4) 데이터가 적은 쪽을 HashTable로 만드는 것이 유리하다