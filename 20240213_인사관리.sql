-- yy/MM/dd 기본 oracle 날짜포맷
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
-- 제약조건은 MODIFY의 개념이 없기때문에 제약조건을 수정하고 싶으면 DROP한 다음에 ADD로 추가

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
    '총무팀',
    '본101호',
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
    '회계팀',
    '본102호',
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
    '영업팀',
    '본103호',
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
    '박민수',
    TO_DATE('12/03/02', 'YY/MM/DD'), -- (실제값, format) 기본적으로 매개변수는 2개임
    '대구',
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
    '박준식',
    TO_DATE('10/09/01', 'YY/MM/DD'),
    '경산',
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
    '선아라',
    TO_DATE('12/03/02', 'YY/MM/DD'),
    '대구',
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
    '이범수',
    TO_DATE('11/03/02', 'YY/MM/DD'),
    '서울',
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
    '이융희',
    TO_DATE('12/09/01', 'YY/MM/DD'),
    '부산',
    '010-1234-2222',
    1003
);

-- 9
ALTER TABLE employee
MODIFY empname NOT NULL;

-- 10 서브쿼리와 조인 둘다 사용가능하지만 가능한 조인을 권장
-- JOIN은 집합임
-- INNER JOIN(교집합) : 조건에 해당, 보통 생략하고 사용하는 조인  / OUTER JOIN : 조건에 해당하지 않는 대상들에 대해서 어떻게 처리할 것인지
-- OUTER JOIN > FULL(합집합) : 조건을 만족하든 하지않든 전부 다 출력하겠다 , LEFT, RIGHT > 두 테이블 중 누구를 출력을 할 것인가
-- INNER JOIN과 OUTER JOIN 둘은 서로 대체될 수 없음
SELECT e.empname,
       e.hiredate,
       d.deptname
FROM   employee e
       INNER JOIN department d
       ON(e.deptid = d.deptid)
WHERE     d.deptname = '총무팀';

-- 모든 부서의 사원정보
SELECT employee_id,
       first_name,
       depatment_name
FROM   employees e
       RIGHT OUTER JOIN departments d
       ON(e.depatment_id = d.depatment_id);

-- 11
DELETE FROM employee
WHERE  ADDR = '대구';

-- 12
UPDATE employee
SET deptid = (SELECT deptid
              FROM department
              WHERE deptname = '회계팀')
WHERE deptid = (SELECT deptid
                FROM department
                WHERE deptname = '영업팀');

-- 13
-- IN을 사용하여 비교할 수도 있음
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
-- GRANT CREATE VIEW TO hr; 관리자에서 권한을 부여
-- OR REPLACE : 이미 존재하는걸 덮어씀 / 현업에서 사용할 때는 특히나 조심해야함
CREATE OR REPLACE VIEW employee_view
AS
    SELECT e.empname eid,
           e.addr eaddr,
           d.deptname dname
    FROM   employee e
           JOIN department d
           ON (e.deptid = d.deptid) 
    WHERE  d.deptname = '총무팀';
    