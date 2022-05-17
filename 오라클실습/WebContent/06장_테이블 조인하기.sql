--<북스-06장_테이블 조인하기>

--1. 조인
--1.1 카디시안 곱 (=곱집합)=구 방식 : cross join (현 방식 cross join)- 조인조건이 없다.
select * from EMPLOYEE; --컬럼수:8, 행수:14
select * from DEPARTMENT;--컬럼수:3, 행수:4

select * --11개 컬럼, 56개 전체 행수
from EMPLOYEE, DEPARTMENT;--from EMPLOYEE join DEPARTMENT;--오류발생(반드시 ON+조인조건 추가해야 하므로)
--조인결과 : 컬럼수(11) = 사원테이블의 컬럼수(8) + 부서테이블의 컬럼수(3)
--         행수(56) = 사원테이블의 행수(14) x 부서테이블의 행수(4)
--                 = 사원테이블의 사원 1명 당 x 부서테이블의 행수(4)

select eno --eno 컬럼만, 56개 전체 행수
from EMPLOYEE, DEPARTMENT;

select * --11개 컬럼, eno가 7369인 것만
from EMPLOYEE, DEPARTMENT
where eno = 7369;--(조인조건아님)검색조건

select eno --eno 컬럼만, 56개 전체 행수
from EMPLOYEE CROSS JOIN DEPARTMENT;

--1.2 조인의 유형
--오라클 8i이전 조인 : equi 조인(=등가 조인), non-equi 조인(=비등가 조인), outer 조인(왼쪽, 오른쪽), self 조인
--오라클 9i이후 조인 : cross 조인, natural 조인(=자연 조인), join~using, outer 조인(왼쪽, 오른쪽, full까지)
--(오라클 9i부터 ANSI 표준 SQL 조인 : 현재 대부분의 상용 데이터베이스 시스템에서 사용.
--                            다른 DBMS와 호환이 가능하기 때문에 ANSI 표준 조인에 대해서 확실히 학습하자.

-----<아래 4가지 비교>--------------------------------------------------------------------
--[해결할 문제] '사원번호가 7788'인 사원이 소속된 '사원번호, 사원이름, 소속부서번호, 소속부서이름' 얻기

--2.equi join(=등가조인=동일조인) : 동일한 이름과 유형(=데이터 타입)을 가진 컬럼으로 조인
--            단  방법-1 , ~ where 와  방법-2 join~on은 데이터 타입만 같아도 조인이 됨

--[방법-1 : , ~ where]
--동일한 이름과 데이터 유형을 가진 컬럼으로 조인 + "임의의 조건을 지정"하거나 "조인할 컬럼을 지정"할 때 where 절을 사용
--조인결과는 중복된 컬럼 제거X -> 따라서 테이블에 '별칭 사용'해서 어느 테이블의 컬럼인지 구분해야 함
select 컬럼명1, 컬럼명2...--중복되는 컬럼은 반드시 '별칭.컬럼명'(예)e.dno
from 테이블1 별칭1, 테이블2 별칭2--별칭 사용(별칭 : 해당 SQL명령문내에서만 유효함)
where ★조인조건(주의 : 테이블의 별칭 사용)
AND   ★검색조건
--★문제점 : 원하지 않는 결과가 나올 수 있다.(이유? AND -> OR의 우선순위 때문에)
--★문제점 해결법 : AND 검색조건 에서 '괄호()를 이용하여 우선순위 변경'
--예)부서번호로 조인한 후 부서번호가 10이거나 40인 정보 조회
--where e.dno=d.dno AND d.dno=10 OR d.dno=40;--문제 발생
--where e.dno=d.dno AND (d.dno=10 OR d.dno=40);--★해결법 : '괄호()를 이용하여 우선순위 변경'

--★★★ [장점] 이 방법은 outer join하기가 편리하다.
select *
from EMPLOYEE e, DEPARTMENT d 
where e.dno(+)=d.dno;--두 테이블에서 같은 dno끼리 조인(그러면 부서테이블의 40은 표시안됨. 따라서 (+)붙여 outer join)

