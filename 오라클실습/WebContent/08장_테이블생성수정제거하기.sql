--<�Ͻ� 8��_���̺� ���� ���� �����ϱ�>

--������ ���Ǿ�(DDL=Data Definition Languade)
--1. CREATE: DB ��ü ����
--2. ALTER: DB ����
--3. DROP: DB ����
--4. RENAME: DB �̸�����
--5. TRUNCATE: ������ �� ���� ���� ����

/*
 * DELETE(DML: ������ ���۾�), TRUNCATE, DROP(DDL: ������ ���Ǿ�) ��ɾ��� ������
 * (DELETE, TRUNCATE, DROP ��ɾ�� ��� �����ϴ� ��ɾ������� �߿��� �������� �ִ�.)
 * 1. DELETE��ɾ�: �����ʹ� ���������� ���̺� �뷮�� �پ� ���� �ʴ´�. ���ϴ� �����͸� ������ �� �ִ�.
 * 					���� �� �߸� ������ ���� �ǵ��� �� �ֵ�.(rollback)
 * 
 * 2. TRUNCATE��ɾ�: �뷮�� �پ���, index � ��� �����ȴ�.
 * 					�������� �������� �ʰ�, ���̺� �����ȴ�.
 * 					�Ѳ����� �� �������Ѵ�.
 * 					 ���� �Ŀ� ���� �ǵ��� �� ����.
 * 
 * 3. DROP��ɾ�: ���̺� ��ü�� ����(���̺����, ��ü�� �����Ѵ�.)
 * 				���� �Ŀ� ���� �ǵ��� �� ����.
 * 
 */

--1. ���̺����� ����� CREATE TABLE��(���� P206)
--���̺� �����ϱ� ���ؼ��� ���̺�� ����, ���̺��� �����ϴ� �ķ��� ������ Ÿ�԰� ���Ἲ ���� ���� ����

--<���̺� �� �÷��� ���� ��Ģ>
--����(���� ��ҹ���)�� ����, 30�� �̳�
--����(���� ��ҹ���)�� ����, ���� 0~9, Ư������(_ $ #)�� ��밡��
--��ҹ��� ��������, �ҹ��ڷ� �����Ϸ��� ''�� ������� ��
--���� ������� �ٸ� ��ü�� �̸��� �ߺ� �Ұ��ϴ�. ��)SYSTEM�� ���� ���̺����� �� �޶�� �Ѵ�.

--<���������� �̿��Ͽ� �ٸ� ���̺�κ��� �����Ͽ� ���̺� ���� ���>
--�������������� �μ� ���̺��� ������ ������ ���� ---> ���ο� ���̺� ����
--CREATE TABLE ���̺��(�÷��� ��� O): ������ �ķ����� ������ Ÿ���� ���������� �˻��� �÷��� ��ġ 
--CREATE TABLE ���̺��(�÷��� ��� X): ���������� �÷����� �״�� ����
--
--���Ἲ ��������: �ڡ�not null ���Ǹ� ����, 
--				�⺻Ű(=PK), �ܷ�Ű(=FK)�� ���� ���Ἲ���������� ����ȵȴ�.
--				����Ʈ �ɼǿ��� ������ ���� ����
--
--���������� ��� ����� ���̺��� �ʱ� �����ͷ� ���Ե�

--(��)CREATE TABLE ���̺��(�÷��� ��� O)
--[����] �������������� �μ� ���̺��� ������ ������ �����ϱ�(�ڡ�'��������'�� ����ȵȴ�.�ڡ�not null ���Ǹ� ����)
select dno--�÷��� 1��
from department;

CREATE TABLE dept1(dept_id)--�÷��� 1��(�ڡ�'��������'�� ����ȵȴ�.�ڡ�not null ���Ǹ� ����)
AS
select dno--�÷��� 1��
from department;-- select department������ ���������� �� �� �ִ�.

select * from dept1;

