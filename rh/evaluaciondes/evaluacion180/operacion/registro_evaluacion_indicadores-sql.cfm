<cfif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update RHRegistroEvaluacion
		set REindicaciones =<cfif isdefined("form.REindicaciones") and len(trim(form.REindicaciones))>
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.REindicaciones#">
							<cfelse>
								null
							</cfif>
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>	
</cfif>
<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&sel=2&Estado=#form.Estado#">