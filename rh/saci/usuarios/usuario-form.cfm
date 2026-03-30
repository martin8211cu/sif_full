<cfoutput>
	<form name="form1" action="usuario-apply.cfm" method="post" style="margin: 0;">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>
				<cf_usuarioSACI
					form = "form1"
					sufijo = ""
					cambioPass = "false"
					showId = "true"
					readonly = "false"
				>
			</td>
		  </tr>
		  <tr>
			<td>
				<cf_botones names="Guardar" values="Crear Usuario" tabindex="1">
			</td>
		  </tr>
		</table>
		
	</form>
	
	<script language="javascript" type="text/javascript">
		function funcGuardar() {
			var a = document.getElementById("boxbotones");
			if ((a.style.display == 'none') || (document.form1.rdGen[0].checked && document.form1.userEmail.value == '') || (document.form1.rdGen[1].checked && document.form1.user.value == '')) {
				alert('No se puede crear el usuario');
				return false;
			}
			if (document.form1.rdGen[1].checked) {
				if (document.form1.userPass1.value != document.form1.userPass2.value) {
					alert('La confirmación de la contraseña es diferente a la contraseña digitada. Digite ambas nuevamente.');
					return false;
				}
			}
		}
	</script>
</cfoutput>