--(��)CREATE TABLE ���̺��(�÷��� ��� X)
--[����] 2�� �μ� �Ҽ� ����� ���� ������ ������ dept2 ���̺� �����ϱ�
--[1]. 2�� �μ� �Ҽ� ����� ���� ���� ��ȸ
select eno, ename, salary*12 as "����"
from employee
where dno = 20;

--[2]. �ڡڼ������������� '�����'�� ���� ��Ī �����ؾ���
CREATE TABLE dept2
AS
select eno, ename, salary*12 as "����"
from employee
where dno = 20;

select * from dept2;

CREATE TABLE dept_err
AS
select eno, ename, salary*12--as "����"(��Ī ������ ����)
from employee
where dno = 20;

--<���������� �����ʹ� �������� �ʰ� ���̺� ������ ������>
--���������� where���� �׻� ������ �Ǵ� ���� ����: ���ǿ� �´� �����Ͱ� ��� ������ ����ȵ�
--where 0=1
--[����] �μ����̺��� ������ �����Ͽ�dept3���̺� �����ϱ�
CREATE TABLE dept3
AS
select *
from department
WHERE 0=1;--���� ����

select * from dept3;-- ������ ����ǰ� �����ʹ� ������� �ʾҴ�.

--���̺� ���� Ȯ��
DESC dept3;--��Ŭ���������� ��ɾ ������� �ʴ´�.
--RUN SQL... â ���� Ȯ���غ��� ---> conn system/1234 ---> DESC dept3;

------------------------------------------------------------------------
--2. ���̺� ������ �����ϴ� ALTER
--2.1 �÷��߰�: �߰����÷��� ������ ��ġ�� ����(��, ���ϴ� ��ġ�� ������ �� ����.)

--[����] ������̺� dept2�� ��¥Ÿ���� ���� birth �÷��߰�
ALTER TABLE dept2
ADD birth date;
--�� ���̺� ������ �߰��� ������(��)�� ������ �߰��� �÷�(brith)�� �÷����� NULL�� �ڵ� �Էµ�

--[����]������̺� dept2
ALTER TABLE dept2
ADD email varchar2(50) DEFAULT 'test@test.com' not null;

select * from dept2;

--2.2 �÷�����
--���� �÷��� �����Ͱ� ���� ���: �÷�Ÿ���̳� ũ�� ���� ����
--���� �÷��� �����Ͱ� �ִ� ���: Ÿ�Ժ����� char�� varchar2(��������)�� ����ϰ� 
--							������ �÷��� ũ�Ⱑ ����� �������� ũ�⺸�� ���ų� Ŭ ��쿡�� ���氡����
--							����Ÿ���� �� �Ǵ� ��ü�ڸ��� �ø��� �ִ�.(�� : number, number(7), number(5,2)=number(��ü�ڸ���, �Ҽ���°�ڸ�)123.45)

--[����] ���̺� dept2���� ����̸��� �÷�ũ�⸦ ����
--run sql���� Ȯ�� �����ϴ�.
ALTER TABLE dept2
MODIFY ename varchar2(30);--�÷� ũ�� 10(10���� ���� ���� ���Ѵ�.) ---> 30���� ũ�� ����

desc dept2;

ALTER TABLE dept2
MODIFY ename char(30);--varchar2 ---> charŸ������ ����

ALTER TABLE dept2
MODIFY ename char(10);--�÷� ũ�� 30 ---> 10���� ���� �Ұ� --->����: ũ�⸦ �۰� ���� �Ұ�

ALTER TABLE dept2
MODIFY ename number(30);--����: ���� Ÿ�Գ����� ������ ����������, char�� varchar2�� ����
--����, char (30) ---> number�� �����ؾ� �ϴ� ���: �ش� �÷��� ���� ��� ������ ���� ����

ALTER TABLE dept2
MODIFY ename varchar2(40);

--[����] ���̺� dept2���� ����̸��� �÷��� ����(ename ---> ename2)
ALTER TABLE dept2
RENAME column ename TO ename2;

select *from dept2;

