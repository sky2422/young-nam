---<북스 11장_뷰>

--1. 뷰: 하나이상의 테이블이나 다른 뷰를 이용하여 생성되는 '가상테이블'
--즉, 실질적으로 데이터를 저장하지 않고 데이터 사전에 뷰를 정의할 때 기술한 '쿼리문만 저장'

--뷰를 정의하기 위해 사용된 테이블: 기본 테이블
--뷰는 별도의 기억 공간이 존재하지 않기 때문에 뷰에 대한 수정 결과는
--뷰를 정의한 기본 테이블에 적용된다.

--반대로 기본테이블의 데이터 변경되면 뷰에 반영된다. 뷰를 수정하더라도 기본테이블은 변경되지 않는다.
--뷰를 정의한 기본테이클의 '무결성 제약조건' 역시 상속된다.
--뷰의 정의를 조회하려면: user_viewS 데이터 사전이다.

--뷰는 '복잡한 쿼리를 단순화' 시킬수 있다.
--뷰는 사용자에게 필요한 정보만 접근하도록 '접근을 제한' 할 수 있다.

--1.1 뷰 생성
--※대괄호([ ])의 항목은 필요하지 않을 경우 생략이 가능하다.
create [or replace] [FORCE|NOFORCE(기본값)]
VIEW 뷰이름[(컬럼명1, 컬럼명2,...): 기본테이블의 컬럼명과 다르게 지정할 경우 사용한다. ※순서와 개수를 맞춰야 한다.]
AS 서브쿼리
[WITH CHECK OPTION [constraint 제약조건명]]
[WITH READ ONLY];--select문만 가능, DML(데이터 조작어: 변경 INSERT, UPDATE, DELETE) 불가

--or replace: 해당 구문을 사용하면 뷰를 수정할 때 DROP 없이 수정이 가능하다.

--FORCE: 뷰를 생성할 때 쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않아도 생성 가능하다.
--		  즉, 기본테이블의 존재 유무에 상관없이 뷰 생성된다.

--NOFORCE: 뷰를 생성할 때  쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않으면 생성되지 않는다.
--		      반드시 기본 테이블이 존재할 경우에만 뷰 생성
--		      지정하지 않으면 NOFORCE를 사용한다.

--WITH CHECK OPTION: WHERE 절의 조건에 해당하는 데이터만 저장, 변경이 가능하다.
--WITH READ ONLY: select문만 가능, DML(=데이터 조작어: 변경 INSERT, UPDATE, DELETE) 불가

--컬럼명을 명시하지 않으면 기본 테이블의 컬럼명을 상속한다.
--<컬럼명 반드시 명시해야 하는 경우>
--[1] 컬럼이 산술식, 함수, 상수에서 파생된 경우
--[2] join 때문에 둘 이상의 컬럼이 같은 이름을 갖는 경우
--[3] 뷰의 컬럼이 파생된 컬럼과 다른 이름을 갖는 경우 

--1.2 뷰의 종류
--[1] 단순 뷰: 하나의 기본테이블로 생성한 뷰
--			 DML 명령문의 처리 결과는 기본 테이블에 반영된다.
--			 단순 뷰는 단일 테이블에 필요한 컬럼을 나열한 것이다.
--			 그래서 JOIN, 함수 GROUP BY, UNION 등을 사용하지 않는다.
--			 단순 뷰는 SELECT + INSERT, UPDATE, DELETE를 자유롭게 사용 가능하다.

--[2] 복합 뷰: 두 개 이상의 기본테이블로 생성한 뷰
--			 DISTINCT, 그룹함수, rownum을 포함해서 사용할 수 없다.
--			 복합 뷰는 JOIN, 함수, GROUP BY, UNION 등을 사용하여 뷰를 생성할 수 있다.
--			 함수 등을 사용할 경우 '컬럼 별칭'은 꼭 부여해야 한다.(예: AS hiredate)
--			 복합 뷰는 SELECT는 사용 가능하지만  INSERT, UPDATE, DELETE는 상황에 따라서 가능하지 않을 수도 있다.

--<실습을 위해 새로운 테이블 2개 생성>
create table emp11
as
select * from employee;

