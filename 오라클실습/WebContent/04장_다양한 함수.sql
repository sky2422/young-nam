--<북스-04장_다양한 함수>

--<문자함수>
--1. 대소문자 변환함수
select 'Apple',
upper('Apple'),--대문자로 변환
lower('Apple'),--소문자로 변환
initcap('aPPLE')--첫글자만 대문자, 나머지는 소문자로 변환
from dual;--dual : 가상테이블, 결과값을 1개만 표시하고 싶을 때 사용

--대소문자 변환함수 어떻게 활용되는지 살펴보기
--'scott' 사원의 사번, 이름, 부서번호 출력
SELECT eno, ename, dno 
FROM EMPLOYEE
WHERE lower(ENAME)='scott';
--비교대상인 사원이름을 모두 소문자로 변환하여 비교

select ename, lower(ename)
from employee;

SELECT eno, ename, dno 
FROM EMPLOYEE
WHERE initcap(ENAME)='Scott';

--2. 문자길이를 반환하는 함수
--영문, 수, 특수문자(1byte) 또는 한글의 길이 구하기
--length() : 문자 수
select length('Apple'), length('사과')
from dual;--5 2 

--lengthB():한글2byte-'인코딩 방식'에 따라 달라짐(UTF-8:한글 1글자가 '3바이트')
select lengthB('Apple'), lengthB('사과')
from dual;--5바이트 6바이트

--3. 문자 조작 함수
--concat(매개변수가 2개만):'두 문자열'을 하나의 문자열로 연결(=결합)
--                    	★반드시 2 문자열만 연결 가능

--매개변수=인수=인자=argument
select 'Apple', '사과',
concat('Apple ', '사과') AS "함수 사용",--자바에서는 "Apple".concat("사과")
'Apple ' || '사과 ' || '맛있어' AS "|| 사용"--자바에서는  "Apple" + "사과" + "맛있어"
from dual;

--substr(기존문자열, 시작index, 추출할 개수) : 문자열의 일부만 추출하여 부분문자열
--시작index : 음수이면 문자열의 마지막을 기준으로 거슬러 올라옴
--인덱스(index) : 1 2 3....(자바 index : 0 1 2...)
select substr('apple mania',7,5), --mania
substr('apple mania',-11,5) --apple
from dual;

--[문제1] '이름이 N으로 끝나는' 사원 정보 표시
--방법-1:like연산자와 와일드카드(% _) 이용
select *
from EMPLOYEE
where ename LIKE '%N';

--방법-2:substr() 이용
select *
from EMPLOYEE
where substr(ename, -1, 1)='N';

select ename, substr(ename, -1, 1)
from EMPLOYEE
where substr(ename, -1, 1)='N';

--[문제2] 87년도에 입사한 사원 정보 검색
--방법-1
select *
from EMPLOYEE
where substr(hiredate,1,2)='87';--★오라클 : 날짜 기본 형식 'YY/MM/DD'
--where substr(hiredate,1,2)='1987';--결과 안나옴

--방법-2
--to_char(수나 날짜,'형식'):수나 날짜를 문자로 형변환함
select *
from EMPLOYEE -- substr('1987-11-12',1,4)
where substr(to_char(hiredate,'yyyy-mm-dd'),1,4)='1987';

--[문제3] '급여가 50으로 끝나는' 사원의 사원이름과 급여 출력
select ename, salary
from EMPLOYEE
where salary like '%50';--salary는 실수number(7,2)타입이지만 '문자로 자동형변환'되어 비교

select ename, salary
from EMPLOYEE--시작index :끝에서 2번째부터 시작해서 2개 문자로 부분문자열 생성
where substr(salary,-2,2)='50';--salary는 실수number(7,2)타입이지만 '문자로 자동형변환'

--substr()는 문자함수
select ename, salary
from EMPLOYEE--시작index :끝에서 2번째부터 시작해서 2개 문자로 부분문자열 생성
where substr(to_char(salary),-2,2)='50';--to_char(수나 날짜)를 문자로 형변환함

