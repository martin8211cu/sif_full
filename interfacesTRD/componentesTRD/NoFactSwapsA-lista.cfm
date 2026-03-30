<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#session.qproductos#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="orden, Documento, FechaTrade, Nsocio, producto, importe, modulo, tipotransaccion, tipoventa"/>
	<cfinvokeargument name="etiquetas" value="Contrato, Trade, Fecha, Socio, Producto, Importe, Módulo, T.T., T.Venta"/>
	<cfinvokeargument name="formatos" value="S,S,D,S,S,M,S,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,right,left,left,left"/>
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
