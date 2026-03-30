<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select CPperiodo,CPmes
		from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery> 

<cfquery name="rsCantPeriodos" datasource="#session.dsn#">
	select CPmes, CPperiodo, count(1) as Periodos
		from CalendarioPagos
		where CPperiodo = #rsPeriodo.CPperiodo#
			and CPmes = #rsPeriodo.CPmes#
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CPtipo < 2
		group by CPmes,CPperiodo
</cfquery>

<cfquery datasource="#Arguments.datasource#" name="rsDeducEmpleados">
	select b.*
	from DeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	  and b.Did = a.Did
	  and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DeduccionesEspeciales.TDid#">
</cfquery>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
    ecodigo="#session.Ecodigo#" pvalor="2110" default="0" returnvariable="lstInfonavit"/>


<cfloop query="rsDeducEmpleados">
 
    <cfquery datasource="#session.DSN#" name="rsOtro">
		select se.DEid, se.RCNid, se.DEid, se.SEsalariobruto, SErenta, se.SEincidencias, se.SEespecie
		from SalarioEmpleado se 
		where se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">	
			and se.DEid = #rsDeducEmpleados.DEid#
	</cfquery>

	<cfset vActual = (rsOtro.SEsalariobruto + rsOtro.SEespecie + rsOtro.SEincidencias) * (rsDeducEmpleados.Dvalor/100)>
    
    <cfquery datasource="#session.DSN#">
        update DeduccionesCalculo
        set DCvalor = 	#vActual#
        where Did= #rsDeducEmpleados.Did#
        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">			
        and DEid = #rsDeducEmpleados.DEid#
    </cfquery>
</cfloop>


<!---  Actualizar la Tabla SalarioEmpleado para poner Deducciones --->

<cfquery datasource="#Arguments.datasource#">
    update SalarioEmpleado set 
        SEdeducciones = coalesce(( 
            select sum(a.DCvalor)
            from DeduccionesCalculo a
            where a.DEid = SalarioEmpleado.DEid
              and a.RCNid = SalarioEmpleado.RCNid
            ),0.00)
    where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
      and SalarioEmpleado.SEcalculado = 0
      <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
</cfquery>







