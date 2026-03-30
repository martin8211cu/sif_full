<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsCur" datasource="#session.dsn#">
	select RHECjustRechazo from RHEmpleadoCurso
	where RHCid=#url.RHCid#
	and DEid=#url.DEid#
	and Ecodigo=#session.Ecodigo#
</cfquery>
<cfoutput>
	<table width="100%" bgcolor="e6eef5">
		<tr bordercolor="add5f8">
			<td align="center" bgcolor="add5f8">
				<strong>Motivo de Rechazo de Matricula:</strong>
			</td>
		</tr>	
		<tr>	
			<td align="center">
				#rsCur.RHECjustRechazo#
			</td>
		</tr>
		
	</table>
</cfoutput>

