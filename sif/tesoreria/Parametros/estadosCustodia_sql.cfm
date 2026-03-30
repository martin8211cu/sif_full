<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update TESCFestados
		   set TESCFEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFEdescripcion#" null="#Len(form.TESCFEdescripcion) Is 0#">,
		   TESCFEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESCFEcodigo#" null="#Len(form.TESCFEcodigo) Is 0#">
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and TESCFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFEid#" null="#Len(form.TESCFEid) Is 0#">
	</cfquery>

	<cflocation url="estadosCustodia.cfm?TESCFEid=#URLEncodedFormat(form.TESCFEid)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESCFestados
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and TESCFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFEid#" null="#Len(form.TESCFEid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into TESCFestados (
			TESid,
			TESCFEcodigo,
			TESCFEdescripcion)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESCFEcodigo#" null="#Len(form.TESCFEcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFEdescripcion#" null="#Len(form.TESCFEdescripcion) Is 0#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="estadosCustodia.cfm">

