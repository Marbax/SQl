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

