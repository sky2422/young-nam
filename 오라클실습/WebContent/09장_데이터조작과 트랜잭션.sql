--<북스-9장_데이터조작과 트랜잭션>

--데이터 조작어(DML : Data Manipulation Language)
--1. INSERT: 데이터 입력
--2. UPDATE: 데이터 수정
--3. DELETE: 데이터 삭제
--위 작업 후 반드시 commit;(영구적으로 데이터 저장)

--1. INSERT: 데이블에 내용 추가
--문저(char, varchar2)와 날짜 (date)는 ''를 사용

--실습위해 기존의 '부서테이블의 구조만 복사'(제약조건 복사 안 된다. not null 제약 조건만 복사 된다.)
create table dept_copy--dno(PK가 아니므로 같은 dno가 여러개 추가 가능 )
AS
select * from DEPARTMENT--dno(PK=not null+unique)
where 0=1;--조건이 무조건 거짓

--RUN SQL... 창에서 
desc dept_copy;--데이터 구조 확인
insert into dept_copy values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept_copy (dno, loc, dname)--3
			values(20, 'DALLAS', 'RESEARCH');--3
			

commit;--이클립스에서는 자동 commit되어 명령어가 실행안된다.
-----------> RUN SQL... 또는 SQL Developer에서 실행	

--아래 delete는 결과를 수정하기 위한 것들이다.
delete from dept_copy where loc='뉴욕';
delete dept_copy where dno=30;

--1.1 NULL값을 갖는 ROW 삽입
--문자나 날짜 타입은 NULL 대신 '' 사용가능
--제약조건이 복사되지 않는다. 아래 3개 다 같은 형식이다.
insert into dept_copy (dno,dname) values (30, 'SALES');--제약조건이 복사되지 않는다. null값을 허용하여 loc에 null이 저장된다.
--default '대구' 지정되어 있으면 loc에 '대구' 입력된다.(데이터 삽입하기 전에 미리 default 지정해야 함)
insert into dept_copy values (40, 'OPERATIONS', NULL);--3:3
insert into dept_copy values (50, 'COMPUTION', '');--3:3
--commit; 영구적으로 데이터 저장
select * from dept_copy; 

--[실습위해 기본 사원테이블 구조만 복사] (제약조건 복사안된다. not null제약조건만 복사된다.)
create table emp_copy
AS
select eno, ename, job, hiredate, dno 부서번호
from employee
where 0=1;

select *from emp_copy;--구조만 복사된 상황이다.

insert into emp_copy values(7000,'캔디','MANAGER','2021/12/20',10);
--날짜 기본형식: 'YY/MM/DD'
insert into emp_copy values(7010,'톰','MANAGER',to_date('2021,06,01','YYYY,MM,DD'),20);
insert into emp_copy values(7020,'제리','SALESMAN', sysdate, 30);
--sysdate: system으로 부터 현재 날짜 데이터를 반환하는 함수(주의: 괄호()가 없는 것이 특징이다.)
select * from emp_copy;

--1.2 다른 테이블에서 데이터 복사하기
--INSETY INTO + 다른 테이블의 서브쿼리 결과 데이터 복사
--단, 컬럼수= 컬럼수

--실습위해 기본 부서테이블 구조만 복사(제약조건 복사안된다. not null제약조건만 복사된다.)
DROP TABLE dept_copy;--기존 dept_copy 삭제 후

create table dept_copy--dept_copy 테이블 생성
AS
select * from department
where 0=1;

select * from dept_copy;

--예: 서브쿼리로 다른 행 입력하기
INSERT INTO dept_copy--department의 컬럼수와 dept_copy의 데이터타입이 같아야한다.
select * from department;

select * from dept_copy;

--------------------------------------------------------------------------------------
--2. UPDATE: 테이블의 내용 수정
--where절 생략: 테이블의 모든 행 수정된다.
UPDATE dept_copy
set dname='programming'
where dno=10;

select * from dept_copy;

--컬럼값 여러개를 한 번에 수정하기
UPDATE dept_copy
set dname='accounting', loc='서울'
where dno=10;

--update문의 set절에서 서브쿼리를 기술하면 서브쿼리를 수행한 결과로 내용이 변경된다.
--즉, 다른 테이블에 저장된 데이터로 해당 컬럼 값 변경 가능

--예: 10번 부서의 지역명을 20번 부서의 지역으로  변경 (서브쿼리를 이용했다.)
--[1] 20번 부서의 지역명 구하기
select loc
from dept_copy
where dno=20;--'DALLAS'
--[2]
update dept_copy
SET loc = (select loc
			from dept_copy
			where dno=20)
where dno = 10;

select loc from dept_copy where dno=10;

--예: 10번 부서의 '부서명과 지역명'을 30번 부서의 '부서명과 지역명'으로 변경
--[1] 30번 부서의 '부서명과 지역명'구하기
select dname from dept_copy where dno =30;--'SALES'
select loc from dept_copy where dno =30;--'NULL'

--[2]
update dept_copy
SET dname = (select dname from dept_copy where dno =30),
	loc=(select loc from dept_copy where dno =30)
where dno = 10;

select * from dept_copy;

--------------------------------------------------------------------------------------

--3. DELETE문: 테이블의 내용 삭제
--where 절 생략: 모든 행 삭제

delete from dept_copy--from 생략가능하다.
where dno=10;

select * from dept_copy;

delete from dept_copy;--모든 행 삭제
select * from dept_copy;

