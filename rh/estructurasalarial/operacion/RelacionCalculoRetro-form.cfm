<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_No_quedan_calendarios_de_pago_para_el_tipo_de_Nomina_seleccionado" Default="No quedan calendarios de pago para el tipo de Nómina seleccionado"	 returnvariable="LB_No_quedan_calendarios_de_pago_para_el_tipo_de_Nomina_seleccionado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_No_puede_ser_cero" Default=" no puede ser cero" returnvariable="LB_No_puede_ser_cero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripción"returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TipodeNomina" Default="Tipo de Nómina" returnvariable="LB_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton de Calcular ---->
<cfinvoke Key="BTN_Calcular" Default="Calcular" returnvariable="BTN_Calcular" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- Consultas --->
<!--- 1.Tipos de Nómina --->
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
		and b.CPtipo = 3
	)
	order by a.Tdescripcion
</cfquery>

<!--- 1.Calendarios --->
<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
	select 
		a.CPcodigo, 
		a.CPid, 
		rtrim(a.Tcodigo) as Tcodigo, 
		a.CPdesde, 
		a.CPhasta,
		case when a.CPtipo = 0 then 'Normal'
			when a.CPtipo = 2 then 'Anticipo'
			when a.CPtipo = 3 then 'Retroactivo' end as TipoCalendario,
		a.CPdescripcion as RCDescripcion
	from CalendarioPagos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.CPfenvio is null
	and a.CPtipo = 3
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
	order by CPhasta
</cfquery>

<cfquery name="MinFechasNomina" dbtype="query">
	select Tcodigo, min(CPhasta) as CPhasta
	from PaySchedAfterRestrict
	group by Tcodigo
</cfquery>



	
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");

	// loads all default libraries
	qFormAPI.include("*");

	var calCPcodgo = new Object();
	var calRCdesde = new Object();
	var calRChasta = new Object();
	var calTipoCal = new Object();
	var calDescCal = new Object();
	var calRCid = new Object();		
	
	<cfoutput>
		<cfloop query="MinFechasNomina">
			<cfquery name="rsCalendarios" dbtype="query">
				select *
				from PaySchedAfterRestrict
				where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MinFechasNomina.Tcodigo#">
				and CPhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#MinFechasNomina.CPhasta#">
				order by CPhasta
			</cfquery>
			
			calCPcodgo['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.CPcodigo#';
			calRCdesde['#rsCalendarios.Tcodigo#'] = '#LSDateFormat(rsCalendarios.CPdesde, 'DD/MM/YYYY')#';
			calRChasta['#rsCalendarios.Tcodigo#'] = '#LSDateFormat(rsCalendarios.CPhasta, 'DD/MM/YYYY')#';
			calTipoCal['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.TipoCalendario#';
			calDescCal['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.RCDescripcion#';
			calRCid['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.CPid#';
		</cfloop>
	</cfoutput>
	function changeCalculo(){
		changeCal(document.form1.Tcodigo);
	}
	function changeCal(ctl) {
		var name = ctl.value;
		if (calRCdesde[name] && calRChasta[name]) {
			ctl.form.CPcodigo.value = calCPcodgo[name];
			ctl.form.RCdesde.value = calRCdesde[name];
			ctl.form.RChasta.value = calRChasta[name];
			ctl.form.TipoCalendario.value = calTipoCal[name];
			ctl.form.RCDescripcion.value = calDescCal[name];
			ctl.form.RCNid.value = calRCid[name];
		} else {
			ctl.form.CPcodigo.value = '';
			ctl.form.RCdesde.value = '';
			ctl.form.RChasta.value = '';
			ctl.form.TipoCalendario.value = '';
			ctl.form.RCDescripcion.value = '';
			ctl.form.RCNid.value = '';
			<cfoutput>alert('#LB_No_quedan_calendarios_de_pago_para_el_tipo_de_Nomina_seleccionado#')</cfoutput>;
		}
	}


</SCRIPT>

<cfoutput>
<form name="form1" method="post" action="RelacionCalculoRetro-sql.cfm">
	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr> 
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Nomina">Tipo de nomina:</cf_translate></td>
			<td nowrap> 
				<!--- Tipos de Nómina --->
				<cf_rhtiponominaCombo index="0" onchange="changeCalculo" combo="True" todas="False">
			</td>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Desde">Fecha Desde:</cf_translate></td>
			<td nowrap> 
				<input tabindex="1" type="text" name="RCdesde" id="RCdesde" value="" 
						size="15" maxlength="10" readonly=""> 
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_CodigoCalendarioDePago" xmlFile="/rh/estructurasalarial/operacion/RelacionCalculoRetro-lista.xml">C&oacute;digo Calendario de Pago:</cf_translate></td>
			<td nowrap>
				<input tabindex="1" type="text" name="CPcodigo" id="CPcodigo2" value="" 
						size="20" maxlength="11" readonly=""> 
			</td>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta:</cf_translate></td>
			<td nowrap>
				<input tabindex="1" type="text" name="RChasta" id="RChasta" value="" size="15" maxlength="10" readonly=""> 
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_TipodeCalendarioDePago">Tipo de Calendario de Pago</cf_translate>:</td>
			<td nowrap colspan="3"><input tabindex="1" name="TipoCalendario" type="text" id="TipoCalenario" size="20" readonly></td>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
			<td nowrap>&nbsp;</td>
		</tr>
		<tr> 
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Descripcion">Descripci&oacute;n:</cf_translate></td>
			<td nowrap colspan="3"><input tabindex="1" name="RCDescripcion" type="text" id="RCDescripcion2" size="90" maxlength="80"></td>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
			<td nowrap>&nbsp;</td>
		</tr>
		<tr> 
			<td height="28" colspan="6" align="center">  
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"> 
				<cfoutput> 
					<input tabindex="1" type="submit" name="btnAplicar" value="#BTN_Calcular#" >
				</cfoutput> </td>
		</tr>
	</table>
	<input type="hidden" name="RCNid" value="">
</form>
</cfoutput>

<SCRIPT LANGUAGE="JavaScript">
	// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
	function __isNotCero() {
		if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.error = this.description + <cfoutput>"#LB_No_puede_ser_cero#"</cfoutput>;
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isNotCero", __isNotCero);
	<cfoutput>
		objForm.RCDescripcion.required = true;
		objForm.RCDescripcion.description = "#LB_Descripcion#";
	
		objForm.Tcodigo.required = true;
		objForm.Tcodigo.description = "#LB_TipodeNomina#";
		objForm.RCdesde.required = true;
		objForm.RCdesde.description = "#LB_FechaDesde#";
		objForm.RChasta.required = true;
		objForm.RChasta.description = "#LB_FechaHasta#";
	</cfoutput>
	changeCal(document.form1.Tcodigo);
</SCRIPT>