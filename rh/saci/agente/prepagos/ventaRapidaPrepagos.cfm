<form name="formVentaRapida" method="post" action="ventaPrepagos-aply.cfm" style="margin: 0;">
	<cfoutput>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="28%">&nbsp;</td>
			<td width="23%">&nbsp;</td>
			<td width="49%">&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right">
				<label for="prefijo">
					Log&iacute;n:
				</label>
			</td>
			<td>
				<input 
					name="TJlogin" 
					type="text" 
					value="" 
					size="30" 
					maxlength="30"
					tabindex="1" 
					onBlur="javascript: CargarValoresPrepago(this.value);">
			</td>
			<td>
				&nbsp;
			</td>
		  </tr>
		  <tr>
			<td align="right">
				<label for="prefijo">
					Precio:
				</label>				
			</td>
			<td>
				<input name="TJprecio" onFocus="javascript: this.select();" readonly="true" style="text-align: right;" type="text"  tabindex="1" size="20" maxlength="30">			
				<input type="hidden" name="TJid" value="">
			</td>
			<td align="center">
				<cf_botones modo="ALTA" exclude="Alta,Limpiar" include="Vender" tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">&nbsp;
				
			</td>
		  </tr>		  
		</table>
	</cfoutput>		
</form>

<!------------------------------ Sentencia Iframe---------------------------------->
<iframe id="frPrepago" name="frPrepago" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	
<script language="javascript" type="text/javascript">
	function funcVender(){
		var formulario = document.formVentaRapida;
		var error_input;
		var error_msg = '';
		
		if(!btnSelected('Regresar', formulario)){
			if (formulario.TJlogin.value == "") {
				error_msg += "\n - El Logín no puede quedar en blanco.";
				error_input = formulario.TJlogin;
			}
			if (formulario.TJprecio.value == "") {
				error_msg += "\n - El Precio no puede quedar en blanco.";
				error_input = formulario.TJprecio;
			}			
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguientes datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		
		if(btnSelected('Vender', formulario)){
			if(confirm('Desea vender esta tarjeta prepago ?')){
				formulario.submit();
			}else{
				return false;
			}
		}
	}
	function CargarValoresPrepago(valor) {
		if(valor != ''){
			<cfoutput>
				var formulario = document.formVentaRapida;
				var fr = document.getElementById("frPrepago");
				
				fr.src = "/cfmx/saci/utiles/queryPrepago.cfm?TJlogin=" + valor + 
						"&form_name=" + formulario.name + 
						"&conexion=#session.dsn#";
			</cfoutput>
		}
	}	

</script>