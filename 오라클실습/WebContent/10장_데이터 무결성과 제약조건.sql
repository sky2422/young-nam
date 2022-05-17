---<북스 10장_데이터 무결성과 제약조건>

--※대괄호([ ])의 항목은 필요하지 않을 경우 생략이 가능하다.
CREATE TABLE [SCHEMA: 소유자 이름(사용자 계정)] table명(--[]는 모두 옵션
컬럼명1 데이터타입(길이) [NULL|NOT NULL|UNIQUE(INDEX자동생성)|DEFAULT 표현: 값이 생략되면 입력되는 기본값|CHECK(체크조건)(AGE > 0)]
[[CONSTRAINT 제약조건명(테이블명_컬럼명_PK)] PRIMARY KEY(INDEX자동생성)|[CONSTRAINT 제약조건명(테이블명_컬럼명_FK)]|[FOREIGN KEY]] REFERENCES 참조테이블명],
컬럼명2....,
컬러명3...

테이블 레벨 제약조건
[CONSTRAINT 제약조건명(테이블명_컬럼명_PK)] PRIMARY KEY(컬럼명1, 컬럼명2,...),
[CONSTRAINT 제약조건명(테이블명_컬럼명_FK)]|FOREIGN KEY(컬럼명) REFERENCES 참조테이블명(컬럼명)
[ON DELETE no action(기본값)|cascade|set null|set default]--반드시 테이블 레벨에서만 가능
[ON UPDATE no action(기본값)|cascade|set null|set default]--반드시 테이블 레벨에서만 가능
);

/*
 * [ON DELETE 뒤에]
 * 1. no action(기본값): 부모테이블 값이 자식 테이블에서 참조하고 있으면 부모테이블 삭제 불가능하다.
 *  ※restrict(MYSQL에서 기본값, MYSQL에서 retrict는 no action과 같은 의미로 사용한다.)
 * ※오라클에서의 restrict는 no action과 약간의 차이가 있다.
 * 
 * 2. CASCADE: 참조되는 '부모테이블의 값이 삭제'되면 연쇄적으로 '자식테이블이 참조하는 값 역시 삭제된다.'
 * 				부서테이블의 부서번호 40 삭제할 때 사원테이블의 부서번호 40도 삭제
 * 
 * 3. Set null: 부모테이블의 값이 삭제되면 해당 참조하는 자식테이블의 값들은 모두 null으로 설정된다.
 * 				(단, null 허용한 경우)
 * 				부서테이블의 부서번호 40 삭제할 때 사원테이블의 부서번호가 null로 변경된다.
 * 
 * 4. Set default: 자식테이블의 관련 튜플을 미리 설정한 값으로 변경
 * 					부서테이블의 부서번호 40 삭제할 때 사원테이블의 부서번호를 default값으로 변경해준다.
 * 					이 제약조건이 실행하려면 모든 참조키 컬럼에 기본 정의가 있어야 한다.
 * 					컬럼이 null을 허용하고 명시적 기본값이 설정되어 있지 않는 경우 null은 해당 열의 암시적인 기본값이 된다.
 */

/*
 * ==ON DELETE==
 * 1. no action (기본값)(restrict와 비슷): 자식테이블에 데이터가 남아 있는 경우 부모 테이블의 데이터는 수정 불가하다.
 * 2. cascade: 부모데이터 수정 시 자식 데이터도 동시 수정가능하다.
 * 3. set null: 부모데이터 수정 시 해당되는 자식 데이터의 컬럼값은 null로 처리
 * 4. set default: 부모 데이터 수정 시 자식 데이터의 컬럼값은 기본값이(default)으로 수정한다.
 * 
 */

--1.제약조건
--'데이터 무결성' 제약조건: 테이븡에 유효하지 않은 (부적절한) 데이터가 입력되는 것을 방지하기 위해
--테이블생성할 때 각 컬럼에 대해 정의하는 여러 규칙

--<제약조건(5가지)>----------------------------------------------------------------------------------------
--1. NOT NULL

--2. UNIQUE: 중복을 허용하지 않는다. 유일한 값이다. = 고유한 값이다. ---> 고유키(암시적 INDEX 자동 생성)
--			 ★★NULL은 UNIQUE 제약조건에 위반되지 않으므로 'NULL'값을 허용'

