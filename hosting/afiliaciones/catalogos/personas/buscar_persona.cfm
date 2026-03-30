<cfsetting enablecfoutputonly="yes">
<cfparam name="url.cedula">
<cfparam name="url.nombre">
<cfparam name="url.apellido1">
<cfparam name="url.apellido2">
<cfquery datasource="#session.dsn#" name="buscar">
	select *
	from sa_personas
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	<cfif Len(Trim(url.cedula))>
	  and Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.cedula)#">
	</cfif>
	<cfif Len(Trim(url.nombre))>
	  and upper(Pnombre) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.nombre))#">
	</cfif>
	<cfif Len(Trim(url.apellido1))>
	  and upper(Papellido1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.apellido1))#">
	</cfif>
	<cfif Len(Trim(url.apellido2))>
	  and upper(Papellido2) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.apellido2))#">
	</cfif>
</cfquery>
<cfoutput><html><head><title>Busqueda de personas</title><body bgcolor="black" text="white">
<script type="text/javascript">
<!--
<cfif buscar.RecordCount is 1>
	window.parent.persona_encontrada(
		'#JSStringFormat(buscar.id_persona)#',
		'#JSStringFormat(buscar.Pnombre)#',
		'#JSStringFormat(buscar.Papellido1)#',
		'#JSStringFormat(buscar.Papellido2)#',
		'#JSStringFormat(buscar.Pid)#');
<cfelse>
	window.parent.persona_no_encontrada();
</cfif>
//-->
</script>
RecordCount:{#buscar.RecordCount#}<br>
id_persona:{#ValueList(buscar.id_persona)#}
</body></head></html>
</cfoutput>