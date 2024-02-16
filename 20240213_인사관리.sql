-- yy/MM/dd �⺻ oracle ��¥����
-- 6
CREATE TABLE department(
    deptid NUMBER(10) PRIMARY KEY,
    deptname VARCHAR2(10),
    location VARCHAR2(10),
    tel VARCHAR2(15)
);

CREATE TABLE employee(
    empid NUMBER(10) PRIMARY KEY,
    empname VARCHAR2(10),
    hiredate DATE,
    addr VARCHAR2(12),
    tel VARCHAR2(15),
    -- deptid NUMBER(10) REFERENCES department (deptid)
    deptid NUMBER(10),
    CONSTRAINT emp_dept_deptid_FK FOREIGN KEY(deptid) REFERENCES department(deptid)
);

SELECT
    deptid,
    deptname,
    location,
    tel
FROM department;

-- 7
ALTER TABLE employee
ADD birthday DATE;
-- MODIFY, DROP
-- ���������� MODIFY�� ������ ���⶧���� ���������� �����ϰ� ������ DROP�� ������ ADD�� �߰�

-- 8
INSERT INTO department
(
    deptid,
    deptname,
    location,
    tel
)
VALUES
(
    1001,
    '�ѹ���',
    '��101ȣ',
    '053-777-8777'
);

INSERT INTO department
(
    deptid,
    deptname,
    location,
    tel
)
VALUES
(
    1002,
    'ȸ����',
    '��102ȣ',
    '053-888-9999'
);

INSERT INTO department
(
    deptid,
    deptname,
    location,
    tel
)
VALUES
(
    1003,
    '������',
    '��103ȣ',
    '053-222-3333'
);

SELECT
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid,
    birthday
FROM employee;

INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES
(
    20121945,
    '�ڹμ�',
    TO_DATE('12/03/02', 'YY/MM/DD'), -- (������, format) �⺻������ �Ű������� 2����
    '�뱸',
    '010-1111-1234',
    1001
);

INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES
(
    20101817,
    '���ؽ�',
    TO_DATE('10/09/01', 'YY/MM/DD'),
    '���',
    '010-2222-1234',
    1003
);

INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES
(
    20122245,
    '���ƶ�',
    TO_DATE('12/03/02', 'YY/MM/DD'),
    '�뱸',
    '010-3333-1222',
    1002
);

INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES
(
    20121729,
    '�̹���',
    TO_DATE('11/03/02', 'YY/MM/DD'),
    '����',
    '010-3333-4444',
    1001
);

INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES
(
    20121646,
    '������',
    TO_DATE('12/09/01', 'YY/MM/DD'),
    '�λ�',
    '010-1234-2222',
    1003
);

-- 9
ALTER TABLE employee
MODIFY empname NOT NULL;

-- 10 ���������� ���� �Ѵ� ��밡�������� ������ ������ ����
-- JOIN�� ������
-- INNER JOIN(������) : ���ǿ� �ش�, ���� �����ϰ� ����ϴ� ����  / OUTER JOIN : ���ǿ� �ش����� �ʴ� ���鿡 ���ؼ� ��� ó���� ������
-- OUTER JOIN > FULL(������) : ������ �����ϵ� �����ʵ� ���� �� ����ϰڴ� , LEFT, RIGHT > �� ���̺� �� ������ ����� �� ���ΰ�
-- INNER JOIN�� OUTER JOIN ���� ���� ��ü�� �� ����
SELECT e.empname,
       e.hiredate,
       d.deptname
FROM   employee e
       INNER JOIN department d
       ON(e.deptid = d.deptid)
WHERE     d.deptname = '�ѹ���';

-- ��� �μ��� �������
SELECT employee_id,
       first_name,
       depatment_name
FROM   employees e
       RIGHT OUTER JOIN departments d
       ON(e.depatment_id = d.depatment_id);

-- 11
DELETE FROM employee
WHERE  ADDR = '�뱸';

-- 12
UPDATE employee
SET deptid = (SELECT deptid
              FROM department
              WHERE deptname = 'ȸ����')
WHERE deptid = (SELECT deptid
                FROM department
                WHERE deptname = '������');

-- 13
-- IN�� ����Ͽ� ���� ���� ����
SELECT e.empid,
       e.empname,
       e.birthday,
       d.deptname
FROM   employee e
       JOIN department d
       ON (e.deptid = d.deptid)
WHERE e.hiredate > (SELECT hiredate
                    FROM employee
                    WHERE empid = 20121729);
     
-- 14 
-- GRANT CREATE VIEW TO hr; �����ڿ��� ������ �ο�
-- OR REPLACE : �̹� �����ϴ°� ��� / �������� ����� ���� Ư���� �����ؾ���
CREATE OR REPLACE VIEW employee_view
AS
    SELECT e.empname eid,
           e.addr eaddr,
           d.deptname dname
    FROM   employee e
           JOIN department d
           ON (e.deptid = d.deptid) 
    WHERE  d.deptname = '�ѹ���';
    