select *
from EMPLOYEE e RIGHT OUTER JOIN DEPARTMENT d -- 오른쪽의 부서테이블의 40도 표시
ON e.dno=d.dno;

--[문제해결]
select eno, ename, e.dno, dname--별칭사용 : 두 테이블에 모두 존재하므로 구분하기 위해
from EMPLOYEE e, DEPARTMENT d
where e.dno=d.dno
AND eno = 7788;

--[방법-2 : (INNER)join ~ on]
--동일한 이름과 데이터 유형을 가진 컬럼으로 조인 + "임의의 조건을 지정"하거나 "조인할 컬럼을 지정"할 때 ON 절을 사용
--조인결과는 중복된 컬럼 제거X -> 따라서 테이블에 '별칭 사용'해서 어느 테이블의 컬럼인지 구분해야 함

select 컬럼명1, 컬럼명2...--중복되는 컬럼은 반드시 '별칭.컬럼명'(예)e.dno
from 테이블1 별칭1 JOIN 테이블2 별칭2--별칭 사용
ON    ★조인조건(주의 : 테이블의 별칭 사용)
where ★검색조건
--[방법-1]에서 나타난 문제가 발생하지 않으므로 검색조건에서 ()사용안해도 됨

--[문제해결]
select eno, ename, e.dno, dname--별칭사용 : 두 테이블에 모두 존재하므로 구분하기 위해
from EMPLOYEE e INNER JOIN DEPARTMENT d
ON e.dno=d.dno
WHERE eno = 7788;

-----------------------------[방법-1]과 [방법-2]는 문법적 특징이 동일하다.
-----------------------------               의 조인 결과 : 중복된 컬럼 제거x -> 테이블에 별칭 붙임
-----------------------------             ★  데이터 타입만 같아도 join 가능 (예)a.id=b.id2
----[테스트 위해 간단하게 테이블 생성하여 4가지 방법 비교]----------------------------------------------
drop table A;
drop table B;

create table A(
id number(2) primary key,--아이디
name varchar2(20),--이름
addr varchar2(100)--주소
);

insert into A values(10,'유재훈','대구 달서구');
insert into A values(20,'노석찬','대구 북구');

create table B(
id2 number(2) primary key,--아이디
tel varchar2(20)--연락처
);

insert into B values(10,'010-1111-1111');
insert into B values(30,'010-3333-3333');

select *
from A, B;

--[방법-1]
select *
from A a, B b
WHERE a.id=b.id2;--데이터 타입만 같아도 조인이 됨('같은 아이디라는 의미'이므로 조인)
--[방법-2]
select *
from A a JOIN B b
ON a.id=b.id2;--데이터 타입만 같아도 조인이 됨('같은 아이디라는 의미'이므로 조인)

--[방법-3]
select *
from A NATURAL JOIN B;--별칭 사용안함(권함)
--[결과] id와 id2는 이름이 다르므로 cross join결과와 같다.

select * from A, B;--cross join
select * from A join B;--오류 발생(JOIN~반드시 ON + 조인조건)

--[방법-4]
select *
from A JOIN B
USING(id);--오류발생 : USING(같은 컬럼명) id와 id2는 이름이 달라서 조인안됨

--테스트위해 
--B2 테이블 생성
create table B2(
id number(2) primary key,--아이디(A와 B2의 아이디가 같다.)
tel varchar2(20)--연락처
);

insert into B2 values(10,'010-1111-1111');
insert into B2 values(30,'010-3333-3333');

--C 테이블 생성
drop table C;

create table C(
id number(2) primary key,--아이디(A와 B2,C의 아이디가 같다.)
gender char(1)--'M' 또는 'F' ('남''여'는 추가안됨. 이유?1바이트보다 커서)
);

insert into C values(10, 'M');
insert into C values(20, 'M');
insert into C values(30, 'F');
insert into C values(40, 'F');

