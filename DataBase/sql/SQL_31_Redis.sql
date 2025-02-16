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

