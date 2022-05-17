--<북스 8장_테이블 생성 수정 제거하기>

--데이터 정의어(DDL=Data Definition Languade)
--1. CREATE: DB 객체 생성
--2. ALTER: DB 변경
--3. DROP: DB 삭제
--4. RENAME: DB 이름변경
--5. TRUNCATE: 데이터 및 저장 공간 삭제

/*
 * DELETE(DML: 데이터 조작어), TRUNCATE, DROP(DDL: 데이터 정의어) 명령어의 차이점
 * (DELETE, TRUNCATE, DROP 명령어는 모두 삭제하는 명령어이지만 중요한 차이점이 있다.)
 * 1. DELETE명령어: 데이터는 지워지지만 테이블 용량은 줄어 들지 않는다. 원하는 데이터만 삭제할 수 있다.
 * 					삭제 후 잘못 삭제한 것은 되돌릴 수 있따.(rollback)
 * 
 * 2. TRUNCATE명령어: 용량이 줄어들고, index 등도 모두 삭제된다.
 * 					데이터은 삭제하지 않고, 테이블만 삭제된다.
 * 					한꺼번에 다 지워야한다.
 * 					 삭제 후에 절대 되돌릴 수 없다.
 * 
 * 3. DROP명령어: 테이블 전체를 삭제(테이블공간, 객체를 삭제한다.)
 * 				삭제 후에 절대 되돌릴 수 없다.
 * 
 */

--1. 테이블구조를 만드는 CREATE TABLE문(교제 P206)
--테이블 생성하기 위해서는 테이블명 정의, 테이블을 구성하는 컴럼의 데이터 타입과 무결성 제약 조건 정의

--<테이블 및 컬럼명 정의 규칙>
--문자(영어 대소문자)로 시작, 30자 이내
--문자(영어 대소문자)로 시작, 숫자 0~9, 특수문자(_ $ #)만 사용가능
--대소문자 구별없음, 소문자로 저장하려면 ''로 묶어줘야 함
--동일 사용자의 다른 객체의 이름과 중복 불가하다. 예)SYSTEM이 만든 테이블명들은 다 달라야 한다.

--<서브쿼리를 이용하여 다른 테이블로부터 복사하여 테이블 생성 방법>
--서브쿼리문으로 부서 테이블의 구조와 데이터 복사 ---> 새로운 테이블 생성
--CREATE TABLE 테이블명(컬럼명 명시 O): 지정한 컴럼수와 데이터 타입이 서브쿼리의 검색한 컬럼과 일치 
--CREATE TABLE 테이블명(컬럼명 명시 X): 서브쿼리의 컬럼명이 그대로 복사
--
--무결성 제약조건: ★★not null 조건만 복사, 
--				기본키(=PK), 외래키(=FK)와 같은 무결성제약조건은 복사안된다.
--				디폴트 옵션에서 정의한 값은 복사
--
--서브쿼리의 출력 결과가 테이블의 초기 데이터로 삽입됨

--(예)CREATE TABLE 테이블명(컬럼명 명시 O)
--[문제] 서브쿼리문으로 부서 테이블의 구조와 데이터 복사하기(★★'제약조건'은 복사안된다.★★not null 조건만 복사)
select dno--컬럼수 1개
from department;

CREATE TABLE dept1(dept_id)--컬럼수 1개(★★'제약조건'은 복사안된다.★★not null 조건만 복사)
AS
select dno--컬럼수 1개
from department;-- select department까지가 서브쿼리라 할 수 있다.

select * from dept1;

--(예)CREATE TABLE 테이블명(컬럼명 명시 X)
--[문제] 2번 부서 소속 사원에 대한 정보를 포함한 dept2 테이블 생성하기
--[1]. 2번 부서 소속 사원에 대한 정보 조회
select eno, ename, salary*12 as "연봉"
from employee
where dno = 20;

--[2]. ★★서브쿼리문내에 '산술식'에 대해 별칭 지정해야함
CREATE TABLE dept2
AS
select eno, ename, salary*12 as "연봉"
from employee
where dno = 20;

select * from dept2;

CREATE TABLE dept_err
AS
select eno, ename, salary*12--as "연봉"(별칭 없으면 오류)
from employee
where dno = 20;

--<서브쿼리의 데이터는 복사하지 않고 테이블 구조만 복사방법>
--서브쿼리의 where절을 항상 거짓이 되는 조건 지정: 조건에 맞는 데이터가 없어서 데이터 복사안됨
--where 0=1
--[문제] 부서테이블의 구조만 복사하여dept3테이블 생성하기
CREATE TABLE dept3
AS
select *
from department
WHERE 0=1;--거짓 조건

