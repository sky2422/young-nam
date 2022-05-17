---<�Ͻ� 13��-����� ���Ѱ� ���̺� �����̽�>

--[���̺� �����̽�]---------------------------------------------------------------------
--����Ŭ������ Data file�̶�� ������ ���� ���·� �����ϰ�
--�̷��� Data file�� �ϳ� �̻� �𿩼� Tablespace��� ���� ������ �����Ѵ�.
/*
 * ������ ����		���� ����
 * 				DATABASE(=DB)
 * 				    |
 * datafile		TABLESPACE: ������ ���� ���� �� ���� ������ �մ� �����̴�.
 * (*.dbf)			|
 * 				segment: 1���� segment �������� extent(=Ȯ��)�� ���� table, Ʈ���� ��
 * 					|
 * 				extent: 1���� extent�� ���� ����  DB block���� �����Ǿ��ִ�.
 * 						extent�� �ݵ�� �޸𸮿� ���ӵ� ������ ��ƾ��Ѵ�.(����ȭ�� ������ ��ũ ������������ ����ȭ�� �ذ��Ѵ�.)
 * 					|
 * 				DB block: �޸𸮳� ��ũ���� Input/Output �� �� �ִ� �ּ� �����̴�.
 */
--��Ʈ����: �������� �Է�, �߰�, ���� ���� �̺�Ʈ�� �߻��� ������ �ڵ����� ����Ǵ� ����� ���� ���ν���

--[���̺����̽� ���� Dictionary] 
/*
 * .DBA_TABLESPACES : ��� ���̺����̽��� �������� �� ���������� ���� �ִ� Dictionary
 * .DBA_DATA_FILES  : ���̺����̽��� ��������
 * .DBA_FREE_SPACE  : ���̺����̽��� �������� ���� ����
 * .DBA_FREE_SPACE_COALESCED : ���̺����̽��� ������ �� �ִ� extent�� ����
 * 
 */
--Tablespace�� ����
--ù°, contents�� �����ϸ� 3���� �����̴�.
select tablespace_name, contents
from dba_tablespaceS;--��� ���̺����̽��� �������� �� ���� ����
--1. Permanent Tablespace
--2. Undo Tablespace
--3. Temporary Tablespace�� �����ȴ�.

--��°, ũ�� 2���� �������� �����ϸ�ȴ�.
--��, ����Ŭ DB�� ũ�� 2���� ������ Tablespace�� ����
--1. 'SYSTEM' ���̺����̽�(�ʼ�, �⺻): 
--    DB��ġ�� �ڵ����� �⺻������ ������ �ִ� ���̺� �����̽���,
--    ������ ���̺� �����̽��� �������� �ʰ� ���̺�, Ʈ����, ���ν��� ���� �����ߴٸ�
--    �� �ý��� ���̺� �����̽��� ����Ǿ��� ��
--    (��) Data Dictionary ����, ���ν���, Ʈ����, ��Ű��,
--    System Rollback segment ���Եȴ�.
--    ����� ������ ���� ����(��)����Ŭ ��ġ�ϸ� �⺻���� ����Ǿ� �ִ� emp�� dept���̺�(�� ���̺���� ����ڵ��� ��밡����)�̴�. 
--    
--    �� rollback segment��? rollback��commit�ϱ� �� ���·� �����µ� �� ������ ���� ���¸� �����ϰ� �ִ� ���׸�Ʈ�̴�.
          
--    DB��� �ʿ��� �⺻ ������ ��� �ִ� Data Dictionary Table�� ����Ǵ� ��������
--    DB���� ���� �߿��� Tablespace
--    �߿��� �����Ͱ� ����� �ִ� ��ŭ ������ ���� ��� �ڵ����� �����ͺ��̽��� ����� �� �����Ƿ�
--    �Ϲ� ����ڵ��� ��ü���� �������� �ʴ� ���� �����Ѵ�.
--    (Ȥ���� ����ڵ��� ��ü�� ������ ���� �����ͺ��̽��� ����ǰų� 
--     �Ϻ��� ������ �Ұ����� ��Ȳ�� �߻��� �� �ֱ� �����̴�.)

--2. 'NON-SYSTEM' ���̺����̽�
--   ���� ���뼺�ְ� DB�� ������ �� �ִ�.
--   (��) rollback segment,
--	 Temporary Segment,
--   Application Data Segment,
--   Index Segment,
--   User Data Segment ����

--�� Temporary���׸�Ʈ��?
--order by�� �ؼ� �����͸� �������� ���ؼ� �ӽ÷� ������ �����͸� ������ ���� ������ �ʿ��ϰ�
--�� ������ ������ �� �����͸� �������µ� �� ������ ����Ų��.

select default_tablespace--'SYSTEM'
from user_userS;

