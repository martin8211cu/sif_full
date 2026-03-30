<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBactividadEconomica"
		method="Cambio" >
		<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
		<cfinvokeargument name="AEnombre" value="#form.AEnombre#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBactividadEconomica"
		method="Baja" >
		<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBactividadEconomica"
		method="Alta"  >
		<cfinvokeargument name="AEactividad" value="#form.AEactividad#">
		<cfinvokeargument name="AEnombre" value="#form.AEnombre#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBactividadEconomica-redirect.cfm">
