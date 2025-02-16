-- 12. 데이터베이스 작성
-- 우선 데이터베이스를 만들어야 한다.
-- 참고) Schema라고도 함

CREATE DATABASE GameDB;

USE GameDB;

-- 테이블 생성(CREATE)/삭제(DROP)/변경(ALTER)
-- CREATE TABLE 테이블명(열이름 자료형 [DEFAULT 기본값] [NULL | NOT NULL], ...)
CREATE TABLE accounts(
	accountId INTEGER NOT NULL,
	accountName VARCHAR(10) NOT NULL,
	coins INTEGER DEFAULT 0,
	createdTime DATETIME
);

CREATE TABLE accounts(
	accountId INTEGER NOT NULL PRIMARY KEY,
	accountName VARCHAR(10) NOT NULL,
	coins INTEGER DEFAULT 0,
	createdTime DATETIME
);

CREATE TABLE accounts(
	accountId INTEGER NOT NULL,
	accountName VARCHAR(10) NOT NULL,
	coins INTEGER DEFAULT 0,
	createdTime DATETIME,
	PRIMARY KEY(accountId)
);

SELECT * FROM accounts;

-- 테이블 삭제
DROP TABLE accounts;

-- 변경
-- 열 추가(ADD) / 삭제(DROP) / 변경(ALTER)
ALTER TABLE accounts ADD lastEnterTime DATETIME;

ALTER TABLE accounts DROP COLUMN lastEnterTime;

ALTER TABLE accounts ALTER COLUMN accountName VARCHAR(20) NOT NULL;

-- 제약(CONSTRAINT) 추가/삭제
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY
-- FOREIGN KEY

ALTER TABLE accounts ADD PRIMARY KEY (accountId); --> 지우기 어렵다

ALTER TABLE accounts ADD CONSTRAINT PK_Account PRIMARY KEY (accountId);

ALTER TABLE accounts DROP CONSTRAINT PK_Account;

select * from accounts where accountId = 1111;