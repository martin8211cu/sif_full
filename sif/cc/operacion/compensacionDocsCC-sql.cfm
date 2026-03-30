
<cfset params = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset params = params & "Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
	<cfset params = params & "&DocCompensacion_F=#form.DocCompensacion_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset params = params & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>

<cfif isdefined("form.AltaCompensacion")>
	<cftransaction>
	<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
		select 1
		from DocCompensacion
		where DocCompensacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocCompensacion#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsValidaCodigo.recordcount gt 0>
		<cf_errorCode	code = "50186" msg = "El Código del Documento ya existe. Proceso Cancelado!">
	</cfif>
	<cfquery name="rsAltaCompensacion" datasource="#session.dsn#">
		insert into DocCompensacion
		(Ecodigo, DocCompensacion, Observaciones, BMUsucodigo, Mcodigo, CCTcodigo, Ocodigo, Dfechadoc, SNcodigo, Dmonto, TipoCompensacion, TipoCompensacionDocs)
		values(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocCompensacion#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Observaciones#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Dfechadoc)#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.Dmonto,',','','all')#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoCompensacion#">
			<cfparam name="form.TipoCompensacionDocs" default="0">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoCompensacionDocs#">
		)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="rsAltaCompensacion">
	</cftransaction>
	<cfset params=params & "&idDocCompensacion=" & rsAltaCompensacion.identity>
<cfelseif isdefined("form.CambioCompensacion")>
	<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
		select 1
		from DocCompensacion
		where DocCompensacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocCompensacion#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and idDocCompensacion <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>
	<cfif rsValidaCodigo.recordcount gt 0>
		<cf_errorCode	code = "50186" msg = "El Código del Documento ya existe. Proceso Cancelado!">
	</cfif>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="DocCompensacion"
		redirect="compensacionDocsCC-form.cfm?idDocCompensacion=#form.idDocCompensacion#"
		timestamp="#form.timestampComp#"
		field1="Ecodigo,integer,#session.Ecodigo#"
		field2="idDocCompensacion,numeric,#form.idDocCompensacion#"/>
	<cfquery datasource="#session.dsn#">
		update DocCompensacion
		set DocCompensacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocCompensacion#">
		, Observaciones = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Observaciones#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		, CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		, Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		, Dfechadoc = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Dfechadoc)#">
		, SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		, Dmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.Dmonto,',','','all')#">
		<cfparam name="form.TipoCompensacionDocs" default="0">
		, TipoCompensacionDocs = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoCompensacionDocs#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>
	<cfset params=params & "&idDocCompensacion=" & form.idDocCompensacion>
<cfelseif isdefined("form.BajaCompensacion")>
	<cfquery datasource="#session.dsn#">
		delete from DocCompensacionDCxC
		where idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from DocCompensacionDCxP
		where idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from DocCompensacion
		where idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cflocation url="compensacionDocsCC.cfm?#params#">
</cfif>
<cflocation url="compensacionDocsCC-form.cfm?#params#">

