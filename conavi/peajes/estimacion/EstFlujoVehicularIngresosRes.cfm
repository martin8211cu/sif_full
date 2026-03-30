  
	<cfif isdefined("url.Periodo") and LEN(url.Periodo)>	
	    <cfset navegacion = "">
	    <cfset navegacion = navegacion & "&Periodo="&url.Periodo>
		
		<cfif isdefined("url.Peaje") and LEN(url.Peaje)>
			<cfset navegacion = navegacion & "&Peaje="&url.Peaje>
		</cfif>	
		
		<cf_rhimprime datos="/conavi/peajes/estimacion/EstFlujoVehicularIngresosResRep.cfm" paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/estimacion/EstFlujoVehicularIngresosRes.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
		 <cf_sifHTML2Word>
		<cfinclude template="EstFlujoVehicularIngresosResRep.cfm">
		 </cf_sifHTML2Word> 
	<cfelse>
	 
		<cfinclude template="EstFlujoVehicularIngresosResForm.cfm">
		
	</cfif>
