<form name="formD" action="calificaciones-sql.cfm" method="post">
<cfoutput>
<cfif isdefined ('url.DEid') and len(trim(url.DEid)) gt 0>
	<input type="hidden" name="DEid" value="#url.DEid#" />
</cfif>
<cfif isdefined ('url.RHCid') and len(trim(url.RHCid)) gt 0>
	<input type="hidden" name="RHCid" value="#url.RHCid#" />
</cfif>
<cfif isdefined ('url.Mcodigo') and len(trim(url.Mcodigo)) gt 0>
	<input type="hidden" name="Mcodigo" value="#url.Mcodigo#" />
</cfif>
<cfquery name="rsData" datasource="#session.dsn#">
	select RHECjust from RHEmpleadoCurso
	where RHCid=#url.RHCid#
	and DEid=#url.DEid#
	and Ecodigo=#session.Ecodigo#
</cfquery>
	<table align="center">
		<tr>
			<td align="center" bgcolor="CCCCCC">
				<strong>Justificación</strong>
			</td>
		</tr>
		<tr>
			<td>
				<textarea name="just" cols="75" rows="3"  style="width:400px;font-family:Arial, Helvetica, sans-serif;font-size:12px " ><cfif isdefined('rsData') and rsData.recordcount gt 0>#rsData.RHECjust#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="submit" value="Guardar" name="AgregaDet" />
			</td>
		</tr>
	</table>
</cfoutput>
</form>