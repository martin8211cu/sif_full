<cfset session.debug=1>
<cfmail from="gestion@soin.co.cr" 
	to="jcgudino@soin.co.cr" subject="Informacion recibida por el portal" type="html" > 
<table width="550" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="##CCCCCC" style="font-style:italic;" >
    <td colspan="2"> Informacion recibida por el portal </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  <td>&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Producto</td>
    <td>Giro de Negocio</td>
  </tr><tr>
    <td>#HTMLEditFormat(form.selectproduct)#</td>
  <td>#HTMLEditFormat(form.Giros )#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td width="240">Nombre</td>
    <td width="310">Nombre de la Empresa </td>
  </tr><tr>
    <td width="240">#HTMLEditFormat(form.Nombre )#</td>
  <td width="310">#HTMLEditFormat(form.nombreempresa)#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Apellidos</td>
    <td>Numero de Empleados </td>
  </tr><tr>
    <td>#HTMLEditFormat(form.Apellido1)# #HTMLEditFormat(form.Apellido2 )#</td>
  <td>#HTMLEditFormat(form.Empleados )#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Rol</td>
    <td>Pa&iacute;s</td>
  </tr><tr>
    <td>#HTMLEditFormat(form.contactrole)#</td>
  <td>#HTMLEditFormat(form.Pais )#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Telefono</td>
    <td>&iquest; C&oacute;mo Escuch&oacute; de Nosotros ? </td>
  </tr><tr>
    <td>#HTMLEditFormat(form.Tel )#</td>
  <td>#HTMLEditFormat(form.comoescucho)#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Fax</td>
    <td>&iquest; Est&aacute; trabajando con un proveedor ? </td>
  </tr><tr>
    <td>#HTMLEditFormat(form.Fax )#</td>
  <td>#HTMLEditFormat(form.trabajanetsuit)#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Codigo Postal </td>
    <td>&iquest; Cu&aacute;l ? </td>
  </tr><tr>
    <td>#HTMLEditFormat(form.zip_code )#</td>
  <td>#HTMLEditFormat(form.nombreprovedor)#</td>
  </tr>
  <tr bgcolor="##CCCCCC" style="font-style:italic;">
    <td>Email</td>
    <td>Referral code </td>
  </tr><tr>
    <td>#HTMLEditFormat(form.Email )#</td>
  <td>#HTMLEditFormat(form.ferrealcode)#</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="##CCCCCC" style="font-style:italic;">Recibido</td>
    <td bgcolor="##CCCCCC" style="font-style:italic;">&nbsp;</td>
  </tr>
  <tr>
    <td>#DateFormat(Now(),'dd-mmm-yyy')# #TimeFormat(Now(),'hh:mm:ss' )#</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfmail>
<cflocation url="gracias.html">
<a href="gracias.html">gracias</a>

