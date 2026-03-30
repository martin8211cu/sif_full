
<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_translatedata name="get" tabla="CFuncional" col="CF.CFdescripcion" returnvariable="LvarCFdescripcion">  

<cfset pre = 'H'>
<!--- <cfif isDefined("CKNOMINASHISTORICAS")>
 	 <cfset pre='H'>
 </cfif>
---> 

<cfquery name="rsPrefiltro" datasource="#session.dsn#">
	select distinct rct.RCNid, coalesce(dc.DClinea,0) as DClinea, dc.DCcodigo, dc.DCdescripcion, rct.tiporeg
	from RCuentasTipo rct
	inner join #pre#RCalculoNomina hr
		on rct.RCNid = hr.RCNid
	left join DCargas dc
		on dc.DClinea = rct.referencia
		<cfif isDefined("form.CARGASLIST") and len(trim(form.CARGASLIST))>
			and dc.DClinea in (#form.CARGASLIST#)
		</cfif>
	where rct.Ecodigo = #session.Ecodigo#
	<cfif isDefined("form.LISTATCODIGOCALENDARIO1") and len(trim(form.LISTATCODIGOCALENDARIO1))>
		and rct.RCNid in (#form.LISTATCODIGOCALENDARIO1#)
	</cfif>
	<cfif isDefined("form.CKUTILIZARFILTROFECHAS")>
		<cfif len(trim(form.FechaHasta))>
			and hr.RCdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
		<cfif len(trim(form.FechaDesde))>
			and hr.RChasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
	</cfif>
	<cfif isdefined("form.CFcuenta1") and len(trim(form.CFcuenta1))>
		and rct.CFcuenta = #form.CFcuenta1#
	</cfif>
</cfquery> 

<cfif rsPrefiltro.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
</cfif>	

<!--- lista de nominas --->
<cfquery dbtype="query" name="rsNominas">
	select distinct RCNid
	from rsPrefiltro
</cfquery>
<cfset listaNominas = valueList(rsNominas.RCNid)>

<!--- obtiene las distintas cargas a mostrar --->
<cfquery dbtype="query" name="rsCargas">
	select distinct DClinea, DCcodigo, DCdescripcion
	from rsPrefiltro
	where DClinea != 0 and tiporeg = 30
</cfquery>
<cfset listaCargas = valueList(rsCargas.DClinea)>

<!--- realiza el filtro a las nominas seleccionadas --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select x.cuenta, x.nombre, x.codigo, x.anno, x.mes, min(x.mesMin) as mesMin, max(x.mesMax) as mesMax, max(x.tipocambio) as tipocambio, 
		sum(case when x.regla = 1 then 
				x.salario * x.tipocambio 
		    when x.regla = 2 then 
		    	x.salario / x.tipocambio 
		    else x.salario end
		) as salario,
		sum(case when x.regla = 1 then 
				x.otrosingresos * x.tipocambio 
			when x.regla = 2 then  
				x.otrosingresos / x.tipocambio 
			else x.otrosingresos end 
		) as otrosingresos

		<cfloop list="#listaCargas#" index="i">
			,sum(case when x.regla = 1 then 
					x.carga_#i# * x.tipocambio 
				when x.regla = 2 then 
					x.carga_#i# / x.tipocambio 
				else x.carga_#i# end 
			) as carga_#i#
		</cfloop>
	from (
		select  <cf_dbfunction name="spart" args="rct.Cformato,6,100"> as cuenta,
			de.DEidentificacion as codigo,
			de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as nombre,
			rct.Periodo as anno,
			rct.Mes as mes,
			case when rct.tiporeg = 10 then 	
				rct.montores 
			else 0 end as salario,
			case when rct.tiporeg = 20 <cfif isDefined("form.INCIDENCIASLIST") and len(trim(form.INCIDENCIASLIST))> and rct.referencia in (#form.INCIDENCIASLIST#) </cfif> then 	
				rct.montores 
			else 0 end as otrosingresos
			<cfloop list="#listaCargas#" index="i">
				,case when rct.tiporeg = 30 and rct.referencia = #i# then rct.montores else 0 end as carga_#i#
			</cfloop>
			,cp.CPfpago as mesMax
			,cp.CPfpago as mesMin
			,coalesce(rcn.RCtc,1) as tipocambio,	
			coalesce( (
					    select coalesce(RCMregla,0)
			            from RHReglaConvMoneda 
			            where McodigoOrig = rcn.Mcodigo
			            and McodigoDest = (select Mcodigo 
											from Monedas 
											where Ecodigo = rcn.Ecodigo 
											and Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.sMoneda#"/>
										) 
			            ) ,0) as regla
		from RCuentasTipo rct
		inner join HRCalculoNomina rcn
			on rct.RCNid = rcn.RCNid
		inner join CalendarioPagos cp
			on rcn.RCNid = cp.CPid	
		inner join DatosEmpleado de
			on rct.DEid = de.DEid	
		where rct.RCNid in (#listaNominas#)
			<cfif isdefined("form.CFcuenta1") and len(trim(form.CFcuenta1))>
				and rct.CFcuenta = #form.CFcuenta1#
			</cfif>
			and rct.tiporeg in(10,20,30,40)
			and not exists (select 1 from CIncidentes where CIid = rct.referencia and CInoanticipo = 1 and 20=rct.tiporeg)
            <cfif isdefined("form.LISTADEIDEMPLEADO") and len(trim(form.LISTADEIDEMPLEADO))>
            	and rct.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO#" list="true" />) 
            </cfif>
        ) x
	group by x.nombre, x.cuenta, x.codigo, x.anno, x.mes
	order by x.codigo, x.nombre, x.cuenta, x.anno, x.mes 
</cfquery>
 
<cfif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cfquery dbtype="query" name="rsTotales">
		select sum(salario) as totSalario, sum(otrosingresos) as totOtrosIngresos
		<cfloop query="#rsCargas#">
			, sum(carga_#DClinea#) as totCarga_#DClinea#
		</cfloop>
		from rsReporte
	</cfquery>

	<cfinclude template="ReporteCostosSalariales-html.cfm">
</cfif>
