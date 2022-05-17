--<북스-05장_그룹함수> : 하나 이상의 행을 그룹으로 묶어 연산하여 종합, 평균 등 결과를 구함

--★★주의 : count(*) 함수를 제외한 모든 그룹함수들은 null값을 무시
--사원들의 급여 총액, 급여평균액, 급여최고액, 급여최저액 출력
select
sum(salary),
avg(salary),
--trunc(avg(salary)),--정수
max(salary),
min(salary)
from employee;
전체 사원테이블이 대상이면 group by사용안함

--★max(), min()함수는 숫자데이터 이외의 다른 '모든 데이터 유형'에 사용가능
--최근에 입사한 사원과 가장 오래전에 입사한 사원의 입사일을 출력
select 
max(hiredate) as 최근사원, 
min(hiredate) as "오래 전 사원"--별칭이 너무 길어도 오류 발생함듕
from employee;

--1.1 그룹함수와 null값(P145)
--사원들의 커미션 총액 출력
select
sum(commission) as "커미션 총액"
from employee;
--null값과 연산환 결과는 모두 null이 나오지만
--★count(*)함수를 제외한 모든 그룹함수들은 null값을 무시

--1.2 행 개수를 구하는 count함수
--count(*|컬럼명|distinct 컬럼명|(all) 컬럼명) : 행 개수(|는 '또는'을 의미)

--그룹함수 중 count(*)만 null포함하여 행 세기
--전체 사원수
select count(*) as "전체 월급 루팡 수"
from employee;

--커미션을 받는 사원수
--[방법-1]
select count(*) as "커미션을 받는 사원수"
from employee
WHERE commission is not null;

--[방법-2] count(컬럼명) : null제외
select count(commission) as "커미션을 받는 루팡 수"
from employee;

--직업(job)이 어떤 종류?
select job
from employee;

select distinct job--distinct : 중복 제외
from employee;

--직업(job)의 개수 : all
select count(job), count(all job) as "all한 작업수"
from employee;--14 14

select count(commission), count(all commission) as "all한 커미션수", count(*)
from employee;--4 4 14

--직업(job)의 개수 : distinct(중복 제외)
select count(job), count(distinct job) as "중복제외한 작업수"
from employee;--14 5

--★★★★★★★★★1-3.그룹함수와 단순컬럼★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
select ename, max(salary)--다:1
from EMPLOYEE;
--오류? 그룹함수의 결과값은 1개인데,
--그룹함수를 적용하지 않은 컬럼은 겨로가가 여러 개 나올 수 있으므로
--매치시킬 수 없기 때문에 오류발생

--2.데이터 그룹:GROUP BY-특정 컬럼을 기준으로 그룹별로 나눠야 할 경우
--★group by절 뒤에 별칭 사용 못함. 반드시 컬럼명만 기술

--소속 부서별로 평균급여를 부서번호와 함께 출력(부서본호를 기준으로 오름차순 정렬)
select dno, avg(salary)--4 : 4
from employee
group by dno--10 20 30 40 
order by 1;--order by dno asc;

select avg(salary)--부서번호가 없으면 결과가 무의미함
from employee
group by dno;

--오류?group by절에 명시하지 않은 컬럼을 select절에 사용하면 오류(개수가 달라 매치가 불가능하므로)
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
--group by절은 먼저 부서번호를 기준으로 그룹화한 다음
--해당 부서 번호 그룹내에서 직업을 기준으로 다시 그룹화

--3.그룹 결과 제한 : having절 (P152)
--그룹 함수의 결과 중 having절 다음에 지정한 조건에 true인 그룹으로 결과 제한

--'부서별 급여총액이 9000이상'인 부서의 부서번화와 부서별 급여총액 구하기(부서번호로 오름차순 정렬)
select dno, sum(salary)
from employee
--where sum(salary) >= 9000--where 조건=>오류발생? 그룹함수의 조건은 having절에
group by dno
having sum(salary) >= 9000--그룹함수에 조건
order by 1 asc;--정렬

