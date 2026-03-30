<cfparam name="form.emp" type="numeric">
<cfparam name="form.ctae" type="numeric">
<cfparam name="form.motivo" default="">
<cfparam name="form.otromotivo" default="">

<cfif IsDefined('form.habilitar')>
	<cfset Eactiva = 1>
<cfelse>
	<cfset Eactiva = 0>
</cfif>

<cfif form.motivo is 'otro'>
	<cfset EactivaMotivo = form.otromotivo>
<cfelse>
	<cfset EactivaMotivo = form.motivo>
</cfif>

<cfquery datasource="asp">
	update Empresa
	set Eactiva = <cfqueryparam cfsqltype="cf_sql_bit" value="#Eactiva#">,
		EactivaMotivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EactivaMotivo# #DateFormat(Now(), 'd mmm yy')#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.emp#">
	and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ctae#">
</cfquery>

<cfif IsDefined('form.habilitar')>
	<cfset session.statusmsg = 'Empresa habilitada'>
<cfelse>
	<cfset session.statusmsg = 'Empresa deshabilitada'>
</cfif>
<cflocation url="../empresas.cfm">