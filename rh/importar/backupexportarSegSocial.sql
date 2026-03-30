set nocount on
/*
Este archivo tiene que incluir la información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Para el caso de Nación, esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
4. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas
5. El formato del archivo debe ser el siguiente:
    a) 01 - 01 Todos los registros 4
    b) 02 - 07 Número patronal
    c) 08 - 09 Sector del patrono
    d) 10 - 10 Digito verificador 
    e) 11 - 11 Tipo de cédula (0 nacionales, 7 extranjeros)
    f) 12 - 21 Número de cédula o asegurado
    g) 22 - 51 Apellidos y nombre del empleado (En MAYÚSCULA)
    h) 52 - 61 Espacio en blanco
    i) 62 - 70 Salario (con dos decimales y sin punto)
    j) 71 - 71 Clase de seguro (En MAYUSCULA)
    k) 72 - 72 Observaciones (En MAYUSCULA)
    l) 73 - 80 Espacios en Blanco

k) Esto se llena solamente para aquellos empleados 
que en el mes que se esta sacando hayan 'ingresado', 'salido' 
o hayan estado incapacitados.   
Para el caso que hayan ingresado se pone una 'E', 
para el caso que hayan salido se pone una 'S' 
y para el caso que hayn tenido una incapacidad en el mes actual se pone una 'I'
           
l) Para el caso reciba de monto 0 en su salario (incapacidad diferente a maternidad), debe sustituirse el campo 72 la I por el mes en que se inició la incapacidad, de acuerdo a la siguiente simbología
        1 Enero
        2 Febrero
        3 Marzo
        4 Abril
        5 Mayo
        6 Junio
        7 Julio
        8 Agosto
        9 Setiembre
        0 Octubre
        N Noviembre
        X Diciembre
*/

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


--- Parametros que deben incorporarse en la tabla RHParametros y deben leerse al iniciar la consulta
declare @numeropatronal char(9) 

select @numeropatronal = ' '

select @numeropatronal = Pvalor
from RHParametros
where Ecodigo = @Ecodigo
  and Pcodigo = 300

create table #reporte (
	DEid numeric, 
	denombre char(30), 
	texto char(61), 
	observaciones char(1), 
	salario money,
	ordenar char(1)
)

/* Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado */ 
insert #reporte (DEid, denombre, texto, observaciones, salario,ordenar)
select 
	e.DEid as DEid, 
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) as denombre,
	'4' || 
	@numeropatronal || 
	case when e.NTIcodigo = 'C' then '0' else '7' end ||
	replicate ('0', 10 - datalength(convert(varchar(10), e.DEidentificacion))) ||
	convert(varchar(10), e.DEidentificacion) ||
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) ||
	'          ' as texto,
	' ' as observaciones,
	sum(h.SEsalariobruto) as salario, ' '
from CalendarioPagos c (index CalendarioPagos_01), HSalarioEmpleado h, DatosEmpleado e
where c.Ecodigo = @Ecodigo
  and c.CPperiodo = @CPperiodo
  and c.CPmes = @CPmes
  and h.RCNid = c.CPid
  and e.DEid = h.DEid
group by e.NTIcodigo, e.DEidentificacion, e.DEapellido1, e.DEapellido2, e.DEnombre

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

--  Determinacion de registros de Salida / Entrada / Incapacidad en el mes

-- Salida
update #reporte
set observaciones = 'S'
where exists(
	select 1 
	from DLaboralesEmpleado dl, RHTipoAccion ta 
	where dl.DEid = #reporte.DEid 
	  and dl.DLfvigencia between @f1 and @f2
	  and ta.RHTid = dl.RHTid
	  and ta.RHTcomportam = 2)

-- Entrada. Cuando tiene el empleado una accion de nombramiento entre las fechas
update #reporte
set observaciones = 'E'
where observaciones = ' '
  and exists(
	select 1 
	from DLaboralesEmpleado dl, RHTipoAccion ta 
	where dl.DEid = #reporte.DEid 
	  and dl.DLfvigencia between @f1 and @f2
	  and ta.RHTid = dl.RHTid
	  and ta.RHTcomportam = 1)


