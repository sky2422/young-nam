--<�Ͻ�-06��_���̺� �����ϱ�>

--1. ����
--1.1 ī��þ� �� (=������)=�� ��� : cross join (�� ��� cross join)- ���������� ����.
select * from EMPLOYEE; --�÷���:8, ���:14
select * from DEPARTMENT;--�÷���:3, ���:4

select * --11�� �÷�, 56�� ��ü ���
from EMPLOYEE, DEPARTMENT;--from EMPLOYEE join DEPARTMENT;--�����߻�(�ݵ�� ON+�������� �߰��ؾ� �ϹǷ�)
--���ΰ�� : �÷���(11) = ������̺��� �÷���(8) + �μ����̺��� �÷���(3)
--         ���(56) = ������̺��� ���(14) x �μ����̺��� ���(4)
--                 = ������̺��� ��� 1�� �� x �μ����̺��� ���(4)

select eno --eno �÷���, 56�� ��ü ���
from EMPLOYEE, DEPARTMENT;

select * --11�� �÷�, eno�� 7369�� �͸�
from EMPLOYEE, DEPARTMENT
where eno = 7369;--(�������Ǿƴ�)�˻�����

select eno --eno �÷���, 56�� ��ü ���
from EMPLOYEE CROSS JOIN DEPARTMENT;

--1.2 ������ ����
--����Ŭ 8i���� ���� : equi ����(=� ����), non-equi ����(=�� ����), outer ����(����, ������), self ����
--����Ŭ 9i���� ���� : cross ����, natural ����(=�ڿ� ����), join~using, outer ����(����, ������, full����)
--(����Ŭ 9i���� ANSI ǥ�� SQL ���� : ���� ��κ��� ��� �����ͺ��̽� �ý��ۿ��� ���.
--                            �ٸ� DBMS�� ȣȯ�� �����ϱ� ������ ANSI ǥ�� ���ο� ���ؼ� Ȯ���� �н�����.

-----<�Ʒ� 4���� ��>--------------------------------------------------------------------
--[�ذ��� ����] '�����ȣ�� 7788'�� ����� �Ҽӵ� '�����ȣ, ����̸�, �ҼӺμ���ȣ, �ҼӺμ��̸�' ���

--2.equi join(=�����=��������) : ������ �̸��� ����(=������ Ÿ��)�� ���� �÷����� ����
--            ��  ���-1 , ~ where ��  ���-2 join~on�� ������ Ÿ�Ը� ���Ƶ� ������ ��

--[���-1 : , ~ where]
--������ �̸��� ������ ������ ���� �÷����� ���� + "������ ������ ����"�ϰų� "������ �÷��� ����"�� �� where ���� ���
--���ΰ���� �ߺ��� �÷� ����X -> ���� ���̺� '��Ī ���'�ؼ� ��� ���̺��� �÷����� �����ؾ� ��
select �÷���1, �÷���2...--�ߺ��Ǵ� �÷��� �ݵ�� '��Ī.�÷���'(��)e.dno
from ���̺�1 ��Ī1, ���̺�2 ��Ī2--��Ī ���(��Ī : �ش� SQL��ɹ��������� ��ȿ��)
where ����������(���� : ���̺��� ��Ī ���)
AND   �ڰ˻�����
--�ڹ����� : ������ �ʴ� ����� ���� �� �ִ�.(����? AND -> OR�� �켱���� ������)
--�ڹ����� �ذ�� : AND �˻����� ���� '��ȣ()�� �̿��Ͽ� �켱���� ����'
--��)�μ���ȣ�� ������ �� �μ���ȣ�� 10�̰ų� 40�� ���� ��ȸ
--where e.dno=d.dno AND d.dno=10 OR d.dno=40;--���� �߻�
--where e.dno=d.dno AND (d.dno=10 OR d.dno=40);--���ذ�� : '��ȣ()�� �̿��Ͽ� �켱���� ����'

--�ڡڡ� [����] �� ����� outer join�ϱⰡ ���ϴ�.
select *
from EMPLOYEE e, DEPARTMENT d 
where e.dno(+)=d.dno;--�� ���̺��� ���� dno���� ����(�׷��� �μ����̺��� 40�� ǥ�þȵ�. ���� (+)�ٿ� outer join)

