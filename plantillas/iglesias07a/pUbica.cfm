<cfif Not IsDefined("request.PORTLET_PUBICA")>
<cfset request.PORTLET_PUBICA=1>

<cfif isdefined("Session.datos_personales.NOMBRE") and Len(trim(Session.Usucodigo)) GT 0>
		
	<cfoutput>
			
		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
			<tr><td> <div align="center" class="style81"><strong><font size="2" face="Verdana">#session.enombre#</font></strong></div></td>
			<tr><td><div align="center" class="style81"><strong><font size="2" face="Verdana">
				#session.datos_personales.NOMBRE#&nbsp;#session.datos_personales.APELLIDO1#&nbsp;#session.datos_personales.APELLIDO2#
			</font></strong></div>
			</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="100%" align="center" nowrap><cfinclude template="login-form2.cfm"></td>
			</tr>
		</table>
			
	</cfoutput>
</cfif>

</cfif>