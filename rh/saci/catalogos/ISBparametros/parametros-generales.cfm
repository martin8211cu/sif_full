<cfif not isdefined("Request.utilesMonto")>
	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<cfset Request.utilesMonto = true>
</cfif>

<cfquery datasource="#session.dsn#" name="motivosBloqueo">
	select MBmotivo, MBdescripcion
	from ISBmotivoBloqueo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Habilitado!=2
</cfquery>

<cfquery datasource="#session.dsn#" name="motivosBloqueoSinCompromiso">
	select MBmotivo, MBdescripcion
	from ISBmotivoBloqueo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 	  and Habilitado=1
	  and MBconCompromiso = 0
</cfquery>

<cfquery datasource="#session.dsn#" name="vendedores199">
	select Vid, Pnombre || ' ' || Papellido || ' ' || Papellido2 as nombre
	from ISBvendedor v
		join ISBpersona p
			on p.Pquien = v.Pquien
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and v.AGid = 199
</cfquery>

<cfoutput>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<form name="form1" method="post" action="parametros-apply.cfm" style="margin: 0;" onSubmit="javascript: return validaParams(this);">
		<cfinclude template="parametros-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['40']#:</label></td>
						<td>
							<cf_campoNumerico name="param_40" decimales="-1" size="30" maxlength="18" value="#HtmlEditFormat(Trim(paramValues['40']))#" tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Plazo máximo en días para la reserva de los nombres de login para los 
					productos inactivos. Los logines son los nombres familiares para acceder los 
					productos o servicios en las cuentas comercializadas, los cuales deben ser 
					únicos en el sistema, sin embargo debido a que corresponden a nombres 
					significativos para el usuario, algunos de ellos tendrán alta demanda, por lo 
					que resulta injusto para los clientes que permanezcan asociados a una cuenta 
					inhabilitada.  Ahora debido a que una simple inactivación no necesariamente es 
					irreversible, se establece unos días de gracia (este campo), durante los cuales 
					se respeta el nombre o login de la cuenta inactiva, cumplidos los cuales el 
					login asociado no será tomado en cuenta en la verificación de unicidad.
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"><hr></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['50']#:</label></td>
						<td>
							<input type="text" 
								name="param_50" 
								maxlength="255" 
								onBlur="javascript: quitaBlancos(this);"
							 	onKeyUp="javascript: this.value = trim(this.value); quitaComilla(event,this);"
								value="#HtmlEditFormat(Trim(paramValues['50']))#" 
								style="width: 100%" tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['223']#:</label></td>
						<td>
							<input type="text" 
								name="param_223" 
								maxlength="255" 
								onBlur="javascript: quitaBlancos(this);"
							 	onKeyUp="javascript: this.value = trim(this.value); quitaComilla(event,this);"
								value="#HtmlEditFormat(Trim(paramValues['223']))#" 
								style="width: 100%" tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Determina los caracteres válidos para la nomenclatura de logines y 
					otros elementos en el sistema para una empresa dada.
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"><hr></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['60']#:</label></td>
						<td>
							<input type="text" 
								name="param_60" 
								size="30" 
								maxlength="15" 
								onBlur="javascript: quitaBlancos(this);quitaInvalidChars(this);"
								onkeydown="javascript: this.value = trim(this.value); filtraCarac(event,this);"
								onKeyUp="javascript: this.value = trim(this.value); filtraCarac(event,this);"
								value="#HtmlEditFormat(Trim(paramValues['60']))#" 
								tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Formato de un número telefónico o de fax.
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"><hr></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['70']#:</label></td>
						<td>
							<select name="param_70" tabindex="1">
								<!---<option value=""></option>----->
								<option value="TACACS"<cfif paramValues['70'] EQ 'TACACS'> selected</cfif>>TACACS</option>
								<option value="RADIUS"<cfif paramValues['70'] EQ 'RADIUS'> selected</cfif>>RADIUS</option>
							</select>
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Este es un indicador del protocolo vigente en el registro de la ocurrencia del 
					tráfico para determinar con &eacute;l las reglas de interpretación de la hilera. Establece
					la forma de acceso a la bit&aacute;cora de seguridad.
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"><hr></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['80']#:</label></td>
						<td>
							<cf_campoNumerico name="param_80" decimales="-1" size="15" maxlength="2" value="#HtmlEditFormat(Trim(paramValues['80']))#" tabindex="1">
						</td>
					  </tr>
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['90']#:</label></td>
						<td>
							<cf_campoNumerico name="param_90" decimales="-1" size="15" maxlength="2" value="#HtmlEditFormat(Trim(paramValues['90']))#" tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Días del mes donde inicia y concluye el período donde se debe restringir el cambio 
					del tipo de cobro de las cuentas.
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"><hr></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['220']#:</label></td>
						<td>
							<cf_usuario
								id = "#HtmlEditFormat(Trim(paramValues['220']))#"
								form = "form1"
								funcion = "updParam220"
							>
							<input type="hidden" name="param_220" value="#HtmlEditFormat(Trim(paramValues['220']))#">
						</td>
					  </tr>
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['221']#:</label></td>
						<td>
							<select name="param_221" tabindex="1">
								<option value=""></option>
							<cfloop query="motivosBloqueo">
								<option value="#HTMLEditFormat( motivosBloqueo.MBmotivo )#"<cfif Trim(paramValues['221']) EQ Trim(motivosBloqueo.MBmotivo)> selected</cfif>>#HTMLEditFormat( motivosBloqueo.MBdescripcion )#</option>
								</cfloop>
							</select>
						</td>
					  </tr>		  
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Se refiere a el motivo de bloqueo que se realiza cuando expira las 24 hrs dadas
						posteriormente de una reprogramación de un login o restablecimiento de clave.
				</td>
				<td>&nbsp;</td>
			</tr>
	
