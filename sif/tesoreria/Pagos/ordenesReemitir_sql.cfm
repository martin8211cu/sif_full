<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="Tesoreria"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="TESid"
				type1="numeric"
				value1="#form.TESid#"
		>
	<cfquery datasource="#session.dsn#">
		update Tesoreria
		set TESdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESdescripcion#" null="#Len(form.TESdescripcion) Is 0#">
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, EcodigoAdm = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoAdm#" null="#Len(form.EcodigoAdm) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#" null="#Len(form.TESid) Is 0#">
	</cfquery>

	<cflocation url="Tesoreria.cfm?TESid=#URLEncodedFormat(form.TESid)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from Tesoreria
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#" null="#Len(form.TESid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into Tesoreria (
			TESdescripcion,
			CEcodigo,
			EcodigoAdm,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESdescripcion#" null="#Len(form.TESdescripcion) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoAdm#" null="#Len(form.EcodigoAdm) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="Tesoreria.cfm">


