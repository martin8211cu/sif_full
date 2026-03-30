<cfif not isdefined("Request.utilesMonto")>
	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<cfset Request.utilesMonto = true>
</cfif>

<cfif isdefined('url.Pagina') and not isdefined('form.Pagina')>
	<cfset form.Pagina = url.Pagina>
</cfif>
<cfif isdefined('url.filtro_TJlogin') and not isdefined('form.filtro_TJlogin')>
	<cfset form.filtro_TJlogin = url.filtro_TJlogin>
</cfif>
<cfif isdefined('url.filtro_descTJestado') and not isdefined('form.filtro_descTJestado')>
	<cfset form.filtro_descTJestado = url.filtro_descTJestado>
</cfif>
<cfif isdefined('url.filtro_nombreAgente') and not isdefined('form.filtro_nombreAgente')>
	<cfset form.filtro_nombreAgente = url.filtro_nombreAgente>
</cfif>

<cfoutput>
	<cfquery datasource="#session.dsn#" name="rsPrefijo">
		select prefijo
		from  ISBprefijoPrepago
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
	</cfquery>	
	<form name="form1" method="post" action="prepagosMasivo-aply.cfm" style="margin: 0;" onsubmit="return validar(this);">
		<cfinclude template="prepagos-hiddens.cfm">
		<input type="hidden" name="masivo" value="1" />
		
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	
		  	<tr>
				<cfoutput>
					<td>
                        <table width="100%"  border="0" cellspacing="2" cellpadding="0">
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr> 						
						  <tr>
							<td colspan="3" class="subTitulo">Administraci&oacute;n Masiva de Tarjetas Prepago</td>
						  </tr>  						
                          <tr>
                            <td width="15%">&nbsp;</td>
                            <td width="20%">&nbsp;</td>
                            <td width="65%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td align="right" nowrap><label for="Prefijo Prepago">Prefijo Prepago</label>:</td>
                            <td>
								<select name="prefijo" id="prefijo" tabindex="1">
								  <cfloop query="rsPrefijo">
									<option value="#rsPrefijo.prefijo#" <cfif isdefined('form.prefijo') and form.prefijo NEQ '' and form.prefijo EQ rsPrefijo.prefijo> selected</cfif>>#rsPrefijo.prefijo#</option>
								  </cfloop>
								</select>
							</td>
                            <td nowrap>
                              	<label for="Prepago Inicial">Prepago Inicial</label>:
								<cfset varTarIni = "">
								<cfif isdefined('form.tarIni') and len(trim(form.tarIni))>
									<cfset varTarIni = form.tarIni>								
								</cfif> 
 								<cf_campoNumerico name="tarIni" decimales="-1" size="20" maxlength="30" value="#varTarIni#" tabindex="1">

								&nbsp;&nbsp;&nbsp;
								<label for="Prepago Final">Prepago Final</label>:
								<cfset varTarFin = "">
								<cfif isdefined('form.tarFin') and len(trim(form.tarFin))>
									<cfset varTarFin = form.tarFin>								
								</cfif> 

								<cf_campoNumerico name="tarFin" decimales="-1" size="20" maxlength="30" value="#varTarFin#" tabindex="1">								

							</td>
                          </tr>						  
                          <tr>
                            <td align="right"><label for="Agente">Agente</label>:</td>
                            <td colspan="2">
								<cfset idAgente = "">					
								<cfif isdefined('form.Pquien_mas') and form.Pquien_mas NEQ ''>
									<cfset idAgente = Form.Pquien_mas>
								</cfif>									
								<cf_agenteId
									id="#idAgente#"
									sufijo="_mas">												
							</td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
					</td>
				</cfoutput>					
		  	</tr>			
		  	<tr>
				<td>
					<cf_botones tabindex="1" exclude="Alta,Limpiar" include="Regresar,Anular,Asignar,Activar,Bloquear" includeValues="Regresar,Anular,Asignar Agente,Activar,Desactivar">
				</td>
			</tr>
		</table>
	</form>
	
	<script type="text/javascript">
	<!--
		function verificaNum(param){
			var dato = qf(param);
			if (ESNUMERO(dato)) {
				return true;
			} else {
				return false;
			}
		}
			
		function validar(formulario){
			var error_input;
			var error_msg = '';
			var num_ok = true;
			
			if(!btnSelected('Regresar', formulario)){
				if (formulario.prefijo.value == "") {
					error_msg += "\n - El Prefijo no puede quedar en blanco.";
					error_input = formulario.prefijo;
				}
				if (formulario.tarIni.value == "") {
					error_msg += "\n - El Rango Inicial no puede quedar en blanco.";
					error_input = formulario.tarIni;
				}				
				if (formulario.tarFin.value == "") {
					error_msg += "\n - El Rango Final no puede quedar en blanco.";
					error_input = formulario.tarFin;
				}								
				if(btnSelected('Asignar', formulario)){
					if (formulario.AGidp_mas.value == "") {
						error_msg += "\n - El Agente no puede quedar en blanco.";
						error_input = formulario.AGidp_mas;
					}			
				}					
				if(formulario.tarIni.value != ''){
					if(!verificaNum(formulario.tarIni.value)){
						error_msg += "\n - El número digitado para el rango inicial debe ser numérico.";
						error_input = formulario.tarIni;
						num_ok = false;
					}
				}
				if(formulario.tarFin.value != ''){
					if(!verificaNum(formulario.tarFin.value)){
						error_msg += "\n - El número digitado para el rango final debe ser numérico.";
						error_input = formulario.tarFin;
						num_ok = false;
					}
				}	
				if(num_ok){
					var numIni = new Number(formulario.tarIni.value);
					var numFin = new Number(formulario.tarFin.value);
					
					if(numIni > numFin){
						error_msg += "\n - El rango inicial es mayor que el rango final.";
						error_input = formulario.tarIni;
					}
				}
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguientes datos:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}				
				//Confirmaciones
				if(btnSelected('Activar', formulario)){
					if (!confirm('Realmente desea activar este rango de Tarjetas de Prepago ?'))
						return false;
				}	
				if(btnSelected('Bloquear', formulario)){
					if (!confirm('Realmente desea Bloquear este rango de Tarjetas de Prepago ?'))
						return false;
				}	
				if(btnSelected('Anular', formulario)){
					if (!confirm('Realmente desea Anular este rango de Tarjetas de Prepago ?'))
						return false;
				}			
				if(btnSelected('Asignar', formulario)){
					if (!confirm('Realmente desea Asignar este Agente a este rango de Tarjetas de Prepago ?'))
						return false;
				}			
			}

			return true;
		}
	//-->
	</script>		
</cfoutput>
