<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td style="text-align:justify">
		Digitar el nuevo n&uacute;mero telef&oacute;nico para el login actual.  
	</td>
  </tr>
  <tr>
	<td>
		<cf_web_portlet_start tipo="box">
			<cfif LoginBloqueado>
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td align="center"><label style="color:##660000">#mensArr[5]#</label></td></tr>
				</table>
			<cfelseif not ExisteACCS>
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td align="center"><label style="color:##660000">#mensArr[15]#</label></td></tr>
				</table>
			<cfelse>	
				<table class="cfmenu_menu" width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<cfif Attributes.permiteTel>
								<cf_cambioTelefono
									cuentaid="#Attributes.idcuenta#"
									contratoid="#Attributes.idcontrato#"
									loginid="#Attributes.idlogin#"
									cliente="#Attributes.idpersona#"
									porFilas="true">							
							<cfelse>
									<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
										<tr><td align="center">
											<label style="color:##660000">
												<cfoutput>
													#mensArr[16]#													
												</cfoutput>
											</label>
										</td></tr>
									</table>
							</cfif>
						</td>
					</tr>
				</table>
			</cfif>
		<cf_web_portlet_end> 
	</td>
  </tr>
</table>
</cfoutput>