--substrB(기존문자열, 시작index, 추출할 바이트수)
select substr('사과매니아',1,2),--'사과'
substrB('사과매니아',1,3),--'사'  1부터 시작해서 3바이트를 추출
substrB('사과매니아',4,3),--'과'  4부터 시작해서 3바이트를 추출
substrB('사과매니아',1,6)--'사과'  1부터 시작해서 6바이트를 추출
from dual;

--instr(대상문자열, 찾을 문자열, 시작 index, 몇 번째 발견): 대상문자열 내에 찾고자 하는 해당 문자열이 어느 '위치(=index번호)'에 존재
--'시작 index, 몇 번째 발견' 생략하면 모두 1로 간주
--(ex)instr(대상문자열, 찾을 문자) ---> instr(대상문자열, 찾을 문자, 1, 1)
--찾는 문자가 없으면 0을 결과로 돌려줌(자바에서는 -1)
--자바에서는 "행복,사랑".indexOf("사랑")==3
select instr('apple','p'), instr('apple','p',1,1), --2 2
      instrB('apple','p'),instrB('apple','p',1,1), --2 2
instr('apple','p',1,2)--3('apple'내에서  1부터 시작해서 두 번째 발견하는 'p'를 찾아 index번호)
from dual; 

select instr('apple','p',2,2)
from dual; --3

select instr('apple','p',3,1)
from dual; --3

select instr('apple','p',3,2)
from dual; --0:찾는 문자가 없다.(자바에서는 찾는 문자열이 없으면 -1)

select instr('apple','pl',1,1)
from dual; --3

--영어는 무조건 1글자에 1byte, 그러나 한글은 인코딩방식에 따라 달라짐
--'바나나'에서 '나'문자가 1부터 시작해서 1번째 발견되는 '나'를 찾아 위치(index)=?
select instr('바나나','나'), instr('바나나','나',1,1), --2 2
      instrB('바나나','나'), instrB('바나나','나',1,1) --4 4
from dual;

--'바나나'에서 '나'문자가 2부터 시작해서 2번째 발견되는 '나'를 찾아 위치(index)=?
select instr('바나나','나',2,2), --3
      instrB('바나나','나',2,2)  --7
from dual;

--이름의 세번째 글자가 'R'인 사원의 정보를 검색
--방법-1
select *
from EMPLOYEE
where ename like '__R%';

--방법-2
select *
from EMPLOYEE
where substr(ename,3,1)='R';

--방법-3
select *
from EMPLOYEE
where instr(ename,'R',3,1)=3;

--LPAD(Left Padding) : '컬럼'이나 대상문자열을 명시된 자릿수에서 오른쪽에 나타내고
--남은 왼쪽은 특정 기호로 채움

--10자리를 마련 후 salary는 오른쪽, 남은 왼쪽자리를 '*'로 채움
select salary, LPAD(salary,10,'*')
from employee;
--10자리를 마련 후 salary는 왼쪽, 남은 오른쪽자리를 '*'로 채움
select salary, RPAD(salary,10,'*')
from employee;

--LTRIM('  문자열') : 문자열의 '왼쪽' 공백 제거
--RTRIM('문자열    ') : 문자열의 '왼쪽' 공백 제거
--TRIM('  문자열     ') : 문자열의 양쪽 공백 제거
select '   사과매니아     '||'입니다.',
LTRIM('   사과매니아     ')||'입니다.',
RTRIM('   사과매니아     ')||'입니다.',
TRIM('   사과매니아     ')||'입니다.'
from dual;

--TRIM('특정문자1개만' from 컬럼이나 '대상문자열')
--컬럼이나 '대상문자열'에서 '특정문자'가 '첫번째 글자'이거나 '마지막 글자'이면 잘라내고
--남은 문자열만 결과로 반환(=리턴=돌려줌)
select TRIM('사과' from '사과매니아')
from dual;/*오류메시지 : trim set should have only one character*/

select TRIM('사' from '사과매니아')
from dual;--'과매니아'

select TRIM('아' from '사과매니아')
from dual;--'사과매니'

select TRIM('과' from '사과매니아')
from dual;--'사과매니아':'과'가 처음이나 마지막에 없으므로 잘라내지 못해 결과가 '사과매니아'그대로 나옴 

