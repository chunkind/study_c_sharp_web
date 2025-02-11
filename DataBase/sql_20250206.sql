-- 1. SSMS 입문
SELECT TOP (1000) [lahmanID]
    ,[playerID]
    ,[managerID]
    ,[hofID]
    ,[birthYear]
    ,[birthMonth]
    ,[birthDay]
    ,[birthCountry]
    ,[birthState]
    ,[birthCity]
    ,[deathYear]
    ,[deathMonth]
    ,[deathDay]
    ,[deathCountry]
    ,[deathState]
    ,[deathCity]
    ,[nameFirst]
    ,[nameLast]
    ,[nameNote]
    ,[nameGiven]
    ,[nameNick]
    ,[weight]
    ,[height]
    ,[bats]
    ,[throws]
    ,[debut]
    ,[finalGame]
    ,[college]
    ,[lahman40ID]
    ,[lahman45ID]
    ,[retroID]
    ,[holtzID]
    ,[bbrefID]
FROM [BaseballData].[dbo].[players]
;

select * from dbo.players;

SELECT * FROM DBO.PLAYERS;

-- 2. SELECT FROM WHERE

select namefirst, nameLast, birthYear
from players
where birthYear = 1866
;

select namefirst, nameLast, birthYear
from players
where birthYear != 1866
;

select nameFirst, nameLast, birthYear, birthCountry
  from players
 where 1=1
   and birthCountry = 'USA'
;

-- and가 우선순위가 높다. 그래서 주석친것 처럼 동작한다.
select nameFirst, nameLast, birthYear, birthCountry
  from players
 where 1=1
   and birthYear = 1974 or birthCountry = 'USA' and weight > 185
   --and birthYear = 1974 or (birthCountry = 'USA' and weight > 185)
;

select *
  from players
where deathYear is null
;


-- % 임의의 문자열
-- _ 임의의 문자열 1개
select *
  from players
--where birthCity like 'New%'
where birthCity like 'New Yor_'
;


-- 3. ORDER BY

SELECT *
  FROM players
where birthYear is not null
--order by birthYear asc
order by birthYear desc, birthMonth desc, birthDay desc
;


SELECT TOP (10) *
--SELECT TOP 10 *
  FROM players
where birthYear is not null
--order by birthYear asc
order by birthYear desc, birthMonth desc, birthDay desc
;

SELECT TOP 1 PERCENT *
  FROM players
where birthYear is not null
--order by birthYear asc
order by birthYear desc, birthMonth desc, birthDay desc
;

-- 100 ~ 200
SELECT *
  FROM players
where birthYear is not null
--order by birthYear asc
order by birthYear desc, birthMonth desc, birthDay desc
offset 100 rows fetch next 100 rows only
;


-- 4.수치와 문자열

select 10 - 9;

select 2021 - birthYear as koreanAge
from players
--where deathYear is null and birthYear is not null and koreanAge <= 80
where deathYear is null and birthYear is not null and (2021 - birthYear) <= 80
order by koreanAge
;

-- FROM 책상에서
-- WHERE 볼펜을
-- SELECT 갖고 오고
-- ORDERBY 크기 순서로 정렬해라

SELECT 3/2; --> 정수
SELECT 3.0/2; --> 실수

SELECT ROUND(3.141423231, 3)

SELECT POWER(2, 3)

SELECT SELECT COS(0)

-- 문자열

SELECT 'HELOW'; --> 문자하나당 1바이트

SELECT N'안녕하세요'; --> 유니코드로 문자하나들 2바이트

SELECT 'HELLO ' + 'WORLD';

SELECT SUBSTRING('20200425', 1, 4);

SELECT TRIM('    HELLO WORLD   ');

SELECT *
 FROM PLAYERS;

SELECT nameFirst + ' ' + nameLast AS fullName
from PLAYERS
where nameFirst is not null and nameLast is not null
;

-- 5. DATETIME

-- DATE 열/월/일
-- TIME 시/분/초
-- DATETIME 연/월/일/시/분/초


CREATE TABLE DateTimeTest
( time datetime not null
);


select CAST('20200426' AS DATETIME);
select CAST('20200425 05:03' AS DATETIME);
-- YYYYMMDD
-- YYYYMMDD hh:mm:ss.nnn
-- YYYY-MM-DDThh:mm

select GETDATE();

select CURRENT_TIMESTAMP;

insert into DateTimeTest
values(CURRENT_TIMESTAMP);

select * from DateTimeTest;


insert into DateTimeTest
values('20200421 12:00');

insert into DateTimeTest
values(CAST('20200425 05:03' AS DATETIME));

select *
  from DateTimeTest
where time >= '20100101'
;

