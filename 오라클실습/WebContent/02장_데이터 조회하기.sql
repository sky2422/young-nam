--<북스-2장_데이터 조회하기>

--이름이 SCOTT 사원의 정보 출력
select * 
from employee
where ename='SCOTT';--where 조건  '문자'

SELECT * 
FROM EMPLOYEE
WHERE ENAME='scott';--문자값은 대소문자 구분함. 결과없음

SELECT * 
FROM EMPLOYEE
WHERE ENAME='SCOTT';--결과나옴

--'1981년 1월 1일 이전에 입사'한 사원만 출력
select * 
from employee
where hiredate < '1981/01/01';--'1 2 3'

--논리연산자
--10번 부서 소속인 사원들 중에서 직급이 MANAGER인 사원 검색
select * 
from employee
where dno=10 AND job='MANAGER';--(자바 &&)

--10번 부서 소속이거나 직급이 MANAGER인 사원 검색
select * 
from employee
where dno=10 OR job='MANAGER';--(자바 ||)

--10번 부서에 소속된 사원만 제외
select * 
from employee
where NOT dno = 10;--NOT 참<->거짓 (자바 !)

select * 
from employee
where dno != 10;--같지않다.다르다. != 오라클은 <> ^=

--급여가 1000~1500사이인 사원 출력
select *
from employee
where salary >= 1000 AND salary <= 1500;

select *
from employee
where salary between 1000 and 1500;

/*
 * 미만 <   이하 <=   초과 >   이상 >=
 */

--급여가 1000미만이거나 1500초과인 사원 검색
select *
from employee
where salary < 1000 OR salary > 1500;

select *
from employee
where salary NOT between 1000 and 1500;

--'1982년'에 입사한 사원 정보 출력
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
where hiredate between '82-01-01' AND '82-12-31';--1982에서 19제외해도 1982로 인식

--커미션이 300이거나 500이거나 1400인 사원 정보 검색
select *
from employee
where commission=300 OR commission=500 OR commission=1400;

select *
from employee
where commission IN(300, 500, 1400);--컬럼명 IN(수,수,수...)

--커미션이 300, 500, 1400이 모두 아닌 사원 정보 검색
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
--이름이 'F로 시작'하는 사원 정보 출력
select *
from employee
where ename LIKE 'F%';
--%:문자가 없거나 하나 이상의 문자가 어떤값이 와도 상관없다.(예)'F', 'Fs', 'FVB'

--이름에 'M이 포함'된 사원 정보 출력
select *
from employee
where ename LIKE '%M%';--(예)'M', 'aM', 'MB', 'AMb'

--이름이 'M으로 끝나는' 사원 정보 출력
select *
from employee
where ename LIKE '%M';--(예)'M', 'aM', 'cccM'

--이름의 '두번째 글자가 A'인 사원 검색
select *
from employee
where ename LIKE '_A%';-- _:하나의 문자가 어떤 값이 와도 상관없다.

--이름의 '세번째 글자가 A'인 사원 검색
select *
from employee
where ename LIKE '__A%';-- _:하나의 문자가 어떤 값이 와도 상관없다.

--이름에 'A가 포함'되는 사원 검색
select *
from employee
where ename LIKE '%A%';

--이름에 'A가 포함되지 않는' 사원 검색
select *
from employee
where ename NOT LIKE '%A%';

------------------------------------
select * from employee;

--commission을 받지 못하는 사원 정보 검색
select *
from employee --자바에서는  =대입연산자 ==같다, SQL에서는 =같다.(비교연산자)
where commission = null;--null 비교연산자로 비교불가하므로 결과안나옴

select *
from employee
where commission IS null;

--commission을 받는 사원 정보 검색
select *
from employee
where commission IS NOT null;

---------------------------------------
--정렬:ASC 오름차순(ASC는 생략가능), DESC 내림차순
--급여가 가장 적은 순부터 출력
select *
from employee
ORDER BY salary ASC;

--급여가 적은 순부터 출력(이 때, 급여가 같으면 commission이 많은 순부터 출력)
select *
from employee
ORDER BY salary ASC, commission DESC;

--급여가 적은 순부터 출력(이 때, 급여가 같으면 commission이 많은 순부터, commission이 같으면 이름을 알파벳순으로 출력)
select *
from employee
--ORDER BY salary ASC, commission DESC, ename ASC;
--ORDER BY salary, commission DESC, ename;--ASC 생략가능
ORDER BY 6 ASC, 7 DESC, 2 ASC;--INDEX번호:SQL 1부터 시작, 자바 0부터 시작
--ORDER BY 6, 7 DESC, 2;

--입사일을 중심으로 오름차순 정렬
select *
from employee
ORDER BY hiredate ASC;

---------------------------------------------------------------

--<혼자 해보기(P65~72)>-----------------------------

--1.덧셈 연산자를 이용하여 모든 사원에 대해서 300의 급여인상을 계산한 후 
--사원의 이름, 급여, 인상된 급여 출력
SELECT ename, salary, salary+300 as "300이 인상된 급여"
FROM employee;

