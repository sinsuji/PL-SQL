SET SERVEROUTPUT ON

-- 커서 FOR LOOP
DECLARE
     CURSOR emp_cursor IS
        SELECT employee_Id, last_name
        FROM employees;
        -- WHERE employee_id = 0; 데이터가 없으면 출력자체가 안됨
BEGIN
    FOR emp_record IN emp_cursor LOOP -- FOR 레코드타입 변수 IN 범위 cursor LOOP
        DBMS_OUTPUT.PUT('NO. ' || emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(', 사원번호 : ' || emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', 사원이름 : ' || emp_record.last_name); 
    END LOOP; -- CLOSE; END LOOP 밖에서 ROWCOUNT, NOTFOUND는 사용불가
        -- DBMS_OUTPUT.PUT_LINE('Total : ' || emp_cursor%ROWCOUNT);
    
    FOR dept_info IN (SELECT * 
                      FROM departments) LOOP -- 이름이 없으므로 속성을 사용할 수 없고 재사용이 불가, 데이터를 확인하는 용도에서 그침
        DBMS_OUTPUT.PUT('부서번호 : ' || dept_info.department_id);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || dept_info.department_name);    
    END LOOP;
END;
/


-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
-- SQL문
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
    LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id;

-- PLSQL문
DECLARE
    CURSOR emp_cursor IS 
        SELECT e.employee_id eid, e.last_name ename, d.department_name dept_name
        FROM employees e
        LEFT OUTER JOIN departments d
        ON e.department_id = d.department_id;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사원번호 : ' || emp_record.eid);
        DBMS_OUTPUT.PUT(', 사원이름 : ' || emp_record.ename);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || emp_record.dept_name);  
    END LOOP;
END;
/

-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- SQL문
SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
FROM employees
WHERE department_id IN (50, 80);

-- PLSQL문
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
        FROM employees
        WHERE department_id IN (50, 80);
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT(', 급여 : ' || emp_record.salary);
        DBMS_OUTPUT.PUT_LINE(', 연봉 : ' || emp_record.annual);
    END LOOP;
END;
/

-- PLSQL문
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id IN (50, 80);
        
    v_annual NUMBER(10, 0);
BEGIN
    FOR emp_record IN emp_cursor LOOP
        v_annual := (emp_record.salary*12+(NVL(emp_record.salary, 0) * NVL(emp_record.commission_pct, 0) * 12));
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT(', 급여 : ' || emp_record.salary);
        DBMS_OUTPUT.PUT_LINE(', 연봉 : ' || v_annual);
    END LOOp;
END;
/

-- 매개변수를 사용하는 커서
DECLARE
    CURSOR emp_cursor
        ( p_mgr employees.manager_id%TYPE ) IS -- 이름과 데이터 타입만 선언함
            SELECT *
            FROM employees
            WHERE manager_id = p_mgr;
            
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    -- 기본
    OPEN emp_cursor(100); -- 커서를 OPEN 할 때 매개변수를 반드시 넣어줘야 함
        
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.last_name);
    END LOOP;
    
    CLOSE emp_cursor; -- 커서를 닫지 않고 새로운 값을 오픈하면 불가능함
    
    -- 커서 FOR LOOP
    FOR emp_info IN emp_cursor(149) LOOP
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.last_name);
    END LOOP;
END;
/

/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를
다음 기준에 맞게 각각 test01, test02에 입력하시오.
입사년도가 2015년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2015년 이후 입사한 사원은 test02 테이블에 입력
=> 커서
=> 조건문(IF문)
=> INSERT문
*/

CREATE TABLE test01
AS
    SELECT employee_id, first_name, hire_date
    FROM employees
    WHERE employee_id = 0;
    
CREATE TABLE test02
AS
    SELECT employee_id, first_name, hire_date
    FROM employees
    WHERE employee_id = 0;

-- 1-1) 명시적 커서 + 기본 LOOP 사용
DECLARE
    CURSOR emp_cursor IS
            SELECT employee_id, first_name, hire_date
            FROM employees;
            
    emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        -- 커서가 가리키는 한행을 기준으로 실행하고자 하는 부분
        IF TO_CHAR(emp_record.hire_date, 'yyyy') >= '2015' THEN
            INSERT INTO test01 ( employee_id, first_name, hire_date )
            VALUES ( emp_record.employee_id, emp_record.first_name, emp_record.hire_date );
        ELSE
            INSERT INTO test02
            VALUES emp_record;
        END IF;
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

