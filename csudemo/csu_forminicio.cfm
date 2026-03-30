 <form style="margin:0;" name="form1" method="post" action="consultas/csu_pedidos.cfm" onSubmit="return validar(this);">
	<table width="100%" border="0">
	  <tr>
		<td width="23%">&nbsp;</td>
		<td width="11%"><b>Usuario:</b></td>
		<td width="46%"><input name="CODCLIENTE" type="text" id="CODCLIENTE" size="25" tabindex="-1" ></td>
		<td width="20%">&nbsp;</td>
	
	  </tr>
	  <tr>
		<td width="23%">&nbsp;</td>
		<td><b>Contrase&ntilde;a:</b></td>
		<td><input name="PassCODCLIENTE" type="password" id="PassCODCLIENTE" size="25" tabindex="-1" ></td>
		<td width="20%">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="4" align="center"><input name="Entrar" type="submit" id="Entrar" value="Entrar" onClick="javascript:"></td>
	  </tr>
	</table>
</form>

<script language="javascript1.2" type="text/javascript">
	function validar(f){
		var msg = '';
		if( document.form1.CODCLIENTE.value == '' ){
			msg = msg + ' - El usuario es requerido.\n';
		}
		if( document.form1.PassCODCLIENTE.value == '' ){
			msg = msg + ' - La contraseña es requerida.\n';
		}
		if( document.form1.PassCODCLIENTE.value != document.form1.CODCLIENTE.value){
			msg = msg + ' - La contraseña no es valida.\n';
		}
		if(msg != ''){
			msg = 'Se presentaron los siguientes errores:\n' + msg;
			alert(msg);
			return false;
		}
		return true;
	
	}
</script> 