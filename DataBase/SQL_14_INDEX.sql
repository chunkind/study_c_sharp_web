/*************************************************************************************
* INDEX(색인)이란?

책에서 특정 단어가 몇페이지에 나오는지 찾아보려면?
index(색인)을 찾아보면 쉽게 찾을수 있다.


* 이진 검색 트리를 사용

      16
    14 78
  5 15 31 90
1 10

1) 왼쪽을 타고 가면 현재 값보다 작다.
2) 오른쪽을 타고 가면 현재 값보다 크다.

인덱스를 걸면 항상 좋을까?
-> 아니요, 단어가 많고 중복되는 데이터가 별로 없어야 성능이 좋다.


* PRIMARY KEY? INDEX?
INDEX 는 CLUSTERED와 NON-CLUSTERED 2 가지 종류가 있다.

- PRIMARY KEY = 대부분 CLUSTERED INDEX
	- 테이블당 1개만 존재!
	- 제일 좋고 빠르다

- 나머지 = NON-CLUSTERED INDEX
	- 별다른 제한 없음

CLUSTERED?
ㄴ 실제 데이터가 키에 따라 정렬된 상태로 저장(물리적으로 정렬되서 테이블을 만들고 여기서 찾음 1단계에 일어남)

NON-CLUSTERED?
ㄴ 별도의 공간에 index생성후 찾고 -> 실DB에가서 몇페이지인지 찾는다 (2단계에 일어남)


* 요약
INDEX(색인)은 데이터를 빨리 찾을 수 있게 보조해준다.
- PRIMARY KEY(CLUSTERED INDEX)
	물리적인 데이터 저장 순서의 기준
	영한 사전

- 일반 INDEX (NON-CLUSTERED INDEX)
	따로 관리하는 일종의 LOOKUP 테이블
	책 후반에 나오는 색인


*************************************************************************************/

CREATE TABLE accounts(
	accountId INTEGER NOT NULL,
	accountName VARCHAR(10) NOT NULL,
	coins INTEGER DEFAULT 0,
	createdTime DATETIME
);


ALTER TABLE accounts ADD CONSTRAINT PK_Account PRIMARY KEY (accountId);

ALTER TABLE accounts DROP CONSTRAINT PK_Account;

-- 인덱스 CREATE INDEX / DROP INDEX

CREATE INDEX i1 ON accounts(accountName);

-- 모든정보가 유니크하다 겹치는게 없다.
CREATE UNIQUE INDEX i1 ON accounts(accountName);

-- 열 여러개 가능
CREATE UNIQUE INDEX i1 ON accounts(accountName, coins);

-- 딱하나만 만들수 있다.
CREATE CLUSTERED INDEX i1 ON accounts(accountName);

DROP INDEX accounts.i1;

