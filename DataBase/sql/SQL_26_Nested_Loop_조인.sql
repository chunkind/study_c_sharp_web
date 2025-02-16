use BaseballData;

-- 조인 원리
--1) Nested Loop (NL) 조인
--2) Merge(병합) 조인
--3) Hash(해시) 조인

-- Merge
select *
  from players as p
  inner join salaries as s
  on p.playerID = s.playerID
;

-- NL
select top 5 *
  from players as p
  inner join salaries as s
  on p.playerID = s.playerID
;

-- Hash
select *
  from salaries as s
  inner join teams as t
  on s.teamID = t.teamID
;


-- merge -> ln로
select *
  from players as p
  inner join salaries as s
  on p.playerID = s.playerID
  option(loop join)
;

-- ln로 루프 돌리되, 외부에다 players를 놓고 내부에다 salaries를 놓고 포문 돌려라
select *
  from players as p
  inner join salaries as s
  on p.playerID = s.playerID
  option(force order, loop join)
;

-- 결론
-- NL 특징
-- 먼저 액세스한 (OUTER)테이블의 로우를 차례 차례 -> (INNER)테이블에 랜덤 엑세스
-- (INER)테이블에 인덱스가 없으면 노답
-- 부분범위 처리에 좋다 (ex. TOP 5)