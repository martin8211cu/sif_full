
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select CPperiodo,CPmes
		from CalendarioPagos
	where CPid = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0> <!---SML. Modificacion para Calculo de PTU--->
    				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
    			 <cfelse>
                 	<cfif isdefined('form.RCNid')>
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                    <cfelse>
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    </cfif>
                 </cfif>
		and Ecodigo = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0> <!---SML. Modificacion para Calculo de PTU--->
        				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.Ecodigo#">
        			  <cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      </cfif>
</cfquery> 

<cfquery name="rsCantPeriodos" datasource="#session.dsn#">
	select CPmes, CPperiodo, count(1) as Periodos
		from CalendarioPagos
		where CPperiodo = #rsPeriodo.CPperiodo#
			and CPmes = #rsPeriodo.CPmes#
			and Ecodigo = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0> <!---SML. Modificacion para Calculo de PTU--->
        					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.Ecodigo#">
        			  	  <cfelse>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!---SML. Modificacion para Calculo de PTU--->
                      	  </cfif>
			and CPtipo < 2
		group by CPmes,CPperiodo
</cfquery>

<cfquery datasource="#session.dsn#" name="rsDeducEmpleados">
	select b.*
	from DeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0><!---SML. Modificacion para Calculo de PTU--->
    					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
    			 	<cfelse>
    					<cfif isdefined('form.RCNid')>
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                    	<cfelse>
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    	</cfif>
                 	</cfif>
	  and b.Did = a.Did
	  and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DeduccionesEspeciales.TDid#">
</cfquery>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
    ecodigo="#session.Ecodigo#" pvalor="2110" default="0" returnvariable="lstInfonavit"/>


<cfloop query="rsDeducEmpleados">
 
    <cfquery datasource="#session.DSN#" name="rsOtro">
		select se.DEid, se.RCNid, se.DEid, se.SEsalariobruto, SErenta, se.SEincidencias, se.SEespecie
		from SalarioEmpleado se 
		where se.RCNid = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0> <!---SML. Modificacion para Calculo de PTU--->
    						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
    			 		<cfelse>
    						<cfif isdefined('form.RCNid')>
                    			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                    		<cfelse>
                    			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    		</cfif>
                 		</cfif>	
			and se.DEid = #rsDeducEmpleados.DEid#
	</cfquery>
    
    <cfquery name="rsFondoAhorro" datasource="#session.DSN#">
   		select coalesce(ICvalor,0) as ICvalor
		from IncidenciasCalculo a 
			inner join CIncidentes b on a.CIid = b.CIid
		where RCNid = <cfif isdefined('form.RCNid')>
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                      <cfelse>
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                      </cfif>
			and b.CIfondoahorro = 1 
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducEmpleados.DEid#">
   	</cfquery>
    
    <cfif isdefined('rsFondoAhorro') and len(trim(rsFondoAhorro.ICvalor)) GT 0>
    	<cfset SEincidencias = rsOtro.SEincidencias - rsFondoAhorro.ICvalor>
    <cfelse>
    	<cfset SEincidencias = rsOtro.SEincidencias>
    </cfif>
    
	<cfset vActual = (rsOtro.SEsalariobruto + rsOtro.SEespecie + SEincidencias) * (rsDeducEmpleados.Dvalor/100)>
        
    <cfquery datasource="#session.DSN#">
        update DeduccionesCalculo
        set DCvalor = 	#vActual#
        where Did= #rsDeducEmpleados.Did#
        and RCNid = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0> <!---SML. Modificacion para Calculo de PTU--->
    					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
    			 	<cfelse>
    					<cfif isdefined('form.RCNid')>
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                    	<cfelse>
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    	</cfif>
                 	</cfif>		
        and DEid = #rsDeducEmpleados.DEid#
    </cfquery>
</cfloop>


<!---  Actualizar la Tabla SalarioEmpleado para poner Deducciones --->

<cfquery datasource="#session.DSN#">
    update SalarioEmpleado set 
        SEdeducciones = coalesce(( 
            select sum(a.DCvalor)
            from DeduccionesCalculo a
            where a.DEid = SalarioEmpleado.DEid
              and a.RCNid = SalarioEmpleado.RCNid
            ),0.00)
    where SalarioEmpleado.RCNid = <cfif isdefined('rsEmpresa') and len(trim(rsEmpresa.Ecodigo)) GT 0> <!---SML. Modificacion para Calculo de PTU--->
    								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
    			 				  <cfelse>
    								<cfif isdefined('form.RCNid')>
                    					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                    				<cfelse>
                    					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    				</cfif>
                 				  </cfif>
      and SalarioEmpleado.SEcalculado = 0
      <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
</cfquery>







