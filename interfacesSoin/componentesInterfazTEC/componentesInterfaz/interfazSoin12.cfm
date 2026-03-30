<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		select 
			a.ID, 
			a.EcodigoSDC, 
			a.CodigoMonedaOrigen, 
			a.NumeroSocioDocOrigen, 
			a.FechaAplicacion, 
			a.TipoCambio, 
			a.TransaccionOrigen, 
			a.BMUsucodigo, 
			
			b.NumeroSocioDoc,
			b.Modulo,
			b.CodigoTransaccion, 
			b.Documento, 
			b.Monto
		from IE12 a
			inner join ID12 b
			on b.ID = a.ID
		where a.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 12=Aplicación de Notas de Crédito o Anticipos">
	</cfif>
</cftransaction>

<cftransaction>
	<!--- Inicializa el componente de interfaz con solicitudes --->
	<cfset LobjControl = createObject("component","interfacesSoin.Componentes.CM_InterfazNeteo")>
	<cfset LobjControl.init(rsInput.EcodigoSDC)>
	<cfoutput query="rsInput" group="ID">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<!--- Validar que las dos Monedas sean iguales --->
		<!--- <cfset LobjControl.validaMonedas(rsInput.CodigoMonedaOrigen, rsInput.CodigoMonedaDestino)> --->
		<!--- Validar que los dos Modulos pertenezcan a CxC o CxP --->
		<!--- <cfset LobjControl.validaModulos(rsInput.ModuloOrigen, rsInput.ModuloDestino)> --->
		<!--- Insertar el Encabezado --->
		<cfset LvarID = LobjControl.Alta_DocNeteo(rsInput.CodigoMonedaOrigen, rsInput.TransaccionOrigen, rsInput.NumeroSocioDocOrigen, rsInput.FechaAplicacion, 'Generado por Interfaz de Neteo/Aplicación de Notas de Crédito o Anticipos')>
		<cfoutput>
			<!--- Insertar los detalles --->
			<cfset LobjControl.Alta_DocNeteoDet(rsInput.Modulo, LvarID, rsInput.CodigoTransaccion, rsInput.NumeroSocioDoc, rsInput.Monto, rsInput.Documento, rsInput.TransaccionOrigen)>
		</cfoutput>
	</cfoutput>
</cftransaction>

<!--- Aplicar el Documento de Neteo --->
<cfset LobjControl.Aplica_Documento(LvarID)>
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
