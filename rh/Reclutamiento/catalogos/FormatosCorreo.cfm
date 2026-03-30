
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset LB_FormatosCorreo = t.translate('LB_FormatosCorreo','Formatos de Correo')>

<cf_templateheader> 
	<cf_web_portlet_start>
		<div class="row">
			<div class="col-sm-1"></div>
			<div class="col-sm-10">
				<cfinclude template="FormatosCorreoLista.cfm">
			</div>
			<div class="col-sm-1"></div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>


