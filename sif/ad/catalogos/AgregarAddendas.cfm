<cf_templateheader title="Agregar Addenda">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Agregar Addenda al Cliente'>
<form enctype="multipart/form-data" action="AgregarAddendas-sql.cfm" method="post" name="form6" onsubmit="javascript:document.form6.dir.value=document.form6.OLPdato.value;">
<table>
	<tr>
		<td>Clave de la Addenda</td>
		<td><Input type="text" maxlength="5" name="ADDcodigo"></td>
	</tr>
	<tr>
		<td>Nombre de la Addenda</td>
		<td><Input type="text" maxlength="15" name="ADDNombre"></td>
	</tr>
	<tr>
		<td>Ingresa una descripci&oacute;n</td>
		<td><input type="text" maxlength="50" name="ADDdesc"></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<table align="center">
				<tr>
					<td align="center">
						<input type="submit" class = "btnGuardar" name="Guardar" value="Guardar" >
					</td>
					<td align="center">
						<input type="button" class = "btnAnterior" onclick="Regresar();" value="Regresar">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<cf_templatefooter>

<cf_qforms objForm="objForm6" form="form6">
<script type="text/javascript" language="JavaScript1.2" >

		objForm6.ADDcodigo.required = true;
		objForm6.ADDcodigo.description="Clave de la Addenda";

		objForm6.ADDNombre.required = true;
		objForm6.ADDNombre.description="Nombre de la Addenda";

		objForm6.ADDdesc.required = true;
		objForm6.ADDdesc.description="Descripción de la Addenda";

	function Regresar(){
		location.href = 'listaAddendas.cfm';
	}
</script>