---<북스 12장_시퀀스와 인덱스>

--1.시퀀스 생성
--※시퀀스: 테이블 내의 유일한 숫자를 자동 생성
--오라클에서는 데이터가 중복된 값을 가질 수 있으나
--'개체 무결성'을 위해 항상 유일한 값을 갖도록 하는 '기본키'를 두고 있다.
--시퀀스는 기본키가 유일한 값을 반드시 갖도록 자동생성하여 사용자가 직접 생성하는 부담감을 줄인다.

create sequence 시퀀스명
[start with 시작숫자]--시작숫자의 기본값은 증가할 때 minvalue, 감소할 때 maxvalue이다.
[increment by 증감숫자]--증가숫자가 양수면 증가, 음수면 감소 (기본값: 1)한다.

[minvalue 최소값 | nominvalue]--NOMINVALUE(기본값): 증가일때 1, 감소일때 -10의 26승까지(10^-26)
                            --MINVALUE: 최소값 설정, 시작숫자와 작거나 같아야하고 MAXVALUE보다 작아야 한다.
                            
[maxvalue 최대값 | nomaxvalue]--NOMAXVALUE(기본값): 증가일때 10의 27까지, 감소일때 -1까지이다.
                            --MAXVALUE 최대값 : 최대값 설정, 시작숫자와 같거나 커야하고 MINVALUE보다 커야 한다.
                           
[cycle | nocycle(기본값)]--cycle: 최대값까지 증가 후 최소값부터 다시 시작한다.
                       --nocycle: 최대값까지 증가 후  그 다음 시퀀스를 발급받으려면 에러 발생한다.
[cache n | nocache]--cache n: 메모리상에 시퀀스 값을 미리 할당 (기본값 20)이다.
                   --nocache: 메모리상에 시퀀스 값을 미리 할당하지 않는다.(관리하지 않는다.)
                         
[order | noorder(기본값)]--order: 병렬서버를 사용할 경우 요청 순서에 따라 정확하게 시퀀스를 생성하기를 원할 때 order로 지정한다.
                        --        단일 서버일 경우 이 옵션과 관계없이 정확히 요청 순서에 따라 시퀀스가 생성된다.     
;

--sequence-1 생성
create sequence sample_test;

create sequence sample_seq
start with 10--10부터 시작
increment by 3--10 13 16 19...자동 증가하는 값을 생성할 수 있다.
maxvalue 20
cycle
nocache;--10 13 16 19 ---> 1(최소값) 4 7 10 ---> 

create sequence sample_seq;--1씩 증가한다.

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS
where sequence_name IN UPPER('sample_test');

--sequence-2 생성
create sequence sample_seq
start with 10
increment by 3
maxvalue 20
cycle
nocache;

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS
where sequence_name IN UPPER('sample_seq');

select sample_seq.nextval, sample_seq.currval from dual;--10 10
select sample_seq.nextval, sample_seq.currval from dual;--13 13
select sample_seq.nextval, sample_seq.currval from dual;--16 16
select sample_seq.nextval, sample_seq.currval from dual;--19 19
select sample_seq.nextval, sample_seq.currval from dual;--1   1(최소값으로 돌아간다.)
select sample_seq.nextval, sample_seq.currval from dual;--4   4

--sequence-3 생성
create sequence sample_seq2
start with 10
increment by 3;

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS--   1		1e+28=10^27		3			NO			   20
where sequence_name IN UPPER('sample_seq2');

--1.1 NEXTVAL ---> CURRVAL(★★ 사용순서 주의)
--NEXTVAL: 다음값(★새로운 값 생성) 다음값 다음에 
--CURRVAL: 시퀀스의 현재값 알아낸다.

--<CURRVAL, NEXTVAL 사용할 수 있는 경우>
--서브쿼리가 아닌 select문
--insert문의 values절
--update문의 set절

--<CURRVAL, NEXTVAL 사용할 수 없는 경우>
--view의 select문
--distinct 키워드가 있는 select문
--group by, having, order by 절이 있는 select문
--select, delete, update의 서브쿼리
--create table, alter table명령의 default값