select * from dept3;-- 구조만 복사되고 데이터는 복사되지 않았다.

--테이블 구조 확인
DESC dept3;--이클립스에서는 명령어가 실행되지 않는다.
--RUN SQL... 창 열얼 확인해보기 ---> conn system/1234 ---> DESC dept3;

------------------------------------------------------------------------
--2. 테이블 구조를 변경하는 ALTER
--2.1 컬럼추가: 추가된컬럼은 마지막 위치에 생성(즉, 원하는 위치에 지정할 수 없음.)

--[문제] 사원테이블 dept2에 날짜타입을 가진 birth 컬럼추가
ALTER TABLE dept2
ADD birth date;
--이 테이블에 기존에 추가한 데이터(행)가 있으면 추가한 컬럼(brith)의 컬럼값은 NULL로 자동 입력됨

--[문제]사원테이블 dept2
ALTER TABLE dept2
ADD email varchar2(50) DEFAULT 'test@test.com' not null;

select * from dept2;

--2.2 컬럼변경
--기존 컬럼에 데이터가 없는 경우: 컬럼타입이나 크기 변경 자유
--기존 컬럼에 데이터가 있는 경우: 타입변경은 char와 varchar2(가변길이)만 허용하고 
--							변경할 컬럼의 크기가 저장된 데이터의 크기보다 같거나 클 경우에만 변경가능함
--							숫자타입은 폭 또는 전체자릿수 늘릴수 있다.(예 : number, number(7), number(5,2)=number(전체자릿수, 소수둘째자리)123.45)

--[문제] 테이블 dept2에서 사원이름의 컬럼크기를 변경
--run sql에서 확인 가능하다.
ALTER TABLE dept2
MODIFY ename varchar2(30);--컬럼 크기 10(10보다 작은 값은 못한다.) ---> 30으로 크게 변경

desc dept2;

ALTER TABLE dept2
MODIFY ename char(30);--varchar2 ---> char타입으로 변경

ALTER TABLE dept2
MODIFY ename char(10);--컬럼 크기 30 ---> 10으로 변경 불가 --->오류: 크기를 작게 변경 불가

ALTER TABLE dept2
MODIFY ename number(30);--오류: 문자 타입끼리는 변경이 가능하지만, char와 varchar2만 가능
--만약, char (30) ---> number로 변경해야 하는 경우: 해당 컬럼의 값을 모두 지워야 변경 가능

ALTER TABLE dept2
MODIFY ename varchar2(40);

--[문제] 테이블 dept2에서 사원이름의 컬럼명 변경(ename ---> ename2)
ALTER TABLE dept2
RENAME column ename TO ename2;

select *from dept2;

--[문제] 테이블 dept2에서 컬럼 기본 값 지정--이미 지정이 되어 있어서 불가능하다.
--변경 안됨? ename2에 데이터가 null로 입력된 상태이므로 컬럼변경이 안된다.
ALTER TABLE dept2
MODIFY ename2 varchar2(40) DEFAULT 'AA' not null;
--해결방법: 데이터 구조는 그대로 두고 데이터만 삭제
TRUNCATE table dept2;
select * from dept2;

ALTER TABLE dept2
MODIFY ename2 varchar2(50) DEFAULT '기본' not null;
-----------------------------------------------

--★★DROP, SET unused: 둘 다 실행한 후  될돌릴수 없음. 그러나 다시 같은 이름의 컬럼 생성은 가능
--2.3 컬럼제거: 2개 이상 컬림이 존재한 테이블에서만 컬럼 삭제 가능
--[문제] 테이블 dept2에서 사원이름 제거
ALTER TABLE dept2
DROP column ename;

--그러나 다시 같은 이름의 컬럼 생성은 가능(예)
ALTER TABLE dept2
ADD ename varchar2(20);

select * from dept2;

--2.4 set unused(사용되지 않는): 시스템의 요구가 적을  때 컬럼을 제거할 수 있도록 하나 이상의 컬럼을 unused로 표시
--실제로 제거되지는 않음
--데이터가 존재하는 경우에는 삭제된 것처럼 처리되기 때문에 select절로 조회가 불가능하다.
--descibe 문으로 표시되지 않는다. (예: desc 테이블명; 테이블 구조확인)

--사용하는 이유? 1. 사용자에게 보이지 않게 하기 위해
--		      2. unused로 미사용 상태로 표시한 후 나중에 한꺼번에 DROP으로 제거하기 위해	
--				운영중에 컬럼을 삭제하는 것은 시간이 오래 걸릴수 있어서 unused로 표시해두고 나중에 한꺼번에 drop으로 제거해준다.

