<cfoutput>
<cfif isdefined("Session.Params.ModoDespliegue")>
<cfif  Session.Params.ModoDespliegue EQ 0>
	<a href="/cfmx/rh/expediente/consultas/expedientes-listaAuto.cfm?DEid=#rsEmpleado.DEid#"><cf_translate key="VerExpedientes">Ver Expedientes</cf_translate> &gt;&gt;</a>
<cfelseif Session.Params.ModoDespliegue EQ 1>
	<a href="/cfmx/rh/expediente/consultas/expedientes-lista.cfm?DEid=#rsEmpleado.DEid#"><cf_translate key="VerExpedientes">Ver Expedientes</cf_translate> &gt;&gt;</a>
</cfif>
<cfelse>
	<a href="/cfmx/rh/expediente/consultas/expedientes-lista.cfm?DEid=#rsEmpleado.DEid#"><cf_translate key="VerExpedientes">Ver Expedientes</cf_translate> &gt;&gt;</a>
</cfif>
</cfoutput>
