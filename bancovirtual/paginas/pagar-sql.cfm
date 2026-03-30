<cfinvoke component="home.tramites.componentes.tramites"
	method="obtener_instancia"
	id_persona="#session.user#"
	id_tramite="#url.id_tramite#"
	returnvariable="instancia" />
	

<cfif isdefined('url.cuenta') and len(trim(url.cuenta)) and isdefined('url.monto') and len(trim(url.monto))>
	<cfinvoke component="home.tramites.componentes.tramites"
		method="completar_requisito"
		id_instancia="#instancia#"
		id_requisito="#url.id_requisito#" />
</cfif>
	
<cflocation url="pagar_fin.cfm?id_tramite=#url.id_tramite#&id_requisito=#url.id_requisito#&monto=#url.monto#&cuenta=#url.cuenta#">