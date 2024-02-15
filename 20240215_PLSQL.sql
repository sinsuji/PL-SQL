SET SERVEROUTPUT ON

/*
2. 치환변수(&)를 사용하여 숫자를 입력하면
해당 구구단이 출력되도록 하시오.
예) 2 입력시
2 * 1 = 2
...
=> 치환변수 : 변수, 단을 입력
=> 곱하는 수 : 1에서 9까지, 정수값 ==> LOOP문
*/

-- 1) LOOP => 조건과 관련된 변수 필요!
DECLARE
    v_dan CONSTANT NUMBER(2,0) := &dan;
    v_num NUMBER(2,0) := 0;
    v_result NUMBER(2) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        v_result := v_dan * v_num;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_result);
        EXIT WHEN v_num >= 9;
    END LOOP;
END;
/

-- 1) LOOP 교수님 코드
DECLARE
    v_dan CONSTANT NUMBER(2,0) := &단;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * num));
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

-- 2) WHILE LOOP
DECLARE
    v_dan NUMBER(1) := &dan;
    v_num NUMBER(2) := 0;
    v_result NUMBER(2) := 0;
BEGIN
    WHILE v_num < 9 LOOP
        v_num := v_num + 1;
        v_result := v_dan * v_num;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_result);
    END LOOP;
END;
/

-- 2) WHILE LOOP 교수님 코드
DECLARE
    v_dan CONSTANT NUMBER(2, 0) := &단;
    v_num NUMBER(2, 0) := 1; -- 범위 : 1 ~ 9, 정수 모두
BEGIN
    WHILE v_num <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * num));
        v_num := v_num + 1;
    END LOOP;
END;
/

-- 3) FOR LOOP
DECLARE
    v_dan NUMBER(1) := &dan;
    v_result NUMBER(2) := 0;
BEGIN
    FOR num IN 1 .. 9 LOOP
        v_result := v_dan * num;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num || ' = ' || v_result);    
    END LOOP;
END;
/

-- 3) FOR LOOP 교수님 코드
DECLARE
    v_dan CONSTANT NUMBER(2, 0) := &단;
BEGIN
    FOR num IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num || ' = ' || (v_dan * num));    
    END LOOP;
END;
/

/*
3. 구구단 2~9단까지 출력되도록 하시오.
2 ~ 9 사이의 정수 => 반복문
각 단별로 곱하는 수, 1 ~ 9 사이의 정수 => 반복문
*/
-- FOR LOOP
BEGIN
    FOR dan IN 2..9 LOOP
        FOR num IN 1..9 LOOP
           DBMS_OUTPUT.PUT(dan || ' * ' || num || ' = ' || (dan * num) || ' ');           
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 순서 바꾸기
BEGIN
    FOR num IN 1..9 LOOP
        FOR dan IN 2..9 LOOP
           DBMS_OUTPUT.PUT(dan || ' * ' || num || ' = ' || (dan * num) || ' ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- WHILE LOOP => 반복조건과 관련된 변수
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_dan <= 9 LOOP 
        v_num := 1;
        WHILE v_num <= 9 LOOP
            DBMS_OUTPUT.PUT(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num) || ' ');
            v_num := v_num + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- 순서바꾸기
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num <= 9 LOOP 
        v_dan := 2;
        WHILE v_dan <= 9 LOOP
            DBMS_OUTPUT.PUT(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num) || ' ');
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_num := v_num + 1;
    END LOOP;
END;
/

-- LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP 
        v_num := 1;
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num) || ' '); 
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;  
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/


/*
4. 구구단 1~9까지 출력되도록 하시오.
   (단, 홀수단 출력)
MOD(실제값, 나누는 값) : 나머지
*/
DECLARE
    v_dan NUMBER(2, 0) := 2;
BEGIN
    FOR dan IN 2..9 LOOP
        IF MOD(dan, 2) <> 0 THEN
            FOR num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num || ' = ' || (v_dan * num));
            END LOOP;
        END IF;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- 교수님 코드/FOR LOOP
BEGIN
    FOR v_dan IN 2..9 LOOP
        IF MOD(v_dan, 2) = 0 THEN
            CONTINUE;
        END IF;
        
        FOR v_num IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;
/

-- 교수님 코드/기본 LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP 
        IF MOD(v_dan, 2) <> 0 THEN
            v_num := 1;
            LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num) || ' '); 
                v_num := v_num + 1;
                EXIT WHEN v_num > 9;  
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- RECORD : 기본적으로 직접 정의해야함
DECLARE
    -- 1) 정의
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0),
        ename employees.last_name%TYPE,
        sal employees.salary%TYPE := 0);
    
    -- 2) 변수 선언(이름, 데이터타입 중심으로)
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    
    SELECT employee_id, first_name, salary
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.empno);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', 급여 : ' || v_emp_info.sal);
    
END;
/

-- RECORD : %ROWTYPE
DECLARE
    v_emp_info employees%ROWTYPE; -- %ROWTYPE : 이미 존재하고 있는 테이블과 뷰를 통채로 받아오기 때문에 별도의 정의가 필요없다, 컬럼명이 필드명이 된다
BEGIN
    SELECT *
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
    DBMS_OUTPUT.PUT_LINE(', 업무 : ' || v_emp_info.job_id);
END;
/

-- TABLE
DECLARE
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER; -- PLS_INTEGER가 검색 속도면에서 나음
        
    -- 2) 변수 선언
    v_num_info num_table_type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('현재 인덱스 - 1000 : ' || v_num_info(-1000));
    
    v_num_info(-1000) := 10000; -- (인덱스)
    
    DBMS_OUTPUT.PUT_LINE('현재 인덱스 - 1000 : ' || v_num_info(-1000));
