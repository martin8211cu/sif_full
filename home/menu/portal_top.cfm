<table width="392" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td width="382" height="33" align="right" valign="bottom"><span class="toprightitems">
		<a href="/cfmx/home/menu/micuenta/buzon.cfm">Mensajes</a> |
		<a href="/cfmx/home/menu/micuenta/index.cfm">Preferencias</a> | 
		<a href="/cfmx/plantillas/portal/observaciones.cfm">Obs</a> |
		<a href="/cfmx/home/menu/passch.cfm">Cambiar contrase&ntilde;a</a> |
		<a href="javascript:void(0)">?</a> | 
		<a href="/cfmx/home/public/logout.cfm">Salir</a> </span></td>
    <td width="10" align="right" valign="bottom">&nbsp;</td>
  </tr>
  <tr>
	<td height="27" align="right"><span class="toprightitems">
	  <cfif session.Usucodigo>
		<cfoutput>#session.Usulogin#, #session.CEnombre#</cfoutput>
	  </cfif>
	</span></td>
    <td align="right">&nbsp;</td>
  </tr>
</table>
