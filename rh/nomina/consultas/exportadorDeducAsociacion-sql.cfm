<cfparam name="url.periodo" 		type="integer" 	default="-1">	<!----Periodo--->
<cfparam name="url.mes" 			type="integer"	default="-1">	<!----Mes--->
<cfparam name="url.calendariopago" 	type="numeric" 	default="-1">	<!---Calendario de pago---->
<cfparam name="url.historico" 		type="string" 	default="0">	<!---Son nominas historicas---->
<!----Variables de traduccion---->
<cfinvoke Key="MSG_NoHayDatosParaLosFiltrosSeleccionados" Default="No hay datos para los filtros seleccionados" returnvariable="MSG_NoHayDatosParaLosFiltrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" Default="No se ha definido el formato para la generación del archivo" returnvariable="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfset prefijo = ''>
<cfif isdefined("url.historico") and url.historico EQ 1>
	<cfset prefijo = 'H'>
</cfif>
<!----Verificar si existe calendario de pago---->
<cfquery name="rsExisteCalendario" datasource="#session.DSN#">
	select 1 from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
			and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
			and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
		</cfif>
</cfquery>
<cfquery name="rsParametro" datasource="#session.DSN#">
	select 1
	from RHReportesNomina 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHRPTNcodigo = 'DEDAS'
</cfquery>
<cfif rsParametro.RecordCount EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select '#MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo#' as Error
		from dual
	</cfquery>
<cfelse>
	<cfif rsExisteCalendario.RecordCount EQ 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select '#MSG_NoHayDatosParaLosFiltrosSeleccionados#' as Error
			from dual
		</cfquery>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">					
			<!----Tipos de deduccion--->
			select ltrim(rtrim(e.DEidentificacion)),ltrim(rtrim(td.TDcodigo)),b.DCvalor
			from HSalarioEmpleado a
				inner join HDeduccionesCalculo b
					on a.RCNid = b.RCNid
					and a.DEid = b.DEid
				inner join DeduccionesEmpleado c
					on b.Did = c.Did
					and b.DEid = c.DEid
					and c.TDid in (select TDid
									from RHReportesNomina c
										inner join RHColumnasReporte b
											on b.RHRPTNid = c.RHRPTNid
										inner join RHConceptosColumna a
											on a.RHCRPTid = b.RHCRPTid
											and a.TDid is not null
									where c.RHRPTNcodigo = 'DEDAS'
										and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 )
				inner join TDeduccion td
					on c.TDid=td.TDid
				inner join CalendarioPagos d
					on a.RCNid = d.CPid
					<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
						and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
					<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
						and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
					</cfif>
					
				inner join DatosEmpleado e
					on a.DEid = e.DEid	
			union all
			
			<!---Conceptos de pago--->
			select ltrim(rtrim(e.DEidentificacion)),ltrim(rtrim(ci.CIcodigo)),b.ICvalor
			from HSalarioEmpleado a
				inner join HIncidenciasCalculo b
					on a.RCNid = b.RCNid
					and a.DEid = b.DEid	
					and b.CIid in (select CIid
									from RHReportesNomina c
										inner join RHColumnasReporte b
											on b.RHRPTNid = c.RHRPTNid
										inner join RHConceptosColumna a
											on a.RHCRPTid = b.RHCRPTid
											and a.CIid is not null
									where c.RHRPTNcodigo = 'DEDAS'
										and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 )
				inner join CIncidentes ci
					on b.CIid = ci.CIid					
				inner join CalendarioPagos d
					on a.RCNid = d.CPid
					<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
						and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
					<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
						and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
					</cfif>
				inner join DatosEmpleado e
					on a.DEid = e.DEid	
			union all
			
			<!---Cargas--->
			select ltrim(rtrim(e.DEidentificacion)),ltrim(rtrim(dc.DCcodigo)),case when b.CCvalorpat=0 then
																						b.CCvaloremp
																			  else
																						b.CCvalorpat
																			  end as Monto
			from HSalarioEmpleado a
				inner join HCargasCalculo b
					on a.RCNid = b.RCNid
					and a.DEid = b.DEid
					and b.DClinea in (select DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
												on b.RHRPTNid = c.RHRPTNid
											inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
												and a.DClinea is not null
										where c.RHRPTNcodigo = 'DEDAS'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										 )
				inner join DCargas dc
					on b.DClinea=dc.DClinea
				inner join CalendarioPagos d
					on a.RCNid = d.CPid
					<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
						and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
					<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
						and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
					</cfif>
				inner join DatosEmpleado e
					on a.DEid = e.DEid		
		</cfquery>
	</cfif>
</cfif>
