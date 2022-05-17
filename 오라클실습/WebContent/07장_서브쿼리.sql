--<북스-07장_서브쿼리>

--[문제]'SCOTT'보다 급여를 많이 받는 사원의 사원명과 급여 조회
--[1]. 우선 'SCOTT'의 급여를 알아야 함
select salary
from employee
where ename='SCOTT';--3000

--[2]. 해당급여 3000보다 급여가 많은 사원 검색
select ename, salary
from employee
where salary > 3000;

--[2] 메인쿼리 -[1] 서브쿼리
select ename, salary
from employee
where salary > (select salary
				from employee
				where ename='SCOTT');
				--서브쿼리에서 실행한 결과(3000)가 메인쿼리에 전달되어 최종 결과를 출력

--단일 행 서브쿼리 : 내부서브쿼리문의 결과가 행 '1개'
--			      단일행 비교연산자(>,=,>=,<=), IN연산자
--			   (예) salary>3000		salary=3000와 salary IN(3000)는 같은 표현
--다중 행 서브쿼리 : 내부서브쿼리문의 결과가 행 '1개 이상'
--			      다중행 비교연산자(IN, any, some, all, exists)
--			   (예) salary IN(1000, 2000, 3000)

--1. 단일 행 서브쿼리
--[문제] 'SCOTT'과 동일한 부서에서 근무하는 사원이름, 부서번호 조회
select ename, dno
from employee
where dno = (select dno
			 from employee
			 where ename='SCOTT');--서부쿼리 결과 : 1개
			 
select ename, dno
from employee
where dno IN (select dno
			 from employee
			 where ename='SCOTT');--서브쿼리 결과 : 여러개라도 가능

--위 결과에는 'SCOTT'도 함께 조회됨. 'SCOTT'은 제외하고 조회하려면
select ename, dno
from employee
where dno = (select dno
			 from employee
			 where ename='SCOTT')
AND ename != 'SCOTT';--조건 추가

select ename, dno
from employee
where dno = 20
AND ename != 'SCOTT';--조건 추가

--[문제] 회사 전체에서 최소 급여를 받는 사원의이름, 담당업무(JOB), 급여 조회
--[1] 최소급여 구하기
select MIN(salary)
from employee;--800
--[2] 구한 최소급여(800)를 받는 사원의이름, 담당업무(JOB), 급여 조회
select ename, job, salary
from employee
where salary = (select MIN(salary)
				from employee);--800도 가능 -- 서브쿼리 결과 1개
--where salary = 800;
				
select ename, job, salary
from employee
where salary in (select MIN(salary)
				from employee);
--where salary IN(800);

--2. 다중 행 서브쿼리
--1) IN 연산자: 메인쿼레의 비교조건에서 서브쿼리의 출력결과와 '하나라도 일치하며' 
--      		메인쿼리의 where 절이  true
--★단일 또는 다중 행 서브쿼리에 둘 다 사용 가능함

--[문제] ★★★"부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
--[방법-1]
--[1] "부서별 최소급여"구하기(dno까지 표시)
select MIN(salary)
from employee
group by dno;--최종결과라면 이 결과가 무의미하다.

--[2] ★★★'부서별 최소급여'를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
select dno, eno, ename, salary
from employee
where (dno, salary) in (select dno, MIN(salary)--IN(1300, 800, 950)
				  from employee
				  group by dno)
ORDER BY 1;		
				
--[문제] "부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
--[방법-2]
--[1] "부서별 최소급여"구하기(dno까지 표시)
select dno, MIN(salary)-- (10, 20, 30)
from employee
group by dno;--(10, 1300),(20, 800),(30, 950) 결과가 무의미하다 해서 dno 붙이기

--[2-1]서브쿼리 이용: ★★★'부서별 최소급여'를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
select dno, eno, ename, salary
from employee
where (dno, salary) IN (select dno, MIN(salary)--IN((10, 1300),(20, 800),(30, 950))의 모양을 (dno, salary) 모양 만들어주기
				  from employee
				  group by dno)
ORDER BY 1;		

