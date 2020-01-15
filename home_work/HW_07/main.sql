-------------------------------------------------------------------------------------------------------------------------


use [master];
go

if db_id('SportShopDB') is not null
begin
	drop database [SportShopDB];
end
go

create database [SportShopDB];
go

use [SportShopDB];
go

---1. О товарах: название товара, вид товара (одежда, обувь, и т.д.), количество товара в наличии, себестоимость, производитель, цена продажи 
create table [Products]
(
    [Id] int not null identity(1, 1) constraint pk_ProductsID primary key,
	[Name] nvarchar(100) not null check ([Name] <> N''),
	[TypeId] int not null,
    [Quantity] int default 0,
    [PrimeValue] int default 0,
	[ManufacturerId] int not null,
    [SaleValue] int  default 0

);
go

create table [ProductTypes]
(
    [Id] int not null identity(1, 1) constraint pk_ProductTypesID primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Manufacturers]
(
    [Id] int not null identity(1, 1) constraint pk_ManufacturersID primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

---2. О продажах: название проданного товара, цена продажи, количество, дата продажи,
---     информация о продавце (ФИО сотрудника, выполнившего продажу), информация о покупателе (ФИО покупателя, если купил зарегистрированный покупатель) 
create table [Sales]
(
    [Id] int not null identity(1, 1) constraint pk_SalesID primary key,
	[ProductId] int not null,
    [SaleValue] int default 0,
    [Quantity] int default 0,
    [SaleDate] date default getdate(),
    [SellerId] int not null,
    [BuyerId] int default null
);
go

---3. О сотрудниках: ФИО сотрудника, должность, дата приёма на работу, пол, зарплата 
create table [Sellers]
(
    [Id] int not null identity(1, 1) constraint pk_SellersID primary key,
	[PersonId] int not null,
	[PositionId] int not null,
    [EmployDate] date not null,
	[GenderId] int default 1,
	[Salary] money not null check (Salary > 0)
);
go

create table [Genders]
(
    [Id] int not null identity(1, 1) constraint pk_GendersID primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Persons]
(
    [Id] int not null identity(1, 1) constraint pk_PersonsID primary key,
	[Name] nvarchar(100) not null check ([Name] <> N''),
	[Surname] nvarchar(100) not null check ([Surname] <> N''),
	[MiddleName] nvarchar(100) not null check ([MiddleName] <> N'')
);
go

create table [Positions]
(
    [Id] int not null identity(1, 1) constraint pk_PositionsID primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

---4. О клиентах: ФИО клиента, email, контактный телефон, пол, история заказов, процент скидки, подписан ли на почтовую рассылку.
create table [Buyers]
(
    [Id] int not null identity(1, 1) constraint pk_BuyersID primary key,
	[PersonId] int not null,
    [Email] varchar(255) not null unique check ([Email] <> N''),
    [PhoneNumber] varchar(22) not null unique check ([PhoneNumber] <> N''),
	[GenderId] int default 1,
	[Discount] decimal(5,4) default 0 check (Discount between 0 and 100),
	[MailSubscribe] bit default 0,
);
go

alter table [Products]
add constraint fk_Products_ProductTypesID foreign key ([TypeId]) references [ProductTypes]([Id]);
go

alter table [Products]
add constraint fk_Products_ManufacturersID foreign key ([ManufacturerId]) references [Manufacturers]([Id]);
go

alter table [Sales]
add constraint fk_Sales_ProductsID foreign key ([ProductId]) references [Products]([Id]);
go

alter table [Sales]
add constraint fk_Sales_SellersID foreign key ([SellerId]) references [Sellers]([Id]);
go

alter table [Sales]
add constraint fk_Sales_BuyersID foreign key ([BuyerId]) references [Buyers]([Id]);
go

alter table [Sellers]
add constraint fk_Sellers_PersonsID foreign key ([PersonId]) references [Persons]([Id]);
go

alter table [Sellers]
add constraint fk_Sellers_PositionsID foreign key ([PositionId]) references [Positions]([Id]);
go

alter table [Sellers]
add constraint fk_Sellers_GendersID foreign key ([GenderId]) references [Genders]([Id]);
go

alter table [Buyers]
add constraint fk_Buyers_PersonsID foreign key ([PersonId]) references [Persons]([Id]);
go

alter table [Buyers]
add constraint fk_Buyers_GendersID foreign key ([GenderId]) references [Genders]([Id]);
go

-------------------------------------------
/*
ProductTypes\Manufacturers -> Products
Genders\Persons -> Buyers
Genders\Persons\Positions -> Sellers
Products\Sellers\Buyers -> Sales
*/
-------------------------------------------

---ProductTypes\Manufacturers -> Products
insert into ProductTypes(Name)
values
('Snickers'),
('T-shirt'),
('Gloves'),
('Pants'),
('Sox')
;
go

insert into Manufacturers(Name)
values
('Abibas'),
('Nukas'),
('Kuma'),
('Xiaomi'),
('Pineapple')
;
go

insert into Products (Name,TypeId,Quantity,PrimeValue,ManufacturerId,SaleValue)
values
('Chavkodav-3000',1,12,1000,1,2500),
('Radioactive Chavkodav',1,22,1200,2,3500),
('Gansta gun',1,55,3000,1,5500),
('IChavkodav',1,1,10000,5,11500),
('MyShirt-2k10',2,32,200,1,2500),
('My Nuka shirt',2,55,199,2,2499),
('Jaguar skin',2,6,1111,3,3999),
('Lion skin',2,5,1000,3,2199),
('Fat puma',2,1,4000,3,4001),
('Useful Shirt',2,111,99,4,100),
('Like a spotsman',3,4,100,1,1000),
('Like a spotsman-2k17',3,25,1000,1,4000),
('Like a spotsman-2k18',3,12,2000,1,8000),
('Like a spotsman-2k19',3,12,3000,1,16000),
('Like a spotsman-2k20',3,12,4000,1,32000),
('Like a spotsman-from the future',3,12,9999,1,199999),
('Pripyat panty',3,14,100,2,2000),
('Nuka pants',3,666,100,2,3000),
('Branded cutty cat',3,11,220000,3,99999),
('Useful and simple',3,222,100,4,199),
('Simple sox',5,111,9,4,15)
;
go

-------------------------------------------

---Genders\Persons -> Buyers
insert into Genders(Name)
values
('Unknown'),
('Male'),
('Female')
;
go

insert into Persons(Name,Surname,MiddleName)
values
('Petro','Petrov','Petovich'),
('Snake','Solid','7'),
('Snake','Old','Clone'),
('Petro','Petrov','Antonov'),
('Bilbo','Beggins','Hobbitson'),
('Frodo','Beggins','Bolboson'),
('Saruman','Wise','The'),
('Sauron','Corruption','Middle Earth''s')
;
go

insert into Buyers(PersonId,Email,PhoneNumber,GenderId,Discount,MailSubscribe)
values
(1,'petro007@rubler.com.ch.ru.mc','440932421',2,0.0,0),
(1,'petroTheUniqOne@mail.ru','4409322421',2,0.0,1),
(2,'snake1980@kodzima.net','4409326661',1,0.10,0),
(4,'petro007@rubmbler.net','44093232421',3,0.0,1)
;
go

-------------------------------------------

---Genders\Persons\Positions -> Sellers
insert into Positions(Name)
values
('Junior Seller'),
('Main Seller'),
('Default Seller'),
('Off Seller')
;
go

insert into Sellers(PersonId,PositionId,EmployDate,GenderId,Salary)
values
(5,1,'02-22-2019',2,5000),
(8,2,'12-26-2013',2,15000),
(7,3,'02-22-2014',2,12000),
(6,1,'02-23-2018',2,4000)
;
go

-------------------------------------------

---Products\Sellers\Buyers -> Sales
insert into Sales(ProductId,SaleValue,Quantity,SaleDate,SellerId,BuyerId)
values
(1,2200,2,'2-22-2019',1,1),
(2,3200,22,'2-24-2019',1,2),
(3,4200,15,'2-21-2019',1,3),
(4,5200,13,'3-26-2019',1,1),
(5,3200,11,'2-20-2019',2,4),
(6,2200,10,'3-19-2019',3,2),
(6,1200,9,'1-28-2019',4,3),
(1,6200,8,'2-21-2019',3,2)
;
go



----------- Задание 1. Для базы данных «Спортивный магазин» из практического задания модуля «Триггеры,
----------- хранимые процедуры и пользовательские функции» создайте следующие хранимые процедуры: 
-------------------------------------------------------------------------------------------------------------------------

---     1. Хранимая процедура отображает полную информацию о всех товарах 
if object_id('sp_show_full_info_about_priducts','P')is not null
    drop procedure sp_show_full_info_about_priducts;
go
create procedure sp_show_full_info_about_priducts
as 
select p.Id , p.Name as 'Product', pt.Name as 'Type', p.Quantity,p.PrimeValue,m.Name as 'Manufacturer',p.SaleValue
from  Products p left join ProductTypes pt on p.TypeId=pt.Id
left join Manufacturers m on p.ManufacturerId=m.Id
;

go 
exec sp_show_full_info_about_priducts ;


---     2. Хранимая процедура показывает полную информацию о товаре конкретного вида. 
---     Вид товара передаётся в качестве параметра. Например, если в качестве параметра указана обувь, нужно показать всю обувь, которая есть в наличии 
if object_id('sp_show_full_info_about_certain_priduct_type','P')is not null
    drop procedure sp_show_full_info_about_certain_priduct_type;
go
create procedure sp_show_full_info_about_certain_priduct_type @type_input nvarchar(100)
as 
select p.Id , p.Name as 'Product', pt.Name as 'Type', p.Quantity,p.PrimeValue,m.Name as 'Manufacturer',p.SaleValue
from  Products p join ProductTypes pt on p.TypeId=pt.Id and pt.Name=@type_input
join Manufacturers m on p.ManufacturerId=m.Id
;

go 
exec sp_show_full_info_about_certain_priduct_type 'Snickers';


---     3. Хранимая процедура показывает топ-3 самых старых клиентов. Топ-3 определяется по дате регистрации (дата регистрации(приема на работу) есть только у продавцов)
if object_id('sp_show_oldest_sellers','P')is not null
    drop procedure sp_show_oldest_sellers;
go
create procedure sp_show_oldest_sellers
as 
select top 3 s.Id , p.Name, p.SurName,p.MiddleName,pos.Name as 'Position',s.EmployDate,g.Name as 'Gender',s.Salary
from Sellers s join Persons p on s.PersonId=p.Id
join Positions pos on s.PositionId=pos.Id
join Genders g on s.GenderId=g.Id
order by s.EmployDate
;

go 
exec sp_show_oldest_sellers;


---     4. Хранимая процедура показывает информацию о самом успешном продавце. Успешность определяется по общей сумме продаж за всё время
if object_id('sp_show_best_seller','P')is not null
    drop procedure sp_show_best_seller;
go
create procedure sp_show_best_seller
as 
select top 3 s.Id , p.Name, p.SurName,p.MiddleName,pos.Name as 'Position',s.EmployDate,g.Name as 'Gender',s.Salary
from Sellers s join Persons p on s.PersonId=p.Id and s.Id=
(
	select top 1 s.SellerId
	from Sales s
	group by s.SellerId
	order by sum(SaleValue) desc
)
join Positions pos on s.PositionId=pos.Id
join Genders g on s.GenderId=g.Id
order by s.EmployDate
;

go 
exec sp_show_best_seller;


---     5. Хранимая процедура проверяет есть ли хоть один товар указанного производителя в наличии. 
---     Название производителя передаётся в качестве параметра. 
---     По итогам работы хранимая процедура должна вернуть yes в том случае, если товар есть, и no, если товара нет 
if object_id('sp_product_exists','P')is not null
    drop procedure sp_product_exists;
go
create procedure sp_product_exists @manufacturer_input nvarchar(100), @answer nvarchar(3) output
as 
if exists (select p.id from Products p join Manufacturers m on p.ManufacturerId=m.Id and m.Name=@manufacturer_input)
set @answer='yes'
else
set @answer='no'
;

go 
declare @answer nvarchar(3)
exec sp_product_exists 'Abibas', @answer output
select @answer;


---     6. Хранимая процедура отображает информацию о самом популярном производителе среди покупателей. 
---     Популярность среди покупателей определяется по общей сумме продаж 
if object_id('sp_show_best_manufacturer','P')is not null
    drop procedure sp_show_best_manufacturer;
go
create procedure sp_show_best_manufacturer
as 
	select top 1 p.ManufacturerId, m.Name , sum(s.SaleValue)
	from Sales s join Products p on s.ProductId=p.Id
    join Manufacturers m on p.ManufacturerId=m.Id
	group by p.ManufacturerId, m.Name
	order by sum(s.SaleValue) desc
;

go 
exec sp_show_best_manufacturer;


---     7. Хранимая процедура удаляет всех клиентов, зарегистрированных после указанной даты. 
---     Дата передаётся в качестве параметра. Процедура возвращает количество удаленных записей. (у клиентов нет никаких дат ,поэтому будут продавци)
if object_id('sp_remove_sellers_employed_after','P')is not null
    drop procedure sp_remove_sellers_employed_after;
go
create procedure sp_remove_sellers_employed_after @employ_date_input date, @deleted_sellers int output
as 
set @deleted_sellers=(select count(s.id) from Sellers s where EmployDate > @employ_date_input)
delete from Sales
where SellerId in (select Id from Sellers where EmployDate > @employ_date_input)
delete from Sellers
where Id in (select Id from Sellers where EmployDate > @employ_date_input)
;

go 
declare @deleted_sellers int
exec sp_remove_sellers_employed_after '11.19.2016', @deleted_sellers output
select @deleted_sellers;



-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------_END_OF_SPORT_SHOP_-----------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


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

go
insert into Publisher(Name,Country)
values
('Britain Records','Britain'),
('USA Records','USA'),
('Russian Records','Russia'),
('Indian Records','India'),
('China Records','China')
;

go
insert into Genre(Name)
values
('Indie Rock'),
('Doom Metal'),
('Core Metal'),
('D&B')
;

go
insert into Author(Name)
values
('Deathclock'),
('Rolling Stones'),
('Muse'),
('Pirate Station')
;

go
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

go
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


-----------  Задание 2. Для базы данных «Музыкальная коллекция» из практического задания модуля 
-----------  «Работа с таблицами и представлениями в MS SQL Server» создайте следующие хранимые процедуры: 
-------------------------------------------------------------------------------------------------------------------------

---     1. Хранимая процедура показывает полную информацию о музыкальных дисках 
if object_id('sp_show_full_info','P')is not null
    drop procedure sp_show_full_info;
go
create procedure sp_show_full_info
as 
select Song.Name as 'Song',Author.Name as 'Author', Song.Durability,Disk.Name as 'Disk',Genre.Name as 'Genre', Disk.PublishDate,Publisher.Name as 'Publisher',Publisher.Country 
from Song join Disk on Song.DiskId=Disk.Id
join Author on Author.Id=Disk.AuthorId
join Genre on Genre.Id=Disk.GenreId
join Publisher on Publisher.Id=Disk.PublisherId;

go 
exec sp_show_full_info ;


---     2. Хранимая процедура показывает полную информацию о всех музыкальных дисках конкретного издателя. Название издателя передаётся в качестве параметра 
if object_id('sp_show_publisher_disks','P')is not null
    drop procedure sp_show_publisher_disks;
go
create procedure sp_show_publisher_disks @publ_input nvarchar(100)
as 
select Song.Name as 'Song',Author.Name as 'Author', Song.Durability,Disk.Name as 'Disk',Genre.Name as 'Genre', Disk.PublishDate,Publisher.Name as 'Publisher',Publisher.Country 
from Song join Disk on Song.DiskId=Disk.Id
join Author on Author.Id=Disk.AuthorId
join Genre on Genre.Id=Disk.GenreId
join Publisher on Publisher.Id=Disk.PublisherId and Publisher.Name=@publ_input --- like ('%'+@publ+'%');

go 
exec sp_show_publisher_disks 'USA';


---     3. Хранимая процедура показывает название самого популярного стиля 
if object_id('sp_show_most_popular_style','P')is not null
    drop procedure sp_show_most_popular_style;
go
create procedure sp_show_most_popular_style
as 
select top 1 Genre.Name as 'Most popular genre' , count(Disk.Id) as 'Disks'
from Disk join Genre on Disk.GenreId=Genre.Id
group by Genre.Name
order by 'Disks' desc;

go 
exec sp_show_most_popular_style ;

---     4. Популярность стиля определяется по количеству дисков в коллекции (same)
if object_id('sp_show_most_popular_style','P')is not null
    drop procedure sp_show_most_popular_style;
go
create procedure sp_show_most_popular_style
as 
select top 1 Genre.Name as 'Most popular genre' , count(Disk.Id) as 'Disks'
from Disk join Genre on Disk.GenreId=Genre.Id
group by Genre.Name
order by 'Disks' desc;

go 
exec sp_show_most_popular_style ;


---     5. Хранимая процедура отображает информацию о диске конкретного стиля с наибольшим количеством песен. 
---     Название стиля передаётся в качестве параметра, если передано слово all, анализ идёт по всем стилям 
if object_id('sp_show_biggest_disk_by_style','P')is not null
    drop procedure sp_show_biggest_disk_by_style;
go
create procedure sp_show_biggest_disk_by_style @genre_input nvarchar(100)
as 
if (@genre_input='all')
	begin
		select Song.Name as 'Song',Author.Name as 'Author', Song.Durability,Disk.Name as 'Disk',Genre.Name as 'Genre', Disk.PublishDate,Publisher.Name as 'Publisher',Publisher.Country 
		from Song join Disk on Song.DiskId=Disk.Id and Disk.Name =
			(
			select top 1 Disk.Name
			from Song join Disk on Song.DiskId=Disk.Id 
			join Genre on Genre.Id=Disk.GenreId
			group by Disk.Name
			order by count(Song.Id) desc
			)
		join Author on Author.Id=Disk.AuthorId
		join Genre on Genre.Id=Disk.GenreId
		join Publisher on Publisher.Id=Disk.PublisherId
	end
else
	begin
		select Song.Name as 'Song',Author.Name as 'Author', Song.Durability,Disk.Name as 'Disk',Genre.Name as 'Genre', Disk.PublishDate,Publisher.Name as 'Publisher',Publisher.Country 
		from Song join Disk on Song.DiskId=Disk.Id and Disk.Name =
			(
			select top 1 Disk.Name
			from Song join Disk on Song.DiskId=Disk.Id 
			join Genre on Genre.Id=Disk.GenreId and Genre.Name=@genre_input --- like ('%'+@genre_input+'%')
			group by Disk.Name
			order by count(Song.Id) desc
			)
		join Author on Author.Id=Disk.AuthorId
		join Genre on Genre.Id=Disk.GenreId
		join Publisher on Publisher.Id=Disk.PublisherId
	end;

go 
exec sp_show_biggest_disk_by_style 'rock';


---     6. Хранимая процедура удаляет все диски заданного стиля. Название стиля передаётся в качестве параметра. 
---     Процедура возвращает количество удаленных альбомов 
if object_id('sp_remove_disks_with_style','P')is not null
    drop procedure sp_remove_disks_with_style;
go
create procedure sp_remove_disks_with_style @style_input nvarchar(100), @deleted_disks int output
as 
delete from Song
where DiskId in (select Disk.Id from Disk join Genre on Disk.GenreId=Genre.id and Genre.Name=@style_input)
set @deleted_disks=(select count(disk.id) from Disk join Genre on Disk.GenreId=Genre.id and Genre.Name=@style_input)
delete from Disk
where Id in (select Disk.Id from Disk join Genre on Disk.GenreId=Genre.id and Genre.Name=@style_input)
;

go 
declare @deleted_disks int
exec sp_remove_disks_with_style 'Core Metal', @deleted_disks output
select @deleted_disks;


---     7. Хранимая процедура отображает информацию о самом «старом» альбом и самом «молодом». 
---     Старость и молодость определяются по дате выпуска 
if object_id('sp_show_oldest_and_youngest_disks','P')is not null
    drop procedure sp_show_oldest_and_youngest_disks;
go
create procedure sp_show_oldest_and_youngest_disks
as 
declare @min_date date
declare @max_date date
set @min_date=
	(
		select top 1 Disk.PublishDate
		from Disk
		order by Disk.PublishDate
	)
set @max_date=
	(
		select top 1 Disk.PublishDate
		from Disk
		order by Disk.PublishDate desc
	)
select top 1 'Newest',Song.Name as 'Song',Author.Name as 'Author', Song.Durability,Disk.Name as 'Disk',Genre.Name as 'Genre', Disk.PublishDate,Publisher.Name as 'Publisher',Publisher.Country 
from Song join Disk on Song.DiskId=Disk.Id and Disk.PublishDate=@max_date
join Author on Author.Id=Disk.AuthorId
join Genre on Genre.Id=Disk.GenreId
join Publisher on Publisher.Id=Disk.PublisherId
union all
select top 1 'Oldest',Song.Name as 'Song',Author.Name as 'Author', Song.Durability,Disk.Name as 'Disk',Genre.Name as 'Genre', Disk.PublishDate,Publisher.Name as 'Publisher',Publisher.Country 
from Song join Disk on Song.DiskId=Disk.Id and Disk.PublishDate=@min_date
join Author on Author.Id=Disk.AuthorId
join Genre on Genre.Id=Disk.GenreId
join Publisher on Publisher.Id=Disk.PublisherId
;

go 
exec sp_show_oldest_and_youngest_disks ;


---     8. Хранимая процедура удаляет все диски в названии которых есть заданное слово. 
---     Слово передаётся в качестве параметра. Процедура возвращает количество удаленных альбомов.
if object_id('sp_remove_disks_which_includes_word','P')is not null
    drop procedure sp_remove_disks_which_includes_word;
go
create procedure sp_remove_disks_which_includes_word @word_input nvarchar(100), @deleted_disks int output
as 
set @deleted_disks=(select count(disk.id) from Disk where Name like ('%'+@word_input+'%'))
delete from Song
where DiskId in (select Disk.Id from Disk where Disk.Name like ('%'+@word_input+'%'))
delete from Disk
where Id in (select Disk.Id from Disk where Disk.Name like ('%'+@word_input+'%'))
;

go 
declare @deleted_disks int
exec sp_remove_disks_which_includes_word 'Polka', @deleted_disks output
select @deleted_disks;


