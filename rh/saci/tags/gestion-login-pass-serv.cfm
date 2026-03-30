<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td style="text-align:justify">
			<cfif form.rol EQ "DAS">
				#mensArr[6]# 
			<cfelse>	
				Especificar el nuevo password por servicio que desea modificar.
			</cfif>
		</td>
  	</tr>
  	<tr>
	<td>
		
		<cfif not LoginSinServicios  and not LoginBloqueado>
			<cfquery name="rsServicios" datasource="#session.DSN#">
				select distinct  b.LGnumero,c.TScodigo   
				from ISBproducto a
					inner join  ISBlogin b
						on b.Contratoid = b.Contratoid
						and b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
						and b.Habilitado=1	
					inner join  ISBserviciosLogin c
						on c.LGnumero = c.LGnumero
						and c.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
						and  c.PQcodigo=a.PQcodigo
						and c.Habilitado=1
				where
					a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcuenta#">
					and a.Contratoid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
			</cfquery>
		</cfif>
		
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
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td align="right" width="30%"><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
						<td>
							<select name="TScodigo#Attributes.sufijo#" style="width:200" tabindex="1">
								<cfloop query="rsServicios">
									<cfif #rsServicios.TScodigo# neq "CABM">
										<option value="#rsServicios.TScodigo#">#rsServicios.TScodigo#</option>
									</cfif>
								</cfloop>
							</select>
						</td>
					</tr>
					<cfif form.rol NEQ "DAS">
							<cfloop query="rsServicios">
								<tr id="#rsServicios.TScodigo#">
									<td colspan="2">
										<table width="100%" cellpadding="2" cellspacing="0" border="0">	
										<tr><td align="right" width="30%"><label><cf_traducir key="anterior">Anterior</cf_traducir></label></td>
											<td>
												<cf_password
													name="Ant_#rsServicios.TScodigo##Attributes.sufijo#"
													size="30"
													maxlength="30"
													form="#Attributes.form#"
													etiqueta="Anterior"
													user="#Attributes.user#"
												>
											</td>
										</tr><tr>
											<td align="right"><label><cf_traducir key="nuevo">Nuevo</cf_traducir></label></td>
											<td>
												<cf_password
													name="pass_#rsServicios.TScodigo##Attributes.sufijo#"
													size="30"
													maxlength="30"
													form="#Attributes.form#"
													etiqueta="Nuevo"
													user="#Attributes.user#"
												>
											</td>
										</tr><tr>
											<td align="right"><label><cf_traducir key="confirmar">Confirmar</cf_traducir></label></td>
											<td>
												<cf_password
													name="pass2_#rsServicios.TScodigo##Attributes.sufijo#"
													size="30"
													maxlength="30"
													form="#Attributes.form#"
													etiqueta="Confirmar"
													user="#Attributes.user#"
												>
											</td>
										</tr>
									</table>
									</td>
								</tr>
							</cfloop>
					</cfif>
					<cfif len(trim(PasswordProbicional))>
						<tr><td align="right"><label><cf_traducir key="nuevo">Nuevo</cf_traducir></label></td>
							<td>#PasswordProbicional#</td>
						</tr>
					</cfif>
				</table>
			</cfif>
		<cf_web_portlet_end> 
	</td></tr>
	
 	<cfif isdefined("Attributes.mens") and len(trim(Attributes.mens))>
		<cfif Attributes.mens EQ 1 or Attributes.mens EQ 2>
		<tr><td colspan="2" align="center">
			<label style="color:##660000">#mensArr[Attributes.mens]#<cfif len(trim(PasswordProbicional))><br />#mensArr[8]#</cfif></label>
		</td></tr>
		</cfif>
  	</cfif>
</table>
	<script type="text/javascript" language="javascript">
		function aparecer(){
			var id="";
			for (i = 0; i < document.#Attributes.form#.TScodigo#Attributes.sufijo#.length; i++) {
				document.getElementById(document.#Attributes.form#.TScodigo#Attributes.sufijo#[i].value).style.display="none";
			}
			document.getElementById(document.#Attributes.form#.TScodigo#Attributes.sufijo#.value).style.display="";
		}
		<cfif form.rol NEQ "DAS">
		 aparecer();
		</cfif> 
	</script>
</cfoutput>