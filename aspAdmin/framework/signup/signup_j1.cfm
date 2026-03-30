<html>
<head><title>MiGesti&oacute;n</title>
<link href="login.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script type="text/javascript" language="JavaScript" src="signup2.js">//</script>
</head>
<body>
<center><table border="0" width="585" cellspacing="0" cellpadding="0">
<tr>
      <td width="1%"><a href="/"><img src="login-migestion.gif" alt="MiGestion" border="0" /></a></td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="signon-ayuda.jsp">Ayuda</a> 
              - <a href="../../logout/logout.cfm">Iniciar 
              sesi&oacute;n </a></td>
          </tr></table>
        <hr size="1" /></td></tr></table>
  <form method="post" name="f" action="signup_j1-apply.cfm" >
    <table width="585" cellspacing="4" cellpadding="4" border="0" class="g" >
      <!--DWLayoutTable-->
      <tr > 
        <td colspan="2" class="h">Ind&iacute;quenos su usuario</td>
      </tr>
      <tr> 
        <td height="3" colspan="2" valign="top" class="t"> <p>Si usted ya posee
                un usuario activo podr&aacute; continuar utiliz&aacute;ndolo. Por su seguridad,
                debe digitar la informaci&oacute;n de su usuario actual para poderle
                asignar los permisos que tiene actualmente en su usuario temporal.
                <br>
                Una vez validada esta informaci&oacute;n, su usuario anterior se inhabilitar&aacute;
                y continuar&aacute; usando el que especifique en esta p&aacute;gina.</p>        </td>
        </tr>
    <tr>
      <td class="err" colspan="2">
	  	<cfif IsDefined("url.error") AND url.error EQ 1>
		  	Por favor, indique su usuario
              y contrase&ntilde;a actuales. Estas son necesarias para validar que este
              usuario es realmente suyo.
	  	<cfelseif IsDefined("url.error") AND url.error EQ 2>
		  	La contrase&ntilde;a y el usuario especificado no son v&aacute;lidos.
	  	<cfelseif IsDefined("url.error") AND url.error EQ 3>
			El login especificado no existe o no est&aacute; activo.
	    </cfif>
	  </td></tr>
      <tr>
          <td height="4" valign="top" class="t"><p>Usuario</p></td>
          <td valign="top" class="e"><input type="text" name="loginex" id="loginex" value="" size="30" onFocus="this.select()" /></td>
      </tr>
      <tr>
          <td height="15" valign="top" class="t"><p>Contrase&ntilde;a</p></td>
          <td valign="top" class="e"><input type="password" name="passwdex" id="passwdex" size="30" onFocus="this.select()" /></td>
      </tr>
      <tr valign="top">
          <td colspan="2" class="t"><p>Si no posee una cuenta activa, o si desea
                  crear una cuenta nueva, haga clic <a href="signup2.cfm">aqu&iacute;</a>.</p></td>
      </tr>
      <tr> 
        <td colspan="2" align="center"><p> 
            <input type="button" value="Cancelar" onClick="self.location.href='../../logout/logout.cfm'" />
            <input type="submit" value="Continuar &gt; " />
          </p></td>
      </tr>
    </table>
  </form></center>
		<script type="text/javascript">
		<!--
			document.f.loginex.focus();
		//-->
		</script>
</body>
</html>
