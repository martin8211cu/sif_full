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

<cfparam name="form.rdTipoAdmin" type="integer" default="1">

<cfoutput>
	<form name="form1" method="post" action="sobres-aply.cfm" style="margin: 0;" onsubmit="return validar(this);">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	
		  	<tr><td>&nbsp;</td></tr>		
		  	<tr>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td colspan="2" align="center">
							<label for="Individual">Individual</label>:	
							<input name="rdTipoAdmin" type="radio" value="1" 
								 onClick="javascript:clickTipo(this.value);"
								<cfif isdefined('form.rdTipoAdmin') and form.rdTipoAdmin EQ 1> checked</cfif>>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<label for="Macivo">Macivo</label>:	
							<input name="rdTipoAdmin" type="radio" value="2" 
								 onClick="javascript:clickTipo(this.value);"								
								<cfif isdefined('form.rdTipoAdmin') and form.rdTipoAdmin EQ 2> checked</cfif>>
						</td>
					  </tr>
					</table>					
				</td>
			</tr>		
		  	<tr id="idIndiv">
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="23%">&nbsp;</td>
						<td width="24%">&nbsp;</td>
						<td width="21%">&nbsp;</td>
						<td width="32%">&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right"><label for="Sobre">Sobre</label>:</td>
						<td>
							<cfset idSnumero = "">
							<cfif isdefined('form.Snumero') and form.Snumero NEQ ''>
								<cfset idSnumero = Form.Snumero>
							</cfif>			
							<cf_sobre
								numero = "#idSnumero#"
								responsable="0">							
						</td>
						<td align="right"><label for="Agente">Agente</label>:</td>
						<td>
							<cfset idAgente = "">					
							<cfif isdefined('form.Pquien') and form.Pquien NEQ ''>
								<cfset idAgente = Form.Pquien>
							</cfif>									
							<cf_agenteId
								id="#idAgente#">
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					</table>
				</td>
		  	</tr>
		  	<tr id="idRango">
				<cfoutput>
					<td>

                        <table width="100%"  border="0" cellspacing="2" cellpadding="0">
                          <tr>
                            <td width="10%">&nbsp;</td>
                            <td width="31%">&nbsp;</td>
                            <td width="8%">&nbsp;</td>
                            <td width="51%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td align="right" nowrap><label for="Rango Inicial">Sobre Inicial</label>
                              :</td>
                            <td>
								<input type="text" tabindex="1" name="sobreIni" size="20" maxlength="30" value="<cfif isdefined('form.sobreIni') and len(trim(form.sobreIni))>#form.sobreIni#</cfif>">
							</td>
                            <td nowrap align="right"><label for="Rango Final">Sobre Final</label>:</td>
                            <td>
								<input type="text" tabindex="1" name="sobreFin" size="20" maxlength="30" value="<cfif isdefined('form.sobreFin') and len(trim(form.sobreFin))>#form.sobreFin#</cfif>">
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
					<cf_botones tabindex="1" exclude="Alta,Limpiar" include="Anular,Asignar" includeValues="Anular,Asignar Agente">
				</td>
			</tr>
		</table>
	</form>
	
	<script type="text/javascript">
	<!--
		function clickTipo(val){
			if (val==1){	//Individual
				document.getElementById('idIndiv').style.display='';
				document.getElementById('idRango').style.display='none';
			}
			if(val==2){	//Masivo
				document.getElementById('idIndiv').style.display='none';
				document.getElementById('idRango').style.display='';
			}
		}
		
		function validar(formulario){
			var error_input;
			var error_msg = '';

			if (formulario.rdTipoAdmin[1].checked) {	//Asignacion Masiva
				if (formulario.sobreIni.value == "") {
					error_msg += "\n - El Rango Inicial no puede quedar en blanco.";
					error_input = formulario.sobreIni;
				}				
				if (formulario.sobreFin.value == "") {
					error_msg += "\n - El Rango Final no puede quedar en blanco.";
					error_input = formulario.sobreFin;
				}								
				if(btnSelected('Asignar', formulario)){
					if (formulario.AGidp_mas.value == "") {
						error_msg += "\n - El Agente no puede quedar en blanco.";
						error_input = formulario.AGidp_mas;
					}			
				}					

				var numIni = new Number(formulario.sobreIni.value);
				var numFin = new Number(formulario.sobreFin.value);
				
				if(numIni > numFin){
					error_msg += "\n - El sobre inicial es mayor que el final.";
					error_input = formulario.sobreIni;
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
			}else{										//Asignacion Individual
				if(btnSelected('Asignar', formulario)){
					if (formulario.AGidp.value == "") {
						error_msg += "\n - El Agente no puede quedar en blanco.";
						error_input = formulario.Pid;
					}
				}
				
				if (formulario.Snumero.value == "") {
					error_msg += "\n - El Sobre no puede quedar en blanco.";
					error_input = formulario.Snumero;
				}
				
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguientes datos:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}
							
				//Confirmaciones
				if(btnSelected('Anular', formulario)){
					if (!confirm('Realmente desea Anular este Sobre ?'))
						return false;
				}						
				if(btnSelected('Asignar', formulario)){
					if (!confirm('Realmente desea Asignar este Agente a este Sobre ?'))
						return false;
				}						
			}

			return true;
		}

		clickTipo(1);
	//-->
	</script>		
</cfoutput>
