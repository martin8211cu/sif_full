<cfquery name="rsSeguros" datasource="sifinterfaces">
	select *
	from #session.Dsource#segurosPMI
	where sessionid=#session.monitoreo.sessionid#
	  and mensajeerror is null
</cfquery>

<cfinvoke  
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsSeguros#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="Documento,Orden, fecha_creacion, trade_num, prima_cargo, moneda, tipo_poliza"/>
	<cfinvokeargument name="etiquetas" value="Documento,Orden, Fecha Creación, Trade, Prima, Moneda, Tipo Póliza"/>
	<cfinvokeargument name="formatos" value="S,S,D,S,M,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,right,left,left"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,Errores,Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
</cfinvoke>
