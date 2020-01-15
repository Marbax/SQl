create database [Academy];
go

use [Academy];
go

create table [Departments]
(
	[Id] int not null identity(1, 1) primary key,
	[Financing] money not null check ([Financing] >= 0.0),
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Faculties]
(
	[Id] int not null identity(1, 1) primary key,
	[Dean] nvarchar(max) not null check ([Dean] <> N''),
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
);
go

create table [Groups]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(10) not null unique check ([Name] <> N''),
	[Rating] float not null check ([Rating] between 0 and 5),
	[Year] int not null check ([Year] between 1 and 5)
);
go

create table [Teachers]
(
	[Id] int not null identity(1, 1) primary key,
	[EmploymentDate] date not null check ([EmploymentDate] >= '1990-01-01'),
	[IsAssistant] bit not null default 0,
	[IsProfessor] bit not null default 0,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[Position] nvarchar(max) not null check ([Position] <> N''),
	[Premium] money not null check ([Premium] >= 0.0) default 0.0,
	[Salary] money not null check ([Salary] > 0.0),
	[Surname] nvarchar(max) not null check ([Surname] <> N'')
);
go

insert into Departments(Financing,Name)
values 
(11000.24,'Computer Scince'),
(122020.111,'Programming'),
(3200.214,'Engineering'),
(10230.24,'Geometry')
;
go

insert into Teachers(EmploymentDate,IsAssistant,IsProfessor,Name,Position,Premium,Salary,Surname)
values 
('2010-07-01',0,1,'Golum','Teacher',200,7500,'Warts'),
('2011-02-01',0,1,'Petro','Teacher',0,6500,'Petrov'),
('1995-11-21',1,0,'Nindja','Teacher',2000,12000,'Ukulele'),
('2012-11-11',1,1,'Lilu','Teacher',11000,3000,'Fifth'),
('2016-03-11',0,1,'Garen','Teacher',0,15000,'Demacian'),
('2017-03-11',1,0,'Poporo','Teacher',10,200,'Great'),
('1996-03-11',1,1,'Beelzebob','Teacher',180,22000,'Hellscream'),
('1999-03-11',1,0,'Azazel','Teacher',333,22000,'Hellscream'),
('2017-07-11',1,0,'Tarzan','Teacher',0,300,'Wild')
;
go

insert into Faculties(Dean,Name)
values
('Grisha','Computer Science'),
('Oleg','Geometry'),
('Valera','Programming'),
('Anton','Engineering'),
('Petrsia','Software Development')
;
go

--- 1. Вывести таблицу кафедр, но расположить ее поля в обратном порядке.
select Name,Financing,Id from Departments;

--- 2. Вывести названия групп и их рейтинги, используя в качестве названий выводимых полей “Group Name” и “Group
--- Rating” соответственно.
select Id,Name as "Group Name",Rating as "Group Rating",Year from Groups;

--- 3. Вывести для преподавателей их фамилию, процент ставки
--- по отношению к надбавке и процент ставки по отношению
--- к зарплате (сумма ставки и надбавки).
select Surname , 
Salary*100/(Premium) as "Salary percent to Premium" ,
Salary*100/(Salary+Premium) as "Salary percent to Salary+Premium"
from Teachers
where Premium>0;

--- 4. Вывести таблицу факультетов в виде одного поля 
--- в следующем формате: “The dean of faculty [faculty] is [dean].”.
select 'The dean of faculty '+Name +' is '+Dean+'.' as "Faculties" from Faculties;

--- 5. Вывести фамилии преподавателей, которые являются 
--- профессорами и ставка которых превышает 1050.
select Surname from Teachers
where Salary>1050 and IsProfessor=1;

--- 6. Вывести названия кафедр, фонд финансирования которых
-- меньше 11000 или больше 25000.
select Name from Departments
where Financing<11000 or Financing>25000;

--- 7. Вывести названия факультетов кроме факультета “Computer Science”.
select Name from Faculties
where Name!='Computer Science';

--- 8. Вывести фамилии и должности преподавателей, которые не являются профессорами.
select Surname,Position from Teachers
where IsProfessor=0;

--- 9. Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 550.
select Surname,Position,Salary,Premium from Teachers
where IsAssistant=1 and Premium between 160 and 550;

--- 10. Вывести фамилии и ставки ассистентов.
select Surname,Salary from Teachers
where IsAssistant=1;

--- 11. Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2000.
select Surname,Position from Teachers
where EmploymentDate<'2000-01-01';

--- 12. Вывести названия кафедр, которые в алфавитном порядке
--- располагаются до кафедры “Software Development”.
--- Выводимое поле должно иметь название “Name of De­part­ment”.
select Name as 'Name of De­part­ment' from Faculties
order by Name
;

--- 13. Вывести фамилии ассистентов, имеющих зарплату (сумма
--- ставки и надбавки) не более 1200.
select Surname from Teachers
where IsAssistant=1 and (Salary+Premium)<1200;

--- 14. Вывести названия групп 5-го курса, имеющих рейтинг
--- в диапазоне от 2 до 4.
select Name from Groups
where Year=5 and Rating between 2 and 4;

--- 15. Вывести фамилии ассистентов со ставкой меньше 550 или надбавкой меньше 200.
select Surname from Teachers
where IsAssistant=1 and (Salary<550 or Premium<200);
