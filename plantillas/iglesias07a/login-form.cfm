<style type="text/css">
<!--
	.loginstyle1 {
		color: #FFFFFF;
		font-weight: bold;
	}
	.loginstyle6 {font-size: 14px; color: #FF0000;}
	.loginstyle7 {
		font-size: 12px;
		color: #FFFFFF;
	}
	.loginstyle8 {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-weight: bold;
		color: #FFFFFF;
	}
	.loginstyle9 {color: #003399}
	.loginstyle10 {
		color: #626262;
		font-size: 12px;
	}
	.loginstyle13 {font-size: 14px}
	.loginstyle14 {
		color: #003399;
		font-family: Arial;
		font-size: 14px;
		font-loginstyle: normal;
		font-weight: lighter;
	}
	.loginstyle16 {color: #0033FF}
	.loginstyle18 {
		color: #660066;
		font-size: 10px;
		font-weight: bold;
	}
	.loginstyle47 {color: #FFFFFF; font-weight: bold; }
	.loginstyle59 {
		color: #003399;
		font-weight: bold;
		font-size: 10px;
		font-family: Verdana, Arial, Helvetica, sans-serif;
	}
	.loginstyle60 {font-family: Verdana, Arial, Helvetica, sans-serif; color: #003399;}

-->
</style>

<cfparam name="url.uri" default="../login02/login.cfm">
<script type="text/javascript" src="login.js"></script>
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="return validarLogin(this);" style="margin:0 " action="<cfoutput>#url.uri#</cfoutput>" method="post" >

	  <table width="618" cellpadding="0" cellspacing="0" border="0" >
		<!--DWLayoutTable-->
		<tr> 
		  <td width="358" height="119" valign="top" class="loginstyle9">
			<p><font size="2" face="Verdana">Usted debe conectarse
			    para acceder esta &aacute;rea del sitio. Por favor
			  digite su clave de usuario y contraseña y presione el bot&oacute;n <font color="#0000FF">Conectarse</font>.</font></p>
			<p><font size="2" face="Verdana">Si usted no tiene clave
			    de usuario ni contrase&ntilde;a, por favor cont&aacute;ctenos
			  para prestarle este servicio.</font></p></td>
		  <td width="258" valign="top" class="g">
			<table width="273" height="150" border="0" cellpadding="0" cellspacing="0" background="/cfmx/sif/logout/login02/images/main05.jpg">
			  <tr>
				<td width="23">&nbsp;</td>
				<td height="45" colspan="2"><div align="center" class="loginstyle8">
				  <div align="left"><font color="#CCCCCC" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Conectarse</font></div>
				</div></td>
				</tr>
			  <tr>
				<td height="21">&nbsp;</td>
				<td width="115"><div align="left" class="loginstyle1">
				  <div align="left"><font size="2">Usuario</font></div>
				</div></td>
				<td width="135"><span class="loginstyle1">
				  <input type="text" name="j_username" size="12" tabindex="1" onFocus="this.select()" >
				  </span></td>
			  </tr>
			  <tr>
				<td height="29">&nbsp;</td>
				<td>
				  <div align="left"><span class="loginstyle1"><font size="2">Contrase&ntilde;a</font> </span> </div></td>
				<td>
				  <div align="left">
					<input type="password" name="j_password" size="14" tabindex="2" onfocus="this.select()" >
				  </div></td>
			  </tr>
			  <tr>
				<td colspan="3" height="19"><div align="center"><input type="submit" name="Submit" value="Conectarse"></div></td>
			  </tr>
			  <tr>
				<td colspan="3" height="30">				  <div align="center"><input type="checkbox" name="recordar" value="checkbox">
				  <span class="loginstyle1"><font size="2">Recordar mi usuario en este computador</font></span>
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
	<cfif IsDefined("url.errormsg")>
		<table border="0" cellpadding="1" cellspacing="1" width="400">	  
		  <tr>
			<td align="center" class="loginstyle6"><strong>No se pudo iniciar la sesi&oacute;n.</strong></td>
		  </tr>
		  <tr align="center" class="loginstyle6">
			<td><a href="/cfmx/sif/logout/recordar/recordar.cfm"><font color="#0000FF">¿Necesita
		  ayuda para ingresar?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    </font></a></td>
		  </tr>	  
		  <tr>
			<td align="center" class="loginstyle1">¡Olvidé mi contraseña!.</td>
		  </tr>
		</table>
	</cfif>
<cfelse>
	<cflocation url="#Url.uri#">
</cfif>