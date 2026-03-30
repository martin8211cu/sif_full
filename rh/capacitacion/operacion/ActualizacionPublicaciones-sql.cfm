<cfif isdefined('form.BtnAprobar') or  isdefined('form.BtnRechazar')>
	<cfquery name="rsUpdEstPub" datasource="#session.DSN#">
		update RHPublicaciones
			set RHPEstado = <cfif isdefined('form.BtnAprobar')>1<cfelseif isdefined('form.BtnRechazar')>0</cfif>
		where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cflocation url="AprobacionCV.cfm?DEid=#form.DEid#&tab=5">
<cfelse>
	<cflocation url="ActualizacionPublicaciones.cfm">
</cfif>
