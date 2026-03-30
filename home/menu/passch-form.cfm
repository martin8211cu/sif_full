<cfif isdefined('url.error') and not isdefined('form.error')>
	<cfset form.error = url.error></cfif>
<style type="text/css" >
.ayuda {
	background-color: #e4e4e4;
	padding: 4px;
	border: 1px solid #000000;
}
.error {
	font-weight: bold;
	color: #FF0000;
	font-family: Arial, Helvetica, sans-serif;
	font-size:small;
}
</style>

<form method="post" name="f" action="passch-apply.cfm" onSubmit="return valida(this, '#session.usuario#');" >

<table border="0" width="100%">
  <tr>
    <td width="33%" class="subTitulo">Instrucciones</td>
    <td width="67%"  class="subTitulo">Contrase&ntilde;a nueva</td>
  </tr>
  <tr>
    <td valign="top" class="ayuda">Se recomienda realizar este cambio de manera peri&oacute;dica, con el fin de incrementar la seguridad de su informaci&oacute;n.<br>
  Junto con la contrase&ntilde;a, usted podr&aacute; modificar la informaci&oacute;n personal que lo identifica como due&ntilde;o de la cuenta, y que solamente usted deber&iacute;a conocer. Si omite esta identificaci&oacute;n, y si llega a olvidar su contrase&ntilde;a deber&aacute; comunicarse con el administrador.
        <p>Por su propia seguridad, seleccione una contrase&ntilde;a que cumpla con las siguientes caracter&iacute;sticas:</p>
        <ul>
          <li>Tener un m&iacute;nimo de seis caracteres.</li>
          <li>Contener letras y n&uacute;meros.</li>
          <li>Ser diferente al usuario. Debe haber al menos cuatro diferencias.</li>
          <li>No puede ser parte del usuario ni viceversa.
        </ul>        </td>
    <td valign="top"><table border="0" cellspacing="4" cellpadding="4"  width="100%">
    <!--DWLayoutTable-->
    <tr> 
      <td colspan="3" valign="top" align="center" class="error">

		<cfif isdefined("form.error") and form.error eq '1'>
			Complete los datos solicitados
		<cfelseif isdefined("form.error") and form.error eq '2'>
			La contrase&ntilde;a anterior es incorrecta
		<cfelseif isdefined("form.error") and form.error eq '3'>
			Su contrase&ntilde;a ya expir&oacute;. Por favor, seleccione una nueva contrase&ntilde;a.
		<cfelseif isdefined("form.error") and form.error eq '4'>
			<cfparam name="url.days" default="7">
			Su contrase&ntilde;a expira en <cfoutput>#url.days#</cfoutput> d&iacute;as. Seleccione una nueva contrase&ntilde;a, o presione cancelar para regresar m&aacute;s tarde.
		</cfif>
      </td>
    </tr>
    <tr>
      <td colspan="2"  valign="top"> <p>Contrase&ntilde;a anterior</p></td>
      <td width="412" valign="top" > <input name="oldpass" type="password" id="oldpass" value="" size="30" onFocus="this.select()" /> 
      </td>
    </tr>
    <tr>
      <td colspan="3"  valign="top">Esto se solicita para mantener la seguridad del sitio.</td>
    </tr>
    <tr>
      <td colspan="2" valign="top" >Contrase&ntilde;a deseada</td>
      <td valign="top" ><input name="newpass" type="password" id="newpass" value="" size="30" onFocus="this.select()" /></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" >Confirme la nueva contrase&ntilde;a</td>
      <td valign="top" ><input name="newpass2" type="password" id="newpass2" value="" size="30" onFocus="this.select()"  /></td>
    </tr>
    <tr>
      <td colspan="3" valign="top" class="subTitulo"> Identificaci&oacute;n personal</td>
    </tr>
    <tr>
      <td width="62"  valign="top" ><input type="radio" name="preg" id="pregno" value="0" checked></td>
      <td colspan="2" valign="top" >Deseo que la pregunta y respuesta personales permanezcan como est&aacute;n.</td>
    </tr>
    <tr>
      <td width="62"  valign="top" ><input type="radio" name="preg" id="pregsi" value="1" ></td>
      <td colspan="2" valign="top" >Deseo modificar la pregunta y respuesta personales como medio de identificaci&oacute;n.</td>
    </tr>
    <tr>
      <td colspan="2" valign="top">Pregunta</td>
      <td valign="top" ><select name="pregunta" id="pregunta" onChange="document.f.pregsi.checked = true" >
          <option>&iquest; Cu&aacute;l es mi n&uacute;mero de la suerte ?</option>
          <option>&iquest; C&oacute;mo se llama mi suegra ?</option>
          <option>&iquest; De qu&eacute; color fue mi primer auto ?</option>
          <option>&iquest; Cu&aacute;ntos hermanos tengo ?</option>
          <option selected>Nombre de mi mascota</option>
          <option>Segundo apellido de mi mam&aacute;</option>
        </select>
		</td>
    </tr>

    <tr>
      <td colspan="2" valign="top">Respuesta</td>
      <td valign="top"> <input name="respuesta" type="text" value="" size="30" maxlength="60" onChange="document.f.pregsi.checked = true" /></td>
    </tr>
    <tr>
      <td colspan="3" align="center" valign="top"><p> 
          <input type="button" value="Cancelar" onClick="self.location.href='../../'" />
          <input type="submit" value="Continuar &gt; " />
        </p></td>
    </tr>
    <tr> 
      <td></td>
      <td width="9"></td>
      <td></td>
    </tr>
  </table></td>
  </tr>
</table>

  
</form>
		
<script type="text/javascript" src="../signup/passwd.js">//</script>
<script type="text/javascript" src="passch.js">//</script>
<script type="text/javascript">
	document.f.oldpass.focus();
</script>