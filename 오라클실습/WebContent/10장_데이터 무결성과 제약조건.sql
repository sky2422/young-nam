---<�Ͻ� 10��_������ ���Ἲ�� ��������>

--�ش��ȣ([ ])�� �׸��� �ʿ����� ���� ��� ������ �����ϴ�.
CREATE TABLE [SCHEMA: ������ �̸�(����� ����)] table��(--[]�� ��� �ɼ�
�÷���1 ������Ÿ��(����) [NULL|NOT NULL|UNIQUE(INDEX�ڵ�����)|DEFAULT ǥ��: ���� �����Ǹ� �ԷµǴ� �⺻��|CHECK(üũ����)(AGE > 0)]
[[CONSTRAINT �������Ǹ�(���̺��_�÷���_PK)] PRIMARY KEY(INDEX�ڵ�����)|[CONSTRAINT �������Ǹ�(���̺��_�÷���_FK)]|[FOREIGN KEY]] REFERENCES �������̺��],
�÷���2....,
�÷���3...

���̺� ���� ��������
[CONSTRAINT �������Ǹ�(���̺��_�÷���_PK)] PRIMARY KEY(�÷���1, �÷���2,...),
[CONSTRAINT �������Ǹ�(���̺��_�÷���_FK)]|FOREIGN KEY(�÷���) REFERENCES �������̺��(�÷���)
[ON DELETE no action(�⺻��)|cascade|set null|set default]--�ݵ�� ���̺� ���������� ����
[ON UPDATE no action(�⺻��)|cascade|set null|set default]--�ݵ�� ���̺� ���������� ����
);

/*
 * [ON DELETE �ڿ�]
 * 1. no action(�⺻��): �θ����̺� ���� �ڽ� ���̺��� �����ϰ� ������ �θ����̺� ���� �Ұ����ϴ�.
 *  ��restrict(MYSQL���� �⺻��, MYSQL���� retrict�� no action�� ���� �ǹ̷� ����Ѵ�.)
 * �ؿ���Ŭ������ restrict�� no action�� �ణ�� ���̰� �ִ�.
 * 
 * 2. CASCADE: �����Ǵ� '�θ����̺��� ���� ����'�Ǹ� ���������� '�ڽ����̺��� �����ϴ� �� ���� �����ȴ�.'
 * 				�μ����̺��� �μ���ȣ 40 ������ �� ������̺��� �μ���ȣ 40�� ����
 * 
 * 3. Set null: �θ����̺��� ���� �����Ǹ� �ش� �����ϴ� �ڽ����̺��� ������ ��� null���� �����ȴ�.
 * 				(��, null ����� ���)
 * 				�μ����̺��� �μ���ȣ 40 ������ �� ������̺��� �μ���ȣ�� null�� ����ȴ�.
 * 
 * 4. Set default: �ڽ����̺��� ���� Ʃ���� �̸� ������ ������ ����
 * 					�μ����̺��� �μ���ȣ 40 ������ �� ������̺��� �μ���ȣ�� default������ �������ش�.
 * 					�� ���������� �����Ϸ��� ��� ����Ű �÷��� �⺻ ���ǰ� �־�� �Ѵ�.
 * 					�÷��� null�� ����ϰ� ����� �⺻���� �����Ǿ� ���� �ʴ� ��� null�� �ش� ���� �Ͻ����� �⺻���� �ȴ�.
 */

/*
 * ==ON DELETE==
 * 1. no action (�⺻��)(restrict�� ���): �ڽ����̺� �����Ͱ� ���� �ִ� ��� �θ� ���̺��� �����ʹ� ���� �Ұ��ϴ�.
 * 2. cascade: �θ����� ���� �� �ڽ� �����͵� ���� ���������ϴ�.
 * 3. set null: �θ����� ���� �� �ش�Ǵ� �ڽ� �������� �÷����� null�� ó��
 * 4. set default: �θ� ������ ���� �� �ڽ� �������� �÷����� �⺻����(default)���� �����Ѵ�.
 * 
 */

--1.��������
--'������ ���Ἲ' ��������: ���̕��� ��ȿ���� ���� (��������) �����Ͱ� �ԷµǴ� ���� �����ϱ� ����
--���̺������ �� �� �÷��� ���� �����ϴ� ���� ��Ģ

--<��������(5����)>----------------------------------------------------------------------------------------
--1. NOT NULL

--2. UNIQUE: �ߺ��� ������� �ʴ´�. ������ ���̴�. = ������ ���̴�. ---> ����Ű(�Ͻ��� INDEX �ڵ� ����)
--			 �ڡ�NULL�� UNIQUE �������ǿ� ���ݵ��� �����Ƿ� 'NULL'���� ���'

