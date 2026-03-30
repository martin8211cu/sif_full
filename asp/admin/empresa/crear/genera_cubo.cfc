<cfcomponent output="no">
<!--- generacubo con insert al final.sql --->
<cffunction name="copiar" output="false" returntype="void">
	<cfargument name="dsori" type="string" hint="datasource origen">
	<cfargument name="dsdst" type="string" hint="datasource destino">
	<cfargument name="Eori" type="numeric" hint="Ereferencia(Ecodigo int) origen">
	<cfargument name="Edst" type="numeric" hint="Ereferencia(Ecodigo int) destino">
	<cfargument name="CEdst" type="numeric" hint="CEcodigo destino">

<cfquery datasource="#dsdst#">
create table ##PCDCatalogoCuenta (Ccuenta numeric, Ccuentaniv numeric, Cpadre numeric null, nivel int, nivel2 int null)
</cfquery>
<cfquery datasource="#dsdst#">
declare @nivel int
select @nivel = 0


insert ##PCDCatalogoCuenta 
	(Ccuenta, Ccuentaniv, Cpadre, nivel)
select 
	Ccuenta, Ccuenta, Cpadre, @nivel
from CContables
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
  and Cmovimiento = 'S'

while (1=1) begin

	insert ##PCDCatalogoCuenta (
		Ccuenta, 
		Ccuentaniv, 
		Cpadre, 
		nivel)
	select 
		a.Ccuenta, 
		a.Cpadre,
		((select b.Cpadre from CContables b where b.Ccuenta = a.Cpadre)),
		@nivel + 1 
	from ##PCDCatalogoCuenta a
	where nivel = @nivel
	  and Cpadre is not null

	if @@rowcount = 0 break

	select @nivel = @nivel + 1

end


/* Recalcular el nivel */

/*
update ##PCDCatalogoCuenta
set nivel2 = ((select count(1) from ##PCDCatalogoCuenta b where b.Ccuenta = a.Ccuenta)) - 1
from ##PCDCatalogoCuenta a
where a.Ccuenta = a.Ccuentaniv

*/


update ##PCDCatalogoCuenta
set nivel2 = 0
from ##PCDCatalogoCuenta a
where a.Cpadre is null

declare @nivel2 int
select @nivel2 = 0


while (1=1) begin

	update ##PCDCatalogoCuenta
	set nivel2 = @nivel2 + 1
	from ##PCDCatalogoCuenta a
	where a.nivel2 is null
		and exists(
			select 1
			from ##PCDCatalogoCuenta b
			where b.nivel2 = @nivel2
			  and a.Ccuenta = b.Ccuenta
			  and a.Cpadre  = b.Ccuentaniv)

	if @@rowcount = 0 break

	select @nivel2 = @nivel2 + 1 


end

/* Insertar el Cubo */

</cfquery>
<cfquery datasource="#dsdst#">
/*
select a.*, b.Cformato, b.Cpadre, b.Cmovimiento 
	from ##PCDCatalogoCuenta a
		inner join CContables b
			on b.Ccuenta = a.Ccuentaniv
order by a.nivel, b.Cformato
*/

insert PCDCatalogoCuenta
(Ccuenta, Ccuentaniv, PCDCniv)
select
 Ccuenta, Ccuentaniv, nivel2
from ##PCDCatalogoCuenta

</cfquery>
<cfquery datasource="#dsdst#">
drop table ##PCDCatalogoCuenta
</cfquery>
</cffunction>
</cfcomponent>
