SET SERVEROUTPUT ON 
SET TIMING ON
-- 묵시적 커서와 커서속성
/**
    커서란 특정 SQL문장을 처리한 결과를 담고 있는 영역(PRIVATE SQL 이라는 메모리 영역)을 가리키는 일종의 포인터로, 
    커서를 사용하면 처리된 SQL 문장의 결과 집합에 접근할 수 있다. 
    
    개별 로우에 순차적으로 접근이 가능하다.
    
    종류 
    1. 묵시적 커서 (오라클 내부에서 자동생성) PL/SQL 블로에서 실행하는 SQL 문장
      (INSERT, UPDATE, SELECT .. ) 이 실행될 때마다 자동으로 생성.
    2. 명시적 커서 (사용자가 직접 정의) 
    순서 open -> fetch -> close 
    명시적은 선언도 필요 
*/

--1
DECLARE 
  vn_department_id employees.department_id%TYPE := 80;
BEGIN
	-- 80번 부서의 사원이름을 자신의 이름으로 갱신
	 UPDATE employees
	     SET emp_name = emp_name
	   WHERE department_id = vn_department_id;	   
	   
	-- 몇 건의 데이터가 갱신됐는지 출력  없으면 0을 반환
	DBMS_OUTPUT.PUT_LINE('묵시적 커서 :'||SQL%ROWCOUNT); 
	COMMIT;
END;


-- 명시적 커서
--2
DECLARE
   -- 사원명을 받아오기 위한 변수 선언
   vs_emp_name employees.emp_name%TYPE;

   --1.단계 커서 선언 : 명칭과 사용 쿼리 선언 매개변수로 부서코드를 받는다.
   -- CURSOR 커서명 [(매개변수1, 매개변수2, ..)]

   CURSOR cur_emp_dep ( cp_department_id employees.department_id%TYPE )

   IS

   SELECT emp_name
     FROM employees
    WHERE department_id = cp_department_id;

BEGIN
	--2.단계 커서 오픈 (매개변수로 90번 부서를 전달)
	OPEN cur_emp_dep (90);

	--3.단계 패치 단계에서 커서 사용
	LOOP
	
    	  -- 반복문을 통한 커서 패치작업
	  -- 커서 결과로 나온 로우를 패치함 (사원명을 변수에 할당)
	  FETCH cur_emp_dep INTO vs_emp_name;
	  -- 더 이상 패치된 참조로우가 없는 경우 LOOP 탈출
	  EXIT WHEN cur_emp_dep%NOTFOUND;
	  -- 사원명을 출력
	  DBMS_OUTPUT.PUT_LINE(vs_emp_name);

  END LOOP;
  --4.단계 커서 닫기(반드시 닫아야함)
  CLOSE cur_emp_dep;

END;
	
	
-- 커서와 FOR문
--3
DECLARE
   -- 커서 선언, 매개변수로 부서코드를 받는다.
   CURSOR cur_emp_dep ( cp_department_id employees.department_id%TYPE )

   IS
   SELECT emp_name
     FROM employees
    WHERE department_id = cp_department_id;
    
BEGIN
	-- FOR문을 통한 커서 패치작업 ("초깃값.. 최종값" 대신 커서가 위치한다)
	-- FOR 레코드 IN 커서명(매개변수1, 매개변수2,...) 

	FOR emp_rec IN cur_emp_dep(90)
	LOOP
	  -- 사원명을 출력, 레코드 타입은 레코드명.컬럼명 형태로 사용
	  DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name);
  END LOOP;
END;

--FOR문에 직접 커서 정의 넣을 수 있다. 
--4
DECLARE
BEGIN
	-- FOR문을 통한 커서 패치작업 ( 커서 선언시 정의 부분을 FOR문에 직접 기술)
	FOR emp_rec IN ( SELECT emp_name
                         FROM employees
                         WHERE department_id = 90	
	               ) 
	LOOP
	  -- 사원명을 출력, 레코드 타입은 레코드명.컬럼명 형태로 사용
	  DBMS_OUTPUT.PUT_LINE(emp_rec.emp_name);
	END LOOP;
