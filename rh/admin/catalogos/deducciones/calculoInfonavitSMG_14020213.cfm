<cfif not isdefined('EsLiquidacionMX')>
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
        select a.CPperiodo,a.CPmes, a.CPdesde, a.CPhasta, a.CPtipo, b.FactorDiasSalario, b.FactorDiasIMSS  <!---CPtipo => 0- Normal, 1- Especial--->
            ,case b.Ttipopago  
				when  0 then 1
				when  1 then 1
				when  2 then 2
				when  3 then 2
            end as OpcionCalculo
            
        	from CalendarioPagos a 
            inner join TiposNomina b
                on a.Tcodigo = b.Tcodigo
                and a.Ecodigo = b.Ecodigo
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery> 
    
   <!---Deducciones Infonavit--->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2110" default="" returnvariable="lstInfonavit"/>    
	
	<cfquery datasource="#Arguments.datasource#" name="rsDeducEmpleados">
		select b.*
		from DeduccionesCalculo a, DeduccionesEmpleado b
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and b.Did = a.Did
		  and b.TDid in (#lstInfonavit#)
		  <cfif IsDefined('Arguments.pDEid1')> and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid1#"></cfif>
		  and a.DEid = b.DEid
	</cfquery>

    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2034" default="" returnvariable="vMtoSegInfonavit"/>
        
        
	<cfset vMes 	= rsPeriodo.CPmes>
    <cfset vPeriodo = rsPeriodo.CPperiodo>
    <!---dias del bimestre --->
    <cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnDiasBimestre" CPmes="#vMes#" CPperiodo="#vPeriodo#" default="0" returnvariable="DiasB"/> 
    
	<!---calendarios del bimestre--->    
	<cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnCalBimestre"  CPmes="#vMes#" CPperiodo="#vPeriodo#" default="0" Tcodigo = "#Arguments.Tcodigo#" returnvariable="CalB"/>  
    
	<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
	
    <cfquery name="rsTtipoPago" datasource="#session.DSN#">
    	select Ttipopago
		from TiposNomina
		where Ecodigo = #session.Ecodigo# and Tcodigo = #Arguments.Tcodigo#
    </cfquery>
    
 <!---   <cf_dump var = "#rsTtipoPago#">--->

	<cfloop query="rsDeducEmpleados">
		<!---<cfset SMinimo = SMG(#rsDeducEmpleados.DEid#)>--->
        
        <!--- asi era como estaba para clear channel 
		<cfset vActual = ((rsDeducEmpleados.Dvalor * SMinimo ) / rsCantPeriodos.Periodos) + 3.25>--->
        
        <cfquery datasource="#Arguments.datasource#" name="rsDiasTrab"> 
            select a.DEid, sum(a.PEcantdias) as DiasTrab
                from PagosEmpleado a
                inner join RHTipoAccion b
                    on a.RHTid = b.RHTid
                    <cfif isdefined('rsTtipoPago') and #rsTtipoPago.Ttipopago# EQ 2> <!---Modificacion para que tome el .21 en nomina quincenal--->
                     and b.RHTcomportam in (13,3,4,5)
                    <cfelse>
                    and b.RHTcomportam not in (13,3,4,5)
                    </cfif>	<!---Faltas, Vacaciones, Permisos, Incapacidades--->
                where a.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                	and a.PEtiporeg = 0
                    and a.DEid = #rsDeducEmpleados.DEid#
             	group by a.DEid
        </cfquery>
         
       
         <cfif isdefined('rsDiasTrab') and rsDiasTrab.RecordCount NEQ 0>
         	 <cfif isdefined('rsTtipoPago') and #rsTtipoPago.Ttipopago# EQ 2> <!---Modificacion para que tome el .21 en nomina quincenal--->
         		<cfset vDiasTrab = (#rsPeriodo.FactorDiasIMSS# / 2) - rsDiasTrab.DiasTrab >
             <cfelse>
        		<cfset vDiasTrab = rsDiasTrab.DiasTrab *(#rsPeriodo.FactorDiasIMSS# / #rsPeriodo.FactorDiasSalario#) >
             </cfif>
        <cfelse>
        	 <cfif isdefined('rsTtipoPago') and #rsTtipoPago.Ttipopago# EQ 2> <!---Modificacion para que tome el .21 en nomina quincenal--->
         		<cfset vDiasTrab = (#rsPeriodo.FactorDiasIMSS# / 2)>
             <cfelse>
        		<cfset vDiasTrab = 0>
             </cfif>
        </cfif>
        
       <!--- <cfthrow message = "#vDiasTrab#"> --->        
       
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
            <!---<cf_dump var = "#rsDiasVac#">--->
            <cfset vDiasTrab = ((vDiasTrab + #rsDiasVac.DiasVacac#) * (#rsPeriodo.FactorDiasIMSS# / #rsPeriodo.FactorDiasSalario#)) >
        </cfif>
        
        
        <cfif #rsPeriodo.OpcionCalculo# EQ 1>
        	<cfset vActual = ((((rsDeducEmpleados.Dvalor * SZEsalarioMinimo )* 2) / #DiasB#) * #vDiasTrab#)>
        <cfelse>
        	<cfset vActual = (((rsDeducEmpleados.Dvalor * SZEsalarioMinimo )/#rsPeriodo.FactorDiasIMSS# )* #vDiasTrab#) >
        </cfif>
        
        

   <!-----
        TipoCalculo:<cfdump var="#rsPeriodo.OpcionCalculo#"> <br>
        VSM:<cfdump var="#rsDeducEmpleados.Dvalor#"><br>
        DiasLaborado:<cfdump var="#vDiasTrab#"><br>
        DiasBimestre:<cfdump var="#DiasB#"><br>
        NominasBimestre:<cfdump var="#CalB#"><br>
        SZEsalarioMinimo:<cfdump var="#SZEsalarioMinimo#"><br>
        
        vActual:<cfdump var="#vActual#"> <br>
        vMtoSegInfonavit = <cfdump var="#vMtoSegInfonavit#">
        --->
        
        
        <cfif #vActual# NEQ 0>
        		<cfset vActual = vActual + (#vMtoSegInfonavit# / #CalB#)>
        </cfif>
        
               
		
	<!---
        rsDeducEmpleadosDvalor : <cfdump var="#rsDeducEmpleados.Dvalor#"> <br>
        SMinimo:	<cfdump var="#SMinimo#"> <br>
        vActual: 	<cfdump var="#vActual#"> <br>
        --->	
		<cfquery datasource="#session.DSN#">
			update DeduccionesCalculo
			set DCvalor = #vActual#
			where Did= #rsDeducEmpleados.Did#
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">			
			and DEid = #rsDeducEmpleados.DEid#
		</cfquery>	
<!----		
		<cfquery datasource="#session.DSN#" name="z">
		select * from DeduccionesCalculo
		 where Did= #rsDeducEmpleados.Did#
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">			
			and DEid = #rsDeducEmpleados.DEid#
	</cfquery>
	<cfdump var="#z#">	
	--->	
		
	</cfloop>
	
<cfelse>
	    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2034" default="" returnvariable="vMtoSegInfonavit"/>
        
	<cfset rsSMGA  = fnGetDato(2024,Arguments.Ecodigo,Arguments.Conexion)><!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
	<cfset Infonavit = (DeduccionValor * rsSMGA.Pvalor) + #vMtoSegInfonavit#>
	<!--- (valor deduccion * salario minimo general) + 3.25--->
	
</cfif>

		
