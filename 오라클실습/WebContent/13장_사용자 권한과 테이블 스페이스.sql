---<북스 13장-사용자 권한과 테이블 스페이스>

--[테이블 스페이스]---------------------------------------------------------------------
--오라클에서는 Data file이라는 물리적 파일 형태로 저장하고
--이러한 Data file이 하나 이상 모여서 Tablespace라는 논리적 공간을 형성한다.
/*
 * 물리적 단위		논리적 단위
 * 				DATABASE(=DB)
 * 				    |
 * datafile		TABLESPACE: 데이터 저장 단위 중 가장 상위에 잇는 단위이다.
 * (*.dbf)			|
 * 				segment: 1개의 segment 여러개의 extent(=확장)로 구성 table, 트리거 등
 * 					|
 * 				extent: 1개의 extent는 여러 개의  DB block으로 구성되어있다.
 * 						extent는 반드시 메모리에 연속된 공강을 잡아야한다.(단편화가 많으면 디스크 조각모음으로 단편화로 해결한다.)
 * 					|
 * 				DB block: 메모리나 디스크에서 Input/Output 할 수 있는 최소 단위이다.
 */
--※트리거: 데이터의 입력, 추가, 삭제 등의 이벤트가 발생할 때마다 자동으로 수행되는 사용자 정의 프로시저

--[테이블스페이스 관련 Dictionary] 
/*
 * .DBA_TABLESPACES : 모든 테이블스페이스의 저장정보 및 상태정보를 갖고 있는 Dictionary
 * .DBA_DATA_FILES  : 테이블스페이스의 파일정보
 * .DBA_FREE_SPACE  : 테이블스페이스의 사용공간에 관한 정보
 * .DBA_FREE_SPACE_COALESCED : 테이블스페이스가 수용할 수 있는 extent의 정보
 * 
 */
--Tablespace의 종류
--첫째, contents로 구분하면 3가지 유형이다.
select tablespace_name, contents
from dba_tablespaceS;--모든 테이블스페이스의 저장정보 및 상태 정보
--1. Permanent Tablespace
--2. Undo Tablespace
--3. Temporary Tablespace로 구성된다.

--둘째, 크게 2가지 유형으로 구분하면된다.
--즉, 오라클 DB는 크게 2가지 유형의 Tablespace로 구성
--1. 'SYSTEM' 테이블스페이스(필수, 기본): 
--    DB설치시 자동으로 기본적으로 가지고 있는 테이블 스페이스로,
--    별도로 테이블 스페이스를 지정하지 않고 테이블, 트리거, 프로시저 등을 생성했다면
--    이 시스템 테이블 스페이스에 저장되었던 것
--    (예) Data Dictionary 정보, 프로시저, 트리거, 패키지,
--    System Rollback segment 포함된다.
--    사용자 데이터 포함 가능(예)오라클 설치하면 기본으로 저장되어 있는 emp나 dept테이블(이 테이블들은 사용자들이 사용가능함)이다. 
--    
--    ※ rollback segment란? rollback시commit하기 전 상태로 돌리는데 그 돌리기 위한 상태를 저장하고 있는 세그먼트이다.
          
--    DB운영에 필요한 기본 정보를 담고 있는 Data Dictionary Table이 저장되는 공간으로
--    DB에서 가장 중요한 Tablespace
--    중요한 데이터가 담겨져 있는 만큼 문제가 생길 경우 자동으로 데이터베이스를 종료될 수 있으므로
--    일반 사용자들의 객체들을 저장하지 않는 것을 권장한다.
--    (혹여나 사용자들의 객체에 문제가 생겨 데이터베이스가 종료되거나 
--     완벽한 복구가 불가능한 상황이 발생할 수 있기 때문이다.)

--2. 'NON-SYSTEM' 테이블스페이스
--   보다 융통성있게 DB를 관리할 수 있다.
--   (예) rollback segment,
--	 Temporary Segment,
--   Application Data Segment,
--   Index Segment,
--   User Data Segment 포함

--※ Temporary세그먼트란?
--order by를 해서 데이터를 가져오기 위해선 임시로 정렬할 데이터를 가지고 있을 공간이 필요하고
--그 곳에서 정렬한 뒤 데이터를 가져오는데 이 공간을 가리킨다.

select default_tablespace--'SYSTEM'
from user_userS;

--1. <테이블 스페이스 생성>----------------------------------------------------------------
create tablespace [테이블스페이스명]
datafile '파일경로'
size 초기 데이터 파일 크기 설정한다. 예: size 10M
AUTOextend ON next 1M--size로 설정한 초기 크기 공간을 모두 사용하는 경우 자동으로 파일의 크기가 커지는 것이 가능하다.
							 --K(킬로 바이트), M(메가 바이트) 두 단위를 사용할 수 있다.
							 --1024K=1M
