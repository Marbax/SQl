------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_Music_collection_--------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------


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

--- Задание 2. К базе данных «Музыкальная коллекция» из практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие триггеры: 

---         1. Триггер не позволяющий добавить уже существующий в коллекции альбом
create trigger add_product_black_list
on Disk instead of insert
as
begin
    insert into Disk
    select i.Name,i.AuthorId,i.PublishDate,i.GenreId,i.PublisherId
    from inserted i
    where i.Name not in(select i.Name from inserted i  group by i.Name,i.AuthorId)
end;

---         2. Триггер не позволяющий удалять диски группы The Beatles 
create trigger add_imun_beatles
on Disk instead of delete
as
begin
    delete from Disk
    where AuthorId!=(select a.Id from Author a where Name='Beatles')
    and Id in (select d.Id from deleted d )
end;

---         3. При удалении диска триггер переносит информацию об удаленном диске в таблицу «Архив» 
create table [DisksArchive]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) ,
	[AuthorId] int,
	[PublishDate] date ,
    [GenreId] int,
    [PublisherId] int
);
go


---         4. Триггер не позволяющий добавлять в коллекцию диски музыкального стиля «Dark Power Pop».
create trigger del_disk
on Disk instead of delete
as
begin
    insert into DisksArchive
    select s.Name,s.AuthorId,s.PublishDate,s.GenreId,s.PublisherId
    from Disk s
    where s.Id in (select d.Id from deleted d)

    update Song
    set DiskId=(select i.Id from inserted i join Disk d on d.Name=i.Name and d.AuthorId=i.AuthorId 
                and d.PublishDate=i.PublishDate and d.GenreId=i.GenreId and d.PublisherId=i.PublisherId)
    where DiskId=(select i.Id from inserted i join Disk d on d.Name=i.Name and d.AuthorId=i.AuthorId 
                and d.PublishDate=i.PublishDate and d.GenreId=i.GenreId and d.PublisherId=i.PublisherId)

    delete from Disk
    where id in (select d.Id from deleted d)
end;



------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_Music_collection_END_----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_Sales_-------------------------------------------------------------------------------------------------
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
    [PhoneNum] varchar(15) not null
);
go

