<cfinvoke key="LB_CentroFuncional" 	default="Centro Funcional" returnvariable="LB_CentroFuncional" 		component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_Identificacion" 	default="Identificación" 	returnvariable="LB_Identificacion" 		component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_Nombre" 			default="Nombre" 			returnvariable="LB_Nombre" 				component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Centro_Funcional" default="Centro Funcional" 	returnvariable="LB_Centro_Funcional" 	component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Cantidad" 		default="Cantidad" 			returnvariable="LB_Cantidad" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Importe" 			default="Importe" 			returnvariable="LB_Importe" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Resultado" 		default="Resultado" 		returnvariable="LB_Resultado" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Totales" 			default="Totales" 			returnvariable="LB_Totales" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_SubTotal" 		default="Sub Total" 		returnvariable="LB_SubTotal" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />

<cfinvoke key="MSG_Debe_Seleccionar_al_menos_un_concepto" 		default="Debe Seleccionar al menos un Concepto de Pago tipo Cálculo" 		returnvariable="MSG_Debe_Seleccionar_al_menos_un_concepto" 			component="sif.Componentes.Translate" method="Translate">


<cfset filtro1 = ''>
<cfset filtro2 = ''>

<cfset CFagrup=false>
<cfif isdefined("form.CFagrupamiento")>
	<cfset CFagrup=true>
</cfif>

<cfset listaCF=0>
<cfif form.RDform eq 1>
	<cfif len(trim(form.Ocodigo))>
		<cfquery datasource="#session.dsn#" name="rsOf">
			select CFid
			from CFuncional
			where Ecodigo = #session.Ecodigo#
			and Ocodigo = #trim(form.Ocodigo)#
		</cfquery>
		<cfif len(trim(rsOf.CFid))>
			<cfset  listaCF=valuelist(rsOf.CFid)>
		</cfif>
	</cfif>
<cfelse>
	<cfif len(trim(form.CFid))>
		<cfquery datasource="#session.dsn#" name="rsCF">
			select CFpath, CFid
			from CFuncional
			where CFid = #form.CFid#
		</cfquery>
	
		<cfif isdefined("form.dependencias")>
			<cfquery datasource="#session.dsn#" name="rsCF">
				select CFid
				from CFuncional
				where Ecodigo =#session.Ecodigo#
				and CFpath like '%#rsCF.CFpath#%'
			</cfquery>
		</cfif>
		<cfset listaCF=valuelist(rsCF.CFid)>
	</cfif>
</cfif>
 