-- 1-2) 커서 FOR LOOP 사용
DECLARE
    CURSOR emp_cursor IS
            SELECT employee_id, first_name, hire_date
            FROM employees;
            
    emp_record emp_cursor%ROWTYPE;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        IF TO_CHAR(emp_record.hire_date, 'yyyy') >= '2015' THEN
            INSERT INTO test01 ( employee_id, first_name, hire_date )
            VALUES ( emp_record.employee_id, emp_record.first_name, emp_record.hire_date );
        ELSE
            INSERT INTO test02
            VALUES emp_record;
        END IF;
    END LOOP;
END;
/

SELECT * FROM test01;
SELECT * FROM test02;

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
(단, cursor 사용)
*/
DECLARE
    CURSOR dept_emp_cursor IS
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e
            JOIN departments d
            ON e.department_id = d.department_id
        WHERE e.department_id = &부서번호;
    
    v_emp_info dept_emp_cursor%ROWTYPE;
BEGIN

    OPEN dept_emp_cursor;

    LOOP
        FETCH dept_emp_cursor INTO v_emp_info;
        EXIT WHEN dept_emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT(', 입사일자 : ' || v_emp_info.hire_date);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || v_emp_info.department_name);
    END LOOP;
    
    CLOSE dept_emp_cursor;
END;
/

-- 매개변수 CURSOR 사용
DECLARE
    CURSOR dept_cursor IS
        SELECT *
        FROM departments;
        
    CURSOR dept_emp_cursor 
        (p_dept_id departments.department_id%TYPE) IS -- departments.department_id%TYPE => NUMBER를 사용해도 되지만 같이 움직이는걸 권장
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e
            JOIN departments d
            ON e.department_id = d.department_id
        WHERE e.department_id = p_dept_id;
    
    v_emp_info dept_emp_cursor%ROWTYPE;
BEGIN
    FOR dept_info IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('====== 현재 부서 정보 : ' || dept_info.department_name);
        OPEN dept_emp_cursor(dept_info.department_id);
    
        LOOP
            FETCH dept_emp_cursor INTO v_emp_info;
            EXIT WHEN dept_emp_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT('사원이름 : ' || v_emp_info.last_name);
            DBMS_OUTPUT.PUT(', 입사일자 : ' || v_emp_info.hire_date);
            DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || v_emp_info.department_name);
        END LOOP;
        
        IF dept_emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('현재 소속된 사원이 없습니다.');
        END IF;
        
        CLOSE dept_emp_cursor;
    END LOOP;
END;
/

-- 예외처리
-- 1) Oracle이 관리하고 있고 이름이 존재하는 경우
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러명의 사원이 존재합니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 근무하는 사원이 존재하지 않습니다.');
    WHEN OTHERS THEN -- 위의 예외를 제외하고 나머지 모든 예외를 처리
        DBMS_OUTPUT.PUT_LINE('기타 예외가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('EXCEPTION 절이 실행되었습니다.'); -- OTHERS에서 실행됨
END;
/

-- 2) Oracle이 관리하고 있고 이름이 존재하지 않는 경우
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292); -- 예외와 이름을 묶어줌(일시적) PRAGMA EXCEPTION_INIT(이름, 오류코드)
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호; -- NOT NULL, UNIQUE, FK, CHECK

EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('다른 테이블에서 사용하고 있습니다.');
END;
/

-- 3) 사용자가 정의하는 예외사항
DECLARE
    e_emp_del_fail EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employees_id = &사원번호;
    
    IF SQL&ROWCOUNT = 0 THEN
        RAISE e_emp_del_fail;
    END IF;
EXCEPTION
    WHEN e_emp_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
END;
/

-- 예외 트랩 함수
DECLARE
    e_too_many EXCEPTION;
    
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
    emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_info
    FROM employees
    WHERE department_id = &부서번호;
    
    IF emp_info.salary < (emp_info.salary * emp_info.commission_pct + 10000) THEN
        RAISE e_too_many;
    END IF;
EXCEPTION
    WHEN e_too_many THEN
        DBMS_OUTPUT.PUT_LINE('사용자 정의 예외 발생!');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('ORA ' || v_ex_code);
        DBMS_OUTPUT.PUT_LINE(' - ' || v_ex_msg);
END;
/

/*
1) test_employees 테이블을 사용하여 선택된 사원을 삭제하는 PL/SQL 작성
-- 조건 1) 치환변수 사용
-- 조건 2) 사원이 존재하지 않는 경우 '해당사원이 존재하지 않습니다.' 라는 메세지를 출력
-- => 사용자 정의 예외
*/

DECLARE
    e_emp_del_fail EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_del_fail;
    END IF;
EXCEPTION
    WHEN e_emp_deL_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 존재하지 않습니다.');
END;
/