--C2 테이블 생성
create table C2(
tel varchar2(20) not null,--연락처(B2와 같다.)
hobby varchar2(20)--취미
);

insert into C2 values('010-1111-1111', '');
insert into C2 values('010-2222-2222', '축구');
insert into C2 values('010-3333-3333', '영화감상');

--[문제] 3개의 테이블 조인
--[방법-1]
--[방법-2]

--[방법-3] 
select *
from A NATURAL JOIN B2 NATURAL JOIN C;--별칭 사용안함(권함)
--세 테이블 모두 id가 있으므로 id로 조인
--먼저 A와 B2가 id로 조인 -> 조인된 결과 테이블의 id와 C의 id로 조인

--[문제]id, 이름, 주소, 연락처, 취미 구하기
select id, name, addr, tel, hobby
from A NATURAL JOIN B2 NATURAL JOIN C2;
--A과 B2테이블은 id로 조인한 결과 테이블과 C2테이블과 tel로 조인됨

--[문제]id, 이름, 주소, 연락처, 취미 구하기
--위 [문제]의 결과에 추가로 나머지 모두 표시하는 방법-1 : outer join 사용 [방법-2]
--[1]
select a.id, name, addr, tel
from A a JOIN B2 b2
ON a.id=b2.id;
--[2] 위 결과와 같다.     
SELECT id, name, addr, c2.tel, hobby--tel 반드시 별칭 사용
FROM (select a.id, name, addr, tel
      from A a JOIN B2 b2
      ON a.id=b2.id) ab2 JOIN C2 c2
ON ab2.tel=c2.tel;
--[3] outer join 이용하여 표시되지 않은 부분도 다 표시하기
select a.id, b2.id, name, addr, tel--a.id(10 20), b2.id(10 30)의 결과가 다르다.
from A a FULL OUTER JOIN B2 b2--두 테이블에 표시되지 않은 부분 다 표시됨
ON a.id=b2.id;--★★중복제거안함

SELECT ab2.id, name, addr, c2.tel, hobby--(오류발생)ab2.id는 a.id, b2.id 2개 중 어느 것인지 구분안됨
FROM (select a.id, b2.id,name, addr, tel
     from A a FULL OUTER JOIN B2 b2
     ON a.id=b2.id) ab2 FULL OUTER JOIN C2 c2
ON ab2.tel=c2.tel;

--[방법-4]
select *
from A JOIN B
USING(id);--오류발생 : USING(같은 컬럼명) id와 id2는 이름이 달라서 조인안됨
--[1]
select id, name, addr, tel
from A JOIN B2 --★★중복제거하므로 별칭 필요없음
USING(id);
--[2] 위 결과와 같다.
select id, name, addr, tel, hobby--tel에 별칭 사용불가
from (select id, name, addr, tel--id에 별칭 사용불가
     from A JOIN B2 --중복제거하므로 별칭 필요없음
     USING(id)) JOIN C2
USING(tel);
--위 [문제]의 결과에 추가로 나머지 모두 표시하는 방법-2 :[방법-4]에 outer join 이용
--[3]
select id, name, addr, tel--id(10 20 30)
from A FULL OUTER JOIN B2 --★★중복제거하므로 별칭 필요없음
USING(id);--★★중복제거하므로 하나의 id 컬럼값으로 합쳐짐 

select id, name, addr, tel, hobby
from (select id, name, addr, tel
	 from A FULL OUTER JOIN B2 --★★중복제거하므로 별칭 필요없음
	 USING(id)) FULL OUTER JOIN C2
USING(tel);

--위 결과에서 'id가 없는 사람 제외'하여 출력
select id, name, addr, tel, hobby
from (select id, name, addr, tel
	 from A FULL OUTER JOIN B2 --★★중복제거하므로 별칭 필요없음
	 USING(id)) FULL OUTER JOIN C2
USING(tel)
WHERE id is not null;

