---------------------------------------------------------------------------------------------------------------------
---Задание 2. Используя триггеры, пользовательские функции, хранимые процедуры реализуйте следующую функциональность: 
---------------------------------------------------------------------------------------------------------------------
--- 1. Вернуть ФИО всех барберов салона 
if object_id('uf_get_all_barbers_fnames')is not null
    drop function uf_get_all_barbers_fnames;
go
create function uf_get_all_barbers_fnames()
returns table
as 
    return (select p.Name,p.Surname,p.MiddleName
        from Barbers b join Persons p on b.Persons_Id=p.Persons_Id)
;

go
select * from uf_get_all_barbers_fnames();



--- 2. Вернуть информацию о всех синьор-барберах 
if object_id('uf_get_all_barbers')is not null
    drop function uf_get_all_barbers;
go
create function uf_get_all_barbers()
returns table
as 
    return (select b.Barbers_Id, p.Name, p.Surname, p.MiddleName , g.Name as 'Gender', b.PhoneNum, b.Email, b.BirthDate, b.EmployDate, pos.Name as 'Position'
        from Barbers b join Persons p on b.Persons_Id=p.Persons_Id
        join Genders g on b.Genders_Id=g.Genders_Id
        join Positions pos on b.Positions_Id=pos.Positions_Id)
;
go 

if object_id('uf_get_all_seniors')is not null
    drop function uf_get_all_seniors;
go
create function uf_get_all_seniors()
returns table
as 
    return (select * from uf_get_all_barbers() uf where uf.Position='Senior-barber')
;

go
select * from uf_get_all_seniors();



--- 4. Вернуть информацию о всех барберах, которые могут предоставить конкретную услугу.  
--- Информация о требуемой услуге предоставляется в качестве параметра 
if object_id('uf_get_barbers_by_concrete_service')is not null
    drop function uf_get_barbers_by_concrete_service;
go
create function uf_get_barbers_by_concrete_service(@service_input nvarchar(100))
returns table
as 
    return (select uf.*
        from Services s join Services_Barbers sb on sb.Services_Id=s.Services_Id and s.Name like ('%'+@service_input+'%')
        join uf_get_all_barbers() uf on uf.Barbers_Id=sb.Barbers_Id)
;

go
select * from uf_get_barbers_by_concrete_service('some service') ;



--- 3. Вернуть информацию о всех барберах, которые могут предоставить услугу традиционного бритья бороды
if object_id('uf_get_traditional_barbers')is not null
    drop function uf_get_traditional_barbers;
go
create function uf_get_traditional_barbers()
returns table
as 
    return (select * from uf_get_barbers_by_concrete_service('Traditional beard haircut'))
;

go
select * from uf_get_traditional_barbers();




--- 5. Вернуть информацию о всех барберах, которые работают свыше указанного количества лет. 
--- Количество лет передаётся в качестве параметра 
if object_id('uf_get_barbers_by_emp_date')is not null
    drop function uf_get_barbers_by_emp_date;
go
create function uf_get_barbers_by_emp_date(@years_input int)
returns table
as
    return (select * from uf_get_all_barbers() uf where uf.EmployDate > convert(varchar,datepart(year,getdate())- @years_input))
;

go
select * from uf_get_barbers_by_emp_date(3);




--- 6. Вернуть количество синьор-барберов и количество джуниор-барберов 
if object_id('uf_juns_and_sen_count')is not null
    drop function uf_juns_and_sen_count;
go
create function uf_juns_and_sen_count()
returns table
as
    return (select 'Juniors' as 'Position',count(b.Positions_Id) as 'Count' from Barbers b join Positions pos on b.Positions_Id=pos.Positions_Id and pos.name like ('%jun%') group by b.Positions_Id
            union
            select 'Senior' as 'Position',count(b.Positions_Id) as 'Count' from Barbers b join Positions pos on b.Positions_Id=pos.Positions_Id and pos.name like ('%sen%') group by b.Positions_Id)
;

go
select * from uf_juns_and_sen_count();




--- 7. Вернуть информацию о постоянных клиентах. Критерий постоянного клиента: 
--- был в салоне заданное количество раз. Количество передаётся в качестве параметра 
if object_id('uf_get_all_clients')is not null
    drop function uf_get_all_clients;
go
create function uf_get_all_clients()
returns table
as 
    return (select c.Customers_Id, p.Name, p.Surname, p.MiddleName ,c.PhoneNum, c.Email
        from Customers c join Persons p on c.Persons_Id=p.Persons_Id)
;
go 

select * from uf_get_all_clients();
go

if object_id('uf_get_regular_customers')is not null
    drop function uf_get_regular_customers;