<!----------------------------------------------------------PARAM[224]------------------------------------------------------------------->
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['224']#:</label></td>
						<td>
							<select name="param_224" tabindex="1">
								<!---<option value=""></option>----->
								<option value="SI"<cfif paramValues['224'] EQ 'SI'> selected</cfif>>SI</option>
								<option value="NO"<cfif paramValues['224'] EQ 'NO'> selected</cfif>>NO</option>
							</select>
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
				<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Se refiere a la sincronización de paquetes entre el módelo propuesto del SACI y 
					el Sistema de back office. En el caso que existieran discrepancias entre ellas.
				</td>
				<td>&nbsp;</td>
			</tr>
			
<!----------------------------------------------------------PARAM[225]------------------------------------------------------------------->
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['225']#:</label></td>
						<td>
							<select name="param_225" tabindex="1">
								<option value=""></option>
							<cfloop query="motivosBloqueoSinCompromiso">
								<option value="#HTMLEditFormat( motivosBloqueoSinCompromiso.MBmotivo )#"<cfif Trim(paramValues['225']) EQ Trim(motivosBloqueoSinCompromiso.MBmotivo)> selected</cfif>>#HTMLEditFormat( motivosBloqueoSinCompromiso.MBdescripcion )#</option>
								</cfloop>
							</select>
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
				<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Se refiere al motivo de bloqueo que se debe registrar en el bloqueo de un medio, cuando se reciben llamadas pendientes de pago en el archivo de liquidación
				</td>
				<td>&nbsp;</td>
			</tr>
<!---------------------------------------------------------PARAM[224]---------------------------------------------------------------------->

<!----------------------------------------------------------PARAM[226]------------------------------------------------------------------->
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['226']#:</label></td>
						<td>
							<cf_campoNumerico name="param_226" decimales="-1" size="15" maxlength="3" value="#HtmlEditFormat(Trim(paramValues['226']))#" tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
				<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">
					Número de días mediante los cuáles se calcula la fecha histórica (fecha actual - días), apartir de la cuál
 					se realiza el pase de llamadas ignoradas por el proceso de tasación (crudo) hacia un histórico.
					 Estás llamadas son ignoradas por el proceso de tasación ya
					que no cumplen con la estructura y formatos nesesarios.
				</td>
				<td>&nbsp;</td>
			</tr>
