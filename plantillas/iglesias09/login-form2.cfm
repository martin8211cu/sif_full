<cfif (not isdefined("session.usucodigo")) or session.usucodigo is 0>
	<cfparam name="url.uri" default="index.cfm">
	<script language="javascript1.2" type="text/javascript" 
		src="/cfmx/home/public/login.js">
	</script>
	<form name="login" onsubmit="javascript:return validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" style="margin:0">
		<div style="margin-left: 40px; padding-bottom: 10px;">
		  <input type="text" name="j_username" size="12" style="font-size: 8pt" onFocus="this.select()" value="USUARIO" class="style0901"><br>
		  <input type="password" name="j_password" size="14" style="font-size: 8pt" onFocus="this.select()" value="PASSWORD" class="style0901"><input type="Image" src="imagenes/b_go.jpg" width="23" height="27" alt="" border="0" hspace="10" align="absbottom">
		</div>
		<input type="hidden" name="recordar">
		<cfif IsDefined("url.errormsg")>
			<p class="bot" style="margin-bottom: -5px; margin-left: 40px;"><img src="imagenes/e_pass.gif" width="12" height="12" alt="" border="0" align="texttop">&nbsp;&nbsp;<b>No se pudo iniciar la sesi&oacute;n.&nbsp;<a href="/cfmx/hosting/publico/afiliacion/afiliacion.cfm">Puede Subscribirse</a>&nbsp;o&nbsp;<a href="/cfmx/home/public/recordar.cfm">Recordar Contraseña.</a></b></p>
		<cfelse>
			<p class="bot" style="margin-bottom: -5px; margin-left: 40px;"><img src="imagenes/e_pass.gif" width="12" height="12" alt="" border="0" align="texttop">&nbsp;&nbsp;<b><a href="/cfmx/hosting/publico/afiliacion/afiliacion.cfm">Subscribirse</a></b></p>
		</cfif>
	</form>
	<script type="text/javascript">
		<!--
		llenarLogin(document.login);
		-->
	</script>
<cfelse>
	<form name="login" action="/cfmx/home/public/logout.cfm" method="post" style="margin:0">
		<div style="margin-left: 40px; padding-bottom: 10px;">
		  <cfif isdefined("Session.datos_personales.NOMBRE") and Len(trim(Session.Usucodigo)) GT 0>
		  <span class="style0901"><cfoutput>#session.datos_personales.NOMBRE#&nbsp;#session.datos_personales.APELLIDO1#&nbsp;#session.datos_personales.APELLIDO2#</cfoutput></span>
		  <cfelse>
		  <br>
		  </cfif>
		  <input type="submit" name="Submit" value="DESCONECTARSE" class="style0901">
	  </div>
		<input type="hidden" name="uri" value="/cfmx/plantillas/iglesias07/index.cfm">
	</form>
</cfif>