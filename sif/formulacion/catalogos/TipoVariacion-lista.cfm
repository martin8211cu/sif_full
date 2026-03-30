<cfquery name="rsFPTVTipo" datasource="#session.dsn#">
		select -1 as value, '-Todos-' DESCRIPTION from dual
			union all
		select 0 as value , 'Presupuesto Extraordinario' DESCRIPTION from dual
			union all
		select 1  as value, 'No modifica monto' DESCRIPTION from dual
			union all
		select 4  as value, 'No modifica monto grupal' DESCRIPTION from dual
		union all
		select 2  as value, 'Modifica monto hacia abajo' DESCRIPTION from dual
			union all
		select 3  as value, 'Modifica monto hacia Arriba' DESCRIPTION from dual
		order by value
</cfquery>
<form name="formTVP" action="TipoVariacion.cfm" method="post">
	 <cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="TipoVariacionPres"
		columnas		="FPTVid,FPTVCodigo,FPTVDescripcion, case FPTVTipo when -1 then 'Presupuesto Ordinario' 
																		   when 0  then 'Presupuesto Extraordinario' 
																		   when 1  then 'No modifica monto' 
																		   when 2  then 'Modifica monto hacia abajo' 
																		   when 3  then 'Modifica monto hacia Arriba' 
																		   when 4  then 'No modifica monto grupal' 
																		   else 'Otro' end as FPTVTipo"
		desplegar		="FPTVCodigo,FPTVDescripcion,FPTVTipo"
		etiquetas		="Código, Descripción, Tipo"
		formatos		="S,S,S"
		filtro			="Ecodigo = #session.Ecodigo#"
		incluyeform		="false"
		align			="left,left,left"
		keys			="FPTVid"
		maxrows			="25"
		showlink		="true"
		filtrar_automatico="YES"
		mostrar_filtro	="YES"
		rsFPTVTipo		="#rsFPTVTipo#"
		formname		="formTVP"
		ira				="TipoVariacion.cfm"
		showemptylistmsg="true"
		ajustar			="N"
		debug			="N"/>					
</form>