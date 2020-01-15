--- Задание 3. Создайте базу данных «Музыкальная коллекция».
--- База данных должна содержать информацию о музыкальных дисках, исполнителях, стилях. Необходимо хранить
--- следующую информацию:
---     1. О музыкальном диске: название диска, исполнитель, дата выпуска, стиль, издатель
---     2. О стилях: названия стилей
---     3. Об исполнителях: название
---     4. Об издателях: название, страна
---     5. О песнях: название песни, название диска, длительность песни, музыкальный стиль песни, исполнитель.

--- Продумайте правильную структуру базы данных. Для создания базы данных используйте запрос CREATE DATABASE.
--- Для создания таблицы используйте запрос CREATE TABLE.
--- Обязательно при создании таблиц задавать связи между ними.


use [master];
go

if db_id('Music_collection') is not null
begin
	drop database [Music_collection];
end
go

create database [Music_collection];
go

use [Music_collection];
go

---     1. О музыкальном диске: название диска, исполнитель, дата выпуска, стиль, издатель
create table [Disk]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
	[AuthorId] int not null,
	[PublishDate] date not null ,
    [GenreId] int not null,
    [PublisherId] int not null
);
go

---     2. О стилях: названия стилей
create table [Genre]
(
    [Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

---     3. Об исполнителях: название
create table [Author]
(
    [Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

---     4. Об издателях: название, страна
create table [Publisher]
(
    [Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
	[Country] nvarchar(100) not null check ([Country] <> N'')
);
go

---     5. О песнях: название песни, название диска, длительность песни, музыкальный стиль песни, исполнитель.
create table [Song]
(
    [Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
	[Durability] float not null check (Durability>0),
	[DiskId] int not null
);
go

alter table [Disk]
add foreign key ([AuthorId]) references [Author]([Id]);
go

alter table [Disk]
add foreign key ([GenreId]) references [Genre]([Id]);
go

alter table [Disk]
add foreign key ([PublisherId]) references [Publisher]([Id]);
go

alter table [Song]
add foreign key ([DiskId]) references [Disk]([Id]);
go

--- Song -> Disk -> Author|Genre|Publisher

insert into Publisher(Name,Country)
values
('Britain Records','Britain'),
('USA Records','USA'),
('Russian Records','Russia'),
('Indian Records','India'),
('China Records','China')
;

insert into Genre(Name)
values
('Indie Rock'),
('Doom Metal'),
('Core Metal'),
('D&B')
;

insert into Author(Name)
values
('Deathclock'),
('Rolling Stones'),
('Muse'),
('Pirate Station')
;

insert into Disk(Name,AuthorId,PublishDate,GenreId,PublisherId)
values
('Trash',4,'2010-03-2',4,2),
('Hard',1,'2000-07-2',2,1),
('Indastrial',3,'2012-03-2',1,3),
('Stones',2,'1989-03-2',1,4),
('About life',3,'2001-02-12',1,5),
('Some kind',4,'2010-03-2',4,2),
('Polka',4,'2012-12-22',4,3)
;

insert into Song(Name,Durability,DiskId)
values
('First',3.55,1),
('Second',3.25,2),
('Third',4.55,3),
('Uno',3.51,4),
('Ich',3.15,5),
('Nee',4.35,6),
('San',3.21,7),
('Chee',3.35,5),
('Go',4.15,6),
('Rok',3.15,4),
('Sich',4.35,3),
('Hach',3.21,2),
('Ku',3.35,1),
('Dzyu',4.15,1),
('Dzyu-Ich',3.21,2),
('Dzyu-Nee',3.35,1),
('Dzyu-San',4.15,1),
('Dzyu-Chee',3.21,2),
('Dzyu-Go',3.35,1),
('Dzyu-Rok',4.15,1)
;

--- Exercises ---

---	Задание 1. Все задания необходимо выполнить по отношению к базе данных «Музыкальная коллекция»,
---	описанной в практическом задании для этого модуля. 
--- Создайте следующие представления: 

---		1. Представление отображает названия всех исполнителей 
create view SingersView as
select Name from Author;

---		2. Представление отображает полную информацию о всех песнях: название песни, название диска, длительность песни, музыкальный стиль песни, исполнитель 
create view SongInfoView as 
select song.name as 'Song' ,disk.name as 'Disk',Song.Durability,Genre.Name as 'Genre ',Author.Name as 'Author'
from song join Disk on Song.DiskId=Disk.Id
join Author on Author.Id=Disk.AuthorId
join Genre on Genre.Id=Disk.GenreId;

---		3. Представление отображает информацию о музыкальных дисках конкретной группы. Например, The Beatles 
create view ParticularAuthorView as 
select Disk.Name as 'Disk',Author.Name as 'Author',PublishDate , Genre.Name as 'Genre',Publisher.Name as 'Publisher',Publisher.Country
from Disk join Author on Author.Id=Disk.AuthorId and Author.Name like 'Muse'
join Genre on Genre.Id=Disk.GenreId
join Publisher on Publisher.Id=Disk.PublisherId;

---		4. Представление отображает название самого популярного в коллекции исполнителя. Популярность определяется по количеству дисков в коллекции 
create view MostPopularView as 
select top 1 Author.Name , count(Disk.Id) as 'Disks'
from Disk join Author on Disk.AuthorId=Author.Id
group by Author.Name
order by 'Disks' desc;

---		5. Представление отображает топ-3 самых популярных в коллекции исполнителей. Популярность определяется по количеству дисков в коллекции 
create view Top3View as 
select top 3 Author.Name , count(Disk.Id) as 'Disks'
from Disk join Author on Disk.AuthorId=Author.Id
group by Author.Name
order by 'Disks' desc;

---		6. Представление отображает самый долгий по длительности музыкальный альбом
create view LongestDiskView as
select top 1 Disk.Name , sum(Song.Durability) as 'Time'
from song join Disk on Song.DiskId=Disk.Id
group by Disk.Name
order by 'Time' desc;
;

--- Задание 2. Все задания необходимо выполнить по отношению к базе данных «Музыкальная коллекция», описанной в практическом задании для этого модуля: 
--- 	1. Создайте обновляемое представление, которое позволит вставлять новые стили 
create view GenresView as 
select Name
from Genre;

--- 	2. Создайте обновляемое представление, которое позволит вставлять новые песни 
create view SongsView as 
select Name,Durability,DiskId
from Song;

--- 	3. Создайте обновляемое представление, которое позволит обновлять информацию об издателе 
create view PublishersView as 
select Name,Country
from Publisher;

--- 	4. Создайте обновляемое представление, которое позволит удалять исполнителей 
--- Из-за того что диск ссылается сюда ,это невозможно...
create view AuthorsView as 
select Name
from Author;

---		5. Создайте обновляемое представление, которое позволит обновлять информацию о конкретном исполнителе. Например, Muse. 
create view AuthorsView as 
select Name
from Author;
go
update AUthorsView
set Name='Bur bur' 
where Id=3;
go
select * from AuthorsView;


--- Задание 4. Все задания необходимо выполнить по отношению к базе данных из третьего задания: 
--- 	1. Добавьте к уже существующей таблице с информацией о музыкальном диске столбец с краткой рецензией на него 
ALTER TABLE Disk
ADD Review nvarchar(100);

--- 	2. Добавьте к уже существующей таблице с информацией об издателе столбец с юридическим адресом главного офиса 
ALTER TABLE Publisher
ADD LegalAdress nvarchar(100);

--- 	3. Измените в уже существующей таблице с информацией о песнях размер поля, хранящий название песни 
ALTER TABLE Song
ALTER COLUMN Name nvarchar(150); 

--- 	4. Удалите из уже существующей таблицы с информацией об издателе столбец с юридическим адресом главного офиса
ALTER TABLE Publisher
Drop COLUMN LegalAdress; 

--- 	5. Удалите связь между таблицами «музыкальных дисков» и «исполнителей» 
ALTER TABLE dbo.Disk
DROP constraint FK__Disk__AuthorId__1BC821DD; 
/*go
alter table Disk
drop column AuthorId;
*/

--- 	6. Добавьте связь между таблицами «музыкальных дисков» и «исполнителей».
/*alter table Disk
add AuthorId int;
go
*/
alter table [Disk]
add foreign key ([AuthorId]) references [Author]([Id]);

------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_Music_collection_END_----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Задание 1. Создайте базу данных «Телефонный справочник».
--- Эта база данных должна содержать одну таблицу «Люди».
--- В таблице нужно хранить: ФИО человека, дату рождения, пол, телефон, город проживания, страна проживания, домашний адрес.

use [master];
go

if db_id('Phonebook') is not null
begin
	drop database [Phonebook];
end
go

create database [Phonebook];
go

use [Phonebook];
go

--- Эта база данных должна содержать одну таблицу «Люди».
--- В таблице нужно хранить: ФИО человека, дату рождения, пол, телефон, город проживания, страна проживания, домашний адрес.
create table [People]
(
	[Id] int not null identity(1, 1) primary key,
	[FullName] nvarchar(100) not null check ([FullName] <> N''),
	[BirthDate] date not null ,
	[Gender] nvarchar(100) not null,
    [PhoneNum] varchar(15) not null,
    [City] nvarchar(100) not null,
    [Country] nvarchar(100) not null,
    [Adress] nvarchar(100) not null	
);
go


------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------_Phonebook_END_------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Задание 2. Создайте базу данных «Продажи». База данных должна содержать информацию о продавцах, покупателях, продажах. Необходимо хранить следующую информацию: 
use [master];
go

if db_id('Sales') is not null
begin
	drop database [SalesBD];
end
go

create database [SalesBD];
go

use [SalesBD];
go

--- 	1. О продавцах: ФИО, email, контактный телефон 
create table [Salers]
(
    [Id] int not null identity(1, 1) primary key,
	[FullName] nvarchar(100) not null check ([FullName] <> N''),
	[Email] nvarchar(100) not null check ([Email] <> N''),
    [PhoneNum] varchar(15) not null,

);
go

--- 	2. О покупателях: ФИО, email, контактный телефон 
create table [Buyers]
(
    [Id] int not null identity(1, 1) primary key,
	[FullName] nvarchar(100) not null check ([FullName] <> N''),
	[Email] nvarchar(100) not null check ([Email] <> N''),
    [PhoneNum] varchar(15) not null,

);
go

--- 	3. О продажах: покупатель, продавец, название товара, цена продажи, дата сделки. 
create table [Sales]
(
    [Id] int not null identity(1, 1) primary key,
	[BuyerId] int not null,
	[SalerId] int not null,
	[ProductTitle] nvarchar(100) not null check ([ProductTitle] <> N''),
	[Price] money not null check (Price > 0),
	[DealDate] date not null 

);
go

alter table [Sales]
add foreign key ([BuyerId]) references [Buyers]([Id]);
go

alter table [Sales]
add foreign key ([SalerId]) references [Salers]([Id]);
go


insert into Salers(FullName,Email,PhoneNum)
values
('Petro P.F.','petro666@ukr.net','380934275655'),
('Ivan Z.S','ivan1999@mail.ru','380931277855'),
('Michael Y.F.','micha_star@ukr.net','380674273555')
;
go

insert into Buyers(FullName,Email,PhoneNum)
values
('Dmitry E.R.','dm_nagibator@gmail.com','380932375555'),
('Igor D.D.','princess777@ukr.net','380934275512'),
('Sergey A.A.','satan999@ukr.ru','380934200555')
;

insert into Sales(BuyerId,SalerId,ProductTitle,Price,DealDate)
values
(1,1,'Fish ears',12222,'05-04-2010'),
(1,3,'Dino egg',122000,'12-04-2009'),
(2,3,'Dino egg',122000,'12-02-2009'),
(3,3,'Dino egg',122000,'11-03-2009'),
(2,3,'Hipo skin',19000,'10-12-2007'),
(3,1,'Fish hair',1200,'09-11-1998'),
(3,3,'Gods blessing',666,'02-11-1988'),
(3,2,'Fish tail',1000,'01-11-1998')
;

--- Exercises ---

--- Задание 3. Все задания необходимо выполнить по отношению к базе данных «Продажи», описанной в практическом задании для этого модуля: 
---					Используйте опции CHECK OPTION, SCHEMABINDING, ENCRYPTION там, где это необходимо или полезно.
--- 	1. Создайте обновляемое представление, которое отображает информацию о всех продавцах 
create view SalersView as 
select FullName,Email,PhoneNum
from Salers;

--- 	2. Создайте обновляемое представление, которое отображает информацию о всех покупателях 
create view BuyersView as 
select FullName,Email,PhoneNum
from Buyers;

--- 	3. Создайте обновляемое представление, которое отображает информацию о всех продажах конкретного товара. Например, яблок 
create view SalesView as 
select *
from Sales
where ProductTitle='Dino egg';

--- 	4. Создайте представление, отображающее все осуществленные сделки
create view DealsView as 
select Salers.FullName as 'Saler Full Name' , Salers.Email as 'Saler Email', Salers.PhoneNum as 'Saler phone number' ,
Buyers.FullName as 'Buyer Full Name' , Buyers.Email as 'Buyer Email', Buyers.PhoneNum as 'Buyer phone number' ,
Sales.ProductTitle as 'Product Title', Sales.Price as 'Product Price', Sales.DealDate as 'Deal Date'
from Sales
join [dbo].[Buyers] on [dbo].[Buyers].Id=[dbo].[Sales].BuyerId
join [dbo].[Salers] on [dbo].[Salers].Id=[dbo].[Sales].SalerId
;

--- 	5. Создайте представление, отображающее информацию о самом активном продавце. Определяем самого активного продавца по максимальной общей сумме продаж 
create view BestSalerView as 
select top 1 Salers.FullName as 'Saler Full Name' , Salers.Email as 'Saler Email', Salers.PhoneNum as 'Saler phone number' , sum(Sales.Price) as 'Summary income from deals'
from Sales
join [dbo].[Salers] on [dbo].[Salers].Id=[dbo].[Sales].SalerId
group by Salers.FullName , Salers.Email , Salers.PhoneNum
order by 'Summary income from deals' desc
;

--- 	6. Создайте представление, отображающее информацию о самом активном покупателе. Определяем самого активного покупателя по максимальной общей сумме покупок. 
create view BestBuyerView as
select top 1 Buyers.FullName as 'Buyer Full Name' , Buyers.Email as 'Buyer Email', Buyers.PhoneNum as 'Buyer phone number' , sum(Sales.Price) as 'Summary paid from deals'
from Sales
join [dbo].[Buyers] on [dbo].[Buyers].Id=[dbo].[Sales].BuyerId
group by Buyers.FullName , Buyers.Email , Buyers.PhoneNum
order by 'Summary paid from deals' desc
;


------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_Sales_END_---------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------