<cfset session.debug=1>

<cfmail from="gestion@soin.co.cr" to="eladio@soin.co.cr" subject="Informacion recibida por el portal" type="html" > 


<table width="382" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2"> Informacion recibida por el portal </td>
    </tr>
  <tr>
    <td>Asunto</td>
    <td>#HTMLEditFormat(form.subject)#</td>
  </tr>
  <tr>
    <td width="160">Nombre</td>
    <td width="222">#HTMLEditFormat(form.Nombre)#</td>
  </tr>
  <tr>
    <td>Apellidos</td>
    <td>#HTMLEditFormat(form.Apellido1)# #HTMLEditFormat(form.Apellido2)#</td>
  </tr>
  <tr>
    <td>Telefono</td>
    <td>#HTMLEditFormat(form.Tel)#</td>
  </tr>
  <tr>
    <td>Fax</td>
    <td>#HTMLEditFormat(form.Fax)#</td>
  </tr>
  <tr>
    <td>Codigo Postal </td>
    <td>#HTMLEditFormat(form.zip_code)#</td>
  </tr>
  <tr>
    <td>Email</td>
    <td>#HTMLEditFormat(form.Email)#</td>
  </tr>
  <tr>
    <td>Giro de Negocio</td>
    <td>#HTMLEditFormat(form.Giros)#</td>
  </tr>
  <tr>
    <td>N&uacute;mero de Empleados </td>
    <td>#HTMLEditFormat(form.Empleados)#</td>
  </tr>
  <tr>
    <td>Pais</td>
    <td>#HTMLEditFormat(form.Pais)#</td>
  </tr>
</table>

</cfmail>
<cflocation url="gracias.html">
<a href="gracias.html">gracias</a>
