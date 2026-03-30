<cfinclude template="url_params.cfm">
<cf_templateheader title="">
	<cf_web_portlet_start titulo="Programación de Cursos">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<table width="100%">
				<tr>
					<td align="left" valign="top" width="50%">
						<cfinclude template="lista.cfm"></td>
					<td width="50%" align="left" valign="top">
						<cfinclude template="NuevoCurso.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>


