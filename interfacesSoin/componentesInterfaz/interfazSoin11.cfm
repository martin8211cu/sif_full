<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsConDetalle" datasource="sifinterfaces">
				select ConDetalle,MontoPago from IE11 where ID = #GvarID#
	</cfquery>
	
	<cfif rsConDetalle.ConDetalle eq 1>
			<cfquery name="TieneD" datasource="sifinterfaces">
				select count(1) as lineas, sum (MontoPago) as MontoPago  
				from ID11 
				where ID = #GvarID#
			</cfquery>
			<cfif isdefined("TieneD.lineas") and TieneD.lineas eq 0>
				<cfthrow message="Error no existen líneas de detalle y el check ConDetalle se encuentra activo. Proceso Cancelado!">
			<cfelse>
				<cfif isdefined("TieneD.MontoPago") and TieneD.MontoPago neq rsConDetalle.MontoPago>
					<cfthrow message="Error la sumatoria de los montos en el detalle no es igual al encabezado. Proceso Cancelado!">
				</cfif>	
			</cfif>
	</cfif>
	<cfquery name="rsInput" datasource="sifinterfaces">
				select 
					IE11.ID,
					IE11.EcodigoSDC,
					IE11.TipoCobroPago,
					IE11.CodigoBanco,
					IE11.CuentaBancaria,
					IE11.FechaTransaccion,
					IE11.TipoPago,
					IE11.NumeroDocumento,
					IE11.NumeroSocio,
					IE11.NumeroSocioDocumento,
					IE11.MontoPago,
					IE11.TipoCambio,
					IE11.CodigoMonedaPago,
					IE11.CodigoMonedaDoc,
					IE11.TransaccionOrigen,
					IE11.BMUsucodigo,
					IE11.ConDetalle,
					null as IDpago,
					round(coalesce(ID11.MontoPago,IE11.MontoPago),2)		  as MontoPagoL,
					coalesce(ID11.CodigoTransaccion,IE11.CodigoTransaccion)   as CodigoTransaccionL,
					coalesce(ID11.Documento,IE11.Documento) 				  as DocumentoL,
					coalesce(ID11.CodigoMonedaDoc,IE11.CodigoMonedaDoc) 	  as CodigoMonedaDocL,
					coalesce(ID11.MontoPagoDocumento,IE11.MontoPagoDocumento) as MontoPagoDocumentoL,
					case when ID11.ID is null then 0 else ID11.Anticipo end   as Anticipo,
					coalesce(ID11.MontoRetencion, IE11.MontoRetencion, 0)     as MontoRetencion
				from IE11
				left outer join ID11 
					on  IE11.ID  = ID11.ID
				where IE11.ID = #GvarID#
	</cfquery>


	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 11=Pagos para la aceptación de SOIN desde Movimientos TBS">
	</cfif>
</cftransaction>


<cftransaction>
	<!--- Inicializa el componente de interfaz con CM_Interfaz --->
	<!--- <cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CP_InterfazPagos")>
	<cfset LobjControl.init(rsInput.EcodigoSDC)> --->
	<cfinvoke component="interfacesSoin.Componentes.CP_InterfazPagos" method="init" EcodigoSDC="#rsInput.EcodigoSDC#" />
	<cfinvoke component="interfacesSoin.Componentes.CP_InterfazPagos" method="Procesa_Pago" returnvariable="MSG" query="#rsInput#"/>
	
	
<!--- 	<cfoutput query="rsInput" group="ID">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<!--- Alta de Transacciones --->
			<cfset pago = LobjControl.Procesa_Pago(
					#GvarID#,
					EcodigoSDC,
					TipoCobroPago,
					CodigoBanco,
					CuentaBancaria,
					FechaTransaccion,
					TipoPago,
					ConDetalle,
					NumeroDocumento,
					NumeroSocio,
					NumeroSocioDocumento,
					MontoPago,
					TipoCambio,
					CodigoMonedaPago,
					CodigoMonedaDoc,
					TransaccionOrigen,
					BMUsucodigo)>
	</cfoutput> --->
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
</cftransaction>
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

