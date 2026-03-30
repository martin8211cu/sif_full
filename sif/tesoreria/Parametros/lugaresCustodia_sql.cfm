<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update TESCFlugares
		   set TESCFLUdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFLdescripcion#" null="#Len(form.TESCFLdescripcion) Is 0#">,
		   	TESCFLUcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESCFLUcodigo#" null="#Len(form.TESCFLUcodigo) Is 0#">
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and TESCFLUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLUid#" null="#Len(form.TESCFLUid) Is 0#">
	</cfquery>

	<cflocation url="lugaresCustodia.cfm?TESCFLUid=#URLEncodedFormat(form.TESCFLUid)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESCFlugares
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and TESCFLUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLUid#" null="#Len(form.TESCFLUid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into TESCFlugares (
			TESid,
			TESCFLUcodigo,
			TESCFLUdescripcion)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESCFLUcodigo#" null="#Len(form.TESCFLUcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFLdescripcion#" null="#Len(form.TESCFLdescripcion) Is 0#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="lugaresCustodia.cfm">

