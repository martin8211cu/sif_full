<cfquery name="rsPlantillas" datasource="#session.dsn#">
	select FPEPid,FPEPdescripcion, case FPCCtipo when 'G' then 'Gasto' when 'I' then 'Ingreso' end as Tipo
	from FPEPlantilla
</cfquery>
<cfquery name="rsFPCCtipo" datasource="#session.dsn#">
		select '' as value, '-Todos-' DESCRIPTION	from dual
			union all
		select 'G' as value , 'Egreso' DESCRIPTION 	from dual
			union all
		select 'I' as value, 'Ingreso' DESCRIPTION 	from dual
</cfquery>
<cfquery name="rsFPCCconcepto" datasource="#session.dsn#">
		select '' as value, 	'-Todos-' DESCRIPTION 					from dual
			union all
		select 'S' as value,	'Gastos o Servicio' DESCRIPTION  		from dual
			union all
		select 'P' as value,	'Obras en Proceso' DESCRIPTION  		from dual
			union all
		select 'A' as value,	'Artículos Inventario' DESCRIPTION 		from dual
			union all
		select 'F' as value,	'Activo Fijo' DESCRIPTION 				from dual
			union all
		select '1' as value,	'Otros' DESCRIPTION 					from dual
			union all
		select '2' as value,	'Concepto Salarial' DESCRIPTION 		from dual
			union all
		select '3' as value,	'Amortización de Prestamos' DESCRIPTION from dual
			union all
		select '4' as value,	'Financiamiento' DESCRIPTION 			from dual
			union all
		select '5' as value,	'Patrimonio' DESCRIPTION 				from dual
			union all
		select '6' as value,	'Ventas' DESCRIPTION 					from dual
</cfquery>
<form name="formPlantilla" action="Plantillas.cfm" method="post">
	 <cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="FPEPlantilla"
		columnas		="FPEPid,FPEPdescripcion, case FPCCtipo when 'G' then 'Egreso' when 'I' then 'Ingreso' end as FPCCtipo, 
							case FPCCconcepto 
								when 'S' then 'Gastos o Servicio'
								when 'P' then 'Obras en Proceso'
								when 'A' then 'Artículos Inventario'
								when 'F' then 'Activo Fijo'
								when '1' then 'Otros'
								when '2' then 'Concepto Salarial'
								when '3' then 'Amortización de Prestamos'
								when '4' then 'Financiamiento'
								when '5' then 'Patrimonio'
								when '6' then 'Ventas'
								else FPCCconcepto
								end as FPCCconcepto"
		desplegar		="FPEPdescripcion,FPCCtipo, FPCCconcepto"
		etiquetas		="Descripcion, Tipo, Indicador Auxiliar"
		formatos		="S,S,S"
		filtro			="Ecodigo = #session.Ecodigo# order by FPEPdescripcion"
		incluyeform		="false"
		align			="left,left,left"
		keys			="FPEPid"
		maxrows			="25"
		showlink		="true"
		filtrar_automatico="true"
		mostrar_filtro	="true"
		rsFPCCtipo		="#rsFPCCtipo#"
		rsFPCCconcepto	="#rsFPCCconcepto#"
		formname		="formPlantilla"
		ira				="Plantillas.cfm"
		showemptylistmsg="true"
		ajustar			="N"
		debug			="N"
		botones			="Nuevo"/>					
</form>
<script language="javascript1.2" type="text/javascript">
	function funcNuevo(){
		document.formPlantilla.action="Plantillas-sql.cfm?Nuevo=true";
	}
</script>