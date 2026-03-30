<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHCursos"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHCid"
				type1="numeric"
				value1="#form.RHCid#">
	
	<cfquery datasource="#session.dsn#">
		update RHCursos
		set RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#" null="#Len(form.RHIAid) Is 0#">
		, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">
		, RHTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTCid#" null="#Len(form.RHTCid) Is 0#">
		
		, RHCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCcodigo#" null="#Len(form.RHCcodigo) Is 0#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, RHCfdesde = <cfif Len(form.RHCfdesde)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfdesde)#"><cfelse>null</cfif>
		, RHCfhasta = <cfif Len(form.RHCfhasta)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfhasta)#"><cfelse>null</cfif>
		
		, RHCprofesor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCprofesor#" null="#Len(form.RHCprofesor) Is 0#">
		, RHCcupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCcupo#" null="#Len(form.RHCcupo) Is 0#">
		, RHCautomat = <cfif isdefined("form.RHCautomat")>1<cfelse>0</cfif>
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">
	</cfquery>

	<cflocation url="RHCursos.cfm?RHCid=#URLEncodedFormat(form.RHCid)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHCursos
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHCursos( 	RHIAid,
								Mcodigo,
								RHTCid,
								RHCcodigo,
								Ecodigo,
								RHCfdesde,
								RHCfhasta,
								RHCprofesor,
								RHCcupo,
								RHCautomat,
								BMfecha,
								BMUsucodigo)
		values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#" null="#Len(form.RHIAid) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTCid#" null="#Len(form.RHTCid) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCcodigo#" null="#Len(form.RHCcodigo) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif Len(form.RHCfdesde)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfdesde)#"><cfelse>null</cfif>,
					<cfif Len(form.RHCfhasta)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfhasta)#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCprofesor#" null="#Len(form.RHCprofesor) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCcupo#" null="#Len(form.RHCcupo) Is 0#">,
					<cfif isdefined("form.RHCautomat")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cfif>

<cflocation url="RHCursos.cfm">


