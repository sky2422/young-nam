--<�Ͻ�-04��_�پ��� �Լ�>

--<�����Լ�>
--1. ��ҹ��� ��ȯ�Լ�
select 'Apple',
upper('Apple'),--�빮�ڷ� ��ȯ
lower('Apple'),--�ҹ��ڷ� ��ȯ
initcap('aPPLE')--ù���ڸ� �빮��, �������� �ҹ��ڷ� ��ȯ
from dual;--dual : �������̺�, ������� 1���� ǥ���ϰ� ���� �� ���

--��ҹ��� ��ȯ�Լ� ��� Ȱ��Ǵ��� ���캸��
--'scott' ����� ���, �̸�, �μ���ȣ ���
SELECT eno, ename, dno 
FROM EMPLOYEE
WHERE lower(ENAME)='scott';
--�񱳴���� ����̸��� ��� �ҹ��ڷ� ��ȯ�Ͽ� ��

select ename, lower(ename)
from employee;

SELECT eno, ename, dno 
FROM EMPLOYEE
WHERE initcap(ENAME)='Scott';

--2. ���ڱ��̸� ��ȯ�ϴ� �Լ�
--����, ��, Ư������(1byte) �Ǵ� �ѱ��� ���� ���ϱ�
--length() : ���� ��
select length('Apple'), length('���')
from dual;--5 2 

--lengthB():�ѱ�2byte-'���ڵ� ���'�� ���� �޶���(UTF-8:�ѱ� 1���ڰ� '3����Ʈ')
select lengthB('Apple'), lengthB('���')
from dual;--5����Ʈ 6����Ʈ

--3. ���� ���� �Լ�
--concat(�Ű������� 2����):'�� ���ڿ�'�� �ϳ��� ���ڿ��� ����(=����)
--                    	�ڹݵ�� 2 ���ڿ��� ���� ����

--�Ű�����=�μ�=����=argument
select 'Apple', '���',
concat('Apple ', '���') AS "�Լ� ���",--�ڹٿ����� "Apple".concat("���")
'Apple ' || '��� ' || '���־�' AS "|| ���"--�ڹٿ�����  "Apple" + "���" + "���־�"
from dual;

--substr(�������ڿ�, ����index, ������ ����) : ���ڿ��� �Ϻθ� �����Ͽ� �κй��ڿ�
--����index : �����̸� ���ڿ��� �������� �������� �Ž��� �ö��
--�ε���(index) : 1 2 3....(�ڹ� index : 0 1 2...)
select substr('apple mania',7,5), --mania
substr('apple mania',-11,5) --apple
from dual;

--[����1] '�̸��� N���� ������' ��� ���� ǥ��
--���-1:like�����ڿ� ���ϵ�ī��(% _) �̿�
select *
from EMPLOYEE
where ename LIKE '%N';

--���-2:substr() �̿�
select *
from EMPLOYEE
where substr(ename, -1, 1)='N';

select ename, substr(ename, -1, 1)
from EMPLOYEE
where substr(ename, -1, 1)='N';

--[����2] 87�⵵�� �Ի��� ��� ���� �˻�
--���-1
select *
from EMPLOYEE
where substr(hiredate,1,2)='87';--�ڿ���Ŭ : ��¥ �⺻ ���� 'YY/MM/DD'
--where substr(hiredate,1,2)='1987';--��� �ȳ���

--���-2
--to_char(���� ��¥,'����'):���� ��¥�� ���ڷ� ����ȯ��
select *
from EMPLOYEE -- substr('1987-11-12',1,4)
where substr(to_char(hiredate,'yyyy-mm-dd'),1,4)='1987';

--[����3] '�޿��� 50���� ������' ����� ����̸��� �޿� ���
select ename, salary
from EMPLOYEE
where salary like '%50';--salary�� �Ǽ�number(7,2)Ÿ�������� '���ڷ� �ڵ�����ȯ'�Ǿ� ��

select ename, salary
from EMPLOYEE--����index :������ 2��°���� �����ؼ� 2�� ���ڷ� �κй��ڿ� ����
where substr(salary,-2,2)='50';--salary�� �Ǽ�number(7,2)Ÿ�������� '���ڷ� �ڵ�����ȯ'

--substr()�� �����Լ�
select ename, salary
from EMPLOYEE--����index :������ 2��°���� �����ؼ� 2�� ���ڷ� �κй��ڿ� ����
where substr(to_char(salary),-2,2)='50';--to_char(���� ��¥)�� ���ڷ� ����ȯ��

