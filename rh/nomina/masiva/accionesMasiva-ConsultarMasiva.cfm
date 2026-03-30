<html>
	<head>
		<title><cf_translate key="LB_Consulta_de_accion_de_personal">Consulta de Acci&oacute;n de Personal</cf_translate></title>
	</head>
	<body>
		<cf_templatecss>

		<!--- Variables por URL --->
		<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea))><cfset form.RHAlinea = url.RHAlinea></cfif>
		<cfif isdefined("url.RHAid") and len(trim(url.RHAid))><cfset form.RHAid = url.RHAid></cfif>
		
		<cfif isdefined("form.RHAlinea") and len(trim(form.RHAlinea))>
			<cf_rhconsultaraccion RHAlinea="#Form.RHAlinea#" botonCerrar="true">
		<cfelse>
			<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="center" style="color:#FF0000; font-size:14px; " class="fileLabel">-- El Tipo de Acci&oacute;n Masiva no permite Trabajar con Per&iacute;odos --</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			
		</cfif>
	</body>
</html>	
