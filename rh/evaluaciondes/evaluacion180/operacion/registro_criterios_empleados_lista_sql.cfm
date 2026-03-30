<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.CHK" type="string" default="">
<cfset LISTACHK = ListToArray(FORM.CHK)>
<cftry>
	<cfif isdefined("FORM.BTNELIMINAR") and FORM.BTNELIMINAR eq 1>
		<cfquery name="ABC_ELIM_MASIVO" datasource="#SESSION.DSN#">
			set nocount on
			<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
				delete from RHDEvaluacionDes
				from RHListaEvalDes b, RHEEvaluacionDes a
				where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
				and a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.Ecodigo#">
				and a.RHEEestado < 3
				and RHDEvaluacionDes.DEid = b.DEid
				and RHDEvaluacionDes.RHEEid = b.RHEEid
				and b.RHEEid = a.RHEEid
				
				delete from RHNotasEvalDes
				from RHListaEvalDes b, RHEEvaluacionDes a
				where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
				and a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.Ecodigo#">
				and a.RHEEestado < 3
				and RHNotasEvalDes.DEid = b.DEid
				and RHNotasEvalDes.RHEEid = b.RHEEid
				and b.RHEEid = a.RHEEid
				
				delete from RHEvaluadoresDes
				from RHListaEvalDes b, RHEEvaluacionDes a
				where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
				and a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.Ecodigo#">
				and a.RHEEestado < 3
				and RHEvaluadoresDes.DEid = b.DEid
				and RHEvaluadoresDes.RHEEid = b.RHEEid
				and b.RHEEid = a.RHEEid
				
				delete from RHListaEvalDes
				from RHEEvaluacionDes a
				where RHListaEvalDes.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
				and a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.Ecodigo#">
				and a.RHEEestado < 3
				and RHListaEvalDes.RHEEid = a.RHEEid
			</cfloop>
			set nocount off
		</cfquery>
	<cfelseif isdefined("FORM.BTNGENERAREMPL") and FORM.BTNGENERAREMPL eq 1>
		<!--- Dentro está contemplado esta ejecución especial del proceso de generación --->
		<cfinclude template="registro_criterios_empleados_sql.cfm">
	<cfelseif isdefined("FORM.BTNGENERAREMPLS") and FORM.BTNGENERAREMPLS eq 1>
		<cfset FORM.DEIDLIST = FORM.CHK>
		<!--- Dentro está contemplado esta ejecución especial del proceso de generación --->
		<cfinclude template="registro_criterios_empleados_sql.cfm">
	</cfif>
<cfcatch>
	<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
<cflocation url="registro_evaluacion.cfm?RHEEid=#FORM.RHEEID#&SEL=3">