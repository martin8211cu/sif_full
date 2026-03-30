<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

		<cfinclude template="accionesMasiva-config.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td valign="top" align="center">
				<cf_web_portlet_start titulo="#titulo#">
					<cfinclude template="/home/menu/pNavegacion.cfm">
					<cfinclude template="accionesMasiva-header.cfm">
					<cfinclude template="accionesMasiva-paso#Form.paso#.cfm">
				<cf_web_portlet_end>
			</td>
			<!--- Columna de Menú de Pasos y Sección de Ayuda --->
			<td valign="top" width="1%">
				<cfinclude template="accionesMasiva-progreso.cfm"><br>
				<cfinclude template="accionesMasiva-ayuda.cfm">
			</td>
		  </tr>
		</table>
<cf_templatefooter>
