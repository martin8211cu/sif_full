<br /><br /><br />
<table width="100%" valign="middle" align="center">	
	<cfif url.r eq -1>
		<tr><td valign="middle" align="center"><strong>El prospecto con la identificaci&oacute;n <cfoutput>#form.Pid#</cfoutput> ya fue registrado en el sistema.</strong></td></tr>
	<cfelse>
		<tr><td valign="middle" align="center"><strong>El prospecto se agreg&oacute; en forma exitosa.</strong></td></tr>
	</cfif>
	<tr><td valign="middle" align="center">
		&nbsp;
	</td></tr>
	<tr><td valign="middle" align="center">
		<form action="prospectos.cfm" method="get">
			<cf_botones names="Regresar" values="Regresar">
		</form>
	</td></tr>
</table>
<br /><br /><br />
<script language="javascript" type="text/javascript">
	function funcRegresar() {
		location.href = 'prospectos.cfm';
		return false;
	}
</script>
