----script  del ins


set nocount on
/*
Este archivo tiene que incluir la información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Para el caso de Nación, esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
4. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas
5. El formato del archivo debe ser el siguiente:
	Póliza			Alfanumérico	7	Número de póliza Diferente de blancos.Diferente de cero.
	Tipo				Alfanumérico	1	Tipo de planilla	M = mensual ó A = adicional
	Libre				Alfanumérico	1	Blanco
	Año				Numérico		4	Año de la planilla	
	Libre				Alfanumérico	1	Blanco
	Mes				Numérico		2	Mes de la Planilla	
	*Cédula 			Alfanumérico	15	Cédula del trabajador Diferente de blancos.No existan registros duplicados. 
	*No. Asegurado	Alfanumérico	25	Número Asegurado C.C.S.S Según especificaciones que rigen para la C.C.S.S
	Nombre			Alfanumérico	15	Nombre del trabajador	
	Apellido1			Alfanumérico	15	1er Apellido 	
	Apellido2			Alfanumérico	15	2do Apellido	
	Salario			Numérico		10.2	Salario Mensual Diferente de cero si el campo días es mayor que cero.Salarios redondeados los céntimos.(léase 13 caracteres tomando en cuenta el punto decimal)
	Libre				Alfanumérico	1	Blanco	
	Días				Numérico		2	Días Laborados De 0 a 30 días
	Libre				Alfanumérico	1	Blanco	
	Horas			Numérico		3	Horas laboradas Ceros
	*Ocupación		Alfanumérico	5	Ocupación Código según lista de puestos del INS
*/


--- Parametros que deben incorporarse en la tabla RHParametros y deben leerse al iniciar la consulta

declare @f1 datetime, @f2 datetime

select @f1 = min(CPdesde)
   from  CalendarioPagos 
where CPmes = @CPmes
    and CPperiodo = @CPperiodo
    and Ecodigo =@Ecodigo

select  @f2= max(CPhasta)
   from  CalendarioPagos 
where CPmes = @CPmes
    and CPperiodo = @CPperiodo
    and Ecodigo =@Ecodigo


create table #reporte (
	DEid numeric null, 
	poliza varchar(7) null,
	tipoP char(1) null,
    tipoC char(2) null,
    cedula varchar(15) null,
    numseguro varchar(15) null,
    nombre char(15) null, 
    apellido1 char(15) null, 
    apellido2 char(15) null, 
	salario money null,
	dias  int null,
	horas  char(3) null,
    ocupacion char(10) null,
	puesto char(10) null
)


/* Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado */ 

insert #reporte (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP, dias, horas, ocupacion, salario, puesto)
select 
	e.NTIcodigo, 
	h.DEid ,
	e.DEidentificacion,
	e.DEnombre,
	e.DEapellido1,
	e.DEapellido2,
	e.DEidentificacion,
    '0000000',
 	'M',       
    0,
    '001','',
	sum(h.SEsalariobruto),
	null
from CalendarioPagos c (index CalendarioPagos_01), HSalarioEmpleado h, DatosEmpleado e
where c.Ecodigo = @Ecodigo
  and c.CPperiodo = @CPperiodo
  and c.CPmes = @CPmes
  and c.CPid = h.RCNid 
  and h.DEid = e.DEid 
  and e.Ecodigo = @Ecodigo
group by  e.NTIcodigo, h.DEid, e.DEidentificacion, e.DEnombre, e.DEapellido1,e.DEapellido2

insert #reporte (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
select 
	e.NTIcodigo, 
	dl.DEid ,
	e.DEidentificacion,
	e.DEnombre,
	e.DEapellido1,
	e.DEapellido2,
	e.DEidentificacion,
    '0000000',
 	'M',       
    0,
    '001','',
	0,
	null
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfechaaplic between @f1 and @f2
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and e.Ecodigo = @Ecodigo 
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

insert #reporte (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
select 
	e.NTIcodigo, 
	dl.DEid ,
	e.DEidentificacion,
	e.DEnombre,
	e.DEapellido1,
	e.DEapellido2,
	e.DEidentificacion,
    '0000000',
 	'M',       
    0,
    '001','',
	0,
	null
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfechaaplic between @f1 and @f2
  and dl.DLfvigencia < @f1 
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

update #reporte 
	set puesto = (
		select RHPcodigo 
		from LineaTiempo b 
		where b.DEid = #reporte.DEid 
		  and b.LThasta = (
			select max(lt.LThasta)
			from LineaTiempo lt
			where lt.DEid = #reporte.DEid
			  and @f2 between lt.LTdesde and lt.LThasta)
		)


update #reporte 
	set puesto = (
		select RHPcodigo 
		from LineaTiempo b 
		where b.DEid = #reporte.DEid 
		  and b.LThasta = (
			select max(lt.LThasta)
			from LineaTiempo lt
			where lt.DEid = #reporte.DEid)
		)
where puesto is null

update #reporte
set ocupacion = RHPEcodigo
from RHPuestos r, RHPuestosExternos o
where r.Ecodigo = @Ecodigo
  and r.RHPcodigo = #reporte.puesto
  and o.RHPEid = r.RHPEid

update #reporte
set dias =  (select  isnull(sum(a.PEcantdias),0) 
                          from  HPagosEmpleado a, CalendarioPagos c
	where a.DEid = #reporte.DEid
            and a.PEtiporeg = 0
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo =@CPperiodo
	  and c.CPmes = @CPmes
	  and c.CPid = a.RCNid           )


update #reporte
set dias = (case when dias  > 24 then 24 else dias end )


update #reporte
set salario = salario 
	+ isnull(
		(select sum(se.SEsalariobruto)
		     from SalarioEmpleado se, CalendarioPagos c
		  where se.DEid = #reporte.DEid
		      and c.CPid = se.RCNid
		      and c.CPperiodo = @CPperiodo
		      and c.CPmes = @CPmes
		)
		, 0)


/* Actualizar el monto de salario tomando en cuenta las incidencias aplicadas */
update #reporte
set salario = salario + isnull(
	(select sum(ic.ICmontores)
	from 
		HIncidenciasCalculo ic, 
		CalendarioPagos c,
		CIncidentes ci
	where ic.DEid = #reporte.DEid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ci.CIid = ic.CIid
	  and ci.CInocargas = 0), 0.00)

update #reporte
set salario = salario + isnull(
	(select sum(ic.ICmontores)
	from 
		IncidenciasCalculo ic, 
		CalendarioPagos c,
		CIncidentes ci
	where ic.DEid = #reporte.DEid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ci.CIid = ic.CIid
	  and ci.CInocargas = 0	), 0.00)

select 
    convert(char(7), poliza)  || 'M'  || ' '  ||
    convert(char(4),@CPperiodo) || ' '  ||
    replicate('0', 2-datalength(ltrim(rtrim(convert(char,@CPmes))))) + ltrim(rtrim(convert(char,@CPmes))) ||
    case tipoC when 'C'  then  '0'+convert(char(14),cedula) else  '1'+convert(char(14),cedula) end  ||
	convert(char(25),numseguro) ||
    convert(char(15),nombre) ||
    convert(char(15),apellido1) ||
    convert(char(15),apellido2) ||
	replicate('0', 13-datalength(ltrim(rtrim(convert(char,salario))))) + ltrim(rtrim(convert(char(13),salario)))  || ' '  ||
	convert(char(2), dias) || ' '  ||
    horas|| ocupacion as salida
from #reporte
order by nombre

drop table #reporte

set nocount off
