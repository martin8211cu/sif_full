<cfquery name="rsFPAEtipo" datasource="#session.dsn#">
		select '' as value, '-Todos-' DESCRIPTION from dual
			union all
		select 'G' as value , 'Egreso' DESCRIPTION from dual
			union all
		select 'I' as value, 'Ingreso' DESCRIPTION from dual
</cfquery>
<form name="formActividades" action="ActividadesEmpresa.cfm" method="post">
	 <cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="FPActividadE"
		columnas		="FPAEid,FPAECodigo,FPAEDescripcion,case FPAETipo when 'G' then 'Egreso' when 'I' then 'Ingreso' end as FPAETipo"
		desplegar		="FPAECodigo, FPAEDescripcion,FPAETipo"
		etiquetas		="Codigo, Descripcion, Tipo"
		formatos		="S,S,S"
		filtro			="Ecodigo = #session.Ecodigo#"
		incluyeform		="false"
		align			="left,left,left"
		keys			="FPAEid"
		maxrows			="25"
		showlink		="true"
		filtrar_automatico="true"
		mostrar_filtro	="true"
		rsFPAEtipo		="#rsFPAEtipo#"
		formname		="formActividades"
		ira				="ActividadesEmpresa.cfm"
		showemptylistmsg="true"
		ajustar			="N"
		debug			="N"
		botones			="Nuevo"/>					
</form>