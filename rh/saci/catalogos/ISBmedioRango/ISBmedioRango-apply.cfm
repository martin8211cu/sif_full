<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBmedioRango"
		method="Cambio" 
		MRid="#form.MRid#"
		EMid="#form.EMid#"
		access_server="#form.access_server#"
		MRdesde="#form.MRdesde#"
		MRhasta="#form.MRhasta#"
		ts_rversion="#form.ts_rversion#"/>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBmedioRango"
		method="Baja" 
		MRid="#form.MRid#"/>
<cfelseif IsDefined("form.Nuevo")>

<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBmedioRango" returnvariable="newID"
		method="Alta" 
		EMid="#form.EMid#"
		access_server="#form.access_server#"
		MRdesde="#form.MRdesde#"
		MRhasta="#form.MRhasta#"/>
		
	<cfif isdefined('newID') and newID NEQ -1>
		<cfset form.MRid = newID>
	</cfif>		
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBmedioRango-redirect.cfm">



