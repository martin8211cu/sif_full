<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Resultado de la votacion</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body>
<table width="769" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="765" valign="top" scope="row"><table width="77%" height="79"  border="0" align="left" cellpadding="0" cellspacing="0">
      <tr>
        <th width="26%" height="79" valign="top" scope="row"><img src="images/sitioh5_11.jpg" width="208" height="79"></th>
        <th width="19%" scope="row"><img src="images/internah5_12.jpg" width="140" height="79"></th>
        <th width="37%" scope="row"><img src="images/internah5_13.jpg" width="295" height="79"></th>
        <th width="18%" scope="row"><p align="left"><img src="images/internah5_14.jpg" width="118" height="79"></p>          </th>
      </tr>
    </table> 
  </tr>
  <tr>
    <td valign="top" scope="row">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" valign="top" scope="row">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" valign="top" scope="row">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" valign="top" scope="row"><cfquery datasource="h5_votacion" name="cuenta">
select count(1) cuenta from Votos
    </cfquery>
      <strong>Tu voto ha sido contabilizado.</strong></td>
  </tr>
  <tr>
    <td align="center" valign="top" scope="row">&nbsp;</td>
  </tr>
  <tr>
    <td align="center" valign="top" scope="row"> 
El total de votos hasta es momento es de: <cfoutput><strong>#cuenta.cuenta#</strong></cfoutput>.   </td>
  </tr>
  <tr>
    <td valign="top" >&nbsp;</td>
  </tr>
  <tr>
    <td align="center" valign="top" >El resultado final de esta votaci&oacute;n y del concurso ser&aacute; publicado <br>
    posteriormente en este mismo sitio. </td>
  </tr>
  <tr>
    <td valign="top" >&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" >&nbsp;</td>
  </tr>
  <tr>
    <td align="center" valign="top"><input type="button" onClick="window.close()" value="Cerrar"></td>
  </tr>
</table>
    <div align="center"></div>
    <form style="margin-bottom:0;margin-top:20px">
    </form></th>
</body>
</html>