--3. PRIMARY KEY(�⺻Ű=PK): NOT NULL ��������: NULL�� ������� �ʴ´�.
--							UNIQUE ��������: �ߺ��� ������� �ʴ´�. = ������ ���̴�. ---> ����Ű(�Ͻ��� INDEX �ڵ� ����)

--4. FOREIGN KEY(�ܷ�Ű=����Ű=FK): �����Ǵ� ���̺� �÷� ���� �׻� �����ؾ��Ѵ�.(�ߺ����� �ʴ� ������ Ű)
--								(��) ������̺�(�ڽ�) DNO(=FK) ---> �μ����̺�(�θ�) DNO(PK OR UNIQUE)
--								������ ���Ἲ -���̺� ������ '���� ���踦 ����'�ϱ� ���� ���� ����
--'��� ���̺��� �����Ͱ� ���� ���ǵǾ�� �ϴ°�?': ����, �θ� ���̺���� �����ϰ� ---> �ڽ����̺� ����

--5. CHECK(): '���� ������ ������ ������ ���� ����'�Ͽ�(��)CHECK(SALARY > 0)
--				������ �� �̿��� ���� ������ ������ �Ͼ�� �ȴ�.
---------------------------------------------------------------------------------------------------------
--DEFAULT ����: �ƹ��� ���� �Է����� �ʾ��� �� DEFAULT���� �Էµǵ��� �Ѵ�.

--��������: �÷�����- �ϳ��� �÷��� ���� ��� ���� ������ ����
--		   ���̺��� - 'NOT NULL ����'�� ������ ���������� ����

--<���������̸� ���� ������ ���� ����>
--CONSTRAINT ���������̸�
--CONSTRAINT ���̺��_�÷���_������������
--���������̸��� �������� ������ �ڵ����� �����ȴ�.

create table customer2(
id varchar2(20) unique,
pwd varchar2(20) not null,
name varchar2(20) not null,
phone varchar2(30),
address varchar2(100)
);

DROP TABLE customer2;

create table customer2(
id varchar2(20) constraint customer2_id_uq unique,--uq�� ���߰����ϰ� ����� �ȴ�.
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_name_nn not null,
phone varchar2(30),
address varchar2(100)
);

DROP TABLE customer2;

create table customer2(
id varchar2(20) constraint customer2_id_pk primary key,--�÷� ����
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

constraint customer2_id_pk primary key(id)--���̺� ����
--constraint customer2_id_pk primary key(id, name)--�⺻Ű�� 2�� �̻��� �� ���̺� ���
);

--'���̺� ��������'�� ������ '�������ǿ� ���̺� ����(=USER_constraintS)' ����Ͽ� ���̺��, �������Ǹ� ��ȸ
-- C�� not null�̰� U(UNIQUE)�̰� P(primary key)�̰� R�� ����Ű
select table_name, constraint_name, constraint_type
from USER_constraintS
where table_name LIKE 'CUSTOMER2';
--where table_name IN('CUSTOMER2');
--where LOWER(table_name) IN('customer2'); 
--where table_name IN UPPER('customer2');
--where table_name LIKE '%CUSTOMER2%';
--where table_name LIKE '%CUSTOMER2';
--�ϳ��� �ּ��� ���Խ�Ű�� �ʰ� �����ϸ� ���� �����ϴ�.

--1.1 NOT NLL ��������: �÷� �����θ� ����
insert into customer2 values(null, null, null, '010-1111-1111', '�뱸�� �޼���');

--1.2 UNIQUE ��������: ������ ���� ����Ѵ�.(��, null ���)

--1.3 PRIMARY KEY ��������
--���̺��� ��� ROW(���ڵ�)�� �����ϱ� ���� �ĺ���

--1.4 FOREIGN KEY(FK=����Ű=�ܷ�Ű) ��������
--��� ���̺��� �μ���ȣ�� ������ �μ� ���̺��� ������ ����: ���� ���Ἲ

select * from department;--�����Ǵ� �θ�

--�ڡڻ���(�ڽ��� ��� ���̺���)
insert into employee(eno, ename, dno) 
			values(8000, 'ȫ�浿', 50);
--�μ���ȣ 50 �Է��ϸ� 
--'�������Ἲ ����, �θ�Ű�� �߰����� ���ߴ�.'�����߻��Ѵ�.
--integrity constraint (SYSTEM.SYS_C007038) violated - parent key not found

