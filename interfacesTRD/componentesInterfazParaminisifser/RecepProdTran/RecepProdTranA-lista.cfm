<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from RecProdTranPMI
	where mensajeerror is not null 
	and sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<cfquery name="rsProducto" datasource="sifinterfaces">
	select distinct Almacen || ' - ' || convert(varchar, title_tran_date, 103) as Almacen_fecha,
	Almacen,title_tran_date, Compra, Producto, Unidad, sum(Volumen) as Volumen
	from #session.Dsource#RecProdTranPMI a
	where not exists (select 1 from RecProdTranPMI 
						where a.Almacen = Almacen and a.title_tran_date = title_tran_date 
						and a.sessionid = sessionid and mensajeerror is not null)
	and sessionid = #session.monitoreo.sessionid#
	group by Almacen,title_tran_date,Compra,Producto
	order by Almacen,title_tran_date
</cfquery>

<cfinvoke  
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsProducto#"/>
	<cfinvokeargument name="cortes" value="Almacen_Fecha"/>
	<cfinvokeargument name="desplegar" value="Almacen,title_tran_date, Compra, Producto, Unidad, Volumen"/>
	<cfinvokeargument name="etiquetas" value="Almacen,Fecha Cambio Propiedad, Compra, Producto, Unidad, Volumen"/>
	<cfinvokeargument name="formatos" value="S,D,S,S,S,N"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,right"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,#BErrores#,Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
</cfinvoke>