go
create function uf_get_regular_customers(@counts_input int)
returns table
as 
    return (select uf.Customers_Id, uf.Name, uf.Surname, uf.MiddleName ,uf.PhoneNum, uf.Email , count(va.Customers_Id) as 'Visit''s count' from uf_get_all_clients() uf join Visits_Arch va on uf.Customers_Id=va.Customers_Id
            group by uf.Customers_Id, uf.Name, uf.Surname, uf.MiddleName ,uf.PhoneNum, uf.Email
            having count(va.Customers_Id)> @counts_input)
;
go 

select * from uf_get_regular_customers(0);
go



--- 8. Запретить возможность удаления информации о чиф-барбере, если не добавлен второй чиф-барбер 
if object_id('del_not_del_solo_chief')is not null
    drop trigger del_not_del_solo_chief;
go
create trigger del_not_del_solo_chief
on Barbers instead of delete
as
begin
    if ((select count(b.Barbers_Id) as 'Chiefs count' 
        from Barbers b join Positions p on b.Positions_Id=p.Positions_Id and p.Name = 'Chieff-barber') > 1)
            begin
            delete from Barbers
            where Barbers_Id in (select d.Barbers_Id
            from deleted d join Barbers b on b.Barbers_Id=d.Barbers_Id)
            end
    else 
        begin
            set nocount on
            raiserror ('This barber cannot be deleted!',0,1) 
        end
end;




--- 9. Запретить добавлять барберов младше 21 года.
if object_id('ins_cant_to_young_barber')is not null
    drop trigger ins_cant_to_young_barber;
go
create trigger ins_cant_to_young_barber
on Barbers instead of insert
as
begin
    if not exists (select * from inserted i where BirthDate > convert(varchar,datepart(year,getdate()) - 21) )
            begin
            insert into Barbers
            select i.Persons_Id, i.Genders_Id, i.PhoneNum,Email, i.BirthDate, i.EmployDate, i.Positions_Id from inserted i
            end
    else 
        begin
            set nocount on
            raiserror ('This barber is to young!',0,1) 
        end
end;

----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
---Задание 2.1. Используя триггеры, пользовательские функции, хранимые процедуры реализуйте следующую функциональность: 
------------------------------------------------------------------------------------------------------------------------
--- 1. Вернуть информацию о барбере, который работает в барбершопе дольше всех 
if object_id('uf_get_oldest_barbers')is not null
    drop function uf_get_oldest_barbers;
go
create function uf_get_oldest_barbers()
returns table
as 
    return (select * from uf_get_all_barbers() uf where uf.Barbers_Id = (select top 1 b.Barbers_Id from Barbers b order by b.EmployDate))
;

go
select * from uf_get_oldest_barbers();




--- 2.Вернуть информацию о барбере, который обслужил максимальное количество клиентов в указанном диапазоне дат. 
--- Даты передаются в качестве параметра 
if object_id('uf_most_useful_barber_between_dates')is not null
    drop function uf_most_useful_barber_between_dates;
go
create function uf_most_useful_barber_between_dates(@start_date date,@end_date date)
returns table
as 
    return (select * from uf_get_all_barbers() uf 
            where uf.Barbers_Id = (select top 1 b.Barbers_Id from Barbers b join Visits_Arch v 
                                    on b.Barbers_Id=v.Barbers_Id and v.SessionDate between @start_date and @end_date
                                    group by b.Barbers_Id order by count(v.Visits_Arch_Id) desc))
;

go
select * from uf_most_useful_barber_between_dates('02-22-2019','03-12-2019');

--- check
/*
select top 1 b.Barbers_Id,count(v.Visits_Arch_Id) as 'visits' from Barbers b join Visits_Arch v 
                                   on b.Barbers_Id=v.Barbers_Id and v.SessionDate between '02-22-2019' and '03-12-2019'
                                 group by b.Barbers_Id order by count(v.Visits_Arch_Id) desc
*/


--- 3. Вернуть информацию о клиенте, который посетил барбершоп максимальное количество раз 
if object_id('uf_best_client_by_visits')is not null
    drop function uf_best_client_by_visits;
go
create function uf_best_client_by_visits()
returns table
as 
    return (select top 1 uf.* , count(va.Customers_Id) as 'Visit''s count' from uf_get_all_clients() uf join Visits_Arch va 
            on uf.Customers_Id=va.Customers_Id
            group by uf.Customers_Id, uf.Name, uf.Surname, uf.MiddleName ,uf.PhoneNum, uf.Email
            order by count(va.Customers_Id) desc)
;

go
select * from uf_best_client_by_visits();




--- 4.Вернуть информацию о клиенте, который потратил в барбершопе максимальное количество денег 
if object_id('uf_best_client_by_money_spent')is not null
    drop function uf_best_client_by_money_spent;