--����: ������̺��� ����� ������ ���Ӱ� �߰��� ���
--		������̺��� �μ���ȣ�� �μ����̺��� ����� �μ���ȣ �� �ϳ��� ��ġ
--		or NULL �� �Է� �����ϴ�.(��, NULL������� ��� - ���� ���Ἲ ��������)

--���� ���
--[���-1]
insert into employee(eno, ename, dno)--�����ϴ� �ڽ�
			values(8000, 'ȫ�浿', '');--'' = null ��, dno�� null ����ϸ�
--[���-2]: ���������� �������� �ʰ� �Ͻ������� '��Ȱ��ȭ' ---> ������ ó�� ---> �ٽ� 'Ȱ��ȭ'
--USER_constraintS ������ ������ �̿��Ͽ� constraint_name�� Ÿ��(=type)�� ����(=status) ��ȸ
select constraint_name, constraint_type, status--P(�⺻Ű), R(����Ű), ENABLED (Ȱ��ȭ��) 
from USER_constraintS
where table_name IN('EMPLOYEE');

--[1] �������� '��Ȱ��ȭ'
alter table employee
disable constraint SYS_C007038;--constraint_type�� R�� ���� ã�Ƽ� �����ϸ� �ȴ�.

select constraint_name, constraint_type, status
from USER_constraintS
where table_name IN('EMPLOYEE');

--[2] �ڽĿ��� ����
insert into employee(eno, ename, dno) 
			values(9000, 'ȫ�浿', 50);
			--values(8000, 'ȫ�浿', 50);--�̹� 8000�� �� ���� ���Ե� ����
			
--[3] �ٽ� Ȱ��ȭ
alter table employee
enable constraint SYS_C007038;		
--����: integrity constraint (SYSTEM.SYS_C007038) violated - parent key not found
			
--�ٽ� Ȱ��ȭ��Ű�� ���� eno�� 9000�� row ����			
delete employee where eno=9000;
			
alter table employee
enable constraint SYS_C007038;			
			
--Ȱ��ȭ ���� Ȯ��
select constraint_name, constraint_type, status
from USER_constraintS
where constraint_name IN('SYS_C007038');			

--���Թ��-2 ����: �������� ��Ȱ��ȭ���� ���ϴ� �����͸� �ٽ� �������� Ȱ��ȭ��Ű�� ���� �߻��Ͽ� ������ �����͸� �����ؾ��Ѵ�.

--�ڡڡڻ���(�θ𿡼�)-�μ����̺��� ������ ��
drop table department;
--unique/primary keys in table referenced by foreign keys
--�ڽ��� employee���� �����ϴ� ��Ȳ������ ������ �ȵȴ�.


-----1. �θ���� ���̺� ����: �ǽ����� department �����Ͽ� department2 ���̺� ����
-----������: ���������� ���簡 �ȵȴ�.
create table department2
as
select * from department;--������: ���������� ���簡 �ȵȴ�.

select * from department2;

select constraint_name, constraint_type, status
from USER_constraintS
where table_name IN('DEPARTMENT2');
--where lower(table_name) IN ('department2');--�� ����

-----PRIMARY KEY �������� �߰��ϱ�(��, �������Ǹ��� ���� ����� �߰�): �������� ���簡 �ȵȴ�.
alter table department2
add CONSTRAINT department2_dno_pk primary key (dno);

-----�������� Ȯ���غ���
select constraint_name, constraint_type, status
from USER_constraintS
where table_name IN('DEPARTMENT2');

-----2. �ڽ����̺� ����
create table emp_second(
eno number(4) constraint emp_second_eno_pk primary key,
ename varchar2(10),
job varchar2(9),
salary number(7, 2) default 1000 check(salary > 0),
dno number(2), --constraint emp_second_dno_fk foreign key references department2 ON DELETE CASCADE--(FK=����Ű=�ܷ�Ű R�� ��µȴ�.) �÷�����

--���̺� ����: ON DELETE �ɼ�
constraint emp_second_dno_fk foreign key(dno) references department2(dno)
ON DELETE CASCADE--CASCADE: ����
);
--constraint emp_second_dno_fk foreign key ���� ������ �κ��̴�.

insert into emp_second values(1, '��', '����', null, 30);
insert into emp_second values(2, '��', '����', null, 20);
insert into emp_second values(3, '��', '�', null, 40);
insert into emp_second values(4, '��', '���', null, 20);

--1.6 default ����
--default �� �ִ� 2���� ���
insert into emp_second(eno, ename, job, dno) values(5, '��', '����', 30);--salary: default 1000
insert into emp_second values(6, '��', '����', default, 40);--salary: default 1000

