SET SERVEROUTPUT ON

DECLARE
    v_deptno departments.department_id%TYPE; -- table이 선행되고나서 어떤 컬럼의 타입을 참조할건지 선언하면 됨
    v_comm employees.commission_pct%TYPE := .1; -- 0.1
BEGIN
    SELECT department_id
    INTO v_deptno -- 접두어로 시작하는 애들을 변수로 생각하면 됨
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);

    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;
END;
/

SELECT * 
FROM employees
WHERE employee_id = 1000;


BEGIN
    DELETE FROM employees
    WHERE employee_id = 1000;
    
--    UPDATE employees
--    SET salary = salary * 1.1
--    WHERE employee_id = 0;
    
    -- 암시적커서는 우리가 제어불가하기 때문에 바로 앞에 update구문이 들어오면 delete가 아니라 update에 반응함(덮어씀), 직전실행 쿼리에만 반응함
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되지 않았습니다.');
    END IF;
END;
/

/*
1. 사원번호를 입력(치환변수사용&) 할 경우
사원번호, 사원이름, 부서이름
을 출력하는 PL/SQL을 작성하시오.

=> SELECT문
*/

-- 1) SQL문
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
                 ON (e.department_id = d.department_id)
WHERE employee_id = &사원번호;

-- 2) PL/SQL 블록
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_eid, v_ename, v_deptname
    FROM employees e
         JOIN departments d
         ON (e.department_id = d.department_id)
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_deptname);
END;
/

-- PL/SQL의 경우 가능한 방법) 2개의 SELECT문
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
    v_deptid departments.department_id%TYPE;
BEGIN
    SELECT employee_id, last_name, department_id
    INTO v_eid, v_ename, v_deptid
    FROM employees
    WHERE employee_id = &사원번호;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_deptname);
END;


/*
사원번호를 입력(치환변수사용&)할 경우
사원이름, 급여, 연봉 -> (급여*12+(nvl(급여, 0)*nvl(커미션퍼센트, 0) * 12))
을 출력하는 PL/SQL을 작성하시오.
*/

-- 1) SQL문
SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
FROM employees
WHERE employee_id = &사원번호;

-- 2) PL/SQL 블록
DECLARE
    v_ename  employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_annual v_salary%TYPE;
BEGIN
    SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
    INTO v_ename, v_salary, v_annual
    FROM employees
    WHERE employee_id = &사원번호;    
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);

END;
/

-- 2) PL/SQL의 경우 가능한 방법2
DECLARE
    v_ename  employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_salary%TYPE;
    
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_ename, v_salary, v_comm
    FROM employees
    WHERE employee_id = &사원번호;    
    
    v_annual := (v_salary*12+(NVL(v_salary, 0) * NVL(v_comm, 0) * 12));
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);

END;
/

CREATE TABLE test_employees
AS
    SELECT *
    FROM employees;

SELECT *
FROM test_employees;
--ROLLBACK;
-- 기본 IF 문
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요.');
    END IF;
END;
/

-- IF ~ ELSE 문 : 하나의 조건식, 결과는 참과 거짓 각각
DECLARE
    v_result NUMBER(4,0);
BEGIN
    SELECT COUNT(employee_id) -- 그룹함수 중에 null에 대한 처리가 가능한건 count 밖에 없음
    INTO v_result
    FROM employees
    WHERE manager_id = &사원번호;
    
    IF v_result = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('팀장입니다.');
    END IF;
END;
/

SELECT employee_id
FROM employees
WHERE manager_id = 100;

-- IF ~ ELSIF ~ ELSE 문 : 다중 조건식이 필요, 각각 결과처리
-- 연차를 구하는 공식
-- ROUND, TRUNC의 매개값은 2개, (실제값, 몇자리까지 끊을건지), 생략시 원단위로 끊는다
SELECT employee_id, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12) -- MONTHS_BETWEEN : 개월수
FROM employees;

DECLARE
    v_hyear NUMBER(2,0);
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hyear < 5 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 미만입니다.');
    ELSIF v_hyear < 10 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 이상 10년 미만입니다.');
    ELSIF v_hyear < 15 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 10년 이상 15년 미만입니다.');
    ELSIF v_hyear < 20 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 15년 이상 20년 미만입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('입사한 지 20년 이상입니다.');
    END IF;
END;
/

/*
3-1
사원번호를 입력(치환변수사용&)할 경우
입사일이 2015년 이후(2015년 포함)이면 'New employee' 출력
        2015년 이전이면 'Career employee; 출력

=> SQL : SELECT문 입력 : 사원번호 => 결과 : 입사일
   IF문, 입사일 >= 2015-01-01, New employee
         아닐경우, Career employee
*/
--1) SQl문
SELECT hire_date
FROM employees
WHERE employee_id = &사원번호;