select sample_seq2.nextval from dual;--10
select sample_seq2.currval from dual;--오류
--sequence SAMPLE_SEQ2.CURRVAL is not yet defined in this session 출력된다.
--sequence SAMPLE_SEQ2.CURRVAL 정의되지 않았다.

select sample_seq2.nextval, sample_seq2.currval from dual;--13 13순서에 관계없이 실행된다.(이 방법권장)
select sample_seq2.currval, sample_seq2.nextval from dual;--16 16
--sample_seq2.nextval 생성 ---> 다음값 생성 ---> sample.seq2.currval 현재값 알려준다.

--1.2 시퀀스를 기본키에 접목하기
--부서테이블의 기본키인 부서번호는 반드시 유일한 값을 가져와야 한다.
--유일한 값을 자동 생성해주는 시퀀스를 통해 순차적으로 증가하는 프라이머리 컬럼값 자동 생성

--실습위해 dept12 테이블 생성
drop table dept12;

create table dept12
as
select * 
from department
where 0=1;--조건을 거짓으로
--테이블 구조만 복사(단, 제약조건은 복사안된다.-dno는 기본키가 아니다.)

--dno에 기본키 제약조건 추가
alter table dept12
add primary key(dno);--index 자동생성

select * from dept12;

--기본키에 접목시킬 시퀀스 생성
create sequence dno_seq
start with 10
increment by 10;--nocycle이 기본값

insert into dept12 values(dno_seq.nextval,'ACCOUNTING','NEW YORK');--10
insert into dept12 values(dno_seq.nextval,'RESEARCH','DALLAS');--20
insert into dept12 values(dno_seq.nextval,'SALES','CHICAGO');--30
insert into dept12 values(dno_seq.nextval,'OPERATIONS','BOSTON');--40

select * from dept12;

--2. 시퀀스 수정 및 제거
--<수정 시 주의할 사항 내용 2가지>
--[1] 'START WITH 시작숫자'은 수정 불가
--이유: 이미 사용중인 시퀀스의 시자값을 변경할 수 없으므로
--시작번호를 다른 번호로 다시 시작하려면 이전 시퀀스를 DROP으로 삭제후 다시 생성해야한다.
--[2] 증가: 현재 들어있는 값보다 높은 최소값으로 설정 할 수 없다.
--	   감소: 현재 들어있는 값보다 낮은 최대값으로 설정 할 수 없다.
--		(예: 최대값 9999 시작하여 10씩 감소 ---> 최대값 5000으로 변경하면 5000보다 큰 이미 추가된  값들이 무효화된다.)

alter sequence 시퀀스명--시퀀스도 DDL(=데이터 정의어(=Data Definition Language))문이므로 ALTER문으로 수정 가능
--[start with 시작숫자]--시퀀스 수정시 사용 불가함. create sequence에서만 사용 가능하다.
[increment by 증감숫자]--증가숫자가 양수면 증가, 음수면 감소 (기본값: 1)한다.

[minvalue 최소값 | nominvalue]--NOMINVALUE(기본값): 증가일때 1, 감소일때 -10의 26승까지(10^-26)
                            --MINVALUE: 최소값 설정, 시작숫자와 작거나 같아야하고 MAXVALUE보다 작아야 한다.
                            
[maxvalue 최대값 | nomaxvalue]--NOMAXVALUE(기본값): 증가일때 10의 27까지, 감소일때 -1까지이다.
                            --MAXVALUE 최대값 : 최대값 설정, 시작숫자와 같거나 커야하고 MINVALUE보다 커야 한다.
                           
[cycle | nocycle(기본값)]--cycle: 최대값까지 증가 후 최소값부터 다시 시작한다.
                       --nocycle: 최대값까지 증가 후  그 다음 시퀀스를 발급받으려면 에러 발생한다.
[cache n | nocache]--cache n: 메모리상에 시퀀스 값을 미리 할당 (기본값 20)이다.
                   --nocache: 메모리상에 시퀀스 값을 미리 할당하지 않는다.(관리하지 않는다.)
                         
