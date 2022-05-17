--<�Ͻ�-07��_��������>

--[����]'SCOTT'���� �޿��� ���� �޴� ����� ������ �޿� ��ȸ
--[1]. �켱 'SCOTT'�� �޿��� �˾ƾ� ��
select salary
from employee
where ename='SCOTT';--3000

--[2]. �ش�޿� 3000���� �޿��� ���� ��� �˻�
select ename, salary
from employee
where salary > 3000;

--[2] �������� -[1] ��������
select ename, salary
from employee
where salary > (select salary
				from employee
				where ename='SCOTT');
				--������������ ������ ���(3000)�� ���������� ���޵Ǿ� ���� ����� ���

--���� �� �������� : ���μ����������� ����� �� '1��'
--			      ������ �񱳿�����(>,=,>=,<=), IN������
--			   (��) salary>3000		salary=3000�� salary IN(3000)�� ���� ǥ��
--���� �� �������� : ���μ����������� ����� �� '1�� �̻�'
--			      ������ �񱳿�����(IN, any, some, all, exists)
--			   (��) salary IN(1000, 2000, 3000)

--1. ���� �� ��������
--[����] 'SCOTT'�� ������ �μ����� �ٹ��ϴ� ����̸�, �μ���ȣ ��ȸ
select ename, dno
from employee
where dno = (select dno
			 from employee
			 where ename='SCOTT');--�������� ��� : 1��
			 
select ename, dno
from employee
where dno IN (select dno
			 from employee
			 where ename='SCOTT');--�������� ��� : �������� ����

--�� ������� 'SCOTT'�� �Բ� ��ȸ��. 'SCOTT'�� �����ϰ� ��ȸ�Ϸ���
select ename, dno
from employee
where dno = (select dno
			 from employee
			 where ename='SCOTT')
AND ename != 'SCOTT';--���� �߰�

select ename, dno
from employee
where dno = 20
AND ename != 'SCOTT';--���� �߰�

--[����] ȸ�� ��ü���� �ּ� �޿��� �޴� ������̸�, ������(JOB), �޿� ��ȸ
--[1] �ּұ޿� ���ϱ�
select MIN(salary)
from employee;--800
--[2] ���� �ּұ޿�(800)�� �޴� ������̸�, ������(JOB), �޿� ��ȸ
select ename, job, salary
from employee
where salary = (select MIN(salary)
				from employee);--800�� ���� -- �������� ��� 1��
--where salary = 800;
				
select ename, job, salary
from employee
where salary in (select MIN(salary)
				from employee);
--where salary IN(800);

--2. ���� �� ��������
--1) IN ������: ���������� �����ǿ��� ���������� ��°���� '�ϳ��� ��ġ�ϸ�' 
--      		���������� where ����  true
--�ڴ��� �Ǵ� ���� �� ���������� �� �� ��� ������

--[����] �ڡڡ�"�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
--[���-1]
--[1] "�μ��� �ּұ޿�"���ϱ�(dno���� ǥ��)
select MIN(salary)
from employee
group by dno;--���������� �� ����� ���ǹ��ϴ�.

--[2] �ڡڡ�'�μ��� �ּұ޿�'�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
select dno, eno, ename, salary
from employee
where (dno, salary) in (select dno, MIN(salary)--IN(1300, 800, 950)
				  from employee
				  group by dno)
ORDER BY 1;		
				
--[����] "�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
--[���-2]
--[1] "�μ��� �ּұ޿�"���ϱ�(dno���� ǥ��)
select dno, MIN(salary)-- (10, 20, 30)
from employee
group by dno;--(10, 1300),(20, 800),(30, 950) ����� ���ǹ��ϴ� �ؼ� dno ���̱�

--[2-1]�������� �̿�: �ڡڡ�'�μ��� �ּұ޿�'�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
select dno, eno, ename, salary
from employee
where (dno, salary) IN (select dno, MIN(salary)--IN((10, 1300),(20, 800),(30, 950))�� ����� (dno, salary) ��� ������ֱ�
				  from employee
				  group by dno)
ORDER BY 1;		

