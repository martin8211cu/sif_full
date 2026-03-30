<cfoutput>
  <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td width="50%" valign="top">
      <table	 border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td width="10">&nbsp;</td>
            <td width="17">&nbsp;</td>
            <td width="20">&nbsp;</td>
            <td width="104">&nbsp;</td>
            <td width="176">&nbsp;</td>
            <td width="20">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Expiraci&oacute;n de contrase&ntilde;as en d&iacute;as </strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td colspan="2"><label for="pass_expira_default">Valor general </label></td>
            <td><input name="pass_expira_default" type="text" class="flat right" id="pass_expira_default" onFocus="this.select()" value="#data.pass.expira.default#" size="6" maxlength="6" onblur="solonumero(this,'#data.pass.expira.default#')">
                <label for="pass_expira_default">d&iacute;as</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="pass_expira_recordatorio">Recordatorio</label></td>
            <td><input name="pass_expira_recordatorio" type="text" class="flat right" id="pass_expira_recordatorio" onFocus="this.select()" value="#data.pass.expira.recordatorio#" size="6" maxlength="6" onblur="solonumero(this,'#data.pass.expira.recordatorio#')">
                <label for="pass_expira_recordatorio"> d&iacute;as</label></td>
            <td >&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="pass_expira_min">Rango v&aacute;lido &dagger;</label></td>
            <td><input name="pass_expira_min" type="text" class="flat right" id="pass_expira_min" onFocus="this.select()" value="#data.pass.expira.min#" size="6" maxlength="6" onblur="solonumero(this,'#data.pass.expira.min#')">
                <label for="pass_expira_max"> a </label>
                <input name="pass_expira_max" type="text" class="flat right" id="pass_expira_max" onFocus="this.select()" value="#data.pass.expira.max#" size="6" maxlength="6" onblur="solonumero(this,'#data.pass.expira.max#')">            </td>
            <td bgcolor="">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Bloqueo de usuarios</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="sesion_bloqueo_cant">Si falla el login</label>
                  <input name="sesion_bloqueo_cant" type="text" class="flat right" id="sesion_bloqueo_cant" onFocus="this.select()" value="#data.sesion.bloqueo.cant#" size="6" maxlength="6" onblur="solonumero(this,'#data.sesion.bloqueo.cant#')">
            <label for="sesion_bloqueo_cant">veces, el usuario: </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="sesion_bloqueo_reactivar" id="sesion_bloqueo_reactivar_0" type="radio" value="0" onClick="with(form.sesion_bloqueo_duracion){disabled = false;focus()}" <cfif data.sesion.bloqueo.duracion > checked </cfif>>            </td>
            <td colspan="2"><label for="sesion_bloqueo_reactivar_0">se bloquea por</label>
                <input name="sesion_bloqueo_duracion" type="text" class="flat right" id="sesion_bloqueo_duracion" onFocus="this.select()" value="<cfif data.sesion.bloqueo.duracion is 0>#data.sesion.bloqueo.periodo#<cfelse>#data.sesion.bloqueo.duracion#</cfif>" size="6" maxlength="6" onblur="solonumero(this,'<cfif data.sesion.bloqueo.duracion is 0>#data.sesion.bloqueo.periodo#<cfelse>#data.sesion.bloqueo.duracion#</cfif>')" <cfif data.sesion.bloqueo.duracion is 0 >disabled</cfif>>
                <label for="sesion_bloqueo_duracion"> minutos, o</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="sesion_bloqueo_reactivar" id="sesion_bloqueo_reactivar_1" type="radio" value="1" onClick="form.sesion_bloqueo_duracion.disabled = this.checked" <cfif data.sesion.bloqueo.duracion is 0 > checked </cfif>>            </td>
            <td colspan="2"><label for="sesion_bloqueo_reactivar_1">requerir&aacute; reactivaci&oacute;n. </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="sesion_bloqueo_periodo">Borrar contador despu&eacute;s de</label>
                  <input name="sesion_bloqueo_periodo" type="text" class="flat right" id="sesion_bloqueo_periodo" onFocus="this.select()"  onblur="solonumero(this,'#data.sesion.bloqueo.periodo#')" value="#data.sesion.bloqueo.periodo#" size="6" maxlength="6">
            <label for="sesion_bloqueo_periodo">minutos.</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Login de Usuarios</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="5"><label for="label">El login de usuario debe ser de </label>
         <input name="user_long_min" type="text" class="flat right" id="user_long_min" onfocus="this.select()" value="#data.user.long.min#" size="2" maxlength="3" onblur="solonumero(this,'#data.user.long.min#')" />
