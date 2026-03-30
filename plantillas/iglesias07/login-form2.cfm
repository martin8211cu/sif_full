<!--- OJO se incluyo este .js que estaba el login.cfm --->
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/home/public/login.js">//</script>
</cfif>
<cfparam name="url.uri" default="index.cfm">
<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<form name="login" onsubmit="javascript:return validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" style="margin:0">
		<table width="200" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber4" style="border-collapse: collapse;margin:0">
			<tr>
			  <td valign="middle" class="etiqwhite16" align="center" colspan="2">
			
			<font face="arial"><b>Usuarios Existentes!</b></font><br>
			<font face="arial" size="-1"><nobr>&nbsp;Ingrese su usuario y password</nobr></font>
			</td>
			</tr>
			<tr>
			  <td width="210" valign="middle"> 
			  <div align="left" class="etiqwhite">Usuario:</div></td>
			  <td valign="top">
			 
				<p style="margin-top: 0; margin-bottom: 0">
			  <input type="text" name="j_username" size="12" style="font-size: 8pt" onFocus="this.select()"></p>			  </td>
		  <tr>
			    <td class="etiqwhite">Contrase&ntilde;a:</td>
			    <td  valign="top" nowrap><span class="style9"><strong><font size="1" face="Verdana">
			      <input type="password" name="j_password" size="14" style="font-size: 8pt" onFocus="this.select()">
			    </font></strong></span></td>
	      </tr>

		  <tr>
		  	<td colspan="2"  class="etiqwhite10" nowrap align="center">
				<input type="checkbox" name=".persistent" value="y">Recordar mi usuario en este equipo
			</td>
		  </tr>
		  <tr>
			    <td colspan="2" valign="top" nowrap align="center"><input type="submit" value="Conectarse" name="Submit2" style="font-size: 8pt"></td>
	      </tr>
		  <cfif IsDefined("url.errormsg")>
			  <tr><td></td>
			
			  <td  valign="top" nowrap>
				<strong class="textwhite14">No se pudo iniciar la sesi&oacute;n.</strong>
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