select * from emp_second;
select * from department2;

--�θ����̺��� dno=20 �����ϸ� �ڽ����̺��� �����ϴ� �൵ ���� �����ȴ�.
--����: ON DELETE CASCADE
delete department2 where dno=20;

select * from emp_second;--�θ����̺� �����ϸ�
select * from department2;--�ڽ����̺����� �����ȴ�.

--�����Ѵ�.
--�⺻���� �ڽ����̺��� �����ϰ� ������ �θ����̺��� �࿡ �ִ� ������ ���� �Ұ��ϴ�.
delete department where dno=20;

--���̺� ��ü ���� 
--���� �޽��� unique/primary keys in table referenced by foreign keys
--���������̺��� ����Ű�� �����ϰ� �����Ƿ� ���̺� ��ü ������ �ȵȴ�.
drop table department2;

--���̺� �����͸� ����(���̺� ������ �����)
truncate table department2;--����: rollback �Ұ���
delete from department2;--�ڡڼ���: rollback �����ϹǷ�(Ȥ�� �߸� ���� �� �ٽ� ���� ����)

select * from department2;--�θ����̺��� ��� ������ �� �����ϸ�
select * from emp_second;--�ڽ����̺����� ��� ������ �� �����ȴ�.

--1.5 check ��������: ���� ������ ���� ����
--currval(�������� ��), nextval, rownum ���Ұ�
--sysdate, user�� ���� �Լ��� ��� �Ұ�

--[test�� ����] 
--[1]. emp_second���� drop ---> department2 drop
drop table emp_second;
drop table department2;
--[2]. department2 ���� ---> emp_second ����
--[2.1] department2 ����
create table department2
as
select * from department;--������: ���������� ���簡 �ȵȴ�.

alter table department2
add CONSTRAINT department2_dno_pk primary key (dno);--�⺻Ű �������� �߰�
--[2.2] emp_second ����
create table emp_second(
eno number(4) constraint emp_second_eno_pk primary key,
ename varchar2(10),
job varchar2(9),
salary number(7, 2) default 1000 check(salary > 0),
dno number(2), 
constraint emp_second_dno_fk foreign key(dno) references department2(dno)
ON DELETE CASCADE--CASCADE: ����
);

--check(salary > 0)
insert into emp_second values(4, '��', '���', -3000,30);
--����: check constraint (SYSTEM.SYS_C007113) violated (check �������� ����)
insert into emp_second values(4, '��', '���', 3000,30);--����
---------------------------------------------------------------------------------
--2. �������� �����ϱ�
--2.1 �������� �߰�: alter table ���̺�� + ADD constraint �������Ǹ� + ��������
--��, 'null ���Ἲ ��������'�� alter table ���̺�� + ADD ~ �� �߰����� ���Ѵ�.
--						alter table ���̺�� + MODIFY�� NULL ���·� ���� ����
--	'default ���� �� ��'��  alter table ���̺�� + MODIFY�� 

--[test�� ����]
--drop table dept_copy;
create table dept_copy
as
select * from department;--���� ���� ����ȵȴ�.

--drop table emp_copy;
create table emp_copy
as
select * from employee;--���� ���� ����ȵȴ�.

select table_name constraint_name
from user_constraintS
where table_name IN('DEPARTMENT', 'EMPLOYEE', 'DEPT_COPY', 'EMP_COPY');
--����

--��-1: �⺻Ű �������� �߰��ϱ�
alter table dept_copy
add constraint dept_copy_dno_pk primary key(dno);

alter table emp_copy
add constraint emp_copy_eno_pk primary key(eno);

--�߰��� �������� Ȯ��
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPARTMENT', 'EMPLOYEE', 'DEPT_COPY', 'EMP_COPY');
--���������� ��µȴ�.

--��-2: �ܷ�Ű(=����Ű) �������� �߰��ϱ�
alter table emp_copy
add constraint emp_copy_fk foreign key(dno) references dept_copy(dno);
--ON delete CASCADE; �ʿ�� �߰� �����ϴ�. ,�� ; ������ ���� �ؾ� �Ѵ�.
--ON delete set null;�ʿ�� �߰� �����ϴ�. ,�� ; ������ ���� �ؾ� �Ѵ�.

--�߰��� �������� Ȯ��
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

--��-3: NOT NULL �������� �߰��ϱ�
alter table emp_copy
MODIFY ename constraint emp_copy_ename_nn NOT NULL;

