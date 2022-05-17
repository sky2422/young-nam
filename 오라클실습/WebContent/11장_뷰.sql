---<�Ͻ� 11��_��>

--1. ��: �ϳ��̻��� ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� '�������̺�'
--��, ���������� �����͸� �������� �ʰ� ������ ������ �並 ������ �� ����� '�������� ����'

--�並 �����ϱ� ���� ���� ���̺�: �⺻ ���̺�
--��� ������ ��� ������ �������� �ʱ� ������ �信 ���� ���� �����
--�並 ������ �⺻ ���̺� ����ȴ�.

--�ݴ�� �⺻���̺��� ������ ����Ǹ� �信 �ݿ��ȴ�. �並 �����ϴ��� �⺻���̺��� ������� �ʴ´�.
--�並 ������ �⺻����Ŭ�� '���Ἲ ��������' ���� ��ӵȴ�.
--���� ���Ǹ� ��ȸ�Ϸ���: user_viewS ������ �����̴�.

--��� '������ ������ �ܼ�ȭ' ��ų�� �ִ�.
--��� ����ڿ��� �ʿ��� ������ �����ϵ��� '������ ����' �� �� �ִ�.

--1.1 �� ����
--�ش��ȣ([ ])�� �׸��� �ʿ����� ���� ��� ������ �����ϴ�.
create [or replace] [FORCE|NOFORCE(�⺻��)]
VIEW ���̸�[(�÷���1, �÷���2,...): �⺻���̺��� �÷���� �ٸ��� ������ ��� ����Ѵ�. �ؼ����� ������ ����� �Ѵ�.]
AS ��������
[WITH CHECK OPTION [constraint �������Ǹ�]]
[WITH READ ONLY];--select���� ����, DML(������ ���۾�: ���� INSERT, UPDATE, DELETE) �Ұ�

--or replace: �ش� ������ ����ϸ� �並 ������ �� DROP ���� ������ �����ϴ�.

--FORCE: �並 ������ �� �������� ���̺�, �÷�, �Լ� ���� �������� �ʾƵ� ���� �����ϴ�.
--		  ��, �⺻���̺��� ���� ������ ������� �� �����ȴ�.

--NOFORCE: �並 ������ ��  �������� ���̺�, �÷�, �Լ� ���� �������� ������ �������� �ʴ´�.
--		      �ݵ�� �⺻ ���̺��� ������ ��쿡�� �� ����
--		      �������� ������ NOFORCE�� ����Ѵ�.

--WITH CHECK OPTION: WHERE ���� ���ǿ� �ش��ϴ� �����͸� ����, ������ �����ϴ�.
--WITH READ ONLY: select���� ����, DML(=������ ���۾�: ���� INSERT, UPDATE, DELETE) �Ұ�

--�÷����� ������� ������ �⺻ ���̺��� �÷����� ����Ѵ�.
--<�÷��� �ݵ�� ����ؾ� �ϴ� ���>
--[1] �÷��� �����, �Լ�, ������� �Ļ��� ���
--[2] join ������ �� �̻��� �÷��� ���� �̸��� ���� ���
--[3] ���� �÷��� �Ļ��� �÷��� �ٸ� �̸��� ���� ��� 

--1.2 ���� ����
--[1] �ܼ� ��: �ϳ��� �⺻���̺�� ������ ��
--			 DML ��ɹ��� ó�� ����� �⺻ ���̺� �ݿ��ȴ�.
--			 �ܼ� ��� ���� ���̺� �ʿ��� �÷��� ������ ���̴�.
--			 �׷��� JOIN, �Լ� GROUP BY, UNION ���� ������� �ʴ´�.
--			 �ܼ� ��� SELECT + INSERT, UPDATE, DELETE�� �����Ӱ� ��� �����ϴ�.

--[2] ���� ��: �� �� �̻��� �⺻���̺�� ������ ��
--			 DISTINCT, �׷��Լ�, rownum�� �����ؼ� ����� �� ����.
--			 ���� ��� JOIN, �Լ�, GROUP BY, UNION ���� ����Ͽ� �並 ������ �� �ִ�.
--			 �Լ� ���� ����� ��� '�÷� ��Ī'�� �� �ο��ؾ� �Ѵ�.(��: AS hiredate)
--			 ���� ��� SELECT�� ��� ����������  INSERT, UPDATE, DELETE�� ��Ȳ�� ���� �������� ���� ���� �ִ�.

