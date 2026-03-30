<cfinclude template="agente-params.cfm">

<cfif isdefined("form.Alta")>

	<cfinvoke component="saci.comp.ISBagenteValoracion" method="Alta" returnvariable="newID">
		<cfinvokeargument name="AGid" value="#form.AGid#">
		<cfinvokeargument name="ANvaloracion" value="#form.ANvaloracion#">
		<cfinvokeargument name="ANautomatica" value="#form.ANautomatica#">	
		<cfinvokeargument name="ANpuntaje" value="#form.ANpuntaje#">		
		<cfinvokeargument name="ANobservacion" value="#form.ANobservacion#">		
	</cfinvoke>
	<cfif isdefined('newID') and newID NEQ ''>
		<cfset form.ANid = newID>
	</cfif>
<cfelseif isdefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBagenteValoracion" method="Baja">
		<cfinvokeargument name="ANid" value="#form.ANid#">
	</cfinvoke>
	<cfset form.ANid = ''>
<cfelseif isdefined("form.Cambio")>
	<cfinvoke component="saci.comp.ISBagenteValoracion" method="Cambio">
		<cfinvokeargument name="ANid" value="#form.ANid#">
		<cfinvokeargument name="AGid" value="#form.AGid#">
		<cfinvokeargument name="ANvaloracion" value="#form.ANvaloracion#">
		<cfinvokeargument name="ANautomatica" value="#form.ANautomatica#">	
		<cfinvokeargument name="ANpuntaje" value="#form.ANpuntaje#">		
		<cfinvokeargument name="ANobservacion" value="#form.ANobservacion#">
	</cfinvoke>
<cfelseif isdefined("form.Nuevo")>	
	<cfset form.ANid = ''>
</cfif>

<cfinclude template="agente-redirect.cfm">
