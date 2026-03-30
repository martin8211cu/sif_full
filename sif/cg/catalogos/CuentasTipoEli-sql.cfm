<!--- <cf_dump var="#form#"> --->
<cfif IsDefined("form.btnAgregar")>

	<cfquery name="insCtaTipoRep" datasource="#Session.DSN#">
		insert into CGAreasTipoRepCtasEliminar 
			(Ccuenta, Ocodigo, CGARepid, Ecodigo, BMUsucodigo)
		 values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta2#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCGARepid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo_Ccuenta2#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		)
	</cfquery>
<cfelseif IsDefined("form.btnEliminar")>
	<cfquery name="insCtaTipoRep" datasource="#Session.DSN#">
		delete from CGAreasTipoRepCtasEliminar 
		where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta2#">
		 and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
		 and CGARepid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCGARepid#">
	</cfquery>

</cfif>

<cfset params= "">
<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum>
</cfif>

<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARepid=" & Form.fCGARepid>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=2">

<cflocation url="CuentasTipoRep_Option.cfm#params#">


