<cfcomponent output="false">

	<cffunction name="ValidarNumero" access="public" return="numeric">
		<cfargument name="Num_Producto" 		required="yes" 		type="string">
		<cfargument name="SocioNegocioID" 		required="yes" 		type="numeric">
		<cfargument name="TipoProducto" 		default='' 			type="string">
		<cfargument name="TipoTransac"			default='' 			type="string">
		<cfargument name="TiendaID"		 		required="yes" 		type="string">

		<cfargument name="Monto" 				default=0 			type="numeric">
		<cfargument name="DSN" 					default="#Session.DSN#" type="string">
		<cfargument name="Ecodigo" 				default="#Session.Ecodigo#" type="string">
		
		<cfquery name="q_ValeCancelado" datasource="#arguments.DSN#">
			select id from CRCValesExtCancelados 
				where 
					folio = '#arguments.Num_Producto#'
					and	CRCTiendaExternaid = #arguments.TiendaID#
					and Ecodigo = #arguments.Ecodigo#;
		</cfquery>
		
		<cfif q_ValeCancelado.recordcount neq 0>
			<cfthrow type="TransaccionException" message = "El vale de crédito numero [#arguments.Num_Producto#] esta cancelado">
		</cfif>
		
		<cfquery name="q_Externo" datasource="#arguments.DSN#">
			select id from CRCCuentas 
				where 
					SNegociosSNid = #arguments.SocioNegocioID#
					and	Tipo = '#arguments.TipoProducto#'
					and Ecodigo = #arguments.Ecodigo#;
		</cfquery>
		
		<cfif q_Externo.recordcount eq 1>
			<cfset q_Externo = QueryGetRow(q_Externo, 1)>
			<cfset objCuenta = createObject("component","crc.Componentes.CRCCuentas")>
			<cfset montoDisponible = objCuenta.DisponibleCuenta(CuentaID="#q_Externo.id#", Monto="#arguments.Monto#",DSN = #arguments.DSN#,Ecodigo = #arguments.Ecodigo#)>
			<cfif (arguments.Monto le montoDisponible and arguments.Monto ge 0) || arguments.Monto eq 0>
				<cfreturn q_Externo.id>
			<cfelse>
				<cfreturn 0>
			</cfif>
		<cfelse>
			<cfthrow type="TransaccionException" message = "No se encontro una cuenta para folio numero [#arguments.Num_Producto#]">	
		</cfif>
		
		<cfreturn 0>

		
	</cffunction>
	
	
</cfcomponent>