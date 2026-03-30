
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<form name="filtro" method="get" action="EmpleadosCF.cfm">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
 	<tr>
		<td align="right">
			<strong><cf_translate key="LB_CentroFuncionalDesde">Centro Funcional Desde</cf_translate>:&nbsp;</strong>
		</td>
		<td colspan="3">
			<cf_rhcfuncional form="filtro" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" >
		</td>
	</tr>
 	<tr>
		<td align="right">
			<strong><cf_translate key="LB_CentroFuncionalHasta">Centro Funcional Hasta</cf_translate>:&nbsp;</strong>
		</td>
		<td colspan="3">
			<cf_rhcfuncional form="filtro" name="CFcodigoF" desc="CFdescripcionF" id="CFidF" >
		</td>
	</tr>
 	
	<tr>
		<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
		<td >
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
			

		<cfoutput>
		<input type="submit" name="btnFiltrar" id="btnFiltrar" value="#BTN_Consultar#">
		<input type="reset" name="btnLimpiar" id="btnLimpiar" value="#BTN_Limpiar#">
		</cfoutput>
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