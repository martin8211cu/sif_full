<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Recaudaci&oacute;n por Sucursal</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">


<table width="700" border="0" align="center">
<tr>
  <td><cfinclude template="hdr_persona.cfm"></td>
</tr>
<tr>
  <td><cfinclude template="hdr_tramite.cfm"></td>
</tr>
<tr>
  <td><cfinclude template="hdr_requisito.cfm">
</td>
</tr>
<tr>
  <td>El requisito no aparece en el expediente del usuario. Puede solicitarlo, o bien ir a una de las oficinas listadas para que le reciban el documento en su expediente. </td>
</tr>
<tr>
  <td>Si desea iniciar un nuevo tr&aacute;mite para cumplir con el requisito, selecci&oacute;nelo de la lista. </td>
</tr>
<tr>
  <td><table width="100%" border="0">
    <tr>
      <td colspan="4" class="subTitulo">Tr&aacute;mites para obtener un Comprobante de No Delitos </td>
      </tr>
    <tr>
      <td width="3%">&nbsp;</td>
      <td width="11%">OIJ</td>
      <td width="60%">Certificaci&oacute;n de No Delitos </td>
      <td width="26%"><input name="Button" type="button" onclick="location.href=('nvo_tramite2.cfm');" value="Iniciar &gt;&gt;"></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>MSP</td>
      <td> Copia del Expediente Policial </td>
      <td><input name="Button" type="button" onclick="location.href=('nvo_tramite2.cfm');" value="Iniciar &gt;&gt;"></td>
    </tr>
  </table></td>
</tr>
<tr>
  <td><table width="614" border="0">
    <tr>
      <td colspan="4" class="subTitulo">Oficinas donde puede entregar su Comprobante de No Delitos </td>
      </tr>
    <tr>
      <td width="13">&nbsp;</td>
      <td width="98">Automercado</td>
      <td width="229">Plaza del Sol </td>
      <td width="246">Curridabat, Plaza del Sol </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>BCR</td>
      <td>Registro</td>
      <td>Dentro del Registro Nacional </td>
    </tr>
  </table></td>
</tr>
<tr>
  <td align="right"><input name="Button" type="button" onclick="location.href=('edit_tramite.cfm');" value="Regresar"></td>
</tr>
</table>
</body>
</html>