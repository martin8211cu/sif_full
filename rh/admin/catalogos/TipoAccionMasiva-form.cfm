<!-- Establecimiento del modo -->
<cfif isdefined("form.RHTAid")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!--- Consultas de Tipo de Acción Masiva --->
<cfif modo EQ "CAMBIO">
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.RHTAid, a.RHTid, a.RHTAcodigo, a.PCid, rtrim(a.RHTAdescripcion) as RHTAdescripcion, 
			   a.Ecodigo, a.RHTAcomportamiento, a.RHTAaplicaauto, a.RHTAcempresa, a.RHTActiponomina, 
			   a.RHTAcregimenv, a.RHTAcoficina, a.RHTAcdepto, a.RHTAcplaza, a.RHTAcpuesto, 
			   a.RHTAccomp, a.RHTAcsalariofijo, a.RHTAccatpaso, a.RHTAcjornada, a.RHTAidliquida, 
			   a.RHTAevaluacion, a.RHTAnotaminima, a.RHTAperiodos, a.RHTAfutilizap, a.RHTArespetarLT,a.RHTAanualidad,
			   b.CAMid, rtrim(b.CAMAcodigo) as CAMAcodigo, b.CAMdescripcion, 
			   case when a.RHTAcomportamiento is not null then b.CAMcempresa else 1 end as CAMcempresa, 
			   case when a.RHTAcomportamiento is not null then b.CAMctiponomina else 1 end as CAMctiponomina, 
			   case when a.RHTAcomportamiento is not null then b.CAMcregimenv else 1 end as CAMcregimenv, 
			   case when a.RHTAcomportamiento is not null then b.CAMcoficina else 1 end as CAMcoficina, 
			   case when a.RHTAcomportamiento is not null then b.CAMcdepto else 1 end as CAMcdepto, 
			   case when a.RHTAcomportamiento is not null then b.CAMcplaza else 1 end as CAMcplaza, 
			   case when a.RHTAcomportamiento is not null then b.CAMcpuesto else 1 end as CAMcpuesto, 
			   case when a.RHTAcomportamiento is not null then b.CAMccomp else 1 end as CAMccomp, 
			   case when a.RHTAcomportamiento is not null then b.CAMcsalariofijo else 1 end as CAMcsalariofijo, 
			   case when a.RHTAcomportamiento is not null then b.CAMccatpaso else 1 end as CAMccatpaso, 
			   case when a.RHTAcomportamiento is not null then b.CAMcjornada else 1 end as CAMcjornada, 
			   case when a.RHTAcomportamiento is not null then b.CAMidliquida else 1 end as CAMidliquida
		from RHTAccionMasiva a
			left outer join ComportamientoAMasiva b
				on b.CAMid = a.RHTAcomportamiento
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTAid#">
	</cfquery>
	
	<!---
	<cfquery name="rsComportamiento" datasource="#Session.DSN#">
		select RHTcomportam 
		from RHTipoAccion 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHTid#" >
	</cfquery>
	--->
	
</cfif>

<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
	select RHTid, RHTcodigo, RHTdesc 
	from RHTipoAccion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and RHTcomportam <> 1 
		and RHTcomportam <> 7
		and RHTcomportam <> 9
	order by RHTcomportam, RHTcodigo
</cfquery>

<cfif isdefined("Url.PageNum_lista")>
	<cfparam name="Form.PageNum_lista" default="#Url.PageNum_lista#">
</cfif>