create table dept11
as
select * from department;
--테이블 구조와 데이터만 복사(★단, 제약조건은 복사가 안된다.)

--[1] 단순 view(예)
create view v_emp_job(사원번호, 사원명, 부서번호, 담당업무)
as 
select eno, ename, dno, job
from emp11
where job like 'SALESMAN';

select * from v_emp_job;

create view v_emp_job2--서브쿼리(기본테이블)의 컬럼명이 그대로 복사
as 
select eno, ename, dno, job
from emp11
where job like 'SALESMAN';

select * from v_emp_job2;

create view v_emp_job2
as 
select eno, ename, dno, job
from emp11
where job like 'MANAGER';
--실패: 같은 이름의 view가 존재하기 때문이다.

--OR REPLACE: 이미 존재하는 view는 내용을 새롭게 변경하여 재생성
--			  존재하지 않는 뷰는 뷰를 새롭게 생성
--따라서, create OR REPLACE view로 사용하여 융통성 있는 view 생성하는 것을 권장한다.
create OR REPLACE view v_emp_job2
as 
select eno, ename, dno, job
from emp11
where job like 'MANAGER';

select * from v_emp_job2;
--OR REPLACE로 MANAGER로 변경된 정상적인 값이 출력된다.

--[2] 복합 view(예)
create OR REPLACE view v_emp_dept_complex
as
select *
from emp11 natural join dept11
order by dno asc;

select * from v_emp_dept_complex;

--양쪽 테이블에서 조건에 맞지 않는 row도 모두 추가한다. 
create OR REPLACE view v_emp_dept_complex
as
select *
from emp11 e full outer join dept11 d
using(dno)--중복제거
order by dno asc;

select * from v_emp_dept_complex;

--1.3 view의 필요성
--뷰를 사용하는 이유는 '보안'과 '사용의 편의성' 때문
--[1] 보안: 전체 데이터가 아닌 '일부만 접근' 하도록 뷰를 정의하면
--			일반 사용자에게 해당 뷰만 가능하도록 허용하여
--			중요한 데이터가 외부에 공개되는 것을 막을 수 있다.
--(예: 사원테이블의 급여나 커미션은 개인적인 정보이므로 다른 사원들의 접근 제한해야 한다.)

--즉, 뷰는 복잡한 쿼리를 단순화 시킬수 있다.
--	  뷰는 사용자에게 필요한 정보만 접근하도록 접근을 제한 할 수 있다.

--예: 사원테이블에서 '급여와 커미션을 제외'한 나머지 컬럼으로 구성된 뷰 생성
select * from emp11;

create OR REPLACE view v_emp_sample
as
select eno, ename, job, manager, hiredate, dno--salary, commissoin은 제외
from emp11;

select * from v_emp_sample;

--[2] 사용의 편의성: '정보접근을 편리'하게 하기 위해 '뷰를 통해'
--					사용자에게 '필요한 정보만 선택적으로 제공'한다.
--'사원이 속한 부서에 대한 정보'를 함께 보려면 사원 테이블과 부서테이블을 조인해야한다.
--하지만 이를 뷰로 정의해 두면 '뷰를 마치 테이블처럼 사용'하여 원하는 정보를 얻을 수 있다.
create OR REPLACE view v_emp_dept_complex2
as
select eno, ename, dno, dname, loc--선택적으로
from emp11 natural join dept11 
order by dno asc;

select * from v_emp_dept_complex2;
--뷰를 통해 복잡한 조인문을 사용하지 않고 정보를 쉽게 얻을수 있다.

--1.4. 뷰의 처리 과정
select view_name, text
from USER_viewS;

--USER_viewS 데이터 사전에 사용자가 생성한 '모든 뷰에 대한 정의'를 저장
--뷰는 select 문에 이름을 붙인것
--[1] 뷰에 질의를 하면  오라클 서버는 USER_viewS에서 뷰를 찾아 서브쿼리문을 실행시킨다.
--[2] '서브쿼리문'은 기본테이블을 통해 실행된다.