--substrB(�������ڿ�, ����index, ������ ����Ʈ��)
select substr('����ŴϾ�',1,2),--'���'
substrB('����ŴϾ�',1,3),--'��'  1���� �����ؼ� 3����Ʈ�� ����
substrB('����ŴϾ�',4,3),--'��'  4���� �����ؼ� 3����Ʈ�� ����
substrB('����ŴϾ�',1,6)--'���'  1���� �����ؼ� 6����Ʈ�� ����
from dual;

--instr(����ڿ�, ã�� ���ڿ�, ���� index, �� ��° �߰�): ����ڿ� ���� ã���� �ϴ� �ش� ���ڿ��� ��� '��ġ(=index��ȣ)'�� ����
--'���� index, �� ��° �߰�' �����ϸ� ��� 1�� ����
--(ex)instr(����ڿ�, ã�� ����) ---> instr(����ڿ�, ã�� ����, 1, 1)
--ã�� ���ڰ� ������ 0�� ����� ������(�ڹٿ����� -1)
--�ڹٿ����� "�ູ,���".indexOf("���")==3
select instr('apple','p'), instr('apple','p',1,1), --2 2
      instrB('apple','p'),instrB('apple','p',1,1), --2 2
instr('apple','p',1,2)--3('apple'������  1���� �����ؼ� �� ��° �߰��ϴ� 'p'�� ã�� index��ȣ)
from dual; 

select instr('apple','p',2,2)
from dual; --3

select instr('apple','p',3,1)
from dual; --3

select instr('apple','p',3,2)
from dual; --0:ã�� ���ڰ� ����.(�ڹٿ����� ã�� ���ڿ��� ������ -1)

select instr('apple','pl',1,1)
from dual; --3

--����� ������ 1���ڿ� 1byte, �׷��� �ѱ��� ���ڵ���Ŀ� ���� �޶���
--'�ٳ���'���� '��'���ڰ� 1���� �����ؼ� 1��° �߰ߵǴ� '��'�� ã�� ��ġ(index)=?
select instr('�ٳ���','��'), instr('�ٳ���','��',1,1), --2 2
      instrB('�ٳ���','��'), instrB('�ٳ���','��',1,1) --4 4
from dual;

--'�ٳ���'���� '��'���ڰ� 2���� �����ؼ� 2��° �߰ߵǴ� '��'�� ã�� ��ġ(index)=?
select instr('�ٳ���','��',2,2), --3
      instrB('�ٳ���','��',2,2)  --7
from dual;

--�̸��� ����° ���ڰ� 'R'�� ����� ������ �˻�
--���-1
select *
from EMPLOYEE
where ename like '__R%';

--���-2
select *
from EMPLOYEE
where substr(ename,3,1)='R';

--���-3
select *
from EMPLOYEE
where instr(ename,'R',3,1)=3;

--LPAD(Left Padding) : '�÷�'�̳� ����ڿ��� ��õ� �ڸ������� �����ʿ� ��Ÿ����
--���� ������ Ư�� ��ȣ�� ä��

--10�ڸ��� ���� �� salary�� ������, ���� �����ڸ��� '*'�� ä��
select salary, LPAD(salary,10,'*')
from employee;
--10�ڸ��� ���� �� salary�� ����, ���� �������ڸ��� '*'�� ä��
select salary, RPAD(salary,10,'*')
from employee;

--LTRIM('  ���ڿ�') : ���ڿ��� '����' ���� ����
--RTRIM('���ڿ�    ') : ���ڿ��� '����' ���� ����
--TRIM('  ���ڿ�     ') : ���ڿ��� ���� ���� ����
select '   ����ŴϾ�     '||'�Դϴ�.',
LTRIM('   ����ŴϾ�     ')||'�Դϴ�.',
RTRIM('   ����ŴϾ�     ')||'�Դϴ�.',
TRIM('   ����ŴϾ�     ')||'�Դϴ�.'
from dual;

--TRIM('Ư������1����' from �÷��̳� '����ڿ�')
--�÷��̳� '����ڿ�'���� 'Ư������'�� 'ù��° ����'�̰ų� '������ ����'�̸� �߶󳻰�
--���� ���ڿ��� ����� ��ȯ(=����=������)
select TRIM('���' from '����ŴϾ�')
from dual;/*�����޽��� : trim set should have only one character*/

select TRIM('��' from '����ŴϾ�')
from dual;--'���ŴϾ�'

