-- new Query : ctrl + n
-- excute : F5

SELECT *
  FROM dbo.players
;

-- create : nvarchar -> �����ڵ�
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

-- SQL (RDBMS�� �����ϱ� ���� ��ɾ�)
-- +@ T-SQL

-- CRUD (Create, Read, Update, Delete)
