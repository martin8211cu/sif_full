<!---
	Interfaz 10
	Interfaz de Intercambio de Información de Documentos de Cuentas por Cobrar / Cuentas por Pagar
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: D.A.G. (dabarca@soin.co.cr)
	Fecha de U. Modificación: 22/6/2005
	Motivo de la Modificación: Se Modifico la Interpretación y Validación de la Información, además se agregaron algunos campos a las Tablas IE1o y ID10
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar de la BD de Interfaces. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz10" datasource="sifinterfaces">
		select IE10.ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento,
		  	   coalesce(FechaTipoCambio,FechaDocumento) as FechaTipoCambio,
		<cfif isdefined("LvarRicardoPerez")>
			case when Facturado = '0' then 'S' else 'N' end as Facturado, 
		<cfelse>
			Facturado, 
		</cfif>
			coalesce(CodigoDireccionEnvio,NumeroSocio) as CodigoDireccionEnvio, 
			coalesce(CodigoDireccionFact,NumeroSocio) as CodigoDireccionFact, 
			Origen, 
			VoucherNo, 
			CodigoRetencion, 
			CodigoOficina, 
			CuentaFinanciera, 
			CodigoConceptoServicio, 
			DiasVencimiento, 
			ID10.Consecutivo, 
			TipoItem, 
			CodigoItem, 
			NombreBarco, 
			FechaHoraCarga, 
			FechaHoraSalida, 
			PrecioUnitario, 
			CodigoUnidadMedida, 
			CantidadTotal, 
			CantidadNeta, 
			CodEmbarque, 
			NumeroBOL, 
			FechaBOL, 
			TripNo, 
			ContractNo, 
			CodigoImpuesto, 
			ImporteImpuesto,
			coalesce(OCtransporte,'-1') as OCtransporte, 
			coalesce(OCcontrato,'-1') as OCcontrato,
			coalesce(OCconceptoCompra,'-1') as OCconceptoCompra,
			coalesce(OCtransporteTipo,'-1') as OCtransporteTipo, 
			ImporteDescuento, 
			CodigoAlmacen, 
			CodigoDepartamento, 
			PrecioTotal, 
			CentroFuncional, 
			CuentaFinancieraDet, 
			ID10.CodEmbarque as DDembarque, 
			ID10.FechaBOL as DDfembarque,
			ID10.OCconceptoIngreso as OCconceptoIngreso,
			IE10.DEordenCompra,
			IE10.DEnumReclamo
		from IE10, ID10
		where IE10.ID = ID10.ID
		and IE10.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz10.recordcount eq 0>
		<cfthrow message="Error en Interfaz 10. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Invoca Componente de Procesamiento de Interfaz 10. --->
<cfinvoke component="interfacesSoin.Componentes.CPCC_InterfazDocumentos" method="process" returnvariable="MSG" query="#readInterfaz10#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>