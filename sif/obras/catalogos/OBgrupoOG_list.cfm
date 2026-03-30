<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="
			OBgrupoOG o
				inner join PCECatalogo c
					on c.PCEcatid = o.PCEcatidOG
			"
	columnas="o.OBGid,o.OBGcodigo,o.OBGdescripcion,c.PCEcodigo,c.PCEdescripcion"
	filtro="1=1 order by o.OBGcodigo"
	desplegar="OBGcodigo,OBGdescripcion,PCEcodigo,PCEdescripcion"
	etiquetas="Codigo,Descripcion del Grupo,Catálogo,Descripcion"
	formatos="S,S,S,S"
	align="left,left,left,left"
	ira="OBgrupoOG.cfm"
	form_method="post"
	keys="OBGid"
	showLink="yes"

	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_Por=""

	botones="Nuevo"
/>
