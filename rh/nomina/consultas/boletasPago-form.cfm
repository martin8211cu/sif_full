<cf_htmlreportsheaders
	title="Resumen de Boletas de Pago"
	filename="ResumenBoletasPago#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls"
	ira="boletasPago-parametros.cfm"
	method="url">

<cfset prefijo = ''>
<cfif url.tipo eq 'H' >
	<cfset prefijo = 'H'>
	<cfset url.DEidentificacion1 = url.DEidentificacion3>
	<cfset url.DEidentificacion2 = url.DEidentificacion4>
</cfif>

<cfset lVarPagoEfect = 0>
<cfset lVarPagoEsp = 0>
<cfset lVarDiasCP = 0>
<cfset lvarFaltasDias = 0>
<cfset lvarNeto = 0>

<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfquery name="data_centro" datasource="#session.DSN#" >
	select CFcodigo, CFdescripcion, CFpath
	from CFuncional
	where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFidconta#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data_nomina" datasource="#session.DSN#" >
	select RCDescripcion, RCdesde, RChasta
	from #prefijo#RCalculoNomina
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Consultas --->
<cfquery name="rsMensaje" datasource="#session.DSN#">
	select Mensaje
	from MensajeBoleta A
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfsetting enablecfoutputonly="no">
<cfoutput>
	<cf_templatecss>
	<cfsetting requesttimeout="8600">
</cfoutput>
<style>
	@media all {
	   div.saltopagina{
	      display: none;
	   }
	}
	@media print{
	   div.saltopagina{
	      display:block;
	      page-break-before:always;
	   }
	}
</style>

<cfquery name="regPat" datasource="#session.dsn#">
	SELECT
		Pvalor
	FROM
		RHParametros
	WHERE
		Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="300">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery name="isRegOfi" datasource="#session.dsn#">
	select *
	from
		Oficinas
	where Onumpatronal is not null
	OR RTRIM(LTRIM(Onumpatronal)) <> ''
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfif IsDefined('url.DEid3') and Trim(url.DEid3) neq ''>
	<cfset url.DEid1 = url.DEid3>
</cfif>

<cfif IsDefined('url.DEid4') and Trim(url.DEid4) neq ''>
	<cfset url.DEid2 = url.DEid4>
</cfif>

<cfset varRegPat = Trim(regPat.Pvalor)>
	<cfquery name="data" datasource="#session.dsn#">
		select
			de.DEid,
			de.DEidentificacion,
			de.DEtarjeta,
			de.DEnombre,
			de.DEapellido1,
			de.DEapellido2,
			lt.RHPid,
			p.CFidconta,
			cf.CFcodigo,
			cf.CFdescripcion,
			se.SEsalariobruto, <!---, round(coalesce((select coalesce(sum(b.PEmontores) ,0.00) from PagosEmpleado b where se.DEid = b.DEid and rc.RCNid = b.RCNid), 0.00),2) as Componentes--->
			se.SErenta,
			coalesce(DESeguroSocial,'') as DESeguroSocial,
			<cfif varRegPat neq ''>
				'#varRegPat#' as Onumpatronal
			<cfelse>
				coalesce(Onumpatronal,'') as Onumpatronal
			</cfif>
			,RFC
			,concat(LTRIM(RTRIM(p.RHPcodigo)),' ',LTRIM(RTRIM(p.RHPdescripcion))) as Plaza
			,LTRIM(RTRIM(RHPdescpuesto)) as Puesto
			,((select top 1 DLsalario 
				from DLaboralesEmpleado dle
				inner join RHTipoAccion ta on dle.RHTid = ta.RHTid
				and ta.RHTcomportam != 2
				where dle.DEid = lt.DEid 
				and DLfvigencia <= rc.RCHasta
				order by DLfechaaplic desc) / tn.FactorDiasSalario) as SueldoDiario
			,rc.RChasta as FechaPago
			,dep.Ddescripcion
		from #prefijo#RCalculoNomina rc
			inner join #prefijo#SalarioEmpleado se
				on rc.RCNid = se.RCNid
			inner join DatosEmpleado de
				on de.DEid = se.DEid
			inner join LineaTiempo lt
				on se.DEid = lt.DEid
		   	   and lt.Ecodigo = rc.Ecodigo
			   and lt.LThasta = (	select max(lt2.LThasta)
			   						from LineaTiempo lt2
									where lt.DEid = lt2.DEid
									  and lt2.LTdesde < = rc.RChasta
									  and lt2.LThasta > = rc.RCdesde )
			inner join RHPlazas p
				on lt.RHPid = p.RHPid
			   and lt.Ecodigo = p.Ecodigo
			   <cfif not isdefined("url.dependencias") and url.DEid2 LTE 0 and url.DEid2 LTE 0>
				   and p.CFidconta = #url.CFidconta#
			   </cfif>
			inner join RHPuestos pu
				on pu.RHPcodigo = lt.RHPcodigo
				and pu.Ecodigo = lt.Ecodigo
			inner join CFuncional cf
				on cf.CFid=coalesce(p.CFidconta, p.CFid)
				<cfif isdefined("url.dependencias")>
					and cf.CFpath like '#trim(data_centro.CFpath)#%'
				</cfif>
			inner join Oficinas o
				on o.Ocodigo = lt.Ocodigo
				and o.Ecodigo = lt.Ecodigo
			Inner Join Departamentos dep
				on dep.Dcodigo = lt.Dcodigo
				and dep.Ecodigo = lt.Ecodigo
			inner join TiposNomina tn
				on tn.Tcodigo = lt.Tcodigo
				and tn.Ecodigo = lt.Ecodigo
		where rc.Ecodigo = #session.Ecodigo#
		and rc.RCNid = #url.RCNid#
		<cfif IsDefined('url.DEid1') and Trim(url.DEid1) neq '' and IsDefined('url.DEid2') and Trim(url.DEid2) neq ''>
			and de.DEid >= #url.DEid1#
			and de.DEid <= #url.DEid2#
		<cfelseif IsDefined('url.DEid1') and Trim(url.DEid1) neq ''>
			and de.DEid = #url.DEid2#
		<cfelseif IsDefined('url.DEid2') and Trim(url.DEid2) neq ''>
			and de.DEid = #url.DEid2#
		</cfif>
		order by cf.CFcodigo, <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif>
	</cfquery>

<cftry>
	<cfquery name="rsEmp" datasource="#session.dsn#">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfset separadoTablasEnc = "padding-right: 5px; padding-left: 25px;">
	<cfset separadoContenido = "padding-right: 5px; padding-left: 5px;">
	<cfset encabezado = "font-size: 80%; font-weight:bold; padding-left:5px; padding-right:5px;">
	<cfset contenidoEnc  = "font-size: 75%; padding-left:5px; padding-right:5px;">
	<cfset contenido  = "font-size: 75%; padding-left:5px; padding-right:5px;">
	<cfset resaltar   = "font-size:110%; font-weight:bold; padding-left:5px; padding-right:5px;">
	<cfset miniBold   = "font-size:90%; font-weight:bold; padding-left:5px; padding-right:5px;">

	<cfset vTSalarioDevengado = 0 >
	<cfset vTDeducciones = 0 >

	<cfset contador = 1 >
	<cfset cortes = 0 >
	<cfset countTbl = 1>
<cfoutput>
<cfloop query="data">
	<cfset vSTSalarioDevengado = 0 >
	<cfset vSTDeducciones = 0 >
	<cfif (countTbl mod 2 eq 1)>
		<table width="100%" align="center">
	</cfif>
		<tr>
			<td>
			<table width="100%" align="center" border="0" cellspacing="0">
				<tr>
					<td colspan="8">
						<table width="100%" align="center" cellspacing="0">
							<tr><td align="center" colspan="8" style="#resaltar#"><strong>#rsEmp.Edescripcion#</strong></td></tr>
							<tr><td align="center" colspan="8" style="#miniBold#"><strong><cf_translate key="LB_Resumen_de_Boletas_de_Pago">Resumen de Boletas de Pago</cf_translate></strong></td></tr>
							<tr><td align="center" colspan="8" style="#miniBold#"><strong><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</strong>#data_nomina.RCDescripcion#</td></tr>
							<tr><td align="center" colspan="8" style="#miniBold#"><strong><cf_translate key="LB_Del">Del</cf_translate>&nbsp;</strong>#LSDateFormat(data_nomina.RCdesde, 'dd/mm/yyyy')# <strong><cf_translate key="LB_al">al</cf_translate></strong> #LSDateFormat(data_nomina.RChasta, 'dd/mm/yyyy')#</td></tr>
							<tr><td align="center" colspan="8" style="#miniBold#"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong>#trim(data_centro.CFcodigo)# - #data_centro.CFdescripcion#</td></tr>
						</table>
					</td>
				</tr>
				<tr bgcolor="##CCCCCC">
					<td align="left" colspan="8" style="#miniBold#">
						<strong>
							<cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>: #trim(CFcodigo)# - #CFdescripcion#
						</strong>
					</td>
				</tr>
			</table>
			<table width="100%" align="center" border="0" cellspacing="0" >
				<cfset vSalarioDevengado = 0 >
				<cfset vDeducciones = 0 >
				<tr>
					<td colspan="8" bgcolor="##e5e5e5" cellspacing="0">
						<table width="100%">
							<tr>
								<td bgcolor="##e5e5e5" width="25%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_Identificacion" xmlfile="/sif/rh/generales.xml">No. Empleado</cf_translate></strong></td>
								<td bgcolor="##e5e5e5" width="25%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_Nombre" xmlfile="/sif/rh/generales.xml">Nombre</cf_translate></strong></td>
								<td bgcolor="##e5e5e5" width="25%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_IMSS" xmlfile="/sif/rh/generales.xml">No. Afiliacion IMSS</cf_translate></strong></td>
								<td bgcolor="##e5e5e5" width="25%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_RFC" xmlfile="/sif/rh/generales.xml">Reg. Fed de Contribuyentes</cf_translate></strong></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="8" class="listaNon" >
						<table width="100%" cellspacing="0">
							<tr>
								<td class="listaNon" width="25%" colspan="2" style="#contenidoEnc#">#DEidentificacion#</td>
								<td class="listaNon" width="25%" colspan="2" style="#contenidoEnc#">#DEapellido1# #DEapellido2# #DEnombre#</td>
								<td class="listaNon" width="25%" colspan="2" style="#contenidoEnc#">#DESeguroSocial#</td>
								<td class="listaNon" width="25%" colspan="2" style="#contenidoEnc#">#RFC#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="8" bgcolor="##e5e5e5">
						<table width="100%" cellspacing="0">
							<tr>
								<td width="20%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_Puesto" xmlfile="/sif/rh/generales.xml">Puesto</cf_translate></strong></td>
								<td width="20%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_Depto" xmlfile="/sif/rh/generales.xml">Departamento</cf_translate></strong></td>
								<td width="20%" style="#encabezado#"><strong><cf_translate key="LB_SueldoDiario" xmlfile="/sif/rh/generales.xml">Sueldo Diario</cf_translate></strong></td>
								<td width="20%" colspan="2" style="#encabezado#"><strong><cf_translate key="LB_FecPago" xmlfile="/sif/rh/generales.xml">Fecha Pago</cf_translate></strong></td>
								<td width="20%" style="#encabezado#"><strong><cf_translate key="LB_DiasTrab" xmlfile="/sif/rh/generales.xml">Dias Trabajados</cf_translate></strong></td>
							</tr>
						</table>
					</td>
				</tr>

				<cfquery name="rsFaltas" datasource="#session.dsn#">
					select
						pe.DEid,
						sum((DateDiff(day,lt.LTdesde,LThasta)+1) * ta.RHTfactorfalta) as dias
					from
						#prefijo#RCalculoNomina rc
					inner join #prefijo#PagosEmpleado pe
						on rc.RCNid = pe.RCNid
					inner join RHTipoAccion ta
						on pe.RHTid = ta.RHTid
					inner join LineaTiempo lt
						on lt.LTid = pe.LTid
						and lt.DEid = pe.DEid
					where
						rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="13">
					and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					group by pe.DEid
				</cfquery>
				<cfset lvarFaltasDias = (Trim(rsFaltas.dias) neq '' ? rsFaltas.dias : 0)>

				<cfquery name="rsIncFaltas" datasource="#session.dsn#">
					select
						ic.ICvalor
					from #prefijo#IncidenciasCalculo ic
					inner join CIncidentes ci
					on ci.CIid = ic.CIid
					where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and LTRIM(RTRIM(ci.CIcodigo)) = '04'
				</cfquery>
				<cfset varHrsToDias = (Trim(rsIncFaltas.ICvalor) neq '' ? ((rsIncFaltas.ICvalor /8) * 1.1) : 0)>

				<cfquery name="rsDiasCP" datasource="#session.dsn#">
					select RCdesde,RChasta,
						(DateDiff(day,RCdesde,RChasta)+1) as DiasCP
					from
						#prefijo#RCalculoNomina rc
					where
						rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfquery name="rsFechaBaja" datasource="#session.dsn#">
					select dle.DLfvigencia ,datediff(day,dle.DLfvigencia,'#rsDiasCP.RChasta#') dias
					from DLaboralesEmpleado dle 
					inner join RHTipoAccion ta on dle.RHTid = ta.RHTid
					where dle.DEid = #DEid#
					and ta.RHTcomportam = 2
					and datediff(day,dle.DLfvigencia,'#rsDiasCP.RChasta#') > 0
				</cfquery>
				<cfset diasBaja = (rsFechaBaja.recordCount gt 0) ? ( (rsFechaBaja.dias gt rsDiasCP.DiasCP) ? rsDiasCP.DiasCP : rsFechaBaja.dias ) : 0>
				<cfset lVarDiasCP = rsDiasCP.DiasCP - diasBaja - lvarFaltasDias - varHrsToDias>

				<tr>
					<td colspan="8" class="listaNon">
						<table width="100%" cellspacing="0">
							<tr>
								<td class="listaNon" width="20%" colspan="2" style="#contenidoEnc#">#Puesto#</td>
								<td class="listaNon" width="20%" colspan="2" style="#contenidoEnc#">#Ddescripcion#</td>
								<td class="listaNon" width="20%" style="#contenidoEnc#">#SueldoDiario#</td>
								<td class="listaNon" width="20%" colspan="2" style="#contenidoEnc#">#FechaPago#</td>
								<td class="listaNon" width="20%" style="#contenidoEnc#">#LSNumberFormat((Trim(lVarDiasCP) eq '' ? 0 : lVarDiasCP),'9.00')#</td>
							</tr>
						</table>
					</td>
				</tr>

				<cfquery name="rsIncEfect" datasource="#session.DSN#">
					select ic.CIid, ci.CIcodigo, ci.CIdescripcion,
						sum(
							case
								when ic.ICmontoant = 0 and ci.CItipo in (0,1) then ic.ICvalor
								when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then 0
								else ic.ICvalor
							end
							)
						as ICvalor,
						sum(ic.ICmontores) as ICmontores
					from #prefijo#IncidenciasCalculo ic
					inner join CIncidentes ci
						on ci.CIid = ic.CIid
						and ci.CItimbrar = 1
					where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					group by ic.CIid, ci.CIcodigo, ci.CIdescripcion
					order by ci.CIcodigo, ci.CIdescripcion
				</cfquery>
				<cfset lVarPagoEfect = (TRIM(rsIncEfect.ICmontores) neq '' ? rsIncEfect.ICmontores : 0)>



				<tr class="corte">
					<td colspan="8" nowrap="">
						<table border="0" width="100%">
							<tr>
								<td width="50%" align="center" style="border:1px solid gray;" valign="top" colspan="4">
									<table width="100%" cellspacing="0">
										<tr>
											<td class="tituloListas" align="left" colspan="2" style="#encabezado#"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
											<td class="tituloListas" align="right" style="#encabezado#"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
											<td class="tituloListas" align="right" style="#encabezado#"><cf_translate key="LB_Monto">Monto</cf_translate></td>
										</tr>

										<cfif len(trim(SEsalariobruto))>
											<tr>
												<td align="left" colspan="2" style="#contenidoEnc#"><cf_translate key="LB_Componentes_Salariales">Sueldo Normal</cf_translate></td>
												<td></td>
												<td align="right" style="#contenidoEnc#">#lsnumberformat(SEsalariobruto, ',9.00')#</td>
											</tr>
											<cfset vSalarioDevengado = vSalarioDevengado + SEsalariobruto >
										</cfif>

										<cfquery name="data_incidencias" datasource="#session.DSN#">
											select ic.CIid, ci.CIcodigo, ci.CIdescripcion,
											<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
											pues sino incrementara la cantidad con sumas que no aplican --->
											<cfif isdefined("url.resumido")>sum(case  when ic.ICmontoant=0 and ci.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
																							ic.ICvalor
																					  when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
																					  		0
																						else ic.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
																					  end) as</cfif> ICvalor,
											<cfif isdefined("url.resumido")>sum(ic.ICmontores) as</cfif> ICmontores
											from #prefijo#IncidenciasCalculo ic
											inner join CIncidentes ci
											on ci.CIid = ic.CIid
											<!--- 2018-12-31 OPARRALES Se excluyen incidencias que no se timbran, como pago en efectivo. --->
											and ci.CItimbrar = 0
											where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">   <!--- OJO filtrar por CF (averiguar) --->
											and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
											<cfif isdefined("url.resumido")>
												group by ic.CIid, ci.CIcodigo, ci.CIdescripcion
											</cfif>
											order by ci.CIcodigo, ci.CIdescripcion
										</cfquery>
										<cfloop query="data_incidencias">
											<tr>
												<td align="left" colspan="2" style="#contenidoEnc#">#trim(data_incidencias.CIcodigo)# - #trim(data_incidencias.CIdescripcion)#</td>
												<td align="right" style="#contenidoEnc#">#lsnumberformat(data_incidencias.ICvalor, ',9.00')#</td>
												<td align="right" style="#contenidoEnc#">#lsnumberformat(data_incidencias.ICmontores, ',9.00')#</td>
											</tr>
											<cfset vSalarioDevengado = vSalarioDevengado + data_incidencias.ICmontores >
										</cfloop>
										<cfset vSTSalarioDevengado = vSTSalarioDevengado + vSalarioDevengado >
										<cfset vTSalarioDevengado = vTSalarioDevengado + vSalarioDevengado >
									</table>
								</td>
								<td width="50%" align="center" style="border:1px solid gray;" valign="top" colspan="4">
									<table width="100%" cellspacing="0">
										<tr>
											<td class="tituloListas" align="left" colspan="2" style="#encabezado#"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
											<td class="tituloListas" align="right" style="#encabezado#"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
											<td class="tituloListas" align="right" style="#encabezado#"><cf_translate key="LB_Monto">Monto</cf_translate></td>
										</tr>

										<cfquery name="data_cargas" datasource="#session.DSN#">
											select '' as DCcodigo, 'IMSS' as DCdescripcion, coalesce(sum(cc.CCvaloremp),0) as CCvaloremp
											from #prefijo#CargasCalculo cc

											inner join DCargas c
											on c.DClinea = cc.DClinea

											where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
											  and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
											  and cc.CCvaloremp != 0
										</cfquery>
										<cfloop query="data_cargas">
											<tr>
												<td align="left" colspan="2" style="#contenidoEnc#">#trim(data_cargas.DCcodigo)# - #trim(data_cargas.DCdescripcion)#</td>
												<td align="right" style="#contenidoEnc#"></td>
												<td align="right" style="#contenidoEnc#">#lsnumberformat(data_cargas.CCvaloremp, ',9.00')#</td>
											</tr>
											<cfset vDeducciones = vDeducciones + data_cargas.CCvaloremp >
											<cfset vSTDeducciones = vSTDeducciones + data_cargas.CCvaloremp >
											<cfset vTDeducciones = vTDeducciones + data_cargas.CCvaloremp >
										</cfloop>
										<cfquery name="data_deducciones" datasource="#session.DSN#">
											select dc.Did, dc.DCvalor, de.Ddescripcion,  de.Dreferencia
											from #prefijo#DeduccionesCalculo dc

											inner join DeduccionesEmpleado de
											on de.Did=dc.Did

											where dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
											  and dc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
										</cfquery>
										<cfloop query="data_deducciones">
											<tr>
												<td align="left" colspan="2" style="#contenidoEnc#">#trim(data_deducciones.Ddescripcion)# - #trim(data_deducciones.Dreferencia)#</td>
												<td align="right" style="#contenidoEnc#"></td>
												<td align="right" style="#contenidoEnc#">#lsnumberformat(data_deducciones.DCvalor, ',9.00')#</td>
											</tr>
											<cfset vDeducciones = vDeducciones + data_deducciones.DCvalor >
											<cfset vSTDeducciones = vSTDeducciones + data_deducciones.DCvalor >
											<cfset vTDeducciones = vTDeducciones + data_deducciones.DCvalor >
										</cfloop>

										<cfif SErenta neq 0>
											<cfset vDeducciones = vDeducciones + SErenta >
											<cfset vSTDeducciones = vSTDeducciones + SErenta >
											<cfset vTDeducciones = vTDeducciones + SErenta  >
											<tr>
												<td align="left" colspan="2" style="#contenidoEnc#"><cf_translate key="LB_Renta">ISR</cf_translate></td>
												<td align="right" style="#contenidoEnc#"></td>
												<td align="right" style="#contenidoEnc#">#lsnumberformat(SErenta, ',9.00')#</td>
											</tr>
										</cfif>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<td colspan="8">
						<table width="100%" cellspacing="0">
							<tr>
								<td align="right" width="50%" colspan="4" style="#encabezado#"><strong><cf_translate key="LB_Salario_devengado">Total de Percepciones</cf_translate>:</strong> #lsnumberformat(vSalarioDevengado, ',9.00')#&nbsp;</td>
								<td align="right" width="50%" colspan="4" style="#encabezado#"><strong><cf_translate key="LB_Total_Deducciones">Total Deducciones</cf_translate>:</strong> #lsnumberformat(vDeducciones, ',9.00')#&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<cfset lvarNeto = vSalarioDevengado-vDeducciones>
					<td colspan="8" align="right" style="#encabezado#"><strong><cf_translate key="LB_Neto">Neto</cf_translate>:</strong> #lsnumberformat(vSalarioDevengado-vDeducciones, ',9.00')#&nbsp;&nbsp;</td>
				</tr>

				<!--- <cfif rsMensaje.recordCount gt 0 and len(trim(rsMensaje.mensaje))> --->
				<tr>
					<td colspan="8">
						<table width="100%" cellspacing="0">
							<tr>
								<td colspan="4" width="35%" style="text-align: justify; text-justify: inter-word; #contenido#" >Recibi de #rsEmp.Edescripcion# la cantidad indicada que cubre a la fecha el importe de mi salario, tiempo extra
								septimo dia y todas las percepciones y prestaciones a las que tengo derecho sin que se me adeude alguna cantidad por otro concepto.</td>
								<td colspan="2" align="center" width="35%" style="#miniBold#"><p><hr width="75%"/></p><strong>Firma del Empleado</strong></td>
								<cfquery name="rsIncDespensa" datasource="#session.dsn#">
									select
										ic.ICmontores
									from #prefijo#IncidenciasCalculo ic
									inner join CIncidentes ci
									on ci.CIid = ic.CIid
									where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
									and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
									and ci.CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="2DE">
								</cfquery>
								<cfset lVarPagoEsp = (Trim(rsIncDespensa.ICmontores) eq '' ? 0 : rsIncDespensa.ICmontores)>
								<td char="2" width="30%" align="right" style="#encabezado#">
									<p>
										<strong>Pago en Efectivo</strong> #LSNumberFormat(((vSalarioDevengado-vDeducciones)-lVarPagoEsp),'9.00')#&nbsp;&nbsp;
									</p>
									<p>
										<strong>Pago en Especie </strong> #LSNumberFormat(lVarPagoEsp,'9.00')#&nbsp;&nbsp;
									</p>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="8">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="8">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="8">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<cfif countTbl mod 2 eq 0>
		</table>
		<cfif data.RecordCount neq countTbl>
			<div class="saltopagina"></div>
		</cfif>
	</cfif>
<cfset countTbl++>
</cfloop>

</cfoutput>
<!--- nuevo --->
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfthrow object="#cfcatch#">
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
<!--- nuevo --->
