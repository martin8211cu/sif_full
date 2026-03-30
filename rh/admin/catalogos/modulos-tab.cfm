<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Lista_de_Compentecias" default="Lista de Compentecias" returnvariable="LB_Lista_de_Compentecias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Lista_de_Acciones" default="Lista de Acciones" returnvariable="LB_Lista_de_Acciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_descripcion" default="Descripici&oacute;n"returnvariable="LB_descripcion" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="BTN_Agregar" default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_AreaDeEvaluacionDeDesempeno" default="&Aacute;reas de Evaluaci&oacute;n del Desempe&ntilde;o" returnvariable="LB_AreaDeEvaluacionDeDesempeno" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" >
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_PerfilIdealDelPuesto">Perfil ideal del puesto</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_TipoAprobacion">Tipo Aprobaci&oacute;n</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<select name="Aprobacion" tabindex="1">
								<option value="A" <cfif existeAprobacion and PvalorAprobacion.Pvalor eq 'A' >selected</cfif> ><cf_translate key="CMB_Abierta">Abierta</cf_translate></option>
								<option value="P" <cfif existeAprobacion and PvalorAprobacion.Pvalor eq 'P' >selected</cfif> ><cf_translate key="CMB_PorAprobacion">Por aprobaci&oacute;n</cf_translate></option>
							</select>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_EncargadoAprobacionFinalCentroFuncional">Encargado aprobaci&oacute;n final (Centro funcional)</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<cfif existeAprobadorFinal>
								<cfquery name="rsForm" datasource="#session.DSN#">
									select	
									CFid,
									CFcodigo,
									CFdescripcion
									from  CFuncional 
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorAprobacionFinal.Pvalor#">
								</cfquery>
								<cf_rhcfuncional query="#rsForm#" tabindex="1">
							<cfelse>
								<cf_rhcfuncional tabindex="1">
							</cfif>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>		
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_Permitir_al_encargado_del_centro_funcional_modificar_el_perfil">Permitir al encargado del centro funcional modificar el perfil</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<select name="ModificaPuesto" tabindex="1">
								<option value="S" <cfif existeModificaPuesto and PvalorModificaPuesto.Pvalor eq 'S' >selected</cfif> ><cf_translate key="CMB_SI">Si</cf_translate></option>
								<option value="N" <cfif existeModificaPuesto and PvalorModificaPuesto.Pvalor eq 'N' >selected</cfif> ><cf_translate key="CMB_NO">No</cf_translate></option>
							</select>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_ClasificacionYValoracionDePuestos">Clasificaci&oacute;n y valoraci&oacute;n de Puestos</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_progresion">Progresi&oacute;n</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<select name="progresion" tabindex="1">
								<option value="A" <cfif existeprogresion and Pvalorprogresion.Pvalor eq 'A' >selected</cfif> ><cf_translate key="CMB_Aritmetica">Aritm&eacute;tica</cf_translate></option>
								<option value="G" <cfif existeprogresion and Pvalorprogresion.Pvalor eq 'G' >selected</cfif> ><cf_translate key="CMB_Geometrica"> Geom&eacute;trica</cf_translate></option>
							</select>
						</td>
					</tr>
				</table>
				<input type="hidden" name="progresionActual" value="#Pvalorprogresion.Pvalor#">
			</td>
			<td>&nbsp;</td>
		</tr>
        <tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_progresion">Porcentaje para el segundo ajuste en el proceso de dispersi&oacute;n</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
                            <cfoutput>
                            <input 
                            name="AJUSTE1" 
                            type="text" 
                            id="AJUSTE1"
                            tabindex="1"
                            size="10"
                            style="text-align: right; font-size:10px" 
                            onblur="javascript: fm(this,2);"  
                            onfocus="javascript:this.value=qf(this); this.select();"  
                            onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                            value="<cfif (isdefined("Pvalorajuste1.Pvalor") and len(trim(Pvalorajuste1.Pvalor)))>#LSNumberFormat(Pvalorajuste1.Pvalor,'____,.__')#</cfif>"><b>%</b> 
                            </cfoutput>
						</td>
					</tr>
                    
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
        <tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_progresion">Porcentaje para el tercer ajuste en el proceso de dispersi&oacute;n</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
                           <cfoutput>
                            <input 
                            name="AJUSTE2" 
                            type="text" 
                            id="AJUSTE2"
                            tabindex="1"
                            size="10"
                            style="text-align: right; font-size:10px" 
                            onblur="javascript: fm(this,2);"  
                            onfocus="javascript:this.value=qf(this); this.select();"  
                            onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                            value="<cfif (isdefined("Pvalorajuste2.Pvalor") and len(trim(Pvalorajuste2.Pvalor)))>#LSNumberFormat(Pvalorajuste2.Pvalor,'____,.__')#</cfif>"><b>%</b> 
                            </cfoutput>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
        <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<input name="chkActivaGrados" tabindex="1" type="checkbox"<cfif PvalorActivarGradosVal.Pvalor eq 1> checked</cfif>>
				<cf_translate key="CHK_ActivarGrados">Activar Grados para Valoraci&oacute;n</cf_translate>
			</td>
			
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_ControldeMarcas">Control de Marcas</cf_translate></strong></font>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ScriptDeImportacionDeMarcasDeReloj">Script de Importaci&oacute;n de Marcas de Reloj</cf_translate>:</td>
			<td>
				<cfquery name="rsScriptsMarcas" datasource="sifcontrol">
					select rtrim(EIcodigo) as EIcodigo
					from EImportador
					where EImodulo = 'rh.marcas'
				</cfquery>
				<select name="MarcasScript" tabindex="1">
					<option value="">-- <cf_translate key="CMB_Ninguno" XmlFile="/rh/generales.xml">Ninguno</cf_translate> ---</option>
					<cfloop query="rsScriptsMarcas">
						<cfoutput>
							<option value="#rsScriptsMarcas.EIcodigo#" 
								<cfif Trim(PvalorScriptMarcas.Pvalor) EQ rsScriptsMarcas.EIcodigo> 
									selected
								</cfif>>
								#rsScriptsMarcas.EIcodigo#
							</option>
						</cfoutput>
					</cfloop>
				</select>
			</td>
	    </tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<input name="AutorizaMarcas" tabindex="1" type="checkbox"<cfif PvalorAutorizaMarcas.Pvalor eq 1> checked</cfif>>
				<cf_translate key="CHK_AutorizaciondeMarcas">Autorizaci&oacute;n de Marcas</cf_translate>
			</td>
			
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<input name="DetalleInconsistencias" type="checkbox" tabindex="1"<cfif PvalorDetalleInconsistencias.Pvalor eq 1> checked</cfif>>
				<cf_translate key="CHK_DetallarInconsistencias">Detallar Inconsistencias</cf_translate>
			</td>
			
		</tr>
		<!--- PARAMETRO : MARCAS : Cantidad de horas para diferenciar Entrada \ Salida para el proceso
		de agrupamiento de marcas (Validado de 4 a 12 horas) --->
		<tr>
			<td>&nbsp;</td>
			<td>
				<!--- Etiqueta --->
				<cf_translate key="LB_CantidadDeHorasParaDiferenciasEntradaSalidaParaElProcesoDeAgrupamientoDeMarcas">
					Cantidad de horas para diferencias Entrada \ Salida para el proceso de agrupamiento de marcas.
				</cf_translate>
			</td>
			<td>
				<!--- Objeto --->
				<cfif (isDefined("PvalorCantidadHorasMarcas.Pvalor") 
						and (len(trim(PvalorCantidadHorasMarcas.Pvalor)))
						and (PvalorCantidadHorasMarcas.Pvalor gte 4)
						and (PvalorCantidadHorasMarcas.Pvalor lte 12))>
					<cfset Form.cantidadHorasMarcas = PvalorCantidadHorasMarcas.Pvalor>
				</cfif>
				<cfparam name="Form.cantidadHorasMarcas" default="4" type="numeric">
				<CF_inputNumber 
					name			= "cantidadHorasMarcas"
					value			= "#Form.cantidadHorasMarcas#"
					default			= "0"
					enteros			= "2"
					decimales		= "0"
					negativos		= "false"
					comas			= "false"/>
			</td>
			
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				Cantidad de horas extra m&aacute;ximas por semanas:
			</td>
			<td>
			<cfif (isDefined("PhorasMaxSemana.Pvalor"))	and (len(trim(PhorasMaxSemana.Pvalor)))>
					<cfset form.horasSem = PhorasMaxSemana.Pvalor>
			</cfif>
			<cfparam name="form.horasSem" default="0" type="numeric">
			<CF_inputNumber name= "horasSem" value="#form.horasSem#" enteros="3" decimales= "0">
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				Cantidad de horas extra m&aacute;ximas por mes:
			</td>
			<td>
				<cfif (isDefined("PhorasMaxMes.Pvalor"))and (len(trim(PhorasMaxMes.Pvalor)))>
					<cfset form.horasMes = PhorasMaxMes.Pvalor>
				</cfif>
				<cfparam name="form.horasMes" default="0" type="numeric">
				<CF_inputNumber name= "horasMes" value="#form.horasMes#" enteros="3" decimales= "0">
			</td>
		</tr>
		
		<!----=============== Datos Séptimo y Q250 ====================---->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo" 
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250" 
				returnvariable="Lvar_PagaQ250">
		<cfif Lvar_PagaQ250>
		  <tr>
			<td>&nbsp;</td>
			<td>
				<cf_translate key="LB_Componente_Salarial_de_Bonificación_de_Ley_Q250">
					Componente Salarial de Bonificaci&oacute;n de Ley(Q250)
				</cf_translate>
			</td>
			<td>
				
				<cfquery name="rsCSq250" datasource="#Session.Dsn#">
					select CSid as CSidq250, CScodigo as CScodigoq250, CSdescripcion as CSdescripcionq250
					from ComponentesSalariales cs, RHParametros p
					where cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and cs.CSid = case when p.Pvalor is not null then <cf_dbfunction name="to_number" args="p.Pvalor"> else -1 end
					and p.Ecodigo = cs.Ecodigo
					and p.Pcodigo = 740
				</cfquery>
				<cfset Lvar_CSvalues=ArrayNew(1)>
				<cfif rsCSq250.recordcount GT 0>
						<cfset ArrayAppend(Lvar_CSvalues,rsCSq250.CSidq250)>
						<cfset ArrayAppend(Lvar_CSvalues,rsCSq250.CScodigoq250)>
						<cfset ArrayAppend(Lvar_CSvalues,rsCSq250.CSdescripcionq250)>
				</cfif>
				<cf_conlis
					campos="CSidq250, CScodigoq250, CSdescripcionq250"
					desplegables="N,S,S"
					modificables="N,S,N"	
					size="0,10,30"
					valuesArray="#Lvar_CSvalues#"
					title="Lista de Componentes Salariales"
					tabla="ComponentesSalariales"
					columnas="CSid as CSidq250, CScodigo as CScodigoq250, CSdescripcion as CSdescripcionq250"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="CScodigoq250, CSdescripcionq250"
					filtrar_por="CScodigo, CSdescripcion"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="CSidq250, CScodigoq250, CSdescripcionq250"
					asignarFormatos="I, S, S">
			</td>
			
		  </tr>
		</cfif>
		
		<cfif Lvar_PagaSeptimo>
		  <tr>
			<td>&nbsp;</td>
			<td>
				<cf_translate key="LB_Concepto_Incidente_de_Septimo">
					Concepto Incidente de S&eacute;ptimo
				</cf_translate>
			</td>
			<td>
				<cfquery name="rsCIseptimo" datasource="#session.DSN#"><!----Comportamiento antes de entrada ---->
					select CIid, CIcodigo, CIdescripcion
					from CIncidentes ci, RHParametros p
					where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and ci.CIid = case when p.Pvalor is not null then <cf_dbfunction name="to_number" args="p.Pvalor"> else -1 end
					and p.Ecodigo = ci.Ecodigo
					and p.Pcodigo = 750
				</cfquery>
				<cfset Lvar_CIvalues=ArrayNew(1)>
				<cfif rsCIseptimo.recordcount GT 0>
						<cfset ArrayAppend(Lvar_CIvalues,rsCIseptimo.CIid)>
						<cfset ArrayAppend(Lvar_CIvalues,rsCIseptimo.CIcodigo)>
						<cfset ArrayAppend(Lvar_CIvalues,rsCIseptimo.CIdescripcion)>
				</cfif>
				<cf_conlis
					campos="CIidsep, CIcodigosep, CIdescripcionsep"
					desplegables="N,S,S"
					modificables="N,S,N"	
					size="0,10,30"
					valuesArray="#Lvar_CIvalues#"
					title="Lista de Conceptos Incidente"
					tabla="CIncidentes"
					columnas="CIid as CIidsep, CIcodigo as CIcodigosep, CIdescripcion as CIdescripcionsep"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0"
					desplegar="CIcodigosep, CIdescripcionsep"
					filtrar_por="CIcodigo, CIdescripcion"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="CIidsep, CIcodigosep, CIdescripcionsep"
					asignarFormatos="I, S, S">
					
			</td>
			
		  </tr>
		</cfif>
		
		<!--- AREA DE TRABAJO--->
		<tr><td>&nbsp;</td></tr>
			<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong>
					<cf_translate key="LB_Evaluacion_por_Habilidade">Evaluaci&oacute;n por Habilidades</cf_translate>
				</strong></font>
			</td>
		</tr>		
		
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_Competencia_a_valorar_en_todos_los_puestos">Competencia a valorar en todos los puestos</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<cfset ArrayCompetencia=ArrayNew(1)>
							<cfif isdefined("Competencia") and len(trim(Competencia))>
								<cfquery name="rsCompetencia" datasource="#session.DSN#">
									   select a.RHHid, a.RHHcodigo, 
										 case when len(a.RHHdescripcion) > 60 then 
										 	{fn concat(substring(a.RHHdescripcion,1,57),'...')} 
											else a.RHHdescripcion end as RHHdescripcion
									   from RHHabilidades a 
										Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
										and  a.RHHid = <cfqueryparam value="#Competencia#" cfsqltype="cf_sql_numeric">	
										and a.PCid is not null

									</cfquery>								
								<cfset ArrayAppend(ArrayCompetencia,rsCompetencia.RHHid)>
								<cfset ArrayAppend(ArrayCompetencia,rsCompetencia.RHHcodigo)>
								<cfset ArrayAppend(ArrayCompetencia,rsCompetencia.RHHdescripcion)>
							</cfif> 
							
							<cf_conlis
								Campos="RHHid,RHHcodigo,RHHdescripcion"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								Size="0,10,50"
								tabindex="1"
								ValuesArray="#ArrayCompetencia#" 
								Title="#LB_Lista_de_Compentecias#"
								Tabla="RHHabilidades "
								Columnas="RHHid,RHHcodigo,case when len(RHHdescripcion) > 60 then 
										 	{fn concat(substring(RHHdescripcion,1,57),'...')} 
											else RHHdescripcion end as RHHdescripcion "
								Filtro=" Ecodigo =  #Session.Ecodigo# and PCid is not null"
								Desplegar="RHHcodigo,RHHdescripcion"
								Etiquetas="#LB_Codigo#,#LB_descripcion#"
								filtrar_por="RHHcodigo,RHHdescripcion"
								Formatos="S,S"
								Align="left,left"
								form="form1"
								Asignar="RHHid,RHHcodigo,RHHdescripcion"
								Asignarformatos="S,S,S"/>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>		
		
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong>
					<cf_translate key="LB_EvaluacionDelDesempenno">Evaluaci&oacute;n del Desempe&ntilde;o</cf_translate>
				</strong></font>
			</td>
		</tr>
		
		<cfquery name="rsTablas" datasource="#session.DSN#">
			select TEcodigo, TEnombre
			from TablaEvaluacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_TipodeEvaluacion">Tipo de Evaluaci&oacute;n</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<input type="radio" name="tipo_evaluacion" tabindex="1" 
								   value="P" <cfif PvalorTipoEvaluacion.RecordCount GT 0 and len(trim(PvalorTipoEvaluacion.Pvalor)) eq 0 >
												checked
											 <cfelseif PvalorTipoEvaluacion.RecordCount eq 0>
												checked
											</cfif> 
									onclick="javascript:mostrar_tabla('hidden');" >
						</td>
						<td nowrap><cf_translate key="RAD_Porcentaje" XmlFile="/rh/generales.xml">Porcentaje</cf_translate></td>
						<td>
							<input type="radio" name="tipo_evaluacion" tabindex="1" 
								   value="T" <cfif PvalorTipoEvaluacion.RecordCount GT 0 and len(trim(PvalorTipoEvaluacion.Pvalor)) GT 0 >
												checked</cfif> 
											 <cfif rsTablas.RecordCount eq 0>
												disabled
											 </cfif> 
								   onclick="javascript:mostrar_tabla('visible');" ></td>
						<td nowrap><cf_translate key="RAD_Tabla" XmlFile="/rh/generales.xml">Tabla</cf_translate></td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr id="id_tabla" style="visibility: <cfif PvalorTipoEvaluacion.RecordCount GT 0 and len(trim(PvalorTipoEvaluacion.Pvalor)) GT 0 >
												visible
											 <cfelse>
											 	hidden
											 </cfif>">
			<td>&nbsp;</td>
			<td><cf_translate key="LB_TabladeEvaluacion">Tabla de Evaluaci&oacute;n</cf_translate></td>
			<td>
				<select name="RHtabla" tabindex="1">
					<cfoutput query="rsTablas">
						<option value="#rsTablas.TEcodigo#" <cfif PvalorTipoEvaluacion.RecordCount GT 0 
																and trim(PvalorTipoEvaluacion.Pvalor) eq rsTablas.TEcodigo >
																selected</cfif> >
							#rsTablas.TEnombre#
						</option>
					</cfoutput>
				</select>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_PesoDeIndicadoresDeEvaluacionDelDesempeno">Peso de Indicadores de Evaluaci&oacute;n del Desempe&ntilde;o</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<CF_inputNumber 
									name			= "PesoIndicadores"
									value			= "#PvalorPesoIndicadoresED.Pvalor#"
									default			= "0"
									enteros			= "3"
									decimales		= "0"
									negativos		= "false"
									comas			= "false"
									tabindex		= "1"/>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td><font style="font-style:italic;">#LB_AreaDeEvaluacionDeDesempeno#</font> </td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_RequiereMejora">Requiere Mejora</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<CF_inputNumber 
									name			= "RequiereMejora"
									value			= "#PvalorAreaEvalReqMejora.Pvalor#"
									default			= "0"
									enteros			= "3"
									decimales		= "0"
									negativos		= "false"
									comas			= "false"
									tabindex		= "1"/>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_CumpleParcialmenteLasEspectativas">Cumple Parcialmente las Espectativas</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<CF_inputNumber 
									name			= "ParcialEspec"
									value			= "#PvalorAreaEvalCumplePar.Pvalor#"
									default			= "0"
									enteros			= "3"
									decimales		= "0"
									negativos		= "false"
									comas			= "false"
									tabindex		= "1"/>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_CumpleSatisfactoriamenteLasEspectativas">Cumple Satisfactoriamente las Espectativas</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<CF_inputNumber 
									name			= "SatisfacEspec"
									value			= "#PvalorAreaEvalCumpleSat.Pvalor#"
									default			= "0"
									enteros			= "3"
									decimales		= "0"
									negativos		= "false"
									comas			= "false"
									tabindex		= "1"/>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ExcedeLasEspectativas">Excede las Espectativas</cf_translate></td>
			<td>
				<table width="10%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<CF_inputNumber 
									name			= "ExcedeEspec"
									value			= "#PvalorAreaEvalExcedeEsp.Pvalor#"
									default			= "0"
									enteros			= "3"
									decimales		= "0"
									negativos		= "false"
									comas			= "false"
									tabindex		= "1"/>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input name="chkPorc_dist" type="checkbox" tabindex="1" 
						<cfif Pporc_distr.RecordCount GT 0 and Pporc_distr.Pvalor eq '1'>checked</cfif> >
			<cf_translate key="Porc_Distribucion">Utiliza porcentaje de distribuci&oacute;n de jefaturas</cf_translate></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>	
			<td>&nbsp;</td>
			<td><input name="chkPcf_fijo" type="checkbox" tabindex="1" 
						<cfif Pcf_fijo.RecordCount GT 0 and Pcf_fijo.Pvalor eq '1'>checked</cfif> >		
			<cf_translate key="CF_fijo">Centro Funcional Fijo en evaluaci&oacute;n</cf_translate></td>
			<td>&nbsp;</td>
		</tr>
		<!--- DEFINICION DE LA ACCION QUE SE DEBE DE UTILIZAR PARA LA CONFECCION DE LA ACCION PARA AGREGAR LOS COMPONENTE DE CARRERA PROFESIONAL --->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong>
					<cf_translate key="LB_EvaluacionDelTalentoYObjetivos">Evaluaci&oacute;n del Talento y Objetivos</cf_translate>
				</strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_TomarEnCuentaAutoevaluacionParaPonderacionDeNotas">Tomar en cuenta la autoevaluaci&oacute;n para la ponderaci&oacute;n de notas</cf_translate></td>
			<td><input name="AutoevalTalento" type="checkbox"<cfif PvalorAutoevalTalento.Pvalor eq 1> checked</cfif>></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong>
					<cf_translate key="LB_CarreraProfesional">Carrera Profesional</cf_translate>
				</strong></font>
			</td>
		</tr>
		<cfset values = ''>	
		<cfset valuesArray = ArrayNew(1)>
		<cfif PvalorCPTipoAccion.RecordCount GT 0 >	
			<cfif len(trim(PvalorCPTipoAccion.Pvalor)) GT 0 >										
				<cfquery name="rsListaAcciones" datasource="#session.DSN#">
					select RHTid,RHTcodigo,RHTdesc
					from RHTipoAccion 		
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCPTipoAccion.Pvalor#">							
				</cfquery>
				<cfset values = '#rsListaAcciones.RHTcodigo#,#rsListaAcciones.RHTdesc#'>
				<cfset ArrayAppend(valuesArray, rsListaAcciones.RHTid)>
				<cfset ArrayAppend(valuesArray, rsListaAcciones.RHTcodigo)>
				<cfset ArrayAppend(valuesArray, rsListaAcciones.RHTdesc)>			
			</cfif>	
		</cfif>	
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_TipoAccionparaCarreraProfesional">Tipo de Acci&oacute;n para Carrera Profesional</cf_translate></td>
			<td>
				<!--- ACCIONES DE PERSONAL TIPO CAMBIO, CAMBIO DE COMPONENTES SALARIALES --->
				<cf_conlis 
					campos="RHTidCP,RHTcodigo,RHTdesc"
					asignar="RHTidCP,RHTcodigo,RHTdesc"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"						
					title="#LB_Lista_de_Acciones#"
					tabla="RHTipoAccion"
					columnas="RHTid  as RHTidCP,RHTcodigo,RHTdesc"
					filtro="Ecodigo = #Session.Ecodigo# and RHTcomportam = 6"
					filtrar_por="RHTcodigo,RHTdesc"
					desplegar="RHTcodigo,RHTdesc"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#" 
					alt=""					
				/>  	
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_CapacitacionyDesarrollo">Capacitaci&oacute;n y Desarrollo</cf_translate></strong></font>
			</td>
		</tr>
		<!---<tr>
			<td>&nbsp;</td>
			<td><input name="chkDisponibles" type="checkbox" tabindex="1" 
						<cfif PcamposDisponible.RecordCount GT 0 and PcamposDisponible.Pvalor eq '1'>checked</cfif> >		
			<cf_translate key="CamposDisponibles">Mostrar Campos Disponibles en Cursos</cf_translate></td>
			<td>&nbsp;</td>
		</tr>--->
		<tr>
		<td>&nbsp;</td>
			<td><input name="chkApruebaMat" type="checkbox" tabindex="1" 
						<cfif PapruebaMat.RecordCount GT 0 and PapruebaMat.Pvalor eq '1'>checked</cfif> >		
			<cf_translate key="ApruebaMatricula">Activar la aprobaci&oacute;n de matricula</cf_translate></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
		<cfif isdefined('Pcuotas.Pvalor') and len(trim(Pcuotas.Pvalor)) gt 0>
			<cfset LPcuotas=Pcuotas.Pvalor>
		<cfelse>
			<cfset LPcuotas=0>
		</cfif>
			<td>&nbsp;</td>
			<td>Cantidad de cuotas por curso perdido:</td>
			<td><cf_inputNumber name="LvarCuotas" value="#LPcuotas#" size="15" enteros="13" decimales="2"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input name="chkdirigido" type="checkbox" tabindex="1" 
						<cfif Pdirigido.RecordCount GT 0 and Pdirigido.Pvalor eq '1'>checked</cfif> >		
			<cf_translate key="ActivarDirigido">Activar el campo "Dirigido a" en cursos</cf_translate></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input name="chkfiltros" type="checkbox" tabindex="1" 
						<cfif Pfiltros.RecordCount GT 0 and Pfiltros.Pvalor eq '1'>checked</cfif> >		
			<cf_translate key="ActivarFiltros">Activar los filtros de selecci&oacute;n de empleados en cursos</cf_translate></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
		<cfif isdefined('PporcAus.Pvalor') and len(trim(PporcAus.Pvalor)) gt 0>
			<cfset LvarAus=PporcAus.Pvalor>
		<cfelse>
			<cfset LvarAus=0>
		</cfif>
			<td>&nbsp;</td>
			<td>Porcentaje m&iacute;nimo de asistencia:</td>
			<td><cf_inputNumber name="LvarAuse" value="#LvarAus#" size="15" enteros="13" decimales="2"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>Deducci&oacute;n asociada a la perdida de un curso:</td>
			<cfif isdefined('PtipoDed.Pvalor') and len(trim(PtipoDed.Pvalor)) gt 0>
				<cfquery name="rs" datasource="#session.dsn#">
					select TDid as TDid2,TDcodigo as TDcodigo2,TDdescripcion as TDdescripcion2 from TDeduccion
					where TDid=#PtipoDed.Pvalor#
					and Ecodigo=#session.Ecodigo#
				</cfquery>

				<td><cf_rhtipodeduccion query="#rs#"  name="TDcodigo2" desc="TDdescripcion2" id="TDid2"></td>
			<cfelse>
			<td><cf_rhtipodeduccion  name="TDcodigo2" desc="TDdescripcion2" id="TDid2"></td>
			</cfif>
		</tr>		
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_ReclutamientoSeleccion">Reclutamiento y Selecci&oacute;n</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>		
			<td>Utilizar consecutivo en Concursos</td>
			<td><input type="checkbox" name="chkDisponibles" 	<cfif PConsActivar.RecordCount GT 0 and PConsActivar.Pvalor eq '1'>checked</cfif> />
		</tr>
		<tr>
			<td>&nbsp;</td>		
			<cfif isdefined('PConsecutivo.Pvalor') and len(trim(Pcuotas.Pvalor)) gt 0>
				<cfset Cons=PConsecutivo.Pvalor>
			<cfelse>
				<cfset Cons=0>
			</cfif>
			<td>Inicio de Consecutivo</td>
			<td><cf_inputNumber name="LvarCons" value="#Cons#" size="15" enteros="13" decimales="0"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>		
			<cfif isdefined('PNotaMinima.Pvalor') and len(trim(PNotaMinima.Pvalor)) gt 0>
				<cfset LvarNota=PNotaMinima.Pvalor>
			<cfelse>
				<cfset LvarNota=0>
			</cfif>
			<td>Nota M&iacute;nima para aprobar concurso</td>
			<td><cf_inputNumber name="LvarNotas" value="#LvarNota#" size="15" enteros="13" decimales="0"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>		
			<td>Utilizar plazas activas en Concursos</td>
			<td><input type="checkbox" name="chkplazasA" <cfif PactivaC.RecordCount GT 0 and PactivaC.Pvalor eq '1'>checked</cfif> />
		</tr>
		<tr>
			<td>&nbsp;</td>		
			<td>Adjudicar la misma plaza a varios concursantes</td>
			<td><input type="checkbox" name="chkadjP" <cfif PvariasPlazas.RecordCount GT 0 and PvariasPlazas.Pvalor eq '1'>checked</cfif> />
		</tr>
		<tr>	
			<td>&nbsp;</td>
			<td colspan="4" align="center">
				<input type="submit" name="btnAceptar" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="1">
			</td>
		</tr>
	</table>		
 