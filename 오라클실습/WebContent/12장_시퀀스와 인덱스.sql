---<�Ͻ� 12��_�������� �ε���>

--1.������ ����
--�ؽ�����: ���̺� ���� ������ ���ڸ� �ڵ� ����
--����Ŭ������ �����Ͱ� �ߺ��� ���� ���� �� ������
--'��ü ���Ἲ'�� ���� �׻� ������ ���� ������ �ϴ� '�⺻Ű'�� �ΰ� �ִ�.
--�������� �⺻Ű�� ������ ���� �ݵ�� ������ �ڵ������Ͽ� ����ڰ� ���� �����ϴ� �δ㰨�� ���δ�.

create sequence ��������
[start with ���ۼ���]--���ۼ����� �⺻���� ������ �� minvalue, ������ �� maxvalue�̴�.
[increment by ��������]--�������ڰ� ����� ����, ������ ���� (�⺻��: 1)�Ѵ�.

[minvalue �ּҰ� | nominvalue]--NOMINVALUE(�⺻��): �����϶� 1, �����϶� -10�� 26�±���(10^-26)
                            --MINVALUE: �ּҰ� ����, ���ۼ��ڿ� �۰ų� ���ƾ��ϰ� MAXVALUE���� �۾ƾ� �Ѵ�.
                            
[maxvalue �ִ밪 | nomaxvalue]--NOMAXVALUE(�⺻��): �����϶� 10�� 27����, �����϶� -1�����̴�.
                            --MAXVALUE �ִ밪 : �ִ밪 ����, ���ۼ��ڿ� ���ų� Ŀ���ϰ� MINVALUE���� Ŀ�� �Ѵ�.
                           
[cycle | nocycle(�⺻��)]--cycle: �ִ밪���� ���� �� �ּҰ����� �ٽ� �����Ѵ�.
                       --nocycle: �ִ밪���� ���� ��  �� ���� �������� �߱޹������� ���� �߻��Ѵ�.
[cache n | nocache]--cache n: �޸𸮻� ������ ���� �̸� �Ҵ� (�⺻�� 20)�̴�.
                   --nocache: �޸𸮻� ������ ���� �̸� �Ҵ����� �ʴ´�.(�������� �ʴ´�.)
                         
[order | noorder(�⺻��)]--order: ���ļ����� ����� ��� ��û ������ ���� ��Ȯ�ϰ� �������� �����ϱ⸦ ���� �� order�� �����Ѵ�.
                        --        ���� ������ ��� �� �ɼǰ� ������� ��Ȯ�� ��û ������ ���� �������� �����ȴ�.     
;

--sequence-1 ����
create sequence sample_test;

create sequence sample_seq
start with 10--10���� ����
increment by 3--10 13 16 19...�ڵ� �����ϴ� ���� ������ �� �ִ�.
maxvalue 20
cycle
nocache;--10 13 16 19 ---> 1(�ּҰ�) 4 7 10 ---> 

create sequence sample_seq;--1�� �����Ѵ�.

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS
where sequence_name IN UPPER('sample_test');

--sequence-2 ����
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
select sample_seq.nextval, sample_seq.currval from dual;--1   1(�ּҰ����� ���ư���.)
select sample_seq.nextval, sample_seq.currval from dual;--4   4

--sequence-3 ����
create sequence sample_seq2
start with 10
increment by 3;

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS--   1		1e+28=10^27		3			NO			   20
where sequence_name IN UPPER('sample_seq2');

--1.1 NEXTVAL ---> CURRVAL(�ڡ� ������ ����)
--NEXTVAL: ������(�ڻ��ο� �� ����) ������ ������ 
--CURRVAL: �������� ���簪 �˾Ƴ���.

--<CURRVAL, NEXTVAL ����� �� �ִ� ���>
--���������� �ƴ� select��
--insert���� values��
--update���� set��

--<CURRVAL, NEXTVAL ����� �� ���� ���>
--view�� select��
--distinct Ű���尡 �ִ� select��
--group by, having, order by ���� �ִ� select��
--select, delete, update�� ��������
--create table, alter table����� default��

select sample_seq2.nextval from dual;--10
select sample_seq2.currval from dual;--����
--sequence SAMPLE_SEQ2.CURRVAL is not yet defined in this session ��µȴ�.
--sequence SAMPLE_SEQ2.CURRVAL ���ǵ��� �ʾҴ�.