--[2-2]조인방법-1 이용
--[방법-1]
select *
from employee e1, (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno--조인조건
AND e1.salary=e2.minsalary
ORDER BY 1;

--[방법-2]
select e1.dno, eno, ename, salary
from employee e1, (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno--조인조건
AND e1.salary="minsalary"
ORDER BY 1;
--[2-3] 조인방법-2 이용
select e1.dno, eno, ename, salary
from employee e1 join (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) e2
on e1.dno = e2.dno--조인조건
where e1.salary="minsalary"
ORDER BY 1;

--[2-4] 조인방법-3 이용 (natural join): dno로 자연조인 ---> 별칭 필요없다.
select dno, eno, ename, salary
from employee natural join (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) 
where salary="minsalary"
ORDER BY dno;

--[2-4] 조인방법-4 중복제거 ---> 별칭 필요없다.
select dno, eno, ename, salary
from employee join (select dno, min(salary) AS "minsalary"
					from employee
					group by dno) 
USING (dno)					
where salary="minsalary"
ORDER BY dno;

-----------------------------------------------------------------------------

--[위 문제 '방법-1'의 쿼리에서 'min(salary) 출력' 하려면]
select dno, eno, ename, salary, min(salary)--"그룹함수 출력" 하려면
from employee
where (dno, salary) in (select dno, MIN(salary)--IN(1300, 800, 950)
				  from employee
				  group by dno)-- (1300. 800, 950)
group by dno, eno, ename, salary--group by 절 뒤에 반드시 출력할 컬럼들 나열(그룹함수 제외)			  
ORDER BY 1;		

select dno, min(salary)--14:1
from employee;--오류? 전체 사원테이블이 대상이면 group by사용안함(이유:전체가 하나의 그룹이므로
--그룹함수를 출력하려면

--[위 문제의 '방법-1'의 쿼리를 도출하기 위해 단계적으로 실행]
--차근 차근 한 단계
--단계-1
select min(salary)--전체사원테이블 대상이므로 1그룹:1 
from employee;

--단계-2
select dno, min(salary)--dno 3그룹 : 3
from employee
group by dno
order by 1;

--단계-3
select dno, eno, ename, salary, min(salary)--dno 3그룹 : 3
from employee
group by dno, eno, ename, salary
order by 1;

--단계-4
select dno, eno, ename, salary, min(salary)--dno 3그룹 : 3
from employee
where salary in(1300, 800, 950)--검색조건
group by dno, eno, ename, salary
order by 1;
--단계-4랑 같은 것이다. IN의 값의 차이만 있다. (두 식 다 같은 값이다.)
select dno, eno, ename, salary, min(salary)--"그룹함수 출력" 하려면
from employee
where (dno, salary) in (select dno, MIN(salary)--IN(1300, 800, 950)
				  from employee
				  group by dno)-- (1300, 800, 950)
group by dno, eno, ename, salary--group by 절 뒤에 반드시 출력할 컬럼들 나열(그룹함수 제외)			  
ORDER BY 1;		
---------------------------------------------------------------------------------
--2) ANY 연산자: 서브쿼리가 변환하는 각각의 값과 비교
--where 컬럼명       IN(서브쿼리의 결과1, 결과2...)---> 결과들 중 아무거나와 같다.
--where 컬럼명 = any(서브쿼리의 결과1, 결과2...)---> 결과들 중에아무거나와 같다.

--정리: A조건 OR B조건
--where 컬럼명 < any(서브쿼리의 결과1, 결과2...)---> 결과들 중 "최대값"보다 작다.
--where 컬럼명 > any(서브쿼리의 결과1, 결과2...)---> 결과들 중 "최소값"보다 작다.

--[문제] ★★★"부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
--[2-5] = ANY 이용
--[1] "부서별 최소 급여"구하기
select dno,MIN(salary)
from employee
group by dno;--최종결과라면 이 결과가 무의미하다.

--[2] ★★★'부서별 최소급여'를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
select dno, eno, ename, salary
from employee
where (dno, salary) =ANY (select dno, MIN(salary)
				 			 from employee
				 			 group by dno)
ORDER BY 1;		

--정리: where(dno, salary) = ANY((10, 1300), (20, 800), (30, 950))
--정리: where(dno, salary)    IN((10, 1300), (20, 800), (30, 950))
--서브쿼리의 결과 중 아무거나와 같은 것

--정리: where(dno, salary)  not IN((10, 1300), (20, 800), (30, 950))
--정리: where(dno, salary)  != ANY((10, 1300), (20, 800), (30, 950))
--정리: where(dno, salary) <>= ANY((10, 1300), (20, 800), (30, 950)) 
--정리: where(dno, salary)  ^= ANY((10, 1300), (20, 800), (30, 950))
--서브쿼리의 결과 중 어느것도 아니다.

--정리: where salary not IN(1300, 800, 950)
--정리: where salary  != ANY(1300, 800, 950)
--정리: where salary <>= ANY(1300, 800, 950)
--정리: where salary ^= ANY(1300, 800, 950)
--서브쿼리의 결과 중 어느것도 아니다.

--정리: where salary < any(1300, 800, 950) 서브쿼리 결과 중에 '최대값(1300)'보다 작다.
--정리: where salary > any(1300, 800, 950) 서브쿼리 결과 중에 '최소값(800)'보다 작다.
--(예1)
select eno, ename, salary
from employee
where salary < ANY(1300, 800, 950)
order by 1;
-- 	  salary < ANY(1300, 800, 950)
--    salary < 1300
-- 	  salary < 800
-- 	  salary < 950
-- 결국 salary < 1300(최대값)의 범위가 나머지 범위를 다 포함한다.

--(예2)
select eno, ename, salary
from employee
where salary > ANY(1300, 800, 950)
order by 1;
-- 	  salary > ANY(1300, 800, 950)
--    salary > 1300
-- 	  salary > 800
-- 	  salary > 950
-- 결국 salary > 800(최소값)의 범위가 나머지 범위를 다 포함한다.

--[12월 27일]

--[문제] 직급이 SALESMAN이 아니면서
--급여가 임의의 SALSEMAN보다 낮은 사원의 정보(사원이름, 직급, 급여) 출력(임의의=최소)
--[1].직급이 SALSEMAN의 급여 구하기
select DISTINCT salary--결과 1600 1250 1250 1500 중복제거 전의 값
from employee
where job='SALESMAN';--결과 1250 1600 1500

--[2].
select ename, job, salary
from employee
where job!='SALESMAN' AND salary<ANY(select DISTINCT salary
									from employee
									where job='SALESMAN');
							-- salary < ANY(1250, 1600, 1500)의 서브쿼리결과 중 '최대값'보다 작다.

--위 결과를 검증
--[1]. 직급이 SALESMAN의 최대 급여 구하기
select MAX(salary)-- MAX는 그룹함수이다.--1600
from employee
where job='SALESMAN';

--[2]
select ename, job, salary--결과 1300 1250 1250 1500 중복제거
from employee
where job!='SALESMAN' AND salary<(select MAX(salary)
									from employee
									where job='SALESMAN');
--	job!='SALESMAN'
--	job^='SALESMAN'
--	job<>'SALESMAN'
--	job NOT like='SALESMAN'
-- 다 같은 것들이다.
---------------------------------------------------------------------------------

--3) ALL연산자: 서브쿼리에서 반환되는 모든 값과 비교
--정리: A조건 AND B조건 -여러조건을 동시에 만족
--where salary > ALL(결과1, 결과2,...) 쿼리 결과 중 '최대값'보다 크다.
--where salary < ALL(결과1, 결과2,...) 쿼리 결과 중 '최소값'보다 작다.

									
--[문제] 직급이 SALESMAN이 아니면서
--급여가 모든 SALSEMAN보다 낮은 사원의 정보(사원이름, 직급, 급여) 출력(모든=모두 동시에 만족)
--[1].직급이 SALSEMAN의 급여 구하기
select DISTINCT salary--결과 1600 1250 1250 1500 중복제거 전의 값
from employee
where job='SALESMAN';--결과 1250 1600 1500

--[2].
select ename, job, salary
from employee
where job!='SALESMAN' AND salary<ALL(select DISTINCT salary
									from employee
									where job='SALESMAN');
							-- salary < ALL(1250, 1600, 1500)의 서브쿼리결과 중 '최소값'보다 작다.

--위 결과를 검증
--[1]. 직급이 SALESMAN의 최소 급여 구하기
select MIN(salary)-- MIN는 그룹함수이다.--1250
from employee
where job='SALESMAN';

--[2]
select ename, job, salary
from employee
where job!='SALESMAN' AND salary<(select MIN(salary)
									from employee
									where job='SALESMAN');--800, 1100, 950	
---------------------------------------------------------------------------------								
--4) EXISTS 연산자: EXISTS =존재하다.
select 
from 
where EXISTS (서브쿼리);-- 컬럼명 없이 이런 양식이다.				
--서브쿼리에서 구해진 데이터가 1개라도 존재하면 		true ---> 메인 쿼리 실행
--서브쿼리에서 구해진 데이터가 1개라도 존재하지 않으면 false ---> 메인 쿼리 실행 불가
				