-- 2) PLSQL
DECLARE
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;  

    -- IF문, 입사일 >= 2015-01-01, New employee
    -- 아닐경우, Career employee
    
    -- IF v_hdate >= TO_DATE('2015-01-01', 'yyyy-MM-dd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2015' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

SELECT TO_CHAR(TO_DATE('99/01/01', 'rr/MM/dd'), 'yyyy-MM-dd'), -- rr은 1900년대에 대한 처리를 도와준다
       TO_CHAR(TO_DATE('99/01/01', 'yy/MM/dd'), 'yyyy-MM-dd') -- yy는 무조건 현재세기(2000년대)
FROM dual;

/*
3-2
사원번호를 입력(치환변수사용&)할 경우
입사일이 2015년 이후(2015년 포함)이면 'New employee' 출력
        2015년 이전이면 'Career employee; 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/

DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR2(1000);
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;  

    -- IF문, 입사일 >= 2015-01-01, New employee
    -- 아닐경우, Career employee
    
    -- IF v_hdate >= TO_DATE('2015-01-01', 'yyyy-MM-dd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2015' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면
사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오

입력 : 사원번호
연산 : 1) SELECT문 employees
      2) IF문을 이용해서 비율을 결정
        -> 조건식 : 기준, 급여
출력(결과) : 사원이름, 급여, 인상된 급여
*/

-- 1) SQL문
SELECT last_name, salary
FROM employees
WHERE employee_id = &사원번호;

-- 2) PLSQL
DECLARE
    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_raise NUMBER(6,1); -- NUMBER는 38까지가 최대단위
    v_result v_sal%TYPE;
BEGIN
    SELECT last_name, salary, v_raise
    INTO v_name, v_sal, v_raise
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    ELSE
        v_raise := 0;
    END IF;
    
    v_result := v_sal + (v_sal * v_raise/100);
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('인상된 급여 : ' || v_result);
END;
/

-- 기본 LOOP 문
DECLARE
    v_num NUMBER(38) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_num);
        EXIT WHEN v_num > 10; -- 종료조건(언제 끝날지 알려줘야함), WHEN 조건절이 없을때는 그냥 STOP
    END LOOP;
END;
/

-- WHILE LOOP문
DECLARE
    v_num NUMBER(38,0) := 1;
BEGIN
    WHILE v_num < 5 LOOP -- 반복조건
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

-- 예제 : 1에서 10까지 정수값의 합
-- 1) 기본 LOOP
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 2) WHILE LOOP
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num <= 10 LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 또다른 방법
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_num NUMBER(2,0) := 0;
BEGIN
    LOOP 
        EXIT WHEN v_num >= 10; 
        v_num := v_num + 1;
        v_sum := v_sum + v_num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP
BEGIN
    FOR idx IN -10 .. 5 LOOP -- dot을 기준으로 왼: 최소값, 오: 최대값
        IF MOD(idx,2) <> 0 THEN -- MOD : 나머지 연산자, <> -> != 를 의미, 2로 나누었을 때 나머지가 0이 아닌 것
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- 주의사항 1) 범위 지정
BEGIN
    FOR idx IN REVERSE -10 .. 5 LOOP -- 거꾸로 출력하고 싶을 땐 IN 뒤에 REVERSE를 넣어주면 됨 
        IF MOD(idx,2) <> 0 THEN
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- 주의사항 2) 카운터(counter)
DECLARE
    v_num NUMBER(2,0) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num * 2;
    DBMS_OUTPUT.PUT_LINE(v_num);
    DBMS_OUTPUT.PUT_LINE('==============================');
    FOR v_num IN 1 .. 10 LOOP
        -- v_num := v_num * 2; -- FOR LOOP 안에서는 임시변수의 값을 변환하려고 하면 안됨
        -- v_num := 0;
        DBMS_OUTPUT.PUT_LINE(v_num);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_num);
END;
/

-- 예제 : 1에서 10까지 정수값의 합
-- 3) FOR LOOP
DECLARE
    -- 정수값 : 1 ~ 10 => FOR LOOP의 카운터로 처리
    -- 합계
    v_total NUMBER(2,0) := 0; -- 초기값 주기
BEGIN
    FOR num IN 1 .. 10 LOOP
        v_total := v_total + num;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

/*

1. 다음과 같이 출력되도록 하시오.
*       
**
***
****
*****

LOOP문과 ||

*/

-- LOOP
DECLARE
    v_star VARCHAR2(10) := ''; -- null은 연산이 되지 않기 때문에 공백을 넣어야함
    v_num NUMBER(1,0) := 0;
BEGIN
    LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 5;
    END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    v_star VARCHAR2(10) := '';
    v_num NUMBER(1,0) := 0;
BEGIN
    WHILE v_num <= 5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        
        v_num := v_num + 1;
    END LOOP;
END;
/

-- FOR LOOP
DECLARE
    v_star VARCHAR2(10) := '';
BEGIN
    FOR num IN 1 .. 5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/

-- 이중 FOR LOOP
BEGIN
    FOR counter IN 1 .. 5 LOOP  -- 몇번째 줄
        FOR i IN 1 .. counter LOOP -- *
            DBMS_OUTPUT.PUT('*'); -- 단독 사용불가, PUT을 사용하는 경우 반드시 마지막에는 PUT_LINE을 사용해줘야함
        END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
    END LOOP;    
END;
/
