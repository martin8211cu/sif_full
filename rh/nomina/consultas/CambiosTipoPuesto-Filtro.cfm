<!---
	Creado por: Ana Villavicencio
	Fecha: 03 de enero del 2006
	Motivo: Nuevo reporte de Empleados por Rango de Salarios
--->
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<form name="filtro" method="get" action="CambiosTipoPuesto.cfm">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
		<tr>
			<td>
				<table border="0" cellpadding="1" cellspacing="1" align="center">
					<tr>
						<td align="right"><strong>Salario desde&nbsp;</strong></td>
						<td>
							<input name="SalarioD" type="text" value="" size="15"
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,2);">
						</td>
						<td><strong>hasta&nbsp;</strong></td>
						<td>
							<input name="SalarioH" type="text" value="" size="15"
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,2);">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Hacer cortes por:&nbsp;</strong></td>
						<td>
							<input name="Corte" type="text" value="" size="15"
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,2);">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Formato:&nbsp;</strong></td>
						<td colspan="4">
							<select name="formato">
								<option value="flashpaper">Flashpaper</option>
								<option value="pdf">PDF</option>
								<option value="excel">Excel</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td nowrap align="center" colspan="4">
						<input type="button" name="btnFiltrar" id="btnFiltrar" value="Consultar" 
							onClick="javascript: document.filtro.SalarioD.value = qf(document.filtro.SalarioD.value);document.filtro.SalarioH.value=qf(document.filtro.SalarioH.value);document.filtro.Corte.value=qf(document.filtro.Corte.value);funcConsultar(this.form); ">
						<input type="hidden" name="btnFiltrar" value="Filtrar">
						<input type="reset" name="btnLimpiar" id="btnLimpiar" value="Limpiar">
						</td>
					</tr>
			  </table>
			</td>
		</tr>
	</table>
</form>
 <script language="JavaScript" type="text/javascript">
	/*qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtro");
	
	objForm.SalarioD.required = true;
	objForm.SalarioD.description = "Salario desde";
	objForm.SalarioH.required = true;
	objForm.SalarioH.description = "Salario hasta";*/
	function funcConsultar(f){
		if (f.SalarioH.value != '' && parseFloat(redondear(f.SalarioD.value,2)) > parseFloat(redondear(f.SalarioH.value,2))){
			alert('El salario HASTA debe ser mayor al salario DESDE');
			f.SalarioD.focus();
			return false;
		}
		f.submit();
	}
</script>  