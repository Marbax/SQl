
---ProductTypes\Manufacturers -> Products
insert into ProductTypes(Name)
values
('Snickers'),
('T-shirt'),
('Gloves'),
('Pants'),
('Sox')
;
go

insert into Manufacturers(Name)
values
('Abibas'),
('Nukas'),
('Kuma'),
('Xiaomi'),
('Pineapple')
;
go

insert into Products (Name,TypeId,Quantity,PrimeValue,ManufacturerId,SaleValue)
values
('Chavkodav-3000',1,12,1000,1,2500),
('Radioactive Chavkodav',1,22,1200,2,3500),
('Gansta gun',1,55,3000,1,5500),
('IChavkodav',1,1,10000,5,11500),
('MyShirt-2k10',2,32,200,1,2500),
('My Nuka shirt',2,55,199,2,2499),
('Jaguar skin',2,6,1111,3,3999),
('Lion skin',2,5,1000,3,2199),
('Fat puma',2,1,4000,3,4001),
('Useful Shirt',2,111,99,4,100),
('Like a spotsman',3,4,100,1,1000),
('Like a spotsman-2k17',3,25,1000,1,4000),
('Like a spotsman-2k18',3,12,2000,1,8000),
('Like a spotsman-2k19',3,12,3000,1,16000),
('Like a spotsman-2k20',3,12,4000,1,32000),
('Like a spotsman-from the future',3,12,9999,1,199999),
('Pripyat panty',3,14,100,2,2000),
('Nuka pants',3,666,100,2,3000),
('Branded cutty cat',3,11,220000,3,99999),
('Useful and simple',3,222,100,4,199),
('Simple sox',5,111,9,4,15)
;
go

-------------------------------------------

---Genders\Persons -> Buyers
insert into Genders(Name)
values
('Unknown'),
('Male'),
('Female')
;
go

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

insert into Buyers(PersonId,Email,PhoneNumber,GenderId,Discount,MailSubscribe)
values
(1,'petro007@rubler.com.ch.ru.mc','440932421',2,0.0,0),
(1,'petroTheUniqOne@mail.ru','4409322421',2,0.0,1),
(2,'snake1980@kodzima.net','4409326661',1,0.10,0),
(4,'petro007@rubmbler.net','44093232421',3,0.0,1)
;
go

-------------------------------------------

---Genders\Persons\Positions -> Sellers
insert into Positions(Name)
values
('Junior Seller'),
('Main Seller'),
('Default Seller'),
('Off Seller')
;
go

insert into Sellers(PersonId,PositionId,EmployDate,GenderId,Salary)
values
(5,1,'02-22-2019',2,5000),
(8,2,'12-26-2013',2,15000),
(7,3,'02-22-2014',2,12000),
(6,1,'02-23-2018',2,4000)
;
go

-------------------------------------------

---Products\Sellers\Buyers -> Sales
insert into Sales(ProductId,SaleValue,Quantity,SaleDate,SellerId,BuyerId)
values
(1,2200,2,'2-22-2019',1,1),
(2,3200,22,'2-24-2019',1,2),
(3,4200,15,'2-21-2019',1,3),
(4,5200,13,'3-26-2019',1,1),
(5,3200,11,'2-20-2019',2,4),
(6,2200,10,'3-19-2019',3,2),
(6,1200,9,'1-28-2019',4,3),
(1,6200,8,'2-21-2019',3,2)
;
go


