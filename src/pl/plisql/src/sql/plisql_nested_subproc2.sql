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