--3. PRIMARY KEY(기본키=PK): NOT NULL 제약조건: NULL값 허용하지 않는다.
--							UNIQUE 제약조건: 중복을 허용하지 않는다. = 고유한 값이다. ---> 고유키(암시적 INDEX 자동 생성)

--4. FOREIGN KEY(외래키=참조키=FK): 참조되는 테이블에 컬럼 값이 항상 존재해야한다.(중복되지 않는 유일한 키)
--								(예) 사원테이블(자식) DNO(=FK) ---> 부서테이블(부모) DNO(PK OR UNIQUE)
--								※참조 무결성 -테이블 사이의 '주종 관계를 설정'하기 위해 제약 조건
--'어느 테이블의 데이터가 먼저 정의되어야 하는가?': 먼저, 부모 테이블부터 정의하고 ---> 자식테이블 정의

--5. CHECK(): '저장 가능한 데이터 범위나 조건 지정'하여(예)CHECK(SALARY > 0)
--				설정된 값 이외의 값이 들어오면 오류가 일어나게 된다.
---------------------------------------------------------------------------------------------------------
--DEFAULT 정의: 아무런 값을 입력하지 않았을 때 DEFAULT값이 입력되도록 한다.

--제약조건: 컬럼레벨- 하나의 컬럼에 대해 모든 제약 조건을 정의
--		   테이블레벨 - 'NOT NULL 제외'한 나머지 제약조건을 정의

--<제약조건이름 직접 지정할 때의 형식>
--CONSTRAINT 제약조건이름
--CONSTRAINT 테이블명_컬럼명_제약조건유형
--제약조건이름을 지정하지 않으면 자동으로 생성된다.

create table customer2(
id varchar2(20) unique,
pwd varchar2(20) not null,
name varchar2(20) not null,
phone varchar2(30),
address varchar2(100)
);

DROP TABLE customer2;

create table customer2(
id varchar2(20) constraint customer2_id_uq unique,--uq는 유추가능하게 만들면 된다.
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100)
);

DROP TABLE customer2;

create table customer2(
id varchar2(20) constraint customer2_id_pk primary key,--컬럼 레벨
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100)
);

DROP TABLE customer2;

create table customer2(
id varchar2(20),
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100),

constraint customer2_id_pk primary key(id)--테이블 레벨
--constraint customer2_id_pk primary key(id, name)--기본키가 2개 이상일 때 테이블 사용
);

--'테이블 제약조건'을 보려면 '제약조건에 테이블 사전(=USER_constraintS)' 사용하여 테이블명, 제약조건명 조회
-- C는 not null이고 U(UNIQUE)이고 P(primary key)이고 R은 참조키
select table_name, constraint_name, constraint_type
from USER_constraintS
where table_name LIKE 'CUSTOMER2';
--where table_name IN('CUSTOMER2');
--where LOWER(table_name) IN('customer2'); 
--where table_name IN UPPER('customer2');
--where table_name LIKE '%CUSTOMER2%';
--where table_name LIKE '%CUSTOMER2';
--하나씩 주석을 포함시키지 않고 실행하면 전부 가능하다.

--1.1 NOT NLL 제약조건: 컬럼 레벨로만 정의
insert into customer2 values(null, null, null, '010-1111-1111', '대구시 달서구');

--1.2 UNIQUE 제약조건: 유일한 값만 허용한다.(단, null 허용)

--1.3 PRIMARY KEY 제약조건
--테이블의 모든 ROW(레코드)를 구별하기 위한 식별자

--1.4 FOREIGN KEY(FK=참조키=외래키) 제약조건
--사원 테이블의 부서번호는 언제나 부서 테이블에서 참조가 가능: 참조 무결성

select * from department;--참조되는 부모

--★★삽입(자식인 사원 테이블에서)
insert into employee(eno, ename, dno) 
			values(8000, '홍길동', 50);
--부서번호 50 입력하면 
--'참조무결성 위배, 부모키를 발견하지 못했다.'오류발생한다.
--integrity constraint (SYSTEM.SYS_C007038) violated - parent key not found

