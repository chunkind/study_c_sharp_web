-- 10. INSERT DELETE UPDATE
select * from salaries order by salary desc;

-- insert
insert into salaries values(2020, 'KOR', 'NL', 'chunkind', 90000000);

insert into salaries values(2020, 'KOR', 'NL', 'chunkind'); -- 에러 발생

insert into salaries(yearId, teamId, playerId, lgId, salary)
values (2020, 'KOR', 'rookiss', 'NL', 900000);

-- delete
delete from salaries where playerId = 'rookiss';

-- update
update salaries
   set salary = salary * 2
     , yearId = yearId + 1
 where teamId = 'KOR'
;

delete from salaries where yearId >= 2020;

-- delete vs update
-- 물리삭제 vs 논리삭제