<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update TESendoso
		set TESEdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESEdescripcion#" null="#Len(form.TESEdescripcion) Is 0#">
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		  and TESEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESEcodigo#" null="#Len(form.TESEcodigo) Is 0#">
	</cfquery>

	<cflocation url="tipoEndosos.cfm?TESEcodigo=#URLEncodedFormat(form.TESEcodigo)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESendoso
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and TESEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESEcodigo#" null="#Len(form.TESEcodigo) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Endoso_Default")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TESendoso
			   set TESEdefault = 0
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESendoso
			   set TESEdefault = 1
			 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESEcodigo#" null="#Len(form.TESEcodigo) Is 0#">
		</cfquery>
	</cftransaction>
	
	<cflocation url="tipoEndosos.cfm?TESEcodigo=#URLEncodedFormat(form.TESEcodigo)#">
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into TESendoso (
			TESid,
			TESEcodigo,
			TESEdescripcion)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESEcodigo#" null="#Len(form.TESEcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESEdescripcion#" null="#Len(form.TESEdescripcion) Is 0#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="tipoEndosos.cfm">
