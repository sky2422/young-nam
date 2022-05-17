--<�Ͻ�-9��_���������۰� Ʈ�����>

--������ ���۾�(DML : Data Manipulation Language)
--1. INSERT: ������ �Է�
--2. UPDATE: ������ ����
--3. DELETE: ������ ����
--�� �۾� �� �ݵ�� commit;(���������� ������ ����)

--1. INSERT: ���̺� ���� �߰�
--����(char, varchar2)�� ��¥ (date)�� ''�� ���

--�ǽ����� ������ '�μ����̺��� ������ ����'(�������� ���� �� �ȴ�. not null ���� ���Ǹ� ���� �ȴ�.)
create table dept_copy--dno(PK�� �ƴϹǷ� ���� dno�� ������ �߰� ���� )
AS
select * from DEPARTMENT--dno(PK=not null+unique)
where 0=1;--������ ������ ����

--RUN SQL... â���� 
desc dept_copy;--������ ���� Ȯ��
insert into dept_copy values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept_copy (dno, loc, dname)--3
			values(20, 'DALLAS', 'RESEARCH');--3
			

commit;--��Ŭ���������� �ڵ� commit�Ǿ� ��ɾ ����ȵȴ�.
-----------> RUN SQL... �Ǵ� SQL Developer���� ����	

--�Ʒ� delete�� ����� �����ϱ� ���� �͵��̴�.
delete from dept_copy where loc='����';
delete dept_copy where dno=30;

--1.1 NULL���� ���� ROW ����
--���ڳ� ��¥ Ÿ���� NULL ��� '' ��밡��
--���������� ������� �ʴ´�. �Ʒ� 3�� �� ���� �����̴�.
insert into dept_copy (dno,dname) values (30, 'SALES');--���������� ������� �ʴ´�. null���� ����Ͽ� loc�� null�� ����ȴ�.
--default '�뱸' �����Ǿ� ������ loc�� '�뱸' �Էµȴ�.(������ �����ϱ� ���� �̸� default �����ؾ� ��)
insert into dept_copy values (40, 'OPERATIONS', NULL);--3:3
insert into dept_copy values (50, 'COMPUTION', '');--3:3
--commit; ���������� ������ ����
select * from dept_copy; 

--[�ǽ����� �⺻ ������̺� ������ ����] (�������� ����ȵȴ�. not null�������Ǹ� ����ȴ�.)
create table emp_copy
AS
select eno, ename, job, hiredate, dno �μ���ȣ
from employee
where 0=1;

select *from emp_copy;--������ ����� ��Ȳ�̴�.

insert into emp_copy values(7000,'ĵ��','MANAGER','2021/12/20',10);
--��¥ �⺻����: 'YY/MM/DD'
insert into emp_copy values(7010,'��','MANAGER',to_date('2021,06,01','YYYY,MM,DD'),20);
insert into emp_copy values(7020,'����','SALESMAN', sysdate, 30);
--sysdate: system���� ���� ���� ��¥ �����͸� ��ȯ�ϴ� �Լ�(����: ��ȣ()�� ���� ���� Ư¡�̴�.)
select * from emp_copy;

--1.2 �ٸ� ���̺��� ������ �����ϱ�
--INSETY INTO + �ٸ� ���̺��� �������� ��� ������ ����
--��, �÷���= �÷���

--�ǽ����� �⺻ �μ����̺� ������ ����(�������� ����ȵȴ�. not null�������Ǹ� ����ȴ�.)
DROP TABLE dept_copy;--���� dept_copy ���� ��

create table dept_copy--dept_copy ���̺� ����
AS
select * from department
where 0=1;

select * from dept_copy;

--��: ���������� �ٸ� �� �Է��ϱ�
INSERT INTO dept_copy--department�� �÷����� dept_copy�� ������Ÿ���� ���ƾ��Ѵ�.
select * from department;

select * from dept_copy;

