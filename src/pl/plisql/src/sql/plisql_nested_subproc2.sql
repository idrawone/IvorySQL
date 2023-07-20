--test ok
create or replace function test_subproc_func(a in integer) return integer as
  mds integer;
  original integer;
  function square(original in integer) return integer;
  function square(original in integer) return integer
  AS
       original_squared integer;
  begin
       original_squared := original * original;
       original := original_squared + 1;
       return original_squared;
   end;
begin
    mds := 10;
    original := square(mds);
    raise info '%',original;
    a := original + 1;
    return mds;
end;
/

--print 100 and 10
select * from test_subproc_func(23);
drop function test_subproc_func(integer);

---global variable the name as local variable
--test ok
create or replace function test_subproc_func(a in out integer) return integer AS
  mds integer;
  original integer;
  function square(original in out integer) return integer;
  function square(original in out integer) return integer
  AS
       original_squared integer;
	   a integer;
  BEGIN
       a := 23;
       original_squared := original * original;
       raise info 'mds=%', mds;
       raise info 'original=%', original;
	   raise info 'local var a = %',a;
	   raise info 'global a = %', test_subproc_func.a;
       original := original_squared + 1;
       --return original_squared;
   end;
begin
    mds := 10;
    original := 21;
    original := square(mds);
    raise info '%', original;
    a := original + 1;
    --return mds;
end;
/
--print mds=10 original=10 local var a =23
--global a =21 101 102
select * from test_subproc_func(21);
drop function test_subproc_func(integer);
---schema function and subproc function as the same name
create or replace function test_subproc(id integer) return integer
AS
   var1 integer;
begin
    var1 := id;
    raise info 'schema function test_subproc';
    return var1;
END;
/

drop function test_subproc(integer);

--test ok
create or replace function test_mds(id integer) return integer AS
  ids integer;
  function test_subproc(id integer) return integer result_cache;
  function test_subproc(id integer) return integer result_cache
 IS
  declare
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/
--test failed
create or replace function test_mds(id integer) return integer AS
  ids integer;
  function test_subproc(id integer) return integer result_cache relies_on (mds);
  function test_subproc(id integer) return integer result_cache relies_on (mds)
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/
--test ok
create or replace function test_mds(id integer) return integer as
  ids integer;
  function test_subproc(id integer) return integer result_cache;
  function test_subproc(id integer) return integer result_cache relies_on (mds)
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--print 23 23
select * from test_mds(23);

--test ok
create or replace function test_mds(id integer) return integer AS
  ids integer;
  function test_subproc(id integer) return integer DETERMINISTIC result_cache;
  function test_subproc(id integer) return integer DETERMINISTIC result_cache
  IS
    var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer  result_cache DETERMINISTIC;
  function test_subproc(id integer) return integer  result_cache DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer AS
  ids integer;
  function test_subproc(id integer) return integer  result_cache;
  function test_subproc(id integer) return integer  result_cache DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer AS
  ids integer;
  function test_subproc(id integer) return integer;
  function test_subproc(id integer) return integer DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer is
ids integer;
  function test_subproc(id integer) return integer DETERMINISTIC;
  function test_subproc(id integer) return integer
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer RESULT_CACHE;
  function test_subproc(id integer) return integer
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer;
  function test_subproc(id integer) return integer RESULT_CACHE
 Is
   var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer;
  function test_subproc(id integer) return integer RESULT_CACHE DETERMINISTIC
 Is
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer RESULT_CACHE DETERMINISTIC;
  function test_subproc(id integer) return integer
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer RESULT_CACHE;
  function test_subproc(id integer) return integer DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer DETERMINISTIC;
  function test_subproc(id integer) return integer RESULT_CACHE
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test failed
create or replace function test_mds(id integer) return integer AS
  ids integer;
  function test_subproc(id integer) return integer result_cache result_cache;
  function test_subproc(id integer) return integer  result_cache result_cache
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer DETERMINISTIC RESULT_CACHE;
  function test_subproc(id integer) return integer RESULT_CACHE
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer RESULT_CACHE;
  function test_subproc(id integer) return integer RESULT_CACHE DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

--test ok
create or replace function test_mds(id integer) return integer AS
ids integer;
  function test_subproc(id integer) return integer RESULT_CACHE;
  function test_subproc(id integer) return integer RESULT_CACHE relies_on (mds,sds) DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
    return id;
end;
/

drop function test_mds(integer);

--test ok
create or replace procedure test_mds(id integer) AS
ids integer;
  function test_subproc(id integer) return integer RESULT_CACHE;
  function test_subproc(id integer) return integer RESULT_CACHE DETERMINISTIC
 IS
  var1 integer;
  begin
     var1 := id;
     return var1;
  end;