--뷰는 select문으로 기본 테이블을 조회하고
--DML(INSERT, UPDATE, DELETE)문으로 기본테이블을 변경 가능하다.
--(단, 그룹함수를 가상컬럼으로 갖는 뷰는 DML 사용못한다.)
select * from emp11;--기본테이블 emp11(★제약조건은 복사가 안되어 있는 상황이다.)
select * from v_emp_job;--기본테이블 emp11(★제약조건은 복사가 안된다.)

insert into v_emp_job values(8000, '홍길동', 30, 'SALESMAN');
--★주의: 뷰 정의에 포함되지 않는 컬럼 중에 '기본 테이블의 컬럼이  not null 제약조건이 지정되어 있는 경우'
--insert 사용이 불가능하다.

--insert 확인하면
select * from emp11;--기본테이블(★제약조건은 복사가 안되어 있는 상황이라 같은 eno 8000이 추가되어있다.)

insert into v_emp_job values(9000, '이길동', 30, 'MANAGER');--성공
select * from v_emp_job;--뷰 조회에는 존재하지 않는다.
--이유: 서브쿼리의 where절:  job이 'SALESMAN'으로 생성했기 때문이다.

select * from emp11;--기본테이블에는 존재한다.

--1.5 다양한 뷰
--함수 사용하여 뷰 생성 가능
--★주의: 그룹함수는 물리적인 컬럼이 존재하지 않고 결과를 가상컬럼처럼 사용한다.
--		가상컬럼은 기본테이블에서 컬럼명을 상속받을수 없기 때문에 반드시 '별칭 사용'해야한다.
create OR replace view v_emp_salary
as
select dno, sum(salary), avg(salary)--실패: must name this expression with a column alias
from emp11
group by dno;

create OR replace view v_emp_salary
as
select dno, sum(salary) AS "sal_sum", avg(salary) AS "sal_avg"--오류해결: 별칭사용
from emp11
group by dno;

select * from v_emp_salary;

select * from emp11;

--예: 그룹함수를 가상컬럼으로 갖는 뷰는 DML 사용 못한다.
insert into v_emp_salary values(50, 2000, 200);--실패: virtual column not allowed here

/*
 * 단순 뷰에서 DML 명령어 사용이 불가능한 이유?
 * 1. 뷰 정의에 포함되지 않은 컬럼 중에 기본 테이블의 컬럼이 NOT NULL 제약조건이 지정되어 있는 경우 INSERT문 사용이 불가능하다.
 * 왜냐하면 뷰에 대한 INSERT문은 기본 테이블의 뷰정의에 포함되지 않는 컬럼에 NULL값을 입력하는 형태가 되기 때문이다.
 * 2. salary*12와 같이 산술 표현식으로 정의된 가상 컬럼이 뷰에 정의되면 INSERT나 UPDATE가 불가능하다.
 * 3. DISTINCT를 포함한 경우에도 DML 명령 사용이 불가능하다.
 * 4. 그룹함수나 GROUP BY절을 포함한 경우도 DML 명령 사용이 불가능하다.
 */
--1.6 뷰 제거
--뷰를 제거한다는 것은 USER_viewS 데이터 사전에 뷰의 정의 제거
DROP VIEW v_emp_salary;

select view_name, text
from USER_viewS
where view_name IN ('V_EMP_SALARY');--삭제되어 결과가 공백으로 나온다.

--2. 다양한 뷰 옵션
--※대괄호([ ])의 항목은 필요하지 않을 경우 생략이 가능하다.
create [or replace] [FORCE|NOFORCE(기본값)]
VIEW 뷰이름[(컬럼명1, 컬럼명2,...): 기본테이블의 컬럼명과 다르게 지정할 경우 사용한다. ※순서와 개수를 맞춰야 한다.]
AS 서브쿼리
[WITH CHECK OPTION [constraint 제약조건명]]
[WITH READ ONLY];--select문만 가능, DML(데이터 조작어: 변경 INSERT, UPDATE, DELETE) 불가

--or replace: 해당 구문을 사용하면 뷰를 수정할 때 DROP 없이 수정이 가능하다.

