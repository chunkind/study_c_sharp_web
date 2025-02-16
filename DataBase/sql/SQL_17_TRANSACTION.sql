use GameDB;

select * from accounts;

delete accounts;
delete from accounts;

-- tran 명시하지 않으면, 자동으로 COMMIT
insert into accounts values(1, 'chunkind', 100, GETUTCDATE());

-- ALL OR NOTHING :: 트랜잭션

-- 메일 BEGIN TRAN
 -- 보낼 것인가 COMMIT;
 -- 취소할 것인가 ROLBACK;

-- 거래
 -- A의 인벤토리에서 아이템 제거
 -- B의 인벤토리에다가 아이템 추가
 -- A의 골드 감소

-- begin tran;
-- commit;
-- rollback;

-- 성공/실패 여부에 따라 COMMIT (= COMMIT을 수동으로 하겠다)
BEGIN TRAN;
	INSERT INTO ACCOUNTS VALUES(2, 'ROOKISS', 100, GETUTCDATE());
ROLLBACK;

BEGIN TRAN;
	INSERT INTO ACCOUNTS VALUES(2, 'ROOKISS', 100, GETUTCDATE());
COMMIT;

-- 응용
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO ACCOUNTS VALUES(1, 'chunkind', 100, GETUTCDATE());
		INSERT INTO ACCOUNTS VALUES(2, 'rookiss', 100, GETUTCDATE());
	COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- 현재 활성화된 트랜잭션 수를 반환
		ROLLBACK
	PRINT('ROOLBACK 했음');
END CATCH
;

-- TRAN 사용할 때 주의할 점
-- TRAN 안에는 꼭! 원자적으로 실행될 애들만 넣자
-- C# List<Player> List<Salary> 원자적으로 수정 -> lock 을 잡고 실행 -> writelock(상호배타적인 락) readlock (공유 락)

-- 1. 트랜잭션 종료안한다.
BEGIN TRAN;
	INSERT INTO ACCOUNTS VALUES(2, 'ROOKISS', 100, GETUTCDATE());

-- 2. 다른쪽에서 아래 실행하면 계속 기다리면서 실행이 안된다.
USE GameDB;
SELECT * FROM accounts;

-- 3. 트랜잭션 시작한곳에서 트랜잭션을 종료해 줘야만 위에 쿼리가 실행된다.
ROLLBACK;