select TRIM('��' from '����ŴϾ�')
from dual;--'����Ŵ�'

select TRIM('��' from '����ŴϾ�')
from dual;--'����ŴϾ�':'��'�� ó���̳� �������� �����Ƿ� �߶��� ���� ����� '����ŴϾ�'�״�� ���� 

--<�����Լ�>-�Ͻ� P114~
--  -2(��)   -1(��)   0(��) . 1   2   3

--1. round(���,ȭ�鿡 ǥ�õǴ� �ڸ���) : �ݿø�
--��, �ڸ��� �����ϸ� 0���� ����
select 98.7654,
round(98.7654),   --99
round(98.7654,0), --99    ���� �ڸ����� ǥ��. �Ҽ� 1°�ڸ����� �ݿø��Ͽ�
round(98.7654,2), --98.77 �Ҽ� 2°�ڸ����� ǥ��. �Ҽ� 3°�ڸ����� �ݿø��Ͽ�
round(98.7654,-1) --100   ���� �ڸ����� ǥ��. ���� �ڸ����� �ݿø��Ͽ�
from dual;

--2. trunc(���, ȭ�鿡 ǥ�õǴ� �ڸ���) : 'ȭ�鿡 ǥ�õǴ� �ڸ���'���� ����� ������ ����
--��, �ڸ��� �����ϸ� 0���� ����
select 98.7654,
trunc(98.7654),   --98
trunc(98.7654,0), --98    ���� �ڸ����� ǥ��. 
trunc(98.7654,2), --98.76 �Ҽ� 2°�ڸ����� ǥ��. 
trunc(98.7654,-1) --90    ���� �ڸ����� ǥ��. 
from dual;

--3. mod(��1,��2) : ��1�� ��2�� ���� ������
select MOD(10,3)
from dual;

--����̸�, �޿�, �޿��� 500���� ���� ������ ���
select ename, salary, MOD(salary,500)
from EMPLOYEE;

--<��¥�Լ�>-�Ͻ� P117~
--1. sysdate : �ý������κ��� ������ ��¥�� �ð��� ��ȯ
select sysdate from dual;

--date + �� = ��¥���� ����ŭ '���� ��¥'
--date - �� = ��¥���� ����ŭ '���� ��¥'
--date - date = �ϼ�
--date + ��/24 = ��¥ + �ð�

select sysdate-1 as ����,
sysdate "����",
sysdate+1 as "�� ��"
from dual;

--[����]������� ��������� �ٹ��ϼ� ���ϱ�(��, �Ǽ��̸� �ݿø��Ͽ� ���� �ڸ����� ǥ��)
select sysdate-hiredate as "�ٹ��ϼ�"--�Ǽ�
from employee;

select sysdate-hiredate as "�ٹ��ϼ�",--�Ǽ�
ROUND(sysdate-hiredate,0) as "�ٹ��ϼ� �ݿø�"--����
from employee;

--�Ի��Ͽ��� '���� ����'���� �߶󳻷���('������ ǥ��', ������ ����)
select hiredate, 
trunc(hiredate,'month') --��(01)�� ��(01)�� �ʱ�ȭ
from employee;

select sysdate, 
trunc(sysdate),     --�ð� �߶�
trunc(sysdate,'dd'),--�ð� �߶�(���ٰ� ������ ���)
trunc(sysdate,'hh24'),--��, �� �߶�
trunc(sysdate,'mi'),--�� �߶�
trunc(sysdate,'year'), --��(01)�� ��(01)�� �ʱ�ȭ
trunc(sysdate,'month'),--��(01)�� �ʱ�ȭ
trunc(sysdate,'day')--���� �ʱ�ȭ(�ش糯¥���� �� ���� ������ �Ͽ��Ϸ� �ʱ�ȭ)
from dual;


select sysdate,
trunc(sysdate,'day')
from dual;

--2. monthS_between(��¥1, ��¥2): ��¥1�� ��¥2 ���̿� ���� �� ���ϱ�(��¥1-��¥2)
select ename, sysdate, hiredate,
monthS_between(sysdate, hiredate), TRUNC(monthS_between(sysdate, hiredate)),--���
monthS_between(hiredate, sysdate), TRUNC(monthS_between(hiredate, sysdate))--����
from employee;

--3. add_monthS(��¥, ���� ������): Ư�� �������� ���� ��¥
select ename, hiredate, 
add_monthS(hiredate,3), add_monthS(hiredate,-3)
from employee; 

