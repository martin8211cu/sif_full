<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td style="text-align:justify">
		Especificar el nuevo Real Name que desea.
	</td>
  </tr>
  <tr>
	<td>
		<cf_web_portlet_start tipo="Box">
			<cfif LoginBloqueado>
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td align="center"><label style="color:##660000">#mensArr[5]#</label></td></tr>
				</table>
			<cfelseif not ExisteMail>
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td align="center"><label style="color:##660000">#mensArr[14]#</label></td></tr>
				</table>
			<cfelse>			
				<table class="cfmenu_menu" width="100%" cellpadding="0" cellspacing="0" border="0">
				  <tr>
					<td>
						<cf_cambioRealName
						cuentaid="#Attributes.idcuenta#"
						contratoid="#Attributes.idcontrato#"
						loginid="#Attributes.idlogin#" 
						cliente="#Attributes.idpersona#"
						porFilas="true"
						>
					</td>
				  </tr>
				</table>
			</cfif>
		<cf_web_portlet_end> 
	</td>
  </tr>
</table>
</cfoutput>