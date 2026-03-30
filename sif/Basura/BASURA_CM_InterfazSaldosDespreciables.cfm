<cfinclude template="../Application.cfm">
<cfset session.Ecodigo = 1>
<cfset session.dsn = "minisif">
<cfset session.usucodigo = 27>
<cfset GVarID = 48003 >
<!----<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cfset bandera = false>
---->

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
				select 	IE13.ID,
						IE13.EcodigoSDC,
						IE13.ModuloOrigen,
						IE13.FechaAplicacion,
						IE13.NumeroSocio,
						IE13.CodigoTransaccion,
						IE13.Documento,
						IE13.CodigoMoneda,
						IE13.MontoEliminado,
						IE13.TransaccionOrigen,
						IE13.Observacion,
						IE13.CodigoTransaccionElim,
						IE13.DocumentoEliminacion,
						IE13.BMUsucodigo
				from IE13
				where IE13.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 13=Registro de Transacciones eliminadas">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con CM_Interfaz --->
	<cfset LobjControl = createObject( "component","interfacesSoin.Componentes.CM_InterfazSaldosDespreciables")>
	<cfset LobjControl.init(rsInput.EcodigoSDC)>
	<cfoutput query="rsInput"> <!----group="ID">---->
		<!----<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>--->
			<!--- Alta de TransaccionesFechaAplicacion, --->
			<cfset EncabDocumento = LobjControl.Alta_SaldosDespreciables(
					EcodigoSDC,
					ModuloOrigen,					
					NumeroSocio,					
					CodigoMoneda,
					MontoEliminado,					
					Observacion,
					CodigoTransaccionElim,
					DocumentoEliminacion,
					BMUsucodigo)
			>	
			<!----<cfoutput>---->
				<!----<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>---->							
					<cfset DetDocumento = LobjControl.Alta_DetSaldosDespreciables(
							EncabDocumento.idDocumentoNeteo,
							EcodigoSDC,
							ModuloOrigen,												
							CodigoTransaccion,
							Documento,
							TransaccionOrigen,												
							MontoEliminado,																			
							BMUsucodigo)>
			<!----</cfoutput>-dateformat(FechaAplicacion,'yyyy/mm/dd'),		--->
	</cfoutput>	
	
</cftransaction>

<cfset LobjControl.aplicar(EncabDocumento.idDocumentoNeteo, EncabDocumento.Ecodigo, session.Usucodigo, session.usulogin) >



