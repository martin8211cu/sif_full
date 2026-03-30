<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DatosPersonales"
	Default="Datos Personales"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_DatosPersonales"/>
	﻿<cf_templateheader title="#LB_DatosPersonales#">

		<cf_web_portlet_start border="true" skin="portlet" tituloalign="center" titulo='Datos Personales'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td valign="top"></td>
					<td width="55%" valign="top"></td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>