-- PROCEDURE
-- PROCEDURE 안에서는 치환변수 사용하지 않기
-- PROCEDURE는 수정이 어려움, VIEW와 동일
-- PROCEDURE는 무조건 PLSQL 안에서 실행해야함
CREATE PROCEDURE test_pro
IS 
-- 선언부 : 내부에서 사용하는 변수, 커서, 타입, 예외 정의 가능 (DECLARE가 보이지만 않을 뿐 실제로 공간은 차지함)
    v_msg VARCHAR2(1000) := 'Execute Procedure';
BEGIN
    DELETE FROM test_employees
    WHERE department_id = 50;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
EXCEPTION
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('사용할 수 없는 커서입니다.');
END;
/

-- 1) PROCEDURE 실행방법 - 블록안에서 실행
-- PROCEDURE는 RETURN값이 없기때문에 변수를 사용하면 안됨
DECLARE
    v_num NUMBER(1,0);
BEGIN
    test_pro;
END;
/

-- 2) PROCEDURE 실행방법 - 단축명령어 : 임시적으로 블록이 생성되고 실행하고자하는 PROCEDURE를 실행한다
EXECUTE test_pro;


-- IN : 프로시저 내부에서 상수로 인식됨
-- DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
    -- p_eid := 100; 컴파일에서 거부함
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_first NUMBER(3,0) := 100;
    v_second CONSTANT NUMBER(3,0) := 149;
BEGIN
    raise_salary(103);
    raise_salary((120+10));
    raise_salary(v_second);
    raise_salary(v_first);
END;
/
SELECT employee_id, salary
FROM employees;

-- OUT : PROCEDURE 내부에서 초기화되지 않은 변수
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,
p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_result);
    
    -- p_result := 10;
    v_sum := p_num + p_result;
    p_result := v_sum; -- 내부코드에서 p_result에 값이 null로 담겼기 때문에
END;
/

DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
DBMS_OUTPUT.PUT_LINE('1) result : ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result : ' || v_result);
END;
/

DROP PROCEDURE select_emp;
CREATE PROCEDURE select_emp
(p_eid IN employees.employee_id%TYPE,
p_ename OUT employees.last_name%TYPE,
p_sal OUT employees.salary%TYPE,
p_comm OUT employees.commission_pct%TYPE)
IS

BEGIN
    SELECT last_name, salary, NVL(commission_pct, 0)
    INTO p_ename, p_sal, p_comm
    FROM employees
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_name VARCHAR2(100 char);
    v_sal NUMBER;
    v_comm NUMBER;
    
    v_eid NUMBER := &사원번호;
BEGIN
    select_emp(v_eid, v_name, v_sal, v_comm);

    DBMS_OUTPUT.PUT('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT(', 급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE(', 커미션 : ' || v_comm);
END;
/

-- IN OUT 매개변수
-- '01012341234' => '010-1234-1234'
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS

BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                  || '-' || SUBSTR(p_phone_no, 4, 4) -- 네번째부터 네글자 잘라냄
                  || '-' || SUBSTR(p_phone_no, 8); -- 8번째부터 나머지를 반환
END;
/

DECLARE
    v_ph_no VARCHAR2(100) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) ' || v_ph_no);
    format_phone(v_ph_no);
    DBMS_OUTPUT.PUT_LINE('2) ' || v_ph_no);
END;
/

CREATE TABLE var_pk_tbl
(
    no VARCHAR2(1000) PRIMARY KEY,
    name VARCHAR2(4000) DEFAULT 'aanony'
);

SELECT no, name
FROM var_pk_tbl;
-- 'TEMP240215101' -- TEMP + yyMMdd + 숫자(3자리)



-- 번외) 기본키
SELECT NVL(MAX(employee_id),0) + 1
FROM employees;

CREATE TABLE var_pk_tbl
(
    no VARCHAR2(1000) PRIMARY KEY,
    name VARCHAR2(4000) DEFAULT 'anony'
);

-- 'TEMP240215101' -- TEMP + yyMMdd + 숫자(3자리)
SELECT no, name
FROM var_pk_tbl;

INSERT INTO var_pk_tbl(no, name)
VALUES ('TEMP240215101', '상품01');


SELECT 'TEMP' || TO_CHAR(sysdate, 'yyMMdd') || LPAD(NVL(MAX(SUBSTR(no, -3)), 0)+1,3,'0')
FROM var_pk_tbl
WHERE SUBSTR(no, 5, 6) = TO_CHAR(sysdate, 'yyMMdd');

/*
1.
주민등록번호를 입력하면
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
*/

-- 프로시저, IN 매개변수 하나
CREATE PROCEDURE yedam_ju
(p_ju_no IN VARCHAR2)
IS
    v_result VARCHAR2(100);