<label for="label">a</label>
  <input name="user_long_max" type="text" class="flat right" id="user_long_max" onfocus="this.select()" value="#data.user.long.max#" size="2" maxlength="3" onblur="solonumero(this,'#data.user.long.max#')" />
        <label for="label">digitos</label>
         	</td>
          </tr>
          <tr><td>&nbsp;</td>
           <td valign="top">
				  <input name="user_valida_letras" type="checkbox" id="user_valida_letras" value="1" <cfif isdefined("data.user.valida.letras") and data.user.valida.letras is 1>checked</cfif>>
            <td colspan="3" valign="top">
				 <label for="user_valida_letras">Que el usuario tenga al menos una May&uacute;scula</label>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr><td>&nbsp;</td>
           <td valign="top">
				 <input name="user_valida_digitos" type="checkbox" id="user_valida_digitos" value="1" <cfif isdefined("data.user.valida.digitos") and data.user.valida.digitos is 1>checked</cfif>>
            <td colspan="3" valign="top">
				 <label for="user_valida_digitos">Que el usuario tenga al menos un N&uacute;mero</label>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          
      </table></td>
      <td width="50%" valign="top"><table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31">&nbsp;</td>
            <td>&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="122">&nbsp;</td>
            <td width="214">&nbsp;</td>
            <td width="12">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="5" class="subTitulo"><strong>Gesti&oacute;n de contrase&ntilde;as</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="5"><label for="label">La contraseña de ser de </label>
            <input name="pass_long_min" type="text" class="flat right" id="pass_long_min" onFocus="this.select()" value="#data.pass.long.min#" size="2" maxlength="3" onblur="solonumero(this,'#data.pass.long.max#')" > 
              <label for="label">a</label> 
              <input name="pass_long_max" type="text" class="flat right" id="pass_long_max" onfocus="this.select()" value="#data.pass.long.max#" size="2" maxlength="3" onblur="solonumero(this,'#data.pass.long.max#')" />
              <label for="label">digitos</label> </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">Rangos de caracteres válidos</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><input name="user_valid_chars" type="text" class="flat" id="user_valid_chars" onfocus="this.select()" value="#data.user.valid.chars#" size="35" maxlength="60" onblur="validcharsok(this)" /></td>
            <td>&nbsp;</td>
          </tr>
           <tr>
            <td>&nbsp;</td>
            <td colspan="4"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">
                <input name="pass_valida_simbolos" type="checkbox" id="pass_valida_simbolos" value="1" <cfif data.pass.valida.simbolos is 1>checked</cfif>>
                <label for="pass_valida_simbolos">La contraseña debe contener S&iacute;mbolos</label></td>
            <td>&nbsp;</td>
          </tr>
         <tr><td>&nbsp;</td>
           <td valign="top">
				  <input name="pass_valida_letras" type="checkbox" id="pass_valida_letras" value="1" <cfif data.pass.valida.letras is 1>checked</cfif>>
            <td colspan="3" valign="top">
				 <label for="pass_valida_letras">Que la contraseña tenga al menos una May&uacute;scula</label>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr><td>&nbsp;</td>
           <td valign="top">
				 <input name="pass_valida_digitos" type="checkbox" id="pass_valida_digitos" value="1" <cfif data.pass.valida.digitos is 1>checked</cfif>>
            <td colspan="3" valign="top">
				 <label for="pass_valida_digitos">Que la contraseña tenga al menos un N&uacute;mero</label>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td width="27"><input name="pass_valida_usuario" type="checkbox" id="pass_valida_usuario" value="1" <cfif data.pass.valida.usuario is 1>checked</cfif>>            </td>
            <td colspan="3"><label for="pass_valida_usuario">Comparar contrase&ntilde;a con usuario. </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input name="pass_valida_diccionario" type="checkbox" id="pass_valida_diccionario" value="1" <cfif data.pass.valida.diccionario is 1>checked</cfif>>            </td>
            <td colspan="3" valign="top"><label for="pass_valida_diccionario">Validar la contrase&ntilde;a contra un diccionario</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input name="pass_valida_lista_0" type="checkbox" id="pass_valida_lista_0" value="1" <cfif data.pass.valida.lista neq 0>checked</cfif> onClick="this.form.pass_valida_lista.disabled=!this.checked;">
                <label for="pass_valida_lista_0"></label></td>
            <td colspan="3" valign="top"><label for="pass_valida_lista_0">Evitar que se repitan las &uacute;ltimas</label>
                <select name="pass_valida_lista" id="pass_valida_lista" <cfif data.pass.valida.lista is 0>disabled</cfif>>
                  <cfloop from="1" to="40" index="i">
                    <option <cfif data.pass.valida.lista is i or data.pass.valida.lista is 0 and i is 10>selected</cfif>>#i#</option>
                  </cfloop>
                </select>
            <label for="pass_valida_lista_0">contrase&ntilde;as</label></td>
            <td>&nbsp;</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
            <td valign="top">
				<cfparam name="data['pass.mail.cambiar']" default="0">
				<input name="pass_mail_cambiar" type="checkbox" id="pass_mail_cambiar" value="1" <cfif data.pass.mail.cambiar neq 0>checked</cfif>>
            <td colspan="3" valign="top">
				<strong>Cambio obligatorio de Contraseña enviada por mail</strong>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          
      </table>        </td>  
    </tr>
    <tr>
      <td align="left" class="subTitulo"><input name="submit-pass" type="submit" id="submit-pass" value="Aplicar" class="btnGuardar">
          <input type="reset" name="Reset" value="Cancelar" class="btnLimpiar">      </td>
      <td align="right" class="subTitulo"><input type="submit" name="submit-passtest" value="Probar ahora" class="btnSiguiente" /></td>
    </tr>
  </table>
