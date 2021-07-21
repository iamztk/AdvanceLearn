create or replace function getSubStr (str varchar2)
return emp_id_table pipelined is   --》 返回的是object类型的集合？？

     cursor emp_list_cursor is   --声明显式游标
             select regexp_substr(str,'[^,]+',1,LEVEL)
            from dual
            CONNECT BY regexp_substr(str,'[^,]+',1,LEVEL) is not null; --条件语句
     v_emp_id_type EMP_ID_TYPE;   --Object对象
     v_emp_id varchar2(300);              --临时变量
     begin
       OPEN emp_list_cursor;
           loop

               fetch emp_list_cursor into v_emp_id;  
               exit when emp_list_cursor%notfound; --这两句是体环

               v_emp_id_type := EMP_ID_TYPE(v_emp_id);  --取值
               PIPE ROW(v_emp_id_type);   --管道   将字符串拆分为多条

           end loop;
       CLOSE emp_list_cursor;
     return;
  end;
  
--OR REPLACE 子句   指定 CREATE OR REPLACE FUNCTION 将创建一个新函数或替换同名的现有函数。替换函数时会更改函数的定义，但保留现有特权。

--不能将 OR REPLACE 子句与临时函数一起使用。

pipelined 是oracle管道函数是一类特殊的函数，oracle管道函数返回值类型必须为集合

CREATE OR REPLACE TYPE EMP_ID_TYPE AS OBJECT(code varchar2(20)) 自定义类型
CREATE OR REPLACE TYPE EMP_ID_TABLE  AS TABLE of EMP_ID_TYPE  自定义类型



