
<cfif isdefined("form.chk") and len(trim(form.chk))>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfquery datasource="#session.DSN#"	>
			delete from RHRUReportes
			where RHRURid in (#form.chk#)
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="eliminar-reporte.cfm">