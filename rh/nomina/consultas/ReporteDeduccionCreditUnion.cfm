
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset LB_ReporteDeduccionCreditUnion = t.translate('LB_ReporteDeduccionCreditUnion','Reporte de Deducción de Credit Union')>

<cf_templateheader title="#LB_ReporteDeduccionCreditUnion#"> 
	<cf_web_portlet_start titulo="#LB_ReporteDeduccionCreditUnion#">
		<div class="row">
			<div class="col-sm-11 col-sm-offset-1">
				<cfinclude template="ReporteDeduccionCreditUnion-form.cfm">
			</div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>