--위 [문제]의 결과에 추가로 나머지 모두 표시하는 방법-3 :[방법-1] , where => 결과 도출 못함(이유? (+)를 양쪽에 사용할 수 없다.)
--[1]
select a.id, name, addr, tel
from A a , B2 b2
WHERE a.id=b2.id;
--[2] 위 결과와 같다.     
SELECT id, name, addr, c2.tel, hobby--tel 반드시 별칭 사용
FROM (select a.id, name, addr, tel
      from A a , B2 b2
      WHERE a.id=b2.id) ab2 , C2 c2
WHERE ab2.tel=c2.tel;

--[3] (+) 이용하여 표시되지 않은 부분도 다 표시하기=>안됨
select a.id, b2.id, name, addr, tel--a.id(10 20), b2.id(10)
from A a, B2 b2
WHERE b2.id(+)=a.id;--(+)없는 쪽 테이블의 모든 부분 다 표시됨

select a.id, b2.id, name, addr, tel--a.id(10), b2.id(10 30)
from A a, B2 b2
WHERE a.id(+)=b2.id;--(+)없는 쪽 테이블의 모든 부분 다 표시됨

select a.id, b2.id, name, addr, tel--오류
from A a, B2 b2
WHERE a.id(+)=b2.id(+);--★★★주의 : 양쪽 안됨(오류)=>따라서, full outer join~on 또는 using으로 해결해야 함

SELECT id, name, addr, c2.tel, hobby--id:오류발생(ab2에 id가 2개이므로)
FROM (select a.id, b2.id, name, addr, tel--a.id(10), b2.id(10 30)
     from A a, B2 b2
     WHERE a.id(+)=b2.id) ab2 , C2 c2
WHERE ab2.tel(+)=c2.tel;

--[문제 수정] : 아이디(id)가 존재하는 고객만 모두 표시 => (+)이용하여 문제해결못함 -> full outer join~on 또는 using으로 해결해야 함
select a.id, b.id, name, addr, tel
from A a, B2 b2--★★★주의 : 양쪽 안됨(오류)
WHERE a.id(+)=b2.id(+);--10 20(A) 10 30(B2)

----[테스트 위해 간단하게 테이블 생성하여 4가지 방법 비교 끝]-----------------------------------------------------------------------


-----------------------------[방법-3] : 컬럼명이 다르면 cross join 결과가 나옴
-----------------------------[방법-4] : 컬럼명이 다르면 join 안됨(오류 발생)

--[방법-3 : natural join]
--조인결과는 중복된 컬럼 제거

--"자동으로" 동일한 이름과 데이터 유형을 가진 컬럼으로 조인(★단, 1개만 있을 때 사용하는 것을 권장)
--동일한 이름과 데이터 유형을 가진 컬럼이 없으면 CROSS JOIN이 됨
--★★ 자동으로 조인이 되나 문제가 발생할 수 있다.
-----> 문제 발생하는 이유 ? (예)EMPLOYEE의 dno와  DEPARTMENT의 dno : 동일한 이름(dno)과 데이터 유형(number(2))
--                                                       (★ 두 테이블에서 dno는 부서번호로 의미도 같다.)
--                    만약, EMPLOYEE의 manager_id(각 사원의 '상사'를 의미하는 번호)가 있고
--                       DEPARTMENT의 manager_id(그 부서의 '부장'을 의미하는 번호)가 있다고 가정했을 때
--                       둘 다 동일한 이름과 데이터 유형을 가졌지만 manager_id의 의미가 다르다면 원하지 않는 결과가 나올 수 있다.

select 컬럼명1, 컬럼명2...
from 테이블1 NATURAL JOIN 테이블2--별칭 사용안함(권장)
--★조인조건 필요없음
where ★검색조건

--[문제해결]
select eno, ename, e.dno, dname--dno는 중복 제거했으므로 e.dno d.dno 별칭사용=>[오류]
from EMPLOYEE e NATURAL JOIN DEPARTMENT d--별칭 사용으로 오류발생안함
WHERE eno = 7788;

