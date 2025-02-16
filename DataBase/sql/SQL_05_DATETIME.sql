-- 5. DATETIME

-- DATE 열/월/일
-- TIME 시/분/초
-- DATETIME 연/월/일/시/분/초


CREATE TABLE DateTimeTest
( time datetime not null
);


select CAST('20200426' AS DATETIME);
select CAST('20200425 05:03' AS DATETIME);
-- YYYYMMDD
-- YYYYMMDD hh:mm:ss.nnn
-- YYYY-MM-DDThh:mm

select GETDATE();

select CURRENT_TIMESTAMP;

insert into DateTimeTest
values(CURRENT_TIMESTAMP);

select * from DateTimeTest;


insert into DateTimeTest
values('20200421 12:00');

insert into DateTimeTest
values(CAST('20200425 05:03' AS DATETIME));

select *
  from DateTimeTest
where time >= '20100101'
;

-- 현재의 UTC(Greenwich Mean Time::표준시간(영국에위치한) 시간
select GETUTCDATE();

select DATEADD(YEAR, 1, '20200426');
select DATEADD(YEAR, -1, '20200426');
select DATEADD(DAY, 5, '20200426');
select DATEADD(DAY, -5, '20200426');
select DATEADD(SECOND, 10, '20200426');
select DATEADD(SECOND, -10, '20200426');

-- 시간차이
select DATEDIFF(SECOND, '20200501', '20200503');

-- 특정날짜에서 특정 일자 가져오기
select datepart(DAY, '20200826');
select year('20200826');
select month('20200826');
select day('20200826');

DROP TABLE DateTimeTest;