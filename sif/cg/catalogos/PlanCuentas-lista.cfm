<cf_templateheader title="Contabilidad General">
   <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Catalogos"
	Default="Catálogos"
	returnvariable="LB_Catalogos"/>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Catalogos#">
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
        
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td width="100%" valign="top">
						<cfinclude template="PlanCuentas-listaform.cfm">
					</td>
				</tr>
			</table>
	 <cf_web_portlet_end>
<cf_templatefooter>