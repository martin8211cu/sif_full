<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_TITULOCONLISCONCEPTOSPAGO" default="Lista de Conceptos de Pago" returnvariable="LB_TITULOCONLISCONCEPTOSPAGO"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoHayRegistrosRelacionados" default="No hay registros relacionados" returnvariable="MSG_NoHayRegistrosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CODIGO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TITULOCONLISTIPOSDEDUCCION" default="Lista de Tipos de Deduccion" returnvariable="LB_TITULOCONLISTIPOSDEDUCCION"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Agregar" default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/genenrales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" >
	<!------------------- Nóminas---------------------->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_Nominas">N&oacute;minas</cf_translate></strong></font>
			</td>

		</tr>
		<tr>
		  <td>&nbsp;</td>
		  <td><cf_translate key="CHK_NominasSoloAdministrador">Prohibir Agregar, Eliminar y Modificar elementos a la N&oacute;mina</cf_translate></td>
		  <td>
				<table border="0" cellpadding="0" cellspacing="0">

					<tr>
						<td nowrap width="1%">
										<input type="checkbox" name="ProhibirAcceso" <cfif PvalorValidaAcceso.RecordCount GT 0 and PvalorValidaAcceso.Pvalor eq '1' >checked</cfif> >
						</td>

							<cfquery name="rsUsuCodigoAdmin" datasource="#session.dsn#"><!--- encuentra el usucodigo del administrador--->
								select COALESCE(Pvalor,'0') as codigoAdmin
								from RHParametros
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and Pcodigo=180<!--- este es el Pcodigo de administrador--->
							</cfquery>
							<cfset nombreUserAdmin="Administrador a&uacute;n No asignado">
							<cfif  rsUsuCodigoAdmin.Recordcount GT 0 and  rsUsuCodigoAdmin.codigoAdmin NEQ '0' >
								<cf_dbfunction name="OP_concat" returnvariable="concat">
								<cfquery name="rsNombreAdministrador" datasource="#session.dsn#">
									select Pnombre #concat#' '#concat# Papellido1 #concat#' '#concat# Papellido2 as nombre
									from Usuario a inner join DatosPersonales b
										on a.datos_personales = b.datos_personales
									where a.Usucodigo=#rsUsuCodigoAdmin.codigoAdmin#
								</cfquery>
								<cfif rsNombreAdministrador.RecordCount GT 0>
									<cfset nombreUserAdmin=rsNombreAdministrador.nombre>
								</cfif>
							</cfif>

						<td><cf_translate key="CHK_CNominasSoloAdministradorCHK">S&oacute;lo habilitado al usuario Administrador </cf_translate><cfoutput>(#nombreUserAdmin#)</cfoutput></td>
					</tr>
				</table>
		  </td>
		</tr>


		<tr><td colspan="4">&nbsp;</td></tr>


	<!-------------------------------------->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_CalculoDeComisiones">C&aacute;lculo de Comisiones</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap width="1%">
							<input type="checkbox" name="CalculaComision" tabindex="1"
								   onclick="javascript: salario_base(this.checked);"
										<cfif PvalorCalculaComisionSB.RecordCount GT 0 and PvalorCalculaComisionSB.Pvalor eq '1' >
											checked
										</cfif> >
						</td>
						<td><cf_translate key="CHK_CalcularComisionesConSalarioBase">Calcular comisiones con salario base</cf_translate></td>
					</tr>
					<tr>
						<td nowrap width="1%">
							<input type="checkbox" name="CalculaComisionC" tabindex="1"
								   onclick="javascript: salario_baseC(this.checked);"
										<cfif PvalorCalculaComisionCSB.RecordCount GT 0 and PvalorCalculaComisionCSB.Pvalor eq '1' >
											checked
										</cfif> >
						</td>
						<td><cf_translate key="CHK_CalcularComisionesCompletasSalarioBase">Calcular comisiones completas con salario base</cf_translate></td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_IncidenciaParaRebajoDeSalarioxCalculoporComisiones">Incidencia para rebajo de salario por c&aacute;lculo de comisiones</cf_translate>:&nbsp;</td>
			<td>
				<cfquery name="rsRebajo" datasource="#session.DSN#">
					select CIid, CIcodigo, CIdescripcion
					from CIncidentes
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and CItipo=2
					  and CInegativo < 0
					  and CIcarreracp = 0
				</cfquery>
				<select name="RHrebajo" tabindex="1">
					<option value="">- <cf_translate key="CMB_Ninguna">Ninguna</cf_translate> -</option>
					<cfoutput query="rsRebajo">
						<option value="#rsRebajo.CIid#"
								<cfif PvalorIncidenciaRebajoSB.RecordCount GT 0
									  and trim(PvalorIncidenciaRebajoSB.Pvalor) EQ trim(rsRebajo.CIid)>
									selected
								</cfif> >
							#rsRebajo.CIcodigo#-#rsRebajo.CIdescripcion#
						</option>
					</cfoutput>
				</select>
			</td>
		</tr>

		<cfquery name="rsIncidencia" datasource="#session.DSN#">
			select CIid, CIcodigo, CIdescripcion
			from CIncidentes
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CItipo=2
			and CInegativo > 0
			and CIcarreracp = 0
		</cfquery>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_IncidenciaParaSalarioBase">Incidencia para salario base</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHincidencia" tabindex="1">
					<option value="">- <cf_translate key="CMB_Ninguna">ninguna</cf_translate> -</option>
					<cfoutput query="rsIncidencia">
						<option value="#rsIncidencia.CIid#"
							<cfif PvalorIncidenciaSB.RecordCount GT 0
								  and trim(PvalorIncidenciaSB.Pvalor) EQ trim(rsIncidencia.CIid)>
								selected
							</cfif> >
							#rsIncidencia.CIcodigo#-#rsIncidencia.CIdescripcion#
						</option>
					</cfoutput>
				</select>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_IncidenciaParaAjusteDeSalarioBase">Incidencia para ajuste de salario base</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHajuste" tabindex="1">
					<option value="">- <cf_translate key="CMB_Ninguna">ninguna</cf_translate> -</option>
					<cfoutput query="rsIncidencia">
						<option value="#rsIncidencia.CIid#"
							<cfif PvalorIncidenciaAjusteSB.RecordCount GT 0
								  and trim(PvalorIncidenciaAjusteSB.Pvalor) EQ trim(rsIncidencia.CIid)>
								selected
							</cfif> >
							#rsIncidencia.CIcodigo#-#rsIncidencia.CIdescripcion#
						</option>
					</cfoutput>
				</select>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ScriptImportacionComisiones">Script de importaci&oacute;n de Comisiones</cf_translate>:</td>
			<td>
				<cfquery name="rsImpComision" datasource="sifcontrol">
					select EIid, EIcodigo, EIdescripcion from EImportador where EImodulo = 'rh.nomina' and EIimporta=1
				</cfquery>
				<cfoutput>
					<select name="impComision">
						<option value="">- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
						<cfloop query="rsImpComision">
							<option value="#rsImpComision.EIcodigo#"
								<cfif trim(PvalorScriptComisiones.Pvalor) eq trim(rsImpComision.EIcodigo) >
									selected
								</cfif> >
								#rsImpComision.EIcodigo# - #rsImpComision.EIdescripcion#
							</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_Liquidaciones">Liquidaciones</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		  	<td><cf_translate key="LB_FechaDeCorteEnCalculoDeCesantiaBoleta">Fecha de Corte en C&aacute;lculo de Cesant&iacute;a (Boleta)</cf_translate>:&nbsp;</td>
		  	<td>
				<cfif PvalorProteccionTrab.RecordCount GT 0 and len(trim(PvalorProteccionTrab.Pvalor)) >
					<cf_sifcalendario form="form1" name="RHProtecTrabajador" value="#PvalorProteccionTrab.Pvalor#" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="form1" name="RHProtecTrabajador" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif>
		  	</td>
	    </tr>
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<cf_translate key="LB_CantidadPeriodosParaCalculoSalarioPromedioBoleta">Cantidad de Per&iacute;odos para C&aacute;lculo de Salario Promedio (Boleta)</cf_translate>:&nbsp;
			</td>
			<td>
				<input name="RHPeriodosLiq" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); if ( trim(this.value) == '' ){ this.value = 0; }"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorPeriodos.RecordCount GT 0 ><cfoutput>#PvalorPeriodosLiq.Pvalor#</cfoutput><cfelse>0</cfif>"
					   size="8" maxlength="5" ></td>
			<td>&nbsp;</td>
		</tr>

		<tr><td colspan="4">&nbsp;</td></tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<cf_translate key="LB_CantidadDeDiasParaAnularAntiguedadDeEmpleadosInactivos">Cantidad de d&iacute;as para anular antig&uuml;edad de empleados inactivos</cf_translate>:&nbsp;
			</td>
			<td>
				<input name="RHCantDiasAnularAntiguedad" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); if ( trim(this.value) == '' ){ this.value = 0; }"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorCantDiasAnularAntig.RecordCount GT 0 ><cfoutput>#PvalorCantDiasAnularAntig.Pvalor#</cfoutput><cfelse>15</cfif>"
					   size="8" maxlength="5" >&nbsp;d&iacute;as
			</td>
			<td>&nbsp;</td>
		</tr>
		<!----************* Mostrar Saldo Al Corte *************----->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<cf_translate key="LB_MostrarSaldoAlCorte">Mostrar Saldo al Corte (*)</cf_translate>:&nbsp;
			</td>
			<td nowrap>
				<input type="checkbox" name="RHMostrarSaldoAlCorte" <cfif len(trim(PvalorMostrarSaldoAlCorte.Pvalor)) and PvalorMostrarSaldoAlCorte.Pvalor >checked</cfif>>&nbsp;
			</td>
		</tr>
		<tr>
			<td nowrap>&nbsp;</td>
			<td colspan="2">
				<cf_translate key="LB_SaldoTotalDeVacacionesAcumuladoAlUltimoMesCumplidoDeAntiguedad">
				(*)Saldo total de vacaciones acumulado al &uacute;ltimo mes cumplido de antig&uuml;edad del empleado
				</cf_translate>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_PlanillaPresupuestaria">Planilla Presupuestaria</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="sincroniza" tabindex="1"
					   type="checkbox"
						<cfif  PvalorSincroniza.RecordCount GT 0 and trim(PvalorSincroniza.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_SincronizaComponentesSalarialesConceptosPago">Sincroniza Componentes Salariales con Conceptos de Pago</cf_translate>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="validapp" onclick="ValidarGenera(this.checked)"
					   type="checkbox"
						<cfif  PvalorValidaPP.RecordCount GT 0 and trim(PvalorValidaPP.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_ValidarPlanillaPresupuestaria">Validar Planilla Presupuestaria</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="validaagc" disabled="disabled"
					   type="checkbox"
						<cfif  PAprobadorGeneraConcuro.RecordCount GT 0 and trim(PAprobadorGeneraConcuro.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_AprobadorGeneraConcurso">Aprobador genera concurso</cf_translate>
			</td>
		</tr>

		<cfset consecutivo = PvalorNumConsecutivo.Pvalor >
		<cfif not len(trim(consecutivo)) >
			<cfset consecutivo  = 1 >
		<cfelse>
			<cfset consecutivo  = consecutivo+1 >
		</cfif>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="CHK_Consecutivo_aprobacion_incidencias">Consecutivo de aprobaci&oacute;n de incidencias</cf_translate>:</td>
			<td ><input type="text" name="consecutivoInc" id="consecutivoInc" style="text-align:right" disabled="disabled" size="5" maxlength="5" value="<cfoutput>#consecutivo#</cfoutput>" />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="RHEquivPlazasComp"
					   type="checkbox"
						<cfif trim(PequivalenciaPlazasComponentes.Pvalor) eq 1 >checked</cfif>>
				<cf_translate key="CHK_Estructura_Equivalencia_Plazas_Componentes">Estructura de equivalencia de plazas con componentes</cf_translate>
			</td>
		</tr>


<!---		<tr>
			<td>&nbsp;</td>
<<<<<<< .mine
			<td><cf_translate key="LB_PorcentajeOcupacionPlaza">Porcentaje m&aacute;ximo de ocupaci&oacute;n de plazas</cf_translate>:</td>
			<td><input type="text" name="RHPorcOcupPlaza" id="RHPorcOcupPlaza" style="text-align:right" size="5" maxlength="5" value="<cfoutput><cfif len(trim(PporcentajeOcupacionPlaza.Pvalor))>#PporcentajeOcupacionPlaza.Pvalor#</cfif></cfoutput>" />
			</td>
		</tr>	--->

		<tr>
			<td>&nbsp;</td>

			<td><cf_translate key="LB_PorcentajePlazaEmpleado">Porcentaje m&aacute;ximo de ocupaci&oacute;n de plazas y recargos</cf_translate>:</td>
			<td><input type="text" name="RHPorcOcupPlazaEmpleado" id="RHPorcOcupPlazaEmpleado" style="text-align:right" size="5" maxlength="5" value="<cfoutput><cfif len(trim(PporcentajeOcupacionPlazaEmpleado.Pvalor))>#PporcentajeOcupacionPlazaEmpleado.Pvalor#</cfif></cfoutput>" />
			</td>
		</tr>

		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong>
				<cf_translate key="LB_DesgloceIncidenciasBoleta">Boleta de Pago</cf_translate>
				</strong></font>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="verIncidencias" tabindex="1"
					   type="checkbox"
						<cfif  PvalorVerIncidencias.RecordCount GT 0 and trim(PvalorVerIncidencias.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_MostrarDesgloseDeIncidenciasEnBoletaDePago">Mostrar Desglose de Incidencias en Boleta de Pago</cf_translate>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>

		<!--- seccion de Incidencias --->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong>
				<cf_translate key="LB_Incidencias">Incidencias</cf_translate>
				</strong></font>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="cargarIncidencias" tabindex="1"
					   type="checkbox"
						<cfif  PvalorCargarIncidencias.RecordCount GT 0 and trim(PvalorCargarIncidencias.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_CargarCFdeServicioenRegistrodeIncidencias">Cargar Centro Funcional de Servicio en Registro de Incidencias</cf_translate>
			</td>
		</tr>

		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<input type="checkbox" name="AfectaCostoHE" <cfif len(trim(PvalorAfectaCostoHE.Pvalor)) and PvalorAfectaCostoHE.Pvalor >checked</cfif>>&nbsp;<cf_translate key="LB_IncidenciasTipoImporteAfectaHorasExtra">Incidencias Tipo Importe Afectan Horas Extraordinarias</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap>
							<input type="checkbox" tabindex="1" name="RHAjusteSalario"  onclick="javascrip: ShowDeduccionAjuste(this);"
									<cfif PvalorAjusteSalarioNegativo.RecordCount GT 0 and PvalorAjusteSalarioNegativo.Pvalor eq '1' >checked</cfif> >
							<cf_translate key="CHK_AjusteSalarioNegativo">Ajuste autom&aacute;tico de salario negativo</cf_translate>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="apruebaIncidencias"
					id="apruebaIncidencias"
					   type="checkbox"
					   onclick="javascript: FuncActiva()"
						<cfif trim(PvalorApruebaIncidencias.Pvalor) eq 1 >checked</cfif>>
				<cf_translate key="CHK_RequiereAprobacionIncidencias">Requiere aprobaci&oacute;n incidencias</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="apruebaIncidenciasCalc"
					 id="apruebaIncidenciasCalc"
					   type="checkbox"
						<cfif trim(PvalorApruebaIncidenciasCalc.Pvalor) eq 1 >checked</cfif>>
				<cf_translate key="CHK_RequiereAprobacionIncidenciasCalc">Requiere aprobaci&oacute;n incidencias de tipo cálculo</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="apruebaIncidenciaJefeCF"
						id="apruebaIncidenciaJefeCF"
					   type="checkbox"
						<cfif trim(PvalorApruebaIncidenciasJefeCF.Pvalor) eq 1 >checked</cfif>>
				<cf_translate key="CHK_RequiereAprobacionIncidenciasJefeCF">Requiere aprobaci&oacute;n de incidencias por jefe del centro funcional</cf_translate>
			</td>
		</tr>

		<tr><td colspan="4">&nbsp;</td>
		</tr>
		<tr id="trDA" <cfif PvalorAjusteSalarioNegativo.RecordCount GT 0 and PvalorAjusteSalarioNegativo.Pvalor NEQ '1'> style="display:none" </cfif>> <td>&nbsp;</td>
		<cfset imgrecalcular = "<img border='0' src='/cfmx/rh/imagenes/question.gif' onClick='javascript:return funcOpen();'>">
			<td>
				<cf_translate key="LB_DeducionAjuste">Deducci&oacute;n Ajuste:</cf_translate><cfoutput>#imgrecalcular#</cfoutput>
			</td>
			<td colspan="2" width="50%">
				<cfset valuesArray = ArrayNew(1)>
				<cfif PvalorDeduccionAjuste.RecordCount GT 0 and trim(PvalorDeduccionAjuste.Pvalor) neq '' >
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and CIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorDeduccionAjuste.Pvalor#">
					</cfquery>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIid)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIcodigo)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIdescripcion)>
				</cfif>
				<cf_conlis
					campos="CIidB,CIcodigoB,CIdescripcionB"
					asignar="CIidB, CIcodigoB, CIdescripcionB"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidB, CIcodigo as CIcodigoB, CIdescripcion as CIdescripcionB"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and CItipo = 2 and CInopryrenta=1 and CInorenta=1 and CInodeducciones=1 and CInocargas=1 and CInocargasley=1"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoB,CIdescripcionB"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/>
		</td></tr>

		<!--- ARCHIVOS PARA PROCESO DE LIQUIDACION DE RENTA --->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_CalculoSeptimo">Liquidaci&oacute;n de Renta</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td ><cf_translate  key="LB_ProcesoDeLiquidacion">Proceso de Liquidaci&oacute;n de Renta</cf_translate>:</td>
			<td>
				<select name="URLPLiqu">
					<option value="liquidacionRentaForm.cfm" <cfif LEN(TRIM(PvalorProcesoLiqRenta.Pvalor)) and PvalorProcesoLiqRenta.Pvalor EQ 'liquidacionRentaForm.cfm'>selected</cfif>><cf_translate  key="CMB_Estandar">Est&aacute;dar</cf_translate></option>
					<option value="liquidacionRentaGT.cfm" <cfif LEN(TRIM(PvalorProcesoLiqRenta.Pvalor)) and PvalorProcesoLiqRenta.Pvalor EQ 'liquidacionRentaGT.cfm'>selected</cfif>><cf_translate  key="CMB_Estandar">Guatemala</cf_translate></option>
				</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td ><cf_translate  key="LB_RepProcesoDeLiquidacion">Reporte de Liquidaci&oacute;n de Renta</cf_translate>:</td>
			<td>
				<select name="URLPLiquRep">
					<option value="RepLiquidacionRenta.cfm" <cfif LEN(TRIM(PvalorRepProcesoLiqRenta.Pvalor)) and PvalorRepProcesoLiqRenta.Pvalor EQ 'RepLiquidacionRenta.cfm'>selected</cfif>><cf_translate  key="CMB_Estandar">Est&aacute;dar</cf_translate></option>
					<option value="RepLiquidacionRentaGT.cfm" <cfif LEN(TRIM(PvalorRepProcesoLiqRenta.Pvalor)) and PvalorRepProcesoLiqRenta.Pvalor EQ 'RepLiquidacionRentaGT.cfm'>selected</cfif>><cf_translate  key="CMB_Estandar">Guatemala</cf_translate></option>
				</select>
			</td>
		</tr>

		<!--- El parametro de replicacion solo se usa cuando no hay sido definido, cuando esta nulo.
			  Una vez que se ha definido (0 ó 1), ya no se modifica más.
		--->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate></strong></font>
			</td>
		</tr>
		<cfif isdefined("form.tab") and form.tab eq 2>
			<tr>
				<td nowrap colspan="2">&nbsp;</td>
				<td>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="1%">
								<input name="replicacion" type="checkbox" <cfif PvalorReplicacion.Pvalor eq 1 >checked</cfif> <cfif len(trim(PvalorReplicacion.Pvalor)) gt 0>disabled="disabled"</cfif>  >
								<input name="existeReplicacion" type="hidden" <cfif len(trim(PvalorReplicacion.Pvalor)) gt 0 >value="1"<cfelse>value="0"</cfif> >
							</td>
							<td width="99%" valign="middle" ><cf_translate  key="CHK_EstablecerReplicacionDeEmpleadosEntreEmpresas">Establecer Replicaci&oacute;n de Empleados entre Empresas</cf_translate></td>
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				<td>&nbsp;</td>
				<td ><cf_translate  key="LB_EmpresaOrigenParaReplicacionDeIncidencias">Empresa Origen para Replicaci&oacute;n de Incidencias</cf_translate>:</td>
				<td>
					<cfquery name="rsEmpresas" datasource="#session.DSN#">
						select Ecodigo, Edescripcion
						from Empresas
						where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						order by 2
					</cfquery>
					<select name="repEmpresaOrigen" <cfif len(trim(PvalorReplicacion.Pvalor)) gt 0>disabled="disabled"</cfif>>
						<option value=""><cf_translate  key="CMB_Ninguno">-- Ninguno ---</cf_translate></option>
						<cfloop query="rsEmpresas">
							<cfoutput>
								<option value="#rsEmpresas.Ecodigo#"
									<cfif Trim(PvalorEmpresaOrigen.Pvalor) EQ rsEmpresas.Ecodigo>selected</cfif>>
									#rsEmpresas.Edescripcion#
								</option>
							</cfoutput>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfif>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="decimales" tabindex="1"
					   type="checkbox"
						<cfif  PvalorDecimales.RecordCount GT 0 and trim(PvalorDecimales.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_MostrarDecimalesVacaciones">Mostrar sin decimales el saldo de vacaciones</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="IDautomatico" tabindex="1"
					   type="checkbox"
						<cfif  PvalorIDautomatico.RecordCount GT 0 and trim(PvalorIDautomatico.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_UsarIdentificacionAutomatica.">Usar Identificaci&oacute;n Autom&aacute;tica</cf_translate>
			</td>
		</tr>


		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate  key="LB_Otros">Otros</cf_translate></strong></font>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_Tipo_Tipo_boleta_de_pago">Tipo boleta de pago</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHTipoBoleta" tabindex="1">
					<option value="10" 	<cfif PvalorTipoBoletaPago.RecordCount GT 0 and trim(PvalorTipoBoletaPago.Pvalor) EQ 10>selected</cfif> ><cf_translate key="LB_boletaEstandarCarta">Boleta Est&aacute;ndar (Carta)</cf_translate></option>
					<option value="20" 	<cfif PvalorTipoBoletaPago.RecordCount GT 0 and trim(PvalorTipoBoletaPago.Pvalor) EQ 20>selected</cfif> ><cf_translate key="LB_boletaUnTercio">Boleta 1/3</cf_translate></option>
					<option value="30" 	<cfif PvalorTipoBoletaPago.RecordCount GT 0 and trim(PvalorTipoBoletaPago.Pvalor) EQ 30>selected</cfif> ><cf_translate key="LB_boletaUnTercio">Boleta 1/2</cf_translate></option>
					<option value="40" 	<cfif PvalorTipoBoletaPago.RecordCount GT 0 and trim(PvalorTipoBoletaPago.Pvalor) EQ 40>selected</cfif> ><cf_translate key="LB_boletaUnTercioImportadora">Boleta 1/3 Importadora</cf_translate></option>
					<option value="50" 	<cfif PvalorTipoBoletaPago.RecordCount GT 0 and trim(PvalorTipoBoletaPago.Pvalor) EQ 50>selected</cfif> ><cf_translate key="LB_boletaUnTercioImportadora">Boleta Mexico</cf_translate></option>
                </select>
			</td>
		</tr>
        <!---SML Aparezca en la boleta de Pago (rh/expediente/consultas/FormatoBoletaPagoEstandar.cfm) la leyenda de Fondo de Ahorro--->
		<tr>
			<td nowrap></td>
			<td nowrap><cf_translate key="LB_RHFondoAhorro">Mostrar Fondo de Ahorro en Boleta de Pago</cf_translate>
			</td>
			<td nowrap>
            	<!--- <cfif len(trim(PvalorSPIncapacidad.Pvalor)) and PvalorSPIncapacidad.Pvalor >--->
				<input type="checkbox" name="CHK_RHFOA" <cfif PvalorMostarFOABoletaPago.RecordCount GT 0 and trim(PvalorMostarFOABoletaPago.Pvalor) neq '0' >checked</cfif>>
			</td>
		</tr>
        <!---SML--->
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="RentaManual" tabindex="1"type="checkbox" <cfif  PvalorRentaManual.RecordCount GT 0 and trim(PvalorRentaManual.Pvalor) neq '0' >checked</cfif> />
				<cf_translate key="CHK_CalculoRentaManual">Activar C&aacute;lculo de Renta por medio de Deducci&oacute;n tipo Renta</cf_translate>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_Tipo_de_Calculo_de_Renta">Tipo de C&aacute;lculo de Renta</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHTipoCalculoRenta" tabindex="1">
					<option value="">-<cf_translate key="LB_Ninguno" xmlfile="/rh/generales.xml">Ninguno</cf_translate>-</option>
					<option value="CR" 	<cfif PvalorTipoCalculoRenta.RecordCount GT 0 and trim(PvalorTipoCalculoRenta.Pvalor) EQ 'CR'>selected</cfif> >Costa Rica</option>
					<option value="HN" 	<cfif PvalorTipoCalculoRenta.RecordCount GT 0 and trim(PvalorTipoCalculoRenta.Pvalor) EQ 'HN'>selected</cfif> >Honduras</option>
				</select>
			</td>
		</tr>


		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ConceptoDePagoParaAnticiposDeSalario">Concepto de Pago para Anticipos de Salario</cf_translate>:&nbsp;</td>
			<td>
				<cfset valuesArray = ArrayNew(1)>
				<cfif PvalorCPagoAnticipos.RecordCount GT 0 and trim(PvalorCPagoAnticipos.Pvalor) neq '' >
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and CIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCPagoAnticipos.Pvalor#">
					</cfquery>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIid)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIcodigo)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIdescripcion)>
				</cfif>
				<cf_conlis
					campos="CIidA,CIcodigoA,CIdescripcionA"
					asignar="CIidA, CIcodigoA, CIdescripcionA"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidA, CIcodigo as CIcodigoA, CIdescripcion as CIdescripcionA"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and CItipo = 2"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoA,CIdescripcionA"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/>
			</td>
		</tr>

        <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="cbSalDiaHisSal" tabindex="1"
					   type="checkbox"
						<cfif  PvalorSalDiaHisSal.RecordCount GT 0 and trim(PvalorSalDiaHisSal.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_MostrarSalarioDiarioEnHistoricosSalariales">Mostrar Salario Diario En Hist&oacute;ricos Salariales</cf_translate>
			</td>
		</tr>


		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="cbSalDiaTpoNomina" tabindex="1"
					   type="checkbox"
						<cfif  PvalorSalTipoNomina.RecordCount GT 0 and trim(PvalorSalTipoNomina.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_Mostrar_Salario_Nominal_en_Boletas_y_Acciones_de_Personal">Mostrar Salario Nominal en Boletas y Acciones de Personal</cf_translate>
			</td>
		</tr>

		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="chkUnificaSalBruto" tabindex="1"
					   type="checkbox"
						<cfif  PvalorUnificaSalBruto.RecordCount GT 0 and trim(PvalorUnificaSalBruto.Pvalor) neq '0' >
							checked
						</cfif>>
				<cf_translate key="CHK_UnificarSalarioBrutoIncidencias">Unificar Salario Bruto e Incidencias en un s&oacute;lo rubro en Boleta de Pago.</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_Importador_de_deducciones">Importador de deducciones</cf_translate>:&nbsp;</td>
			<td>
                <select name="RHTipoImport" tabindex="1">
					<option value="DEDUC" 	<cfif PvalorTipoImport.RecordCount GT 0 and trim(PvalorTipoImport.Pvalor) EQ 'DEDUC'> selected</cfif> ><cf_translate key="LB_Porsocioytipo">Por socio y tipo</cf_translate></option>
					<option value="DEDUCM" 	<cfif PvalorTipoImport.RecordCount GT 0 and trim(PvalorTipoImport.Pvalor) EQ 'DEDUCM'>selected</cfif> ><cf_translate key="LB_MasivoMultiplesRelaciones">Masivo -Multiples relaciones</cf_translate></option>
				</select>
			</td>
		</tr>
		<!-----=========== Afecta costo de horas extra ===========----->


		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<cf_translate key="LB_PorcionSubcidioMexico">Porci&oacute;n Subsidio</cf_translate>:&nbsp;
			</td>
			<td nowrap>
				<input type="text" name="PvalorPorcionSubcidioMexico"  <cfif len(trim(PvalorPorcionSubcidioMexico.Pvalor))>value="<cfoutput>#PvalorPorcionSubcidioMexico.Pvalor#"</cfoutput></cfif>>&nbsp;
			</td>
		</tr>
		<!--- LISTA DE CONCEPTOS DE PAGO PARA EL CALCULO DEL SEPTIMO --->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250"
				returnvariable="Lvar_PagaQ250">
		<cfif Lvar_PagaQ250>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_CalculoSeptimo">C&aacute;lculo S&eacute;ptimo</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ConceptoDePagoParaCalculoSeptimo">Conceptos de Pago para C&aacute;lculo de S&eacute;ptimo</cf_translate></td>
			<td>
				<cf_rhCIncidentes IncluirChk="S" index="7" size="35">
				<input name="chkLista7" type="hidden" value="" />
			</td>
		  </tr>
		  <tr>
		  	<td colspan="2">&nbsp;</td>
		  	<td>
				<cfquery name="rsListaCS" datasource="#session.DSN#">
					select Pvalor
					from RHParametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo =  1050
				</cfquery>
				<cfif isdefined('rsListaCS') and rsListaCS.RecordCount  and LEN(TRIM(rsListaCS.Pvalor)) and rsListaCS.Pvalor NEQ 0>
					<cfquery name="rsCIid" datasource="#session.DSN#">
						select CIid,CIcodigo,CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CIid in (#rsListaCS.Pvalor#)
					</cfquery>
					<table border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid black;">
						<tr style="height: 25;">
							<td class="tituloListas" width="60" nowrap>C&Oacute;DIGO</td>
							<td class="tituloListas" width="200" nowrap>CONCEPTO DE PAGO</td>
							<td class="tituloListas" width="25" nowrap>&nbsp;</td>
						</tr>
					</table>
					<table border="0" cellspacing="0" cellpadding="2">
						<cfoutput query="rsCIid">
							<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';" style="height: 25;">
								<td nowrap width="60" align="center">#CIcodigo#</td>
								<td nowrap width="200">#CIdescripcion#</td>
								<td width="25"><input name="chkListaSep" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
							</tr>
						</cfoutput>
					</table>
				</cfif>
			</td>
		  </tr>
		</cfif>



		<!---Tomar en salario promedio la incapacidas--->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;

			</td>
			<td nowrap>

				<input type="checkbox" name="RHSPMes" <cfif len(trim(PvalorSPIncapacidad.Pvalor)) and PvalorSPIncapacidad.Pvalor >checked</cfif>><cf_translate key="LB_SPMes">Tomar en cuenta en Salario Promedio las incapacidades</cf_translate>
			</td>
		</tr>

		<!---Tomar en salario promedio los retroactivos--->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;

			</td>
			<td nowrap>
				<input type="checkbox" name="RHSPRetroactivo" <cfif len(trim(PvalorSPRetroactivos.Pvalor)) and PvalorSPRetroactivos.Pvalor >checked</cfif>><cf_translate key="LB_SPRetro">Tomar en salario promedio los retroactivos distribuidos por mes</cf_translate>
			</td>
		</tr>
		<!---Tomar en cuanta nominas especiales para salario promedio--->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;

			</td>
			<td nowrap>
				<input type="checkbox" name="RHSPNomEsp" <cfif len(trim(PvalorSPnominasEspeciales.Pvalor)) and PvalorSPnominasEspeciales.Pvalor EQ 1 >checked</cfif>><cf_translate key="LB_SPNomEsp">Tomar en cuenta n&oacute;minas especiales para c&aacute;lculo de Salario Promedio</cf_translate>
			</td>
		</tr>

		<!---Calculo de horas extra en caso de que no se configure en jornadas el pago por horas laboradas--->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;

			</td>
			<td nowrap>
				<input type="checkbox" name="RHCalculoHEX" <cfif len(trim(PcalcularHEX.Pvalor)) and PcalcularHEX.Pvalor >checked</cfif>><cf_translate key="LB_CalcHEX">Calcular horas extra por medio de registro de marcas</cf_translate>
			</td>
		</tr>

		<!--- OPARRALES 2018-08-30 Codigo Cliente Despensas --->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<cf_translate key="LB_CodClienteDespensa">C&oacute;digo de Cliente para Despensa</cf_translate>:&nbsp;
			</td>
			<td nowrap>
				<input type="text" name="PvalorCodClienteDespensa"  <cfif len(trim(PvalorCodClienteDespensa.Pvalor))>value="<cfoutput>#PvalorCodClienteDespensa.Pvalor#"</cfoutput></cfif>>&nbsp;
			</td>
		</tr>

		<!--- OPARRALES 2019-01-31 Cuenta Contable para pago de Despensa Exenta --->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<cf_translate key="LB_CuentaDespesaEx">Cuenta para Despensa Exenta</cf_translate>:&nbsp;
			</td>
			<td nowrap>
				<cfif IsDefined('PvalorCCuentaDespensaE') and PvalorCCuentaDespensaE.RecordCount gt 0 and Trim(PvalorCCuentaDespensaE.Pvalor) neq ''>
					<cfquery name="rsCuenta" datasource="#session.DSN#">
						select a.Ccuenta, b.CFcuenta, a.Cformato
						from CContables a
							inner join CFinanciera b
								on a.Ccuenta = b.Ccuenta
								and a.Ecodigo = b.Ecodigo
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCCuentaDespensaE.Pvalor#">
					</cfquery>
					<cf_cuentas query="#rsCuenta#" descwidth="15">
				<cfelse>
					<cf_cuentas descwidth="15">
				</cfif>
			</td>
		</tr>

		<!---►►►►►►Cargas del IGSS(ISRR)◄◄◄◄◄◄◄--->
        <tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_CargasdelIGSS">Cargas del IGSS(ISRR)</cf_translate></strong></font>
			</td>
		</tr>
        <tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_CargasObreroPatronales">Cargas Obrero Patronales</cf_translate></td>
			<td>
				<cf_conlis
                	title	 		 ="Lista de Cargas Obrero Patronales"
                    tabla	 		 ="ECargas E inner join DCargas D on E.ECid = D.ECid"
                    columnas 		 ="E.ECdescripcion , D.DClinea as DClineaCOP,D.DCcodigo, D.DCdescripcion as DCdescripcionCOP"
                    filtro   		 ="E.Ecodigo = #session.Ecodigo# and D.DCvaloremp > 0 and E.ECauto = 1"
                    showEmptyListMsg ="true"
                    EmptyListMsg     ="-- No se encontraron Cargas Obrero Patronales --"
                    conexion         = "#session.DSN#"
                    campos		 	 ="DClineaCOP,DCcodigo,DCdescripcionCOP"
                    desplegables 	 ="N,S,S"
                    modificables 	 ="N,S,N"
                    size		 	 ="0,5,40"
                    desplegar		 ="DCcodigo,DCdescripcionCOP"
                    filtrar_por 	 ="DCcodigo,DCdescripcion"
                    etiquetas  	     ="Código,Descripción "
                    formatos    	 ="S,S"
                    align      	     ="left,left"
                    asignar			 ="DClineaCOP,DCcodigo,DCdescripcionCOP"
                    asignarformatos  ="S,S,S"
                    Cortes 			 ="ECdescripcion">
			</td>
		</tr>
        <tr>
        	<td colspan="2">&nbsp;</td>
            <td>
                 <cfquery name="plistaCargasIGSS" datasource="#session.dsn#">
                 	select E.ECdescripcion , D.DClinea as DClineaList,D.DCcodigo, D.DCdescripcion, D.DClinea as checkedcol
                    	from ECargas E
                        	inner join DCargas D
                            	on E.ECid = D.ECid
                        	where D.DClinea in (#ListAppend(ValueList(rsListaCargasIGSS.Pvalor),-1)#)
                 </cfquery>
                 <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                    <cfinvokeargument name="query" 			  value="#plistaCargasIGSS#"/>
                    <cfinvokeargument name="desplegar" 		  value="DCcodigo,DCdescripcion"/>
                    <cfinvokeargument name="etiquetas" 		  value="Código,Descripción"/>
                    <cfinvokeargument name="formatos" 		  value="S,S"/>
                    <cfinvokeargument name="align" 			  value="left,left"/>
                    <cfinvokeargument name="checkboxes" 	  value="S"/>
                    <cfinvokeargument name="keys"	 		  value="DClineaList"/>
                    <cfinvokeargument name="ira" 			  value=""/>
                    <cfinvokeargument name="showEmptyListMsg" value="true"/>
                    <cfinvokeargument name="showLink"		  value="false"/>
                    <cfinvokeargument name="incluyeForm"	  value="false"/>
                    <cfinvokeargument name="MaxRows" 		  value="0"/>
                    <cfinvokeargument name="ajustar" 		  value="s"/>
					<cfinvokeargument name="checkedcol"       value="checkedcol"/>
                    <cfinvokeargument name="Cortes"           value="ECdescripcion"/>
				</cfinvoke>
            </td>
        </tr>
       <!--- SML. Inicio Modificacion para que considerar suma de los Conceptos Prima Vacacional, Separacion, Aguinaldo y realizar el limite en el Ajuste Anual--->
       <tr><td colspan="4" align="center"><hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_AjusteAnual">Ajuste Anual</cf_translate></strong></font></td></tr>
       <tr>
			<td>&nbsp;</td>
       		<td nowrap="nowrap"><cf_translate key="LB_ConceptosPrimaVacacional">Conceptos para Prima Vacacional</cf_translate></td>

       		<td nowrap="nowrap" colspan="2">
            <cf_conlis
					campos="CIidPrimVac,CIcodigoPrimVac,CIdescripcionPrimVac"
					asignar="CIidPrimVac, CIcodigoPrimVac, CIdescripcionPrimVac"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidPrimVac, CIcodigo as CIcodigoPrimVac, CIdescripcion as CIdescripcionPrimVac"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoPrimVac,CIdescripcionPrimVac"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
                    key = "CIidPrimVac"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					<!---valuesArray="#valuesArray#" --->
				/>  	</td>
       </tr>
       <tr>
	   		<td colspan="2">&nbsp;</td>
			<td>
			<cfquery name="rsPrimVacacional" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 2560
			</cfquery>
			<cfif isdefined('rsPrimVacacional') and rsPrimVacacional.RecordCount  and LEN(TRIM(rsPrimVacacional.Pvalor)) and rsPrimVacacional.Pvalor NEQ 0>
				<cfquery name="rsCIid" datasource="#session.dsn#">
					select CIid, CIcodigo, CIdescripcion
                    from CIncidentes
					where Ecodigo = #session.Ecodigo#
					and CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPrimVacacional.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsCIid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsCIid.CIcodigo#</td>
							<td nowrap width="60%">#rsCIid.CIdescripcion#</td>
							<td width="10%"><input name="chkPrimVacacional" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
			</td>
		</tr>
       	<tr>
			<td>&nbsp;</td>
       		<td nowrap="nowrap"><cf_translate key="LB_ConceptosAguinaldo">Conceptos para Aguinaldo</cf_translate></td>

       		<td nowrap="nowrap" colspan="2"><cf_conlis
					campos="CIidAguin,CIcodigoAguin,CIdescripcionAguin"
					asignar="CIidAguin, CIcodigoAguin, CIdescripcionAguin"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidAguin, CIcodigo as CIcodigoAguin, CIdescripcion as CIdescripcionAguin"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and CItipo = 3"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoAguin,CIdescripcionAguin"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					key = "CIidAguin"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/> </td>
       </tr>
        <tr>
	   		<td colspan="2">&nbsp;</td>
			<td>
			<cfquery name="rsAguinaldo" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 2561
			</cfquery>
			<cfif isdefined('rsAguinaldo') and rsAguinaldo.RecordCount  and LEN(TRIM(rsAguinaldo.Pvalor)) and rsAguinaldo.Pvalor NEQ 0>
				<cfquery name="rsCIid" datasource="#session.dsn#">
					select CIid, CIcodigo, CIdescripcion
                    from CIncidentes
					where Ecodigo = #session.Ecodigo#
					and CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAguinaldo.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsCIid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsCIid.CIcodigo#</td>
							<td nowrap width="60%">#rsCIid.CIdescripcion#</td>
							<td width="10%"><input name="chkAguinaldo" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
			</td>
		</tr>
       <tr>
			<td>&nbsp;</td>
       		<td nowrap="nowrap"><cf_translate key="LB_ConceptosSeparacion">Conceptos para Separaci&oacute;n</cf_translate></td>

       		<td nowrap="nowrap" colspan="2"><cf_conlis
					campos="CIidSep,CIcodigoSep,CIdescripcionSep"
					asignar="CIidSep, CIcodigoSep, CIdescripcionSep"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidSep, CIcodigo as CIcodigoSep, CIdescripcion as CIdescripcionSep"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoSep,CIdescripcionSep"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					key = "CIidSep"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/> </td>
       </tr>
       <tr>
	   		<td colspan="2">&nbsp;</td>
			<td>
			<cfquery name="rsSeparacion" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 2562
			</cfquery>
			<cfif isdefined('rsSeparacion') and rsSeparacion.RecordCount  and LEN(TRIM(rsSeparacion.Pvalor)) and rsSeparacion.Pvalor NEQ 0>
				<cfquery name="rsCIid" datasource="#session.dsn#">
					select CIid, CIcodigo, CIdescripcion
                    from CIncidentes
					where Ecodigo = #session.Ecodigo#
					and CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSeparacion.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsCIid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsCIid.CIcodigo#</td>
							<td nowrap width="60%">#rsCIid.CIdescripcion#</td>
							<td width="10%"><input name="chkSeparacion" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
			</td>
		</tr>
        <tr>
			<td>&nbsp;</td>
       		<td nowrap="nowrap" ><cf_translate key="LB_PTU">Conceptos para PTU</cf_translate></td>

       		<td nowrap="nowrap" colspan="2"><cf_conlis
					campos="CIidPTU,CIcodigoPTU,CIdescripcionPTU"
					asignar="CIidPTU, CIcodigoPTU, CIdescripcionPTU"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidPTU, CIcodigo as CIcodigoPTU, CIdescripcion as CIdescripcionPTU"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoPTU,CIdescripcionPTU"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					key = "CIidPTU"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/> </td>
       </tr>
       <tr>
	   		<td colspan="2">&nbsp;</td>
			<td>
			<cfquery name="rsPTU" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 2563
			</cfquery>
			<cfif isdefined('rsPTU') and rsPTU.RecordCount  and LEN(TRIM(rsPTU.Pvalor)) and rsPTU.Pvalor NEQ 0>
				<cfquery name="rsCIid" datasource="#session.dsn#">
					select CIid, CIcodigo, CIdescripcion
                    from CIncidentes
					where Ecodigo = #session.Ecodigo#
					and CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPTU.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsCIid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsCIid.CIcodigo#</td>
							<td nowrap width="60%">#rsCIid.CIdescripcion#</td>
							<td width="10%"><input name="chkPTU" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
			</td>
		</tr>

        <tr>
			<td>&nbsp;</td>
       		<td nowrap="nowrap" colspan="1"><cf_translate key="LB_FOA">Conceptos para Fondo Ahorro</cf_translate></td>

       		<td nowrap="nowrap" colspan="2"><cf_conlis
					campos="CIidFOA,CIcodigoFOA,CIdescripcionFOA"
					asignar="CIidFOA, CIcodigoFOA, CIdescripcionFOA"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidFOA, CIcodigo as CIcodigoFOA, CIdescripcion as CIdescripcionFOA"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoFOA,CIdescripcionFOA"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					key = "CIidFOA"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/> </td>
       </tr>
       <tr>
	   		<td colspan="2">&nbsp;</td>
			<td>
			<cfquery name="rsFOA" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 2564
			</cfquery>
			<cfif isdefined('rsFOA') and rsFOA.RecordCount  and LEN(TRIM(rsFOA.Pvalor)) and rsFOA.Pvalor NEQ 0>
				<cfquery name="rsCIid" datasource="#session.dsn#">
					select CIid, CIcodigo, CIdescripcion
                    from CIncidentes
					where Ecodigo = #session.Ecodigo#
					and CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFOA.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsCIid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsCIid.CIcodigo#</td>
							<td nowrap width="60%">#rsCIid.CIdescripcion#</td>
							<td width="10%"><input name="chkFOA" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
			</td>
		</tr>

		<!--- OPARRALES 2019-01-08 Check para calcular cargas basado en Semanas por Mes --->
		<tr>
			<td >&nbsp;</td>
			<td ><cf_translate key="LB_CargasSemanasXMes">Calcular Cargas Obrero - Patron basado en Semanas por Mes</cf_translate></td>
			<td colspan="2">
				<input type="checkbox" name="chkSemanasXMes" id="chkSemanasXMes" <cfif len(trim(PvalorCargasSemanasXMes.Pvalor)) and PvalorCargasSemanasXMes.Pvalor eq 1>checked</cfif>>
			</td>
		</tr>

       <!--- SML Final--->
        <tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" align="center">
				<input type="submit" name="btnAceptar" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="1">
			</td>
		</tr>

</table>
<!---  <input name="" type="checkbox" value="" disabled="disabled" /> --->
 <script language="JavaScript1.2" type="text/javascript">
	var nuevo=0;
	function funcOpen(id) {
			var width = 500;
			var height = 230;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('ParamMensajeNomina.cfm','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;

			return false;
		}

	function ValidarGenera(m){
		if (m==true){
			document.form1.validaagc.disabled=false;
		}
		if (m==false){
			document.form1.validaagc.disabled=true
			document.form1.validaagc.checked=false;
		}
	}
function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
  	}
}

	function FuncActiva(){
		if (document.getElementById("apruebaIncidencias").checked){
			document.getElementById("apruebaIncidenciaJefeCF").checked = true;
			document.getElementById("apruebaIncidenciaJefeCF").disabled = false;
		}else{
			document.getElementById("apruebaIncidenciaJefeCF").checked = false;
			document.getElementById("apruebaIncidenciaJefeCF").disabled = true;
			}
	}
</script>
