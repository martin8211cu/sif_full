<cfset req = GetHTTPRequestData().headers>

<cfset _Error_Server = CGI.SERVER_NAME & ":" & CGI.SERVER_PORT>
<cfif StructKeyExists(req,"X-Forwarded-Host")>
	<cfset _Error_Server = req["X-Forwarded-Host"]>
</cfif>
<cfif Len(_Error_Server) EQ 0>
	<cfset _Error_Server = req["Host"]>
</cfif>

<cfset _Error_IPAddress = CGI.REMOTE_ADDR>
<cfif StructKeyExists(req,"X-Forwarded-For")>
	<cfset _Error_IPAddress = req["X-Forwarded-For"]>
</cfif>
<cfif Len(_Error_IPAddress) EQ 0>
	<cfset _Error_IPAddress = req["Host"]>
</cfif>

<cfset _Error_Login = "anonymous">
<cfif IsDefined("session.Usuario")>
	<cfset _Error_Login = session.Usuario>
</cfif>

<cfset _Error_URL = "//" & _Error_Server & CGI.SCRIPT_NAME >
<cfif Len(CGI.QUERY_STRING)>
	<cfset _Error_URL = _Error_URL & "?" & CGI.QUERY_STRING>
</cfif>
<cfoutput>
<strong>url: </strong>#_Error_URL#<br>
<strong>IP: </strong>#_Error_IPAddress#<br>
<strong>Login: </strong>#_Error_Login#
</cfoutput>


<cfabort>

<cfquery datasource="aspmonitor">

insert MonErrores (componente, titulo, cuando, ip, url, login, detalle, detalle_extra)
values (
	<cfqueryparam cfsqltype="cf_sql_varchar" value="coldfusion">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Error.Message#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Error.DateTime#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#_Error_IPAddress#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#_Error_URL#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#_Error_Login#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Error.Diagnostics#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Error.Diagnostics#" null="yes">

)
</cfquery>



<cf_template>
<cf_templatearea name="title">
	Reporte de Error
	</cf_templatearea>
<cf_templatearea name="left"></cf_templatearea>
<cf_templatearea name="body">

		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Error'>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td width="24%">&nbsp;</td>
		<td colspan="3">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="8%" bgcolor="#003366" ><font color="#FFFFFF"><img src="/imagenes/Stop01_T.gif" width="25" height="25"></font></td>
		<td width="49%" bgcolor="#003366" ><div align="left"><font color="#FFFFFF">&nbsp;<strong><font size="3">Mensaje</font></strong></font></div></td>
		<td width="15%">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="1%" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right">&nbsp;</div></td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">
			<br>
			<cfdump var="#error#">
				<font color="#FF3300" size="2">
				<cfif isdefined('Error.RootCause.NativeErrorCode') and RootCause.NativeErrorCode eq 547 >
					El registro no puede ser eliminado, pues posee dependencias con otros datos.
				<cfelseif isdefined('Error.RootCause.NativeErrorCode') and RootCause.NativeErrorCode eq 2601 >
					El registro que desea insertar ya existe.
				<cfelse>
					<cfoutput>#Error.Diagnostics#</cfoutput>
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
		</cf_web_portlet>

</cf_templatearea>
</cf_template>
