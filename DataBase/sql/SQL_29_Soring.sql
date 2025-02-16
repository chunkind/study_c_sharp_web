use BaseballData;


-- Sorting (정렬) 을 줄이자

-- O(NlogN) -> DB는 데이터가 어마어마하게 많다
-- 너무 용량이 커서 가용 메모리로 커버가 안 되면 -> 디스크까지 찾아간다(!)
-- sorting이 언제 일어나는지 파악하고 있어야 함

-- sorting이 일어날때
-- 1) SORT MERGE JOIN
	-- 원인) 알고리즘 특성상 Merge하기 전에 Sort를 해야함
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX

-- 1) 생략
-- 2) ORDER BY
-- 원인) ORDER BY 순서로 정렬을 해야 하니까 SORT
SELECT *
  FROM PLAYERS
order by college;

select *
  from batting
order by playerID, yearID;

-- 3) GROUP BY
-- 원인) 집계를 하기 위해
select college, count(college)
 from players
 where college like 'C%'
 group by college;

select playerID, count(playerID)
from players
where playerID like 'C%'
group by playerID;

 -- 4) DISTINCT
 -- 원인) 중복 제거 : 정말 중복 제거가 필요한가?
select distinct college
 from players
 where college like 'C%';

select college
 from players
 where college like 'C%';

-- 5) UNION
-- 원인) 중복 제거
select college
from players
where college like 'B%'
UNION
select college
from players
where college like 'C%'
;

select college
from players
where college like 'B%'
UNION ALL
select college
from players
where college like 'C%'
;

-- 6) 순위 윈도우 함수
-- 원인) 집계를 하기 위해서
select ROW_NUMBER() OVER(ORDER BY college)
FROM players;

select ROW_NUMBER() OVER(ORDER BY playerID)
FROM players;



-- Sorting (정렬) 을 줄이자!

-- O(NlogN) -> DB는 데이터가 어마어마하게 많다
-- 너무 용량이 커서 가용 메모리로 커버가 안 되면 -> 디스크까지 찾아간다(!)
-- sorting이 언제 일어나는지 파악하고 있어야 함

-- sorting이 일어날때
-- 1) SORT MERGE JOIN
	-- 원인) 알고리즘 특성상 Merge하기 전에 Sort를 해야함
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX

-- INDEX를 잘 활용하면, SORTING을 굳이 하지 않아도 됨.