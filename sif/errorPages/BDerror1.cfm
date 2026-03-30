<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Problema  en la Operaci&oacute;n
	</cf_templatearea>
	
	<cf_templatearea name="body" >
	

								
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&nbsp;'>
		<cftransaction action="rollback">

		
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr> 
				<td width="24%">&nbsp;</td>
				<td colspan="5" nowrap="nowrap">&nbsp;</td>
			</tr>
			<tr > 
				<td>&nbsp;</td>
				
				<cfif not isdefined('url.errTitle')>
					<cfset #url.errTitle#="Error">
				</cfif>
				
				<cfif not isdefined('url.errMsg')>
					<cfset #url.errMsg#="Por favor revise los siguiente errores:">
				</cfif>
			
				<cfif isdefined ('url.errType')>
						<cfif url.errType eq 0><!--- mensaje de error--->
							<td bgcolor="#003366" background="/cfmx/sif/imagenes/tab_unselected_bg5.gif"><font color="#FFFFFF"><img src="/cfmx/sif/imagenes/Stop01_T.gif" width="25" height="25"></font></td>
						<cfelseif url.errType eq 1><!--- mensaje informativo o advertencia--->
							<td bgcolor="#003366" background="/cfmx/sif/imagenes/tab_unselected_bg5.gif"><font color="#FFFFFF"><img src="/cfmx/sif/imagenes/info.png" width="25" height="25"></font></td>
						</cfif>
				<cfelse>
							<td bgcolor="#003366" background="/cfmx/sif/imagenes/tab_unselected_bg5.gif"><font color="#FFFFFF"><img src="/cfmx/sif/imagenes/Stop01_T.gif" width="25" height="25"></font></td>		
				</cfif>
				
				<td width="50%" bgcolor="#003366" background="/cfmx/sif/imagenes/tab_unselected_bg5.gif" ><div align="left"><font color="#FFFFFF">&nbsp;<strong><font size="3"><cfoutput>#url.errTitle#</cfoutput></font></strong></font></div></td>
				<!---<td width="15%">&nbsp;</td>--->
			</tr>
		
			<tr > 
				<td>&nbsp;</td>
				<td width="1%" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right">&nbsp;</div></td>
				<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder" >
					<br>
						<font color="#FF3300" size="2">
							<cfif isdefined('url.errMsg')>
								<b><cfoutput>#URLDecode(url.errMsg)#</cfoutput></b><br><br>
							</font>		
							<font color="#000000" size="2">
								<cfif isdefined("url.errDet")>
									<cfoutput>#url.errDet#</cfoutput>
								</cfif>
							<cfelseif isdefined("cfcatch.Detail")>
								<cfif isdefined("session.debug") and session.debug eq true >
									<cfoutput>#cfcatch.Detail#</cfoutput>
								<cfelse>
									<cfif isdefined('cfcatch.NativeErrorCode') and (cfcatch.NativeErrorCode eq 547 or cfcatch.NativeErrorCode eq 2292) >
										El registro no puede ser eliminado, pues posee dependencias con otros datos.
									<cfelseif isdefined('cfcatch.NativeErrorCode') and cfcatch.NativeErrorCode eq 2601 >
										El registro que desea insertar ya existe.
									<cfelse>
										<cfoutput>#cfcatch.Message#</cfoutput>
										<cfif len(trim(cfcatch.Detail))>
											<br><cfoutput>#cfcatch.Detail#</cfoutput>
											<cfif FindNoCase("If the component name", cfcatch.Detail)>
											
											<cfdump var="#cfcatch.TagContext#">
											</cfif>
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
						<cfelseif isdefined('url.Regresar') and Len(Trim(Url.Regresar))>
							<input type="button" name="Button" value="Regresar" onClick="javascript:location.href='<cfoutput>#Url.Regresar#</cfoutput>'">
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
		
		</cf_web_portlet>
				
	</cf_templatearea>
</cf_template>
