<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select
			a.ID
			, a.EcodigoSDC
			, a.CodigoBancoOrigen
			, a.CuentaBancariaOrigen
			, a.TipoMovimientoOrigen
			, a.CodigoMonedaOrigen
			, round(a.MontoOrigen,2) as MontoOrigen
			, round(a.MontoComision,2) as MontoComision
			, a.CodigoBancoDestino
			, a.CuentaBancariaDestino
			, a.TipoMovimientoDestino
			, a.CodigoMonedaDestino
			, round(a.MontoDestino,2) as MontoDestino
			, a.NumeroDocumento
			, a.FechaValor
			, a.Observacion
			, a.FechaAplicacion
			, a.ConceptoComision
			, a.Estimacion
			, a.IndMovConta
			, a.BMUsucodigo	
			, coalesce(a.TipoCambio,-1) as TipoCambio
			, a.ImpRetencion
			, a.CodRentencion
			

		from IE14 a
		where a.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 14=Registro de Transferencias">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con CM_InterfazTransferencias --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazTransferencias")>
	<cfset LobjControl.init(rsInput.EcodigoSDC)>
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	<cfif rsInput.Estimacion eq 0 and rsInput.IndMovConta eq '0' and len(trim(rsInput.CodigoBancoOrigen)) GT 0>
		<!--- No es Estimación --->
		<!--- Alta del encabezado de Transferencias --->							
		<cfset EncabTraspaso = LobjControl.Alta_ETransferencias(
				rsInput.Observacion,
				rsInput.FechaValor,					
				rsInput.BMUsucodigo,
				rsInput.NumeroDocumento)
		>
		<cfif isdefined('EncabTraspaso') and EncabTraspaso GT 0>
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
			<!--- Alta del detalle de Transferencias --->											
			<cfset DetTraspaso = LobjControl.Alta_DTransferencias(
					<!---rsInput.EncabTraspaso, --->
					EncabTraspaso,
					rsInput.CuentaBancariaOrigen,
					rsInput.CuentaBancariaDestino,
					rsInput.MontoOrigen,
					rsInput.MontoDestino,												
					rsInput.CodigoMonedaOrigen,
					rsInput.MontoComision,								
					rsInput.CodigoBancoOrigen,
					rsInput.CodigoBancoDestino,
					rsInput.BMUsucodigo,
					rsInput.CodigoMonedaDestino,
					rsInput.NumeroDocumento,
					rsInput.FechaValor,
					rsInput.TipoCambio,
					rsInput.TipoMovimientoOrigen,
					rsInput.TipoMovimientoDestino)
			>
			<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>		
			<!--- Aplicación de la Transferencia --->
			<!--- <cftransaction action="commit"/> --->
			
			<cfset LvarAplicaTrans = LobjControl.Aplica_Transferencia(EncabTraspaso)>
		</cfif>
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	<cfelse>
		<!--- Es Estimación --->
		<!--- Contabiliza Estimación --->
		<cfset LvarAplicaTrans = LobjControl.Aplica_TransferenciaEstimacion(
			rsInput.CodigoBancoOrigen
			, rsInput.CuentaBancariaOrigen
			, rsInput.TipoMovimientoOrigen
			, rsInput.CodigoMonedaOrigen
			, rsInput.MontoOrigen
			, rsInput.MontoComision
			, rsInput.CodigoBancoDestino
			, rsInput.CuentaBancariaDestino
			, rsInput.TipoMovimientoDestino
			, rsInput.CodigoMonedaDestino
			, rsInput.MontoDestino
			, rsInput.FechaValor
			, rsInput.Observacion
			, rsInput.FechaAplicacion
			, rsInput.ConceptoComision
			, rsInput.Estimacion
			, rsInput.BMUsucodigo
			, rsInput.IndMovConta
			, rsInput.NumeroDocumento
			, false
			, rsInput.TipoCambio
			, rsInput.ImpRetencion
			, rsInput.CodRentencion
		)>
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	</cfif>
</cftransaction>