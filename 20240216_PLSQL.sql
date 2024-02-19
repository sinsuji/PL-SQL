SET SERVEROUTPUT ON

-- Ŀ�� FOR LOOP
DECLARE
     CURSOR emp_cursor IS
        SELECT employee_Id, last_name
        FROM employees;
        -- WHERE employee_id = 0; �����Ͱ� ������ �����ü�� �ȵ�
BEGIN
    FOR emp_record IN emp_cursor LOOP -- FOR ���ڵ�Ÿ�� ���� IN ���� cursor LOOP
        DBMS_OUTPUT.PUT('NO. ' || emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(', �����ȣ : ' || emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', ����̸� : ' || emp_record.last_name); 
    END LOOP; -- CLOSE; END LOOP �ۿ��� ROWCOUNT, NOTFOUND�� ���Ұ�
        -- DBMS_OUTPUT.PUT_LINE('Total : ' || emp_cursor%ROWCOUNT);
    
    FOR dept_info IN (SELECT * 
                      FROM departments) LOOP -- �̸��� �����Ƿ� �Ӽ��� ����� �� ���� ������ �Ұ�, �����͸� Ȯ���ϴ� �뵵���� ��ħ
        DBMS_OUTPUT.PUT('�μ���ȣ : ' || dept_info.department_id);
        DBMS_OUTPUT.PUT_LINE(', �μ��̸� : ' || dept_info.department_name);    
    END LOOP;
END;
/


-- 1) ��� ����� �����ȣ, �̸�, �μ��̸� ���
-- SQL��
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
    LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id;

-- PLSQL��
DECLARE
    CURSOR emp_cursor IS 
        SELECT e.employee_id eid, e.last_name ename, d.department_name dept_name
        FROM employees e
        LEFT OUTER JOIN departments d
        ON e.department_id = d.department_id;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('�����ȣ : ' || emp_record.eid);
        DBMS_OUTPUT.PUT(', ����̸� : ' || emp_record.ename);
        DBMS_OUTPUT.PUT_LINE(', �μ��̸� : ' || emp_record.dept_name);  
    END LOOP;
END;
/

-- 2) �μ���ȣ�� 50�̰ų� 80�� ������� ����̸�, �޿�, ���� ���
-- SQL��
SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
FROM employees
WHERE department_id IN (50, 80);

-- PLSQL��
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
        FROM employees
        WHERE department_id IN (50, 80);
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('����̸� : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT(', �޿� : ' || emp_record.salary);
        DBMS_OUTPUT.PUT_LINE(', ���� : ' || emp_record.annual);
    END LOOP;
END;
/

-- PLSQL��
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id IN (50, 80);
        
    v_annual NUMBER(10, 0);
BEGIN
    FOR emp_record IN emp_cursor LOOP
        v_annual := (emp_record.salary*12+(NVL(emp_record.salary, 0) * NVL(emp_record.commission_pct, 0) * 12));
        DBMS_OUTPUT.PUT('����̸� : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT(', �޿� : ' || emp_record.salary);
        DBMS_OUTPUT.PUT_LINE(', ���� : ' || v_annual);
    END LOOp;
END;
/

-- �Ű������� ����ϴ� Ŀ��
DECLARE
    CURSOR emp_cursor
        ( p_mgr employees.manager_id%TYPE ) IS -- �̸��� ������ Ÿ�Ը� ������
            SELECT *
            FROM employees
            WHERE manager_id = p_mgr;
            
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    -- �⺻
    OPEN emp_cursor(100); -- Ŀ���� OPEN �� �� �Ű������� �ݵ�� �־���� ��
        
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.last_name);
    END LOOP;
    
    CLOSE emp_cursor; -- Ŀ���� ���� �ʰ� ���ο� ���� �����ϸ� �Ұ�����
    
    -- Ŀ�� FOR LOOP
    FOR emp_info IN emp_cursor(149) LOOP
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.last_name);
    END LOOP;
END;
/

/*
1.
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬����
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.
�Ի�⵵�� 2015��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2015�� ���� �Ի��� ����� test02 ���̺� �Է�
=> Ŀ��
=> ���ǹ�(IF��)
=> INSERT��
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

-- 1-1) ����� Ŀ�� + �⺻ LOOP ���
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
        -- Ŀ���� ����Ű�� ������ �������� �����ϰ��� �ϴ� �κ�
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

-- 1-2) Ŀ�� FOR LOOP ���
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
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
(��, cursor ���)
*/
DECLARE
    CURSOR dept_emp_cursor IS
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e
            JOIN departments d
            ON e.department_id = d.department_id
        WHERE e.department_id = &�μ���ȣ;
    
    v_emp_info dept_emp_cursor%ROWTYPE;
