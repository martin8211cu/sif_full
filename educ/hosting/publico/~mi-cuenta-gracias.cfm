<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Mis Datos Personales
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">


<form action="" method="get"><table border="1">
  <tr>
    <td>Gracias por afiliarse con nosotros. En pocos minutos le haremos llegar por correo electr&oacute;nico un usuario y contrase&ntilde;a temporales para que pueda firmarse en nuestro portal.</td>
  </tr>
  <tr>
    <td>
	<cfoutput>
	<input value="Continuar" type="button">
	<input value="Ingresar al portal" type="button" onClick="javascript:location.href='/cfmx/home/public/login.cfm?uri=#URLEncodedFormat(CGI.SCRIPT_NAME)#'">
	</cfoutput>
	</td>
  </tr>
</table></form>


</cf_templatearea>
</cf_template>
