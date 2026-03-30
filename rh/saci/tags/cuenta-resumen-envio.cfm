<cfset ExisteEnvio = 0>
<cfif ExisteCuenta>
	<cfquery name="rsPersona" datasource="#Attributes.Conexion#">
		select rtrim(Pfax) as Pfax, rtrim(Pemail) as Pemail
		from ISBpersona
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
	</cfquery>

	<cfquery name="rsLogin" datasource="#Attributes.Conexion#">
		select rtrim(a.LGlogin) || '@racsa.co.cr' as Pemail
		from ISBlogin a
			inner join ISBproducto b
				on b.Contratoid = a.Contratoid
				and b.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.CTid#">
			inner join ISBserviciosLogin c
				on c.LGnumero = a.LGnumero
				and c.TScodigo = 'MAIL'
		order by b.Contratoid
	</cfquery>
	
	<cfquery name="rsEnvioCuenta" datasource="#Attributes.Conexion#">
		select CTid, CTtipoEnvio, CTatencionEnvio, CTdireccionEnvio, CTapdoPostal, CTcopiaModo, CTcopiaDireccion, CTcopiaDireccion2, CTcopiaDireccion3, CPid, LCid, CTbarrio 
		from ISBcuentaNotifica 
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.CTid#">
	</cfquery>
	
	
	 
	<cfif rsEnvioCuenta.RecordCount GT 0>
		<cfset ExisteEnvio = 1>
	</cfif>

	<cfoutput>
		<table width="100%" border="0" cellspacing="2" cellpadding="2">
			<cfif ExisteEnvio>
					<tr>
						<td width="15%" align="#Attributes.alignEtiquetas#" nowrap><label>Tipo de Env&iacute;o</label></td>
						<td colspan="2" >
							<cfif rsEnvioCuenta.CTtipoEnvio EQ "1">Apartado Postal
							<cfelseif rsEnvioCuenta.CTtipoEnvio EQ "2">Direcci&oacute;n F&iacute;sica
							<cfelse>&lt;No Especificado&gt;
							</cfif>
						</td>
						<td align="#Attributes.alignEtiquetas#" nowrap><label>Enviar copia a</label></td>
						<td colspan="2" >
							<cfif rsEnvioCuenta.CTcopiaModo EQ "N">No enviar
							<cfelseif rsEnvioCuenta.CTcopiaModo EQ "E">E-mail
							<cfelseif rsEnvioCuenta.CTcopiaModo EQ "F">Fax
							<cfelse>&lt;No Especificado&gt;
							</cfif>
						</td>
					</tr>
					
					<cfif rsEnvioCuenta.CTtipoEnvio EQ "1">			
					<tr><td align="#Attributes.alignEtiquetas#" nowrap><label>Apdo Postal</label></td>
						<td colspan="5">
							<cfif isdefined("rsEnvioCuenta.CPid") and len(trim(rsEnvioCuenta.CPid))>
								<cfif len(trim(rsEnvioCuenta.CTapdoPostal)) EQ 0>
									<cfset rsEnvioCuenta.CTapdoPostal = "'0000'">
								</cfif>
								#rsEnvioCuenta.CTapdoPostal#-#rsEnvioCuenta.CPid#
							<cfelse>
								&lt;No Especificado&gt;
							</cfif>
					</td></tr>
					</cfif>	
					<cfif rsEnvioCuenta.CTtipoEnvio EQ "1">  <!--- Se debe mostrar si la forma de envió es apartado --->
					<tr>
						<td align="#Attributes.alignEtiquetas#" nowrap><label>Atenci&oacute;n a</label></td>
						<td colspan="5">
							<cfif len(trim(rsEnvioCuenta.CTatencionEnvio))>
								#rsEnvioCuenta.CTatencionEnvio#
							<cfelse>
								&lt;No Especificado&gt;
							</cfif>
						</td>
					</tr>
					</cfif>
					<cfif rsEnvioCuenta.CTtipoEnvio EQ "2">		 
							<cfset idlocalidad= rsEnvioCuenta.LCid>
							<cf_localidad 
								id="#idlocalidad#"
								pais = "#session.saci.pais#"
								form = "#Attributes.form#"
								porFila = "false"
								incluyeTabla = "false"
								Ecodigo = "#Attributes.Ecodigo#"
								Conexion = "#Attributes.Conexion#"
								readOnly="true">	
					  
					<tr>
						<td align="#Attributes.alignEtiquetas#" nowrap><label>Barrio</label></td>
						<td colspan="5">
							<cfif len(trim(rsEnvioCuenta.CTbarrio))>
								#rsEnvioCuenta.CTbarrio#
							<cfelse>
								&lt;No Especificado&gt;
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="#Attributes.alignEtiquetas#" nowrap><label>Direcci&oacute;n</label></td>
						<td colspan="5">
							<cfif len(trim(rsEnvioCuenta.CTdireccionEnvio))>
								#rsEnvioCuenta.CTdireccionEnvio#
							<cfelse>
								&lt;No Especificado&gt;
							</cfif>
						</td>
					</tr>
					</cfif>  
					<tr>
						
						<cfif len(trim(rsEnvioCuenta.CTcopiaModo)) and rsEnvioCuenta.CTcopiaModo NEQ "S">
							<cfif rsEnvioCuenta.CTcopiaModo EQ "F">
							<td id="fax" align="#Attributes.alignEtiquetas#" nowrap><label>Fax</label></td>
							<cfelseif rsEnvioCuenta.CTcopiaModo EQ "E" >
							<td id="ema" align="#Attributes.alignEtiquetas#" nowrap><label>E-mail</label></td>
							</cfif>
							<td>
								<cfif len(trim(rsEnvioCuenta.CTcopiaDireccion))>
									#rsEnvioCuenta.CTcopiaDireccion#
								<cfelse>
									&lt;No Especificado&gt;
								</cfif>
							</td>
							
							<cfif rsEnvioCuenta.CTcopiaModo EQ "E">
								<td id="ema" align="#Attributes.alignEtiquetas#" nowrap><label>E-mail 2</label></td>									
									<td>
									<cfif len(trim(rsEnvioCuenta.CTcopiaDireccion2))>
										#rsEnvioCuenta.CTcopiaDireccion2#
									<cfelse>
										&lt;No Especificado&gt;
									</cfif>
									</td>
								</td>
							</cfif>


						</cfif>
					</tr>
			<cfelse>
					<tr><td align="center">&lt;No Especificado&gt;</td></tr>
			</cfif>
		</table>
	</cfoutput>
</cfif>