--[����] ���̺� dept2���� �÷� �⺻ �� ����--�̹� ������ �Ǿ� �־ �Ұ����ϴ�.
--���� �ȵ�? ename2�� �����Ͱ� null�� �Էµ� �����̹Ƿ� �÷������� �ȵȴ�.
ALTER TABLE dept2
MODIFY ename2 varchar2(40) DEFAULT 'AA' not null;
--�ذ���: ������ ������ �״�� �ΰ� �����͸� ����
TRUNCATE table dept2;
select * from dept2;

ALTER TABLE dept2
MODIFY ename2 varchar2(50) DEFAULT '�⺻' not null;
-----------------------------------------------

--�ڡ�DROP, SET unused: �� �� ������ ��  �ɵ����� ����. �׷��� �ٽ� ���� �̸��� �÷� ������ ����
--2.3 �÷�����: 2�� �̻� �ø��� ������ ���̺����� �÷� ���� ����
--[����] ���̺� dept2���� ����̸� ����
ALTER TABLE dept2
DROP column ename;

--�׷��� �ٽ� ���� �̸��� �÷� ������ ����(��)
ALTER TABLE dept2
ADD ename varchar2(20);

select * from dept2;

--2.4 set unused(������ �ʴ�): �ý����� �䱸�� ����  �� �÷��� ������ �� �ֵ��� �ϳ� �̻��� �÷��� unused�� ǥ��
--������ ���ŵ����� ����
--�����Ͱ� �����ϴ� ��쿡�� ������ ��ó�� ó���Ǳ� ������ select���� ��ȸ�� �Ұ����ϴ�.
--descibe ������ ǥ�õ��� �ʴ´�. (��: desc ���̺��; ���̺� ����Ȯ��)

--����ϴ� ����? 1. ����ڿ��� ������ �ʰ� �ϱ� ����
--		      2. unused�� �̻�� ���·� ǥ���� �� ���߿� �Ѳ����� DROP���� �����ϱ� ����	
--				��߿� �÷��� �����ϴ� ���� �ð��� ���� �ɸ��� �־ unused�� ǥ���صΰ� ���߿� �Ѳ����� drop���� �������ش�.

--[����] ���̺� dept2���� "����"�� unused ���·� �����
ALTER TABLE dept2
SET unused("����");

--[����] unused�� ǥ�õ� ��� �÷��� �Ѳ����� ����
ALTER TABLE dept2
DROP unused columns;--s����

--�׷��� �ٽ� ���� �̸��� �÷� ������ ����(��-2)
ALTER TABLE dept2
ADD salary number(20);

select * from dept2;

--[ORACLE 11G]
--ORACLE 11G���� ���� �÷��� ������ �ٲٱ� ���ؼ��� ���� ���̺��� �����ϰ� �ٽ� �����ؾ� �Ѵ�.
--��κ� �÷� ���� ������ �� �ʿ��� ��쿡�� �۾��� �ϰ� �� �ܴ� �������� �÷��� �߰��ϴ� ���̴�.

--[1] ���� ���̺��� ������ �÷� ������ ��ȸ �� �����̺� ���� (�ڡ�'��������'�� ����ȵȴ�.�ڡ�not null ���Ǹ� ����)
CREATE TABLE dept2_copy
AS
select eno, ename, salary, birth
from dept2;

--[2]���� ���̺� ����
DROP TABLE dept2;

--[3]�����̺� �̸����� (dept2_copy ---> dept2)
RENAME dept2_copy TO dept2;

select * from dept2;
--[4] ������: �������� �ٽ� �����ؾ� ��

------------------------------------------------------------------------------
--3. ���̺�� ����:rename�� �����̸� to ���̸�;
rename dept2 to emp2;

