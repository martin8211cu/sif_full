<cf_templateheader title="Servidores de replicación monitoreados">
	
<cf_web_portlet_start titulo="Servidores de replicación monitoreados">

	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="ISBrsServidor"
		columnas="nombreRS,nombreASE,nombreRSSD"
		filtro="1=1 order by nombreRS,nombreASE,nombreRSSD"
		desplegar="nombreRS,nombreASE,nombreRSSD"
		etiquetas="Replication Server,ASE Server (RSSD),RSSD"
		formatos="S,S,S"
		align="left,left,left"
		ira="ISBrsServidor-edit.cfm"
		form_method="get"
		keys="nombreRS"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="Nuevo"
	/>
<cf_web_portlet_end>
<cf_templatefooter>

