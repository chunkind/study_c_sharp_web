-- 1. 트랜잭션 종료안한다.
--BEGIN TRAN;
--	INSERT INTO ACCOUNTS VALUES(2, 'ROOKISS', 100, GETUTCDATE());

-- 2. 다른쪽에서 아래 실행하면 계속 기다리면서 실행이 안된다.
USE GameDB;
SELECT * FROM accounts;

-- 3. 트랜잭션 시작한곳에서 트랜잭션을 종료해 줘야만 위에 쿼리가 실행된다.
--ROLLBACK;