<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td width="24%">&nbsp;</td>
		<td colspan="3">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="8%" bgcolor="#003366" ><font color="#FFFFFF"><img src="/cfmx/aspAdmin/imagenes/Stop01_T.gif" width="25" height="25"><span class="titulo"></span></font></td>
		<td width="49%" bgcolor="#003366" ><div align="left"><font color="#FFFFFF">&nbsp;<strong><font size="3">Mensaje</font></strong></font></div></td>
		<td width="15%">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="1%" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right">&nbsp;</div></td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">
			<br>
				<font color="#FF3300" size="2">
					<cfif isdefined('url.errMsg')>
						<cfoutput>#URLDecode(url.errMsg)#</cfoutput><br>
					<cfelseif isdefined("url.errDet")>
						<cfoutput>#url.errDet#</cfoutput>
					<cfelseif isdefined("cfcatch.Detail")>
						<cfif isdefined("session.debug") and session.debug eq true >
							<cfoutput>#cfcatch.Detail#</cfoutput>
						<cfelse>
							<cfif isdefined('cfcatch.NativeErrorCode') and cfcatch.NativeErrorCode eq 547 >
								El registro no puede ser eliminado, pues posee dependecias con otros datos.
							<cfelseif isdefined('cfcatch.NativeErrorCode') and cfcatch.NativeErrorCode eq 2601 >
								El registro que desea insertar ya existe.
							<cfelse>
								<cfif len(trim(cfcatch.Detail))>
									<cfoutput>#cfcatch.Detail#</cfoutput>
								<cfelse>
									<cfoutput>#cfcatch.Message#</cfoutput>
								</cfif>
							</cfif>
						</cfif>	
					</cfif>

				</font>
			<br>&nbsp;
		</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr> 
		<td>&nbsp;</td>
		<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder">&nbsp;</td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lrborder">
			<div align="center">
				<cfif isdefined("Regresar") and len(trim(Regresar))>
					<input type="button" name="Button" value="Regresar" onClick="javascript:location.href='<cfoutput>#Regresar#</cfoutput>'">
				<cfelse>
					<input type="button" name="Button" value="Regresar" onClick="javascript:history.back()">
				</cfif>
			</div>
		</td>
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td colspan="2" align="center" valign="middle" nowrap bgcolor="#F5F5F5" class="contenido-lbrborder">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
		<td>&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
		<td>&nbsp;</td>
	</tr>

</table>
</body>
</html>