select e.eno, e.ename, dno, d.dname--dno만 별칭 사용안됨
from EMPLOYEE e NATURAL JOIN DEPARTMENT d
WHERE e.eno = 7788;

select eno, ename, dno, dname
from EMPLOYEE NATURAL JOIN DEPARTMENT
WHERE eno = 7788;

--[방법-4 : join~using(★반드시 '동일한 컬럼명'만 가능)] ★다르면 오류발생
--조인결과는 중복된 컬럼 제거 -> 제거한 결과에  FULL outer join~using(id)하면 하나의 id로 합쳐짐
--동일한 이름과 유형을 가진 컬럼으로 조인(★조인 시 1개 이상 사용할 때 편리:가독성이 좋아서...)

select 컬럼명1, 컬럼명2...
from 테이블1 JOIN 테이블2--별칭 사용안함(권장)
USING(★조인조건)--USING(동일한 컬럼명1, 동일한 컬럼명2)
where ★검색조건

--[문제해결]
select eno, ename, d.dno, dname--d.dno:별칭사용하면 오류발생
from EMPLOYEE e JOIN DEPARTMENT d
USING(dno)
WHERE eno = 7788;

select eno, ename, dno, dname--dno:별칭사용하면 오류발생하여 별칭제거
from EMPLOYEE e JOIN DEPARTMENT d
USING(dno)
WHERE eno = 7788;

--★★만약 manager가 DEPARTMENT에 있다고 가정 후 아래 결과 유추
select eno, e.manager, dno, d.manager_id--별칭 사용하여 구분해야함
from EMPLOYEE e JOIN DEPARTMENT d--manager_id를 출력하려면 반드시 별칭 사용
USING(dno)--dno만 중복제거(★manager는 중복제거안함)
WHERE eno = 7788;

--※여러 테이블 간 조인할 경우 natural join과 join~using을 이용한 조인 모두 사용 가능하나
--가독성이 좋은 join~using을 이용하는 방법을 권한다.
-----------------------------[방법-3] : 컬럼명이 다르면 cross join 결과가 나옴
-----------------------------[방법-4] : 컬럼명이 다르면 join 안됨(오류 발생)

---------------------------<4가지 정리 끝>------------------------------

--3.non-equi join=비등가조인 : 조인조건에서 '=(같다)연산자 이외'의 연산자를 사용할 때
--						   (예) !=, >, <, >=, <=, between~and

--[문제] 사원별로 '사원이름, 급여, 급여등급' 출력
--[1] 급여등급 테이블 출력
select * from salgrade;
select * from employee;
--[2]. 사원별로 '사원이름, 급여, 급여등급' 출력
--사원이름, 급여:사원테이블,	  급여등급:급여정보 테이블
select ename, salary, grade
from employee JOIN salgrade--별칭사용안함(이유?중복되는 컬럼이 없으므로)
ON salary between losal and hisal;--비등가 조인조건

--[문제] 사원별로 '사원이름, 급여, 급여등급' 출력 + 추가조건: 급여가 1000미만이거나 2000초과
--[방법-2] 사용
select ename, salary, grade
from employee JOIN salgrade--별칭사용안함(이유?중복되는 컬럼이 없으므로)
ON losal <= salary and salary <= hisal--비등가 조인조건
where salary < 1000 or salary > 2000;--[검색조건] 추가

--[방법-1] 사용 : 정확한 결과가 안나옴
--이유: AND와 OR 함께 있으면 AND 실행후 OR 실행
--=> 해결법 : ()괄호 이용하여 우선순위 변경
select ename, salary, grade
from employee , salgrade--별칭사용안함(이유?중복되는 컬럼이 없으므로)
where losal <= salary and salary <= hisal--비등가 조인조건
AND salary < 1000 or salary > 2000;--[검색조건] 추가

--위 문제 해결한 SQL문
select ename, salary, grade
from employee , salgrade--별칭사용안함(이유?중복되는 컬럼이 없으므로)
where losal <= salary and salary <= hisal--비등가 조인조건
AND (salary < 1000 or salary > 2000);--[검색조건] 추가

