<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Registro_de_Asistencia_a_Cursos"
	Default="Registro de Asistencia a Cursos"
	XmlFile="/rh/capacitacion/operacion/cursos/asistencia-lista.xml"	
	returnvariable="LB_Asistencia"/>

<!--- *
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dia"
	Default="D&iacute;a"
	returnvariable="lb_dia"/>
	--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	Default="Desde"
	xmlfile="/rh/generales.xml"	
	returnvariable="lb_de"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_hasta"
	Default="Hasta"
	xmlfile="/rh/generales.xml"	
	returnvariable="lb_a"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Horas"
	Default="Horas"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"
	returnvariable="lb_horas"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Guardar"
	Default="Guardar"
	returnvariable="lb_guardar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Curso"
	Default="Curso"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	returnvariable="lb_curso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Inicio"
	Default="Fecha de Inicio"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	returnvariable="LB_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Finalizacion"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	Default="Fecha de Finalizacion"
	returnvariable="LB_Fin"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_horario"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	Default="Horario"
	returnvariable="LB_horario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_duracion"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	Default="Duraci&oacute;n"
	returnvariable="LB_duracion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Regresar"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	Default="Regresar"
	returnvariable="LB_Regresar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Seleccionar_Dia"
	xmlfile="/rh/capacitacion/operacion/cursos/programar.xml"	
	Default="Seleccionar d&iacute;a"
	returnvariable="LB_Seleccionar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Seleccionar_una_fecha"
	Default="Si no selecciona un d&iacute;a espec&iacute;fico, el proceso trae todos los d&iacute;as definidos para asistencia al curso"
	returnvariable="MSG_traer"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Traer_Datos"
	Default="Traer datos"
	returnvariable="LB_traer"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_hay_personas_matriculadas"
	Default="No hay personas matriculadas para este curso"
	returnvariable="lb_nomatricula"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Dia_fuera_de_rango"
	Default="El d&iacute;a seleccionado no esta dentro del rango de fechas en que se impartir&aacute; el curso"
	returnvariable="lb_fuerarango"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Dia_suspendido"
	Default="El d&iacute;a seleccionado no esta habilitado para asistencia al curso."
	returnvariable="lb_inhabilitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_de_fechas_de_asistencia_a_curso"
	Default="Listado de fechas de asistencia a curso"
	returnvariable="lb_titulo_conlis"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	returnvariable="lb_fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	xmlfile="/rh/generales.xml"		
	returnvariable="lb_limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente Fecha"
	returnvariable="lb_siguiente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Finalizar"
	returnvariable="lb_finalizar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_se_ha_establecido_la_programacion_del_curso"
	Default="No se ha establecido la programaci&oacute;n del curso"
	returnvariable="lb_noprogramacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Va_a_marcar_como_finalizado_el_registro_de_asistencia_para_este_curso."
	Default="Va a marcar como finalizado el registro de asistencia para este curso."
	returnvariable="lb_mensajefinalizar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Si_finaliza_no_podra_modificar_mas_las_horas_de_asistencia"
	Default="Si finaliza no podra modificar mas las horas de asistencia"
	returnvariable="lb_mensajefinalizar2"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Existen_registros_de_asistencia_con_cantidad_de_horas_en_cero"
	Default="Existen registros de asistencia con cantidad de horas en cero"
	returnvariable="lb_registroscero"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Existen_registros_de asistencia_con_cantidad_de_horas_no_registradas"
	Default="Existen registros con cantidad de horas no registradas"
	returnvariable="lb_registrosnulos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Desea_continuar?"
	Default="Desea continuar?"
	returnvariable="lb_continuar"/>

<!---
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar"
	Default="Eliminar"
	returnvariable="LB_Eliminar"/>
--->	
<!--- *
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Eliminar"
	Default="Esta seguro que desea eliminar de la programacion del curso, los dias seleccionados?"
	returnvariable="MSG_Eliminar"/>
--->	

<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("url.RHCid") and not isdefined("form.RHCid")>
	<cfset form.RHCid = url.RHCid >
