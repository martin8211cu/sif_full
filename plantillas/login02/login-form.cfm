<cfparam name="url.uri" default="/cfmx/plantillas/login02/login.cfm">
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/home/public/login.js">
</script>
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="return validarLogin(this);" action="<cfoutput>#url.uri#</cfoutput>" method="post" >

	  <table width="618" cellpadding="2" cellspacing="0" border="0" >
		<!--DWLayoutTable-->
		<tr> 
		  <td width="358" height="119" valign="top" class="style9">
			<p><font size="2" face="Verdana">Usted debe conectarse
			    para acceder esta &aacute;rea del sitio. Por favor
			  digite su clave de usuario y contrase&ntilde;a y presione el bot&oacute;n <font color="#0000FF">Conectarse</font>.</font></p>
			<p><font size="2" face="Verdana">Si usted no tiene clave
			    de usuario ni contrase&ntilde;a, por favor cont&aacute;ctenos
			  para prestarle este servicio.</font></p></td>
		  <td width="258" valign="top" class="g">
			<table width="273" height="150" border="0" cellpadding="0" cellspacing="0" background="/cfmx/plantillas/login02/images/main05.jpg" style="background-repeat:no-repeat ">
			  <tr>
				<td width="23">&nbsp;</td>
				<td height="45" colspan="2"><div align="center" class="style8">
				  <div align="left"><font color="#CCCCCC" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Conectarse</font></div>
				</div></td>
			  </tr>
<cfif Len(session.sitio.CEcodigo) EQ 0>
<tr><td></td>
			  <td valign="top" height="1">
			  	<div align="left"><span class="style1" style="color:#ffffff "><font size="2">Empresa</font> </span> </div></td>
			  <td valign="top" height="1">
        <input type="text" name="j_empresa" style="font-size:12px" size="12" tabindex="1" onFocus="this.select()" ></td></tr>
</cfif>			  
			  <tr>
				<td height="21">&nbsp;</td>
				<td width="115" align="left" style="color:#ffffff "><font size="2">Usuario</font></td>
				<td width="135"><span class="style1">
				  <input type="text" name="j_username" style="font-size:12px" size="12" tabindex="2" onFocus="this.select()" >
				  </span></td>
			  </tr>
			  <tr>
				<td height="21">&nbsp;</td>
				<td align="left"><span class="style1" style="color:#ffffff "><font size="2">Contrase&ntilde;a</font></span></td>
				<td align="left">
				  <div align="left">
					<input type="password" name="j_password" style="font-size:12px" size="14" tabindex="3" onfocus="this.select()" >
				  </div></td>
			  </tr><tr>
				<td colspan="3" height="19"><br>
<div align="center"><input type="submit" name="Submit" value="Conectarse"></div></td>
			  </tr>
			  <tr >
				<td height="30" colspan="3" valign="top">				 
<br>
<div align="center">
				<input type="checkbox" name="recordar" id="recordar" value="checkbox">
				  <label for="recordar"><span class="style1" style="font-size:10px">Recordar mi usuario en este computador</span></label>
				</div></td>
			  </tr>
			</table>			
			</td>
		</tr>
		<tr> 
		  <td height="6"></td>
		  <td></td>
		</tr>
	  </table>
	</form>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
	
	<cfif IsDefined("url.errormsg")>
		<table border="0" cellpadding="1" cellspacing="1" width="400">	  
		  <tr>
			<td align="center" class="style6"><strong>No se pudo iniciar la sesi&oacute;n.</strong></td>
		  </tr>
		  <tr align="center" class="style6">
			<td><a href="/cfmx/home/public/recordar.cfm"><font color="#0000FF">&iquest;Necesita
		  ayuda para ingresar?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    </font></a></td>
		  </tr>	  
		  <tr>
			<td align="center" class="style1"><a href="/cfmx/home/public/recordar.cfm">&iexcl;Olvid&eacute; mi contrase&ntilde;a!</a></td>
		  </tr>
		</table>
	</cfif>
<cfelse>
	<cflocation url="#Url.uri#">
</cfif>
