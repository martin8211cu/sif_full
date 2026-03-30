<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Aprobaci&oacute;n de Incidencias"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#nombre_proceso#">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top"> 
							<td align="center"><cfinclude template="aprobarIncidenciasProceso-form.cfm"></td>
						</tr>
						<tr valign="top"> <td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	
