use [master];
go

if db_id('BookShop') is not null
begin
	drop database [BookShop];
end
go

create database [BookShop];
go

use [BookShop];
go

create table [Authors]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[Surname] nvarchar(max) not null check ([Surname] <> N''),
	[CountryId] int not null
);
go

create table [Books]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[Pages] int not null check (Pages>0),
	[Price] money not null check (Price>=0),
	[PublishDate] date not null check (PublishDate<getdate()), ---CURRENT_TIMESTAMP 
	[AuthorId] int not null,
	[ThemeId] int not null
);
go

create table [Countries]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(50) not null unique check ([Name] <> N''),
);
go

create table [Sales]
(
	[Id] int not null identity(1, 1) primary key,
	[Price] money not null check (Price>=0),
	[Quantity] int not null check (Quantity>0),
	[SaleDate] date not null check (SaleDate<getdate()) default (getdate()), ---CURRENT_TIMESTAMP 
	[BookId] int not null,
	[ShopId] int not null
);
go

create table [Shops]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[CountryId] int not null
);
go

create table [Themes]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
);
go

alter table [Authors]
add foreign key ([CountryId]) references [Countries]([Id]);
go

alter table [Books]
add foreign key ([AuthorId]) references [Authors]([Id]);
go

alter table [Books]
add foreign key ([ThemeId]) references [Themes]([Id]);
go

alter table [Sales]
add foreign key ([BookId]) references [Books]([Id]);
go

alter table [Sales]
add foreign key ([ShopId]) references [Shops]([Id]);
go

alter table [Shops]
add foreign key ([CountryId]) references [Countries]([Id]);
go


insert into Themes(Name)
values
('Documental'),
('Political novel'),
('Ouvenile fantasy'),
('Heroic fantasy'),
('Child''s'),
('High fantasy'),
('Fantasy'),
('Detective'),
('Study')
;
go

insert into Countries(Name)
values
('USA'),
('Great Britan'),
('Poland')
;
go

insert into Authors(Name,Surname,CountryId)
values
('Marcel','Proust',2),
('George','Reymond',1),
('John','Ronald Reuel',3),
('Patrick','Rothfuss',1),
('Clive','Staples',2),
('Bill','Gates',1)
;
go

insert into Shops(Name,CountryId)
values
('Eurpe Editions',2),
('Bantam Spectra',1),
('Allen & Unwin',3),
('DAW books',1),
('Geoffrey Bles',2)
;
go

insert into Books(Name,Pages,Price,PublishDate,AuthorId,ThemeId)
values
('In Search of Lost Time',2500,10,'1998-05-27',1,1),
('A game of Thrones',2900,27,'1996-08-1',2,2),
('A Clash of Kings',3700,13,'1999-01-22',2,4),
('A Storm of Swords',600,18,'2000-08-8',2,4),
('The Lord of the Rings',2580,10,'1954-07-29',3,6),
('The Adventures of Tom Bombadil',3500,23,'1962-11-22',3,6),
('The Hobbit',2100,32,'1937-09-21',3,4),
('Tree and Leaf',630,25,'1964-05-28',3,5),
('The Name of the Wind',1900,21,'2007-04-27',4,3),
('The Wise Man''s Fear',4700,22,'2011-04-1',4,7),
('The Chronicles of Narnia',1100,28,'1950-10-16',5,3),
('The Wise Man',4700,22,'2011-04-1',4,8),
('The Fear',1200,22,'2001-04-1',4,8),
('Microsoft C#',550,9,'2013-04-1',3,9),
('Microsoft Windows .Net',400,9,'2013-04-1',6,9),
('Windows forms',550,9,'2001-04-1',6,9),
('Microsoft soft',2200,9,'2003-04-1',6,9)
;
go

insert into Sales(Price,Quantity,SaleDate,BookId,ShopId)
values
(25,5000,'2011-05-27',2,2),
(35,3000,'2001-08-27',3,2),
(35,3000,'2002-01-27',3,3),
(35,4000,'2007-05-27',3,4),
(44,4000,'2009-06-27',4,4),
(44,4000,'2018-05-27',4,5),
(41,8000,'2008-05-27',5,5),
(31,11000,'2008-02-27',6,4),
(31,11000,'2008-08-27',6,2),
(44,1000,'2006-05-27',7,1),
(33,6000,'2008-03-17',7,4),
(33,6000,'2002-03-17',8,4),
(22,9000,'2012-08-17',8,2),
(22,9000,'2012-08-17',8,1),
(38,8800,'2017-08-17',9,5),
(38,800,'2017-04-17',9,2),
(38,400,'2017-01-17',9,3),
(38,8800,'2015-08-17',3,5),
(31,1000,'2011-08-17',7,2),
(38,800,'2012-08-17',9,3),
(30,10000,'2005-05-27',1,1),
(30,80,'2005-05-27',12,3),
(35,40,'2005-05-27',13,2),
(32,28,'2005-05-27',14,1)
;
go


--- 1. Показать все книги, количество страниц в которых больше 500, но меньше 650.
select *
from Books
where Books.Pages between  500 and 650
;

--- 2. Показать все книги, в которых первая буква названия либо «А», либо «З». 'A' || 'The'
select *
from Books
where Books.Name like 'A%'
or
Books.Name like 'The%'
;