--FORCE: 뷰를 생성할 때 쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않아도 생성 가능하다.
--		  즉, 기본테이블의 존재 유무에 상관없이 뷰 생성된다.

--NOFORCE: 뷰를 생성할 때  쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않으면 생성되지 않는다.
--		      반드시 기본 테이블이 존재할 경우에만 뷰 생성
--		      지정하지 않으면 NOFORCE(기본값)를 사용한다.

--WITH CHECK OPTION: WHERE 절의 조건에 해당하는 데이터만 저장(=insert), 변경(=update)이 가능하다.
--WITH READ ONLY: select문만 가능, DML(=데이터 조작어: 변경 INSERT, UPDATE, DELETE) 불가

--2.1 OR REPLECE

--2.2 FORCE
--FORCE 옵션을 사용하면 쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않을 경우 (즉, 기본테이블이 존재하지 않는다.)
--'오류발생없이'뷰는 생성되지만. INVALID 상태이기 때문에 뷰는 동작하지 않는다.
--(즉, USER_viewS 데이터 사전에 등록되어 있지만 기본테이블이 존재하지 않는다.)
--오류가 없으면 정상적으로 뷰가 생성된다.
create or replace view v_emp_notable
as
select eno, ename, dno, job
from emp_notable;--기본테이블이 존재하지 않는다.(기본값 NOFORCE)---> 오류 해결하려면 FORCE 추가해야한다.
where job like 'MANAGER';

drop view v_emp_notable;

create or replace force view v_emp_notable--성공
as
select eno, ename, dno, job
from emp_notable
where job like 'MANAGER';


select view_name, text
from user_viewS
where view_name =upper('v_emp_notable');
--where lower(view_name) =('v_emp_notable');
--where view_name IN ('V_EMP_NOTABLE');

select * from v_emp_notable;--실패

--2.3 WITH CHECK OPTION
--해당 뷰를 통해서 볼수 있는 범위 내에서만 insert 또는 update 가능하다.
--예: 담당업무가 MANAGER인 사원들을 조회하는 뷰 생성
create or replace view v_emp_job_nochk
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER';

select * from v_emp_job_nochk;

insert into v_emp_job_nochk values(9100, '이순신', 30, 'SALESMAN');
select * from v_emp_job_nochk;--뷰에는 없지만
select * from emp11;--기본테이블에는 추가되었다.---> "혼돈 발생"
--따라서 '미연에 방지하기 위해'
--with check option 사용하여 기본 테이블에도 추가 될수 없도록 방지
--즉, with check option으로 뷰를 생성할 때 조건제시에 사용된 컬럼값을 변경하지 못하도록 한다.
create or replace view v_emp_job_chk
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER' with check option;

insert into v_emp_job_chk values(9500, '김유신', 30, 'SALESMAN');--실패: 추가 안된다.
--with check option: 조건제시(='MANAGER')를 위해 사용한 컬럼값이 아닌 (='SALESMAN')값에 대해서는 뷰를 통해서 추가/변경하지 못하도록 막는다.

insert into v_emp_job_chk values(9500, '김유신', 30, 'MANAGER');--성공: 추가된다.

select * from v_emp_job_chk;--뷰에는 추가되었고
select * from emp11;--기본테이블에도 추가되었다.

--2.4 WITH READ ONLY: select문만 가능, DML(=데이터 조작어: 변경 INSERT, UPDATE, DELETE) 불가
create or replace view v_emp_job_readonly
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER' with read only;

select * from v_emp_job_readonly;--조회는 가능하다.
insert into v_emp_job_readonly values(9700, '강감찬', 30, 'MANAGER');--실패

--<11장 뷰 혼자 해보기>-----------------------------
--1.20번 부서에 소속된 사원의 사원번호,이름,부서번호를 출력하는 select문을
--뷰로 정의(v_em_dno)
create view v_em_dno
as
select eno, ename, dno
from emp11
where dno=20;

--2.이미 생성된 v_em_dno 뷰에 급여 역시 출력되도록 수정
create or replace view v_em_dno--재생성
as
select eno, ename, dno, salary
from emp11
where dno=20;

--3.뷰 제거
drop view v_em_dn0;
