<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
		<cftransaction action="rollback">
		
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  </td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5"><cfoutput></cfoutput></font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
           </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&nbsp;'>
	
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td width="24%">&nbsp;</td>
		<td colspan="3">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="8%" bgcolor="#003366" ><font color="#FFFFFF"><img src="/cfmx/rh/imagenes/Stop01_T.gif" width="25" height="25"></font></td>
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
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->