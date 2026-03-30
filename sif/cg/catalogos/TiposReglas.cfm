<cf_templateheader title="Mantenimiento de Reglas">
<cf_web_portlet_start _start titulo="Tipo de Reglas">
	
	<cf_navegacion name="Cmayor" default="" navegacion="">
	<cf_navegacion name="PCRGDescripcion" default="" navegacion="">
	<cf_navegacion name="PCRGorden" default="" navegacion="">
	
	<table width="100%" align="center">
		<tr>
			<td align="center" width="50%" valign="top">
				<cfinclude template="TiposReglas_list.cfm">
			</td>
			<td align="center" width="50%" valign="top">
				<cfinclude template="TiposReglas_form.cfm">
			</td>
		</tr>
	</table>
		
	<cf_web_portlet_start _end>
<cf_templatefooter>