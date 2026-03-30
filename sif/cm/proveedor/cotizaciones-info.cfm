<cfparam name="url.titulo" default="Solicitud de Compra">
<!---<cfparam name="url.form" default="form1">--->
<cfparam name="url.descalterna" default="DSdescalterna">
<cfparam name="url.observaciones" default="DSobservacion">
<cfparam name="url.index" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Informaci&oacute;n Adicional de <cfoutput>#url.titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<!--- Lo que se esta recibiendo/enviando en la variable linea es el LPCid  ---->
<cfquery name="rsObservaciones" datasource="sifpublica">
	select DSobservacion, DSdescalterna
	from LineasProcesoCompras
	where LPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.linea#">		
</cfquery>

<cfoutput>
<form name="form1" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
<tr><td></td></tr>
<tr><td align="center">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" >
		<tr><td align="left"><strong><font size="2">Datos Adicionales de la <cfoutput>#url.titulo#</cfoutput></font></strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="left"><strong><font size="1">Descripci&oacute;n Alterna</font></strong></td></tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="alterna" rows="10" readonly>#rsObservaciones.DSdescalterna#</textarea></td>
		</tr>
		<tr>
			<td align="left"><strong><font size="1">Observaciones</font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="observaciones" rows="8" readonly>#rsObservaciones.DSobservacion#</textarea></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" style=" font-size:11px" name="Cerrar" value="Cerrar" onClick="javascript:cerrar();"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</td></tr>
</table>
</form>
</cfoutput>
</body>
</html>

<script type="text/javascript" language="javascript1.2">
	function cerrar(){
		window.close();
	}
</script>
