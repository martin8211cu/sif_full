<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBclaseCuenta"
		method="Cambio" 
		CCclaseCuenta="#form.CCclaseCuenta#"
		CCnombre="#form.CCnombre#"
		ts_rversion="#form.ts_rversion#"/>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBclaseCuenta"
		method="Baja" 
		CCclaseCuenta="#form.CCclaseCuenta#"/>
<cfelseif IsDefined("form.Nuevo")>

<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBclaseCuenta"
		method="Alta" 
		CCclaseCuenta="#form.CCclaseCuenta#"
		CCnombre="#form.CCnombre#"/>
		
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBclaseCuenta-redirect.cfm">
