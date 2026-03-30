<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Inicio de sesi&oacute;n - BRUJASFC
</cf_templatearea>
<cf_templatearea name="left">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="19%" id="AutoNumber2">
  <tr>
    <td width="100%" background="images/top1.jpg">
      <p style="margin-top: 3; margin-bottom: 0"><b> <font face="Verdana" size="2" color="#FFFFFF">Misi&oacute;n</font></b></td>
  </tr>
  <tr>
    <td width="100%" background="/cfmx/plantillas/login02/images/fondo_rombos9.gif"><p class="paragraph style14"><span class="style59">Proveer a nuestros Clientes de Innovaci&oacute;n e Infraestructura tecnol&oacute;gica para apoyar decididamente su desarrollo empresarial.</span></p>
        <p><img border="0" src="images/bottom1.jpg" width="180" height="24"></p></td>
  </tr>
</table>
</cf_templatearea>
<cf_templatearea name="body">

<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
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
			<table width="273" height="150" border="0" cellpadding="0" cellspacing="0" style="background-repeat:no-repeat ">
			  <tr>
				<td width="23">&nbsp;</td>
				<td height="45" colspan="2"><div class="subTitulo">
				  <div align="left"><font color="white" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Conectarse</font></div>
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

</cf_templatearea>
</cf_template>