--1. <���̺� �����̽� ����>----------------------------------------------------------------
create tablespace [���̺����̽���]
datafile '���ϰ��'
size �ʱ� ������ ���� ũ�� �����Ѵ�. ��: size 10M
AUTOextend ON next 1M--size�� ������ �ʱ� ũ�� ������ ��� ����ϴ� ��� �ڵ����� ������ ũ�Ⱑ Ŀ���� ���� �����ϴ�.
							 --K(ų�� ����Ʈ), M(�ް� ����Ʈ) �� ������ ����� �� �ִ�.
							 --1024K=1M
MXASIZE 250M--������������ �ִ�� Ŀ�� �� �ִ� ũ�� ����(�⺻��: unlimited ������)
uniform size 1M--extend 1���� ũ��
--(1)
create tablespace test_data
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data01.dbf' 
size 10M
default storage(initial 2M--���� extend ũ��
				next 1M--ó�� 2M�� �� ���� 1M�� �����ȴ�. ���ӵ� ������ ��ƾ� �Ѵ�.
				minextents 1
				maxextents 121--122���ʹ� ������ �߻��Ѵ�.
				pctincrease 50);--�⺻��: ������ �Ҵ��� extent�� ��ġ�� %�� ��Ÿ�����̴�.
--pctincrease 50%���� �����ϸ� ó���� 1M = 1024K, �� ��°���ʹ� 1M�� ���� 512K, �� ������ �� 512K�� ���� 256K �Ҵ��Ѵ�.

--default storage �����ϸ� ' �⺻������ ������ ��'���� �����ȴ�.

--(2)tablespace ��ȸ�ϱ�
select tablespace_name, status, segment_space_management
from dba_tablespaceS;--��� ���̺� �����̽��� storage ���� �� ���� ����

--2. <���̺����̽� ����>----------------------------------------------------------------
--test_data ���̺� �����̽��� datafile 1�� �� �߰�
alter tablespace test_data
add datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data02.dbf' 
size 10M;
--10M + 10M = 20M
--��, ���������� 2���� ������ ���Ϸ� �����Ǿ��� �ϳ��� ���̺����̽��� ���������.

--3. <���̺����̽��� data file ũ�� ����>----------------------------------------------------
--3-1. �ڵ����� ũ�� ����
alter tablespace test_data
add datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data03.dbf' 
size 10M
AUTOextend ON next 1M
MAXSIZE 250M;
--test_data03.dbf'�� ũ���� 10M�� �ʰ��ϸ� �ڵ����� 1M�� �þ �ִ� 250M���� �þ��.
--������: MAXSIZE 250M ---> �⺻���� unlimited(������)���� �����ϸ� ���� �߻��� ���ɼ��� �ִ�.
--		��: ������������ ���� 1���� �ڵ帵 �� �� �ִ� ����� 2G�� �����Ǿ� �����Ƿ�
--			����, data file�� 2G�� ������ �� ������ �����߻��ϹǷ�
--			�������̸� MAXSIZE �����Ͽ� ����ϴ� ���� �ٶ����ϴ�.

--3-2. �������� ũ�� ����(�ڡ�����: alter database)
alter database
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data02.dbf'
REsize 20M;--10M ---> 20M�� ũ�� ���� 
--�ϳ��� ���̺����̽�(test_data) = �� 40M�� 3���� ������ datafile�� �����Ǿ���.

--4. <data file �뷮 ��ȸ>---------------------------------------------------------------
select tablespace_name, bytes/1024/1024MB, file_name, autoextensible as "auto"
from dba_data_fileS;--���̺� �����̽��� ���� ����

--���̺����̽��� ���������� extend�� ���� ��� ���� ��ȸ
select tablespace_name, total_extents, extents_coalesced, percent_extents_coalesced
from dba_free_space_coalesced;--���̺����̽��� ������ �� �ִ� extents�� ����
--total_extents: ��� ������ extents�� ��
--extents_coalesced: ������ ��� ������ extents�� ��
--percent_extents_coalesced: �� ������ �� %?
--4�� ��µǴµ� ���� 100%�̴�.
--100���� ������ ����ȭ�� ��ƴ�. 

--5. <���̺����̽� ����ȭ�� ���� ����: ��, ��ũ ��������>-------------------------------------
alter tablespace ���̺����̽��� coalesce;
alter tablespace test_data coalesce;

--6. <���̺����̽� �����ϱ�>-------------------------------------------------------------
--����
drop tablespace ���̺����̽���;--���̺����̽� ���� ��ü�� �����ϸ� �����Ұ��ϴ�.
[INCLUDING CONTENTS]--<�ɼ�1>�ذ��: ��� ����(��ü) �����Ͽ� ����
					--�׷���, Ž���⿡�� Ȯ���غ��� ������ data file�� ������ �ȵȴ�.
[INCLUDING CONTENTS and datafileS]--<�ɼ�2>�ذ��: �������� file���� �Բ� �����ϱ�
[CASCADE constraintS]--<�ɼ�3> �������Ǳ��� �Բ� ����

--����, ���̺� �ϳ� ����(test_data���̺����̽���)
create table test3(
a char(1))
tablespace test_data;

drop tablespace test_data;
--����: tablespace not empty, use INCLUDING CONTENTS option