BEGIN

    OPEN dept_emp_cursor;

    LOOP
        FETCH dept_emp_cursor INTO v_emp_info;
        EXIT WHEN dept_emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('����̸� : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT(', �Ի����� : ' || v_emp_info.hire_date);
        DBMS_OUTPUT.PUT_LINE(', �μ��̸� : ' || v_emp_info.department_name);
    END LOOP;
    
    CLOSE dept_emp_cursor;
END;
/

-- �Ű����� CURSOR ���
DECLARE
    CURSOR dept_cursor IS
        SELECT *
        FROM departments;
        
    CURSOR dept_emp_cursor 
        (p_dept_id departments.department_id%TYPE) IS -- departments.department_id%TYPE => NUMBER�� ����ص� ������ ���� �����̴°� ����
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e
            JOIN departments d
            ON e.department_id = d.department_id
        WHERE e.department_id = p_dept_id;
    
    v_emp_info dept_emp_cursor%ROWTYPE;
BEGIN
    FOR dept_info IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('====== ���� �μ� ���� : ' || dept_info.department_name);
        OPEN dept_emp_cursor(dept_info.department_id);
    
        LOOP
            FETCH dept_emp_cursor INTO v_emp_info;
            EXIT WHEN dept_emp_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT('����̸� : ' || v_emp_info.last_name);
            DBMS_OUTPUT.PUT(', �Ի����� : ' || v_emp_info.hire_date);
            DBMS_OUTPUT.PUT_LINE(', �μ��̸� : ' || v_emp_info.department_name);
        END LOOP;
        
        IF dept_emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('���� �Ҽӵ� ����� �����ϴ�.');
        END IF;
        
        CLOSE dept_emp_cursor;
    END LOOP;
END;
/

-- ����ó��
-- 1) Oracle�� �����ϰ� �ְ� �̸��� �����ϴ� ���
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &�μ���ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� �������� ����� �����մϴ�.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� �ٹ��ϴ� ����� �������� �ʽ��ϴ�.');
    WHEN OTHERS THEN -- ���� ���ܸ� �����ϰ� ������ ��� ���ܸ� ó��
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���ܰ� �߻��߽��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('EXCEPTION ���� ����Ǿ����ϴ�.'); -- OTHERS���� �����
END;
/

-- 2) Oracle�� �����ϰ� �ְ� �̸��� �������� �ʴ� ���
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292); -- ���ܿ� �̸��� ������(�Ͻ���) PRAGMA EXCEPTION_INIT(�̸�, �����ڵ�)
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ; -- NOT NULL, UNIQUE, FK, CHECK

EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('�ٸ� ���̺��� ����ϰ� �ֽ��ϴ�.');
END;
/

-- 3) ����ڰ� �����ϴ� ���ܻ���
DECLARE
    e_emp_del_fail EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employees_id = &�����ȣ;
    
    IF SQL&ROWCOUNT = 0 THEN
        RAISE e_emp_del_fail;
    END IF;
EXCEPTION
    WHEN e_emp_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�.');
END;
/

-- ���� Ʈ�� �Լ�
DECLARE
    e_too_many EXCEPTION;
    
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
    emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_info
    FROM employees
    WHERE department_id = &�μ���ȣ;
    
    IF emp_info.salary < (emp_info.salary * emp_info.commission_pct + 10000) THEN
        RAISE e_too_many;
    END IF;
EXCEPTION
    WHEN e_too_many THEN
        DBMS_OUTPUT.PUT_LINE('����� ���� ���� �߻�!');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('ORA ' || v_ex_code);
        DBMS_OUTPUT.PUT_LINE(' - ' || v_ex_msg);
END;
/

/*
1) test_employees ���̺��� ����Ͽ� ���õ� ����� �����ϴ� PL/SQL �ۼ�
-- ���� 1) ġȯ���� ���
-- ���� 2) ����� �������� �ʴ� ��� '�ش����� �������� �ʽ��ϴ�.' ��� �޼����� ���
-- => ����� ���� ����
*/

DECLARE
    e_emp_del_fail EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_del_fail;
    END IF;
EXCEPTION
    WHEN e_emp_deL_fail THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �������� �ʽ��ϴ�.');
END;
/

-- PROCEDURE
-- PROCEDURE �ȿ����� ġȯ���� ������� �ʱ�
-- PROCEDURE�� ������ �����, VIEW�� ����
-- PROCEDURE�� ������ PLSQL �ȿ��� �����ؾ���
CREATE PROCEDURE test_pro
IS 
-- ����� : ���ο��� ����ϴ� ����, Ŀ��, Ÿ��, ���� ���� ���� (DECLARE�� �������� ���� �� ������ ������ ������)
    v_msg VARCHAR2(1000) := 'Execute Procedure';
BEGIN
    DELETE FROM test_employees
    WHERE department_id = 50;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
EXCEPTION
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('����� �� ���� Ŀ���Դϴ�.');
END;
/