--4. next_day(��¥, '������'): �ش糯¥�� �������� ���ʷ� �����ϴ� ���Ͽ� �ش��ϴ� ��¥ ��ȯ
select sysdate,
next_day('2021-10-26','������'),
next_day(sysdate, 4)--�Ͽ���(1), ������(2),...�����(7) ���� ��� ���ڷ� �Է°���
from dual;

--5. last_day(��¥): �ش糯¥�� ���� ���� ������ ��¥�� ��ȯ
--��κ� ���� ���, ������ ���� ������ ������
--2������ ������ ���� 28 �Ǵ� 29�� �� �� �����Ƿ� '2���� ����ϸ� ȿ������'
select sysdate, last_day(sysdate)
from dual;

select ename, hiredate, last_day(hiredate)
from employee;

--6. ��¥ �Ǵ� �ð� ���� ��� ���
--��¥ ���� : ��������(YYYY-MM-DD)-��������(YYYY-MM-DD)
--�ð� ���� : ( �����Ͻ�(YYYY-MM-DD HH:MI:SS)-�����Ͻ�(YYYY-MM-DD HH:MI:SS) )*24
--�� ����    : ( �����Ͻ�(YYYY-MM-DD HH:MI:SS)-�����Ͻ�(YYYY-MM-DD HH:MI:SS) )*24*60
--�� ����    : ( �����Ͻ�(YYYY-MM-DD HH:MI:SS)-�����Ͻ�(YYYY-MM-DD HH:MI:SS) )*24*60*60

--�� '��������-��������' ���� ���� ���� '�� ����'�� ��ġ ������ ��ȯ�ȴ�.

select '20211129'-'20211127'--number�� �ڵ�����ȯ(20211129-20211127)�Ǿ� ����� 
from dual;--2

--��¥ ���� ���
select '2021-11-29'-'2021-11-27'--����-����=>number�� �ڵ�����ȯ(X)
from dual;--���� �߻�

--to_date(��,'����') : ��->'��¥'�� ��ȯ
select 20211129 ,to_date(20211129, 'YYYYMMDD') from dual;

--to_date('����','����') : '����'->'��¥'�� ��ȯ
--(��)1800-1-1 => 1, 2021-11-26 => 1000�� ����, 2021-11-27 => 998�� ����
select to_date('2021-11-29','YYYY-MM-DD')-to_date('2021-11-27','YYYY-MM-DD')
from dual;--2

--�ð� ���� ���
select (to_date('15:00','HH24:MI')-to_date('13:00','HH24:MI')) * 24
from dual;--0.08333��*24=>2�ð�

select (to_date('2021-11-29 15:00','YYYY-MM-DD HH24:MI')-to_date('2021-11-29 13:00','YYYY-MM-DD HH24:MI')) * 24
from dual;--���� ���� ��� 2�ð�

select (to_date('2021-11-30 15:00','YYYY-MM-DD HH24:MI')-to_date('2021-11-29 13:00','YYYY-MM-DD HH24:MI')) * 24
from dual;--25.999999..�ð�


select (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24
from dual;--2.005�ð�
--�ð��� �ʰ� �����ϸ� �Ҽ����� �߻��ϹǷ� round �Լ��� �Ҽ����� ó���� �� �ִ�.
--�Ҽ� 2°�ڸ����� ǥ��(�Ҽ�3°�ڸ����� �ݿø��Ͽ�)
select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 , 2)
from dual;--2.01�ð�

--�� ���� ���
select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60 , 2)
from dual;--120.3��


select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60)
from dual;--120��(�Ҽ��� 1°�ڸ� �ݿø�)

select TRUNC( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60)
from dual;--120��(�Ҽ��� ����)

--�� ���� ���
select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60 * 60)
from dual;--120��*60=>7218��


--<����ȯ�Լ�>-�Ͻ� P124~
/*
 *
 *     - to_char()->      <- to_char() - 
 * [��]               [����]               [��¥]
 *    <-to_number()-      - to_date() ->
 *   ------------- to_date() --------->
 */


--1. to_char(���� '��¥', ����) : ���� '��¥'�� ���ڷ� ��ȯ

--<'��¥'�� ���õ� ����>
--YYYY : ���� 4�ڸ�,            YY : ���� 2�ڸ�
--MM : �� 2�ڸ� ���� (��)1��=>01,  MON : ���� '���ĺ�'����
--DD : �� 2�ڸ� ����  (��)2��=>02,  D : ������
--DAY : ���� ǥ�� (��)������,      DY : ������ ���� ǥ�� (��)��

--<'�ð�'�� ���õ� ����>
--AM �Ǵ� PM     : ����AM, ����PM �ð� ǥ��
--A.M. �Ǵ� P.M. : ����A.M., ����P.M. �ð� ǥ��
--�� 4���� �� ���� ��� (12�� ������ '����'��µ�, 12�� ���Ĵ� '����'��µ�)
--AM or PM or A.M. or P.M. + HH �Ǵ� HH12�� �ݵ�� ���
--HH �Ǵ� HH12   : �ð�(1~12�÷� ǥ��)
--HH24      : 24�ð����� ǥ��(0~23) 
--               AM or PM or A.M. or P.M. �����ص� �ð� ����� ���޵�
--MI        : ��
--SS        : �� 


select ename, hiredate,
to_char(hiredate, 'YY-MM'),
to_char(hiredate, 'YYYY/MM/DD DAY DY')
from employee;

select
to_char(sysdate,'YYYY/MM/DD DAY DY, HH'),--������� ����(���� ���İ� �����Ƿ� ���оȵ�)
to_char(sysdate,'YYYY/MM/DD DAY DY, PM HH'),--AM �Ǵ� PM �ݵ�� ��� + HH12
to_char(sysdate,'YYYY-MM-DD DAY DY, A.M. HH'),
to_char(sysdate,'YYYY/MM/DD DAY DY, HH24:MI:SS')--AM �Ǵ� PM �������� + HH24
to_char(sysdate,'YYYY/MM/DD DAY DY, AM HH24:MI:SS')
from dual;

/*
 * <���ڿ� ���õ� ����>
 * 0 : �ڸ����� ��Ÿ���� �ڸ����� ���� ���� ��� '0���� ä��'
 * 9 : �ڸ����� ��Ÿ���� �ڸ����� ���� ���� ��� 'ä���� ����'
 * L : �� ������ ��ȭ��ȣ�� �տ� ǥ�� (��)���ѹα� �� (��, �޷��� ���� �տ� $�ٿ��� ��)
 * . : �Ҽ��� ǥ��
 * , : õ ���� �ڸ� ǥ��
 */

select ename, salary,
to_char(salary,'L000,000'),
to_char(salary,'L999,999'),
to_char(salary,'L999,999.00'),
to_char(salary,'L999,999.99')
from employee;

select 123.4, to_char(123.4,'L000,000.00'), to_char(123.4,'L999,999.99')
from dual;--123.4   ��000123.40   ��123.40

--10���� 10�� ���� -> 16����(=HEX) ���� A = ����'A'(16���� ���� '0'~'F')�� ��ȯ�ȴ�.
select to_char(10,'X'),--10���� 10�� 16���� 1�ڸ��� �� ���ڷ� ��ȯ�ϸ�'A'�̴�.
to_char(255, 'XX')--10���� 255�� 16���� 2�ڸ��� �� ���ڷ� ��ȯ 'FF'('X'�� �ϸ� '##'�ڸ����� ����)
from dual;

--'����'�� '16��������('0'~'F')' -> 10������ ��ȯ
select to_number('A','X'),--16����A -> ���� ��ȯ 10
to_number('FF','XX')--16����FF -> ���� ��ȯ 255
from dual;

/*
 * ��κ� ����ϴ� to_number('10���� ������ ����')�� �뵵��
 * �ܼ��� '10���� ������ ����'�� ���ڷ� ��ȯ�ϴµ� ����
 */

select to_number('0123'), to_number('12.34'), to_number('��')
from dual;

/*
 * java������ int num1=Integer.parseInt("0123");//0123
 *         int num2=Integer.parseInt("����");//���ܰ�ü->���α׷��� ����
 * 
 *          double num3=Double.parseDouble("12.34");//12.34
 *          double num4=Double.parseDouble("ab");//���ܰ�ü->���α׷��� ����
 */

--2. to_date(���� '����', '����') : ���� '����'�� ��¥������ ��ȯ
select ename, hiredate
from employee
where hiredate=19810220;--������ Ÿ���� ���� �ʾ� �˻� �Ұ���(����)

--�׷��� to_date()�Լ� �̿��Ͽ� ���� ��¥�� ����ȯ�Ͽ� �ذ�
select ename, hiredate
from employee
where hiredate = to_date(19810220,'yymmdd');
--��� ���� 1981-02-20 �� �� ��

select ename, hiredate, 
from employee
where hiredate = to_date(810220,'yymmdd');--���� ��� ����(����?'1900�⵵ = 2081-02-20' �̹Ƿ� ���� ��� ����.)