select *
from EMPLOYEE e RIGHT OUTER JOIN DEPARTMENT d -- �������� �μ����̺��� 40�� ǥ��
ON e.dno=d.dno;

--[�����ذ�]
select eno, ename, e.dno, dname--��Ī��� : �� ���̺� ��� �����ϹǷ� �����ϱ� ����
from EMPLOYEE e, DEPARTMENT d
where e.dno=d.dno
AND eno = 7788;

--[���-2 : (INNER)join ~ on]
--������ �̸��� ������ ������ ���� �÷����� ���� + "������ ������ ����"�ϰų� "������ �÷��� ����"�� �� ON ���� ���
--���ΰ���� �ߺ��� �÷� ����X -> ���� ���̺� '��Ī ���'�ؼ� ��� ���̺��� �÷����� �����ؾ� ��

select �÷���1, �÷���2...--�ߺ��Ǵ� �÷��� �ݵ�� '��Ī.�÷���'(��)e.dno
from ���̺�1 ��Ī1 JOIN ���̺�2 ��Ī2--��Ī ���
ON    ����������(���� : ���̺��� ��Ī ���)
where �ڰ˻�����
--[���-1]���� ��Ÿ�� ������ �߻����� �����Ƿ� �˻����ǿ��� ()�����ص� ��

--[�����ذ�]
select eno, ename, e.dno, dname--��Ī��� : �� ���̺� ��� �����ϹǷ� �����ϱ� ����
from EMPLOYEE e INNER JOIN DEPARTMENT d
ON e.dno=d.dno
WHERE eno = 7788;

-----------------------------[���-1]�� [���-2]�� ������ Ư¡�� �����ϴ�.
-----------------------------               �� ���� ��� : �ߺ��� �÷� ����x -> ���̺� ��Ī ����
-----------------------------             ��  ������ Ÿ�Ը� ���Ƶ� join ���� (��)a.id=b.id2
----[�׽�Ʈ ���� �����ϰ� ���̺� �����Ͽ� 4���� ��� ��]----------------------------------------------
drop table A;
drop table B;

create table A(
id number(2) primary key,--���̵�
name varchar2(20),--�̸�
addr varchar2(100)--�ּ�
);

insert into A values(10,'������','�뱸 �޼���');
insert into A values(20,'�뼮��','�뱸 �ϱ�');

create table B(
id2 number(2) primary key,--���̵�
tel varchar2(20)--����ó
);

insert into B values(10,'010-1111-1111');
insert into B values(30,'010-3333-3333');

select *
from A, B;

--[���-1]
select *
from A a, B b
WHERE a.id=b.id2;--������ Ÿ�Ը� ���Ƶ� ������ ��('���� ���̵��� �ǹ�'�̹Ƿ� ����)
--[���-2]
select *
from A a JOIN B b
ON a.id=b.id2;--������ Ÿ�Ը� ���Ƶ� ������ ��('���� ���̵��� �ǹ�'�̹Ƿ� ����)

--[���-3]
select *
from A NATURAL JOIN B;--��Ī ������(����)
--[���] id�� id2�� �̸��� �ٸ��Ƿ� cross join����� ����.

select * from A, B;--cross join
select * from A join B;--���� �߻�(JOIN~�ݵ�� ON + ��������)

--[���-4]
select *
from A JOIN B
USING(id);--�����߻� : USING(���� �÷���) id�� id2�� �̸��� �޶� ���ξȵ�

--�׽�Ʈ���� 
--B2 ���̺� ����
create table B2(
id number(2) primary key,--���̵�(A�� B2�� ���̵� ����.)
tel varchar2(20)--����ó
);

insert into B2 values(10,'010-1111-1111');
insert into B2 values(30,'010-3333-3333');

--C ���̺� ����
drop table C;

create table C(
id number(2) primary key,--���̵�(A�� B2,C�� ���̵� ����.)
gender char(1)--'M' �Ǵ� 'F' ('��''��'�� �߰��ȵ�. ����?1����Ʈ���� Ŀ��)
);

insert into C values(10, 'M');
insert into C values(20, 'M');
insert into C values(30, 'F');
insert into C values(40, 'F');

--C2 ���̺� ����
create table C2(
tel varchar2(20) not null,--����ó(B2�� ����.)
hobby varchar2(20)--���
);

