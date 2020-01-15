# SQL
 Lessons with SQL(T-SQL)

---

<details><summary> SQL_01-05. DML. Join.   </summary><p>


### SQL(MsSQL)
SQL
- T-SQL версия ,(tansact)

- DDL(data defination language) - для создания ,удаления ,изменения БД
- DML - работа с существующей БД
- DCL - для управления доступами к БД
  
[metanit](https://metanit.com/ "https://metanit.com/")

```SQL
create database my_second_db
go
use my_second_db
go
create table my_table
(
id int identity not null primary key,
first_name nvarchar(30) not null,
last_name nvarchar(30) not null,
phone_number int
);
```

---

### Commands:

```SQL
create database Films
go
use Films
create table Film
(
Id int identity primary key not null,
Title nvarchar(60) not null,
Director nvarchar(30) ,
R_year int check(r_year>1900) default 1901,
Country nvarchar(20),
genre nvarchar(100)
);
```

```SQL
insert into Film(Title,Director,R_year,Country,genre)
values
('Titanic','Cameron',1999,'USA','comedy'),
('Terminator','Cameron',2000,'USA','horror'),
('Dampo','Jack',1999,'USA','comedy'),
('Bompo','ss',1999,'USA','comedy'),
('Pimpa','Camerwon',1999,'USA','triller');
```

```SQL
select Title as 'Название',genre as 'Жанр' from Film
where R_year>=1999
;
```


```SQL
update Film
set Country='USA'
where Country='UA' and Id=1 ;
```

```SQL
delete from Film
where Title='Bompo';
```

---

### Нормализация :
- Каждая ячейка хранит только атомарное(неделимое) значение 
- Нет составных ключей , только уникальный идентификатор
- Нет зависимостей полей от неключевых полей

>Внешние ключи - поля которые хранят первичные ключи (обычно отдельная таблица внешних ключей)  
С помощью этих ключей производится взаимодействие между таблицами  

Задачи http://www.sql-ex.ru/



---


## Агрегирование - если нужно что то из многих ( напр sum , avg , count).  

## Джойны - для обьеденения данных из нескольких таблиц
- Inner join - показывает если инфа есть в обоих полях(пересекающаяся часть/общее из двух таблиц) , join просто - всегда Inner ,может опускаться
- Outer join - (left,right,full могут опускать outer )
    - Outer left join - все данные из левой , и соответствие из правой (если оно есть или нул)
    - Outer right join - наоборот
    - Outer full join - все со всем

>Коротко : join , left join ,right join , full join.  


</p></details>

---

<details><summary> SQL_06 .Trigers , procedures. </summary><p>

[Trigers,procedures](SQL\CW_06\main.sql "SQL\CW_06\main.sql")   

---

<details><summary> Insert trigger example </summary><p>

```SQL

create trigger CheckDateTrigger 
on book.Books 
for insert 
as 
begin    
    declare @InsDate smalldatetime 
    -- получаем дату издательства книги, которая добавляется    
    select @InsDate = DateOfPublish     
    from inserted 
    -- проверяем, сколько прошло дней со дня издания    
        if (@InsDate <= getdate()-30)    
            begin        
            raiserror('Это старая книга и данные о ней добавлены не будут ',0,1)        
            rollback transaction    
            end
        else        
            PRINT(' Данные добавлены успешно ') 
        End 

```

</p></details>

---

<details><summary> Delete trigger example </summary><p>

```SQL

create trigger CheckBookDelete 
on book.Books 
for delete 
as 
begin    
    declare @NameBook varchar(25), @BestBook varchar(25) 
    -- Получаем название удаляемой книги    
    select @NameBook = deleted.NameBook    
    from deleted     
    declare @Zvit table (nameB varchar(25), quantity int) 
    -- Получаем информацию о названиях книг и их количестве продаж (популярность)    
    insert @Zvit        
    select b.NameBook, count(s.id_book)         
    from book.Books b, sale.Sales s       
    where b.id_book = s.id_book
    group by b.NameBook 
    -- находим самую продаваемую книгу    
    select @BestBook = z.nameB    
    from @Zvit z    
    where z.quantity = (select max(quantity)                         
    from @Zvit) 
    -- проверяем, совпали ли названия     
    if (@BestBook = @NameBook)    
        begin        
            raiserror("Вы не можете удалить эту книгу ",0,1)        
            rollback transaction    
        end    
    else    
        begin        
            print ("Книга удалена успешно ")    
        end 
end 

```

</p></details>

---

<details><summary> Delete trigger example </summary><p>

```SQL

create trigger NotDeleteComputerScience 
on Books 
instead of delete 
as 
begin 
    declare @ThemeId int 
    -- get the identifier of 'Computer Science' theme 
    select @ThemeId = id 
    from Themes 
    where NameTheme = 'Computer Science' 
    -- check whether the identifier of removing book matches the @ThemeId 
    if exists (select * from deleted where id_theme = @ThemeId) 
        raiserror ('This book cannot be deleted!',0,1) 
end;

```

</p></details>

---

<details><summary> Drop trigger example </summary><p>

```SQL

create trigger NotAlterDropTable 
on DATABASE 
for DROP_TABLE, ALTER_TABLE 
as 
begin 
    print 'Модификация и удаление таблиц запрещены. Обратитесь к администратору.' 
    rollback 
end 

```

</p></details>

---

<details><summary> Logon trigger example </summary><p>

```SQL

use master; 
go 
create trigger TriggerConnection 
on ALL SERVER 
with execute as 'vasja_pupkin' 
for logon 
as 
begin    
    if ORIGINAL_LOGIN()= 'vasja_pupkin'    
    begin        
        print 'Такой логин запрещен на сервере. Обратитесь к администратору.'        
        rollback    
    end 
end

```

</p></details>

---

<details><summary> Print example </summary><p>

>В операторе Print нельзя форматировать строку или конкатенировать (select может)

```SQL

PRINT 'Hello World' 
DECLARE @msg nvarchar(50); 
SET @msg = N'Сегодня '+ CAST(GETDATE() AS nvarchar(30)) + N'.'; 
PRINT @msg;

```

</p></details>

---

<details><summary> If exists example </summary><p>

```SQL

if exists  (select * from book.Books where DateOfPublish between '2006.01.01' and current_timestamp) 
begin 
    PRINT 'Информация про книги' 
    select * 
    from book.Books 
    where DateOfPublish between '01.01.2006' and current_timestamp 
    return 
end

```

</p></details>

---

<details><summary> Case example </summary><p>

```SQL

select 'Book title' = b.NameBook,        
'Topic' = case t.NameTheme                 
            when 'Computer Science' then 'Everything about programming'                  
            when 'Web Technologies' then 'For Web developers'                  
            else 'Leisure reading'                 
          end 
from books b, Themes t 
where b.id_theme = t.id;

```

</p></details>

---

<details><summary> Case example </summary><p>

```SQL

select 'Book title' = b.NameBook,        
'Book price' = case   
                when b.price < 50 then 'Book cheaper than 50'   
                when b.price between 50 and 100 then 'Price ranges between 50 and 100'   
                else 'Book more expensive than 100'   
              end 
from books b;

```

</p></details>

---

<details><summary> Coalesce example </summary><p>

```SQL

-- с оператором case 
select 'Book title' = NameBook,        
'Price' = case   
            when TradePrice IS NOT NULL then TradePrice * Quantity   
            when RetailPrice IS NOT NULL then RetailPrice * Quantity   
          end 
from book.Books; 

-- с использованием функции coalesce 
select 'Book title' = NameBook,        
'Price' = coalesce (TradePrice * Quantity, RetailPrice* Quantity) 
from book.Books;

```

</p></details>

---

<details><summary> Nullif example </summary><p>

```SQL

-- с оператором case
select 'Books' = NameBook,        
'Pressrun' = case         
                when Quantity=0 then NULL        
                else Quantity        
              end 
from books; 

-- с использованием функции nullif 
select 'Books' = NameBook,        
'Pressrun' = NULLIF(Quantity,0) 
from books;

select 'Number of books with not zero quantity' = count(NULLIF(Quantity,0)) 
from books; 

```

</p></details>

---

<details><summary> Recusrsive virtual view example </summary><p>

>Иерархический список тематик и книг

```SQL

WITH Reports(ID_THEME, ID_BOOK, Level_) AS 
(    
    SELECT ID_THEME, ID_BOOK, 1 AS Level_    
    FROM book.Books    
    WHERE ID_THEME IS NULL    
    UNION ALL    
    SELECT b.ID_THEME, b.ID_BOOK, Level_ + 1    
    FROM book.Books b INNER JOIN Reports r        
    ON b.ID_THEME = r.ID_BOOK 
) 
select * 
from Reports 
order by 1; 

```

</p></details>

---

<details><summary> Transaction rollback example </summary><p>

```SQL

begin transaction    -- начало транзакции 
-- 1 
select distinct FirstName 
from book.Authors; 
save transaction pt1  -- первая точка сохранения 
-- 2 
insert into book.Themes(NameTheme) 
values ('MFC') 
save transaction pt2 -- вторая точка сохранения
-- 3 
update book.Authors 
set id_country = (select id_country       
                for global.Country        
                where NameCountry = 'USA') 
-- выбор действия в зависимости от текущего состояния ошибки 
if(@@error >=1 and @@error <= 10) 
    begin 
        print 'Значение ошибки 1..10' 
        rollback transaction pt2 
    end 
else if(@@error > 10) 
    rollback transaction 
else 
    commit transaction 

```

</p></details>

---

</p></details>

---

<details><summary> SQL_07. Procedures and Functions. </summary><p>

---

[Procedures and Functions example](\class_work\lesson_07\main.sql "\class_work\lesson_07\main.sql")   

---

</p></details>

---

<details><summary> SQL_08. Functions. </summary><p>

---

[Functions example](\class_work\lesson_08\main.sql "\class_work\lesson_08\main.sql")   

---

</p></details>

---

<details><summary> SQL_11. WinForms plus DB. </summary><p>

---

[WinForms plus DB example](\class_work\lesson_11 "\class_work\lesson_11")   

---

</p></details>

