<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Recaudaci&oacute;n por Sucursal</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">
<table width="100%" border="0" cellspacing="0" cellpadding="2">
<tr style="background-color:#ededed">
    <td colspan="4" style="border-bottom:1px solid black"><table border="0" cellpadding="0" cellspacing="0">
        <tr style="background-color:#ededed">
          <td rowspan="2"><img src="fischel.gif" width="146" height="59"></td>
          <td style="font-size:16px">&nbsp;</td>
          <td colspan="4" style="font-size:16px">Farmacias Fischel</td>
        </tr>
        <tr style="background-color:#ededed">
          <td style="font-size:14px">&nbsp;</td>
          <td colspan="4" style="font-size:14px">Recaudaci&oacute;n por sucursal</td>
        </tr>
          </table></td>
  </tr>  <tr style="background-color:#ededed ">
    <td><em><strong>Sucursal</strong></em></td>
    <td align="right"><em><strong>Recaudado </strong></em></td>
    <td align="right"><em><strong>Por Liquidar</strong></em></td>
    <td>&nbsp;</td>
  </tr>
  <tr onclick="location.href='recauda_ven.cfm'" style="background-color:#CCFFCC;cursor:pointer;">
    <td>Multiplaza</td>
    <td align="right">1,470,126.00</td>
    <td align="right">790,160.00</td>
    <td><a href="recauda_ven.cfm">Detalle</a></td>
  </tr>
  <tr onclick="location.href='recauda_ven.cfm'" style="cursor:pointer;">
    <td>Forum</td>
    <td align="right">1,320,155.00</td>
    <td align="right">1,320,155.00</td>
    <td><a href="recauda_ven.cfm">Detalle</a></td>
  </tr>
  <tr onclick="location.href='recauda_ven.cfm'" style="background-color:#ededed ">
    <td><strong>Total</strong></td>
  <td align="right"><strong>2,790,281.00</strong></td>
    <td align="right"><strong>2,110,315.00</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4">
	
	<cfchart seriesplacement="stacked" showlegend="yes">
	
		<cfchartseries type="bar" serieslabel="Por liquidar">
			<cfchartdata item="Multiplaza" value="790160.00">
			<cfchartdata item="Forum" value="1320155.00">
			<cfchartdata item="Total" value="2110315.00">
		</cfchartseries>
	
		<cfchartseries type="bar" serieslabel="Liquidado">
			<cfchartdata item="Multiplaza" value="529995.00">
			<cfchartdata item="Forum" value="658005.00">
			<cfchartdata item="Total" value="679966.00">
		</cfchartseries>
	
	</cfchart>
	</td>
  </tr>
  <tr>
    <td colspan="4" align="center">      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="105" height="33">
        <param name="movie" value="liquidar.swf">
        <param name="quality" value="high">
        <embed src="liquidar.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="105" height="33" ></embed>
          </object>
    </td>
  </tr>
</table>
</body>
</html>
