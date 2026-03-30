<!--- Nota:
	Esta plantilla de errores se creo para la parte del framework, pues hay mantenimientos 
	que se despliegan en iframes, y si se usa la plantilla normal de sif, entonces inserta
	todo la pantalla en el frame (menues, ubica...) y solo nos interesa la apre del error
--->

<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/portlets.css" rel="stylesheet" type="text/css">

<table width="60%" border="0" cellspacing="0" cellpadding="2" align="center">
	<tr align="center"> 
		<td width="8%" bgcolor="#003366" ><font color="#FFFFFF"><img src="/cfmx/sif/imagenes/Stop01_T.gif" width="25" height="25"><span class="titulo"></span></font></td>
		<td width="49%" bgcolor="#003366" ><div align="left"><font color="#FFFFFF">&nbsp;<strong><font size="3">Mensaje</font></strong></font></div></td>
	</tr>

	<tr align="center">  
		<td width="1%" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right">&nbsp;</div></td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder" nowrap>
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
	</tr>
	
	<tr align="center"> 
		<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder">&nbsp;</td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">&nbsp;</td>
	</tr>
	
	<tr align="center"> 
		<td colspan="2" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lrborder">
			<div align="center">
				<input type="button" name="Button" value="Regresar" onClick="javascript:history.back()">
			</div>
		</td>
	</tr>

	<tr align="center">
		<td colspan="2" align="center" valign="middle" nowrap bgcolor="#F5F5F5" class="contenido-lbrborder">&nbsp;</td>
	</tr>

	<tr align="center"> 
		<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
	</tr>

</table>