--'MANAGER를 제외'하고 급여총액이 5000이상인 직급별 수와 급여총액 구하기(급여총액을 기준으로 내림차순 정렬)
--[1]. 직급별 급여총액 구하기
select job, count(*), sum(salary)
from employee
group by job;

--[2]. 'MANAGER를 제외'하기--[방법-1]
select job, count(*), sum(salary)
from employee
where job != 'MANAGER'--  !=  ^=  <>
group by job;

--[2]. 'MANAGER를 제외'하기--[방법-2]
select job, count(*), sum(salary)
from employee
where job not like 'MANAGER'
group by job;

--[3]. 급여총액이 5000이상--[방법-1]
select job, count(*), sum(salary)
from employee
where job != 'MANAGER'
group by job
having sum(salary) >= 5000;

--[3]. 급여총액이 5000이상--[방법-2]
select job, count(*), sum(salary) as "급여 총액"
from employee
where job not like 'MANAGER'
group by job
having sum(salary) >= 5000
--order by sum(salary) desc;
--order by 3 desc;
order by  "급여 총액" desc;--별칭으로 정렬 가능

--★★그룹함수는 2번까지 중첩해서 사용가능
--직급별 급여평균의 최고값을 출력
--[1] 직급별 급여평균 구하기
select dno, avg(salary)
from EMPLOYEE
group by dno;

