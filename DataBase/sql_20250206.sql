-- 1. SSMS �Թ�
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

-- and�� �켱������ ����. �׷��� �ּ�ģ�� ó�� �����Ѵ�.
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


-- % ������ ���ڿ�
-- _ ������ ���ڿ� 1��
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


-- 4.��ġ�� ���ڿ�

select 10 - 9;

select 2021 - birthYear as koreanAge
from players
--where deathYear is null and birthYear is not null and koreanAge <= 80
where deathYear is null and birthYear is not null and (2021 - birthYear) <= 80
order by koreanAge
;

-- FROM å�󿡼�
-- WHERE ������
-- SELECT ���� ����
-- ORDERBY ũ�� ������ �����ض�

SELECT 3/2; --> ����
SELECT 3.0/2; --> �Ǽ�

SELECT ROUND(3.141423231, 3)

SELECT POWER(2, 3)

SELECT SELECT COS(0)

-- ���ڿ�

SELECT 'HELOW'; --> �����ϳ��� 1����Ʈ

SELECT N'�ȳ��ϼ���'; --> �����ڵ�� �����ϳ��� 2����Ʈ

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

-- DATE ��/��/��
-- TIME ��/��/��
-- DATETIME ��/��/��/��/��/��


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

-- ������ UTC(Greenwich Mean Time::ǥ�ؽð�(��������ġ��) �ð�
select GETUTCDATE();

select DATEADD(YEAR, 1, '20200426');
select DATEADD(YEAR, -1, '20200426');
select DATEADD(DAY, 5, '20200426');
select DATEADD(DAY, -5, '20200426');
select DATEADD(SECOND, 10, '20200426');
select DATEADD(SECOND, -10, '20200426');

-- �ð�����
select DATEDIFF(SECOND, '20200501', '20200503');

-- Ư����¥���� Ư�� ���� ��������
select datepart(DAY, '20200826');
select year('20200826');
select month('20200826');
select day('20200826');

DROP TABLE DateTimeTest;

-- 6. CASE

SELECT *
     , case birthMonth
			when 1 then N'�ܿ�'
			when 2 then N'�ܿ�'
			when 3 then N'��'
			when 4 then N'��'
			when 5 then N'��'
			when 6 then N'����'
			when 7 then N'����'
			when 8 then N'����'
			when 9 then N'����'
			when 10 then N'����'
			when 11 then N'����'
			when 12 then N'����'
			else N'�����'
		end AS birthSeason
  FROM PLAYERS
;

SELECT *
     , case 
			when birthMonth <= 2 then N'�ܿ�'
			when birthMonth <= 5 then N'��'
			when birthMonth <= 8 then N'����'
			when birthMonst <= 11 then N'����'
			else N'�����'
		end AS birthSeason
  FROM PLAYERS
;

-- �������� ���� null �̵ȴ�.
SELECT *
     , case birthMonth
			when 1 then N'�ܿ�'
			when 2 then N'�ܿ�'
			when 3 then N'��'
		end AS birthSeason
  FROM PLAYERS
;

-- 7. ���� �Լ�
-- count
select count(*) from players; -- null ����
select count(birthYear) from players; -- null ����

select distinct birthCity from players;

select distinct birthYear, birthMonth, birthDay from players order by birthYear;

select count(distinct birthCity) from players;

-- sum
-- avg
-- �������� ��� weight
select avg(weight) from Players;
select sum(weight) / count(weight) from Players;
select avg(case when weight is null then 0 else weight end) from players;

-- min
-- max
select min(weight), max(weight) from players;


-- 8. ���� ����
-- playerId(���� ID)
-- yearId (���� �⵵)
-- teamId (�� ��Ī, 'BOS' = ������)
-- G_batting (���� ��� + Ÿ��)

-- AB(Ÿ��)
-- H(��Ÿ)
-- R(���)
-- 2B(2��Ÿ)
-- 3B(3��Ÿ)
-- HR(Ȩ��)
-- BB(����)

-- 1) ������ �Ҽ� �������� �����鸸 ��� ���
select * from batting where teamId = 'BOS';

-- 2) ������ �Ҽ� �������� ���� ���? (��, �ߺ��� ����)
select count(distinct playerId) from batting where teamId = 'BOS';

-- 3) ������ ���� 2004�⵵�� ģ Ȩ�� ����
select sum(hr) from batting where teamId = 'BOS' and yearId = 2004;

-- 4) ������ �� �Ҽ����� ���� �⵵ �ִ� Ȩ���� ģ ����� ����
select top 1 * from batting where teamId = 'BOS' order by hr desc;

select * from players where playerId = 'ortizda01';


-- 9. GROUP BY
-- 2004�⵵ ������ �Ҽ����� ������ �������� Ÿ�� ����
select * from batting where yearId = 2005 and teamId = 'BOS';

-- 2004�⵵ ������ �Ҽ����� �����ؼ� ���� Ȩ�� ����
select sum(hr) from batting where yearId = 2004 and teamId = 'BOS';

-- Q) 2004�⵵�� ���� ���� Ȩ���� ���� ����?
select top 1 teamId, sum(hr) as homeRuns
  from batting
 where yearId = 2004
 group by teamId
 order by homeRuns desc
;

-- ������ ��� ������ �м��ϰ� �ʹ� -> grouping
select teamId, count(teamId) as playerCount, sum(hr) as homeRuns
from batting
where yearId = 2004
group by teamId
having sum(hr) >= 200
order by homeRuns desc
;

--from     å�󿡼�
--where    ����
--group by ���󺰷� �з��ؼ�
--having   �з��� ������ �������� �����ϰ�
--select   ����ͼ�
--order by ũ�� ���� �������ּ���.


select teamId, yearId, sum(hr) as homeRuns
  from batting
 group by teamId, yearId
 order by homeRuns desc;


-- 10. INSERT DELETE UPDATE
select * from salaries order by salary desc;

-- insert
insert into salaries values(2020, 'KOR', 'NL', 'chunkind', 90000000);

insert into salaries values(2020, 'KOR', 'NL', 'chunkind'); -- ���� �߻�

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
-- �������� vs ������

-- 11. SUBQUERY(��������/��������)
-- SQL ��ɹ� �ȿ� �����ϴ� �Ϻ� SELECT

-- ������ ��������� ���� ������ ������ ����
select top 2 *
  from salaries
order by salary desc
;

select * from players where playerId = 'rodrial01';

select *
  from players
where playerId = (select top 1 playerid from salaries where playerId !='chunkind' order by salary desc)
;

-- ������ in ���
select *
  from players
where playerId in (select top 20 playerid from salaries where playerId !='chunkind' order by salary desc)
;

-- ���������� where ���� ���� ���� ��������, ������ ���������� ��� ����
select (select count(*) from players) as playerCount 
    , (select count(*) from batting) as battingCount
;

-- insert ������ ��밡��
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

-- ��� ���� ��������
-- exists, not exists
-- ����Ʈ ���� Ÿ�ݿ� ������ ������ ���
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

-- ��Ʈ�� + L => ���ɺм� 
-- ���ɺм����� exists �� ������ 