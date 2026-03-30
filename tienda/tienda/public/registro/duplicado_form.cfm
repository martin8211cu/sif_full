<cfparam name="url.email" default="">
<style type="text/css">
<!--
.duplicado_redbold {
	color: #CC3333;
	font-weight: bold;
}
-->
</style>
<cfoutput>  <table width="551" border="0">
    <tr>
      <td colspan="3" class="tituloListas">Registro de clientes </td>
    </tr>
    <tr>
      <td colspan="3" class="small">El registro de clientes es gratuito, y le permitir&aacute; realizar el seguimiento de sus pedidos.<br>
      Es muy importante que escriba correctamente su direcci&oacute;n de correo electr&oacute;nico, ya que le estaremos enviando informaci&oacute;n sobre el estado de su pedido cuando lo tengamos listo. </td>
    </tr>
    <tr>
      <td colspan="3" valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" valign="top"><span class="duplicado_redbold">La direcci&oacute;n del correo electr&oacute;nica que nos sumistr&oacute;, #url.email#, ya est&aacute; registrada en nuestro sistema. </span></td>
    </tr>
    <tr>
      <td colspan="3" valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" valign="top">Seleccione una de estas tres opciones: </td>
    </tr>
    <tr>
      <td colspan="3" align="center">&nbsp;</td>
    </tr>
    <tr align="left">
      <td width="39">&nbsp;</td>
      <td width="12"><a href="/cfmx/home/public/login.cfm"><img src="arrow_rt.gif" width="12" height="17" border="0"></a></td>
      <td width="486"><a href="/cfmx/home/public/login.cfm">Conectarse como #url.email#</a></td>
    </tr>
    <tr align="left">
      <td>&nbsp;</td>
      <td><a href="/cfmx/home/public/recordar.cfm"><img src="arrow_rt.gif" width="12" height="17" border="0"></a></td>
      <td><a href="/cfmx/home/public/recordar.cfm">Recordar contrase&ntilde;a </a></td>
    </tr>
    <tr align="left">
      <td>&nbsp;</td>
      <td><a href="registro.cfm"><img src="arrow_rt.gif" width="12" height="17" border="0"></a></td>
      <td><a href="registro.cfm"> Registrarme de nuevo con otro correo</a></td>
    </tr>
    <tr align="left">
      <td colspan="3">&nbsp;</td>
    </tr>
    </table>
</cfoutput>