<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)> 
<cfset bandera = false>--->

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		Select
			ID
			, EcodigoSDC
			, CodigoBancoOrigen
			, CuentaBancariaOrigen
			, TipoMovimientoOrigen
			, CodigoMonedaOrigen
			, MontoOrigen
			, MontoComision
			, CodigoBancoDestino
			, CuentaBancariaDestino
			, TipoMovimientoDestino
			, CodigoMonedaDestino
			, MontoDestino
			, FechaValor
			, Observacion
			, FechaAplicacion
			, ConceptoComision
			, BMUsucodigo	
		from IE14
		where ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cf_errorCode	code = "50271"
						msg  = "No existen datos de Entrada para el ID='@errorDat_1@' en la Interfaz 14=Registro de Transferencias"
						errorDat_1="#GvarID#"
		>
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con CM_InterfazTransferencias 
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazTransferencias")>--->
	<cfset LobjControl = createObject( "component","sif.cm.consultas.CM_InterfazTransferencias")>	
	<cfset LobjControl.init(Session.Dsn,0,rsInput.EcodigoSDC)>
	<cfoutput query="rsInput" group="ID">
		<!--- <cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)> --->
			<!--- Alta del encabezado de Transferencias --->							
			<cfset EncabTraspaso = LobjControl.Alta_ETransferencias(
					Observacion,
					FechaValor,					
					BMUsucodigo)
			>
			<cfif isdefined('EncabTraspaso') and EncabTraspaso NEQ -1>
				<!---<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
				 Alta del detalle de Transferencias --->											
				<cfset DetTraspaso = LobjControl.Alta_DTransferencias(
						EncabTraspaso,
						CuentaBancariaOrigen,
						CuentaBancariaDestino,
						MontoOrigen,
						MontoDestino,												
						CodigoMonedaOrigen,
						MontoComision,								
						BMUsucodigo)
				>		
				
			</cfif>
	</cfoutput>		
	
	<!---<cfif isdefined('EncabTraspaso') and EncabTraspaso NEQ ''>
		 <cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)> 		
		<cfset LvarAplicaTrans = LobjControl.Aplica_Transferencia(EncabTraspaso)>
	</cfif>
	<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)> --->
</cftransaction>

