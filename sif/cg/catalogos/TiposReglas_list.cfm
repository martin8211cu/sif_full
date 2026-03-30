<cfset filtro="">
<cfset navegacion="">

<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
	tabla="PCReglaGrupo" 
	columnas="PCRGid, PCRGcodigo, Cmayor, PCRGDescripcion, PCRGorden"
	desplegar="PCRGcodigo, Cmayor, PCRGDescripcion, PCRGorden"
	etiquetas="Código, Cuenta, Descripción, Orden"
	formatos="S, S, S, I"
	filtro="Ecodigo=#session.Ecodigo# #filtro# order by PCRGorden, Cmayor"
	filtrar_automatico= "True"
	filtrar_por = "PCRGcodigo, Cmayor, PCRGDescripcion, PCRGorden"
	mostrar_filtro ="True"
	align="left, left, left, center"
	checkboxes="N"
	keys="PCRGid"
	ira="TiposReglas.cfm"
	navegacion="#navegacion#"
	maxrows = "10"
	PageIndex="10">
</cfinvoke>