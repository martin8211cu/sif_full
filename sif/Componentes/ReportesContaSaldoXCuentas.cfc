<cfcomponent>

	<cffunction name="uno">
	
	</cffunction>

set nocount on
go
 
create table #ctassel (cgm1id int)
create table #cuentas (cgm1id int, cgm1idniv int)
create table #cuentas2 (mayor char(4), cgm1idniv int, nombre varchar(50), cgm1fi varchar(100), nivel int, detalle int, saldoini money, debitos money, creditos money)
create table #sucursales (cge5cod char(5))
create table #asientos (cg5con int)
create table #periodos (periodo int, mes int)
 
go
 
/*  Se insertan las sucursales, asientos y periodos segun parametros de pantalla */
insert #sucursales (cge5cod) select "001"
insert #sucursales (cge5cod) select "002"
 
insert #asientos (cg5con) select 0
insert #asientos (cg5con) select 1500
insert #asientos (cg5con) select 1000
 
insert #periodos (periodo, mes) select 2002, 8
insert #periodos (periodo, mes) select 2002, 9
insert #periodos (periodo, mes) select 2002, 10
 
/*  Se insertan las cuentas que cumplan con los criterios y que sean de ultimo nivel
 Ciclo por cada cuenta incorporada en la pantalla como parametros  */
 
select "Etapa 1. Seleccion de las Cuentas a analizar"
go
--set statistics time on
--set statistics io on
go
 
insert #ctassel (cgm1id)
select c.CGM1ID
from CGM001 c
where c.CGM1IM = '0009'
  and c.CGM1CD like '%'
  and c.CTAMOV = 'S'
  and not exists (select 1 from #ctassel cs where cs.cgm1id = c.CGM1ID)
 
go
 
select "Etapa 2.  Procesamiento de los saldos de las cuentas"
go
/* 
 PROCESO
 Con las cuentas seleccionadas se incorporan todas las cuentas a considerar
*/
declare @niveldetalle int, @periodoini int, @mesini int, @t datetime
select @niveldetalle = 2, @periodoini = 2000, @mesini = 6, @t = getdate()
 
insert #cuentas (cgm1id, cgm1idniv)
select cu.CGM1ID, cu.ctanivel
from #ctassel a, CGM001cubo cu
where cu.CGM1ID = a.cgm1id
  and cu.nivelcubo <= @niveldetalle
 
insert #cuentas2 (
 mayor, cgm1idniv, nombre, cgm1fi, 
 nivel, detalle, saldoini, debitos, creditos)
select distinct 
 c.CGM1IM, cu.ctanivel, c.CTADES, c.CGM1FI, 
 cu.nivelcubo, case when cu.nivelcubo = @niveldetalle then 1 else 0 end,
 0.00 saldoini, 0.00 debitos, 0.00 creditos
from #ctassel a, CGM001cubo cu, CGM001 c
where cu.CGM1ID = a.cgm1id
  and cu.nivelcubo <= @niveldetalle
  and c.CGM1ID = cu.ctanivel
 
/* Insertar las cuentas de mayor -- no se encuentran en el cubo */
insert #cuentas2 (
 mayor, cgm1idniv, nombre, cgm1fi, 
 nivel, detalle, saldoini, debitos, creditos)
select distinct
 cm.CGM1IM, cm.CGM1ID, cm.CTADES, cm.CGM1FI, 
 0, 0,
 0.00 saldoini, 0.00 debitos, 0.00 creditos
from #ctassel a, CGM001 c, CGM001 cm
where c.CGM1ID = a.cgm1id
  and cm.CGM1IM = c.CGM1IM
  and cm.CGM1CD is null
 
update #cuentas2
set saldoini = isnull((
 select sum(CTSSAN) 
 from CGM007 s, #asientos a
 where s.CGM1ID = #cuentas2.cgm1idniv
   and s.CTSPER = @periodoini
   and s.CTSMES = @mesini
   and s.CG5CON = a.cg5con), 0.00)
 

update #cuentas2
set debitos = isnull((
 select sum(CTSDEB) 
 from CGM007 s, #asientos a, #periodos p
 where s.CGM1ID = #cuentas2.cgm1idniv
   and s.CTSPER = p.periodo
   and s.CTSMES = p.mes
   and s.CG5CON = a.cg5con), 0.00)
 
update #cuentas2
set creditos = isnull((
 select sum(CTSCRE) 
 from CGM007 s, #asientos a, #periodos p
 where s.CGM1ID = #cuentas2.cgm1idniv
   and s.CTSPER = p.periodo
   and s.CTSMES = p.mes
   and s.CG5CON = a.cg5con), 0.00)
 
select 
 c.cgm1idniv as idCta,
 c.mayor as Mayor, 
 c.cgm1fi as Cuenta, 
 c.nivel as Nivel, 
 c.nombre as Descripcion,
 c.saldoini as SaldoInicial,
 c.debitos as Debitos,
 c.creditos as Creditos,
 detalle as Detalle
from #cuentas2 c
order by c.mayor, c.cgm1fi
go
 
select "Etapa 3.  Procesamiento de los detalles de la primera cuenta seleccionada"
go
/* El detalle para cada resultado (cuando detalle > 0 and debitos <> 0 and creditos <> 0) es el siguiente */
 
declare @idCta int  /* parametro */
declare @cformato varchar(100)
select @cformato = " "
 
while (1=1) begin
 
 select @cformato = min(cgm1fi)
 from #cuentas2 
 where detalle = 1
   and cgm1fi > @cformato
 
 if @cformato is null
  break
 
 select @idCta = cgm1idniv
 from #cuentas2
 where detalle = 1
   and cgm1fi = @cformato
 
 if @idCta is null break
 
 /******************* qry del detalle ***********************/
 select 
  t.CGTPER Año,
  t.CGTMES Mes, 
  t.CG5CON Asiento,
  t.CGTBAT Consecutivo,
  sum(case when t.CGTTIP = 'D' then t.CGTMON else 0.00 end) Debitos,
  sum(case when t.CGTTIP = 'C' then t.CGTMON else 0.00 end) Creditos
 from #cuentas c, #periodos p, #asientos a, #sucursales o, CGT002 t
 where c.cgm1idniv = @idCta
   and t.CGM1ID = c.cgm1id
   and t.CGTPER = p.periodo
   and t.CGTMES = p.mes
   and t.CGE5COD = o.cge5cod
   and t.CG5CON = a.cg5con
 group by t.CGTPER, t.CGTMES, t.CG5CON, t.CGTBAT
end
go
set statistics time off
set statistics io off
go
 
drop table #ctassel, #cuentas, #cuentas2, #sucursales, #asientos, #periodos
go
 
set nocount off
go

</cfcomponent>