--- 3. Показать все книги жанра «Детектив», количество проданных книг более 30 экземпляров. 'Detective'(id=8) (Sales>30)
select Books.Name as 'Title',Themes.Name as 'Genre' , Sales.Quantity as "Saled Count"
from Sales join Books on Sales.BookId=Books.Id and Sales.Quantity>30
join Themes on Books.ThemeId=Themes.Id
and Themes.Name='Detective'
;

--- 4. Показать все книги, в названии которых есть слово «Microsoft », но нет слова «Windows».
select *
from Books 
where Books.Name like '%Microsoft%' and  Books.Name not like '%Windows%'
;

--- 5. Показать все книги (название, тематика, полное имя автора в одной ячейке), цена одной страницы которых меньше 65 копеек.
select Books.Name+'. '+ Themes.Name+'. '+Authors.Name+ ' '+Authors.Surname as 'Books', Books.Price/Books.Pages as "One paper cost"
from Authors join Books on Books.AuthorId=Authors.Id and Books.Price/Books.Pages<0.65
join Themes on Themes.Id=Books.ThemeId
;

--- 6. Показать все книги, название которых состоит из 4 слов.
select * , len(Books.Name)-len(replace(Books.Name,' ',''))+1 as 'Words count'
from Books
where len(Books.Name)-len(replace(Books.Name,' ',''))+1=4
;


--- 7. Показать информацию о продажах в следующем виде:
    --- ▷▷Название книги, но, чтобы оно не содержало букву «А». not like '%A%'
    --- ▷▷Тематика, но, чтобы не «Программирование». not Study
    --- ▷▷Автор, но, чтобы не «Герберт Шилдт». not Bill Gates
    --- ▷▷Цена, но, чтобы в диапазоне от 10 до 20 гривен.
    --- ▷▷Количество продаж, но не менее 8 книг.
    --- ▷▷Название магазина, который продал книгу, но он не должен быть в Украине или России. not USA or Poland
select Books.Name as 'Title',Themes.Name as 'Genre', Authors.Name+' '+Authors.Surname as 'Author',Books.Price, Sales.Quantity as 'Quantity of sales',Shops.Name 'Shop''s name' 
from Themes join Books on Books.ThemeId=Themes.Id and Themes.Name not like 'Study' and Books.Name not like '%A%' and Books.Price between 10 and 20
join Authors on Authors.Id=Books.AuthorId and Authors.Name not like 'Bill' and Authors.Surname not like 'Gates'
join Sales on Books.Id=Sales.BookId and Sales.Quantity>8
join Shops on Shops.Id=Sales.ShopId
join Countries on Countries.Id=Shops.CountryId and Countries.Name not like 'USA' and Countries.Name not like 'Poland'
;

--- 8. Показать следующую информацию в два столбца (числа в правом столбце приведены в качестве примера):
    --- ▷▷Количество авторов: 14
    --- ▷▷Количество книг: 47
    --- ▷▷Средняя цена продажи: 85.43 грн.
    --- ▷▷Среднее количество страниц: 650.6.
select count(Authors.Id) as 'Authors count', count(Books.Id) as 'Books count', avg(Sales.Price) as 'Average sale cost', avg(Books.Pages) as 'Average pages count'
from Authors,Books,Sales
;

--- 9. Показать тематики книг и сумму страниц всех книг по каждой из них.
select Themes.Name as 'Genre' , sum (Books.Pages) as 'Pages count'
from Books join Themes on Themes.Id=Books.ThemeId
group by Themes.Name
;

--- 10. Показать количество всех книг и сумму страниц этих книг по каждому из авторов.
select Authors.Name+' '+Authors.Surname as 'Author' , count (Books.id) as 'Books count' , sum (Books.Pages) as 'Pages count'
from Authors join Books on Authors.Id=Books.AuthorId
join Themes on Themes.Id=Books.ThemeId
group by Authors.Name+' '+Authors.Surname
;

--- 11. Показать книгу тематики «Программирование» с наибольшим количеством страниц. Study
select top 1 *
from Books join Themes on Themes.id=Books.ThemeId  and Themes.Name like 'Study'
order by Books.Pages desc
;

--- 12. Показать среднее количество страниц по каждой тематике, которое не превышает 400.
select Themes.Name , avg (Books.Pages)
from Books join Themes on Themes.Id=Books.ThemeId
group by Themes.Name
having avg(Books.Pages)<400
;

--- 13. Показать сумму страниц по каждой тематике, учитывая только книги с количеством страниц более 400,
	--- и чтобы тематики были «Программирование», «Администрирование » и «Дизайн». Fantasy , Detective ,Study
select Themes.Name , sum (Books.Pages)
from Books join Themes on Themes.Id=Books.ThemeId and Books.Pages>400 and Themes.Name in ('Fantasy','Detective','Study')
group by Themes.Name
;

--- 14. Показать информацию о работе магазинов: что, где, кем, когда и в каком количестве было продано.
select Books.Name as 'What',Countries.Name 'Where', Shops.Name as 'Whom' , Sales.SaleDate as 'When' , Sales.Quantity as 'How much'
from Books join Sales on Sales.BookId=Books.Id
join Shops on Shops.Id=Sales.ShopId
join Countries on Countries.Id=Shops.CountryId
order by Books.Name
;

--- 15. Показать самый прибыльный магазин.
select top 1 Shops.Name as 'Shop Title', sum(Sales.Price*Sales.Quantity) as 'Profit'
from Sales join Shops on Sales.ShopId=Shops.Id
group by Shops.Name
order by 'Profit' desc
;