--- 	2. О покупателях: ФИО, email, контактный телефон 
create table [Buyers]
(
    [Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null check ([Name] <> N''),
	[Surname] nvarchar(100) not null check ([Surname] <> N''),
	[MiddleName] nvarchar(100) not null check ([MiddleName] <> N''),
	[Email] nvarchar(100) not null check ([Email] <> N''),
    [PhoneNum] varchar(15) not null
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

insert into Buyers(Name,SurName,MiddleName,Email,PhoneNum)
values
('Petro','Petrov','Petovich','dm_nagibator@gmail.com','380932375555'),
('Snake','Solid','7','princess777@ukr.net','380934275512'),
('Snake','Old','Clone','satan999@ukr.ru','380934200555'),
('Petro','Petrov','Antonov','prinfcess777@ukr.net','3809345275512'),
('Bilbo','Beggins','Hobbitson','princzess777@ukr.net','3809434275512'),
('Frodo','Beggins','Bolboson','dm_nagsibator@gmail.com','3809323375555'),
('Saruman','Wise','The','princasdeess777@ukr.net','38093424275512'),
('Sauron','Corruption','Middle Earth''s','princeqss777@ukr.net','3809342765512')

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

--- Задание 3. К базе данных «Продажи» из практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие триггеры: 

---         1. При добавлении нового покупателя триггер проверяет наличие покупателей с такой же фамилией. 
---             При нахождении совпадения триггер записывает об этом информацию в специальную таблицу 
create table [SameSurNames]
(
    [Id] int not null identity(1, 1) primary key,
	[SurName] nvarchar(100) ,
	[Count] int 
);
go

create trigger add_buyers_same_surname
on Buyers instead of insert
as
begin
    if exists (select b.SurName from inserted i join Buyers b on i.SurName=b.SurName )
        begin
            if exists (select s.SurName from inserted i join SameSurNames s on i.SurName=s.SurName )
                begin
                    update SameSurNames
                    set Count+=(select count(i.SurName)
                        from inserted i join SameSurNames p on i.SurName=p.SurName 
                        group by i.SurName)
                    where SurName in (select distinct i.SurName
                        from inserted i join SameSurNames p on i.SurName=p.SurName)
                end
            else
                begin
                    insert into SameSurNames
                    select i.SurName ,count(i.SurName)+1
                    from inserted i
                    group by i.SurName
                end
        end
    else
        begin
            insert into Buyers
            select i.Name,i.SurName,i.MiddleName,i.Email,i.PhoneNum
            from inserted i
        end
end;

---         2. При удалении информации о покупателе триггер переносит его историю покупок в таблицу «История покупок» 
create table [SalesStory]
(
    [Id] int not null identity(1, 1) primary key,
	[ProductTitle] nvarchar(100) ,
	[Price] money ,
	[DealDate] date 
);
go

create trigger del_buyers
on Buyers instead of delete
as
begin
    insert into SalesStory
    select s.ProductTitle,s.Price,s.DealDate
    from Sales s
    where s.BuyerId in (select d.Id from deleted d)
    delete from Sales
    where BuyerId in (select d.Id from deleted d)
    delete from Buyers
    where Id in (select d.Id from deleted d)
end;

---         3. При добавлении продавца триггер проверяет есть ли он в таблице покупателей, если запись существует добавление нового продавца отменяется 
create trigger add_buyer_cant_be_seller
on Salers instead of insert
as
begin
    if not exists (select i.Email,i.PhoneNum from inserted i join Buyers b on i.Email=b.Email and i.PhoneNum=b.PhoneNum group by i.Email,i.PhoneNum)
        begin
            insert into Salers
            select  i.FullName,i.Email,i.PhoneNum
            from inserted i
        end
end;

---         4. При добавлении покупателя триггер проверяет есть ли он в таблице продавцов, если запись существует добавление нового покупателя отменяется 
create trigger add_seller_cant_be_buyer
on Buyers instead of insert
as
begin
    if not exists (select i.Email,i.PhoneNum from inserted i join Salers b on i.Email=b.Email and i.PhoneNum=b.PhoneNum group by i.Email,i.PhoneNum)
        begin
            insert into Buyers
            select  i.Name,i.SurName,i.MiddleName,i.Email,i.PhoneNum
            from inserted i
        end
end;

---         5. Триггер не позволяет вставлять информацию о продаже таких товаров: яблоки, груши, сливы, кинза.
create trigger add_product_black_list
on Sales instead of insert
as
begin
    insert into Sales
    select i.BuyerId,i.SalerId,i.ProductTitle,i.Price,i.DealDate
    from inserted i
    where i.ProductTitle not in('яблоки','груши','сливы','кинза')
end;


------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_Sales_END_---------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------_SPORT_SHOP_--------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Задание 1. Создайте базу данных «Спортивный магазин».
--- Эта база данных должна содержать информацию о товарах, продажах, сотрудниках, клиентах. Необходимо хранить следующую информацию: 
---         1. О товарах: название товара, вид товара (одежда, обувь, и т.д.), количество товара в наличии, себестоимость, производитель, цена продажи 
---         2. О продажах: название проданного товара, цена продажи, количество, дата продажи,
---              информация о продавце (ФИО сотрудника, выполнившего продажу), информация о покупателе (ФИО покупателя, если купил зарегистрированный покупатель) 
---         3. О сотрудниках: ФИО сотрудника, должность, дата приёма на работу, пол, зарплата 
---         4. О клиентах: ФИО клиента, email, контактный телефон, пол, история заказов, процент скидки, подписан ли на почтовую рассылку.


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


--- Задание 2. Для базы данных из первого задания создайте триггеры, которые будут решать задачи ниже: 

---         1. При продаже товара, заносить информацию о продаже в таблицу «История». Таблица «История» используется для дубляжа информации о всех продажах 
create table [SalesHistory]
(
    [Id] int constraint pk_SalesHistoryID primary key,
	[ProductId] int ,
    [SaleValue] int ,
    [Quantity] int ,
    [SaleDate] date ,
    [SellerId] int ,
    [BuyerId] int
);
go

create trigger add_copy_to_history
on Sales after insert
as
begin
	set nocount on --- не будет засчитывать кол-во изменненых полей(копированых в другую таблицу)
	insert into SalesHistory (Id,ProductId,SaleValue,Quantity,SaleDate,SellerId,BuyerId)
    	select Sales.Id,Sales.ProductId,Sales.SaleValue,Sales.Quantity,Sales.SaleDate,Sales.SellerId,Sales.BuyerId
    	from Sales inner join inserted
    	on Sales.Id = inserted.Id
end;

---         2. Если после продажи товара не осталось ни одной единицы данного товара, необходимо перенести информацию о полностью проданном товаре в таблицу «Архив» 
create table [ProductsArchive]
(
    [Id] int  constraint pk_ProductsArchiveID primary key,
	[Name] nvarchar(100) ,
	[ProductTypes] nvarchar(100) ,
    [PrimeValue] int ,
	[Manufacturer] nvarchar(100) ,
    [SaleValue] int 
);
go

create trigger add_copy_to_product_archive  --- может быть эррор при удалении(перенос подразумевает удаление) ,если на запись ссылаются (продажи на него ссылаются)
on Products after update
as
begin
	set nocount on
	insert into ProductsArchive (Id,Name,ProductTypes,PrimeValue,Manufacturer,SaleValue)
    	select p.Id,p.Name,pt.Name,p.PrimeValue,mn.Name,p.SaleValue
    	from Products p join inserted
    	on p.Id = inserted.Id and inserted.Quantity=0
        join ProductTypes pt
        on p.TypeId=pt.Id
        join Manufacturers mn on p.ManufacturerId=mn.Id
		--- если удалить то ,что дальше будет лучше 
    delete from Products  
    where Id in (select p.Id from Products p join inserted
    	on p.Id = inserted.Id and inserted.Quantity=0)
end;

---         3. Не позволять регистрировать уже существующего клиента. При вставке проверять наличие клиента по ФИО и email 

--- странный какой-то , не добавляет новых ,но и ошибку не выводит
create trigger add_exist_client_by_email --- вообще не может быть одинаковых емейлов
on Buyers instead of update,insert
as
begin
    if exists (select * from Buyers b join inserted i on b.Email=i.Email)
        begin
	        set nocount on
            raiserror ('This email already exists!',0,1) 
        end
    else
        begin
            insert into Buyers
            select i.PersonId,i.Email,i.PhoneNumber,i.GenderId,i.Discount,i.MailSubscribe from inserted i
        end
end;

---         4. Запретить удаление существующих клиентов 
create trigger del_exist_user
on Buyers instead of delete
as
begin
        set nocount on
        raiserror ('This client cannot be deleted!',0,1) 
end;

---         5. Запретить удаление сотрудников, принятых на работу до 2015 года 
create trigger del_exist_seller
on Sellers instead of delete
as
begin
    delete from Sellers
    where Id in (select d.Id
    from deleted d join Sellers s on s.Id=d.Id and d.EmployDate>'01.01.2015')
end;

---         6. При новой покупке товара нужно проверять общую сумму покупок клиента. Если сумма превысила 50000 грн, необходимо установить процент скидки в 15% 
create trigger add_discount
on Sales after insert
as
begin
    update Buyers
    set Discount=0.15
    where Discount<0.15 and Id in (select b.Id
                from inserted i join Sales s on i.BuyerId=s.BuyerId 
                join Buyers b on s.BuyerId=b.Id
                join Persons p on b.PersonId=p.Id
                group by b.Id,p.Name,p.Surname,p.MiddleName,b.Email
                having sum(s.SaleValue)>50000)
end;

---         7. Запретить добавлять товар конкретной фирмы. Например, товар фирмы «Спорт, солнце и штанга» 
create trigger add_ban_list
on Products instead of insert
as
begin
    insert into Products
    select i.Name,i.TypeId,i.Quantity,i.PrimeValue,i.ManufacturerId,i.SaleValue
    from inserted i
    where ManufacturerId!=(select p.Id from Products p where Name='Спорт, солнце и штанга')
end;

---         8. При продаже проверять количество товара в наличии. Если осталась одна единица товара, необходимо внести информацию об этом товаре в таблицу «Последняя Единица».
create table [LastProductUnit]
(
    [Id] int  constraint pk_LastProductUnitID primary key,
	[Name] nvarchar(100) ,
	[ProductTypes] nvarchar(100) ,
	[Manufacturer] nvarchar(100) ,
);
go

create trigger upd_last_product_unit
on Products after update
as
begin
	set nocount on
	insert into LastProductUnit
    	select p.Name,pt.Name,mn.Name
    	from inserted i join Products p
    	on p.Id = i.Id and p.Quantity=1
        join ProductTypes pt
        on p.TypeId=pt.Id
        join Manufacturers mn on p.ManufacturerId=mn.Id
end;

--- Задание 1. К базе данных «Спортивный магазин» из практического задания к этому модулю создайте следующие триггеры: 

---         1. При добавлении нового товара триггер проверяет его наличие на складе,
---              если такой товар есть и новые данные о товаре совпадают с уже существующими данными, 
---              вместо добавления происходит обновление информации о количестве товара 
create trigger upd_repeat_prod
on Products instead of insert
as
begin
	set nocount on
    if exists (select p.Id
                        from inserted i join Products p on i.Name=p.Name 
                        and i.TypeId=p.TypeId 
                        and i.ManufacturerId=p.ManufacturerId)
        begin
            update Products
            set Quantity=(select i.Quantity
                        from inserted i join Products p on i.Name=p.Name 
                        and i.TypeId=p.TypeId 
                        and i.ManufacturerId=p.ManufacturerId)
            where Id in (select p.Id
                        from inserted i join Products p on i.Name=p.Name 
                        and i.TypeId=p.TypeId 
                        and i.ManufacturerId=p.ManufacturerId)
        end
    else
        begin
            insert into Products
            select i.Name ,i.TypeId ,i.Quantity ,i.PrimeValue ,i.ManufacturerId ,i.SaleValue
            from inserted i
            where Id not in(select p.Id
                        from inserted i join Products p on i.Name=p.Name 
                        and i.TypeId=p.TypeId 
                        and i.ManufacturerId=p.ManufacturerId)
        end
end;

---         2. При увольнении сотрудника триггер переносит информацию об уволенном сотруднике в таблицу «Архив сотрудников» 
create table [FiredSellers]
(
    [Id] int not null identity(1, 1) constraint pk_FiredSellersID primary key,
	[PersonId] int not null,
	[PositionId] int not null,
    [EmployDate] date not null,
	[GenderId] int default 1,
	[Salary] money not null check (Salary > 0)
);
go

alter table [FiredSellers]
add constraint fk_FiredSellers_PersonsID foreign key ([PersonId]) references [Persons]([Id]);
go

alter table [FiredSellers]
add constraint fk_FiredSellers_PositionsID foreign key ([PositionId]) references [Positions]([Id]);
go

alter table [FiredSellers]
add constraint fk_FiredSellers_GendersID foreign key ([GenderId]) references [Genders]([Id]);
go

create trigger del_fired_seller
on Sellers after delete
as
begin
    insert into FiredSellers
    select d.PersonId ,d.PositionId ,d.EmployDate ,d.GenderId ,d.Salary 
    from deleted d
end;

---         3. Триггер запрещает добавлять нового продавца, если количество существующих продавцов больше 6. 
create trigger add_less_then_six_sellers
on Sellers instead of insert
as
begin
    declare @sellers_count int;
    select @sellers_count=count(s.Id)  from Sellers s
    if(@sellers_count<6)
        begin
            insert into Sellers
            select i.PersonId ,i.PositionId ,i.EmployDate ,i.GenderId ,i.Salary 
            from inserted i
        end
end;
