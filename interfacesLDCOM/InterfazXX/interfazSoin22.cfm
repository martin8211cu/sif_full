<!---
	Interfaz 22
	Interfaz de Intercambio de Información de Documentos de Prefacturacion
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: <Gabriel Ernesto Sanchez Huerta - Application Hosting>
	Fecha de Creacion: 03/04/2009

--->
Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento Prefacturacion de la BD de Interfaces. --->

<!---<cfthrow message="Entre a Interfaz 22 >>>>>>>>>>>>>>>>>>   ">--->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz22" datasource="sifinterfaces">
		select IE22.ID, 
        		Ecodigo, 
                NumeroSocio, 
                CodigoTransaccion,
                Documento, 
                CodigoMoneda, 
                FechaTipoCambio, 
                TipoCambio, 
                Descuento, 
                Vendedor, 
                FechaDocumento,
                DiasVigencia, 
                FechaVencimiento, 
                CodigoOficina, 
                CodigoDireccionFacturacion, 
                NumeroOrdenCompra, 
                StatusProceso, 
                Observaciones, 
                Origen, 
                IE22.BMUsucodigo,
                ID22.Consecutivo, 
                ID22.TipoItem, 
                ID22.CodigoItem, 
                ID22.PrecioUnitario, 
                ID22.CantidadTotal, 
                ID22.CodigoImpuesto, 
                ID22.ImporteDescuento, 
                ID22.CodigoAlmacen,
                ID22.CentroFuncional, 
                ID22.CuentaFinancieraDet, 
                ID22.PrecioTotal, 
                ID22.Descripcion, 
                ID22.Descripcion_Alt,
                ID22.BMUsucodigo
		from IE22, ID22
		where IE22.ID = ID22.ID
		and IE22.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz22.recordcount eq 0>
		<cfthrow message="Error en Interfaz 22. No existen datos de Entrada para el ID='' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
</cftransaction>

      
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Prefacturacion. --->
<!--- Invoca Componente de Procesamiento de Interfaz 22. --->
<cfinvoke component="interfacesLDCOM.InterfazXX.PREFACT_InterfazDocumentos" method="process" returnvariable="MSG" query="#readInterfaz22#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
