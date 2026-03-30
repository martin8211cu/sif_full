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
    
    	<cf_dbfunction name="OP_concat"	returnvariable="cat">
        
        <!---Periodo--->
        <cf_dbfunction name="to_char"	args="x.CPperiodo" returnvariable="vCPperiodo">
        
		<!---Mes--->
        <cf_dbfunction name="to_char"	args="x.CPmes" returnvariable="vCPmes">
        <cf_dbfunction name="length"	args="#vCPmes#" returnvariable="lCPmes">
        <cf_dbfunction name="sRepeat"	args="0,2-#lCPmes#" returnvariable="cCPmes">
        
        <!---Monto--->
        <cf_dbfunction name="to_number"   args="sum(x.monto)*100/100 * 100" returnvariable="LvarMontoN">
        <cf_dbfunction name="to_char"	  args="#LvarMontoN#"				returnvariable="LvarMonto">
        <cf_dbfunction name="length"      args="#LvarMonto#"  				returnvariable="LvarMontoStrL"  delimiters="|" >
        <cf_dbfunction name="sRepeat"     args="0|10-#LvarMontoStrL#" 		returnvariable="LvarMontoStrLS" delimiters="|">
        
        <!---Identificacion--->
        <cf_dbfunction name="length"	args="ltrim(rtrim(x.DEidentificacion))" returnvariable="lId">
        
       <cfquery name="ERR" datasource="#session.DSN#">					
			select  x.DEidentificacion #cat# replicate(' ',9-#lId#) #cat# x.codigo #cat# replicate(' ',10-#LvarMontoStrL#) #cat# #LvarMonto# #cat# x.entidad #cat# #vCPperiodo#  #cat# replicate('0',2-#lCPmes#) #cat# #vCPmes#
            from (
            	<!----Tipos de deduccion--->
                select ltrim(rtrim(e.DEidentificacion))as DEidentificacion,ltrim(rtrim(td.TDcodigo)) as codigo,b.DCvalor as monto,'TELE' as entidad,d.CPperiodo,d.CPmes
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
                        and d.CPtipo=0
                    inner join DatosEmpleado e
                        on a.DEid = e.DEid	
                  <!---group by e.DEidentificacion,td.TDcodigo--->
                union all
                
                <!---Conceptos de pago--->
                select ltrim(rtrim(e.DEidentificacion))as DEidentificacion,ltrim(rtrim(ci.CIcodigo))as codigo,b.ICvalor as monto,'TELE' as entidad,d.CPperiodo,d.CPmes
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
                select ltrim(rtrim(e.DEidentificacion)) as DEidentificacion,ltrim(rtrim(dc.DCcodigo)) as codigo,case when b.CCvalorpat=0 then
                                                                                           b.CCvaloremp
                                                                                  else
                                                                                            b.CCvalorpat
                                                                                  end as Monto
                , 'TELE' as entidad,d.CPperiodo,d.CPmes
                
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
                  <!---group by ltrim(rtrim(e.DEidentificacion)),ltrim(rtrim(dc.DCcodigo))--->
                ) x
                group by x.DEidentificacion, x.codigo ,x.entidad,x.CPperiodo,x.CPmes
                order by x.DEidentificacion, x.codigo ,x.entidad,x.CPperiodo,x.CPmes
		</cfquery>
	</cfif>
          
</cfif>
