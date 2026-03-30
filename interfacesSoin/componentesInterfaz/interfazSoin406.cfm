<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
<cfsetting 	enablecfoutputonly="yes" requesttimeout="36000">

<!--- <cfif listlen(GvarXML_IE) NEQ 5>
	<cfthrow message="No se han enviado los 5 parámetros separados por coma: Periodo, Mes, Cuenta Presupuesto inicial, Cuenta Presupuesto final, Código de Oficina. Adicionalmente no se permiten nulos, se debe poner -1">
</cfif>

<cfset LvarPeriodo			= listGetAt(GvarXML_IE,1)>
<cfset LvarMes				= listGetAt(GvarXML_IE,2)>
<cfset LvarCPformatoIni		= listGetAt(GvarXML_IE,3)>
<cfset LvarCPformatoFin		= listGetAt(GvarXML_IE,4)>
<cfset LvarOficodigo		= listGetAt(GvarXML_IE,5)> --->

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
 
<cfset LvarPeriodo		= #datosXML.row.LvarPeriodo.xmltext#>
<cfset LvarMes			= #datosXML.row.LvarMes.xmltext#>
<cfset LvarCPformatoIni = #datosXML.row.LvarCPformatoIni.xmltext#>
<cfset LvarCPformatoFin	= #datosXML.row.LvarCPformatoFin.xmltext#>
<cfset LvarOficodigo	= #datosXML.row.LvarOficodigo.xmltext#>

<cfset LvarPeriodoMes = LvarPeriodo * 100 + LvarMes>

<!--- Busca el periodo presupuestario con que se esta trabajando actualmente --->
<cfquery name="rsPerMes" datasource="#session.dsn#">
	select CPPid, CPPtipoPeriodo, CPPestado, CPPfechaDesde, CPPfechaHasta, CPPanoMesDesde, CPPanoMesHasta
	from CPresupuestoPeriodo
	where Ecodigo = #session.Ecodigo#
    	and CPPestado = 1
     	and #LvarPeriodoMes# = CPPanoMesDesde
</cfquery>


<cfif rsPerMes.recordCount EQ 0>
	<cfthrow message="No se ha indicado el Período de Presupuesto a Trabajar (Interfaz)">
<cfelseif rsPerMes.CPPestado NEQ "1">
	<cfthrow message="El Período de Presupuesto no está Abierto">
<cfelseif LvarPeriodoMes GT rsPerMes.CPPanoMesHasta>
	<cfthrow message="El mes de Auxiliables es posterior al Período de Presupuesto (Interfaz)">
</cfif>
<cfset LvarCPPid = rsPerMes.CPPid>

<cfif rsPerMes.recordcount eq 0>
    <cfthrow message="No se encontró un periodo configurado para #LvarPeriodoMes#, proceso cancelado. (Interfaz)">
<cfelse>
    <cfset LvarCPPid = rsPerMes.CPPid>
    <cfset LvarCPPtipoPeriodo = rsPerMes.CPPtipoPeriodo>
</cfif>


<cfparam name="LvarCPPid" default="-1">

<cfset LvarProcesaInterfaz = fnProcesaInterfaz406(LvarCPformatoIni,LvarCPformatoFin,LvarOficodigo)>

