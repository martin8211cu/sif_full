<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
  <cfinclude template="/rh/Utiles/params.cfm">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
				Default="Comisiones"
				VSgrupo="103"
				returnvariable="nombre_proceso"/>
				<cf_web_portlet_start titulo="#nombre_proceso#" >
					<cfset regresar = "RelacionCalculo-lista.cfm">					
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top"> 
							<td align="center">
								<cfinclude template="ResultadoCalculo-comisionesForm.cfm">
							</td>
						</tr>
						<tr valign="top"><td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>