<cfset params = ''>
<cfif isdefined('form.fTESOPidioma') and LEN(TRIM(form.fTESOPidioma))>
	<cfset params = params & '&fTESOPidioma=#form.fTESOPidioma#'>
</cfif>
<cfif isdefined('form.fTESOPRevisado') and LEN(TRIM(form.fTESOPRevisado))>
	<cfset params = params & '&fTESOPRevisado=#form.fTESOPRevisado#'>
</cfif>
<cfif isdefined('form.fTESOPAprobado') and LEN(TRIM(form.fTESOPAprobado))>
	<cfset params = params & '&fTESOPAprobado=#form.fTESOPAprobado#'>
</cfif>
<cfif isdefined('form.fTESOPRefrendado') and LEN(TRIM(form.fTESOPRefrendado))>
	<cfset params = params & '&fTESOPRefrendado=#form.fTESOPRefrendado#'>
</cfif>

<cfif isdefined('form.Pagina')>
	<cfset params = params & '&Pagina=#form.Pagina#'>
</cfif>
<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp
	datasource="#session.DSN#"
	table="TESOPprocEmi"
	redirect="OPProcEmi_form.cfm"
	timestamp="#form.ts_rversion#"
	field1="TESid" type1="numeric" value1="#session.tesoreria.TESid#">

	<cfquery datasource="#session.dsn#">
		update TESOPprocEmi
		set TESOPidioma 	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.TESOPidioma#">,
			TESOPRevisado 	= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.TESOPRevisado#">,
			TESOPAprobado 	= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESOPAprobado#">,
			TESOPRefrendado = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.TESOPRefrendado#">
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
	</cfquery>

	<cflocation url="OPProcEmi_form.cfm?TESId=#URLEncodedFormat(session.tesoreria.TESid)##params#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESOPprocEmi
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
	</cfquery>
	<cflocation url="OPProcEmi.cfm?1=1#params#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OPProcEmi_form.cfm?1=1&Nuevo='Nuevo'#params#">
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into TESOPprocEmi (
			TESid, 
			TESOPidioma, 
			TESOPRevisado, 
			TESOPAprobado, 
			TESOPRefrendado, 
			BMUsucodigo,
			ts_rversion
			)
		values 
			(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPidioma#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPRevisado#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPAprobado#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPRefrendado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				null
			)
	</cfquery>
	<cflocation addtoken="no" url="OPProcEmi_form.cfm?1=1#params#">
</cfif>

