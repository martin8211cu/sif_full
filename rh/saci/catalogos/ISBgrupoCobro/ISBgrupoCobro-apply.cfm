<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBgrupoCobro"
		method="Cambio" >
		<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
		<cfinvokeargument name="GCnombre" value="#form.GCnombre#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBgrupoCobro"
		method="Baja" >
		<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBgrupoCobro"
		method="Alta"  >
		<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
		<cfinvokeargument name="GCnombre" value="#form.GCnombre#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBgrupoCobro-redirect.cfm">