insert into C2 values('010-1111-1111', '');
insert into C2 values('010-2222-2222', '�౸');
insert into C2 values('010-3333-3333', '��ȭ����');

--[����] 3���� ���̺� ����
--[���-1]
--[���-2]

--[���-3] 
select *
from A NATURAL JOIN B2 NATURAL JOIN C;--��Ī ������(����)
--�� ���̺� ��� id�� �����Ƿ� id�� ����
--���� A�� B2�� id�� ���� -> ���ε� ��� ���̺��� id�� C�� id�� ����

--[����]id, �̸�, �ּ�, ����ó, ��� ���ϱ�
select id, name, addr, tel, hobby
from A NATURAL JOIN B2 NATURAL JOIN C2;
--A�� B2���̺��� id�� ������ ��� ���̺�� C2���̺�� tel�� ���ε�

--[����]id, �̸�, �ּ�, ����ó, ��� ���ϱ�
--�� [����]�� ����� �߰��� ������ ��� ǥ���ϴ� ���-1 : outer join ��� [���-2]
--[1]
select a.id, name, addr, tel
from A a JOIN B2 b2
ON a.id=b2.id;
--[2] �� ����� ����.     
SELECT id, name, addr, c2.tel, hobby--tel �ݵ�� ��Ī ���
FROM (select a.id, name, addr, tel
      from A a JOIN B2 b2
      ON a.id=b2.id) ab2 JOIN C2 c2
ON ab2.tel=c2.tel;
--[3] outer join �̿��Ͽ� ǥ�õ��� ���� �κе� �� ǥ���ϱ�
select a.id, b2.id, name, addr, tel--a.id(10 20), b2.id(10 30)�� ����� �ٸ���.
from A a FULL OUTER JOIN B2 b2--�� ���̺� ǥ�õ��� ���� �κ� �� ǥ�õ�
ON a.id=b2.id;--�ڡ��ߺ����ž���

SELECT ab2.id, name, addr, c2.tel, hobby--(�����߻�)ab2.id�� a.id, b2.id 2�� �� ��� ������ ���оȵ�
FROM (select a.id, b2.id,name, addr, tel
     from A a FULL OUTER JOIN B2 b2
     ON a.id=b2.id) ab2 FULL OUTER JOIN C2 c2
ON ab2.tel=c2.tel;

--[���-4]
select *
from A JOIN B
USING(id);--�����߻� : USING(���� �÷���) id�� id2�� �̸��� �޶� ���ξȵ�
--[1]
select id, name, addr, tel
from A JOIN B2 --�ڡ��ߺ������ϹǷ� ��Ī �ʿ����
USING(id);
--[2] �� ����� ����.
select id, name, addr, tel, hobby--tel�� ��Ī ���Ұ�
from (select id, name, addr, tel--id�� ��Ī ���Ұ�
     from A JOIN B2 --�ߺ������ϹǷ� ��Ī �ʿ����
     USING(id)) JOIN C2
USING(tel);
--�� [����]�� ����� �߰��� ������ ��� ǥ���ϴ� ���-2 :[���-4]�� outer join �̿�
--[3]
select id, name, addr, tel--id(10 20 30)
from A FULL OUTER JOIN B2 --�ڡ��ߺ������ϹǷ� ��Ī �ʿ����
USING(id);--�ڡ��ߺ������ϹǷ� �ϳ��� id �÷������� ������ 

select id, name, addr, tel, hobby
from (select id, name, addr, tel
	 from A FULL OUTER JOIN B2 --�ڡ��ߺ������ϹǷ� ��Ī �ʿ����
	 USING(id)) FULL OUTER JOIN C2
USING(tel);

--�� ������� 'id�� ���� ��� ����'�Ͽ� ���
select id, name, addr, tel, hobby
from (select id, name, addr, tel
	 from A FULL OUTER JOIN B2 --�ڡ��ߺ������ϹǷ� ��Ī �ʿ����
	 USING(id)) FULL OUTER JOIN C2
USING(tel)
WHERE id is not null;