--<�ǽ��� ���� ���ο� ���̺� 2�� ����>
create table emp11
as
select * from employee;

create table dept11
as
select * from department;
--���̺� ������ �����͸� ����(�ڴ�, ���������� ���簡 �ȵȴ�.)

--[1] �ܼ� view(��)
create view v_emp_job(�����ȣ, �����, �μ���ȣ, ������)
as 
select eno, ename, dno, job
from emp11
where job like 'SALESMAN';

select * from v_emp_job;

create view v_emp_job2--��������(�⺻���̺�)�� �÷����� �״�� ����
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
--����: ���� �̸��� view�� �����ϱ� �����̴�.

--OR REPLACE: �̹� �����ϴ� view�� ������ ���Ӱ� �����Ͽ� �����
--			  �������� �ʴ� ��� �並 ���Ӱ� ����
--����, create OR REPLACE view�� ����Ͽ� ���뼺 �ִ� view �����ϴ� ���� �����Ѵ�.
create OR REPLACE view v_emp_job2
as 
select eno, ename, dno, job
from emp11
where job like 'MANAGER';

select * from v_emp_job2;
--OR REPLACE�� MANAGER�� ����� �������� ���� ��µȴ�.

--[2] ���� view(��)
create OR REPLACE view v_emp_dept_complex
as
select *
from emp11 natural join dept11
order by dno asc;

select * from v_emp_dept_complex;

--���� ���̺��� ���ǿ� ���� �ʴ� row�� ��� �߰��Ѵ�. 
create OR REPLACE view v_emp_dept_complex
as
select *
from emp11 e full outer join dept11 d
using(dno)--�ߺ�����
order by dno asc;

select * from v_emp_dept_complex;

--1.3 view�� �ʿ伺
--�並 ����ϴ� ������ '����'�� '����� ���Ǽ�' ����
--[1] ����: ��ü �����Ͱ� �ƴ� '�Ϻθ� ����' �ϵ��� �並 �����ϸ�
--			�Ϲ� ����ڿ��� �ش� �丸 �����ϵ��� ����Ͽ�
--			�߿��� �����Ͱ� �ܺο� �����Ǵ� ���� ���� �� �ִ�.
--(��: ������̺��� �޿��� Ŀ�̼��� �������� �����̹Ƿ� �ٸ� ������� ���� �����ؾ� �Ѵ�.)

--��, ��� ������ ������ �ܼ�ȭ ��ų�� �ִ�.
--	  ��� ����ڿ��� �ʿ��� ������ �����ϵ��� ������ ���� �� �� �ִ�.

--��: ������̺��� '�޿��� Ŀ�̼��� ����'�� ������ �÷����� ������ �� ����
select * from emp11;

create OR REPLACE view v_emp_sample
as
select eno, ename, job, manager, hiredate, dno--salary, commissoin�� ����
from emp11;

select * from v_emp_sample;

--[2] ����� ���Ǽ�: '���������� ��'�ϰ� �ϱ� ���� '�並 ����'
--					����ڿ��� '�ʿ��� ������ ���������� ����'�Ѵ�.
--'����� ���� �μ��� ���� ����'�� �Բ� ������ ��� ���̺�� �μ����̺��� �����ؾ��Ѵ�.
--������ �̸� ��� ������ �θ� '�並 ��ġ ���̺�ó�� ���'�Ͽ� ���ϴ� ������ ���� �� �ִ�.
create OR REPLACE view v_emp_dept_complex2
as
select eno, ename, dno, dname, loc--����������
from emp11 natural join dept11 
order by dno asc;

select * from v_emp_dept_complex2;
--�並 ���� ������ ���ι��� ������� �ʰ� ������ ���� ������ �ִ�.

--1.4. ���� ó�� ����
select view_name, text
from USER_viewS;

--USER_viewS ������ ������ ����ڰ� ������ '��� �信 ���� ����'�� ����
--��� select ���� �̸��� ���ΰ�
--[1] �信 ���Ǹ� �ϸ�  ����Ŭ ������ USER_viewS���� �並 ã�� ������������ �����Ų��.
--[2] '����������'�� �⺻���̺��� ���� ����ȴ�.

