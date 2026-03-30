<cfparam name="form.RHRCid">
<cfparam name="FORM.CHK" type="string" default="">
<cfset LISTACHK = ListToArray(FORM.CHK)>
<cfset codEvaluad = ''>
<cfif isdefined("FORM.BTNELIMINAR") and FORM.BTNELIMINAR eq 1>
	<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
		<!--- 0-RHRCid,1-CFid,2-DEid --->
		<cfset dato = ListToArray(LISTACHK[i],'|')>
		<cfset codEvaluad = dato[3]>
		
		<!--- RHEvalPlanSucesion --->
		<cfquery datasource="#session.DSN#">
			delete from RHEvalPlanSucesion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
				and DEid in (
					Select DEid 
					from RHEmpleadosCF
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
						and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
				)		
		</cfquery>
		
		<!--- RHEvaluacionComp --->
		<cfquery datasource="#session.DSN#">
			Delete from RHEvaluacionComp
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
				and DEid in (
					Select DEid 
					from RHEmpleadosCF
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
						and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
				)		
		</cfquery>		
		
		<!--- RHEmpleadosCF --->
		<cfquery datasource="#session.DSN#">
			Delete from RHEmpleadosCF
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
		</cfquery>
		
		<!--- <!--- RHEvaluadoresCF --->
		<cfquery datasource="#session.DSN#">
			Delete from RHEvaluadoresCF
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
				and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[3]#">		
		</cfquery>	 --->			
	</cfloop>
</cfif>

<cflocation url="actCompetencias.cfm?RHRCid=#FORM.RHRCID#&SEL=4&DEid=#codEvaluad#">