<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
	function showPeriodo() {
		var a = document.getElementById("trPeriodo");
		if (document.form1.RHTAperiodos.checked) {
			if (a) a.style.display = "";
		} else {
			if (a) a.style.display = "none";
		}
	}

	function showCuestionario() {
		var a = document.getElementById("trCuestionario");
		if (document.form1.RHTAevaluacion.checked) {
			if (a) a.style.display = "";
		} else {
			if (a) a.style.display = "none";
		}
	}

	function showCompSalarial() {
		var a = document.getElementById("trCompSalarial");
		if (document.form1.RHTAccomp.checked) {
			if (a) a.style.display = "";
		} else {
			if (a) a.style.display = "none";
		}
	}
	
	<!--- Función que ejecuta el cf_conlis cuando se borra el valor seleccionado --->
	function resetRHTAcomportamiento() {
		if (document.form1.CAMAcodigo.value == '') {
			document.form1.RHTAcempresa.disabled = false;
			document.form1.RHTActiponomina.disabled = false;
			document.form1.RHTAcregimenv.disabled = false;
			document.form1.RHTAcoficina.disabled = false;
			document.form1.RHTAcdepto.disabled = false;
			document.form1.RHTAcpuesto.disabled = false;
			document.form1.RHTAccomp.disabled = false;
			document.form1.RHTAcsalariofijo.disabled = false;
			document.form1.RHTAccatpaso.disabled = false;
			document.form1.RHTAcjornada.disabled = false;
			document.form1.RHTAidliquida.disabled = false;
		}
	}
	
	function habilitarChecks() {
		// Empresa
		if (document.form1.CAMcempresa.value == '1') {
			document.form1.RHTAcempresa.disabled = false;
			document.form1.RHTAcempresa.checked = true;
		} else {
			document.form1.RHTAcempresa.checked = false;
			document.form1.RHTAcempresa.disabled = true;
		}
		// Tipo de Nomina
		if (document.form1.CAMctiponomina.value == '1') {
			document.form1.RHTActiponomina.disabled = false;
			document.form1.RHTActiponomina.checked = true;
		} else {
			document.form1.RHTActiponomina.checked = false;
			document.form1.RHTActiponomina.disabled = true;
		}
		// Regimen de Vacaciones
		if (document.form1.CAMcregimenv.value == '1') {
			document.form1.RHTAcregimenv.disabled = false;
			document.form1.RHTAcregimenv.checked = true;
		} else {
			document.form1.RHTAcregimenv.checked = false;
			document.form1.RHTAcregimenv.disabled = true;
		}
		// Oficina
		if (document.form1.CAMcoficina.value == '1') {
			document.form1.RHTAcoficina.disabled = false;
			document.form1.RHTAcoficina.checked = true;
		} else {
			document.form1.RHTAcoficina.checked = false;
			document.form1.RHTAcoficina.disabled = true;
		}
		// Departamento
		if (document.form1.CAMcdepto.value == '1') {
			document.form1.RHTAcdepto.disabled = false;
			document.form1.RHTAcdepto.checked = true;
		} else {
			document.form1.RHTAcdepto.checked = false;
			document.form1.RHTAcdepto.disabled = true;
		}
		// Puesto
		if (document.form1.CAMcpuesto.value == '1') {
			document.form1.RHTAcpuesto.disabled = false;
			document.form1.RHTAcpuesto.checked = true;
		} else {
			document.form1.RHTAcpuesto.checked = false;
			document.form1.RHTAcpuesto.disabled = true;
		}
		// Componentes Salariales
		if (document.form1.CAMccomp.value == '1') {
			document.form1.RHTAccomp.disabled = false;
			document.form1.RHTAccomp.checked = true;
		} else {
			document.form1.RHTAccomp.checked = false;
			document.form1.RHTAccomp.disabled = true;
		}
		// Porcentaje de Salario Fijo
		if (document.form1.CAMcsalariofijo.value == '1') {
			document.form1.RHTAcsalariofijo.disabled = false;
			document.form1.RHTAcsalariofijo.checked = true;
		} else {
			document.form1.RHTAcsalariofijo.checked = false;
			document.form1.RHTAcsalariofijo.disabled = true;
		}
		// Categoría / Paso
		if (document.form1.CAMccatpaso.value == '1') {
			document.form1.RHTAccatpaso.disabled = false;
			document.form1.RHTAccatpaso.checked = true;
		} else {
			document.form1.RHTAccatpaso.checked = false;
			document.form1.RHTAccatpaso.disabled = true;
		}
		// Jornada
		if (document.form1.CAMcjornada.value == '1') {
			document.form1.RHTAcjornada.disabled = false;
			document.form1.RHTAcjornada.checked = true;
		} else {
			document.form1.RHTAcjornada.checked = false;
			document.form1.RHTAcjornada.disabled = true;
		}
		// Permite Liquidaci&oacute;n
		if (document.form1.CAMidliquida.value == '1') {
			document.form1.RHTAidliquida.disabled = false;
			document.form1.RHTAidliquida.checked = true;
		} else {
			document.form1.RHTAidliquida.checked = false;
			document.form1.RHTAidliquida.disabled = true;
		}
		
	}
		