END;

/**
 명시적 커서는 "CURSOR 커서명 IS SELECT ..." 형태로 선언한 뒤, '커서명'을 참조해서 사용했다. 
 즉 명시적 커서를 사용할 때는 커서명을 마치 변수처럼 사용했는데, 정확히 말하면 
 변수라기보다는 '상수'라고 할 수 있다. 
 커서를 변수처럼 할당한뒤 다시 다른 값을 할당해서 사용하려면 커서변수를 사용해야한다. 
**/
--5
DECLARE
   -- 사원명을 받아오기 위한 변수 선언
   vs_emp_name employees.emp_name%TYPE;

   TYPE emp_dep_curtype IS REF CURSOR;                               -- 약한 커서타입 선언 
-- TYPE emp_dep_curtype IS REF CURSOR RETURN departments%ROWTYPE;    -- 강한 커서타입 선언 (집합을 고정해서)
   -- 커서변수 선언
   emp_dep_curvar emp_dep_curtype; -- 커서변수 선언
BEGIN
  -- 커서변수를 사용한 커서정의 및 오픈
  OPEN emp_dep_curvar FOR SELECT emp_name
                          FROM employees
                          WHERE department_id = 90	;
  -- LOOP문
  LOOP
     -- 커서변수를 사용해 결과집합을  vs_emp_name 변수에 할당 
     FETCH emp_dep_curvar INTO vs_emp_name;
	  -- 더 이상 패치된 참조로우가 없는 경우 LOOP 탈출(커서변수를 이용한 커서속성 참조)
	  EXIT WHEN emp_dep_curvar%NOTFOUND;
	  -- 사원명을 출력
	  DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
  CLOSE emp_dep_curvar;
END;

--6------------------------------------------------------------------------------------
DECLARE
   -- 사원명을 받아오기 위한 변수 선언
   vs_emp_name employees.emp_name%TYPE;
   -- SYS_REFCURSOR 타입의 커서변수 선언
   -- oracle 에서 제공하는 커서타입
   emp_dep_curvar SYS_REFCURSOR;
BEGIN
  -- 커서변수를 사용한 커서정의 및 오픈
  OPEN emp_dep_curvar FOR SELECT emp_name
                     FROM employees
                    WHERE department_id = 90;
  -- LOOP문
  LOOP
     -- 커서변수를 사용해 결과집합을  vs_emp_name 변수에 할당 
     FETCH emp_dep_curvar INTO vs_emp_name;
	  -- 더 이상 패치된 참조로우가 없는 경우 LOOP 탈출(커서변수를 이용한 커서속성 참조)
	  EXIT WHEN emp_dep_curvar%NOTFOUND;
	  -- 사원명을 출력
	  DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
  CLOSE emp_dep_curvar;
END;

-- 커서변수를 매개변수로 전달
--7----------------------------------------------------------------------------------------------
DECLARE
    -- (ⅰ) SYS_REFCURSOR 타입의 커서변수 선언
   emp_dep_curvar SYS_REFCURSOR;
    -- 사원명을 받아오기 위한 변수 선언
   vs_emp_name employees.emp_name%TYPE;

   -- (ⅱ) 커서변수를 매개변수르 받는 프로시저, 매개변수는 SYS_REFCURSOR 타입의 IN OUT형
   PROCEDURE test_cursor_argu ( p_curvar IN OUT SYS_REFCURSOR)
   IS
       c_temp_curvar SYS_REFCURSOR;
   BEGIN
       -- 커서를 오픈한다
       OPEN c_temp_curvar FOR 
             SELECT emp_name
               FROM employees
             WHERE department_id = 90;
        -- (ⅲ) 오픈한 커서를 IN OUT 매개변수에 다시 할당한다. 
        p_curvar := c_temp_curvar;
   END;