--<숫자함수>-북스 P114~
--  -2(백)   -1(십)   0(일) . 1   2   3

--1. round(대상,화면에 표시되는 자릿수) : 반올림
--단, 자릿수 생략하면 0으로 간주
select 98.7654,
round(98.7654),   --99
round(98.7654,0), --99    일의 자리까지 표시. 소수 1째자리에서 반올림하여
round(98.7654,2), --98.77 소수 2째자리까지 표시. 소수 3째자리에서 반올림하여
round(98.7654,-1) --100   십의 자리까지 표시. 일의 자리에서 반올림하여
from dual;

--2. trunc(대상, 화면에 표시되는 자릿수) : '화면에 표시되는 자릿수'까지 남기고 나머지 버림
--단, 자릿수 생략하면 0으로 간주
select 98.7654,
trunc(98.7654),   --98
trunc(98.7654,0), --98    일의 자리까지 표시. 
trunc(98.7654,2), --98.76 소수 2째자리까지 표시. 
trunc(98.7654,-1) --90    십의 자리까지 표시. 
from dual;

--3. mod(수1,수2) : 수1을 수2로 나눈 나머지
select MOD(10,3)
from dual;

--사원이름, 급여, 급여를 500으로 나눈 나머지 출력
select ename, salary, MOD(salary,500)
from EMPLOYEE;

--<날짜함수>-북스 P117~
--1. sysdate : 시스템으로부터 오늘의 날짜와 시간을 반환
select sysdate from dual;

--date + 수 = 날짜에서 수만큼 '지난 날짜'
--date - 수 = 날짜에서 수만큼 '이전 날짜'
--date - date = 일수
--date + 수/24 = 날짜 + 시간

select sysdate-1 as 어제,
sysdate "오늘",
sysdate+1 as "내 일"
from dual;

--[문제]사원들의 현재까지의 근무일수 구하기(단, 실수이면 반올림하여 일의 자리까지 표시)
select sysdate-hiredate as "근무일수"--실수
from employee;

select sysdate-hiredate as "근무일수",--실수
ROUND(sysdate-hiredate,0) as "근무일수 반올림"--정수
from employee;

--입사일에서 '월을 기준'으로 잘라내려면('월까지 표시', 나머지 버림)
select hiredate, 
trunc(hiredate,'month') --월(01)과 일(01)을 초기화
from employee;

select sysdate, 
trunc(sysdate),     --시간 잘라냄
trunc(sysdate,'dd'),--시간 잘라냄(윗줄과 동일한 결과)
trunc(sysdate,'hh24'),--분, 초 잘라냄
trunc(sysdate,'mi'),--초 잘라냄
trunc(sysdate,'year'), --월(01)과 일(01)을 초기화
trunc(sysdate,'month'),--일(01)을 초기화
trunc(sysdate,'day')--요일 초기화(해당날짜에서 그 주의 지나간 일요일로 초기화)
from dual;


select sysdate,
trunc(sysdate,'day')
from dual;

--2. monthS_between(날짜1, 날짜2): 날짜1과 날짜2 사이에 개월 수 구하기(날짜1-날짜2)
select ename, sysdate, hiredate,
monthS_between(sysdate, hiredate), TRUNC(monthS_between(sysdate, hiredate)),--양수
monthS_between(hiredate, sysdate), TRUNC(monthS_between(hiredate, sysdate))--음수
from employee;

--3. add_monthS(날짜, 더할 개월수): 특정 개월수를 더한 날짜
select ename, hiredate, 
add_monthS(hiredate,3), add_monthS(hiredate,-3)
from employee; 

--4. next_day(날짜, '수요일'): 해당날짜를 기준으로 최초로 도래하는 요일에 해당하는 날짜 반환
select sysdate,
next_day('2021-10-26','수요일'),
next_day(sysdate, 4)--일요일(1), 월요일(2),...토요일(7) 요일 대신 숫자로 입력가능
from dual;

