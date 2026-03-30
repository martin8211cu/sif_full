<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lunes"
	Default="Lunes"
	xmlfile="/rh/generales.xml"
	returnvariable="vLunes"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Martes"
	Default="Martes"
	xmlfile="/rh/generales.xml"
	returnvariable="vMartes"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Miercoles"
	Default="Mi&eacute;rcoles"
	xmlfile="/rh/generales.xml"
	returnvariable="vMiercoles"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jueves"
	Default="Jueves"
	xmlfile="/rh/generales.xml"
	returnvariable="vJueves"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Viernes"
	Default="Viernes"
	xmlfile="/rh/generales.xml"
	returnvariable="vViernes"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sabado"
	Default="S&aacute;bado"
	xmlfile="/rh/generales.xml"
	returnvariable="vSabado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Domingo"
	Default="Domingo"
	xmlfile="/rh/generales.xml"
	returnvariable="vDomingo"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
	  <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_UsuarioNoesEmpleado"
						Default="El usuario no es empleado de la empresa"
						returnvariable="MSG_UsuarioNoEsEmpleado"/>

		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">

					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="nombre_proceso"
					Default="Consulta de Horario Laboral"
					returnvariable="nombre_proceso"/>
					<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<!---Averiguar el DEid del usuario logueado---->
						<cfquery name="rsDEid" datasource="#session.DSN#">
							select llave as DEid
							from UsuarioReferencia
							where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								and STabla = 'DatosEmpleado'
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
						</cfquery>
						<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
						<cfif rsDEid.RecordCount NEQ 0>
							<cfquery name="rsLineaT" datasource="#session.DSN#">
								select count(1) as cant from LineaTiempo
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
									and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
							</cfquery>
							<cfif rsLineaT.Recordcount NEQ 0 and rsLineaT.cant GT 0>
								<cfset vd_fechaFinal = DateAdd("d", 6, "#now()#")>
								<!---Tabla temporal para almacenar todas las fechas del rango---->
								<cf_dbtemp name="TempRangoFechas" returnvariable="TempRangoFechas" datasource="#session.DSN#">
									<cf_dbtempcol name="tmpfecha" 		type="datetime"		mandatory="yes">
									<cf_dbtempcol name="tmpDEid" 		type="numeric"		mandatory="yes">
									<cf_dbtempcol name="tmpRHJid" 		type="numeric"		mandatory="no">
									<cf_dbtempcol name="tmpLibre" 		type="char(1)"		mandatory="no">
									<cf_dbtempcol name="tmpEntrada" 	type="datetime"		mandatory="no">
									<cf_dbtempcol name="tmpSalida" 		type="datetime"		mandatory="no">
									<cf_dbtempcol name="tmpTocioso" 	type="float"		mandatory="no">
									<cf_dbtempcol name="tmpDia" 		type="varchar(16)"	mandatory="no">
									<cf_dbtempcol name="tmpFeriado" 	type="char(1)"		mandatory="no">
									<cf_dbtempcol name="tmpVacacion" 	type="char(1)"		mandatory="no">
								</cf_dbtemp>
								<!---Inserta las fechas ---->
								<cfset vd_fecha = CreateDateTime(year(now()), month(now()), day(now()), 00, 00,0)><!---Variable con la fecha---->
								<cfloop condition = "#vd_fecha# LTE #vd_fechaFinal#">
									<cfquery datasource="#session.DSN#">
										insert into #TempRangoFechas# (tmpfecha,tmpDEid)
										values(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">)
									</cfquery>
									<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
								</cfloop>
								<!----Actualiza el dia de la semana---->
								<cfquery datasource="#session.DSN#">
									update #TempRangoFechas# set
										tmpDia = case <cf_dbfunction name="date_part"   args="DW,tmpfecha">
													when 2 then
														'#vLunes#'
													when 3 then
														'#vMartes#'
													when 4 then
														'#vMiercoles#'
													when 5 then
														'#vJueves#'
													when 6 then
														'#vViernes#'
													when 7 then
														'#vSabado#'
													when 1 then
														'#vDomingo#'
												end
								</cfquery>
								<!----Actualiza los días feriados ----->
								<cfquery datasource="#session.DSN#">
									update #TempRangoFechas#
										set tmpFeriado = '1'
									where exists( select 1
									from #TempRangoFechas# a
										inner join RHFeriados b
											on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHFfecha,yyyymmdd">
											and b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
								</cfquery>
								<!---Actualiza los dias de vacaciones ---->
								<cfquery datasource="#session.DSN#">
									update #TempRangoFechas#
										set tmpVacacion = '1'
									where exists(select 1
									from  #TempRangoFechas# a
										inner join LineaTiempo b
											on  <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> between b.LTdesde and b.LThasta
											and a.tmpDEid = b.DEid

											inner join RHTipoAccion c
												on b.RHTid = c.RHTid
												and b.Ecodigo = c.Ecodigo
												and c.RHTcomportam = 3)
								</cfquery>
								<!----Actualiza los datos de los días que si estan en el planificador--->
								<cfquery name="updatePlan" datasource="#session.DSN#">
									update #TempRangoFechas# set
										<!---Prioridad al horario del planificador--->
										tmpLibre = case when b.RHPJfinicio != c.RHJhoraini then
													 <cf_dbfunction name="to_char" args="b.RHPlibre">
													else
														case when c.RHDJdia is null then '1'
														else
															<cf_dbfunction name="to_char" args="b.RHPlibre">
														end
													end,
										tmpEntrada =  case when b.RHPJfinicio != c.RHJhoraini then
														b.RHPJfinicio
													  else
													  	c.RHJhoraini
													  end,
										tmpSalida = case when b.RHPJffinal != c.RHJhorafin then
														b.RHPJffinal
													else
														c.RHJhorafin
													end,
										tmpRHJid = b.RHJid
									from  #TempRangoFechas# a
										inner join RHPlanificador b
											on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="b.RHPJfinicio,yyyymmdd">
											and a.tmpDEid = b.DEid

											left outer join RHDJornadas c
												on b.RHJid = c.RHJid
												and datepart(dw,a.tmpfecha) = c.RHDJdia
								</cfquery>
								<!----Actualiza los días que estan definidos en la linea del tiempo ---->
								<cfquery name="updatePlan" datasource="#session.DSN#">
									update #TempRangoFechas# set
										tmpLibre = 	case datepart(dw,a.tmpfecha) 	when  2 then ( case when RHJmon = 1 then '0' else '1' end )
																					when  3 then ( case when RHJtue = 1 then '0' else '1' end )
																					when  4 then ( case when RHJwed = 1 then '0' else '1' end )
																					when  5 then ( case when RHJthu = 1 then '0' else '1' end )
																					when  6 then ( case when RHJfri = 1 then '0' else '1' end )
																					when  7 then ( case when RHJsat = 1 then '0' else '1' end )
																					when  1 then ( case when RHJsun = 1 then '0' else '1' end )
										end,
										tmpEntrada = d.RHJhoraini,
										tmpSalida = d.RHJhorafin,
										tmpRHJid = b.RHJid
									from  #TempRangoFechas# a
										inner join LineaTiempo b
											on <cf_dbfunction name="date_format" args="a.tmpfecha,yyyymmdd"> between b.LTdesde and b.LThasta
											and a.tmpDEid = b.DEid

											inner join RHJornadas c
												on b.RHJid = c.RHJid

												left outer join RHDJornadas d
													on c.RHJid = d.RHJid
													and datepart(dw,a.tmpfecha) = d.RHDJdia

									where a.tmpRHJid is null
								</cfquery>
								<!----Actualiza el tiempo ocioso----->
								<cfquery datasource="#session.DSN#">
									update #TempRangoFechas# set
										 tmpTocioso = datediff(mi, convert(varchar, b.RHJhorainicom, 108), convert(varchar, b.RHJhorafincom, 108))
									from #TempRangoFechas# c
										inner join RHJornadas a
											on c.tmpRHJid = a.RHJid
										inner join RHDJornadas b
											on a.RHJid = b.RHJid
											and datepart(dw,c.tmpfecha) = b.RHDJdia
								</cfquery>

								<cfquery name="rsHorario" datasource="#session.DSN#">
									select 	tmpDia,
											tmpfecha,
											tmpTocioso,
											tmpLibre,
											tmpVacacion,
											tmpFeriado,
											tmpEntrada as HoraInicio,
											tmpSalida as HoraSalida
									from  #TempRangoFechas#
									order by tmpfecha asc
								</cfquery>



								<!---Datos de empleado---->
								<cfquery name="rsEmpleado" datasource="#Session.DSN#"><!----Busca la ULTIMA jornada definida en la linea del tiempo (para los empleados que no estan activos actualmente)---->
									select 	a.DEid,
											a.DEidentificacion,
											a.DEnombre,
											a.DEapellido1,
											a.DEapellido2,
											n.NTIdescripcion
									from DatosEmpleado a, NTipoIdentificacion n
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
										and a.NTIcodigo = n.NTIcodigo
								</cfquery>
							</cfif>
							<table width="100%" cellpadding="0" cellspacing="0" align="center">
								<cfif isdefined("rsHorario") and rsHorario.RecordCount NEQ 0>
									<tr>
										<td><cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm"></td>
									</tr>
									<tr>
										<td>
											<table width="100%" cellpadding="5" cellspacing="0">
												<tr class="tituloListas">
													<td width="3%">&nbsp;</td>
													<td width="29%"><strong><cf_translate key="LB_DiaSemana">D&iacute;a de la semana</cf_translate></strong></td>
													<td width="21%" align="center"><strong><cf_translate key="LB_HoraEntrada">Hora de entrada</cf_translate></strong></td>
													<td width="20%" align="center"><strong><cf_translate key="LB_HoraSalida">Hora de salida</cf_translate></strong></td>
													<td width="26%" align="center"><strong><cf_translate key="LB_TiempoOcioso">Tiempo Ocioso(minutos)</cf_translate></strong></td>
													<td width="1%" align="center">&nbsp;</td>
												</tr>
												<cfloop query="rsHorario">
													<tr class="<cfif rsHorario.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
														<td>&nbsp;</td>
														<td>
															<cfset vn_mes = Month(rsHorario.tmpfecha)>
															<cfset vs_mes = listgetat(meses, vn_mes)>
															<cf_translate key="LB_#rsHorario.tmpDia#">#rsHorario.tmpDia#</cf_translate>
															#LSDateFormat(rsHorario.tmpfecha,'dd')#
															<cf_translate key="LB_#vs_mes#">#vs_mes#</cf_translate>,
															#LSDateFormat(rsHorario.tmpfecha,'yyyy')#														</td>
														<td align="center">
															<cfif rsHorario.tmpFeriado EQ 1>
																<strong><i> <cf_translate  key="LB_Feriado">Feriado</cf_translate> </i></strong>
															<cfelseif rsHorario.tmpVacacion EQ 1>
																<strong><i> <cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate> </i></strong>
															<cfelseif rsHorario.tmpLibre EQ 1>
																<strong><i> <cf_translate  key="LB_Libre">Libre</cf_translate> </i></strong>
															<cfelse>
																#TIMEformAT(rsHorario.HoraInicio,'hh:mm:ss tt')#
															</cfif>														</td>
														<td align="center">
															<cfif rsHorario.tmpFeriado EQ 1>
																<strong><i> <cf_translate  key="LB_Feriado">Feriado</cf_translate></i></strong>
															<cfelseif rsHorario.tmpVacacion EQ 1>
																<strong><i> <cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate></i></strong>
															<cfelseif rsHorario.tmpLibre EQ 1>
																<strong><i> <cf_translate  key="LB_Libre">Libre</cf_translate> </i></strong>
															<cfelse>
																#timeformat(rsHorario.HoraSalida,'hh:mm:ss tt')#
															</cfif>														</td>
														<td align="center">
															<cfif rsHorario.tmpFeriado EQ 1>
																<strong><i> <cf_translate  key="LB_Feriado">Feriado</cf_translate> </i></strong>
															<cfelseif rsHorario.tmpVacacion EQ 1>
																<strong><i> <cf_translate  key="LB_Vacaciones">Vacaciones</cf_translate> </i></strong>
															<cfelseif rsHorario.tmpLibre EQ 1>
																<strong><i> <cf_translate  key="LB_Libre">Libre</cf_translate> </i></strong>
															<cfelse>
																#rsHorario.tmpTocioso#
															</cfif>														</td>
													</tr>
												</cfloop>
											<cfelse>
												<tr><td>&nbsp;</td></tr>
												<tr><td align="center"><strong>---- #MSG_UsuarioNoEsEmpleado# ----</strong></td></tr>
												<tr><td>&nbsp;</td></tr>
											</cfif>
											<tr><td>&nbsp;</td></tr>
											<tr><td>&nbsp;</td></tr>
										</table>
									</td>
								</tr>
								<cfelse>
									<tr><td align="center">&nbsp;</td>
									</tr>
								</cfif>
						</table>
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
		</cfoutput>
<cf_templatefooter>