--[문제] 3개의 테이블 조인하기
--'사원이름, 소속된 부서번호, 소속된 부서명, 급여, 몇 등급'인지 조회
--사원이름/급여/소속된 부서번호:사원 테이블, 소속된 부서번호/소속된 부서명:부서테이블, 몇 등급:급여정보 테이블
--사원테이블과 부서테이블은 동일한 컬럼이 있다. (소속된 부서번호 : dno)
--[1]. 사원테이블과 부서테이블은 '등가조인'
--[방법-1]
select ename, e.dno, dname, salary
from employee e, department d--별칭 사용
where e.dno=d.dno;
--[방법-2]
select ename, e.dno, dname, salary
from employee e JOIN department d--별칭 사용
ON e.dno=d.dno;

--[2]. 등가조인한 결과 테이블과 급여정보 테이블은 '비등가조인'
select ename, dno, dname, salary, grade--d.dno 별칭사용 안됨
from salgrade JOIN (select ename, e.dno, dname, salary
					from employee e JOIN department d--별칭 사용
					ON e.dno=d.dno)
ON salary BETWEEN losal AND hisal;--비등가조인

----------------------------------------------------------------

--4. self join : 하나의 테이블에 있는 컬럼끼리 연결해야 하는 조인이 필요한 경우
select * from employee;

--[문제] 사원이름과 직속상관이름 조회
select *
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno--'KING'은 직속상관이 NULL이므로 등가조인에서 제외됨
order by 1;

select e.ename as "사원 이름", m.ename as "직속상관이름"
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno--'KING'은 직속상관이 NULL이므로 등가조인에서 제외됨
order by 1;

select e.ename || '의 직속상관은' || m.ename
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno--'KING'은 직속상관이 NULL이므로 등가조인에서 제외됨
order by 1;

--'SCOTT'란 사원의 '매니저 이름(=직속상관이름)'을 검색
select e.ename || '의 직속상관은' || m.ename
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno--'KING'은 직속상관이 NULL이므로 등가조인에서 제외됨
where LOWER(e.ename)='scott';
--e.ename의 값을 하나하나 소문자로 변경 후 'scott'과 같은 것 찾기

---------------------------------------------------------

--5. outer join
--equi join(=등가조인)의 조인조건에서 기술한 컬럼에 대해 두 테이블 중 어느 한쪽 컬럼이라도
--null이 저장되어 있으면 '='의 비교결과가 거짓이 됩니다.
--그래서 null값을 가진 행은 조인 결과로 얻어지지 않음
select e.ename || '의 직속상관은' || m.ename
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno;--조인조건('KING'은 직속상관이 NULL이므로 등가조인에서 제외됨)

select e.ename || '의 직속상관은' || m.ename
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno--조인조건:null은 비교연산자(=, !=, >, <=) 로 비교할 수 없다.
WHERE e.ename='KING';--오류는 없지만 검색결과가 없음
--사원이름이 'KING' 검색

select e.ename || '의 직속상관은' || m.ename
from employee e inner JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno
WHERE m.ename='KING';
--직속상관이름이 'KING'인 사원의 이름 3명 검색

--위 방법으로는 null값 표현할 수 없다.[아래 방법으로 해결]
--[방법-1] null값도 표현하기 위한 해결방법 : 조인조건에서 null값을 출력하는 곳에 (+)
--주의 : (+)도 한쪽만 사용가능(left/right), 즉 full 안됨
select e.ename || '의 직속상관은' || m.ename
from employee e , employee m--반드시 별칭 사용
WHERE e.manager=m.eno(+);

--[방법-2] null값도 표현하기 위한 해결방법 : (left/right/full) outer join
select e.ename || '의 직속상관은' || NVL(m.ename, ' 없다')
from employee e LEFT OUTER JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno;


--<6장 테이블 조인하기-혼자해보기>-----------------------------