select 810220, 
to_date(810220,'yymmdd'), --2081-02-20 ��:��:�� (�⵵���� �� 2�ڸ� �����ϸ� �ڵ����� 20����)
to_date('810220','yy/mm/dd'),--2081-02-20 ��:��:��
to_date('81/02/20','yy-mm-dd'),--2081-02-20 ��:��:��
to_date('81/02/20','yy$mm$dd'),--2081-02-20 ��:��:��

to_date(19810220,'yymmdd'), --1981-02-20 ��:��:�� 
to_date('19810220','yymmdd'),--1981-02-20 ��:��:�� 

to_date(19810220,'yyyymmdd'),--���� ���
to_date('19810220','yyyymmdd'),--���� ���

to_date(19810220,'yyyy-mm-dd'),--���� ���
to_date('19810220','yyyy/mm/dd'),--���� ���

--to_date(1981/02/20,'yyyy-mm-dd'),--�ڡ����� :����
to_date('1981-02-20','yyyy/mm/dd')--���� ���
from dual;--to_date()�� ����� '��-��-�� ��:��:��'�� ��ȯ��.

select ename, hiredate
from employee
where hiredate = to_date('81/02/20','yy/mm/dd');--���� ��� ����

select ename, hiredate
from employee
where hiredate = to_date('19810220','yyyy-mm-dd');--��� ���� 1981-02-20 �� �� ��

select ename, hiredate
from employee
where hiredate = to_date('1981-02-20','yyyy/mm/dd');--��� ���� 1981-02-20 �� �� ��

select ename, hiredate
from employee
where hiredate = to_date(19810220,'yyyy/mm/dd');--��� ���� 1981-02-20 �� �� ��

select ename, hiredate
from employee
where hiredate = to_date(19810220,'yyyy/mm/dd');--��� ���� 1981-02-20 �� �� ��

select ename, hiredate
from employee
where hiredate = to_date(19810220,'yyyy$mm$dd');--��� ���� 1981-02-20 �� �� ��

select ename, hiredate, to_char(hiredate,'yy/mm/dd')
from employee;

--3. to_number('10��������','����') : '����
select 123, to_number('123'), to_number('12.3'), to_number('10,100','99999')
from dual;--to_number('10,100'):�����߻�

select 100000 - 50000
from dual;--��� 50000

select 100,000 - 50,000
from dual;

select '100000' - '50000'
from dual;--��� 50000(����?'10���� ����'�̹Ƿ� ���� �ڵ�����ȯ�Ǿ� ����)

select '100000' - 50000
from dual;--��� 50000

select '100,000' - '50,000'
from dual;--����(����?'10���� ���ڰ� �ƴ� ,�� �־' ���� �ڵ�����ȯ�� �ȵ�)
--�ذ��
select to_number('100,000','999,999') - to_number('50,000','99,999')
from dual;--��� 50000(,õ���� ���н�ǥ)

select to_number('100,000','999,999'), to_number('50,000','99,999')
from dual;--100000, 50000

select to_number('100,000','999999') - to_number('50,000','99999')
from dual;--��� 50000(,�� �����ص� ���� ��ȯ��)

select to_number('100,000','999999'), to_number('50,000','99999')
from dual;--100000, 50000

select '100000' - to_number('50000')
from dual;--��� 50000  to_number()����� �ʿ����(�ڵ�����ȯ�ǹǷ�...)

--<�Ϲ��Լ�>-�Ͻ� P130~

/* NULL�� ����� �񱳸� ���� ����
 * 
 * �ڡ�nulló���ϴ� �Լ���
 * 1. NVL(��1, ��2) : ��1�� null�� �ƴϸ� ��1, ��1�� null�̸� ��2
 *    ����: ��1�� ��2�� �ݵ�� ������ Ÿ���� ��ġ
 *    (��) NVL(hiredate, '2021/05/21') : �Ѵ� date Ÿ������ ��ġ
 *        NVL(job, 'MANAGER') : �Ѵ� ����Ÿ������ ��ġ
 * 
 * 2. NVL2(��1, ��2, ��3)
 *        (��1, ��1�� null�� �ƴϸ� ��2, ��1�� null�̸� ��3)
 * 3. NULLif(��1, ��2) : �� ���� ������ null, �ٸ��� 'ù��° ��1'�� ��ȯ
 */

