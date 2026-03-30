<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<cfparam name="url.logintext" default="">
<head><title>MiGesti&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" >
<link href="login.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript" src="../catalogos/passwd.js" >//Password</script>
</head>
<body><table border="0" width="80%" cellspacing="0" cellpadding="0" align="center">
<tr>
      <td width="1%"><a href="/"><img src="login-migestion.gif" alt="MiGestion" border="0" /></a></td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="signon-ayuda.cfm">Ayuda</a> 
              - <a href="../../logout/logout.cfm">Iniciar 
              sesi&oacute;n </a></td>
          </tr></table>
        <hr size="1" /></td></tr>
</table>
<cfoutput>
<form method="post" name="f" action="signup3-apply.cfm" onSubmit="return valida(this, '#url.logintext#');" >
<input type="hidden" name="logintext" value="#url.logintext#">
  <table border="0" width="80%" cellspacing="4" cellpadding="4" align="center">
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
              <ul>
                <li>Tener un m&iacute;nimo de seis caracteres.</li>
                <li>Contener letras y n&uacute;meros.</li>
                <li>Ser diferente al usuario. Debe haber al menos cuatro diferencias.</li>
                <li>No puede ser parte del usuario ni viceversa. 
              </ul>
              <strong>Despu&eacute;s de realizar el cambio de contrase&ntilde;a
              y pregunta secreta,  finalizar&aacute; la sesi&oacute;n en la que
              se encuentra trabajando y deber&aacute; iniciar una nueva sesi&oacute;n con
              el nuevo usuario y contrase&ntilde;a especificados</strong> </td>
          </tr>
        </table></td>
      <td valign="top" class="g"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="3">
          <!--DWLayoutTable-->
          <tr> 
            <td colspan="3" valign="top" class="h"> <p>Contrase&ntilde;a nueva</p></td>
          </tr>
          <tr> 
            <td colspan="3" valign="top" class="error">
				<cfif IsDefined("url.error") AND url.error EQ 1>
                	Complete los datos solicitados
				<cfelseif IsDefined("url.error") AND url.error EQ 2>
                	La contrase&ntilde;a especificada en ambos espacios debe coincidir
				</cfif>
			</td>
          </tr>
          <tr>
              <td colspan="2" valign="top" >Usuario especificado</td>
              <td valign="top" ><strong>#url.logintext#</strong></td>
          </tr>
          <tr> 
            <td colspan="2" valign="top" >Contrase&ntilde;a temporal</td>
            <td valign="top" ><input name="oldpass" type="password" id="oldpass" value="" size="30" onFocus="this.select()" /></td>
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
            <td colspan="3" valign="top" class="h"> Identificaci&oacute;n personal</td>
          </tr>
          <tr> 
            <td colspan="3" valign="top" ></td>
          </tr>
          <tr> 
            <td colspan="2" valign="top">Pregunta</td>
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
            <td colspan="2" valign="top">Respuesta</td>
            <td valign="top"> <input name="respuesta" type="text" value="" size="30" maxlength="60" /></td>
          </tr>
          <tr> 
            <td colspan="3" align="center" valign="top"><p> 
                <input type="button" value="Cancelar" onClick="self.location.href='../../logout/logout.cfm'" />
                <input type="submit" value="Finalizar" />
              </p></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</cfoutput>		
<script type="text/javascript">
		<!--
			document.f.oldpass.focus();
		//-->
		</script>
</body>
</html>
