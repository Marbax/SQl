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

