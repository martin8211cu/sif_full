<cfset ExisteEnvio = 0>
<cfif ExisteCuenta>
	
	<cfquery name="rsPersona" datasource="#Attributes.Conexion#">
		select rtrim(Pfax) as Pfax, rtrim(Pemail) as Pemail
		from 
		<cfif isdefined("Attributes.Ltipo") and Attributes.Ltipo EQ "P">
			ISBpersona
			Where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
		<cfelse>
			ISBlocalizacion
			Where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefId#">	
			And Ltipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Ltipo#">	
		</cfif>
	</cfquery>
	
	<cfquery name="rsPrecargaDir" datasource="#Attributes.Conexion#">
		select   Pdireccion,LCid,Papdo,CPid,Pbarrio 
		from 		
		<cfif isdefined("Attributes.Ltipo") and Attributes.Ltipo EQ "P">
			ISBpersona
			Where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
		<cfelse>
			ISBlocalizacion
			Where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefId#">	
			And Ltipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Ltipo#">	
		</cfif>
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
		select
			CTid, CTtipoEnvio, CTatencionEnvio, CTdireccionEnvio, CTapdoPostal, CTcopiaModo, CTcopiaDireccion, CTcopiaDireccion2, CTcopiaDireccion3, CPid, LCid, CTbarrio
		from ISBcuentaNotifica 
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.CTid#">
	</cfquery>
	
	<cfif rsEnvioCuenta.RecordCount GT 0>
		<cfset ExisteEnvio = 1>
	</cfif>

<cfif isdefined('rsCuenta') and ListFind('1,3',rsCuenta.Habilitado)>
		<!--- Se muestra el  resumen no se puede modificar la cuenta--->
		<cfinclude template="cuenta-resumen-envio.cfm">	
