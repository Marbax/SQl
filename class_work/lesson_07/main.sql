----------------------------------------------------------------------------------------------------
--                      Задание 1. Создайте следующие хранимые процедуры:
----------------------------------------------------------------------------------------------------

--- 1. Хранимая процедура выводит «Hello, world!»

if object_id('sp_hello_world','P')is not null
    drop procedure sp_hello_world;
go
create procedure sp_hello_world
as 
print 'Hello, world!';
go 
exec sp_hello_world;

--- 2. Хранимая процедура возвращает информацию о текущем времени

if object_id('sp_get_time','P')is not null
    drop procedure sp_get_time;
go
create procedure sp_get_time @time time output
as 
set @time=convert(time,getdate());
go 
declare @time time
exec sp_get_time @time output
--- print @time
select @time;

--- 3. Хранимая процедура возвращает информацию о текущей дате

if object_id('sp_get_date','P')is not null
    drop procedure sp_get_date;
go
create procedure sp_get_date @date date output
as 
set @date=convert(date,getdate());
go 
declare @date date
exec sp_get_date @date output
--- print @date
select @date;


--- 4. Хранимая процедура принимает три числа и возвращает их сумму

if object_id('sp_get_sum','P')is not null
    drop procedure sp_get_sum;
go
create procedure sp_get_sum @a int, @b int, @c int, @sum int output
as 
set @sum=@a+@b+@c;
go 
declare @sum int
exec sp_get_sum 2,4,5,@sum output
--- print @date
select @sum;


--- 5. Хранимая процедура принимает три числа и возвращает среднеарифметическое трёх чисел

if object_id('sp_get_avg','P')is not null
    drop procedure sp_get_avg;
go
create procedure sp_get_avg @a int, @b int, @c int, @avg float output
as 
set @avg=(@a+@b+@c)/3;
go 
declare @avg float
exec sp_get_avg 5,4,5,@avg output
--- print @date
select @avg;


--- 6. Хранимая процедура принимает три числа и возвращает максимальное значение

if object_id('sp_get_max','P')is not null
    drop procedure sp_get_max;
go
create procedure sp_get_max @a int, @b int, @c int, @avg int output
as 
set @avg=@a;
if(@avg<@b)
set @avg=@b;
if(@avg<@c)
set @avg=@c;
go 
declare @avg int
exec sp_get_max 51,114,115,@avg output
--- print @date
select @avg;



--- 7. Хранимая процедура принимает три числа и возвращает минимальное значение



--- 8. Хранимая процедура принимает число и символ. В результате работы хранимой процедуры отображается линия длиной
--- равной числу. Линия построена из символа, указанного во втором параметре. 
--- Например, если было передано 5 и#, мы получим линию такого вида #####



--- 9. Хранимая процедура принимает в качестве параметра числои возвращает его факториал. Формула расчета факториала:
--- n! = 1*2*…n. Например, 3! = 1*2*3 = 6



--- 10. Хранимая принимает два числовых параметра. Первыйпараметр — это число. Второй параметр — это степень.
--- Процедура возвращает число, возведенное в степень. 
--- Например, если параметры равны 2 и 3, тогда вернется 2 в третьей степени, то есть 8.




----------------------------------------------------------------------------------------------------
--                                          fucntions
----------------------------------------------------------------------------------------------------


--- 1. Функция выводит «Hello, world!»

if object_id('uf_hello')is not null
    drop function uf_hello;
go
create function uf_hello()
returns nvarchar(20)
as 
begin
return N'Hello World'
end;
go
declare @g nvarchar(20)
exec @g = uf_hello
print @g;

--- 2. Функция возвращает информацию о текущем времени


if object_id('uf_sum')is not null
    drop function uf_sum;
go
create function uf_sum(@a int ,@b int,@c int)
returns int
as 
begin
return (@a+@b+@c)
end;
go
declare @g int
exec @g = uf_sum @a=2,@b=12,@c=12
print @g;