--[문제] 테이블 dept2에서 "연봉"을 unused 상태로 만들기
ALTER TABLE dept2
SET unused("연봉");

--[문제] unused로 표시된 모든 컬럼을 한꺼번에 제거
ALTER TABLE dept2
DROP unused columns;--s복수

--그러나 다시 같은 이름의 컬럼 생성은 가능(예-2)
ALTER TABLE dept2
ADD salary number(20);

select * from dept2;

--[ORACLE 11G]
--ORACLE 11G이하 경우는 컬럼의 순서를 바꾸기 위해서는 기존 테이블을 삭제하고 다시 생성해야 한다.
--대부분 컬럼 순서 변경이 꼭 필요한 경우에만 작업을 하고 그 외는 마지막에 컬럼을 추가하는 편이다.

--[1] 기존 테이블에서 변경할 컬럼 순서로 조회 후 새테이블 생성 (★★'제약조건'은 복사안된다.★★not null 조건만 복사)
CREATE TABLE dept2_copy
AS
select eno, ename, salary, birth
from dept2;

--[2]기존 테이블 삭제
DROP TABLE dept2;

--[3]새테이블 이름변경 (dept2_copy ---> dept2)
RENAME dept2_copy TO dept2;

select * from dept2;
--[4] 마지막: 제약조건 다시 생성해야 함

------------------------------------------------------------------------------
--3. 테이블명 변경:rename문 기존이름 to 새이름;
rename dept2 to emp2;

--4. 테이블 구조를 제거: DROP TABLE 테이블명
--★★[department 테이블 제거-1]---> 참조키의 상황 자체를 삭제 하면 department 테이블 삭제 가능하다.
--삭제할 테이블의 기본키나 고유키를 다른 테이블에서 참조하고 있는 경우에 삭제 불가능하다.
--그래서  '참조하는 테이블(자식 테이블)'을 먼저 제거 후 부모 테이블 제거할 수 있다.
DROP TABLE department;--실패
DROP TABLE employee;--먼저 제거 후
DROP TABLE department;-- 성공
--실행하면 1장에 가서 다시 해야하니 실행을 하지 말자.

--★★[department 테이블 제거-2]
--사원테이블의 참조키 제약조건까지 함께 제거
DROP TABLE department cascade constraintS;--s를 붙여서 완성

select table_name, constraint_name, constraint_type
from user_constraintS
--table_name: 대문자로 ---> 소문자로 변경하여 찾는 방법
where lower(table_name) in ('employee', 'department');
--where table_name in ('EMPLOYEE', 'DEPARTMENT');
-- 둘 중에 하나 사용해야 한다.

--5. 테이블의 모든 데이터만 제거: TRUNCATE TABLE문
--테이블 구조는 유지, 테이블에 생성된 제약조건과 연관된 인덱스, 뷰, 동의어는 유지됨

select * from emp2;
insert into emp2 values(1,'kim', 2500, '2022-01-03',default);
select * from emp2;--조회 후

TRUNCATE TABLE emp2;--데이터만 제거
select * from emp2;--확인

--6. 데이터 사전: 사용자와 DB 자원을 효율적으로 관리위해 다양한 정보를 저장하는 시스템 테이블 집합
--사용자가 테이블을 생성하거나 사용자를 변경하는 등의 작업을 할때
--DB 서버에 의해 자동 갱신되는 테이블
--사용자가 직접수정x, 삭제x --->'읽기전용 뷰'로 사용자에게 정보를 제공함

--6.1 USER_데이터 사전:'USER_로 시작~S(복수)'로 끝남
--사용자와 가장 밀접하게 관련된 뷰로 
--자신이 생성한 테이블, 뷰, 인덱스, 동의어 등의 객체나 해당 사용자에게 권한 정보 제공
--(예) USER_table로 사용자가 소유한 'table'에 대한 정보 조회
select table_name
from USER_tableS;--사용자(system)가 소유한 'table' 정보

select sequence_name, min_value, max_value, increment_by, cycle_flag
from USER_sequenceS;--사용자(system)가 소유한 'sequence' 정보(P 292참조)

select index_name
from USER_indexS;--사용자(system)가 소유한 'index' 정보
-- 검색을 빨리 할 수 있다.

select view_name
from USER_viewS;-- 사용자(system)가 소유한 'view' 정보