select ename, salary, commission,
salary*12 + NVL(commission, 0) as "�� ��",
salary*12 + NVL2(commission, commission, 0) as "�� ��",
NVL2(commission, salary*12 + commission, salary*12) as "�� ��",
salary*12 + NVL2(commission, 1000, 0) as "Ŀ�̼�null�ƴѻ��+1000",
salary*12 + nvl( NULLif(commission, null), 0) as "�������(�������)"
from employee;

select NULLIF('A','A'),NULLIF('a','b')
from dual;--null, 'a'

--4. coalesce(�μ�, �μ�, �μ�...) 

/*
 * ������̺��� Ŀ�̼��� null�� �ƴϸ� Ŀ�̼��� ���,
 * Ŀ�̼��� null�̰� �޿�(salary)�� null�� �ƴϸ� �޿��� ���,
 * Ŀ�̼ǰ� �޿� ��� null�̸� 0���
 */

select ename, salary, commission,
coalesce(commission, salary, 0)
from employee;

/*
 * java������
 * if(commission !=null) commission���
 * else if(salary != null) salary ���
 * else 0 ���
 */

/*
 * 5.decode() : switch~case�� �ڡڸ��� ����ϴ� �Լ�
 * switch(dno){
 * case10: 'ACCOUNTING'���;break;
 * case20: 'RESEARCH'���;break;
 * case30: 'SALE'���;break;
 * case40: 'OPERATIONS'���;break;
 * default: '�⺻' ���
 * }
 */

--�μ��̸� �������� �����Ͽ� ���: [���-1] decode()�Լ� ���
select ename, dno,
decode(dno 10,'ACCOUNTING',
			20,'RESEARCH',
			30,'SALE',
			40,'OPERATIONS',
			'�⺻') as dname
from employee
order by dno asc;

--�μ��̸� �������� �����Ͽ� ��� : [���-2]
--6.case~end : �ڹٿ��� if~else if~...else���� ���
--���� case~end���̿� , ����
--decode()�Լ����� ������� ���ϴ� �񱳿����� �� = ������ ������ �񱳿�����(>=, < ��)�� ����� ��
select ename, dno,
case when dno=10 then 'ACCOUNTING'
	 when dno=20 then 'RESEARCH'
	 when dno=30 then 'SALES'
	 when dno=40 then 'OPERATIONS'
	 else '�⺻'
end as DNAME
from employee
order by dno asc;

--�μ��̸��� �������� �����Ͽ� ��� : [���-3] �����̺��� �ϳ��� ���̺�� join
select ename, dno, dname
from employee natural join department;--�� �� dno
order by dno asc;

---------------------------------------------------
--[������� ����]

--�ڵ� ����ȯ

select '100'+200
from dual;--���� '100'�� ��100���� �ڵ�����ȯ�Ǿ� ����

--���� ����
select concat('100',200),--��200->����'200'���� �ڵ�����ȯ '100200'
100 || 200 || 300 || 400--��� ���ڷ� �ڵ�����ȯ '100' || '200'
from dual;

select ename
from employee
where eno = '7369';--'eno�� number'�̹Ƿ� ���� '7369'�� ������ �ڵ�����ȯ�� �� �񱳿����ڷ� ����


select ename
from employee
where eno = cast('7369' as number(4));
--���� �������� ������, cast�Լ��� ����ϸ� Ÿ���� ���� �ʾ� �߻��ϴ� ������ ������ �� �ִ�.

--cast() :������ ���� ��ȯ �Լ� ������ ������ �ǽð����� ��ȯ�ϴµ� ����
		   
select avg(salary) as "��� ����"
from employee;--����� �Ǽ��� 2073.2142...

--1.1 �Ǽ��� ���� ����� '��ü �ڸ��� 6�ڸ� �� �Ҽ��� ���� 2�ڸ����� ǥ��(3° �ڸ����� �ݿø�)'
--���� : �Ҽ����� �����ϴ� ���� Ÿ�� ��ȯ �� ���� ���� �ڸ������� ���� �ڸ����� cast�ϰ� �Ǹ�
--round()�Ǿ� �ݿø� ó����
select CAST(avg(salary) AS NUMBER(6,2)) as "��� ����"
from employee;--2073.21

select round(avg(salary),2) as "��� ����"
from employee;

--������ ������ �ǽð����� ��ȯ�ϴµ� ���Ǵ� ��
select cast(ename as char(20)),
	   length(ename),
	   length(cast(ename as char(20)))
from employee;
--RUN SQL command line���� employee���̺��� ���� Ȯ���غ���
desc employee;
--��� : ename�� ������ ������ ������ ����

