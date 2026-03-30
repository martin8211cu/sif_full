<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/sif/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ReporteDeDepositosElectronicos" default="Reporte de Dep&oacute;sitos Electr&oacute;nicos" returnvariable="LB_ReporteDeDepositosElectronicos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ReporteDeDepositosCheques" default="Reporte de Dep&oacute;sitos Cheques" returnvariable="LB_ReporteDeDepositosCheques" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipodeNomina" default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaNoAplicada" default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_ElTipoDeCambioDebeSerMayorACero" default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_TipoDeNomina" default="Tipo de N&oacute;mina" returnvariable="MSG_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="N&oacute;mina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_Buscar" default="Buscar" returnvariable="MSG_Buscar" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_Clave" default="Clave" returnvariable="MSG_Clave" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('Lvar_tipo') and Lvar_tipo EQ 1>
	<cfset titulo = LB_ReporteDeDepositosCheques>
<cfelse>
	<cfset titulo = LB_ReporteDeDepositosElectronicos>
</cfif>
<cf_templateheader title="#LB_nav__SPdescripcion#">
			<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet titulo="#LB_nav__SPdescripcion#" >
			<form name="form1" method="post" action="ExportaSAP-form.cfm" style="margin:0;">
            	<cfif isdefined('Lvar_tipo') and Lvar_tipo EQ 1><input name="chq" type="hidden" value="1"></cfif>
				<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td colspan="2">&nbsp;</td></tr>
					<!--- <tr>
						<td nowrap align="right"> <strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate> :&nbsp;</strong></td>
						<td><cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true"></td>
					</tr> --->
					<tr>
						<td width="43%">&nbsp;</td>
						<td colspan="2">
							<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
							<label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></strong></label>
						</td>
					</tr>
					<tr id="NAplicadas">
						<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
						<td colspan="2">
							<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" Excluir="2">
						</td>
					</tr>
					<tr id="NNoAplicadas" style="display:none">
						<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
						<td colspan="2">
							<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1"  Excluir="2">
						</td>
					</tr>
					
					<tr>
						<td nowrap align="right"> <strong><cf_translate  key="LB_Clave">Clave</cf_translate>:&nbsp;</strong></td>
						<td><input name="Clave" type="text" maxlength="4" size="5"></td>
					</tr>
					<tr>
						<td nowrap align="right"> <strong><cf_translate  key="LB_AgruparPor">Agrupar por</cf_translate>:&nbsp;</strong></td>
						<td>
							<input name="Orden" type="radio" id="radio0" value="0" checked>
								<label for="radio0" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_CentroFuncionalCuenta">Centro Funcional / Cuenta</cf_translate></label>&nbsp;&nbsp;
							<input name="Orden" type="radio" id="radio1" value="1">
								<label for="radio1" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_Cuenta">Cuenta</cf_translate></label>&nbsp;&nbsp;
							<input name="Orden" type="radio" id="radio2" value="2">
								<label for="radio2" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_Deducciones">Deducciones</cf_translate></label>
						</td>
					</tr>
					<tr>
						<td nowrap align="right" valign="top"> <strong><cf_translate  key="LB_Buscar">Buscar</cf_translate>:&nbsp;</strong></td>
						<td>
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<input name="Todos" type="checkbox" id="Todos" value="-1" checked="checked" onclick="javascript: funcTodos();">
											<label for="Todos" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_Todos">Todos</cf_translate></label>&nbsp;&nbsp;
									</td>
									<td>
										<input name="busca" type="checkbox" id="Deducciones" value="0" checked="checked">
											<label for="Deducciones" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_Deducciones">Deducciones</cf_translate></label>&nbsp;&nbsp;
									</td>
									<td>
										<input name="busca" type="checkbox" id="ConceptoPago" value="1" checked="checked">
											<label for="ConceptoPago" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_ConceptosDePago">Conceptos de Pago</cf_translate></label>&nbsp;&nbsp;
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<input name="busca" type="checkbox" id="DetalleCargas" value="2" checked onclick="javascript: deshabilitaE(this)">
											<label for="DetalleCargas" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_DetalleDeCargas">Detalle de Cargas</cf_translate></label>&nbsp;&nbsp;
									</td>
									<td>
										<input name="busca" type="checkbox" id="ComponenteSal" value="3" checked="checked">
											<label for="ComponenteSal" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_ComponentesSalariales">Componentes Salariales</cf_translate></label>&nbsp;&nbsp;
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<input name="busca" type="checkbox" id="Salarios" value="4" checked onclick="javascript: deshabilitaE(this)">
											<label for="Salarios" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_Salarios">Salarios</cf_translate></label>&nbsp;&nbsp;
									</td>
									<td colspan="2">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td nowrap align="right"> <strong><cf_translate  key="LB_Incluir">Incluir</cf_translate>:&nbsp;</strong></td>
						<td>
							<input name="Empleado" type="checkbox" id="Empleado" disabled>
								<label for="Empleado" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_Empleado">Empleado</cf_translate></label>&nbsp;&nbsp;
							<input name="CodExterno" type="checkbox" id="CodExterno">
								<label for="CodExterno" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="CHK_CodigoExterno">C&oacute;digo Externo</cf_translate></label>&nbsp;&nbsp;
						</td>
					</tr>
					<tr><td align="center" colspan="2"><cf_botones values="Generar" tabindex="1"></td></tr>
				</table>
			</form>
		</cf_web_portlet>
<cf_templatefooter>
<!--- <cf_qforms form="form1">
	<cf_qformsrequiredfield args="Tcodigo,#MSG_TipoDeNomina#">
    <cf_qformsrequiredfield args="CPcodigo,#MSG_NominaAplicada#">
	<!---cf_qformsrequiredfield args="Clave,#MSG_Clave#"--->
	<cf_qformsrequiredfield args="busca,#MSG_Buscar#">
</cf_qforms> --->
<script  language="javascript" type="text/javascript">
	function funcTodos(){
		var c = document.form1.Todos;
		if (c.checked){
			document.form1.Empleado.disabled = true;
		}else{
			document.form1.Empleado.disabled = false;
		}

		if (document.form1.busca) {
			if (document.form1.busca.value) {
				if (!document.form1.busca.disabled) { 
					document.form1.busca.checked = c.checked;
				}
			} else {
				for (var counter = 0; counter < document.form1.busca.length; counter++) {
					if (!document.form1.busca[counter].disabled) {
						document.form1.busca[counter].checked = c.checked;
					}
				}
			}
		}
	}
	function deshabilitaE(obj){
		if (obj.checked){
			document.form1.Empleado.disabled = true;
		}else{
			document.form1.Empleado.disabled = false;
		}
	}
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