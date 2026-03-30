<cf_templateheader title="Reasignaci&oacute;n de Cargas de Trabajo - Env&iacute;o de Correo ">
		
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset dataBuyerTo = sec.getUsuarioByRef(form.CMCid, session.EcodigoSDC, 'CMCompradores') >
		<cfset dataBuyerCc = sec.getUsuarioByRef(form.Comprador, session.EcodigoSDC, 'CMCompradores') >
		<cfset nameBuyerTo = dataBuyerTo.Pnombre & ' ' & dataBuyerTo.Papellido1 & ' ' & dataBuyerTo.Papellido2 >
		<cfset nameBuyerCc = dataBuyerCc.Pnombre & ' ' & dataBuyerCc.Papellido1 & ' ' & dataBuyerCc.Papellido2 >
				
		<cfset usuarioEnvia = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#" >
		
		<script type="text/javascript" language="javascript1.2">
			function isEmail(s){
				return /^[\w\.-]+@[\w-]+(\.[\w-]+)+$/.test(s);
			}

			function validar(f){
				if (f.email.value.length < 5) {
					alert ("Por favor indique la dirección de Correo");
					return false;
				}

				if (confirm('Está seguro de que desea realizar la reasignación del comprador a la solicitud de compra seleccionada?')) {
					return true;
				} else {
					return false;
				}
				
				if (!isEmail(f.email.value)) {
					return confirm ("El correo que ha indicado no parece válido.  ¿Desea continuar?");
				}
				return true;
			}
		</script>

		<!---Verificar que si la solicitud de compra esta en multiples contratos no pueda reasignar---->
		<cfquery name="rsValidaMult" datasource="#session.DSN#">
			select count(1) as Existe
			from ESolicitudCompraCM a
				inner join DSolicitudCompraCM b
					on a.ESidsolicitud = b.ESidsolicitud
					and a.Ecodigo = b.Ecodigo
					
					inner join DSProvLineasContrato c
						on b.DSlinea = c.DSlinea
						and b.Ecodigo = c.Ecodigo
			
			where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		</cfquery>
		<cfif rsValidaMult.Existe NEQ 0>
			<cf_errorCode	code = "50324" msg = "La solicitud de compra no puede ser reasignada porque se encuentra en múltiples contratos">
		</cfif>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reasignaci&oacute;n Cargas de Trabajo -  Envio de Correo'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
			
			<cfoutput>
				<form action="reasignarCargas-email-apply.cfm" name="form1" id="form1" method="post" onSubmit="javascript: return validar(this);">
					<cfloop collection="#Form#" item="i">
						<input type="hidden" name="#i#" id="#i#" value="#Form[i]#">
					</cfloop>
					<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap>
								<fieldset><legend><strong>Envío de Correo a Compradores&nbsp;</strong></legend>	
									<table width="90%" align="center">
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<img src="Reclamos-email.gif" width="37" height="12">&nbsp;&nbsp;Env&iacute;o de Informaci&oacute;n de Reasignaci&oacute;n de Cargas de Trabajo </td>
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
												<input size="60" type="text" name="email" id="email" onFocus="this.select()" value="#HTMLEditFormat(trim(dataBuyerTo.Pemail1))#">
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Cc:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" name="Ccemail" id="Ccemail" onFocus="this.select()" value="#HTMLEditFormat(trim(dataBuyerCc.Pemail1))#">&nbsp;Use punto y coma ';' como separador
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												<input size="60" type="text" readonly="" value="Reasignaci&oacute;n de Cargas de Trabajo.">
											</td>
										</tr>
										<tr>
											<td colspan="3" class="subTitulo tituloListas" align="center">
												<input type="submit" name="btnEnviar" value="Confirmar Reasignación y Enviar Correo">
												<input type="button" name="btnCancelar" value="Cancelar" onClick="javascript: location.href='reasignarCargas.cfm';">
												<input type="hidden" name="nameBuyerTo" value="#nameBuyerTo#"> 
												<input type="hidden" name="nameBuyerCc" value="#nameBuyerCc#">  
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
						<tr><td nowrap>&nbsp;</td></tr>
					</table>
				</form>
			</cfoutput>
			<cfinclude template="reasignarCargas-Aviso.cfm">
			
		<cf_web_portlet_end>
	<cf_templatefooter>