--��� select������ �⺻ ���̺��� ��ȸ�ϰ�
--DML(INSERT, UPDATE, DELETE)������ �⺻���̺��� ���� �����ϴ�.
--(��, �׷��Լ��� �����÷����� ���� ��� DML �����Ѵ�.)
select * from emp11;--�⺻���̺� emp11(������������ ���簡 �ȵǾ� �ִ� ��Ȳ�̴�.)
select * from v_emp_job;--�⺻���̺� emp11(������������ ���簡 �ȵȴ�.)

insert into v_emp_job values(8000, 'ȫ�浿', 30, 'SALESMAN');
--������: �� ���ǿ� ���Ե��� �ʴ� �÷� �߿� '�⺻ ���̺��� �÷���  not null ���������� �����Ǿ� �ִ� ���'
--insert ����� �Ұ����ϴ�.

--insert Ȯ���ϸ�
select * from emp11;--�⺻���̺�(������������ ���簡 �ȵǾ� �ִ� ��Ȳ�̶� ���� eno 8000�� �߰��Ǿ��ִ�.)

insert into v_emp_job values(9000, '�̱浿', 30, 'MANAGER');--����
select * from v_emp_job;--�� ��ȸ���� �������� �ʴ´�.
--����: ���������� where��:  job�� 'SALESMAN'���� �����߱� �����̴�.

select * from emp11;--�⺻���̺��� �����Ѵ�.

--1.5 �پ��� ��
--�Լ� ����Ͽ� �� ���� ����
--������: �׷��Լ��� �������� �÷��� �������� �ʰ� ����� �����÷�ó�� ����Ѵ�.
--		�����÷��� �⺻���̺��� �÷����� ��ӹ����� ���� ������ �ݵ�� '��Ī ���'�ؾ��Ѵ�.
create OR replace view v_emp_salary
as
select dno, sum(salary), avg(salary)--����: must name this expression with a column alias
from emp11
group by dno;

create OR replace view v_emp_salary
as
select dno, sum(salary) AS "sal_sum", avg(salary) AS "sal_avg"--�����ذ�: ��Ī���
from emp11
group by dno;

select * from v_emp_salary;

select * from emp11;

--��: �׷��Լ��� �����÷����� ���� ��� DML ��� ���Ѵ�.
insert into v_emp_salary values(50, 2000, 200);--����: virtual column not allowed here

/*
 * �ܼ� �信�� DML ��ɾ� ����� �Ұ����� ����?
 * 1. �� ���ǿ� ���Ե��� ���� �÷� �߿� �⺻ ���̺��� �÷��� NOT NULL ���������� �����Ǿ� �ִ� ��� INSERT�� ����� �Ұ����ϴ�.
 * �ֳ��ϸ� �信 ���� INSERT���� �⺻ ���̺��� �����ǿ� ���Ե��� �ʴ� �÷��� NULL���� �Է��ϴ� ���°� �Ǳ� �����̴�.
 * 2. salary*12�� ���� ��� ǥ�������� ���ǵ� ���� �÷��� �信 ���ǵǸ� INSERT�� UPDATE�� �Ұ����ϴ�.
 * 3. DISTINCT�� ������ ��쿡�� DML ��� ����� �Ұ����ϴ�.
 * 4. �׷��Լ��� GROUP BY���� ������ ��쵵 DML ��� ����� �Ұ����ϴ�.
 */
--1.6 �� ����
--�並 �����Ѵٴ� ���� USER_viewS ������ ������ ���� ���� ����
DROP VIEW v_emp_salary;

select view_name, text
from USER_viewS
where view_name IN ('V_EMP_SALARY');--�����Ǿ� ����� �������� ���´�.

--2. �پ��� �� �ɼ�
--�ش��ȣ([ ])�� �׸��� �ʿ����� ���� ��� ������ �����ϴ�.
create [or replace] [FORCE|NOFORCE(�⺻��)]
VIEW ���̸�[(�÷���1, �÷���2,...): �⺻���̺��� �÷���� �ٸ��� ������ ��� ����Ѵ�. �ؼ����� ������ ����� �Ѵ�.]
AS ��������
[WITH CHECK OPTION [constraint �������Ǹ�]]
[WITH READ ONLY];--select���� ����, DML(������ ���۾�: ���� INSERT, UPDATE, DELETE) �Ұ�

--or replace: �ش� ������ ����ϸ� �並 ������ �� DROP ���� ������ �����ϴ�.

--FORCE: �並 ������ �� �������� ���̺�, �÷�, �Լ� ���� �������� �ʾƵ� ���� �����ϴ�.
--		  ��, �⺻���̺��� ���� ������ ������� �� �����ȴ�.

