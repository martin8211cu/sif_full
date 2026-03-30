<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update OCcomplementoSNegocio
		set  CFcomplementoTransito 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoTransito#">
			,CFcomplementoCostoVenta   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoCostoVenta#">
			,CFcomplementoIngreso	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoIngreso#">
			,BMUsucodigo			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
	</cfquery>
	<cflocation url="OCComplementoSocio.cfm?SNid=#URLEncodedFormat(form.SNid)#&TieneComplemento=#URLEncodedFormat(form.TieneComplemento)#">
<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete OCcomplementoSNegocio
			 where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
		</cfquery>
	</cftransaction>
	<cflocation url="OCComplementoSocio.cfm">
<cfelseif IsDefined("form.Alta")>	
	<cftransaction>
	<cfquery name="RSInsert" datasource="#session.DSN#">
		insert into OCcomplementoSNegocio (
			SNid,
			CFcomplementoTransito,
			CFcomplementoCostoVenta,
			CFcomplementoIngreso,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoTransito#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoCostoVenta#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcomplementoIngreso#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		</cfquery>
	</cftransaction>
	<cflocation url="OCComplementoSocio.cfm?SNid=#URLEncodedFormat(form.SNid)#&TieneComplemento=S">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OCComplementoSocio.cfm">
</cfif>



