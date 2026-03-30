<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Generar Lotes de Marcas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
</head>

<body>
	<!----================== TRADUCCION =====================---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Debe_seleccionar_la_fecha_de_corte"
		Default="Debe seleccionar la fecha de corte"	
		returnvariable="MSG_Debe_seleccionar_la_fecha_de_corte"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Generar"
		Default="Generar"
		returnvariable="BTN_Generar"/>
	
	<script language="javascript" type="text/javascript">
		function valida(f) {
			<cfoutput>
				if (f.fecha.value == "") {
					alert('#MSG_Debe_seleccionar_la_fecha_de_corte#');
					return false;
				}
				return true;
			</cfoutput>
		}
	</script>

	<form name="frmGenera" action="GenerarMarcas-SQL.cfm" method="post" onSubmit="javascript: return valida(this);">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="right"><strong><cf_translate key="LB_Fecha_de_Corte">Fecha de Corte:</cf_translate></strong></td>
			<td>
				<cf_sifcalendario name="fecha" form="frmGenera">
			</td>
		  </tr>
		  <!---
		  <tr>
			<td>Marcas de Entrada Antes de </td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>Marcas de Salida Antes de </td>
			<td>&nbsp;</td>
		  </tr>
		  --->
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr align="center">
			<td colspan="2">
				<cfoutput><input type="submit" name="btnGenerar" value="#BTN_Generar#"></cfoutput>
			</td>
		  </tr>
	  </table>
	</form>

</body>
</html>
