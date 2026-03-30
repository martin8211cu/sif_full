<!--- OJO se incluyo este .js que estaba el login.cfm --->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/home/public/login.js">
</script>
<cfparam name="url.uri" default="/cfmx/plantillas/login02/index.cfm">
<style type="text/css">
<!--
.style1 {font-weight: bold}
-->
</style>

<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="javascript:return validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" style="margin:0">
		<table background="/cfmx/plantillas/login02/images/fondo_rombos9.gif" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4" height="11">
				
<cfif Len(session.sitio.CEcodigo) EQ 0>
<tr>
			  <td valign="top" height="1"><div align="left" class="style9"><strong><font size="1" face="Verdana">Empresa:</font></strong></div></td>
			  <td valign="top" height="1">
        <input type="text" name="j_empresa" size="12" style="font-size: 8pt" onFocus="this.select()" tabindex="1"></td></tr>
</cfif>			<tr>
			  <td width="32%" valign="top" height="17"> 
				<div align="left" class="style9"><strong><font size="1" face="Verdana">Usuario:</font></strong></div></td>
			  <td valign="top" height="17">
			 
				<p style="margin-top: 0; margin-bottom: 0">
				<input type="text" name="j_username" size="12" style="font-size: 8pt" onFocus="this.select()" tabindex="2"></p>
			  </td>
			</tr>
			<tr>
			  <td valign="top" height="1"><div align="left" class="style9"><strong><font size="1" face="Verdana">Contrase&ntilde;a:</font></strong></div></td>
			  <td valign="top" height="1"><input type="password" name="j_password" size="14" style="font-size: 8pt" onFocus="this.select()" tabindex="3"></td>
			</tr>	<tr>
				<td colspan="2" >				  <div align="center"><input type="checkbox" name="recordar" value="checkbox" tabindex="4">
				  <span class="style9"><strong><font size="1" face="Verdana">Recordar mi usuario en este computador</font></strong></span>
				</div></td>
			</tr>		
			<tr>
			  <td width="32%" valign="top" height="22"><p style="margin-top: 3; margin-bottom: 0; margin-left:5"></td>
			  <td width="62%" valign="top" height="22"><p style="margin-top: 0; margin-bottom: 0">
				<input type="submit" value="Conectarse" name="Submit" style="font-size: 8pt" tabindex="5"></td>
			</tr>
	  </table>
  </form>	
		<cfif IsDefined("url.errormsg")>
			<table background="/cfmx/plantillas/login02/images/fondo3.gif" border="0" cellpadding="1" cellspacing="1" width="180">	  
			  <tr>
				<td align="center" class="style6"><strong>No se pudo iniciar la sesi&oacute;n.</strong></td>
			  </tr>
			  <tr align="center" class="style6">
				<td><a href="/cfmx/home/public/recordar.cfm"><font color="#FFFF00">&iquest;Necesita
			  ayuda para ingresar?</font></a></td>
			  </tr>	  
			  <tr>
				<td align="center" class="style1">&iexcl;Olvid&eacute; mi contrase&ntilde;a!.</td>
			  </tr>
			</table>
		</cfif>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
<cfelse>
	<form name="login" action="/cfmx/home/public/logout.cfm" method="post" style="margin:0">
	<table width="150" height="27" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		<td align="center"><input type="submit" name="Submit" value="Desconectarse"></td>
	  </tr>
	</table>	
	<input type="hidden" name="uri" value="/cfmx/plantillas/login02/index.cfm">
	</form>
</cfif>

