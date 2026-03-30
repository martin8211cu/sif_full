<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>CG_CierreAuxiliares</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	font-size: 36px;
	font-weight: bold;
	color: #0000FF;
}
-->
</style>
</head>

<body>

<cfset session.dsn = 'minisif'>
<cfset session.Ecodigo = 1>
<cfset session.usuario = 'marcel'>


<form name="form1" method="post" action="CG_CierreAuxiliares_sql.cfm">
  <table width="200" border="0" align="center">
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" align="center"><span class="style1">CG_CierreAuxiliares</span></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <table width="200" border="0" align="center">
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td align="center"><input name="btnInicio" type="button" id="btnInicio" value="Inicio" onClick="javascript: inicio();"></td>
      <td>&nbsp;</td>
      <td><input name="btnCierreMes2" type="submit" id="btnCierreMes2" value="Prueba"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>


<script language="javascript" type="text/javascript">
	function inicio(){
		location.href="/cfmx/sif/Componentes/test/index.cfm";
	}
</script>