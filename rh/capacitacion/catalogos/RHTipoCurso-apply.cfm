<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHTipoCurso"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHTCid"
				type1="numeric"
				value1="#form.RHTCid#"
			
		>
	<cfquery datasource="#session.dsn#">
		update RHTipoCurso
		set RHTCdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHTCdescripcion#" null="#Len(form.RHTCdescripcion) Is 0#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where RHTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTCid#" null="#Len(form.RHTCid) Is 0#">
	</cfquery>

	<cflocation url="RHTipoCurso.cfm?RHTCid=#URLEncodedFormat(form.RHTCid)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHTipoCurso
		where RHTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTCid#" null="#Len(form.RHTCid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHTipoCurso (
			RHTCdescripcion,
			Ecodigo,
			BMfecha,
			BMUsucodigo)
		values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHTCdescripcion#" null="#Len(form.RHTCdescripcion) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHTipoCurso.cfm">


