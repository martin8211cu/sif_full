<!---=============== TRADUCCION ===================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_quedan_calendarios_de_pago_para_el_tipo_de_Nomina_seleccionado"
	Default="No quedan calendarios de pago para el tipo de Nómina seleccionado"	
	returnvariable="MSG_NoHayCalendariosPago"/>
<!---Boton de aplicar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_puede_ser_cero"
	Default="no puede ser cero!"	
	returnvariable="MSG_No_puede_ser_cero"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"	
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo_de_Nomina"
	Default="Tipo de Nómina"	
	returnvariable="MSG_Tipo_de_Nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Desde"
	Default="Fecha Desde"	
	returnvariable="MSG_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Hasta"
	Default="Fecha Hasta"	
	returnvariable="MSG_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Porcentaje_incorrecto"
	Default="El porcentaje no puede ser mayor a 100."	
	returnvariable="MSG_Porcentaje_incorrecto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Porcentaje"
	Default="Porcentaje"
	returnvariable="MSG_Porcentaje"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concepto_Incidente"
	Default="Concepto Incidente"
	returnvariable="LB_Concepto_Incidente"
	xmlfile="/rh/nomina//operacion/Incidencias.xml"/>

<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var calCPcodgo = new Object();
	var calRCdesde = new Object();
	var calRChasta = new Object();
	var calRCid = new Object();	
	
	<cfoutput>
	<cfloop query="MinFechasNomina">
		<cfquery name="rsCalendarios" dbtype="query">
			select *
			from PaySchedAfterRestrict
			where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MinFechasNomina.Tcodigo#">
			and CPdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#MinFechasNomina.CPdesde#">
		</cfquery>
		calCPcodgo['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.CPcodigo#';
		calRCdesde['#rsCalendarios.Tcodigo#'] = '#LSDateFormat(rsCalendarios.CPdesde, 'DD/MM/YYYY')#';
		calRChasta['#rsCalendarios.Tcodigo#'] = '#LSDateFormat(rsCalendarios.CPhasta, 'DD/MM/YYYY')#';
		calRCid['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.CPid#';
	</cfloop>
	</cfoutput>
	
	function changeCalculo() {
		changeCal(document.form1.Tcodigo);
	}
	

	function changeCal(ctl) {
		var name = ctl.value;
		if (ctl.form.Tcodigo == '') {
			return false;
		}
		if (calRCdesde[name] && calRChasta[name]) {
			ctl.form.CPcodigo.value = calCPcodgo[name];
			ctl.form.RCdesde.value = calRCdesde[name];
			ctl.form.RChasta.value = calRChasta[name];
			ctl.form.RCNid.value = calRCid[name];
		} else {
			ctl.form.CPcodigo.value = '';
			ctl.form.RCdesde.value = '';
			ctl.form.RChasta.value = '';
			ctl.form.RCNid.value = '';
			<cfoutput>alert('#MSG_NoHayCalendariosPago#')</cfoutput>;
		}
	}
	//-->
</SCRIPT>

<cfoutput>
<form name="form1" method="post" action="RelacionCalculoEsp-sql.cfm">
	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
      <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_nomina">Tipo de N&oacute;mina:</cf_translate></td>
        <td nowrap> 
			<cf_rhtiponominaCombo index="0" onChange="changeCalculo" combo="true" todas="false">
			
			<!---<select tabindex="1" name="Tcodigo" onChange="javascript: changeCal(this);">
            <cfloop query="rsTiposNomina">
              <option value="#rsTiposNomina.Tcodigo#">#rsTiposNomina.Tdescripcion#</option>
            </cfloop>
          	</select>---> 
		</td>
        <td align="right" nowrap class="fileLabel">&nbsp;</td>
        <td nowrap>&nbsp;</td>
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Desde">Fecha Desde:</cf_translate></td>
        <td nowrap> <input tabindex="1" type="text" name="RCdesde" id="RCdesde" value="" size="15" maxlength="10" readonly=""> 
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Calendario_de_Pago">Calendario de Pago:</cf_translate></td>
        <td nowrap><input tabindex="1" type="text" name="CPcodigo" id="CPcodigo2" value="" size="20" maxlength="11" readonly=""> 
        </td>
        <td align="right" nowrap class="fileLabel">&nbsp;</td>
        <td nowrap>&nbsp;</td>
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta:</cf_translate></td>
        <td nowrap> <input tabindex="1" type="text" name="RChasta" id="RChasta" value="" size="15" maxlength="10" readonly=""> 
        </td>
      </tr>
      <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n:</cf_translate></td>
        <td nowrap colspan="3"> <input tabindex="1" name="RCDescripcion" type="text" id="RCDescripcion2" size="90" maxlength="80"></td>
        <td align="right" nowrap class="fileLabel">&nbsp;</td>
        <td nowrap>&nbsp;</td>
      </tr>

      <tr> 
        <td nowrap align="right" ><input type="checkbox" name="RCpagoentractos" value="" onclick="javascript:funcPorcentaje(this);" /> </td>
        <td colspan="5">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" nowrap class="fileLabel"><cf_translate key="LB_PagoDosTractos">Pago en dos tractos</cf_translate></td>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_PorcentajePago">Porcentaje de Pago</cf_translate></td>
					<td nowrap><cf_monto name="RCporcentaje" size="3" decimales="0" value="" >%</td>
					<td nowrap class="fileLabel">#LB_Concepto_Incidente#</td>
					<td><cf_rhCIncidentes tabindex="1" ExcluirTipo="3"></td>
					
				</tr>
			</table>
		</td>
		
      </tr>
	  
      <tr> 
        <td height="28" colspan="6" align="center">  
          <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"> 
          <cfoutput> 
            <input tabindex="1" type="submit" name="btnAplicar" value="#BTN_Aplicar#" >
          </cfoutput> </td>
      </tr>
    </table>
	<input type="hidden" name="RCNid" value="">
</form>
</cfoutput>

<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
	
	function __isNotCero() {
		if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.error = this.description + ' ' + "#MSG_No_puede_ser_cero#";
		}
	}

	function __isFueraRango() {
		if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) > 100))) {
			this.error = "<cfoutput>#MSG_Porcentaje_incorrecto#</cfoutput>";
		}
	}

	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isFueraRango", __isFueraRango);	
	<cfoutput>
	objForm.RCDescripcion.required = true;
	objForm.RCDescripcion.description = "#MSG_Descripcion#";

	objForm.Tcodigo.required = true;
	objForm.Tcodigo.description = "#MSG_Tipo_de_Nomina#";
	objForm.RCdesde.required = true;
	objForm.RCdesde.description = "#MSG_Fecha_Desde#";
	objForm.RChasta.required = true;
	objForm.RChasta.description = "#MSG_Fecha_Hasta#";

	objForm.RCporcentaje.validateFueraRango();
	
	changeCal(document.form1.Tcodigo);
	
	function funcPorcentaje(obj){
		if ( obj.checked ){
			objForm.RCporcentaje.required = true;
			objForm.RCporcentaje.description = '#MSG_Porcentaje#';
			objForm.CIid.required = true;
			objForm.CIid.description = '#LB_Concepto_Incidente#';
		}
		else{
			objForm.RCporcentaje.required = false;
			objForm.CIid.required = false;
		}
	}
	
	</cfoutput>	
	
	
	//-->
</SCRIPT>