--�� [����]�� ����� �߰��� ������ ��� ǥ���ϴ� ���-3 :[���-1] , where => ��� ���� ����(����? (+)�� ���ʿ� ����� �� ����.)
--[1]
select a.id, name, addr, tel
from A a , B2 b2
WHERE a.id=b2.id;
--[2] �� ����� ����.     
SELECT id, name, addr, c2.tel, hobby--tel �ݵ�� ��Ī ���
FROM (select a.id, name, addr, tel
      from A a , B2 b2
      WHERE a.id=b2.id) ab2 , C2 c2
WHERE ab2.tel=c2.tel;

--[3] (+) �̿��Ͽ� ǥ�õ��� ���� �κе� �� ǥ���ϱ�=>�ȵ�
select a.id, b2.id, name, addr, tel--a.id(10 20), b2.id(10)
from A a, B2 b2
WHERE b2.id(+)=a.id;--(+)���� �� ���̺��� ��� �κ� �� ǥ�õ�

select a.id, b2.id, name, addr, tel--a.id(10), b2.id(10 30)
from A a, B2 b2
WHERE a.id(+)=b2.id;--(+)���� �� ���̺��� ��� �κ� �� ǥ�õ�

select a.id, b2.id, name, addr, tel--����
from A a, B2 b2
WHERE a.id(+)=b2.id(+);--�ڡڡ����� : ���� �ȵ�(����)=>����, full outer join~on �Ǵ� using���� �ذ��ؾ� ��

SELECT id, name, addr, c2.tel, hobby--id:�����߻�(ab2�� id�� 2���̹Ƿ�)
FROM (select a.id, b2.id, name, addr, tel--a.id(10), b2.id(10 30)
     from A a, B2 b2
     WHERE a.id(+)=b2.id) ab2 , C2 c2
WHERE ab2.tel(+)=c2.tel;

--[���� ����] : ���̵�(id)�� �����ϴ� ���� ��� ǥ�� => (+)�̿��Ͽ� �����ذ���� -> full outer join~on �Ǵ� using���� �ذ��ؾ� ��
select a.id, b.id, name, addr, tel
from A a, B2 b2--�ڡڡ����� : ���� �ȵ�(����)
WHERE a.id(+)=b2.id(+);--10 20(A) 10 30(B2)

----[�׽�Ʈ ���� �����ϰ� ���̺� �����Ͽ� 4���� ��� �� ��]-----------------------------------------------------------------------


-----------------------------[���-3] : �÷����� �ٸ��� cross join ����� ����
-----------------------------[���-4] : �÷����� �ٸ��� join �ȵ�(���� �߻�)

--[���-3 : natural join]
--���ΰ���� �ߺ��� �÷� ����

--"�ڵ�����" ������ �̸��� ������ ������ ���� �÷����� ����(�ڴ�, 1���� ���� �� ����ϴ� ���� ����)
--������ �̸��� ������ ������ ���� �÷��� ������ CROSS JOIN�� ��
--�ڡ� �ڵ����� ������ �ǳ� ������ �߻��� �� �ִ�.
-----> ���� �߻��ϴ� ���� ? (��)EMPLOYEE�� dno��  DEPARTMENT�� dno : ������ �̸�(dno)�� ������ ����(number(2))
--                                                       (�� �� ���̺��� dno�� �μ���ȣ�� �ǹ̵� ����.)
--                    ����, EMPLOYEE�� manager_id(�� ����� '���'�� �ǹ��ϴ� ��ȣ)�� �ְ�
--                       DEPARTMENT�� manager_id(�� �μ��� '����'�� �ǹ��ϴ� ��ȣ)�� �ִٰ� �������� ��
--                       �� �� ������ �̸��� ������ ������ �������� manager_id�� �ǹ̰� �ٸ��ٸ� ������ �ʴ� ����� ���� �� �ִ�.

select �÷���1, �÷���2...
from ���̺�1 NATURAL JOIN ���̺�2--��Ī ������(����)
--���������� �ʿ����
where �ڰ˻�����

--[�����ذ�]
select eno, ename, e.dno, dname--dno�� �ߺ� ���������Ƿ� e.dno d.dno ��Ī���=>[����]
from EMPLOYEE e NATURAL JOIN DEPARTMENT d--��Ī ������� �����߻�����
WHERE eno = 7788;

select e.eno, e.ename, dno, d.dname--dno�� ��Ī ���ȵ�
from EMPLOYEE e NATURAL JOIN DEPARTMENT d
WHERE e.eno = 7788;

