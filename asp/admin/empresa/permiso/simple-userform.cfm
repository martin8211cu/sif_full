<cfoutput>
<div id="divuserform" style="display:none;position:absolute;top:270px;background-color:white;border:4px solid gray;background-color:##f0f0f0">
<form name="frmUsuarios" id="frmUsuarios" method="post" action="simple-go.cfm" target="myframe"
	onSubmit="return usubmit(this)" style="margin:0;">
	<input type="hidden" name="action"  value="uadd" />
	<input type="hidden" name="usucodigo"  value="" />
	
	<table width="784" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="256" valign="top" class="textoAyuda"><div id="div_test_msg" class="textoAyuda">
        <div class="subTitulo">
          Reglas de validación del usuario:</div>
            <cfinvoke component="home.Componentes.ValidarPassword" method="reglas" data="#dataPoliticas#" returnvariable="reglas"/>        
        <cfif ArrayLen(reglas.erruser)>
              <ul>
                <li class="textoAyuda" style="border:none">#ArrayToList( reglas.erruser, '</li><li class="textoAyuda" style="border:none">')#</li>
              </ul>
            </cfif>
            <cfif ArrayLen(reglas.errpass)>
              <ul>
                <li class="textoAyuda" style="border:none">#ArrayToList( reglas.errpass, '</li><li class="textoAyuda" style="border:none">')#</li>
              </ul>
            </cfif>
      </div></td>
    <td width="19" valign="top" class="textoAyuda"><img src="blank.gif" border="0" width="1" height="320" /></td>
    <td width="497" valign="top"><table width="497" border="0" cellpadding="2" cellspacing="0" align="center">
  
    <tr>
      <td class="subTitulo" colspan="2">Agregar usuario </td>
      </tr>
    <tr>
    <td width="151">Nombre (*) </td>
    <td width="284"><input type="text" name="nombre" style="border:1px solid black" size="30"
		value="" onfocus="this.select()" onkeyup="valid_password( this.form )"/></td>
    </tr>
  <tr>
    <td>Apellido (*) </td>
    <td><input type="text" name="apellido1" style="border:1px solid black" size="30"
		value="" onfocus="this.select()" onkeyup="valid_password( this.form )"/></td>
    </tr>
  <tr>
    <td>Usuario</td>
    <td>
		<input name="username" type="text" id="username" style="border:1px solid black"
			size="30" maxlength="30" value=""
			onfocus="this.select()" onblur="loginquery(this.form)" 
			onkeyup="valid_password( this.form )" />
        <img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_user_ok" width="13" height="12" id="img_user_ok" longdesc="Usuario aceptado" style="display:none" /> <img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_user_mal" width="13" height="12" id="img_user_mal" longdesc="Usuario rechazado" /> </td>
    </tr>
  <tr>
    <td>Contrase&ntilde;a</td>
    <td>
		<input name="password" type="password" id="password" style="border:1px solid black" size="30" maxlength="30" value=""
			onfocus="this.select()" onblur="loginquery(this.form)"
			onkeyup="valid_password( this.form )" />
		<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass_ok" width="13" height="12" id="img_pass_ok" longdesc="Contraseña aceptada" style="display:none" />
		<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass_mal" width="13" height="12" id="img_pass_mal" longdesc="Contraseña rechazada" />	</td>
    </tr>
  <tr>
    <td>Confirmar contrase&ntilde;a</td>
    <td><input name="password2" type="password" id="password2" style="border:1px solid black" size="30" maxlength="30" value="" onFocus="javascript: this.select();"  onkeyup="valid_password( this.form )" />
		<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass2_ok" width="13" height="12" id="img_pass2_ok" longdesc="Contraseña aceptada" style="display:none" />
		<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass2_mal" width="13" height="12" id="img_pass2_mal" longdesc="Contraseña rechazada" />	</td>
    </tr>
  <tr>
    <td>Dirección de email </td>
    <td><input type="text" name="email1" style="border:1px solid black" size="30"
		value="" onfocus="this.select()" onkeyup="valid_password( this.form )"/></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" value="Enviar" class="btnGuardar">
	<input type="button" value="Cancelar" class="btnLimpiar" onclick="hideUser()" />
	</td>
    </tr>
  
</table></td>
  </tr>
</table></form></div>
<script type="text/javascript">
	hideUser();
</script>
</cfoutput>