-- 현재의 UTC(Greenwich Mean Time::표준시간(영국에위치한) 시간
select GETUTCDATE();

select DATEADD(YEAR, 1, '20200426');
select DATEADD(YEAR, -1, '20200426');
select DATEADD(DAY, 5, '20200426');
select DATEADD(DAY, -5, '20200426');
select DATEADD(SECOND, 10, '20200426');
select DATEADD(SECOND, -10, '20200426');

-- 시간차이
select DATEDIFF(SECOND, '20200501', '20200503');

-- 특정날짜에서 특정 일자 가져오기
select datepart(DAY, '20200826');
select year('20200826');
select month('20200826');
select day('20200826');

DROP TABLE DateTimeTest;

-- 6. CASE

SELECT *
     , case birthMonth
			when 1 then N'겨울'
			when 2 then N'겨울'
			when 3 then N'봄'
			when 4 then N'봄'
			when 5 then N'봄'
			when 6 then N'여름'
			when 7 then N'여름'
			when 8 then N'여름'
			when 9 then N'가을'
			when 10 then N'가을'
			when 11 then N'가을'
			when 12 then N'가을'
			else N'몰라요'
		end AS birthSeason
  FROM PLAYERS
;

SELECT *
     , case 
			when birthMonth <= 2 then N'겨울'
			when birthMonth <= 5 then N'봄'
			when birthMonth <= 8 then N'여름'
			when birthMonst <= 11 then N'가을'
			else N'몰라요'
		end AS birthSeason
  FROM PLAYERS
;

-- 설정안한 값은 null 이된다.
SELECT *
     , case birthMonth
			when 1 then N'겨울'
			when 2 then N'겨울'
			when 3 then N'봄'
		end AS birthSeason
  FROM PLAYERS
;

-- 7. 집계 함수
-- count
select count(*) from players; -- null 포함
select count(birthYear) from players; -- null 제외

select distinct birthCity from players;

select distinct birthYear, birthMonth, birthDay from players order by birthYear;

select count(distinct birthCity) from players;

-- sum
-- avg
-- 선수들의 평균 weight
select avg(weight) from Players;
select sum(weight) / count(weight) from Players;
select avg(case when weight is null then 0 else weight end) from players;

-- min
-- max
select min(weight), max(weight) from players;


-- 8. 연습 문제
-- playerId(선수 ID)
-- yearId (시즌 년도)
-- teamId (팀 명칭, 'BOS' = 보스턴)
-- G_batting (출전 경기 + 타석)

-- AB(타수)
-- H(안타)
-- R(출루)
-- 2B(2루타)
-- 3B(3루타)
-- HR(홈런)
-- BB(볼넷)

-- 1) 보스턴 소속 선수들의 정보들만 모두 출력
select * from batting where teamId = 'BOS';

-- 2) 보스턴 소속 선수들의 수는 몇명? (단, 중복은 제거)
select count(distinct playerId) from batting where teamId = 'BOS';

-- 3) 보스턴 팀이 2004년도에 친 홈런 개수
select sum(hr) from batting where teamId = 'BOS' and yearId = 2004;

-- 4) 보스턴 팀 소속으로 단일 년도 최다 홈런을 친 사람의 정보
select top 1 * from batting where teamId = 'BOS' order by hr desc;

select * from players where playerId = 'ortizda01';


-- 9. GROUP BY
-- 2004년도 보스턴 소속으로 출전한 선수들의 타격 정보
select * from batting where yearId = 2005 and teamId = 'BOS';

-- 2004년도 보스턴 소속으로 출전해서 날린 홈런 개수
select sum(hr) from batting where yearId = 2004 and teamId = 'BOS';

-- Q) 2004년도에 가장 많은 홈런을 날린 팀은?
select top 1 teamId, sum(hr) as homeRuns
  from batting
 where yearId = 2004
 group by teamId
 order by homeRuns desc
;

-- 팀별로 묶어서 뭔가를 분석하고 싶다 -> grouping
select teamId, count(teamId) as playerCount, sum(hr) as homeRuns
from batting
where yearId = 2004
group by teamId
having sum(hr) >= 200
order by homeRuns desc
;

--from     책상에서
--where    공을
--group by 색상별로 분류해서
--having   분류한 다음에 빨간색은 제외하고
--select   갖고와서
--order by 크기 별로 나열해주세요.


select teamId, yearId, sum(hr) as homeRuns
  from batting
 group by teamId, yearId
 order by homeRuns desc;


-- 10. INSERT DELETE UPDATE
select * from salaries order by salary desc;

-- insert
insert into salaries values(2020, 'KOR', 'NL', 'chunkind', 90000000);

insert into salaries values(2020, 'KOR', 'NL', 'chunkind'); -- 에러 발생

insert into salaries(yearId, teamId, playerId, lgId, salary)
values (2020, 'KOR', 'rookiss', 'NL', 900000);

-- delete
delete from salaries where playerId = 'rookiss';

-- update
update salaries
   set salary = salary * 2
     , yearId = yearId + 1
 where teamId = 'KOR'
;

delete from salaries where yearId >= 2020;

-- delete vs update
-- 물리삭제 vs 논리삭제

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