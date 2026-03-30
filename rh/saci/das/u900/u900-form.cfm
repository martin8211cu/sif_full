<cfif isdefined('url.TJid') and not isdefined('form.TJid')>
	<cfset form.TJid = url.TJid>
</cfif>

<cfset mask = "">

<cfoutput>
	<form name="form1" method="post" action="u900-aply.cfm" style="margin: 0;" onsubmit="return validar(this);">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  	<tr>
				<td colspan="2">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td colspan="3" class="menuhead">Solicitud de Bloqueo <hr></td>
					  </tr>
					  <tr>
						<td width="31%" align="right"><label>Tel&eacute;fono:</label></td>
						<td width="2%">&nbsp;</td>
						<td>
							<cf_campoNumerico nullable="true" name="MDref" decimales="-1" size="15" 
						     maxlength="7" value="" tabindex="1">

						<!---							
						<cfset id="">
						<cfif isdefined("url.MDref")and len(trim(url.MDref))>		
						<cfset id = url.MDref>	
						</cfif>
						<cf_medio id="#id#" funcion="cargaMedio()" MDbloqueado="0">									
						--->
						
						</td>													
					  </tr>
					  <tr>
						<td align="right"><label>Origen del Bloqueo:</label></td>
						<td>&nbsp;</td>
						<td>
							<cf_motivoBloq sufijo="900" conCompromiso="0" BloqueablePorPantalla = "1">
						</td>
					  </tr>		
					  <tr>
						<td align="right" valign="top"><label>Observaciones:</label></td>
						<td>&nbsp;</td>
						<td><textarea name="BTobs" cols="50" rows="3" id="BTobs"><cfif isdefined('form.BTobs') and form.BTobs NEQ ''>#form.BTobs#</cfif></textarea></td>
					  </tr>							
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>							  
					    			  
					</table>
					
				</td>	
			</tr>			
		  	<tr>
				<td colspan="2" align="center">
					<cf_botones exclude="Alta,Limpiar" include="Bloquear" includeValues="Bloquear">
				</td>
			</tr>
		</table>
	</form>
	
	<script language="javascript" type="text/javascript">
	<!--		
		function cargaMedio(){
			if(document.form1.MBmotivo.value != ''){
				document.form1.MBmotivo900.value = document.form1.MBmotivo.value;			
			}else{
				document.form1.MBmotivo900.selectedIndex = 0;		
			}

			if(document.form1.MDbloqueado.value == 1)
				document.form1.Bloquear.value = 'Desbloquear';
			else
				document.form1.Bloquear.value = 'Bloquear';
		}
	
		function validar(formulario){
			var error_input;
			var error_msg = '';
			
			if (! (/^[0-9]*$/.test(trim(formulario.MDref.value)))) 
			{
				error_msg += "\n - El campo Teléfono sólo se permite el ingreso de números.";
				error_input = formulario.MBmotivo;
			}
					
			var tel = formulario.MDref.value; 
			if (trim(formulario.MDref.value) == "" || formulario.MDref.value == "0" || formulario.MDref.value.length < 7) {
				error_msg += "\n - El Telefono no puede quedar en blanco y debe contener siete dígitos.";
				error_input = formulario.MDref;
			}
		
			if (formulario.MBmotivo900.value == "") {
				error_msg += "\n - El origen del bloqueo no puede quedar en blanco.";
				error_input = formulario.MBmotivo900;
			}
			if (trim(formulario.BTobs.value) == "") {
				error_msg += "\n - Las observaciones del bloqueo no pueden quedar en blanco.";
				error_input = formulario.BTobs;
			}			
			
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguientes datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
						
			//Confirmaciones
			if(btnSelected('Bloquear', formulario)){
				var msj = "";
				if(document.form1.MDbloqueado.value == 1)
					msj = "Realmente desea desloquear este Usuario 900 ?";
				else
					msj = "Realmente desea bloquear este Usuario 900 ?";
							
				if (!confirm(msj))
					return false;
			}							
			return true;
		}
		
		function trim(dato) {
			dato = dato.replace(/^\s+|\s+$/g, '');
			return dato;
		}

	//-->
	</script>		
</cfoutput>