--1.2 �Ǽ��� ���� ����� '������ ���� ���ؼ�'
--�Ʒ� 2���� ����� �ٸ�
select CAST(avg(salary) AS NUMBER(6)) "��� ����"
from employee;--����2073.7142...=>2074

select trunc(avg(salary),0) as "��� ����"
from employee;--�ڹٿ��� (int)2073.2142...=>2073

--�׽�Ʈ : �����ȣ 7369�� �޿��� 800���� ����
update employee --update ���̺��(���� : from ����)
set salary=800 --set �÷���=������ ��
where eno=7369; --where ����

select*
from employee;

select ename, salary
from employee
where eno=7369;

--2. �پ��� �����ڸ� ��¥ �������� ���氡��(��)��¥:'2021-05-21', '2021/05/21'
select CAST('2021$05$21' AS DATE) from dual;
select CAST('2021%05%21' AS DATE) from dual;
select CAST('2021#05#21' AS DATE) from dual;
select CAST('2021@05@21' AS DATE) from dual;

--3. ������ ����� ���� ������ ó���� ��
select nvl(salary, 0) + nvl(commission, 0) as "����"
from employee;

select cast(nvl(salary, 0) as char(7)) || '+' 
|| cast(nvl(commission, 0) as char(7)) || '=' as "����+Ŀ�̼�",
nvl(salary, 0) + nvl(commission, 0) as "����"
from employee;

--<4�� ȥ���غ���>-----------------------------

--1.substr �Լ��� ����Ͽ� ������� �Ի��� �⵵�� �Ի��� �޸� ����Ͻÿ� 
select hiredate, 
substr(hiredate, 1, 2) �⵵, substr(hiredate, 4, 2) ��
from employee;--����� ��¥ �⺻ ����(yy/mm/dd)

select hiredate, 
substr(to_char(hiredate,'yyyy-mm-dd'), 1, 4) �⵵,
substr(hiredate, 4, 2) ��
from employee;

--2.substr �Լ��� ����Ͽ� 4���� �Ի��� ����� ����Ͻÿ�.
select *
from employee
--where substr(hiredate, 4, 2) like '04';
where substr(to_char(hiredate,'yyyy-mm-dd'), 6, 2)='04';

--3.mod �Լ��� ����Ͽ� �����ȣ�� ¦���� ����� ����Ͻÿ�.
select ename, eno
from employee
--where mod(eno, 2) like 0;
where mod(eno, 2) = 0;

--4.�Ի����� ������ 2�ڸ�(YY), ���� ����(MON)�� ǥ���ϰ� ������ ���(DY)�� �����Ͽ� ����Ͻÿ�.
select hiredate, 
to_char(hiredate, 'yy/mm/dd dy')--81/11/23 ��
from employee;

select hiredate, 
to_char(hiredate, 'yy/mon/dd day')--81/11��/23 ������
from employee;

--5.���� ��ĥ�� �������� ����Ͻÿ�. ���� ��¥���� ���� 1�� 1���� �� ����� ����ϰ� 
--to_date �Լ��� ����Ͽ� ������ ���� ��ġ ��Ű�ÿ�.
select sysdate-'2021/01/01'
from dual;--����?������ ���� ��ġ���� �ʾƼ�

select sysdate-to_date(20210101,'YYYY/MM/DD')
from dual;--to_date(���� '����', '����')

select trunc(sysdate-to_date('2021/01/01','YYYY/MM/DD'))
from dual;--������ ǥ��

--6.������� ��� ����� �߷��ϵ� ����� ���� ����� ���ؼ��� null �� ��� 0���� ����Ͻÿ�.
select ename, manager, NVL(manager, 0) as "��� ���"--NVL2(manager, manager, 0)
from employee;

--7.decode �Լ��� ���޿� ���� �޿��� �λ��ϵ��� �Ͻÿ�. 
--������ 'accounting'�� ����� 200, 'research'�� ����� 180,
--'sale'�� ����� 150,'operation'�� ����� 100�� �λ��Ͻÿ�.
select eno, ename, dno, salary,
decode (dno,10,salary+200,
            20,salary+180,
            30,salary+150,
            40,salary+100) as "�ӱ� ����"
from employee;

select eno, ename, job, salary,
Decode (job, 'ACCOUNTING', salary+200,
			 'RESEARCH', salary+180,
			 'SALE', salary+150,
			 'OPERATION', salary+100,
			 salary) as "�ӱ� ����"
from employee;

