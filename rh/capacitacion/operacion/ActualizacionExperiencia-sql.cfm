<cfset params = ''>
<cfif isdefined('form.BtnAprobar') or isdefined('form.BtnRechazar')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="RHExperienciaEmpleado"
		redirect="ActualizacionExperiencia.cfm"
		timestamp="#form.ts_rversion#"				
		field1="Ecodigo" type1="integer" value1="#session.Ecodigo#"
		field2="DEid" type2="integer" value2="#form.DEid#"
		field3="RHEEid" type3="numeric" value3="#form.RHEEid#">
	<cfquery name="UpdateEstudio" datasource="#session.DSN#">
		update RHExperienciaEmpleado
		set RHEEestado = <cfif isdefined('form.BtnAprobar')>1<cfelseif isdefined('form.BtnRechazar')>0</cfif>,
			RHEEObserv = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEObserv#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
	<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "DEid=" & DEid>	
</cfif>
 
<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cflocation url="AprobacionCV.cfm?DEid=#form.DEid#&tab=3">
<cfelse>
	<cflocation url="ActualizacionExperiencia.cfm#params#">
</cfif>