--4. ���̺� ������ ����: DROP TABLE ���̺��
--�ڡ�[department ���̺� ����-1]---> ����Ű�� ��Ȳ ��ü�� ���� �ϸ� department ���̺� ���� �����ϴ�.
--������ ���̺��� �⺻Ű�� ����Ű�� �ٸ� ���̺��� �����ϰ� �ִ� ��쿡 ���� �Ұ����ϴ�.
--�׷���  '�����ϴ� ���̺�(�ڽ� ���̺�)'�� ���� ���� �� �θ� ���̺� ������ �� �ִ�.
DROP TABLE department;--����
DROP TABLE employee;--���� ���� ��
DROP TABLE department;-- ����
--�����ϸ� 1�忡 ���� �ٽ� �ؾ��ϴ� ������ ���� ����.

--�ڡ�[department ���̺� ����-2]
--������̺��� ����Ű �������Ǳ��� �Բ� ����
DROP TABLE department cascade constraintS;--s�� �ٿ��� �ϼ�

select table_name, constraint_name, constraint_type
from user_constraintS
--table_name: �빮�ڷ� ---> �ҹ��ڷ� �����Ͽ� ã�� ���
where lower(table_name) in ('employee', 'department');
--where table_name in ('EMPLOYEE', 'DEPARTMENT');
-- �� �߿� �ϳ� ����ؾ� �Ѵ�.

--5. ���̺��� ��� �����͸� ����: TRUNCATE TABLE��
--���̺� ������ ����, ���̺� ������ �������ǰ� ������ �ε���, ��, ���Ǿ�� ������

select * from emp2;
insert into emp2 values(1,'kim', 2500, '2022-01-03',default);
select * from emp2;--��ȸ ��

TRUNCATE TABLE emp2;--�����͸� ����
select * from emp2;--Ȯ��

--6. ������ ����: ����ڿ� DB �ڿ��� ȿ�������� �������� �پ��� ������ �����ϴ� �ý��� ���̺� ����
--����ڰ� ���̺��� �����ϰų� ����ڸ� �����ϴ� ���� �۾��� �Ҷ�
--DB ������ ���� �ڵ� ���ŵǴ� ���̺�
--����ڰ� ��������x, ����x --->'�б����� ��'�� ����ڿ��� ������ ������

--6.1 USER_������ ����:'USER_�� ����~S(����)'�� ����
--����ڿ� ���� �����ϰ� ���õ� ��� 
--�ڽ��� ������ ���̺�, ��, �ε���, ���Ǿ� ���� ��ü�� �ش� ����ڿ��� ���� ���� ����
--(��) USER_table�� ����ڰ� ������ 'table'�� ���� ���� ��ȸ
select table_name
from USER_tableS;--�����(system)�� ������ 'table' ����

select sequence_name, min_value, max_value, increment_by, cycle_flag
from USER_sequenceS;--�����(system)�� ������ 'sequence' ����(P 292����)

select index_name
from USER_indexS;--�����(system)�� ������ 'index' ����
-- �˻��� ���� �� �� �ִ�.

select view_name
from USER_viewS;-- �����(system)�� ������ 'view' ����

--'���̺� ��������' ������ 'User_constraintS' ������ ���� �����
select table_name, constraint_name, constraint_type--P:PK=�⺻Ű, R=����Ű
from USER_constraintS
where table_name IN('TEST');--�ڡ�����: 1. �ݵ�� '�빮�ڷ�'
--where LOWER(table_name) IN ('employee');--2. LOWER()�Լ� ����Ͽ� �ҹ��ڷ� ����

--�ذ�ü: ���̺�, ������, �ε���, �� ��
--6.2 ALL_������ ����
--��ü ����ڿ� ���õ� ��, ����ڰ� ������ �� �ִ� ��� ��ü ���� ��ȸ
--owner:��ȸ ���� ��ü�� ������ �������� Ȯ��

--��) ALL_tableS�� ���̺� ���� ���� ��ȸ
--�����: system �϶� 500���ڵ�(SYS�� SYSTEM�� : �����(HR) ���ܵ� ���·� ����� ���´�.)
--�����: 	hr �϶� 78���ڵ�(�����(HR)�� �ٸ� ����ڵ� ���Ե� ����� ���´�.)
select owner, table_name
from ALL_tableS;