select sample_seq2.nextval, sample_seq2.currval from dual;--13 13������ ������� ����ȴ�.(�� �������)
select sample_seq2.currval, sample_seq2.nextval from dual;--16 16
--sample_seq2.nextval ���� ---> ������ ���� ---> sample.seq2.currval ���簪 �˷��ش�.

--1.2 �������� �⺻Ű�� �����ϱ�
--�μ����̺��� �⺻Ű�� �μ���ȣ�� �ݵ�� ������ ���� �����;� �Ѵ�.
--������ ���� �ڵ� �������ִ� �������� ���� ���������� �����ϴ� �����̸Ӹ� �÷��� �ڵ� ����

--�ǽ����� dept12 ���̺� ����
drop table dept12;

create table dept12
as
select * 
from department
where 0=1;--������ ��������
--���̺� ������ ����(��, ���������� ����ȵȴ�.-dno�� �⺻Ű�� �ƴϴ�.)

--dno�� �⺻Ű �������� �߰�
alter table dept12
add primary key(dno);--index �ڵ�����

select * from dept12;

--�⺻Ű�� �����ų ������ ����
create sequence dno_seq
start with 10
increment by 10;--nocycle�� �⺻��

insert into dept12 values(dno_seq.nextval,'ACCOUNTING','NEW YORK');--10
insert into dept12 values(dno_seq.nextval,'RESEARCH','DALLAS');--20
insert into dept12 values(dno_seq.nextval,'SALES','CHICAGO');--30
insert into dept12 values(dno_seq.nextval,'OPERATIONS','BOSTON');--40

select * from dept12;

--2. ������ ���� �� ����
--<���� �� ������ ���� ���� 2����>
--[1] 'START WITH ���ۼ���'�� ���� �Ұ�
--����: �̹� ������� �������� ���ڰ��� ������ �� �����Ƿ�
--���۹�ȣ�� �ٸ� ��ȣ�� �ٽ� �����Ϸ��� ���� �������� DROP���� ������ �ٽ� �����ؾ��Ѵ�.
--[2] ����: ���� ����ִ� ������ ���� �ּҰ����� ���� �� �� ����.
--	   ����: ���� ����ִ� ������ ���� �ִ밪���� ���� �� �� ����.
--		(��: �ִ밪 9999 �����Ͽ� 10�� ���� ---> �ִ밪 5000���� �����ϸ� 5000���� ū �̹� �߰���  ������ ��ȿȭ�ȴ�.)

alter sequence ��������--�������� DDL(=������ ���Ǿ�(=Data Definition Language))���̹Ƿ� ALTER������ ���� ����
--[start with ���ۼ���]--������ ������ ��� �Ұ���. create sequence������ ��� �����ϴ�.
[increment by ��������]--�������ڰ� ����� ����, ������ ���� (�⺻��: 1)�Ѵ�.

[minvalue �ּҰ� | nominvalue]--NOMINVALUE(�⺻��): �����϶� 1, �����϶� -10�� 26�±���(10^-26)
                            --MINVALUE: �ּҰ� ����, ���ۼ��ڿ� �۰ų� ���ƾ��ϰ� MAXVALUE���� �۾ƾ� �Ѵ�.
                            
[maxvalue �ִ밪 | nomaxvalue]--NOMAXVALUE(�⺻��): �����϶� 10�� 27����, �����϶� -1�����̴�.
                            --MAXVALUE �ִ밪 : �ִ밪 ����, ���ۼ��ڿ� ���ų� Ŀ���ϰ� MINVALUE���� Ŀ�� �Ѵ�.
                           
[cycle | nocycle(�⺻��)]--cycle: �ִ밪���� ���� �� �ּҰ����� �ٽ� �����Ѵ�.
                       --nocycle: �ִ밪���� ���� ��  �� ���� �������� �߱޹������� ���� �߻��Ѵ�.
[cache n | nocache]--cache n: �޸𸮻� ������ ���� �̸� �Ҵ� (�⺻�� 20)�̴�.
                   --nocache: �޸𸮻� ������ ���� �̸� �Ҵ����� �ʴ´�.(�������� �ʴ´�.)
                         
[order | noorder(�⺻��)]--order: ���ļ����� ����� ��� ��û ������ ���� ��Ȯ�ϰ� �������� �����ϱ⸦ ���� �� order�� �����Ѵ�.
                        --        ���� ������ ��� �� �ɼǰ� ������� ��Ȯ�� ��û ������ ���� �������� �����ȴ�.     
;

