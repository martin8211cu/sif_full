<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
.style6 {font-size: 14px; color: #FF0000;}
.style7 {
	font-size: 12px;
	color: #FFFFFF;
}
.style8 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #FFFFFF;
}
-->
</style>
<cfparam name="url.uri" default="/cfmx/sif/default.cfm">
<form name="login" onsubmit="validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" style="margin:0">
<table width="273" height="150" border="0" cellpadding="0" cellspacing="0" background="images/main05.jpg">
  <tr>
    <td width="15">&nbsp;</td>
    <td height="51" colspan="2"><div align="center" class="style8">
      <div align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Conectarse</div>
    </div></td>
    </tr>
  <tr>
    <td height="21">&nbsp;</td>
    <td width="123"><div align="left" class="style1">
      <div align="left">Usuario</div>
    </div></td>
    <td width="135"><span class="style1">Contrase&ntilde;a
    </span></td>
  </tr>
  <tr>
    <td height="29">&nbsp;</td>
    <td>
      <div align="left">
        <input type="text" name="j_username" size="14" tabindex="1" onfocus="this.select()" >
        </div></td>
    <td>
      <div align="left">
        <input type="password" name="j_password" size="14" tabindex="2" onfocus="this.select()" >
      </div></td>
  </tr>
  <tr>
    <td colspan="3" height="19"><div align="center"><input type="submit" name="Submit" value="Conectarse"></div></td>
  </tr>
  <tr>
    <td colspan="3" height="30">
                <div align="center"><input type="checkbox" name="recordar" value="checkbox">
                <span class="style7">Recordar mi usuario en este computador</span>
	</div></td>
  </tr>
</table>
</form>
<cfif IsDefined("url.errormsg")>
<div align="center"><span class="style6">
No se pudo iniciar la sesi&oacute;n.<br><a href="recordar/recordar.cfm">¿Necesita ayuda para ingresar?<br>
¡Olvidé mi contraseña!.</a>
</span>
</div>
</cfif>