[order | noorder(기본값)]--order: 병렬서버를 사용할 경우 요청 순서에 따라 정확하게 시퀀스를 생성하기를 원할 때 order로 지정한다.
                        --        단일 서버일 경우 이 옵션과 관계없이 정확히 요청 순서에 따라 시퀀스가 생성된다.     
;

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS--   1		1e+28=10^27		10			NO			   20
where sequence_name IN UPPER('dno_seq');

--최대값을 50으로 수정
alter sequence dno_seq
maxvalue 50;

--최대값 확인
select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS--   1			50		10			NO			   20
where sequence_name IN UPPER('dno_seq');

insert into dept12 values(dno_seq.nextval,'COMPUTING','SEOUL');--50
insert into dept12 values(dno_seq.nextval,'COMPUTING','DARGU');--실패

select * from dept12;

--시퀀스 제거
DROP sequence dno_seq;
insert into dept12 value(60,'COMPUTING','DARGU');

---------------------------------------------------------------------------------------

--3. 인덱스: DB 테이블에 대한 검색 속도를 향상 시켜주는 자료 구조
--			특정 컬럼에 인덱스를 생성하면 해당 컬럼의 데이터들을 정렬하여 별도의 메모리 공간에 데이터의 물리적 주소와 함께 저장된다.
				index				table
		  Date  Location	  Location  Data
('김'찾기)	김		 1			1		 김
쿼리실행--->	김		 3			2		 이
			김		1000		3		 김
			이		 2			4		 박
			박		 4			...
								1000	 김 

--			사용자의 필요에 의해서 직접 생성할 수도 있지만 
--			데이터 무결성을 확인하기 위해서 수시로 데이터를 검색하는 용도로 사용되는
--			'기본키'나 '유일키(=unique)'는 인덱스 자동 생성
--user_indexES나 user_IND_columnS(컬럼이름까지 검색가능) 데이터 사전에서 index 객체 확인 가능하다.

