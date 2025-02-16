USE BaseballData;

-- 윈도우 함수
-- 행들의 서브 집함을 대상으로, 각 행별로 계산을 해서 스칼라(단일 고정)값을 출력하는 함수

-- 느낌상 groupping이랑 비슷한가?
-- SUM, COUNT, AVG 집계 함수

select *
  from salaries
order by salary desc;

select playerId, max(salary)
  from salaries
group by playerID
order by MAX(salary) desc;

-- ~OVER([PARTITION] [ORDER BY] [ROWS])
-- 전체 데이터를 연봉 순서로 나열하고, 순위 표기
select *,
  row_number() over(order by salary desc), -- 행#번호
  rank() over(order by salary desc), -- 랭킹
  dense_rank() over(order by salary desc), -- 랭킹
  ntile(100) over(order by salary desc) -- 석차 : 백분율
from salaries;

-- playerID 별 순위를 따로 하고 싶다면
select *,
  rank() over(partition by playerId order by salary desc)
from salaries
order by playerID;

-- LAG(바로 이전), LEAD(바로 다음)
select *,
  rank() over(partition by playerId order by salary desc),
  lag(salary) over(partition by playerId order by salary desc) as prevSalary,
  lead(salary) over(partition by playerId order by salary desc) as nextSalary
from salaries
order by playerID;

-- FIRST_VALUE, LAST_VALUE
-- WORST가 이상하다

-- FRAME : FIRST~CURRENT
SELECT *,
  RANK() over(partition by playerId order by salary desc),
  FIRST_VALUE(SALARY) OVER(PARTITION BY PLAYERID ORDER BY SALARY DESC) AS BEST,
  LAST_VALUE(SALARY) OVER(PARTITION BY PLAYERID ORDER BY SALARY DESC) AS WORST
FROM SALARIES
;

SELECT *,
  RANK() over(partition by playerId order by salary desc),
  FIRST_VALUE(SALARY) OVER(PARTITION BY PLAYERID ORDER BY SALARY DESC 
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS BEST,
  LAST_VALUE(SALARY) OVER(PARTITION BY PLAYERID ORDER BY SALARY DESC
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS WORST
FROM SALARIES
;