select eno, ename, dno, dname
from EMPLOYEE NATURAL JOIN DEPARTMENT
WHERE eno = 7788;

--[���-4 : join~using(�ڹݵ�� '������ �÷���'�� ����)] �ڴٸ��� �����߻�
--���ΰ���� �ߺ��� �÷� ���� -> ������ �����  FULL outer join~using(id)�ϸ� �ϳ��� id�� ������
--������ �̸��� ������ ���� �÷����� ����(������ �� 1�� �̻� ����� �� ��:�������� ���Ƽ�...)

select �÷���1, �÷���2...
from ���̺�1 JOIN ���̺�2--��Ī ������(����)
USING(����������)--USING(������ �÷���1, ������ �÷���2)
where �ڰ˻�����

--[�����ذ�]
select eno, ename, d.dno, dname--d.dno:��Ī����ϸ� �����߻�
from EMPLOYEE e JOIN DEPARTMENT d
USING(dno)
WHERE eno = 7788;

select eno, ename, dno, dname--dno:��Ī����ϸ� �����߻��Ͽ� ��Ī����
from EMPLOYEE e JOIN DEPARTMENT d
USING(dno)
WHERE eno = 7788;

--�ڡڸ��� manager�� DEPARTMENT�� �ִٰ� ���� �� �Ʒ� ��� ����
select eno, e.manager, dno, d.manager_id--��Ī ����Ͽ� �����ؾ���
from EMPLOYEE e JOIN DEPARTMENT d--manager_id�� ����Ϸ��� �ݵ�� ��Ī ���
USING(dno)--dno�� �ߺ�����(��manager�� �ߺ����ž���)
WHERE eno = 7788;

--�ؿ��� ���̺� �� ������ ��� natural join�� join~using�� �̿��� ���� ��� ��� �����ϳ�
--�������� ���� join~using�� �̿��ϴ� ����� ���Ѵ�.
-----------------------------[���-3] : �÷����� �ٸ��� cross join ����� ����
-----------------------------[���-4] : �÷����� �ٸ��� join �ȵ�(���� �߻�)

---------------------------<4���� ���� ��>------------------------------

--3.non-equi join=������ : �������ǿ��� '=(����)������ �̿�'�� �����ڸ� ����� ��
--						   (��) !=, >, <, >=, <=, between~and

--[����] ������� '����̸�, �޿�, �޿����' ���
--[1] �޿���� ���̺� ���
select * from salgrade;
select * from employee;
--[2]. ������� '����̸�, �޿�, �޿����' ���
--����̸�, �޿�:������̺�,	  �޿����:�޿����� ���̺�
select ename, salary, grade
from employee JOIN salgrade--��Ī������(����?�ߺ��Ǵ� �÷��� �����Ƿ�)
ON salary between losal and hisal;--�� ��������

--[����] ������� '����̸�, �޿�, �޿����' ��� + �߰�����: �޿��� 1000�̸��̰ų� 2000�ʰ�
--[���-2] ���
select ename, salary, grade
from employee JOIN salgrade--��Ī������(����?�ߺ��Ǵ� �÷��� �����Ƿ�)
ON losal <= salary and salary <= hisal--�� ��������
where salary < 1000 or salary > 2000;--[�˻�����] �߰�

--[���-1] ��� : ��Ȯ�� ����� �ȳ���
--����: AND�� OR �Բ� ������ AND ������ OR ����
--=> �ذ�� : ()��ȣ �̿��Ͽ� �켱���� ����
select ename, salary, grade
from employee , salgrade--��Ī������(����?�ߺ��Ǵ� �÷��� �����Ƿ�)
where losal <= salary and salary <= hisal--�� ��������
AND salary < 1000 or salary > 2000;--[�˻�����] �߰�

--�� ���� �ذ��� SQL��
select ename, salary, grade
from employee , salgrade--��Ī������(����?�ߺ��Ǵ� �÷��� �����Ƿ�)
where losal <= salary and salary <= hisal--�� ��������
AND (salary < 1000 or salary > 2000);--[�˻�����] �߰�

--[����] 3���� ���̺� �����ϱ�
--'����̸�, �Ҽӵ� �μ���ȣ, �Ҽӵ� �μ���, �޿�, �� ���'���� ��ȸ
--����̸�/�޿�/�Ҽӵ� �μ���ȣ:��� ���̺�, �Ҽӵ� �μ���ȣ/�Ҽӵ� �μ���:�μ����̺�, �� ���:�޿����� ���̺�
--������̺�� �μ����̺��� ������ �÷��� �ִ�. (�Ҽӵ� �μ���ȣ : dno)
--[1]. ������̺�� �μ����̺��� '�����'
--[���-1]
select ename, e.dno, dname, salary
from employee e, department d--��Ī ���
where e.dno=d.dno;
--[���-2]
select ename, e.dno, dname, salary
from employee e JOIN department d--��Ī ���
ON e.dno=d.dno;

--[2]. ������� ��� ���̺�� �޿����� ���̺��� '������'
select ename, dno, dname, salary, grade--d.dno ��Ī��� �ȵ�
from salgrade JOIN (select ename, e.dno, dname, salary
					from employee e JOIN department d--��Ī ���
					ON e.dno=d.dno)
ON salary BETWEEN losal AND hisal;--������

----------------------------------------------------------------

--4. self join : �ϳ��� ���̺� �ִ� �÷����� �����ؾ� �ϴ� ������ �ʿ��� ���
select * from employee;

--[����] ����̸��� ���ӻ���̸� ��ȸ
select *
from employee e JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno--'KING'�� ���ӻ���� NULL�̹Ƿ� ����ο��� ���ܵ�
order by 1;

select e.ename as "��� �̸�", m.ename as "���ӻ���̸�"
from employee e JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno--'KING'�� ���ӻ���� NULL�̹Ƿ� ����ο��� ���ܵ�
order by 1;

select e.ename || '�� ���ӻ����' || m.ename
from employee e JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno--'KING'�� ���ӻ���� NULL�̹Ƿ� ����ο��� ���ܵ�
order by 1;

--'SCOTT'�� ����� '�Ŵ��� �̸�(=���ӻ���̸�)'�� �˻�
select e.ename || '�� ���ӻ����' || m.ename
from employee e JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno--'KING'�� ���ӻ���� NULL�̹Ƿ� ����ο��� ���ܵ�
where LOWER(e.ename)='scott';
--e.ename�� ���� �ϳ��ϳ� �ҹ��ڷ� ���� �� 'scott'�� ���� �� ã��

---------------------------------------------------------

--5. outer join
--equi join(=�����)�� �������ǿ��� ����� �÷��� ���� �� ���̺� �� ��� ���� �÷��̶�
--null�� ����Ǿ� ������ '='�� �񱳰���� ������ �˴ϴ�.
--�׷��� null���� ���� ���� ���� ����� ������� ����
select e.ename || '�� ���ӻ����' || m.ename
from employee e JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno;--��������('KING'�� ���ӻ���� NULL�̹Ƿ� ����ο��� ���ܵ�)

select e.ename || '�� ���ӻ����' || m.ename
from employee e JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno--��������:null�� �񱳿�����(=, !=, >, <=) �� ���� �� ����.
WHERE e.ename='KING';--������ ������ �˻������ ����
--����̸��� 'KING' �˻�

select e.ename || '�� ���ӻ����' || m.ename
from employee e inner JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno
WHERE m.ename='KING';
--���ӻ���̸��� 'KING'�� ����� �̸� 3�� �˻�

--�� ������δ� null�� ǥ���� �� ����.[�Ʒ� ������� �ذ�]
--[���-1] null���� ǥ���ϱ� ���� �ذ��� : �������ǿ��� null���� ����ϴ� ���� (+)
--���� : (+)�� ���ʸ� ��밡��(left/right), �� full �ȵ�
select e.ename || '�� ���ӻ����' || m.ename
from employee e , employee m--�ݵ�� ��Ī ���
WHERE e.manager=m.eno(+);

--[���-2] null���� ǥ���ϱ� ���� �ذ��� : (left/right/full) outer join
select e.ename || '�� ���ӻ����' || NVL(m.ename, ' ����')
from employee e LEFT OUTER JOIN employee m--�ݵ�� ��Ī ���
ON e.manager=m.eno;


--<6�� ���̺� �����ϱ�-ȥ���غ���>-----------------------------