select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS--   1		1e+28=10^27		10			NO			   20
where sequence_name IN UPPER('dno_seq');

--�ִ밪�� 50���� ����
alter sequence dno_seq
maxvalue 50;

--�ִ밪 Ȯ��
select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequenceS--   1			50		10			NO			   20
where sequence_name IN UPPER('dno_seq');

insert into dept12 values(dno_seq.nextval,'COMPUTING','SEOUL');--50
insert into dept12 values(dno_seq.nextval,'COMPUTING','DARGU');--����

select * from dept12;

--������ ����
DROP sequence dno_seq;
insert into dept12 value(60,'COMPUTING','DARGU');

---------------------------------------------------------------------------------------

--3. �ε���: DB ���̺� ���� �˻� �ӵ��� ��� �����ִ� �ڷ� ����
--			Ư�� �÷��� �ε����� �����ϸ� �ش� �÷��� �����͵��� �����Ͽ� ������ �޸� ������ �������� ������ �ּҿ� �Բ� ����ȴ�.
				index				table
		  Date  Location	  Location  Data
('��'ã��)	��		 1			1		 ��
��������--->	��		 3			2		 ��
			��		1000		3		 ��
			��		 2			4		 ��
			��		 4			...
								1000	 �� 

--			������� �ʿ信 ���ؼ� ���� ������ ���� ������ 
--			������ ���Ἲ�� Ȯ���ϱ� ���ؼ� ���÷� �����͸� �˻��ϴ� �뵵�� ���Ǵ�
--			'�⺻Ű'�� '����Ű(=unique)'�� �ε��� �ڵ� ����
--user_indexES�� user_IND_columnS(�÷��̸����� �˻�����) ������ �������� index ��ü Ȯ�� �����ϴ�.