select 
from 
where NOT EXISTS (서브쿼리);-- 컬럼명 없이 이런 양식이다.				
--서브쿼리에서 구해진 데이터가 1개라도 존재하지 않으면 true ---> 메인 쿼리 실행
--서브쿼리에서 구해진 데이터가 1개라도 존재하면 		false ---> 메인 쿼리 실행 불가
				
--[문제-1] 사원테이블에서 직업이 'PRESIDENT'가 있으면 모든 사원이름을 출력, 없으면 출력안함
--★문제의 뜻: 조건을 만족하는 사원이 있으면 메인쿼리를 실행하여 결과를 출력
				
--[1].사원테이블에서 직업이 'PRESIDENT'인 사원의 사원번호 조회
select eno--7839
from employee
where job='PRESIDENT';

--[2]		
select ename
from employee
where EXISTS (select eno
			  from employee
			  where job='PRESIDENT');--14명 출력	

--위 문제를 테스트하기 위해 직업이 'PRESIDENT'인 사원 삭제 후 다시 [2] 실행해보면 결과 도출 안나온다.			
delete
from employee
where job='PRESIDENT';-- 삭제 후 [2] 실행하면 아무것도 출력이 안나온다. 오류는 아니다.

--다시 되돌리기는 1장 오라클과 데이터베이스에서 실행하기

