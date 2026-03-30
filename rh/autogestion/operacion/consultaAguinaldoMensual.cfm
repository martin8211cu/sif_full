<!----TRADUCCION--->
<cfinvoke key="LB_HistoricoDeAguinaldoAcumulado" default="Hist&oacute;rico de Aguinaldo Acumulado" returnvariable="LB_HistoricoDeAguinaldoAcumulado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke key="MSG_NoSeHanConfiguradoLosDatosDelReporte" default="No se han configurado los datos del reporte" returnvariable="MSG_NoSeHanConfiguradoLosDatosDelReporte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElUsuarioNoSeEncuentraComoEmpleadoDeLaEmpresa" default="El usuario no se encuentra como empleado de la empresa" returnvariable="MSG_ElUsuarioNoSeEncuentraComoEmpleadoDeLaEmpresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeHaEstablecidoElMesInicialDelReporte" default="No se ha establecido el mes inicial del reporte" returnvariable="MSG_NoSeHaEstablecidoElMesInicialDelReporte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<cf_web_portlet_start titulo="#LB_HistoricoDeAguinaldoAcumulado#" border="true" skin="#Session.Preferences.Skin#">
<!----Asociacion de mes con el concepto de pago correspondiente--->
<cfquery name="rsRepAguinaldoMensual" datasource="#session.DSN#">
	select * from RepAguinaldoMensual
	where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<!----Mes inicio del reporte--->
<cfquery name="rsMinicio" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 1070	
</cfquery>
<cfif rsMinicio.RecordCount EQ 0 or len(trim(rsMinicio.Pvalor)) EQ 0>
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="center"><strong><cfoutput>#MSG_NoSeHaEstablecidoElMesInicialDelReporte#</cfoutput></strong></td>
		</tr>
	</table>