--[2-2]���ι��-1 �̿�
--[���-1]
select *
from employee e1, (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno--��������
AND e1.salary=e2.minsalary
ORDER BY 1;

--[���-2]
select e1.dno, eno, ename, salary
from employee e1, (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno--��������
AND e1.salary="minsalary"
ORDER BY 1;
--[2-3] ���ι��-2 �̿�
select e1.dno, eno, ename, salary
from employee e1 join (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) e2
on e1.dno = e2.dno--��������
where e1.salary="minsalary"
ORDER BY 1;

--[2-4] ���ι��-3 �̿� (natural join): dno�� �ڿ����� ---> ��Ī �ʿ����.
select dno, eno, ename, salary
from employee natural join (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) 
where salary="minsalary"
ORDER BY dno;

--[2-4] ���ι��-4 �ߺ����� ---> ��Ī �ʿ����.
select dno, eno, ename, salary
from employee join (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) 
USING (dno)					
where salary="minsalary"
ORDER BY dno;

-----------------------------------------------------------------------------

--[�� ���� '���-1'�� �������� 'min(salary) ���' �Ϸ���]
select dno, eno, ename, salary, min(salary)--"�׷��Լ� ���" �Ϸ���
from employee
where (dno, salary) in (select dno, MIN(salary)--IN(1300, 800, 950)
				  from employee
				  group by dno)-- (1300. 800, 950)
group by dno, eno, ename, salary--group by �� �ڿ� �ݵ�� ����� �÷��� ����(�׷��Լ� ����)			  
ORDER BY 1;		

select dno, min(salary)--14:1
from employee;--����? ��ü ������̺��� ����̸� group by������(����:��ü�� �ϳ��� �׷��̹Ƿ�
--�׷��Լ��� ����Ϸ���

--[�� ������ '���-1'�� ������ �����ϱ� ���� �ܰ������� ����]
--���� ���� �� �ܰ�
--�ܰ�-1
select min(salary)--��ü������̺� ����̹Ƿ� 1�׷�:1 
from employee;

--�ܰ�-2
select dno, min(salary)--dno 3�׷� : 3
from employee
group by dno
order by 1;

--�ܰ�-3
select dno, eno, ename, salary, min(salary)--dno 3�׷� : 3
from employee
group by dno, eno, ename, salary
order by 1;

--�ܰ�-4
select dno, eno, ename, salary, min(salary)--dno 3�׷� : 3
from employee
where salary in(1300, 800, 950)--�˻�����
group by dno, eno, ename, salary
order by 1;
--�ܰ�-4�� ���� ���̴�. IN�� ���� ���̸� �ִ�. (�� �� �� ���� ���̴�.)
select dno, eno, ename, salary, min(salary)--"�׷��Լ� ���" �Ϸ���
from employee
where (dno, salary) in (select dno, MIN(salary)--IN(1300, 800, 950)
				  from employee
				  group by dno)-- (1300, 800, 950)
group by dno, eno, ename, salary--group by �� �ڿ� �ݵ�� ����� �÷��� ����(�׷��Լ� ����)			  
ORDER BY 1;		
---------------------------------------------------------------------------------
--2) ANY ������: ���������� ��ȯ�ϴ� ������ ���� ��
--where �÷���       IN(���������� ���1, ���2...)---> ����� �� �ƹ��ų��� ����.
--where �÷��� = any(���������� ���1, ���2...)---> ����� �߿��ƹ��ų��� ����.

--����: A���� OR B����
--where �÷��� < any(���������� ���1, ���2...)---> ����� �� "�ִ밪"���� �۴�.
--where �÷��� > any(���������� ���1, ���2...)---> ����� �� "�ּҰ�"���� �۴�.

--[����] �ڡڡ�"�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
--[2-5] = ANY �̿�
--[1] "�μ��� �ּ� �޿�"���ϱ�
select dno,MIN(salary)
from employee
group by dno;--���������� �� ����� ���ǹ��ϴ�.

--[2] �ڡڡ�'�μ��� �ּұ޿�'�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
select dno, eno, ename, salary
from employee
where (dno, salary) =ANY (select dno, MIN(salary)
				 			 from employee
				 			 group by dno)
ORDER BY 1;		

--����: where(dno, salary) = ANY((10, 1300), (20, 800), (30, 950))
--����: where(dno, salary)    IN((10, 1300), (20, 800), (30, 950))
--���������� ��� �� �ƹ��ų��� ���� ��

--����: where(dno, salary)  not IN((10, 1300), (20, 800), (30, 950))
--����: where(dno, salary)  != ANY((10, 1300), (20, 800), (30, 950))
--����: where(dno, salary) <>= ANY((10, 1300), (20, 800), (30, 950)) 
--����: where(dno, salary)  ^= ANY((10, 1300), (20, 800), (30, 950))
--���������� ��� �� ����͵� �ƴϴ�.

--����: where salary not IN(1300, 800, 950)
--����: where salary  != ANY(1300, 800, 950)
--����: where salary <>= ANY(1300, 800, 950)
--����: where salary ^= ANY(1300, 800, 950)
--���������� ��� �� ����͵� �ƴϴ�.

--����: where salary < any(1300, 800, 950) �������� ��� �߿� '�ִ밪(1300)'���� �۴�.
--����: where salary > any(1300, 800, 950) �������� ��� �߿� '�ּҰ�(800)'���� �۴�.
--(��1)
select eno, ename, salary
from employee
where salary < ANY(1300, 800, 950)
order by 1;
-- 	  salary < ANY(1300, 800, 950)
--    salary < 1300
-- 	  salary < 800
-- 	  salary < 950
-- �ᱹ salary < 1300(�ִ밪)�� ������ ������ ������ �� �����Ѵ�.

--(��2)
select eno, ename, salary
from employee
where salary > ANY(1300, 800, 950)
order by 1;
-- 	  salary > ANY(1300, 800, 950)
--    salary > 1300
-- 	  salary > 800
-- 	  salary > 950
-- �ᱹ salary > 800(�ּҰ�)�� ������ ������ ������ �� �����Ѵ�.

--[12�� 27��]

--[����] ������ SALESMAN�� �ƴϸ鼭
--�޿��� ������ SALSEMAN���� ���� ����� ����(����̸�, ����, �޿�) ���(������=�ּ�)
--[1].������ SALSEMAN�� �޿� ���ϱ�
select DISTINCT salary--��� 1600 1250 1250 1500 �ߺ����� ���� ��
from employee
where job='SALESMAN';--��� 1250 1600 1500

--[2].
select ename, job, salary
from employee
where job!='SALESMAN' AND salary<ANY(select DISTINCT salary
									from employee
									where job='SALESMAN');
							-- salary < ANY(1250, 1600, 1500)�� ����������� �� '�ִ밪'���� �۴�.

--�� ����� ����
--[1]. ������ SALESMAN�� �ִ� �޿� ���ϱ�
select MAX(salary)-- MAX�� �׷��Լ��̴�.--1600
from employee
where job='SALESMAN';

--[2]
select ename, job, salary--��� 1300 1250 1250 1500 �ߺ�����
from employee
where job!='SALESMAN' AND salary<(select MAX(salary)
									from employee
									where job='SALESMAN');
--	job!='SALESMAN'
--	job^='SALESMAN'
--	job<>'SALESMAN'
--	job NOT like='SALESMAN'
-- �� ���� �͵��̴�.
---------------------------------------------------------------------------------

--3) ALL������: ������������ ��ȯ�Ǵ� ��� ���� ��
--����: A���� AND B���� -���������� ���ÿ� ����
--where salary > ALL(���1, ���2,...) ���� ��� �� '�ִ밪'���� ũ��.
--where salary < ALL(���1, ���2,...) ���� ��� �� '�ּҰ�'���� �۴�.

									
--[����] ������ SALESMAN�� �ƴϸ鼭
--�޿��� ��� SALSEMAN���� ���� ����� ����(����̸�, ����, �޿�) ���(���=��� ���ÿ� ����)
--[1].������ SALSEMAN�� �޿� ���ϱ�
select DISTINCT salary--��� 1600 1250 1250 1500 �ߺ����� ���� ��
from employee
where job='SALESMAN';--��� 1250 1600 1500

--[2].
select ename, job, salary
from employee
where job!='SALESMAN' AND salary<ALL(select DISTINCT salary
									from employee
									where job='SALESMAN');
							-- salary < ALL(1250, 1600, 1500)�� ����������� �� '�ּҰ�'���� �۴�.

--�� ����� ����
--[1]. ������ SALESMAN�� �ּ� �޿� ���ϱ�
select MIN(salary)-- MIN�� �׷��Լ��̴�.--1250
from employee
where job='SALESMAN';

--[2]
select ename, job, salary
from employee
where job!='SALESMAN' AND salary<(select MIN(salary)
									from employee
									where job='SALESMAN');--800, 1100, 950	
---------------------------------------------------------------------------------								
--4) EXISTS ������: EXISTS =�����ϴ�.
select 
from 
where EXISTS (��������);-- �÷��� ���� �̷� ����̴�.				
--������������ ������ �����Ͱ� 1���� �����ϸ� 		true ---> ���� ���� ����
--������������ ������ �����Ͱ� 1���� �������� ������ false ---> ���� ���� ���� �Ұ�
				
select 
from 
where NOT EXISTS (��������);-- �÷��� ���� �̷� ����̴�.				
--������������ ������ �����Ͱ� 1���� �������� ������ true ---> ���� ���� ����
--������������ ������ �����Ͱ� 1���� �����ϸ� 		false ---> ���� ���� ���� �Ұ�
				
--[����-1] ������̺��� ������ 'PRESIDENT'�� ������ ��� ����̸��� ���, ������ ��¾���
--�ڹ����� ��: ������ �����ϴ� ����� ������ ���������� �����Ͽ� ����� ���
				
--[1].������̺��� ������ 'PRESIDENT'�� ����� �����ȣ ��ȸ
select eno--7839
from employee
where job='PRESIDENT';

--[2]		
select ename
from employee
where EXISTS (select eno
			  from employee
			  where job='PRESIDENT');--14�� ���	

--�� ������ �׽�Ʈ�ϱ� ���� ������ 'PRESIDENT'�� ��� ���� �� �ٽ� [2] �����غ��� ��� ���� �ȳ��´�.			
delete
from employee
where job='PRESIDENT';-- ���� �� [2] �����ϸ� �ƹ��͵� ����� �ȳ��´�. ������ �ƴϴ�.

--�ٽ� �ǵ������ 1�� ����Ŭ�� �����ͺ��̽����� �����ϱ�

--[�� ������ job='SALESMAN' �߰���]				
--������ AND ����: �� ������ ��� ���̸� ��	
select ename
from employee
where job='SALESMAN'AND EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--4�� ���	
--���: 4�� AND 14�� ---> 4�� 			  					
				
--������ OR ����: �� ������ �ϳ��� ���̸� �� 	
select ename
from employee
where job='SALESMAN'OR EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--14�� ���	
--���: 4�� OR 14�� ---> 14��

			  					--[NOT EXISTS]					
--������ AND ����: �� ������ ��� ���̸� ��	
select ename
from employee
where job='SALESMAN'AND NOT EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--0�� ���	�� �� ���̾�� �ϴµ� �ϳ��� �����̹Ƿ� 0�� ���
--���: 4�� AND 0�� ---> 0��
--������ OR ����: �� ������ �ϳ��� ���̸� �� 	
select ename
from employee
where job='SALESMAN'OR NOT EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--4(=0+4)�� ���	OR�� AND�� ����
--���: 4�� OR 0�� ---> 4��


--[����-1] ������̺��� ������ 'PRESIDENT'�� ������ ��� ����̸��� ���, ������ ��¾���
--�ڹ����� ��: ������ �����ϴ� ����� ������ ���������� �����Ͽ� ����� ���
--[���-1] EXISTS ���
--[1].������̺��� ������ 'PRESIDENT'�� ����� �����ȣ ��ȸ
select eno
from employee
where job='PRESIDENT';--���: 1�� 14�� ���(employee�� row�� ��ŭ)

--[2]		
select ename
from employee
where NOT EXISTS (select eno
			  	  from employee 
			      where job='PRESIDENT');--0�� ���
			  
--[����-1]:������̺�� �μ����̺��� ���ÿ� ���� �μ���ȣ, �μ��̸� ��ȸ	
select 1
from employee;--���: 1�� 14�� ���(employee�� row�� ��ŭ)

--[1]
select dno, dname
from department d
where EXISTS (select dno--dno�� 1�� �ƴ� dno,1�� �ΰ��� ��� ��� �������� ����� �����ϴ�.
                  from employee e
                  where d.dno = e.dno);
--[2]
select dno, dname
from department d
where NOT EXISTS (select dno
                  from employee e
                  where d.dno = e.dno);

select dno, dname
from department --department d�� d�� �־�� �Ѵ�.
where NOT EXISTS (select dno--10 20 30�� NOT�� 40
                  from employee --employee e�� ���������Ѵ�. ��Ī��� ���ص� �ȴ�.
                  where d.dno = e.dno);--e.dno e�� ���������Ѵ�.
 
--[���-2], [���-3]��                 
--EMPLOYEE�� dno�� department�� dno�� references�� �ƴ� ���� �Ͽ���
--��, EMPLOYEE�� dno�� �����ϴ� dno�� �ݵ�� department������ dno�� �����ؾ��Ѵ�. �� ����� �ƴ� �����Ͽ��� ���� Ǯ��                  
--[���-2] MINUS ���  
--[1]
select dno, dname
from department;--10 20 30 40
--[2]
select DISTINCT d.dno, dname
from EMPLOYEE e,department d
where e.dno(+) = d.dno;

--[3] {10 20 30 40} - {10 20 30} = {40}�� ���� �̿�
--�̸��� �޶����� ������ Ÿ���� ���ƾ� �Ѵ�.
select dno, dname
from department

MINUS

select DISTINCT e.dno, dname
from EMPLOYEE e,department d
where e.dno = d.dno;

--[���-3] JOIN ���-1 ���  
--EMPLOYEE�� dno�� department�� dno�� references�� �ƴ� ���� �Ͽ���
--EMPLOYEE�� dno�� �����ϴ� dno�� �ݵ�� department������ dno�� ����
--[1]
select DISTINCT e.dno, dname
from EMPLOYEE e,department d
where e.dno = d.dno;--10 20 30(���ÿ�)

--[2]
select DISTINCT d.dno, dname--e.dno�ϸ� 10 20 30�� ���
from EMPLOYEE e,department d
where e.dno(+) = d.dno;--10 20 30(���ÿ�)+�μ����Ϻ� �ִ� 40���� ��ȸ�ϱ� ���ؼ�

--[3-1]
select DISTINCT d.dno, dname
from EMPLOYEE e,department d
where e.dno(+) = d.dno AND d.dno NOT IN (10, 20, 30);
--[3-2]
select DISTINCT d.dno, dname--DISTINCT ���� ����
from EMPLOYEE e,department d
where e.dno(+) = d.dno AND d.dno NOT IN (select DISTINCT dno from EMPLOYEE);
--[3-3]
select DISTINCT d.dno, dname
from EMPLOYEE e,department d
where e.dno(+) = d.dno AND d.dno != ALL (select DISTINCT dno from EMPLOYEE);