</script>

<cfoutput>
	<form name="form1" method="post" action="TipoAccionMasiva-sql.cfm" style="margin: 0;">
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="RHTAid" value="#rsForm.RHTAid#" />
		</cfif> 
		<cfif isdefined("Form.PageNum_lista")>
			<input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" />
		<cfelseif isdefined("Form.PageNum")>
			<input type="hidden" name="PageNum_lista" value="#Form.PageNum#" />
		</cfif>
		<cfif isdefined("form.fRHTAcodigo") and len(trim(form.fRHTAcodigo))>
			<input type="hidden" name="fRHTAcodigo" value="#Form.fRHTAcodigo#" />
		</cfif>
		<cfif isdefined("form.fRHTAdescripcion") and len(trim(form.fRHTAdescripcion))>
			<input type="hidden" name="fRHTAdescripcion" value="#Form.fRHTAdescripcion#" />
		</cfif>
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr> 
				<td colspan="4" align="center" class="tituloAlterno"> 
					<cfif modo EQ "CAMBIO"> 
					    <cf_translate key="LB_ModificacionDeTipoDeAccionMasiva">Modificaci&oacute;n de Tipo de Acci&oacute;n Masiva</cf_translate>
					<cfelse> 
					    <cf_translate key="LB_NuevoTipoDeAccionMasiva">Nuevo Tipo de Acci&oacute;n Masiva</cf_translate>
					</cfif> 
				</td>
			</tr>
			<tr> 
				<td align="right" width="15%" class="fileLabel">#LB_CODIGO#:</td>
				<td colspan="3">
					<input name="RHTAcodigo" type="text" value="<cfif modo EQ "CAMBIO">#trim(rsForm.RHTAcodigo)#</cfif>" size="5" maxlength="3"  > 
				</td>
			</tr>
			<tr> 
				<td align="right" class="fileLabel">#LB_DESCRIPCION#:</td>
				<td colspan="3"> 
					<input name="RHTAdescripcion" type="text" value="<cfif modo EQ "CAMBIO">#rsForm.RHTAdescripcion#</cfif>" maxlength="80" size="60" >
				</td>
			</tr>
			<tr>
				<td align="right" class="fileLabel"><cf_translate key="LB_TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
				<td colspan="3">
					<select name="RHTid">
						<cfloop query="rsTipoAccion">
							<option value="#rsTipoAccion.RHTid#" onChange="javascript:showAutomatico();" <cfif modo EQ "CAMBIO" and isdefined('rsForm') and rsForm.RHTid EQ rsTipoAccion.RHTid> selected</cfif>>#rsTipoAccion.RHTcodigo# - #rsTipoAccion.RHTdesc#</option>
						</cfloop>
					</select>
				</td>
			</tr> 
			<tr> 
				<td align="right" class="fileLabel"><cf_translate key="LB_Comportamiento">Comportamiento</cf_translate>:</td>
				<td colspan="3">
					<cfset valuesArray = ArrayNew(1)>
					<cfif modo EQ "CAMBIO">
						<cfset ArrayAppend(valuesArray, rsForm.RHTAcomportamiento)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMAcodigo)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMdescripcion)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcempresa)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMctiponomina)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcregimenv)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcoficina)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcdepto)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcplaza)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcpuesto)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMccomp)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcsalariofijo)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMccatpaso)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMcjornada)>
						<cfset ArrayAppend(valuesArray, rsForm.CAMidliquida)>
					</cfif>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Comportamientos"
					Default="Comportamientos"
					returnvariable="LB_Comportamientos"/>
					
					<cf_conlis title="#LB_Comportamientos#"
						campos = "RHTAcomportamiento, CAMAcodigo, CAMdescripcion, CAMcempresa, CAMctiponomina, CAMcregimenv, CAMcoficina, CAMcdepto, CAMcplaza, CAMcpuesto, CAMccomp, CAMcsalariofijo, CAMccatpaso, CAMcjornada, CAMidliquida" 
						desplegables = "N,S,S,N,N,N,N,N,N,N,N,N,N,N,N" 
						modificables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N" 
						valuesArray="#valuesArray#" 
						size = "0,10,30,0,0,0,0,0,0,0,0,0,0,0,0"
						tabla="ComportamientoAMasiva a"
						columnas="a.CAMid as RHTAcomportamiento, rtrim(a.CAMAcodigo) as CAMAcodigo, a.CAMdescripcion, a.CAMcempresa, a.CAMctiponomina, a.CAMcregimenv, a.CAMcoficina, a.CAMcdepto, a.CAMcplaza, a.CAMcpuesto, a.CAMccomp, a.CAMcsalariofijo, a.CAMccatpaso, a.CAMcjornada, a.CAMidliquida"
						filtro="1=1 order by CAMAcodigo"
						desplegar="CAMAcodigo, CAMdescripcion"
						filtrar_por="a.CAMAcodigo, a.CAMdescripcion"
						etiquetas="#LB_CODIGO#, #LB_DESCRIPCION#"
						formatos="S,S"
						align="left,left"
						asignar="RHTAcomportamiento, CAMAcodigo, CAMdescripcion, CAMcempresa, CAMctiponomina, CAMcregimenv, CAMcoficina, CAMcdepto, CAMcplaza, CAMcpuesto, CAMccomp, CAMcsalariofijo, CAMccatpaso, CAMcjornada, CAMidliquida"
						asignarformatos="S,S,S,S,S,S,S,S,S,S,S,S,S,S,S"
						showEmptyListMsg="true"
						funcion="habilitarChecks"
						debug="false">
				</td>
			</tr>
			<tr>
				<td colspan="4"><cfinclude template="TipoAccionMasiva-permiteModificar.cfm"></td>
			</tr>
			<tr>
				<!---
				<cfif modo EQ "CAMBIO" and rsComportamiento.RHTcomportam EQ 8>
					<td align="right"><input name="RHTAaplicaauto" type="checkbox" checked disabled ></td>
				<cfelse>
					<td align="right"><input name="RHTAaplicaauto" type="checkbox"<cfif modo EQ "CAMBIO" and rsForm.RHTAaplicaauto EQ 1> checked</cfif>></td>
				</cfif> 
				--->
				<td align="right"><input name="RHTAaplicaauto" type="checkbox"<cfif modo EQ "CAMBIO" and rsForm.RHTAaplicaauto EQ 1> checked</cfif>></td>
				<td><cf_translate key="CHK_AplicacionAutomatica">Aplicaci&oacute;n Autom&aacute;tica</cf_translate></td>
				<td align="right"><input name="RHTAidliquida" type="checkbox"<cfif modo EQ "CAMBIO" and rsForm.RHTAidliquida EQ 1> checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMidliquida eq 0>disabled</cfif>></td>
				<td><cf_translate key="CHK_PermiteLiquidacion">Permite Liquidaci&oacute;n</cf_translate></td>
			</tr>
			<tr>
				<td nowrap align="right"><input name="RHTAperiodos" type="checkbox" onclick="javascript: showPeriodo();"<cfif modo EQ "CAMBIO" and rsForm.RHTAperiodos EQ 1> checked</cfif>></td>
				<td><cf_translate key="CHK_TrabajarConPeriodo">Trabajar con Periodo</cf_translate></td>
				<td align="right"><input name="RHTArespetarLT" type="checkbox" <cfif modo EQ "CAMBIO" and rsForm.RHTArespetarLT EQ 1> checked</cfif> ></td>
				<td><cf_translate key="CHK_RespetarCortesEnLineaDelTiempo">Respetar Cortes en L&iacute;nea del Tiempo</cf_translate></td>
			</tr>
			<tr id="trPeriodo" style="display: none;">
				<td colspan="4"><cfinclude template="TipoAccionMasiva-periodos.cfm"></td>
			</tr>
			<tr>
				<td nowrap align="right"><input name="RHTAevaluacion" type="checkbox" onclick="javascript: showCuestionario(); validarTabla();"<cfif modo EQ "CAMBIO" and rsForm.RHTAevaluacion EQ 1> checked</cfif>></td>
				<td ><cf_translate key="CHK_UsarTablaDeEvaluacion">Usar Tabla de Evaluaci&oacute;n</cf_translate></td>
				<td align="right"><input name="RHTAanualidad" type="checkbox" <cfif modo EQ "CAMBIO" and rsForm.RHTAanualidad EQ 1> checked</cfif>></td>
				<td><cf_translate key="CHK_EsAnualidad">Es anualidad</cf_translate></td>
			</tr>
			<tr id="trCuestionario" style="display: none;">
				<td colspan="4"><cfinclude template="TipoAccionMasiva-tablaEvalua.cfm"></td>
			</tr>
			<cfif modo EQ "CAMBIO">
				<tr id="trCompSalarial" style="display: none;"> 
					<td colspan="4"><cfinclude template="TipoAccionMasiva-comptSalarial.cfm"></td>
				</tr>
			</cfif>	
			<tr>
				<td colspan="4" align="center"><cf_botones modo="#modo#"></td>
			</tr>
			<tr>
				<td colspan="4" align="center">&nbsp;</td>
			</tr>
		</table>
	</form>
