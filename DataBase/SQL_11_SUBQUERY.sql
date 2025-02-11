-- 11. SUBQUERY(서브쿼리/하위쿼리)
-- SQL 명령문 안에 지정하는 하부 SELECT

-- 연봉이 역대급으로 높은 선수의 정보를 추출
select top 2 *
  from salaries
order by salary desc
;

select * from players where playerId = 'rodrial01';

select *
  from players
where playerId = (select top 1 playerid from salaries where playerId !='chunkind' order by salary desc)
;

-- 다중행 in 사용
select *
  from players
where playerId in (select top 20 playerid from salaries where playerId !='chunkind' order by salary desc)
;

-- 서브쿼리는 where 에서 가장 많이 사용되지만, 나머지 구문에서도 사용 가능
select (select count(*) from players) as playerCount 
    , (select count(*) from batting) as battingCount
;

-- insert 에서도 사용가능
select *
  from salaries
order by yearId desc;

-- insert into
insert into salaries
values (2020, 'KOR', 'NL', 'chunkind', (select max(salary) from salaries))
;

-- insert select
insert into salaries_temp
select yearId, playerId, salary from salaries
;

create table salaries_temp
( yearId int
, playerId varchar(9)
, salary int
);

select * from salaries_temp;

drop table salaries_temp;

-- 상관 관계 서브쿼리
-- exists, not exists
-- 포스트 시즌 타격에 참여한 선수들 목록
select playerId from battingpost;

select *
  from players
where playerId in (select playerId from battingpost);

select *
  from players
where exists (select playerId from battingpost where battingpost.playerId = players.playerId);


select *
  from players
where exists (select playerId from battingpost where battingpost.playerId = 'bordafr01');

-- 컨트롤 + L => 성능분석 
-- 성능분석에서 exists 가 빠르다 