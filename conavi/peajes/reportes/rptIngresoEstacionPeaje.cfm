<cfset LvarNombreReporte = ''>
<cfset navegacion = "">
<cfset navegacion = navegacion & "&Generar="&url.Generar>
<cfset navegacion = navegacion & "&Pidinicio="&url.Pidinicio>
<cfset navegacion = navegacion & "&Pidfinal="&url.Pidfinal>
<cfset navegacion = navegacion & "&PVidinicio="&url.PVidinicio>
<cfset navegacion = navegacion & "&PVidfinal="&url.PVidfinal>
<cfset navegacion = navegacion & "&periodoInicial="&url.periodoInicial>
<cfset navegacion = navegacion & "&periodoFinal="&url.periodoFinal>
<cfset navegacion = navegacion & "&mesInicial="&url.mesInicial>
<cfset navegacion = navegacion & "&mesFinal="&url.mesFinal>
<cfset navegacion = navegacion & "&PVcodigoinicio="&url.PVcodigoinicio>
<cfset navegacion = navegacion & "&PVdescripcioninicio="&url.PVdescripcioninicio>
<cfset navegacion = navegacion & "&PVcodigofinal="&url.PVcodigofinal>
<cfset navegacion = navegacion & "&PVdescripcionfinal="&url.PVdescripcionfinal>
<cfif isdefined("url.monto") >
	<cfset navegacion = navegacion & "&monto="&url.monto>
</cfif>
<cfif isdefined ("url.cantidad")>
	<cfset navegacion = navegacion & "&cantidad="&url.cantidad>
</cfif>
<cfset navegacion = navegacion & "&botonSel="&url.botonSel>
<cfset navegacion = navegacion & "&Fechadesde="&url.Fechadesde>
<cfset navegacion = navegacion & "&Fechahasta="&url.Fechahasta>
<cfset navegacion = navegacion & "&Pcodigoinicio="&url.Pcodigoinicio>
<cfset navegacion = navegacion & "&Pdescripcioninicio="&url.Pdescripcioninicio>
<cfset navegacion = navegacion & "&Pcodigofinal="&url.Pcodigofinal>
<cfset navegacion = navegacion & "&Pdescripcionfinal="&url.Pdescripcionfinal>
<cfset navegacion = navegacion & "&PTidinicio="&url.PTidinicio>
<cfset navegacion = navegacion & "&PTcodigoinicio="&url.PTcodigoinicio>
<cfset navegacion = navegacion & "&PTidfinal="&url.PTidfinal>
<cfset navegacion = navegacion & "&PTcodigofinal="&url.PTcodigofinal>


<cfif isdefined("url.tipoResumen") and url.tipoResumen eq 1>
	<cfset navegacion = navegacion & "&tipoResumen="&url.tipoResumen>
	<cfset LvarNombreReporte = 'Ingreso por Estaci&oacute;n de Peaje (Resumido)'>
	<cfset navegacion = navegacion & "&LvarNombreReporte="&LvarNombreReporte>
	<cfif isdefined("url.Fechadesde") and len(trim(url.Fechadesde)) and isdefined("url.Fechahasta") and len(trim(url.Fechahasta))>
		<cf_rhimprime datos="/conavi/peajes/reportes/rptIngresoEstacionPeajeRES.cfm" paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/reportes/rptIngresoEstacionPeaje-form.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			<cf_sifHTML2Word>
				<cfinclude template="rptIngresoEstacionPeajeRES.cfm">
			</cf_sifHTML2Word>	
	<cfelse>
		<cf_rhimprime datos="/conavi/peajes/reportes/rptIngresoEstacionPeajeRESperiodo.cfm" paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/reportes/rptIngresoEstacionPeaje-form.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			<cf_sifHTML2Word>
				<cfinclude template="rptIngresoEstacionPeajeRESperiodo.cfm">
			</cf_sifHTML2Word>	
	</cfif>	
<cfelse>

<cfset LvarNombreReporte = 'Ingreso por Estaci&oacute;n de Peaje (Detallado)'>
<cfset navegacion = navegacion & "&LvarNombreReporte="&LvarNombreReporte>
<cfif isdefined("url.Fechadesde") and len(trim(url.Fechadesde)) and isdefined("url.Fechahasta") and len(trim(url.Fechahasta))>
	<cf_rhimprime datos="/conavi/peajes/reportes/rptIngresoEstacionPeajeDET.cfm" paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/reportes/rptIngresoEstacionPeaje-form.cfm">
	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
		<cf_sifHTML2Word>
			<cfinclude template="rptIngresoEstacionPeajeDET.cfm">
		</cf_sifHTML2Word>
<cfelse>
	<cf_rhimprime datos="/conavi/peajes/reportes/rptIngresoEstacionPeajeDETperiodo.cfm"  paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/reportes/rptIngresoEstacionPeaje-form.cfm">
	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
		<cf_sifHTML2Word>
			<cfinclude template="rptIngresoEstacionPeajeDETperiodo.cfm">
		</cf_sifHTML2Word>
	</cfif>		
</cfif>