--[위 문제에 job='SALESMAN' 추가함]				
--조건을 AND 연결: 두 조건이 모두 참이면 참	
select ename
from employee
where job='SALESMAN'AND EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--4명 출력	
--결과: 4명 AND 14명 ---> 4명 			  					
				
--조건을 OR 연결: 두 조건이 하나만 참이면 참 	
select ename
from employee
where job='SALESMAN'OR EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--14명 출력	
--결과: 4명 OR 14명 ---> 14명

			  					--[NOT EXISTS]					
--조건을 AND 연결: 두 조건이 모두 참이면 참	
select ename
from employee
where job='SALESMAN'AND NOT EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--0명 출력	둘 다 참이어야 하는데 하나가 거짓이므로 0이 출력
--결과: 4명 AND 0명 ---> 0명
--조건을 OR 연결: 두 조건이 하나만 참이면 참 	
select ename
from employee
where job='SALESMAN'OR NOT EXISTS (select eno
			  					from employee
			  					where job='PRESIDENT');--4(=0+4)명 출력	OR과 AND의 차이
--결과: 4명 OR 0명 ---> 4명


--[문제-1] 사원테이블에서 직업이 'PRESIDENT'가 없으면 모든 사원이름을 출력, 없으면 출력안함
--★문제의 뜻: 조건을 만족하는 사원이 있으면 메인쿼리를 실행하여 결과를 출력
--[방법-1] EXISTS 사용
--[1].사원테이블에서 직업이 'PRESIDENT'인 사원의 사원번호 조회
select eno
from employee
where job='PRESIDENT';--결과: 1이 14줄 출력(employee의 row수 만큼)

--[2]		
select ename
from employee
where NOT EXISTS (select eno
			  	  from employee 
			      where job='PRESIDENT');--0명 출력
			  
--[과제-1]:사원테이블과 부서테이블에서 동시에 없는 부서번호, 부서이름 조회	
select 1
from employee;--결과: 1이 14줄 출력(employee의 row수 만큼)

--[1]
select dno, dname
from department d
where EXISTS (select dno--dno를 1로 아님 dno,1로 두가지 방법 모두 정상적인 출력이 가능하다.
                  from employee e
                  where d.dno = e.dno);
--[2]
select dno, dname
from department d
where NOT EXISTS (select dno
                  from employee e
                  where d.dno = e.dno);

select dno, dname
from department --department d의 d는 있어야 한다.
where NOT EXISTS (select dno--10 20 30의 NOT은 40
                  from employee --employee e를 생략가능한다. 별칭사용 안해도 된다.
                  where d.dno = e.dno);--e.dno e를 생략가능한다.
 
--[방법-2], [방법-3]은                 
--EMPLOYEE의 dno가 department의 dno를 references를 아는 전제 하에서
--즉, EMPLOYEE의 dno가 참조하는 dno는 반드시 department에서는 dno로 존재해야한다. 는 사실을 아는 전제하에서 문제 풀이                  
--[방법-2] MINUS 사용  
--[1]
select dno, dname
from department;--10 20 30 40
--[2]
select DISTINCT d.dno, dname
from EMPLOYEE e,department d
where e.dno(+) = d.dno;

--[3] {10 20 30 40} - {10 20 30} = {40}의 원리 이용
--이름은 달라져도 되지만 타입은 같아야 한다.
select dno, dname
from department

MINUS

select DISTINCT e.dno, dname
from EMPLOYEE e,department d
where e.dno = d.dno;

--[방법-3] JOIN 방법-1 사용  
--EMPLOYEE의 dno가 department의 dno를 references를 아는 전제 하에서
--EMPLOYEE의 dno가 참조하는 dno가 반드시 department에서는 dno로 존재
--[1]
select DISTINCT e.dno, dname
from EMPLOYEE e,department d
where e.dno = d.dno;--10 20 30(동시에)