BEGIN
    -- v_result := SUBSTR(p_ju_no, 1, 6) || '-' || SUBSTR(p_ju_no, 7, 1) || '******';
    v_result := SUBSTR(p_ju_no, 1, 6) || '-' || RPAD(SUBSTR(p_ju_no, 7, 1), 7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/

CREATE TABLE test_employees
AS
    SELECT *
    FROM employees;

SELECT *
FROM test_employees;
   
DROP PROCEDURE TEST_PRO;
CREATE PROCEDURE TEST_PRO
(p_eid IN employees.employee_id%TYPE)
IS
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');    
    END IF;
END;
/

EXECUTE TEST_PRO(0);

-- 교수님 코드
CREATE PROCEDURE test_pro
(p_eid employees.employee_id%TYPE)
IS 

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 없습니다.');
    END IF;
END;
/

EXECUTE TEST_PRO(0);



/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/

-- 1) 입력 : 사원번호  -> 출력 : 사원이름  => SELECT 
-- 2) 사원이름 : 정해진 포맷으로 변환

DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE)
IS
    v_name employees.last_name%TYPE;
    v_result VARCHAR2(100);
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE employee_id = p_eid;
   
    v_result := RPAD(SUBSTR(v_name, 1, 1), LENGTH(v_name), '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

EXECUTE yedam_emp(176);

-- 교수님 코드
CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE) -- 입력 : 사원번호 => IN 매개변수
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    -- 조회 : 사원번호 -> 사원이름
    SELECT last_name
    INTO v_ename -- 변수 : VARCHAR2
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 이름 : 첫번째 글자 제외 나머지 글자 *로 변환
    v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*' ); -- 변수 : VARCHAR2
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ' -> ' || v_result);
END;
/

EXECUTE yedam_emp(176);

/*
4.
부서번호를 입력할 경우
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을 출력하는 get_emp 프로시저를 생성하시오.
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/
-- 1) 입력 : 부서번호 -> 출력 : 사원번호, 사원이름 => 커서
-- 2) 예외사항 : 사원이 없는 경우 -> "해당 부서에는 사원이 없습니다." 출력

DROP PROCEDURE get_emp;
CREATE PROCEDURE get_emp
(p_did IN employees.department_id%TYPE)
IS
    e_emp_not_found EXCEPTION;
    CURSOR dept_emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = p_did;
   
    v_emp_info dept_emp_cursor%ROWTYPE;
    v_count NUMBER := 0;

BEGIN
    OPEN dept_emp_cursor;
   
    LOOP
        FETCH dept_emp_cursor INTO v_emp_info;
        EXIT WHEN dept_emp_cursor%NOTFOUND;
       
        DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id);
        DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT_LINE('');
        v_count := v_count + 1;
    END LOOP;
       
    IF v_count = 0 THEN
        RAISE e_emp_not_found;
    END IF;
   
    CLOSE dept_emp_cursor;
   
EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');    
END;
/

EXECUTE get_emp(30);

-- 교수님 코드
CREATE PROCEDURE get_emp
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_info dept_cursor%ROWTYPE;
    
    e_no_emp EXCEPTION;
BEGIN
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO emp_info;
        EXIT WHEN dept_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(emp_info.employee_id || ', ' || emp_info.last_name);
    END LOOP;
    
    IF dept_cursor%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    CLOSE dept_cursor;    
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
END;
/
EXECUTE get_emp(0);

/*
5.
직원들의 사번, 급여 증가치(비율)만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요.
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/

-- 1) 입력 : 사원번호, 급여증가치 -> UPDATE
-- 2) 예외사항 : 사원이 없는 경우 ‘No search employee!!’ 출력

DROP PROCEDURE y_update;
CREATE PROCEDURE y_update
(p_eid IN employees.employee_id%TYPE,
p_raise NUMBER)
IS
    e_emp_not_found EXCEPTION;
    v_salary employees.salary%TYPE;
BEGIN

    SELECT salary
    INTO v_salary
    FROM test_employees
    WHERE employee_id = p_eid;

    v_salary := v_salary + (v_salary * p_raise/100);
   
    UPDATE test_employees
    SET salary = v_salary
    WHERE employee_id = p_eid;
   
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_not_found;
    END IF;

EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');    

END;
/

EXECUTE y_update(200, 10);

SELECT employee_id, salary
FROM test_employees;


-- 교수님 코드
CREATE PROCEDURE y_update
( p_eid IN employees.employee_id%TYPE,
  p_raise IN NUMBER )
IS
    e_no_emp EXCEPTION;
BEGIN
    UPDATE employees
    -- SET salary = salary + salary * (p_raise/100)
    SET salary = salary * ( 1 + (p_raise/100) )
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

SELECT * FROM employees WHERE employee_id = 200;

EXECUTE y_update(0, 10);
