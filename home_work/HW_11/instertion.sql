
go
insert into Publisher(Name,Country)
values
('Britain Records','Britain'),
('USA Records','USA'),
('Russian Records','Russia'),
('Indian Records','India'),
('China Records','China')
;

go
insert into Genre(Name)
values
('Indie Rock'),
('Doom Metal'),
('Core Metal'),
('D&B')
;

go
insert into Author(Name)
values
('Deathclock'),
('Rolling Stones'),
('Muse'),
('Pirate Station')
;

go
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

go
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