--where owner IN ('SYSTEM') OR table_name IN ('EMPLOYEE','DEPARTMENT');
--where owner IN ('EMPLOYEE','DEPARTMENT');

--���ǽĿ� owner IN ('HR')�߰��Ͽ� ��ȸ�ϸ� �����(HR) ����� ����
select owner, table_name--�����(HR) ���ܵ� ���·� ����� ����
from ALL_tableS
where owner IN ('HR');

--6.3 DBA_������ ����: system������ ���õ� view, DBA�� system ������ ���� ����ڸ� ���� ����
--���� ������ ����ڰ� hr(���������)�̶�� 'DBA_������ ����'�� ��ȸ�� ������ ����
--DBA ���� ���� system�������� �����ؾ� �׽�Ʈ ����

--(��) DBA_tableS�� ���̺� ���� ���� ��ȸ
--�����:system �� �� 500���ڵ�(SYS�� SYSTEM�� : �����(HR) ���ܵ� ���·� ����� ���´�.)
--					ALL_tableS�� ��ȸ�� ������ ���� ���
--			hr �� ��  table or tiew does not exist�� DBA ������ ����. ---> �������� �Ѱ�
select owner, table_name
from DBA_tableS;

select owner, table_name
from DBA_tableS
where owner IN('HR');
-------------------------------------------------------------------------------
--RUN SQL Command Line���� HR�� �����ϴ� ���
--1. RUN SQL â����
--connhr/hr
--����: account is locked

--2.������ Ȱ��ȭ��Ű�� ���ؼ� ������ ���� ����
--conn system/1234;
--alter user hr identified by hr account unlock;

--3. �ٽ� hr�� ����
--conn hr/hr
-------------------------------------------------------------------------------

--<08�� ���̺�������������ϱ� ȥ���غ���>-----------------------------
--1. ����ǥ�� ��õ� ��� DEPT ���̺� �����ϱ�
CREATE TABLE dept
dno number(2), dname varchar2(14), loc vachar2(13);


--2. EMP ���̺��� �����Ͻÿ�.
CREATE TABLE emp
eno number(4), ename varchar2(10), dno number(2);


--3. �� �̸��� ������ �� �ֵ��� emp ���̺��� �����Ͻÿ�. (ename �÷��� ũ��)
CREATE TABLE emp
eno number(4), ename varchar2(25), dno number(2);


ALTER TABLE
MODIFY ename varchar2(25);

--4. EMPLOYEE ���̺��� �����ؼ� EMPLOYEE2�� �̸��� ���̺��� �����ϵ� �����ȣ, �̸�, �޿�, �μ���ȣ �÷���
--�����ϰ� ���� ������ ���̺��� �÷����� ���� EMP_ID, NAME, SAL, DEPT_ID�� �����Ͻÿ�.
--[���-1]
create table employee2(EMP_ID, NAME, SAL, DEPT_ID)--4��
as
select eno, ename, salary, dno--4��
from employee;

--[���-2]
--[1]
create table employee2
as
select eno, ename, salary, dno
from employee;

--[2] �÷��� ����
alter table employee2
rename column to EMP_ID;

alter table employee2
rename column to NAME;

alter table employee2
rename column to SAL;

alter table employee2
rename column to DEPT_ID;

select * from employee2;

--5. emp ���̺��� �����Ͻÿ�.
drop table emp;

--6. EMPLOYEE2�� ���̺��� EMP�� �����Ͻÿ�.
rename employee2 to emp;

--7. DEPT ���̺��� DNAME �÷��� �����Ͻÿ�.
ALTER TABLE dept
drop column dname;

--8. DEPT ���̺��� LOC �÷��� UNUSED�� ǥ�� �Ͻÿ�.
ALTER TABLE dept
set unused (loc);

select * from dept;

--9. UNUSED �÷��� ��� �����Ͻÿ�.
ALTER TABLE dept
drop unused columns;