--5. last_day(날짜): 해당날짜가 속한 달의 마지막 날짜를 반환
--대부분 달의 경우, 마지막 날이 정해져 있지만
--2월달은 마지막 날이 28 또는 29가 될 수 있으므로 '2월에 사용하면 효과적임'
select sysdate, last_day(sysdate)
from dual;

select ename, hiredate, last_day(hiredate)
from employee;

--6. 날짜 또는 시간 차이 계산 방법
--날짜 차이 : 종료일자(YYYY-MM-DD)-시작일자(YYYY-MM-DD)
--시간 차이 : ( 종료일시(YYYY-MM-DD HH:MI:SS)-시작일시(YYYY-MM-DD HH:MI:SS) )*24
--분 차이    : ( 종료일시(YYYY-MM-DD HH:MI:SS)-시작일시(YYYY-MM-DD HH:MI:SS) )*24*60
--초 차이    : ( 종료일시(YYYY-MM-DD HH:MI:SS)-시작일시(YYYY-MM-DD HH:MI:SS) )*24*60*60

--★ '종료일자-시작일자' 빼면 차이 값이 '일 기준'의 수치 값으로 변환된다.

select '20211129'-'20211127'--number로 자동형변환(20211129-20211127)되어 연산됨 
from dual;--2

--날짜 차이 계산
select '2021-11-29'-'2021-11-27'--문자-문자=>number로 자동형변환(X)
from dual;--오류 발생

--to_date(수,'형식') : 수->'날짜'로 변환
select 20211129 ,to_date(20211129, 'YYYYMMDD') from dual;

--to_date('문자','형식') : '문자'->'날짜'로 변환
--(예)1800-1-1 => 1, 2021-11-26 => 1000일 지남, 2021-11-27 => 998이 지남
select to_date('2021-11-29','YYYY-MM-DD')-to_date('2021-11-27','YYYY-MM-DD')
from dual;--2

--시간 차이 계산
select (to_date('15:00','HH24:MI')-to_date('13:00','HH24:MI')) * 24
from dual;--0.08333일*24=>2시간

select (to_date('2021-11-29 15:00','YYYY-MM-DD HH24:MI')-to_date('2021-11-29 13:00','YYYY-MM-DD HH24:MI')) * 24
from dual;--위와 같은 결과 2시간

select (to_date('2021-11-30 15:00','YYYY-MM-DD HH24:MI')-to_date('2021-11-29 13:00','YYYY-MM-DD HH24:MI')) * 24
from dual;--25.999999..시간


select (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24
from dual;--2.005시간
--시간에 초가 존재하면 소수점이 발생하므로 round 함수로 소수점을 처리할 수 있다.
--소수 2째자리까지 표시(소수3째자리에서 반올림하여)
select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 , 2)
from dual;--2.01시간

--분 차이 계산
select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60 , 2)
from dual;--120.3분


select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60)
from dual;--120분(소수점 1째자리 반올림)

select TRUNC( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60)
from dual;--120분(소수점 절사)

--초 차이 계산
select ROUND( (to_date('15:00:58','HH24:MI:SS')-to_date('13:00:40','HH24:MI:SS')) * 24 * 60 * 60)
from dual;--120분*60=>7218초


--<형변환함수>-북스 P124~
/*
 *
 *     - to_char()->      <- to_char() - 
 * [수]               [문자]               [날짜]
 *    <-to_number()-      - to_date() ->
 *   ------------- to_date() --------->
 */


--1. to_char(수나 '날짜', 형식) : 수나 '날짜'를 문자로 변환

--<'날짜'와 관련된 형식>
--YYYY : 연도 4자리,            YY : 연도 2자리
--MM : 월 2자리 수로 (예)1월=>01,  MON : 월을 '알파벳'으로
--DD : 일 2자리 수로  (예)2일=>02,  D : 사용안함
--DAY : 요일 표현 (예)월요일,      DY : 요일을 약어로 표현 (예)월

