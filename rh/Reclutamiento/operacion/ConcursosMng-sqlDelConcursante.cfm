<!--- Eliminar el concursante y todos sus datos --->
<cfquery name="delRHCalificaCompPrueOfer" datasource="#Session.DSN#">
	delete from RHCalificaCompPrueOfer
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
</cfquery>

<cfquery name="delRHCalificaPrueConcursante" datasource="#Session.DSN#">
	delete from RHCalificaPrueConcursante
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
</cfquery>

<cfquery name="delRHCalificaAreaConcursante" datasource="#Session.DSN#">
	delete from RHCalificaAreaConcursante
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
</cfquery>

<cfquery name="delRHConcursantes" datasource="#Session.DSN#">
	delete from RHConcursantes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
</cfquery>
