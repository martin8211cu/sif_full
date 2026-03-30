<cfinvoke key="LB_CentroFuncional" 	default="Centro Funcional" returnvariable="LB_CentroFuncional" 		component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_Identificacion" 	default="Identificación" 	returnvariable="LB_Identificacion" 		component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_Nombre" 			default="Nombre" 			returnvariable="LB_Nombre" 				component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Centro_Funcional" default="Centro Funcional" 	returnvariable="LB_Centro_Funcional" 	component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Monto_Total" 		default="Monto Total" 		returnvariable="LB_Monto_Total" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_Totales" 			default="Totales" 			returnvariable="LB_Totales" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />
<cfinvoke key="LB_SubTotal" 		default="Sub Total" 		returnvariable="LB_SubTotal" 			component="sif.Componentes.Translate" method="Translate"  XmlFile="/rh/generales.xml" />

<cfset CFagrup=false>
<cfif isdefined("form.CFagrupamiento")>
	<cfset CFagrup=true>
</cfif>

<cfset listaCF=0>
<cfset listaCIid=0>

<cfset listaNominas=0>

<cfif form.RDfiltro eq 1><!---- por periodo mes--->
	<cfquery datasource="#session.dsn#" name="rsNominas">
		select CPid
		from CalendarioPagos
		where CPmes = #form.mes#
		and CPperiodo = #form.periodo#
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif len(trim(rsNominas.CPid))>
		<cfset listaNominas = valuelist(rsNominas.CPid)>
	</cfif>
	
