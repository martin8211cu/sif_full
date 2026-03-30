<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_ReporteEscalaSalarial = t.translate('LB_ReporteEscalaSalarial','Reporte Escala Salarial')>
<cfset LB_EscalaSalarial = t.translate('LB_EscalaSalarial','Escala Salarial')>
<cfset LB_Ayuda = t.translate('LB_Ayuda','Ayuda','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_AyudaRepEscalaSalarial = t.translate('LB_AyudaRepEscalaSalarial','Muestra la información de la escala salarial en forma matricial')>


<cf_templateheader title="#LB_ReporteEscalaSalarial#"> 
	<cf_web_portlet_start titulo="#LB_ReporteEscalaSalarial#">
		<br/>
		<div class="row">
			<div class="col-sm-1"></div>
			<div class="col-sm-4">
				<cf_web_portlet_start titulo="#LB_Ayuda#">
					<cfoutput>#LB_AyudaRepEscalaSalarial#</cfoutput>
			 	<cf_web_portlet_end>
			</div> 		
			<div class="col-sm-6">
				<cf_web_portlet_start >
					<cfinclude template="RepEscalaSalarial-Form.cfm">		
				<cf_web_portlet_end>	
			</div>
		</div>
		<br/>
	<cf_web_portlet_end>
<cf_templatefooter>