<!---Proceso de borrado de alumnos de un curso--->
<cfparam name="url.deid" default="0">
<cfparam name="url.RHCid" default="0">

<cfif url.deid NEQ 0 and url.RHCid NEQ 0>
	<cftry>
	
		<cftransaction>
			<cfquery name="rsdel1" datasource="Minisif">
			   delete
			   from RHAsistenciaCurso
			   where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.deid#">    
			   and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
			</cfquery>
			<cfquery name="rsdel2" datasource="Minisif">
			   delete RHEmpleadoCurso
			   where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.deid#">    
			   and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">     	
			</cfquery>
		</cftransaction>
		<center>Se excluyo con éxito al alumno.</center>
	<cfcatch type="any">
		<center>Error, favor comunicarse con el proveedor.</center>	
	</cfcatch>
	</cftry>
<cfelse>
	<center>Error, favor comunicarse con el proveedor.</center>
</cfif>
