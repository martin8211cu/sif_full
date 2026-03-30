<cfoutput>

	<cfparam name="url.esMetric" default="M">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Filtros de C&aacute;lculo'>
		<cfparam name="url.MIGMid" default="">
		<cfif isdefined('url.MIGMid') and len(trim(url.MIGMid))>

			<cfquery datasource="#session.DSN#" name="rsPerteneceA"><!--- Localiza si para F_resultados ya existia el resultado --->
				Select MIGMdetalleid from MIGFiltrosmetricas
				where
					MIGMid = #url.MIGMid#
					and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfquery datasource="#session.DSN#" name="rsMetricas"><!--- Localiza si para F_resultados ya existia el resultado --->
				Select MIGMesmetrica,MIGMperiodicidad from MIGMetricas
				where
					MIGMid = #url.MIGMid#
					and Ecodigo = #session.Ecodigo#
			</cfquery>

			<cfquery datasource="#session.DSN#" name="rsFiltros"><!--- Localiza si para F_resultados ya existia el resultado --->
				Select MIGMdetalleid from MIGFiltrosderivadas
				where
					MIGMidderivada = #url.MIGMid#
					and Ecodigo = #session.Ecodigo#
			</cfquery>

			<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
			<cfquery datasource="#Session.DSN#" name="rsPeriodos">
					select
						  distinct a.Periodo,
						   a.Pfecha,
						   case a.Periodo_Tipo
								when 'D' then 'Diaria'
								when 'W' then 'Semana'
								when 'M' then 'Mensual'
								when 'T' then 'Trimestral'
								when 'A' then 'Anual'
								when 'S' then 'Semestral'
								else ''end  as perioci
					from F_Datos a
					where
						  a.Ecodigo = #Session.Ecodigo#
						  and a.Periodo_Tipo = '#rsMetricas.MIGMperiodicidad#'
						  <cfif url.esMetric NEQ  'I' and rsFiltros.recordCount EQ 0> <!---si no es indicador y si no es metrica derivada--->
							and  a.MIGMid=#url.MIGMid#
						  </cfif>
						   and a.Pfecha = (
						  	 select Max(b.Pfecha)
								from F_Datos b
								where
									  b.Ecodigo =  a.Ecodigo
									  and b.Periodo_Tipo = a.Periodo_Tipo
									  and b.Periodo = a.Periodo
									   <cfif url.esMetric NEQ  'I' and rsFiltros.recordCount EQ 0> <!---si no es indicador y si no es metrica derivada--->
										and  b.MIGMid=a.MIGMid
									  </cfif>
						  )
					order by
						   a.Periodo, a.Pfecha,perioci
			</cfquery>

			<!---ESTE FILTRO ES POR SI QUIEREN VOLVER A ACTIVAR LOS CONLIS--->
			<!---<cfset filtro = "a.Ecodigo=#Session.Ecodigo#">
			<cfif rsMetricas.MIGMesmetrica NEQ  'I'>
				<cfset filtro = filtro & " and  a.MIGMid=#url.MIGMid#">
			</cfif>
			<cfset filtro = filtro & " order by a.periodo,perioci">
			--->

			<cfif rsPeriodos.recordCount EQ 0>
				<cfquery datasource="#Session.DSN#" name="rsPeriodos">
						select
						  distinct a.Periodo,
						   a.Pfecha,
						   case a.Periodo_Tipo
								when 'D' then 'Diaria'
								when 'W' then 'Semana'
								when 'M' then 'Mensual'
								when 'T' then 'Trimestral'
								when 'A' then 'Anual'
								when 'S' then 'Semestral'
								else ''end  as perioci
					from F_Datos a
					where
						  a.Ecodigo = #Session.Ecodigo#
						  and a.Periodo_Tipo = '#rsMetricas.MIGMperiodicidad#'
						  and a.Pfecha = (
						  	 select Max(b.Pfecha)
								from F_Datos b
								where
									  b.Ecodigo =  a.Ecodigo
									  and b.Periodo_Tipo = a.Periodo_Tipo
									  and b.Periodo = a.Periodo
						  )
					order by
						   a.Periodo, a.Pfecha,perioci
				</cfquery>

			</cfif>

			<cfif rsPeriodos.recordCount GT 0 >
						<form name="formCalculo" action="CalcularSQL.cfm" method="post" onsubmit="return validar();">
						<input type="hidden" name="MODO" id="MODO" value="CAMBIO">
						<input type="hidden" name="MIGMid" id="MIGMid" value="#url.MIGMid#">
						<input type="hidden" name="esMetric" id="esMetric" value="#url.esMetric#">
						<table cellpadding="2" cellspacing="2" border="0"  width="100%">
						<tr>
							<td nowrap="nowrap"><input name="tipoFiltro" id="tipoFiltro1" type="radio" value="1"/>
							<strong><label for="tipoFiltro1">Por periodo actual</label></strong></td>
						</tr>
						<tr>
							<td><input name="tipoFiltro" id="tipoFiltro2" type="radio" value="2" checked="checked"/>
								<strong><label for="tipoFiltro2">Por periodo:</label></strong>
							</td><td>


								<!---<cf_conlis title="Lista de periodos"
								tabla="F_Datos a"
								columnas=" distinct a.periodo as periodo,
										(select case b.MIGMperiodicidad
												when 'D' then '*'
												when 'W' then 'Semana'
												when 'M' then 'Mes'
												when 'T' then 'Trimestre'
												when 'A' then 'A'
												when 'S' then 'Semestre'
												else ''
											end as periocidad
											from MIGMetricas b
											where b.MIGMid=a.MIGMid and b.Ecodigo = #session.Ecodigo#)as perioci"
								campos = "periodo,perioci"
								desplegables = "S,S"
								modificables = "S,S"
								filtro="#filtro#"
								desplegar="periodo,perioci"
								etiquetas="periodo,perioci"
								formatos="S,S"
								align="left"
								traerInicial="false"
								traerFiltro=""
								filtrar_por="periodo,perioci"
								tabindex="1"
								size="10"
								form="formCalculo"
								fparams="periodo,perioci"/>--->




								<select name="periodo" id="periodo">
								<cfloop query="rsPeriodos">
								<option value="#rsPeriodos.periodo#">
									<cfif rsPeriodos.perioci EQ 'Diaria'>
										#DateFormat(rsPeriodos.pfecha,'DD/MM/YYYY')# (#rsPeriodos.perioci#)
									<cfelseif rsPeriodos.perioci EQ 'Anual'>
										#rsPeriodos.periodo# (#rsPeriodos.perioci#)
									<cfelse>
										#left(rsPeriodos.periodo,4)#-#mid(rsPeriodos.periodo,5,10)# (#rsPeriodos.perioci#)
									</cfif><!---#LSDateFormat(rsPeriodos.pfecha)# (#rsPeriodos.perioci#)---></option>
								</cfloop>
							</select>
						</td>
						</tr>
						<tr>
							<td>
							<input name="tipoFiltro" id="tipoFiltro3" type="radio" value="3"/>
							<strong><label for="tipoFiltro3">Por rango:</label></strong> </td>
						<!---</tr>
						<tr>--->
							<td valign="baseline"><table cellpadding="2" cellspacing="2" border="0">
								<tr><td>Inicio </td><td>Fin </td></tr>
								<tr><td>
									<!---<cf_conlis title="Lista de Departamentos"
										tabla="F_Datos a"
										columnas=" distinct a.periodo as pinicio, (select max(b.pfecha)from F_Datos b
																	where b.MIGMid=a.MIGMid
																	and a.periodo = b.periodo

																)as pfecha,
																(select case b.MIGMperiodicidad
																		when 'D' then 'Diario'
																		when 'W' then 'Semanal'
																		when 'M' then 'Mensual'
																		when 'T' then 'Trimestral'
																		when 'A' then 'Anual'
																		when 'S' then 'Semestre'
																		else ''
																	end as periocidad
																	from MIGMetricas b
																	where b.MIGMid=a.MIGMid)as perioci"
										campos = "pinicio,pfecha,perioci"
										desplegables = "S,N,N"
										modificables = "S,N,N"
										filtro="#filtro#"
										desplegar="pinicio,perioci"
										etiquetas="pinicio,perioci"
										formatos="S,S"
										align="left,left,left"
										traerInicial="false"
										traerFiltro=""
										filtrar_por="pinicio,pfecha,perioci"
										tabindex="1"
										size="10,10,8"
										form="formCalculo"
										fparams="pinicio"/>--->

									<select name="pinicio" id="pinicio">
										<cfloop query="rsPeriodos">
										<option value="#rsPeriodos.periodo#">
										<cfif rsPeriodos.perioci EQ 'Diaria'>
											#DateFormat(rsPeriodos.pfecha,'DD/MM/YYYY')# (#rsPeriodos.perioci#)
										<cfelseif rsPeriodos.perioci EQ 'Anual'>
											#rsPeriodos.periodo# (#rsPeriodos.perioci#)
										<cfelse>
											#left(rsPeriodos.periodo,4)#-#mid(rsPeriodos.periodo,5,10)# (#rsPeriodos.perioci#)
										</cfif>
										</option>
										</cfloop>
									</select>
								</td><td>

								<!---<cf_conlis title="Lista de Departamentos"
										tabla="F_Datos a"
										columnas=" distinct a.periodo as pfin, (select max(b.pfecha)from F_Datos b
																	where b.MIGMid=a.MIGMid
																	and a.periodo = b.periodo

																)as pfecha,
																(select case b.MIGMperiodicidad
																		when 'D' then 'Diario'
																		when 'W' then 'Semanal'
																		when 'M' then 'Mensual'
																		when 'T' then 'Trimestral'
																		when 'A' then 'Anual'
																		when 'S' then 'Semestre'
																		else ''
																	end as periocidad
																	from MIGMetricas b
																	where b.MIGMid=a.MIGMid)as perioci"
										campos = "pfin,pfecha,perioci"
										desplegables = "S,N,N"
										modificables = "S,N,N"
										filtro="#filtro#"
										desplegar="pfin,perioci"
										etiquetas="pfin,perioci"
										formatos="S,S"
										align="left,left,left"
										traerInicial="false"
										traerFiltro=""
										filtrar_por="pfin,pfecha,perioci"
										tabindex="1"
										size="10,10,8"
										form="formCalculo"
										fparams="pfin"/>--->
						<select name="pfin" id="pfin">
						<cfloop query="rsPeriodos">
							<option value="#rsPeriodos.periodo#">
									<cfif rsPeriodos.perioci EQ 'Diaria'>
										#DateFormat(rsPeriodos.pfecha,'DD/MM/YYYY')# (#rsPeriodos.perioci#)
									<cfelseif rsPeriodos.perioci EQ 'Anual'>
										#rsPeriodos.periodo# (#rsPeriodos.perioci#)
									<cfelse>
										#left(rsPeriodos.periodo,4)#-#mid(rsPeriodos.periodo,5,10)# (#rsPeriodos.perioci#)
									</cfif>
							</option>
						</cfloop>
						</select></td></tr>
							</table>
							</td>
						</tr>
						<tr><td><input name="recalcular" id="recalcular" type="checkbox" <cfif isdefined('url.recalcular')>checked="checked"</cfif>/>&nbsp;<strong>Recalcular</strong></td></tr>

						<tr><td align="center" colspan="2">&nbsp;</td></tr>
						<tr><td align="center" colspan="2"><input name="Aceptar" type="submit" value="Aceptar"/></td></tr>
						</table>
						</form>

			<cfelse>
				<center><strong>No hay periodos de informaci&oacute;n definidos</strong></center>
			</cfif>
		<cfelse>
			<center><strong>No viene definido el id de Metrica o el id de Indicador.</strong></center>
		</cfif>
	<cf_web_portlet_end>

<script language="javascript" type="text/javascript">
	function validar(){

		var valido = false;
		var mens = '';
		for (i=0;i<document.formCalculo.tipoFiltro.length;i++){
			if (document.formCalculo.tipoFiltro[i].checked){
				 valido = true;
				 break;
			}
		}
		if (i==2){
			if(document.formCalculo.pinicio.value == ''){
				mens = 'Elija el periodo inicial en que desea generar el calculo';
			}
			if(document.formCalculo.pfin.value == ''){
				mens = 'Elija el periodo final en que desea generar el calculo';
			}
			if((document.formCalculo.pinicio.value != '') && (document.formCalculo.pfin.value != '')){
				if(document.formCalculo.pinicio.value > document.formCalculo.pfin.value){
					mens = 'El periodo inicial no puede ser mayor al periodo final.';
				}
			}
		}
		if (i==1){
			if(document.formCalculo.periodo.value == ''){
				mens = 'Elija el periodo en que desea generar el calculo';
			}
		}

		if(!valido){
			mens = 'Elija el periodo en que desea generar el calculo';
		}

		<!---<cfif url.esMetric EQ  'I'>--->
			<cfif not isdefined('rsPerteneceA.MIGMdetalleid') or not len(trim(rsPerteneceA.MIGMdetalleid))>
				<cfif url.esMetric EQ  'I'>
					mens = 'Debe especificar el departamento al cual se le asignará el indicador para poder realizar calculos';
				<cfelse>
					mens = 'Debe especificar el departamento al cual se le asignará la métrica para poder realizar calculos';
				</cfif>
				valido = false;
			</cfif>
		<!---</cfif>--->

		if(mens != ''){
			alert(mens);
			return(false);
		}

	}
</script>

</cfoutput>