--index 생성: CREATE INDEX [인덱스명] ON [테이블명(컬럼1, 컬럼2, 컬럼3....);
--index 삭제: DROP INDEX 인덱스명;

/*
 * <index 생성 전략>
 * 생성된 index를 가장 효율적으로 사용하려면 데이터의 분포도는 최대한으로 
 * 그리고 조건절에 호출빈도는 자주 사용되는 컬럼을 index로 생성하는 것이 좋다.
 * index는 특정 컬럼을 기준으로 생성하고 기준이 된 컬럼으로 '정렬된 index 테이블'이 생성된다.
 * 이 기준 컬럼은 최대한 중복이 되지 않는 값이 좋다.
 * 가장 최선은 PK로 인덱스를 생성하는 것이다.
 * 
 * 1. 조건절에 자주 등장하는 컬럼
 * 2. 항상 = 으로 비교되는 컬럼
 * 3. 중복되는 데이터가 최소한인 컬럼
 * 4. order by절에서 자주 사용되는 컬럼
 * 5. 조인조건으로 자주 사용되는 컬럼
 */
--두 테이블에 자동으로 생성된 index 살펴보기
select index_name, table_name, column_name
from user_IND_columns
where table_name IN('EMPLOYEE', 'DEPARTMENT');

--사용자가 직접 index 생성
create index idx_employee_ename
on employee(ename);
--확인
select index_name, table_name, column_name
from user_IND_columns
where table_name IN('EMPLOYEE');

--※하나의 테이블에 index가 많으면 DB 성능에 좋지 않은 영향을 미칠수 있다. ---> index 제거
DROP index idx_employee_ename;
--확인
select index_name, table_name, column_name
from user_IND_columns
where table_name IN('EMPLOYEE');

----------------------------------------------------------------------------
----------------------------------------------------------------------------
--북스 P299
--인덱스 내부구조는 B-Tree(Balanced= 균형트리)으로 구성되어 있다.
--컬럼에 인덱스를 설정하면 이를 B-Tree도 생성되어야 하기 때문에
--인덱스 생성 위한 시간도 필요하고 인덱스를 위한 추가공간도 필요

--인덱스 생성 후에 새로운 행을 추가하거나 삭제할 경우
--인덱스로 사용된 컬럼값도 함께 변경---> 내부 구조(B-Tree)도 함께 변경된다.
--오라클 서버가 이 작업을 자동으로 발생하므로 인덱스가 있는 경우의 
--DML(=Data Manipulation Language)작업이 훨씬 무거워진다.(=속도가 느리다)
--계획성없이 너무 만은 인덱스를 지정하면 오히려 성능을 저하시킬 수 있다.

--최대 3개의 자식을 갖는 B-Tree에서 3을 찾는다면
--					4(root=뿌리)노드
--			2			6	
--		1		3	5		7

--북스 P300 표 정리
--<인덱스 사용해야 하는 경우>
--테이블의 행수 많을 때
--while문에 해당 컬럼이 많이 사용될 때
--검색결과가 전체 데이터의 2% ~ 4% 정도일 때 
--join에 자주 사용되는 컬럼이나 null을 포함하는 컬럼이 많을 때

--<인덱스 사용하지 말아야 하는 경우>
--테이블의 행 수 적을 때
--where문에 해당 컬럼이 많이 사용되지 않을 때
--					10 ~ 15% 이상일 때
--테이블에 DML(=Data Manipulation Language)작업이 많은 경우, 
--즉 입력 수정 삭제 등이 자주 일어날 때 사용한다.

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--★교재 이외 내용
--(예)인덱스 사용해야 하는 경우
create table emp12
as
select * 
from employee;

select distinct ename
from emp12
where dno = 10;

--쿼리문의 조건이
--1. 테이블에 전체 행의 수: 10000건
--2. 위 쿼리문이 전체 쿼리문 중에서 95% 사용된다.
--3. 쿼리문의 결과로 구해지는 행: 200건 정도라면 dno 컬럼은 인덱스를 사용하는 것이 효율적이다.
--							검색결과가 전체 데이터의 2 ~ 4% 정도이므로 인덱스가 있어야 검색을 빨리할 수 있기 때문이다.

--인덱스가 생성된 후에 새로운 행이 추가, 삭제, 수정 작업이 잦으면
--node의 갱신이 주기적으로 일어나 '단편화' 현상 발생
--단편화(=fragmentation): 삭제된 레코드의 인덱스 값 자리가 비게 되는 현상
-- ---> 검색 성능 저하된다.
--따라서
alter index idx_employee_ename rebuild;--인덱스를 다시 생성하여
--기존의 단편화가 많은 인덱스를 버리는 작업을 해야 빠른 효율을 누릴 수 있다.

--<테이블에서 컬럼을 데이터가 입력 수정 삭제될 경우, 해당 컬럼에 의해 생성된 '인덱스에 대해서 재구성을 해야하는 이유'?
--1. 인덱스르 구성하는 B-Tree에서는 인덱스 키에 의해서 일정한 정렬 순서를 유지하고 있다.
---- 새로운 노드가 추가되면,
---- 이 노드에 의해서 인덱스의 정렬 순서가 재구성되어야만 인덱스 키의 정렬 순서를 유지 할 수 있기 때문이다.
--2. 단편화현상을 해결하여 검색 성늘 올리기 위해
----------------------------------------------------------------------------
----------------------------------------------------------------------------

--4. 인덱스 종류(P 301참조)
--4.1 고유/비 고유 인덱스
--고유인덱스: 기본키(unique + not null)나 유일키(unique)처럼 유일한 값을 갖는 컬럼에 생성된 인덱스
--			unique 있으면 (예) 부서 테이블의 부서번호
--비고유 인덱스: 중복된 데이터를 갖는 컬럼에 생성된 인덱스
--			unique 없으면(예) 부서테이블의 부서명이나 지역명
create UNIQUE index 인덱스명
ON 테이블명(컬럼명);

--고유인덱스 지정하기
create UNIQUE index idx_dept_dno
ON dept12(dno));
--실퍠: invalid CREATE INDEX option
--이유: 위에서 '기본키 제약조건 추가'하면서 자동으로 index 생성되었다.

--방법-1: 실패 -자동생성된 dno의 index를 찾아서 제거하기 위한 방법
select index_name, table_name, column_name
from user_ind_columnS
where table_name in('DEPT12');

drop table SYS_C007132;--실패: 제약조건명 이름과 같다.