begin
    ids := test_subproc(23);
    raise info '%', id;
end;
/

drop procedure test_mds(integer);

--test ok
create or replace function test_subprocfunc(id integer) return integer
as
  mds integer;
  function test_subprocfunc(id integer) return integer;
  procedure test_subprocproc(id integer);
  procedure test_subprocproc(id integer) IS
    var1 integer;
  begin
    raise info 'test_subprocproc';
  end;
  function test_subprocfunc(id integer) return integer IS
    var1 integer;
   begin
     raise info 'test_subprocfunc';
     return id;
   end;
begin
  call test_subprocproc(23);
  mds := test_subprocfunc(23);
  return mds;
end;
/

--test ok
create or replace procedure test_subprocproc(id integer)
AS
  mds integer;
  function test_subprocfunc(id integer) return integer;
  procedure test_subprocproc(id integer);
  procedure test_subprocproc(id integer) IS
    var1 integer;
  begin
    raise info 'test_subprocproc';
  end;
  function test_subprocfunc(id integer) return integer IS
    var1 integer;
   begin
     raise info 'test_subprocfunc';
     return id;
   end;
begin
  call test_subprocproc(23);
  mds := test_subprocfunc(23);
end;
/

--test ok
create or replace procedure test_subprocproc(id integer) AS
  var1 integer;
  function square(original integer) return integer;
  function square(original integer) return integer
  AS
       original_squared integer;
       var1 integer;
       function test(test integer) return integer
       AS
          var1 integer;
	      var2 integer;
       begin
           var1 := 55;
	   raise info '%',var1;
           var2 := var1 + 10;
	   return var2;
       end;
  begin
       var1 := 45;
       original_squared := original * original;
       raise info '%',var1;
       var1 := test(23);
       return original_squared;
   end;
begin
    var1 := 23;
    var1 := square(100);
    raise info '%', var1;
 end;
/

drop procedure test_subprocproc(integer);
--only declare but no define and no use ok
DECLARE
  var1 integer;
  function mds(id integer) return integer;
begin
  var1 := 23;
end;
/

--no define but use failed
DECLARE
  var1 integer;
  function mds(id integer) return integer;
begin
  var1 := mds(23);
end;
/

--again
DECLARE
  var1 integer;
  function mds(id integer) return integer;
begin
  var1 := mds(23);
end;
/

--define before declare faield
declare
   function mds(id integer) return integer IS
      var1 integer;
   begin
      var1 := id;
      return id;
   end;
   function mds(id integer) return integer;
begin
   NULL;
end;
/

--duplicate define failed
declare
   function mds(id integer) return integer IS
      var1 integer;
   begin
      var1 := id;
      return id;
   end;
   function mds(id integer) return integer IS
      var2 integer;
   begin
      var2 := id;
      return id;
    end;
begin
   NULL;
end;
/

--
--
-- subproc function support polymorphic type
--
--point raise error others is ok
DECLARE
   var1 integer;
   var2 number;
   var3 point;
   function f1(x anyelement) return anyelement as
   begin
	return x + 1;
   END;
BEGIN
   var1 := f1(42);
   var2 := f1(4.5);
   raise info 'var1=%,var2=%',var1,var2;
   var3 := f1(point(3,4));
end;
/

--global var
CREATE TABLE mds(id integer,name varchar2(1024));

--ok
DECLARE
   var1 integer;
   var2 number;
   var3 mds%rowtype;
   function f1(x anyelement) return anyelement as
   BEGIN
    var3.id := var3.id + 1;
	var3.name := var3.name || x;
	return x + 1;
   END;
BEGIN
   var3.id := 1;
   var3.name := 'ok';
   var1 := f1(42);
   var2 := f1(4.5);
   raise info 'var1=%,var2=%',var1,var2;
   raise info '%', var3;
end;
/

--two nested ok
DECLARE
   var1 integer;
   var2 number;
   var3 mds%rowtype;
   function f1(x anyelement) return anyelement AS
      var1 integer;
	  var2 number;
      FUNCTION test_f(x anyelement) RETURN  anyelement AS
      BEGIN
          var3.id := var3.id + 1;
		  var3.name := var3.name || x;
		  RETURN x + 1;
	  end;
   BEGIN
    var1 := test_f(24);
	var2 := test_f(5.4);
    var3.id := var3.id + 1;
	var3.name := var3.name || x;
	return x + 1;
   END;
BEGIN
   var3.id := 1;
   var3.name := 'ok';
   var1 := f1(42);
   var2 := f1(4.5);
   raise info 'var1=%,var2=%',var1,var2;
   raise info '%', var3;
end;
/

