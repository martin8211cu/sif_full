<cfif Not IsDefined("request.PORTLET_PUBICA")>
<cfset request.PORTLET_PUBICA=1>

<cfif isdefined("Session.datos_personales.NOMBRE") and Len(trim(Session.Usucodigo)) GT 0>
		
	<cfoutput>
			
		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
			<tr><td align="center" class="etiqwhite16">#session.enombre#</td>
			<tr><td align="center" class="etiqwhite16">#session.datos_personales.NOMBRE#&nbsp;#session.datos_personales.APELLIDO1#&nbsp;#session.datos_personales.APELLIDO2#</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="100%" align="center" nowrap><cfinclude template="login-form2.cfm"></td>
			</tr>
		</table>
			
	</cfoutput>
</cfif>

</cfif>