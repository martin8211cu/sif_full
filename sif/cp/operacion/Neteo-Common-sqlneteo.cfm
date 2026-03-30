<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 23 de agosto del 2005
	Motivo: Correccion del titulo de la forma, cuando entraba por CxP dejaba el titulo "Cuentas por Cobrar".
			Esto porque solo existen un proceso de neteo de documentos y este se encuentra dentro de la carpeta 
			de CxC. Creando un archivo dentro de CxP y haciendo la llamada del proceso, hace la corrección. Además 
			cambios en la seguridad de CxP.
			Se cambia la direccion de ubicacion de las distintas llamadas a fuentes condicionado a el modulo en q me encuentro. 
			Utilizando la variable de session modulo.
 --->

<cfset params = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset params = params & "Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocumentoNeteo_F") and LEN(TRIM(form.DocumentoNeteo_F))>
	<cfset params = params & "&DocumentoNeteo_F=#form.DocumentoNeteo_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset params = params & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>

<cfif isdefined("form.AltaNeteo")>
	<cftransaction>
	<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
		select 1 
		from DocumentoNeteo
		where DocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocumentoNeteo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsValidaCodigo.recordcount gt 0>
		<cf_errorCode	code = "50186" msg = "El Código del Documento ya existe. Proceso Cancelado!">
	</cfif>
	<cfquery name="rsAltaNeteo" datasource="#session.dsn#">
		insert into DocumentoNeteo
		(Ecodigo, DocumentoNeteo, Observaciones, BMUsucodigo, Mcodigo, CCTcodigo, Ocodigo, Dfechadoc, SNcodigo, Dmonto, TipoNeteo, TipoNeteoDocs)
		values(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocumentoNeteo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Observaciones#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Dfechadoc)#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.Dmonto,',','','all')#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoNeteo#">
			<cfparam name="form.TipoNeteoDocs" default="0">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoNeteoDocs#">
		)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="rsAltaNeteo">
	</cftransaction>
	<cfset params=params & "&idDocumentoNeteo=" & rsAltaNeteo.identity>
<cfelseif isdefined("form.CambioNeteo")>
	<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
		select 1 
		from DocumentoNeteo
		where DocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocumentoNeteo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and idDocumentoNeteo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
	</cfquery>
	<cfif rsValidaCodigo.recordcount gt 0>
		<cf_errorCode	code = "50186" msg = "El Código del Documento ya existe. Proceso Cancelado!">
	</cfif>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="DocumentoNeteo"
		redirect="Neteo#form.TipoNeteo#.cfm?idDocumentoNeteo=#form.idDocumentoNeteo#"
		timestamp="#form.timestampneteo#"
		field1="Ecodigo,integer,#session.Ecodigo#"
		field2="idDocumentoNeteo,numeric,#form.idDocumentoNeteo#"/>
	<cfquery datasource="#session.dsn#">
		update DocumentoNeteo
		set DocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DocumentoNeteo#">
		, Observaciones = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Observaciones#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		, CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		, Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		, Dfechadoc = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Dfechadoc)#">
		, SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		, Dmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.Dmonto,',','','all')#">
		<cfparam name="form.TipoNeteoDocs" default="0">
		, TipoNeteoDocs = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoNeteoDocs#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
	</cfquery>
	<cfset params=params & "&idDocumentoNeteo=" & form.idDocumentoNeteo>
<cfelseif isdefined("form.BajaNeteo")>
	<cfquery datasource="#session.dsn#">
		delete from DocumentoNeteoDCxC
		where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from DocumentoNeteoDCxP
		where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from DocumentoNeteo
		where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cflocation url="../../#lcase(Session.monitoreo.smcodigo)#/operacion/Neteo-Lista#form.TipoNeteo#.cfm?#params#">
</cfif>
<cflocation url="../../#lcase(Session.monitoreo.smcodigo)#/operacion/Neteo#form.TipoNeteo#.cfm?#params#">