--NOFORCE: �並 ������ ��  �������� ���̺�, �÷�, �Լ� ���� �������� ������ �������� �ʴ´�.
--		      �ݵ�� �⺻ ���̺��� ������ ��쿡�� �� ����
--		      �������� ������ NOFORCE(�⺻��)�� ����Ѵ�.

--WITH CHECK OPTION: WHERE ���� ���ǿ� �ش��ϴ� �����͸� ����(=insert), ����(=update)�� �����ϴ�.
--WITH READ ONLY: select���� ����, DML(=������ ���۾�: ���� INSERT, UPDATE, DELETE) �Ұ�

--2.1 OR REPLECE

--2.2 FORCE
--FORCE �ɼ��� ����ϸ� �������� ���̺�, �÷�, �Լ� ���� �������� ���� ��� (��, �⺻���̺��� �������� �ʴ´�.)
--'�����߻�����'��� ����������. INVALID �����̱� ������ ��� �������� �ʴ´�.
--(��, USER_viewS ������ ������ ��ϵǾ� ������ �⺻���̺��� �������� �ʴ´�.)
--������ ������ ���������� �䰡 �����ȴ�.
create or replace view v_emp_notable
as
select eno, ename, dno, job
from emp_notable;--�⺻���̺��� �������� �ʴ´�.(�⺻�� NOFORCE)---> ���� �ذ��Ϸ��� FORCE �߰��ؾ��Ѵ�.
where job like 'MANAGER';

drop view v_emp_notable;

create or replace force view v_emp_notable--����
as
select eno, ename, dno, job
from emp_notable
where job like 'MANAGER';


select view_name, text
from user_viewS
where view_name =upper('v_emp_notable');
--where lower(view_name) =('v_emp_notable');
--where view_name IN ('V_EMP_NOTABLE');

select * from v_emp_notable;--����

--2.3 WITH CHECK OPTION
--�ش� �並 ���ؼ� ���� �ִ� ���� �������� insert �Ǵ� update �����ϴ�.
--��: �������� MANAGER�� ������� ��ȸ�ϴ� �� ����
create or replace view v_emp_job_nochk
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER';

select * from v_emp_job_nochk;

insert into v_emp_job_nochk values(9100, '�̼���', 30, 'SALESMAN');
select * from v_emp_job_nochk;--�信�� ������
select * from emp11;--�⺻���̺��� �߰��Ǿ���.---> "ȥ�� �߻�"
--���� '�̿��� �����ϱ� ����'
--with check option ����Ͽ� �⺻ ���̺��� �߰� �ɼ� ������ ����
--��, with check option���� �並 ������ �� �������ÿ� ���� �÷����� �������� ���ϵ��� �Ѵ�.
create or replace view v_emp_job_chk
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER' with check option;

insert into v_emp_job_chk values(9500, '������', 30, 'SALESMAN');--����: �߰� �ȵȴ�.
--with check option: ��������(='MANAGER')�� ���� ����� �÷����� �ƴ� (='SALESMAN')���� ���ؼ��� �並 ���ؼ� �߰�/�������� ���ϵ��� ���´�.

insert into v_emp_job_chk values(9500, '������', 30, 'MANAGER');--����: �߰��ȴ�.

select * from v_emp_job_chk;--�信�� �߰��Ǿ���
select * from emp11;--�⺻���̺��� �߰��Ǿ���.

--2.4 WITH READ ONLY: select���� ����, DML(=������ ���۾�: ���� INSERT, UPDATE, DELETE) �Ұ�
create or replace view v_emp_job_readonly
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER' with read only;

select * from v_emp_job_readonly;--��ȸ�� �����ϴ�.
insert into v_emp_job_readonly values(9700, '������', 30, 'MANAGER');--����

--<11�� �� ȥ�� �غ���>-----------------------------
--1.20�� �μ��� �Ҽӵ� ����� �����ȣ,�̸�,�μ���ȣ�� ����ϴ� select����
--��� ����(v_em_dno)
create view v_em_dno
as
select eno, ename, dno
from emp11
where dno=20;

--2.�̹� ������ v_em_dno �信 �޿� ���� ��µǵ��� ����
create or replace view v_em_dno--�����
as
select eno, ename, dno, salary
from emp11
where dno=20;

--3.�� ����
drop view v_em_dn0;
