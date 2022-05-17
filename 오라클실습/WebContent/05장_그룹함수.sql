--<�Ͻ�-05��_�׷��Լ�> : �ϳ� �̻��� ���� �׷����� ���� �����Ͽ� ����, ��� �� ����� ����

--�ڡ����� : count(*) �Լ��� ������ ��� �׷��Լ����� null���� ����
--������� �޿� �Ѿ�, �޿���վ�, �޿��ְ��, �޿������� ���
select
sum(salary),
avg(salary),
--trunc(avg(salary)),--����
max(salary),
min(salary)
from employee;
��ü ������̺��� ����̸� group by������

--��max(), min()�Լ��� ���ڵ����� �̿��� �ٸ� '��� ������ ����'�� ��밡��
--�ֱٿ� �Ի��� ����� ���� �������� �Ի��� ����� �Ի����� ���
select 
max(hiredate) as �ֱٻ��, 
min(hiredate) as "���� �� ���"--��Ī�� �ʹ� �� ���� �߻��Ե�
from employee;

--1.1 �׷��Լ��� null��(P145)
--������� Ŀ�̼� �Ѿ� ���
select
sum(commission) as "Ŀ�̼� �Ѿ�"
from employee;
--null���� ����ȯ ����� ��� null�� ��������
--��count(*)�Լ��� ������ ��� �׷��Լ����� null���� ����

--1.2 �� ������ ���ϴ� count�Լ�
--count(*|�÷���|distinct �÷���|(all) �÷���) : �� ����(|�� '�Ǵ�'�� �ǹ�)

--�׷��Լ� �� count(*)�� null�����Ͽ� �� ����
--��ü �����
select count(*) as "��ü ���� ���� ��"
from employee;

--Ŀ�̼��� �޴� �����
--[���-1]
select count(*) as "Ŀ�̼��� �޴� �����"
from employee
WHERE commission is not null;

--[���-2] count(�÷���) : null����
select count(commission) as "Ŀ�̼��� �޴� ���� ��"
from employee;

--����(job)�� � ����?
select job
from employee;

select distinct job--distinct : �ߺ� ����
from employee;

--����(job)�� ���� : all
select count(job), count(all job) as "all�� �۾���"
from employee;--14 14

select count(commission), count(all commission) as "all�� Ŀ�̼Ǽ�", count(*)
from employee;--4 4 14

--����(job)�� ���� : distinct(�ߺ� ����)
select count(job), count(distinct job) as "�ߺ������� �۾���"
from employee;--14 5

--�ڡڡڡڡڡڡڡڡ�1-3.�׷��Լ��� �ܼ��÷��ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
select ename, max(salary)--��:1
from EMPLOYEE;
--����? �׷��Լ��� ������� 1���ε�,
--�׷��Լ��� �������� ���� �÷��� �ܷΰ��� ���� �� ���� �� �����Ƿ�
--��ġ��ų �� ���� ������ �����߻�

--2.������ �׷�:GROUP BY-Ư�� �÷��� �������� �׷캰�� ������ �� ���
--��group by�� �ڿ� ��Ī ��� ����. �ݵ�� �÷��� ���

--�Ҽ� �μ����� ��ձ޿��� �μ���ȣ�� �Բ� ���(�μ���ȣ�� �������� �������� ����)
select dno, avg(salary)--4 : 4
from employee
group by dno--10 20 30 40 
order by 1;--order by dno asc;

select avg(salary)--�μ���ȣ�� ������ ����� ���ǹ���
from employee
group by dno;

--����?group by���� ������� ���� �÷��� select���� ����ϸ� ����(������ �޶� ��ġ�� �Ұ����ϹǷ�)
select dno, ename, avg(salary)--4 : 14 : 4
from employee
group by dno;--10 20 30 40

select dno, ename, avg(salary)--14 : 14
from employee
group by dno, ename;--14

select dno, job, count(*), sum(salary), avg(salary)
from employee
group by dno, job
order by dno asc, job asc;
--group by���� ���� �μ���ȣ�� �������� �׷�ȭ�� ����
--�ش� �μ� ��ȣ �׷쳻���� ������ �������� �ٽ� �׷�ȭ

--3.�׷� ��� ���� : having�� (P152)
--�׷� �Լ��� ��� �� having�� ������ ������ ���ǿ� true�� �׷����� ��� ����

--'�μ��� �޿��Ѿ��� 9000�̻�'�� �μ��� �μ���ȭ�� �μ��� �޿��Ѿ� ���ϱ�(�μ���ȣ�� �������� ����)
select dno, sum(salary)
from employee
--where sum(salary) >= 9000--where ����=>�����߻�? �׷��Լ��� ������ having����
group by dno
having sum(salary) >= 9000--�׷��Լ��� ����
order by 1 asc;--����

