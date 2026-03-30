<!---
<cf_template>
<cf_templatearea name="title">
Consulta de Empleados afectados por Movimiento
</cf_templatearea>
<cf_templatearea name="body">
--->

<html>
	<meta />
	<body>
	<cf_templatecss>
	<!---<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Movimientos de Plazas'>--->
		<table width="100%" border="0" cellspacing="0">
		  <!---<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>--->
		  <tr>
			<td valign="top"  width="55%">
				<cfset params = '&RHPPid=#url.RHPPid#&fdesde=#url.fdesde#&fhasta=#url.fhasta#' >
				<cf_rhimprime datos="/rh/admplazas/operacion/rm-consultaEmpleados-form.cfm" paramsuri="#params#">
				<cfinclude template="rm-consultaEmpleados-form.cfm">
			</td>
		  </tr>
		</table>
	<!---<cf_web_portlet_end>--->
	</body>
</html>

<!---
</cf_templatearea>
</cf_template>
--->


