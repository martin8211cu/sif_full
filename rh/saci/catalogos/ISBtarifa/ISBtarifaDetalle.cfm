<cfparam name="url.TAtarifa" type="numeric">

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="ISBtarifaDetalle"
	columnas="TAtarifa,TAlinea,TAlineaNombre, (case when TAlineaDefault =1 then 'X' else '' end) as esdefault"
	filtro="TAtarifa=#url.TAtarifa# order by TAtarifa,TAlinea,TAlineaNombre"
	desplegar="TAlineaNombre,esdefault"
	etiquetas="Tipo de tarifa,Default"
	formatos="S,B"
	align="left,center"
	ira="ISBtarifa-edit.cfm"
	form_method="get"
	keys="TAtarifa,TAlinea"
	mostrar_filtro="no"
	filtrar_automatico="no"
	botones_no="Nuevo"
	formName="listaDet"
	PageIndex="2"
/>