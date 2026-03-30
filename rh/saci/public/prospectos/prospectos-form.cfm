<cfoutput>

	<form method="post" name="form1" action="prospectos-apply.cfm" onsubmit="return validar(this);" style="margin:0">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td>
				<cf_web_portlet_start titulo="Ayuda" tipo="box">
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
				<tr>
					<td>
					Si usted desea recibir alguno de nuestros servicios,
					puede llenar el siguiente formulario para que alguno
					de nuestros agentes pueda contactarlo.
					</td>
				</tr>
				</table>
				<cf_web_portlet_end> 
			</td>
		</tr>
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
				<cf_botones names="Enviar" values="Enviar">
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