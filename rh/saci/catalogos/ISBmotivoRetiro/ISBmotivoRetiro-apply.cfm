<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBmotivoRetiro"
		method="Cambio" >
		<cfinvokeargument name="MRid" value="#form.MRid#">
		<cfinvokeargument name="MRcodigo" value="#form.MRcodigo#">
		<cfinvokeargument name="MRnombre" value="#form.MRnombre#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBmotivoRetiro"
		method="Baja" >
		<cfinvokeargument name="MRid" value="#form.MRid#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBmotivoRetiro" returnvariable="newID"
		method="Alta">
		<cfinvokeargument name="MRcodigo" value="#form.MRcodigo#">
		<cfinvokeargument name="MRnombre" value="#form.MRnombre#">
	</cfinvoke>
	
	<cfif isdefined('newID') and newID NEQ -1>
		<cfset form.MRid = newID>
	</cfif>	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBmotivoRetiro-redirect.cfm">



