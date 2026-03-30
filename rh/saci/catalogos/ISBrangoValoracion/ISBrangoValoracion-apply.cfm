<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBrangoValoracion"
		method="Cambio" >
		<cfinvokeargument name="rangoid" value="#form.rangoid#">
		<cfinvokeargument name="rangodes" value="#form.rangodes#">
		<cfinvokeargument name="rangotope" value="#form.rangotope#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBrangoValoracion"
		method="Baja" >
		<cfinvokeargument name="rangoid" value="#form.rangoid#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBrangoValoracion" returnvariable="newID"
		method="Alta"  >
		<cfinvokeargument name="rangodes" value="#form.rangodes#">
		<cfinvokeargument name="rangotope" value="#form.rangotope#">
	</cfinvoke>
	<cfif isdefined('newID') and newID NEQ -1>
		<cfset form.rangoid = newID>
	</cfif>	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBrangoValoracion-redirect.cfm">



