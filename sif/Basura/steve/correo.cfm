<script>
	function fnEnviarCorreo() {
		alert(window.document.fSteve.txtName.value);
	}
</script>

<cfmail from="srodriguez@soin.co.cr" to="srodriguez@soin.co.cr" subject="sdf" type="html">
	<html>
		<body>
			<form name="fSteve">
				<table>
					<tr>
						<td>
							Digite su nombre: 
							<input name="txtName" type="text" value="">
							<input name="btnEnviar" type="button" value="Enviar"
								onClick="javascript:fnEnviarCorreo()">
						</td>
					</tr>
				</table>
			</form>
		</body>
	</html>
</cfmail>