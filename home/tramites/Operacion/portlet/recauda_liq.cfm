<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Liquidaci&oacute;n de ingresos</title>
<cf_templatecss>
</head>

<body style="border:0;margin:0 ">
<form style="margin:0" name="formliquida" id="formliquida" method="post" action="recauda_liq_sql.cfm">
<table width="100%" border="0" cellpadding="2" cellspacing="0">
  <tr style="background-color:#ededed">
    <td colspan="4" style="border-bottom:1px solid black"><table border="0" cellpadding="0" cellspacing="0">
        <tr style="background-color:#ededed">
          <td rowspan="2"><img src="fischel.gif" width="146" height="59"></td>
          <td style="font-size:16px">&nbsp;</td>
          <td colspan="4" style="font-size:16px">Farmacias Fischel</td>
        </tr>
        <tr style="background-color:#ededed">
          <td style="font-size:14px">&nbsp;</td>
          <td colspan="4" style="font-size:14px">Liquidaci&oacute;n de ingresos</td>
        </tr>
          </table></td>
  </tr>
  <tr style="background-color:#444444;color:white; ">
    <td>&nbsp;</td>
    <td colspan="3"><em><strong>Seleccione los conceptos que desea liquidar</strong></em></td>
    </tr>
  <tr style="background-color:#ededed ">
    <td>&nbsp;</td>
    <td><em><strong>Concepto</strong></em></td>
    <td align="right"><em><strong>Recaudado </strong></em></td>
    <td align="right"><em><strong>Por Liquidar</strong></em></td>
    </tr>
  <tr style="background-color:#CCFFCC;cursor:pointer;">
    <td><input type="checkbox" name="checkbox" value="checkbox" id="checkliq1"></td>
    <td onClick="with(document.formliquida.checkliq1)checked=!checked">MOPT - Derecho de Licencias </td>
    <td onClick="with(document.formliquida.checkliq1)checked=!checked" align="right">290,600.00</td>
    <td onClick="with(document.formliquida.checkliq1)checked=!checked" align="right">290,600.00</td>
    </tr>
  <tr style="cursor:pointer;">
    <td><input type="checkbox" name="checkbox" value="checkbox" id="checkliq2"></td>
    <td onClick="with(document.formliquida.checkliq2)checked=!checked">Migraci&oacute;n - Pago de Pasaportes </td>
    <td onClick="with(document.formliquida.checkliq2)checked=!checked" align="right">1,600,380.00</td>
    <td onClick="with(document.formliquida.checkliq2)checked=!checked" align="right">1,600,380.00</td>
    </tr>
  <tr style="background-color:#CCFFCC;cursor:pointer;">
    <td><input type="checkbox" name="checkbox" value="checkbox" id="checkliq3"></td>
    <td onClick="with(document.formliquida.checkliq3)checked=!checked">Migraci&oacute;n - Timbres del PANI </td>
    <td onClick="with(document.formliquida.checkliq3)checked=!checked" align="right">899,301.00</td>
    <td onClick="with(document.formliquida.checkliq3)checked=!checked" align="right">219,335.00</td>
    </tr>
  <tr style="background-color:#ededed ">
    <td>&nbsp;</td>
    <td><strong>Total</strong></td>
  <td align="right"><strong>2,790,281.00</strong></td>
    <td align="right"><strong>2,110,315.00</strong></td>
    </tr>
  <tr>
    <td colspan="4">
	
	<cfchart seriesplacement="stacked" showlegend="yes">
	
		<cfchartseries type="bar" serieslabel="Por liquidar">
			<cfchartdata item="Derecho de Licencias" value="290600.00">
			<cfchartdata item="Pago de Pasaportes" value="1600380.00">
			<cfchartdata item="Timbres del PANI" value="219335.00">
			<cfchartdata item="Total" value="2110315.00">
		</cfchartseries>
	
		<cfchartseries type="bar" serieslabel="Liquidado">
			<cfchartdata item="Derecho de Licencias" value="0.00">
			<cfchartdata item="Pago de Pasaportes" value="0.00">
			<cfchartdata item="Timbres del PANI" value="679966.00">
			<cfchartdata item="Total" value="679966.00">
		</cfchartseries>
	
	</cfchart>
	</td>
  </tr>
  <tr align="center">
    <td colspan="4"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="105" height="33">
      <param name="movie" value="liquidar2.swf">
      <param name="quality" value="high">
      <embed src="liquidar2.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="105" height="33" ></embed>
    </object>
      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="93" height="33">
        <param name="BGCOLOR" value="">
        <param name="BGCOLOR" value="">
        <param name="BGCOLOR" value="">
        <param name="BGCOLOR" value="">
        <param name="BGCOLOR" value="">
        <param name="movie" value="regresar.swf">
        <param name="quality" value="high">
        <embed src="regresar.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="93" height="33" ></embed>
      </object></td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
function liquidar(){
	with(document.formliquida) {
		if (!(checkliq1.checked||checkliq2.checked||checkliq3.checked)) {
			alert('Seleccione los conceptos que desea liquidar');
			return;
		}
	}
	if (confirm('¿Confirma que desea liquidar las líneas seleccionadas?')) {
		document.formliquida.submit();
		liquidar=false;
	}
}
function regresar(){
	location.href=('recauda_suc.cfm');
}
//-->
</script>
</body>
</html>
