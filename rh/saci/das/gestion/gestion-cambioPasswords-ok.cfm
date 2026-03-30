<table width="60%" border="0" align="center">
  <tr>
    <td class="subTitulo">Felicitaciones</td>
    </tr>
  <tr>
    <td valign="top" class="ayuda">La contrase&ntilde;a ha sido modificada.<br>
      <br>      
      Recuerde realizar el cambio de esta contrase&ntilde;a cada cierto tiempo, con el fin de mantener la confidencialidad de &eacute;sta. La contrase&ntilde;a es estrictamente personal. <br>
      <br>
      Procure no utilizar la misma contrase&ntilde;a que use en otros portales o servicios, de esta manera si alguien conoce una de sus contrase&ntilde;as no se comprometer&aacute; toda su informaci&oacute;n a la misma vez. <br>
      </td>
    </tr>
 <!--- <tr>
    <td valign="top">&iquest;Qu&eacute; desea hacer ahora? </td>
  </tr>--->
  <tr>
    <td align="left">
	<cfoutput><!---<img src="/cfmx/home/menu/imagenes/content_arrow.gif" width="12" height="17" border="0">
		<a href="/cfmx/home/index.cfm">Continuar trabajando </a>--->
		<form method="post" name="f" action="gestion.cfm" onSubmit="return valida(this, &quot;# HTMLEditFormat( JSStringFormat(session.usuario)) #&quot;);" >
		 <cfinclude template="gestion-hiddens.cfm">
		 <cf_botones values="Continuar" names="Continuar">
		</form> 
	</cfoutput>
	  </td>
  </tr>
  <!---<tr>
    <td align="left"> <img src="/cfmx/home/menu/imagenes/content_arrow.gif" width="12" height="17" border="0">
		<a href="/cfmx/home/public/logout.cfm">&iexcl;Quiero probar mi nueva contrase&ntilde;a!</a></td>
  </tr>--->
</table>