--index ����: CREATE INDEX [�ε�����] ON [���̺��(�÷�1, �÷�2, �÷�3....);
--index ����: DROP INDEX �ε�����;

/*
 * <index ���� ����>
 * ������ index�� ���� ȿ�������� ����Ϸ��� �������� �������� �ִ������� 
 * �׸��� �������� ȣ��󵵴� ���� ���Ǵ� �÷��� index�� �����ϴ� ���� ����.
 * index�� Ư�� �÷��� �������� �����ϰ� ������ �� �÷����� '���ĵ� index ���̺�'�� �����ȴ�.
 * �� ���� �÷��� �ִ��� �ߺ��� ���� �ʴ� ���� ����.
 * ���� �ּ��� PK�� �ε����� �����ϴ� ���̴�.
 * 
 * 1. �������� ���� �����ϴ� �÷�
 * 2. �׻� = ���� �񱳵Ǵ� �÷�
 * 3. �ߺ��Ǵ� �����Ͱ� �ּ����� �÷�
 * 4. order by������ ���� ���Ǵ� �÷�
 * 5. ������������ ���� ���Ǵ� �÷�
 */
--�� ���̺� �ڵ����� ������ index ���캸��
select index_name, table_name, column_name
from user_IND_columns
where table_name IN('EMPLOYEE', 'DEPARTMENT');

--����ڰ� ���� index ����
create index idx_employee_ename
on employee(ename);
--Ȯ��
select index_name, table_name, column_name
from user_IND_columns
where table_name IN('EMPLOYEE');

--���ϳ��� ���̺� index�� ������ DB ���ɿ� ���� ���� ������ ��ĥ�� �ִ�. ---> index ����
DROP index idx_employee_ename;
--Ȯ��
select index_name, table_name, column_name
from user_IND_columns
where table_name IN('EMPLOYEE');

----------------------------------------------------------------------------
----------------------------------------------------------------------------
--�Ͻ� P299
--�ε��� ���α����� B-Tree(Balanced= ����Ʈ��)���� �����Ǿ� �ִ�.
--�÷��� �ε����� �����ϸ� �̸� B-Tree�� �����Ǿ�� �ϱ� ������
--�ε��� ���� ���� �ð��� �ʿ��ϰ� �ε����� ���� �߰������� �ʿ�

--�ε��� ���� �Ŀ� ���ο� ���� �߰��ϰų� ������ ���
--�ε����� ���� �÷����� �Բ� ����---> ���� ����(B-Tree)�� �Բ� ����ȴ�.
--����Ŭ ������ �� �۾��� �ڵ����� �߻��ϹǷ� �ε����� �ִ� ����� 
--DML(=Data Manipulation Language)�۾��� �ξ� ���ſ�����.(=�ӵ��� ������)
--��ȹ������ �ʹ� ���� �ε����� �����ϸ� ������ ������ ���Ͻ�ų �� �ִ�.

--�ִ� 3���� �ڽ��� ���� B-Tree���� 3�� ã�´ٸ�
--					4(root=�Ѹ�)���
--			2			6	
--		1		3	5		7

--�Ͻ� P300 ǥ ����
--<�ε��� ����ؾ� �ϴ� ���>
--���̺��� ��� ���� ��
--while���� �ش� �÷��� ���� ���� ��
--�˻������ ��ü �������� 2% ~ 4% ������ �� 
--join�� ���� ���Ǵ� �÷��̳� null�� �����ϴ� �÷��� ���� ��

--<�ε��� ������� ���ƾ� �ϴ� ���>
--���̺��� �� �� ���� ��
--where���� �ش� �÷��� ���� ������ ���� ��
--					10 ~ 15% �̻��� ��
--���̺� DML(=Data Manipulation Language)�۾��� ���� ���, 
--�� �Է� ���� ���� ���� ���� �Ͼ �� ����Ѵ�.

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--�ڱ��� �̿� ����
--(��)�ε��� ����ؾ� �ϴ� ���
create table emp12
as
select * 
from employee;

select distinct ename
from emp12
where dno = 10;

--�������� ������
--1. ���̺� ��ü ���� ��: 10000��
--2. �� �������� ��ü ������ �߿��� 95% ���ȴ�.
--3. �������� ����� �������� ��: 200�� ������� dno �÷��� �ε����� ����ϴ� ���� ȿ�����̴�.
--							�˻������ ��ü �������� 2 ~ 4% �����̹Ƿ� �ε����� �־�� �˻��� ������ �� �ֱ� �����̴�.

--�ε����� ������ �Ŀ� ���ο� ���� �߰�, ����, ���� �۾��� ������
--node�� ������ �ֱ������� �Ͼ '����ȭ' ���� �߻�
--����ȭ(=fragmentation): ������ ���ڵ��� �ε��� �� �ڸ��� ��� �Ǵ� ����
-- ---> �˻� ���� ���ϵȴ�.
--����
alter index idx_employee_ename rebuild;--�ε����� �ٽ� �����Ͽ�
--������ ����ȭ�� ���� �ε����� ������ �۾��� �ؾ� ���� ȿ���� ���� �� �ִ�.

--<���̺��� �÷��� �����Ͱ� �Է� ���� ������ ���, �ش� �÷��� ���� ������ '�ε����� ���ؼ� �籸���� �ؾ��ϴ� ����'?
--1. �ε����� �����ϴ� B-Tree������ �ε��� Ű�� ���ؼ� ������ ���� ������ �����ϰ� �ִ�.
---- ���ο� ��尡 �߰��Ǹ�,
---- �� ��忡 ���ؼ� �ε����� ���� ������ �籸���Ǿ�߸� �ε��� Ű�� ���� ������ ���� �� �� �ֱ� �����̴�.
--2. ����ȭ������ �ذ��Ͽ� �˻� ���� �ø��� ����
----------------------------------------------------------------------------
----------------------------------------------------------------------------

--4. �ε��� ����(P 301����)
--4.1 ����/�� ���� �ε���
--�����ε���: �⺻Ű(unique + not null)�� ����Ű(unique)ó�� ������ ���� ���� �÷��� ������ �ε���
--			unique ������ (��) �μ� ���̺��� �μ���ȣ
--����� �ε���: �ߺ��� �����͸� ���� �÷��� ������ �ε���
--			unique ������(��) �μ����̺��� �μ����̳� ������
create UNIQUE index �ε�����
ON ���̺��(�÷���);

--�����ε��� �����ϱ�
create UNIQUE index idx_dept_dno
ON dept12(dno));
--�ǻ�: invalid CREATE INDEX option
--����: ������ '�⺻Ű �������� �߰�'�ϸ鼭 �ڵ����� index �����Ǿ���.

--���-1: ���� -�ڵ������� dno�� index�� ã�Ƽ� �����ϱ� ���� ���
select index_name, table_name, column_name
from user_ind_columnS
where table_name in('DEPT12');

drop table SYS_C007132;--����: �������Ǹ� �̸��� ����.