-- Entradas retroactivas, antes del inicio de las fechas del mes seleccionado, procesadas entre las fechas de la nomina.
update #reporte
set observaciones = 'E'
where observaciones = ' '
  and exists(
	select 1 
	from DLaboralesEmpleado dl, RHTipoAccion ta 
	where dl.DEid = #reporte.DEid 
	  and dl.DLfechaaplic between @f1 and @f2
	  and dl.DLfvigencia < @f1 
	  and ta.RHTid = dl.RHTid
	  and ta.RHTcomportam = 1)

update #reporte
set observaciones = 'I'
where observaciones = ' '
  and exists(
	select 1 
	from CalendarioPagos c, HIncidenciasCalculo ic, RHSaldoPagosExceso sp, RHTipoAccion ta 
	where c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ic.DEid = #reporte.DEid
	  and ic.RHSPEid is not null
	  and sp.RHSPEid = ic.RHSPEid
	  and ta.RHTid = sp.RHTid
	  and ta.RHTcomportam = 5)

update #reporte
set observaciones = 'I'
where observaciones = ' '
  and exists(
	select 1 
	from HPagosEmpleado pe, CalendarioPagos c, RHTipoAccion ta 
	where pe.DEid = #reporte.DEid
	  and c.CPid = RCNid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ta.RHTid = pe.RHTid
	  and ta.RHTcomportam = 5)

update #reporte
set observaciones = 'I'
where observaciones = ' '
  and exists(
	select 1 
	from PagosEmpleado pe, CalendarioPagos c, RHTipoAccion ta 
	where pe.DEid = #reporte.DEid
	  and c.CPid = RCNid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ta.RHTid = pe.RHTid
	  and ta.RHTcomportam = 5)

/* 
	Insertar todas las salidas de funcionarios aplicables  
	entre las fechas del reporte y que no esten incluidas en el reporte generado
	(no tuvieron salario) en el mes seleccionado.
	Se incluyen las salidas retroactivas a esta nomina aplicadas entre las fechas del mes seleccionado
	en el segundo query
*/

insert #reporte (DEid, denombre, texto, observaciones, salario, ordenar)
select 
	e.DEid as DEid, 
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) as denombre,
	'4' || @numeropatronal || 
	case when e.NTIcodigo = 'C' then '0' else '7' end ||
	replicate ('0', 10 - datalength(convert(varchar(10), ltrim(rtrim(e.DEidentificacion))))) ||
	convert(varchar(10), e.DEidentificacion) ||
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) ||
	'          ' as texto,
	'S' as observaciones,
	0.00 as salario, '0'
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfvigencia between @f1 and @f2
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

insert #reporte (DEid, denombre, texto, observaciones, salario, ordenar)
select 
	e.DEid as DEid, 
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) as denombre,
	'4' || @numeropatronal || 
	case when e.NTIcodigo = 'C' then '0' else '7' end ||
	replicate ('0', 10 - datalength(convert(varchar(10), ltrim(rtrim(e.DEidentificacion))))) ||
	convert(varchar(10), e.DEidentificacion) ||
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) ||
	'          ' as texto,
	'S' as observaciones,
	0.00 as salario, '0'
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfechaaplic between @f1 and @f2
  and dl.DLfvigencia < @f1 
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

/* 
	Poner el mes de inicio de la incapacidad actual cuando la persona 
	esta incapacitada y el salario es cero, segun especificacion.
	Pendiente de completar este punto!
*/

update #reporte
set observaciones = '%', ordenar = '1'
where observaciones = 'I'
  and salario = 0.00

if @tiporep != 'D' begin
	select 
		texto 
		||
		replicate('0', 9 - datalength(convert(varchar, convert(numeric(9,0), salario * 100)))) 
		||
		convert(varchar, convert(numeric(9,0), salario * 100)) 
		|| 
		'C'
		||
		observaciones 
		|| 
		'        ' as salida
	from #reporte
	order by ordenar, denombre
end
else begin
	select 
		left(texto, 21),
		denombre as Nombre,
		convert(char(15), salario, 1) as Salario,
		'C'
		||
		observaciones 
		|| 
		'        ' as salida
	from #reporte
	order by ordenar, denombre
end

drop table #reporte