MXASIZE 250M--데이터파일이 최대로 커질 수 있는 크기 지정(기본값: unlimited 무제한)
uniform size 1M--extend 1개의 크기
--(1)
create tablespace test_data
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data01.dbf' 
size 10M
default storage(initial 2M--최초 extend 크기
				next 1M--처음 2M가 다 차면 1M가 생성된다. 연속된 공간을 잡아야 한다.
				minextents 1
				maxextents 121--122부터는 오류가 발생한다.
				pctincrease 50);--기본값: 다음에 할당할 extent의 수치를 %로 나타낸것이다.
--pctincrease 50%으로 지정하면 처음은 1M = 1024K, 두 번째부터는 1M의 반인 512K, 그 다음에 또 512K의 반인 256K 할당한다.

--default storage 생략하면 ' 기본값으로 지정된 값'으로 설정된다.

--(2)tablespace 조회하기
select tablespace_name, status, segment_space_management
from dba_tablespaceS;--모든 테이블 스페이스의 storage 정보 및 상태 정보

--2. <테이블스페이스 변경>----------------------------------------------------------------
--test_data 테이블 스페이스에 datafile 1개 더 추가
alter tablespace test_data
add datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data02.dbf' 
size 10M;
--10M + 10M = 20M
--즉, 물리적으로 2개의 데이터 파일로 구성되어진 하나의 테이블스페이스가 만들어진다.

--3. <테이블스페이스의 data file 크기 조절>----------------------------------------------------
--3-1. 자동으로 크기 조절
alter tablespace test_data
add datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data03.dbf' 
size 10M
AUTOextend ON next 1M
MAXSIZE 250M;
--test_data03.dbf'의 크기인 10M를 초과하면 자동으로 1M씩 늘어나 최대 250M까지 늘어난다.
--★주의: MAXSIZE 250M ---> 기본값인 unlimited(무제한)으로 변경하면 문제 발생할 가능성이 있다.
--		예: 리눅스에서는 파일 1개를 핸드링 할 수 있는 사이즈가 2G로 한정되어 있으므로
--			따라서, data file이 2G를 넘으면 그 때부터 오류발생하므로
--			가급적이면 MAXSIZE 지정하여 사용하는 것이 바람직하다.

--3-2. 수동으로 크기 조절(★★주의: alter database)
alter database
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data02.dbf'
REsize 20M;--10M ---> 20M로 크기 변경 
--하나의 테이블스페이스(test_data) = 총 40M인 3개의 물리적 datafile로 구성되었다.

--4. <data file 용량 조회>---------------------------------------------------------------
select tablespace_name, bytes/1024/1024MB, file_name, autoextensible as "auto"
from dba_data_fileS;--테이블 스페이스의 파일 정보

--테이블스페이스의 수집가능한 extend에 대한 통계 정보 조회
select tablespace_name, total_extents, extents_coalesced, percent_extents_coalesced
from dba_free_space_coalesced;--테이블스페이스가 수용할 수 있는 extents의 정보
--total_extents: 사용 가능한 extents의 수
--extents_coalesced: 수집된 사용 가능한 extents의 수
--percent_extents_coalesced: 그 비율은 몇 %?
--4개 출력되는데 전부 100%이다.
--100보다 작으면 단편화가 어렵다. 

--5. <테이블스페이스 단편화된 공간 수정: 즉, 디스크 조각모음>-------------------------------------
alter tablespace 테이블스페이스명 coalesce;
alter tablespace test_data coalesce;

--6. <테이블스페이스 제거하기>-------------------------------------------------------------
--형식
drop tablespace 테이블스페이스명;--테이블스페이스 내에 객체가 존재하면 삭제불가하다.
[INCLUDING CONTENTS]--<옵션1>해결법: 모든 내용(객체) 포함하여 삭제
					--그러나, 탐색기에서 확인해보면 물리적 data file은 삭제가 안된다.
[INCLUDING CONTENTS and datafileS]--<옵션2>해결법: 물리적인 file까지 함께 삭제하기
[CASCADE constraintS]--<옵션3> 제약조건까지 함께 삭제

--먼저, 테이블 하나 생성(test_data테이블스페이스에)
create table test3(
a char(1))
tablespace test_data;

drop tablespace test_data;
--실패: tablespace not empty, use INCLUDING CONTENTS option

--해결법<옵션1>
drop tablespace test_data
INCLUDING CONTENTS;
--성공: 탐색기에서 확인해보면 물리적 data file은 삭제가 안되는 것을 확인하고
--따라서, 직접 delete로 삭제 해야한다.