BEGIN
   -- 프로시저를 호출한다. 
   test_cursor_argu (emp_dep_curvar);
   -- (ⅳ) 전달해서 받은 매개변수를 LOOP문을 사용해 결과를 출력한다. 
   LOOP
     -- 커서변수를 사용해 결과집합을  vs_emp_name 변수에 할당 
     FETCH emp_dep_curvar INTO vs_emp_name;
	  -- 더 이상 패치된 참조로우가 없는 경우 LOOP 탈출(커서변수를 이용한 커서속성 참조)
	  EXIT WHEN emp_dep_curvar%NOTFOUND;
	  -- 사원명을 출력
	  DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
END;

--8
------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE test_cursor_argu ( p_curvar IN OUT SYS_REFCURSOR)
   IS
       c_temp_curvar SYS_REFCURSOR;
   BEGIN
       -- 커서를 오픈한다
       OPEN c_temp_curvar FOR 
             SELECT emp_name
               FROM employees
             WHERE department_id = 90;
        -- (ⅲ) 오픈한 커서를 IN OUT 매개변수에 다시 할당한다. 
        p_curvar := c_temp_curvar;
   END;

-- 위에 프로시져를 아래와 같이 사용가능 -------------------------------------------------
DECLARE
    -- (ⅰ) SYS_REFCURSOR 타입의 커서변수 선언
   emp_dep_curvar SYS_REFCURSOR;
    -- 사원명을 받아오기 위한 변수 선언
   vs_emp_name employees.emp_name%TYPE;
   -- (ⅱ) 커서변수를 매개변수르 받는 프로시저, 매개변수는 SYS_REFCURSOR 타입의 IN OUT형
BEGIN
   -- 프로시저를 호출한다. 
   test_cursor_argu (emp_dep_curvar);
   -- (ⅳ) 전달해서 받은 매개변수를 LOOP문을 사용해 결과를 출력한다. 
   LOOP
     -- 커서변수를 사용해 결과집합을  vs_emp_name 변수에 할당 
     FETCH emp_dep_curvar INTO vs_emp_name;
	  -- 더 이상 패치된 참조로우가 없는 경우 LOOP 탈출(커서변수를 이용한 커서속성 참조)
	  EXIT WHEN emp_dep_curvar%NOTFOUND;
	  -- 사원명을 출력
	  DBMS_OUTPUT.PUT_LINE(vs_emp_name);
  END LOOP;
END;

--9 커서 표현식 ----------------------------------------------------------------------------------------------

DECLARE
    -- 커서표현식을 사용한 명시적 커서 선언
    CURSOR mytest_cursor IS
         SELECT d.department_name,      
                  CURSOR ( SELECT e.emp_name
                                 FROM employees e
                                WHERE e.department_id = d.department_id) AS emp_name        
          FROM departments d
        WHERE d.department_id = 90;
    -- 부서명을 받아오기 위한 변수
    vs_department_name departments.department_name%TYPE;
    --커서표현식 결과를 받기 위한 커서타입변수
    c_emp_name SYS_REFCURSOR;
    -- 사원명을 받는 변수
    vs_emp_name employees.emp_name%TYPE;
BEGIN
    -- 커서오픈
    OPEN mytest_cursor;
    -- 명시적 커서를 받아오는 첫 번째 LOOP
    LOOP
       -- 부서명은 변수, 사원명 결과집합은 커서변수에 패치
       FETCH mytest_cursor INTO vs_department_name, c_emp_name;
       EXIT WHEN mytest_cursor%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE ('부서명 : ' || vs_department_name);
       -- 사원명을 출력하기 위한 두 번째 LOOP 
       LOOP
          -- 사원명 패치
          FETCH c_emp_name INTO vs_emp_name;
          EXIT WHEN c_emp_name%NOTFOUND;
          DBMS_OUTPUT.PUT_LINE('   사원명 : ' || vs_emp_name);
       END LOOP; -- 두 번째 LOOP 종료    
    END LOOP; -- 첫 번째 LOOP 종료
    CLOSE mytest_cursor;
END;

--10------------------------------------------------------------------------------------------------------------------------------------------------------------------- 커서 끝 

