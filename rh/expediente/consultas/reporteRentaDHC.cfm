<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_de_Renta_DHC"
	Default="Reporte de Renta (DHC)"
	returnvariable="LB_Reporte_de_Renta_DHC"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_de_Renta"
	Default="Reporte de Renta"
	returnvariable="LB_Reporte_de_Renta"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Periodo"
	Default="Per&iacute;odo"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Periodo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tabla_de_Renta"
	Default="Tabla de Renta"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Tabla_de_Renta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identifiaci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Identificacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MesesLaborados"
	Default="Meses Laborados"
	returnvariable="LB_MesesLaborados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SalariosRecibidos"
	Default="Salarios Recibidos"
	returnvariable="LB_SalariosRecibidos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SalariosRecibidosXIIIMes"
	Default="Salarios Recibidos XIII Mes"
	returnvariable="LB_SalariosRecibidosXIIIMes"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExoneracionFija"
	Default="Exoneracion Fija"
	returnvariable="LB_ExoneracionFija"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExoneracionSeguroEducativo"
	Default="Exoneraci&oacute;n Seguro Educativo"
	returnvariable="LB_ExoneracionSeguroEducativo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExoneracionDependientes"
	Default="Exoneraci&oacute;n por Dependientes"
	returnvariable="LB_ExoneracionDependientes"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RentaReal"
	Default="Renta Real"
	returnvariable="LB_RentaReal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RentaRetenida"
	Default="Renta Retenida"
	returnvariable="LB_RentaRetenida"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontraronRegistros"
	Default="No se encontraron registros"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_NoSeEncontraronRegistros"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MGS_FinDelReporte"
	Default="Fin del reporte"
	xmlfile="/rh/generales.xml"
	returnvariable="MGS_FinDelReporte"/>	

<cf_htmlReportsHeaders 	irA="reporteRentaDHC-filtro.cfm"
						FileName="Reporte_de_Renta_DHC.xls"
						title="#LB_Reporte_de_Renta_DHC#">



<cf_templatecss>

<cfquery name="rsIRs" datasource="sifcontrol">
	select a.EIRid, 
		<cf_dbfunction name="date_part" args="mm,a.EIRdesde"> as mesDesde,
		<!--- datepart(mm,a.EIRdesde) as mesDesde, --->
		<cf_dbfunction name="date_part" args="yy,a.EIRdesde"> as periodoDesde,
		<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
		<cf_dbfunction name="date_part" args="mm,a.EIRhasta"> as mesHasta,
		<!--- datepart(mm,a.EIRhasta) as mesHasta,  --->
		<cf_dbfunction name="date_part" args="yy,a.EIRhasta"> as periodoHasta,
		<!--- datepart(yy,a.EIRhasta) as periodoHasta,  --->
		b.IRcodigo, 
		b.IRdescripcion, a.EIRdesde, a.EIRhasta
	from EImpuestoRenta a
		inner join ImpuestoRenta b
		on a.IRcodigo = b.IRcodigo
	where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
</cfquery>

<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<cfoutput>
	<tr>
		<td colspan="24">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td>
					<cf_EncReporte
						Titulo="#LB_Reporte_de_Renta#"
						Color="##E3EDEF"
						filtro1="#LB_Tabla_de_Renta#: #rsIRs.IRcodigo# - #rsIRs.IRdescripcion#"
						filtro2="#LB_Periodo#: #LSDateFormat(rsIRs.EIRdesde, 'dd/mm/yyyy')# - #LSDateFormat(rsIRs.EIRhasta, 'dd/mm/yyyy')#"
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<!-----========================== ENCABEZADO ANTERIOR ==========================
	<tr><td colspan="24" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
	<tr><td colspan="24" align="center"><strong>#LB_Reporte_de_Renta#</strong></td></tr>
	<tr><td colspan="24" align="center"><strong>#LB_Tabla_de_Renta#:</strong> #rsIRs.IRcodigo# - #rsIRs.IRdescripcion#</td></tr>
	<tr><td colspan="24" align="center"><strong>#LB_Periodo#:</strong> #LSDateFormat(rsIRs.EIRdesde, 'dd/mm/yyyy')# - #LSDateFormat(rsIRs.EIRhasta, 'dd/mm/yyyy')#</td></tr>
	----->
	</cfoutput>
</table>

	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     				type="numeric"  mandatory="yes">
		<cf_dbtempcol name="EIRid"     				type="numeric"  mandatory="yes">		
		<cf_dbtempcol name="desde"     				type="datetime"	mandatory="no">
		<cf_dbtempcol name="hasta"     				type="datetime" mandatory="no">
		<cf_dbtempcol name="meses_laborados"		type="float" 	mandatory="no">
		<cf_dbtempcol name="salario"				type="money" 	mandatory="no">
		<cf_dbtempcol name="xiii"					type="money" 	mandatory="no">
		<cf_dbtempcol name="exoneracion_fija"		type="money" 	mandatory="no">
		<cf_dbtempcol name="exoneracion_educativo"	type="money" 	mandatory="no">
		<cf_dbtempcol name="dependientes"			type="money" 	mandatory="no">
		<cf_dbtempcol name="renta_retenida"			type="money" 	mandatory="no">
		<cf_dbtempcol name="renta_real"			type="money" 	mandatory="no">
		<cf_dbtempcol name="salario_real"			type="money" 	mandatory="no">
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>

	<cf_dbtemp name="CFiscal" returnvariable="CFiscal">
		<cf_dbtempcol name="DEid"     				type="numeric"  mandatory="yes">
		<cf_dbtempcol name="CDid"     				type="numeric"  mandatory="yes">		
		<cf_dbtempcol name="valor"					type="money" 	mandatory="no">
		<cf_dbtempcol name="esporcentaje"			type="int" 		mandatory="no">
		<cf_dbtempcol name="desde"     				type="datetime"	mandatory="no">
		<cf_dbtempcol name="hasta"     				type="datetime" mandatory="no">
		<cf_dbtempcol name="factor"					type="int" 		mandatory="no">		
	</cf_dbtemp>

	<cf_dbtemp name="nominas" returnvariable="nominas">
		<cf_dbtempcol name="RCNid"     				type="numeric"  mandatory="yes">
		<cf_dbtempcol name="DEid"     				type="numeric"  mandatory="yes">
		<cf_dbtempcol name="Tcodigo"   				type="char(5)"  mandatory="yes">		
		<cf_dbtempcol name="tipo"					type="int" 		mandatory="no">
		<cf_dbtempcol name="cant_nominas"			type="int" 		mandatory="no">
		<cf_dbtempcol name="periodo"   				type="int"		mandatory="no">
		<cf_dbtempcol name="mes"     				type="int" 		mandatory="no">
	</cf_dbtemp>
	
	<!--- empleados activos en el periodo de tiempo de la tabla de renta  --->
	<cfquery datasource="#session.DSN#">
		insert into #salida#(DEid, EIRid)
		select distinct lt.DEid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
		from LineaTiempo lt
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#">
		and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
	</cfquery>
	
	<!--- actualiza las fechas en que el empleado estuvo activo en el rango de fechas de la tabla de renta --->
	<cfquery datasource="#session.DSN#"	>
		update #salida#
		set desde = 	(
							select 	(	case 
											when ( 	select min(LTdesde) 
													from LineaTiempo ltd 
													where ltd.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#"> 
													  and ltd.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
													and ltd.DEid=a.DEid
												 )  <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
											else ( 	select min(LTdesde) 
													from LineaTiempo ltd 
													where ltd.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#"> 
													  and ltd.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
													and ltd.DEid=a.DEid
												 )
										end
									)
							from #salida# a
							where a.DEid=#salida#.DEid
						),
			hasta =	(	select	(	case 
										when ( 	select max(LThasta) 
												from LineaTiempo ltd 
												where ltd.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#"> 
												  and ltd.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
												and ltd.DEid=a.DEid
											 )  >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#">  then <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#">  
										else ( 	select max(LThasta) 
												from LineaTiempo ltd 
												where ltd.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#"> 
												  and ltd.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
												and ltd.DEid=a.DEid
											)
									end
								) 
						from #salida# a
						where a.DEid=#salida#.DEid
					)
	</cfquery>
	
	<!--- meses laborados --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set meses_laborados = <cf_dbfunction name="datediff" args="desde,hasta,mm" >
	</cfquery>
	
	<!--- salario bruto del empleado recibido durante el periodo de la tabla de renta--->
	<cfset fecha1 = (datepart('yyyy', rsIRs.EIRdesde)*100+ datepart('m', rsIRs.EIRdesde))*100+1 >
	<cfset fecha2 = (datepart('yyyy', rsIRs.EIRhasta)*100+ datepart('m', rsIRs.EIRhasta))*100+1 >
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario = 	(	select sum(a.SEsalariobruto)
							from HSalarioEmpleado a, CalendarioPagos cp, #salida# s
							where s.DEid=#salida#.DEid
							  and cp.CPid=a.RCNid
							   and cp.CPtipo = 0
							   and s.DEid=a.DEid
							   and ((cp.CPperiodo*100+cp.CPmes)*100+1) between <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha2#">
						)	
	</cfquery>

	<!--- Incidencias asociadas al salario en el tiempo de la tabla de renta--->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario = coalesce(salario,0) + coalesce(
												(	select sum(ICmontores)							
													from HIncidenciasCalculo i, CalendarioPagos cp, CIncidentes ci
													where cp.CPid=i.RCNid
													   and ci.CIid=i.CIid
													   and ci.CInorenta = 0
													   and cp.CPtipo = 0
						  	         				   and i.DEid=#salida#.DEid
							         				   and ((cp.CPperiodo*100+cp.CPmes)*100+1) between <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha2#">

						  	         				   and i.CIid in (	select a.CIid
																		from RHReportesNomina c
																			
																		inner join RHColumnasReporte b
																		on b.RHRPTNid = c.RHRPTNid
																		and b.RHCRPTcodigo = 'SR'
												
																		inner join RHConceptosColumna a
																		on a.RHCRPTid = b.RHCRPTid
																			
																		where c.RHRPTNcodigo = 'RENTA'
																		  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
																	 )
												)					 
											, 0)
	</cfquery>
	
	<!--- salarios recibidos por decimo tercer mes--->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set xiii = ( 	select sum(i.ICmontores)
						from HIncidenciasCalculo i, CalendarioPagos cp, CIncidentes ci
						where cp.CPid=i.RCNid
						  and i.DEid=#salida#.DEid
						  and ci.CIid=i.CIid
						  and cp.CPtipo = 1
						  and ci.CInorenta = 0
						  and ((cp.CPperiodo*100+cp.CPmes)*100+1) between <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha2#">
						  and i.CIid in (	select a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
												on b.RHRPTNid = c.RHRPTNid
												and b.RHCRPTcodigo = 'SRXIII'
					
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
												
											where c.RHRPTNcodigo = 'RENTA'
											  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
				)
	</cfquery>
	
	<!--- exoneracion fija --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set exoneracion_fija = 800
	</cfquery>

	<!--- seguro educativo --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set exoneracion_educativo = 1.25
	</cfquery>

	<!--- familiares --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set dependientes = (  	select sum(b.DCDvalor )
								from FEmpleado a, ConceptoDeduc e, DConceptoDeduc b
								
								where a.FEdeducrenta = 1
								  and e.CDid = a.FEidconcepto	
								  and b.CDid = e.CDid
								  and b.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
								
								  and a.FEdeducdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#">
								  and a.FEdeduchasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
								  and a.DEid=#salida#.DEid )
	</cfquery>


	<!--- renta retenida --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set renta_retenida = 	(	select sum(a.SErenta)
									from HSalarioEmpleado a, CalendarioPagos cp
									where a.DEid=#salida#.DEid
									  and cp.CPid=a.RCNid
									   and ((cp.CPperiodo*100+cp.CPmes)*100+1) between <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha2#">
								)	
	</cfquery>
	
	<!--- =================================================== --->
	<!--- CALCULO DE RENTA REAL inicio						  --->
	<!--- =================================================== --->

	<!--- 1. Salarios recibidos durante el anno (calculo ya hecho, campo salario ) --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_real = coalesce(salario, 0)
	</cfquery>

	<!--- 2. a salario anual restar seguro educativo 1.25  --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_real = salario_real - ( salario_real * (coalesce(exoneracion_educativo, 0)/100) )
	</cfquery>

	<!--- 3. al resultado de 2, sumar los salarios por decimotercer mes recibidos (ya esta calculado, columna xiii) --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_real = salario_real + coalesce(xiii, 0)
	</cfquery>
	
	<!--- 4. a resultado de 3 se resta la exoneracion fija --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_real = salario_real - exoneracion_fija
	</cfquery>

	<!--- 5. CALCULO DE CREDITOS FISCALES. Se deben restar lo screditos fiscales al monto resultante hasta el punto 4 --->
	<cfquery datasource="#session.DSN#">
		insert into #CFiscal#(DEid, CDid, valor, esporcentaje, desde, hasta, factor)
		select 	a.DEid, 
				b.CDid,
			  	b.DCDvalor, 
			  	b.esporcentaje,
				case  when  a.FEdeducdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#"> else a.FEdeducdesde end	 as desde,
				case  when  a.FEdeduchasta > <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#"> else a.FEdeduchasta end as hasta,
				( select IRfactormeses from ImpuestoRenta where IRcodigo = e.IRcodigo) 
		
		from FEmpleado a, ConceptoDeduc e, DConceptoDeduc b
		
		where a.FEdeducrenta = 1
		  and e.CDid = a.FEidconcepto	
		  and b.CDid = e.CDid
		  and b.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
		
		  and a.FEdeducdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRhasta#">
		  and a.FEdeduchasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsIRs.EIRdesde#">
	</cfquery>
	<cfquery datasource="#session.DSN#"	>
		insert into #nominas# (RCNid, DEid, Tcodigo, tipo, cant_nominas, periodo, mes)

		select 	a.RCNid, 
				a.DEid, 
				cp.Tcodigo,  
				tn.Ttipopago, 
				( 	select count(1) 
					from CalendarioPagos cp1 
					where cp1.CPperiodo = cp.CPperiodo 
				 	  and cp1.CPmes=cp.CPmes
				  	  and cp1.Tcodigo=cp.Tcodigo  ) as nominas,
				cp.CPperiodo,
				cp.CPmes
		
		from HSalarioEmpleado a, CalendarioPagos cp, TiposNomina tn

		where cp.CPid = a.RCNid
		  and tn.Tcodigo = cp.Tcodigo
		  and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ((cp.CPperiodo*100+cp.CPmes)*100+1) between <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#fecha2#">
	</cfquery>

	<!--- resta los creditos fiscales --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_real =  salario_real - coalesce(( 	select 	sum((case when a.factor = 12 then round((a.valor/12.00),2) else round(a.valor, 2) end)/b.cant_nominas)
														from #CFiscal# a, #nominas# b
														where b.DEid=a.DEid
														  and a.DEid=#salida#.DEid
														  and a.CDid not in (  	select CDid
																				from RHExcluirCFiscal
																				where CPid = b.RCNid )
										   ), 0)
	</cfquery>
	
	<!--- 6. Calculo de la renta --->
	<cfquery datasource="#session.DSN#" >
		update #salida#
		set renta_real = (	select ((#salida#.salario_real-DIRinf)*(DIRporcentaje/100))+DIRmontofijo
							from DImpuestoRenta a, #salida# b
							where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
							and #salida#.salario_real between DIRinf and DIRsup	
							and b.EIRid=a.EIRid
							and b.DEid=#salida#.DEid
						 )	
	</cfquery>
	
	<!--- =================================================== --->
	<!--- CALCULO DE RENTA REAL FIN							  --->
	<!--- =================================================== --->
	
	<!--- salida de datos --->
	<cfquery name="data" datasource="#session.DSN#">
		select 	s.DEid, 
				de.DEidentificacion as id, 
				de.DEnombre as nombre, 
				de.DEapellido1 as apellido1, 
				de.DEapellido2 as apellido2,
				s.meses_laborados,
				coalesce(salario, 0) as salario,
				coalesce(renta_real, 0) as renta_real,
				coalesce(xiii, 0) as xiii,
				coalesce(exoneracion_fija, 0) as fija,
				coalesce(exoneracion_educativo, 0) as educativo,
				coalesce(dependientes, 0) as dependientes,
				coalesce(renta_retenida, 0) as renta_retenida
				
		from #salida# s, DatosEmpleado de
		
		where de.DEid= s.DEid
		  and s.salario  > 0
		order by de.DEapellido1, de.DEapellido2, de.DEnombre

	</cfquery>
	<br>
	<table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">
		<cfoutput>
		<tr>
			<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong></td>
			<td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong></td>
			<td  class="tituloListas" valign="top" align="center" ><strong>#LB_MesesLaborados#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_SalariosRecibidos#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_SalariosRecibidosXIIIMes#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_ExoneracionFija#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_ExoneracionSeguroEducativo#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_ExoneracionDependientes#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_RentaReal#</strong></td>
			<td  class="tituloListas" valign="top" align="right" ><strong>#LB_RentaRetenida#</strong></td>
		</tr>
		</cfoutput>
	
		<cfoutput query="data">
			<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td nowrap>#data.apellido1# #data.apellido2# #data.nombre#</td>
				<td nowrap>#data.id#</td>
				<td nowrap align="center">#data.meses_laborados#</td>
				<td nowrap align="right">#LSNumberFormat(data.salario, ',9.00')#</td>
				<td nowrap align="right">#LSNumberFormat(data.xiii, ',9.00')#</td>
				<td nowrap align="right">#LSNumberFormat(data.fija, ',9.00')#</td>
				<td nowrap align="right">#LSNumberFormat(data.educativo, ',9.00')#%</td>
				<td nowrap align="right">#LSNumberFormat(data.dependientes, ',9.00')#</td>
				<td nowrap align="right">#LSNumberFormat(data.renta_real, ',9.00')#</td>				
				<td nowrap align="right">#LSNumberFormat(data.renta_retenida, ',9.00')#</td>
			</tr>
		</cfoutput>

		<cfoutput>
		<cfif data.recordcount gt 0 >
			<tr><td colspan="10" align="center">--- #MGS_FinDelReporte# ---</td></tr>
		<cfelse>	
			<tr><td colspan="10" align="center"><strong>- #MSG_NoSeEncontraronRegistros# -</strong></td></tr>
		</cfif>
		</cfoutput>
	
	</table>
	