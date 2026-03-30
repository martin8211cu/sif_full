<cfsetting requesttimeout="3600">
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate" method="Translate"/>

<cfset filtro1 = ''>
<cfset filtro2 = ''>
	
<cfset vn_filtroempleados = ''>

<cfif isdefined("form.CFidI") and len(trim(form.CFidI))>
	<cfquery name="CFuncional" datasource="#session.DSN#">
		select CFpath,CFcodigo,CFdescripcion 
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
	</cfquery>
	<cfset filtro2 = '#LB_CentroFuncional#: '& CFuncional.CFcodigo & ' - ' & CFuncional.CFdescripcion>	
</cfif>

<cfif isdefined("form.CIid") and len(trim(form.CIid))> 
	
	<!--- Tomar en cuenta el redondeo para el saldo de vacaiones--->
	<cfquery name="rsRodondeo" datasource="#session.DSN#">
		select Pvalor from RHParametros where Pcodigo=600 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cf_dbtemp name="TempVacacionesPorPagar" returnvariable="VacacionesPorPagar" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid" 			type="numeric"			mandatory="no">
		<cf_dbtempcol name="CFid" 			type="numeric"			mandatory="no">
		<cf_dbtempcol name="identificacion"	type="varchar(100)"		mandatory="no">
		<cf_dbtempcol name="nombre" 		type="varchar(100)"		mandatory="no">
		<cf_dbtempcol name="apellido1"		type="varchar(160)" 	mandatory="no">
		<cf_dbtempcol name="apellido2"		type="varchar(160)" 	mandatory="no">
		<cf_dbtempcol name="CFcodigo"		type="varchar(50)" 		mandatory="no">
		<cf_dbtempcol name="CFdescripcion"	type="varchar(160)" 	mandatory="no">
		<cf_dbtempcol name="Importe"		type="money"			mandatory="no">
		<cf_dbtempcol name="Cantidad"		type="float"			mandatory="no"> <!--- numeric(18,2) --->
		<cf_dbtempcol name="Resultado"		type="money"			mandatory="no">
		<cf_dbtempcol name="LTdesde"		type="date"				mandatory="no">
		<cf_dbtempcol name="LThasta"		type="date"				mandatory="no">
		<cf_dbtempcol name="RHTid"			type="numeric" 			mandatory="no">
		<cf_dbtempcol name="RHJid"			type="numeric" 			mandatory="no">
		<cf_dbtempcol name="Tcodigo"		type="varchar(50)" 		mandatory="no">
		<cf_dbtempcol name="Ecodigo"		type="numeric" 			mandatory="no">
	</cf_dbtemp>

	<cfparam name="form.FechaCorte" 	default="#now()#">
	<cfparam name="form.CFidI" 			default="0">
	<cfparam name="form.dependencias" 	default="false">
	
	
	<!--- Encabezado del reporte--->
	<!---<cfinvoke key="LB_ReporteDeVacacionesPendientesPorPagar" default="Reporte de Vacaciones de Pendientes a Pagar" returnvariable="LB_ReporteDeVacacionesPendientesPorPagar" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_FechaCorte" default="Fecha de Corte" returnvariable="LB_FechaCorte" component="sif.Componentes.Translate" method="Translate">
	<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			<table width="98%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>					
					<cfset filtro1 = '#LB_FechaCorte#: '&LSDateFormat(form.FechaCorte,'dd/mm/yyyy')>
					
					<cf_EncReporte
						Titulo="#LB_ReporteDeVacacionesPendientesPorPagar#"
						Color="##E3EDEF"
						filtro1="#filtro1#"
						filtro2="#filtro2#">
						
				</td></tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>---->
	<!--- Fin del Encabezado--->
	
	<cfinvoke key="LB_ReporteDeVacacionesPendientesPorPagar" default="Reporte de Vacaciones de Pendientes por Pagar" returnvariable="LB_ReporteDeVacacionesPendientesPorPagar" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_FechaCorte" default="Fecha de Corte" returnvariable="LB_FechaCorte" component="sif.Componentes.Translate" method="Translate">
		
	<!--- Encabezado del reporte--->
		<table id="tbIlusion" width="98%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td colspan="8">
				<table width="98%" cellpadding="0" cellspacing="0" align="center">
					<tr><td>					
						<cfset filtro1 = '#LB_FechaCorte#: '&LSDateFormat(form.FechaCorte,'dd/mm/yyyy')>
						
						<cf_EncReporte
							Titulo="#LB_ReporteDeVacacionesPendientesPorPagar#"
							Color="##E3EDEF"
							filtro1="#filtro1#"
							filtro2="#filtro2#"
							cols = "6">
							
					</td></tr>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr id="trIlusion"><td align="center"><input type="text" name="ilusion" id="ilusion" value="" style="font-size:12px; border:none"/></td></tr>
		</table>
		
		
		<cfset LvarFileName = "VacacionesPendientesPago#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		
		<cf_htmlReportsHeaders 
		title="#LB_ReporteDeVacacionesPendientesPorPagar#" 
		filename="#LvarFileName#"
		irA="repAuxVacacionesPendientesPago-filtro.cfm">
		
		<table id="tbIlusion2" width="98%" cellpadding="0" cellspacing="0" align="center" style=" display:none">
		<tr>
			<td colspan="8" nowrap="nowrap">
				<cfset filtro1 = '#LB_FechaCorte#: '&LSDateFormat(form.FechaCorte,'dd/mm/yyyy')>
						
				<cf_EncReporte
					Titulo="#LB_ReporteDeVacacionesPendientesPorPagar#"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					filtro2="#filtro2#"
					cols = "6">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		</table>
	<!--- Fin del Encabezado--->
	
	<!--- Optiene el o los empleados y centro funcional--->
	<cfquery name="rsIns" datasource="#session.DSN#">
		Insert into #VacacionesPorPagar#(
			DEid,
			CFid,
			LTdesde,
			LThasta,
			Ecodigo,
			RHTid,
			RHJid,
			Tcodigo,
			identificacion,
			nombre,
			apellido1,
			apellido2,
			CFcodigo,
			CFdescripcion
		)
		select  		
		   a.DEid,
		   e.CFid,
		   a.LTdesde as inicio, 
		   a.LThasta as fin, 
		   a.Ecodigo, 
		   a.RHTid, 
		   coalesce(a.RHJid, 0) as RHJid, 
		   a.Tcodigo,
		   b.DEidentificacion,
		   b.DEnombre,
		   b.DEapellido1,
		   b.DEapellido2,
		   c.CFcodigo,
		   c.CFdescripcion
		from LineaTiempo a
			inner join DatosEmpleado b
				on b.DEid = a.DEid
				and b.Ecodigo = a.Ecodigo
			inner join RHPlazas e
				on e.RHPid = a.RHPid
				and e.Ecodigo = a.Ecodigo
			inner join CFuncional c
				on c.CFid = e.CFid
				and c.Ecodigo = e.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaCorte#">  between a.LTdesde and a.LThasta
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
		</cfif>
		<!---and a.DEid = 90866--->
		<cfif isdefined("form.CFidI") and len(trim(form.CFidI))>
			and e.CFid in (	select z.CFid 
							from CFuncional z 
							where z.Ecodigo = a.Ecodigo
								<cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.dependencias") and len(trim(form.dependencias))>
									and z.CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFuncional.CFpath#/%">
									or z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
								<cfelseif not isdefined("form.dependencias")>
									and z.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidI#">
								</cfif>)
		</cfif>
	</cfquery>
	
	<!--- Concepto de pago --->
	<cfquery name="rsConcepto" datasource="#session.DSN#">
		select a.CIid,coalesce(c.CIcantidad,0) as CIcantidad, coalesce(c.CIrango,0) as CIrango, c.CItipo, c.CIcalculo, c.CIdia as CIdia, c.CImes as CImes
			   ,coalesce(c.CIsprango,0) as CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto,CImultiempresa
		from CIncidentes a 
			inner join CIncidentesD c
			on c.CIid = a.CIid 
		where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CItipo = 3 				<!--- Calculo--->
	</cfquery>

	<cfif rsConcepto.recordCount GT 0>
		
		<!--- Empleados --->
		<cfquery name="rsEmpleados" datasource="#session.DSN#">
			select * from #VacacionesPorPagar#
		</cfquery>
		
		<cfif rsEmpleados.recordCount GT 0>
			<cfflush interval="10">
			<!--- <cfset ahoraAnterio = now()>
			<cfset ahoraInicial = now()>--->
			
			<cfset contador = 0>
			<cfloop query="rsEmpleados">
				
				<cfset contador= contador + 1>
				
				<!---<cfdump var="#NOW() - ahoraAnterio#">
				<cfset ahoraAnterio = now()>
				<br/> --->
				
				<script language="javascript" type="text/javascript">
					<cfif contador MOD 2 EQ 0>
						document.getElementById("ilusion").value="";
					<cfelse>
						document.getElementById("ilusion").value = 'En proceso...';
					</cfif><!------>
				</script>
				
				<!---<cfoutput>
					#rsEmpleados.DEid#_
					#values.get('importe').toString()#_
					#values.get('cantidad').toString()#_
					#values.get('resultado').toString()# <br /><br />
				</cfoutput>--->
				
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>			
            	<cfset current_formulas = rsConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(
											fecha1_accion=CreateDate(ListGetAt(form.FechaCorte,3,'/'), ListGetAt(form.FechaCorte,2,'/'), ListGetAt(form.FechaCorte,1,'/')),	<!---Fecha1_Accion--->
											fecha2_accion=CreateDate(ListGetAt(form.FechaCorte,3,'/'), ListGetAt(form.FechaCorte,2,'/'), ListGetAt(form.FechaCorte,1,'/')),				<!---Fecha2_Accion--->
											CIcantidad=rsConcepto.CIcantidad,																			<!---Cicantidad--->
											CIrango=rsConcepto.CIrango,	<!---CIrango --->
											CItipo=rsConcepto.CItipo,	<!---Citipo--->
											DEid=rsEmpleados.DEid,	<!---DEid--->
											RHJid=rsEmpleados.RHJid,	<!---RHJid--->
											Ecodigo=rsEmpleados.Ecodigo,<!---Ecodigo--->
											RHTid=rsEmpleados.RHTid,	<!---RHTid--->
											RHAlinea=0 ,					<!---RHAlinea--->
											CIdia=rsConcepto.CIdia,	<!---Cidia--->
											CImes=rsConcepto.CImes,	<!---Cimes--->
											Tcodigo=rsEmpleados.Tcodigo,<!---Tcodigo--->
											calc_promedio=FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->	<!---calc_promedio--->
											masivo='false',			<!---masivo--->
											tabla_temporal='',					<!---tablaTemporal--->
											calc_diasnomina=FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->	<!---calc_diasnomina--->
											, Cantidad=0					<!---cantidad--->
											, Origen='' 				<!---origen--->
											,CIsprango=rsConcepto.CIsprango		<!---Cisprango--->
											,CIspcantidad=rsConcepto.CIspcantidad	<!---Cispcantidad--->
											,CImescompleto=rsConcepto.CImescompleto	<!---Cimescompleto--->
											,MontoIncidencia=javaCast("null", "")	<!---MontoIncidencia--->
											,FijarVariable=javaCast("null", "")	<!---FijarVariable--->
											,Conexion=javaCast("null", "")	<!---Conexión--->
											,CIid=rsConcepto.CIid		<!---Ciid--->
											,TablaComponentes='RHDAcciones'			<!---TablaComponentes--->
											,CampoMontoTC='RHDAmontores'			<!---CampoMontoTC--->
											,CampoLlaveTC='RHAlinea'				<!---CampoLlaveTC--->
											,ValorLlaveTC=0						<!---ValorLlaveTC--->
											,VacacionesProyectadas=true					<!---VacacionesProyectadas--->
											,CImultiempresa=rsConcepto.CImultiempresa
											)>  
				
				<!---<script language="javascript" type="text/javascript">
					document.getElementById("ilusion").value = document.getElementById("ilusion").value + ".";
				</script> ---->
				
				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
				<cfset calc_error = RH_Calculadora.getCalc_error()>
				<cfif Not IsDefined("values")>
					<cfif isdefined("presets_text")>
						<cf_errorCode	code="52014" msg="@errorDat_1@ & '----' & @errorDat_2@ & '-----' & @errorDat_3@"
										errorDat_1="#presets_text#"
										errorDat_2="#current_formulas#"
										errorDat_3="#calc_error#"
						> 
					<cfelse>
						<cf_throw message="#calc_error#" >
					</cfif>
				</cfif>
				<!--- Update de los valores--->
				<cfquery name="rsUpdate" datasource="#session.DSN#">
					Update #VacacionesPorPagar# 
						set Importe = <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
							Cantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
							Resultado = <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
				</cfquery>
				
			</cfloop> <!---fin de calculos--->
			
			<!---Oculta el mensaje de 'En Proceso' una vez finalizado el ciclo--->
			<script language="javascript" type="text/javascript">
				document.getElementById("tbIlusion").style.display="none";
				document.getElementById("tbIlusion2").style.display="";
			</script>
			<!----<cfdump var="TOTAL: #now()-ahoraInicial#">--->
		</cfif>
		
		<!-------------------------------------------------------Pintado del reporte ----------------------------------------------->
		
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select * from  #VacacionesPorPagar#
					<cfif isdefined("form.CFagrupamiento")>
						order by CFcodigo,CFdescripcion,apellido1,apellido2,nombre 
					<cfelse>
						order by apellido1,apellido2,nombre,CFcodigo,CFdescripcion
					</cfif>
				</cfquery>
				
				<!---<cf_dump var="#rsDatos#">--->
				<cfif rsDatos.RecordCount NEQ 0>
					<table width="98%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td colspan="7">
							<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
								<cfif not isdefined("form.CFagrupamiento")>
								<tr>
									<cfoutput>
									<td valign="top" style="border-bottom:1px solid black;"><strong><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
									<td valign="top" style="border-bottom:1px solid black;"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
									
									<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap"><strong><cf_translate key="LB_CF">Centro Funcional</cf_translate></strong></td>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_SaldoProyectado">Saldo Proyectado</cf_translate></strong>
									</td>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_SalarioDiario">Salario Diario</cf_translate></strong>
									</td>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Monto_de_Vacaciones">Monto de Vacaciones</cf_translate></strong>
									</td>
									</cfoutput>
								</tr>	
								</cfif>
								
								<cfset vn_totalproy = 0>
								<cfset vn_totalSalVac = 0>
								<cfset vn_totalVacPag = 0>
								
								<cfset vn_subtotalproy = 0>
								<cfset vn_subtotalSalVac = 0>
								<cfset vn_subtotalVacPag = 0>
								
								<cfset cfidAct = -1>
								<cfoutput query="rsDatos">
									
									<cfif isdefined("form.CFagrupamiento")>
										
										<cfif cfidAct NEQ rsDatos.CFid>
											
											<cfif cfidAct NEQ -1>							
												<!---subTotales del centro Funcional Anterior --->
												<tr>
													<td colspan="3" align="right"><strong><cf_translate key="LB_subTotal">Sub Total</cf_translate>:&nbsp;</strong></td>
													<td align="right"><strong style="border-top: 1px solid black;">#LSCurrencyFormat(vn_subtotalproy,'none')#</strong></td>
													<td align="right"><strong style="border-top: 1px solid black;">#LSCurrencyFormat(vn_subtotalSalVac,'none')#</strong></td>
													<td align="right"><strong style="border-top: 1px solid black;">#LSCurrencyFormat(vn_subtotalVacPag,'none')#</strong></td>
												</tr>
												<!---reset--->
												<cfset vn_subtotalproy = 0>
												<cfset vn_subtotalSalVac = 0>
												<cfset vn_subtotalVacPag = 0>
												
											</cfif>
											
											<!---encabezado--->
											<cfset cfidAct = rsDatos.CFid>
											<tr>
												<td colspan="8" bgcolor="##F0F0F0">#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
											</tr>
											
											<!---etiquetas--->
											<tr>
												<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap"><strong><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
												
												<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
												<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap" nowrap="nowrap"><strong><cf_translate key="LB_CF">Centro Funcional</cf_translate></strong></td>
												<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
													&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Cantidad">Cantidad</cf_translate></strong>
												</td>
												<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
													&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Importe">Importe</cf_translate></strong>
												</td>
												<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
													&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Resultado">Resultado</cf_translate></strong>
												</td>
											</tr>	
										</cfif>
										
									</cfif>
									<!---Pintado de corte por centro funcional--->
									<tr>
										<td nowrap="nowrap">#rsDatos.identificacion#</td>
										<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.apellido1#&nbsp;#rsDatos.apellido2# &nbsp; #rsDatos.nombre#</td>
										<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
										<td align="right">
													#LSCurrencyFormat(rsDatos.Cantidad,'none')#
										</td>
										<td align="right">
												#LSCurrencyFormat(rsDatos.Importe,'none')#
										</td>
										<td align="right">
												#LSCurrencyFormat(rsDatos.Resultado,'none')#
										</td>
									</tr>
									
									<cfset vn_subtotalproy = vn_subtotalproy+rsDatos.Cantidad>
									<cfset vn_subtotalSalVac = vn_subtotalSalVac+rsDatos.Importe>
									<cfset vn_subtotalVacPag = vn_subtotalVacPag+rsDatos.Resultado>
									
									<cfset vn_totalproy = vn_totalproy+rsDatos.Cantidad>
									<cfset vn_totalSalVac = vn_totalSalVac+rsDatos.Importe>
									<cfset vn_totalVacPag = vn_totalVacPag+rsDatos.Resultado>
								</cfoutput>	
								
								
								<!---Pintado del corte por centro funcional en caso de que se requiera--->
								<cfif isdefined("form.CFagrupamiento")>
									<tr>
										<cfoutput>
										<td colspan="3" align="right"><strong><cf_translate key="LB_subTotal">Sub Total</cf_translate>:&nbsp;</strong></td>
										<td align="right">
											<strong style="border-top: 1px solid black;">
												<!---<cfif rsRodondeo.Pvalor EQ 0>--->
													#LSCurrencyFormat(vn_subtotalproy,'none')#
												<!---<cfelse> 
													#LSNumberFormat(vn_subtotalproy,'___,___')#
												</cfif>--->
											</strong>
										</td>
										<td align="right">
											<strong style="border-top: 1px solid black;">
											<!---<cfif rsRodondeo.Pvalor EQ 0>--->
											#LSCurrencyFormat(vn_subtotalSalVac,'none')#
											<!---<cfelse> 
											#LSNumberFormat(vn_subtotalSalVac,'___,___')#
											</cfif>--->
											</strong>
										</td>
										<td align="right">
											<strong style="border-top: 1px solid black;">
											<!---<cfif rsRodondeo.Pvalor EQ 0>--->
											#LSCurrencyFormat(vn_subtotalVacPag,'none')#
											<!---<cfelse> 
											#LSNumberFormat(vn_subtotalVacPag,'___,___')#
											</cfif>--->
											</strong>
										</td>
										</cfoutput>
									</tr>
									<tr>
										<td colspan="8"valign="top" style="border-bottom:1px solid black;">&nbsp;</td>
									</tr>
								</cfif>
								<tr>
									<cfoutput>
									<td colspan="3" align="right"><strong><cf_translate key="LB_Totales">Totales</cf_translate>:&nbsp;</strong></td>
									<td align="right">
									<strong style="border-top: 1px solid black;">
										<!---<cfif rsRodondeo.Pvalor EQ 0>---> 
											#LSCurrencyFormat(vn_totalproy,'none')#
										<!---<cfelse>
											#LSNumberFormat(vn_totalproy,'___,___')#
										</cfif>---> 
									</strong>
									</td>
									<td align="right">
									<strong style="border-top: 1px solid black;">
										<!---<cfif rsRodondeo.Pvalor EQ 0>--->
											#LSCurrencyFormat(vn_totalSalVac,'none')#
										<!---<cfelse> 
											#LSNumberFormat(vn_totalSalVac,'___,___')#
										</cfif>--->
									</strong>
									</td>
									<td align="right">
									<strong style="border-top: 1px solid black;">
										<!---<cfif rsRodondeo.Pvalor EQ 0>--->
											#LSCurrencyFormat(vn_totalVacPag,'none')#
										<!---<cfelse> 
											#LSNumberFormat(vn_totalVacPag,'___,___')#
										</cfif>--->
									</strong>
									</td>
									</cfoutput>
								</tr>				
							</table>
						</td>
					</tr>
				<cfelse>
					<tr><td align="center"><strong>---- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ----</strong></td></tr>	
				</cfif>	
			</table>	

		
		
	<cfelse>
		<cf_errorCode	code="51921" msg="El concepto de vacaciones es invalido, verificar que el concepto tengo una formula asociada.">
	</cfif>
	
</cfif>


