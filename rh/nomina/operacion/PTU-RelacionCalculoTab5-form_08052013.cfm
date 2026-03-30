<cfset navegacion = "RHPTUEid=" & Form.RHPTUEid>
<cfset navegacion = navegacion & "&tab=5">

<!--- Consultas --->
<!--- Tipos de Nómina que tienen un calendario de pago de tipo PTU --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and exists (
		select 1
		from CalendarioPagos b
		where a.Tcodigo = b.Tcodigo
		and a.Ecodigo = b.Ecodigo
		and b.CPfcalculo is null
		and b.CPtipo = 4
		and not exists(
			select 1
			from RCalculoNomina rc
			where rc.RCNid = b.CPid
			)
	)
	order by a.Tdescripcion
</cfquery>
<!--- <cfif rsTiposNomina.RecordCount EQ 0>
	<cfthrow message="No hay relaciones de Cálculo Especiales definidas.">
</cfif> --->
<!--- Calendarios --->

<cfquery datasource = "#session.DSN#" name="rsEmpresa">
	select Ecodigo from RHPTUD
	where RHPTUEid = #form.RHPTUEid#
</cfquery>
            
<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
	select
		a.CPcodigo, 
		a.CPid, 
		rtrim(a.Tcodigo) as Tcodigo, 
		a.CPdesde, 
		a.CPhasta
	from CalendarioPagos a
	where a.Ecodigo in (#ValueList(rsEmpresa.Ecodigo)#)
	and a.CPfenvio is null
	and a.CPtipo = 4
	and not exists (
		select 1
		from RCalculoNomina h
		where a.Ecodigo = h.Ecodigo
		and a.Tcodigo = h.Tcodigo
		and a.CPdesde = h.RCdesde
		and a.CPhasta = h.RChasta
		and a.CPid = h.RCNid
	)
	and not exists (
		select 1
		from HERNomina i
		where a.Tcodigo = i.Tcodigo
		and a.Ecodigo = i.Ecodigo
		and a.CPdesde = i.HERNfinicio
		and a.CPhasta = i.HERNffin
		and a.CPid = i.RCNid
	)
</cfquery>
<!--- <cfif rsTiposNomina.RecordCount EQ 0>
	<cfthrow message="No hay Calendarios definidos para Nóminas Especiales.">
</cfif> --->

<cfquery name="MinFechasNomina" dbtype="query">
	select Tcodigo, min(CPdesde) as CPdesde
	from PaySchedAfterRestrict
	group by Tcodigo
</cfquery>


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

<cfquery name="rsRHPTUEt5" datasource="#session.DSN#">
	select a.CIid, b.CIcodigo, b.CIdescripcion
    from RHPTUE a
	inner join CIncidentes b
	on b.CIid = a.CIid
    where RHPTUEid = #form.RHPTUEid#
</cfquery>

<cfoutput>
<form name="form1" method="post" action="PTU-RelacionCalculoTab5-sql.cfm" ><!--- onsubmit="return fnVerifica(document.form1.RCNid.value);" --->
	<input name="RHPTUEid" value="<cfoutput>#form.RHPTUEid#</cfoutput>" type="hidden" />
    <input name="tab" value="5" type="hidden" />
	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
      <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_nomina">Tipo de N&oacute;mina:</cf_translate></td>
        <td nowrap>                        
			<cf_rhtiponominaCombo index="0" onChange="changeCalculo" combo="true" todas="false" Ecodigo="#ValueList(rsEmpresa.Ecodigo)#">
		</td>
      </tr>
      <tr>
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Desde">Fecha Desde:</cf_translate></td>
		<td nowrap> <input tabindex="1" type="text" name="RCdesde" id="RCdesde" value="" size="15" maxlength="10" readonly=""></td>        
      </tr> 

      <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Calendario_de_Pago">Calendario de Pago:</cf_translate></td>
        <td nowrap><input tabindex="1" type="text" name="CPcodigo" id="CPcodigo2" value="" size="20" maxlength="11" readonly=""> 
	  </tr>
      <tr>
	    <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta:</cf_translate></td>
        <td nowrap> <input tabindex="1" type="text" name="RChasta" id="RChasta" value="" size="15" maxlength="10" readonly=""></td>
      </tr>
      <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n:</cf_translate></td>
        <td nowrap> <input tabindex="1" name="RCDescripcion" type="text" id="RCDescripcion2" size="40" maxlength="80"></td>
      </tr>

      <tr> 
        <td nowrap class="fileLabel" align="right">#LB_Concepto_Incidente#</td>
        <td align="left">#rsRHPTUEt5.CIcodigo# - #rsRHPTUEt5.CIdescripcion#</td>
        <input name="CIid" value="#rsRHPTUEt5.CIid#" type="hidden" />
      </tr>
	  
      <tr> 
        <td height="28" colspan="6" align="center">  
          <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"> 
          <cfoutput> 
            <input tabindex="1" type="submit" name="btnAplicar" value="#BTN_Aplicar#" >
          </cfoutput> </td>
          <input name="control" id="control" value="0" type="hidden" />
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
	
	changeCal(document.form1.Tcodigo);
	
	</cfoutput>	
	
	//-->
</SCRIPT>