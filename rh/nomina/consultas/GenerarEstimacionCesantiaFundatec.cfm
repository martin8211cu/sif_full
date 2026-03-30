<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset LB_ReporteEstimacionCesantia = t.translate('LB_ReporteEstimacionCesantia','Generar Información Reporte de Estimación de Cesantía')>

<cf_templateheader title="#LB_ReporteEstimacionCesantia#"> 
	<cf_web_portlet_start titulo="#LB_ReporteEstimacionCesantia#">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
				<cfinclude template="GenerarEstimacionCesantiaFundatec-form.cfm">
			</div>
			<div class="col-sm-2"></div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>