<!--- * modificado en notepad para incluir el boom * --->
<cfif IsDefined("form.Cambio")>	
	<cfparam name="form.PEXTsirenta" default="0">
	<cfparam name="form.PEXTsicargas" default="0">
	<cfparam name="form.DClinea" default="0">
	<cfif form.PEXTsirenta neq 0><cfset form.PEXTsirenta = 1></cfif>
	<cfif form.PEXTsicargas neq 0><cfset form.PEXTsicargas = 1></cfif>
	<cfif len(trim(form.DClinea)) eq 0><cfset form.DClinea = 0></cfif>
	<cfinvoke component="RHPagosExternosTipo"
		method="Cambio" >
		<cfinvokeargument name="PEXTid" value="#form.PEXTid#">
		<cfinvokeargument name="PEXTcodigo" value="#form.PEXTcodigo#">
		<cfinvokeargument name="PEXTdescripcion" value="#form.PEXTdescripcion#">
		<cfinvokeargument name="PEXTsirenta" value="#form.PEXTsirenta#">
		<cfinvokeargument name="PEXTsicargas" value="#form.PEXTsicargas#">
		<cfinvokeargument name="DClinea" value="#form.DClinea#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
	<cflocation url="RHPagosExternosTipo.cfm?PEXTid=#URLEncodedFormat(form.PEXTid)#">

<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="RHPagosExternosTipo"
		method="Baja" >
		<cfinvokeargument name="PEXTid" value="#form.PEXTid#">
	</cfinvoke>
	
	<!--- Ir a la Lista --->
	
<cfelseif IsDefined("form.Alta")>	
	<cfparam name="form.PEXTsirenta" default="0">
	<cfparam name="form.PEXTsicargas" default="0">
	<cfparam name="form.DClinea" default="0">
	<cfif form.PEXTsirenta neq 0><cfset form.PEXTsirenta = 1></cfif>
	<cfif form.PEXTsicargas neq 0><cfset form.PEXTsicargas = 1></cfif>
	<cfif len(trim(form.DClinea)) eq 0><cfset form.DClinea = 0></cfif>
	<cfinvoke component="RHPagosExternosTipo"
		method="Alta" returnvariable="form.PEXTid" >
		<cfinvokeargument name="PEXTcodigo" value="#form.PEXTcodigo#">
		<cfinvokeargument name="PEXTdescripcion" value="#form.PEXTdescripcion#">
		<cfinvokeargument name="PEXTsirenta" value="#form.PEXTsirenta#">
		<cfinvokeargument name="PEXTsicargas" value="#form.PEXTsicargas#">
		<cfinvokeargument name="DClinea" value="#form.DClinea#">
	</cfinvoke>
	<cflocation url="RHPagosExternosTipo.cfm?PEXTid=#URLEncodedFormat(form.PEXTid)#">
	
<cfelseif IsDefined("form.Nuevo")>	
	<cflocation url="RHPagosExternosTipo.cfm?btnNuevo='Nuevo'">
	
<cfelse>
	<!--- Ir a la Lista --->
</cfif>

<cflocation url="RHPagosExternosTipo.cfm">