--�ذ��<�ɼ�1>
drop tablespace test_data
INCLUDING CONTENTS;
--����: Ž���⿡�� Ȯ���غ��� ������ data file�� ������ �ȵǴ� ���� Ȯ���ϰ�
--����, ���� delete�� ���� �ؾ��Ѵ�.

--�ذ��<�ɼ�2>
drop tablespace test_data
INCLUDING CONTENTS and datafileS;

--�ذ��<�ɼ�3>
--�׷���, 'A���̺����̽��� ��� ���̺�(dno:FK)'��'B���̺����̽��� �μ� ���̺�(dno:PK)'�� �����ϴ� ��Ȳ����
--B���̺����̽��� �� ���(�ɼ�2)ó�� �����Ѵٸ� '���� ���ἱ'�� ����Ǹ鼭 ���� �߻��Ѵ�.
drop tablespace B
INCLUDING CONTENTS and datafileS
CASCADE constraintS;--�������Ǳ��� �����Ͽ� �ذᰡ���ϴ�.

-------------------------------------------------------------------------------------
--���� P 308--------------------------------------------------------------------------
--1. ������
--����Ŭ ���� ��å: 2����(�ý��� ���� ---> �ý��� ����, ������ ���� ---> ��ü ����(=Object Privileges)
--[1] �ý��ۺ���(=System Privileges): DB�� ���� ������ ����, ����� ������ ��ȣ �Է��ؼ� �����޾ƾ� �Ѵ�.
--[2] �����ͺ���: ����ڰ� ������ ��ü�� ���� �������� ������ �ֱ� ������
--				�����͸� ��ȸ�Ұų� �����Ҽ� ������
--				�ٸ� ����ϴ� ��ü�� �����ڷκ��� ���� ������ �޾ƾ� ��밡���ϴ�.

--����: �ý����� �����ϴ� '�ý��� ����', ��ü�� ����� �� �ֵ��� �����ϴ� '��ü ����'

--���� P 308 ǥ-�ý��� ����: 'DBA ������ ���� �����'�� �ý��� ������ �ο��Ѵ�.
--1. create session: DB ����(=����)�� �� �ִ� ����

--2. create table: ���̺� ������ �� �ִ� ����
--3. unlimited tablespace: ���̺����̽��� ����� �Ҵ��� �� �ֵ��� ���ִ� ����
--�׷��� unlimited tablespace�ϸ� ���� �߻��� �� �ִ�.(default tablespace)
--...

--4. create sequence: ������ ���� �� �� �ִ� ����
--5. create view: �� ���� �� �� �ִ� ����
--6. select any table: ������ ���� �ڰ� ��� ���̺�, ��� �˻� ����
--�̿ܿ��� 100���� �̻��� �ý��� ������ �ִ�.
--DBA�� ����ڸ� ������ ������ ������ �ý��۱����� �ο��ؾ� �Ѵ�.

--<�ý��۱���>---------------------------------------------------------------
--������ ��ü�� ������ ������ ���� ��ɾ�: DCL(=Data Manipulation Language) (GRANT, REVOKE)
/*
 * �ý��� ���� ����: '�ݵ�� DBA ����' ���� ����ڸ� ���� �ο��� �� �ִ�.
 * GRANT 'create session' To ������̸�|��(rolw)|public(��� �����)[with ADDMIN option]
 */

--<�ǽ�����>
--'DBA����' ���� SYSTEM���� �����Ͽ� ������� �̸��� ��ȣ �����Ͽ� ����� �����ϱ�

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

--1. ���� �ذ���-1: ó������ unlimited tablespace ������ �ش�.
SQL> conn system/1234
Connected.
SQL> grant unlimited tablespace to user01;

Grant succeeded.
--default tablespace�� 'SYSTEM' ������ ������ ����� �� �ִ�.
--�׷���, ���� �ο��ϸ� ������ �߻� �� �� �ִ�.('SYSTEM' tablespace�� �߿��� �������� ���ȿ� ����ϴ�. ) 

--'user01'�� default_tablespace Ȯ��
select username, default_tablespace
from dba_userS
where username IN ('USER01')--default_tablespace: SYSTEM
--where lower(username) IN ('user01')

--2. ���� �ذ���-2: SYSTEM tablespace�� �߿��� �������� ���Ȼ� default_tablespace �����ϸ� �ȴ�.
alter user user01
default tablespace users--users: ����� �����Ͱ� �� ���̺� �����̽�
quota 5M on users;--5 mega �Ҵ�Ǿ���.

alter user user01
default tablespace users
quota unlimited on users;--unlimited: �뷮�� �������� �ʰ� ��� �� �� �ִ�.(-1�� ǥ�õȴ�.)

select username, tablespace_name, max_bytes
from dba_ts_quotas--quota�� ������ user�� ǥ��
where username In ('USER01');-- -1�� ��µǾ� ������ �뷮�� ���Ѵ�.
--1mega: 1024*1024
--1k: 1024 byte



















