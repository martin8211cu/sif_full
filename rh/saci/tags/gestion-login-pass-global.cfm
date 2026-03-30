<cfoutput>
		<table width="100%" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="text-align:justify">
				<cfif form.rol EQ "DAS">
					#mensArr[7]#
				<cfelse>
					Especificar el nuevo password v&aacute;lido para todos los servicios que posee el login actual.
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td>
				<cf_web_portlet_start tipo="Box">
					<cfif LoginSinServicios>
						<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr><td align="center"><label style="color:##660000">#mensArr[4]#</label></td></tr>
						</table>
					<cfelseif LoginBloqueado>
						<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr><td align="center"><label style="color:##660000">#mensArr[5]#</label></td></tr>
						</table>
					<cfelse>
						<cfif form.rol NEQ "DAS">	
							<table class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
								<tr>
									<td align="right"><label><cf_traducir key="clave">Contrase&ntilde;a</cf_traducir></label></td>
									<td><cf_password
											name="SLpassword#Attributes.sufijo#"
											size="30"
											maxlength="30"
											form="#Attributes.form#"
											etiqueta="Password"
											idpersona="#Attributes.idpersona#"
											user="#Attributes.user#"
										>
									</td>
								</tr><tr>
									<td align="right"><label><cf_traducir key="confirmar">Confirmar</cf_traducir></label></td>
									<td><cf_password
											name="SLpassword2#Attributes.sufijo#"
											size="30"
											maxlength="30"
											form="#Attributes.form#"
											etiqueta="Confirmar"
											idpersona="#Attributes.idpersona#"
											user="#Attributes.user#"
										>
									</td>
									
								</tr>
							</table>
						
						<cfelse>	
							<table class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
								<tr>
									<td align="center" colspan="2"><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
								</tr>
								<tr>
									<td  colspan="2" align="center">
										<table border="0" cellpadding="0" cellspacing="0">
											<cfloop query="rsServicios">
												<cfif #rsServicios.TScodigo# neq "CABM">
													<tr><td>#rsServicios.TScodigo#</td></tr>
												</cfif>
											</cfloop>
										</table>
									</td>
								</tr>
								<cfif len(trim(PasswordProbicional))>
									<tr><td align="center" colspan="2"><label><cf_traducir key="nuevo">Nuevo</cf_traducir></label></td></tr>
									<tr>
										<td align="center" colspan="2">#PasswordProbicional#</td>
									</tr>
								</cfif>
							</table>
						</cfif>
					</cfif>
				<cf_web_portlet_end> 
			</td>
			<cfif isdefined("Attributes.mens") and len(trim(Attributes.mens))>
				<cfif Attributes.mens EQ 3 or Attributes.mens EQ 4>
				<tr><td colspan="2" align="center">
					<label style="color:##660000">#mensArr[Attributes.mens]#<cfif len(trim(PasswordProbicional))><br />#mensArr[8]#</cfif></label>
				</td></tr>
				</cfif>
			</cfif>
		  </tr>
		</table>
</cfoutput>
