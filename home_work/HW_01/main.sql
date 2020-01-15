create database Library
go
use Library
create table Books
(
Id int identity primary key not null,
Title nvarchar(60) not null,
Author nvarchar(30) not null,
Genres nvarchar(100),
Publisher nvarchar(30),
Publish_date date,
Cost money not null
)
go
insert into Books(Title,Author,Genres,Publisher,Publish_date,Cost)
values 
('In Search of Lost Time' , 'Marcel Proust','documental', 'Eurpe Editions','1998-05-27',10),
('A game of Thrones','George Reymond Richard Martin', 'Political novel,epic fantasy','Bantam Spectra','1996-08-1',27),
('A Clash of Kings','George Reymond Richard Martin','Fantasy','Bantam Spectra','1999',22),
('A Storm of Swords','George Reymond Richard Martin','Fantasy','Bantam Spectra','2000-08-8',17),
('The Lord of the Rings','John Ronald Reuel Tilkien','Fantasy , adventure','Allen & Unwin','1954-07-29',33),
('The Adventures of Tom Bombadil','John Ronald Reuel Tilkien','Poetry','Allen & Unwin','1962-11-22',11),
('The Hobbit','John Ronald Reuel Tilkien','High fantasy, juvenile fantasy','Allen & Unwin','1937-09-21',22),
('Tree and Leaf','John Ronald Reuel Tilkien',' ','Allen & Unwin','1964-05-28',8),
('The Name of the Wind','Patrick Rothfuss','Heroic fantasy','DAW books','2007-04-27',18),
('The Wise Man''s Fear','Patrick Rothfuss','Heroic fantasy','DAW books','2011-04-1',17),
('The Chronicles of Narnia','Clive Staples Lewis','Fantasy, child''s','Geoffrey Bles','1950-10-16',5);

---1.Вывести всю информацию обо всех книгах
select * from books;
---2.Вывести названия всех книг год издания которых больше 2000 года
select Title from books
where Publish_date>'2000';
---3.Вывести все книги одного издательства
select Title from books
where Publisher='DAW books';
---4.Вывести всех авторов ,которые написали больше трех книг
select Author from books
group by Author
having (count(Author)>3);
