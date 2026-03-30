<cfif not isdefined('EsLiquidacionMX')>
   	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		 select a.CPperiodo,a.CPmes, a.CPdesde, a.CPhasta, a.CPtipo, b.FactorDiasSalario, b.FactorDiasIMSS  <!---CPtipo => 0- Normal, 1- Especial--->
            ,case b.Ttipopago  
				when  0 then 1  <!---Semanal--->
				when  1 then 1	<!---bisemanal--->
				when  2 then 2	<!---Quincenal--->
				when  3 then 2	<!---Mensual--->
            end as OpcionCalculo
            
        	from CalendarioPagos a 
            inner join TiposNomina b
                on a.Tcodigo = b.Tcodigo
                and a.Ecodigo = b.Ecodigo
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery> 
    
    
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
		ecodigo="#session.Ecodigo#" pvalor="2034" default="" returnvariable="vMtoSegInfonavit"/>
        
        
	<cfset vMes 	= rsPeriodo.CPmes>
    <cfset vPeriodo = rsPeriodo.CPperiodo>
    <!---dias del bimestre --->
    <cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnDiasBimestre" CPmes="#vMes#" CPperiodo="#vPeriodo#" default="0" returnvariable="DiasB"/> 
	<!---calendarios del bimestre--->    
	<cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnCalBimestre"  CPmes="#vMes#" CPperiodo="#vPeriodo#" default="0" Tcodigo = "#Arguments.Tcodigo#" returnvariable="CalB"/>
	
	<cfquery datasource="#Arguments.datasource#" name="rsDeducEmpleados">
		select c.DEsdi, b.*
		from DeduccionesCalculo a, DeduccionesEmpleado b, DatosEmpleado c
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and b.Did = a.Did
		  and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DeduccionesEspeciales.TDid#">
		  and b.DEid = c.DEid
	</cfquery>
	
	<cfloop query="rsDeducEmpleados">
	
		<cfquery datasource="#Arguments.datasource#" name="rsDiasTrab"> 
            select a.DEid, sum(a.PEcantdias) as DiasTrab
                from PagosEmpleado a
                inner join RHTipoAccion b
                    on a.RHTid = b.RHTid
                    and b.RHTcomportam not in (13,3,4,5) <!---Faltas, Vacaciones, Permisos, Incapacidades--->
                where a.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                	and a.PEtiporeg = 0
                    and a.DEid = #rsDeducEmpleados.DEid#
             	group by a.DEid
        </cfquery>
        
        <cfif isdefined('rsDiasTrab') and rsDiasTrab.RecordCount NEQ 0>
        	<cfset vDiasTrab = rsDiasTrab.DiasTrab *  (#rsPeriodo.FactorDiasIMSS# / #rsPeriodo.FactorDiasSalario#)>
        <cfelse>
			<cfset vDiasTrab = 0>
        </cfif>
        
        
        <cfif #rsPeriodo.CPtipo# EQ 1 or #rsPeriodo.CPtipo# EQ 0>
            <cfquery datasource="#session.dsn#" name="rsDiasVac">
                select coalesce(sum(a.ICmontores),0) as MtoVacac , coalesce(sum(a.ICvalor),0) as DiasVacac
                        from IncidenciasCalculo a
                        where a.DEid = #rsDeducEmpleados.DEid#
                            and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                            and CIid  in (select distinct a.CIid
                                    from RHReportesNomina c
                                        inner join RHColumnasReporte b
                                                    inner join RHConceptosColumna a
                                                    on a.RHCRPTid = b.RHCRPTid
                                             on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'IncVac'		<!---Total Incidencias--->
                                    where c.RHRPTNcodigo = 'PR002'				<!--- Codigo Reporte Dinamico --->
                                      and c.Ecodigo = #session.Ecodigo#)
            </cfquery>
            <cfset vDiasTrab = vDiasTrab + (#rsDiasVac.DiasVacac# * (#rsPeriodo.FactorDiasIMSS# / #rsPeriodo.FactorDiasSalario#))>
        </cfif>
        
        <cfset vActual = (((rsDeducEmpleados.Dvalor/100) * rsDeducEmpleados.DEsdi ) * (#vDiasTrab#))>
        
                
    
        <cfif #vActual# NEQ 0>
        		<cfset vActual = vActual + (#vMtoSegInfonavit# / #CalB#)>
        </cfif>
        
	
		<!---<cfset vActual = (((rsDeducEmpleados.Dvalor/100) * rsDeducEmpleados.DEsdi ) * (#vDiasTrab#)) + (#vMtoSegInfonavit# / #CalB#)>--->
		
		<!---
        TipoCalculo:<cfdump var="#rsPeriodo.OpcionCalculo#"> <br>
        SDI:<cfdump var="#rsDeducEmpleados.DEsdi#"><br>
        VSM:<cfdump var="#rsDeducEmpleados.Dvalor#"><br>
        DiasLaborado:<cfdump var="#vDiasTrab#"><br>
        FactorDiasIMSS:<cfdump var="#rsPeriodo.FactorDiasIMSS#"><br>
        FactorDiasSalario:<cfdump var="#rsPeriodo.FactorDiasSalario#"><br>
        vMtoSegInfonavit:<cfdump var="#vMtoSegInfonavit#"><br>
        vActual:<cfdump var="#vActual#"><br>
        CalendariosPeriodo:<cf_dump var="#CalB#"><br>
        
       
        --->
		
		
		<cfquery datasource="#session.DSN#">
			update DeduccionesCalculo
			set DCvalor = 	#vActual#
			where Did= #rsDeducEmpleados.Did#
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">			
			and DEid = #rsDeducEmpleados.DEid#
		</cfquery>	
	</cfloop>
<cfelse>
	<cfquery name="rsSDI" datasource="#Arguments.Conexion#">
		select DEsdi as SDI
			from DatosEmpleado
			where DEid = #Arguments.DEid#
	</cfquery>
	<cfquery name="rsDias" datasource="#Arguments.Conexion#">
		select b.CPdesde 
		from LineaTiempo a
			inner join  CalendarioPagos b
				on b.Tcodigo = a.Tcodigo and a.Ecodigo = b.Ecodigo
					and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha#"> between b.CPdesde and b.CPhasta
		where DEid = #Arguments.DEid# and a.LThasta = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -1, Fecha)#">
	</cfquery>
	<cfif len(trim(rsDias.CPdesde)) gt 0>
		<cfset diasPeriodo = DateDiff("d", rsDias.CPdesde, Fecha)>
	<cfelse>
		<cfset diasPeriodo = 0>
	</cfif>
	<cfset faltas = 0>
	<cfset Infonavit = ((DeduccionValor / 100) * rsSDI.SDI) * (diasPeriodo - faltas)>
</cfif>


		