--[2]
select DISTINCT d.dno, dname--e.dno하면 10 20 30만 출력
from EMPLOYEE e,department d
where e.dno(+) = d.dno;--10 20 30(동시에)+부서테일블에 있는 40까지 조회하기 위해서

--[3-1]
select DISTINCT d.dno, dname
from EMPLOYEE e,department d
where e.dno(+) = d.dno AND d.dno NOT IN (10, 20, 30);
--[3-2]
select DISTINCT d.dno, dname--DISTINCT 생략 가능
from EMPLOYEE e,department d
where e.dno(+) = d.dno AND d.dno NOT IN (select DISTINCT dno from EMPLOYEE);
--[3-3]
select DISTINCT d.dno, dname
from EMPLOYEE e,department d
where e.dno(+) = d.dno AND d.dno != ALL (select DISTINCT dno from EMPLOYEE);

--<7장서브쿼리-혼자해보기>-----------------------------

--1.사원번호가 7788인 사원과 '담당업무가 같은' 사원을 표시(사원이름과 담당업무)
--[1]. 사원번호가 7788인 사원인 담당업무 조회
select job
from employee
where eno = 7788;--ANALYST이 출력
--[2-1] 
select ename, job
from employee
where job = (select job-- =은 서브쿼리과 1개
             from employee
             where eno = 7788);
--[2-2]
select ename, job
from employee
where job IN (select job--IN: 서브쿼리 결과 1개이상
             from employee
             where eno = 7788);           
--[2-3]
select ename, job
from employee
where job = ANY (select job--ANY: 서브쿼리 결과 1개이상
             from employee
             where eno = 7788);             
--[2-4]
select ename, job
from employee
where job = ALL (select job--ANY: 서브쿼리 결과 1개이상
             from employee
             where eno = 7788); 
             
--2.사원번호가 7499인 사원보다 급여가 많은 사원을 표시(사원이름과 담당업무)
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
               
--3.최소급여를 받는 사원의 이름, 담당 업무 및 급여 표시(그룹함수 사용)
--[1].사원테이블에서 최소급여 조회
select min(salary)
from employee;--800
--[2]
select ename, job, salary
from employee
where salary = (select min(salary)-- =대신  IN, =ANY =ALL 사용가능
                from employee);
              
--4.'직급별' 평균 급여가 가장 적은 담당 업무를 찾아 '직급(job)'과 '평균 급여' 표시
--단, 평균의 최소급여는 반올림하여 소수1째자리까지 표시
--[방법-1]
--[1] '직급별' 평균 급여 중 가장 적은 평균급여를 구한다.
--먼저, 사원전체의 평균급여 구하기
select avg(salary), ROUND(avg(salary),1)--소수 두번째 자리에서 반올림하여 소수 첫번째자리까지 표시
from employee;

--사원전체의 평균급여의 최소값 구하면
select MIN(avg(salary))
from employee;--오류발생---> avg(salary)의 결과 1개에 대한 MIN(최소값)이나 MAX(최소값)를 구하는 것은 모호하기 때문이다.

select job, avg(salary)--5:5
from employee
GROUP BY job;

--job(5):MIN(avg(salary)) = 5:1 매치가 안되서 오류 발생한다. 
 select job, MIN(avg(salary))
from employee
GROUP BY job;

--[위 오류를 해결하기 위해 job조회에서 제거]
--★★ 그룹함수는 최대 2개까지만 중첩허용
--그룹함수: MIN, MAX, AVG
--ROUND는 그룹함수가 아니다.
--[1]
select MIN(avg(salary)), ROUND(MIN(avg(salary)),1)--1037.5 1037.5
from employee
GROUP BY job;
--[2]
select round(MIN(AVG(salary)),1)--1037.5
from employee
GROUP BY job;
--[최종-1]
select job, AVG(salary),round(AVG(salary),1)--평균급여
from employee
GROUP BY job--해당되는 그룹의 평균
HAVING round(AVG(salary),1) = (select round(MIN(AVG(salary)),1)
								from employee
								GROUP BY job);

--[방법-2]: 단, 작업별 평균 급여가 다를 때만 가능								
--[1]
select job, avg(salary)
from employee
GROUP BY job
ORDER BY avg(salary) ASC;--정렬: 가장 적은 평균급여가 1번째 줄에 표시					
--[2]
select *
from(select job, avg(salary)
		from employee
		GROUP BY job
		ORDER BY avg(salary) ASC)