--방법-2: 성공 - dno의 기본키 제약조건 제거 찾아 제거 후 ---> 다시 dno에 고유 인덱스 지정하기
--dno: 기본키 제약조건 제거
select table_name, constraint_name, constraint_type
from user_ind_constraintS
where table_name in('DEPT12');

alter table dept12
drop constraint SYS_C007132 cascade;

--dno에 고유 인덱스 지정하기(성공) 
create UNIQUE index idx_dept_dno
on dept12(dno);

--★★고유 인덱스가 지정되려면 추가한 데이터에 중복된 값이 있어서는 안된다.
--만약 오류가 발생한다면 cannot CREATE UNIQUE index idx_dept_loc; duplicate keys found
--중복된 데이터가 있기 때문이다.
create UNIQUE index idx_dept_loc
on dept12(loc);--성공

--------------------------------------------------------
--★★고유 인덱스가 지정되려면 추가한 데이터에 중복된 값이 있어서는 안된다. (테스트)
--테스트 위한 것이다.
create table dept12_2
as
select * from department;
--테이블 구조와 데이터 복사된다.(제약조건 복사 안된다.dno는 기본키가 아니다.)

insert into dept12_2 values(10, 'ACCOUNTING', 'SEOUL');

select * from dept12_2;
--성공(dno는 기본키가 아니므로 중복된 10 입력가능하다.) 현재 dno는 10으로 중복, loc 중복된 값이 없다.

--dno에 고유 index 지정하기
drop index idx_dept12_2_dno;

create UNIQUE index idx_dept12_2_dno
on dept12_2(dno);
--실패:cannot CREATE UNIQUE INDEX; duplicate keys(=중복된 키) found
--dept12_2를 생성할 때 department의 제약조건을 상속(복사)받지 못해서
--dno가 기본키가 아니다.---> dno 10이 2번 중복 저장된다.

--loc에 고유index 지정하기
create UNIQUE index idx_dept12_2_loc
on dept12_2(loc);
--성공: loc값은 중복된 값이 없으므로 고유인덱스 지정 가능하다.

--------------------------------------------------------

--지금까지 생성한 인덱스는 '단순 인덱스'(한개의 컬럼으로 구성한 인덱스)--
--4.2 결합인덱스: 두 개 이상의 컬럼으로 구성한 인덱스
create index idx_dept_complex
on dept12(dname, loc);

--idx_dept_complex 인덱스를 이용하여 검색속도를 높이는데 사용되는 예
select * 
from dept12
where dname=' ' and loc=' ';
--그런데 위 쿼리가 거의 사용되지 않는다면 오히려 성능저하가 발생한다.

select * 
from dept12
where dname=' '; 
--dname에 index가 없으면 
--dname과 loc를 결합하여 생성한 idx_dept_complex 인덱스를 사용하여 검색한다.
--따라서 전체 테이블 검색보다 더 효율적이다.

--4.3 함수기반 인덱스: 수식이나 함수를 적용하여 만든 인덱스이다.
create index idx_emp12_salary12
on emp12(salary*12);--수식이므로 컬럼명이 없어서 가상 컬럼이 생성된다.

select --index_name, table_name, column_name
from user_ind_columnS--컬럼명 확인하기 위해 user_ind_columnS 사전 이용
--from user_ind_columnS-- user_indexes 사전은 컬럼명 조회불가하다.
where table_name in('EMP12');--column_name은  SYS_NC000009$이다.

--<12장 시퀀스와 인덱스 혼자 해보기>-----------------------------
--1. 사원테이블의 사원번호가 자동으로 생성되도록 시퀀스를 생성하시오.
create sequence emp_up
start with 10
increment by 1;

--2. 사원번호를 시퀀스로부터 발급받으시오.
drop table emp01;

create table emp01(
empno number(4) primary key,
ename varchar2(10),
hiredate date
);

--3. EMp01 테이블의 이름 컬럼을 인덱스로 설정하되 인덱스 이름을 IDX_EMP01_ENAME로 지정하시오.
select * from EMP;

create index IDX_EMP01_ENAME
on EMP01(ename);
