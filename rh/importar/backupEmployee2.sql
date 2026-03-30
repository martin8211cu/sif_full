create table ##empleados (
	empced     varchar(30) null,
	nopatr       varchar(30) null,
	notarj        varchar(30) null,
	empnomb  varchar(14) null,
	empapel    varchar(20) null,
	empadr1    varchar(35) null,
	empadr2    varchar(35) null,
	empcity      varchar(24) null,
	empstate    varchar(2) null,
	empzip       varchar(10) null,
	empmarital varchar(1) null,
	empchauf   varchar(1) null,
	emphouse  varchar(1) null,
	emplicen    varchar(10) null,
	empsssid   varchar(30) null,
	empretir     money null,
	empsinot    varchar(4) null,
	empagrno   varchar(1) null
)

insert ##empleados
select distinct 
	substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8), 
	substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9),
	e.DEtarjeta,
	e.DEnombre,
	e.DEapellido1 || ' ' || e.DEapellido2,
	case when charindex(char(10), e.DEdireccion) = 0 then e.DEdireccion else substring(e.DEdireccion, 1, charindex(char(10), e.DEdireccion)- 2) end,
	case when charindex(char(10), e.DEdireccion) = 0 then null else substring(e.DEdireccion, charindex(char(10), e.DEdireccion) + 1, 35) end,
	' ',
	'PR',
	' ',
	case when e.DEcivil = 1 then 'M' else 'S' end,
	'N',
	'N',
	' ',
	(select min(fe.FEidentificacion) from FEmpleado fe where fe.DEid = e.DEid and fe.Pid = 3),
	0.00,
	' ',
	'N'
from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
where cp.Ecodigo = @Ecodigo
  and cp.CPperiodo = @CPperiodo
  and cp.CPmes = @CPmes
  and se.RCNid = cp.CPid
  and e.DEid = se.DEid

update ##empleados
set 
	empcity = substring(empadr2, charindex(char(10), empadr2) + 1, 35),
	empadr2 = substring(empadr2, 1, charindex(char(10), empadr2) - 2)
where charindex(char(10), empadr2) > 1

update ##empleados
set empcity = substring(empcity, 1, charindex(char(10), empcity) - 2)
where charindex(char(10), empcity) > 0

select 
	empced,
	nopatr,
	notarj,
	empnomb,
	empapel,
	empadr1,
	empadr2,
	empcity,
	empstate,
	empzip,
	empmarital,
	empchauf,
	emphouse,
	emplicen,
	empsssid,
	empretir,
	empsinot,
	empagrno
from ##empleados

drop table ##empleados
