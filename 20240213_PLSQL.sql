SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, World!');
END;
/ 
-- / : 해당 블록을 컴파일하고 실행하는 명령어이기 때문에 반드시 넣기

DECLARE
    -- 선언부 : 정의 및 선언
    v_annual NUMBER(9, 2) := &연봉; -- (사이즈, 소수점 몇자리까지), 두번째를 생략하면 기본 정수타입, & : 치환변수 사용
    v_sal v_annual%TYPE; -- 위에 선언된 변수의 데이터타입을 그대로 사용하겠다
BEGIN
    -- 실행부
    v_sal := v_annual/12;
    DBMS_OUTPUT.PUT_LINE('The monthly salary is ' || TO_CHAR(v_sal));
END;
/

DECLARE
    v_sal NUMBER(7,2) := 60000;
    v_comm v_sal%TYPE := v_sal * .20;
    v_message VARCHAR2(255) := ' eligible for commission';
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);  -- 60000
    DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm); -- 12000
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- ' eligible for commission'
    DBMS_OUTPUT.PUT_LINE('================================');
    DECLARE 
        v_sal NUMBER(7,2) := 50000;
        v_comm v_sal%TYPE := 0;
        v_total_comp NUMBER(7,2) := v_sal + v_comm;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal); -- 50000
        DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm); -- 0
        DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- ' eligible for commission'
        DBMS_OUTPUT.PUT_LINE('v_total_comp ' || v_total_comp); -- 50000
        DBMS_OUTPUT.PUT_LINE('================================');
        v_message := 'CLERK not ' || v_message;
        v_comm := v_sal * .30;
    END;
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal); -- 60000
    DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm); -- 12000
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- 'CLERK not  eligible for commission'
    DBMS_OUTPUT.PUT_LINE('================================');
    v_message := 'SALESMAN ' || v_message;
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- 'SALESMAN CLERK not  eligible for commission'
END;
/

DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename VARCHAR2(100);
BEGIN
    SELECT employee_id, last_name
    INTO   v_eid, v_ename
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
END;
/
