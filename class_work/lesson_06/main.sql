print 'hello world'
declare @a int = 3 ,@b int = 9,@res int
set @res = @a+@b
print @res;

if (@a>@b)
print @a
else
print @b;

print ''
print 'while'
while (@a<@b)
begin --- начало блока вайл
print @a
set @a+=1
end --- конец блока вайл


-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

use Music_collection;
go
create procedure sp_Hello
as 
print 'hello';

go
exec sp_Hello;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

create procedure sp_sum;1 @a int ,@b int --- принимаемые параметры
as 
declare @res int
set @res = @a+@b
print @res;

create procedure sp_sum;2 @a int ,@b int --- ;2 варинт процедуры ,другой
as 
declare @res int
set @res = @a+@b
return @res;

go
exec sp_sum 4 ,11; -- позиционно
go
exec sp_sum @b=4 ,@a=11; --- явно
go

--- drop procedure sp_sum;
--- go

exec sp_sum;1 5,6; --- вывести вариант с принтом 
go

declare @res int
exec @res=sp_sum;2 5,6 --- вернуть результат и потом вывести
print @res;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

create procedure sp_fact @num int --- факториал
as 
declare @f int =1
while (@num>0)
begin
set @f*=@num
set @num-=1
end
return @f;

go
declare @res int
exec @res=sp_fact 5
print @res;


-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------
---_ERRORs

raiserror (N'Today is %d %s %d',10,1,16,'November',2019) --- 10 - серьезность ошибки (19 критична) , 1 - идентификатор ошибки

RAISERROR (N'This is message %s %d.', -- Message text.  
           10, -- Severity,  
           1, -- State,  
           N'number', -- First argument.  
           5); -- Second argument.  
-- The message text returned is: This is message number 5.  
GO  

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

create procedure sp_get_all_songs --- процедура выполняющая запрос
as
select *
from Song;

go
exec sp_get_all_songs;

go
create procedure sp_get_song_with_disk
as
select *
from Song join Disk on Song.DiskId=Disk.Id;

go
exec sp_get_song_with_disk;


create procedure sp_get_song_with_disk;2 @num int
as
select  *
from Song join Disk on Song.DiskId=Disk.Id and Song.Durability>@num;

go
exec sp_get_song_with_disk;2 4;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

--- Тригеры After(default) и Instead of( напр. заменяет какой то запрос на другой) 


create trigger add_confirm --- просто выводит сообщение после каждого инсерта в таблицу 
on Genre After insert --- after можно упустить
as
print 'New genre added';
go 
insert into Genre
values ('Pepepe');

--- 

create trigger add_show_tmp 
on Genre After insert
as
select *
from inserted;--- временная таблица , хранит последние вставленные или изменные эллементы
go 
insert into Genre
values ('дщдщ')

---- при удалении формируется таблица deleted ,хранит все последнее удаленное

create trigger add_show_deleted_tmp 
on Genre After delete
as
select *
from deleted;

go 
delete from Genre
where Name like('%some%');

