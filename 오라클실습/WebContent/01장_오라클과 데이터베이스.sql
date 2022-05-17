--<�Ͻ�-01��_����Ŭ�� �����ͺ��̽�>

/*
 * P26~
 * '�����ͺ��̽� �����'�� '����Ŭ ����'�� ���� �ǹ�
 * <����Ŭ���� �����ϴ� ����� ����>
 * 1.sys : �ý��� ����, ����, ���� '��� ����'. ����Ŭ�ý��� '�Ѱ�����'. sysdba����
 * 2.system : ������ DB�, ����. '������'����. sysoper����
 * 3.hr : ó�� ����Ŭ ����ϴ� ����ڸ� ���� �ǽ����� '������ ����'
 */

--3.2 �����ͺ��̽� �����ϱ�
--(1). �����ͺ��̽� ���� = ���̺� ����
--(2). ��������� ����� �Ҽӵ� �μ� ������ �޿� ���� ������ ���̺� ����

--���̺� ����
DROP table employee;--�ڽ����̺� : �ڽ����̺��� �θ� ���̺��� dno ����
DROP table department;--�θ����̺� : ������ -�����Ǵ� ��Ȳ������ �����Ұ���(�׷��� �ڽĺ��� �����ؾ� �θ� ���� ������)
DROP table salgrade;

--�μ� ����
--����, '�μ����� ���̺�'���� �����.(������� ���̺��� �����ϰ� ������)
create table department(
dno number(2) primary key,--'�μ���ȣ'�� �⺻Ű(=primary key:�ߺ�X, unique������)+not null��.(Mysql : int)
dname varchar2(14),--'�μ���':����ũ��(Mysql : varchar)
loc varchar2(13)--'������'
);

--�μ����� ���̺� �����͸� �߰��Ѵ�.
insert into department values(10,'ACCOUNTING','NEW YORK');
insert into department values(20,'RESEARCH','DALLAS');
insert into department values(30,'SALES','CHICAGO');
insert into department values(40,'OPERATIONS','BOSTON');

--�μ����� ���̺� ��ȸ(��� ��:*)
select * from department;

--��� ����---------------------------------------
--������� ���̺��� �����.
create table employee(
eno number(4) primary key,--�����ȣ(�⺻Ű=PK:�ߺ�X,����)
ename varchar2(10),--�����
job varchar2(9),--������
manager number(4),--�ش� ����� ����ȣ(=������)
hiredate date,--�Ի���
salary number(7,2),--�޿�(�Ǽ�:�Ҽ����� ������ ��ü �ڸ���, �Ҽ��� ���� �ڸ�)
commission number(7,2),--Ŀ�̼�
dno number(2) references department--�μ���ȣ(�ܷ�Ű=����Ű=FK)--references=�����Ѵ�
--department���̺����� dno�� �⺻Ű�� �ݵ�� �����ؾ� �Ѵ�.
);

--INSERT INTO EMPLOYEE VALUES
--(7000,'KIM','CLERK', 7902, '1980-12-17' ,800,NULL,20);

--INSERT INTO EMPLOYEE VALUES
--(7001,'LEE','CLERK', 7902, '1980/12/17' ,800,NULL,20);

--INSERT INTO EMPLOYEE VALUES
--(7002,'JANG','CLERK', 7902, '1980/12/17' ,NULL,NULL,20);

INSERT INTO EMPLOYEE VALUES
(7369,'SMITH','CLERK', 7902, to_date('17-12-1980','dd-mm-yyyy') ,800,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);
INSERT INTO EMPLOYEE VALUES
(7521,'WARD','SALESMAN', 7698,to_date('22-2-1981', 'dd-mm-yyyy'),1250,500,30);
INSERT INTO EMPLOYEE VALUES
(7566,'JONES','MANAGER', 7839,to_date('2-4-1981', 'dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7654,'MARTIN','SALESMAN', 7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMPLOYEE VALUES
(7698,'BLAKE','MANAGER', 7839,to_date('1-5-1981', 'dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMPLOYEE VALUES
(7782,'CLARK','MANAGER', 7839,to_date('9-6-1981', 'dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMPLOYEE VALUES
(7788,'SCOTT','ANALYST', 7566,to_date('13-07-1987', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7839,'KING','PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMPLOYEE VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981', 'dd-mm-yyyy'),1500,0,30);
INSERT INTO EMPLOYEE VALUES
(7876,'ADAMS','CLERK',   7788,to_date('13-07-1987', 'dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7900,'JAMES','CLERK',   7698,to_date('3-12-1981', 'dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMPLOYEE VALUES
(7902,'FORD','ANALYST',  7566,to_date('3-12-1981', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7934,'MILLER','CLERK',  7782,to_date('23-1-1982', 'dd-mm-yyyy'),1300,NULL,10);

delete from employee where ename='JANG';
--��� ���� ���̺� ��ȸ
SELECT * FROM EMPLOYEE;

--�޿� ����---------------------------------------
--�޿����� ���̺��� �����.
create table salgrade(
grade number,--�޿� ���
losal number,--�޿� ���Ѱ�
hisal number--�޿� ���Ѱ�
);

--������ �߰�
insert into salgrade values(1,  700, 1200);
insert into salgrade values(2, 1201, 1400);
insert into salgrade values(3, 1401, 2000);
insert into salgrade values(4, 2001, 3000);
insert into salgrade values(5, 3001, 9999);
--insert into salgrade values(6, 100, null);

--��ȸ(*��� ��)
select * from salgrade;

select ename, salary, salary*12
from employee
where ename='SMITH';--sql = ����(�ڹٿ����� ���� ==, =���Կ�����)

/*
 * ��� ���꿡 null�� ����ϴ� ��쿡�� Ư���� ���ǰ� �ʿ���
 * null�� '��Ȯ��', '�˼����� ��'�� �ǹ��̹Ƿ� '����,�Ҵ�,�񱳰� �Ұ���'��
 */

--Ŀ�̼��� ���� ���� ���ϱ�
select ename, salary, commission, salary*12+commission
from employee;
--commission�� null�̸� ����� null(������ �ȵǴ� ���� �߻�)

--nvl()�Լ� ����Ͽ� ���� ���� �ذ���
--NVL(��,0) ���� null�̸� 0���� ����, null�� �ƴϸ� ���� �״�� ���
select ename, salary, commission, salary*12+NVL(commission, 0)
from employee;

/*
 * ��Ī
 * 1. �÷��� ��Ī
 * 2. �÷��� AS ��Ī
 * 3. �÷��� AS "��Ī+Aa" 
 * �ݵ�� "" �ؾ� �Ǵ� ��Ģ
 * ��Ī ���ڻ��̿� '����, Ư������ �߰�' �Ǵ� '��ҹ��� ����'
 * 
 */

select ename ����̸�, salary AS "�� ��", commission as "Cms", salary*12+NVL(commission, 0) AS "����+Ŀ�̼�"
from employee;

--distinct:�ߺ��� �����͸� �ѹ����� ǥ��
select distinct dno--�μ���ȣ
from employee;

--dual : �������̺�, ������� 1���� ǥ���ϰ� ���� �� ���
 
--sysdate:��ǻ�ͷκ��� ���ó�¥(���� :�ڿ� ��ȣ ����)
select sysdate from employee;--14���̸� 14�� ���
select sysdate from dual;--���ó�¥ �ѹ��� ���










