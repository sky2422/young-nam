--<�Ͻ�-2��_������ ��ȸ�ϱ�>

--�̸��� SCOTT ����� ���� ���
select * 
from employee
where ename='SCOTT';--where ����  '����'

SELECT * 
FROM EMPLOYEE
WHERE ENAME='scott';--���ڰ��� ��ҹ��� ������. �������

SELECT * 
FROM EMPLOYEE
WHERE ENAME='SCOTT';--�������

--'1981�� 1�� 1�� ������ �Ի�'�� ����� ���
select * 
from employee
where hiredate < '1981/01/01';--'1 2 3'

--��������
--10�� �μ� �Ҽ��� ����� �߿��� ������ MANAGER�� ��� �˻�
select * 
from employee
where dno=10 AND job='MANAGER';--(�ڹ� &&)

--10�� �μ� �Ҽ��̰ų� ������ MANAGER�� ��� �˻�
select * 
from employee
where dno=10 OR job='MANAGER';--(�ڹ� ||)

--10�� �μ��� �Ҽӵ� ����� ����
select * 
from employee
where NOT dno = 10;--NOT ��<->���� (�ڹ� !)

select * 
from employee
where dno != 10;--�����ʴ�.�ٸ���. != ����Ŭ�� <> ^=

--�޿��� 1000~1500������ ��� ���
select *
from employee
where salary >= 1000 AND salary <= 1500;

select *
from employee
where salary between 1000 and 1500;

/*
 * �̸� <   ���� <=   �ʰ� >   �̻� >=
 */

--�޿��� 1000�̸��̰ų� 1500�ʰ��� ��� �˻�
select *
from employee
where salary < 1000 OR salary > 1500;

select *
from employee
where salary NOT between 1000 and 1500;

--'1982��'�� �Ի��� ��� ���� ���
select *
from employee
where hiredate >= '1982-01-01' AND hiredate <= '1982-12-31';
--where hiredate >= '82/01/01' AND hiredate <= '82/12/31';

select *
from employee
where hiredate between '1982-01-01' AND '1982-12-31';

select *
from employee
where hiredate between '1982/01/01' AND '1982/12/31';

select *
from employee
where hiredate between '82-01-01' AND '82-12-31';--1982���� 19�����ص� 1982�� �ν�

--Ŀ�̼��� 300�̰ų� 500�̰ų� 1400�� ��� ���� �˻�
select *
from employee
where commission=300 OR commission=500 OR commission=1400;

select *
from employee
where commission IN(300, 500, 1400);--�÷��� IN(��,��,��...)

--Ŀ�̼��� 300, 500, 1400�� ��� �ƴ� ��� ���� �˻�
select *
from employee
where NOT (commission=300 OR commission=500 OR commission=1400);

select *
from employee
where commission != 300 AND commission <> 500 AND commission ^= 1400;

select *
from employee
where commission NOT IN(300, 500, 1400);

------------------------------------------------------
--�̸��� 'F�� ����'�ϴ� ��� ���� ���
select *
from employee
where ename LIKE 'F%';
--%:���ڰ� ���ų� �ϳ� �̻��� ���ڰ� ����� �͵� �������.(��)'F', 'Fs', 'FVB'

--�̸��� 'M�� ����'�� ��� ���� ���
select *
from employee
where ename LIKE '%M%';--(��)'M', 'aM', 'MB', 'AMb'

--�̸��� 'M���� ������' ��� ���� ���
select *
from employee
where ename LIKE '%M';--(��)'M', 'aM', 'cccM'

--�̸��� '�ι�° ���ڰ� A'�� ��� �˻�
select *
from employee
where ename LIKE '_A%';-- _:�ϳ��� ���ڰ� � ���� �͵� �������.

--�̸��� '����° ���ڰ� A'�� ��� �˻�
select *
from employee
where ename LIKE '__A%';-- _:�ϳ��� ���ڰ� � ���� �͵� �������.

--�̸��� 'A�� ����'�Ǵ� ��� �˻�
select *
from employee
where ename LIKE '%A%';

--�̸��� 'A�� ���Ե��� �ʴ�' ��� �˻�
select *
from employee
where ename NOT LIKE '%A%';

------------------------------------
select * from employee;

--commission�� ���� ���ϴ� ��� ���� �˻�
select *
from employee --�ڹٿ�����  =���Կ����� ==����, SQL������ =����.(�񱳿�����)
where commission = null;--null �񱳿����ڷ� �񱳺Ұ��ϹǷ� ����ȳ���

select *
from employee
where commission IS null;

--commission�� �޴� ��� ���� �˻�
select *
from employee
where commission IS NOT null;

---------------------------------------
--����:ASC ��������(ASC�� ��������), DESC ��������
--�޿��� ���� ���� ������ ���
select *
from employee
ORDER BY salary ASC;

--�޿��� ���� ������ ���(�� ��, �޿��� ������ commission�� ���� ������ ���)
select *
from employee
ORDER BY salary ASC, commission DESC;

--�޿��� ���� ������ ���(�� ��, �޿��� ������ commission�� ���� ������, commission�� ������ �̸��� ���ĺ������� ���)
select *
from employee
--ORDER BY salary ASC, commission DESC, ename ASC;
--ORDER BY salary, commission DESC, ename;--ASC ��������
ORDER BY 6 ASC, 7 DESC, 2 ASC;--INDEX��ȣ:SQL 1���� ����, �ڹ� 0���� ����
--ORDER BY 6, 7 DESC, 2;

--�Ի����� �߽����� �������� ����
select *
from employee
ORDER BY hiredate ASC;

---------------------------------------------------------------

--<ȥ�� �غ���(P65~72)>-----------------------------

--1.���� �����ڸ� �̿��Ͽ� ��� ����� ���ؼ� 300�� �޿��λ��� ����� �� 
--����� �̸�, �޿�, �λ�� �޿� ���
SELECT ename, salary, salary+300 as "300�� �λ�� �޿�"
FROM employee;

--2.����� �̸�,�޿�,���� �Ѽ����� �� ������ ���� �ͺ��� ���� ������ ���
--���� �Ѽ���=����*12+�󿩱�100
SELECT ENAME, salary, salary*12+100 as "���� �Ѽ���"
FROM employee
ORDER BY "���� �Ѽ���" DESC;--�������� ����
--order by 3 desc;--�������� ����

--3.�޿��� 2000�� �Ѵ� ����� �̸��� �޿��� �޿��� ���� �ͺ��� ���� ������ ���
SELECT ENAME, salary
FROM employee
WHERE salary>=2000
ORDER BY salary DESC;

--4.�����ȣ�� 7788�� ����� �̸��� �μ���ȣ�� ���
SELECT ENAME, DNO
FROM employee
WHERE ENO LIKE 7788;
--WHERE ENO = 7788;

--5.�޿��� 2000���� 3000 ���̿� ���Ե��� �ʴ� ����� �̸��� �޿� ���
SELECT ENAME, salary
FROM employee
WHERE  salary < 2000 or salary > 3000;

SELECT ENAME, salary
FROM employee
WHERE salary NOT BETWEEN 2000 AND 3000;

--����: �켱���� NOT ---> AND ---> OR(�ڹ� ! ---> && ---> ||)
--�켱������ �ٲٴ� ����� ()��ȣ
select ename, salary
from employee
where NOT(2000<= salary AND salary <=3000);

--5-2. �޿��� 2000���� 3000 ���̿� ���ԵǴ� ����� �̸��� �޿� ���
select ename, salary
from employee
where 2000 <= salary AND salary <=3000;

select ename, salary
from employee
where salary between 2000 and 3000;

--����: �켱���� NOT ---> AND ---> OR (�ڹ� ! ---> ||)
--�켱������ �ٲٴ� �����()
select ename, salary
from employee
where not (2000 > salary OR salary> 3000);

--6.1981�� 2�� 20�Ϻ��� 1981�� 5�� 1�� ���̿� �Ի��� ����� �̸�, ������,�Ի��� ���
--����Ŭ�� �⺻��¥ ������ 'YY/MM/DD'
select ename, job, hiredate
from employee
where hiredate between '81/02/20' and '81/05/01';

SELECT ENAME, JOB, HIREDATE
FROM employee
WHERE HIREDATE BETWEEN '1981-02-20' AND '1981-05-01';

SELECT ENAME, JOB, HIREDATE
from employee
where '81/02/20' <=hiredate and hiredate <= '1981-05-01';
--7.�μ���ȣ�� 20 �� 30�� ���� ����� �̸��� �μ���ȣ�� ����ϵ� 
--�̸��� �������� �����ڼ����� ���
select ename, dno
from employee
where dno=20 or dno=30
order by ename;--asc ��������

select ename, dno
from employee
where dno IN(20,30)
order by ename;

--8.����� �޿��� 2000���� 3000���̿� ���Եǰ� �μ���ȣ�� 20 �Ǵ� 30�� ����� �̸�, �޿��� �μ���ȣ�� ����ϵ� 
--�̸���(��������)���� ���
select ename, salary, dno
from employee
where salary between 3000 AND 3000 AND (dno=20 or dno=30 )--�켱���� not
order by ename;

select ename, salary, dno
from employee
where salary between 2000 and 3000 and dno IN(20, 30)--�켱���� ����
order by ename;

--9. 1981�⵵�� �Ի��� ����� �̸��� �Ի��� ���(like�����ڿ� ���ϵ�ī�� ���)
SELECT ENAME, HIREDATE
FROM employee
WHERE HIREDATE LIKE '%81%';--'1981%' ��� �ȳ��´�.

--to_char(���� ��¥, '����')
select ename, hiredate --����Ŭ�� �⺻ ��¥�� ������ 'YY/MM/DD'
from employee
where to_char(hiredate, 'yyyy') like '1981%';--1981, 1981 ���� ~ ���
--where to_char(hiredate,'yyyy-mm-dd') like '1981%';--��� �ȳ��´�. 

select hiredate,--�� - �� - ��: ��:��
to_char(hiredate, 'yyyy/mm/dd'),--��/��/��
to_char(hiredate, 'yyyy')--��
from employee;

--10.������(=���)�� ���� ����� �̸��� ������
select ename, job
from employee
where manager IS null;

--11.'Ŀ�̼��� ���� �� �ִ� �ڰ�'�� �Ǵ� ����� �̸�, �޿�, Ŀ�̼��� ����ϵ�
--�޿� �� Ŀ�̼��� �������� �������� ����
select ename, salary, commission
from employee
where commission IS NOT null
order by salary desc, commission desc;

select ename, salary, commission
from employee
where job = 'SALESMAN'
order by 2 desc, 3 desc;

--12.�̸��� ����° ���ڰ� R�� ����� �̸� ǥ��
SELECT ENAME 
FROM employee
WHERE ENAME LIKE '__R%';

--13.�̸��� A�� E�� ��� �����ϰ� �ִ� ����̸� ǥ��
SELECT ENAME
FROM employee
WHERE ENAME LIKE '%A%' AND ENAME LIKE '%E%';

--14.'��� ������ �繫��(CLERK) �Ǵ� �������(SALESMAN)'�̸鼭 
--'�޿��� 1600,950 �Ǵ� 1300�� �ƴ�' ����̸�, ������, �޿� ���
SELECT ENAME, JOB, SALARY
FROM EMPLOYEE
where (job='CLERK' OR job='SALESMAN')
AND salary !=1600 and salary!=950 and salary!=1300; 

SELECT ENAME, JOB, SALARY
FROM EMPLOYEE
where job IN('CLERK', 'SALESMAN')
AND salary NOT IN (1600, 950, 1300);

SELECT ENAME, JOB, SALARY
FROM EMPLOYEE
where (job='CLERK' OR job='SALESMAN')
and salary not in (1600, 950, 1300);

--15.'Ŀ�̼��� 500�̻�'�� ����̸��� �޿�, Ŀ�̼� ���
SELECT ENAME, SALARY, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION>=500;


