<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Notificaci&oacute;n de Recibo de Pago</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">


</style>
</head>
<body>
<cfparam name="_fileCount" default="">
<cfparam name="_codCorte" default="">
<cfset currentDate= DateFormat("#now()#",'mm/dd/yyyy')>


<cfoutput>
<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
  <tr bgcolor="##dee7e5">
    <td colspan="2" height="8"></td>
  </tr>
  <tr bgcolor="##7cb3c3">
    <td colspan="2" height="24"></td>
  </tr>
  <tr bgcolor="##dee7e5">
    <td colspan="2"> <strong>Estados de Cuenta generados</strong> </td>
  </tr>
  <tr>
    <td width="50">&nbsp;</td>
    <td width="500">&nbsp;</td>
  </tr>
  <tr>
    <td><span></span></td>
    <td><span></span></td>
  </tr>
  <tr>
    <td colspan="2">Fecha de generaci&oacute;n: #currentDate#</td>
  </tr>
  <tr>
    <td><span ></span></td>
    <td><span>Estados de Cuenta Generados Para : #_codCorte#</span></td>
  </tr>
  <tr>
    <td><span></span></td>
    <td><span></span></td>
  </tr>
  <tr>
    <td><span></span></td>
    <td><span>Detalle: </span></td>
  </tr>
  <tr>
    <td><span></span></td>
    <td><table border="0">
        <tr>
          <td><strong>N&uacute;mero estados de cuenta:</strong></td>
          <td>&nbsp;</td>
          <td>#_fileCount#</td>
        </tr>

      </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><span></span></td>
    <td><span></span></td>
  </tr>
</table>
<br>
<br>
<br>
<br>
</cfoutput>
</body>
</html>