--1.EQUI 조인을 사용하여 SCOTT 사원의 부서번호와 부서이름을 출력하시오.
select e.dno, dname
from employee e join department d
on e.dno=d.dno
where ename='SCOTT';

--방법-1
select e.dno, dname
from employee e, department d
where e.dno=d.dno--조인조건
and ename='SCOTT';--검색조건
--and LOWER(ename)='scott';--검색조건

--2.(INNER) JOIN과 ON 연산자를 사용하여 사원이름과 함께 그 사원이 소속된 부서이름과 지역명을 출력하시오.
select ename, dname, loc
from employee e join department d
on e.dno=d.dno;

--사원이름:사원 테이블, 부서이름/지역명:부서테이블
--[방법-2]
select ename, dname, loc
from employee e join department d
on e.dno=d.dno;--조인조건

--3.(INNER) JOIN과 USING 연산자를 사용하여 10번 부서에 속하는 모든 담당 업무의 고유 목록
--(한 번씩만 표시)을 부서의 지역명을 포함하여 출력하시오.
select dno, ename, job, dname, loc
from employee e join department d
using (dno)
where dno='10';

--업무=job:사원테이블, loc:부서테이블
--[방법-4]
select dno, job, loc
from employee join department--중복제거->별칭필요없음
using (dno)--조인조건
where dno='10';--검색조건

--4.NATURAL JOIN을 사용하여 커미션을 받는 모든 사원의 이름, 부서이름, 지역명을 출력하시오.
select ename, dname, loc, commission
from employee natural join department
where commission>0;

--사원이름:사원 테이블, 부서이름/지역명:부서테이블
select ename, dname, loc
from employee natural join department--자동 : 같은 dno로 조인 후 중복 제거
where commission is not null;

--5.EQUI 조인과 WildCard를 사용하여 '이름에 A가 포함'된 모든 사원의 이름과 부서이름을 출력하시오.
select ename, dname
from employee e join department d
on e.dno=d.dno
where ename like '%A%';

--[방법-4]
select ename, dname
from employee join department
using(dno)
where ename like '%A%';--A__, _A_, __A

--6.NATURAL JOIN을 사용하여 NEW YORK에 근무하는 모든 사원의 이름, 업무, 부서번호, 부서이름을 출력하시오.
select ename, job, dno, dname
from employee natural join department
where loc = 'NEW YORK';

--사원의 이름/업무/부서번호:사원테이블, 부서번호/부서이름:부서테이블
select ename, job, dno, dname
from employee natural join department
where loc='NEW YORK';
--where lower(loc)='new york';

--7.SELF JOIN을 사용하여 사원의 이름 및 사원번호를 관리자 이름 및 관리자 번호와 함께 출력하시오.
select e.ename, e.eno, m.ename, m.eno
from employee e join employee m
on e.manager=m.eno;

--[방법-1]
select e.ename, e.eno, m.ename, m.eno--★★반드시 별칭
from employee e, employee m
where e.manager = m.eno;--KING 제외됨

--8.'7번 문제'+ OUTER JOIN, SELF JOIN을 사용하여 '관리자가 없는 사원'을 포함하여 사원번호를
--기준으로 내림차순 정렬하여 출력하시오.
select e.ename, e.eno, m.ename, m.eno
from employee e left outer join employee m
on e.manager=m.eno
order by e.eno desc;

--관리자가 없는 사원 : 'KING'
--[방법-1]
select e.ename, e.eno, m.ename, m.eno--★★반드시 별칭
from employee e, employee m
where e.manager = m.eno(+)--제외된 'KING'을 표시
order by 2 desc;

--[방법-2]
select e.ename, e.eno, m.ename, m.eno
from employee e left outer join employee m
on e.manager=m.eno--제외된 'KING'을 표시 (모든 사원을 다 표시하려면 왼쪽 테이블)
order by 2 desc;

