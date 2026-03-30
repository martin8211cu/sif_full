<cfset LvarTitulo = "Reporte de Obras Retrasadas no liquidadas">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<form name="form_filtro" method="post" action="noLiquidadas_imprimir.cfm">
		<table width="100%" align="center">
			<tr>
				<td><strong>Tipo de Proyectos:</strong></td>
				<td colspan="2">
					<cf_conlis
						Campos="OBTPid, OBTPcodigo, OBTPdescripcion, MaxNivel"
						Desplegables="N,S,S,N"
						Modificables="N,S,N,N"
						Size="0,10,40"
	
						Title="Lista de Tipo de Proyectos"
						Tabla="OBtipoProyecto"
						Filtro="Ecodigo = #session.Ecodigo#"
						Columnas="OBTPid, OBTPcodigo, OBTPdescripcion, Cmayor
								, (
									select count(PCNid) 
									  from PCNivelMascara n
									 where n.PCEMid= OBtipoProyecto.PCEMid
									   and n.PCNcontabilidad = 1
								   ) as MaxNivel
						"
						Desplegar="OBTPcodigo, OBTPdescripcion, Cmayor"
						Etiquetas="Codigo,Descripción, Cta.Mayor"
						filtrar_por="OBTPcodigo, OBTPdescripcion, Cmayor"
						Formatos="S,S,S"
						Align="left,left.left"
	
						Asignar="OBTPid, OBTPcodigo, OBTPdescripcion, Cmayor, Cformato1=Cmayor, MaxNivel, Cnivel=MaxNivel"
						Asignarformatos="S,S,S"
						MaxRowsQuery="200"
						form="form_filtro"
					/>										
				</td>
			</tr>
			<tr>
				<td><strong>Cuenta Mayor:</strong></td>
				<td nowrap>
					<cf_inputNumber	name="Cmayor" 
								value=""
								enteros="4" decimales="0"
								modificable="false"
								style="border:none;text-align:left;"
					>
				</td>
			</tr>
			<tr>
				<td><strong>Oficina:</strong></td>
				<td colspan="2">
					<cf_conlis
						Campos="Ocodigo, Oficodigo, Odescripcion"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
	
						Title="Lista de Oficinas"
						Tabla="Oficinas ofi"
						Columnas="Ocodigo, Oficodigo, Odescripcion"
						Filtro="Ecodigo = #session.Ecodigo#"
						Desplegar="Oficodigo, Odescripcion"
						Etiquetas="Codigo,Descripción"
						filtrar_por="Oficodigo, Odescripcion"
						Formatos="S,S"
						Align="left,left"
	
						Asignar="Ocodigo, Oficodigo, Odescripcion"
						Asignarformatos="S,S,S"
						MaxRowsQuery="200"
						form="form_filtro"
					/>										
				</td>
			</tr>
			<tr>
				<td><strong>Fecha final estimada:</strong></td>
				<td>
					<cfinclude template="../Componentes/functionsPeriodo.cfm">
					<cfset LvarPeriodos = fnPeriodoContable ()>
					del mes
					<cfquery name="rsPeriodos" datasource="#session.DSN#">
						select min(Speriodo) as ini, max(Speriodo) as fin
						  from SaldosContables
						 where Ecodigo = #session.Ecodigo#
					</cfquery>
					<select name="Speriodo1">
						<cfif rsPeriodos.recordcount GT 0 and LEN(TRIM(rsPeriodos.ini)) and LEN(TRIM(rsPeriodos.fin))>
							<cfloop index="LvarPer" from="#rsPeriodos.fin#" to="#rsPeriodos.ini#" step="-1">
								<cfoutput>
									<option value="#LvarPer#" <cfif LvarPeriodos.ActualIni.Ano EQ LvarPer>selected</cfif>>#LvarPer#</option>
								</cfoutput>
							</cfloop>
						</cfif>
					</select>
					<select name="Smes1">
						<option value="1"  <cfif LvarPeriodos.ActualIni.Mes EQ 1>selected</cfif>>Enero</option>
						<option value="2"  <cfif LvarPeriodos.ActualIni.Mes EQ 2>selected</cfif>>Febrero</option>
						<option value="3"  <cfif LvarPeriodos.ActualIni.Mes EQ 3>selected</cfif>>Marzo</option>
						<option value="4"  <cfif LvarPeriodos.ActualIni.Mes EQ 4>selected</cfif>>Abril</option>
						<option value="5"  <cfif LvarPeriodos.ActualIni.Mes EQ 5>selected</cfif>>Mayo</option>
						<option value="6"  <cfif LvarPeriodos.ActualIni.Mes EQ 6>selected</cfif>>Junio</option>
						<option value="7"  <cfif LvarPeriodos.ActualIni.Mes EQ 7>selected</cfif>>Julio</option>
						<option value="8"  <cfif LvarPeriodos.ActualIni.Mes EQ 8>selected</cfif>>Agosto</option>
						<option value="9"  <cfif LvarPeriodos.ActualIni.Mes EQ 9>selected</cfif>>Setiembre</option>
						<option value="10" <cfif LvarPeriodos.ActualIni.Mes EQ 10>selected</cfif>>Octubre</option>
						<option value="11" <cfif LvarPeriodos.ActualIni.Mes EQ 11>selected</cfif>>Noviembre</option>
						<option value="12" <cfif LvarPeriodos.ActualIni.Mes EQ 12>selected</cfif>>Diciembre</option>
					</select>
					&nbsp;al mes&nbsp;
					<cfquery name="rsPeriodos" datasource="#session.DSN#">
						select min(Speriodo) as ini, max(Speriodo) as fin
						  from SaldosContables
						 where Ecodigo = #session.Ecodigo#
					</cfquery>
					<select name="Speriodo2">
						<cfif rsPeriodos.recordcount GT 0 and LEN(TRIM(rsPeriodos.ini)) and LEN(TRIM(rsPeriodos.fin))>
							<cfloop index="LvarPer" from="#rsPeriodos.fin#" to="#rsPeriodos.ini#" step="-1">
								<cfoutput>
									<option value="#LvarPer#" <cfif LvarPeriodos.ActualFin.Ano EQ LvarPer>selected</cfif>>#LvarPer#</option>
								</cfoutput>
							</cfloop>
						</cfif>
					</select>
					<select name="Smes2">
						<option value="1"  <cfif LvarPeriodos.ActualFin.Mes EQ 1>selected</cfif>>Enero</option>
						<option value="2"  <cfif LvarPeriodos.ActualFin.Mes EQ 2>selected</cfif>>Febrero</option>
						<option value="3"  <cfif LvarPeriodos.ActualFin.Mes EQ 3>selected</cfif>>Marzo</option>
						<option value="4"  <cfif LvarPeriodos.ActualFin.Mes EQ 4>selected</cfif>>Abril</option>
						<option value="5"  <cfif LvarPeriodos.ActualFin.Mes EQ 5>selected</cfif>>Mayo</option>
						<option value="6"  <cfif LvarPeriodos.ActualFin.Mes EQ 6>selected</cfif>>Junio</option>
						<option value="7"  <cfif LvarPeriodos.ActualFin.Mes EQ 7>selected</cfif>>Julio</option>
						<option value="8"  <cfif LvarPeriodos.ActualFin.Mes EQ 8>selected</cfif>>Agosto</option>
						<option value="9"  <cfif LvarPeriodos.ActualFin.Mes EQ 9>selected</cfif>>Setiembre</option>
						<option value="10" <cfif LvarPeriodos.ActualFin.Mes EQ 10>selected</cfif>>Octubre</option>
						<option value="11" <cfif LvarPeriodos.ActualFin.Mes EQ 11>selected</cfif>>Noviembre</option>
						<option value="12" <cfif LvarPeriodos.ActualFin.Mes EQ 12>selected</cfif>>Diciembre</option>
					</select>
				</td>
			</tr>

			<tr>
				<td><strong>Nivel de detalle de Cuenta Contable:</strong></td>
				<td nowrap>
					<cf_inputNumber	name="Cnivel" 
								value="0"
								enteros="4" decimales="0"
					>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="btnImprimir" value="Imprimir" class="btnNormal" title="Generar el Reporte en la pantalla con Cortes de Página"	onClick="this.form.btnName.value = this.name;">
 					<input type="submit" name="btnDownload" value="Download" class="btnNormal" title="Generar el Reporte en Excel sin Cortes de Página"  		onClick="this.form.btnName.value = this.name; setTimeout ('fnHabilitarSubmit()', 5000);">
					<input type="hidden" name="btnName"		value="">
				</td>
			</tr>
		</table>
	</form>
	
	<script language="javascript">
		function fnCformato1()
		{
			if (document.form_filtro.Cformato1.value.substring(0,4) != document.form_filtro.Cmayor.value)
				this.error = "El formato de la Cuenta no pertenece a la cuenta mayor";
			if ((document.form_filtro.Cformato2.value != "") && (document.form_filtro.Cformato2.value.substring(0,4) != document.form_filtro.Cmayor.value))
				this.error = "El formato de la Cuenta Hasta no pertenece a la cuenta mayor";
		}

		function fnCnivel()
		{
			var LvarMaxNivel = LvarQForm.MaxNivel.getValue();

			if (parseInt(this.value) > parseInt(LvarMaxNivel))
				this.error = "La Cuenta Contable sólo tiene " + LvarMaxNivel + " niveles";
		}

		function fnHabilitarSubmit()
		{
			LvarQForm._status = null;
			document.form_filtro.btnImprimir.disabled = false;
			document.form_filtro.btnDownload.disabled = false;
		}

		function fnDeshabilitarSubmit()
		{
			document.form_filtro.btnImprimir.disabled = true;
			document.form_filtro.btnDownload.disabled = true;
		}
	</script>
	<cf_qforms form="form_filtro" objForm="LvarQForm" onsubmit="fnDeshabilitarSubmit">
		<cf_qformsRequiredField args="OBTPid, Tipo Proyectos">
		<cf_qformsRequiredField args="Cnivel,Nivel de Cuenta,fnCnivel">
		<cf_qformsRequiredField args="Speriodo1,Periodo Inicial">
		<cf_qformsRequiredField args="Speriodo2,Periodo Final">
	</cf_qforms>
	<cf_web_portlet_end>
<cf_templatefooter>
