<cfif len(Trim(form.pregunta)) and len(trim(form.respuesta))>
<cfquery name="upd_pregunta" datasource="asp">
	update Usuario
	set Usupregunta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.pregunta)#">,
		Usurespuesta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.respuesta)#">
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery></cfif>
<cflocation url="index.cfm">