<cfquery datasource="tramites_cr">
	update TPInstanciaRequisito
	set completado = <cfif isdefined("url.completar")>1<cfelse>0</cfif>
	where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
	  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
</cfquery>

<cflocation url="tramite.cfm?id_instancia=#url.id_instancia#&id_persona=#url.id_persona#&id_tramite=#url.id_tramite#">