--<'시간'과 관련된 형식>
--AM 또는 PM     : 오전AM, 오후PM 시각 표시
--A.M. 또는 P.M. : 오전A.M., 오후P.M. 시각 표시
--위 4가지 다 같은 결과 (12시 이전은 '오전'출력됨, 12시 이후는 '오후'출력됨)
--AM or PM or A.M. or P.M. + HH 또는 HH12에 반드시 사용
--HH 또는 HH12   : 시간(1~12시로 표현)
--HH24      : 24시간으로 표현(0~23) 
--               AM or PM or A.M. or P.M. 사용안해도 시간 충분히 전달됨
--MI        : 분
--SS        : 초 


select ename, hiredate,
to_char(hiredate, 'YY-MM'),
to_char(hiredate, 'YYYY/MM/DD DAY DY')
from employee;

select
to_char(sysdate,'YYYY/MM/DD DAY DY, HH'),--사용하지 말기(오전 오후가 없으므로 구분안됨)
to_char(sysdate,'YYYY/MM/DD DAY DY, PM HH'),--AM 또는 PM 반드시 사용 + HH12
to_char(sysdate,'YYYY-MM-DD DAY DY, A.M. HH'),
to_char(sysdate,'YYYY/MM/DD DAY DY, HH24:MI:SS')--AM 또는 PM 생략가능 + HH24
to_char(sysdate,'YYYY/MM/DD DAY DY, AM HH24:MI:SS')
from dual;

/*
 * <숫자와 관련된 형식>
 * 0 : 자릿수를 나타내며 자릿수가 맞지 않을 경우 '0으로 채움'
 * 9 : 자릿수를 나타내며 자릿수가 맞지 않을 경우 '채우지 않음'
 * L : 각 지역별 통화기호를 앞에 표시 (예)대한민국 ￦ (단, 달러는 직접 앞에 $붙여야 함)
 * . : 소수점 표시
 * , : 천 단위 자리 표시
 */

select ename, salary,
to_char(salary,'L000,000'),
to_char(salary,'L999,999'),
to_char(salary,'L999,999.00'),
to_char(salary,'L999,999.99')
from employee;

select 123.4, to_char(123.4,'L000,000.00'), to_char(123.4,'L999,999.99')
from dual;--123.4   ￦000123.40   ￦123.40

--10진수 10인 수를 -> 16진수(=HEX) 문자 A = 문자'A'(16진수 문자 '0'~'F')로 변환된다.
select to_char(10,'X'),--10진수 10을 16진수 1자리로 된 문자로 변환하면'A'이다.
to_char(255, 'XX')--10진수 255를 16진수 2자리로 된 문자로 변환 'FF'('X'로 하면 '##'자릿수가 부족)
from dual;

--'문자'나 '16진수문자('0'~'F')' -> 10진수로 변환
select to_number('A','X'),--16진수A -> 수로 변환 10
to_number('FF','XX')--16진수FF -> 수로 변환 255
from dual;

/*
 * 대부분 사용하는 to_number('10진수 형태의 문자')의 용도는
 * 단순히 '10진수 형태의 문자'를 숫자로 변환하는데 사용됨
 */

select to_number('0123'), to_number('12.34'), to_number('가')
from dual;

/*
 * java에서는 int num1=Integer.parseInt("0123");//0123
 *         int num2=Integer.parseInt("가나");//예외객체->프로그램이 종료
 * 
 *          double num3=Double.parseDouble("12.34");//12.34
 *          double num4=Double.parseDouble("ab");//예외객체->프로그램이 종료
 */

--2. to_date(수나 '문자', '형식') : 수나 '문자'를 날짜형으로 변환
select ename, hiredate
from employee
where hiredate=19810220;--데이터 타입이 맞지 않아 검색 불가능(오류)

--그래서 to_date()함수 이용하여 수를 날짜로 형변환하여 해결
select ename, hiredate
from employee
where hiredate = to_date(19810220,'yymmdd');
--결과 나옴 1981-02-20 시 분 초

select ename, hiredate, 
from employee
where hiredate = to_date(810220,'yymmdd');--같은 결과 없음(이유?'1900년도 = 2081-02-20' 이므로 같은 결과 없다.)

select 810220, 
to_date(810220,'yymmdd'), --2081-02-20 시:분:초 (년도에서 앞 2자리 생략하면 자동으로 20붙음)
to_date('810220','yy/mm/dd'),--2081-02-20 시:분:초
to_date('81/02/20','yy-mm-dd'),--2081-02-20 시:분:초
to_date('81/02/20','yy$mm$dd'),--2081-02-20 시:분:초

to_date(19810220,'yymmdd'), --1981-02-20 시:분:초 
to_date('19810220','yymmdd'),--1981-02-20 시:분:초 

to_date(19810220,'yyyymmdd'),--평상시 사용
to_date('19810220','yyyymmdd'),--평상시 사용

to_date(19810220,'yyyy-mm-dd'),--평상시 사용
to_date('19810220','yyyy/mm/dd'),--평상시 사용

--to_date(1981/02/20,'yyyy-mm-dd'),--★★주의 :오류
to_date('1981-02-20','yyyy/mm/dd')--평상시 사용
from dual;--to_date()의 결과는 '년-월-일 시:분:초'로 변환됨.

select ename, hiredate
from employee
where hiredate = to_date('81/02/20','yy/mm/dd');--같은 결과 없음

select ename, hiredate
from employee
where hiredate = to_date('19810220','yyyy-mm-dd');--결과 나옴 1981-02-20 시 분 초

select ename, hiredate
from employee
where hiredate = to_date('1981-02-20','yyyy/mm/dd');--결과 나옴 1981-02-20 시 분 초

select ename, hiredate
from employee
where hiredate = to_date(19810220,'yyyy/mm/dd');--결과 나옴 1981-02-20 시 분 초

select ename, hiredate
from employee
where hiredate = to_date(19810220,'yyyy/mm/dd');--결과 나옴 1981-02-20 시 분 초

select ename, hiredate
from employee
where hiredate = to_date(19810220,'yyyy$mm$dd');--결과 나옴 1981-02-20 시 분 초

select ename, hiredate, to_char(hiredate,'yy/mm/dd')
from employee;

--3. to_number('10진수문자','형식') : '문자
select 123, to_number('123'), to_number('12.3'), to_number('10,100','99999')
from dual;--to_number('10,100'):오류발생

select 100000 - 50000
from dual;--결과 50000

select 100,000 - 50,000
from dual;

select '100000' - '50000'
from dual;--결과 50000(이유?'10진수 문자'이므로 수로 자동형변환되어 연산)

select '100000' - 50000
from dual;--결과 50000

select '100,000' - '50,000'
from dual;--오류(이유?'10진수 문자가 아닌 ,가 있어서' 수로 자동형변환이 안됨)
--해결법
select to_number('100,000','999,999') - to_number('50,000','99,999')
from dual;--결과 50000(,천단위 구분쉼표)

select to_number('100,000','999,999'), to_number('50,000','99,999')
from dual;--100000, 50000

select to_number('100,000','999999') - to_number('50,000','99999')
from dual;--결과 50000(,를 생략해도 수로 변환됨)

select to_number('100,000','999999'), to_number('50,000','99999')
from dual;--100000, 50000

select '100000' - to_number('50000')
from dual;--결과 50000  to_number()사용할 필요없음(자동형변환되므로...)

--<일반함수>-북스 P130~

/* NULL은 연산과 비교를 하지 못함
 * 
 * ★★null처리하는 함수들
 * 1. NVL(값1, 값2) : 값1이 null이 아니면 값1, 값1이 null이면 값2
 *    주의: 값1과 값2는 반드시 데이터 타입이 일치
 *    (예) NVL(hiredate, '2021/05/21') : 둘다 date 타입으로 일치
 *        NVL(job, 'MANAGER') : 둘다 문자타입으로 일치
 * 
 * 2. NVL2(값1, 값2, 값3)
 *        (값1, 값1이 null이 아니면 값2, 값1이 null이면 값3)
 * 3. NULLif(값1, 값2) : 두 값이 같으면 null, 다르면 '첫번째 값1'을 반환
 */