--1.EQUI ������ ����Ͽ� SCOTT ����� �μ���ȣ�� �μ��̸��� ����Ͻÿ�.
select e.dno, dname
from employee e join department d
on e.dno=d.dno
where ename='SCOTT';

--���-1
select e.dno, dname
from employee e, department d
where e.dno=d.dno--��������
and ename='SCOTT';--�˻�����
--and LOWER(ename)='scott';--�˻�����

--2.(INNER) JOIN�� ON �����ڸ� ����Ͽ� ����̸��� �Բ� �� ����� �Ҽӵ� �μ��̸��� �������� ����Ͻÿ�.
select ename, dname, loc
from employee e join department d
on e.dno=d.dno;

--����̸�:��� ���̺�, �μ��̸�/������:�μ����̺�
--[���-2]
select ename, dname, loc
from employee e join department d
on e.dno=d.dno;--��������

--3.(INNER) JOIN�� USING �����ڸ� ����Ͽ� 10�� �μ��� ���ϴ� ��� ��� ������ ���� ���
--(�� ������ ǥ��)�� �μ��� �������� �����Ͽ� ����Ͻÿ�.
select dno, ename, job, dname, loc
from employee e join department d
using (dno)
where dno='10';

--����=job:������̺�, loc:�μ����̺�
--[���-4]
select dno, job, loc
from employee join department--�ߺ�����->��Ī�ʿ����
using (dno)--��������
where dno='10';--�˻�����

--4.NATURAL JOIN�� ����Ͽ� Ŀ�̼��� �޴� ��� ����� �̸�, �μ��̸�, �������� ����Ͻÿ�.
select ename, dname, loc, commission
from employee natural join department
where commission>0;

--����̸�:��� ���̺�, �μ��̸�/������:�μ����̺�
select ename, dname, loc
from employee natural join department--�ڵ� : ���� dno�� ���� �� �ߺ� ����
where commission is not null;

--5.EQUI ���ΰ� WildCard�� ����Ͽ� '�̸��� A�� ����'�� ��� ����� �̸��� �μ��̸��� ����Ͻÿ�.
select ename, dname
from employee e join department d
on e.dno=d.dno
where ename like '%A%';

--[���-4]
select ename, dname
from employee join department
using(dno)
where ename like '%A%';--A__, _A_, __A

--6.NATURAL JOIN�� ����Ͽ� NEW YORK�� �ٹ��ϴ� ��� ����� �̸�, ����, �μ���ȣ, �μ��̸��� ����Ͻÿ�.
select ename, job, dno, dname
from employee natural join department
where loc = 'NEW YORK';

--����� �̸�/����/�μ���ȣ:������̺�, �μ���ȣ/�μ��̸�:�μ����̺�
select ename, job, dno, dname
from employee natural join department
where loc='NEW YORK';
--where lower(loc)='new york';

--7.SELF JOIN�� ����Ͽ� ����� �̸� �� �����ȣ�� ������ �̸� �� ������ ��ȣ�� �Բ� ����Ͻÿ�.
select e.ename, e.eno, m.ename, m.eno
from employee e join employee m
on e.manager=m.eno;

--[���-1]
select e.ename, e.eno, m.ename, m.eno--�ڡڹݵ�� ��Ī
from employee e, employee m
where e.manager = m.eno;--KING ���ܵ�

--8.'7�� ����'+ OUTER JOIN, SELF JOIN�� ����Ͽ� '�����ڰ� ���� ���'�� �����Ͽ� �����ȣ��
--�������� �������� �����Ͽ� ����Ͻÿ�.
select e.ename, e.eno, m.ename, m.eno
from employee e left outer join employee m
on e.manager=m.eno
order by e.eno desc;

--�����ڰ� ���� ��� : 'KING'
--[���-1]
select e.ename, e.eno, m.ename, m.eno--�ڡڹݵ�� ��Ī
from employee e, employee m
where e.manager = m.eno(+)--���ܵ� 'KING'�� ǥ��
order by 2 desc;

--[���-2]
select e.ename, e.eno, m.ename, m.eno
from employee e left outer join employee m
on e.manager=m.eno--���ܵ� 'KING'�� ǥ�� (��� ����� �� ǥ���Ϸ��� ���� ���̺�)
order by 2 desc;

