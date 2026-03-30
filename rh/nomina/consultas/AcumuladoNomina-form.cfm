<!--- OPARRALES 2019-02-06
	- Reporte de acumulados de Nomina
 --->
<cf_htmlreportsheaders
			title="Acumulado de N&oacute;mina"
			filename="AcumuladoDeNomina#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls"
			ira="AcumuladoNomina-parametros.cfm"
			method="url">

<cfset prefijo = 'H'>
<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
	<cfquery name="data_centro" datasource="#session.DSN#" >
		select CFcodigo, CFdescripcion, CFpath
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfset varTextoDescRep = "">
<cfset varTextoExtra = "">
<cfset arrMeses = ArrayNew(1)>
<cfset arrayAppend(arrMeses,"ENERO")>
<cfset arrayAppend(arrMeses,"FEBRERO")>
<cfset arrayAppend(arrMeses,"MARZO")>
<cfset arrayAppend(arrMeses,"ABRIL")>
<cfset arrayAppend(arrMeses,"MAYO")>
<cfset arrayAppend(arrMeses,"JUNIO")>
<cfset arrayAppend(arrMeses,"JULIO")>
<cfset arrayAppend(arrMeses,"AGOSTO")>
<cfset arrayAppend(arrMeses,"SEPTIEMBRE")>
<cfset arrayAppend(arrMeses,"OCTUBRE")>
<cfset arrayAppend(arrMeses,"NOVIEMBRE")>
<cfset arrayAppend(arrMeses,"DICIEMBRE")>

<cfif IsDefined('url.TAcumulado') and url.TAcumulado eq 1>
	<cfset varTextoDescRep = "Acumulado por Semana">
<cfelseif IsDefined('url.TAcumulado') and url.TAcumulado eq 2>
	<cfset varTextoDescRep = "Acumulado por Mes">
<cfelseif IsDefined('url.TAcumulado') and url.TAcumulado eq 3>
	<cfset varTextoDescRep = "Acumulado por Catorcena">
<cfelseif IsDefined('url.TAcumulado') and url.TAcumulado eq 4>
	<cfset varTextoDescRep = "Acumulado por Quincena">
<cfelse>
	<cfset varTextoDescRep = "Reporte de Acumulados de Nomina">
</cfif>
<cfif IsDefined('url.corteEmp')>
	<cfset varTextoExtra = "y Empleados">
</cfif>

<cfset separadoTablasEnc = "padding-right: 5px; padding-left: 25px;">
<cfset separadoContenido = "padding-top: 5px; padding-bottom: 5px;">
<cfset contenidoEnc  = "font-size: 85%; padding-left:5px; padding-right:5px;">
<cfset encabezado = "font-size: 100%; font-weight:bold; padding-left:5px; padding-right:5px;">
<cfset contenido  = "font-size: 85%; padding-left:5px; padding-right:5px;">
<cfset resaltar   = "font-size:120%; font-weight:bold; padding-left:5px; padding-right:5px;">
<cfset miniBold   = "font-size:90%; font-weight:bold; padding-left:5px; padding-right:5px;">
<cfset lineaBottom	= "border-bottom: 2px solid;">
<cfsetting enablecfoutputonly="no">
<style>    DIV.pageBreak { page-break-before: always; }</style>

<!--- DEFINIMOS FECHA INICIO y FECHA FIN --->
<cfif  Tfiltro eq 1> 
	<cfset fechaIni = getfechaIni(CPperiodo=url.CPperiodo,Tcodigo=url.TNomina)>
	<cfset fechaFin = getfechaFin(CPperiodo=url.CPperiodo,Tcodigo=url.TNomina)>	
  <cfelse>
	<cfset fechaIni = LSDateFormat(url.FechaDesde,"yyyy-mm-dd")>
	<cfset fechaFin = LSDateFormat(url.FechaHasta,"yyyy-mm-dd")>
</cfif>

<cfquery name="rsValoresPV" datasource="#session.dsn#">
	select distinct
		cp.CPperiodo,
		<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4><!--- SEMANAL, CATORCENAL, QUINCENAL  --->
			cp.CPid
		<cfelse>
			cp.CPmes
		</cfif> as valorPV
	from CalendarioPagos cp
	where cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaIni#">
	and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaFin#">
	and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.TNomina#">
	and cp.CPfcalculo is not null <!--- TODOS LOS YA CALCULADOS --->
	order by <cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4><!--- SEMANAL, CATORCENAL, QUINCENAL --->
			cp.CPid
		<cfelse>
			cp.CPperiodo,cp.CPmes
		</cfif>
</cfquery>

<cfset varValoresPV = "">
<cfset varValoresPVDesc = "">
<cfset varPVDesc = "">
<cfset countPV = 1>
<cfset varColumnasPintar = "">

