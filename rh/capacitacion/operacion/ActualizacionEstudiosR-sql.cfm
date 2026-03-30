<cfset params = ''>
<cfif isdefined('form.BtnAprobar') or isdefined('form.BtnRechazar')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="RHEducacionEmpleado"
		redirect="ActualizacionEstudiosR.cfm"
		timestamp="#form.ts_rversion#"				
		field1="Ecodigo" type1="integer" value1="#session.Ecodigo#"
		field2="DEid" type2="integer" value2="#form.DEid#"
		field3="RHEElinea" type3="numeric" value3="#form.RHEElinea#">
	<cfquery name="UpdateEstudio" datasource="#session.DSN#">
		update RHEducacionEmpleado
		set RHEestado = <cfif isdefined('form.BtnAprobar')>1<cfelseif isdefined('form.BtnRechazar')>2</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
	</cfquery>
	<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "DEid=" & DEid>	
</cfif>

<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cflocation url="AprobacionCV.cfm?DEid=#form.DEid#&tab=4">
<cfelse>
	<cflocation url="ActualizacionEstudiosR.cfm#params#">
</cfif>
