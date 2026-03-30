
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset LB_EnvioCorreosConcursantes = t.translate('LB_EnvioCorreosConcursantes','Envío de Correos a Concursantes')>

<cf_templateheader title="#LB_EnvioCorreosConcursantes#"> 
	<cf_web_portlet_start titulo="#LB_EnvioCorreosConcursantes#">
		<div class="row">
			<div class="col-sm-1"></div>
			<div class="col-sm-10">
				<cfinclude template="EnvioCorreosConcursantes-form.cfm">
			</div>
			<div class="col-sm-1"></div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>






