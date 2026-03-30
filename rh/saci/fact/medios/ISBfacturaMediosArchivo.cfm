<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="ISBfacturaMediosArchivo"
	columnas="FMEarchivo,FMEnombre,FMEtotal,FMEprocesados,FMEignorados,FMEerrores,FMEinicio,
		case when FMEinicio is null then 'No se ha procesado'
			when FMEfin is null then 'Trabajando...'
			when FMEfin is not null then 'Procesado en ' || convert(varchar, datediff(ss, FMEinicio, FMEfin)) || ' s'
			else ' - '  end as estado"
	filtro="FMEtipoArchivo = 'L' order by FMEinicio desc"
	desplegar="FMEnombre,FMEtotal,FMEignorados,FMEerrores,estado,FMEinicio"
	etiquetas="Nombre archivo,Líneas,Ignoradas,Errores,Estado,Fecha"
	formatos="S,S,S,S,S,DT"
	align="left,center,center,center,left,left"
	funcion="DetalleArchivo"
	fparams="FMEarchivo"
	form_method="get"
	keys="FMEarchivo"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	botones="Importar_archivo"
/>

<script type="text/javascript">
<!--
	function funcImportar_archivo() {
		document.location.href = 'index.cfm?tab=<cfoutput>#url.tab#</cfoutput>&imp=y';
		return false;
	}
	function DetalleArchivo(FMEarchivo){
		document.location.href = 'index.cfm?tab=<cfoutput>#url.tab#</cfoutput>&FMEarchivo=' + escape(FMEarchivo);
	}
-->
</script>