<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Observaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<form name="formObserv" method="post" action="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0"> 		
		  <tr>
			<td width="22%">&nbsp;</td>
			<td width="78%">&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right" valign="top"><strong>Observaciones:</strong></td>
			<td><textarea name="txtObs" cols="50" rows="5" id="txtObs"></textarea></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="2" align="center"><input type="button" onClick="javascript: if (validar()){ guardar();} " 
			                name="btnGuardar" value="Guardar">
			</td>
		  </tr>
		</table>
	</form>
</body>
</html>
<script language="javascript" type="text/javascript">
	function guardar()
	{
		if (window.opener != null) 
		{
			<cfoutput>
				window.opener.document.#url.formulario#.BTOBS.value = document.formObserv.txtObs.value;
				window.opener.document.#url.formulario#.BOTON.value='btnDesbloquear';				
				window.opener.document.#url.formulario#.submit();				
				window.close();
			</cfoutput>
		}	
	}
	
	function validar()
	{
		var error_input;
		var error_msg = '';
			
		if (trim(document.formObserv.txtObs.value) == "") 
		{
			error_msg += "\n - Las observaciones del Desbloqueo no pueden quedar en blanco.";
			error_input = document.formObserv.txtObs;
		}
			
		// Validacion terminada
		if (error_msg.length != "") 
		{
			alert("Por favor revise los siguientes datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
						
		return true;
	}
	
	function trim(dato) 
	{
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
</script>