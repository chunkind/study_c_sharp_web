-- new Query : ctrl + n
-- excute : F5

SELECT *
  FROM dbo.players
;

-- create : nvarchar -> 유니코드
create table ExamResult
(name nvarchar(50)
,english int
,muth int
,korean int
);


select *
  from ExamResult
;

drop table ExamResult;

-- SQL (RDBMS를 조작하기 위한 명령어)
-- +@ T-SQL

-- CRUD (Create, Read, Update, Delete)