END;
/

-- 2의 배수 10개를 담는 예제 : 2, 4, 6, 8, 10, 12, 14, ...
DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
    v_num_ary num_table_type;            
    
    v_result NUMBER(4,0) := 0;
BEGIN
    FOR idx IN 1..10 LOOP
        v_num_ary(idx * 5) := idx * 2;
    END LOOP;
    
    FOR i IN v_num_ary.FIRST .. v_num_ary.LAST LOOP
        IF v_num_ary.EXISTS(i) THEN
            DBMS_OUTPUT.PUT(i || ' : ');
            DBMS_OUTPUT.PUT_LINE(v_num_ary(i));
            
            v_result := v_result + v_num_ary(i);
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총 갯수 : ' || v_num_ary.COUNT);
    DBMS_OUTPUT.PUT_LINE('누적합 : ' || v_result);
END;
/

-- TABLE + RECORD
SELECT *
FROM employees;

DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
    
    v_emps emp_table_type;
    v_emp_info employees%ROWTYPE;
BEGIN
    FOR eid IN 100 .. 104 LOOP
        SELECT *
        INTO v_emp_info
        FROM employees
        WHERE employee_id = eid;
        
        v_emps(eid) := v_emp_info;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총 갯수 : ' || v_emps.COUNT);
    DBMS_OUTPUT.PUT_LINE(v_emps(100).last_name);
END;
/

-- 총 20건의 데이터 담기 
DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_max employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    v_emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응
    
    TYPE emp_table_type IS TABLE OF v_emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*) -- null에 대한 처리
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO v_emp_record
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_table(eid) := v_emp_record;     
    END LOOP;
    
    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP;    
END;
/


-- CURSOR
DECLARE
    -- 커서를 선언
    CURSOR emp_cursor IS -- SELECT문에 이름을 붙이는 과정이라 생각하면 됨
        SELECT employee_id, last_name
        FROM employees
        WHERE employee_id = 0;
    
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor; -- 활성집합 실행
    
    FETCH emp_cursor INTO v_eid, v_ename;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    
    CLOSE emp_cursor; -- 활성집합 해제
END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees;
        
    v_emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- 실제 연산 진행
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name);
    END LOOP;
    
    -- FETCH emp_cursor INTO v_emp_record;
    -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
    -- DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name);
        
    CLOSE emp_cursor;
    
    -- FETCH emp_cursor INTO v_emp_record;
    -- DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT || ', ');
END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees;

    v_emp_record employees%ROWTYPE;
    
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        v_emp_table(v_emp_record.employee_id) := v_emp_record;
    END LOOP;
    
    CLOSE emp_cursor;
    
    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP; 
END;
/

--
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
        
    v_emp_info emp_dept_cursor%ROWTYPE;    
BEGIN
    -- 1) 해당 부서에 속한 사원의 정보를 출력
    -- 2) 해당 부서에 속한 사원이 없는 경우 '해당 부서에 소속된 직원이 없습니다.';
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- 첫번째 => 몇번째 행
        DBMS_OUTPUT.PUT_LINE('첫번째 : ' || emp_dept_cursor%ROWCOUNT);
        
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT(v_emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.job_id);
    END LOOP;
    
    -- 두번째 => 현재 커서의 데이터 총 갯수
    DBMS_OUTPUT.PUT_LINE('두번째 : ' || emp_dept_cursor%ROWCOUNT);
    IF emp_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 소속된 직원이 없습니다.');
    END IF;
    
    CLOSE emp_dept_cursor;
    
END;
/

-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
-- SQL문
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
    LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id;
      
-- PL/SQL 블록            
DECLARE
    CURSOR emp_all_cursor IS
        SELECT e.employee_id eid, e.last_name ename, d.department_name dept_name
        FROM employees e
            LEFT OUTER JOIN departments d
            ON e.department_id = d.department_id;
            
    v_emp_info emp_all_cursor%ROWTYPE; -- ROWTYPE을 사용할 경우 별칭부여가능
BEGIN
    OPEN emp_all_cursor;
    
    LOOP
        FETCH emp_all_cursor INTO v_emp_info;
        EXIT WHEN emp_all_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.eid);
        DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.ename);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || v_emp_info.dept_name);
    END LOOP;
    
    CLOSE emp_all_cursor;
END;
/
     
-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12) + (NVL(급여, 0) * NVL(커미션, 0) * 12)

-- SQL문
SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual, department_id
FROM employees
WHERE department_id IN (50, 80);

-- PL/SQL문        
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT last_name,
               salary,
               (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual,
               department_id
        FROM employees
        WHERE department_id IN (50, 80);
    
    v_emp_info emp_dept_cursor%ROWTYPE;
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT('부서번호 : ' || v_emp_info.department_id);
        DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT(', 급여 : ' || v_emp_info.salary);
        DBMS_OUTPUT.PUT_LINE(', 연봉 : ' || v_emp_info.annual);
    END LOOP;
    
    CLOSE emp_dept_cursor;
END;
/

-- SQL문
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id IN (50, 80);

-- PL/SQL문        
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT last_name,
               salary,
               commission_pct
        FROM employees
        WHERE department_id IN (50, 80);
    
    v_emp_info emp_dept_cursor%ROWTYPE;
    v_annual employees.salary%TYPE;
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;  
        
        v_annual := (v_emp_info.salary*12+(NVL(v_emp_info.salary, 0) * NVL(v_emp_info.commission_pct, 0) * 12));
        DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT(', 급여 : ' || v_emp_info.salary);
        DBMS_OUTPUT.PUT_LINE(', 연봉 : ' || v_annual);
    END LOOP;
    
    CLOSE emp_dept_cursor;
END;
/