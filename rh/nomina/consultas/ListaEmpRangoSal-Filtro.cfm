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
<form name="filtro" method="get" action="ListaEmpRangoSal.cfm">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
		<tr>
			<td>
				<table border="0" cellpadding="1" cellspacing="1" align="center">
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td align="right"><strong><cf_translate  key="LB_SalarioDesde">Salario desde</cf_translate>&nbsp;</strong></td>
						<td>
							<input name="SalarioD" type="text" value="" size="15"
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,2);">
						</td>
						<td><strong><cf_translate  key="LB_Hasta">hasta</cf_translate>&nbsp;</strong></td>
						<td>
							<input name="SalarioH" type="text" value="" size="15"
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,2);">
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate  key="LB_HacerCortesPor">Hacer cortes por</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<input name="Corte" type="text" value="" size="15"
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,2);">
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate  key="LB_DesplegarNombrePor">Desplegar Nombre por</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<input name="nombre1" id="nombre1" type="checkbox" value="0" checked
								onClick="javascript: if (this.checked == false){document.filtro.nombre1.checked=false;document.filtro.nombre2.checked=true;}else{document.filtro.nombre2.checked=false;}">
							<label for="nombre1"><cf_translate  key="CHK_ApellidoNombre">Apellido - Nombre</cf_translate></label>
						
							<input name="nombre2" id="nombre2" type="checkbox" value="1" 
								onClick="javascript: if (this.checked == false){document.filtro.nombre2.checked=false;document.filtro.nombre1.checked=true;}else{document.filtro.nombre1.checked=false;}">
							<label for="nombre2"><cf_translate  key="CHK_NombreApellido">Nombre - Apellido</cf_translate></label>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate  key="LB_OrdenadoPor">Ordenado por</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<select name="orden">
								<option value="1"><cf_translate  key="CMB_Identificacion">Identificaci&oacute;n</cf_translate></option>
								<option value="2"><cf_translate  key="CMB_Nombre">Nombre</cf_translate></option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
						<td colspan="4">
							<select name="formato">
								<option value="flashpaper"><cf_translate  key="CMB_Flashpaper">Flashpaper</cf_translate></option>
								<option value="pdf"><cf_translate  key="CMB_PDF">PDF</cf_translate></option>
								<option value="excel"><cf_translate  key="CMB_Excel">Excel</cf_translate></option>
							</select>
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td nowrap align="center" colspan="4">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Consultar"
						Default="Consultar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Consultar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
						
						
						<input type="button" name="btnFiltrar" id="btnFiltrar" value="<cfoutput>#BTN_Consultar#</cfoutput>" 
							onClick="javascript: document.filtro.SalarioD.value = qf(document.filtro.SalarioD.value);document.filtro.SalarioH.value=qf(document.filtro.SalarioH.value);document.filtro.Corte.value=qf(document.filtro.Corte.value);funcConsultar(this.form); ">
						<input type="hidden" name="btnFiltrar" value="Filtrar">
						<input type="reset" name="btnLimpiar" id="btnLimpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>">
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
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

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElSalarioHASTADebeSerMayorAlSalarioDESDE"
	Default="El salario HASTA debe ser mayor al salario DESDE"
	returnvariable="MSG_ElSalarioHASTADebeSerMayorAlSalarioDESDE"/>

	
	function funcConsultar(f){
		if (f.SalarioH.value != '' && parseFloat(redondear(f.SalarioD.value,2)) > parseFloat(redondear(f.SalarioH.value,2))){
			alert('<cfoutput>#MSG_ElSalarioHASTADebeSerMayorAlSalarioDESDE#</cfoutput>');
			f.SalarioD.focus();
			return false;
		}
		f.submit();
	}
</script>  