<cfelse>	

	<cfoutput>
		<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
		<input type="hidden" name="CTid#Attributes.sufijo#" value="<cfif ExisteCuenta>#rsCuenta.CTid#</cfif>">
		<input type="hidden" name="emailsug#Attributes.sufijo#" value="<cfif ExisteEnvio and rsEnvioCuenta.CTcopiaModo EQ "E" and Len(Trim(rsEnvioCuenta.CTcopiaDireccion))>#HtmlEditFormat(rsEnvioCuenta.CTcopiaDireccion)#<cfelseif ExisteCuenta>#HtmlEditFormat(rsLogin.Pemail)#</cfif>" />
		<input type="hidden" name="faxsug#Attributes.sufijo#" value="<cfif ExisteEnvio and rsEnvioCuenta.CTcopiaModo EQ "F" and Len(Trim(rsEnvioCuenta.CTcopiaDireccion))>#HtmlEditFormat(rsEnvioCuenta.CTcopiaDireccion)#<cfelseif ExisteCuenta>#HtmlEditFormat(rsPersona.Pfax)#</cfif>" />
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  
		  <tr align="center">
			<td colspan="6" class="subTitulo"><strong>Mecanismo de Env&iacute;o</strong></td>
		  </tr>
	
		  <tr>
			<td width="104" align="#Attributes.alignEtiquetas#" nowrap><label>Tipo de Env&iacute;o</label></td>
			<td colspan="2">
				<select name="CTtipoEnvio#Attributes.sufijo#" onchange="javascript: mostrarTipoenvio();" tabindex="1">
					<option value="1" <cfif ExisteEnvio and rsEnvioCuenta.CTtipoEnvio EQ "1">selected</cfif>>Apartado Postal</option>
					<option value="2" <cfif ExisteEnvio and rsEnvioCuenta.CTtipoEnvio EQ "2">selected</cfif>>Direcci&oacute;n F&iacute;sica</option>
				</select>
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Enviar copia a</label></td>
			<td colspan="2" >
				<select name="CTcopiaModo#Attributes.sufijo#" onchange="javascript: mostrarCopia();" tabindex="1">
					<option value="S" <cfif ExisteEnvio and rsEnvioCuenta.CTcopiaModo EQ "S">selected</cfif>>Sin Copia</option>
					<option value="E" <cfif ExisteEnvio and rsEnvioCuenta.CTcopiaModo EQ "E">selected</cfif>>E-mail</option>
					<!---<option value="F" <cfif ExisteEnvio and rsEnvioCuenta.CTcopiaModo EQ "F">selected</cfif>>Fax</option>--->
				</select>
			</td>
		  </tr>
	
		  <tr id="AP#Attributes.sufijo#">
			<td id="ApdoPostal#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>Apdo Postal</label></td>
			<td id="CodigoPostal#Attributes.sufijo#" style="display:none" align="#Attributes.alignEtiquetas#" nowrap><label>Zona Postal</label></td>
			<td colspan="5">
				
				<cfif ExisteEnvio <!---and rsEnvioCuenta.CTtipoEnvio EQ "1"---> 
					and isdefined("rsEnvioCuenta.CPid") and len(trim(rsEnvioCuenta.CPid))>
					
					<cfif len(trim(rsEnvioCuenta.CTapdoPostal)) EQ 0>
						<cfset rsEnvioCuenta.CTapdoPostal = "''">
					</cfif>
					<cfquery name="rsApdo" datasource="#Attributes.Conexion#">
						select #rsEnvioCuenta.CPid# as CPid, #rsEnvioCuenta.CTapdoPostal# as Papdo
					</cfquery>
					
					<cf_apdopostal
						query="#rsApdo#"
						pais = "#session.saci.pais#"
						form = "#Attributes.form#"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
						sufijo="#Attributes.sufijo#"
					> 
				
				<cfelseif len(trim(rsPrecargaDir.CPid))>
					<cfif len(trim(rsPrecargaDir.Papdo)) EQ 0> <cfset rsPrecargaDir.Papdo = "''"> </cfif>
					<cfquery name="rsApdo" datasource="#Attributes.Conexion#">
						select #rsPrecargaDir.CPid# as CPid, #rsPrecargaDir.Papdo# as Papdo
					</cfquery>
					<cf_apdopostal
						query="#rsApdo#"
						pais = "#session.saci.pais#"
						form = "#Attributes.form#"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
						sufijo="#Attributes.sufijo#"
					>
				
				<cfelse>	
					<cf_apdopostal
						pais = "#session.saci.pais#"
						form = "#Attributes.form#"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
						sufijo= "#Attributes.sufijo#"
					>
				</cfif>
				
			</td>
		  </tr>
		  
		  <tr id="AT#Attributes.sufijo#">
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Atenci&oacute;n a</label></td>
			<td colspan="5" >
				<input type="text" style="width: 100%" onblur="javascript: validaBlancos(this); this.value = this.value.toUpperCase();" name="CTatencionEnvio#Attributes.sufijo#" value="<cfif ExisteEnvio>#HTMLEditFormat(rsEnvioCuenta.CTatencionEnvio)#</cfif>" tabindex="1"/>
			</td>
		  </tr>
		 
		  <tr id="LC#Attributes.sufijo#">
			<td colspan="6">
				
				<cfif len(trim(rsPrecargaDir.LCid))>
					<cfset idlocalidad= rsPrecargaDir.LCid>
				<cfelse>
					<cfset idlocalidad= "">
				</cfif>
				
				<cfif ExisteEnvio and rsEnvioCuenta.CTtipoEnvio EQ "2">
					<cfif len(trim(rsEnvioCuenta.LCid))>
						<cfset idlocalidad= rsEnvioCuenta.LCid>
					</cfif>
				</cfif>
				
				<cf_localidad 
					id="#idlocalidad#"
					pais = "#session.saci.pais#"
					form = "#Attributes.form#"
					porFila = "true"
					incluyeTabla = "true"
					width = "100"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
					sufijo="#Attributes.sufijo#"	
				>
			</td>
		  </tr>
		  
		  <tr id="BA#Attributes.sufijo#">
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Barrio</label></td>
			<td colspan="5"><!---style="width: 100%"--->
				<input type="text" size="104" name="CTbarrio#Attributes.sufijo#" onblur="javascript: validaBlancos(this); this.value = this.value.toUpperCase();" maxlength="80" value="<cfif ExisteEnvio>#HTMLEditFormat(rsEnvioCuenta.CTbarrio)#<cfelse>#rsPrecargaDir.Pbarrio#</cfif><!---<cfif ExisteEnvio and len(trim(rsEnvioCuenta.CTbarrio))>#HTMLEditFormat(rsEnvioCuenta.CTbarrio)#</cfif>--->" tabindex="1"/>
			</td>
		  </tr>
		  
		  <tr id="DI#Attributes.sufijo#">
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Direcci&oacute;n</label></td>
			<td colspan="5"><!---style="width: 100%"--->
				<input type="text" size="104" name="CTdireccionEnvio#Attributes.sufijo#" onblur="javascript: validaBlancos(this); this.value = this.value.toUpperCase();" maxlength="256" value="<cfif ExisteEnvio><cfif len(trim(rsEnvioCuenta.CTdireccionEnvio)) GT 0>#HTMLEditFormat(rsEnvioCuenta.CTdireccionEnvio)#<cfelse>#rsPrecargaDir.Pdireccion#</cfif></cfif>" tabindex="1"/>
			</td>
		  </tr>
		  
		  <tr id="CD1#Attributes.sufijo#">
			<td id="fax1#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>Fax 1</label></td>
			<td id="ema1#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>E-mail 1</label></td>
			<td colspan="5">
				<input type="text" style="width: 100%"  maxlength="50"  name="CTcopiaDireccion#Attributes.sufijo#" value="<cfif ExisteEnvio and (rsEnvioCuenta.CTcopiaModo EQ "F" or rsEnvioCuenta.CTcopiaModo EQ "E")>#HTMLEditFormat(rsEnvioCuenta.CTcopiaDireccion)#</cfif>" tabindex="1"/>
			</td>
		  </tr>

		  <tr id="CD2#Attributes.sufijo#">
			<td id="fax2#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>Fax 2</label></td>
			<td id="ema2#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>E-mail 2</label></td>
			<td colspan="5">
				<input type="text" style="width: 100%"  maxlength="50"  name="CTcopiaDireccion2#Attributes.sufijo#" value="<cfif ExisteEnvio and (rsEnvioCuenta.CTcopiaModo EQ "F" or rsEnvioCuenta.CTcopiaModo EQ "E")>#HTMLEditFormat(rsEnvioCuenta.CTcopiaDireccion2)#</cfif>" tabindex="1"/>
			</td>
		  </tr>

		  <tr id="CD3#Attributes.sufijo#">
			<td id="fax3#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>Fax 3</label></td>
			<td id="ema3#Attributes.sufijo#" align="#Attributes.alignEtiquetas#" nowrap><label>E-mail 3</label></td>
			<td colspan="5">
				<input type="text" style="width: 100%"  maxlength="50"  name="CTcopiaDireccion3#Attributes.sufijo#" value="<cfif ExisteEnvio and (rsEnvioCuenta.CTcopiaModo EQ "F" or rsEnvioCuenta.CTcopiaModo EQ "E")>#HTMLEditFormat(rsEnvioCuenta.CTcopiaDireccion3)#</cfif>" tabindex="1"/>
			</td>
		  </tr>
		  
		</table>
		
		<script language="javascript1.2" type="text/javascript">
	
			function mostrarTipoenvio(radio){
				var tipo = document.#Attributes.form#.CTtipoEnvio#Attributes.sufijo#.value;
				if(tipo == '1'){
					
					document.getElementById("guion#Attributes.sufijo#").style.display="";
					document.getElementById("apartado#Attributes.sufijo#").style.display="";				
					document.getElementById("AT#Attributes.sufijo#").style.display="";
					document.getElementById("AP#Attributes.sufijo#").style.display="";
					document.getElementById("LC#Attributes.sufijo#").style.display="none";
					document.getElementById("DI#Attributes.sufijo#").style.display="none";
					document.getElementById("BA#Attributes.sufijo#").style.display="none";
					
					document.getElementById("ApdoPostal#Attributes.sufijo#").style.display="";
					document.getElementById("CodigoPostal#Attributes.sufijo#").style.display="none";
	
				}
				else if(tipo == '2'){										
					
					document.getElementById("ApdoPostal#Attributes.sufijo#").style.display="none";
					document.getElementById("CodigoPostal#Attributes.sufijo#").style.display="";
					
					
					document.getElementById("guion#Attributes.sufijo#").style.display="none";
					document.getElementById("apartado#Attributes.sufijo#").style.display="none";
					document.getElementById("AT#Attributes.sufijo#").style.display="none";
					document.getElementById("AP#Attributes.sufijo#").style.display="";
					document.getElementById("LC#Attributes.sufijo#").style.display="";
					document.getElementById("DI#Attributes.sufijo#").style.display="";
					document.getElementById("BA#Attributes.sufijo#").style.display="";
				} 
			}
			mostrarTipoenvio();
			
			function mostrarCopia() {
				var modo = document.#Attributes.form#.CTcopiaModo#Attributes.sufijo#.value;
				if (modo == "E") {
					document.getElementById("CD1#Attributes.sufijo#").style.display="";
					document.getElementById("CD2#Attributes.sufijo#").style.display="";
					document.getElementById("CD3#Attributes.sufijo#").style.display="";
					document.getElementById("ema1#Attributes.sufijo#").style.display="";
					document.getElementById("ema2#Attributes.sufijo#").style.display="";
					document.getElementById("ema3#Attributes.sufijo#").style.display="";
					document.getElementById("fax1#Attributes.sufijo#").style.display="none";
					document.getElementById("fax2#Attributes.sufijo#").style.display="none";
					document.getElementById("fax3#Attributes.sufijo#").style.display="none";
					document.#Attributes.form#.CTcopiaDireccion#Attributes.sufijo#.value = document.#Attributes.form#.emailsug#Attributes.sufijo#.value;
				}
				else if (modo == "F") {
					document.getElementById("CD1#Attributes.sufijo#").style.display="";
					document.getElementById("CD2#Attributes.sufijo#").style.display="";
					document.getElementById("CD3#Attributes.sufijo#").style.display="";
					document.getElementById("ema1#Attributes.sufijo#").style.display="none";
					document.getElementById("ema2#Attributes.sufijo#").style.display="none";
					document.getElementById("ema3#Attributes.sufijo#").style.display="none";
					document.getElementById("fax1#Attributes.sufijo#").style.display="";
					document.getElementById("fax2#Attributes.sufijo#").style.display="";
					document.getElementById("fax3#Attributes.sufijo#").style.display="";
					document.#Attributes.form#.CTcopiaDireccion#Attributes.sufijo#.value = document.#Attributes.form#.faxsug#Attributes.sufijo#.value;
				}
				else {
					document.getElementById("CD1#Attributes.sufijo#").style.display="none";
					document.getElementById("CD2#Attributes.sufijo#").style.display="none";
					document.getElementById("CD3#Attributes.sufijo#").style.display="none";
					document.#Attributes.form#.CTcopiaDireccion#Attributes.sufijo#.value = '';
					document.#Attributes.form#.CTcopiaDireccion2#Attributes.sufijo#.value = '';
					document.#Attributes.form#.CTcopiaDireccion3#Attributes.sufijo#.value = '';
				}
				
			}
			mostrarCopia();
		
		</script>
	</cfoutput>
</cfif>
</cfif>
