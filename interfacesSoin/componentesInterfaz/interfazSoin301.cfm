<!---
	Interfaz 301
	En este mensaje se recibirá la información del presupuesto ordinario en términos de formulación 		presupuestal o en términos de una variación presupuestaria al presupuesto aprobado.  Se entiende que el importe se modifica de manera incremental.
	Dirección de la Inforamción: Sistema Externo CONAVI - SIF
	Elaborado por: Jeffry Castro Bermúdez (jcastro@soin.co.cr)
	Fecha de Creación: 15/02/2010
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado, Detalles y Salida de Documento XXX de la BD Interfaces. --->

	<cfquery name="readInterfaz301Datos" datasource="sifinterfaces">
		select a.ID, a.CANTIDAD_DOCUMENTOS, a.IMPORTE_TOTAL,
b.ID, b.DOCUMENTO, b.FECHA_ESTIMACION, b.TIPO_PRESUPUESTO,  b.IMPORTE_DOCUMENTO,
c.ID, c.DOCUMENTO, c.LINEA, c.CANTIDAD_RECURSOS, c.CENTRO_FUNCIONAL, c.CONCEPTO_GASTO,
c.IMPORTE_LINEA, c.JUSTIFICACION
		from IE301 as a 
		inner join  ID301 as b
			on a.ID = b.ID
		inner join IS301 as c
			on b.ID = c.ID
			and b.DOCUMENTO = c.DOCUMENTO
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz301Datos.recordcount eq 0>
		<cfthrow message="Error en Interfaz 301. No existen datos de Entrada para el ID='#GvarID#'. Proceso Cancelado!.">
	</cfif>
	
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz301" datasource="sifinterfaces">
		select a.ID,a.CANTIDAD_DOCUMENTOS,a.IMPORTE_TOTAL,b.ID,b.DOCUMENTO,b.FECHA_ESTIMACION, b.TIPO_PRESUPUESTO,b.IMPORTE_DOCUMENTO,c.ID,c.DOCUMENTO,c.LINEA,c.CANTIDAD_RECURSOS, c.CENTRO_FUNCIONAL,c.CONCEPTO_GASTO,c.IMPORTE_LINEA,c.JUSTIFICACION,fpconcepto.FPCid,fpeestimacion.FPEEid
		from IE301 as a 
		inner join  ID301 as b on a.ID = b.ID
		inner join IS301 as c on b.ID = c.ID and b.DOCUMENTO = c.DOCUMENTO
		inner join <cf_dbdatabase table="CFuncional" datasource="#session.dsn#"> as cfuncional
			on cfuncional.CFcodigo = c.CENTRO_FUNCIONAL
			and cfuncional.Ecodigo = #session.Ecodigo# 			
		inner join <cf_dbdatabase table="FPConcepto" datasource="#session.dsn#"> as fpconcepto 
			on fpconcepto.FPCcodigo = c.CONCEPTO_GASTO
			and fpconcepto.Ecodigo = #session.Ecodigo# 
		inner join <cf_dbdatabase table="CPresupuestoPeriodo" datasource="#session.dsn#">  as cpresupuestoPeriodo
			on b.FECHA_ESTIMACION between cpresupuestoPeriodo.CPPfechaDesde and cpresupuestoPeriodo.CPPfechaHasta and cpresupuestoPeriodo.CPPestado = 0 and cpresupuestoPeriodo.Ecodigo = #session.Ecodigo# 				
		inner join <cf_dbdatabase table="FPEEstimacion" datasource="#session.dsn#"> as fpeestimacion
			on fpeestimacion.CPPid = cpresupuestoPeriodo.CPPid
			and fpeestimacion.CFid = cfuncional.CFid
			and fpeestimacion.FPEEestado = 0
			and fpeestimacion.Ecodigo = #session.Ecodigo#
		inner join <cf_dbdatabase table="TipoVariacionPres" datasource="#session.dsn#"> as tv
			on  tv.FPTVid = fpeestimacion.FPTVid and tv.FPTVTipo = -1
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz301.recordcount eq 0>
		<cfthrow message="Error en Interfaz 301. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>

	<!--- valida que la cantidad de documentos del encabezado sea igual a las lineas de detalle--->
	<cfquery name="readCantED" datasource="sifinterfaces">
		select a.CANTIDAD_DOCUMENTOS as cantidadE,
		(select count(1) from ID301	b where b.ID = a.ID) as cantidaD
		from IE301 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readCantED.cantidadE NEQ readCantED.cantidaD>
		<cfthrow message="Error en Interfaz 301. La cantidad de documentos no coincide con la cantidad especificada en el encabezado. Proceso Cancelado!.">
	</cfif>	
	
	<!--- valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
	<cfquery name="readTotImportED" datasource="sifinterfaces">
		select a.IMPORTE_TOTAL as importeE,
		(select sum(IMPORTE_DOCUMENTO) from ID301 b where b.ID = a.ID) as importeD
		from IE301 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
	<cfif readTotImportED.importeE NEQ readTotImportED.importeD>
		<cfthrow message="Error en Interfaz 301. La cantidad del importe del encabezado no coincide con la suma de importes de los documentos. Proceso Cancelado!.">
	</cfif>
	
	<!--- valida que que los tipos de presupuesto de los detalles sean tipo 'PO'
	<cfquery name="readTipoPresuD" datasource="sifinterfaces">
		select 1 as tipoPresupuesto
		from ID301 	
		where TIPO_PRESUPUESTO != 'PO'
		and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readTipoPresuD.tipoPresupuesto EQ '1'>
		<cfthrow message="Error en Interfaz 301. El tipo de presupuesto especificado no esta implementado en el sistema. Proceso Cancelado!.">
	</cfif>	--->
	
	<!--- valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
	<cfquery name="readTotImportDS" datasource="sifinterfaces">
		select a.IMPORTE_DOCUMENTO as importeD,
		(select sum(IMPORTE_LINEA) from IS301 b where b.ID = a.ID and b.DOCUMENTO = a.DOCUMENTO) as importeS
		from ID301 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
	<cfif readTotImportDS.importeD NEQ readTotImportDS.importeS>
		<cfthrow message="Error en Interfaz 301. La cantidad del importe de las lineas no coincide con la suma de importe del documentos. Proceso Cancelado!.">
	</cfif>

	<!--- Verifica que ningun documento exista el algun otro ID de formulacion
	<cfquery name="readExistDocumt" datasource="sifinterfaces">
		select a.DOCUMENTO
		from ID301 as a
		where a.DOCUMENTO in (select DOCUMENTO from interfaz301Docum)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	
	<cfif readExistDocumt.recordCount NEQ 0>
	   	<cfthrow message="El documento ya existe en una formulación">
	</cfif>	--->
	
	<!--- Verifica que los CF de las lineas existan
	<cfquery name="readExistCF" datasource="sifinterfaces">
		select CENTRO_FUNCIONAL 
		from IS301 as a
		where CENTRO_FUNCIONAL not in (select CFcodigo from <cf_dbdatabase table="CFuncional" datasource="#session.dsn#">)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	
	<cfif readExistCF.recordCount NEQ 0>
	   	<cfthrow message="El Centro Funcional no existe">
	</cfif>	--->
	
 <!---Verifica que ningun documento exista el algun otro ID de formulacion
	<cfquery name="readExistConceptoGasto" datasource="sifinterfaces">
		select a.CONCEPTO_GASTO
		from IS301 as a
		where a.CONCEPTO_GASTO not in (select FPCCcodigo from <cf_dbdatabase table="FPCatConcepto" datasource="#session.dsn#">)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<cfif readExistConceptoGasto.recordCount NEQ 0>
	   	<cfthrow message="El concepto de gasto no existe">
	</cfif>--->
		
	<!---SETEO DE DATOS PARA PODER INVOCAR EL COMPONENTE--->
	
	<cfset form.Dtipocambio = '1.00'>
	<cfset form.Ucodigo = 'UND'>
	<cfset form.DPDEcantidad = 1>
	
		
	<!--- Obtener Moneda Local--->
	
	<cfquery name="getMoneda" datasource="#session.dsn#">
		select Mcodigo
		from Empresas 
		where Ecodigo = #session.Ecodigo# 
	</cfquery>
	
	<cfset form.Mcodigo = #getMoneda.Mcodigo#>falta Validar que no venga nulo
	<!---<cfset form.Mcodigo = 1 >--->	
		
	<!---Iteracion por querry 'readInterfaz301' (Subdetalles) por cada uno de ellos se debe invocar el componente 'sif.Componentes.FPRES_EstimacionGI' --->
	
	<cfloop query="readInterfaz301">
		
		<!---========SE BUSCA LA CLASIFICACION DEL CONCEPTO==========--->
		<cfquery name="FPCCid" datasource="#session.dsn#">
			select FPCCid value from FPConcepto
			where FPCcodigo = '#readInterfaz301.CONCEPTO_GASTO#'
			  and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif FPCCid.recordcount EQ 0 or not len(trim(FPCCid.value))>
			<cfthrow message="El concepto #readInterfaz301.CONCEPTO_GASTO# no existe no esta asosiado a ninguna clasificacion">
		</cfif>
		<!---==========SE BUSCA LA PLANTILLA========--->
		<cfset form.FPEPid = getFPEPid(session.dsn, FPCCid.value)>
		<!---==========SE BUSCA idactividad y complemento de LA PLANTILLA========--->
		<cfquery datasource="#session.dsn#" name="getActYComplPlantilla">
			select FPEPid,CFComplemento,FPAEid from FPEPlantilla where FPEPid = #form.FPEPid#
		</cfquery>				 
					
		<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="AltaDetalleEstimacion">		
			<!---Seteados desde la lectura de tablas y unicos por iteracion de readInterfaz301--->
			<cfinvokeargument name="FPEEid" 			value="#readInterfaz301.FPEEid#">
			<cfinvokeargument name="FPDElinea" 			value="#readInterfaz301.LINEA#">
			<cfinvokeargument name="DPDEdescripcion" 	value="#readInterfaz301.JUSTIFICACION#">
			<cfinvokeargument name="DPDEjustificacion" 	value="#readInterfaz301.JUSTIFICACION#">			
			<cfinvokeargument name="DPDEcosto" 		    value="#readInterfaz301.IMPORTE_LINEA#">
			<cfinvokeargument name="FPCid" 				value="#readInterfaz301.FPCid#">
			<cfinvokeargument name="DPDMontoTotalPeriodo" value="#readInterfaz301.IMPORTE_LINEA#">
			<!---Constantes--->
			<cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#">
			<cfinvokeargument name="Dtipocambio" 		value="#form.Dtipocambio#">
			<cfinvokeargument name="DPDEcantidad" 		value="#form.DPDEcantidad#">
			<!---<cfinvokeargument name="Ucodigo" 			value="#form.Ucodigo#">
			Datos de la plantilla obtenidos segun el Concepto de  gasto enviado--->
			<cfinvokeargument name="FPAEid" 			value="#getActYComplPlantilla.FPAEid#">
			<cfinvokeargument name="CFComplemento" 		value="#getActYComplPlantilla.CFComplemento#">
			<cfinvokeargument name="FPEPid" 			value="#getActYComplPlantilla.FPEPid#">			
		</cfinvoke>		
			
			<!---</cfinvoke>
			<cfquery name="rsInserInterfaz301Docum" datasource="sifinterfaces">
				insert into interfaz301Docum(ID,DOCUMENTO,FPEEid)
				values(#session.Ecodigo#,'#readInterfaz301.DOCUMENTO#',#form.FPEEid#)
			</cfquery>	--->
		</cftransaction>
	</cfloop>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)><br />

<cffunction name="getFPEPid" access="public" returntype="numeric">
	<cfargument name="Conexion"  type="string"   required="no">
	<cfargument name="FPCCid"  	 type="string"   required="no">

	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.DSN>
	</cfif>
	<cfif not isdefined('Arguments.FPCCid')>
		<cfthrow message="Error en Invocacion, se debe enviar la clasificacion de concepto">
	</cfif>
	
	<cfquery datasource="#Arguments.Conexion#" name="rsisRelated">
		select FPEPid from FPDPlantilla where FPCCid = #Arguments.FPCCid#
	</cfquery>
	
	<cfquery datasource="#Arguments.Conexion#" name="isSon">
		select FPCCidPadre from FPCatConcepto where FPCCid = #Arguments.FPCCid# and FPCCidPadre is not null
	</cfquery>
	
	<cfif rsisRelated.recordcount>
		<cfreturn rsisRelated.FPEPid>
	<cfelseif isSon.recordcount GT 0>
		<cfreturn getFPEPid(Arguments.Conexion,isSon.FPCCidPadre)>
	<cfelse>
		<cfthrow message="La Clasificacion de concepto,no esta configurada en ninguna Plantilla">
	</cfif>
</cffunction>