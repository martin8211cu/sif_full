<cfinvoke key="LB_Titulo" default="Parámetros de Contabilidad Electrónica" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="ParametrosCE.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../portlets/pNavegacionCG.cfm">

		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>

				<td valign="top">
					<cfinclude template="formParametrosCE.cfm">
				</td>
		 	</tr>
		 	<tr>
			 	<td valign="top">
				 	<cfinclude template="formCuentasCFDICE.cfm">

				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>