<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
		from Departamentos
	where Ecodigo = #session.Ecodigo#
	order by Dcodigo
</cfquery>
<cf_templateheader title="	Requisiciones por Departamento">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Requisiciones por Departamento'>
		<cfoutput>
			<form style="margin:0;" action="REPReqDepartamento.cfm" name="consulta" method="post">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right">Departamento Inicial:&nbsp;</td>
						<td>
							<select name="depini">
								<option value=""></option>
								<cfloop query="rsDepartamentos">
									<option value="#rsDepartamentos.Dcodigo#">#rsDepartamentos.Dcodigo#-#rsDepartamentos.Ddescripcion#</option>
								</cfloop>
							</select>
						</td>
						<td align="right">Departamento Final:&nbsp;</td>
						<td>
							<cfset ultimo = rsDepartamentos.RecordCount - 1>
							<select name="depfin">
								<option value=""></option>
								<cfloop query="rsDepartamentos">
									<option value="#rsDepartamentos.Dcodigo#" <!---<cfif (rsDepartamentos.CurrentRow - 1) eq ultimo >selected</cfif>---> >#rsDepartamentos.Dcodigo#-#rsDepartamentos.Ddescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="4" align="center"><input type="submit" name="Consultar" value="Consultar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
		</cfoutput>
		<cf_web_portlet_end>
<cf_templatefooter>