<!---
	Interfaz 920
	Interfaz de registro de movimientos de Bancos por concepto de deposito o retiro
	Elaborado por:Maria de los Angeles Blanco López
	Fecha de Creación: 26/04/2010
	--->
	
	
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz ????????????????--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cancelación. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz920" datasource="sifinterfaces">
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
				<!---E.Banco_Origen, 
				E.Cuenta_Origen,--->
				E.Banco_Destino,
				E.Cuenta_Destino,
				E.Moneda,
				E.Tipo_Cambio,
				E.Estatus,
				D.ID_Linea,
				D.Descripcion_Mov_Det,
				D.Concepto_Mov,
				D.Importe_Mov
			from IE920 E
			inner join ID920 D on E.ID = D.ID
			where E.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarID#">
				<!---and E.Procesado = 'S' La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz920.recordcount eq 0>
		<cfthrow message="Error en Interfaz 920. No existen datos de Entrada para <!-- -->el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
	
	<!---Valida Montos--->
		<cfquery name ="rsTotalEnc" datasource="sifinterfaces">
			select Importe_Total_Mov
			from IE920 
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		</cfquery>
			
		<cfquery name ="rsTotalDet" datasource="sifinterfaces">
			select sum(Importe_Mov) as MontoDet
			from ID920 
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		</cfquery>
			
		<cfif rsTotalEnc.recordcount EQ 0 or rsTotalDet.recordcount EQ 0 or rsTotalEnc.Importe_Total_Mov NEQ 
		rsTotalDet.MontoDet>
			<cfthrow message="El importe total del documento no puede ser diferente a la suma de los montos del detalle del movimiento">
		</cfif>
			
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Invoca Componente de Procesamiento de Interfaz 10. --->
<cfinvoke component="interfacesSoin.Componentes.CB_MovimientosBancarios" method="process" returnvariable="MSG" 
query="#readInterfaz920#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>