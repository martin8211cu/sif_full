<!--- CLIENTES --->
<cfinvoke component="cmMisFunciones" method="tmp_BorrarTabla" returnvariable="rError" />
<cfinvoke component="cmMisFunciones" method="tmp_CrearTabla" returnvariable="rError" />
<cfinvoke component="cmMisFunciones" method="tmp_LlenarTablaReales" returnvariable="rError" />

<script language="javascript1.2" type="text/javascript">

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function funConlisMisClientes() {
		var params = "";
		popUpWindow("ConlisMisClientes.cfm"+params,250,200,610,300);
	}
</script>

<form name="fForm" method="post">
	<table>
		<tr>
			<td>C&eacute;dula:</td>
			<td><input name="txtCedula" type="text" value=""></td>
		</tr>
		<tr>
			<td>Nombre:</td>
			<td><input name="txtNombre" type="text" value=""></td>
		</tr>
		<tr>
			<td><input name="btnAbrir" type="button" value="Ver" onClick="javascript:funConlisMisClientes()"></td>
		</tr>
	</table>
</form>