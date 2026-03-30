<cfparam name="url.uri" default="login.cfm">
<script type="text/javascript" src="login.js"></script>
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="return validarLogin(this);" style="margin:0 " action="<cfoutput>#url.uri#</cfoutput>" method="post" >

	  <table width="618" cellpadding="0" cellspacing="0" border="0">
		<!--DWLayoutTable-->
		<tr> 
		  <td width="358" height="119" valign="top" class="textblack">
			<p><font size="2" face="Verdana">Usted debe conectarse
			    para acceder esta &aacute;rea del sitio. Por favor
			  digite su clave de usuario y contraseña y presione el bot&oacute;n <font color="#0000FF">Conectarse</font>.</font></p>
			<p><font size="2" face="Verdana">Si usted no tiene clave
			    de usuario ni contrase&ntilde;a, por favor cont&aacute;ctenos
			  para prestarle este servicio.</font></p></td>
		  <td width="258" valign="top">
			<table width="273" height="150" border="0" cellpadding="0" cellspacing="0" background="/cfmx/sif/logout/login02/images/main05.jpg">
			  <tr>
				<td width="23">&nbsp;</td>
				<td height="45" colspan="2" align="center" class="etiqblack">
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Conectarse
				</td>
				</tr>
			  <tr>
				<td height="21">&nbsp;</td>
				<td width="115" class="etiqblack16">Usuario
				</td>
				<td width="135" class="etiqblack">
				  <input type="text" name="j_username" size="12" tabindex="1" onFocus="this.select()" >
				  </td>
			  </tr>
			  <tr>
				<td height="29">&nbsp;</td>
				<td class="etiqblack16">Contrase&ntilde;a</td>
				<td>
					<input type="password" name="j_password" size="14" tabindex="2" onfocus="this.select()" >
				</td>
			  </tr>
			  <tr>
				<td colspan="3" height="19" align="center"><input type="submit" name="Submit" value="Conectarse"></td>
			  </tr>
			  <tr>
				<td colspan="3" height="30" align="center" class="etiqblack">
					<input type="checkbox" name="recordar" value="checkbox">
				  	Recordar mi usuario en este computador
				</td>
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
			<td align="center" class="textblack14"><strong>No se pudo iniciar la sesi&oacute;n.</strong></td>
		  </tr>
		  <tr align="center" class="textblack14">
			<td><a href="/cfmx/sif/logout/recordar/recordar.cfm"><font color="#0000FF">¿Necesita
		  ayuda para ingresar?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    </			</a></td>
		  </tr>	  
		  <tr>
			<td align="center" class="etiqblack">¡Olvidé mi contraseña!.</td>
		  </tr>
		</table>
	</cfif>
<cfelse>
	<cflocation url="#Url.uri#">
</cfif>