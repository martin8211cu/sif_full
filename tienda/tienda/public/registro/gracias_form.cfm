<cfoutput><form name="form1" method="post" action="../../private/comprar/checkout.cfm">
  <table width="524" border="0" align="center">
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" class="tituloListas">Registro de clientes </td>
    </tr>
    <tr>
      <td colspan="2" class="small">Gracias por registrarse con nosotros.<br> 
        A continuaci&oacute;n le mostramos la informaci&oacute;n de registro suministrada. <br>
        Para acceder la tienda en el futuro, utilice su correo electr&oacute;nico como nombre de usuario. </td>
    </tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td width="228" valign="top">Nombre</td>
      <td width="286" valign="top">
	  <cfif Len(Trim(session.datos_personales.nombre)) is 0 and
	        Len(Trim(session.datos_personales.apellido1)) is 0 and
			Len(Trim(session.datos_personales.apellido2)) is 0 >
			No se especific&oacute;
		</cfif>
	  #session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#
	  </td>
    </tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td valign="top">Correo electr&oacute;nico</td>
      <td valign="top">#session.datos_personales.email1#</td>
    </tr>
    <tr>
      <td colspan="2" align="center">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center">      <input name="Continuar" type="submit" id="Continuar" value="Continuar >>"></td>
    </tr>
  </table>
</form>
</cfoutput>