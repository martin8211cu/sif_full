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
    <p align="center">Gracias por tu voto!<br>
      </p>
    <div align="center">
	<cfquery datasource="h5_votacion" name="grafico">
		select c.concursante, c.nombre_concursante, 1.0 * count(distinct v.email) / sum( count(distinct v.email) ) as porcentaje
		from Votos v join Concursante c on v.concursante = c.concursante
		where v.email like '%@%.%'
		group by c.concursante, c.nombre_concursante
	</cfquery>
	<cfchart show3d="no" format="png"  rotated="yes" scalefrom="0" labelformat="percent" 
		labelmask=""  showborder="no" chartwidth="300" chartheight="200"  >
		<cfchartseries  type="bar" query="grafico" itemcolumn="nombre_concursante" valuecolumn="porcentaje"></cfchartseries>
	</cfchart>
    </div>
    <form style="margin-bottom:0;margin-top:20px"><input type="button" onClick="window.close()" value="Cerrar"></form></th>
  </tr>
</table>
</body>
</html>
