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