<cfif url.TAcumulado eq 1>
	<cfloop query="rsValoresPV">
		<cfset varValoresPV &= "[#valorPV#]">
		<cfset varValoresPVDesc &= "coalesce([#valorPV#],0) as SEMANA#countPV#">
		<cfset varPVDesc &= "SEMANA#countPV#">
		<cfset varColumnasPintar &= "SEMANA#countPV#">
		<cfif countPV neq rsValoresPV.RecordCount>
			<cfset varValoresPV &= ", ">
			<cfset varValoresPVDesc &= ", ">
			<cfset varPVDesc &= ", ">
			<cfset varColumnasPintar &= ", ">
		</cfif>
		<cfset countPV++>
	</cfloop>
	<cfelseif url.TAcumulado eq 3>
		<cfloop query="rsValoresPV">
			<cfset varValoresPV &= "[#valorPV#]">
			<cfset varValoresPVDesc &= "coalesce([#valorPV#],0) as CATORCENA#countPV#">
			<cfset varPVDesc &= "CATORCENA#countPV#">
			<cfset varColumnasPintar &= "CATORCENA#countPV#">
			<cfif countPV neq rsValoresPV.RecordCount>
				<cfset varValoresPV &= ", ">
				<cfset varValoresPVDesc &= ", ">
				<cfset varPVDesc &= ", ">
				<cfset varColumnasPintar &= ", ">
			</cfif>
			<cfset countPV++>
		</cfloop>
	<cfelseif url.TAcumulado eq 4>
		<cfloop query="rsValoresPV">
			<cfset varValoresPV &= "[#valorPV#]">
			<cfset varValoresPVDesc &= "coalesce([#valorPV#],0) as QUINCENA#countPV#">
			<cfset varPVDesc &= "QUINCENA#countPV#">
			<cfset varColumnasPintar &= "QUINCENA#countPV#">
			<cfif countPV neq rsValoresPV.RecordCount>
				<cfset varValoresPV &= ", ">
				<cfset varValoresPVDesc &= ", ">
				<cfset varPVDesc &= ", ">
				<cfset varColumnasPintar &= ", ">
			</cfif>
			<cfset countPV++>
		</cfloop>
<cfelse>
	<cfloop query="rsValoresPV">
		<cfif countPV lte arrayLen(arrMeses)>
			<cfset varValoresPV &= "[#rsValoresPV.valorPV#]">
			<cfset varValoresPVDesc &= "coalesce([#rsValoresPV.valorPV#],0) as #arrMeses[val(rsValoresPV.valorPV)]#">
			<cfset varPVDesc &= "#arrMeses[rsValoresPV.valorPV]#">
			<cfset varColumnasPintar &= "#arrMeses[rsValoresPV.valorPV]#">
			
			<cfif countPV lt rsValoresPV.RecordCount and countPV lt arrayLen(arrMeses)>
				<cfset varValoresPV &= ", ">
				<cfset varValoresPVDesc &= ", ">
				<cfset varPVDesc &= ", ">
				<cfset varColumnasPintar &= ", ">
			</cfif>
			<cfset countPV++>
		</cfif>
	</cfloop>
</cfif>


<cfset strEmpleado = "">
<cfif IsDefined('url.corteEmp')>
	<!--- <cfset strEmpleado = "EMPLEADO,"> --->
</cfif>
<cfset varColumnasPintar = "#strEmpleado#DESCRIPCION,"&varColumnasPintar>

<cfif varPVDesc neq ''> <!--- Sin nominas para consultar --->

