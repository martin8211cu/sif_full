<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos">Recursos Humanos</cf_translate>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ReporteDeNomina"
			Default="Reporte de Nómina"
			returnvariable="LB_ReporteDeNomina"/>
		<cf_web_portlet titulo="#LB_ReporteDeNomina#" >
			<cfinclude template="/rh/portlets/pNavegacion.cfm">	
			<form name="form1" method="post" action="RepNominaBARODASA_Desp.cfm" style="margin:0;">
				<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="2">
							<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
							<label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></strong></label>
						</td>
					</tr>
					<tr id="NAplicadas">
						<td nowrap align="right"> <strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate> :&nbsp;</strong></td>
						<td><cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1"></td>
					</tr>
					<tr id="NNoAplicadas" style="display:none">
						<td nowrap align="right"> <strong><cf_translate  key="LB_NominasNoAplicadas">N&oacute;minas no Aplicadas</cf_translate> :&nbsp;</strong></td>
						<td><cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2"></td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="Formato">Formato</cf_translate>:&nbsp;</strong></td>
						<td>
							<select name="Formatos">
								<option value="flashpaper"><cf_translate key="CMB_Flashpaper">Flashpaper</cf_translate></option>
								<option value="pdf"><cf_translate key="CMB_PDF">PDF</cf_translate></option>
								<option value="excel"><cf_translate key="CMB_Excel">Excel</cf_translate></option>
							</select>
							</td>
					</tr>
					
					<tr>
						<td align="center" colspan="2">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Generar"
								Default="Generar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Generar"/>	
							<cf_botones values="#BTN_Generar#" tabindex="1">
						</td>
					</tr>
				</table>
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipodeNomina"
	Default="Tipo de Nómina"
	returnvariable="MSG_TipodeNomina"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NominaAplicada"
	Default="Nómina Aplicada"
	returnvariable="MSG_NominaAplicada"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NominaNoAplicada"
	Default="Nómina no Aplicada"
	returnvariable="MSG_NominaNoAplicada"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipoDeCambio"
	Default="Tipo de Cambio"
	returnvariable="MSG_TipoDeCambio"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElTipoDeCambioDebeSerMayorACero"
	Default="El tipo de cambio debe ser mayor a cero"
	returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero"/> 

<script language="javascript" type="text/javascript">
	function funcValida(){
		if (!objForm._allowSubmitOnError) {
			<cfoutput>
			objForm.Tcodigo1.description  = "#MSG_TipodeNomina#";
			objForm.CPcodigo1.description = "#MSG_NominaAplicada#";
			objForm.Tcodigo2.description  = "#MSG_TipodeNomina#";
			objForm.CPcodigo2.description = "#MSG_NominaNoAplicada#";
			</cfoutput>
			if (objForm.TipoNomina.getValue()=="on" && objForm.Tcodigo1.getValue() == "")
				objForm.Tcodigo1.throwError('El campo ' + objForm.Tcodigo1.description + ' es requerido.');
			if (objForm.TipoNomina.getValue()=="on" && objForm.CPcodigo1.getValue() == "")
				objForm.CPcodigo1.throwError('El campo ' + objForm.CPcodigo1.description + ' es requerido.');
			if (objForm.TipoNomina.getValue()=="" && objForm.Tcodigo2.getValue() == "")
				objForm.Tcodigo2.throwError('El campo ' + objForm.Tcodigo2.description + ' es requerido.');
			if (objForm.TipoNomina.getValue()=="" && objForm.CPcodigo2.getValue() == "")
				objForm.CPcodigo2.throwError('El campo ' + objForm.CPcodigo2.description + ' es requerido.');
		}
	}
</script>

<cf_qforms onValidate="funcValida">
</cf_qforms>
<script language="javascript" type="text/javascript">
	function Verificar(){
		if (document.getElementById("TipoNomina").checked == true){
			document.getElementById("NNoAplicadas").style.display='none'; 
			document.getElementById("NAplicadas").style.display=''
			document.form1.Tcodigo2.value = '';
			document.form1.CPcodigo2.value = '';
			document.form1.CPdescripcion2.value = '';
			}
		else{
			document.getElementById("NNoAplicadas").style.display=''; 
			document.getElementById("NAplicadas").style.display='none'
			document.form1.Tcodigo1.value = '';
			document.form1.CPcodigo1.value = '';
			document.form1.CPdescripcion1.value = '';
		}
	}
	Verificar();
</script>
