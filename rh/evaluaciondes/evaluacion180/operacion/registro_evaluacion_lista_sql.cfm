<cfsetting requesttimeout="36000">
<cfset LISTACHK = ListToArray(FORM.CHK)>
<cftry>
		<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
		  <cfif isdefined("FORM.CERRAR")>				
				<cfquery name="ABC_Evaluacion_Masivo" datasource="#Session.DSN#">
					update RHRegistroEvaluacion
					set REestado = 2
					where Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
					and REid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					and REestado = 1
				</cfquery>
		  </cfif>
		</cfloop>
	<cfcatch type="any">
		<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>
<cflocation url="registro_evaluacion.cfm">