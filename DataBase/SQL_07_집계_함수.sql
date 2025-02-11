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