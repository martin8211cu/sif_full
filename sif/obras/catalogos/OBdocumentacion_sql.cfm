<cf_navegacion name="OBDid" navegacion="">
<cf_navegacion name="Baja" navegacion="">
<cf_navegacion name="Download" navegacion="">

<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBdocumentacion"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="OBDid"
				type1="numeric"
				value1="#form.OBDid#"
		>

	<cfquery datasource="#session.dsn#">
		update OBdocumentacion
		   set 	Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			, 	OBTPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
			, 	OBPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#" null="#Len(form.OBPid) Is 0#">
			, 	OBOid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
			, 	OBEid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBEid#" null="#Len(form.OBEid) Is 0#">

			, 	OBDdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBDdescripcion#" null="#Len(form.OBDdescripcion) Is 0#">
			, 	OBDtexto		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBDtexto#" null="#Len(form.OBDtexto) Is 0#">
			, 	OBDarchivo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBDarchivo#" null="#Len(form.OBDarchivo) Is 0#">

			<cfif isdefined("form.OBDbinario") and len(trim(Form.OBDbinario))>
			,	OBDbinario 		= <cf_dbupload filefield="OBDbinario" accept="*/*" datasource="#session.DSN#">
			</cfif> 

			, 	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where OBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBDid#" null="#Len(form.OBDid) Is 0#">
	</cfquery>

	<cflocation url="OBdocumentacion.cfm">
<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBdocumentacion
		 where OBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBDid#" null="#Len(form.OBDid) Is 0#">
	</cfquery>

	<cflocation url="OBdocumentacion.cfm">
<cfelseif IsDefined("form.Alta")>	
	<cfif NOT (isdefined("form.OBDbinario") and len(trim(Form.OBDbinario)))>
		<cfset form.OBDarchivo = "*TEXTO*">
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into OBdocumentacion (
					Ecodigo
				, 	OBTPid	
				, 	OBPid	
				, 	OBOid	
				, 	OBEid	
	
				, 	OBDdescripcion	
				, 	OBDtexto		
				, 	OBDarchivo		
	
				,	OBDbinario 		
	
				, 	OBDfechaInclusion 
				, 	BMUsucodigo 
			)
		values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
				, 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPid#" null="#Len(form.OBPid) Is 0#">
				, 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
				, 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBEid#" null="#Len(form.OBEid) Is 0#">
	
				, 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBDdescripcion#" null="#Len(form.OBDdescripcion) Is 0#">
				, 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBDtexto#" null="#Len(form.OBDtexto) Is 0#">
				, 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBDarchivo#" null="#Len(form.OBDarchivo) Is 0#">
	
				,	<cf_dbupload filefield="OBDbinario" accept="*/*" datasource="#session.DSN#">
	
				, 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				, 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
	</cfquery>

	<cflocation url="OBdocumentacion.cfm">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBdocumentacion.cfm">
<cfelseif IsDefined("form.Download")>
	
	<cfquery name="rsArchivo" datasource="#session.dsn#">
		select OBDarchivo, OBDbinario
		  from OBdocumentacion
		where OBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBDid#" null="#Len(form.OBDid) Is 0#">
	</cfquery>

	<cfset LvarFile = GetTempFile(GetTempDirectory(),"archivos")>
	<cffile action="write" file="#LvarFile#" output="#rsArchivo.OBDbinario#" >

	<cfheader name="Content-Disposition"	value="attachment;filename=#rsArchivo.OBDarchivo#">
	<cfheader name="Expires" value="0">
	<cfcontent type="*/*" reset="yes" file="#LvarFile#" deletefile="yes">

	<cflocation url="OBdocumentacion.cfm">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBdocumentacion.cfm">
</cfif>