--��-4: DEFAULT ���� �߰��ϱ�(�ڡ�constraint �������Ǹ� �Է��ϸ� ���� �߻��Ѵ�.)
alter table emp_copy
MODIFY salary constraint emp_copy_ salary_d default 500; 
--����: constraint specification not allowed here
alter table emp_copy
MODIFY salary default 500;  
--����

--�߰��� �������� Ȯ��
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');
--default ���� ������ ���������� �ƴϹǷ� ������� �ʴ´�.

--��-5: check �������� �߰��ϱ� 
select salary from emp_copy where salary <= 1000;

alter table emp_copy
add constraint emp_copy_salary_check CHECK(salary > 1000);
--����: �̹� insert �� ������ �߿� 1000���� ���� �޿��� �����Ƿ� '���ǿ� ����Ǿ� ���� �߻�'�ȴ�.

alter table emp_copy
add constraint emp_copy_salary_check CHECK(500 <= salary and salary < 10000);
--500 <= salary and salary < 10000 �̻��� ���� insert ���� �ʴ´�.

alter table dept_copy
add constraint dept_copy_dno_check CHECK(dno IN(10, 20, 30, 40, 50));
--dno�� �ݵ�� IN(10, 20, 30, 40, 50) �� �ϳ��� insert �����ϴ�.

--�߰��� �������� Ȯ��
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

--2.2 �������� ����
--�ܷ�Ű �������ǿ� �����Ǿ� �ִ� �θ� ���̺��� �⺻Ű ���������� �����Ϸ���
--�ڽ����̺��� ���� ���Ἲ ���������� ���� ������ �� �����ϰų�
--�Ǵ� cascade �ɼ� ���: �����Ϸ��� �÷��� �����ϴ� ���� ���Ἲ �������ǵ� �Բ� ����
alter table dept_copy--�θ�
drop primary key;--��������: �ڽ����̺��� �����ϰ� �����Ƿ� 

alter table emp_copy
drop primary key;

alter table dept_copy
drop primary key cascade;--�����ϴ� �ڽ� ���̺��� '���� ���Ἲ ��������'�� �Բ� ���ŵȴ�.

alter table emp_copy
drop primary key cascade;
--������ �������� Ȯ��: �� �� ���� �ȴ�.
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

--��: NOT NULL �������� ����(EMP_COPY_ENAME_NN �����ϱ�)
alter table emp_copy
drop constraint emp_copy_ename_nn;

--������ �������� Ȯ��
select table_name, constraint_name
from user_constraintS
where table_name IN('DEPT_COPY', 'EMP_COPY');

------------------------------------------------------------------------------------

--3. �������� Ȱ��ȭ �� �� Ȱ��ȭ
--alter table ���̺�� + DISABLE constraint �������� [cascade]
--���������� �������� �ʰ� �Ͻ������� �� Ȱ��ȭ 
--�� ���� �����ϱ�

--<10�� ������ ���۰� Ʈ����� ȥ�� �غ���>-----------------------------
--1.EMPLOYEE ���̺��� ������ �����Ͽ� EMP_SAMPLE�� �̸��� ���̺��� ����ÿ�. 
--��� ���̺��� �����ȣ �÷��� ���̺� ������ primary key ���� ������ 
--�����ϵ� ���� �̸��� my_emp_pk�� �����Ͻÿ�
create table EMP_SAMPLE
as
select * from employee
where 0=1;--������ ������ ���� ---> ������ ������ ����

alter table EMP_SAMPLE
add constraint my_emp_pk primary key(eno);

--2.�μ����̺��� �μ���ȣ �÷��� ���̺� ������ primary key �������� �����ϵ�
--�������Ǹ��� my_dept_pk�� ����
create table dept_sample
as
select * from department;

alter table dept_sample
add constraint my_dept_pk primary key(dno);

--3.������̺��� �μ���ȣ �÷��� �������� �ʴ� �μ��� ����� �������� �ʵ���
--�ܷ�Ű(=����Ű) ��������(=���� ���Ἲ)�� �����ϵ�
--���� ���� �̸��� my_emp_dept_fk�� ����
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);
--�����߻� ���� ����: �ڽ� ���̺� �����;���(��, �ڽĿ��� �θ� �����ϴ� �����Ͱ� ����.)
--�ݵ�� �θ��� �����͸� ���� insert �� �� ---> �ڽ��� �����ϴ� ������ insert �ؾ� �Ѵ�.

--4.��� ���̺��� Ŀ�̼� �÷��� 0���� ū ���� �Է��� �� �ֵ��� �������� ����
alter table emp_sample
add constraint emp_sample_commission_min check(commission > 0);
