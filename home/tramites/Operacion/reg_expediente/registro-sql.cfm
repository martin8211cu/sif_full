<cfset vistas_cfc = CreateObject("component", "home.tramites.componentes.vistas")>
<cfinvoke component="#vistas_cfc#" argumentcollection="#url#"
	method="updRegistro"></cfinvoke>


<cflocation url="index.cfm?id_persona=#url.id_persona#&identificacion_persona=#url.identificacion_persona#&id_tipoident=#url.id_tipoident#">

