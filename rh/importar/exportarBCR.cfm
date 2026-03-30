<cfif Application.dsinfo[session.dsn].type is 'sybase'>
	<cfset number = "convert(numeric,substring(a.CBcc, 6, 3))">
<cfelseif Application.dsinfo[session.dsn].type is 'oracle'>
	<cfset number = "to_number(substring(a.CBcc, 6, 3))">
<cfelse>
	<cfthrow message="Tipo de base de datos desconocido para cf_dbfunction: #Application.dsinfo[Attributes.datasource].type#">
</cfif>
<cfquery name="ERR" datasource="#session.dsn#">
	select  a.DRIdentificacion
			|| '#Chr(9)#'
			|| a.DRNapellido1
			|| ' '
			|| a.DRNapellido2
			|| ' '
			|| a.DRNnombre
			|| '#Chr(9)#'
			|| <cf_dbfunction name="to_char" args="#number#">
			|| '-'
			|| substring(a.CBcc, 9, {fn LENGTH(rtrim(a.CBcc))}-9)
			|| '#Chr(9)#'
			|| <cf_dbfunction name="to_char" args="DRNliquido"> as datos
	from DRNomina a
		inner join ERNomina b
		on b.ERNid = a.ERNid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	and {fn LENGTH(rtrim(a.CBcc))} > 9
</cfquery>