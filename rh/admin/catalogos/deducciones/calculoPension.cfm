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



<cfloop query="rsDeducEmpleados">
	<cfquery datasource="#session.DSN#" name="rsInfonavit">
		select rn.Ecodigo, rn.RHRPTNcodigo, rn.RHRPTNdescripcion, cc.TDid, cc.CIid,
			cc.RHCRPTid, coalesce(dc.DCvalor,0) as Infonavit , dc.DEid, dc.RCNid, se.DEid, se.SEsalariobruto, SErenta, se.SEincidencias
		from    RHReportesNomina rn
			inner join RHColumnasReporte cr    on  rn.RHRPTNid = cr.RHRPTNid
			inner join RHConceptosColumna cc on cr.RHCRPTid = cc.RHCRPTid
			inner join DeduccionesEmpleado de on  cc.TDid = de.TDid
			inner join DeduccionesCalculo dc on   de.DEid = dc.DEid	and  de.Did = dc.Did
			inner join SalarioEmpleado se on se.DEid = dc.DEid and se.RCNid = dc.RCNid
		where    rn.RHRPTNcodigo = 'INFON'
			and rn.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">	
			and se.DEid = #rsDeducEmpleados.DEid#
	</cfquery>
	
	<cfif rsInfonavit.recordCount GT 0>
		<cfset vActual = ((rsInfonavit.SEsalariobruto + rsInfonavit.SEincidencias) - rsInfonavit.Infonavit - rsInfonavit.SErenta) * (rsDeducEmpleados.Dvalor/100)>				
		<cfquery datasource="#session.DSN#">
            update DeduccionesCalculo
            set DCvalor = 	#vActual#
            where Did= #rsDeducEmpleados.Did#
            and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">			
            and DEid = #rsDeducEmpleados.DEid#
        </cfquery>	
	</cfif>
	
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

 







