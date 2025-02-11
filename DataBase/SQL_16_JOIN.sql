-- JOIN(결합)
USE GameDB;

create table testA
(
	a integer
);
create table testB
(
	b varchar(10)
);

-- A(1, 2, 3)
insert into testA values(1);
insert into testA values(2);
insert into testA values(3);
-- B('A','B','C')
insert into testB values('A');
insert into testB values('B');
insert into testB values('C');

-- CROSS JOIN (교차 결합)
select *
  from testA
  cross join testB;

select *
  from testA, testB;

-------------------------------
USE BaseballData;

select * from players order by playerID;

select * from salaries order by playerID;

-- INNER JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
-- playerId가 players, salaries 양쪽에 다 있고 일치하는 애들을 결합
select *
  from players a
 inner join salaries b on a.playerId = b.playerID
;

-- OUTER JOIN(외부 결합)
	-- LEFT / RIGHT
	-- 어느 한쪽에만 존재하는 데이터 -> 정책?

-- LEFT JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
-- playerId가 왼쪽(Left)에 있으면 무조건 표시. 오른쪽(salaries)에 없으면 오른쪽 정보는 NULL로 채움.
select *
  from players a
 LEFT join salaries b on a.playerId = b.playerID
;

-- RIGHT JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
-- playerId가 오른쪽(Right)에 있으면 무조건 표시. 왼쪽(players)에 없으면 왼쪽 정보는 NULL로 채움.
select *
  from players a
 RIGHT join salaries b on a.playerId = b.playerID
;