<cfelse>
	<cfif rsRepAguinaldoMensual.RecordCount EQ 0>
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center"><strong>------ <cfoutput>#MSG_NoSeHanConfiguradoLosDatosDelReporte#</cfoutput> ------</strong></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cfelse>
		<!---Funciones de seguridad---->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"><!---Activar el componente de seguridad(home\componentes\Seguridad.cfc)--->
		<cfset datos_usuario = sec.getUsuarioByCod(session.usucodigo, session.ecodigosdc, 'DatosEmpleado')>
			
		<cfset vs_DEid = datos_usuario.llave>
		
		<cfif len(trim(vs_DEid))>	
			<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
			<cfset LvarFileName = "HistoricoAguinaldoAcumulado#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">	
			
			<!---Funciones calculadora--->
			<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
			
			<cfquery name="rsEmpleado" datasource="#session.DSn#">
				select DEidentificacion,<cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as nombre
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vs_DEid#">
			</cfquery>
			
			<!---ljimenez se agrega para sacar fecha de ultimo pago del empleado 
			con el fin de ver que fecha utilizamos para calculo --->
			
			<cfquery name="rsFecha" datasource="#session.DSn#">			
				select max(RChasta) as RChasta
				from HRCalculoNomina a,  HSalarioEmpleado b
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and	a.RCNid = b.RCNid
		        	and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vs_DEid#">
			</cfquery>
			
			<cfset filtro1 = '#LB_Empleado#: #rsEmpleado.DEidentificacion# - #rsEmpleado.nombre#'>
			<cf_htmlReportsHeaders 
				title="#LB_HistoricoDeAguinaldoAcumulado#" 
				filename="#LvarFileName#"
				irA=""
				back="no">	
				<table width="60%" cellpadding="0" cellspacing="0" align="center" border="0">		
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
								<tr><td>		
									<cf_EncReporte
										Titulo="#LB_HistoricoDeAguinaldoAcumulado#"
										Color="##E3EDEF"
										filtro1= "#filtro1#"							
									>
								</td></tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table width="25%" cellpadding="0" cellspacing="0" border="0" align="center">
								<cfset vn_total = 0>
								<!---================= 1. ONCE MESES ANTERIORES AL ACTUAL =================--->
								<cfloop from="11" to="0" index="i" step="-1">
								<!---<cfloop from="0" to="11" index="i">--->
									<cfset vn_importe = 0>
									<cfset vn_resultado = 0>
									<!---Crear fechas --->
									
									<!---ljimenez--->
									<cfif isdefined("rsFecha") and len(rsFecha.RecordCount)>
										<cfset finicial = DateAdd('m',-i,createdate(year(now()),rsMinicio.Pvalor,01))><!----createdate(year(now()),rsMinicio.Pvalor,01)>---->										
									<cfelse>
										<cfset finicial = DateAdd('m',-i,createdate(year(rsFecha.RChasta),rsMinicio.Pvalor,01))><!----createdate(year(now()),rsMinicio.Pvalor,01)>---->
									</cfif>

									<cfset finicio = DateAdd('m',-i,createdate(year(finicial),rsMinicio.Pvalor,01))><!----CreateDate(vn_anno, vn_mes, 01)>--->
									<cfset ffecha = CreateDate(year(finicial), month(finicial), DaysInMonth(finicial))><!---CreateDate(vn_anno, vn_mes, DaysInMonth(finicio))--->
									<cfset vn_mes = month(finicio)>
									<cfset vs_nmes = listgetat(lista_meses, month(finicio)) >
									<!---FECHA <cfdump var="#ffecha#"> <BR>	--->
									<!---Obtener el concepto de pago parametrizado para el reporte--->
									<cfquery name="rsConceptos" datasource="#session.DSN#">
										select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
										from CIncidentes a
											inner join CIncidentesD b
												on a.CIid = b.CIid
											inner join RepAguinaldoMensual c
												on a.CIid = c.CIid
												and c.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vn_mes#">
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									</cfquery>

									<!---Obtenter datos de Jornada, y tipo de nomina del empleado en c/mes del calculo--->
									<cfquery name="rsLineaT" datasource="#session.DSN#">
										select max(LTid) as LTid
										from LineaTiempo a	
										where a.DEid = #vs_DEid#			
											and (<cfqueryparam cfsqltype="cf_sql_date" value="#finicio#"> between a.LTdesde and a.LThasta
													or
												<cfqueryparam cfsqltype="cf_sql_date" value="#ffecha#"> between a.LTdesde and a.LThasta	
												) 
									</cfquery>
									<cfif rsLineaT.RecordCount NEQ 0 and len(trim(rsLineaT.LTid))>
										<cfquery name="rsOtros" datasource="#session.DSN#">
											select 	a.RHJid, a.Tcodigo
											from LineaTiempo a	
											where a.DEid = #vs_DEid#
												and a.LTid = #rsLineaT.LTid#
										</cfquery>
										<!----Llamado a la calculadora--->
