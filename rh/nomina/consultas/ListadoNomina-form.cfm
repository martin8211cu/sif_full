<cf_htmlreportsheaders
			title="Listado de N&oacute;mina"
			filename="ListadoDeNomina#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls"
			ira="ListadoNomina-parametros.cfm"
			method="url">

<cfset prefijo = ''>
<cfif url.tipo eq 'H' >
	<cfset prefijo = 'H'>
	<cfset url.DEidentificacion1 = url.DEidentificacion3>
	<cfset url.DEidentificacion2 = url.DEidentificacion4>
</cfif>

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

<cfif not isdefined('url.corteBoleta') and not isdefined('url.Encabezado')>
<table width="98%" cellpadding="3" cellspacing="0" align="center">
	<tr>
		<td align="center" colspan="4">
			<strong>#session.Enombre#</strong><br />
			<strong><cf_translate key="LB_Resumen_de_Boletas_de_Pago">Listado de N&oacute;mina</cf_translate></strong><br />
			<strong><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</strong>#data_nomina.RCDescripcion#<br />
			<strong><cf_translate key="LB_Del">Del</cf_translate>&nbsp;</strong>#LSDateFormat(data_nomina.RCdesde, 'dd/mm/yyyy')# <strong><cf_translate key="LB_al">al</cf_translate></strong> #LSDateFormat(data_nomina.RChasta, 'dd/mm/yyyy')#<br />
			<strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong>#trim(data_centro.CFcodigo)# - #data_centro.CFdescripcion#<br /><br />
		</td>
	</tr>
</table>
</cfif>
</cfoutput>
<style>    DIV.pageBreak { page-break-before: always; }</style>
<cfset encabezado = "font-size: 80%; font-weight:bold; padding-left:5px; padding-right:5px;">
<cfset contenidoEnc  = "font-size: 75%; padding-left:5px; padding-right:5px;">


