SET SERVEROUTPUT ON

/*
2. ġȯ����(&)�� ����Ͽ� ���ڸ� �Է��ϸ�
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½�
2 * 1 = 2
...
=> ġȯ���� : ����, ���� �Է�
=> ���ϴ� �� : 1���� 9����, ������ ==> LOOP��
*/

-- 1) LOOP => ���ǰ� ���õ� ���� �ʿ�!
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

-- 1) LOOP ������ �ڵ�
DECLARE
    v_dan CONSTANT NUMBER(2,0) := &��;
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

-- 2) WHILE LOOP ������ �ڵ�
DECLARE
    v_dan CONSTANT NUMBER(2, 0) := &��;
    v_num NUMBER(2, 0) := 1; -- ���� : 1 ~ 9, ���� ���
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

-- 3) FOR LOOP ������ �ڵ�
DECLARE
    v_dan CONSTANT NUMBER(2, 0) := &��;
BEGIN
    FOR num IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num || ' = ' || (v_dan * num));    
    END LOOP;
END;
/

/*
3. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
2 ~ 9 ������ ���� => �ݺ���
�� �ܺ��� ���ϴ� ��, 1 ~ 9 ������ ���� => �ݺ���
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

-- ���� �ٲٱ�
BEGIN
    FOR num IN 1..9 LOOP
        FOR dan IN 2..9 LOOP
           DBMS_OUTPUT.PUT(dan || ' * ' || num || ' = ' || (dan * num) || ' ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- WHILE LOOP => �ݺ����ǰ� ���õ� ����
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

-- �����ٲٱ�
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
4. ������ 1~9���� ��µǵ��� �Ͻÿ�.
   (��, Ȧ���� ���)
MOD(������, ������ ��) : ������
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

-- ������ �ڵ�/FOR LOOP
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

-- ������ �ڵ�/�⺻ LOOP
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

-- RECORD : �⺻������ ���� �����ؾ���
DECLARE
    -- 1) ����
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0),
        ename employees.last_name%TYPE,
        sal employees.salary%TYPE := 0);
    
    -- 2) ���� ����(�̸�, ������Ÿ�� �߽�����)
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    
    SELECT employee_id, first_name, salary
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT('�����ȣ : ' || v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ����̸� : ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', �޿� : ' || v_emp_info.sal);
    
END;
/

-- RECORD : %ROWTYPE
DECLARE
    v_emp_info employees%ROWTYPE; -- %ROWTYPE : �̹� �����ϰ� �ִ� ���̺�� �並 ��ä�� �޾ƿ��� ������ ������ ���ǰ� �ʿ����, �÷����� �ʵ���� �ȴ�
BEGIN
    SELECT *
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT('�����ȣ : ' || v_emp_info.employee_id);
    DBMS_OUTPUT.PUT(', ����̸� : ' || v_emp_info.last_name);
    DBMS_OUTPUT.PUT_LINE(', ���� : ' || v_emp_info.job_id);
END;
/

-- TABLE
DECLARE
    -- 1) ����
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER; -- PLS_INTEGER�� �˻� �ӵ��鿡�� ����
        
    -- 2) ���� ����
    v_num_info num_table_type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� �ε��� - 1000 : ' || v_num_info(-1000));
    
    v_num_info(-1000) := 10000; -- (�ε���)
    
    DBMS_OUTPUT.PUT_LINE('���� �ε��� - 1000 : ' || v_num_info(-1000));
END;
/

-- 2�� ��� 10���� ��� ���� : 2, 4, 6, 8, 10, 12, 14, ...
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
    
    DBMS_OUTPUT.PUT_LINE('�� ���� : ' || v_num_ary.COUNT);
    DBMS_OUTPUT.PUT_LINE('������ : ' || v_result);
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
    
    DBMS_OUTPUT.PUT_LINE('�� ���� : ' || v_emps.COUNT);
    DBMS_OUTPUT.PUT_LINE(v_emps(100).last_name);
END;
/

-- �� 20���� ������ ��� 
DECLARE
    v_min employees.employee_id%TYPE; -- �ּ� �����ȣ
    v_max employees.employee_id%TYPE; -- �ִ� �����ȣ
    v_result NUMBER(1,0);             -- ����� ���������� Ȯ��
    v_emp_record employees%ROWTYPE;     -- Employees ���̺��� �� �࿡ ����
    
    TYPE emp_table_type IS TABLE OF v_emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    -- �ּ� �����ȣ, �ִ� �����ȣ
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*) -- null�� ���� ó��
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
    -- Ŀ���� ����
    CURSOR emp_cursor IS -- SELECT���� �̸��� ���̴� �����̶� �����ϸ� ��
        SELECT employee_id, last_name
        FROM employees
        WHERE employee_id = 0;
    
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor; -- Ȱ������ ����
    
    FETCH emp_cursor INTO v_eid, v_ename;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    
    CLOSE emp_cursor; -- Ȱ������ ����
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
        
        -- ���� ���� ����
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
        WHERE department_id = &�μ���ȣ;
        
    v_emp_info emp_dept_cursor%ROWTYPE;    
BEGIN
    -- 1) �ش� �μ��� ���� ����� ������ ���
    -- 2) �ش� �μ��� ���� ����� ���� ��� '�ش� �μ��� �Ҽӵ� ������ �����ϴ�.';
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- ù��° => ���° ��
        DBMS_OUTPUT.PUT_LINE('ù��° : ' || emp_dept_cursor%ROWCOUNT);
        
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT(v_emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.job_id);
    END LOOP;
    
    -- �ι�° => ���� Ŀ���� ������ �� ����
    DBMS_OUTPUT.PUT_LINE('�ι�° : ' || emp_dept_cursor%ROWCOUNT);
    IF emp_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �Ҽӵ� ������ �����ϴ�.');
    END IF;
    
    CLOSE emp_dept_cursor;
    
END;
/

-- 1) ��� ����� �����ȣ, �̸�, �μ��̸� ���
-- SQL��
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
    LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id;
      
-- PL/SQL ���            
DECLARE
    CURSOR emp_all_cursor IS
        SELECT e.employee_id eid, e.last_name ename, d.department_name dept_name
        FROM employees e
            LEFT OUTER JOIN departments d
            ON e.department_id = d.department_id;
            
    v_emp_info emp_all_cursor%ROWTYPE; -- ROWTYPE�� ����� ��� ��Ī�ο�����
BEGIN
    OPEN emp_all_cursor;
    
    LOOP
        FETCH emp_all_cursor INTO v_emp_info;
        EXIT WHEN emp_all_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT('�����ȣ : ' || v_emp_info.eid);
        DBMS_OUTPUT.PUT(', ����̸� : ' || v_emp_info.ename);
        DBMS_OUTPUT.PUT_LINE(', �μ��̸� : ' || v_emp_info.dept_name);
    END LOOP;
    
    CLOSE emp_all_cursor;
END;
/
     
-- 2) �μ���ȣ�� 50�̰ų� 80�� ������� ����̸�, �޿�, ���� ���
-- ���� : (�޿� * 12) + (NVL(�޿�, 0) * NVL(Ŀ�̼�, 0) * 12)

-- SQL��
SELECT last_name, salary, (salary*12+(NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual, department_id
FROM employees
WHERE department_id IN (50, 80);

-- PL/SQL��        
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
        
        DBMS_OUTPUT.PUT('�μ���ȣ : ' || v_emp_info.department_id);
        DBMS_OUTPUT.PUT(', ����̸� : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT(', �޿� : ' || v_emp_info.salary);
        DBMS_OUTPUT.PUT_LINE(', ���� : ' || v_emp_info.annual);
    END LOOP;
    
    CLOSE emp_dept_cursor;
END;
/

-- SQL��
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id IN (50, 80);

-- PL/SQL��        
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
        DBMS_OUTPUT.PUT(', ����̸� : ' || v_emp_info.last_name);
        DBMS_OUTPUT.PUT(', �޿� : ' || v_emp_info.salary);
        DBMS_OUTPUT.PUT_LINE(', ���� : ' || v_annual);
    END LOOP;
    
    CLOSE emp_dept_cursor;
END;
/