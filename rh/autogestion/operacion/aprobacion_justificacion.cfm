<form name="formD" action="aprobacionMatricula-sql.cfm" method="post">
<cfoutput>

<cfif isdefined ('url.RHECid') and len(trim(url.RHECid)) gt 0>
	<input type="hidden" name="RHECid" value="#url.RHECid#" />
</cfif>
<cfif isdefined ('url.formu') and len(trim(url.formu)) gt 0>
	<input type="hidden" name="formu" value="#url.formu#" />
</cfif>

<cfquery name="rsData" datasource="#session.dsn#">
	select RHECid,DEid,RHCid,RHECjustRechazo 
	from RHEmpleadoCurso
	where RHECid=#url.RHECid#
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
				<textarea name="just" cols="75" rows="3"  style="width:400px;font-family:Arial, Helvetica, sans-serif;font-size:12px " ><cfif isdefined('rsData') and rsData.recordcount gt 0>#rsData.RHECjustRechazo#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="submit" value="Rechazar" name="RechazarDet"  />
			</td>
		</tr>
	</table>
</cfoutput>
</form>

<!---<script language="javascript1.2" type="text/javascript">
function funcV(){
	alert('entre')
	window.opener.document.form1.reloadPage
	document.form1.RechazarDet.click();
	window.close();
	
}

</script>--->