--이유: 사원테이블에서 사원의 정보를 새롭게 추가할 경우
--		사원테이블의 부서번호는 부서테이블의 저장된 부서번호 중 하나와 일치
--		or NULL 만 입력 가능하다.(단, NULL허용했을 경우 - 참조 무결성 제약조건)

--삽입 방법
--[방법-1]
insert into employee(eno, ename, dno)--참조하는 자식
			values(8000, '홍길동', '');--'' = null 단, dno가 null 허용하면
--[방법-2]: 제약조건을 삭제하지 않고 일시적으로 '비활성화' ---> 데이터 처리 ---> 다시 '활성화'
--USER_constraintS 데이터 사전을 이용하여 constraint_name과 타입(=type)과 상태(=status) 조회
select constraint_name, constraint_type, status--P(기본키), R(참조키), ENABLED (활성화된) 
from USER_constraintS
where table_name IN('EMPLOYEE');

--[1] 제약조건 '비활성화'
alter table employee
disable constraint SYS_C007038;--constraint_type이 R인 것의 찾아서 설정하면 된다.

select constraint_name, constraint_type, status
from USER_constraintS
where table_name IN('EMPLOYEE');

--[2] 자식에서 삽입
insert into employee(eno, ename, dno) 
			values(9000, '홍길동', 50);
			--values(8000, '홍길동', 50);--이미 8000은 그 전에 삽입된 상태
			
--[3] 다시 활성화
alter table employee
enable constraint SYS_C007038;		
--오류: integrity constraint (SYSTEM.SYS_C007038) violated - parent key not found
			
--다시 활성화시키기 위해 eno가 9000인 row 삭제			
delete employee where eno=9000;
			
alter table employee
enable constraint SYS_C007038;			
			
--활성화 상태 확인
select constraint_name, constraint_type, status
from USER_constraintS
where constraint_name IN('SYS_C007038');			

--삽입방법-2 정리: 제약조건 비활성화시켜 원하는 데이터를 다시 제약조건 활성화시키면 오류 발생하여 삽입한 데이터를 삭제해야한다.

--★★★삭제(부모에서)-부서테이블에서 삭제할 때
drop table department;
--unique/primary keys in table referenced by foreign keys
--자식인 employee에서 참조하는 상황에서는 삭제가 안된다.


-----1. 부모부터 테이블 생성: 실습위해 department 복사하여 department2 테이블 생성
-----★주의: 제약조건은 복사가 안된다.
create table department2
as
select * from department;--★주의: 제약조건은 복사가 안된다.

select * from department2;

select constraint_name, constraint_type, status
from USER_constraintS
where table_name IN('DEPARTMENT2');
--where lower(table_name) IN ('department2');--도 가능

-----PRIMARY KEY 제약조건 추가하기(단, 제약조건명을 직접 만들어 추가): 제약조건 복사가 안된다.
alter table department2
add CONSTRAINT department2_dno_pk primary key (dno);

-----제약조건 확인해보면
select constraint_name, constraint_type, status
from USER_constraintS
where table_name IN('DEPARTMENT2');

-----2. 자식테이블 생성
create table emp_second(
eno number(4) constraint emp_second_eno_pk primary key,
ename varchar2(10),
job varchar2(9),
salary number(7, 2) default 1000 check(salary > 0),
dno number(2), --constraint emp_second_dno_fk foreign key references department2 ON DELETE CASCADE--(FK=참조키=외래키 R로 출력된다.) 컬럼레벨

--테이블 레벨: ON DELETE 옵션
constraint emp_second_dno_fk foreign key(dno) references department2(dno)
ON DELETE CASCADE--CASCADE: 종속
);
--constraint emp_second_dno_fk foreign key 생략 가능한 부분이다.

insert into emp_second values(1, '김', '영업', null, 30);
insert into emp_second values(2, '이', '조사', null, 20);
insert into emp_second values(3, '박', '운영', null, 40);
insert into emp_second values(4, '조', '상담', null, 20);

--1.6 default 정의
--default 값 넣는 2가지 방법
insert into emp_second(eno, ename, job, dno) values(5, '김', '영업', 30);--salary: default 1000
insert into emp_second values(6, '이', '영업', default, 40);--salary: default 1000

