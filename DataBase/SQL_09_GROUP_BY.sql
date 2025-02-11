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