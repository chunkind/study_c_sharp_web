USE BaseballData;

-- 변수 -------------------------------------------------------------

DECLARE @i AS INT = 10;

DECLARE @j AS INT;
SET @j = 10;

-- 예제) 역대 최고 연봉을 받은 선수 이름?
declare @firstName AS NVARCHAR(15);
declare @lastName as nvarchar(15);

-- 이렇게 넣도되고
select @firstName = (SELECT top 1 nameFirst
					   FROM players as p
					  inner join salaries as s
						 on p.playerID = s.playerID
					  order by s.salary desc);

-- SQL SERVER사용 가능한데 아래처럼 넣어도 된다.
SELECT top 1 @firstName = p.nameFirst, @lastName = p.nameLast
FROM players as p
inner join salaries as s
on p.playerID = s.playerID
order by s.salary desc;

SELECT @firstName, @lastName;


-- 배치 -------------------------------------------------------------

GO

-- 배치를 이용해 변수의 유효범위 설정 가능 { }
DECLARE @i AS INT = 10;

-- 배치는 하나의 묶음으로 분석되고 실행되는 명령어 집합
SELECT * FROM players;

GO
	SELECT * FROM SALARIES;


-- 흐름 제어 ---------------------------------------------------------

-- IF
GO
DECLARE @i AS INT = 1;

IF @i = 10
	PRINT('BINGO!');
ELSE
	PRINT('NO!');

IF @i = 10
BEGIN
	PRINT('BINGO!');
	PRINT('BINGO!');
END
ELSE
BEGIN
	PRINT('NO!');
END

-- WHILE
GO
DECLARE @i AS INT = 0;
WHILE @i <= 10
BEGIN
	PRINT @i;
	SET @i = @i + 1;
	IF @i = 6 CONTINUE;
	PRINT @i;
END


-- 테이블 변수 -------------------------------------------------------
-- 임시로 사용할 테이블을 변수로 만들 수 있다.
-- DECLARE를 사용 -> tempdb 데이터베이스에 임시 저장

GO
DECLARE @test TABLE
(
	name VARCHAR(50) NOT NULL,
	salary INT NOT NULL
);

INSERT INTO @test
SELECT p.nameFirst + ' ' + p.nameLast, s.salary
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.PlayerID;

select *
  from @test;