select * from emp_second;
select * from department2;

--부모테이블에서 dno=20 삭제하면 자식테이블에서 참조하는 행도 같이 삭제된다.
--이유: ON DELETE CASCADE
delete department2 where dno=20;

select * from emp_second;--부모테이블 삭제하면
select * from department2;--자식테이블에서도 삭제된다.

--실패한다.
--기본값이 자식테이블에서 참조하고 있으면 부모테이블의 행에 있는 데이터 삭제 불가하다.
delete department where dno=20;

--테이블 전체 제거 
--실패 메시지 unique/primary keys in table referenced by foreign keys
--현재사원테이블의 참조키로 참조하고 있으므로 테이블 전체 삭제가 안된다.
drop table department2;

--테이블 데이터만 삭제(테이블 구조는 남기고)
truncate table department2;--실패: rollback 불가능
delete from department2;--★★성공: rollback 가능하므로(혹시 잘못 삭제 후 다시 복원 가능)

select * from department2;--부모테이블에서 모든 데이터 다 삭제하면
select * from emp_second;--자식테이블에서도 모든 데이터 다 삭제된다.

--1.5 check 제약조건: 값의 범위나 조건 지정
--currval(시쿼스의 값), nextval, rownum 사용불가
--sysdate, user와 같은 함수는 사용 불가

--[test를 위해] 
--[1]. emp_second부터 drop ---> department2 drop
drop table emp_second;
drop table department2;
--[2]. department2 생성 ---> emp_second 생성
--[2.1] department2 생성
create table department2
as
select * from department;--★주의: 제약조건은 복사가 안된다.

alter table department2
add CONSTRAINT department2_dno_pk primary key (dno);--기본키 제약조건 추가
--[2.2] emp_second 생성
create table emp_second(
eno number(4) constraint emp_second_eno_pk primary key,
ename varchar2(10),
job varchar2(9),
salary number(7, 2) default 1000 check(salary > 0),
dno number(2), 
constraint emp_second_dno_fk foreign key(dno) references department2(dno)
ON DELETE CASCADE--CASCADE: 종속
);

--check(salary > 0)
insert into emp_second values(4, '조', '상담', -3000,30);
--오류: check constraint (SYSTEM.SYS_C007113) violated (check 제약조건 위배)
insert into emp_second values(4, '조', '상담', 3000,30);--성공
---------------------------------------------------------------------------------
--2. 제약조건 변경하기
--2.1 제약조건 추가: alter table 테이블명 + ADD constraint 제약조건명 + 제약조건
--단, 'null 무결성 제약조건'은 alter table 테이블명 + ADD ~ 로 추가하지 못한다.
--						alter table 테이블명 + MODIFY로 NULL 상태로 변경 가능
--	'default 정의 할 때'도  alter table 테이블명 + MODIFY로 

--[test를 위해]
--drop table dept_copy;
create table dept_copy
as
select * from department;--제약 조건 복사안된다.

--drop table emp_copy;
create table emp_copy
as
select * from employee;--제약 조건 복사안된다.

select table_name constraint_name
from user_constraintS
where table_name IN('DEPARTMENT', 'EMPLOYEE', 'DEPT_COPY', 'EMP_COPY');
--오류

--예-1: 기본키 제약조건 추가하기
alter table dept_copy
add constraint dept_copy_dno_pk primary key(dno);

alter table emp_copy
add constraint emp_copy_eno_pk primary key(eno);

--추가된 제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPARTMENT', 'EMPLOYEE', 'DEPT_COPY', 'EMP_COPY');
--정상적으로 출력된다.

--예-2: 외래키(=참조키) 제약조건 추가하기
alter table emp_copy
add constraint emp_copy_fk foreign key(dno) references dept_copy(dno);
--ON delete CASCADE; 필요시 추가 가능하다. ,와 ; 수정을 필히 해야 한다.
--ON delete set null;필요시 추가 가능하다. ,와 ; 수정을 필히 해야 한다.

--추가된 제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

