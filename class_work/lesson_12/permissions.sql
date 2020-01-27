use salesDB;
go

create login Mark with password = 'Mark';
go
create user UserMark for login Mark;
go
exec sp_addrolemember 'db_owner' , 'UserMark';
go


create login Irina with password = 'Irina';
go
create user UserIrina for login Irina;
go
grant select on salesDB.* to UserIrina;


go
deny insert on salesDB.* to UserIrina;
--- exec sp_addrolemember 'db_denydatawrite', 'UserIrina';

go
create login Marat with password = 'Marat';
go
create user UserMarat for login Marat;
go
exec sp_addrolemember 'db_backupoperator', 'UserMarat';


go
create login Oleg with password = 'Oleg';
go
create user UserOleg for login Oleg;
go
grant create table to UserOleg;
go
grant create view to UserOleg;
---exec sp_addrolemember 'db_ddladmin', 'UserOleg';



go
--- create role DBGod authorization db_owner;
create role 'DBGod';
go
exec sp_addrolemember 'db_owner' , 'DBGod';


go
--- create role DBGod authorization db_datareader;
create role 'DBReader';
go
exec sp_addrolemember 'db_datareader' , 'DBReader';

go
create role 'DBSellersReader';
go
grant select on salesDB.Sellers to 'DBSellersReader';

go
create role 'DBSalesDenyAll';
go
exec sp_addrolemember 'db_denydatareader' , 'DBSalesDenyAll';
go
exec sp_addrolemember 'db_denydatawriter' , 'DBSalesDenyAll';

go
create role 'DBDataCreator';
--- create role DBDataCreator authorization db_ddladmin;
go
grant create table to 'DBSellersReader';
go
grant create view to 'DBSellersReader';
go
grant create procedure to 'DBSellersReader';
---exec sp_addrolemember 'db_ddladmin', 'DBDataCreator';