--[2] 직급별 급여평균의 최고값을 출력
select dno, MAX(avg(salary))
from EMPLOYEE
group by dno;
--오류발생(이유?dno 4가지, MAX(avg(salary) 1개이므로 매치불가)

--오류해결
select MAX(avg(salary))
from employee
group by dno;

--★★dno 같이 출력하고 싶다면(서브쿼리 사용)
--[1] 부서별 평균 구하기
select dno, avg(salary)
from EMPLOYEE
group by dno;

--[2] '부서별 평균이 급여평균의 최고값과 같은 것'(조건) 구하기
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

-----[교재에 없는 것]-----------------------------------
--★★rank() : 순위 구하기
--급여 상위 3개 조회 - rank() 함수 사용
--(만약 급여가 같다면 커미션이 높은 순으로 조회, 커미션이 같다면 사원명을 알파벳 순으로 조회)

select ename, salary, commission
from EMPLOYEE;
--아래 sql문으로 해결 못함
select ename, salary, commission
from EMPLOYEE
where rownum <= 3--전체 중 위에서 3줄만 가져옴
order by salary desc, 3 desc;--3=>commission--조회한 후 정렬

--[해결방법]
select ename, salary, commission,
RANK() OVER(order by salary desc) as "급여 순위-1",--1 2 2 4
DENSE_RANK() OVER(order by salary desc) as "급여 순위-2",--1 2 2 3
RANK() OVER(order by salary desc, 3 desc, ename asc) as "급여 순위-3"--1 2 3 4 순위가 중복되지 않도록 하기 위해
from EMPLOYEE;

--'부서'그룹 별 '부서 안에서 각 순위 구하기' :  partition by + 그룹 컬럼명
select dno, ename, salary, commission,
RANK() OVER(partition by dno order by salary desc, 3 desc, ename asc) as "부서별 급여 순위"--순위가 중복되지 않도록 처리함--파티션으로 그룹 분류한뒤 순서 매기기
from employee;


--[문제-2]그룹 별 최소값, 최대값 구하기

--부서그룹 별 최소값, 최대값 구하기
--keep ()함수와 FIRST, LAST키워드를 활용하면 그룹 내에 최소값, 최대값을 쉽게 구할 수 있다.
--DENSE_RANK함수만 사용가능하다.
select max(salary), min(salary)--각 1개의 결과만 나옴
from employee;--전체 사원테이블 최소값 최대값은 각 하나이므로

--dno, ename, salary로 그룹을 만들어 실행하면 각각 1명씩에 대한 급여가 바로 최소이자 최대급여
select dno, ename, salary,
MIN(salary),--그룹함수
MAX(salary)
from employee
GROUP BY dno, ename, salary;--그룹:부서 사원명 급여

--[해결방법-1]
select dno, -- ename, salary, 추가하면 오류 발생(1:n 관계이므로)
MIN(salary) as "부서별 최소 급여",--그룹함수
MAX(salary) as "부서별 최대 급여"
from employee
GROUP BY dno--그룹 : 부서(각 부서는 1개씩만 출력)
order by dno;

--위 방법은 ename, salary를 출력할 수 없다.(1:다 관계이므로)
--[해결방법-2]
select dno, ename, salary,
MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "부서별 최소 급여",
MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "부서별 최대 급여"
from employee
order by dno asc;

--[문제-3]그룹 별 최소값, 최대값 구하기+ 전체급여 순위 구하기(같은 급여는 같은 등수 ex. 1 2 2 4)
select dno, ename, salary,
MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "부서별 최소 급여",
MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "부서별 최대 급여",
RANK() OVER(order by salary desc) as "급여 순위-1"--1 2 2 4
from employee
order by dno asc;

--<5장 그룹함수-혼자해보기>-----------------------------

--1.모든 사원의 급여 최고액, 최저액, 총액 및 평균 급여를 출력하시오.
--컬럼의 별칭은 결과 화면과 동일하게 저장하고 평균에 대해서는 정수로 반올림하시오.
select 
max(salary) as "급여 최고액",
min(salary) as "급여 최저액",
sum(salary) as "급여 총액",
round(avg(salary)) as "평균 급여"--소수 첫째 자리에서 반올림하여 정수로 출력
from employee;

--2.각 담당 업무 유형별로 급여 최고액, 최저액, 총액 및 평균액을 출력하시오.
--컬럼의 별칭은 결과 화면과 동일하게 저장하고 평균에 대해서는 정수로 반올림하시오.
select job, --추가하여 결과가 무의미해지지 않도록 함
max(salary) as "급여 최고액",
min(salary) as "급여 최저액",
sum(salary) as "급여 총액",
round(avg(salary)) as "평균 급여"
from employee
group by job;

--3.count(*)함수를 이용하여 담당 업무가 동일한 사원 수를 출력하시오.
select job as "담당 업무", count(*) as "사원 수"
from employee
group by job;

--4.관리자(=manager : 컬럼명)수(count())를 나열하시오. 
--컬럼의 별칭은 결과 화면과 동일하게 지정하시오.
--count(컬럼명) : 수 세기( null제외)
select count(manager) as "관리자 수"
from employee;

--'MANAGER'의 수 ?
select job, count(*) as "사원 수" --1:1
from employee
where job='MANAGER'--'MANAGER'('대문자'로 입력)
group by job;

--부서별 'MANAGER'의 수?
select dno, count(*) as "사원 수" --1:1
from employee
where job='MANAGER'
group by dno;

--5.급여 최고액, 급여 최저액의 차액을 출력하시오. 
--컬럼의 별칭은 결과 화면과 동일하게 지정하시오. 
select 
max(salary) as "급여 최고액",
min(salary) as "급여 최저액",
max(salary) - min(salary) as "급여 차액"
from employee;

--6.직급별 사원의 최저 급여를 출력하시오. 
--'관리자를 알 수 없는 사원' 및 '최저 급여가 2000 미만'인 그룹은 '제외'시키고 
--결과를 급여에 대한 내림차순으로 정렬하여 출력하시오. 
[1]
select job, min(salary) as "최저 급여"
from employee
group by job;
--[2]where+'관리자를 알 수 없는 사원(=null)' 및 having+'최저 급여가 2000 미만'인 그룹은 '제외'
--방법-1
select job, min(salary) as "최저 급여"
from employee
where manager is not null
group by job
having min(salary)>=2000--그룹함수 조건
order by 2 desc;

--방법-2
select job, min(salary) as "최저 급여"
from employee
where manager is not null
group by job
having not min(salary)<2000--그룹함수 조건
order by "최저 급여" desc;

--7.각 부서에 대해 부서번호, 사원수, 부서 내의 모든 사원의 평균 급여를 출력하시오. 
--컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균 급여는 소수점 둘째 자리로 반올림하시오. 
select dno, count(eno) as "각 부서의 사원수", 
round(avg(salary),2) as "평균 급여"
from employee
group by dno;

--★★7번 문제에 추가(★단, 테이블을 조회하기 전에 salary의 null여부를 모른 상태에서 조회한다면)
--사실 avg(salary)는 null제외하고 평균 구함. 
--그래서 null값 급여를 받는 사원이 있다면 그 사원을 제외하고 평균을 구함
--그러나 null값 급여를 받는 사원도 함께 포함시켜 평균을 계산하려면 
--반드시 null처리함수 사용하여 구체적인 값으로 변경
select dno, count(eno) as "각 부서의 사원수", 
round(avg(NVL(salary,0)),2) as "평균 급여"
from employee
group by dno;

--[추가문제]'커미션을 받는 사원들만의 커미션 평균'과 '전체 사원의 커미션 평균' 구하기
select 
avg(commission) as "커미션o-커미션 평균", 
avg(nvl(commission,0)) as "전체 커미션 평균"
from EMPLOYEE;

--8.각 부서에 대해 부서번호 이름, 지역명, 사원수, 부서내의 모든 사원의 평균 급여를 출력하시오. 
--컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균 급여는 정수로 반올림하시오.
select dno,
decode(dno,10,'ACCOUNTING',
		   20,'RESEARCH',
		   30,'SALES',
		   40,'OPERATIONS') AS "부서이름",
decode(dno,10,'NEW YORK',
		   20,'DALLAS',
		   30,'CHICAGO',
		   40,'BOSTON') AS "지역명",
sum(salary) as "부서별 급여 총액",
count(*) as "부서별 사원수", 
round(avg(salary)) as "부서별 평균급여-1",--null 급여받는 사원제외
round(avg(nvl(salary, 0))) as "부서별 평균급여-2"--null 급여받는 사원 포함
from employee
group by dno
order by 1;

--join이용한 방법-1 : ~where 별칭 사용  
select d.dno, dname as "부서이름", loc as "지역명",
sum(salary) as "부서별 급여 총액",
count(*) as "부서별 사원수", 
round(avg(salary)) as "부서별 평균급여-1",--null 급여받는 사원제외
round(avg(nvl(salary, 0))) as "부서별 평균급여-2"--null 급여받는 사원 포함
from employee e , department d
where e.dno=d.dno--조인조건
group by d.dno, dname, loc
order by 1;

--join이용한 방법-2 : join~on 별칭 사용
select e.dno, dname as "부서이름", loc as "지역명",
sum(salary) as "부서별 급여 총액",
count(*) as "부서별 사원수", 
round(avg(salary)) as "부서별 평균급여-1",--null 급여받는 사원제외
round(avg(nvl(salary, 0))) as "부서별 평균급여-2"--null 급여받는 사원 포함
from employee e join department d
on e.dno=d.dno--조인조건
group by e.dno, dname, loc
order by 1;

--join이용한 방법-3 : natural join은 중복컬럼 제거(dno 1개 제외) 별칭 사용안함.
select dno, dname as "부서이름", loc as "지역명",
sum(salary) as "부서별 급여 총액",
count(*) as "부서별 사원수", 
round(avg(salary)) as "부서별 평균급여-1",--null 급여받는 사원제외
round(avg(nvl(salary, 0))) as "부서별 평균급여-2"--null 급여받는 사원 포함
from employee natural join department
group by dno, dname, loc
order by 1;

--9.업무를 표시한 다음 해당 업무에 대해 부서번호별 급여 및 부서 10, 20, 30의 급여 총액을 각각 출력하시오.
--각 컬럼에 별칭은 각각 job, 부서 10, 부서 20, 부서 30, 총액으로 지정하시오.
select job, dno,
decode(dno, 10, sum(salary), 0) as "부서10",
decode(dno, 20, sum(salary)) as "부서20",
decode(dno, 30, sum(salary)) as "부서30",
sum(salary) as "총액"
from employee
group by job, dno
order by dno;










