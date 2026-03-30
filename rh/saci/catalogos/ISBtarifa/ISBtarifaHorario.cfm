<cfparam name="url.TAtarifa" type="numeric">
<cfparam name="url.TAlinea" type="numeric">

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="ISBtarifaHorario"
	columnas="TAtarifa,TAlinea,TAdia,substring('DomLunMarMieJueVieSab',-2+3*TAdia,3) as NombreDia,TAhoraDesde,TAhoraHasta"
	filtro="TAtarifa=#url.TAtarifa# and TAlinea=#url.TAlinea# order by TAtarifa,TAlinea,TAdia,TAhoraDesde,TAhoraHasta"
	desplegar="NombreDia,TAhoraDesde,TAhoraHasta"
	etiquetas="Dia,Desde,Hasta"
	formatos="S,H,H"
	align="left,left,left"
	ira="ISBtarifa-edit.cfm"
	form_method="get"
	keys="TAtarifa,TAlinea,TAdia,TAhoraDesde"
	mostrar_filtro="no"
	filtrar_automatico="no"
	botones_no="Nuevo"
	formName="listaHor"
	PageIndex="3"
/>
