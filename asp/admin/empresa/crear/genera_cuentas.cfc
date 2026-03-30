<cfcomponent output="no">
<!--- Genera catálogo contable para nueva empresa.sql --->
<cffunction name="copiar" output="false" returntype="void">
	<cfargument name="dsori" type="string" hint="datasource origen">
	<cfargument name="dsdst" type="string" hint="datasource destino">
	<cfargument name="Eori" type="numeric" hint="Ereferencia(Ecodigo int) origen">
	<cfargument name="Edst" type="numeric" hint="Ereferencia(Ecodigo int) destino">
	<cfargument name="CEdst" type="numeric" hint="CEcodigo destino">
<!---
	Copia de catálogo contable a partir de empresa CR_av  */
	que corresponde a una agencia de viajes de Costa Rica */
	Servidor:       10.7.7.241,5000                       */
	Base de datos:  aspweb                                */
	Ecodigo:        243                                   */
--->
<!--- Este script asume que ambos estan en el mismo servidor y son sybase o mssqlserver --->
<cfset dbori = Application.dsinfo[dsori].schema & '.'>

<cfquery datasource="#dsdst#">
insert CtasMayor 
(Ecodigo, Cmayor, PCEMid, Cdescripcion, Ctipo, Cbalancen, CEcodigo, Cmascara, Csubtipo, Crevaluable)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	Cmayor, PCEMid, Cdescripcion, Ctipo, Cbalancen,
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#CEdst#">, Cmascara, Csubtipo, Crevaluable
from #dbori#.CtasMayor
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert CContables 
(Ecodigo, Cmayor, Cformato, Mcodigo, SCid, PCDcatid, Cdescripcion, CdescripcionF, Cmovimiento, Cbalancen, Cbalancenormal)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	Cmayor, Cformato, Mcodigo, SCid, PCDcatid, Cdescripcion, CdescripcionF, Cmovimiento, Cbalancen, Cbalancenormal
from #dbori#.CContables
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<!---<cfquery datasource="#dsdst#">
declare regs cursor for
select Ccuenta, Cformato
from CContables
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
order by Cformato
</cfquery>--->
<cfquery datasource="#dsdst#">
/* Define el Cpadre de cada cuenta en cuentas contables */
declare @Ccuenta numeric,
		@Cformato varchar(100),
		@cuantos int
/*open regs*/
select @Ccuenta = 0, @Cformato = ' '

while 1=1
begin

	/* fetch regs into @Ccuenta, @Cformato

	if @@sqlstatus != 0
		break*/
	select @Ccuenta = 0
	select top 1 @Ccuenta = Ccuenta, @Cformato = Cformato
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
	  and Cformato > @Cformato
	order by Cformato
	if @Ccuenta = 0 break
	
	select @cuantos = len(ltrim(rtrim(@Cformato)))

	select @Cformato = rtrim(ltrim(@Cformato)) + '%'

	update CContables
	set Cpadre = @Ccuenta
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
	  and Cformato like @Cformato
	  and len(ltrim(rtrim(Cformato))) > @cuantos
end
</cfquery>
<!---<cfquery datasource="#dsdst#">
close regs
deallocate cursor regs
</cfquery>--->
<cfquery datasource="#dsdst#">
insert CPVigencia 
(Ecodigo, Cmayor, PCEMid, CPVdesde, CPVhasta, CPVdesdeAnoMes, CPVhastaAnoMes, CPVformatoF, CPVformatoPropio)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	Cmayor, PCEMid, CPVdesde, CPVhasta, CPVdesdeAnoMes, CPVhastaAnoMes, CPVformatoF, CPVformatoPropio
from #dbori#.CPVigencia
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert CFinanciera 
(CPVid,   Ecodigo,  Cmayor,    CFformato,   CFdescripcion,   CFdescripcionF,   CFmovimiento,   Ccuenta)
select
 v.CPVid, c.Ecodigo, c.Cmayor, c.Cformato,  c.Cdescripcion,  c.CdescripcionF,  c.Cmovimiento,  c.Ccuenta
from CContables c, CPVigencia v
where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
  and c.Ecodigo = v.Ecodigo
  and c.Cmayor  = v.Cmayor
</cfquery>
<!---<cfquery datasource="#dsdst#">
declare regs2 cursor for
select CFcuenta, CFformato
from CFinanciera
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
order by CFformato
</cfquery>--->
<cfquery datasource="#dsdst#">
/* Define el Cpadre de cada cuenta en cuentas financieras */
set nocount on
declare @CFcuenta numeric,
		@CFformato varchar(100),
		@cuantos int
/*open regs2*/
select @CFcuenta = 0, @CFformato = ' '

while 1=1
begin

	/* fetch regs2 into @CFcuenta, @CFformato
	if @@sqlstatus != 0
		break
	*/ 
	select @CFcuenta = 0
	select top 1 @CFcuenta = CFcuenta, @CFformato = CFformato
	from CFinanciera
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
	  and CFformato > @CFformato
	order by CFformato
	if @CFcuenta = 0 break

	select @cuantos = len(ltrim(rtrim(@CFformato)))

	select @CFformato = rtrim(ltrim(@CFformato)) + '%'

	update CFinanciera
	set CFpadre = @CFcuenta
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
	  and CFformato like @CFformato
	  and len(ltrim(rtrim(CFformato))) > @cuantos
end
set nocount off
</cfquery>
<!---<cfquery datasource="#dsdst#">
close regs2
deallocate cursor regs2
</cfquery>--->

</cffunction>
</cfcomponent>