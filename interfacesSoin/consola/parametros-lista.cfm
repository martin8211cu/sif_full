<cfquery name="rsQuery" datasource="sifinterfaces">
	select NumeroInterfaz, Descripcion, OrigenInterfaz, TipoProcesamiento,
		Componente, Activa, MinutosRetardo, FechaActivacion, FechaActividad, 
		NumeroEjecuciones, Ejecutando
		, case Activa when 1 then 'Activa' else 'Inactiva' end as ActivaDescripcion
		, case OrigenInterfaz when 'S' then 'SOIN' else '#Ucase(Request.CEnombre)#' end as OrigenInterfazDescripcion
		, case TipoProcesamiento when 'S' then 'Sincrónico' when 'D' then 'Directo' when 'A' then 'Asincrónico'  else '????' end as TipoProcesamientoDescripcion
		, ejecutarSpFinal
	from Interfaz
	order by NumeroInterfaz
</cfquery>
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsQuery#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="NumeroInterfaz, Descripcion, OrigenInterfazDescripcion, TipoProcesamientoDescripcion,ActivaDescripcion,MinutosRetardo, ejecutarSpFinal"/>
	<cfinvokeargument name="etiquetas" value="Número<BR>Interfaz, Descripción, Origen, Tipo<BR>Procesamiento,Estado<BR>Interfaz,Minutos<BR>Retardo,Ejecutar<br>spFinal"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,center,left,center,center"/>
	<cfinvokeargument name="lineaRoja" value="Activa EQ 0"/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value="frmListaParams"/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen Interfaces Definidas"/>
	<cfinvokeargument name="Keys" value="NumeroInterfaz"/>
</cfinvoke>