<cffunction name="fnProcesaInterfaz406" returntype="string" access="public">
	<cfargument name="conexion" default="#session.dsn#" required="no">
	<cfargument name="CPFormatoIni" default="-1" required="yes" type="">
    <cfargument name="CPFormatoFin" default="-1#" required="yes">
    <cfargument name="Oficodigo" default="-1" required="yes">


	<cfset LvarAno = datepart("yyyy",rsPerMes.CPPfechaDesde)>
	<cfset LvarMes = datepart("m",rsPerMes.CPPfechaDesde)>
	<cfset LvarAnoMesIni = LvarAno*100+LvarMes>


	<cfset LvarAuxMes = ''>
    
    <cfquery name="rsSQL" datasource="#session.dsn#">
        select Pvalor
          from Parametros
         where Ecodigo = #session.ecodigo#
           and Pcodigo = 50
    </cfquery>
    
    <cfif isdefined("rsSQL") and rsSQL.recordcount eq 0>
        <cfthrow message="No se ha configurado el Periodo de Auxiliares en el módulo de Administración del Sistema (Interfaz)">
    <cfelse>
        <cfset LvarAuxAno = rsSQL.Pvalor>
    </cfif>
    
    <cfquery name="rsSQL" datasource="#session.dsn#">
        select Pvalor
          from Parametros
         where Ecodigo = #session.ecodigo#
           and Pcodigo = 60
    </cfquery>
    
    <cfif isdefined("rsSQL") and rsSQL.recordcount eq 0>
        <cfthrow message="No se ha configurado el Mes de Auxiliares en el módulo de Administración del Sistema (Interfaz)">
    <cfelse>
        <cfset LvarAuxMes = rsSQL.Pvalor>
    </cfif>
    
    <cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

	<cfif LvarPeriodoMes GT rsPerMes.CPPanoMesHasta>
		<cfset LvarAnoMesFin = rsPerMes.CPPanoHasta*100+rsPerMes.CPPmesHasta>

	<cfelseif LvarAuxMes EQ 1>
		<cfset LvarAnoMesFin = (LvarAuxAno-1)*100+12>
	<cfelse>
		<cfset LvarAnoMesFin = LvarAuxAno*100+(LvarAuxMes-1)>
	</cfif>

	<cf_dbdatabase table="OE406" returnvariable="LvarOE406" datasource="sifinterfaces">
    
   	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Miso4217
		  from Monedas m
		  	inner join Empresas e 
            on e.Ecodigo = m.Ecodigo 
            and e.Mcodigo = m.Mcodigo
		 where e.Ecodigo =#session.Ecodigo#
	</cfquery>


    
   
	<cfquery name="rs" datasource="#arguments.conexion#">
    	<!--- insert into #LvarOD406#(
        	ID,
        	CPformato, 
            CPdescripcion, 
            CVPtipoControl, 
            CVPcalculoControl , 
            Oficodigo, 
            Miso4217, 
            CPCano1, 
            CPCmes1, 
            MonTotal
        ) --->
        

		select distinct 
        	#GvarID#,
        	c.CPformato, 
            coalesce(c.CPdescripcionF,c.CPdescripcion) as CPdescripcion, 
            cp.CPCPtipoControl, 
            cp.CPCPcalculoControl, 
            o.Oficodigo, 
            '#rsSQL.Miso4217#' as Miso4217, 
            #LvarAno# as Ano, 
            #LvarMes# as Mes
				, coalesce(
                            (
                                select sum(CPCpresupuestado + CPCmodificado + CPCmodificacion_Excesos + CPCvariacion + CPCtrasladado + CPCtrasladadoE
                                         -(CPCreservado_Anterior + CPCcomprometido_Anterior + CPCreservado_Presupuesto + CPCreservado + CPCcomprometido + CPCejecutado + CPCejecutadoNC)
                                          )
                                  from CPresupuestoControl ctl
                                 where ctl.Ecodigo 	= f.Ecodigo
                                        and ctl.CPPid		= f.CPPid
                                        and ctl.CPCano		= #LvarAno#
                                        and ctl.CPCmes		= #LvarMes#
                                        and ctl.CPcuenta	= f.CPcuenta
                                        and ctl.Ocodigo		= f.Ocodigo
                            )
						, 0)
				as MonTotal
		  from CPresupuestoControl f
			inner join CPresupuesto c
				 on c.Ecodigo 	= f.Ecodigo
				and c.CPcuenta	= f.CPcuenta
			inner join CPCuentaPeriodo cp
				 on cp.Ecodigo 	= f.Ecodigo
				and cp.CPPid	= f.CPPid
				and cp.CPcuenta	= f.CPcuenta
			inner join Oficinas o
				 on o.Ecodigo	= f.Ecodigo
				and o.Ocodigo	= f.Ocodigo
		 where f.Ecodigo 	= #session.ecodigo#
		   and f.CPPid		= #LvarCPPid#
           <!--- Filtro por Cuentas de presupuesto --->
           <cfif isdefined("arguments.CPFormatoIni") and isdefined("arguments.CPFormatoFin") and len(trim(arguments.CPFormatoIni)) and len(trim(arguments.CPFormatoFin))>
           		and CPformato between '#arguments.CPFormatoIni#' and '#arguments.CPFormatoIni#' 
           </cfif>
           
           <!--- Filtro por Oficina --->
           <cfif isdefined("arguments.Oficodigo") and len(trim(arguments.Oficodigo))>
           		o.Oficodigo = '#arguments.Oficodigo#'
           </cfif>
		 order by c.CPformato, o.Oficodigo, Miso4217, Ano, Mes
	</cfquery> 

	<cfinvoke component="interfacesSoin.Componentes.interfaces" method="fnGeneraQueryToXML" rsSQL="#rs#" returnvariable="LvarXML"  />
    
    
	<cfset GvarXML_OE = LvarXML>
    
    <cfreturn true>
</cffunction>    