--------------------------------------------------------------------------------------
--2. UPDATE: ���̺��� ���� ����
--where�� ����: ���̺��� ��� �� �����ȴ�.
UPDATE dept_copy
set dname='programming'
where dno=10;

select * from dept_copy;

--�÷��� �������� �� ���� �����ϱ�
UPDATE dept_copy
set dname='accounting', loc='����'
where dno=10;

--update���� set������ ���������� ����ϸ� ���������� ������ ����� ������ ����ȴ�.
--��, �ٸ� ���̺� ����� �����ͷ� �ش� �÷� �� ���� ����

--��: 10�� �μ��� �������� 20�� �μ��� ��������  ���� (���������� �̿��ߴ�.)
--[1] 20�� �μ��� ������ ���ϱ�
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

--��: 10�� �μ��� '�μ���� ������'�� 30�� �μ��� '�μ���� ������'���� ����
--[1] 30�� �μ��� '�μ���� ������'���ϱ�
select dname from dept_copy where dno =30;--'SALES'
select loc from dept_copy where dno =30;--'NULL'

--[2]
update dept_copy
SET dname = (select dname from dept_copy where dno =30),
	loc=(select loc from dept_copy where dno =30)
where dno = 10;

select * from dept_copy;

--------------------------------------------------------------------------------------

--3. DELETE��: ���̺��� ���� ����
--where �� ����: ��� �� ����

delete from dept_copy--from ���������ϴ�.
where dno=10;

select * from dept_copy;

delete from dept_copy;--��� �� ����
select * from dept_copy;

--�ǽ����� ������̺��� ������ �����ͺ��� ---> �� ���̺� ����(���������� ���簡 �ȵȴ�.)
DROP TABLE emp_copy;

CREATE TABLE emp_copy
AS
select *
from employee;

select * from emp_copy;

--��: emp_copy ���̺��� '������(SALES)'�� �ٹ��ϴ� ��� ��� ����
--[1]'�μ����̺���' ������(SALES)�� �μ���ȣ ���ϱ�
select dno
from department
where dname ='SALES';--30
--[2]emp_copy ���̺��� ���� �μ���ȣ�� ���� �μ���ȣ�� ���� ����� ����
delete from emp_copy
where dno=(select dno
		from department
		where dname ='SALES');

delete from emp_copy
where dno=30;

select * from emp_copy;

-----------------------------------------------------------------------
--�ڡ� ��Ŭ������ �ڵ� commit�Ǿ� �������� ȯ�漳�� �� �׽�Ʈ�ϱ�

--4.Ʈ����� ����
--����Ŭ�� Ʈ����� ������� �������� �ϰ����� ������
--��: �� ����
--'��ݰ����� ��ݱݾ�'�� '�Աݰ����� �Աݱݾ�'�� �����ؾ� ��
--update				insert
--�ݵ�� �� �۾��� �Բ� ó���ǰų� �Բ� ���
--���ó���� �Ǿ��µ� �Ա�ó���� ���� �ʾҴٸ� ������ �ϰ����� ���� ����

--[Ʈ������ ó�����]: ALL - OR -Nothing �ݵ�� ó�� �ǵ��� �ȵǵ��� 
--					�������� �ϰ����� ����, ���������� ������ ����

--commit: �������߰�, ����, ���� �� ����ʰ� ���ÿ� Ʈ������� ����ȴ�.
--			���������� ����� ���� ���� �����ϱ� ���� �ݵ�� commit

--rollback: �۾��� ���
--			Ʈ��������� ���� �ϳ��� ���� ó���� ���۵Ǳ� ���� ���·� �ǵ�����.

--�ǽ����� ���� �μ� ���̺��� ������ ������ ���� ---> �� ���̺� (�������� ����ȵȴ�. Not Null ����)
drop table dept_copy;

create table dept_copy
AS
select * from department;

select * from dept_copy;

