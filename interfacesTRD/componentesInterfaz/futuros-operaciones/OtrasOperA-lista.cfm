<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<cfif not isdefined("varCodICTS")>
	<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
		<cfset form.CodICTS = url.CodICTS>
		<cfset varCodICTS = form.CodICTS>
	<cfelseif isdefined("form.CodICTS")>
		<cfset varCodICTS = form.CodICTS>
	<cfelse>
		<cfset varCodICTS = "">
	</cfif>	
</cfif>

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from OtrOperaPMI
	where MensajeError is not null 
	and sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<cfquery name="rsSalida" datasource="sifinterfaces">
	select distinct Documento,Concepto,Ccontable,TipoCD,Moneda,Tcambio,MontoCalculado
	from OtrOperaPMI
	where MensajeError is null 
	and sessionid = #session.monitoreo.sessionid#
	order by Documento
</cfquery>

<cfinvoke  
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsSalida#"/>
	<cfinvokeargument name="cortes" value="Documento"/>
	<cfinvokeargument name="desplegar" value="Documento,Concepto,Ccontable,TipoCD,Moneda,Tcambio,MontoCalculado"/>
	<cfinvokeargument name="etiquetas" value="Documento,Descripcion,Cuenta,Tipo Movimiento,Moneda,Tipo Cambio,Monto"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,M,M"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,right,right"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#?CodICTS=#varCodICTS#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,#BErrores#,Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
	<cfinvokeargument name="Navegacion" value="CodICTS=#varCodICTS#"/>
</cfinvoke>