--ok
DECLARE
    function f1(x anyelement) return anyarray as
	begin
	  return array[x + 1, x + 2];
	end;
BEGIN
   raise info '%', f1(42);
   raise info '%', f1(4.5);
end;
/

--ok
declare
	function f1(x anyarray) return anyelement as
	begin
	  return x[1];
	END;
BEGIN
   raise info '%,%', f1(array[2,4]),f1(array[4.5,7.7]);
END;
/

declare
  function f1(x anyarray) return anyarray as
  begin
     return x;
  end;
BEGIN
  raise info '%,%', f1(array[2,4]),f1(array[4.5, 7.7]);
end;
/


-- fail, can't infer type:
declare
  function f1(x anyelement) return anyrange as
  begin
    return array[x + 1, x + 2];
  end;
BEGIN
  NULL;
end;
/

--ok
DECLARE
   function f1(x anyrange) return anyarray as
   begin
       return array[lower(x), upper(x)];
   end;
BEGIN
  raise info '%,%', f1(int4range(42,49)), f1(int8range(430,460));
end;
/

--ok
declare
   function f1(x anycompatible, y anycompatible) RETURN anycompatiblearray AS
	begin
	  return array[x, y];
	end;
BEGIN
   raise info '%,%', f1(2,4),f1(2,4.5);
end;
/

--failed
declare
  function f1(x anycompatiblerange, y anycompatible, z anycompatible) return anycompatiblearray as
  begin
      return array[lower(x), upper(x), y, z];
  end;
BEGIN
  raise info '%',f1(int4range(42, 49), 11, 2::smallint);
  raise info '%',f1(int4range(42, 49), 11, 4.5); --failed
end;
/


-- fail, can't infer type:
declare
   function f1(x anycompatible) return anycompatiblerange as
   begin
     return array[x + 1, x + 2];
   end;
BEGIN
  NULL;
end;
/

declare
   function f1(x anycompatiblerange, y anycompatiblearray) return anycompatiblerange as
   begin
      return x;
   end;
BEGIN
   raise info '%,%',f1(int4range(42, 49), array[11]), f1(int4range(42, 50), array[11]);
END;
/

DECLARE
   r record;
   function f1(a anyelement, b anyarray,
                   c anycompatible, d anycompatible,
                   x OUT anyarray, y OUT anycompatiblearray) RETURN record
	as
	begin
	  x := a || b;
	  y := array[c, d];
	end;
begin
	r := f1(11, array[1, 2], 42, 34.5, NULL,NULL);
	raise info 'r=%',r;
	r := f1(11, array[1, 2], point(1,2), point(3,4), NULL,NULL);
	raise info 'r=%',r;
	r := f1(11, '{1,2}', point(1,2), '(3,4)', NULL,NULL);
	raise info 'r=%',r;
	r := f1(11, array[1, 2.2], 42, 34.5, NULL,NULL);  -- fail
	raise info 'r=%',r;
END;
/
--ok
declare
   function test_f(id anyelement) return anyelement is
   begin
     return id + 1;
   end;
 begin
    raise info '%', test_f(23);
    raise info '%', test_f(24.1);
 end;
 /
--ok
create schema test;
create or replace procedure test.test_proc(id integer) is
  var1 integer;
  function test_f(id integer) return integer;
  procedure test_p2(id integer);
  procedure test_p(id integer) is
    var2 integer;
  begin
     var2 := 1;
     raise info 'subproc level 1 test_p';
   end;
   function test_f(id integer) return integer as
     var3 integer;
     function test_f1(id integer) return integer;
     procedure test_p2(id integer);
     function test_p2(id integer) return integer as
       var3 integer;
     begin
        var3 := 4;
	raise info 'invoke test_f1.test_p2';
	return var3;
     end;
     function test_f1(id integer) return integer is
       var4 integer;
     begin
       if var4 = 23 then
         var4 := 1;
         raise info 'xiexie';
       else
         var4 := 5;
         raise info 'welcome';
       end if;
       return var4;
      end;
      procedure test_p2(id integer) is
      begin
        var3 := 1;
      end;
   begin
      var3 := 1;
      raise info 'subproc level 1 test_f';
      var3 := test_f1(var3);
      var3 := test_p2(var3);
      return var3;
   end;
   procedure test_p2(id integer) is
     var2 integer;
   begin
      var2 := 23;
      raise info 'subproc level 1 test_p2';
   end;
begin
  var1 := 2;
  raise info 'var1 = %', var1;
  declare
     function test_f1(id integer) return integer;
     function test_f1(id integer) return integer IS
        i integer;
     begin
        var1 := 1;
        raise info 'begin in subproc';
		FOR i IN 0..9 LOOP
           raise info '%',i;
			IF i % 2 = 0 THEN
				raise info 'even number';
			ELSE
				raise info 'odd number';
			END IF;
		END LOOP;
		return var1;
     end;
  begin
     var1 := test_f1(var1);
     var1 := test_f(23);
  end;
