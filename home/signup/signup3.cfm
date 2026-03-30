<cfset Request.PNAVEGACION_SHOWN = 1>
<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#session.CEcodigo#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#dataPoliticas#"/>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Login
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">


<cfparam name="url.logintext" default="">
<link href="signup.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript" src="../public/login.js" >//Password</script>
<script language="JavaScript" type="text/JavaScript" src="passwd.js" >//Password</script>
<script language="JavaScript" type="text/JavaScript" src="signup3.js" >//Password</script>

<table border="0" width="100%" cellspacing="0" cellpadding="0" align="center">
<tr>
      <td width="1%">&nbsp;</td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="signon-ayuda.cfm">Ayuda</a> 
              - <a href="../public/logout.cfm">Iniciar 
              sesi&oacute;n </a></td>
          </tr></table>
        <hr size="1" /></td></tr>
</table>
<cfquery datasource="asp" name="aliaslogin">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfoutput>
<form method="post" name="f" action="signup3-apply.cfm" onSubmit="return validarSignup (this)" >
<input type="hidden" name="logintext" value="#url.logintext#">
<input type="hidden" name="aliaslogin" value="#Trim(aliaslogin.CEaliaslogin)#">
  <table border="0" width="100%" cellspacing="4" cellpadding="4" align="center">
    <!--DWLayoutTable-->
    <tr> 
      <td width="50%" rowspan="2" valign="top" class="g" ><table width="100%" border="0" align="center" cellpadding="4" cellspacing="4">
          <!--DWLayoutTable-->
          <tr> 
            <td  valign="top" class="h"><p>Instrucciones</p></td>
          </tr>
          <tr> 
            <td  valign="top" class="ayuda"><p>Se recomienda realizar 
                este cambio de manera peri&oacute;dica, con el fin de incrementar 
                la seguridad de su informaci&oacute;n.<br>
                Junto con la contrase&ntilde;a, usted podr&aacute; modificar
                la  informaci&oacute;n personal que lo identifica como due&ntilde;o
                 de la cuenta, y que solamente usted deber&iacute;a conocer.
                 Si  omite esta informaci&oacute;n y llega a olvidar su contrase&ntilde;a,
                 deber&aacute; comunicarse
                 con  el administrador.</p>
                <p>Por su propia seguridad, seleccione una contrase&ntilde;a que 
                cumpla con las siguientes caracter&iacute;siticas:</p>