<script type="text/javascript">
function validcharsok(c){
	//c.value = c.value.replace(/\s+/g,  '');
	c.value = c.value;
}
function funcvalidar(){
	var f = document.form1;
	solonumero(f.pass_expira_default, '#data.pass.expira.default#');
	solonumero(f.pass_expira_recordatorio, '#data.pass.expira.recordatorio#');
	solonumero(f.pass_expira_min, '#data.pass.expira.min#');
	solonumero(f.pass_expira_max, '#data.pass.expira.max#');
	solonumero(f.sesion_bloqueo_cant, '#data.sesion.bloqueo.cant#');
	solonumero(f.sesion_bloqueo_periodo, '#data.sesion.bloqueo.periodo#');
	solonumero(f.sesion_bloqueo_duracion, '<cfif data.sesion.bloqueo.duracion is 0>#data.sesion.bloqueo.periodo#<cfelse>#data.sesion.bloqueo.duracion#</cfif>');
	solonumero(f.user_long_min, '#data.user.long.min#');
	solonumero(f.user_long_max, '#data.user.long.max#');
	solonumero(f.pass_long_min, '#data.pass.long.min#');
	solonumero(f.pass_long_max, '#data.pass.long.max#');
	validcharsok(f.user_valid_chars);
	if(parseInt(f.pass_expira_max.value) < parseInt(f.pass_expira_min.value)){
		f.pass_expira_max.value = f.pass_expira_min.value;
	}
	if(parseInt(f.user_long_max.value) < parseInt(f.user_long_min.value)){
		f.user_long_max.value = f.user_long_min.value;
	}
	if(parseInt(f.pass_long_max.value) < parseInt(f.pass_long_min.value)){
		f.pass_long_max.value = f.pass_long_min.value;
	}
	return true;
}
function solonumero(c,d) {
	var v = parseInt(c.value);
	if (v!=c.value){
		c.value = isNaN(v) ? d : Math.abs(Math.round(v));
	} else c.value = Math.abs(v)
}

</script>
</cfoutput>
