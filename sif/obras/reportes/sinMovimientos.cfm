<cfset LvarInactivas = isdefined("LvarInactivas")>
<cfif LvarInactivas>
	<!--- Obras Abiertas que dejaron de tener movimientos --->
	<cfset LvarTitulo = "Reporte de Obras Abiertas que dejaron de tener Movimientos">
	<cfset LvarAction = "noMovimientos_imprimir.cfm">
<cfelse>
	<!--- Obras Abiertas que no nunca han tenido movimientos --->
	<cfset LvarTitulo = "Reporte de Obras Abiertas que nunca han tenido Movimientos">
	<cfset LvarAction = "sinMovimientos_imprimir.cfm">
</cfif>

<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<form name="form_filtro" method="post" action="<cfoutput>#LvarAction#</cfoutput>">
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
				<td><strong>Periodo de Apertura:</strong></td>
				<td>
					<cfinclude template="../Componentes/functionsPeriodo.cfm">
					<cfset LvarPeriodos = fnPeriodoContable ()>
					<cfset LvarMes = fnNombreMes(LvarPeriodos.ActualIni.Mes)>
					<cfquery name="rsPeriodos" datasource="#session.DSN#">
						select min(Speriodo) as ini, max(Speriodo) as fin
						  from SaldosContables
						 where Ecodigo = #session.Ecodigo#
					</cfquery>
					<select name="Speriodo">
						<cfif rsPeriodos.recordcount GT 0 and LEN(TRIM(rsPeriodos.ini)) and LEN(TRIM(rsPeriodos.fin))>
							<option value="" selected>(Todas las obras abiertas)</option>
								<cfloop index="LvarPer" from="#rsPeriodos.fin#" to="#rsPeriodos.ini#" step="-1">
									<cfif LvarPer*100+LvarPeriodos.ActualIni.Mes LTE LvarPeriodos.Actual.AnoMes>
										<cfoutput>
										<option value="#LvarPer#">#LvarPer# - #LvarMes#</option>
										</cfoutput>
									</cfif>
								</cfloop>
						</cfif>
					</select>
					<input type="hidden" name="Smes" value="<cfoutput>#LvarPeriodos.ActualIni.Mes#</cfoutput>" />
				</td>
			</tr>
			<tr>
			<cfif LvarInactivas>
				<td><strong>Meses inactivos (sin movimientos):</strong></td>
			<cfelse>
				<td><strong>Meses de apertura sin movimientos:</strong></td>
			</cfif>
				<td>
					<cf_inputNumber	name="Cmeses" 
								value="1"
								enteros="4" decimales="0"
					>
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

		<cfif LvarInactivas>
			<tr>
				<td></td>
				<td nowrap>
					<input type="checkbox" value="1" name="chkIncluirSin" />
					Incluir Obras que nunca han tenido movimiento
				</td>
			</tr>
		</cfif>
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
		function fnCmeses()
		{
			if (parseInt(this.value) == 0)
				this.error = "El Campo Meses sin movimiento debe ser mayor que cero";
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
		<cf_qformsRequiredField args="OBTPcodigo, Tipo Proyectos">
		<cf_qformsRequiredField args="Cmeses,Meses sin Movimientos,fnCmeses">
		<cf_qformsRequiredField args="Cnivel,Nivel de Cuenta,fnCnivel">
		<cf_qformsRequiredField args="Speriodo,Periodo de Apertura">
	</cf_qforms>
	<cf_web_portlet_end>
<cf_templatefooter>
