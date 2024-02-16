SET SERVEROUTPUT ON

DECLARE
    v_deptno departments.department_id%TYPE; -- table�� ����ǰ��� � �÷��� Ÿ���� �����Ұ��� �����ϸ� ��
    v_comm employees.commission_pct%TYPE := .1; -- 0.1
BEGIN
    SELECT department_id
    INTO v_deptno -- ���ξ�� �����ϴ� �ֵ��� ������ �����ϸ� ��
    FROM employees
    WHERE employee_id = &�����ȣ;
    
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
    
    -- �Ͻ���Ŀ���� �츮�� ����Ұ��ϱ� ������ �ٷ� �տ� update������ ������ delete�� �ƴ϶� update�� ������(���), �������� �������� ������
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���������� �������� �ʾҽ��ϴ�.');
    END IF;
END;
/

/*
1. �����ȣ�� �Է�(ġȯ�������&) �� ���
�����ȣ, ����̸�, �μ��̸�
�� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.

=> SELECT��
*/

-- 1) SQL��
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
                 ON (e.department_id = d.department_id)
WHERE employee_id = &�����ȣ;

-- 2) PL/SQL ���
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
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�μ��̸� : ' || v_deptname);
END;
/

-- PL/SQL�� ��� ������ ���) 2���� SELECT��
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
    v_deptid departments.department_id%TYPE;
BEGIN
    SELECT employee_id, last_name, department_id
    INTO v_eid, v_ename, v_deptid
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�μ��̸� : ' || v_deptname);
END;


/*
�����ȣ�� �Է�(ġȯ�������&)�� ���
����̸�, �޿�, ���� -> (�޿�*12+(nvl(�޿�, 0)*nvl(Ŀ�̼��ۼ�Ʈ, 0) * 12))
�� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
*/

-- 1) SQL��
SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
FROM employees
WHERE employee_id = &�����ȣ;

-- 2) PL/SQL ���
DECLARE
    v_ename  employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_annual v_salary%TYPE;
BEGIN
    SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
    INTO v_ename, v_salary, v_annual
    FROM employees
    WHERE employee_id = &�����ȣ;    
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_annual);

END;
/

-- 2) PL/SQL�� ��� ������ ���2
DECLARE
    v_ename  employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_salary%TYPE;
    
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_ename, v_salary, v_comm
    FROM employees
    WHERE employee_id = &�����ȣ;    
    
    v_annual := (v_salary*12+(NVL(v_salary, 0) * NVL(v_comm, 0) * 12));
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_annual);

END;
/

CREATE TABLE test_employees
AS
    SELECT *
    FROM employees;

SELECT *
FROM test_employees;
--ROLLBACK;
-- �⺻ IF ��
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���������� �������� �ʾҽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�����ȣ�� Ȯ�����ּ���.');
    END IF;
END;
/

-- IF ~ ELSE �� : �ϳ��� ���ǽ�, ����� ���� ���� ����
DECLARE
    v_result NUMBER(4,0);
BEGIN
    SELECT COUNT(employee_id) -- �׷��Լ� �߿� null�� ���� ó���� �����Ѱ� count �ۿ� ����
    INTO v_result
    FROM employees
    WHERE manager_id = &�����ȣ;
    
    IF v_result = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ϲ� ����Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�����Դϴ�.');
    END IF;
END;
/

SELECT employee_id
FROM employees
WHERE manager_id = 100;

-- IF ~ ELSIF ~ ELSE �� : ���� ���ǽ��� �ʿ�, ���� ���ó��
-- ������ ���ϴ� ����
-- ROUND, TRUNC�� �Ű����� 2��, (������, ���ڸ����� ��������), ������ �������� ���´�
SELECT employee_id, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12) -- MONTHS_BETWEEN : ������
FROM employees;

DECLARE
    v_hyear NUMBER(2,0);
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_hyear < 5 THEN
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 5�� �̸��Դϴ�.');
    ELSIF v_hyear < 10 THEN
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 5�� �̻� 10�� �̸��Դϴ�.');
    ELSIF v_hyear < 15 THEN
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 10�� �̻� 15�� �̸��Դϴ�.');
    ELSIF v_hyear < 20 THEN
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 15�� �̻� 20�� �̸��Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 20�� �̻��Դϴ�.');
    END IF;
END;
/

/*
3-1
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2015�� ����(2015�� ����)�̸� 'New employee' ���
        2015�� �����̸� 'Career employee; ���

=> SQL : SELECT�� �Է� : �����ȣ => ��� : �Ի���
   IF��, �Ի��� >= 2015-01-01, New employee
         �ƴҰ��, Career employee
*/
--1) SQl��
SELECT hire_date
FROM employees
WHERE employee_id = &�����ȣ;

