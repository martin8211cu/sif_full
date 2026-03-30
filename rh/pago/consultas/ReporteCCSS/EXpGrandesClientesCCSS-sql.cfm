<cfsetting  requesttimeout="36000">
<!--- <cfoutput>#now()#</cfoutput> --->
<cfif isdefined("form.CPperiodo") and len(trim(form.CPperiodo))>
<cfelse>
	<cfset form.CPperiodo = Year(Now())>
</cfif>
<cfif isdefined("form.CPmes") and len(trim(form.CPmes))>
<cfelse>
	<cfset form.CPmes = Month(Now())> 
</cfif>
<cfif isdefined("form.GrupoPlanilla") and len(trim(form.GrupoPlanilla))>
<cfelse>
	<cfset form.GrupoPlanilla = ''>
</cfif>
<!--- ***************************************************** --->
<!--- **********  DEFINICION DE VARIABLES    ************** --->
<!--- ***************************************************** --->
<cfset  Lvar_NUMPAT = "">			<!--- Numero patronal --->
<cfset  Lvar_adscrita = "">			<!--- Sucursal Adscrita CCSS --->
<cfset  Lvar_PatEmp = 0> 			<!--- Numero Patronal Empresarial 0 si, 1 es una oficina  --->
<cfset  Lvar_periodoA = 0> 			<!--- perido anterior si el mes actual no es el enero se mantiene el mismo periodo --->
<cfset  Lvar_mesA = 0> 				<!--- mes anterior --->
<cfset  Lvar_periodoT = 0> 			<!--- perido anterior si el mes Lvar_mesA no es el enero se mantiene el mismo periodo --->
<cfset  Lvar_mesT = 0> 				<!--- mes anterior --->

<cfif form.CPmes eq 1>
	<cfset  Lvar_periodoA = form.CPperiodo - 1> 
	<cfset  Lvar_mesA = 12> 
<cfelse>
	<cfset  Lvar_periodoA = form.CPperiodo > 
	<cfset  Lvar_mesA = form.CPmes - 1> 
</cfif>
<cfif Lvar_mesA eq 1>
	<cfset  Lvar_periodoT = Lvar_periodoA - 1> 
	<cfset  Lvar_mesT = 12> 
<cfelse>
	<cfset  Lvar_periodoT = Lvar_periodoA > 
	<cfset  Lvar_mesT = Lvar_mesA - 1> 
</cfif>

<cfset fecini   = CreateDate(form.CPperiodo, form.CPmes, 01)> 
<cfset fecfin   = DateAdd("s", -1, DateAdd("m", 1, fecini))> 
<cfset feciniA  =  DateAdd("m", -1, fecini)>
<cfset fecfinA  =  DateAdd("d", -1, fecini)>
<cfset feciniTA =  DateAdd("m", -2, fecini)>
<cfset fecfinTA =  DateAdd("d", -1, fecfinA)>

<!--- #############  PARAMETROS GENERALES   ############### --->
<cfquery name="rsParametros300" datasource="#session.DSN#">
	select Pcodigo,Pvalor from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and Pcodigo in (300)
</cfquery>
<cfquery name="rsParametros410" datasource="#session.DSN#">
	select Pcodigo,Pvalor from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and Pcodigo in (410)
</cfquery>

<cfif rsParametros300.recordCount GT 0>
		<cfset  Lvar_NUMPAT = rsParametros300.Pvalor>	
</cfif>

<cfif rsParametros410.recordCount GT 0>
		<cfset  Lvar_adscrita = rsParametros410.Pvalor>
</cfif>


<!--- ***************************************************** --->
<!--- **********  DEFINICION DE TABLAS       ************** --->
<!--- ***************************************************** --->

<cfinclude template="reporteCCSS_E.cfm">

 
 