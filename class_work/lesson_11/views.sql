create view PriceAmmount as
	select g.Name AS 'Наименование жанра',
	sum(b.Price * b.Number) as 'Общая стоимость книг'
	from Genres g inner join Books b on g.Id=b.GenreId
	group by g.Name
	;
go

create view AllLib as
	select b.Name as 'Книга',b.Publish as 'Дата печати',b.Price as 'Цена',
	b.Number as 'Количество', g.Name AS 'Жанр', a.Name as 'Автор'
	from Genres g inner join Books b on g.Id=b.GenreId
	inner join Athors a on a.Id=b.AuthorId
	;
go

create view PriceAmmountWithRollUp as
	select g.Name AS 'Наименование жанра',
	sum(b.Price * b.Number) as 'Общая стоимость книг'
	from Genres g inner join Books b on g.Id=b.GenreId
	group by g.Name
	with rollup
	;
go


create view BooksCountWithRollUp as
	select g.Name AS 'Жанр',
	sum (b.Price*b.Number) as 'Общая стоимость',
	count(b.Number) as 'Общее кол-во'
	from Genres g inner join Books b on g.Id=b.GenreId
	group by rollup(g.Name)
	;
go

create view BooksCountWithCube as
	select g.Name AS 'Жанр',
	sum (b.Price*b.Number) as 'Общая стоимость',
	count(b.Number) as 'Общее кол-во'
	from Genres g inner join Books b on g.Id=b.GenreId
	group by cube(g.Name)
	;
go


alter view BooksCountWithCube as
	select g.Name AS 'Жанр',
	b.Name as 'Книга',
	sum (b.Price*b.Number) as 'Общая стоимость',
	count(b.Number) as 'Общее кол-во'
	from Genres g inner join Books b on g.Id=b.GenreId
	group by cube(g.Name,b.Name)
	;
go

create view BooksCountWithGroupingSets as
	select g.Name AS 'Жанр',
	b.Name as 'Книга',
	sum (b.Price*b.Number) as 'Общая стоимость',
	count(b.Number) as 'Общее кол-во'
	from Genres g inner join Books b on g.Id=b.GenreId
	group by grouping sets(g.Name,b.Name)
	;
go

create view PivotExmpl as
	select N'Общая стоимость по жанрам' as 'Сводка',
	[Учебная литература],[Техническая литература],[Научаная фантастика]
	from ( select g.Name AS 'Жанр',
		b.Price*b.Number as 'Cтоимость книг'
		from Genres g inner join Books b on g.Id=b.GenreId
	) as SourceTable
	pivot(
		sum([Cтоимость книг]) for [Жанр] in 
		([Учебная литература],[Техническая литература],[Научаная фантастика])	
	) as PivotTable
	;
go
