USE BaseballData;

-- RDBMS (Relational 관계형)
-- 데이터를 집합으로 간주하다.

-- 복수의 테이블을 다루는 방법

-- 커리어 평균 연봉이 3000000 이상인 선수들의 playerId
SELECT playerId, AVG(salary)
  FROM salaries
 GROUP BY playerId
HAVING AVG(salary) >= 3000000
;

-- 12월에 태어난 선수들의 playerID
SELECT playerId, birthMonth
 from players
 where birthMonth = 12;

 -- 합집합
-- [커리어 평균 연봉이 300000 이상] || [12월에 태어난] 선수
-- UNION (중복 제거)
SELECT playerId
  FROM salaries
 GROUP BY playerId
HAVING AVG(salary) >= 3000000
UNION
SELECT playerId
 from players
 where birthMonth = 12
;
-- UNION ALL(중복 가능)
SELECT playerId
  FROM salaries
 GROUP BY playerId
HAVING AVG(salary) >= 3000000
UNION ALL
SELECT playerId
 from players
 where birthMonth = 12
ORDER BY playerID
;

-- 교집합
-- [커리어 평균 연봉이 300000 이상] && [12월에 태어난] 선수
-- INTERSECT
SELECT playerId
  FROM salaries
 GROUP BY playerId
HAVING AVG(salary) >= 3000000
INTERSECT
SELECT playerId
 from players
 where birthMonth = 12
ORDER BY playerID
;

-- 차집합
-- [커리어 평균 연봉이 300000 이상] - [12월에 태어난] 선수
-- EXCEPT
SELECT playerId
  FROM salaries
 GROUP BY playerId
HAVING AVG(salary) >= 3000000
EXCEPT
SELECT playerId
 from players
 where birthMonth = 12
ORDER BY playerID
;