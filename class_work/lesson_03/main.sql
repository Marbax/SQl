
create database [Academy];
go

use [Academy];
go

create table [Curators]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[Surname] nvarchar(max) not null check ([Surname] <> N'')
);
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
	[Financing] money not null check ([Financing] >= 0.0) default 0.0,
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


create table [GroupsCurators]
(
	[Id] int not null identity(1, 1) primary key,
	[CuratorId] int not null,
	[GroupId] int not null
);
go


create table [GroupsLectures]
(
	[Id] int not null identity(1, 1) primary key,
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

alter table [GroupsCurators]
add foreign key ([CuratorId]) references [Curators]([Id]);
go

alter table [GroupsCurators]
add foreign key ([GroupId]) references [Groups]([Id]);
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

insert into Teachers(Name,Salary,Surname)
values 
('Golum',7500,'Warts'),
('Smeagol',9500,'Evil'),
('Aragorn',72500,'Boromirovich')
;
go

insert into Subjects(Name)
values
('Math'),
('Chemystry'),
('C#')
;
go

insert into Faculties(Financing,Name)
values
(2000.2,'C++'),
(4050.32,'C#'),
(2040.62,'Algebra'),
(2000.2,'Geometry')
;
go

insert into Curators(Name,Surname)
values 
('Petro','Petrov'),
('Ivan','Ivanov'),
('Lilim','Ubov'),
('Trune','Pupkovich'),
('Gar','Gasky')
;
go

insert into Lectures(LectureRoom,SubjectId,TeacherId)
values
('e122',1,2),
('b22',2,2),
('z202',3,3),
('q12',1,2),
('e192',2,3)
;
go

insert into Departments(Financing,Name,FacultyId)
values 
(11000.24,'Computer Scince',1),
(10230.24,'Math',2)
;
go

insert into Groups(Name,Year,DepartmentId)
values
('P107',3,1),
('B127',2,2),
('E117',4,1),
('Z101',5,2)
;
go

insert into GroupsCurators(CuratorId,GroupId)
values
(1,2),
(3,1),
(1,3),
(2,4)
;
go

insert into GroupsLectures(GroupId,LectureId)
values
(1,2),
(3,2),
(2,1),
(4,3)
;
go

--- More valuees

insert into Curators(Name, Surname)
values('Андрей','Хаустович'),
('Дмитрий','Трофимцов'),
('Тарас','Мельник'),
('Надежда','Полюхович');
go

insert into Faculties(Financing, Name)
values(23000, 'Прикладная Математика'),
(20000, 'Социиологии и права'),
(15000, 'Радиотехнический');
go

insert into Subjects(Name)
values('Програмирование'),
('Математический анализ'),
('Дискретная математика'),
('Право'),
('Физика');
go

insert into Teachers(Name, Salary, Surname)
values('Владислав', 8000,'Глеб'),
('Дмитрий', 10000,'Гломозда'),
('Виталий', 9000,'Бусленко'),
('Ольга', 7500,'Синивец');
go

insert into Departments(Financing, Name, FacultyId)
values(30000, 'Комп. науки', 1),
(27000, 'СПСКС', 2),
(20000, 'Физики', 3);
go

insert into Groups(Name, Year, DepartmentId)
values ('RV83', 2, 1),
('KP71',3, 1),
('IS63',4, 2),
('KM52',5, 3);
go

insert into GroupsCurators(CuratorId, GroupId)
values(1,1),
(2,2),
(3,4),
(4,3);
go

insert into Lectures(LectureRoom, SubjectId, TeacherId)
values('340-19', 1, 1),
('720-22', 3,2),
('92-15', 2,4),
('12-16', 5,3);
go

insert into GroupsLectures(LectureId, GroupId)
values(1,1),
(2,3),
(3,2),
(4,4);
go


--- 1. Вывести все возможные пары строк преподавателей и групп.
select Teachers.Name as 'Teacher' , Groups.Name as 'Group'
from Teachers,Groups;

--- 2. Вывести названия факультетов, фонд финансирования кафедр которых превышает фонд финансирования факультета.
select Distinct Faculties.Name as 'Faculty', Faculties.Financing as 'Fac Fin', Departments.Financing as 'Dep fin'
from Faculties,Departments
where Faculties.Id=Departments.FacultyId and  Departments.Financing>Faculties.Financing;
go --- исход один
select Distinct Faculties.Name as 'Faculty', Faculties.Financing as 'Fac Fin', Departments.Financing as 'Dep fin'
from Faculties join Departments on Faculties.id=Departments.FacultyId
where Departments.Financing>Faculties.Financing;

--- 3. Вывести фамилии кураторов групп и названия групп, которые они курируют.
select Curators.Name as 'Cur name', Groups.Name "Group Name"
from Curators join GroupsCurators on Curators.Id=GroupsCurators.CuratorId
join Groups on Groups.Id=GroupsCurators.GroupId
order by Curators.Name;

--- 4. Вывести имена и фамилии преподавателей, которые читают лекции у группы “P107”.


--- 5. Вывести фамилии преподавателей и названия факультетов на которых они читают лекции.


--- 6. Вывести названия кафедр и названия групп, которые кним относятся.


--- 7. Вывести названия дисциплин, которые читает препода ватель “Samantha Adams”.


--- 8. Вывести названия кафедр, на которых читается дисциплина “Database Theory”.


-- 9. Вывести названия групп, которые относятся к факультету “Computer Science”.


--- 10. Вывести названия групп 5-го курса, а также название факультетов, к которым они относятся.


--- 11. Вывести полные имена преподавателей и лекции, которые они читают (названия дисциплин и групп), причем отобрать
--- только те лекции, которые читаются в аудитории “B103”.



