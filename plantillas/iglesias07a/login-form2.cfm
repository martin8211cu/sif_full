<!--- OJO se incluyo este .js que estaba el login.cfm --->
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/home/public/login.js">//</script>
</cfif>
<cfparam name="url.uri" default="index.cfm">
<style type="text/css">
<!--
.style1login {font-weight: bold}
.style2login {color: #FF0000}
.style2 {
	font-family: Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color: #996600;
}
.style3 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 10px; color: #996600; font-weight: bold; }
-->
</style>
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="javascript:return validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" style="margin:0">
		<table width="200" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber4" style="border-collapse: collapse;margin:0">
			<tr>
			  <td width="210" valign="middle"> 
			  <div align="left" class="style3">Usuario:</div></td>
			  <td valign="top">
			 
				<p style="margin-top: 0; margin-bottom: 0">
			  <input type="text" name="j_username" size="12" style="font-size: 8pt" onFocus="this.select()"></p>			  </td>
		  <tr>
			    <td class="style2"><font size="1" face="Verdana">Contrase&ntilde;a<strong>:</strong></font></td>
			    <td  valign="top" nowrap><span class="style9"><strong><font size="1" face="Verdana">
			      <input type="password" name="j_password" size="14" style="font-size: 8pt" onFocus="this.select()">
			    </font></strong></span></td>
	      </tr>
			  <tr>
			    <td></td>
			    <td  valign="top" nowrap>&nbsp;</td>
	      </tr>
			  <tr>
			    <td></td>
			    <td  valign="top" nowrap><input type="submit" value="Conectarse" name="Submit2" style="font-size: 8pt"></td>
	      </tr>
		  <cfif IsDefined("url.errormsg")>
			  <tr><td></td>
			
			  <td  valign="top" nowrap>
				<strong class="style2login">No se pudo iniciar la sesi&oacute;n.</strong>
			  </td>
			  </tr><tr><td></td>
			  <td width="190"><a href="/cfmx/home/public/recordar.cfm"><font color="#0000FF">¿Necesita
		  ayuda para ingresar?</font></a>  
			  </td></tr>
		  </cfif>

	  </table>
		<input type="hidden" name="recordar">
  </form>	
<cfelse>
	<form name="login" action="/cfmx/home/public/logout.cfm" method="post" style="margin:0">
	<table width="150" height="27" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		<td align="center"><input type="submit" name="Submit" value="Desconectarse"></td>
	  </tr>
	</table>	
	<input type="hidden" name="uri" value="/cfmx/plantillas/iglesias07/index.cfm">
	</form>
</cfif>
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
</cfif>