--�ڡ� ���⼭���ʹ� RUN SQL ~ ���� �׽�Ʈ �ϱ�
delete dept_copy;--��� row �� �����ȴ�.
select* from dept_copy;--Ȯ��

rollback;--�������� �ǵ���(commit�ϱ� ����)
select* from dept_copy;--Ȯ��:��� row �� ��Ÿ����.

--10�� �μ��� ���� ---> savepoint�� �� ������ d10�̸����� ����
delete dept_copy where dno=10;
savepoint d10;

--20�� �μ��� ����
delete dept_copy where dno=20;

--30�� �μ��� ����
delete dept_copy where dno=30;

--d10�������� �ǵ���(198�������� �ǵ��� ���ٶ�� ���̴�.)
rollback to d10;

commit;--���� ����ȴ�.

--�ٽ� 20�� �μ��� ����
delete dept_copy where dno=20;

--�������� �ǵ����� �ִ�.
rollback;

--<9�� ���������۰� Ʈ����� ȥ�� �غ���>-----------------------------

--1.EMPLOYEE ���̺��� ������ �����Ͽ� EMP_INSERT�� �̸��� �� ���̺��� ����ÿ�.
create table emp_table
AS
select * from employee 
where 1=0;

select * from dept_copy2;

--2.������ EMP_INSERT ���̺� �߰��ϵ� SYSDATE�� �̿��Ͽ� �Ի����� ���÷� �Է��Ͻÿ�.
insert into EMP_INSERT
values (9090,'ȫ�浿','ANALYST',null, sysdate , 3000, null,10 );

--3.EMP_INSERT ���̺� �� ����� �߰��ϵ� TO_DATE �Լ��� �̿��Ͽ� �Ի����� ������ �Է��Ͻÿ�.
insert into emp_table
values TO_DATE('20220105')

--4.EMPLOYEE ���̺��� ������ ������ �����Ͽ� EMP_COPY_2�� �̸��� ���̺��� ����ÿ�.
create table emp_copy
AS
select from employee;

--5.�����ȣ�� 7788�� ����� �μ���ȣ�� 10������ �����Ͻÿ�.
update emp_copy2
set dno=10
where eno=7788;

--6.�����ȣ�� 7788�� ��� ���� �� �޿��� �����ȣ 7499�� ��� ���� �� �޿��� ��ġ�ϵ��� �����Ͻÿ�.
select job, salary
from emp_copy
where eno=7788;

update emp_copy2
set job= (select job, salary from emp_copy2 where eno=7499),
	salary =(select job, salary from emp_copy2 where eno=7499)
where eno=7788;

--7.�����ȣ 7369�� ������ ������ ��� ����� �μ���ȣ�� ��� 7369�� ���� �μ���ȣ�� �����Ͻÿ�.
--[1] �����ȣ 7369�� �������ϱ�, �μ���ȣ ���ϱ�
select dno from emp_copy2 where eno=7369;
select job from emp_copy2 where eno=7369;
--[2]
update emp_copy2
set dno(select dno from emp_copy2 where eno=7369)--�μ���ȣ�� 7369�� �μ���ȣ�� ����
where job=(select job from emp_copy2 where eno=7369);--�����ȣ 7369�� ������ ������ ����� ã�Ƽ�

--8.DEPARTMENT ���̺��� ������ ������ �����Ͽ� DEPT_COPY_2�� �̸��� ���̺��� ����ÿ�.
create table dept_copy2
AS
select * from department;

select * from dept_copy2;

--9.DEPT_COPY_2 ���̺��� �μ����� RESEARCH�� �μ��� �����Ͻÿ�.
delete table dept_copy2
where dname= 'RESEARCH';

--10.DEPT_COPY_2 ���̺��� �μ���ȣ�� 10�̰ų� 14�� �μ��� �����Ͻÿ�.
--[���-1]
delete table dept_copy2
where dno IN(10, 14);

--[���-2]
delete table dept_copy2
where dno=10 OR dno=14;