</cfif>
<cfif isdefined("url.traer") and not isdefined("form.traer")>
	<cfset form.traer = true >
</cfif>
<cfif isdefined("url.fecha_registro") and not isdefined("form.fecha_registro")>
	<cfset form.fecha_registro = url.fecha_registro >
</cfif>

<cfparam name="form.fecha_registro" default="">

<cfif isdefined("url.filtro_RHIAid") and not isdefined("form.filtro_RHIAid")>
	<cfset form.filtro_RHIAid = url.filtro_RHIAid >
</cfif>
<cfif isdefined("url.filtro_RHACid") and not isdefined("form.filtro_RHACid")>
	<cfset form.filtro_RHACid = url.filtro_RHACid >
</cfif>
<cfif isdefined("url.filtro_RHGMid") and not isdefined("form.filtro_RHGMid") >
	<cfset form.filtro_RHGMid = url.filtro_RHGMid >
</cfif>
<cfif isdefined("url.filtro_Mnombre") and not isdefined("form.filtro_Mnombre")>
	<cfset form.filtro_Mnombre = url.filtro_Mnombre >
</cfif>
<cfif isdefined("url.filtro_RHCfdesde") and not isdefined("form.filtro_RHCfdesde")>
	<cfset form.filtro_RHCfdesde = url.filtro_RHCfdesde >
</cfif>
<cfif isdefined("url.filtro_RHCfhasta") and not isdefined("form.filtro_RHCfhasta")>
	<cfset form.filtro_RHCfhasta = url.filtro_RHCfhasta >
</cfif>
<cfif isdefined("url.pageNum_lista") and not isdefined("form.pageNum_lista")>
	<cfset form.pageNum_lista = url.pageNum_lista >
</cfif>

<!--- Componente --->
<cfinvoke component="rh.Componentes.RH_ProgramacionCursos" method="init" returnvariable="curso">
<!--- recupera la informacion del curso --->
<cfset rs_datoscurso = curso.obtenerCurso(form.RHCid, session.DSN, session.Usucodigo) >
<cfset rs_programacioncompleta = curso.obtenerProgramacion(form.RHCid, '', session.DSN) >

<!--- fechas del curso --->
<cfset fecha_inicio   = rs_datoscurso.RHCfdesde >
<cfset fecha_final 	  = rs_datoscurso.RHCfhasta >
<cfset duracion_por_dia = rs_datoscurso.duracion/IIf(datediff('d', fecha_inicio, fecha_final) gt 0, datediff('d', fecha_inicio, fecha_final), 1)  >
<cfset hora_inicio = '' >
<cfset hora_final = '' >
<cfif len(trim(rs_datoscurso.horaini))>
	<cfset hora_inicio   = createdatetime(year(rs_datoscurso.horaini), month(rs_datoscurso.horaini), day(rs_datoscurso.horaini), hour(rs_datoscurso.horaini), minute(rs_datoscurso.horaini), second(rs_datoscurso.horaini) )  >
</cfif>
<cfif len(trim(rs_datoscurso.horafin))>
	<cfset hora_final   = createdatetime(year(rs_datoscurso.horafin), month(rs_datoscurso.horafin), day(rs_datoscurso.horafin), hour(rs_datoscurso.horafin), minute(rs_datoscurso.horafin), second(rs_datoscurso.horafin) )  >
</cfif>
<cfset fecha_iterador = createdate(year(fecha_inicio), month(fecha_inicio), day(fecha_inicio)) >	<!--- controlar la iteracion--->
<cfset duracion_por_dia = rs_datoscurso.duracion/IIf(datediff('d', fecha_inicio, fecha_final) gt 0, datediff('d', fecha_inicio, fecha_final), 1)  >
<cfset contador = 0 >	<!--- controlar la iteracion--->

