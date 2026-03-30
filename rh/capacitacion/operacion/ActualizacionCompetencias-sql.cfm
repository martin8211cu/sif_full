<cfif isdefined('form.BtnAprobar') or isdefined('form.BtnRechazar')>
	<cfquery datasource="#session.DSN#">
		update RHCompetenciasEmpleado
		set RHCestado = <cfif isdefined('form.BtnAprobar')>1<cfelseif isdefined('form.BtnRechazar')>2</cfif>
		where RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
	</cfquery>
</cfif>

<cflocation url="AprobacionCV.cfm?DEid=#form.DEid#&tab=#form.tab#&RHCEid=#form.RHCEid#">
