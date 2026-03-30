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
<form name="filtro" method="get" action="CambiosPuesto.cfm">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
		<tr>
			<td>
				<table border="0" cellpadding="1" cellspacing="1" align="center">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>&nbsp;</strong></td>
						<td><cf_sifcalendario name = "FechaD" form="filtro"></td>
						<td><strong><cf_translate key="LB_hasta">hasta</cf_translate>&nbsp;</strong></td>
						<td><cf_sifcalendario name = "FechaH" form="filtro"></td>
					</tr>
					<tr>
						<td><strong><cf_translate key="LB_DesplegarNombrePor">Desplegar Nombre por</cf_translate>:&nbsp;</strong></td>
						<td>
							<input name="nombre1" id="nombre1" type="checkbox" value="0" checked
								onClick="javascript: if (this.checked == false){document.filtro.nombre1.checked=false;document.filtro.nombre2.checked=true;}else{document.filtro.nombre2.checked=false;}">
							<label for="nombre1"><cf_translate key="CHK_ApellidoNombre">Apellido - Nombre</cf_translate></label>
						</td>
						<td colspan="2">
							<input name="nombre2" id="nombre2" type="checkbox" value="1" 
								onClick="javascript: if (this.checked == false){document.filtro.nombre2.checked=false;document.filtro.nombre1.checked=true;}else{document.filtro.nombre1.checked=false;}">
							<label for="nombre2"><cf_translate key="CHK_NombreApellido">Nombre - Apellido</cf_translate></label>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_OrdenadoPor">Ordenado por</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<select name="orden">
								<option value="1"><cf_translate key="CMB_Identificacion">Identificaci&oacute;n</cf_translate></option>
								<option value="2"><cf_translate key="CMB_Nombre">Nombre</cf_translate></option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
						<td colspan="4">
							<select name="formato">
								<option value="flashpaper"><cf_translate key="CMB_Flashpaper">Flashpaper</cf_translate></option>
								<option value="pdf"><cf_translate key="CMB_PDF">PDF</cf_translate></option>
								<option value="excel"><cf_translate key="CMB_Excel">Excel</cf_translate></option>
							</select>
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td nowrap align="center" colspan="4">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Consultar"
						Default="Consultar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Consultar"/>
						<cfoutput>										
						<input type="submit" name="Consultar" value="#BTN_Consultar#">
						<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
						</cfoutput>
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
			  </table>
			</td>
		</tr>
	</table>
</form>
 <script language="JavaScript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtro");
	
	// Valida el rango entre la fecha de desde y la fecha de hasta del filtro
	function __isRangoFechas() {
		if (this.required) {
			var a = this.obj.form.FechaD.value.split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = this.obj.form.FechaH.value.split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			var dif = ((fin-ini)/86400000.0)+1;	// diferencia en días
			if (new Number(dif) < 0) {
				this.error = "La Fecha HASTA no puede ser menor que la Fecha DESDE";
			}
		}
	}
	
	_addValidator("isRangoFechas", __isRangoFechas);
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaDesde"
	Default="Fecha Desde"
	returnvariable="MSG_FechaDesde"/>
						
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="MSG_FechaHasta"/>

	objForm.FechaD.required = true;
	objForm.FechaD.description = "<cfoutput>#MSG_FechaDesde#</cfoutput>";
	objForm.FechaH.required = true;
	objForm.FechaH.description = "<cfoutput>#MSG_FechaHasta#</cfoutput>";
	objForm.FechaH.validateRangoFechas();
	
</script>  