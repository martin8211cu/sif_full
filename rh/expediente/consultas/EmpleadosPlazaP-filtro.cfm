<!--- 
	Creado por: Ana Villavicencio
	Fecha: 26 de enero del 2006
	Motivo: Nuevo reporte de empleados por plaza Presupuestaria.
 --->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<form name="filtro" method="get" action="EmpleadosPlazaP.cfm">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
 	<tr>
		<td width="37%" align="right"><strong><cf_translate key="LB_CentroFuncionalDesde">Centro Funcional Desde</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhcfuncional form="filtro" name="CFcodigoI" desc="CFdescripcionI" id="CFidI"></td>
	</tr>
 	<tr>
		<td align="right"><strong><cf_translate key="LB_CentroFuncionalHasta">Centro Funcional Hasta</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhcfuncional form="filtro" name="CFcodigoF" desc="CFdescripcionF" id="CFidF"></td>
	</tr>
 	<tr>
		<td align="right"><strong><cf_translate key="LB_FechaDeCorte">Fecha de Corte</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_sifcalendario form="filtro" name="FechaCorte"></td>
	</tr>
	<tr>
		<td align="right"><strong><cf_translate key="LB_DesplegarNombrePor">Desplegar Nombre por</cf_translate>:&nbsp;</strong></td>
		<td nowrap>
			<input name="nombre1" id="nombre1" type="checkbox" value="0" checked
				onClick="javascript: if (this.checked == false){document.filtro.nombre1.checked=false;document.filtro.nombre2.checked=true;}else{document.filtro.nombre2.checked=false;}">
			<label for="nombre1"><cf_translate key="CHK_ApellidoNombre">Apellido - Nombre</cf_translate></label>
		</td>
		<td width="48%">
			<input name="nombre2" id="nombre2" type="checkbox" value="1" 
				onClick="javascript: if (this.checked == false){document.filtro.nombre2.checked=false;document.filtro.nombre1.checked=true;}else{document.filtro.nombre1.checked=false;}">
			<label for="nombre2"><cf_translate key="CHK_NombreApellido">Nombre - Apellido</cf_translate></label>
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
	<tr>
		<td nowrap align="center" colspan="10">
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
		
		
		<cf_botones exclude="Alta,Baja,Cambio,Limpiar" include="#BTN_Consultar#,#BTN_Limpiar#">
		<!--- <input type="submit" name="btnFiltrar" id="btnFiltrar" value="Consultar">
		<input type="reset" name="btnLimpiar" id="btnLimpiar" value="Limpiar"> --->
		</td>
	</tr>
</table>
</form>
