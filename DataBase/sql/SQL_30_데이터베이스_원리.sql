TRANSACTION의 ACID 특성

1) A(Atomicity)
원자성
All or Nothing = 애매하게 반만 되는 경우는 없다.

2) C(Consistency)
일관성
데이터 간의 일관성 보장(ex. 데이터와 인덱스간 불일치 등)

3) I(Isolation)
고립성
트랜잭션을 단독으로 실행하나, 다른 트랜잭션과 실행하나 똑같다

4) D(Durability)
지속성
장애가 발생하더라도 데이터는 반드시 복구 가능


1) 실제 데이터를 바로 하드디스크에 반영하진 않고, 로그를 이용
2) REDO (Refore->After), UNDO(After-> Before)
3) 미래로 간다(ROLL FORWARD)
4) 과거로 간다(ROLL BACK)
5) 데이터베이스 장애 발생하더라도 로그를 이용해 복구/롤백