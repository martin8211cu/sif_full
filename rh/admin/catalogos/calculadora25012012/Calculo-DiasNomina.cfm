	<!--- funcion para conocer los dias desde la ultima nomina empleado a su fecha de nombramiento --->
   <cf_dbfunction name="datediff" args="max(RChasta), c.EVfantig" returnvariable="_datediff">
  
	<cfquery name="DiasRealesLaborados" datasource="#Session.DSN#">		
		select c.DEid,
			   c.EVfantig, 
			   max(RChasta) as RChasta,
			   coalesce(abs(#preservesinglequotes(_datediff)#)+1,0) as DiasReales
		from HRCalculoNomina a, HSalarioEmpleado b, EVacacionesEmpleado c

		where a.RCNid=b.RCNid
		  and b.DEid = #DEid#
		  and b.DEid = c.DEid
		  and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">

		group by c.DEid, c.EVfantig
	</cfquery>
	<cfif len(trim(DiasRealesLaborados.DiasReales)) gt 0>
		<cfset DiasRealesCalculoNomina = "#DiasRealesLaborados.DiasReales#">
	</cfif>