go
create function uf_best_client_by_money_spent()
returns table
as 
    return (select top 1 uf.* , sum(va.[Visit's_Value]) as 'Visit''s money spent sum' from uf_get_all_clients() uf join Visits_Arch va 
            on uf.Customers_Id=va.Customers_Id
            group by uf.Customers_Id, uf.Name, uf.Surname, uf.MiddleName ,uf.PhoneNum, uf.Email
            order by sum(va.[Visit's_Value]) desc)
;

go
select * from uf_best_client_by_money_spent();





--- 5. Вернуть информацию о самой длинной по времени услуге в барбершопе 
if object_id('uf_longest_service')is not null
    drop function uf_longest_service;
go
create function uf_longest_service()
returns table
as 
    return (select top 1 s.Services_Id, s.Name, s.Value , s.Durability from Services s
            order by s.Durability desc)
;

go
select * from uf_longest_service();


----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
---Задание 2.2. Используя триггеры, пользовательские функции, хранимые процедуры реализуйте следующую функциональность: 
------------------------------------------------------------------------------------------------------------------------
--- 1. Вернуть информацию о самом популярном барбере (по количеству клиентов) 
if object_id('uf_most_useful_barber_by_clients')is not null
    drop function uf_most_useful_barber_by_clients;
go
create function uf_most_useful_barber_by_clients()
returns table
as 
    return (select * from uf_most_useful_barber_between_dates('01-01-1970',getdate()))
;

go
select * from uf_most_useful_barber_by_clients();



--- 2. Вернуть топ-3 барберов за месяц (по сумме денег, потраченной клиентами) 
if object_id('uf_3_most_useful_barbers_by_money_last_month')is not null
    drop function uf_3_most_useful_barbers_by_money_last_month;
go
create function uf_3_most_useful_barbers_by_money_last_month()
returns table
as
    return (select * from uf_get_all_barbers() uf 
            where uf.Barbers_Id in (select top 3 b.Barbers_Id from Barbers b join Visits_Arch v 
                                    on b.Barbers_Id=v.Barbers_Id and v.SessionDate between getdate() - 30 and getdate()
                                    group by b.Barbers_Id order by sum(v.[Visit's_Value]) desc))
;

go
select * from uf_3_most_useful_barbers_by_money_last_month();



--- 3. Вернуть топ-3 барберов за всё время (по средней оценке). Количество посещений клиентов не меньше 30 
--- (оценки текстовые -_- , при условии ,что очередность(ИД) ьудет идти от худшего ,можно смотреть avg по ИД, будет считать только если была оценка за сеанс)
if object_id('uf_3_most_useful_barbers_by_avg_mark')is not null
    drop function uf_3_most_useful_barbers_by_avg_mark;
go
create function uf_3_most_useful_barbers_by_avg_mark()
returns table
as
    return (select * from uf_get_all_barbers() uf 
            where uf.Barbers_Id in (select top 3 b.Barbers_Id from Barbers b join Visits_Arch v on b.Barbers_Id=v.Barbers_Id
									join Marks_Barbers_Customers mbc on v.Barbers_Id=mbc.Barbers_Id
									join Marks m on mbc.Marks_Id=m.Marks_Id
                                    group by b.Barbers_Id 
									having count(v.Visits_Arch_Id)>30
									order by avg(m.Marks_Id) desc))
;

go
select * from uf_3_most_useful_barbers_by_avg_mark();




--- 4. Показать расписание на день конкретного барбера. Информация о барбере и дне передаётся в качестве параметра 
--- (какая информация о барбере -_- , о дне в текущем месяце ? или месяц ,день ? или год,месяц ,день?)
if object_id('uf_barber_day_schedule')is not null
    drop function uf_barber_day_schedule;
go
create function uf_barber_day_schedule(@barber_input int , @date_input date)
returns table
as
    return (select p.Name, p.Surname , p.MiddleName , c.PhoneNum , c.Email , bs.SessionDate 
            from Barbers_Schedules bs join Customers c 
			on bs.SessionDate between @date_input and dateadd(day,1,@date_input)
			and bs.Barbers_Id=@barber_input
			and  bs.Customers_Id=c.Customers_Id
            join Persons p on c.Persons_Id=p.Persons_Id
			)
;

go
select * from uf_barber_day_schedule(2,'12-25-2019');


--- 5. Показать свободные временные слоты на неделю конкретного барбера. Информация о барбере и дне передаётся в качестве параметра 
--- (слоты на неделю показать ,а параметр - день ? неделю начиная с того дня ,или что?)
if object_id('uf_barber_empty_time_slots_for_day')is not null
    drop function uf_barber_empty_time_slots_for_day;
go
create function uf_barber_empty_time_slots_for_day(@barber_input int , @date_input date)
returns table
as

    return (select @date_input as 'Date', ss.Time from SessionsSlots ss where ss.SessionsSlots_Id not in (
	    select bs.SessionsSlots_Id from Barbers_Schedules bs where bs.Barbers_Id=2 and bs.SessionDate=@date_input)

)
;

go
select * from uf_barber_empty_time_slots_for_day(2,'12-25-2019');

--- Как реализовать такой вариант правильно?
/*
if object_id('uf_barber_empty_time_slots_for_week')is not null
    drop function uf_barber_empty_time_slots_for_week;
go
create function uf_barber_empty_time_slots_for_week(@barber_input int , @date_input date)
returns table
as
begin
    declare @date_end date
    set @date_end = dateadd(day,7,@date_input)

    return (while(@date_input<@date_end)
            begin
            select * from uf_barber_empty_time_slots_for_day(@barber_input,@date_input)
            set @date_input = dateadd(day,1,@date_input) 
            end )
end

;

go
select * from uf_barber_empty_time_slots_for_week(2,'12-25-2019');
*/

if object_id('uf_barber_empty_time_slots_for_week')is not null
    drop function uf_barber_empty_time_slots_for_week;

go
create function uf_barber_empty_time_slots_for_week(@barber_input int , @date_input date)
returns table
as
    return (select * from uf_barber_empty_time_slots_for_day(@barber_input,@date_input)
            union
			select  * from uf_barber_empty_time_slots_for_day(@barber_input,dateadd(day,1,@date_input))
            union
			select  * from uf_barber_empty_time_slots_for_day(@barber_input,dateadd(day,2,@date_input))
            union
			select  * from uf_barber_empty_time_slots_for_day(@barber_input,dateadd(day,3,@date_input))
            union
			select  * from uf_barber_empty_time_slots_for_day(@barber_input,dateadd(day,4,@date_input))
            union
			select  * from uf_barber_empty_time_slots_for_day(@barber_input,dateadd(day,5,@date_input))
            union
			select  * from uf_barber_empty_time_slots_for_day(@barber_input,dateadd(day,6,@date_input))
            )
;

go
select * from uf_barber_empty_time_slots_for_week(2,'12-25-2019');




--- 6. Перенести в архив информацию о всех уже завершенных услугах (это те услуги, которые произошли в прошлом) 
--- (дичь какая-то, в тз по проектированию такое не предусматривалось,есть записи,но они не содержат те же данные)



--- 7. Запретить записывать клиента к барберу на уже занятое время и дату 
if object_id('ins_cant_add_in_same_time')is not null
    drop trigger ins_cant_add_in_same_time;
go
create trigger ins_cant_add_in_same_time
on Barbers_Schedules instead of insert
as
begin
    if not exists (select * from inserted i where i.Barbers_Id + i.SessionDate + i.SessionsSlots_Id in (
                        select bs.Barbers_Id + bs.SessionDate + bs.SessionsSlots_Id from Barbers_Schedules bs ))
            begin
            insert into Barbers_Schedules
            select i.Barbers_Id, i.Customers_Id, i.SessionDate, i.SessionsSlots_Id from inserted i
            end
    else 
        begin
            set nocount on
            raiserror ('This time is busy!',0,1) 
        end
end;

--- 8. Запретить добавление нового джуниор-барбера, если в салоне уже работают 5 джуниор-барберов 
if object_id('ins_no_more_then_5_juns')is not null
    drop trigger ins_no_more_then_5_juns;
go
create trigger ins_no_more_then_5_juns
on Barbers instead of insert
as
begin
    if ((select count(b.Barbers_Id) from Barbers b join Positions p on p.Name='Junior-barber' and b.Positions_Id=p.Positions_Id)<5)
            begin
            insert into Barbers
            select i.Persons_Id, i.Genders_Id, i.PhoneNum, i.Email , i.BirthDate, i.EmployDate, i.Positions_Id from inserted i
            end
    else 
        begin
            set nocount on
            raiserror ('This time is busy!',0,1) 
        end
end;




--- 9. Вернуть информацию о клиентах, которые не поставили ни одного фидбека и ни одной оценки 
if object_id('uf_get_clients_without_feedbacks')is not null
    drop function uf_get_clients_without_feedbacks;

go
create function uf_get_clients_without_feedbacks()
returns table
as
    return (select * from uf_get_all_clients() where Customers_Id not in (select Customers_Id from Reviews) 
        and Customers_Id not in (select Customers_Id from Marks_Barbers_Customers))
;

go
select * from uf_get_clients_without_feedbacks();


--- 10. Вернуть информацию о клиентах, которые не посещали барбершоп свыше одного года
if object_id('uf_get_forgotten_clients')is not null
    drop function uf_get_forgotten_clients;

go
create function uf_get_forgotten_clients()
returns table
as
    return (select * from uf_get_all_clients() where Customers_Id not in (select Customers_Id from Visits_Arch where SessionDate>getdate()-366))
;

go
select * from uf_get_forgotten_clients();