<cfquery name="data" datasource="#session.dsn#">
	select	 se.DEid,
			 de.DEidentificacion,
			 de.DEtarjeta,
			 de.DEnombre,
			 de.DEapellido1,
			 de.DEapellido2,
			 lt.RHPid,
			 p.CFidconta,
			 LTRIM(RTRIM(cf.CFcodigo)) CFcodigo,
			 cf.CFdescripcion,
			 se.SEsalariobruto,
			 se.SErenta,
			 cf.CFid
	from #prefijo#RCalculoNomina rc

		inner join #prefijo#SalarioEmpleado se
			on rc.RCNid = se.RCNid

		inner join DatosEmpleado de
			on de.DEid = se.DEid

		<cfif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion1')>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> >= '#url.DEidentificacion1#'
		<cfelseif isdefined('url.DEidentificacion2') and LEN(TRIM(url.DEidentificacion2)) and not isdefined('url.DEidentificacion1')>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> <= '#url.DEidentificacion2#'
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and
				isdefined('url.DEidentificacion2') and LEN(TRIM(url.DEidentificacion2))>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> between '#url.DEidentificacion1#' and '#url.DEidentificacion2#'
		</cfif>

		inner join LineaTiempo lt
			on se.DEid = lt.DEid
	   	   and lt.Ecodigo = rc.Ecodigo
		   and lt.LTid = (	select max(lt2.LTid)
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

		inner join CFuncional cf
			on cf.CFid=coalesce(p.CFidconta, p.CFid)			<!--- duda  es CFid o *CFidconta*, si es CFid cambiar la parte de centros dependientes --->
			<cfif isdefined("url.dependencias") and url.DEid2 LTE 0 and url.DEid2 LTE 0>
				and cf.CFpath like '#trim(data_centro.CFpath)#%'
			</cfif>

	where rc.Ecodigo = #session.Ecodigo#
	  and rc.RCNid = #url.RCNid#

	order by cf.CFcodigo,de.DEidentificacion
</cfquery>
<cftry>
	<cfflush interval="500">
	<!--- <cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open> --->

<table width="70%" cellpadding="2" cellspacing="2" align="center" border="0">
	<cfset vTSalarioDevengado = 0 >
	<cfset vTDeducciones = 0 >

	<cfset contador = 1 >
	<cfset cortes = 0 >
	<cfoutput>
		<cfif isdefined('url.Encabezado')>
		<tr>
			<td colspan="4" align="center">
				<strong>#session.Enombre#</strong><br />
				<strong><cf_translate key="LB_Resumen_de_Boletas_de_Pago">Listado de Nomina</cf_translate></strong><br />
				<strong><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</strong>#data_nomina.RCDescripcion#<br />
				<strong><cf_translate key="LB_Del">Del</cf_translate>&nbsp;</strong>#LSDateFormat(data_nomina.RCdesde, 'dd/mm/yyyy')# <strong><cf_translate key="LB_al">al</cf_translate></strong> #LSDateFormat(data_nomina.RChasta, 'dd/mm/yyyy')#<br />
				<strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong>#trim(data_centro.CFcodigo)# - #data_centro.CFdescripcion#<br /><br />
			</td>
		</tr>
		<tr bgcolor="##CCCCCC">
			<td align="left" colspan="4"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>: #trim(CFcodigo)# - #CFdescripcion#</strong></td>
		</tr>
		</cfif>
	</cfoutput>

	<!--- OPARRALES 2019-01-15
		- Modificacion para agregar totales por tabla
		- Fin de documento mostrar suma por todos los conceptos incluidos en la Nomina (Percepciones y Deducciones)
	 --->
	<cfoutput query="data" group="CFcodigo">
		<cfif not isdefined('url.corteBoleta') and not isdefined('url.Encabezado')>
			<tr bgcolor="##CCCCCC">
				<td align="left" colspan="4"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>: #trim(CFcodigo)# - #CFdescripcion#</strong></td>
			</tr>

			<cfquery name="rsTodosXCF" datasource="#session.dsn#">
				select TipoReg,Descripcion,Monto,CFid from
				(
					select
						'RENTA' as TipoReg,
						'ISR' as Descripcion,
						sum(cc.SErenta) as Monto,
						cf.CFid
					from #prefijo#SalarioEmpleado cc
					inner join #prefijo#RCalculoNomina rc
						on cc.RCNid = rc.RCNid
					inner join LineaTiempo lt
						on cc.DEid = lt.DEid
					   		   and lt.Ecodigo = rc.Ecodigo
							   and lt.LTid = (	select max(lt2.LTid)
						   							from LineaTiempo lt2
													where lt.DEid = lt2.DEid
													  and lt2.LTdesde < = rc.RChasta
													  and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
							   and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=coalesce(p.CFidconta, p.CFid)
					where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
					group by cf.CFid

					union

					select
						'COMPONENTES SALARIALES' as TipoReg,
						'Componentes Salariales' as Descripcion,
						sum(cc.SEsalariobruto) as Monto,
						cf.CFid
					from #prefijo#SalarioEmpleado cc
					inner join #prefijo#RCalculoNomina rc
						on cc.RCNid = rc.RCNid
					inner join LineaTiempo lt
						on cc.DEid = lt.DEid
					   		   and lt.Ecodigo = rc.Ecodigo
							   and lt.LTid = (	select max(lt2.LTid)
						   							from LineaTiempo lt2
													where lt.DEid = lt2.DEid
													  and lt2.LTdesde < = rc.RChasta
													  and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
							   and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=coalesce(p.CFidconta, p.CFid)
					where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
					group by cf.CFid

					UNION

					select
						'IMSS Empleado' as TipoReg,
						'IMSS Empleado' as Descripcion,
						sum(cc.CCvaloremp) as Monto,
						cf.CFid
					from #prefijo#CargasCalculo cc
					inner join DCargas c
						on c.DClinea = cc.DClinea
					inner join #prefijo#RCalculoNomina rc
						on cc.RCNid = rc.RCNid
					inner join LineaTiempo lt
						on cc.DEid = lt.DEid
					   		   and lt.Ecodigo = rc.Ecodigo
							   and lt.LTid = (	select max(lt2.LTid)
						   							from LineaTiempo lt2
													where lt.DEid = lt2.DEid
													  and lt2.LTdesde < = rc.RChasta
													  and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
							   and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=coalesce(p.CFidconta, p.CFid)
					where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
					group by cf.CFid

					union

					select
						'Deduccion' as TipoReg,
						de.Ddescripcion as Descripcion,
						sum(dc.DCvalor) as Monto,
						cf.CFid
					from
						#prefijo#DeduccionesCalculo dc
					inner join DeduccionesEmpleado de
						on de.Did=dc.Did
					inner join #prefijo#RCalculoNomina rc
							on dc.RCNid = rc.RCNid
						inner join LineaTiempo lt
							on dc.DEid = lt.DEid
					   			   and lt.Ecodigo = rc.Ecodigo
								   and lt.LTid = (	select max(lt2.LTid)
						   								from LineaTiempo lt2
														where lt.DEid = lt2.DEid
														  and lt2.LTdesde < = rc.RChasta
														  and lt2.LThasta > = rc.RCdesde )
								inner join RHPlazas p
									on lt.RHPid = p.RHPid
								   and lt.Ecodigo = p.Ecodigo
								inner join CFuncional cf
									on cf.CFid=coalesce(p.CFidconta, p.CFid)
					where dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
					group by de.Ddescripcion,cf.CFid

					union

					select
						'Incidencia' as TipoReg,
						concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))) as Descripcion,
						sum(case
								when ic.ICmontoant=0 and ci.CItipo in (0,1) then ic.ICmontores
								when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then 0
								else ic.ICmontores
							end) as Monto,
							cf.CFid
					from
						#prefijo#IncidenciasCalculo ic
					inner join CIncidentes ci
						on ci.CIid = ic.CIid
						and ci.CItimbrar = 0
					inner join #prefijo#RCalculoNomina rc
							on ic.RCNid = rc.RCNid
						inner join LineaTiempo lt
							on ic.DEid = lt.DEid
					   			   and lt.Ecodigo = rc.Ecodigo
								   and lt.LTid = (	select max(lt2.LTid)
						   								from LineaTiempo lt2
														where lt.DEid = lt2.DEid
														  and lt2.LTdesde < = rc.RChasta
														  and lt2.LThasta > = rc.RCdesde )
								inner join RHPlazas p
									on lt.RHPid = p.RHPid
								   and lt.Ecodigo = p.Ecodigo
								inner join CFuncional cf
									on cf.CFid=coalesce(p.CFidconta, p.CFid)
					where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
					group by concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))),cf.CFid
				) obj
				order by TipoReg,Descripcion,CFid
			</cfquery>

			<cfquery name="rsSumISR" dbtype="query">
				select
					sum(Monto) sumMonto
				from
					rsTodosXCF
				where TipoReg = 'RENTA'
			</cfquery>
			<cfset varTotISRTmp = (Trim(rsSumISR.sumMonto) neq '' ? rsSumISR.sumMonto : 0)>

			<cfquery name="rsSumCS" dbtype="query">
				select
					sum(Monto) sumMonto
				from
					rsTodosXCF
				where TipoReg = 'COMPONENTES SALARIALES'
			</cfquery>
			<cfset varTotCSTmp = (Trim(rsSumCS.sumMonto) neq '' ? rsSumCS.sumMonto : 0)>

			<cfquery name="rsSumCarg" dbtype="query">
				select
					sum(Monto) sumMonto
				from
					rsTodosXCF
				where TipoReg = 'IMSS Empleado'
			</cfquery>
			<cfset varTotCargTmp = (Trim(rsSumCarg.sumMonto) neq '' ? rsSumCarg.sumMonto : 0)>

			<cfquery name="rsSumDeduc" dbtype="query">
				select
					sum(Monto) sumMonto
				from
					rsTodosXCF
				where TipoReg = 'Deduccion'
			</cfquery>
			<cfset varTotDeducTmp = (Trim(rsSumDeduc.sumMonto) neq '' ? rsSumDeduc.sumMonto : 0)>

			<cfquery name="rsSumInc" dbtype="query">
				select
					sum(Monto) sumMonto
				from
					rsTodosXCF
				where TipoReg = 'Incidencia'
			</cfquery>
			<cfset varTotIncTmp = (Trim(rsSumInc.sumMonto) neq '' ? rsSumInc.sumMonto : 0)>

			<cfquery name="rsEsp" datasource="#session.dsn#">
				select
					'Incidencia' as TipoReg,
					concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))) as Descripcion,
					sum(case
							when ic.ICmontoant=0 and ci.CItipo in (0,1) then ic.ICmontores
							when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then 0
							else ic.ICmontores
						end) as Monto,
						cf.CFid
				from
					#prefijo#IncidenciasCalculo ic
				inner join CIncidentes ci
					on ci.CIid = ic.CIid
					and ci.CItimbrar = 0
				inner join #prefijo#RCalculoNomina rc
						on ic.RCNid = rc.RCNid
					inner join LineaTiempo lt
						on ic.DEid = lt.DEid
				   			   and lt.Ecodigo = rc.Ecodigo
							   and lt.LTid = (	select max(lt2.LTid)
					   								from LineaTiempo lt2
													where lt.DEid = lt2.DEid
													  and lt2.LTdesde < = rc.RChasta
													  and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
							   and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=coalesce(p.CFidconta, p.CFid)
				where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
				and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
				and ci.CIExcluyePagoLiquido = 1
				group by concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))),cf.CFid
			</cfquery>
			<cfset lVarPagoEspTmp = Trim(rsEsp.Monto) eq '' ? 0 : rsEsp.Monto>

			<cfset varTotGralTmp = (varTotIncTmp + varTotCSTmp) - varTotISRTmp - varTotCargTmp - varTotDeducTmp>
			<tr>
				<td style="border:1px solid gray;" colspan="4">
					<table width="100%" align="center">
						<tr bgcolor="##CCCCCC">
							<th colspan="3" ALign="CENTER">CONCEPTOS CALCULADO EN LA NOMINA</th>
						</tr>

						<tr>
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="20%" align="center"><strong>Total Empleados</strong></td>
										<td width="20%" align="center"><strong>Total Percepciones</strong></td>
										<td width="20%" align="center"><strong>Total Retenciones</strong></td>
										<td width="20%" align="center"><strong>Pago en Especie</strong></td>
										<td width="20%" align="center"><strong>Pago en Efectivo</strong></td>
									</tr>
								</table>
							</td>
						</tr>
						<cfquery name="rsTotXCF" datasource="#session.dsn#">
							SELECT
								count(distinct se.DEid) as cantidad
							FROM
								#prefijo#SalarioEmpleado se
							inner join #prefijo#RCalculoNomina rc
								on se.RCNid = rc.RCNid
							inner join LineaTiempo lt
								on se.DEid = lt.DEid
								and lt.Ecodigo = rc.Ecodigo
								and lt.LTid = (	select max(lt2.LTid)
												   	from LineaTiempo lt2
													where lt.DEid = lt2.DEid
														and lt2.LTdesde < = rc.RChasta
														and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
								and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=p.CFid
							where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
							and rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
						</cfquery>
						<tr>
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="20%" align="center">#LSNumberFormat(rsTotXCF.cantidad,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat(varTotIncTmp-lVarPagoEspTmp,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat(varTotDeducTmp,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat(lVarPagoEspTmp,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat((varTotGralTmp - lVarPagoEspTmp),'9.00')#</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr bgcolor="##e5e5e5">
							<td colspan="2"><strong>Descripci&oacute;n</strong></th>
							<td colspan="1"><strong>Total</strong></th>
						</tr>
						<tr><td colspan="3"><hr/></td></tr>
						<cfloop query="rsTodosXCF">
							<tr>
								<td colspan="2">&nbsp;&nbsp;#Descripcion#</td>
								<td align="right">#LSNumberFormat(Monto,'9.00')#</td>
							</tr>
						</cfloop>
						<tr><td colspan="3"><hr/></td></tr>
						<tr>
							<td colspan="2" align="right"><strong>TOTAL:</strong></td>
							<td align="right">
								#LSNumberFormat(varTotGralTmp,'9.00')#
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfif>

		<cfset vSTSalarioDevengado = 0 >
		<cfset vSTDeducciones = 0 >

		<cfoutput>
			<cfset vSalarioDevengado = 0 >
			<cfset vDeducciones = 0 >
			<tr >
				<td bgcolor="##e5e5e5" nowrap colspan="2"><strong><cf_translate key="LB_Identificacion" xmlfile="/sif/rh/generales.xml">Identificaci&oacute;n</cf_translate></strong></td>
				<td bgcolor="##e5e5e5" colspan="2"><strong><cf_translate key="LB_Nombre" xmlfile="/sif/rh/generales.xml">Nombre</cf_translate></strong></td>
			</tr>
			<tr >
				<td class="listaNon" colspan="2">#DEidentificacion#</td>
				<td class="listaNon" colspan="2">#DEapellido1# #DEapellido2# #DEnombre#</td>
			</tr>

			<tr class="corte">
				<td colspan="4" width="50%" align="center" style="border:1px solid gray;" valign="top">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td class="tituloListas" align="left" width="70%" colspan="2"><strong><cf_translate key="LB_Concepto">Concepto</cf_translate></strong></td>
							<td class="tituloListas" align="right" width="15%"><strong><cf_translate key="LB_Cantidad">Cantidad</cf_translate></strong></td>
							<td class="tituloListas" align="right" width="15%"><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
						</tr>

						<cfif len(trim(SEsalariobruto))>
							<tr>
								<td align="left" colspan="2" width="70%"><cf_translate key="LB_Componentes_Salariales">Sueldo Normal</cf_translate></td>
								<td width="15%"></td>
								<td align="right" width="70%">#lsnumberformat(SEsalariobruto, ',9.00')#</td>
							</tr>
							<cfset vSalarioDevengado = vSalarioDevengado + SEsalariobruto >
						</cfif>

						<cfquery name="data_incidencias" datasource="#session.DSN#">
							select ic.CIid, ci.CIcodigo, ci.CIdescripcion,
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
								<td align="left" colspan="2" width="70%">#trim(data_incidencias.CIcodigo)# - #trim(data_incidencias.CIdescripcion)#</td>
								<td align="right" width="15%">#lsnumberformat(data_incidencias.ICvalor, ',9.00')#</td>
								<td align="right" width="15%">#lsnumberformat(data_incidencias.ICmontores, ',9.00')#</td>
							</tr>
							<cfset vSalarioDevengado = vSalarioDevengado + data_incidencias.ICmontores >
						</cfloop>
						<cfset vSTSalarioDevengado = vSTSalarioDevengado + vSalarioDevengado >
						<cfset vTSalarioDevengado = vTSalarioDevengado + vSalarioDevengado >

						<cfquery name="data_cargas" datasource="#session.DSN#">
							select cc.DClinea, c.DCcodigo, c.DCdescripcion, cc.CCvaloremp
							from #prefijo#CargasCalculo cc

							inner join DCargas c
							on c.DClinea = cc.DClinea

							where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
							  and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and cc.CCvaloremp != 0
						</cfquery>
						<cfloop query="data_cargas">
							<tr>
								<td align="left" width="70%" colspan="2">#trim(data_cargas.DCcodigo)# - #trim(data_cargas.DCdescripcion)#</td>
								<td align="right" width="15%"></td>
								<td align="right" width="15%">#lsnumberformat(data_cargas.CCvaloremp, ',9.00')#</td>
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
								<td align="left" width="70%" colspan="2">#trim(data_deducciones.Ddescripcion)# - #trim(data_deducciones.Dreferencia)#</td>
								<td align="right" width="15%"></td>
								<td align="right" width="15%">#lsnumberformat(data_deducciones.DCvalor, ',9.00')#</td>
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
								<td align="left" width="70%" colspan="2"><cf_translate key="LB_Renta">ISR</cf_translate></td>
								<td align="right" width="15"></td>
								<td align="right" width="15%">#lsnumberformat(SErenta, ',9.00')#</td>
							</tr>
						</cfif>


						<cfquery name="sumIncXEmp" dbtype="query">
							select
								sum(ICvalor) sumICvalor,
								sum(ICmontores) sumICmontores
							from
								data_incidencias
						</cfquery>
						<cfset totPerc = Trim(sumIncXEmp.sumICmontores) neq '' ? sumIncXEmp.sumICmontores : 0>

						<cfquery name="sumDedXEmp" dbtype="query">
							select
								sum(DCvalor) as sumDCvalor
							from
								data_deducciones
						</cfquery>
						<cfset totDed = Trim(sumDedXEmp.sumDCvalor) neq '' ? sumDedXEmp.sumDCvalor : 0>

						<cfquery name="sumCargXEmp" dbtype="query">
							select
								sum(CCvaloremp) as sumCCvaloremp
							from
								data_cargas
						</cfquery>
						<cfset totCarg = Trim(sumCargXEmp.sumCCvaloremp) neq '' ? sumCargXEmp.sumCCvaloremp : 0>
						<cfset totXEmpleado = (SEsalariobruto + totPerc) - (totDed + totCarg+SErenta)>

						<tr>
							<td colspan="4"><hr/></td>
						</tr>

						<tr>
							<td align="right" width="70%" colspan="2"><strong>TOTAL</strong>:</td>
							<td align="right" colspan="3">#lsnumberformat(totXEmpleado, ',9.00')#</td>
						</tr>
					</table>
				</td>
			</tr>

			<cfset contador = contador + 1 >
			<cfset cortes = cortes + 1 >
		</cfoutput>
	</cfoutput>

	<cfif data.RecordCount gt 0>
		<cfquery name="rsTodosXNom" datasource="#session.dsn#">
			select Descripcion,sum(Monto) monto from
			(
				select
					'RENTA' as TipoReg,
					'ISR' as Descripcion,
					sum(cc.SErenta) as Monto,
					cf.CFid
				from #prefijo#SalarioEmpleado cc
				inner join #prefijo#RCalculoNomina rc
					on cc.RCNid = rc.RCNid
				inner join LineaTiempo lt
					on cc.DEid = lt.DEid
				   		   and lt.Ecodigo = rc.Ecodigo
						   and lt.LTid = (	select max(lt2.LTid)
					   							from LineaTiempo lt2
												where lt.DEid = lt2.DEid
												  and lt2.LTdesde < = rc.RChasta
												  and lt2.LThasta > = rc.RCdesde )
						inner join RHPlazas p
							on lt.RHPid = p.RHPid
						   and lt.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							on cf.CFid=coalesce(p.CFidconta, p.CFid)
				where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
				group by cf.CFid

				union

				select
					'COMPONENTES SALARIALES' as TipoReg,
					'Componentes Salariales' as Descripcion,
					sum(cc.SEsalariobruto) as Monto,
					cf.CFid
				from #prefijo#SalarioEmpleado cc
				inner join #prefijo#RCalculoNomina rc
					on cc.RCNid = rc.RCNid
				inner join LineaTiempo lt
					on cc.DEid = lt.DEid
				   		   and lt.Ecodigo = rc.Ecodigo
						   and lt.LTid = (	select max(lt2.LTid)
					   							from LineaTiempo lt2
												where lt.DEid = lt2.DEid
												  and lt2.LTdesde < = rc.RChasta
												  and lt2.LThasta > = rc.RCdesde )
						inner join RHPlazas p
							on lt.RHPid = p.RHPid
						   and lt.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							on cf.CFid=coalesce(p.CFidconta, p.CFid)
				where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
				group by cf.CFid

				UNION

				select
					'IMSS Empleado' as TipoReg,
					'IMSS Empleado' as Descripcion,
					sum(cc.CCvaloremp) as Monto,
					cf.CFid
				from #prefijo#CargasCalculo cc
				inner join DCargas c
					on c.DClinea = cc.DClinea
				inner join #prefijo#RCalculoNomina rc
					on cc.RCNid = rc.RCNid
				inner join LineaTiempo lt
					on cc.DEid = lt.DEid
				   		   and lt.Ecodigo = rc.Ecodigo
						   and lt.LTid = (	select max(lt2.LTid)
					   							from LineaTiempo lt2
												where lt.DEid = lt2.DEid
												  and lt2.LTdesde < = rc.RChasta
												  and lt2.LThasta > = rc.RCdesde )
						inner join RHPlazas p
							on lt.RHPid = p.RHPid
						   and lt.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							on cf.CFid=coalesce(p.CFidconta, p.CFid)
				where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
				group by cf.CFid

				union

				select
					'Deduccion' as TipoReg,
					de.Ddescripcion as Descripcion,
					sum(dc.DCvalor) as Monto,
					cf.CFid
				from
					#prefijo#DeduccionesCalculo dc
				inner join DeduccionesEmpleado de
					on de.Did=dc.Did
				inner join #prefijo#RCalculoNomina rc
						on dc.RCNid = rc.RCNid
					inner join LineaTiempo lt
						on dc.DEid = lt.DEid
				   			   and lt.Ecodigo = rc.Ecodigo
							   and lt.LTid = (	select max(lt2.LTid)
					   								from LineaTiempo lt2
													where lt.DEid = lt2.DEid
													  and lt2.LTdesde < = rc.RChasta
													  and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
							   and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=coalesce(p.CFidconta, p.CFid)
				where dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
				group by de.Ddescripcion,cf.CFid

				union

				select
					'Incidencia' as TipoReg,
					concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))) as Descripcion,
					sum(case
							when ic.ICmontoant=0 and ci.CItipo in (0,1) then ic.ICmontores
							when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then 0
							else ic.ICmontores
						end) as Monto,
						cf.CFid
				from
					#prefijo#IncidenciasCalculo ic
				inner join CIncidentes ci
					on ci.CIid = ic.CIid
					and ci.CItimbrar = 0
				inner join #prefijo#RCalculoNomina rc
						on ic.RCNid = rc.RCNid
					inner join LineaTiempo lt
						on ic.DEid = lt.DEid
				   			   and lt.Ecodigo = rc.Ecodigo
							   and lt.LTid = (	select max(lt2.LTid)
					   								from LineaTiempo lt2
													where lt.DEid = lt2.DEid
													  and lt2.LTdesde < = rc.RChasta
													  and lt2.LThasta > = rc.RCdesde )
							inner join RHPlazas p
								on lt.RHPid = p.RHPid
							   and lt.Ecodigo = p.Ecodigo
							inner join CFuncional cf
								on cf.CFid=coalesce(p.CFidconta, p.CFid)
				where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
				group by concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))),cf.CFid
			) obj
			group by Descripcion
			order by Descripcion
		</cfquery>

		<cfquery name="rsTotRenta" datasource="#session.dsn#">
			select
				sum(cc.SErenta) as Monto
			from #prefijo#SalarioEmpleado cc
			inner join #prefijo#RCalculoNomina rc
				on cc.RCNid = rc.RCNid
			inner join LineaTiempo lt
				on cc.DEid = lt.DEid
			   		   and lt.Ecodigo = rc.Ecodigo
					   and lt.LTid = (	select max(lt2.LTid)
				   							from LineaTiempo lt2
											where lt.DEid = lt2.DEid
											  and lt2.LTdesde < = rc.RChasta
											  and lt2.LThasta > = rc.RCdesde )
					inner join RHPlazas p
						on lt.RHPid = p.RHPid
					   and lt.Ecodigo = p.Ecodigo
					inner join CFuncional cf
						on cf.CFid=coalesce(p.CFidconta, p.CFid)
			where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		<cfset varTotISR = (Trim(rsTotRenta.Monto) neq '' ? rsTotRenta.Monto : 0)>

		<cfquery name="rsTotCS" datasource="#session.dsn#">
			select
				sum(cc.SEsalariobruto) as Monto
			from #prefijo#SalarioEmpleado cc
			inner join #prefijo#RCalculoNomina rc
				on cc.RCNid = rc.RCNid
			inner join LineaTiempo lt
				on cc.DEid = lt.DEid
			   		   and lt.Ecodigo = rc.Ecodigo
					   and lt.LTid = (	select max(lt2.LTid)
				   							from LineaTiempo lt2
											where lt.DEid = lt2.DEid
											  and lt2.LTdesde < = rc.RChasta
											  and lt2.LThasta > = rc.RCdesde )
					inner join RHPlazas p
						on lt.RHPid = p.RHPid
					   and lt.Ecodigo = p.Ecodigo
					inner join CFuncional cf
						on cf.CFid=coalesce(p.CFidconta, p.CFid)
			where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		<cfset varTotCS = (Trim(rsTotCS.Monto) neq '' ? rsTotCS.Monto : 0)>

		<cfquery name="rsTotCarg" datasource="#session.dsn#">
			select
				sum(cc.CCvaloremp) as Monto
			from #prefijo#CargasCalculo cc
			inner join DCargas c
				on c.DClinea = cc.DClinea
			inner join #prefijo#RCalculoNomina rc
				on cc.RCNid = rc.RCNid
			inner join LineaTiempo lt
				on cc.DEid = lt.DEid
			   		   and lt.Ecodigo = rc.Ecodigo
					   and lt.LTid = (	select max(lt2.LTid)
				   							from LineaTiempo lt2
											where lt.DEid = lt2.DEid
											  and lt2.LTdesde < = rc.RChasta
											  and lt2.LThasta > = rc.RCdesde )
					inner join RHPlazas p
						on lt.RHPid = p.RHPid
					   and lt.Ecodigo = p.Ecodigo
					inner join CFuncional cf
						on cf.CFid=coalesce(p.CFidconta, p.CFid)
			where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		<cfset varTotCarg = (Trim(rsTotCarg.Monto) neq '' ? rsTotCarg.Monto : 0)>

		<cfquery name="rsTotDeduc" datasource="#session.dsn#">
			select
				sum(dc.DCvalor) as Monto
			from
				#prefijo#DeduccionesCalculo dc
			inner join DeduccionesEmpleado de
				on de.Did=dc.Did
			inner join #prefijo#RCalculoNomina rc
					on dc.RCNid = rc.RCNid
				inner join LineaTiempo lt
					on dc.DEid = lt.DEid
			   			   and lt.Ecodigo = rc.Ecodigo
						   and lt.LTid = (	select max(lt2.LTid)
				   								from LineaTiempo lt2
												where lt.DEid = lt2.DEid
												  and lt2.LTdesde < = rc.RChasta
												  and lt2.LThasta > = rc.RCdesde )
						inner join RHPlazas p
							on lt.RHPid = p.RHPid
						   and lt.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							on cf.CFid=coalesce(p.CFidconta, p.CFid)
			where dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		<cfset varTotDeduc = (Trim(rsTotDeduc.Monto) neq '' ? rsTotDeduc.Monto : 0)>
		<cfset totRetenciones = varTotISR + varTotCarg + varTotDeduc>

		<cfquery name="rsTotInc" datasource="#session.dsn#">
			select
				sum(case
						when ic.ICmontoant=0 and ci.CItipo in (0,1) then ic.ICmontores
						when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then 0
						else ic.ICmontores
					end) as Monto
			from
				#prefijo#IncidenciasCalculo ic
			inner join CIncidentes ci
				on ci.CIid = ic.CIid
				and ci.CItimbrar = 0
			inner join #prefijo#RCalculoNomina rc
					on ic.RCNid = rc.RCNid
				inner join LineaTiempo lt
					on ic.DEid = lt.DEid
			   			   and lt.Ecodigo = rc.Ecodigo
						   and lt.LTid = (	select max(lt2.LTid)
				   								from LineaTiempo lt2
												where lt.DEid = lt2.DEid
												  and lt2.LTdesde < = rc.RChasta
												  and lt2.LThasta > = rc.RCdesde )
						inner join RHPlazas p
							on lt.RHPid = p.RHPid
						   and lt.Ecodigo = p.Ecodigo
						inner join CFuncional cf
							on cf.CFid=coalesce(p.CFidconta, p.CFid)
			where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		<cfset varTotInc = (Trim(rsTotInc.Monto) neq '' ? rsTotInc.Monto : 0)>

		<cfquery name="rsIncDespensa" datasource="#session.dsn#">
			select
				sum(ic.ICmontores) ICmontores
			from #prefijo#IncidenciasCalculo ic
			inner join CIncidentes ci
			on ci.CIid = ic.CIid
			where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
			and ci.CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="2DE">
		</cfquery>
		<cfset lVarPagoEsp = (Trim(rsIncDespensa.ICmontores) eq '' ? 0 : rsIncDespensa.ICmontores)>

		<cfset varTotGral = (varTotInc + varTotCS) - varTotISR - varTotCarg - varTotDeduc>

		<cfoutput>
			<tr>
				<td style="border:1px solid gray;" colspan="4">
					<table width="100%" align="center">
						<tr bgcolor="##CCCCCC">
							<th colspan="3" ALign="CENTER">CONCEPTOS CALCULADO EN LA NOMINA</th>
						</tr>
						<tr>
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="20%" align="center"><strong>Total Empleados</strong></td>
										<td width="20%" align="center"><strong>Total Percepciones</strong></td>
										<td width="20%" align="center"><strong>Total Retenciones</strong></td>
										<td width="20%" align="center"><strong>Pago en Especie</strong></td>
										<td width="20%" align="center"><strong>Pago en Efectivo</strong></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="20%" align="center">#LSNumberFormat(data.RecordCount,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat(varTotInc-lVarPagoEsp,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat(totRetenciones,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat(lVarPagoEsp,'9.00')#</td>
										<td width="20%" align="center">#LSNumberFormat((varTotGral - lVarPagoEsp),'9.00')#</td>
									</tr>
								</table>
							</td>
						</tr>

						<tr bgcolor="##e5e5e5">
							<td colspan="2"><strong>Descripci&oacute;n</strong></th>
							<td colspan="1"><strong>Total</strong></th>
						</tr>
						<tr><td colspan="3"><hr/></td></tr>
						<cfloop query="rsTodosXNom">
							<tr>
								<td colspan="2">&nbsp;&nbsp;#Descripcion#</td>
								<td align="right">#LSNumberFormat(Monto,'9.00')#</td>
							</tr>
						</cfloop>
						<tr><td colspan="3"><hr/></td></tr>
						<tr>
							<td colspan="2" align="right">
								<strong>TOTAL:&nbsp;</strong>
							</td>
							<td align="right">
								#LSNumberFormat(varTotGral,'9.00')#&nbsp;
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfoutput>
	</cfif>

<!--- nuevo --->
<cfcatch type="any">
	<!--- <cf_jdbcquery_close> --->
	<cfthrow object="#cfcatch#">
</cfcatch>
</cftry>
	<!--- <cf_jdbcquery_close> --->
<!--- nuevo --->
