<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfreturn true>
	</cffunction>

	<!--- FUNCION PARA VALIDAR QUE LAS ORDENES DE PAGO, CUENTEN CON UNA CUENTA DE PAGO O DESTINO --->
	<cffunction name="validaOrdenesPago" access="remote" returntype="struct">
		<cfargument name="idsOP" 		required="true" 	type="string">
		<cfset ordenesInvalidas = "">

		<cftry>
			<cfset Local.obj = {MSG='validaOK'}>

			<cfquery name="rsConsultaOrdenes" datasource="#Session.dsn#">
				SELECT TESOPnumero
				FROM TESordenPago
				WHERE (CBidPago IS NULL
				  OR TESTPid IS NULL)
				  AND TESOPid IN (#arguments.idsOP#)
			</cfquery>
			<cfif rsConsultaOrdenes.recordCount GT 0>
				<cfif rsConsultaOrdenes.recordCount EQ 1>
					<cfset ordenesInvalidas = "La orden: "&#rsConsultaOrdenes.TESOPnumero#&" no se puede emitir, debido a que no tiene Cuenta de pago o destino.">
				<cfelse>
					<cfset ordenesInvalidas = "Las ordenes: ">
					<cfloop query="rsConsultaOrdenes">
						<cfif rsConsultaOrdenes.recordCount EQ rsConsultaOrdenes.currentRow>
							<cfset ordenesInvalidas = ordenesInvalidas & #rsConsultaOrdenes.TESOPnumero# &" no pueden emitirse, debido a que no tienen Cuenta de pago o destino.">
						<cfelse>
							<cfset ordenesInvalidas = ordenesInvalidas & #rsConsultaOrdenes.TESOPnumero# & ", ">
						</cfif>
					</cfloop>
				</cfif>
				<cfset Local.obj = {MSG=ordenesInvalidas}>
			</cfif>

			<cfcatch type="any">
				<cfif isDefined("cfcatch.detail")>
					<cfset msg = #cfcatch.detail#>
				<cfelse>
					<cfset msg = "">
				</cfif>
				<cfset Local.obj = {MSG='Ha ocurrido un error al validar las ordenes, intente más tarde. #msg#'}>
			</cfcatch>
		</cftry>
		<cfreturn  Local.obj>
	</cffunction>

	<!--- FUNCION PARA VALIDAR QUE LAS ORDENES DE PAGO, CUENTEN CON UNA CUENTA DE PAGO UNICAMENTE --->
	<cffunction name="validaCuentaPagoSP" access="remote" returntype="struct">
		<cfargument name="idsSP" 		required="true" 	type="string">
		<cfset ordenesInvalidas = "">

		<cftry>
			<cfset Local.obj = {MSG='validaOK'}>

			<cfquery name="rsConsultaSP" datasource="#Session.dsn#">
				SELECT TESSPnumero
				FROM TESsolicitudPago
				WHERE CBidPago IS NULL
				  AND TESSPid IN (#arguments.idsSP#)
			</cfquery>

			<cfif rsConsultaSP.recordCount GT 0>
				<cfif rsConsultaSP.recordCount EQ 1>
					<cfset ordenesInvalidas = "Falta la cuenta de pago, para la solicitud: "&#rsConsultaSP.TESSPnumero#&". Favor de seleccionar una cuenta y un medio de pago.">
				<cfelse>
					<cfset ordenesInvalidas = "Falta la cuenta de pago, para las solicitudes: ">
					<cfloop query="rsConsultaSP">
						<cfif rsConsultaSP.recordCount EQ rsConsultaSP.currentRow>
							<cfset ordenesInvalidas = ordenesInvalidas & #rsConsultaSP.TESSPnumero# &". Favor de seleccionar una cuenta y un medio de pago.">
						<cfelse>
							<cfset ordenesInvalidas = ordenesInvalidas & #rsConsultaSP.TESSPnumero# & ", ">
						</cfif>
					</cfloop>
				</cfif>
				<cfset Local.obj = {MSG=ordenesInvalidas}>
			</cfif>

			<cfcatch type="any">
				<cfif isDefined("cfcatch.detail")>
					<cfset msg = #cfcatch.detail#>
				<cfelseif isDefined("cfcatch.message")>
					<cfset msg = #cfcatch.message#>
				<cfelse>
					<cfset msg = "">
				</cfif>
				<cfset Local.obj = {MSG='Ha ocurrido un error al validar las solicitudes de pago, intente más tarde. #msg#'}>
			</cfcatch>
		</cftry>
		<cfreturn  Local.obj>
	</cffunction>

</cfcomponent>