
<cfif IsDefined("form.Cambio")>

	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBetapa"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="OBEid"
				type1="numeric"
				value1="#form.OBEid#"
		>
	

	<cfquery datasource="#session.dsn#">
		update OBetapa
		
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#">
		, OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
		, Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#" null="#Len(form.Ocodigo) Is 0#">
		, OBEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEcodigo#" null="#Len(form.OBEcodigo) Is 0#">
		, OBEdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEdescripcion#" null="#Len(form.OBEdescripcion) Is 0#">
		, OBEtexto = <cfif isdefined("form.OBEtexto") and Len(Trim(form.OBEtexto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEtexto#"><cfelse>null</cfif>
		
		, OBEfechaInicio = <cfif isdefined("form.OBEfechaInicio") and Len(Trim(form.OBEfechaInicio))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OBEfechaInicio#"><cfelse>null</cfif>
		, OBEfechaFinal = <cfif isdefined("form.OBEfechaFinal") and Len(Trim(form.OBEfechaFinal))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OBEfechaFinal#"><cfelse>null</cfif>
		, OBEresponsable = <cfif isdefined("form.OBEresponsable") and Len(Trim(form.OBEresponsable))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEresponsable#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBEid#" null="#Len(form.OBEid) Is 0#">
	</cfquery>

	<cflocation url="OBobra.cfm?OBOid=#form.OBOid#&OBEid=#URLEncodedFormat(form.OBEid)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBetapa
		where OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBEid#" null="#Len(form.OBEid) Is 0#">
	</cfquery>

	<cflocation url="OBobra.cfm?OBOid=#form.OBOid#">
<cfelseif IsDefined("form.Alta")>	

	<cfquery datasource="#session.dsn#">
		insert into OBetapa (
			
			Ecodigo,
			OBPid,
			OBOid,
			Ocodigo,
			OBEcodigo,
			OBEdescripcion,
			OBEtexto,
			
			OBEfechaInicio,
			OBEfechaFinal,
			OBEresponsable,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#" null="#Len(form.Ocodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEcodigo#" null="#Len(form.OBEcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEdescripcion#" null="#Len(form.OBEdescripcion) Is 0#">,
			<cfif isdefined("form.OBEtexto") and Len(Trim(form.OBEtexto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEtexto#"><cfelse>null</cfif>,
			
			<cfif isdefined("form.OBEfechaInicio") and Len(Trim(form.OBEfechaInicio))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OBEfechaInicio#"><cfelse>null</cfif>,
			<cfif isdefined("form.OBEfechaFinal") and Len(Trim(form.OBEfechaFinal))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OBEfechaFinal#"><cfelse>null</cfif>,
			<cfif isdefined("form.OBEresponsable") and Len(Trim(form.OBEresponsable))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBEresponsable#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>

	<cflocation url="OBobra.cfm?OBOid=#form.OBOid#&##etapa">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBobra.cfm?OBOid=#form.OBOid#&##etapa">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBobra.cfm?OBOid=#form.OBOid#">
</cfif>