<cfinvoke component="home.Componentes.ValidarPassword" method="reglas" data="#dataPoliticas#" returnvariable="reglas"/>
	<cfif ArrayLen(reglas.errpass)>
	<ul>
	<li class="textoAyuda" style="border:none"><cfoutput>#ArrayToList( reglas.errpass, '</li><li class="textoAyuda" style="border:none">')#</cfoutput></li>
	</ul>
	</cfif>
              <strong>Despu&eacute;s de realizar el cambio de contrase&ntilde;a
              y pregunta secreta,  finalizar&aacute; la sesi&oacute;n en la que
              se encuentra trabajando y deber&aacute; iniciar una nueva sesi&oacute;n con
              el nuevo usuario y contrase&ntilde;a especificados</strong> </td>
          </tr>
        </table></td>
      <td valign="top" class="g"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="3">
          <!--DWLayoutTable-->
          <tr> 
            <td colspan="2" valign="top" class="h"> <p>Contrase&ntilde;a nueva</p></td>
          </tr>
          <tr> 
            <td colspan="2" valign="top" class="error">
				<cfif IsDefined("url.error") AND url.error EQ 1>
                	Complete los datos solicitados
				<cfelseif IsDefined("url.error") AND url.error EQ 2>
                	La contrase&ntilde;a especificada en ambos espacios debe coincidir
				<cfelseif IsDefined("url.error") AND url.error EQ 3>
                	&iexcl;La contrase&ntilde;a temporal no es v&aacute;lida!. Por favor, verif&iacute;quela.
				<cfelseif IsDefined("url.error") AND url.error EQ 5>
					<cfparam name="session.errpass" default="Contraseña inválida">
					<cfoutput>#session.errpass#</cfoutput><cfset StructDelete(session, 'errpass')>
                <cfelseif isdefined("url.error") and url.error eq '6'>
					<cfoutput>
                        <cf_translate  key="LB_SuContrasenanopuedeserrepetida">Su contrase&ntilde;a NO puede ser igual con las #data.pass.valida.lista# anteriores. Por favor, seleccione una nueva contrase&ntilde;a</cf_translate>.
                    </cfoutput>
				</cfif>
			</td>
          </tr>
          <tr>
              <td valign="top" >Usuario solicitado </td>
              <td width="60%" valign="top" ><strong>#url.logintext#</strong></td>
          </tr>
          <tr> 
            <td valign="top" >Contrase&ntilde;a temporal</td>
            <td valign="top" ><input name="oldpass" type="password" id="oldpass" value="" size="30"  onFocus="this.select()"/></td>
          </tr>
          <tr> 
            <td valign="top" >Contrase&ntilde;a deseada</td>
            <td valign="top" ><input name="newpass" type="password" id="newpass" value="" size="30" onFocus="this.select()"   onkeyup="valid_password1( this.value)"/>
            <img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass1_ok" width="13" height="12" id="img_pass1_ok" longdesc="Password aceptado" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass1_mal" width="13" height="12" id="img_pass1_mal" longdesc="Password rechazado" />
            </td>
          </tr>
          <tr> 
            <td valign="top" >Confirme la nueva contrase&ntilde;a</td>
            <td valign="top" ><input name="newpass2" type="password" id="newpass2" value="" size="30"  onFocus="this.select()"   onkeyup="valid_password2( this.value)" />
            <img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass2_ok" width="13" height="12" id="img_pass2_ok" longdesc="Password aceptado" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass2_mal" width="13" height="12" id="img_pass2_mal" longdesc="Password rechazad" />
	
            </td>
          </tr>
          <tr>
            <td colspan="2" valign="top" >              <input type="checkbox" name="recordar" id="recordar" value="1">
              Recordar este usuario en mi computador              </td>
            </tr>
          <tr> 
            <td colspan="2" valign="top" class="h"> Identificaci&oacute;n personal</td>
            </tr>
          <tr> 
            <td colspan="2" valign="top" ></td>
          </tr>
          <tr> 
            <td valign="top">Pregunta</td>
            <td valign="top" ><select name="pregunta" id="pregunta" >
                <option>&iquest; Cu&aacute;l es mi n&uacute;mero de la suerte 
                ?</option>
                <option>&iquest; C&oacute;mo se llama mi suegra ?</option>
                <option>&iquest; De qu&eacute; color fue mi primer auto ?</option>
                <option>&iquest; Cu&aacute;ntos hermanos tengo ?</option>
                <option selected>Nombre de mi mascota</option>
                <option>Segundo apellido de mi mam&aacute;</option>
                <option value="">Otra (especifique)</option>
              </select> </td>
          </tr>
          <tr> 
            <td valign="top">Respuesta</td>
            <td valign="top"> <input name="respuesta" type="text" value="" size="30" maxlength="60" /></td>
          </tr>
          <tr> 
            <td colspan="2" align="center" valign="top"><p> 
                <input type="button" value="Cancelar" onClick="self.location.href='../public/logout.cfm'" />
                <input type="submit" value="Finalizar" id="Finalizar" disabled="disabled" />
              </p></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</cfoutput>		
<script type="text/javascript">
	function obid(s) {
		return document.all ? document.all[s] : document.getElementById(s);
	}
	function valid_password1(u ) {
		var valida = validarPassword(u, '');
		obid('img_pass1_ok').style.display = !valida.erruser.length ? '' : 'none';
		obid('img_pass1_mal').style.display = valida.erruser.length ? '' : 'none';
		if(valida.erruser.length==0 && document.getElementById("newpass2").value == document.getElementById("newpass").value){
			document.f.Finalizar.disabled="";
		}
		else{
			document.f.Finalizar.disabled="disabled";
		}
	}
	function valid_password2(u ) {
		var valida = validarPassword(u, '');
		obid('img_pass2_ok').style.display = !valida.erruser.length &&  document.getElementById("newpass2").value == document.getElementById("newpass").value ?'' : 'none';
		obid('img_pass2_mal').style.display = valida.erruser.length || document.getElementById("newpass2").value != document.getElementById("newpass").value? '' : 'none';
		if(valida.erruser.length==0 && document.getElementById("newpass2").value == document.getElementById("newpass").value){
			document.f.Finalizar.disabled="";
		}
		else{
			document.f.Finalizar.disabled="disabled";
		}
	}
<!--
	document.f.oldpass.focus();
//-->
</script>

</cf_templatearea>
</cf_template>