--9.SELF JOIN을 사용하여 지정한 사원의 이름('SCOTT'), 부서번호, 지정한 사원과 동일한 부서에서 
--근무하는 사원이름을 출력하시오.
--단, 각 열의 별칭은 이름, 부서번호, 동료로 하시오.
select e.ename, e.dno, c.ename, c.dno
from employee e join employee c
on e.dno=c.dno
where e.ename='SCOTT' and c.ename!='SCOTT';

--[방법-1]
select *
from employee e, employee m
where e.dno = m.dno--조인조건 : 동일한 부서로 조인
order by 1 asc;

select e.ename as "이름", e.dno as "부서번호", c.ename as "동료"--★★반드시 별칭
from employee e, employee c
where e.dno=c.dno--조인조건
and (e.ename = 'SCOTT' and c.ename != 'SCOTT');--검색조건

--10.SELF JOIN을 사용하여 WARD 사원보다 늦게 입사한 사원의 이름과 입사일을 출력하시오.
--(입사일을 기준으로 오름차순 정렬)
select c.ename, c.hiredate
from employee e join employee c
on e.hiredate<c.hiredate 
where e.ename='WARD'
order by hiredate;

--[join 방법-1]--------------------------------------------
--해결법-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m;--cross join : 14*14=196
where e.ename='WARD';--cross join 결과에서 검색 : 14

select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m--cross join => 조인 조건이 없다
where e.ename='WARD' and e.hiredate < m.hiredate--검색조건
order by m.hiredate asc;

--해결법-2:주쿼리, 서브쿼리 사용
--[1]. 먼저 'WARD'의 입사일 구하기
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select ename, hiredate
from employee
where hiredate > (select hiredate
				 from employee
				 where ename='WARD')
order by 2 asc;

--해결법-3
--[1]. 먼저 'WARD'의 입사일 구하기
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select c.ename, c.hiredate
from (select hiredate
	 from employee
	 where ename='WARD') e, employee c
where e.hiredate < c.hiredate--검색조건
order by 2 asc;
--order by c.hiredate asc;

--[조인 방법-2]--------------------------------------------
--해결법-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e join employee m
on e.ename='WARD';--join 결과에서 검색 : 14

--해결법-1-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e join employee m--cross join => 조인 조건이 없다
on e.ename='WARD' 
where e.hiredate < m.hiredate--검색조건
order by m.hiredate asc;

--해결법-1-2
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e join employee m--cross join => 조인 조건이 없다
on e.ename='WARD' and e.hiredate < m.hiredate--조인조건
order by m.hiredate asc;

--해결법-3
--[1]. 먼저 'WARD'의 입사일 구하기
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select distinct c.ename, c.hiredate
from employee c join employee e
on c.hiredate > (select hiredate
				from employee
				where ename='WARD')--검색조건
order by 2 asc;
--order by c.hiredate asc;

--11.SELF JOIN을 사용하여 관리자보다 먼저 입사한 모든 사원의 이름 및 입사일을 
--관리자 이름 및 입사일과 함께 출력하시오.(사원의 입사일을 기준으로 정렬)
--[조인 방법-1]--------------------------------------------
select e.eno, e.ename, e.manager, e.manager, m.eno, m.ename, m.hiredate
from employee e , employee m-- 196개 출력
where e.manager=m.eno-- 13개
and e.hiredate<m.hiredate--6개 출력
order by e.hiredate asc;--3=e.hiredate 도 가능

select e.ename AS "사원이름", e.hiredate AS "사원입사일",
		m.ename AS "관리자이름", m.hiredate AS "관리자입사일"
from employee e , employee m-- 196개 출력
where e.manager=m.eno-- 13개
and e.hiredate<m.hiredate--6개 출력
order by e.hiredate asc;--3=e.hiredate 도 가능

--[조인 방법-2]--------------------------------------------
select e.ename AS "사원이름", e.hiredate AS "사원입사일",
		m.ename AS "관리자이름", m.hiredate AS "관리자입사일"
from employee e join employee m-- 196개 출력
on e.manager=m.eno-- 13개
where e.hiredate<m.hiredate--6개 출력
order by e.hiredate asc;--3=e.hiredate 도 가능