--'MANAGER�� ����'�ϰ� �޿��Ѿ��� 5000�̻��� ���޺� ���� �޿��Ѿ� ���ϱ�(�޿��Ѿ��� �������� �������� ����)
--[1]. ���޺� �޿��Ѿ� ���ϱ�
select job, count(*), sum(salary)
from employee
group by job;

--[2]. 'MANAGER�� ����'�ϱ�--[���-1]
select job, count(*), sum(salary)
from employee
where job != 'MANAGER'--  !=  ^=  <>
group by job;

--[2]. 'MANAGER�� ����'�ϱ�--[���-2]
select job, count(*), sum(salary)
from employee
where job not like 'MANAGER'
group by job;

--[3]. �޿��Ѿ��� 5000�̻�--[���-1]
select job, count(*), sum(salary)
from employee
where job != 'MANAGER'
group by job
having sum(salary) >= 5000;

--[3]. �޿��Ѿ��� 5000�̻�--[���-2]
select job, count(*), sum(salary) as "�޿� �Ѿ�"
from employee
where job not like 'MANAGER'
group by job
having sum(salary) >= 5000
--order by sum(salary) desc;
--order by 3 desc;
order by  "�޿� �Ѿ�" desc;--��Ī���� ���� ����

--�ڡڱ׷��Լ��� 2������ ��ø�ؼ� ��밡��
--���޺� �޿������ �ְ��� ���
--[1] ���޺� �޿���� ���ϱ�
select dno, avg(salary)
from EMPLOYEE
group by dno;

