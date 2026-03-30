<cf_templateheader title="Reclamos - Env&iacute;o de Correo">
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset usuarioEnvia = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#" >
	<cfset dataUsuario = sec.getUsuarioByRef(form.CMCid, session.EcodigoSDC, 'CMCompradores') >

	<!---  Saca el Código de Socio, Número de Reclamo y el costo del Reclamo --->
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select 	a.SNcodigorec, 
				a.EDRnumero, 
				(b.DRcantorig - b.DRcantrec) * c.DDRpreciou as Monto,
				d.SNnombre  
		from 	EReclamos a 
				inner join DReclamos b
					on a.Ecodigo = b.Ecodigo
					and a.ERid = b.ERid
				inner join DDocumentosRecepcion c
					on b.Ecodigo = c.Ecodigo
					and b.DDRlinea = c.DDRlinea
				inner join SNegocios d
					on a.SNcodigo = d.SNcodigo
					and a.Ecodigo = d.Ecodigo	
		where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
			and c.DDRgenreclamo = 1
	</cfquery>
	<cfset dataSocio = sec.getUsuarioByRef(rsSocio.SNcodigorec, session.EcodigoSDC, 'SNegocios') >

	<script type="text/javascript" language="javascript1.2">
		function isEmail(s){
			return /^[\w\.-]+@[\w-]+(\.[\w-]+)+$/.test(s);
		}

		function validar(f){
			if (f.email.value.length < 5) {
				alert ("Por favor indique la dirección de Correo");
				return false;
			}
			if (!isEmail(f.email.value)) {
				return confirm ("El correo que ha indicado no parece válido.  ¿Desea continuar?");
			}
			return true;
		}
	</script>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reclamos -  Envio de Correo'>
		<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<!---  Empieza el pintado de la pantalla de Envio de Correo --->
		<cfoutput>
			<form action="reclamos-email-apply.cfm" name="form1" id="form1" method="post" onSubmit="return validar(this)">
				<input type="hidden" name="ERid" id="ERid" value="#HTMLEditFormat(form.ERid)#">
				<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
					
					<cfif form._CMCid NEQ form.CMCid AND form._SNcodigorec NEQ form.SNcodigorec>				
						<!--- Si Cambió el Comprador y el Proveedor, le manda un email notificandolos --->
						<cfset Comprador = dataUsuario.Pnombre & ' ' & dataUsuario.Papellido1 & ' ' & dataUsuario.Papellido2 >
						<cfset Proveedor = dataSocio.Pnombre & ' ' & dataSocio.Papellido1 & ' ' & dataSocio.Papellido2 >
						<cfset Pnombre = #Comprador# & ' y ' & #Proveedor#>
						
						<tr>
							<td nowrap>
								<fieldset><legend><strong>Envío de Correo al Comprador y al Proveedor&nbsp;</strong></legend>	
									<table width="90%" align="center">
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<img src="Reclamos-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o de Informaci&oacute;n de Reclamo 
											</td>
										</tr>
										<tr>
											<td nowrap><strong>De:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="#usuarioEnvia#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Para:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(trim(dataUsuario.Pemail1))#;#HTMLEditFormat(trim(dataSocio.Pemail1))#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Cc:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="Ccemail" id="Ccemail" onFocus="this.select()" value="#HTMLEditFormat(trim(dataUsuario.Pemail1))#;#HTMLEditFormat(trim(dataSocio.Pemail1))#">&nbsp;Use punto y coma ';' como separador
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="N&uacute;mero de Reclamo: #HTMLEditFormat(trim(rsSocio.EDRnumero))#  por  #NumberFormat(rsSocio.Monto,',0.00')# ">
											</td>
										</tr>
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<input type="submit" value="Enviar" name="btnEnviar">
												<input type="hidden" name="Pnombre" value="#Pnombre#"> 
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>

					<cfelseif form._CMCid NEQ form.CMCid>				
						<!--- Si Cambió el Comprador, le manda un email notificandolo --->
						<cfset Pnombre = dataUsuario.Pnombre & ' ' & dataUsuario.Papellido1 & ' ' & dataUsuario.Papellido2 >
						
						<tr>
							<td nowrap>
								<fieldset><legend><strong>Envío de Correo al Comprador&nbsp;</strong></legend>	
									<table width="90%" align="center">
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<img src="Reclamos-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o de Informaci&oacute;n de Reclamo 
											</td>
										</tr>
										<tr>
											<td nowrap><strong>De:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="#usuarioEnvia#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Para:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(trim(dataUsuario.Pemail1))#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Cc:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="Ccemail" id="Ccemail" onFocus="this.select()" value="#HTMLEditFormat(trim(dataUsuario.Pemail1))#">&nbsp;Use punto y coma ';' como separador
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="N&uacute;mero de Reclamo: #HTMLEditFormat(trim(rsSocio.EDRnumero))#  por  #NumberFormat(rsSocio.Monto,',0.00')# ">
											</td>
										</tr>
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<input type="submit" value="Enviar" name="btnEnviar">
												<input type="hidden" name="Pnombre" value="#Pnombre#"> 
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
								
					<cfelseif form._SNcodigorec NEQ form.SNcodigorec>
						<!--- Si Cambió el Proveedor, le manda un email notificandolo --->
						<cfset Pnombre = dataSocio.Pnombre & ' ' & dataSocio.Papellido1 & ' ' & dataSocio.Papellido2 >

						<tr>
							<td nowrap>
								<fieldset><legend><strong>Envío de Correo al Proveedor&nbsp;</strong></legend>	
									<table width="90%" align="center">
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<img src="Reclamos-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o de Informaci&oacute;n de Reclamo 
											</td>
										</tr>
										<tr>
											<td nowrap><strong>De:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="#usuarioEnvia#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Para:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(trim(dataSocio.Pemail1))#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Cc:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="Ccemail" id="Ccemail" onFocus="this.select()" value="#HTMLEditFormat(trim(dataSocio.Pemail1))#">&nbsp;Use punto y coma ';' como separador
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="N&uacute;mero de Reclamo: #trim(rsSocio.EDRnumero)#  por  #NumberFormat(rsSocio.Monto,',0.00')# ">
											</td>
										</tr>
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<input type="submit" value="Enviar" name="btnEnviar">
												<input type="hidden" name="Pnombre" value="#Pnombre#"> 
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
									
					</cfif>	
						
					<tr><td nowrap>&nbsp;</td></tr>
				</table>
			</form>
			<cfinclude template="reclamos-detalle.cfm">
			
		</cfoutput>
		
	<cf_web_portlet_end>
<cf_templatefooter>
