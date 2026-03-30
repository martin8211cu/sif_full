<cfoutput>

	<form method="post" name="form1" action="prospectos-apply.cfm" onsubmit="return validar(this);" style="margin:0">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td valign="top">
					<cf_prospecto
						pais = "#session.saci.pais#"
						porFila = "true"
						verNombApPost = "true"
						Conexion = "#session.DSN#"
						Ecodigo = "#session.Ecodigo#"
					>
			</td>
		</tr>
		<tr align="center">
			<td>
				<cf_botones names="Guardar" values="Guardar">
			</td>
		</tr>
		</table>
	</form>
	
	<script type="text/javascript">
	<!--
		function validar(formulario) {
			return validarProspecto(formulario);
		}
	//-->
	</script>

</cfoutput>