<cfif not (isdefined("form.traer") and isdefined("form.fecha_registro") and len(trim(form.fecha_registro)) eq 0) or isdefined("form.siguiente")>
	<cfif not (isdefined("form.fecha_registro") and len(trim(form.fecha_registro))) >
		<cfset form.fecha_registro = curso.obtenerFechaSiguiente(form.RHCid, session.DSN) >
	</cfif>
	<cfif len(trim(form.fecha_registro))>
		<cfparam name="form.traer" default="true">
	</cfif>
</cfif>
<cfquery name="rsVali" datasource="#session.dsn#">
	select count(1) as cantidad from RHEmpleadoCurso where RHCid=#form.RHCid#
	and RHEMestado not in (10,20)
</cfquery>

<cfset parametros = '' >
<cfif isdefined("form.filtro_RHIAid")>
	<cfset parametros = parametros & '&filtro_RHIAid=#form.filtro_RHIAid#' >
</cfif>
<cfif isdefined("form.filtro_RHACid")>
	<cfset parametros = parametros & '&filtro_RHACid=#form.filtro_RHACid#' >
</cfif>
<cfif isdefined("form.filtro_RHGMid") >
	<cfset parametros = parametros & '&filtro_RHGMid=#form.filtro_RHGMid#' >
</cfif>
<cfif isdefined("form.filtro_Mnombre")>
	<cfset parametros = parametros & '&filtro_Mnombre=#form.filtro_Mnombre#' >
</cfif>
<cfif isdefined("form.filtro_RHCfdesde")>
	<cfset parametros = parametros & '&filtro_RHCfdesde=#form.filtro_RHCfdesde#' >
</cfif>
<cfif isdefined("form.filtro_RHCfhasta")>
	<cfset parametros = parametros & '&filtro_RHCfhasta=#form.filtro_RHCfhasta#' >
</cfif>
<cfif isdefined("form.pageNum_lista")>
	<cfset parametros = parametros & '&pageNum_lista=#form.pageNum_lista#' >
</cfif>

<cfquery datasource="#session.DSN#" name="rs_hayceros">
	select 1
	from RHAsistenciaCurso
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	and RHAChoras = 0
</cfquery>

