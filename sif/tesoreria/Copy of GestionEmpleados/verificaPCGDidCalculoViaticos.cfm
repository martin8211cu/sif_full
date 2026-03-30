<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<cfsetting enablecfoutputonly="yes">

<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
	select count(1) cantidad
	from GEanticipoDet  
	where GEAid= #url.GEAid#
	and GEPVid is not null
	and (CFcuenta is null or PCGDid is null)
</cfquery>

<cfoutput>
<cfif len(trim(rsID_concepto_gasto.cantidad)) gt 0>
	#rsID_concepto_gasto.cantidad#
<cfelse>
	0
</cfif>
</cfoutput>