<!---------------------------------------------------------PARAM[226]---------------------------------------------------------------------->


			<tr>
				<td colspan="4"><hr></td>
			</tr>						
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">&nbsp;
					
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<cf_botones names="Guardar" values="Guardar" tabindex="1">
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>
	</form>
	
	<script language="javascript" type="text/javascript">
		function quitaComilla(e, obj){
			if(e.keyCode==50){
				var re = new RegExp('\"','ig');
				obj.value = obj.value.replace(re,"");
			}
			return;
		}
		
		function quitaInvalidChars(obj){
			var re = new RegExp("[^##\(\)-]","ig");
			obj.value = obj.value.replace(re,"");
			return;
		}
		
		function updParam100() {
			document.form1.param_100.value = document.form1.PQcodigo.value;
		}

		function updParam220() {
			document.form1.param_220.value = document.form1.Usucodigo.value;
		}
		function getTecla(e){
			var tecla=null;
			
			e = (e) ? e : event
			tecla = (e.which) ? e.which : e.keyCode

			return tecla;
		}		
		function filtraCarac(e,obj){
			var cl = getTecla(e);
			
			if((cl != 51)&&(cl != 16)&&(cl != 17)&&(cl != 56)&&(cl != 57)&&(cl != 36)&&(cl != 37)&&(cl != 39)){
				if((cl == 32) || (cl == 8) || (cl == 9) || (cl == 109))
					obj.value=obj.value.substring(0,obj.value.length);
				else
					obj.value=obj.value.substring(0,obj.value.length-1);
			}else if(((cl == 51)||(cl == 56)||(cl == 57))&&(!e.shiftKey)){
					obj.value=obj.value.substring(0,obj.value.length-1);
				}
				
		}
		function validaParams(f){
			var error_input;
			var error_msg = '';
			
			if (parseInt(f.param_40.value,10) > 365){
				error_msg += "\n - Plazo para Borrado Permanente de Logines Inactivos no debe ser mayor a 365.";
				error_input = f.param_40;
			}
			else{
				if (f.param_80.value == "") {
					error_msg += "\n - El Inicio de Período de Restricción para Cambios en Forma de Cobro no puede quedar en blanco.";
					error_input = f.param_80;
				}else if(parseInt(f.param_80.value,10) < 1 || parseInt(f.param_80.value,10) > 31){
					error_msg += "\n - El Inicio de Período de Restricción para Cambios en Forma de Cobro debe estar entre 1 y 31";
					error_input = f.param_80;
				}else{
					if (f.param_90.value == "") {
						error_msg += "\n - El Fín de Período de Restricción para Cambios en Forma de Cobro no puede quedar en blanco.";
						error_input = f.param_90;
					}else{
						if(parseInt(f.param_80.value,10) == 0){
							error_msg += "\n - El Inicio de Período de Restricción para Cambios en Forma de Cobro no puede ser igual a cero.";
							error_input = f.param_80;					
						}else{
							if(parseInt(f.param_90.value,10) == 0){
								error_msg += "\n - El Fín de Período de Restricción para Cambios en Forma de Cobro no puede ser igual a cero.";
								error_input = f.param_90;					
							}else if(parseInt(f.param_90.value,10) < 1 || parseInt(f.param_90.value,10) > 31){
								error_msg += "\n - El Fín de Período de Restricción para Cambios en Forma de Cobro debe estar entre 1 y 31";
								error_input = f.param_80;
							}else{					
								if(parseInt(f.param_80.value,10) > parseInt(f.param_90.value,10)){
									error_msg += "\n - El Inicio de Período de Restricción para Cambios en Forma de Cobro no puede ser mayor que el \nFín de Período de Restricción para Cambios en Forma de Cobro.";
									error_input = f.param_80;					
								}else{
								}						
							}
						}
					}
				}
			}
			
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			return true;
		}
		
	</script>
	
</cfoutput>