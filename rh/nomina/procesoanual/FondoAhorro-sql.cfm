<!---<cf_dump var = "#form#">--->
<!---Paso 1--->

<cfif isdefined('BOTONSEL') and BOTONSEL EQ 'Alta'>
	<cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	insert into RHCierreFOA (RHCFOAcodigo,RHCFOAdesc,RHCFOAfechaInicio,RHCFOAfechaFinal,Ecodigo,RHCFOAEstatus, RHCFOAprestamo)
        values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtCodigo#">,
        		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaDesde,'yyyy-mm-dd')#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaHasta,'yyyy-mm-dd')#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                0, 
                coalesce((select sum((coalesce(b.Dmonto,0) - coalesce(b.DmontoFOA,0))) as interes
            	 from DeduccionesEmpleado b
            		inner join TDeduccion c on c.TDid = b.TDid
						and c.Ecodigo  = b.Ecodigo
						and c.TDfoa = 1
            	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              			and b.Dactivo = 1
              			and b.Dfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'yyyy-mm-dd')#">
			  			and coalesce(b.Dfechafin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="6100-01-01">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'yyyy-mm-dd')#">),0))
                
        <cf_dbidentity1 datasource="#session.DSN#">
    </cfquery>
    <cf_dbidentity2 datasource="#session.DSN#" name="rsInsertFOA">
    <cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro-form.cfm?RHCFOAid=#rsInsertFOA.identity#&tab=2" addtoken="no">
</cfif>

<cfif isdefined('BOTONSEL') and BOTONSEL EQ 'Regresar'>
	<cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro.cfm" addtoken="no">
</cfif>

<cfif isdefined('form.Cambio') and form.Cambio EQ 'Modificar'>
	<cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	update RHCierreFOA 
        set RHCFOAcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtCodigo#"> ,
        	RHCFOAdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDescripcion#">,
        	RHCFOAfechaInicio = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'yyyy-mm-dd')#">,
        	RHCFOAfechaFinal = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'yyyy-mm-dd')#">,
        	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ,
        	RHCFOAEstatus =0
        where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>	
    <cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro-form.cfm?RHCFOAid = #form.RHCFOAid#" addtoken="no">
</cfif>

<cfif isdefined('form.Baja') and form.Baja EQ 'Eliminar'>
	<cfquery name="deleteIncidenciasCalculo" datasource="#session.DSN#">
    	delete from DeduccionesCalculo
        where RCNId in (select CPid
						from CalendarioPagos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                        	and CPtipo = 5
							and CPdesde > = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'yyyy-mm-dd')#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'yyyy-mm-dd')#">)
    </cfquery>

	<cfquery name="deleteIncidenciasCalculo" datasource="#session.DSN#">
    	delete from IncidenciasCalculo
        where RCNId in (select CPid
						from CalendarioPagos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                        	and CPtipo = 5
							and CPdesde > = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'yyyy-mm-dd')#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'yyyy-mm-dd')#">)
    </cfquery>
    
    <cfquery name="deleteSalarioEmpleado" datasource="#session.DSN#">
    	delete from SalarioEmpleado
        where RCNId in (select CPid
						from CalendarioPagos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                        	and CPtipo = 5
							and CPdesde > = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'yyyy-mm-dd')#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'yyyy-mm-dd')#">)
    </cfquery>
    
    <cfquery name="deleteRCalculoNomina" datasource="#session.DSN#">
    	delete from RCalculoNomina
        where RCNId in (select CPid
						from CalendarioPagos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                        	and CPtipo = 5
							and CPdesde > = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'yyyy-mm-dd')#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'yyyy-mm-dd')#">)
	</cfquery>
	
	 <cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	delete from RHDCierreFOA 
        where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>
	<cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	delete from RHCierreFOA 
        where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>	

    <cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro.cfm" addtoken="no">
</cfif>


<!---Paso 2--->
<cfif isdefined('btnAgregar')>
	<cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	update RHCierreFOA 
        set RHCFOAInteres = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtImporteInteres#">
        where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>	
    <cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	update RHCierreFOA 
        set RHCFOAtotal = RHCFOAInteres + RHCFOAprestamo
        where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>			
    <cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro-form.cfm?RHCFOAid=#form.RHCFOAid#&tab=2" addtoken="no">
</cfif>

