-- 8. 연습 문제
-- playerId(선수 ID)
-- yearId (시즌 년도)
-- teamId (팀 명칭, 'BOS' = 보스턴)
-- G_batting (출전 경기 + 타석)

-- AB(타수)
-- H(안타)
-- R(출루)
-- 2B(2루타)
-- 3B(3루타)
-- HR(홈런)
-- BB(볼넷)

-- 1) 보스턴 소속 선수들의 정보들만 모두 출력
select * from batting where teamId = 'BOS';

-- 2) 보스턴 소속 선수들의 수는 몇명? (단, 중복은 제거)
select count(distinct playerId) from batting where teamId = 'BOS';

-- 3) 보스턴 팀이 2004년도에 친 홈런 개수
select sum(hr) from batting where teamId = 'BOS' and yearId = 2004;

-- 4) 보스턴 팀 소속으로 단일 년도 최다 홈런을 친 사람의 정보
select top 1 * from batting where teamId = 'BOS' order by hr desc;

select * from players where playerId = 'ortizda01';