<cfif isdefined("form.CIid") and len(trim(form.CIid))> 
	<cf_dbtemp name="TempPrestacionesPorPagar" returnvariable="PrestacionesPorPagar" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid" 			type="numeric"			mandatory="no">
		<cf_dbtempcol name="CFid" 			type="numeric"			mandatory="no">
		<cf_dbtempcol name="identificacion"	type="varchar(100)"		mandatory="no">
		<cf_dbtempcol name="nombre" 		type="varchar(100)"		mandatory="no">
		<cf_dbtempcol name="apellido1"		type="varchar(160)" 	mandatory="no">
		<cf_dbtempcol name="apellido2"		type="varchar(160)" 	mandatory="no">
		<cf_dbtempcol name="CFcodigo"		type="varchar(50)" 		mandatory="no">
		<cf_dbtempcol name="CFdescripcion"	type="varchar(160)" 	mandatory="no">
		<cf_dbtempcol name="Importe"		type="money"			mandatory="no">
		<cf_dbtempcol name="Cantidad"		type="float"			mandatory="no">
		<cf_dbtempcol name="Resultado"		type="money"			mandatory="no">
		<cf_dbtempcol name="LTdesde"		type="date"				mandatory="no">
		<cf_dbtempcol name="LThasta"		type="date"				mandatory="no">
		<cf_dbtempcol name="RHTid"			type="numeric" 			mandatory="no">
		<cf_dbtempcol name="RHJid"			type="numeric" 			mandatory="no">
		<cf_dbtempcol name="Tcodigo"		type="varchar(50)" 		mandatory="no">
		<cf_dbtempcol name="Ecodigo"		type="numeric" 			mandatory="no">
	</cf_dbtemp>

	
	<cfinvoke key="LB_ReporteDePrestacionesLegalesPorPagar" default="Reporte de Prestaciones Legales por Pagar" returnvariable="LB_ReporteDePrestacionesLegalesPorPagar" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_FechaCorte" default="Fecha de Corte" returnvariable="LB_FechaCorte" component="sif.Componentes.Translate" method="Translate">
		
	<!--- Encabezado del reporte--->
		<table id="tbIlusion" width="98%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td colspan="8">
				<table width="98%" cellpadding="0" cellspacing="0" align="center">
					<tr><td>					
						<cfset filtro1 = '#LB_FechaCorte#: '&LSDateFormat(form.FechaCorte,'dd/mm/yyyy')>
						
						<cf_EncReporte
							Titulo="#LB_ReporteDePrestacionesLegalesPorPagar#"
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
		
		
		<cfset LvarFileName = "PrestacionesLegalesPorPagar#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		
		<cf_htmlReportsHeaders 
		title="#LB_ReporteDePrestacionesLegalesPorPagar#" 
		filename="#LvarFileName#"
		irA="RepPrestacionesLegalesPorPagar.cfm">
		
		<table id="tbIlusion2" width="98%" cellpadding="0" cellspacing="0" align="center" style=" display:none">
		<tr>
			<td colspan="8" nowrap="nowrap">
				<cfset filtro1 = '#LB_FechaCorte#: '&LSDateFormat(form.FechaCorte,'dd/mm/yyyy')>
						
				<cf_EncReporte
					Titulo="#LB_ReporteDePrestacionesLegalesPorPagar#"
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
		Insert into #PrestacionesPorPagar#(
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
		<cfif listaCF neq 0>
			and e.CFid in (#listaCF#)
		</cfif>
	</cfquery>
	
	<!--- Concepto de pago --->
	<cfquery name="rsConcepto" datasource="#session.DSN#">
		select a.CIid,coalesce(c.CIcantidad,0) as CIcantidad, coalesce(c.CIrango,0) as CIrango, c.CItipo, c.CIcalculo, c.CIdia as CIdia, c.CImes as CImes
			   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto, CImultiempresa 
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
			select * from #PrestacionesPorPagar#
		</cfquery>
		
		<cfif rsEmpleados.recordCount GT 0>
			<cfflush interval="10">

			<cfset FechaForm = CreateDate(ListGetAt(form.FechaCorte,3,'/'), ListGetAt(form.FechaCorte,2,'/'), ListGetAt(form.FechaCorte,1,'/'))>			
			<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>			
			
			<cfset contador = 0>
			<cfloop query="rsEmpleados">
				<cfset contador= contador + 1>			
				<script language="javascript" type="text/javascript">
					<cfif contador MOD 2 EQ 0>
						document.getElementById("ilusion").value="";
					<cfelse>
						document.getElementById("ilusion").value = 'En proceso...';
					</cfif> 
				</script>
				
				<cfscript>	
            	current_formulas = rsConcepto.CIcalculo;
				presets_text = RH_Calculadora.get_presets(
											Fecha1_Accion 			= FechaForm,
											Fecha2_Accion 			= FechaForm,
											Cicantidad 				= rsConcepto.CIcantidad,	
											CIrango					= rsConcepto.CIrango,
											Citipo					=rsConcepto.CItipo,
											DEid					=rsEmpleados.DEid,
											RHJid					=rsEmpleados.RHJid,
											Ecodigo					=rsEmpleados.Ecodigo,
											RHTid					=rsEmpleados.RHTid,
											RHAlinea				=0,					
											Cidia					=rsConcepto.CIdia,	
											Cimes					=rsConcepto.CImes,	
											Tcodigo					=rsEmpleados.Tcodigo,
											calc_promedio			=FindNoCase('SalarioPromedio', current_formulas),
											masivo					='false',			
											tablaTemporal			='',		
											calc_diasnomina			=FindNoCase('DiasRealesCalculoNomina', current_formulas),
											cantidad				=0,					
											origen					='LineaTiempo', 				
											Cisprango				=rsConcepto.CIsprango,
											Cispcantidad			=rsConcepto.CIspcantidad,
											Cimescompleto			=rsConcepto.CImescompleto,
											Ciid					=rsConcepto.CIid,
											TablaComponentes		='DLineaTiempo',
											CampoMontoTC			='DLTmontores',
											CampoLlaveTC			='LTid',
											ValorLlaveTC			=0,	
											VacacionesProyectadas	='true',
											CImultiempresa = rsConcepto.CImultiempresa
											);
				values = RH_Calculadora.calculate( presets_text & ";" & current_formulas );
				
				</cfscript>
				
			
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
					Update #PrestacionesPorPagar# 
						set Importe = <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
							Cantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
							Resultado = <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
				</cfquery>
				
			</cfloop> <!---fin de calculos--->
			
			<script language="javascript" type="text/javascript">
				document.getElementById("tbIlusion").style.display="none";
				document.getElementById("tbIlusion2").style.display="";
			</script>
		</cfif> 
		<!-------------------------------------------------------Pintado del reporte ----------------------------------------------->
		
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select * from  #PrestacionesPorPagar#
					<cfif CFagrup>
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
								<cfif not CFagrup>
								<tr>
									<cfoutput>
									<td valign="top" style="border-bottom:1px solid black;"><strong>#LB_Identificacion#</strong></td>
									<td valign="top" style="border-bottom:1px solid black;"><strong>#LB_Nombre#</strong></td>
									
									<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap"><strong>#LB_Centro_Funcional#</strong></td>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										&nbsp;&nbsp;&nbsp;<strong>#LB_Cantidad#</strong>
									</td>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										&nbsp;&nbsp;&nbsp;<strong>#LB_Importe#</strong>
									</td>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										&nbsp;&nbsp;&nbsp;<strong>#LB_Resultado#</strong>
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
									
									<cfif CFagrup>
										
										<cfif cfidAct NEQ rsDatos.CFid>
											
											<cfif cfidAct NEQ -1>							
												<!---subTotales del centro Funcional Anterior --->
												<tr>
													<td colspan="<cfif not CFagrup>3<cfelse>2</cfif>" align="right"><strong>#LB_SubTotal#:&nbsp;</strong></td>
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
												<td colspan="<cfif not CFagrup>8<cfelse>7</cfif>" bgcolor="##F0F0F0">#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
											</tr>
											
											<!---etiquetas--->
											<tr>
												<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap"><strong>#LB_Identificacion#</strong></td>
												
												<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap"><strong>#LB_Nombre#</strong></td>
												<cfif not CFagrup>
												<td valign="top" style="border-bottom:1px solid black;" nowrap="nowrap" nowrap="nowrap" ><strong>#LB_Centro_Funcional#</strong></td>
												</cfif>
												<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
													&nbsp;&nbsp;&nbsp;<strong>#LB_Cantidad#</strong>
												</td>
												<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
													&nbsp;&nbsp;&nbsp;<strong>#LB_Importe#</strong>
												</td>
												<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
													&nbsp;&nbsp;&nbsp;<strong>#LB_Resultado#</strong>
												</td>
											</tr>	
										</cfif>
										
									</cfif>
									<!---Pintado de corte por centro funcional--->
									<tr>
										<td nowrap="nowrap">#rsDatos.identificacion#</td>
										<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.apellido1#&nbsp;#rsDatos.apellido2# &nbsp; #rsDatos.nombre#</td>
										<cfif not CFagrup>
										<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
										</cfif>
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
								<cfif CFagrup>
									<tr>
										<cfoutput>
										<td colspan="<cfif not CFagrup>3<cfelse>2</cfif>" align="right"><strong>#LB_SubTotal#:&nbsp;</strong></td>
										<td align="right">
											<strong style="border-top: 1px solid black;">
													#LSCurrencyFormat(vn_subtotalproy,'none')#
											</strong>
										</td>
										<td align="right">
											<strong style="border-top: 1px solid black;">
											#LSCurrencyFormat(vn_subtotalSalVac,'none')#
											</strong>
										</td>
										<td align="right">
											<strong style="border-top: 1px solid black;">
											#LSCurrencyFormat(vn_subtotalVacPag,'none')#
											</strong>
										</td>
										</cfoutput>
									</tr>
									<tr>
										<td colspan="<cfif not CFagrup>8<cfelse>7</cfif>"valign="top" style="border-bottom:1px solid black;">&nbsp;</td>
									</tr>
								</cfif>
								<tr>
									<cfoutput>
									<td colspan="<cfif not CFagrup>3<cfelse>2</cfif>" align="right"><strong>#LB_Totales#:&nbsp;</strong></td>
									<td align="right">
									<strong style="border-top: 1px solid black;">
											#LSCurrencyFormat(vn_totalproy,'none')#
									</strong>
									</td>
									<td align="right">
									<strong style="border-top: 1px solid black;">
											#LSCurrencyFormat(vn_totalSalVac,'none')#
									</strong>
									</td>
									<td align="right">
									<strong style="border-top: 1px solid black;">
											#LSCurrencyFormat(vn_totalVacPag,'none')#
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
		<cfthrow message="#MSG_Debe_Seleccionar_al_menos_un_concepto#">
	</cfif>
	
</cfif>