--해결법<옵션2>
drop tablespace test_data
INCLUDING CONTENTS and datafileS;

--해결법<옵션3>
--그런데, 'A테이블스페이스의 사원 테이블(dno:FK)'이'B테이블스페이스의 부서 테이블(dno:PK)'를 참조하는 상황에서
--B테이블스페이스로 위 방법(옵션2)처럼 삭제한다면 '참조 무결선'에 위배되면서 오류 발생한다.
drop tablespace B
INCLUDING CONTENTS and datafileS
CASCADE constraintS;--제약조건까지 삭제하여 해결가능하다.

-------------------------------------------------------------------------------------
--교재 P 308--------------------------------------------------------------------------
--1. 사용권한
--오라클 보안 정책: 2가지(시스템 보안 ---> 시스템 권한, 데이터 보안 ---> 객체 권한(=Object Privileges)
--[1] 시스템보안(=System Privileges): DB에 접근 권한을 설정, 사용자 계정과 암호 입력해서 인증받아야 한다.
--[2] 데이터보안: 사용자가 생성한 객체에 대한 소유권을 가지고 있기 때문에
--				데이터를 조회할거나 조작할수 있지만
--				다른 사용하는 객체의 소유자로부터 접근 권한을 받아야 사용가능하다.

--권한: 시스템을 관리하는 '시스템 권한', 객체를 사용할 수 있도록 관리하는 '객체 권한'

--교재 P 308 표-시스템 권한: 'DBA 권한을 가진 사용자'가 시스템 권한을 부여한다.
--1. create session: DB 접속(=연결)할 수 있는 권한

--2. create table: 테이블 생성할 수 있는 권한
--3. unlimited tablespace: 테이블스페이스에 블록을 할당할 수 있도록 해주는 권한
--그러나 unlimited tablespace하면 문제 발생할 수 있다.(default tablespace)
--...

--4. create sequence: 시퀀스 생성 할 수 있는 권한
--5. create view: 뷰 생성 할 수 있는 권한
--6. select any table: 권한을 받은 자가 어느 테이블, 뷰라도 검색 가능
--이외에도 100여개 이상의 시스템 권한이 있다.
--DBA는 사용자를 생성할 때마다 적절한 시스템권한을 부여해야 한다.

--<시스템권한>---------------------------------------------------------------
--소유한 객체의 사용권한 관리를 위한 명령어: DCL(=Data Manipulation Language) (GRANT, REVOKE)
/*
 * 시스템 권한 형식: '반드시 DBA 권한' 가진 사용자만 권한 부여할 수 있다.
 * GRANT 'create session' To 사용자이름|롤(rolw)|public(모든 사용자)[with ADDMIN option]
 */

--<실습시작>
--'DBA권한' 가진 SYSTEM으로 접속하여 사용자의 이름과 암호 지정하여 사용자 생성하기

SQL> conn system/1234
Connected.
SQL> create user user01 identified by 1234;

User created.

SQL> conn user01/1234
ERROR:
ORA-01045: user USER01 lacks CREATE SESSION privilege; logon denied

Warning: You are no longer connected to ORACLE.
SQL> conn system/1234
Connected.
SQL> grant create session, create table to user01;

Grant succeeded.

SQL> conn user01/1234
Connected.
SQL> create table sampletb1(no number);
create table sampletb1(no number)
*
ERROR at line 1:
ORA-01950: no privileges on tablespace 'SYSTEM'

--1. 실패 해결방법-1: 처음부터 unlimited tablespace 권한을 준다.
SQL> conn system/1234
Connected.
SQL> grant unlimited tablespace to user01;

Grant succeeded.
--default tablespace인 'SYSTEM' 영역을 무제한 사용할 수 있다.
--그러나, 권한 부여하면 문제가 발생 할 수 있다.('SYSTEM' tablespace의 중요한 데이터의 보안에 취약하다. ) 

--'user01'의 default_tablespace 확인
select username, default_tablespace
from dba_userS
where username IN ('USER01')--default_tablespace: SYSTEM
--where lower(username) IN ('user01')

--2. 실패 해결방법-2: SYSTEM tablespace의 중요한 데이터의 보안상 default_tablespace 변경하면 된다.
alter user user01
default tablespace users--users: 사용자 데이터가 들어갈 테이블 스페이스
quota 5M on users;--5 mega 할당되었다.

alter user user01
default tablespace users
quota unlimited on users;--unlimited: 용량을 제한하지 않고 사용 할 수 있다.(-1로 표시된다.)

select username, tablespace_name, max_bytes
from dba_ts_quotas--quota가 설정된 user만 표시
where username In ('USER01');-- -1로 출력되어 무제한 용량을 말한다.
--1mega: 1024*1024
--1k: 1024 byte



















