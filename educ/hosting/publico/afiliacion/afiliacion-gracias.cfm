<cf_template>
	<cf_templatearea name="title">
		Se registr&oacute; en forma exitosa!
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
	<cfoutput>
		<form name="form1" action="/" method="get" target="_top">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; ">
					<span class="titulo">
					Felicidades #Form.Pnombre#&nbsp;#Form.Papellido1#&nbsp;#Form.Papellido2#!
					</span>
					<br>
					<br>
					Usted ya forma parte de nuestra congregaci&oacute;n.<br>
					Agradecemos su inter&eacute;s en afiliarse a nuestros servicios.<br>
				</td>
			  </tr>
			  <tr>
				<td align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center">
					<input type="submit" name="btnContinuar" value="CONTINUAR EN EL PORTAL">
					<input type="button" name="btnSalir" value="SALIR" onClick="javascript: location.href = '/cfmx/home/public/logout.cfm'">
				</td>
			  </tr>
			</table>
		</form>
	</cfoutput>	
	</cf_templatearea>
</cf_template>