--<7�弭������-ȥ���غ���>-----------------------------

--1.�����ȣ�� 7788�� ����� '�������� ����' ����� ǥ��(����̸��� ������)
--[1]. �����ȣ�� 7788�� ����� ������ ��ȸ
select job
from employee
where eno = 7788;--ANALYST�� ���
--[2-1] 
select ename, job
from employee
where job = (select job-- =�� ���������� 1��
             from employee
             where eno = 7788);
--[2-2]
select ename, job
from employee
where job IN (select job--IN: �������� ��� 1���̻�
             from employee
             where eno = 7788);           
--[2-3]
select ename, job
from employee
where job = ANY (select job--ANY: �������� ��� 1���̻�
             from employee
             where eno = 7788);             
--[2-4]
select ename, job
from employee
where job = ALL (select job--ANY: �������� ��� 1���̻�
             from employee
             where eno = 7788); 
             
--2.�����ȣ�� 7499�� ������� �޿��� ���� ����� ǥ��(����̸��� ������)
--[1]
select salary
from employee
where eno = 7499;--1300
--[2]            
select ename, job
from employee
where salary > (select salary
                from employee
                where eno = 7499);
               
--3.�ּұ޿��� �޴� ����� �̸�, ��� ���� �� �޿� ǥ��(�׷��Լ� ���)
--[1].������̺��� �ּұ޿� ��ȸ
select min(salary)
from employee;--800
--[2]
select ename, job, salary
from employee
where salary = (select min(salary)-- =���  IN, =ANY =ALL ��밡��
                from employee);
              
--4.'���޺�' ��� �޿��� ���� ���� ��� ������ ã�� '����(job)'�� '��� �޿�' ǥ��
--��, ����� �ּұ޿��� �ݿø��Ͽ� �Ҽ�1°�ڸ����� ǥ��
--[���-1]
--[1] '���޺�' ��� �޿� �� ���� ���� ��ձ޿��� ���Ѵ�.
--����, �����ü�� ��ձ޿� ���ϱ�
select avg(salary), ROUND(avg(salary),1)--�Ҽ� �ι�° �ڸ����� �ݿø��Ͽ� �Ҽ� ù��°�ڸ����� ǥ��
from employee;

--�����ü�� ��ձ޿��� �ּҰ� ���ϸ�
select MIN(avg(salary))
from employee;--�����߻�---> avg(salary)�� ��� 1���� ���� MIN(�ּҰ�)�̳� MAX(�ּҰ�)�� ���ϴ� ���� ��ȣ�ϱ� �����̴�.

select job, avg(salary)--5:5
from employee
GROUP BY job;

--job(5):MIN(avg(salary)) = 5:1 ��ġ�� �ȵǼ� ���� �߻��Ѵ�. 
 select job, MIN(avg(salary))
from employee
GROUP BY job;

--[�� ������ �ذ��ϱ� ���� job��ȸ���� ����]
--�ڡ� �׷��Լ��� �ִ� 2�������� ��ø���
--�׷��Լ�: MIN, MAX, AVG
--ROUND�� �׷��Լ��� �ƴϴ�.
--[1]
select MIN(avg(salary)), ROUND(MIN(avg(salary)),1)--1037.5 1037.5
from employee
GROUP BY job;
--[2]
select round(MIN(AVG(salary)),1)--1037.5
from employee
GROUP BY job;
--[����-1]
select job, AVG(salary),round(AVG(salary),1)--��ձ޿�
from employee
GROUP BY job--�ش�Ǵ� �׷��� ���
HAVING round(AVG(salary),1) = (select round(MIN(AVG(salary)),1)
								from employee
								GROUP BY job);

--[���-2]: ��, �۾��� ��� �޿��� �ٸ� ���� ����								
--[1]
select job, avg(salary)
from employee
GROUP BY job
ORDER BY avg(salary) ASC;--����: ���� ���� ��ձ޿��� 1��° �ٿ� ǥ��					
--[2]
select *
from(select job, avg(salary)
		from employee
		GROUP BY job
		ORDER BY avg(salary) ASC)
WHERE rownum =1;-- ����: 1���� �ٸ� ǥ��
--���ϴ� ����� �������� ���� ��ձ޿��� ������ ��� �Ұ���


--[���1]
select job, round(avg(salary),1)
from employee
group by job
having round(avg(salary),1) <= ALL(select round(avg(salary),1)
                          from employee
                          group by job);
--[���2]
select job, round(avg(salary),1)
from employee
group by job
having round(avg(salary),1) = (select round(MIN(avg(salary)),1)
                      from employee
                      group by job);

--5.�� �μ��� �ּ� �޿��� �޴� ����� �̸�, �޿�, �μ� ��ȣ ǥ��
--[���-1]
--[1].�� �μ��� �ּұ޿� ���ϱ�
select dno, MIN(salary)
from employee
group by dno;--����� ������ ����          
--[2]
select ename, salary, dno
from employee
where (dno, salary) IN (select dno, MIN(salary)
						from employee
						group by dno);

--[���-2]
--[1].�μ���  �ּұ޿� ���ϱ�
select MIN(salary)
from employee
group by dno;--950 800 1300                      
--[2]                      
select ename, salary, dno
from employee
where salary IN (select MIN(salary)
						from employee
						group by dno);

--[���1]
select ename, salary, dno
from employee
where salary = ANY(select min(salary)
                   from employee
                   group by dno);
--[���2]
select ename, salary, dno
from employee
where salary IN(select min(salary)
                from employee
                group by dno);

--6.'��� ������ �м���(ANALYST)�� ������� �޿��� �����鼭 ������ �м����� �ƴ�' 
--������� ǥ��(�����ȣ, �̸�, ��� ����, �޿�)
--[1]'��� ������ �м���(ANALYST)�� ������ϱ�
select salary
from employee
where job = 'ANALYST';--(3000, 3000)           
                
--[2]                
select eno, ename, job, salary
from employee
where salary < ANY(select salary
                   from employee
                   where job = 'ANALYST')--salary < ANY (3000, 3000)
	AND job != 'ANALYST';
	--		<>
	-- 		^=
	--		not like

--�ڡ�7.���������� ���� ����̸� ǥ��(���� '���� 8. ���������� �ִ� ����̸� ǥ��'���� Ǯ��)
select * from employee;

--���-1: ��������    
--���-1-1: IN������          
--���-1-1-1                     
--[1].���������� �ִ� �����ȣ ã��:6��                                  
select manager--13�� �߿� �ߺ��� �����ϱ�
from employee
where manager IS NOT NULL;

select DISTINCT manager--�ߺ����� �� 6�� ��� 1���̻��� ���������� ������ �ִ�.
from employee
where manager IS NOT NULL;

--[2]: ���������� ���� ��� 8��
select ename
from employee
where eno NOT IN(select DISTINCT manager
				from employee
				where manager IS NOT NULL);
select ename
from employee
where eno NOT IN(7839, 7782, 7698, 7902, 7566, 7788);
-- �� �Ʒ��� ���� �� ���
	
--���-1-1-2
--[1].���������� �ִ� �����ȣ	ã�� -NVL�Լ��� NULL���� 0���� ����� ���
select DISTINCT NVL(manager,0)
from employee;--0���� 7���� ����

--�������ȣ(manager �÷�)�� �ڽ��� ��� ��ȣ(eno)�� ������ ���������� ���� ����� ��
--���������� ��� �߿� NULL�� ������ ����� �ȳ���
select ename
from employee
where eno NOT IN(select DISTINCT manager
					from employee);
--NVL �����ϸ� ������ �ƴ����� ����� �ȳ���
--���� ������ �ذ��ϱ� ����--->NVL�� NULL���� ó��
select ename
from employee
where eno NOT IN(select DISTINCT NVL(manager,0)
					from employee);

select ename
from employee
where eno NOT IN(7839, 7782, 7698, 7902, 7566, 7788, 0);
                                 
--���-1-2(�߸��� ���): ANY ������  - '����� 14�� ��� ���´�.'
select ename
from employee
where eno !=ANY(select DISTINCT NVL(manager,0)
					from employee);
-- eno !=7839 �ƴ� ��� 13��
-- eno !=7882 �ƴ� ��� 13��...                 
--eno !=0 	    �ƴ� ��� 14��             
--������: �ߺ� �����ϰ� ��� �����ϸ� 14���� ����� ���´�.	

--���-2: SELF JOIN
select*
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;

--[2] {���������� ���� ���}={�����} - {���������� �ִ� ���}
select eno, ename
from employee

MINUS

select DISTINCT m.eno, m.ename--��������
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;
					
select ename
from employee
where ename != ALL(select ename
                   from employee
                   where eno = ANY(select manager
                                   from employee));				
--�ڡ�8.���������� �ִ� ����̸� ǥ��
select *from employee;

--���-1: ��������    
--���-1-1: IN������                               
--[1].���������� �ִ� �����ȣ ã��                                  
select manager--13�� �߿� �ߺ��� �����ϱ�
from employee
where manager IS NOT NULL;

select DISTINCT manager--�ߺ����� �� 6�� ��� 1���̻��� ���������� ������ �ִ�.
from employee
where manager IS NOT NULL;

--[2]
select ename
from employee
where eno IN(select DISTINCT manager
				from employee
				where manager IS NOT NULL);
select ename
from employee
where eno IN(7839, 7782, 7698, 7902, 7566, 7788);
-- �� �Ʒ��� ���� �� ���

--���1-2: ANY ������(eno=7839 ������ eno=7782 ������ eno=7698 ....������ eno=7788)
--������: ���� �����ϴ� ������ ����� �� ��ħ
select ename
from employee
where eno = ANY(select distinct manager
				from employee
				where manager IS NOT NULL);
				
