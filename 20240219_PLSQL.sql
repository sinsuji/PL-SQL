SET SERVEROUTPUT ON

-- FUNCTION
-- ���������� IN�� ��밡��
-- FUNCTION�� PROCEDURE�� �������� ȣ���ϴ� ���
CREATE FUNCTION test_fun
(p_msg IN VARCHAR2)
RETURN VARCHAR2
IS
    -- �����
BEGIN
    RETURN p_msg;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN '�����Ͱ� �������� �ʽ��ϴ�.';
END;
/

-- FUNCTION�� ��Ͽ��� ����� ��� �ݵ�� ������ �ʿ���
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    v_result := test_fun('�׽�Ʈ');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

SELECT test_fun('SELECT������ ȣ��')
FROM dual; -- ���� ���̺�, ���÷�, �ѵ����� �ۿ� ���� �ӽ� ���̺�

SELECT *
FROM dual;

SELECT *
FROM user_source -- �α��� �� ������ ������ �ִ� ��ü�� ���� ����(���ν���, �Լ� ���� TYPE, CODE) 
WHERE type IN ('PROCEDURE');

-- ���ϱ�
CREATE FUNCTION y_sum
(p_x IN NUMBER,
 p_y IN NUMBER)
RETURN NUMBER
IS
    v_result NUMBER;
BEGIN
    v_result := p_x + p_y;
    RETURN v_result;
END;
/

SELECT y_sum(100, 200)
FROM dual;

-- �����ȣ�� �������� ���ӻ�� �̸��� ���
-- SELF JOIN
SELECT m.last_name
FROM employees e JOIN employees m
                 ON (e.manager_id = m.employee_id)
WHERE e.employee_id = 149;

CREATE FUNCTION get_mgr
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2 -- RETURN���� ����ϴ� ��� ������Ÿ��
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT m.last_name
    INTO v_mgr_name
    FROM employees e JOIN employees m
                     ON (e.manager_id = m.employee_id)
    WHERE e.employee_id = p_eid;
    
    RETURN v_mgr_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '���� ��簡 �������� �ʽ��ϴ�.';
END;
/

SELECT employee_id, last_name, get_mgr(employee_id) as manager
FROM employees;

/*

1.
�����ȣ�� �Է��ϸ� 
last_name + first_name �� ��µǴ� 
y_yedam �Լ��� �����Ͻÿ�.

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
��� ��)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;

*/

SELECT last_name || ' ' || first_name
FROM employees;

CREATE OR REPLACE FUNCTION y_yedam
(p_eid IN employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_full_name employees.last_name%TYPE;
BEGIN
    SELECT last_name || ' ' || first_name
    INTO v_full_name
    FROM employees
    WHERE employee_id = p_eid;
        
    RETURN v_full_name;
END;
/

SELECT employee_id, y_yedam(employee_id)
FROM   employees;

EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174));

/*
2.
�����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�.
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �̻��̸� �޿� �״�� ���
����) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;
*/
SELECT CASE
        WHEN salary <= 5000 THEN
            salary * (1 + 20/100)
        WHEN salary <= 10000 THEN
            salary * (1 + 15/100)
        WHEN salary <= 20000 THEN
            salary * (1 + 10/100)
        ELSE
            salary
        END as "new sal"
FROM employees;

CREATE OR REPLACE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_sal employees.salary%TYPE;
    v_raise v_sal%TYPE;
BEGIN
    -- 1) SELECT => salary
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
    -- 2) salary �� ���� ������ �ٸ��� ����
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 20000 THEN
        v_raise := 10;
    ELSE
        v_raise := 0;
    END IF;
    
    RETURN (v_sal + (v_sal * (v_raise/100)));
END;
/

SELECT last_name, salary, ydinc(employee_id)
FROM   employees;

/*

3.
�����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
->������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;
     
*/
CREATE OR REPLACE FUNCTION yd_func
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_annual NUMBER;
BEGIN
    SELECT (salary + (NVL(salary, 0) * NVL(commission_pct, 0))) * 12
    INTO v_annual
    FROM employees
    WHERE employee_id = p_eid;    
    
    RETURN v_annual;

END;
/

SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;

/*
4. 
SELECT last_name, subname(last_name)
FROM   employees;

LAST_NAME     SUBNAME(LA
------------ ------------
King         K***
Smith        S****
...
������ ���� ��µǴ� subname �Լ��� �ۼ��Ͻÿ�.
*/ 



CREATE OR REPLACE FUNCTION subname
(p_ename employees.last_name%TYPE)
RETURN VARCHAR2
IS

BEGIN
    RETURN RPAD(SUBSTR(p_ename, 1, 1), LENGTH(p_ename), '*');
END;
/

SELECT last_name, subname(last_name)
FROM   employees;


-- 10
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY');