
insert into Genres (Name)
values 
(N'Учебная литература'),
(N'Техническая литература'),
(N'Научаная фантастика')
go

insert into Athors(Name)
values 
(N'Иванов'),
(N'Петров'),
(N'Сидоров')
go

insert into Books(Name,Publish,Price,Number,GenreId,AuthorId)
values 
(N'Властелин Assembly',2015,25.5,55,1,2),
(N'Руководоство по чайнику',2011,25.5,10,1,2),
(N'T-SQL ,почему не нужно',2013,35.5,100,1,2),
(N'Справочник по кондиционеру',2011,15.5,1100,2,1),
(N'Справочник по справочникам',2019,33.5,100,2,1),
(N'Справчоник этого',2018,22.5,1020,2,1),
(N'Покемоны',2017,51.5,100,3,3),
(N'Драконы',1999,12.5,100,3,3),
(N'Дигимоны',1965,9.5,111,3,3)
go

