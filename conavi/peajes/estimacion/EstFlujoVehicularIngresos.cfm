
	<cfif isdefined("url.Periodo") and LEN(url.Periodo)>
	<cfset navegacion = "">
    <cfset navegacion = navegacion & "&Periodo="&url.Periodo>
	<cf_rhimprime datos="/conavi/peajes/estimacion/EstFlujoVehicularIngresosDet.cfm"  paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/estimacion/EstFlujoVehicularIngresos.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
		 <cf_sifHTML2Word>
		<cfinclude template="EstFlujoVehicularIngresosDet.cfm">
		</CF_sifHTML2WORD>
	<cfelse>
		<cfinclude template="EstFlujoVehicularIngresosForm.cfm">
	</cfif>
