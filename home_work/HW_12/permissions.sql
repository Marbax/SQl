use SportShopDB;
go

--- 1. Запретите пользователю с логином Марк получать информацию о продавцах.

create login Mark with password = 'Mark';
go
create user UserMark for login Mark;
go
grant select on SportShopDB.* to UserMark;
go
deny select on SportShopDB.Sellers to UserMark;
go


--- 2. Разрешите пользователю с логином Давид получать информацию только о продавцах

create login David with password = 'David';
go
create user UserDavid for login David;
go
grant select on SportShopDB.Sellers to UserDavid;
go
grant select on SportShopDB.Persons to UserKonstantin;
go
grant select on SportShopDB.Positions to UserKonstantin;
go
grant select on SportShopDB.Genders to UserKonstantin;
go


--- 3. Предоставьте полный доступ к базе данных пользователю с логином Ольга

create login Olga with password = 'Olga';
go
create user UserOlga for login Olga;
go
exec sp_addrolemember 'db_owner' , 'UserOlga';
go


--- 4. Предоставьте доступ только на чтение таблиц с информацией о продавцах , товарах в наличии пользователю с логином Константин.

create login Konstantin with password = 'Konstantin';
go
create user UserKonstantin for login Konstantin;
go
grant select on SportShopDB.Sellers to UserKonstantin;
go
grant select on SportShopDB.Persons to UserKonstantin;
go
grant select on SportShopDB.Positions to UserKonstantin;
go
grant select on SportShopDB.Genders to UserKonstantin;
go
grant select on SportShopDB.Products to UserKonstantin;
go
grant select on SportShopDB.ProductTypes to UserKonstantin;
go
grant select on SportShopDB.Manufacturers to UserKonstantin;
go