--���1-3(�߸��� ���):OR ������-'����� ����'(eno=7839 ������ eno=7782 ������ eno=7698 ....������ eno=7788)
--������: ��� ������ ����� ���ÿ� �����ϴ� �͵�
select ename
from employee
where eno = ALL(select distinct manager
				from employee
				where manager IS NOT NULL);
--�������̶� ���� �����ϴ� ���� �����Ƿ� ����� ����.				

--���-2: SELF JOIN
--���-2-1 JOIN ��� 1 == , where
select*
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;

select DISTINCT e.manager, m.eno, m.ename
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;

--���-2-2 JOIN ��� 2 == JOIN ON
select DISTINCT e.manager, m.eno, m.ename
from employee e JOIN employee m	
ON e.manager=m.eno
ORDER BY 1 ASC;

--[���1]
select ename
from employee
where eno = ANY(select manager
                from employee);
--[���2]
select ename
from employee
where eno IN(select manager
             from employee);

--9.BLAKE�� ������ �μ��� ���� ����̸��� �Ի����� ǥ��(��,BLAKE�� ����)
--[1].BLAKE�� ������ �μ���ȣ ���ϱ�
select dno
from employee
where ename = 'BLAKE';--1���� DNO�� 30�� ���
--[2]
select ename, hiredate
from employee
where dno IN (select dno
             from employee
             where ename = 'BLAKE')
	AND ename != 'BLAKE';--�ݵ�� 'BLAKE����' ���� �߰�
 
--10.�޿��� ��� �޿����� ���� ������� �����ȣ�� �̸� ǥ��(����� �޿��� ���� �������� ����)
--[���1]
--[1] ��� ���̺��� ��� �޿� ���ϱ�
select avg(salary)
from employee;
--[2]
select eno, ename
from employee
where salary > (select avg(salary)
                from employee)
order by salary;

--11.�̸��� K�� ���Ե� ����� ���� �μ����� ���ϴ� ����� �����ȣ�� �̸� ǥ��
--[���1]
--[1]�̸� K�� ���Ե� ����� ���� �μ���ȣ ���ϱ�
select dno
from employee 
where ename like '%K%';
--[2]
select eno, ename
from employee
where dno IN(select dno
             from employee 
             where ename like '%K%');
--[���2]
select eno, ename
from employee
where dno = ANY(select dno
                from employee 
                where ename like '%K%');

--12.�μ���ġ�� DALLAS�� ����̸��� �μ���ȣ �� ��� ���� ǥ��
--[���1]
--[1]�μ���ġ�� DALLAS�� �μ���ȣ ���ϱ�
select dno
from department
where loc = 'DALLAS';
--[2]
select ename, dno, job
from employee
where dno = (select dno
             from department
             where loc = 'DALLAS');

--[����-1]12�� ���湮�� �μ���ġ�� DALLAS�� ����̸�, �μ���ȣ, ������, +'�μ���ġ' ǥ��
--����̸�, �μ���ȣ, ������: ������̺�
--�μ���ȣ,�μ���ġ : �μ����̺�
--[���-1]���� ��� -1
select ename, e.dno, job, loc
from employee e, department d--56�� ���
where e.dno=d.dno AND LOC='DALLAS';

--[���-2]���� ��� -2
select ename, e.dno, job, loc
from employee e JOIN department d--56�� ���
ON e.dno=d.dno 
where LOC='DALLAS';

--[���-3]���� ��� -3
select ename, dno, job, loc
from employee NATURAL JOIN department
where LOC='DALLAS';

--[���-4]���� ��� - 4
select ename, dno, job, loc
from employee JOIN department 
USING (dno)
where LOC='DALLAS';
			
--13.KING���� �����ϴ� ����̸��� �޿� ǥ��
--[���1]
--[1]����̸��� KING�� �����ȣ ���ϱ�
select eno--���
from employee
where ename = 'KING';--manager ��ȣ
--[2] KING���� �����ϴ� �������� ���ϱ�
select ename, salary
from employee
where manager = (select eno
                 from employee
                 where ename = 'KING');            
                 
--14.RESEARCH �μ��� ����� ���� �μ���ȣ, ����̸�, ��� ���� ǥ��
--[���1]
--[1]RESEARCH �μ���ȣ ���ϱ�
select dno--20
from department
where dname = 'RESEARCH';
--[2] �� �μ��� �ٹ��ϴ� ��� ���� ���ϱ�
select dno, ename, job
from employee
where dno = (select dno 
             from department
             where dname = 'RESEARCH');
-- = �� IN �� �߿� �ϳ� ��� �ϸ� �ȴ�. IN���� �����ϸ� �ȴ�.
--[���2]
SELECT DEPT.DNO, E.ENAME, JOB
FROM EMPLOYEE
WHERE EMPLOYEE.DNO = DEPARTMENT.DNO 
AND D.DNAME = 'RESEARCH';

