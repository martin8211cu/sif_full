<form enctype="multipart/form-data" method="post" name="formBloqMasivo" action="u900-aply.cfm" onsubmit="return validarMasivo(this);">
	<cfinclude template="u900-hiddens.cfm">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td colspan="2" class="menuhead">Bloqueo Masivo (Importaci&oacute;n)
	    <hr></td>
	  </tr>
	  <tr>
		<td colspan="2" align="center">&nbsp;</td>
	  </tr>  
	  <tr>
		<td width="35%" align="right">
			<label>Archivo a importar:</label>
		</td>
		<td width="65%">
			<input type="file" name="archImportar" />
		</td>
	  </tr>
	  <tr>
		<td width="35%" align="right" valign="top">
			<label>Observaciones:</label>
		</td>
		<td width="65%">
			<textarea name="BTobs" cols="50" rows="3" id="BTobs"><cfif isdefined('form.BTobs') and form.BTobs NEQ ''>#form.BTobs#</cfif></textarea>
		</td>
	  </tr>	  
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="2" align="center">
			<cf_botones exclude="Alta,Limpiar" include="BloquearMasivo" includeValues="Bloquear_Masivo">
		</td>
	  </tr>
	</table>
</form>

<script language="javascript" type="text/javascript">
	function validarMasivo(formulario){
		var error_input;
		var error_msg = '';
	
		if (formulario.archImportar.value == "") {
			error_msg += "\n - La ruta del archivo a importar no puede quedar en blanco.";
			error_input = formulario.archImportar;
		}
		if (trim(formulario.BTobs.value) == "") {
			error_msg += "\n - Las observaciones para el bloqueo masivo no puede quedar en blanco.";
			error_input = formulario.BTobs;
		}		
		
		// Validacion terminada
		if (error_msg.length != "") {
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