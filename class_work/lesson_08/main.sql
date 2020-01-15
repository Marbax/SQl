---------------------------------------------------------------------
---     Задание 2. Создайте следующие пользовательские функции:
---------------------------------------------------------------------


---     1. Пользовательская функция возвращает приветствие в стиле
--- «Hello, ИМЯ!» Где ИМЯ передаётся в качестве параметра.
--- Например, если передали Nick, то будет Hello, Nick!
if object_id('uf_hello_you')is not null
    drop function uf_hello_you;
go
create function uf_hello_you(@name_input nvarchar(100))
returns nvarchar(120)
as 
begin
return N'Hello '+@name_input
end;

go
declare @string_out nvarchar(120)
exec @string_out = uf_hello_you 'MyName'
print @string_out;


---     2. Пользовательская функция возвращает информацию отекущем количестве минут
if object_id('uf_cur_min')is not null
    drop function uf_cur_min;
go
create function uf_cur_min()
returns int
as 
begin
---return convert(int,DATEPART(MINUTE, GETDATE()))
return DATEPART(MINUTE, GETDATE())
end;

go
declare @minutes int
exec @minutes = uf_cur_min
print @minutes;


---     3. Пользовательская функция возвращает информацию о текущем годе
if object_id('uf_cur_year')is not null
    drop function uf_cur_year;
go
create function uf_cur_year()
returns int
as 
begin
---return convert(int,DATEPART(year, GETDATE()))
return DATEPART(year, GETDATE())

end;

go
declare @minutes int
exec @minutes = uf_cur_year
print @minutes;

---     4. Пользовательская функция возвращает информацию о том: чётный или нечётный год
if object_id('uf_even_year_not')is not null
    drop function uf_even_year_not;
go
create function uf_even_year_not()
returns nvarchar (4)
as 
begin
declare @cur_year int 
declare @answer nvarchar(4)
---set @cur_year=convert(int,DATEPART(year, GETDATE()))
set @cur_year=DATEPART(year, GETDATE())
if (@cur_year % 2 = 0)
set @answer='even'
else
set @answer='odd'
return @answer
end;

go
declare @year nvarchar(4)
exec @year = uf_even_year_not
print @year;



---     5. Пользовательская функция принимает число и возвращает yes, если число простое и no, если число не простое.
if object_id('uf_simple_not')is not null
    drop function uf_simple_not;
go
create function uf_simple_not(@num int)
returns nvarchar (3)
as 
begin
    declare @answer nvarchar(3)
    set @answer = 'no'
    declare @iterator int
    set @iterator=@num-1
    while (@iterator!=1)
    begin
        if (@num % @iterator=0)
            set @answer='yes'
        set @iterator=@iterator-1
    end
    return @answer
end;

go
declare @answer nvarchar(3)
exec @answer = uf_simple_not 13
print @answer;


---     6. Пользовательская функция принимает в качестве параметров пять чисел. 
---     Возвращает сумму минимального и максимального значения из переданных пяти параметров



---     7. Пользовательская функция показывает все четные или нечетные числа в переданном диапазоне. 
---     Функция принимает три параметра: начало диапазона, конец диапазона,чёт или нечет показывать.





---------------------------------------------------------------------
---     Задание 2. Для базы данных «Продажи» из практического задания модуля «Работа с таблицами и представлениями
---     в MS SQL Server» создайте следующие пользовательские функции:
---------------------------------------------------------------------




---     1. Пользовательская функция возвращает минимальную продажу конкретного продавца. 
---     ФИО продавца передаётся в качестве параметра пользовательской функции



---     2. Пользовательская функция возвращает минимальнуюпокупку конкретного покупателя. 
---     ФИО покупателя передаётся в качестве параметра пользовательской функции



---     3. Пользовательская функция возвращает общую сумму продаж на конкретную дату. 
---     Дата продажи передаётся в качестве параметра




---     4. Пользовательская функция возвращает дату, когда общая сумма продаж за день была максимальной




---     5. Пользовательская функция возвращает информацию о всех продажах заданного товара. 
---     Название товара передаётся в качестве параметра




---     6. Пользовательская функция возвращает информацию о всех продавцах однофамильцах




---     7. Пользовательская функция возвращает информацию о всех покупателях однофамильцах



---     8. Пользовательская функция возвращает информацию о всех покупателях и продавцах однофамильцах.


