<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<form name="filtro" method="get" action="VacacionesEmpA.cfm">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
 	<tr>
		<td width="38%" align="right">
			<strong>Centro Funcional Desde:&nbsp;</strong>
		</td>
		<td colspan="3">
			<cf_rhcfuncional form="filtro" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" >
		</td>
	</tr>
 	<tr>
		<td align="right">
			<strong>Centro Funcional Hasta:&nbsp;</strong>
		</td>
		<td colspan="3">
			<cf_rhcfuncional form="filtro" name="CFcodigoF" desc="CFdescripcionF" id="CFidF" >
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
			<table width="100%" border="0">
				<tr>
					<td align="right" nowrap="nowrap" width="38%"><strong>Fecha Desde:</strong></td>
					<td align="left" nowrap="nowrap" width="13%"><cf_sifcalendario form="filtro" value="" name="fdesde" tabindex="1"></td>
					<td align="right" nowrap="nowrap" width="10%"><strong>Fecha Hasta:</strong></td>
					<td align="left"><cf_sifcalendario form="filtro" value="" name="fhasta" tabindex="1"></td>
				</tr>
			</table>
		</td>
	</tr>
 	<tr>
		<td align="right"><strong>Desplegar Nombre por:&nbsp;</strong></td>
		<td width="16%">
			<input name="nombre1" id="nombre1" type="checkbox" value="0" checked
				onClick="javascript: if (this.checked == false){document.filtro.nombre1.checked=false;document.filtro.nombre2.checked=true;}else{document.filtro.nombre2.checked=false;}">
			<label for="nombre1">Apellido - Nombre</label>
		</td>
		<td width="46%">
			<input name="nombre2" id="nombre2" type="checkbox" value="1" 
				onClick="javascript: if (this.checked == false){document.filtro.nombre2.checked=false;document.filtro.nombre1.checked=true;}else{document.filtro.nombre1.checked=false;}">
			<label for="nombre2">Nombre - Apellido</label>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Ordenado por:&nbsp;</strong></td>
		<td colspan="3">
			<select name="orden">
				<option value="1">Identificaci&oacute;n</option>
				<option value="2">Nombre</option>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Formato:&nbsp;</strong></td>
		<td colspan="2">
			<select name="formato">
				<option value="flashpaper">Flashpaper</option>
				<option value="pdf">PDF</option>
				<option value="excel">Excel</option>
			</select>
		</td>
	</tr>
	<tr>
		<td nowrap align="center" colspan="3">
		<input type="submit" name="btnFiltrar" id="btnFiltrar" value="Consultar">
		<input type="reset" name="btnLimpiar" id="btnLimpiar" value="Limpiar">
		<!--- <input type="submit" name="btnGenerar" id="btnGenerar" value="Generar"> --->
			</td>
	</tr>
</table>
</form>
<script language="JavaScript" type="text/javascript">
	//Instancia de qForm
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtro");
	//Validaciones 
	//objForm.Tcodigo.required = true;
	//objForm.Tcodigo.description = "Tipo Nómina";
	//objForm.CPcodigo.required = true;
	//objForm.CPcodigo.description = "Código";
	//objForm.Tcodigo.obj.focus();
</script>