--15.��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� ���� �μ����� �ٹ��ϴ� 
--�����ȣ,�̸�,�޿� ǥ��
--[���� �ؼ�-1]��� �޿����� ���� �޿��� �ް�/�̸��� M�� ���Ե� ����� ���� �μ����� �ٹ�
--[���-1]
--[1]. ��� �޿�(����-1)
select avg(salary)
from employee;--2073.21
--[2]�̸��� M�� ���Ե� ����� ���� �μ���ȣ ���ϱ�(����-2)
select DISTINCT dno, ename, salary
from employee
where ename like '%M%';--10, 20, 30
--[3]
select eno, ename, salary, dno
from employee
where salary > (select avg(salary)
				from employee)--2073.21
AND dno IN(select DISTINCT dno
			from employee
			where ename like '%M%');--10, 20, 30
--[4]������: �̸��� M�� ���Ե� ����� ����
select eno, ename, salary, dno
from employee
where salary > (select avg(salary)
				from employee)--2073.21
AND dno IN(select DISTINCT dno
			from employee
			where ename like '%M%')--10, 20, 30
AND ename NOT LIKE '%M%';
--�쿬�� ���� ���� ��µǾ����� �̸��� M�� ���Ե� ����� �����ؾ� �� �ùٸ� ���̴�.

--[���� �ؼ�-2]��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� ���� �μ����� �ٹ�
--���������̺��� '��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ���'�� �������� �����Ƿ� ������ ������ �� ����Ʈ�غ� ���
--[����]: �μ���ȣ�� 20�̰� �̸��� M�� ���Ե� ����� �޿��� 3000���� ����
update employee
set salary =3000
where dno=30 AND ename like '%M%';
-- ����� �ȳ����Ƿ� �Ʒ��� ������ �ʿ��ϴ�. 
select ename, salary
from employee
where dno=30 AND ename like '%M%';alter--smith, adams�� ���� salary 3000���� ����Ǿ���.

--[���-2]
select round(avg(salary),0)--trunc ��뵵 ����
from employee;--������ ���� 2336

--[2]'��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� �μ���ȣ ���ϱ�
select dno--20
from employee
where ename LIKE '%M%'
		AND salary > (select round(avg(salary),0)
						from employee);
--[3]���� �μ���ȣ(20)�� ���� �μ����� �ٹ��ϴ� �����ȣ, �̸�, �޿� ǥ��
select eno, ename, salary, dno
from employee
where dno IN(select DISTINCT dno
			from employee
			where ename like '%M%')
AND salary > (select round(avg(salary),0)
				from employee);--10, 20, 30
--[4]������: �̸��� M�� ���Ե� ����� ����
select eno, ename, salary, dno
from employee
where dno IN(select DISTINCT dno
			from employee
			where ename like '%M%')
AND salary > (select round(avg(salary),0)
				from employee)--2073.21
AND ename NOT LIKE '%M%'; 
--[������ �����͸� �ٽ� ���� ������Ŵ]---> �ٽ� update �����ָ� �ȴ�.
update employee
set salary=800
where ename='SMITH';

update employee
set salary=800
where ename='ADAMS';

--16.��� �޿��� ���� ���� ������ �� ��ձ޿� ǥ��
--[1] ������ ��� �޿��� ���� ���� ������ �� ��ձ޿� ���ϱ�
select min(avg(salary))--�׷��Լ��� �ִ� 2������ ��ø����
from employee
group by job;
--[2]
select job, avg(salary)
from employee
group by job;
--[3]
select job, avg(salary)
from employee
group by job
--�׷��Լ��� ������ 
having avg(salary)= (�ּ���ձ޿�)--�ּ���ձ޿��� [1]�̴�.
--[4]������
select job, avg(salary)
from employee
group by job
having avg(salary)= (select min(avg(salary))
						from employee
							group by job);
--[���1]
select job, avg(salary)
from employee
group by job
having avg(salary) <= ALL(select avg(salary)
                        from employee
                        group by job);
--[���2]
select job, avg(salary)
from employee
group by job
having avg(salary) = (select min(avg(salary))
                      from employee
                      group by job);
 
--17.��� ������ MANAGER�� ����� �Ҽӵ� �μ��� ������ �μ��� ����̸� ǥ��
--[1]��� ������ MANAGER�� ����� �Ҽӵ� �μ��� ������ �μ���ȣ ���ϱ�
select dno
from employee
where job = 'MANAGER';
--[2]
select ename
from employee
where dno IN(select dno
                from employee
                where job = 'MANAGER');--14��
--[3]�����ؼ��� ���� '�������� 'MANAGER'�� ����� ���ܽ�ų�� �ִ�. 
select ename
from employee
where dno IN(select dno
                from employee
                where job = 'MANAGER')
AND job !='MANAGER';--11���̷� �ȴ�.   
                
--[���2]
select ename
from employee
where dno =ANY (select dno
             from employee
             where job = 'MANAGER');
 