select ename, salary, commission,
salary*12 + NVL(commission, 0) as "연 봉",
salary*12 + NVL2(commission, commission, 0) as "연 봉",
NVL2(commission, salary*12 + commission, salary*12) as "연 봉",
salary*12 + NVL2(commission, 1000, 0) as "커미션null아닌사원+1000",
salary*12 + nvl( NULLif(commission, null), 0) as "같은결과(권장안함)"
from employee;

select NULLIF('A','A'),NULLIF('a','b')
from dual;--null, 'a'

--4. coalesce(인수, 인수, 인수...) 

/*
 * 사원테이블에서 커미션이 null이 아니면 커미션을 출력,
 * 커미션이 null이고 급여(salary)가 null이 아니면 급여를 출력,
 * 커미션과 급여 모두 null이면 0출력
 */

select ename, salary, commission,
coalesce(commission, salary, 0)
from employee;

/*
 * java에서는
 * if(commission !=null) commission출력
 * else if(salary != null) salary 출력
 * else 0 출력
 */

/*
 * 5.decode() : switch~case문 ★★많이 사용하는 함수
 * switch(dno){
 * case10: 'ACCOUNTING'출력;break;
 * case20: 'RESEARCH'출력;break;
 * case30: 'SALE'출력;break;
 * case40: 'OPERATIONS'출력;break;
 * default: '기본' 출력
 * }
 */

--부서이름 오름차순 정렬하여 출력: [방법-1] decode()함수 사용
select ename, dno,
decode(dno 10,'ACCOUNTING',
			20,'RESEARCH',
			30,'SALE',
			40,'OPERATIONS',
			'기본') as dname
from employee
order by dno asc;

--부서이름 오름차순 정렬하여 출력 : [방법-2]
--6.case~end : 자바에서 if~else if~...else문과 비슷
--주의 case~end사이에 , 없음
--decode()함수에서 사용하지 못하는 비교연산자 중 = 제외한 나머지 비교연산자(>=, < 등)을 사용할 때
select ename, dno,
case when dno=10 then 'ACCOUNTING'
	 when dno=20 then 'RESEARCH'
	 when dno=30 then 'SALES'
	 when dno=40 then 'OPERATIONS'
	 else '기본'
end as DNAME
from employee
order by dno asc;

--부서이름을 오름차순 정렬하여 출력 : [방법-3] 두테이블을 하나의 테이블로 join
select ename, dno, dname
from employee natural join department;--둘 다 dno
order by dno asc;

---------------------------------------------------
--[교재없는 내용]

--자동 형변환

select '100'+200
from dual;--문자 '100'이 수100으로 자동형변환되어 연산

--문자 연결
select concat('100',200),--수200->문자'200'으로 자동형변환 '100200'
100 || 200 || 300 || 400--모두 문자로 자동형변환 '100' || '200'
from dual;

select ename
from employee
where eno = '7369';--'eno가 number'이므로 문자 '7369'를 정수로 자동형변환한 후 비교연산자로 비교함


select ename
from employee
where eno = cast('7369' as number(4));
--많이 사용되지는 않지만, cast함수를 사용하면 타입이 맞지 않아 발생하는 에러를 방지할 수 있다.

--cast() :데이터 형식 변환 함수 데이터 형식을 실시간으로 변환하는데 사용됨
		   
select avg(salary) as "평균 월급"
from employee;--결과가 실수임 2073.2142...

--1.1 실수로 나온 결과를 '전체 자릿수 6자리 중 소수점 이하 2자리까지 표현(3째 자리에서 반올림)'
--주의 : 소수점을 포함하는 숫자 타입 변환 시 만약 기존 자릿수보다 작은 자릿수로 cast하게 되면
--round()되어 반올림 처리됨
select CAST(avg(salary) AS NUMBER(6,2)) as "평균 월급"
from employee;--2073.21

select round(avg(salary),2) as "평균 월급"
from employee;

--데이터 형식을 실시간으로 변환하는데 사용되는 예
select cast(ename as char(20)),
	   length(ename),
	   length(cast(ename as char(20)))
from employee;
--RUN SQL command line에서 employee테이블의 구조 확인해보니
desc employee;
--결과 : ename의 데이터 형식은 변하지 않음

