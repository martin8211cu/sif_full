<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.CHK" type="string" default="">
<cfset LISTACHK = ListToArray(FORM.CHK)>
<cftry>
	<cfif isdefined("FORM.BTNELIMINAR") and FORM.BTNELIMINAR eq 1>
		<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
			<cfset data = ListToArray(LISTACHK[i],'|')>
			<cfquery datasource="#SESSION.DSN#">
					delete from RHEvaluadoresDes
					where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[1]#">
					and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data[2]#">
			</cfquery>
		</cfloop>
	</cfif>
<cfcatch>
	<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
<cflocation url="registro_evaluacion.cfm?RHEEid=#FORM.RHEEID#&SEL=5">