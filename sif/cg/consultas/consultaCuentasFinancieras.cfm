<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo"	default="Consulta Cuentas Financieras"
returnvariable="LB_Titulo"	xmlfile="consultaCuentasFinancieras.xml"/>
	<cf_templateheader title="#LB_Titulo#">
		<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><iframe src="/cfmx/sif/Utiles/ConlisCuentasFinancieras.cfm" width="100%" height="500" frameborder="1"></td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>