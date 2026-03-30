<cfif not isdefined("Request.utilesMonto")>
	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<cfset Request.utilesMonto = true>
</cfif>

<cfif isdefined('url.TJid') and not isdefined('form.TJid')>
	<cfset form.TJid = url.TJid>
</cfif>
<cfif isdefined('url.prefijo') and not isdefined('form.prefijo')>
	<cfset form.prefijo = url.prefijo>
</cfif>
<cfif isdefined('url.sobreIni') and not isdefined('form.sobreIni')>
	<cfset form.sobreIni = url.sobreIni>
</cfif>
<cfif isdefined('url.sobreFin') and not isdefined('form.sobreFin')>
	<cfset form.sobreFin = url.sobreFin>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="ISBsobresMasivo-aply.cfm" style="margin: 0;" onsubmit="return validar(this);">
		<cfinclude template="ISBsobres-hiddens.cfm">
		<input type="hidden" name="masivo" value="1" />
		
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	
		  	<tr>
				<cfoutput>
					<td>
                        <table width="100%"  border="0" cellspacing="2" cellpadding="0">
						  <tr>
							<td colspan="4">&nbsp;</td>
						  </tr> 						
						  <tr>
							<td colspan="4" class="subTitulo">Asignaci&oacute;n y Anulaci&oacute;n Masiva</td>
						  </tr>  						
                          <tr>
                            <td width="10%">&nbsp;</td>
                            <td width="31%">&nbsp;</td>
                            <td width="8%">&nbsp;</td>
                            <td width="51%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td align="right" nowrap><label for="Rango Inicial">Sobre Inicial</label>:</td>
                            <td>
								<cfset varSobreIni = "">
								<cfif isdefined('form.sobreIni') and len(trim(form.sobreIni))>
									<cfset varSobreIni = form.sobreIni>								
								</cfif>
								<cf_campoNumerico name="sobreIni" decimales="-1" size="20" maxlength="20" value="#varSobreIni#" tabindex="1">
							</td>
                            <td nowrap align="right"><label for="Rango Final">Sobre Final</label>:</td>
                            <td>
								<cfset varSobreFin = "">							
								<cfif isdefined('form.sobreFin') and len(trim(form.sobreFin))>
									<cfset varSobreFin = form.sobreFin>								
								</cfif>								
								<cf_campoNumerico name="sobreFin" decimales="-1" size="20" maxlength="20" value="#varSobreFin#" tabindex="1">								
							</td>
                          </tr>						  
                          <tr>
                            <td align="right"><label for="Agente">Agente</label>:</td>
                            <td>
								<cfset idAgente = "">					
								<cfif isdefined('form.Pquien_mas') and form.Pquien_mas NEQ ''>
									<cfset idAgente = Form.Pquien_mas>
								</cfif>									
								<cf_agenteId
									id="#idAgente#"
									sufijo="_mas">							
							</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
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
					<cf_botones tabindex="1" exclude="Alta,Limpiar" include="Regresar,Anular,Asignar" includeValues="Regresar,Anular,Asignar Agente">
				</td>
			</tr>
		</table>
	</form>
	
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';
			
			if((btnSelected('Anular', formulario)) || (btnSelected('Asignar', formulario))){
				if(btnSelected('Asignar', formulario)){
					if (formulario.AGidp_mas.value == "") {
						error_msg += "\n - El Agente no puede quedar en blanco.";
						error_input = formulario.AGidp_mas;
					}			
				}				
				if (formulario.sobreIni.value == "") {
					error_msg += "\n - El Rango Inicial no puede quedar en blanco.";
					error_input = formulario.sobreIni;
				}				
				if (formulario.sobreFin.value == "") {
					error_msg += "\n - El Rango Final no puede quedar en blanco.";
					error_input = formulario.sobreFin;
				}			
				
				var numIni = new Number(formulario.sobreIni.value);
				var numFin = new Number(formulario.sobreFin.value);
				
				if(numIni > numFin){
					error_msg += "\n - El sobre inicial es mayor que el final.";
					error_input = formulario.sobreIni;
				}
			}
							
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguientes datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}				
			//Confirmaciones
			if(btnSelected('Anular', formulario)){
				if (!confirm('Realmente desea Anular este rango de Sobres ?'))
					return false;
			}							
			if(btnSelected('Asignar', formulario)){
				if (!confirm('Realmente desea Asignar este Agente a este rango de Sobres ?'))
					return false;
			}			

			return true;
		}
	//-->
	</script>		
</cfoutput>
