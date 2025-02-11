-- 6. CASE

SELECT *
     , case birthMonth
			when 1 then N'겨울'
			when 2 then N'겨울'
			when 3 then N'봄'
			when 4 then N'봄'
			when 5 then N'봄'
			when 6 then N'여름'
			when 7 then N'여름'
			when 8 then N'여름'
			when 9 then N'가을'
			when 10 then N'가을'
			when 11 then N'가을'
			when 12 then N'가을'
			else N'몰라요'
		end AS birthSeason
  FROM PLAYERS
;

SELECT *
     , case 
			when birthMonth <= 2 then N'겨울'
			when birthMonth <= 5 then N'봄'
			when birthMonth <= 8 then N'여름'
			when birthMonst <= 11 then N'가을'
			else N'몰라요'
		end AS birthSeason
  FROM PLAYERS
;

-- 설정안한 값은 null 이된다.
SELECT *
     , case birthMonth
			when 1 then N'겨울'
			when 2 then N'겨울'
			when 3 then N'봄'
		end AS birthSeason
  FROM PLAYERS
;