<cfelseif form.RDfiltro eq 2><!---- por rango de fechas--->
	<cfset pre='H'>
	<cfquery datasource="#session.dsn#" name="rsNominas" >
		select cp.CPid, CPhasta, CPdesde
		from CalendarioPagos cp
			inner join #PRE#RCalculoNomina hr
				on cp.CPid =  hr.RCNid
				and cp.Ecodigo = hr.Ecodigo
		where cp.Ecodigo = #session.Ecodigo#
		and CPhasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.FechaDesde#">
		and CPdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.FechaHasta#">
		<cfif isdefined("form.TCODIGO10") and len(trim(form.TCODIGO10))>
			and cp.Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.TCODIGO10#">)
		</cfif>
	</cfquery>
	
	<cfif len(trim(rsNominas.CPid))>
		<cfset listaNominas =valueList(rsNominas.CPid)>
	</cfif>	
		
	<cfelseif form.RDfiltro eq 3><!---- por nominas--->
		<cfif len(trim(form.CPID11))>
			<cfset listaNominas = ListAppend(listaNominas,form.CPID11)>
		</cfif>
		<cfif isdefined("LISTATCODIGOCALENDARIO11") and len(trim(form.LISTATCODIGOCALENDARIO11))>
			<cfset listaNominas = ListAppend(listaNominas,form.LISTATCODIGOCALENDARIO11)>
		</cfif>	
	</cfif>


	<cfif isdefined("form.CIid20") and len(trim(form.CIid20))>
	 <cfset listaCIid =form.CIid20>
	</cfif>
	
	<cfif isdefined("form.LISTACONCEPTOPAGO20") and len(trim(form.LISTACONCEPTOPAGO20))>
		 <cfif listaCIid eq 0>
			 <cfset listaCIid = form.LISTACONCEPTOPAGO20>
		 <cfelse>
		 		<cfif ListFind(form.LISTACONCEPTOPAGO20,listaCIid)>
					<cfset form.LISTACONCEPTOPAGO20 = ListDeleteAt(form.LISTACONCEPTOPAGO20, ListFind(form.LISTACONCEPTOPAGO20,listaCIid))>
				</cfif>
			 <cfset listaCIid = listappend(listaCIid,form.LISTACONCEPTOPAGO20)>
		 </cfif>
	</cfif>
	
	<cfset listaCIid =  ListSort(listaCIid,"Numeric", "asc")>
	
	<cfif isdefined("form.CFid") and len(trim(form.CFid))>
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
	
	<cfif listaCIid neq 0>
		<cfquery datasource="#session.dsn#" name="rsIncidencias">
			select CIid, CIcodigo, CIdescripcion
			from CIncidentes
			where Ecodigo=#session.Ecodigo#
				and CIid in (#listaCIid#)
				order by CIid asc
		</cfquery> 
	</cfif>	
										
	<!--- Optiene el o los empleados y centro funcional--->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  		
		   hse.DEid,
		   b.DEidentificacion,
		   b.DEnombre,
		   b.DEapellido1,
		   b.DEapellido2,
		   	sum(hse.SEsalariobruto) as bruto
			<cfif listaCIid neq 0><!---- si se agregan conceptos se tiran sumatoria para cada uno, 
									Nota Sybase soporta hasta 50 tablas, pero este reporte no debería completar tantas columnas
									En tal caso se pasaría a una temporal
								---->
				<cfloop query="rsIncidencias">
					,coalesce(
								(
									select sum(ICmontores)
									from HIncidenciasCalculo hic
									where hic.DEid = hse.DEid
										<cfif listaNominas neq 0>
											and hic.RCNid in (#listaNominas#)
										</cfif>
										and hic.CIid = #CIid#	
								)
							,0)	 as CIid#CIid#	
				</cfloop>		
			<cfelse><!---- si no se agregan conceptos se tiran todos lo montos---->
				,coalesce(
							(
								select sum(ICmontores)
								from HIncidenciasCalculo hic
								where hic.DEid = hse.DEid
									<cfif listaNominas neq 0>
										and hic.RCNid in (#listaNominas#)
									</cfif>
									<cfif listaCIid neq 0>
										and hic.RCNid in (#listaCIid#)
									</cfif>
							)
						,0)	 as incidencias			
			</cfif>		
		from HSalarioEmpleado hse
			inner join DatosEmpleado b
				on hse.DEid = b.DEid
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif listaNominas neq 0>
		and hse.RCNid in (#listaNominas#)
		</cfif>
		<cfif listaCF neq 0>
			and e.CFid in (#listaCF#)
		</cfif>
		<cfif CFagrup>
			order by CFcodigo,CFdescripcion,DEapellido1,DEapellido2,DEnombre
		<cfelse>
			group by b.DEidentificacion, b.DEnombre,b.DEapellido1, b.DEapellido2,hse.DEid
			order by b.DEidentificacion, b.DEnombre,b.DEapellido1, b.DEapellido2
		</cfif>
	</cfquery>
 
 <cfif not isdefined("form.chkIncluirSB")>
 	<cfset columnas = rsDatos.columnlist>
	<cfset pos = listfindnocase(columnas,'BRUTO')>
	<cfset columnas =  ListDeleteAt(columnas, pos)>
	<cfquery dbtype="query" name="rsDatos">
		select #columnas#,0 as bruto
		from rsDatos
	</cfquery>
 </cfif>

		<cfinvoke key="LB_ReporteDeResumenDePagos" default="Reporte de Resúmen de Pagos" returnvariable="LB_ReporteDeResumenDePagos" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="LB_FechaCorte" default="Fecha de Corte" returnvariable="LB_FechaCorte" component="sif.Componentes.Translate" method="Translate">
			
		<!--- Encabezado del reporte--->
			<table id="tbIlusion" width="98%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td colspan="8">
					<table width="98%" cellpadding="0" cellspacing="0" align="center">
						<tr><td>					
							
							<cf_EncReporte
								Titulo="#LB_ReporteDeResumenDePagos#"
								Color="##E3EDEF"
								cols = "6">
						</td></tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
			
			
			<cfset LvarFileName = "ResumenDePagos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			
			<cf_htmlReportsHeaders 
			title="#LB_ReporteDeResumenDePagos#" 
			filename="#LvarFileName#"
			irA="RepResumenPagos.cfm">
			
			<table id="tbIlusion2" width="98%" cellpadding="0" cellspacing="0" align="center" style=" display:none">
			<tr>
				<td colspan="8" nowrap="nowrap">
					<cf_EncReporte
						Titulo="#LB_ReporteDeResumenDePagos#"
						Color="##E3EDEF"
						cols = "6">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
		<!--- Fin del Encabezado--->
		<!-------------------------------------------------------Pintado del reporte ----------------------------------------------->
				<cfif rsDatos.RecordCount NEQ 0>
					<table width="98%" cellpadding="3" cellspacing="3" align="center">
					<tr>
						<td colspan="7">
							<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
								<cfif not CFagrup>
								<tr>
									<cfoutput>
									<td valign="top" style="border-bottom:1px solid black;"><strong>#LB_Identificacion#</strong></td>
									<td valign="top" style="border-bottom:1px solid black;"><strong>#LB_Nombre#</strong></td>
									<cfif isdefined("form.chkIncluirSB")>
										<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
											<strong><cf_translate key="LB_Salario_Bruto" xmlFile="/rh/generales.xml">Salario Bruto</cf_translate></strong>
										</td>
									</cfif>
									<cfif listaCIid eq 0>
										<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
											<strong><cf_translate key="LB_Incidencias" xmlFile="/rh/generales.xml">Incidencias</cf_translate></strong>
										</td>
									<cfelse>
										<cfloop query="rsIncidencias">
											<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
												&nbsp;&nbsp;&nbsp;&nbsp;<strong>#rsIncidencias.CIcodigo# - #rsIncidencias.CIdescripcion#<strong>
											</td>
										</cfloop>
										
									</cfif>
									<td valign="top" align="right" width="15%" style="border-bottom:1px solid black;" nowrap="nowrap">
										<strong><cf_translate key="LB_Total" xmlFile="/rh/generales.xml">Total</cf_translate></strong>
									</td>

									</cfoutput>
								</tr>	
								</cfif>
								
								<cfset vn_totalBruto = 0>
								<cfset vn_totalInc = 0>
								<cfset vn_totalRow = 0>
								
								<cfset vn_subtotalBruto = 0>
								<cfset vn_subtotalInc = 0>
								<cfset vn_subtotalliquido = 0>
								
								<cfif listaCIid neq 0>
									<cfloop list="#listaCIid#" index="i">
										<cfset evaluate("total_CIid#i# = 0")> 
									</cfloop>
								</cfif>			
											
								<cfoutput query="rsDatos">										
									<!---Pintado de corte por centro funcional--->
									<tr>
										<td nowrap="nowrap">#rsDatos.DEidentificacion#</td>
										<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#rsDatos.DEapellido1#&nbsp;#rsDatos.DEapellido2# &nbsp; #rsDatos.DEnombre#</td>
										<cfif isdefined("form.chkIncluirSB")>
										<td align="right">#LSCurrencyFormat(rsDatos.bruto,'none')#</td>
										</cfif>
										<cfif listaCIid eq 0>
											<td align="right">#LSCurrencyFormat(rsDatos.incidencias,'none')#</td>
											<td align="right">#LSCurrencyFormat(rsDatos.bruto+rsDatos.incidencias,'none')#</td>
										<cfelse>
											<cfset totalCol=0>
											<cfloop list="#listaCIid#" index="i">
												<cfset temp = evaluate("rsDatos.CIid#i#")>
												<cfset totalCol = totalCol+temp>
												<td align="right">#LSCurrencyFormat(temp,'none')#</td>
												 <cfset evaluate("total_CIid#i# = total_CIid#i# + temp")> 
											</cfloop>
											<td align="right">#LSCurrencyFormat(rsDatos.bruto+totalCol,'none')#</td>

										</cfif>	
									</tr>
									 
									<cfset vn_totalBruto = vn_totalBruto+rsDatos.bruto>
									
									<cfif listaCIid eq 0>
										<cfset vn_totalInc = vn_totalInc+rsDatos.incidencias>
										<cfset vn_totalRow = vn_totalRow+rsDatos.bruto+rsDatos.incidencias>
									</cfif>
									
								</cfoutput>	
								
								<tr>
									<cfoutput>
									<td colspan="<cfif not CFagrup>2<cfelse>1</cfif>" align="right"><strong>#LB_Totales#:&nbsp;</strong></td>
									<cfif isdefined("form.chkIncluirSB")>
										<td align="right">
										<strong style="border-top: 1px solid black;">
												#LSCurrencyFormat(vn_totalBruto,'none')#
										</strong>
										</td>
									</cfif>
										<cfif listaCIid eq 0>
											<td align="right">
											<strong style="border-top: 1px solid black;">
													#LSCurrencyFormat(vn_totalInc,'none')#
											</strong>
											</td>
											<td align="right">
											<strong style="border-top: 1px solid black;">
													#LSCurrencyFormat(vn_totalRow,'none')#
											</strong>
											</td>
										<cfelse>
											<cfset totalConCIid =vn_totalBruto>
											<cfloop list="#listaCIid#" index="i">
												<cfset totalConCIid = totalConCIid+ evaluate("total_CIid#i#")>
												<td align="right">
												<strong style="border-top: 1px solid black;">
														#LSCurrencyFormat( evaluate("total_CIid#i#"),'none')#
												</strong>
												</td>
											</cfloop>	
											<td align="right">
											<strong style="border-top: 1px solid black;">
													#LSCurrencyFormat(totalConCIid,'none')#
											</strong>
											</td>											
										</cfif>
									</cfoutput>
								</tr>				
							</table>
						</td>
					</tr>
				<cfelse>
					<tr><td align="center"><strong>---- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ----</strong></td></tr>	
				</cfif>	
			</table>	
 