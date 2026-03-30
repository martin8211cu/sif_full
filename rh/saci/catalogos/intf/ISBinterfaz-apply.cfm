<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBinterfaz"
		method="Cambio" >
		<cfinvokeargument name="interfaz" value="#form.interfaz#">
		<cfinvokeargument name="nombreInterfaz" value="#form.nombreInterfaz#">
		<cfinvokeargument name="S02ACC" value="#form.S02ACC#">
		<cfinvokeargument name="componente" value="#form.componente#">
		<cfinvokeargument name="metodo" value="#form.metodo#">
		<cfinvokeargument name="severidad_reenvio" value="#form.severidad_reenvio#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBinterfaz"
		method="Baja" >
		<cfinvokeargument name="interfaz" value="#form.interfaz#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Exportar") Or IsDefined("url.Exportar")>
	<cfinclude template="ISBinterfaz-export.cfm">
	<cfabort>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBinterfaz"
		method="Alta"  >
		<cfinvokeargument name="interfaz" value="#form.interfaz#">
		<cfinvokeargument name="nombreInterfaz" value="#form.nombreInterfaz#">
		<cfinvokeargument name="S02ACC" value="#form.S02ACC#">
		<cfinvokeargument name="componente" value="#form.componente#">
		<cfinvokeargument name="severidad_reenvio" value="#form.severidad_reenvio#">
		<cfinvokeargument name="metodo" value="#form.metodo#">
	</cfinvoke>
</cfif>

<cfquery datasource="#session.dsn#" name="siguiente">
	select min(interfaz) as sig
	from ISBinterfaz
	where interfaz > <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.interfaz#">
</cfquery>
<cfif Len(siguiente.sig)>
	<cfset form.interfaz = siguiente.sig>
</cfif>
<cfinclude template="ISBinterfaz-redirect.cfm">