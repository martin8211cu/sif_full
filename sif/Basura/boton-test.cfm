<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>
</head>

<body>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="15">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td rowspan="15">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><div align="center" class="style1">cf_bot&oacute;n</div></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp; </td>
    <td>&nbsp;</td>
  </tr>
  <cfoutput>  
  <cfloop from="1" to="10" index="idx">

  <tr>
    <td>estilo #idx#</td>
    <td>: </td>
    <cfloop from="1" to="5" index="idy">
	<td><cf_boton texto = "cf_boton estilo #idx#" size="170" estilo = "#idx#" index="fr#idx##idy#"></td>
	</cfloop>
  </tr>

  </cfloop>
  </cfoutput>  
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
</table>
</body>
</html>