--예-3: NOT NULL 제약조건 추가하기
alter table emp_copy
MODIFY ename constraint emp_copy_ename_nn NOT NULL;

--예-4: DEFAULT 정의 추가하기(★★constraint 제약조건명 입력하면 오류 발생한다.)
alter table emp_copy
MODIFY salary constraint emp_copy_ salary_d default 500; 
--실패: constraint specification not allowed here
alter table emp_copy
MODIFY salary default 500;  
--성공

--추가된 제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');
--default 정의 내용은 제약조건이 아니므로 출려되지 않는다.

--예-5: check 제약조건 추가하기 
select salary from emp_copy where salary <= 1000;

alter table emp_copy
add constraint emp_copy_salary_check CHECK(salary > 1000);
--실패: 이미 insert 된 데이터 중에 1000보다 작은 급여가 있으므로 '조건에 위배되어 오류 발생'된다.

alter table emp_copy
add constraint emp_copy_salary_check CHECK(500 <= salary and salary < 10000);
--500 <= salary and salary < 10000 이상의 값은 insert 되지 않는다.

alter table dept_copy
add constraint dept_copy_dno_check CHECK(dno IN(10, 20, 30, 40, 50));
--dno는 반드시 IN(10, 20, 30, 40, 50) 중 하나만 insert 가능하다.

--추가된 제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

--2.2 제약조건 제거
--외래키 제약조건에 지정되어 있는 부모 테이블의 기본키 제약조건을 제거하려면
--자식테이블의 참조 무결성 제약조건을 먼저 제거한 후 제거하거나
--또는 cascade 옵션 사용: 제거하려는 컬럼을 참조하는 참조 무결성 제약조건도 함께 제거
alter table dept_copy--부모
drop primary key;--실패이유: 자식테이블에서 참조하고 있으므로 

alter table emp_copy
drop primary key;

alter table dept_copy
drop primary key cascade;--참조하는 자식 테이블의 '참조 무결성 제약조건'도 함께 제거된다.

alter table emp_copy
drop primary key cascade;
--삭제된 제약조건 확인: 둘 다 삭제 된다.
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

--예: NOT NULL 제약조건 제거(EMP_COPY_ENAME_NN 제거하기)
alter table emp_copy
drop constraint emp_copy_ename_nn;

--삭제된 제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

------------------------------------------------------------------------------------

--3. 제약조건 활성화 및 비 활성화
--alter table 테이블명 + DISABLE constraint 제약조건 [cascade]
--제약조건을 삭제하지 않고 일시적으로 비 활성화 
--위 내용 참조하기

--<10장 데이터 조작과 트랜잭션 혼자 해보기>-----------------------------
--1.EMPLOYEE 테이블의 구조만 복사하여 EMP_SAMPLE란 이름의 테이블을 만드시오. 
--사원 테이블의 사원번호 컬럼에 테이블 레벨로 primary key 제약 조건을 
--지정하되 조건 이름은 my_emp_pk로 지정하시오
create table EMP_SAMPLE
as
select * from employee
where 0=1;--조건을 무조건 거짓 ---> 데이터 구조만 복사

alter table EMP_SAMPLE
add constraint my_emp_pk primary key(eno);

--2.부서테이블의 부서번호 컬럼에 테이블 레벨로 primary key 제약조건 지정하되
--제약조건명은 my_dept_pk로 지정
create table dept_sample
as
select * from department;

alter table dept_sample
add constraint my_dept_pk primary key(dno);

--3.사원테이블의 부서번호 컬럼에 존재하지 않는 부서의 사원이 배정되지 않도록
--외래키(=참조키) 제약조건(=참조 무결성)을 지정하되
--제약 조건 이름은 my_emp_dept_fk로 지정
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);
--오류발생 안한 이유: 자식 테이블에 데이터없음(즉, 자식에서 부모를 참조하는 데이터가 없다.)
--반드시 부모의 데이터를 먼저 insert 한 후 ---> 자식의 참조하는 데이터 insert 해야 한다.

--4.사원 테이블의 커미션 컬럼에 0보다 큰 값만 입력할 수 있도록 제약조건 지정
alter table emp_sample
add constraint emp_sample_commission_min check(commission > 0);