<cfif isdefined('btnContinuar')>
 
	<cf_dbtemp name = "RHCFOA" datasource = "#session.DSN#" returnvariable = "RHCFOA">
    	<cf_dbtempcol name="RHCFOAid"			type="int"				mandatory="no">
        <cf_dbtempcol name="RHCFOAcodigo"		type="varchar(50)"		mandatory="no">
        <cf_dbtempcol name="RHCFOAfechaInicio" 	type="date"  			mandatory="no">
        <cf_dbtempcol name="RHCFOAfechaFinal" 	type="date"  			mandatory="no">
       	<cf_dbtempcol name="RHCFOAinteres" 		type="money"  			mandatory="no">
    </cf_dbtemp>

	<cf_dbtemp name = "RHDCFOA" datasource = "#session.DSN#" returnvariable = "RHDCFOA">
    	<cf_dbtempcol name="RHCFOAid"				type="int"				mandatory="no">
        <cf_dbtempcol name="DEid"					type="numeric"			mandatory="no">
        <cf_dbtempcol name="Tcodigo" 				type="char(10)"  		mandatory="no">
        <cf_dbtempcol name="RHCFOAempresa" 			type="money"  			mandatory="no">
        <cf_dbtempcol name="RHCFOAempleado" 		type="money"  			mandatory="no">
        <cf_dbtempcol name="RHCFOAmonto" 			type="money"  			mandatory="no">
        <cf_dbtempcol name="RHCFOAinteres" 			type="money"  			mandatory="no">
        <cf_dbtempcol name="RHCFOAmontoT" 			type="money"  			mandatory="no">
    </cf_dbtemp>
    
    <cfquery name="rsRHCFOA" datasource="#session.DSN#">
    	insert into #RHCFOA# (RHCFOAid,RHCFOAcodigo,RHCFOAfechaInicio,RHCFOAfechaFinal,RHCFOAInteres)
        select RHCFOAid,RHCFOAcodigo,RHCFOAfechaInicio,RHCFOAfechaFinal,RHCFOAtotal
		from RHCierreFOA
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>
    
    <cfquery name="rsFechasFOA" datasource="#session.DSN#">
        select RHCFOAfechaInicio,RHCFOAfechaFinal,RHCFOAinteres
		from #RHCFOA#
		where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
    </cfquery>
    
    <cfquery name="rsRHDCFOA" datasource="#session.DSN#">
    	insert into #RHDCFOA# (RHCFOAid,DEid,Tcodigo,RHCFOAmonto)
        select <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">,a.DEid,a.Tcodigo, SUM(a.FAmonto) as monto
		from RHHFondoAhorro a inner join CalendarioPagos b
			on a.RCNid = b.CPid and a.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAEstatus = 0
			and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechasFOA.RHCFOAfechaInicio#">
			and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechasFOA.RHCFOAfechaFinal#">
		group by DEid,a.Tcodigo
    </cfquery>
    
    <cfquery name="rsRHDCFOA" datasource="#session.DSN#">
    	select coalesce(sum(RHCFOAmonto),0) as TotalFOA
        from #RHDCFOA#
    </cfquery>
    
    <cfif isdefined('rsRHDCFOA') and rsRHDCFOA.TotalFOA EQ 0>
    	<cf_throw message = "No hay Acumulados de Fondo de Ahorro">
    </cfif>
    
    <cfif isdefined('rsRHDCFOA') and rsRHDCFOA.RecordCount GT 0>
    	<cfset TotalFOA = #rsRHDCFOA.TotalFOA#>
    </cfif>
    
    <cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	update #RHDCFOA#
        set RHCFOAinteres = (#rsFechasFOA.RHCFOAinteres#/#TotalFOA#) 
    </cfquery>	
    
    <cfquery name="rsInsertFOA" datasource="#session.DSN#">
    	update #RHDCFOA#
        set RHCFOAmontoT = RHCFOAinteres * RHCFOAmonto
    </cfquery>	
       
    <cfquery name="rsFOA" datasource="#session.DSN#">
	select RHCFOAid, RHCFOAcodigo,RHCFOAdesc,RHCFOAfechaInicio,RHCFOAfechaFinal, 
    case  when RHCFOAEstatus = 0 then 'En Proceso'
    	  else 'Aplicado'
    end as Estatus
	from RHCierreFOA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
	</cfquery>

    <cfquery name="rsSelectFOA" datasource="#session.DSN#">
        select DEid
		from #RHDCFOA# 
	</cfquery>

    <cfloop query="rsSelectFOA">
    <cfquery name="rsRHFOAEmpleado" datasource="#session.DSN#">
        update #RHDCFOA# 
        set RHCFOAempresa = coalesce((select coalesce(SUM(a.FAmonto),0) as monto
		from RHHFondoAhorro a inner join CalendarioPagos b
			on a.RCNid = b.CPid and a.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAEstatus = 0
			and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechasFOA.RHCFOAfechaInicio#">
			and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechasFOA.RHCFOAfechaFinal#">
            and TDid in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = '01' 	
                            where c.RHRPTNcodigo = 'PR004'				
                              and c.Ecodigo = #session.Ecodigo#)
            and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
		group by DEid,a.Tcodigo),0)
        where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
    </cfquery>
    
    <cfquery name="rsRHFOAEmpresa" datasource="#session.DSN#">
    	update #RHDCFOA# 
        set RHCFOAempleado =
        coalesce((select coalesce(SUM(a.FAmonto),0) as monto
		from RHHFondoAhorro a inner join CalendarioPagos b
			on a.RCNid = b.CPid and a.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAEstatus = 0
			and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechasFOA.RHCFOAfechaInicio#">
			and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechasFOA.RHCFOAfechaFinal#">
            and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
            and TDid in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = '02' 	
                            where c.RHRPTNcodigo = 'PR004'				
                              and c.Ecodigo = #session.Ecodigo#)
		group by DEid,a.Tcodigo),0)
        where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectFOA.DEid#">
    </cfquery> 
    </cfloop>
    
    <cfquery name="rsSelectFOA" datasource="#session.DSN#">
    	insert into RHDCierreFOA (RHCFOAid,DEid,Tcodigo,RHDCFOAmonto,RHDCFOAinteres,RHDCFOAempresa,RHDCFOAempleado)
    	select RHCFOAid,DEid,Tcodigo,RHCFOAmontoT,RHCFOAinteres,RHCFOAempresa,RHCFOAempleado from #RHDCFOA#
    </cfquery>	
   
    <cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro-form.cfm?RHCFOAid=#form.RHCFOAid#&tab=3">
</cfif>

<cfif isdefined('btnVerReporte')>
	<cflocation url="/cfmx/rh/nomina/procesoanual/repFondoAhorro.cfm?RHCFOAid=#form.RHCFOAid#">
</cfif>

<cfif isdefined('btnCerrarFondo')>
	<cfquery name="rsUpdateFOA" datasource="#session.DSN#">
    	update RHCierreFOA
        set RHCFOAestatus = 1
		 where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
    </cfquery>	
    <cflocation url="/cfmx/rh/nomina/procesoanual/FondoAhorro-form.cfm?RHCFOAid=#RHCFOAid#&tab=4">
</cfif>