-- 2) PLSQL
DECLARE
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;  

    -- IF��, �Ի��� >= 2015-01-01, New employee
    -- �ƴҰ��, Career employee
    
    -- IF v_hdate >= TO_DATE('2015-01-01', 'yyyy-MM-dd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2015' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

SELECT TO_CHAR(TO_DATE('99/01/01', 'rr/MM/dd'), 'yyyy-MM-dd'), -- rr�� 1900��뿡 ���� ó���� �����ش�
       TO_CHAR(TO_DATE('99/01/01', 'yy/MM/dd'), 'yyyy-MM-dd') -- yy�� ������ ���缼��(2000���)
FROM dual;

/*
3-2
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2015�� ����(2015�� ����)�̸� 'New employee' ���
        2015�� �����̸� 'Career employee; ���
��, DBMS_OUTPUT.PUT_LINE ~ �� �ѹ��� ���
*/

DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR2(1000);
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;  

    -- IF��, �Ի��� >= 2015-01-01, New employee
    -- �ƴҰ��, Career employee
    
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
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ�
����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�

�Է� : �����ȣ
���� : 1) SELECT�� employees
      2) IF���� �̿��ؼ� ������ ����
        -> ���ǽ� : ����, �޿�
���(���) : ����̸�, �޿�, �λ�� �޿�
*/

-- 1) SQL��
SELECT last_name, salary
FROM employees
WHERE employee_id = &�����ȣ;

-- 2) PLSQL
DECLARE
    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_raise NUMBER(6,1); -- NUMBER�� 38������ �ִ����
    v_result v_sal%TYPE;
BEGIN
    SELECT last_name, salary, v_raise
    INTO v_name, v_sal, v_raise
    FROM employees
    WHERE employee_id = &�����ȣ;
    
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
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('�λ�� �޿� : ' || v_result);
END;
/

-- �⺻ LOOP ��
DECLARE
    v_num NUMBER(38) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_num);
        EXIT WHEN v_num > 10; -- ��������(���� ������ �˷������), WHEN �������� �������� �׳� STOP
    END LOOP;
END;
/

-- WHILE LOOP��
DECLARE
    v_num NUMBER(38,0) := 1;
BEGIN
    WHILE v_num < 5 LOOP -- �ݺ�����
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

-- ���� : 1���� 10���� �������� ��
-- 1) �⺻ LOOP
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

-- �Ǵٸ� ���
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
    FOR idx IN -10 .. 5 LOOP -- dot�� �������� ��: �ּҰ�, ��: �ִ밪
        IF MOD(idx,2) <> 0 THEN -- MOD : ������ ������, <> -> != �� �ǹ�, 2�� �������� �� �������� 0�� �ƴ� ��
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- ���ǻ��� 1) ���� ����
BEGIN
    FOR idx IN REVERSE -10 .. 5 LOOP -- �Ųٷ� ����ϰ� ���� �� IN �ڿ� REVERSE�� �־��ָ� �� 
        IF MOD(idx,2) <> 0 THEN
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- ���ǻ��� 2) ī����(counter)
DECLARE
    v_num NUMBER(2,0) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num * 2;
    DBMS_OUTPUT.PUT_LINE(v_num);
    DBMS_OUTPUT.PUT_LINE('==============================');
    FOR v_num IN 1 .. 10 LOOP
        -- v_num := v_num * 2; -- FOR LOOP �ȿ����� �ӽú����� ���� ��ȯ�Ϸ��� �ϸ� �ȵ�
        -- v_num := 0;
        DBMS_OUTPUT.PUT_LINE(v_num);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_num);
END;
/

-- ���� : 1���� 10���� �������� ��
-- 3) FOR LOOP
DECLARE
    -- ������ : 1 ~ 10 => FOR LOOP�� ī���ͷ� ó��
    -- �հ�
    v_total NUMBER(2,0) := 0; -- �ʱⰪ �ֱ�
BEGIN
    FOR num IN 1 .. 10 LOOP
        v_total := v_total + num;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

/*

1. ������ ���� ��µǵ��� �Ͻÿ�.
*       
**
***
****
*****

LOOP���� ||

*/

-- LOOP
DECLARE
    v_star VARCHAR2(10) := ''; -- null�� ������ ���� �ʱ� ������ ������ �־����
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

-- ���� FOR LOOP
BEGIN
    FOR counter IN 1 .. 5 LOOP  -- ���° ��
        FOR i IN 1 .. counter LOOP -- *
            DBMS_OUTPUT.PUT('*'); -- �ܵ� ���Ұ�, PUT�� ����ϴ� ��� �ݵ�� ���������� PUT_LINE�� ����������
        END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
    END LOOP;    
END;
/