<cfquery datasource="#session.DSN#" name="rs_haynulos">
	select 1
	from RHAsistenciaCurso
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	and RHAChoras is null
</cfquery>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start titulo="#LB_Asistencia#">
	<form name="form1" method="post" action="asistencia-sql.cfm">
 	<table width="100%" border="0" cellspacing="6">
		<cfoutput>
		<tr>
			<td>
				<table width="85%" bgcolor="##CCCCCC" align="center" style="border:##000000 thin solid;">
					<tr>
						<td width="1%" nowrap="nowrap"><strong>#lb_curso#:</strong></td>
						<td colspan="3">#trim(rs_datoscurso.RHCcodigo)# - #trim(rs_datoscurso.RHCnombre)#</td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong>#LB_inicio#:</strong></td>
						<td><cf_locale name="date" value="#rs_datoscurso.RHCfdesde#"/></td>
						<td nowrap="nowrap"><strong>#LB_fin#:</strong></td>
						<td><cf_locale name="date" value="#rs_datoscurso.RHCfhasta#"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong>#LB_horario#:</strong></td>
						<td>#TimeFormat(rs_datoscurso.horaini, 'hh:mm tt')# - #TimeFormat(rs_datoscurso.horafin, 'hh:mm tt')#</td>
						<td nowrap="nowrap"><strong>#LB_duracion#:</strong></td>
						<td>#lsnumberformat(rs_datoscurso.duracion, ',9.00')# #lb_horas#</td>
					</tr>

					<tr><td colspan="4" align="center"><hr size="1"></td><tr></tr>
					<tr><td colspan="4" align="center">
								<table width="100%" align="center" cellpadding="2" class="areaFiltro" >
									<tr>
										<td width="1%" nowrap="nowrap" valign="middle">#LB_Seleccionar#</td>
										<td valign="middle">
											<!---<cf_sifcalendario name="fecha_registro" value="#form.fecha_registro#">--->
											<cf_dbfunction name="date_format" args="RHDCfecha,dd/mm/yyyy" returnvariable="conlis_fecha">
											<cf_conlis title="#lb_titulo_conlis#"
												campos = "fecha_registro" 
												desplegables = "S" 
												modificables = "N" 
												values="#form.fecha_registro#"
												size = "12"
												asignar="fecha_registro"
												asignarformatos="S"
												tabla="	RHDiasCurso"																	
												columnas="#conlis_fecha# as fecha_registro"
												filtro="RHCid =#form.RHCid#
														and RHDCactivo = 1
														order by RHDCfecha"
												desplegar="fecha_registro"
												etiquetas="#lb_fecha#"
												formatos="D"
												align="left"
												showEmptyListMsg="true"
												debug="false"
												form="form1"
												width="350"
												height="400"
												left="552"
												top="388"
												maxrows="15"
												filtrar_por="RHDCfecha"
												filtrar_por_delimiters="/"
												funcion="refrescar">
										</td>
										<td>
											<table cellpadding="0" cellspacing="0" width="1%" border="0">
												<tr>
													<td width="1%" valign="middle">
														<input type="submit" name="Guardar" style="display:none;" >
														<input type="submit" name="Traer" class="btnRefresh" value="#lb_traer#" tabindex="#contador+1#" onClick="javascript:this.form.action='';">
													</td>
													<td width="1%"  valign="middle"><input type="submit" name="Siguiente" class="btnSiguiente" value="#lb_siguiente#" tabindex="#contador+1#" onClick="javascript:this.form.fecha_registro.value=''; this.form.action='';"></td>
													<td  valign="middle"><input type="button" name="Limpiar" class="btnLimpiar" value="#lb_limpiar#" tabindex="#contador+1#" onClick="javascript:this.form.fecha_registro.value='';"></td>
												</tr>
											</table>
										</td>
										<!---<td>( <em>El d&iacute;a debe estar en el per&iacute;odo del #LSDateFormat(rs_datoscurso.RHCfdesde, 'dd/mm/yyyy')# al #LSDateFormat(rs_datoscurso.RHCfhasta, 'dd/mm/yyyy')#</em>)</td>--->
									</tr>
									<tr><td colspan="3">
										<table width="100%" cellpadding="1">
											<tr>
												<td valign="middle"><img border="0" src="/cfmx/rh/imagenes/Excl16.gif"></td>
												<td valign="middle"><em>#MSG_traer#.</em></td>
											</tr>
										</table>
									</td></tr>
									<tr><td colspan="3" align="center"></td></tr>
								</table>
					
					
					</td></tr>

				</table>			
			</td>
		</tr>

		<tr><td align="center">
			
		</cfoutput>
		<cfif isdefined("form.Traer")>
			<cfif isdefined("form.fecha_registro") and len(trim(form.fecha_registro))>
				<cfset datos = curso.obtenerPersonasPorDia( form.RHCid, form.fecha_registro, session.DSN, session.Usucodigo, session.Ecodigo ) >
			<cfelse>
				<cfset datos = curso.obtenerPersonasPorDia( form.RHCid, '', session.DSN, session.Usucodigo, session.Ecodigo ) >
			</cfif>

			<br>

			<!--- <cf_dump var="#datos#"> --->
			<table align="center" width="85%" border="0" cellpadding="2" cellspacing="0">
				<cfif isdefined("datos") and datos.recordcount gt 40 >
					<cfoutput>
					<tr><td align="center" colspan="5">
						<input type="submit" name="Guardar" class="btnAplicar" value="#lb_guardar#" tabindex="#contador+1#">
						<!---<input type="submit" name="Eliminar" class="btnEliminar" value="#lb_eliminar#" tabindex="#contador+1#" onclick="javascript: return funcEliminar();">--->
						<input type="button" name="Regresar" class="btnAnterior" value="#lb_regresar#" tabindex="#contador+1#" onclick="javascript:location.href='asistencia-lista.cfm?RHCid=#form.RHCid##parametros#'">
					</td></tr>
					</cfoutput>
				</cfif>	
				<cfif datos.recordcount gt 0>
					<cfquery name="rs" dbtype="query">
						select distinct(RHDCfecha) as fecha from datos
					</cfquery>
					<cfoutput query="datos" group="RHDCfecha">
						<tr>
							<td colspan="5" bgcolor="##CCCCCC">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td width="1%" nowrap="nowrap"><strong>D&iacute;a: <cf_locale name="date" value="#datos.RHDCfecha#"/>,&nbsp;</strong></td>
										<td><strong>#lb_de#: #timeformat(datos.RHDChorainicio, 'hh:mm tt')#	#lb_a#: #timeformat(datos.RHDChorafinal, 'hh:mm tt')#</strong></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr bgcolor="##E8e8e8">
							<td ></td>
							<td ></td>
							<td ><strong>Identificaci&oacute;n</strong></td>
							<td ><strong>Empleado</strong></td>
							<td ><strong>Horas</strong></td>
						</tr>
						<cfoutput>
						<cfset datos_dia = curso.obtenerAsistencia(datos.RHCid, datos.RHDCid, datos.DEid, LSDateFormat(datos.RHDCfecha, 'dd/mm/yyyy') ) >
						<cfset LvarHoras=datos_dia.RHAChoras>
						<cfif len(trim(datos_dia.RHAChoras)) eq 0>
							<cfquery name="rsHoras" datasource="#session.dsn#">
								select RHDChoras from RHDiasCurso where RHCid = #datos.RHCid#  
								and RHDCfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#datos.RHDCfecha#">
							</cfquery>
							<cfset LvarHoras=rsHoras.RHDChoras>
						</cfif>
						<cfset contador = contador+1 >
						<tr bgcolor="<cfif contador mod 2>##f5f5f5</cfif>">
							<td style="padding-left:10px;">&nbsp;</td>
							<td width="1%" ><!---<input type="checkbox" tabindex="#contador#" id="asistencia_#contador#" name="asistencia_#contador#">---></td>
							<td width="1%" nowrap="nowrap">#datos.DEidentificacion#</td>
							<td style="padding-left:5px;">#trim(datos.DEapellido1)# #trim(datos.DEapellido2)# #trim(datos.DEnombre)#</td>
							<td>
								<cf_inputnumber name="horas_#contador#" enteros="5" decimales="2" value="#LvarHoras#"  tabindex="#contador#">
								<input type="hidden" name="RHDCid_#contador#" value="#datos.RHDCid#">
								<input type="hidden" name="DEid_#contador#" value="#datos.DEid#">
								<input type="hidden" name="fecha_#contador#" value="#LSDateFormat(datos.RHDCfecha, 'dd/mm/yyyy')#">
							</td>
						</tr>
						</cfoutput>
					</cfoutput>
				<cfelse>
					<cfif not curso.validarFecha(form.RHCid, form.fecha_registro) >
						<tr><td align="center">
							<table width="1%" border="0" cellpadding="2" cellspacing="0" align="center">
								<tr>
									<td width="1%" valign="middle"><img border="0" src="/cfmx/rh/imagenes/Excl32.gif"></td>
									<td valign="middle" nowrap="nowrap"><strong><cfoutput>#lb_fuerarango#</cfoutput></strong></td>
								</tr>
							</table>
						</td></tr>
					<cfelse>
						<tr><td align="center">
							<table width="1%" border="0" cellpadding="2" cellspacing="0" align="center">
								<tr>
									<td width="1%" valign="middle"><img border="0" src="/cfmx/rh/imagenes/Excl32.gif"></td>
									<td valign="middle" nowrap="nowrap"><strong><cfoutput>#lb_nomatricula#</cfoutput></strong></td>
								</tr>
							</table>
						</td></tr>
					</cfif>

				</cfif>
			</table>
		<cfelse>
			<table width="1%" border="0" cellpadding="2" cellspacing="0" align="center">
				<tr>
					<td width="1%" valign="middle"><img border="0" src="/cfmx/rh/imagenes/Excl32.gif"></td>
					<td valign="middle" nowrap="nowrap"><strong><cfoutput>#lb_noprogramacion#</cfoutput></strong></td>
				</tr>
			</table>
		</cfif>

		</td></tr>
		<cfoutput>
		<cfif isdefined("form.filtro_RHIAid")>
			<input type="hidden" name="filtro_RHIAid" value="#form.filtro_RHIAid#">
		</cfif>
		<cfif isdefined("form.filtro_RHACid")>
			<input type="hidden" name="filtro_RHACid" value="#form.filtro_RHACid#">
		</cfif>
		<cfif isdefined("form.filtro_RHGMid") >
			<input type="hidden" name="" value="#form.filtro_RHGMid#">
		</cfif>
		<cfif isdefined("form.filtro_Mnombre")>
			<input type="hidden" name="filtro_Mnombre" value="#form.filtro_Mnombre#">
		</cfif>
		<cfif isdefined("form.filtro_RHCfdesde")>
			<input type="hidden" name="filtro_RHCfdesde" value="#form.filtro_RHCfdesde#">
		</cfif>
		<cfif isdefined("form.filtro_RHCfhasta")>
			<input type="hidden" name="filtro_RHCfhasta" value="#form.filtro_RHCfhasta#">
		</cfif>
		<cfif isdefined("form.pageNum_lista")>
			<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
		</cfif>
		
		<tr><td align="center">
			<cfif isdefined("datos") and datos.recordcount gt 0>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2118" default="" returnvariable="UsaPorc"/>
				<cfif UsaPorc gt 0 and rs_datoscurso.RHCtipo eq 'P'>
					<input type="submit" name="Validar Horas" class="btnAplicar" value="Validar Horas" tabindex="#contador+1#" onclick="javascript: return funcReporte(#form.RHCid#);">
				</cfif>
				<cfif rsVali.cantidad gt 0>
					<input type="submit" name="Guardar" class="btnAplicar" value="#lb_guardar#" tabindex="#contador+1#">
				
				<cfif rs_datoscurso.RHCtipo eq 'P'>
					<input type="submit" name="Finalizar" class="btnAplicar" value="#lb_finalizar#" tabindex="#contador+1#" onclick="javascript: return finalizar();">
				</cfif>
				</cfif>
				<!---<input type="submit" name="Eliminar" class="btnEliminar" value="#lb_eliminar#" tabindex="#contador+1#" onclick="javascript: return funcEliminar();">--->
			</cfif>
			<input type="button" name="Regresar" class="btnAnterior" value="#lb_regresar#" tabindex="#contador+1#" onclick="javascript:location.href='asistencia-lista.cfm?RHCid=#form.RHCid##parametros#'">
		</td></tr>
		
	</table>
	<input type="hidden" name="contador" value="#contador#" />
	<input type="hidden" name="RHCid" value="#form.RHCid#" />
	</cfoutput>

	</form>
	
	<cfset mensaje = '#lb_mensajefinalizar#'>
	<cfif rs_haynulos.recordcount gt 0>
		<cfset mensaje = mensaje & '\n - #lb_registrosnulos#'>
	</cfif>
	<cfif rs_hayCeros.recordcount gt 0>
		<cfset mensaje = mensaje & '\n - #lb_registroscero#'>
	</cfif>
	<cfset mensaje = mensaje & '\n - #lb_mensajefinalizar2#'>
	<cfset mensaje = mensaje & '\n #lb_continuar#'>	

	<script language="javascript1.2" type="text/javascript">
		function refrescar(){
			document.form1.submit();
		}
		
		function finalizar(){
			if ( confirm('<cfoutput>#mensaje#</cfoutput>')  ){
				return true;
			}
		
			return false;
		}
		function funcReporte(RHCid){						
			var PARAM  = "/cfmx/rh/capacitacion/operacion/cursos/validarHoras.cfm?RHCid="+ RHCid;
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=500')  
				} 
	</script>
	
	
<cf_templatefooter	>