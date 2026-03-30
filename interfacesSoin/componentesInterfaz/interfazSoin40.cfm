<!---
	Interfaz 40
	Interfaz de Intercambio de Información de Documentos de Cuentas por Cobrar / Cuentas por Pagar
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por:Maria de los Angeles Blanco López
	Fecha de Creación: 04/03/2010
	Fecha de Modificación: 
	Motivo de la Modificación: 
							   
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz ????????????????--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cancelación. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz40" datasource="sifinterfaces">
		select	E.ID, 
				E.EcodigoSDC, 
				E.Modulo, 
				E.FechaTransaccion, 
				E.Documento, 
				E.NumeroSocio, 
				E.Transaccion, 
				E.MontoTotal,
				E.TipoCambio,
				E.CodigoMoneda, 
				E.BMUsucodigo, 
				E.Estatus, 
				E.ConceptoTesoreria, 
				E.Banco,
				E.CuentaBanco,
				D.DocumentoDestino, 
				D.NumeroSocioDoc,
				D.TransaccionDestino, 
				D.MontoDocumento
				from IE40 E 
				inner join ID40 D on E.ID = D.ID
				where E.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
				<!---and E.Procesado = 'S' La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz40.recordcount eq 0>
		<cfthrow message="Error en Interfaz 40. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
	
	<!---Valida Montos--->
		<cfquery name ="rsTotalEnc" datasource="sifinterfaces">
			select MontoTotal
			from IE40 
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		</cfquery>
			
		<cfquery name ="rsTotalDet" datasource="sifinterfaces">
			select sum(MontoDocumento) as MontoDet
			from ID40 
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		</cfquery>
			
		<cfif rsTotalEnc.recordcount EQ 0 or rsTotalDet.recordcount EQ 0 or rsTotalEnc.MontoTotal NEQ 
		rsTotalDet.MontoDet>
			<cfthrow message="El importe del documento de cancelación no puede ser diferente a la suma de los montos de los documentos a cancelar">
		</cfif>
			
	<!---
	<!---Valida socio--->
		<cfquery name= "rsSocio" datasource="sifinterfaces">
			select distinct NumeroSocioDoc 
			from ID40
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">			
		</cfquery>
		
		<cfif isdefined("rsSocio") and rsSocio.recordcount EQ 1>
			<cfif rsSocio.NumeroSocioDoc NEQ readInterfaz40.NumeroSocio>
			   <cfthrow message="El socio del documento a crear es distinto al de los documentos a cancelar. Proceso cancelado.">
			</cfif>
		<cfelse>
			<cfthrow message="Existe mas de un socio en los documentos que se desean cancelar. Proceso cancelado.">			
		</cfif>	--->		
				
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar. --->
<!--- Invoca Componente de Procesamiento de Interfaz 10. --->
<cfinvoke component="interfacesSoin.Componentes.CP_InterfazCancelacionDocumentos" method="process" returnvariable="MSG" 
query="#readInterfaz40#"/>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>