WHERE rownum =1;-- 조건: 1번재 줄만 표시
--원하는 결과는 나오지만 만약 평균급여가 같으면 사용 불가능


--[방법1]
select job, round(avg(salary),1)
from employee
group by job
having round(avg(salary),1) <= ALL(select round(avg(salary),1)
                          from employee
                          group by job);
--[방법2]
select job, round(avg(salary),1)
from employee
group by job
having round(avg(salary),1) = (select round(MIN(avg(salary)),1)
                      from employee
                      group by job);

--5.각 부서의 최소 급여를 받는 사원의 이름, 급여, 부서 번호 표시
--[방법-1]
--[1].각 부서의 최소급여 구하기
select dno, MIN(salary)
from employee
group by dno;--결과가 여러개 나옴          
--[2]
select ename, salary, dno
from employee
where (dno, salary) IN (select dno, MIN(salary)
						from employee
						group by dno);

--[방법-2]
--[1].부서별  최소급여 구하기
select MIN(salary)
from employee
group by dno;--950 800 1300                      
--[2]                      
select ename, salary, dno
from employee
where salary IN (select MIN(salary)
						from employee
						group by dno);

--[방법1]
select ename, salary, dno
from employee
where salary = ANY(select min(salary)
                   from employee
                   group by dno);
--[방법2]
select ename, salary, dno
from employee
where salary IN(select min(salary)
                from employee
                group by dno);

--6.'담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 업무가 분석가가 아닌' 
--사원들을 표시(사원번호, 이름, 담당 업무, 급여)
--[1]'담당 업무가 분석가(ANALYST)인 사원구하기
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

--★★7.부하직원이 없는 사원이름 표시(먼저 '문제 8. 부하직원이 있는 사원이름 표시'부터 풀기)
select * from employee;

--방법-1: 서브쿼리    
--방법-1-1: IN연산자          
--방법-1-1-1                     
--[1].부하직원이 있는 사원번호 찾기:6명                                  
select manager--13명 중에 중복을 제거하기
from employee
where manager IS NOT NULL;

select DISTINCT manager--중복제거 후 6명 출력 1명이상의 부하직원을 가지고 있다.
from employee
where manager IS NOT NULL;

--[2]: 부하직원이 없는 사원 8명
select ename
from employee
where eno NOT IN(select DISTINCT manager
				from employee
				where manager IS NOT NULL);
select ename
from employee
where eno NOT IN(7839, 7782, 7698, 7902, 7566, 7788);
-- 위 아래식 같은 값 출력
	
--방법-1-1-2
--[1].부하직원이 있는 사원번호	찾기 -NVL함수로 NULL값을 0으로 만들어 출력
select DISTINCT NVL(manager,0)
from employee;--0포함 7개가 나옴

--상사사원번호(manager 컬럼)에 자신의 사원 번호(eno)가 없으면 부하직원이 없는 사원이 됨
--서브쿼리의 결과 중에 NULL이 있으면 결과가 안나옴
select ename
from employee
where eno NOT IN(select DISTINCT manager
					from employee);
--NVL 제거하면 오류는 아니지만 결과가 안나옴
--★위 문제를 해결하기 위해--->NVL로 NULL값을 처리
select ename
from employee
where eno NOT IN(select DISTINCT NVL(manager,0)
					from employee);

select ename
from employee
where eno NOT IN(7839, 7782, 7698, 7902, 7566, 7788, 0);
                                 
--방법-1-2(잘못된 방법): ANY 연산자  - '결과가 14명 모두 나온다.'
select ename
from employee
where eno !=ANY(select DISTINCT NVL(manager,0)
					from employee);
-- eno !=7839 아닌 사원 13명
-- eno !=7882 아닌 사원 13명...                 
--eno !=0 	    아닌 사원 14명             
--합집합: 중복 제외하고 모두 나열하면 14명이 결과로 나온다.	

--방법-2: SELF JOIN
select*
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;

--[2] {부하직원이 없는 사원}={모든사원} - {부하직원이 있는 사원}
select eno, ename
from employee

MINUS

select DISTINCT m.eno, m.ename--부하직원
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;
					
select ename
from employee
where ename != ALL(select ename
                   from employee
                   where eno = ANY(select manager
                                   from employee));				
--★★8.부하직원이 있는 사원이름 표시
select *from employee;

--방법-1: 서브쿼리    
--방법-1-1: IN연산자                               
--[1].부하직원이 있는 사원번호 찾기                                  
select manager--13명 중에 중복을 제거하기
from employee
where manager IS NOT NULL;

