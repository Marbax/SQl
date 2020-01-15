

create table Genres(
	Id int not null Primary key identity,
	Name nvarchar(50) not null unique
)
go

create table Athors(
	Id int not null Primary key identity,
	Name nvarchar(50) not null unique
)
go

create table Books(
	Id int not null Primary key identity,
	Name nvarchar(50) not null ,
	Publish int not null,
	Price money not null,
	Number int not null,
	GenreId int not null foreign key references Genres(id),
)
go

alter table Books
add AuthorId int not null foreign key references Athors(Id)
go

