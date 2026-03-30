
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>
	<cf_translate key="LB_SolicitudesDeCompraDescripciones">Solicitudes de Compra - Descripciones</cf_translate>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<form name="form1" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
<tr><td></td></tr>
<tr><td align="center">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
			<td align="left"><strong><font size="2"><cf_translate key="LB_DescripcionAlterna">Descripción Alterna</cf_translate></font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="descAlterna" rows="10" readonly></textarea></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td align="left"><strong><font size="2"><cf_translate key="LB_Observacion">Observación</cf_translate></font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="observaciones" rows="10" readonly></textarea></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cerrar"
					Default="Cerrar"
					XmlFile="/sif/generales.xml"
					returnvariable="BTN_Cerrar"/>
				<input type="button" style=" font-size:11px" name="Cerrar" value="<cfoutput>#BTN_Cerrar#</cfoutput>" onClick="javascript:salir();">
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
	</table>
</td></tr>
</table>
</form>
</body>
</html>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	document.form1.observaciones.value = window.opener.document.form1.DSobservacion#url.index#.value;
	document.form1.descAlterna.value = window.opener.document.form1.DSdescalterna#url.index#.value;
	function salir(){
		window.close();
	}
	</cfoutput>
</script>