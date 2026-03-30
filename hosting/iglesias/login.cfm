<cfif IsDefined("LOGIN_CFM_INCLUDED")>
	<cfreturn>
</cfif>
<cfset LOGIN_CFM_INCLUDED = TRUE>

<cfset LoginMalito = IsDefined("form.j_username") and Len (GetAuthUser()) EQ 0>

<cfif Len(GetAuthUser()) EQ 0>
	<cflogin>
	<form style="margin:0" method="post" name="loginform">
	<table width="165" border="0" style="border:3px double" cellpadding="2" cellspacing="0">
	  <tr>
		<td><FONT color="#FFFFFF" face="arial, helvetica, verdana"
	size=2><strong>Usuario</strong></FONT></td>
		<td><input name="j_username" onFocus="select()" type="text" size="8" style="width:70px"></td>
	  </tr>
	  <tr>
		<td><FONT color="#FFFFFF" face="arial, helvetica, verdana" 
	size=2><strong>Clave</strong></FONT></td>
		<td><input name="j_password" onFocus="select()" type="password" size="8" style="width:70px" onKeyPress="if (event.keyCode==13) form.submit();"></td>
	  </tr>
	  <tr align="center">
		<td colspan="2"><object tabindex="-1" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="100" height="22">
	        <param name="BGCOLOR" value="">
	        <param name="movie" value="images/logon.swf">
	        <param name="quality" value="high">
	        <embed src="images/logon.swf" width="100" height="22" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" bgcolor="" ></embed>
	      </object></td>
		</tr>
	</table></form>
	</cflogin>
<cfelse>
	<form method="post" style="margin:0" name="loginform" action="/cfmx/home/public/logout.cfm">
	<cfoutput><input type=hidden name=uri value="#cgi.script_name#"></cfoutput>
	<table width="165" border="0" height="80"  style="border:3px double">
	  <tr>
		<td><FONT color="#FFFFFF" face="arial, helvetica, verdana" 
	size=2><strong><em>Bienvenido, <cfoutput>#GetAuthUser()#</cfoutput></em></strong> </FONT></td>
		</tr>
	  <tr align="center">
		<td><input type="hidden" name="logout_me" value="1">
		  <objectXX classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="100" height="22">
	        <param name="BGCOLOR" value="">
	        <param name="movie" value="/cfmx/hosting/iglesias/images/logout.swf">
	        <param name="quality" value="high">
	        <embed src="images/logout.swf" width="100" height="22" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" bgcolor="" ></embed>
	      </object>
		  </td>
		</tr>
	</table></form>
</cfif>
<cfif LoginMalito>
<script type="text/javascript">
<!--
	setTimeout('alert("Acceso incorrecto")', 0);
	loginform.the_username.focus();
-->
</script>
</cfif>