--���-2: ���� - dno�� �⺻Ű �������� ���� ã�� ���� �� ---> �ٽ� dno�� ���� �ε��� �����ϱ�
--dno: �⺻Ű �������� ����
select table_name, constraint_name, constraint_type
from user_ind_constraintS
where table_name in('DEPT12');

alter table dept12
drop constraint SYS_C007132 cascade;

--dno�� ���� �ε��� �����ϱ�(����) 
create UNIQUE index idx_dept_dno
on dept12(dno);

--�ڡڰ��� �ε����� �����Ƿ��� �߰��� �����Ϳ� �ߺ��� ���� �־�� �ȵȴ�.
--���� ������ �߻��Ѵٸ� cannot CREATE UNIQUE index idx_dept_loc; duplicate keys found
--�ߺ��� �����Ͱ� �ֱ� �����̴�.
create UNIQUE index idx_dept_loc
on dept12(loc);--����

--------------------------------------------------------
--�ڡڰ��� �ε����� �����Ƿ��� �߰��� �����Ϳ� �ߺ��� ���� �־�� �ȵȴ�. (�׽�Ʈ)
--�׽�Ʈ ���� ���̴�.
create table dept12_2
as
select * from department;
--���̺� ������ ������ ����ȴ�.(�������� ���� �ȵȴ�.dno�� �⺻Ű�� �ƴϴ�.)

insert into dept12_2 values(10, 'ACCOUNTING', 'SEOUL');

select * from dept12_2;
--����(dno�� �⺻Ű�� �ƴϹǷ� �ߺ��� 10 �Է°����ϴ�.) ���� dno�� 10���� �ߺ�, loc �ߺ��� ���� ����.

--dno�� ���� index �����ϱ�
drop index idx_dept12_2_dno;

create UNIQUE index idx_dept12_2_dno
on dept12_2(dno);
--����:cannot CREATE UNIQUE INDEX; duplicate keys(=�ߺ��� Ű) found
--dept12_2�� ������ �� department�� ���������� ���(����)���� ���ؼ�
--dno�� �⺻Ű�� �ƴϴ�.---> dno 10�� 2�� �ߺ� ����ȴ�.

--loc�� ����index �����ϱ�
create UNIQUE index idx_dept12_2_loc
on dept12_2(loc);
--����: loc���� �ߺ��� ���� �����Ƿ� �����ε��� ���� �����ϴ�.

--------------------------------------------------------

--���ݱ��� ������ �ε����� '�ܼ� �ε���'(�Ѱ��� �÷����� ������ �ε���)--
--4.2 �����ε���: �� �� �̻��� �÷����� ������ �ε���
create index idx_dept_complex
on dept12(dname, loc);

--idx_dept_complex �ε����� �̿��Ͽ� �˻��ӵ��� ���̴µ� ���Ǵ� ��
select * 
from dept12
where dname=' ' and loc=' ';
--�׷��� �� ������ ���� ������ �ʴ´ٸ� ������ �������ϰ� �߻��Ѵ�.

select * 
from dept12
where dname=' '; 
--dname�� index�� ������ 
--dname�� loc�� �����Ͽ� ������ idx_dept_complex �ε����� ����Ͽ� �˻��Ѵ�.
--���� ��ü ���̺� �˻����� �� ȿ�����̴�.

--4.3 �Լ���� �ε���: �����̳� �Լ��� �����Ͽ� ���� �ε����̴�.
create index idx_emp12_salary12
on emp12(salary*12);--�����̹Ƿ� �÷����� ��� ���� �÷��� �����ȴ�.

select --index_name, table_name, column_name
from user_ind_columnS--�÷��� Ȯ���ϱ� ���� user_ind_columnS ���� �̿�
--from user_ind_columnS-- user_indexes ������ �÷��� ��ȸ�Ұ��ϴ�.
where table_name in('EMP12');--column_name��  SYS_NC000009$�̴�.

--<12�� �������� �ε��� ȥ�� �غ���>-----------------------------
--1. ������̺��� �����ȣ�� �ڵ����� �����ǵ��� �������� �����Ͻÿ�.
create sequence emp_up
start with 10
increment by 1;

--2. �����ȣ�� �������κ��� �߱޹����ÿ�.
drop table emp01;

create table emp01(
empno number(4) primary key,
ename varchar2(10),
hiredate date
);

--3. EMp01 ���̺��� �̸� �÷��� �ε����� �����ϵ� �ε��� �̸��� IDX_EMP01_ENAME�� �����Ͻÿ�.
select * from EMP;

create index IDX_EMP01_ENAME
on EMP01(ename);
