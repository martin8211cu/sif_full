<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Clasificaci&oacute;n de Conceptos de Servicio'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="3" valign="top"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
					<tr valign="top"> 
						<td valign="top" width="50%"> 
							<cfinclude template="arbolConceptos.cfm">
						</td>
						<td valign="top" width="5%">&nbsp;</td>
						<td width="50%" valign="top" ><cfinclude template="formCConceptos.cfm"></td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
<cf_templatefooter>