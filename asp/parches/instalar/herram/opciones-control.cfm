<cfparam name="form.notificar" default="0">
<cfif Not ListFind('0,1', form.notificar)>
	<cfset form.notificar = '0'>
</cfif>

<cfinvoke component="asp.parches.comp.instala" method="get_servidor" returnvariable="servidor" />

<cfquery datasource="asp" name="APServidor">
	update APServidor
	set cliente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cliente#">,
		ipaddr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ipaddr#">,
		admin_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
		notifica_instalacion = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.notificar EQ '1'#">
		<!---
		notifica_errores = 
		--->
	where servidor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#servidor#">
</cfquery>

<cflocation url="opciones.cfm">