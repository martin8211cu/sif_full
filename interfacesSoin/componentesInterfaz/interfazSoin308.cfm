<!---
	El Encabezado recibe la cantidad de documentos a insertar.
	El detalle recibe la cantidad de documentos especificados en el encabezado.
	Verifica que la cantidad de lineas del detalle y del encabezado sean igual.
---->

<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInputED" datasource="sifinterfaces">
		select 
			IE308.ID, 
			IE308.CANTIDAD_DOCUMENTOS,
			IE308.IMPORTE_TOTAL,
			ID308.ID,  
			ID308.DOCUMENTO, 
			ID308.CODIGO_PROYECTO,   
			ID308.CODIGO_CONTRATO_OC,
			ID308.DESCRIPCION,
			ID308.JUSTIFICACION,
			ID308.FECHA_SOLICITUD,
			ID308.TIPO_SOLICITUD, 
			ID308.TOTAL_SOLICITADO_ADICIONAL,     
			ID308.USUARIO_SOLICITA ,
        	IS308.LINEA_CONTRATO_OC, 
			IS308.IMPORTE_ADICIONAL

		from IE308 
		inner join ID308 
			on ID308.ID = IE308.ID
		inner join IS308 
			on IS308.ID = ID308.ID
			and IS308.DOCUMENTO = ID308.DOCUMENTO
	 	where IE308.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<cfif rsInputED.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 307 ">
	</cfif>	
</cftransaction>

<!---<!--- Cantidad de documentos del encabezado = documentos del detalle--->
	<cfquery name="cantDocumento" datasource="sifinterfaces">
		select a.CANTIDAD_DOCUMENTOS as cantidadE,
		(select count(1) from ID308 as b where b.ID = a.ID) as cantidaD
		from IE308 as a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
<!--- Valida que vengan datos --->
	<cfif cantDocumento.cantidadE NEQ cantDocumento.cantidaD>
		<cfthrow message="Error en Interfaz 308. La cantidad de Documentos no coincide con la cantidad del Encabezado. Proceso Cancelado!.">
	</cfif>	
	
<!--- valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
	<cfquery name="readTotImportED" datasource="sifinterfaces">
		select a.IMPORTE_TOTAL as importeE,
		(select sum(TOTAL_SOLICITADO_ADICIONAL) from ID308 b where b.ID = a.ID) as importeD
		from IE308 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<cfif readTotImportED.importeE NEQ readTotImportED.importeD>
		<cfthrow message="Error en Interfaz 308. La cantidad del Importe del Encabezado no coincide con la suma de importes de los documentos. Proceso Cancelado!.">
	</cfif>
	
<!--- valida que la cantidad del importe del Detalle sea igual a la suma de lineas de Subdetalle--->
	<cfquery name="readTotImportDS" datasource="sifinterfaces">
		select a.TOTAL_SOLICITADO_ADICIONAL as importeD,
		(select sum(IMPORTE_ADICIONAL ) from IS308 b where b.ID = a.ID and b.DOCUMENTO = a.DOCUMENTO) as importeS
		from ID308 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<cfif readTotImportDS.importeD NEQ readTotImportDS.importeS>
		<cfthrow message="Error en Interfaz 308. La cantidad del Importe de las Lineas no coincide con la suma de Importe de documentos. Proceso Cancelado!.">
	</cfif>--->
	

	<cfquery name="rsPlanCompras" datasource="#session.dsn#">
		select c.CFid, c.PCGDid, a.EOfecha 
			from EOrdenCM a
			inner join DOrdenCM b
				on b.EOidorden= a.EOidorden
			inner join PCGDplanCompras c
				on c.PCGDid =b.PCGDid
			where a.EOidorden=#rsInputED.CODIGO_CONTRATO_OC#
	</cfquery>

<!---Selecciona el id de Tipo de Variación--->	
	<cfquery name="rsTipoVariacion" datasource="#session.dsn#">
		select FPTVid from TipoVariacionPres
			where FPTVCodigo='#rsInputED.TIPO_SOLICITUD#'
	</cfquery>

<cftransaction>
<!------Buscar el periodo presupuestal--->
	<cfinvoke component="sif.Componentes.PRES_Presupuesto" method="rsCPresupuestoPeriodo" returnvariable="rsSQL">
		   <cfinvokeargument name="Ecodigo"             value="#session.Ecodigo#">
		   <cfinvokeargument name="ModuloOrigen"        value="PCG">
		   <cfinvokeargument name="FechaDocumento" 		value="#rsPlanCompras.EOfecha#"> 
		   <cfinvokeargument name="AnoDocumento"        value="#DateFormat(rsPlanCompras.EOfecha,"YYYY")#">
		   <cfinvokeargument name="MesDocumento"       	value="#DateFormat(rsPlanCompras.EOfecha,"MM")#">
	</cfinvoke>
	
<!------Crea el encabezado de la variación--->
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="AltaEncabezadoEstimacion" returnvariable="FPEEid">
		   <cfinvokeargument name="CFid"                      value="#rsPlanCompras.CFid#">
		   <cfinvokeargument name="CPPid"                     value="#rsSQL.CPPid#">
		   <cfinvokeargument name="FPEEestado"                value="0">
		   <cfinvokeargument name="FPTVid"                    value="#rsTipoVariacion.FPTVid#">
	</cfinvoke>
	
<!---Copia el plan de compras a nueva variacion--->
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CopiarDetalles" returnvariable="detalles">
		   <cfinvokeargument name="CPPid"                                	value="#rsSQL.CPPid#">
		   <cfinvokeargument name="CFid"                                   	value="#rsPlanCompras.CFid#">
		   <cfinvokeargument name="FPEEid"                               	value="#FPEEid#">
	</cfinvoke>

<!---Modifica la linea de la variación--->
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CambioMontoVariacion">
		   <cfinvokeargument name="FPEEid"                                	value="#FPEEid#">
		   <cfinvokeargument name="PCGDid"                                  value="#rsPlanCompras.PCGDid#">
		   <cfinvokeargument name="AumentoMonto"                            value="#rsInputED.IMPORTE_TOTAL#">
		   <cfinvokeargument name="DPDEjustificacion"                       value="#rsInputED.JUSTIFICACION#">
	</cfinvoke>
</cftransaction>

	
