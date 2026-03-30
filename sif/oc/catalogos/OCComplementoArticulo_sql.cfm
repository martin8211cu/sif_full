<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update OCcomplementoArticulo
		set  CFcomplementoTransito 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoTransito#">
			,CFcomplementoCostoVenta   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoCostoVenta#">
			,CFcomplementoIngreso      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoIngreso#">
			,BMUsucodigo			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
	</cfquery>
	<cflocation url="OCComplementoArticulo.cfm?Aid=#URLEncodedFormat(form.Aid)#&TieneComplemento=#URLEncodedFormat(form.TieneComplemento)#">
<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete OCcomplementoArticulo
			 where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfquery>
	</cftransaction>
	<cflocation url="OCComplementoArticulo.cfm">
<cfelseif IsDefined("form.Alta")>	
	<cftransaction>
	<cfquery name="RSInsert" datasource="#session.DSN#">
		insert into OCcomplementoArticulo (
			Aid,
			CFcomplementoTransito,
			CFcomplementoCostoVenta,
			CFcomplementoIngreso,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoTransito#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoCostoVenta#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoIngreso#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		</cfquery>
	</cftransaction>
	<cflocation url="OCComplementoArticulo.cfm?Aid=#URLEncodedFormat(form.Aid)#&TieneComplemento=S">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OCComplementoArticulo.cfm">
</cfif>