--2.사원의 이름,급여,연간 총수입을 총 수입이 많은 것부터 작은 순으로 출력
--연간 총수입=월급*12+상여금100
SELECT ENAME, salary, salary*12+100 as "연간 총수입"
FROM employee
ORDER BY "연간 총수입" DESC;--내림차순 정렬
--order by 3 desc;--내림차순 정렬

--3.급여가 2000을 넘는 사원의 이름과 급여를 급여가 많은 것부터 작은 순으로 출력
SELECT ENAME, salary
FROM employee
WHERE salary>=2000
ORDER BY salary DESC;

--4.사원번호가 7788인 사원의 이름과 부서번호를 출력
SELECT ENAME, DNO
FROM employee
WHERE ENO LIKE 7788;
--WHERE ENO = 7788;

--5.급여가 2000에서 3000 사이에 포함되지 않는 사원의 이름과 급여 출력
SELECT ENAME, salary
FROM employee
WHERE  salary < 2000 or salary > 3000;

SELECT ENAME, salary
FROM employee
WHERE salary NOT BETWEEN 2000 AND 3000;

--주의: 우선순위 NOT ---> AND ---> OR(자바 ! ---> && ---> ||)
--우선순위를 바꾸는 방법은 ()괄호
select ename, salary
from employee
where NOT(2000<= salary AND salary <=3000);

--5-2. 급여가 2000에서 3000 사이에 포함되는 사원의 이름과 급여 출력
select ename, salary
from employee
where 2000 <= salary AND salary <=3000;

select ename, salary
from employee
where salary between 2000 and 3000;

--주의: 우선순위 NOT ---> AND ---> OR (자바 ! ---> ||)
--우선순위를 바꾸는 방법은()
select ename, salary
from employee
where not (2000 > salary OR salary> 3000);

--6.1981년 2월 20일부터 1981년 5월 1일 사이에 입사한 사원의 이름, 담당업무,입사일 출력
--오라클의 기본날짜 형식은 'YY/MM/DD'
select ename, job, hiredate
from employee
where hiredate between '81/02/20' and '81/05/01';

SELECT ENAME, JOB, HIREDATE
FROM employee
WHERE HIREDATE BETWEEN '1981-02-20' AND '1981-05-01';

SELECT ENAME, JOB, HIREDATE
from employee
where '81/02/20' <=hiredate and hiredate <= '1981-05-01';
--7.부서번호가 20 및 30에 속한 사원의 이름과 부서번호를 출력하되 
--이름을 기준으로 영문자순으로 출력
select ename, dno
from employee
where dno=20 or dno=30
order by ename;--asc 생략가능

select ename, dno
from employee
where dno IN(20,30)
order by ename;

--8.사원의 급여가 2000에서 3000사이에 포함되고 부서번호가 20 또는 30인 사원의 이름, 급여와 부서번호를 출력하되 
--이름순(오름차순)으로 출력
select ename, salary, dno
from employee
where salary between 3000 AND 3000 AND (dno=20 or dno=30 )--우선순위 not
order by ename;

select ename, salary, dno
from employee
where salary between 2000 and 3000 and dno IN(20, 30)--우선순위 있음
order by ename;

--9. 1981년도에 입사한 사원의 이름과 입사일 출력(like연산자와 와일드카드 사용)
SELECT ENAME, HIREDATE
FROM employee
WHERE HIREDATE LIKE '%81%';--'1981%' 결과 안나온다.

--to_char(수나 날짜, '형식')
select ename, hiredate --오라클의 기본 날짜의 형식은 'YY/MM/DD'
from employee
where to_char(hiredate, 'yyyy') like '1981%';--1981, 1981 시작 ~ 결과
--where to_char(hiredate,'yyyy-mm-dd') like '1981%';--결과 안나온다. 

select hiredate,--년 - 월 - 일: 분:초
to_char(hiredate, 'yyyy/mm/dd'),--년/월/일
to_char(hiredate, 'yyyy')--년
from employee;

--10.관리자(=상사)가 없는 사원의 이름과 담당업무
select ename, job
from employee
where manager IS null;

--11.'커미션을 받을 수 있는 자격'이 되는 사원의 이름, 급여, 커미션을 출력하되
--급여 및 커미션을 기준으로 내림차순 정렬
select ename, salary, commission
from employee
where commission IS NOT null
order by salary desc, commission desc;

select ename, salary, commission
from employee
where job = 'SALESMAN'
order by 2 desc, 3 desc;

--12.이름의 세번째 문자가 R인 사원의 이름 표시
SELECT ENAME 
FROM employee
WHERE ENAME LIKE '__R%';

--13.이름에 A와 E를 모두 포함하고 있는 사원이름 표시
SELECT ENAME
FROM employee
WHERE ENAME LIKE '%A%' AND ENAME LIKE '%E%';

--14.'담당 업무가 사무원(CLERK) 또는 영업사원(SALESMAN)'이면서 
--'급여가 1600,950 또는 1300이 아닌' 사원이름, 담당업무, 급여 출력
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

--15.'커미션이 500이상'인 사원이름과 급여, 커미션 출력
SELECT ENAME, SALARY, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION>=500;


