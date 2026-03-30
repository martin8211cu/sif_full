<cfquery name="rsProductos" datasource="sifinterfaces">
	select *
	from #session.Dsource#ProductosPMI where sessionid=#session.monitoreo.sessionid#
</cfquery>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsProductos#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="orden, documento, Nsocio, producto, fechavoucher, vouchernum, importe, iva, moneda, modulo, tipotransaccion"/>
	<cfinvokeargument name="etiquetas" value="Contrato, Documento, Socio, Producto, Fecha Propiedad, No.Trade, Importe, Iva, Moneda, Módulo, Tipo Trans."/>
	<cfinvokeargument name="formatos" value="S,S,S,S,D,S,M,M,S,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,left,right,right,left,left,left"/>
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