--[2] ���޺� �޿������ �ְ��� ���
select dno, MAX(avg(salary))
from EMPLOYEE
group by dno;
--�����߻�(����?dno 4����, MAX(avg(salary) 1���̹Ƿ� ��ġ�Ұ�)

--�����ذ�
select MAX(avg(salary))
from employee
group by dno;

--�ڡ�dno ���� ����ϰ� �ʹٸ�(�������� ���)
--[1] �μ��� ��� ���ϱ�
select dno, avg(salary)
from EMPLOYEE
group by dno;

--[2] '�μ��� ����� �޿������ �ְ��� ���� ��'(����) ���ϱ�
select dno, avg(salary)
from EMPLOYEE
group by dno
having avg(salary) = (select MAX(avg(salary))
					 from EMPLOYEE
					 group by dno);
					 
select dno, avg(salary)
from EMPLOYEE
group by dno
having avg(salary) IN (select MAX(avg(salary))
					 from EMPLOYEE
					 group by dno);

-----[���翡 ���� ��]-----------------------------------
--�ڡ�rank() : ���� ���ϱ�
--�޿� ���� 3�� ��ȸ - rank() �Լ� ���
--(���� �޿��� ���ٸ� Ŀ�̼��� ���� ������ ��ȸ, Ŀ�̼��� ���ٸ� ������� ���ĺ� ������ ��ȸ)

select ename, salary, commission
from EMPLOYEE;
--�Ʒ� sql������ �ذ� ����
select ename, salary, commission
from EMPLOYEE
where rownum <= 3--��ü �� ������ 3�ٸ� ������
order by salary desc, 3 desc;--3=>commission--��ȸ�� �� ����

--[�ذ���]
select ename, salary, commission,
RANK() OVER(order by salary desc) as "�޿� ����-1",--1 2 2 4
DENSE_RANK() OVER(order by salary desc) as "�޿� ����-2",--1 2 2 3
RANK() OVER(order by salary desc, 3 desc, ename asc) as "�޿� ����-3"--1 2 3 4 ������ �ߺ����� �ʵ��� �ϱ� ����
from EMPLOYEE;

--'�μ�'�׷� �� '�μ� �ȿ��� �� ���� ���ϱ�' :  partition by + �׷� �÷���
select dno, ename, salary, commission,
RANK() OVER(partition by dno order by salary desc, 3 desc, ename asc) as "�μ��� �޿� ����"--������ �ߺ����� �ʵ��� ó����--��Ƽ������ �׷� �з��ѵ� ���� �ű��
from employee;


--[����-2]�׷� �� �ּҰ�, �ִ밪 ���ϱ�

--�μ��׷� �� �ּҰ�, �ִ밪 ���ϱ�
--keep ()�Լ��� FIRST, LASTŰ���带 Ȱ���ϸ� �׷� ���� �ּҰ�, �ִ밪�� ���� ���� �� �ִ�.
--DENSE_RANK�Լ��� ��밡���ϴ�.
select max(salary), min(salary)--�� 1���� ����� ����
from employee;--��ü ������̺� �ּҰ� �ִ밪�� �� �ϳ��̹Ƿ�

--dno, ename, salary�� �׷��� ����� �����ϸ� ���� 1���� ���� �޿��� �ٷ� �ּ����� �ִ�޿�
select dno, ename, salary,
MIN(salary),--�׷��Լ�
MAX(salary)
from employee
GROUP BY dno, ename, salary;--�׷�:�μ� ����� �޿�

--[�ذ���-1]
select dno, -- ename, salary, �߰��ϸ� ���� �߻�(1:n �����̹Ƿ�)
MIN(salary) as "�μ��� �ּ� �޿�",--�׷��Լ�
MAX(salary) as "�μ��� �ִ� �޿�"
from employee
GROUP BY dno--�׷� : �μ�(�� �μ��� 1������ ���)
order by dno;

--�� ����� ename, salary�� ����� �� ����.(1:�� �����̹Ƿ�)
--[�ذ���-2]
select dno, ename, salary,
MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "�μ��� �ּ� �޿�",
MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "�μ��� �ִ� �޿�"
from employee
order by dno asc;

--[����-3]�׷� �� �ּҰ�, �ִ밪 ���ϱ�+ ��ü�޿� ���� ���ϱ�(���� �޿��� ���� ��� ex. 1 2 2 4)
select dno, ename, salary,
MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "�μ��� �ּ� �޿�",
MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "�μ��� �ִ� �޿�",
RANK() OVER(order by salary desc) as "�޿� ����-1"--1 2 2 4
from employee
order by dno asc;

--<5�� �׷��Լ�-ȥ���غ���>-----------------------------

--1.��� ����� �޿� �ְ��, ������, �Ѿ� �� ��� �޿��� ����Ͻÿ�.
--�÷��� ��Ī�� ��� ȭ��� �����ϰ� �����ϰ� ��տ� ���ؼ��� ������ �ݿø��Ͻÿ�.
select 
max(salary) as "�޿� �ְ��",
min(salary) as "�޿� ������",
sum(salary) as "�޿� �Ѿ�",
round(avg(salary)) as "��� �޿�"--�Ҽ� ù° �ڸ����� �ݿø��Ͽ� ������ ���
from employee;

--2.�� ��� ���� �������� �޿� �ְ��, ������, �Ѿ� �� ��վ��� ����Ͻÿ�.
--�÷��� ��Ī�� ��� ȭ��� �����ϰ� �����ϰ� ��տ� ���ؼ��� ������ �ݿø��Ͻÿ�.
select job, --�߰��Ͽ� ����� ���ǹ������� �ʵ��� ��
max(salary) as "�޿� �ְ��",
min(salary) as "�޿� ������",
sum(salary) as "�޿� �Ѿ�",
round(avg(salary)) as "��� �޿�"
from employee
group by job;

--3.count(*)�Լ��� �̿��Ͽ� ��� ������ ������ ��� ���� ����Ͻÿ�.
select job as "��� ����", count(*) as "��� ��"
from employee
group by job;

--4.������(=manager : �÷���)��(count())�� �����Ͻÿ�. 
--�÷��� ��Ī�� ��� ȭ��� �����ϰ� �����Ͻÿ�.
--count(�÷���) : �� ����( null����)
select count(manager) as "������ ��"
from employee;

--'MANAGER'�� �� ?
select job, count(*) as "��� ��" --1:1
from employee
where job='MANAGER'--'MANAGER'('�빮��'�� �Է�)
group by job;

--�μ��� 'MANAGER'�� ��?
select dno, count(*) as "��� ��" --1:1
from employee
where job='MANAGER'
group by dno;

--5.�޿� �ְ��, �޿� �������� ������ ����Ͻÿ�. 
--�÷��� ��Ī�� ��� ȭ��� �����ϰ� �����Ͻÿ�. 
select 
max(salary) as "�޿� �ְ��",
min(salary) as "�޿� ������",
max(salary) - min(salary) as "�޿� ����"
from employee;

--6.���޺� ����� ���� �޿��� ����Ͻÿ�. 
--'�����ڸ� �� �� ���� ���' �� '���� �޿��� 2000 �̸�'�� �׷��� '����'��Ű�� 
--����� �޿��� ���� ������������ �����Ͽ� ����Ͻÿ�. 
[1]
select job, min(salary) as "���� �޿�"
from employee
group by job;
--[2]where+'�����ڸ� �� �� ���� ���(=null)' �� having+'���� �޿��� 2000 �̸�'�� �׷��� '����'
--���-1
select job, min(salary) as "���� �޿�"
from employee
where manager is not null
group by job
having min(salary)>=2000--�׷��Լ� ����
order by 2 desc;

--���-2
select job, min(salary) as "���� �޿�"
from employee
where manager is not null
group by job
having not min(salary)<2000--�׷��Լ� ����
order by "���� �޿�" desc;

--7.�� �μ��� ���� �μ���ȣ, �����, �μ� ���� ��� ����� ��� �޿��� ����Ͻÿ�. 
--�÷��� ��Ī�� ��� ȭ��� �����ϰ� �����ϰ� ��� �޿��� �Ҽ��� ��° �ڸ��� �ݿø��Ͻÿ�. 
select dno, count(eno) as "�� �μ��� �����", 
round(avg(salary),2) as "��� �޿�"
from employee
group by dno;

--�ڡ�7�� ������ �߰�(�ڴ�, ���̺��� ��ȸ�ϱ� ���� salary�� null���θ� �� ���¿��� ��ȸ�Ѵٸ�)
--��� avg(salary)�� null�����ϰ� ��� ����. 
--�׷��� null�� �޿��� �޴� ����� �ִٸ� �� ����� �����ϰ� ����� ����
--�׷��� null�� �޿��� �޴� ����� �Բ� ���Խ��� ����� ����Ϸ��� 
--�ݵ�� nulló���Լ� ����Ͽ� ��ü���� ������ ����
select dno, count(eno) as "�� �μ��� �����", 
round(avg(NVL(salary,0)),2) as "��� �޿�"
from employee
group by dno;

--[�߰�����]'Ŀ�̼��� �޴� ����鸸�� Ŀ�̼� ���'�� '��ü ����� Ŀ�̼� ���' ���ϱ�
select 
avg(commission) as "Ŀ�̼�o-Ŀ�̼� ���", 
avg(nvl(commission,0)) as "��ü Ŀ�̼� ���"
from EMPLOYEE;

--8.�� �μ��� ���� �μ���ȣ �̸�, ������, �����, �μ����� ��� ����� ��� �޿��� ����Ͻÿ�. 
--�÷��� ��Ī�� ��� ȭ��� �����ϰ� �����ϰ� ��� �޿��� ������ �ݿø��Ͻÿ�.
select dno,
decode(dno,10,'ACCOUNTING',
		   20,'RESEARCH',
		   30,'SALES',
		   40,'OPERATIONS') AS "�μ��̸�",
decode(dno,10,'NEW YORK',
		   20,'DALLAS',
		   30,'CHICAGO',
		   40,'BOSTON') AS "������",
sum(salary) as "�μ��� �޿� �Ѿ�",
count(*) as "�μ��� �����", 
round(avg(salary)) as "�μ��� ��ձ޿�-1",--null �޿��޴� �������
round(avg(nvl(salary, 0))) as "�μ��� ��ձ޿�-2"--null �޿��޴� ��� ����
from employee
group by dno
order by 1;

--join�̿��� ���-1 : ~where ��Ī ���  
select d.dno, dname as "�μ��̸�", loc as "������",
sum(salary) as "�μ��� �޿� �Ѿ�",
count(*) as "�μ��� �����", 
round(avg(salary)) as "�μ��� ��ձ޿�-1",--null �޿��޴� �������
round(avg(nvl(salary, 0))) as "�μ��� ��ձ޿�-2"--null �޿��޴� ��� ����
from employee e , department d
where e.dno=d.dno--��������
group by d.dno, dname, loc
order by 1;

--join�̿��� ���-2 : join~on ��Ī ���
select e.dno, dname as "�μ��̸�", loc as "������",
sum(salary) as "�μ��� �޿� �Ѿ�",
count(*) as "�μ��� �����", 
round(avg(salary)) as "�μ��� ��ձ޿�-1",--null �޿��޴� �������
round(avg(nvl(salary, 0))) as "�μ��� ��ձ޿�-2"--null �޿��޴� ��� ����
from employee e join department d
on e.dno=d.dno--��������
group by e.dno, dname, loc
order by 1;

--join�̿��� ���-3 : natural join�� �ߺ��÷� ����(dno 1�� ����) ��Ī ������.
select dno, dname as "�μ��̸�", loc as "������",
sum(salary) as "�μ��� �޿� �Ѿ�",
count(*) as "�μ��� �����", 
round(avg(salary)) as "�μ��� ��ձ޿�-1",--null �޿��޴� �������
round(avg(nvl(salary, 0))) as "�μ��� ��ձ޿�-2"--null �޿��޴� ��� ����
from employee natural join department
group by dno, dname, loc
order by 1;

--9.������ ǥ���� ���� �ش� ������ ���� �μ���ȣ�� �޿� �� �μ� 10, 20, 30�� �޿� �Ѿ��� ���� ����Ͻÿ�.
--�� �÷��� ��Ī�� ���� job, �μ� 10, �μ� 20, �μ� 30, �Ѿ����� �����Ͻÿ�.
select job, dno,
decode(dno, 10, sum(salary), 0) as "�μ�10",
decode(dno, 20, sum(salary)) as "�μ�20",
decode(dno, 30, sum(salary)) as "�μ�30",
sum(salary) as "�Ѿ�"
from employee
group by job, dno
order by dno;










