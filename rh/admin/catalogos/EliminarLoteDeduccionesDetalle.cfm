<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Eliminar Lotes de Deducciones"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">                  
					<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cfinclude template="EliminarLoteDeduccionesDetalle-form.cfm">
					<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>