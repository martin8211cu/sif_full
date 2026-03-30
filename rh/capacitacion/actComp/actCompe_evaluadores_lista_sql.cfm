<cfparam name="form.RHRCid">
<cfparam name="FORM.CHK" type="string" default="">
<cfset LISTACHK = ListToArray(FORM.CHK)>

<cfif isdefined("FORM.BTNELIMINAR") and FORM.BTNELIMINAR eq 1>
	<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">

		<cfset dato = ListToArray(LISTACHK[i],'|')>
		<cfset codEvaluad = dato[1]>
		<!--- RHEvalPlanSucesion --->
		<cfquery datasource="#session.DSN#">
			delete from RHEvalPlanSucesion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and DEid in (
					Select DEid 
					from RHEmpleadosCF
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
						and DEidJefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codEvaluad#">	
				)		
		</cfquery>
		
		<!--- RHEvaluacionComp --->
		<cfquery datasource="#session.DSN#">
			Delete from RHEvaluacionComp
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and DEid in (
					Select DEid 
					from RHEmpleadosCF
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
						and DEidJefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codEvaluad#">
				)		
		</cfquery>		
		
		<!--- RHEmpleadosCF --->
		<cfquery datasource="#session.DSN#">
			Delete from RHEmpleadosCF
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and DEidJefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codEvaluad#">		
		</cfquery>		
		
		<!--- RHEvaluadoresCalificacion --->
		<cfquery datasource="#session.DSN#">
			Delete from RHEvaluadoresCalificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEvaluad#">	
		</cfquery>				
	</cfloop>
</cfif>

<cflocation url="actCompetencias.cfm?RHRCid=#FORM.RHRCID#&SEL=3">