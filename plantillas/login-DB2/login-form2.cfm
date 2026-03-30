<!--- OJO se incluyo este .js que estaba el login.cfm --->

<img border="0" src="images/bottom1.jpg" width="216" height="24" alt="">

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/home/public/login.js">
</script>
<cfparam name="url.uri" default="/cfmx/plantillas/login02/index.cfm">


<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="javascript:return validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" style="margin:0">
		<table border="0" cellpadding="0" cellspacing="0" style="background-image:url(/cfmx/plantillas/login02/images/fondo_rombos9.gif);border-color:#111111" width="216" id="AutoNumber4">
				
<cfif Len(session.sitio.CEcodigo) EQ 0>
<tr>
			  <td width="76" height="1" valign="top"><div align="left" class="style9"><strong><font size="1" face="Verdana">Empresa:</font></strong></div></td>
			  <td width="140" height="1" valign="top">
        <input type="text" name="j_empresa" size="12" style="font-size: 8pt" onFocus="this.select()" tabindex="1"></td></tr>
</cfif>			<tr>
			  <td valign="top" height="17"> 
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
				<td colspan="2" >				  <div align="center"><input type="checkbox" name="recordar" id="recordar" value="checkbox" tabindex="4">
				  <label for="recordar"><span class="style9"><strong><font size="1" face="Verdana">Recordar mi usuario en este computador</font></strong></span></label>
				</div></td>
			</tr>		
			<tr>
			  <td valign="top" height="22"><p style="margin-top: 3; margin-bottom: 0; margin-left:5"></td>
			  <td valign="top" height="22"><p style="margin-top: 0; margin-bottom: 0">
				<input type="submit" value="Conectarse" name="Submit" style="font-size: 8pt" tabindex="5"></td>
			</tr>
	  </table>
  </form>	
<img border="0" src="images/bottom1.jpg" width="216" height="24" alt="">
		
			<table border="0" cellpadding="1" cellspacing="1" width="216">	  
			 <cfif IsDefined("url.errormsg")> <tr>
				<td align="center" class="style6"><strong>No se pudo iniciar la sesi&oacute;n.</strong></td>
			  </tr></cfif>
			  <tr align="center">
				<td><a href="/cfmx/home/public/recordar.cfm"> <strong>&iquest;Necesita
			  ayuda para ingresar?</strong></a></td>
			  </tr>	  
			  <tr>
				<td align="center" ><a href="/cfmx/home/public/recordar.cfm"><strong>&iexcl;Olvid&eacute; mi contrase&ntilde;a!</strong></a></td>
			  </tr>
  </table>
		
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
<cfelse>
	<form name="login" action="/cfmx/home/public/logout.cfm" method="post" style="margin:0">
	<table width="216" height="27" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		<td align="center"><input type="submit" name="Submit" value="Desconectarse"></td>
	  </tr>
	</table>	
	<input type="hidden" name="uri" value="/cfmx/plantillas/login02/index.cfm">
	</form>
<img border="0" src="images/bottom1.jpg" width="216" height="24" alt="">
</cfif>