<!------->	
										<cfset current_formulas = rsConceptos.CIcalculo>
										<cfset presets_text = RH_Calculadora.get_presets(ffecha,
																	   ffecha,
																	   rsConceptos.CIcantidad,
																	   rsConceptos.CIrango,
																	   rsConceptos.CItipo,
																	   vs_DEid,
																	   rsOtros.RHJid,
																	   session.Ecodigo,
																	   0,
																	   0,
																	   rsConceptos.CIdia,
																	   rsConceptos.CImes,
																	   rsOtros.Tcodigo,
																	   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mas pesado --->
																	   'false',
																	   '',
																	   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado --->
																	   )>
										<cfset values = RH_Calculadora.calculate ( presets_text & ";" & current_formulas )>
										<cfset calc_error = RH_Calculadora.getCalc_error()>

										<cfif Not IsDefined("values")>
											<cfif isdefined("presets_text")>
												<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
											<cfelse>
												<cfthrow detail="#calc_error#" >
											</cfif>
										</cfif>
										
										<cfset vn_importe = values.get('importe').toString()>
										<cfset vn_resultado = values.get('resultado').toString()>
									
										<cfoutput>
											<tr>
												<td width="5%" nowrap="nowrap"><b>#vs_nmes#</b></td>
												<td width="20%" align="right">#LSCurrencyFormat(vn_importe,'none')#</td>
											</tr>
										</cfoutput>
										<cfset vn_total = vn_total+vn_importe>
									</cfif>							
								</cfloop>
								<!---================= SUMATORIAS =================--->
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2">
										<table cellpadding="0" cellspacing="0" border="0" align="center">
											<cfoutput>
											<tr>
												<td nowrap="nowrap" align="right"><b><cf_translate key="LB_TotalDeSalariosAcumulados">Total de salarios acumulados</cf_translate>:&nbsp;</b></td>
												<td align="right">&nbsp;#LSCurrencyFormat(vn_total,'none')#</td>
											</tr>
											<!---================= 2. AGUINALDO PROYECTADO =================--->
											<!---=========== En la tabla: RepAguinaldoMensual el mes valor 0 corresponde al CIid del concepto de pago del aguinaldo ===========--->
											<!---Obtener el concepto de pago parametrizado para el reporte--->
											<cfset vn_importe = 0>
											<cfset vn_resultado = 0>
											<cfset finicial = createdate(year(now()),month(now()),01)><!----createdate(year(now()),rsMinicio.Pvalor,01)>---->
											<!---
											<cfset finicial = createdate(year(rsFecha.CPhasta),month(rsFecha.CPhasta),01)><!----createdate(year(now()),rsMinicio.Pvalor,01)>---->
											--->
											<cfset finicio = createdate(year(finicial),month(finicial),daysinmonth(finicial))><!----CreateDate(vn_anno, vn_mes, 01)>--->
										
											<cfquery name="rsConceptos" datasource="#session.DSN#">
												select a.CIid, b.CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
												from CIncidentes a
													inner join CIncidentesD b
														on a.CIid = b.CIid
													inner join RepAguinaldoMensual c
														on a.CIid = c.CIid
														and c.Mes = 0
												where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											</cfquery>
											<cfif rsLineaT.RecordCount NEQ 0 and len(trim(rsLineaT.LTid))>
												<!----Llamado a la calculadora--->
												<cfset current_formulas = rsConceptos.CIcalculo>
												<cfset presets_text = RH_Calculadora.get_presets(finicio,
																			   finicio,
																			   rsConceptos.CIcantidad,
																			   rsConceptos.CIrango,
																			   rsConceptos.CItipo,
																			   vs_DEid,
																			   rsOtros.RHJid,
																			   session.Ecodigo,
																			   0,
																			   0,
																			   rsConceptos.CIdia,
																			   rsConceptos.CImes,
																			   rsOtros.Tcodigo,
																			   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mas pesado--->
																			   'false',
																			   '',
																			   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
																			   )>
												<cfset values = RH_Calculadora.calculate ( presets_text & ";" & current_formulas )>
												<cfset calc_error = RH_Calculadora.getCalc_error()>
												<cfif Not IsDefined("values")>
													<cfif isdefined("presets_text")>
														<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
													<cfelse>
														<cfthrow detail="#calc_error#" >
													</cfif>
												</cfif>					
												<cfset vn_importe = values.get('importe').toString()>
												<cfset vn_resultado = values.get('resultado').toString()>					
												<tr>
													<td nowrap="nowrap" align="right"><b><cf_translate key="LB_MontoProyectadoDelAguinaldo">Monto proyectado del aguinaldo</cf_translate>:&nbsp;</b></td>
													<td align="right">&nbsp;#LSCurrencyFormat(vn_importe,'none')#</td>
												</tr>
											</cfif>
											</cfoutput>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>			
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			<cfelse><!---Usuario no se encontro como empleado--->
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center"><strong>------ <cfoutput>#MSG_ElUsuarioNoSeEncuentraComoEmpleadoDeLaEmpresa#</cfoutput> ------</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>	
			</cfif>		
	</cfif>
</cfif>	
<cf_web_portlet_end>
<cf_templatefooter>	