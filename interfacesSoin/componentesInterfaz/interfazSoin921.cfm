<!---
	Interfaz 921
	Interfaz de registro de movimientos de Bancos por Recibos de CxC
	Elaborado por:Andres Lara
	Fecha de Creación: 22/09/2017
	--->
	
	
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz ????????????????--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cancelación. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz921" datasource="sifinterfaces">
		select	E.ID,
				E.EcodigoSDC, 
				E.Origen, 
				E.Tipo_Operacion,
				E.Tipo_Movimiento,
				Substring(E.Documento,1,20) Documento,
				E.Referencia,
				E.Descripcion_Mov,
				E.Fecha_Mov,
				E.Importe_Total_Mov, 
				E.Banco_Origen,
				E.Cuenta_Origen,
				E.Moneda,
				E.Tipo_Cambio,
				E.Estatus,
				E.NumeroSocio
			from IE921 E			
			where E.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarID#">
				<!---and E.Procesado = 'S' La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz921.recordcount eq 0>
		<cfthrow message="Error en Interfaz 921. No existen datos de Entrada para <!-- -->el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>	
			
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Invoca Componente de Procesamiento de Interfaz 10. --->
<cfinvoke component="interfacesSoin.Componentes.CB_MovimientosBancariosRecibos" method="process" returnvariable="MSG" 
query="#readInterfaz921#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>