select DISTINCT manager--중복제거 후 6명 출력 1명이상의 부하직원을 가지고 있다.
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
-- 위 아래식 같은 값 출력

--방법1-2: ANY 연산자(eno=7839 합집합 eno=7782 합집합 eno=7698 ....합집합 eno=7788)
--합집합: 각각 만족하는 조건의 결과를 다 합침
select ename
from employee
where eno = ANY(select distinct manager
				from employee
				where manager IS NOT NULL);
				
--방법1-3(잘못된 방법):OR 연산자-'결과가 없다'(eno=7839 교집합 eno=7782 교집합 eno=7698 ....교집합 eno=7788)
--교집합: 모든 조건의 결과를 동시에 만족하는 것들
select ename
from employee
where eno = ALL(select distinct manager
				from employee
				where manager IS NOT NULL);
--교집합이라 동시 만족하는 것이 없으므로 결과가 없다.				

--방법-2: SELF JOIN
--방법-2-1 JOIN 방법 1 == , where
select*
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;

select DISTINCT e.manager, m.eno, m.ename
from employee e, employee m	
where e.manager=m.eno
ORDER BY 1 ASC;

--방법-2-2 JOIN 방법 2 == JOIN ON
select DISTINCT e.manager, m.eno, m.ename
from employee e JOIN employee m	
ON e.manager=m.eno
ORDER BY 1 ASC;

--[방법1]
select ename
from employee
where eno = ANY(select manager
                from employee);
--[방법2]
select ename
from employee
where eno IN(select manager
             from employee);

--9.BLAKE와 동일한 부서에 속한 사원이름과 입사일을 표시(단,BLAKE는 제외)
--[1].BLAKE와 동일한 부서번호 구하기
select dno
from employee
where ename = 'BLAKE';--1개인 DNO가 30이 출력
--[2]
select ename, hiredate
from employee
where dno IN (select dno
             from employee
             where ename = 'BLAKE')
	AND ename != 'BLAKE';--반드시 'BLAKE제외' 조건 추가
 
--10.급여가 평균 급여보다 많은 사원들의 사원번호와 이름 표시(결과는 급여에 대해 오름차순 정렬)
--[방법1]
--[1] 사원 테이블에서 평균 급여 구하기
select avg(salary)
from employee;
--[2]
select eno, ename
from employee
where salary > (select avg(salary)
                from employee)
order by salary;

--11.이름에 K가 포함된 사원과 같은 부서에서 일하는 사원의 사원번호와 이름 표시
--[방법1]
--[1]이름 K가 포함된 사원과 같은 부서번호 구하기
select dno
from employee 
where ename like '%K%';
--[2]
select eno, ename
from employee
where dno IN(select dno
             from employee 
             where ename like '%K%');
--[방법2]
select eno, ename
from employee
where dno = ANY(select dno
                from employee 
                where ename like '%K%');

--12.부서위치가 DALLAS인 사원이름과 부서번호 및 담당 업무 표시
--[방법1]
--[1]부서위치가 DALLAS인 부서번호 구하기
select dno
from department
where loc = 'DALLAS';
--[2]
select ename, dno, job
from employee
where dno = (select dno
             from department
             where loc = 'DALLAS');

--[과제-1]12번 변경문제 부서위치가 DALLAS인 사원이름, 부서번호, 담당업무, +'부서위치' 표시
--사원이름, 부서번호, 담당업무: 사원테이블
--부서번호,부서위치 : 부서테이블
--[방법-1]조인 방법 -1
select ename, e.dno, job, loc
from employee e, department d--56개 출력
where e.dno=d.dno AND LOC='DALLAS';

--[방법-2]조인 방법 -2
select ename, e.dno, job, loc
from employee e JOIN department d--56개 출력
ON e.dno=d.dno 
where LOC='DALLAS';

--[방법-3]조인 방법 -3
select ename, dno, job, loc
from employee NATURAL JOIN department
where LOC='DALLAS';

--[방법-4]조인 방법 - 4
select ename, dno, job, loc
from employee JOIN department 
USING (dno)
where LOC='DALLAS';
			
--13.KING에게 보고하는 사원이름과 급여 표시
--[방법1]
--[1]사원이름이 KING인 사원번호 구하기
select eno--상사
from employee
where ename = 'KING';--manager 번호
--[2] KING에게 보고하는 부하직원 구하기
select ename, salary
from employee
where manager = (select eno
                 from employee
                 where ename = 'KING');            
                 
