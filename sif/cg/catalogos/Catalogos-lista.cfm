<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Catalogos"
Default="Catálogos"
returnvariable="LB_Catalogos"/>
<cf_templateheader title="Contabilidad General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Catalogos#">
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="100%" valign="top">
					<cfinclude template="Catalogos-listaform.cfm"></td>
				</td>	
			</tr>
	 	</table>
	 <cf_web_portlet_end>	
<cf_templatefooter>