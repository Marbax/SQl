use Music_collection;
go

/*
--- Роли и их члены , текущей бд

SELECT DP1.name AS DatabaseRoleName,   
   isnull (DP2.name, 'No members') AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS DP1  
   ON DRM.role_principal_id = DP1.principal_id  
 LEFT OUTER JOIN sys.database_principals AS DP2  
   ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;  
*/

/*
--- Члены роли текущей бд

SELECT members.[name] 
FROM sys.database_role_members AS rolemembers
    JOIN sys.database_principals AS roles 
        ON roles.[principal_id] = rolemembers.[role_principal_id]
    JOIN sys.database_principals AS members 
        ON members.[principal_id] = rolemembers.[member_principal_id]
WHERE roles.[name]=@rolename
*/


--- 1. Полный доступ к базе данных "Музыкальная коллекция" имеет только хозяин коллекции

--- revoke all from public;
deny create table to public;



--- 2. Есть фиксированая группа пользователей , которая может получать информацию из базы данных , без права изменения .

go
--- create role DBReader authorization db_datareader;
create role 'DBReader';
go
exec sp_addrolemember 'db_datareader' , 'DBReader';



--- 3. Отдельно есть группа пользователей ,которая имеет право получать информацию только из таблици стилей .
go
create role 'DBGenresSellect';
go
grant select on Music_collection.Genre to 'DBGenresSellect';