</cfoutput>

<cf_qforms>	
<script language="javascript" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	returnvariable="MSG_Codigo"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	returnvariable="MSG_Descripcion"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipodeAccion"
	Default="Tipo de Acción"
	returnvariable="MSG_TipodeAccion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Cuestionario"
	Default="Cuestionario"
	returnvariable="MSG_Cuestionario"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NotaMinima"
	Default="Nota Mínima"
	returnvariable="MSG_NotaMinima"/>	

	objForm.RHTAcodigo.required = true;
	objForm.RHTAcodigo.description = "<cfoutput>#MSG_Codigo#</cfoutput>";
	
	objForm.RHTAdescripcion.required = true;
	objForm.RHTAdescripcion.description = "<cfoutput>#MSG_Descripcion#</cfoutput>";

	objForm.RHTid.required = true;
	objForm.RHTid.description = "<cfoutput>#MSG_TipodeAccion#</cfoutput>";

	function validarTabla() {
		if (document.form1.RHTAevaluacion.checked){
			objForm.PCid.required = true;
			objForm.PCid.description = "<cfoutput>#MSG_Cuestionario#</cfoutput>";
			objForm.RHTAnotaminima.required = true;
			objForm.RHTAnotaminima.description = "<cfoutput>#MSG_NotaMinima#</cfoutput>";
		} else {
			objForm.PCid.required = false;
			objForm.RHTAnotaminima.required = false;
		}
	}

	showPeriodo();
	showCuestionario();
	showCompSalarial();
	
</script>
