<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Registro de Incidencias de Beneficios">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
			</tr>
		  <tr valign="top"> 
			<td align="center">
			  <cfinclude template="beneficiosIncidencia-form.cfm">
			</td>
		  </tr>
		  <tr valign="top"> 
			<td>&nbsp;</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	
