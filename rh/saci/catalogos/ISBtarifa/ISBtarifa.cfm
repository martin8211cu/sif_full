<cf_templateheader title="Mantenimiento de Tarifas">
	
<cf_web_portlet_start titulo="Mantenimiento de Tarifas">

	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="ISBtarifa"
		columnas="TAtarifa,TAnombreTarifa"
		filtro="Ecodigo=#session.Ecodigo# order by TAnombreTarifa"
		desplegar="TAnombreTarifa"
		etiquetas="Nombre de tarifa"
		formatos="S"
		align="left"
		ira="ISBtarifa-edit.cfm"
		form_method="get"
		keys="TAtarifa"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="Nuevo"
	/>
<cf_web_portlet_end>
<cf_templatefooter>