--9.SELF JOIN�� ����Ͽ� ������ ����� �̸�('SCOTT'), �μ���ȣ, ������ ����� ������ �μ����� 
--�ٹ��ϴ� ����̸��� ����Ͻÿ�.
--��, �� ���� ��Ī�� �̸�, �μ���ȣ, ����� �Ͻÿ�.
select e.ename, e.dno, c.ename, c.dno
from employee e join employee c
on e.dno=c.dno
where e.ename='SCOTT' and c.ename!='SCOTT';

--[���-1]
select *
from employee e, employee m
where e.dno = m.dno--�������� : ������ �μ��� ����
order by 1 asc;

select e.ename as "�̸�", e.dno as "�μ���ȣ", c.ename as "����"--�ڡڹݵ�� ��Ī
from employee e, employee c
where e.dno=c.dno--��������
and (e.ename = 'SCOTT' and c.ename != 'SCOTT');--�˻�����

--10.SELF JOIN�� ����Ͽ� WARD ������� �ʰ� �Ի��� ����� �̸��� �Ի����� ����Ͻÿ�.
--(�Ի����� �������� �������� ����)
select c.ename, c.hiredate
from employee e join employee c
on e.hiredate<c.hiredate 
where e.ename='WARD'
order by hiredate;

--[join ���-1]--------------------------------------------
--�ذ��-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m;--cross join : 14*14=196
where e.ename='WARD';--cross join ������� �˻� : 14

select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m--cross join => ���� ������ ����
where e.ename='WARD' and e.hiredate < m.hiredate--�˻�����
order by m.hiredate asc;

--�ذ��-2:������, �������� ���
--[1]. ���� 'WARD'�� �Ի��� ���ϱ�
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select ename, hiredate
from employee
where hiredate > (select hiredate
				 from employee
				 where ename='WARD')
order by 2 asc;

--�ذ��-3
--[1]. ���� 'WARD'�� �Ի��� ���ϱ�
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select c.ename, c.hiredate
from (select hiredate
	 from employee
	 where ename='WARD') e, employee c
where e.hiredate < c.hiredate--�˻�����
order by 2 asc;
--order by c.hiredate asc;

--[���� ���-2]--------------------------------------------
--�ذ��-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e join employee m
on e.ename='WARD';--join ������� �˻� : 14

--�ذ��-1-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e join employee m--cross join => ���� ������ ����
on e.ename='WARD' 
where e.hiredate < m.hiredate--�˻�����
order by m.hiredate asc;

--�ذ��-1-2
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e join employee m--cross join => ���� ������ ����
on e.ename='WARD' and e.hiredate < m.hiredate--��������
order by m.hiredate asc;

--�ذ��-3
--[1]. ���� 'WARD'�� �Ի��� ���ϱ�
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select distinct c.ename, c.hiredate
from employee c join employee e
on c.hiredate > (select hiredate
				from employee
				where ename='WARD')--�˻�����
order by 2 asc;
--order by c.hiredate asc;

--11.SELF JOIN�� ����Ͽ� �����ں��� ���� �Ի��� ��� ����� �̸� �� �Ի����� 
--������ �̸� �� �Ի��ϰ� �Բ� ����Ͻÿ�.(����� �Ի����� �������� ����)
--[���� ���-1]--------------------------------------------
select e.eno, e.ename, e.manager, e.manager, m.eno, m.ename, m.hiredate
from employee e , employee m-- 196�� ���
where e.manager=m.eno-- 13��
and e.hiredate<m.hiredate--6�� ���
order by e.hiredate asc;--3=e.hiredate �� ����

select e.ename AS "����̸�", e.hiredate AS "����Ի���",
		m.ename AS "�������̸�", m.hiredate AS "�������Ի���"
from employee e , employee m-- 196�� ���
where e.manager=m.eno-- 13��
and e.hiredate<m.hiredate--6�� ���
order by e.hiredate asc;--3=e.hiredate �� ����

--[���� ���-2]--------------------------------------------
select e.ename AS "����̸�", e.hiredate AS "����Ի���",
		m.ename AS "�������̸�", m.hiredate AS "�������Ի���"
from employee e join employee m-- 196�� ���
on e.manager=m.eno-- 13��
where e.hiredate<m.hiredate--6�� ���
order by e.hiredate asc;--3=e.hiredate �� ����
