----------------------------------------------------------------------------------------------------------------------------------------------
insert into Persons(Name,Surname,MiddleName)
values
('Petro','Petrov','Petovich'),
('Snake','Solid','7'),
('Snake','Old','Clone'),
('Petro','Petrov','Antonov'),
('Bilbo','Beggins','Hobbitson'),
('Frodo','Beggins','Bolboson'),
('Saruman','Wise','The'),
('Sauron','Corruption','Middle Earth''s')
;
go

insert into Positions(Name)
values
('Junior-barber'),
('Senior-barber'),
('Chieff-barber')
;
go

insert into Genders(Name)
values
('Unknown'),
('Male'),
('Female')
;
go

insert into Services(Name,Value,Durability)
values
('Traditional beard haircut',150,30),
('Armpit haircut',300,10),
('Bikini haircut',600,60),
('Dutch helm',5000,5)
;
go

insert into Barbers(Persons_Id,Genders_Id,PhoneNum,Email,BirthDate,EmployDate,Positions_Id)
values
(1,2,'380936749822','barbusha_007@lgbt.net','06-22-1999','02-12-2017',3),
(2,2,'380936749811','insta_bear@lgbt.net','06-22-2001','02-25-2018',1),
(3,3,'380936749801','taras@ukr.net','06-11-1989','05-21-2011',2),
(4,3,'380936749821','zaza@kyr.net','02-22-1990','09-11-2012',2),
(5,2,'380936749829','ulala@lgbt.net','03-01-1996','02-01-2013',1),
(6,2,'380936749828','simon@lgbt.net','06-02-1998','07-09-2014',1)
;
go

insert into Services_Barbers(Services_Id,Barbers_Id)
values
(1,1),
(1,3),
(1,2),
(2,2),
(2,5),
(2,6),
(3,5),
(3,6),
(3,2),
(4,5),
(4,2)
;
go



insert into Customers(Persons_Id,PhoneNum,Email)
values
(8,'380932749822','barbasdasusha_007@ss.net'),
(7,'380933749811','asdasd@rr.net'),
(3,'380934749801','taraaas@ukr.net'),
(4,'380935749821','zaggza@kyr.net'),
(5,'380937749829','ulagggla@zr.net'),
(6,'380938749828','siasmon@rt.net')
;
go


insert into Visits_Arch(Barbers_Id,Customers_Id,SessionDate,[Visit's_Value])
values
(1,2,'01-22-2018',122),
(2,3,'02-22-2018',322),
(3,4,'02-25-2018',422),
(4,5,'03-12-2018',522),
(4,5,'12-8-2019',522),
(3,5,'12-8-2019',522),
(2,5,'12-8-2019',522),
(4,5,'12-8-2019',522),
(3,5,'12-8-2019',812),
(2,5,'12-8-2019',400),
(1,5,'12-8-2019',522),
(5,5,'12-8-2019',522),
(5,6,'03-22-2018',622)
;
go

insert into SessionsSlots(Time)
values
('10:00'),
('11:00'),
('12:00'),
('13:00'),
('14:00'),
('15:00'),
('16:00')
;
go

insert into Barbers_Schedules(Barbers_Id,Customers_Id,SessionDate,SessionsSlots_Id)
values
(2,2,'12-24-2019',1),
(2,2,'12-24-2019',2),
(2,2,'12-25-2019',2),
(2,2,'11-25-2019',3),
(2,2,'12-25-2019',4),
(2,2,'12-25-2019',5),
(2,2,'12-26-2019',1),
(2,2,'12-26-2019',2)
;
go