--14.RESEARCH 부서의 사원에 대한 부서번호, 사원이름, 담당 업무 표시
--[방법1]
--[1]RESEARCH 부서번호 구하기
select dno--20
from department
where dname = 'RESEARCH';
--[2] 그 부서에 근무하는 사원 정보 구하기
select dno, ename, job
from employee
where dno = (select dno 
             from department
             where dname = 'RESEARCH');
-- = 과 IN 둘 중에 하나 사용 하면 된다. IN으로 통일하면 된다.
--[방법2]
SELECT DEPT.DNO, E.ENAME, JOB
FROM EMPLOYEE
WHERE EMPLOYEE.DNO = DEPARTMENT.DNO 
AND D.DNAME = 'RESEARCH';

--15.평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무하는 
--사원번호,이름,급여 표시
--[문제 해석-1]평균 급여보다 많은 급여를 받고/이름에 M이 포함된 사원과 같은 부서에서 근무
--[방법-1]
--[1]. 평균 급여(조건-1)
select avg(salary)
from employee;--2073.21
--[2]이름에 M이 포함된 사원과 같은 부서번호 구하기(조건-2)
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
--[4]★주의: 이름에 M이 포함된 사원은 제외
select eno, ename, salary, dno
from employee
where salary > (select avg(salary)
				from employee)--2073.21
AND dno IN(select DISTINCT dno
			from employee
			where ename like '%M%')--10, 20, 30
AND ename NOT LIKE '%M%';
--우연히 같은 값이 출력되었지만 이름에 M이 포함된 사원은 제외해야 더 올바른 답이다.

--[문제 해석-2]평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무
--현재사원테이블에는 '평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원'이 존재하지 않으므로 데이터 수정한 후 데스트해본 결과
--[수정]: 부서번호가 20이고 이름에 M이 포함된 사원의 급여를 3000으로 수정
update employee
set salary =3000
where dno=30 AND ename like '%M%';
-- 결과가 안나오므로 아래의 과정이 필요하다. 
select ename, salary
from employee
where dno=30 AND ename like '%M%';alter--smith, adams가 각각 salary 3000으로 변경되었다.

--[방법-2]
select round(avg(salary),0)--trunc 사용도 가능
from employee;--소주점 제거 2336

--[2]'평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원의 부서번호 구하기
select dno--20
from employee
where ename LIKE '%M%'
		AND salary > (select round(avg(salary),0)
						from employee);
--[3]구한 부서번호(20)와 같은 부서에서 근무하는 사원번호, 이름, 급여 표시
select eno, ename, salary, dno
from employee
where dno IN(select DISTINCT dno
			from employee
			where ename like '%M%')
AND salary > (select round(avg(salary),0)
				from employee);--10, 20, 30
--[4]★주의: 이름에 M이 포함된 사원은 제외
select eno, ename, salary, dno
from employee
where dno IN(select DISTINCT dno
			from employee
			where ename like '%M%')
AND salary > (select round(avg(salary),0)
				from employee)--2073.21
AND ename NOT LIKE '%M%'; 
--[수정한 데이터를 다시 원상 복구시킴]---> 다시 update 시켜주면 된다.
update employee
set salary=800
where ename='SMITH';

update employee
set salary=800
where ename='ADAMS';

--16.평균 급여가 가장 적은 업무와 그 평균급여 표시
--[1] 업무별 평균 급여가 가장 적은 업무와 그 평균급여 구하기
select min(avg(salary))--그룹함수는 최대 2번까지 중첩가능
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
--그룹함수에 조건을 
having avg(salary)= (최소평균급여)--최소평균급여가 [1]이다.
--[4]마무리
select job, avg(salary)
from employee
group by job
having avg(salary)= (select min(avg(salary))
						from employee
							group by job);
--[방법1]
select job, avg(salary)
from employee
group by job
having avg(salary) <= ALL(select avg(salary)
                        from employee
                        group by job);
--[방법2]
select job, avg(salary)
from employee
group by job
having avg(salary) = (select min(avg(salary))
                      from employee
                      group by job);
 
--17.담당 업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원이름 표시
--[1]담당 업무가 MANAGER인 사원이 소속된 부서와 동일한 부서번호 구하기
select dno
from employee
where job = 'MANAGER';
--[2]
select ename
from employee
where dno IN(select dno
                from employee
                where job = 'MANAGER');--14명
--[3]문제해석에 따라 '담당업무가 'MANAGER'인 사원을 제외시킬수 있다. 
select ename
from employee
where dno IN(select dno
                from employee
                where job = 'MANAGER')
AND job !='MANAGER';--11명이로 된다.   
                
--[방법2]
select ename
from employee
where dno =ANY (select dno
             from employee
             where job = 'MANAGER');
 