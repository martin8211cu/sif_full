<cfoutput>
  <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td width="50%" valign="top"><table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31">&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="122">&nbsp;</td>
            <td width="214">&nbsp;</td>
            <td width="12">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="5" class="subTitulo"><strong>Probar reglas de usuario y contraseña <strong></strong></strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          
          <tr>
            <td>&nbsp;</td>
            <td colspan="4"><table width="403" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td width="100">Usuario</td>
                </tr>
              <tr>
                <td><input name="test_user" type="text" class="flat" id="test_user" onfocus="this.select()" value="" size="15" maxlength="60" onkeyup="valid_username(this.form.test_user,this.form.test_pass)" />
                  <img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_user_ok" width="13" height="12" id="img_user_ok" longdesc="Usuario aceptado" style="display:none" />
				  <img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_user_mal" width="13" height="12" id="img_user_mal" longdesc="Usuario rechazado" /></td>
                </tr>
              <tr>
                <td>Contraseña</td>
                </tr>
              <tr>
                <td><input name="test_pass" type="password" class="flat" id="test_pass" onfocus="this.select()" value="" size="15" maxlength="60" onkeyup="valid_username(this.form.test_user,this.form.test_pass)" />
                  <img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass_ok" width="13" height="12" id="img_pass_ok" longdesc="Contraseña aceptada" style="display:none" />
				  <img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass_mal" width="13" height="12" id="img_pass_mal" longdesc="Contraseña rechazada" /></td>
                </tr>
              <tr>
                <td>Resultado</td>
                </tr>
              <tr>
                <td><div id="div_test_msg" class="ayuda" style="overflow:auto;height:150px;padding:5px;"> Instrucciones: <br />Digite un usuario y contraseña para validar las reglas especificadas.</div></td>
                </tr>
              
            </table></td>
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
      <td align="left" class="subTitulo"><input type="button" name="Regresar" value="Regresar" class="btnAnterior" onclick="location.href='?tab=pass';">
      <input type="submit" name="check-password" value="Validar en el servidor" class="btnAplicar" onclick="this.form.target='frame_test'; " />
	  <iframe src="about:blank" name="frame_test" id="frame_test" width="500" style="display:none">...</iframe>
	  </td>
    </tr>
  </table>
</cfoutput>

<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#data#"/>
<script type="text/javascript">
function o(s){
	return document.all ? document.all[s] : document.getElementById(s);
}
function valid_username(u,p) {
	var div = o('div_test_msg');
	if (!document.origMsg) {
		document.origMsg = div.innerHTML;
	}
		var valida = validarPassword(u.value,p.value);
		if ( valida.erruser.length == 0 && valida.errpass.length == 0)
			div.innerHTML = 'Datos aceptados:<ul><li>Usuario y contraseña válidos</li></ul>';
		else
			div.innerHTML = 'Se detectaron los siguientes errores:<ul><li>' + valida.erruser.concat(valida.errpass).join('<li>') + '</li></ul>';
		o('img_user_ok').style.display = !valida.erruser.length ? '' : 'none';
		o('img_user_mal').style.display = valida.erruser.length ? '' : 'none';
		o('img_pass_ok').style.display = !valida.errpass.length ? '' : 'none';
		o('img_pass_mal').style.display = valida.errpass.length ? '' : 'none';
}
function probarPassword(f,u,p){
	o('frame_test').src = '/cfmx/asp/admin/politicas/global/check.cfm?u='+escape(u.value) + '&p=' + escape(p.value);
}
</script>