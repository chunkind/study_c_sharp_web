use BaseballData;

set statistics time on;
set statistics io on;
set statistics profile on;

-- Merge(병합) 조인 = Sort Meger(정렬 병합) 조인

SELECT *
  FROM players p
  INNER JOIN salaries AS s
  ON p.playerID = s.playerID
;

-- One-To-Many (outer가 unique해야 함 => PK, Unique)
-- Merge 조인도 조건이 붙는다.
-- 일일히 Random Access -> Clustered Scan 후 정렬

select *
  from schools s
  inner join schoolsplayers p
  on s.schoolid = p.schoolid
 ;

-- 결론
-- merge -> sort merge 조인
-- 1) 양쪽 집합을 sort(정렬)하고 Merge(병합)한다
	-- 이미 정렬된 상태라면 sort는 생략 (특히, clustered로 물리적 정렬된 상태라면 Best)
	-- 정렬할 데이터가 너무 많으면 GG -> Hash
-- 2) Random Access 위주로 수행되진 않는다.
-- 3) Many-to-Many(다대다)보다는 One-to-Many(일대다) 조인에 효과적
	-- PK, UNIQUE
