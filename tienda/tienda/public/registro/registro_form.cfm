<script type="text/javascript">
<!--
function validarLogin(f) {
	if (!f.j_username.value.match(/^.+@.+\...+$/)) {
		alert("Escriba su dirección de correo electrónico");
		f.j_username.focus();
		return false;
	}
	if (f.j_password.value == '') {
		alert("Introduzca su contraseña");
		f.j_password.focus();
		return false;
	}
	return true;
}
function validarRegistro(f) {
	if (!f.email.value.match(/^.+@.+\...+$/)) {
		alert("Escriba su dirección de correo electrónico");
		f.email.focus();
		return false;
	}
	if (f.pass.value == '') {
		alert("Introduzca su contraseña");
		f.pass.value = "";
		f.pass2.value = "";
		f.pass.focus();
		return false;
	}
	if (f.pass.value != f.pass2.value) {
		alert("Debe especificar la misma contraseña en ambas casillas."+String.fromCharCode(13)+"Este control le asegura que introdujo la contraseña que usted desea");
		f.pass.value = "";
		f.pass2.value = "";
		f.pass.focus();
		return false;
	}
	return true;
}
//-->
</script>
<table width="692"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="top">
    <td width="297"><form name="formlogin" method="post" action="login.cfm" onSubmit="return validarLogin(this);">
      <cfquery datasource="asp" name="alias">
  select ce.CEaliaslogin from CuentaEmpresarial ce, Empresa e where ce.CEcodigo = e.CEcodigo and e.Ereferencia = #session.comprar_Ecodigo#
      </cfquery>
      <cfif len(alias.CEaliaslogin)>
        <cfoutput>
          <input type="hidden" name="j_empresa" id="j_empresa" value="#alias.CEaliaslogin#">
        </cfoutput>
      </cfif>
      <table border="0">
        <tr>
          <td colspan="3" class="tituloListas"><img src="arrow_rt.gif" width="12" height="17" border="0"> Si ya hab&iacute;a comprado antes </td>
        </tr>
        <tr>
          <td width="12" class="small">&nbsp;</td>
          <td colspan="2" class="small">Introduzca su correo y su contrase&ntilde;a</td>
          </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td width="123" valign="top">&nbsp;</td>
          <td width="164" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Correo electr&oacute;nico</td>
          <td valign="top"><input style="width:160px" name="j_username" type="text" id="j_username" size="30" maxlength="60" onFocus="this.select()"></td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top">Contrase&ntilde;a </td>
          <td valign="top"><input style="width:160px" name="j_password" type="password" id="j_password" size="30" maxlength="30" onFocus="this.select()">
              <br>
          </td>
        </tr>
        <tr>
          <td colspan="3" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" align="center">
            <input name="Registrar2" type="submit" id="Registrar3" value="Ingresar &gt;&gt;"></td>
        </tr>
      </table>
    </form></td>
    <td width="20">&nbsp;</td>
    <td width="375"><form name="form1" method="post" action="registro_go.cfm" onSubmit="return validarRegistro(this);">
      <table width="362" border="0">
        <tr>
          <td colspan="3" class="tituloListas"> <img src="arrow_rt.gif" width="12" height="17" border="0"> Si es su primer compra </td>
          </tr>
        <tr>
          <td width="20" valign="top">&nbsp;</td>
          <td width="164" valign="top">&nbsp;</td>
          <td width="164" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Nombre (*) </td>
          <td valign="top"><input style="width:160px" name="nombre" type="text" id="nombre2" size="30" maxlength="60" onFocus="this.select()"></td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Apellido 1 (*) </td>
          <td valign="top"><input style="width:160px" name="apellido1" type="text" id="apellido12" size="30" maxlength="60" onFocus="this.select()"></td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Apellido 2 </td>
          <td valign="top"><input style="width:160px" name="apellido2" type="text" id="apellido22" size="30" maxlength="60" onFocus="this.select()"></td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Correo electr&oacute;nico (*) </td>
          <td valign="top"><input style="width:160px" name="email" type="text" id="email2" size="30" maxlength="60" onFocus="this.select()"></td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Contrase&ntilde;a </td>
          <td valign="top"><input style="width:160px" name="pass" type="password" id="pass3" size="30" maxlength="30" onFocus="this.select()">
              <br>
          </td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top" nowrap>Confirmar contrase&ntilde;a </td>
          <td valign="top"><input style="width:160px" name="pass2" type="password" id="pass22" size="30" maxlength="30" onFocus="this.select()"></td>
        </tr>
        <tr>
          <td align="justify" class="small">&nbsp;</td>
          <td colspan="2" align="justify" class="small"><strong>E</strong>l registro de clientes es gratuito, y le permitir&aacute; realizar el seguimiento de sus pedidos.<br>
            <strong>E</strong>s muy importante que escriba correctamente su direcci&oacute;n de correo electr&oacute;nico, ya que le estaremos enviando informaci&oacute;n sobre el estado de su env&iacute;o. <br>
            <strong>A</strong>dicionalmente, el correo electr&oacute;nico que introduzca aqu&iacute; ser&aacute; su identificaci&oacute;n para conectarse a nuestra p&aacute;gina web. </td>
        </tr>
        <tr>
          <td colspan="3" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3" align="center">
            <input name="Registrar" type="submit" id="Registrar4" value="Registrarme >>"></td>
        </tr>
      </table>
    </form></td>
  </tr>
</table>
