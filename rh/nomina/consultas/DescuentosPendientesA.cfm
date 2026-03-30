<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_REcursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DescuentosPendientesDeAplicar" Default="Descuentos Pendientes de Aplicar" returnvariable="LB_DescuentosPendientesDeAplicar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioPago" Default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_TipodeNomina" Default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaAplicada" Default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaNoAplicada" Default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_ElTipoDeCambioDebeSerMayorACero" Default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
        <cf_web_portlet_start titulo="#LB_DescuentosPendientesDeAplicar#">
		<cfoutput>
		<form action="DescuentosPendientesA-form.cfm" method="get" name="form1" style="margin:0">
			<table width="85%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr>
					<td width="43%">&nbsp;</td>
					<td>
						<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
						<label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></strong></label>
					</td>
				</tr>
				<tr id="NAplicadas">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td>
						<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" Excluir="2">
					</td>
				</tr>
				<tr id="NNoAplicadas" style="display:none">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td>
						<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1"  Excluir="2">
					</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong><cf_translate  key="LB_Deduccion">Deducci&oacute;n</cf_translate>&nbsp;:&nbsp;</strong></td>
					<td><cf_rhtipodeduccion form="form1" size= "40" tabindex="1"></td>
				</tr>
				<tr>
					<td align="right" valign="top"><strong>#LB_Empleado#&nbsp;:&nbsp;</strong></td>
					<td><cf_rhempleado tabindex="1">&nbsp;</td>
				</tr>
				<tr>
					<td align="right" nowrap>&nbsp;</td>
					<td>
						<input name="chkTotales" id="chkTotales" type="checkbox">
						<label for="chkTotales" style="font-style:normal; font-variant:normal; font-weight:normal">
							<strong><cf_translate key="LB_TotalesDeColumna">Totales por Columna y Total General</cf_translate></strong>
						</label>
					</td>
				</tr>
				<tr>
					<th scope="row"  colspan="2" class="fileLabel"><cf_botones values="Ver" tabindex="1">&nbsp;</th>
				</tr>
			</table>
	  </form>
</cfoutput>


        <cf_web_portlet_end>
<cf_templatefooter>

<script>
	/*función que prepara las validaciones y muestra oculta campos relacionados con las nóminas aplicadas/sin aplicar*/
	function Verificar(){
		if (document.getElementById("TipoNomina").checked == true){
			document.getElementById("NAplicadas").style.display=''
			document.getElementById("NNoAplicadas").style.display='none'; 
			document.form1.Tcodigo1.value = '';
			document.form1.CPid1.value = '';
			document.form1.CPcodigo1.value = '';
			document.form1.CPdescripcion1.value = '';
			}
		else{
			document.getElementById("NAplicadas").style.display='none'
			document.getElementById("NNoAplicadas").style.display=''; 
			document.form1.Tcodigo2.value = '';
			document.form1.CPid2.value = '';
			document.form1.CPcodigo2.value = '';
			document.form1.CPdescripcion2.value = '';
		}
	}
	Verificar();
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