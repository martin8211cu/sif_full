<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBinterfazMensaje"
		method="Cambio" >
		<cfinvokeargument name="codMensaje" value="#form.codMensaje#">
		<cfinvokeargument name="mensaje" value="#form.mensaje#">
		<cfinvokeargument name="severidad" value="#form.severidad#">
		<cfinvokeargument name="codmensajeinterfaz" value="#form.codmensajeinterfaz#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBinterfazMensaje"
		method="Baja" >
		<cfinvokeargument name="codMensaje" value="#form.codMensaje#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBinterfazMensaje"
		method="Alta"  >
		<cfinvokeargument name="codMensaje" value="#form.codMensaje#">
		<cfinvokeargument name="mensaje" value="#form.mensaje#">
		<cfinvokeargument name="severidad" value="#form.severidad#">
		<cfinvokeargument name="codmensajeinterfaz" value="#form.codmensajeinterfaz#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBinterfazMensaje-redirect.cfm">



