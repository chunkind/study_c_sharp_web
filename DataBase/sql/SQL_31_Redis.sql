관계형 데이터베이스의 단점
-> 자료가 많아지면 현저하게 속도가 떨어짐
-> B-Tree 방식 


REDIS 1초 요약

1) 문자열
2) 리스트
3) 셋
4) 정렬된 셋
5) 해시
class Redis<T>
{
	Dictionary<string, T> keyValuePairs = new Dictionary<string, T>();
}

기본적으로 IN-MEMORY 방식 (설정에 따라 주기적으로 디스크에 저장도 가능)

중요정보 -> RDBS
서브정보 -> Redis

* 윈도우즈 Redis 다운 받는곳
http://github.com/tporadowski/redis/releases



1) 문자열

set [key] [value]
get [key]
------------------------------------------------------------------
127.0.0.1:6379> set key1 "hello world"
OK
127.0.0.1:6379> get key1
"hello world"
127.0.0.1:6379> set user:name "chunkind"
OK
127.0.0.1:6379> get user:name
"chunkind"
-------------------------------------------------------------------


append
-------------------------------------------------------------------
127.0.0.1:6379> append user:name " is godlike"
(integer) 19
127.0.0.1:6379> get user:name
"chunkind is godlike"
-------------------------------------------------------------------

incr
decr
-------------------------------------------------------------------
127.0.0.1:6379> set test1 11
OK
127.0.0.1:6379> set test2 "12"
OK
127.0.0.1:6379> incr test1
(integer) 12
127.0.0.1:6379> decr user:name
(error) ERR value is not an integer or out of range
127.0.0.1:6379> decr test1
(integer) 11
-------------------------------------------------------------------

mset
mget
-------------------------------------------------------------------
127.0.0.1:6379> mset key1 value1 key2 value key3 value3
OK
127.0.0.1:6379> get key1
"value1"
127.0.0.1:6379> mget key1 key2 key3
1) "value1"
2) "value"
3) "value3"
127.0.0.1:6379> mget key1 key2 key3 key4
1) "value1"
2) "value"
3) "value3"
4) (nil)
127.0.0.1:6379> set key anothervalue
OK
127.0.0.1:6379> get key1
"value1"
127.0.0.1:6379> set key1 anothervalue
OK
127.0.0.1:6379> get key1
"anothervalue"
-------------------------------------------------------------------

ttl [key]
expire [key] [seconds]
-------------------------------------------------------------------
127.0.0.1:6379> ttl key1
(integer) -1
127.0.0.1:6379> expire key1 10
(integer) 1
127.0.0.1:6379> ttl key1
(integer) 7
127.0.0.1:6379> ttl key1
(integer) 3
127.0.0.1:6379> ttl key1
(integer) 0
127.0.0.1:6379> ttl key1
(integer) -2
127.0.0.1:6379>

-- 로그인 활용
127.0.0.1:6379> set rookiss:auth qwer4321
OK
127.0.0.1:6379> expire rookiss:auth 3600
(integer) 1
127.0.0.1:6379> get rookiss:auth
"qwer4321"
127.0.0.1:6379> ttl rookiss:auth
(integer) 3587
127.0.0.1:6379> ttl rookiss:auth
(integer) 3585
-------------------------------------------------------------------

2) 셋 (중복을 허용하지 않는 집합)
합집합 교집합 차집합

sadd
sinter
srem
-------------------------------------------------------------------
127.0.0.1:6379> sadd faker:gudok rookiss
(integer) 1
127.0.0.1:6379> sadd faker:gudok rookiss
(integer) 0
127.0.0.1:6379> sadd faker:gudok rookiss2
(integer) 1
127.0.0.1:6379> sadd faker:gudok rookiss3
(integer) 1
127.0.0.1:6379> sinter faker:gudok
1) "rookiss3"
2) "rookiss2"
3) "rookiss"
127.0.0.1:6379> srem faker:gudok rookiss3
(integer) 1
127.0.0.1:6379> sinter faker:gudok
1) "rookiss2"
2) "rookiss"

사용 예제) 유투브 구독(채널/구독자)
-------------------------------------------------------------------


3) 정렬된 셋(셋 + 정렬) = Map, Dictionary

zadd
-------------------------------------------------------------------
127.0.0.1:6379> zadd pvp:ranking 323 rookiss
(integer) 1
127.0.0.1:6379> zadd pvp:ranking 999 faker
(integer) 1
127.0.0.1:6379> zadd pvp:ranking 888 deft
(integer) 1
127.0.0.1:6379> zrange pvp:ranking 0 10
1) "rookiss"
2) "deft"
3) "faker"
127.0.0.1:6379> zrange pvp:ranking 0 -1
1) "rookiss"
2) "deft"
3) "faker"
127.0.0.1:6379> zrevrange pvp:ranking 0 -1
1) "faker"
2) "deft"
3) "rookiss"

사용 예제) 랭킹 시스템
-------------------------------------------------------------------

4) 리스트
lpush
rpush
lrange
lpop
rpop
-------------------------------------------------------------------
127.0.0.1:6379> lpush guild:users rookiss
(integer) 1
127.0.0.1:6379> lpush guild:users faker
(integer) 2
127.0.0.1:6379> lpush guild:users masteryi
(integer) 3
127.0.0.1:6379> rpush guild:users chunkind
(integer) 4
127.0.0.1:6379> lrange guild:users 0 -1
1) "masteryi"
2) "faker"
3) "rookiss"
4) "chunkind"
127.0.0.1:6379> rpop guild:users
"chunkind"
127.0.0.1:6379> lrange guild:users 0 -1
1) "masteryi"
2) "faker"
3) "rookiss"

사용 예제) 스택/큐
-------------------------------------------------------------------

5) 해시
hset
hget
hlen
hdel

hgetall
-------------------------------------------------------------------
127.0.0.1:6379> hset rookiss:info name rookiss email rookiss@naver.com
(integer) 2
127.0.0.1:6379> hget rookiss:info name
"rookiss"
127.0.0.1:6379> hlen rookiss:info
(integer) 2
127.0.0.1:6379> hgetall rookiss:info
1) "name"
2) "rookiss"
3) "email"
4) "rookiss@naver.com"
-------------------------------------------------------------------