--1.2 실수로 나온 결과를 '정수로 보기 위해서'
--아래 2개는 결과가 다름
select CAST(avg(salary) AS NUMBER(6)) "평균 월급"
from employee;--만약2073.7142...=>2074

select trunc(avg(salary),0) as "평균 월급"
from employee;--자바에서 (int)2073.2142...=>2073

--테스트 : 사원번호 7369의 급여를 800으로 수정
update employee --update 테이블명(주의 : from 없음)
set salary=800 --set 컬럼명=변경할 값
where eno=7369; --where 조건

select*
from employee;

select ename, salary
from employee
where eno=7369;

--2. 다양한 구분자를 날짜 형식으로 변경가능(예)날짜:'2021-05-21', '2021/05/21'
select CAST('2021$05$21' AS DATE) from dual;
select CAST('2021%05%21' AS DATE) from dual;
select CAST('2021#05#21' AS DATE) from dual;
select CAST('2021@05@21' AS DATE) from dual;

--3. 쿼리의 결과를 보기 좋도록 처리할 때
select nvl(salary, 0) + nvl(commission, 0) as "총합"
from employee;

select cast(nvl(salary, 0) as char(7)) || '+' 
|| cast(nvl(commission, 0) as char(7)) || '=' as "월급+커미션",
nvl(salary, 0) + nvl(commission, 0) as "총합"
from employee;

--<4장 혼자해보기>-----------------------------

--1.substr 함수를 사용하여 사원들의 입사한 년도와 입사한 달만 출력하시오 
select hiredate, 
substr(hiredate, 1, 2) 년도, substr(hiredate, 4, 2) 달
from employee;--저장된 날짜 기본 형식(yy/mm/dd)

select hiredate, 
substr(to_char(hiredate,'yyyy-mm-dd'), 1, 4) 년도,
substr(hiredate, 4, 2) 달
from employee;

--2.substr 함수를 사용하여 4월에 입사한 사원을 출력하시오.
select *
from employee
--where substr(hiredate, 4, 2) like '04';
where substr(to_char(hiredate,'yyyy-mm-dd'), 6, 2)='04';

--3.mod 함수를 사용하여 사원번호가 짝수인 사람만 출력하시오.
select ename, eno
from employee
--where mod(eno, 2) like 0;
where mod(eno, 2) = 0;

--4.입사일을 연도는 2자리(YY), 월은 숫자(MON)로 표시하고 요일은 약어(DY)로 지정하여 출력하시오.
select hiredate, 
to_char(hiredate, 'yy/mm/dd dy')--81/11/23 수
from employee;

select hiredate, 
to_char(hiredate, 'yy/mon/dd day')--81/11월/23 수요일
from employee;

--5.올해 며칠이 지났는지 출력하시오. 현재 날짜에서 올해 1월 1일을 뺀 결과를 출력하고 
--to_date 함수를 사용하여 데이터 형을 일치 시키시오.
select sysdate-'2021/01/01'
from dual;--오류?데이터 형이 일치하지 않아서

select sysdate-to_date(20210101,'YYYY/MM/DD')
from dual;--to_date(수나 '문자', '형식')

select trunc(sysdate-to_date('2021/01/01','YYYY/MM/DD'))
from dual;--정수로 표시

--6.사원들의 상관 사번을 추력하되 상관이 없는 사원에 대해서는 null 값 대신 0으로 출력하시오.
select ename, manager, NVL(manager, 0) as "상관 사번"--NVL2(manager, manager, 0)
from employee;

--7.decode 함수로 직급에 따라 급여를 인상하도록 하시오. 
--직급이 'accounting'인 사원은 200, 'research'인 사원은 180,
--'sale'인 사원은 150,'operation'인 사원은 100을 인상하시오.
select eno, ename, dno, salary,
decode (dno,10,salary+200,
            20,salary+180,
            30,salary+150,
            40,salary+100) as "임금 상향"
from employee;

select eno, ename, job, salary,
Decode (job, 'ACCOUNTING', salary+200,
			 'RESEARCH', salary+180,
			 'SALE', salary+150,
			 'OPERATION', salary+100,
			 salary) as "임금 상향"
from employee;