end;
/
call test.test_proc(23);
create or replace procedure test.test_proc1(id integer) is
  var1 integer;
begin
  var1 := 2;
  raise info 'var1 = %', var1;
  declare
     function test_f1(id integer) return integer;
     function test_f1(id integer) return integer IS
        i integer;
     begin
        var1 := 1;
        raise info 'begin in subproc';
		FOR i IN 0..9 LOOP
           raise info '%',i;
			IF i % 2 = 0 THEN
				raise info 'even number';
			ELSE
				raise info 'odd number';
			END IF;
		END LOOP;
		return var1;
     end;
  begin
     var1 := test_f1(var1);
  end;
end;
/
call test.test_proc1(23);
--ok
declare
  var1 integer;
  function test_f(id integer) return integer;
  procedure test_p2(id integer);
  procedure test_p(id integer) is
    var2 integer;
  begin
     var2 := 1;
     raise info 'subproc level 1 test_p';
   end;
   function test_f(id integer) return integer as
     var3 integer;
     function test_f1(id integer) return integer;
     procedure test_p2(id integer);
     function test_p2(id integer) return integer as
       var3 integer;
     begin
        var3 := 4;
	raise info 'invoke test_f1.test_p2';
	return var3;
     end;
     function test_f1(id integer) return integer is
       var4 integer;
     begin
       if var4 = 23 then
         var4 := 1;
         raise info 'xiexie';
       else
         var4 := 5;
         raise info 'welcome';
       end if;
       return var4;
      end;
      procedure test_p2(id integer) is
      begin
        var3 := 1;
      end;
   begin
      var3 := 1;
      raise info 'subproc level 1 test_f';
      var3 := test_f1(var3);
      var3 := test_p2(var3);
      return var3;
   end;
   procedure test_p2(id integer) is
     var2 integer;
   begin
      var2 := 23;
      raise info 'subproc level 1 test_p2';
   end;
begin
  var1 := 2;
  raise info 'var1 = %', var1;
  declare
     function test_f1(id integer) return integer;
     function test_f1(id integer) return integer IS
        i integer;
     begin
        var1 := 1;
        raise info 'begin in subproc';
		FOR i IN 0..9 LOOP
           raise info '%',i;
			IF i % 2 = 0 THEN
				raise info 'even number';
			ELSE
				raise info 'odd number';
			END IF;
		END LOOP;
		return var1;
     end;
  begin
     var1 := test_f1(var1);
     var1 := test_f(23);
  end;
end;
/
--ok and print
BEGIN
   raise info 'welccome to begin';
declare
  var1 integer;
  function test_f(id integer) return integer;
  procedure test_p2(id integer);
  procedure test_p(id integer) is
    var2 integer;
  begin
     var2 := 1;
     raise info 'subproc level 1 test_p';
   end;
   function test_f(id integer) return integer as
     var3 integer;
     function test_f1(id integer) return integer;
     procedure test_p2(id integer);
     function test_p2(id integer) return integer as
       var3 integer;
     begin
        var3 := 4;
	raise info 'invoke test_f1.test_p2';
	return var3;
     end;
     function test_f1(id integer) return integer is
       var4 integer;
     begin
       if var4 = 23 then
         var4 := 1;
         raise info 'xiexie';
       else
         var4 := 5;
         raise info 'welcome';
       end if;
       return var4;
      end;
      procedure test_p2(id integer) is
      begin
        var3 := 1;
      end;
   begin
      var3 := 1;
      raise info 'subproc level 1 test_f';
      var3 := test_f1(var3);
      var3 := test_p2(var3);
      return var3;
   end;
   procedure test_p2(id integer) is
     var2 integer;
   begin
      var2 := 23;
      raise info 'subproc level 1 test_p2';
   end;
begin
  var1 := 2;
  raise info 'var1 = %', var1;
  declare
     function test_f1(id integer) return integer;
     function test_f1(id integer) return integer IS
        i integer;
     begin
        var1 := 1;
        raise info 'begin in subproc';
		FOR i IN 0..9 LOOP
           raise info '%',i;
			IF i % 2 = 0 THEN
				raise info 'even number';
			ELSE
				raise info 'odd number';
			END IF;
		END LOOP;
		return var1;
     end;
  begin
     var1 := test_f1(var1);
     var1 := test_f(23);
  end;
end;
end;
/
--clean data
DROP PROCEDURE test.test_proc;
DROP PROCEDURE test.test_proc1;
DROP SCHEMA test;