<cfsavecontent variable="myQuery">
	<!--- DEDUCCION ISR --->
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					2 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'DEDUCCIONES' as TipoReg,
					'ISR' as Descripcion,
					sum(coalesce(cc.SErenta,0)) unMonto,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from HSalarioEmpleado cc
				inner join HRCalculoNomina rc
					on cc.RCNid = rc.RCNid
				inner join CalendarioPagos cp
					on cp.CPid = rc.RCNid
				inner join DatosEmpleado de
					on de.DEid = cc.DEid
				inner join LineaTiempo lt
					on cc.DEid = lt.DEid
					and lt.Ecodigo = rc.Ecodigo
					and lt.LTid = (select max(lt2.LTid)
				   						from LineaTiempo lt2
										where lt.DEid = lt2.DEid
											and lt2.LTdesde < = rc.RChasta
											and lt2.LThasta > = rc.RCdesde)
				inner join RHPlazas p
					on lt.RHPid = p.RHPid
					and lt.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta = #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				where cp.Tcodigo = '#url.TNomina#'
				and cp.CPdesde >= '#fechaIni#'
				and cp.CPhasta <= '#fechaFin#'
				and de.Ecodigo = #session.ecodigo#
				group by
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
							cp.CPid
				<cfelse>
					cp.CPmes,cp.CPdesde
				</cfif>
				<cfif IsDefined('url.corteEmp')>
					,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
				</cfif>
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					,concat(cf.CFcodigo,' ',cf.CFdescripcion)
				</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
					objISR.CPid
				<cfelse>
					objISR.CPmes
				</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>
	union
	<!--- DEDUCCIONES NORMALES --->
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					2 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(dem.DEidentificacion,' ',dem.DEnombre,' ',dem.DEapellido1,' ',dem.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'DEDUCCIONES' as TipoReg,
					de.Ddescripcion as Descripcion,
					sum(coalesce(dc.DCvalor,0)) as unMonto,

					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from
					#prefijo#DeduccionesCalculo dc
				inner join DatosEmpleado dem
					on dem.DEid = dc.DEid
				inner join DeduccionesEmpleado de
					on de.Did=dc.Did
				inner join #prefijo#RCalculoNomina rc
					on dc.RCNid = rc.RCNid
				inner join CalendarioPagos cp
					on cp.CPid = rc.RCNid
				inner join LineaTiempo lt
					on dem.DEid = lt.DEid
					and lt.Ecodigo = rc.Ecodigo
					and lt.LTid = (select max(lt2.LTid)
				   						from LineaTiempo lt2
										where lt.DEid = lt2.DEid
											and lt2.LTdesde < = rc.RChasta
											and lt2.LThasta > = rc.RCdesde)
				inner join RHPlazas p
					on lt.RHPid = p.RHPid
					and lt.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				where cp.Tcodigo = '#url.TNomina#'
				and cp.CPdesde >= '#fechaIni#'
				and cp.CPhasta <= '#fechaFin#'
				and de.Ecodigo = #session.ecodigo#
				group by
						de.Ddescripcion,
						<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
							cp.CPid
						<cfelse>
							cp.CPmes,cp.CPdesde
						</cfif>
						<cfif IsDefined('url.corteEmp')>
							,concat(dem.DEidentificacion,' ',dem.DEnombre,' ',dem.DEapellido1,' ',dem.DEapellido2)
						</cfif>
						<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
							,concat(cf.CFcodigo,' ',cf.CFdescripcion)
						</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>
	union
	<!--- CargasEmpleado --->
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					2 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'DEDUCCIONES' as TipoReg,
					'IMSS Empleado' as Descripcion,
					sum(cc.CCvaloremp) as unMonto,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from #prefijo#CargasCalculo cc
				inner join DatosEmpleado de
					on de.DEid = cc.DEid
				inner join DCargas c
					on c.DClinea = cc.DClinea
				inner join #prefijo#RCalculoNomina rc
					on cc.RCNid = rc.RCNid
				inner join CalendarioPagos cp
					on cp.CPid = rc.RCNid
				inner join LineaTiempo lt
					on de.DEid = lt.DEid
					and lt.Ecodigo = rc.Ecodigo
					and lt.LTid = (select max(lt2.LTid)
				   						from LineaTiempo lt2
										where lt.DEid = lt2.DEid
											and lt2.LTdesde < = rc.RChasta
											and lt2.LThasta > = rc.RCdesde)
				inner join RHPlazas p
					on lt.RHPid = p.RHPid
					and lt.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				where cp.Tcodigo = '#url.TNomina#'
				and cp.CPdesde >= '#fechaIni#'
				and cp.CPhasta <= '#fechaFin#'
				and de.Ecodigo = #session.ecodigo#
				group by
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
							cp.CPid
						<cfelse>
							cp.CPmes,cp.CPdesde
						</cfif>
						<cfif IsDefined('url.corteEmp')>
							,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
						</cfif>
						<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
							,concat(cf.CFcodigo,' ',cf.CFdescripcion)
						</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>

	union
	<!--- IncidenciasTodas --->
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					1 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'PERCEPCIONES' as TipoReg,
					concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))) as Descripcion,
					sum(case
							when ic.ICmontoant=0 and ci.CItipo in (0,1) then ic.ICmontores
							when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then 0
							else ic.ICmontores
						end) as unMonto,
						<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from
					#prefijo#IncidenciasCalculo ic
				inner join DatosEmpleado de
					on de.DEid = ic.DEid
				inner join CIncidentes ci
					on ci.CIid = ic.CIid
					and ci.CItimbrar = 0
				inner join #prefijo#RCalculoNomina rc
					on ic.RCNid = rc.RCNid
				inner join CalendarioPagos cp
					on cp.CPid = rc.RCNid
				inner join LineaTiempo lt
					on de.DEid = lt.DEid
					and lt.Ecodigo = rc.Ecodigo
					and lt.LTid = (select max(lt2.LTid)
				   						from LineaTiempo lt2
										where lt.DEid = lt2.DEid
											and lt2.LTdesde < = rc.RChasta
											and lt2.LThasta > = rc.RCdesde)
				inner join RHPlazas p
					on lt.RHPid = p.RHPid
					and lt.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				where cp.Tcodigo = '#url.TNomina#'
				and cp.CPdesde >= '#fechaIni#'
				and cp.CPhasta <= '#fechaFin#'
				and de.Ecodigo = #session.ecodigo#
				group by
						concat(LTRIM(RTRIM(ci.CIcodigo)),'- ',LTRIM(RTRIM(ci.CIdescripcion))),
						<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
							cp.CPid
						<cfelse>
							cp.CPmes,cp.CPdesde
						</cfif>
						<cfif IsDefined('url.corteEmp')>
							,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
						</cfif>
						<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
							,concat(cf.CFcodigo,' ',cf.CFdescripcion)
						</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>

	union
	<!--- ComponentesSalariales --->
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					1 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'PERCEPCIONES' as TipoReg,
					'SUELDOS' as Descripcion,

					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						<cfif IsDefined('url.corteEmp')>
							cc.SEsalariobruto as unMonto,
						<cfelse>
							sum(cc.SEsalariobruto) as unMonto,
						</cfif>
						cp.CPid
					<cfelse>
						sum(cc.SEsalariobruto) as unMonto,
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from
					#prefijo#SalarioEmpleado cc
				inner join DatosEmpleado de
					on de.DEid = cc.DEid
				inner join #prefijo#RCalculoNomina rc
					on cc.RCNid = rc.RCNid
				inner join CalendarioPagos cp
					on cp.CPid = rc.RCNid
				inner join LineaTiempo lt
					on de.DEid = lt.DEid
					and lt.Ecodigo = rc.Ecodigo
					and lt.LTid = (select max(lt2.LTid)
				   						from LineaTiempo lt2
										where lt.DEid = lt2.DEid
											and lt2.LTdesde < = rc.RChasta
											and lt2.LThasta > = rc.RCdesde)
				inner join RHPlazas p
					on lt.RHPid = p.RHPid
					and lt.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				where cp.Tcodigo = '#url.TNomina#'
				and cp.CPdesde >= '#fechaIni#'
				and cp.CPhasta <= '#fechaFin#'
				and de.Ecodigo = #session.ecodigo#
				group by 
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
							cc.SEsalariobruto,
							cp.CPid
						<cfelse>
							cp.CPmes,cp.CPdesde
						</cfif>
						<cfif IsDefined('url.corteEmp')>
							,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
						</cfif>
						<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
							,concat(cf.CFcodigo,' ',cf.CFdescripcion)
						</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>

	<!--- ========== SE COMPLEMENTA PARA INCLUIR MONTOS DE LIQUIDACIONES Y FINIQUITOS ========== --->
	<!--- INGRESOS LIQUIDACION --->
	union
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select DISTINCT 
					1 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'PERCEPCIONES' as TipoReg,
					RHLPdescripcion Descripcion,
					sum(coalesce(ld.importe,0)) unMonto,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from
					RHLiquidacionPersonal liq
				inner join DLaboralesEmpleado dl
					on liq.DLlinea = dl.DLlinea
					and liq.Ecodigo = dl.Ecodigo
					and dl.DEid = liq.DEid
					and liq.RHLPestado=1					
				inner join DatosEmpleado de
					on de.DEid = dl.DEid
				inner join RHLiqIngresos ld
					on ld.DLlinea = dl.DLlinea
					and dl.DEid = ld.DEid
				inner join RHPlazas p
					on dl.RHPid = p.RHPid
					and dl.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				inner join CalendarioPagos cp
					on dl.DLfvigencia between cp.CPdesde and cp.CPhasta
					and cp.Tcodigo = '#url.TNomina#'
					and cp.Ecodigo = #session.ecodigo#
					and cp.CPdesde != cp.CPfpago
				WHERE dl.DLfvigencia between '#fechaIni#' and '#fechaFin#'
				and RHLPestado = 1 <!--- CONFECCIONES DE LIQUIDACION APLICADAS --->
				and de.Ecodigo = #session.ecodigo#
				group by
					RHLPdescripcion,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						cp.CPmes,case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end

					</cfif>
					<cfif IsDefined('url.corteEmp')>
						,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						,concat(cf.CFcodigo,' ',cf.CFdescripcion)
					</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>

	<!--- DEDUCCIONES LIQUIDACION --->
	union
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					2 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'DEDUCCIONES' as TipoReg,
					RHLDdescripcion Descripcion,
					sum(coalesce(ld.importe,0)) unMonto,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						cp.CPmes
					</cfif>
				from
					RHLiquidacionPersonal liq
				inner join DLaboralesEmpleado dl
					on liq.DLlinea = dl.DLlinea
					and liq.Ecodigo = dl.Ecodigo
					and dl.DEid = liq.DEid
					and liq.RHLPestado=1					
				inner join DatosEmpleado de
					on de.DEid = dl.DEid
				inner join RHLiqDeduccion ld
					on ld.DLlinea = dl.DLlinea
					and dl.DEid = ld.DEid
				inner join RHPlazas p
					on dl.RHPid = p.RHPid
					and dl.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				inner join CalendarioPagos cp
					on dl.DLfvigencia between cp.CPdesde and cp.CPhasta
					and cp.Tcodigo = '#url.TNomina#'
					and cp.Ecodigo = #session.ecodigo#
				WHERE dl.DLfvigencia between '#fechaIni#' and '#fechaFin#'
				and RHLPestado = 1 <!--- CONFECCIONES DE LIQUIDACION APLICADAS --->
				and de.Ecodigo = #session.ecodigo#
				group by
					RHLDdescripcion,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						cp.CPmes,cp.CPdesde
					</cfif>
					<cfif IsDefined('url.corteEmp')>
						,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						,concat(cf.CFcodigo,' ',cf.CFdescripcion)
					</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>

	<!--- FINIQUITO-LIQUIDACION CARGAS --->
	union
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select
					2 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'DEDUCCIONES' as TipoReg,
					RHLCdescripcion Descripcion,
					sum(coalesce(ld.importe,0)) unMonto,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from
					RHLiquidacionPersonal liq
				inner join DLaboralesEmpleado dl
					on liq.DLlinea = dl.DLlinea
					and liq.Ecodigo = dl.Ecodigo
					and dl.DEid = liq.DEid
					and liq.RHLPestado=1
				inner join DatosEmpleado de
					on de.DEid = dl.DEid
				inner join RHLiqCargas ld
					on ld.DLlinea = dl.DLlinea
					and dl.DEid = ld.DEid
				inner join RHPlazas p
					on dl.RHPid = p.RHPid
					and dl.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				inner join CalendarioPagos cp
					on dl.DLfvigencia between cp.CPdesde and cp.CPhasta
					and cp.Tcodigo = '#url.TNomina#'
					and cp.Ecodigo = #session.ecodigo#
				WHERE dl.DLfvigencia between '#fechaIni#' and '#fechaFin#'
				and RHLPestado = 1 <!--- CONFECCIONES DE LIQUIDACION APLICADAS --->
				and de.Ecodigo = #session.ecodigo#
				group by
					RHLCdescripcion,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						cp.CPmes,cp.CPdesde
					</cfif>
					<cfif IsDefined('url.corteEmp')>
						,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						,concat(cf.CFcodigo,' ',cf.CFdescripcion)
					</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>

	<!--- FINIQUITO-LIQUIDACION ISPT SALARIO --->
	union
	<cfoutput>
		select
			ORDEN,
			<cfif IsDefined('url.corteEmp')>
				Empleado,
			</cfif>
			TipoReg,
			Descripcion,
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				CFcodigo,
			</cfif>
			#varPVDesc#
		FROM
		(
			select
				ORDEN,
				<cfif IsDefined('url.corteEmp')>
					Empleado,
				</cfif>
				TipoReg,
				Descripcion,
				<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
					CFcodigo,
				</cfif>
				#varValoresPVDesc#
			from
			(
				select DISTINCT 
					2 AS ORDEN,
					<cfif IsDefined('url.corteEmp')>
						concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Empleado,
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						concat(cf.CFcodigo,' ',cf.CFdescripcion) as CFcodigo,
					</cfif>
					'DEDUCCIONES' as TipoReg,
					'ISPT SALARIO' Descripcion,
					sum(coalesce(ld.RHLFLisptF,0)) unMonto,
					<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						case when cp.CPmes = 12 and  YEAR(cp.CPdesde) < #CPperiodo# then 1 else cp.CPmes end as CPmes
					</cfif>
				from
					RHLiquidacionPersonal liq
				inner join DLaboralesEmpleado dl
					on liq.DLlinea = dl.DLlinea
					and liq.Ecodigo = dl.Ecodigo
					and dl.DEid = liq.DEid
					and liq.RHLPestado=1
				inner join DatosEmpleado de
					on de.DEid = dl.DEid
				inner join RHLiqFL ld
					on ld.DLlinea = dl.DLlinea
					and dl.DEid = ld.DEid
				inner join RHPlazas p
					on dl.RHPid = p.RHPid
					and dl.Ecodigo = p.Ecodigo
					<cfif not isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and p.CFidconta =  #url.CFid#
					</cfif>
				inner join CFuncional cf
					on cf.CFid=coalesce(p.CFidconta, p.CFid)
					<cfif isdefined("url.dependencias") and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						and cf.CFpath like '#trim(data_centro.CFpath)#%'
					</cfif>
				inner join CalendarioPagos cp
					on dl.DLfvigencia between cp.CPdesde and cp.CPhasta
					and cp.Tcodigo = '#url.TNomina#'
					and cp.Ecodigo = #session.ecodigo#
				WHERE dl.DLfvigencia between '#fechaIni#' and '#fechaFin#'
				and RHLPestado = 1 <!--- CONFECCIONES DE LIQUIDACION APLICADAS --->
				and de.Ecodigo = #session.ecodigo#
				group by
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						cp.CPid
					<cfelse>
						cp.CPmes,cp.CPdesde
					</cfif>
					<cfif IsDefined('url.corteEmp')>
						,concat(de.DEidentificacion,' ',de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2)
					</cfif>
					<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
						,concat(cf.CFcodigo,' ',cf.CFdescripcion)
					</cfif>
			) objISR
			pivot
			(
				sum(objISR.unMonto)
				for
				<cfif url.TAcumulado eq 1 or url.TAcumulado eq 3 or url.TAcumulado eq 4>
						objISR.CPid
					<cfelse>
						objISR.CPmes
					</cfif>
				in (#varValoresPV#)
			) objP
		) as objSum
	</cfoutput>



	order by 
	<!--- ORDEN FILTRO CON CF Y EMPLEADO --->
	<cfif IsDefined('url.corteEmp') and IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
		CFcodigo,
		EMPLEADO,
		ORDEN,
		Descripcion
	<!--- ORDEN FILTRO CON EMPLEADO SIN CF --->
	<cfelseif IsDefined('url.corteEmp') and not (IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0)>
		EMPLEADO,
		ORDEN,
		Descripcion
	<!--- ORDEN FILTRO CON CF SIN EMPLEADO --->
	<cfelseif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
		CFcodigo,
		ORDEN,
		Descripcion
	<!--- ORDEN FITRO SIN CF Y SIN EMPLEADO (PUROS CONCEPTOS) --->
	<cfelse>
		ORDEN,
		Descripcion
	</cfif>
</cfsavecontent>
	<cfquery name="unRS" datasource="#session.dsn#">
		#PreserveSingleQuotes(myQuery)#
	</cfquery>
	
</cfif>

<cfset numCols = ListLen(varColumnasPintar)>
<cfset wTable = 100>
<cfif numCols lte 4>
	<cfset wTable = 60>
<cfelseif numCols lte 8>
	<cfset wTable = 80>
</cfif>
<cfoutput>
	<cf_templatecss>
	<cfsetting requesttimeout="8600">
	<cfif not isdefined('url.corteBoleta') and not isdefined('url.Encabezado')>
		<table width="#wTable#%" cellpadding="3" cellspacing="0" align="center">
			<tr>
				<td align="center" colspan="#numCols#" style="#resaltar#">
					<strong>#session.Enombre#</strong><br />
				</td>
			</tr>
			<tr>
				<td align="center" colspan="#numCols#" style="#miniBold#">
					<strong><cf_translate key="LB_Resumen_de_Boletas_de_Pago"><strong>Reporte Acumulado de N&oacute;mina</strong></cf_translate></strong><br />
				</td>
			</tr>
			<tr>
				<td align="center" colspan="#numCols#" style="#miniBold#">
					<strong><cf_translate key="LB_Nomina">#varTextoDescRep#&nbsp;</cf_translate></strong><br /><cf_translate key="LB_Del">#varTextoExtra#</cf_translate>&nbsp;<br />
				</td>
			</tr>
			<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
				<tr>
					<td align="center" colspan="#numCols#" style="#miniBold#">
						<strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate></strong>&nbsp;</strong><br />#trim(data_centro.CFcodigo)# - #data_centro.CFdescripcion#<br /><br />
					</td>
				</tr>
			</cfif>
		</table>
	</cfif>

<table width="#wTable#%" align="center" border="0">
</cfoutput>
	<cfoutput>
		
	  <cfif IsDefined('unRS')>
		<cfif IsDefined('url.CFid') and Trim(url.CFid) neq '' and url.CFid gt 0>
			<cfif IsDefined('url.corteEmp')>
				#pintaConEmpCF()#
			<cfelse>
				#pintaSinEmpCF()#
			</cfif>
		<cfelse>
			<cfif IsDefined('url.corteEmp')>
				#pintaConEmp()#
			<cfelse>
				#pintaSimple()#
			</cfif>
		</cfif>
		<cfelse>
			#pintaSinNominas()#
      </cfif>
	</cfoutput>

</table>
<cffunction access="private" name="getEncabezado" output="true">
	<tr>
		<cfloop list="#varColumnasPintar#" item="unaColumna">
			<cfoutput>
				<td style="#encabezado##lineaBottom#" align="#(Trim(unaColumna) eq 'Descripcion' ? 'LEFT' : 'RIGHT')#">#unaColumna#</td>
			</cfoutput>
		</cfloop>
		<td style="#encabezado##lineaBottom#" align="right">TOTAL</td>
	</tr>
</cffunction>

<cffunction name="pintaConEmpCF" access="private" output="true">
	<cfoutput query="unRS" group="CFcodigo">
		<tr>
			<td colspan="#numCols+1#" style="#resaltar##lineaBottom#">#CFcodigo#</td>
		</tr>
		<cfoutput group="EMPLEADO">
			<tr>
				<td colspan="#numCols+1#" style="#resaltar##lineaBottom#">#EMPLEADO#</td>
			</tr>
			#getEncabezado()#
			<cfoutput group="TIPOREG">
				<tr>
					<td colspan="" style="#minibold#">
						#TIPOREG#
					</td>
				</tr>
				<CFSET miValor = 0>
				<cfset varSrtcMontos = StructNew()>
				<cfloop list="#varColumnasPintar#" item="unaColumna">
					<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
						<cfcontinue/>
					</cfif>
					<cfscript>
						StructInsert(varSrtcMontos,'#unaColumna#',0,true);
					</cfscript>
				</cfloop>
				<cfoutput>
					<tr>
						<cfset totalXFila = 0>
						<cfset countF = 1>
						<cfloop list="#varColumnasPintar#" item="unaColumna">
							<cfif UCASE(unaColumna) eq 'DESCRIPCION' or UCASE(unaColumna) eq 'EMPLEADO'>
								<td style="#contenido#" align="left">#unRS['#Ucase(Trim(unaColumna))#'][currentrow]#</td>
							<cfelse>
								<cfset varMontoTmpFormat = LSNumberFormat((Trim(unRS['#Trim(unaColumna)#'][currentrow]) eq '' ? 0 : unRS['#Trim(unaColumna)#'][currentrow]),",9.00")>
								<td align="right" style="#contenido#">
									#varMontoTmpFormat#
								</td>
								<cfset varMontoTmp = Replace(varMontoTmpFormat,",","","all")>
								<cfset montoAnt = varSrtcMontos['#unaColumna#']>
								<cfset StructUpdate(varSrtcMontos,'#unaColumna#',montoAnt+varMontoTmp)>
								<cfset totalXFila += varMontoTmp>
								<cfset countF+=1>

								<!--- PINTAMOS TOTAL--->
								<cfif Listlen(varColumnasPintar) eq countF>
									<td align="right" style="#contenido#">
										#LSNumberFormat(totalXFila,',9.00')#
									</td>
								</cfif>
							</cfif>
						</cfloop>
					</tr>
				</cfoutput>
				<TR>
					<td colspan="" style="#minibold#">
						TOTAL #TIPOREG#
					</td>
					<cfset totXTipReg = 0>
					<cfloop list="#varColumnasPintar#" item="unaColumna">
						<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
							<cfcontinue/>
						</cfif>
						<cfset totalTmp = varSrtcMontos['#unaColumna#']>
						<cfset totXTipReg += (Trim(totalTmp) eq '' ? 0 : totalTmp)>
						<td align="right" style="#minibold#">#LSNumberFormat(totalTmp,',9.00')#</td>
					</cfloop>
					<td align="right" style="#minibold#">#LSNumberFormat(totXTipReg,',9.00')#</td>
				</TR>
			</cfoutput>
		</cfoutput>
	</cfoutput>
</cffunction>

<cffunction name="pintaSinEmpCF" access="private" output="true">
	<cfoutput query="unRS" group="CFcodigo">
		<tr>
			<td colspan="#numCols+1#" style="#resaltar##lineaBottom#">#CFcodigo#</td>
		</tr>
		#getEncabezado()#
		<cfoutput group="TIPOREG">
			<tr>
				<td colspan="" style="#minibold#">
					#TIPOREG#
				</td>
			</tr>
			<CFSET miValor = 0>
			<cfset varSrtcMontos = StructNew()>
			<cfloop list="#varColumnasPintar#" item="unaColumna">
				<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
					<cfcontinue/>
				</cfif>
				<cfscript>
					StructInsert(varSrtcMontos,'#unaColumna#',0,true);
				</cfscript>
			</cfloop>
			<cfoutput>
				<tr>
					<cfset totalXFila = 0>
					<cfset countF = 1>
					<cfloop list="#varColumnasPintar#" item="unaColumna">
						<cfif UCASE(unaColumna) eq 'DESCRIPCION' or UCASE(unaColumna) eq 'EMPLEADO'>
							<td style="#contenido#" align="left">#unRS['#Ucase(Trim(unaColumna))#'][currentrow]#</td>
						<cfelse>
							<cfset varMontoTmpFormat = LSNumberFormat((Trim(unRS['#Trim(unaColumna)#'][currentrow]) eq '' ? 0 : unRS['#Trim(unaColumna)#'][currentrow]),",9.00")>
							<td align="right" style="#contenido#">
								#varMontoTmpFormat#
							</td>
							<cfset montoAnt = varSrtcMontos['#unaColumna#']>
							<cfset varMontoTmp = Replace(varMontoTmpFormat,",","","all")>
							<cfset StructUpdate(varSrtcMontos,'#unaColumna#',montoAnt+varMontoTmp)>

							<cfset varMontoTmp = Replace(varMontoTmpFormat,",","","all")>
							<cfset montoAnt = varSrtcMontos['#unaColumna#']>
							<cfset totalXFila += varMontoTmp>
							<cfset countF+=1>

							<!--- PINTAMOS TOTAL--->
							<cfif Listlen(varColumnasPintar) eq countF>
								<td align="right" style="#contenido#">
									#LSNumberFormat(totalXFila,',9.00')#
								</td>
							</cfif>
						</cfif>
					</cfloop>
				</tr>
			</cfoutput>
			<tr>
				<td colspan="" style="#minibold#">
					TOTAL #TIPOREG#
				</td>
				<cfset totXTipReg = 0>
				<cfloop list="#varColumnasPintar#" item="unaColumna">
					<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
						<cfcontinue/>
					</cfif>
					<cfset totalTmp = varSrtcMontos['#unaColumna#']>
					<cfset totXTipReg += (Trim(totalTmp) eq '' ? 0 : totalTmp)>
					<td align="right" style="#minibold#">#LSNumberFormat(totalTmp,',9.00')#</td>
				</cfloop>
				<td align="right" style="#minibold#">#LSNumberFormat(totXTipReg,',9.00')#</td>
			</tr>
		</cfoutput>
	</cfoutput>
</cffunction>

<cffunction name="pintaConEmp" access="private" output="true">
	<cfoutput query="unRS" group="EMPLEADO">
		<tr>
			<td colspan="#numCols+1#" style="#resaltar##lineaBottom#">#EMPLEADO#</td>
		</tr>
		#getEncabezado()#
		<cfoutput group="TIPOREG">
			<CFSET miValor = 0>
			<cfset varSrtcMontos = StructNew()>
			<cfloop list="#varColumnasPintar#" item="unaColumna">
				<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
					<cfcontinue/>
				</cfif>
				<cfscript>
					StructInsert(varSrtcMontos,'#unaColumna#',0,true);
				</cfscript>
			</cfloop>
			<tr>
				<td colspan="#numCols+1#" style="#minibold#">
					#TIPOREG#
				</td>
			</tr>

			<cfoutput>
				<tr>
					<cfset totalXFila = 0>
					<cfset countF = 1>
					<cfloop list="#varColumnasPintar#" item="unaColumna">
						<cfif UCASE(unaColumna) eq 'DESCRIPCION' or UCASE(unaColumna) eq 'EMPLEADO'>
							<td style="#contenido#" align="left">#unRS['#Ucase(Trim(unaColumna))#'][currentrow]#</td>
						<cfelse>
							<cfset varMontoTmpFormat = LSNumberFormat((Trim(unRS['#Trim(unaColumna)#'][currentrow]) eq '' ? 0 : unRS['#Trim(unaColumna)#'][currentrow]),",9.00")>
							<td align="right" style="#contenido#">
								#varMontoTmpFormat#
							</td>
							<cfset varMontoTmp = Replace(varMontoTmpFormat,",","","all")>
							<cfset montoAnt = varSrtcMontos['#unaColumna#']>
							<cfset StructUpdate(varSrtcMontos,'#unaColumna#',montoAnt+varMontoTmp)>
							<cfset totalXFila += varMontoTmp>
							<cfset countF+=1>

							<!--- PINTAMOS TOTAL--->
							<cfif Listlen(varColumnasPintar) eq countF>
								<td align="right" style="#contenido#">
									#LSNumberFormat(totalXFila,',9.00')#
								</td>
							</cfif>
						</cfif>
					</cfloop>
				</tr>
			</cfoutput>
			<TR>
				<td colspan="" style="#minibold#">
					TOTAL #TIPOREG#
				</td>
				<cfset totXTipReg = 0>
				<cfloop list="#varColumnasPintar#" item="unaColumna">
					<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
						<cfcontinue/>
					</cfif>
					<cfset totalTmp = varSrtcMontos['#unaColumna#']>
					<cfset totXTipReg += (Trim(totalTmp) eq '' ? 0 : totalTmp)>
					<td align="right" style="#minibold#">#LSNumberFormat(totalTmp,',9.00')#</td>
				</cfloop>
				<!--- ULTIMA COLUMNA TOTAL DE TOTALES SEGUN ACUMULADO --->
				<td align="right" style="#minibold#">#LSNumberFormat(totXTipReg,',9.00')#</td>
			</TR>
		</cfoutput>
	</cfoutput>
</cffunction>

<cffunction name="pintaSimple" access="private" output="true">
	#getEncabezado()#
	<cfoutput query="unRS" group="ORDEN">
		<tr>
			<td colspan="#numCols+1#" style="#minibold#">#TIPOREG#</td>
		</tr>
		<CFSET miValor = 0>
		<cfset varSrtcMontos = StructNew()>
		<cfloop list="#varColumnasPintar#" item="unaColumna">
			<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
				<cfcontinue/>
			</cfif>
			<cfscript>
				StructInsert(varSrtcMontos,'#unaColumna#',0,true);
			</cfscript>
		</cfloop>
		<cfoutput>
			<tr>
				<cfset totalXFila = 0>
				<cfset countF = 1>
				<cfloop list="#varColumnasPintar#" item="unaColumna">
					<cfif UCASE(unaColumna) eq 'DESCRIPCION' or UCASE(unaColumna) eq 'EMPLEADO'>
						<td style="#contenido#" align="left">#unRS['#Ucase(Trim(unaColumna))#'][currentrow]#</td>
						<cfset totalXFila = 0>
					<cfelse>
						<cfset varMontoTmpFormat = LSNumberFormat((Trim(unRS['#Trim(unaColumna)#'][currentrow]) eq '' ? 0 : unRS['#Trim(unaColumna)#'][currentrow]),",9.00")>
						<td align="right" style="#contenido#">
							#varMontoTmpFormat#
						</td>
						<cfset varMontoTmp = Replace(varMontoTmpFormat,",","","all")>
						<cfset montoAnt = varSrtcMontos['#unaColumna#']>
						<cfset totalXFila += varMontoTmp>
						<cfset countF+=1>

						<!--- PINTAMOS TOTAL--->
						<cfif Listlen(varColumnasPintar) eq countF>
							<td align="right" style="#contenido#">
								#LSNumberFormat(totalXFila,',9.00')#
							</td>
						</cfif>
						<cfset StructUpdate(varSrtcMontos,'#unaColumna#',montoAnt+varMontoTmp)>
					</cfif>
				</cfloop>
			</tr>
		</cfoutput>
		<TR>
			<td colspan="" style="#minibold#" align="LEFT">
				TOTAL #TIPOREG#
			</td>
			<CFSET totXTipReg = 0>
			<cfloop list="#varColumnasPintar#" item="unaColumna">
				<cfif Ucase(TRIM(unaColumna)) eq 'DESCRIPCION' or ucase(tRIM(unaColumna)) eq 'EMPLEADO'>
					<cfcontinue/>
				</cfif>
				<cfset totalTmp = varSrtcMontos['#unaColumna#']>
				<CFSET totXTipReg += (Trim(totalTmp) eq '' ? 0 : totalTmp)>
				<td align="right" style="#minibold#">#LSNumberFormat(totalTmp,',9.00')#</td>
			</cfloop>
			<td align="right" style="#minibold#">#LSNumberFormat(totXTipReg,',9.00')#</td>
		</TR>
	</cfoutput>
</cffunction>

<cffunction  name="getfechaIni" access="private">
	<cfargument  name="CPperiodo"  required="true">
	<cfargument  name="Tcodigo"  required="true">

	<cfquery name="rsPrimerSemana" datasource="#session.DSN#">
	select  top 1 CPdesde 
	from CalendarioPagos where CPdesde > (select top 1 CPhasta from CalendarioPagos 
																				where YEAR(CPhasta)=(#CPperiodo#-1)
																				and Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
																				and CPesUltimaSemana=<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
																				order by CPhasta desc)
																				order by CPdesde asc
	</cfquery>
	<cfif rsPrimerSemana.CPdesde neq ''>
		<cfreturn rsPrimerSemana.CPdesde>
	<cfelse>
		<cfquery name="rsDesde" datasource="#session.DSN#">
			SELECT
   				DATEADD(yy, DATEDIFF(yy, 0, CONCAT('#CPperiodo#','0101')), 0) AS StartOfYear
		</cfquery>
		<cfreturn rsDesde.StartOfYear>
	</cfif>
	

</cffunction>

<cffunction  name="getfechaFin" access="private">
	<cfargument  name="CPperiodo"  required="true">
	<cfargument  name="Tcodigo"  required="true">
	<cfquery name="rsCurrentYear" datasource="#session.DSN#">
		SELECT YEAR(CURRENT_TIMESTAMP) as year
	</cfquery>
	<cfif CPperiodo eq rsCurrentYear.year>
		<cfquery name="rsUltimo" datasource="#session.dsn#">
			select top 1 CPhasta
				from CalendarioPagos
				where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
				and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
				order by CPhasta desc
		</cfquery>
		<cfreturn rsUltimo.CPhasta>
	<cfelse>
		<cfquery name="rsUltimaSemana" datasource="#session.DSN#">
			select top 1 CPhasta
			 from CalendarioPagos 
   			 where YEAR(CPhasta)=#CPperiodo#
   			 and Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
			 and CPesUltimaSemana=<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
			 order by CPhasta desc   
		</cfquery>
		<cfif rsUltimaSemana.CPhasta neq "">
			<cfreturn rsUltimaSemana.CPhasta>
		<cfelse>
			<cfquery name="rsHasta" datasource="#session.DSN#">
				SELECT
   					DATEADD(yy, DATEDIFF(yy, 0, CONCAT('#CPperiodo#','0101')) + 1, -1) AS EndOfYear
			</cfquery>
			<cfreturn rsHasta.EndOfYear>
		</cfif>

	</cfif>
</cffunction>
<cffunction access="private" name="pintaSinNominas" output="true">
	<tr>
		<td style="#encabezado##lineaBottom#" align="Center"></td>
	</tr>
	<tr>
		<cfoutput><td style="#encabezado##lineaBottom#" align="Center">Sin Resultados para: #varTextoDescRep#</td></cfoutput>
	</tr>
</cffunction>