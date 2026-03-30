<cfif IsDefined("form.Cambio")>	
	<cf_dbupload filefield="EMlogo" returnvariable="upload_EMlogo" queryparam="false"/>
	<cfinvoke component="saci.comp.ISBmedioCia"
		method="Cambio" 
		EMid="#form.EMid#"
		EMnombre="#form.EMnombre#"
		TAtarifa="#form.TAtarifa#"
		EMlogo="#upload_EMlogo.contents#"
		EMcorreoReciboFacturas="#form.EMcorreoReciboFacturas#"
		EMcorreoEnvioFacturas="#form.EMcorreoEnvioFacturas#"
		ts_rversion="#form.ts_rversion#"/>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBmedioCia"
		method="Baja" 
		EMid="#form.EMid#"/>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cf_dbupload filefield="EMlogo" returnvariable="upload_EMlogo" queryparam="false"/>
	<cfinvoke component="saci.comp.ISBmedioCia" returnvariable="newID"
		method="Alta" 
		EMnombre="#form.EMnombre#"
		TAtarifa="#form.TAtarifa#"
		EMcorreoReciboFacturas="#form.EMcorreoReciboFacturas#"
		EMcorreoEnvioFacturas="#form.EMcorreoEnvioFacturas#"
		EMlogo="#upload_EMlogo.contents#"/>
		
		<cfif isdefined('newID') and newID NEQ -1>
			<cfset form.EMid = newID>
		</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBmedioCia-redirect.cfm">



