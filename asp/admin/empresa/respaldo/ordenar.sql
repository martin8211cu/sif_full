update tablas set nivel = 0 where nivel != 0
go
update tablas
set nivel = 1
where name in('Empresas', 'Monedas', 'CFuncional')
go

while (1=1) BEGIN
	update tablas
	set nivel = (select max(nivel) + 1 from tablas)
	where id not in (
			select tableid
			from sysreferences
			where tableid != reftabid
			  and reftabid not in (select id from tablas where nivel != 0)
			  and reftabid in (select id from tablas where nivel = 0))
	  and id not in (select id from tablas where nivel != 0)
	and nivel = 0
	and id is not null

	if @@rowcount = 0 break
	select @@rowcount
END
go

select nivel,id,name from tablas
where nivel = 0
and inactivo =0
and id is not null


/* Los que faltaron */

select name as 'Faltaron'
from tablas where nivel = 0 and id is not null
order by name


/* Para buscar qué falta, a quiénes referencia. */

select object_name (reftabid)
from sysreferences
where tableid = object_id ('WfActualParameter')
  and tableid != reftabid
  and reftabid not in (select id from tablas where nivel != 0)
  and reftabid in (select id from tablas where nivel = 0)

select object_name (reftabid)
from sysreferences
where tableid = object_id ('WfInvocation')
  and tableid != reftabid
  and reftabid not in (select id from tablas where nivel != 0)
  and reftabid in (select id from tablas where nivel = 0)

select
	name  || ' ' || otro
from tablas
--where id =1960247603
--where name ='AnexoGrupo'
where id is not null
order by nivel, name
