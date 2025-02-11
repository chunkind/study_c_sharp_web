-- 4.수치와 문자열

select 10 - 9;

select 2021 - birthYear as koreanAge
from players
--where deathYear is null and birthYear is not null and koreanAge <= 80
where deathYear is null and birthYear is not null and (2021 - birthYear) <= 80
order by koreanAge
;

-- FROM 책상에서
-- WHERE 볼펜을
-- SELECT 갖고 오고
-- ORDERBY 크기 순서로 정렬해라

SELECT 3/2; --> 정수
SELECT 3.0/2; --> 실수

SELECT ROUND(3.141423231, 3)

SELECT POWER(2, 3)

SELECT SELECT COS(0)

-- 문자열

SELECT 'HELOW'; --> 문자하나당 1바이트

SELECT N'안녕하세요'; --> 유니코드로 문자하나들 2바이트

SELECT 'HELLO ' + 'WORLD';

SELECT SUBSTRING('20200425', 1, 4);

SELECT TRIM('    HELLO WORLD   ');

SELECT *
 FROM PLAYERS;

SELECT nameFirst + ' ' + nameLast AS fullName
from PLAYERS
where nameFirst is not null and nameLast is not null
;