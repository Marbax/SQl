use [master];
go

if db_id('Academy') is not null
begin
	drop database [Academy];
end
go

create database [Academy];
go

use [Academy];
go

create table [Departments]
(
	[Id] int not null identity(1, 1) primary key,
	[Financing] money not null check ([Financing] >= 0.0) default 0.0,
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
	[FacultyId] int not null
);
go

create table [Faculties]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Groups]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
	[Year] int not null check ([Year] between 1 and 5),
	[DepartmentId] int not null
);
go

create table [GroupsLectures]
(
	[Id] int not null identity(1, 1) primary key,
	[DayOfWeek] int not null check ([DayOfWeek] between 1 and 7),
	[GroupId] int not null,
	[LectureId] int not null
);
go

create table [Lectures]
(
	[Id] int not null identity(1, 1) primary key,
	[LectureRoom] nvarchar(max) not null check ([LectureRoom] <> N''),
	[SubjectId] int not null,
	[TeacherId] int not null
);
go

create table [Subjects]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Teachers]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[Salary] money not null check ([Salary] > 0.0),
	[Surname] nvarchar(max) not null check ([Surname] <> N'')
);
go

alter table [Departments]
add foreign key ([FacultyId]) references [Faculties]([Id]);
go

alter table [Groups]
add foreign key ([DepartmentId]) references [Departments]([Id]);
go

alter table [GroupsLectures]
add foreign key ([GroupId]) references [Groups]([Id]);
go

alter table [GroupsLectures]
add foreign key ([LectureId]) references [Lectures]([Id]);
go

alter table [Lectures]
add foreign key ([SubjectId]) references [Subjects]([Id]);
go

alter table [Lectures]
add foreign key ([TeacherId]) references [Teachers]([Id]);
go

---
insert into Faculties(Name)
values
('C#'),
('Computer Science')
;
go

insert into Departments(Financing, Name, FacultyId)
values
(30000, 'Software Development', 1),
(50000, 'Engeneering', 2)
;
go

insert into Groups(Name,Year,DepartmentId)
values
('zp10',1,1),
('zw10',3,2),
('zq10',2,2),
('pp11',1,1)
;
go
---

---
insert into Subjects(Name)
values
('C# lang'),
('C++ lang'),
('Java lang')
;
go

insert into Teachers(Name,Salary,Surname)
values 
('Golum',7500,'Warts'),
('Smeagol',9500,'Evil'),
('Aragorn',72500,'Boromirovich'),
('Pyro',7500,'Lool'),
('Waryn',9500,'Good'),
('Boromyr',72500,'Greggy'),
('Jack',6600,'Greggy'),
('Jack',6600,'Underhill'),
('Dave',12500,'McQueen')
;
go

insert into Lectures(LectureRoom,SubjectId,TeacherId)
values
('101',1,2),
('102',2,8),
('104',3,8),
('103',1,2),
('106',3,5),
('109',1,4),
('108',2,3),
('D201',1,3),
('D201',2,2),
('111',1,9)
;

insert into GroupsLectures(DayOfWeek,GroupId,LectureId)
values
(1,1,2),
(1,2,1),
(1,1,3),
(2,2,5),
(2,2,1),
(2,1,5),
(2,1,4),
(2,2,1),
(2,3,7),
(2,2,2),
(2,3,6),
(6,1,10)
;
go

---


--- 1. Вывести количество преподавателей кафедры “Software Development”.
select Departments.Name "Departments", count(distinct Teachers.Id) as "Teachers count"
from Teachers join Lectures on Teachers.Id=Lectures.TeacherId
join GroupsLectures on GroupsLectures.LectureId=Lectures.Id
join Groups on Groups.Id=GroupsLectures.GroupId
join Departments on Departments.Id=Groups.DepartmentId and Departments.Name='Software Development'
group by Departments.Name
;

--- 2. Вывести количество лекций, которые читает преподаватель “Dave McQueen”.
select Teachers.Name+' '+Teachers.Surname "Teacher", count(Lectures.Id) as "Lectures count"
from Teachers join Lectures on Teachers.Id=Lectures.TeacherId
and Teachers.Name='Dave' and Teachers.Surname='McQueen'
group by Teachers.Name+' '+Teachers.Surname
;

--- 3. Вывести количество занятий, проводимых в аудитории “D201”.
select Lectures.LectureRoom as 'LectureRoom' , count(Subjects.Id) as 'Subjects count'
from Lectures join Subjects on Subjects.Id=Lectures.SubjectId
and Lectures.LectureRoom='D201'
group by Lectures.LectureRoom
;

--- 4. Вывести названия аудиторий и количество лекций, проводимых в них.
select Lectures.LectureRoom as 'LectureRoom' , count(Subjects.Id) as 'Subjects count'
from Lectures full outer join Subjects on Subjects.Id=Lectures.SubjectId
group by Lectures.LectureRoom
;

--- 5. Вывести количество студентов, посещающих лекции преподавателя “Jack Underhill”.
--- Каких студентов ,только группы есть =_=
select Teachers.Name+' '+Teachers.Surname "Teacher", count(Groups.Id) as "Groups count"
from Teachers join Lectures on Teachers.Id=Lectures.TeacherId
join GroupsLectures on GroupsLectures.LectureId=Lectures.Id
join Groups on Groups.Id=GroupsLectures.GroupId
and Teachers.Name='Jack' and Teachers.Surname='Underhill'
group by Teachers.Name+' '+Teachers.Surname
;

--- 6. Вывести среднюю ставку преподавателей факультета “Computer Science”.
select Faculties.Name 'Facultie', avg(Teachers.Salary) as "Teachers avg salary"
from Teachers join Lectures on Teachers.Id=Lectures.TeacherId
join GroupsLectures on GroupsLectures.LectureId=Lectures.Id
join Groups on Groups.Id=GroupsLectures.GroupId
join Departments on Departments.Id=Groups.DepartmentId
join Faculties on Faculties.Id=Departments.FacultyId
and Faculties.Name='Computer Science'
group by Faculties.Name
;

--- 7. Вывести минимальное и максимальное количество студентов среди всех групп.
--- Каких студентов ,только группы есть =_=
select avg(Groups.Id) as 'Students'
from Groups
;

--- 8. Вывести средний фонд финансирования кафедр.
select avg(Departments.Financing) as 'avg Departments Financing'
from Departments
;

--- 9. Вывести полные имена преподавателей и количество читаемых ими дисциплин.
select Teachers.Name+' '+Teachers.Surname 'Teacher', count(Subjects.Id) as 'Subjects count'
from Teachers full join Lectures on Teachers.Id=Lectures.TeacherId
join Subjects on Subjects.Id=Lectures.SubjectId
group by Teachers.Name+' '+Teachers.Surname
order by 'Subjects count' desc
;

--- 10. Вывести количество лекций в каждый день недели.
select GroupsLectures.DayOfWeek 'Day', count(Lectures.Id) as 'Lectures count'
from Lectures join GroupsLectures on Lectures.Id=GroupsLectures.LectureId
group by GroupsLectures.DayOfWeek
order by 'Lectures count' desc
;

--- 11. Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются.
select Lectures.LectureRoom 'LectureRoom', count(Departments.Id) as 'Departments count'
from Lectures join GroupsLectures on Lectures.Id=GroupsLectures.LectureId
join Groups on Groups.Id=GroupsLectures.GroupId
join Departments on Departments.Id=Groups.DepartmentId
group by Lectures.LectureRoom
order by 'Departments count' desc
;

--- 12. Вывести названия факультетов и количество дисциплин, которые на них читаются.
select Faculties.Name as 'Faculties name', count(Subjects.Id) as 'Subjects count'
from Subjects join Lectures on Subjects.Id=Lectures.SubjectId
join GroupsLectures on Lectures.Id=GroupsLectures.LectureId
join Groups on Groups.Id=GroupsLectures.GroupId
join Departments on Departments.Id=Groups.DepartmentId
join Faculties on Faculties.Id=Departments.FacultyId
group by Faculties.Name
order by 'Subjects count' desc
;

--- 13. Вывести количество лекций для каждой пары преподаватель-аудитория.
--- 13. Вывести количество лекций для каждой пары преподаватель-аудитория.
select Teachers.Name+' '+Teachers.Surname+' '+Lectures.LectureRoom as 'Pair', count(Lectures.Id) as 'Lectures count'
from Teachers join Lectures on Teachers.Id=Lectures.TeacherId
group by Teachers.Name+' '+Teachers.Surname+' '+Lectures.LectureRoom
order by 'Lectures count' desc
;