--'테이블 제약조건' 보려면 'User_constraintS' 데이터 사전 사용함
select table_name, constraint_name, constraint_type--P:PK=기본키, R=참조키
from USER_constraintS
where table_name IN('TEST');--★★주의: 1. 반드시 '대문자로'
--where LOWER(table_name) IN ('employee');--2. LOWER()함수 사용하여 소문자로 변경

--※객체: 테이블, 시퀀스, 인덱스, 뷰 등
--6.2 ALL_데이터 사전
--전체 사용자와 관련된 뷰, 사용자가 접근할 수 있는 모든 객체 정보 조회
--owner:조회 중인 객체가 누구의 소유인지 확인

--예) ALL_tableS로 테이블에 대한 정보 조회
--사용자: system 일때 500레코드(SYS와 SYSTEM만 : 사용자(HR) 제외된 상태로 결과가 나온다.)
--사용자: 	hr 일때 78레코드(사용자(HR)과 다른 사용자들 포함된 결과가 나온다.)
select owner, table_name
from ALL_tableS;

--where owner IN ('SYSTEM') OR table_name IN ('EMPLOYEE','DEPARTMENT');
--where owner IN ('EMPLOYEE','DEPARTMENT');

--조건식에 owner IN ('HR')추가하여 조회하면 사용자(HR) 결과가 나옴
select owner, table_name--사용자(HR) 제외된 상태로 결과가 나옴
from ALL_tableS
where owner IN ('HR');

--6.3 DBA_데이터 사전: system관리와 관련된 view, DBA나 system 권한을 가진 사용자만 접근 가능
--현재 접속한 사용자가 hr(교육용계정)이라면 'DBA_데이터 사전'을 조회할 권한이 없음
--DBA 권한 가진 system계정으로 접송해야 테스트 가능

--(예) DBA_tableS로 테이블에 대한 정보 조회
--사용자:system 일 때 500레코드(SYS와 SYSTEM만 : 사용자(HR) 제외된 상태로 결과가 나온다.)
--					ALL_tableS로 조회한 정보와 같은 결과
--			hr 일 때  table or tiew does not exist로 DBA 권한이 없다. ---> 교육용의 한계
select owner, table_name
from DBA_tableS;

select owner, table_name
from DBA_tableS
where owner IN('HR');
-------------------------------------------------------------------------------
--RUN SQL Command Line에서 HR로 접속하는 방법
--1. RUN SQL 창열기
--connhr/hr
--실패: account is locked

--2.계정을 활성화시키기 위해서 관리자 계정 접속
--conn system/1234;
--alter user hr identified by hr account unlock;

--3. 다시 hr로 접속
--conn hr/hr
-------------------------------------------------------------------------------

--<08장 테이블수정생성제거하기 혼자해보기>-----------------------------
--1. 다음표에 명시된 대로 DEPT 테이블 생성하기
CREATE TABLE dept
dno number(2), dname varchar2(14), loc vachar2(13);


--2. EMP 테이블을 생성하시오.
CREATE TABLE emp
eno number(4), ename varchar2(10), dno number(2);


--3. 긴 이름을 저장할 수 있도록 emp 테이블을 수정하시오. (ename 컬럼의 크기)
CREATE TABLE emp
eno number(4), ename varchar2(25), dno number(2);


ALTER TABLE
MODIFY ename varchar2(25);

--4. EMPLOYEE 테이블을 복사해서 EMPLOYEE2란 이름의 테이블을 생성하되 사원번호, 이름, 급여, 부서번호 컬럼만
--복사하고 새로 생성된 테이블의 컬럼명은 각각 EMP_ID, NAME, SAL, DEPT_ID로 지정하시오.
--[방법-1]
create table employee2(EMP_ID, NAME, SAL, DEPT_ID)--4개
as
select eno, ename, salary, dno--4개
from employee;

--[방법-2]
--[1]
create table employee2
as
select eno, ename, salary, dno
from employee;

--[2] 컬럼명 수정
alter table employee2
rename column to EMP_ID;

alter table employee2
rename column to NAME;

alter table employee2
rename column to SAL;

alter table employee2
rename column to DEPT_ID;

select * from employee2;

--5. emp 테이블을 삭제하시오.
drop table emp;

--6. EMPLOYEE2란 테이블을 EMP로 변경하시오.
rename employee2 to emp;

--7. DEPT 테이블에서 DNAME 컬럼을 제거하시오.
ALTER TABLE dept
drop column dname;

--8. DEPT 테이블에서 LOC 컬럼을 UNUSED로 표시 하시오.
ALTER TABLE dept
set unused (loc);

select * from dept;

--9. UNUSED 컬럼을 모두 제거하시오.
ALTER TABLE dept
drop unused columns;
