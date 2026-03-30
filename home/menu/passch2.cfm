<cf_template>
<cf_templatearea name="title">
	Cambiar contrase&ntilde;a</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<style type="text/css" >
.ayuda {
	background-color: #e4e4e4;
	padding: 4px;
	border: 1px solid #000000;
}

</style>
<cf_web_portlet titulo="Contraseña modificada">
<form method="get" name="f" action="" >


<table width="60%" border="0" align="center">
  <tr>
    <td class="subTitulo">Felicitaciones</td>
    </tr>
  <tr>
    <td valign="top" class="ayuda">Su contrase&ntilde;a ha sido modificada.<br>
      <br>      
      Recuerde realizar el cambio de esta contrase&ntilde;a cada cierto tiempo, con el fin de mantener la confidencialidad de &eacute;sta. La contrase&ntilde;a es estrictamente personal. <br>
      <br>
      Procure no utilizar la misma contrase&ntilde;a que use en otros portales o servicios, de esta manera si alguien conoce una de sus contrase&ntilde;as no se comprometer&aacute; toda su informaci&oacute;n a la misma vez. <br>
      </td>
    </tr>
  <tr>
    <td valign="top">&iquest;Qu&eacute; desea hacer ahora? </td>
  </tr>
  <tr>
    <td align="left">
	<cfoutput>
	  <a href="../index.cfm" > <img src="imagenes/content_arrow.gif" width="12" height="17" border="0"> Continuar trabajando </a>
	  </cfoutput>
	  </td>
  </tr>
  <tr>
    <td align="left">
		<a href="../public/logout.cfm"> <img src="imagenes/content_arrow.gif" width="12" height="17" border="0">&iexcl;Quiero probar mi nueva contrase&ntilde;a!</a></td>
  </tr>
</table>

  
</form>
</cf_web_portlet>

</cf_templatearea>
</cf_template>
