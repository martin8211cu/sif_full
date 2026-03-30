<cf_templateheader title="Contabilidad General">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Clasificacion"
	Default="Clasificación"
	returnvariable="LB_Clasificacion"/>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Clasificacion#">
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td width="100%" valign="top">
						<cfinclude template="Clasificacion-listaform.cfm">
					</td>
				</tr>
			</table>
	<cf_web_portlet_end>	
<cf_templatefooter>