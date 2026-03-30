<cfinvoke component="sif.Componentes.pListas" method="pLista"
	conexion="#session.tramites.dsn#"
	columnas="a.id_vista,a.id_tipo,a.nombre_vista,a.titulo_vista"
	desplegar="nombre_vista,titulo_vista"
	etiquetas="Nombre,T&iacute;tulo"
	formatos="S,S"
	align="left,left"
	tabla="DDVista a
		inner join DDTipo d
			on d.id_tipo = a.id_tipo
			and d.es_documento = 1
		inner join TPDocumento e
			on e.id_tipo = a.id_tipo"
	filtro="'#lsdateformat(now(),'yyyymmdd')#' between a.vigente_desde and a.vigente_hasta"
	mostrar_filtro="true"
	filtrar_automatico="true"
	irA="vistas.cfm"
	keys="id_vista,id_tipo"/>