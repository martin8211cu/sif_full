drop table tablas
go
create table tablas (_data varchar(200))
go


select max(datalength(_data)) from tablas
go

alter table tablas add inactivo bit default 0 not null 
go
alter table tablas add name varchar(30) null 
go
alter table tablas add otro varchar(200) null 
go
alter table tablas add id int null 
go
alter table tablas add nivel int default 0 not null
go

update tablas set inactivo = 1, _data = substring(_data,2,500)
where _data like '#%'
go


update tablas set name = rtrim(
case when charindex(':',_data) = 0
	then _data
	else substring (_data, 1,charindex(':',_data)-1)end)
go

update tablas set otro = rtrim(
case when charindex(':',_data) = 0
	then null
	else substring (_data, charindex(':',_data)+1, 200)end)
go

update tablas set id = null
go
update tablas
set id = o.id
from aspweb..sysobjects o
where o.name = tablas.name
and tablas.id is null
go