-- 1) PROCEDURE ������ - ��Ͼȿ��� ����
-- PROCEDURE�� RETURN���� ���⶧���� ������ ����ϸ� �ȵ�
DECLARE
    v_num NUMBER(1,0);
BEGIN
    test_pro;
END;
/

-- 2) PROCEDURE ������ - �����ɾ� : �ӽ������� ����� �����ǰ� �����ϰ����ϴ� PROCEDURE�� �����Ѵ�
EXECUTE test_pro;


-- IN : ���ν��� ���ο��� ����� �νĵ�
-- DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
    -- p_eid := 100; �����Ͽ��� �ź���
    
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

-- OUT : PROCEDURE ���ο��� �ʱ�ȭ���� ���� ����
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
    p_result := v_sum; -- �����ڵ忡�� p_result�� ���� null�� ���� ������
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
    
    v_eid NUMBER := &�����ȣ;
BEGIN
    select_emp(v_eid, v_name, v_sal, v_comm);

    DBMS_OUTPUT.PUT('�����ȣ : ' || v_eid);
    DBMS_OUTPUT.PUT(', ����̸� : ' || v_name);
    DBMS_OUTPUT.PUT(', �޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE(', Ŀ�̼� : ' || v_comm);
END;
/

-- IN OUT �Ű�����
-- '01012341234' => '010-1234-1234'
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS

BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                  || '-' || SUBSTR(p_phone_no, 4, 4) -- �׹�°���� �ױ��� �߶�
                  || '-' || SUBSTR(p_phone_no, 8); -- 8��°���� �������� ��ȯ
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
-- 'TEMP240215101' -- TEMP + yyMMdd + ����(3�ڸ�)



-- ����) �⺻Ű
SELECT NVL(MAX(employee_id),0) + 1
FROM employees;

CREATE TABLE var_pk_tbl
(
    no VARCHAR2(1000) PRIMARY KEY,
    name VARCHAR2(4000) DEFAULT 'anony'
);

-- 'TEMP240215101' -- TEMP + yyMMdd + ����(3�ڸ�)
SELECT no, name
FROM var_pk_tbl;

INSERT INTO var_pk_tbl(no, name)
VALUES ('TEMP240215101', '��ǰ01');


SELECT 'TEMP' || TO_CHAR(sysdate, 'yyMMdd') || LPAD(NVL(MAX(SUBSTR(no, -3)), 0)+1,3,'0')
FROM var_pk_tbl
WHERE SUBSTR(no, 5, 6) = TO_CHAR(sysdate, 'yyMMdd');

/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ�
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
*/

-- ���ν���, IN �Ű����� �ϳ�
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
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
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
        DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');    
    END IF;
END;
/

EXECUTE TEST_PRO(0);

-- ������ �ڵ�
CREATE PROCEDURE test_pro
(p_eid employees.employee_id%TYPE)
IS 

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�.');
    END IF;
END;
/

EXECUTE TEST_PRO(0);



/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
*/

-- 1) �Է� : �����ȣ  -> ��� : ����̸�  => SELECT 
-- 2) ����̸� : ������ �������� ��ȯ

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

-- ������ �ڵ�
CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE) -- �Է� : �����ȣ => IN �Ű�����
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    -- ��ȸ : �����ȣ -> ����̸�
    SELECT last_name
    INTO v_ename -- ���� : VARCHAR2
    FROM employees
    WHERE employee_id = p_eid;
    
    -- �̸� : ù��° ���� ���� ������ ���� *�� ��ȯ
    v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*' ); -- ���� : VARCHAR2
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ' -> ' || v_result);
END;
/

EXECUTE yedam_emp(176);

/*
4.
�μ���ȣ�� �Է��� ���
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name)�� ����ϴ� get_emp ���ν����� �����Ͻÿ�.
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) EXECUTE get_emp(30)
*/
-- 1) �Է� : �μ���ȣ -> ��� : �����ȣ, ����̸� => Ŀ��
-- 2) ���ܻ��� : ����� ���� ��� -> "�ش� �μ����� ����� �����ϴ�." ���

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
       
        DBMS_OUTPUT.PUT('�����ȣ : ' || v_emp_info.employee_id);
        DBMS_OUTPUT.PUT(', ����̸� : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT_LINE('');
        v_count := v_count + 1;
    END LOOP;
       
    IF v_count = 0 THEN
        RAISE e_emp_not_found;
    END IF;
   
    CLOSE dept_emp_cursor;
   
EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');    
END;
/

EXECUTE get_emp(30);

-- ������ �ڵ�
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
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
END;
/
EXECUTE get_emp(0);

/*
5.
�������� ���, �޿� ����ġ(����)�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���.
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
*/

-- 1) �Է� : �����ȣ, �޿�����ġ -> UPDATE
-- 2) ���ܻ��� : ����� ���� ��� ��No search employee!!�� ���

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


-- ������ �ڵ�
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
