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