--- Не хватает identity изначально
--- Действия при добавление изменении - стоит каскад изначально , не ок


use [master];
go

if db_id('University_DB') is not null
begin
	drop database [University_DB];
end
go

create database [University_DB];
go

use [University_DB];
go

CREATE TABLE [Faculties] (
	Id int NOT NULL identity,
	Name nvarchar(100) NOT NULL UNIQUE,
  CONSTRAINT [PK_FACULTIES] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Departments] (
	Id int NOT NULL identity,
	Name nvarchar(100) NOT NULL UNIQUE,
	Faculty_Id int NOT NULL,
  CONSTRAINT [PK_DEPARTMENTS] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Groups] (
	Id int NOT NULL identity,
	Name nvarchar(100) NOT NULL UNIQUE,
	Faculty_Id int NOT NULL,
  CONSTRAINT [PK_GROUPS] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Teachers] (
	Id int NOT NULL identity,
	Name nvarchar(50) NOT NULL,
	Department_Id int NOT NULL,
  CONSTRAINT [PK_TEACHERS] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Students] (
	Id int NOT NULL identity,
	Name nvarchar(50) NOT NULL,
	Group_Id int NOT NULL,
  CONSTRAINT [PK_STUDENTS] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Subjects] (
	Id int NOT NULL identity,
	Name nvarchar(100) NOT NULL UNIQUE,
  CONSTRAINT [PK_SUBJECTS] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Subjects__Teachers] (
	Subject_Id int NOT NULL,
	Teacher_Id int NOT NULL UNIQUE,
  CONSTRAINT [PK_SUBJECTS__TEACHERS] PRIMARY KEY CLUSTERED
  (
  [Subject_Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Exams] (
	Id int NOT NULL identity,
	Subject_id int NOT NULL,
	Teacher_id int NOT NULL,
	Group_Id int NOT NULL,
	ExamDate datetime NOT NULL,
  CONSTRAINT [PK_EXAMS] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE [Grades] (
	Id int NOT NULL identity,
	Exam_Id int NOT NULL,
	Student_Id int NOT NULL,
	Mark int NOT NULL,
  CONSTRAINT [PK_GRADES] PRIMARY KEY CLUSTERED
  (
  [Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

ALTER TABLE [Departments] WITH CHECK ADD CONSTRAINT [Departments_fk0] FOREIGN KEY ([Faculty_Id]) REFERENCES [Faculties]([Id])
ON UPDATE no action
GO
ALTER TABLE [Departments] CHECK CONSTRAINT [Departments_fk0]
GO

ALTER TABLE [Groups] WITH CHECK ADD CONSTRAINT [Groups_fk0] FOREIGN KEY ([Faculty_Id]) REFERENCES [Faculties]([Id])
ON UPDATE no action
GO
ALTER TABLE [Groups] CHECK CONSTRAINT [Groups_fk0]
GO

ALTER TABLE [Teachers] WITH CHECK ADD CONSTRAINT [Teachers_fk0] FOREIGN KEY ([Department_Id]) REFERENCES [Departments]([Id])
ON UPDATE no action
GO
ALTER TABLE [Teachers] CHECK CONSTRAINT [Teachers_fk0]
GO

ALTER TABLE [Students] WITH CHECK ADD CONSTRAINT [Students_fk0] FOREIGN KEY ([Group_Id]) REFERENCES [Groups]([Id])
ON UPDATE no action
GO
ALTER TABLE [Students] CHECK CONSTRAINT [Students_fk0]
GO


ALTER TABLE [Subjects__Teachers] WITH CHECK ADD CONSTRAINT [Subjects__Teachers_fk0] FOREIGN KEY ([Subject_Id]) REFERENCES [Subjects]([Id])
ON UPDATE no action
GO
ALTER TABLE [Subjects__Teachers] CHECK CONSTRAINT [Subjects__Teachers_fk0]
GO
ALTER TABLE [Subjects__Teachers] WITH CHECK ADD CONSTRAINT [Subjects__Teachers_fk1] FOREIGN KEY ([Teacher_Id]) REFERENCES [Teachers]([Id])
ON UPDATE no action
GO
ALTER TABLE [Subjects__Teachers] CHECK CONSTRAINT [Subjects__Teachers_fk1]
GO

ALTER TABLE [Exams] WITH CHECK ADD CONSTRAINT [Exams_fk0] FOREIGN KEY ([Subject_id]) REFERENCES [Subjects]([Id])
ON UPDATE no action
GO
ALTER TABLE [Exams] CHECK CONSTRAINT [Exams_fk0]
GO
ALTER TABLE [Exams] WITH CHECK ADD CONSTRAINT [Exams_fk1] FOREIGN KEY ([Teacher_id]) REFERENCES [Teachers]([Id])
ON UPDATE no action
GO
ALTER TABLE [Exams] CHECK CONSTRAINT [Exams_fk1]
GO
ALTER TABLE [Exams] WITH CHECK ADD CONSTRAINT [Exams_fk2] FOREIGN KEY ([Group_Id]) REFERENCES [Groups]([Id])
ON UPDATE no action
GO
ALTER TABLE [Exams] CHECK CONSTRAINT [Exams_fk2]
GO

ALTER TABLE [Grades] WITH CHECK ADD CONSTRAINT [Grades_fk0] FOREIGN KEY ([Exam_Id]) REFERENCES [Exams]([Id])
ON UPDATE no action
GO
ALTER TABLE [Grades] CHECK CONSTRAINT [Grades_fk0]
GO
ALTER TABLE [Grades] WITH CHECK ADD CONSTRAINT [Grades_fk1] FOREIGN KEY ([Student_Id]) REFERENCES [Students]([Id])
ON UPDATE no action
GO
ALTER TABLE [Grades] CHECK CONSTRAINT [Grades_fk1]
GO