--실습위해 사원테이블의 구조와 데이터복사 ---> 새 테이블 생성(제약조건은 복사가 안된다.)
DROP TABLE emp_copy;

CREATE TABLE emp_copy
AS
select *
from employee;

select * from emp_copy;

--예: emp_copy 테이블에서 '영업부(SALES)'에 근무하는 사원 모두 삭제
--[1]'부서테이블에서' 영업부(SALES)의 부서번호 구하기
select dno
from department
where dname ='SALES';--30
--[2]emp_copy 테이블에서 구한 부서번호와 같은 부서번호를 가진 사원을 삭제
delete from emp_copy
where dno=(select dno
		from department
		where dname ='SALES');

delete from emp_copy
where dno=30;

select * from emp_copy;

-----------------------------------------------------------------------
--★★ 이클립스는 자동 commit되어 수동으로 환경설정 후 테스트하기

--4.트랜잭션 관리
--오라클은 트랙잰션 기반으로 데이터의 일관성을 보장함
--예: 두 계좌
--'출금계자의 출금금액'과 '입금계좌의 입금금액'이 동일해야 함
--update				insert
--반드시 두 작업은 함께 처리되거나 함께 취소
--출금처리는 되었는데 입금처리가 되지 않았다면 데이터 일관성을 유지 못함

--[트랜지션 처리요건]: ALL - OR -Nothing 반드시 처리 되든지 안되든지 
--					데이터의 일관성을 유지, 안정적으로 데이터 복구

--commit: 데이터추가, 수정, 삭제 등 실행됨과 동시에 트랜잭션이 진행된다.
--			성공적으로 변경된 내용 영구 저장하기 위해 반드시 commit

--rollback: 작업을 취소
--			트랜잭션으로 인한 하나의 묶음 처리가 시작되기 이전 상태로 되돌린다.

--실습위해 기존 부서 테이블의 구조와 데이터 복사 ---> 새 테이블 (제약조건 복사안된다. Not Null 제외)
drop table dept_copy;

create table dept_copy
AS
select * from department;

select * from dept_copy;

--★★ 여기서부터는 RUN SQL ~ 에서 테스트 하기
delete dept_copy;--모든 row 다 삭제된다.
select* from dept_copy;--확인

rollback;--이전으로 되돌림(commit하기 전에)
select* from dept_copy;--확인:모든 row 다 나타난다.

--10번 부서만 삭제 ---> savepoint로 이 지점을 d10이름으로 저장
delete dept_copy where dno=10;
savepoint d10;

--20번 부서만 삭제
delete dept_copy where dno=20;

--30번 부서만 삭제
delete dept_copy where dno=30;

--d10지점으로 되돌림(198라인으로 되돌아 간다라는 뜻이다.)
rollback to d10;

commit;--영구 저장된다.

--다시 20번 부서만 삭제
delete dept_copy where dno=20;

--이전으로 되돌릴수 있다.
rollback;

--<9장 데이터조작과 트랜잭션 혼자 해보기>-----------------------------

--1.EMPLOYEE 테이블의 구조만 복사하여 EMP_INSERT란 이름의 빈 테이블을 만드시오.
create table emp_table
AS
select * from employee 
where 1=0;

select * from dept_copy2;

--2.본인을 EMP_INSERT 테이블에 추가하되 SYSDATE를 이용하여 입사일을 오늘로 입력하시오.
insert into EMP_INSERT
values (9090,'홍길동','ANALYST',null, sysdate , 3000, null,10 );

--3.EMP_INSERT 테이블에 옆 사람을 추가하되 TO_DATE 함수를 이용하여 입사일을 어제로 입력하시오.
insert into emp_table
values TO_DATE('20220105')

--4.EMPLOYEE 테이블의 구조와 내용을 복사하여 EMP_COPY_2란 이름의 테이블을 만드시오.
create table emp_copy
AS
select from employee;

--5.사원번호가 7788인 사원의 부서번호를 10번으로 수정하시오.
update emp_copy2
set dno=10
where eno=7788;

--6.사원번호가 7788의 담당 업무 및 급여를 사원번호 7499의 담당 업무 및 급여와 일치하도록 갱신하시오.
select job, salary
from emp_copy
where eno=7788;

update emp_copy2
set job= (select job, salary from emp_copy2 where eno=7499),
	salary =(select job, salary from emp_copy2 where eno=7499)
where eno=7788;

--7.사원번호 7369와 업무가 동일한 모든 사원의 부서번호를 사원 7369의 현재 부서번호로 갱신하시오.
--[1] 사원번호 7369와 업무구하기, 부서번호 구하기
select dno from emp_copy2 where eno=7369;
select job from emp_copy2 where eno=7369;
--[2]
update emp_copy2
set dno(select dno from emp_copy2 where eno=7369)--부서번호를 7369의 부서번호로 갱신
where job=(select job from emp_copy2 where eno=7369);--사원번호 7369와 업무가 동일한 사원만 찾아서

--8.DEPARTMENT 테이블의 구조와 내용을 복사하여 DEPT_COPY_2란 이름의 테이블을 만드시오.
create table dept_copy2
AS
select * from department;

select * from dept_copy2;

--9.DEPT_COPY_2 테이블에서 부서명이 RESEARCH인 부서를 제거하시오.
delete table dept_copy2
where dname= 'RESEARCH';

--10.DEPT_COPY_2 테이블에서 부서번호가 10이거나 14인 부서를 제거하시오.
--[방법-1]
delete table dept_copy2
where dno IN(10, 14);

--[방법-2]
delete table dept_copy2
where dno=10 OR dno=14;
