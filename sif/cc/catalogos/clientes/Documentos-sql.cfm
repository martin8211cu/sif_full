<cfset params = ''>
<cfif isdefined('form.Pagina')>
	<cfset params = params & 'Pagina=#form.Pagina#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&Filtro_rotulo=#form.Filtro_rotulo#'>
</cfif>		

<cfif isdefined('form.nuevo')>
	<cflocation url="Documentos.cfm?CDid=#form.CDid#&#params#" addtoken="no">
<cfelseif isdefined('form.baja')>
	<cfquery datasource="#session.dsn#">
		delete from ClienteDetallistaDoc
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">
		  and CDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDDid#">
	</cfquery>
	<cflocation url="Documentos.cfm?CDid=#form.CDid#&#params#" addtoken="no">
<cfelseif isdefined('form.cambio')>
	<cfquery datasource="#session.dsn#">
		update ClienteDetallistaDoc
		set TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">
		  and CDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDDid#">
	</cfquery>
	<cflocation url="Documentos.cfm?CDid=#form.CDid#&#params#" addtoken="no">
<cfelse>
	<!--- alta --->
	<cfquery datasource="#session.dsn#">
		insert into ClienteDetallistaDoc (CEcodigo,CDid, TDid, CDDfecha, CDDvalidohasta, CDDdocumento)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('y', 1, Now())#">,
			<cf_dbupload filefield='CDDdocumento'>)
	</cfquery>
	
	<cflocation url="Documentos.cfm?CDid=#form.CDid#&#params#" addtoken="no">
</cfif>