<cfcomponent displayname="Conexion a SOIN">

<cffunction name="autorizar" >
	<cfargument name="config"  type="string"  required="yes">
	<cfargument name="tarjeta" type="struct"  required="yes">
	<cfargument name="monto"   type="numeric" required="yes">
	<cfargument name="moneda"  type="string"  required="yes">
	<cfargument name="control" type="string"  required="yes">

	<cfset return_status = StructNew()>
	<cfset return_status.error = 0>
	<cfset return_status.mensaje = "Transacción completada">
	<cfset return_status.autorizacion = NumberFormat( Rand() * 10000, '0000')>
	<cfset return_status.respuesta = "OK">
	<cfset return_status.autorizador = '/soin/'>
	<cfif Rand() GT 0.6>
		<!--- rechazar el 40% de las autorizaciones --->
		<cfset return_status.error = 500501>
		<cfset return_status.mensaje = "Servidor de autorizaciones no disponible, intente más tarde">
		<cfset return_status.autorizacion = "">
		<cfset return_status.respuesta = "No disponible">
	</cfif>
	
	<cflog application="no" file="autorizaciones_soin" text="
		#return_status.autorizador#
		Tarjeta: #Arguments.tarjeta.tc_numero# #Arguments.tarjeta.tc_nombre# #Arguments.tarjeta.tc_vence_mes#/#Arguments.tarjeta.tc_vence_ano# #Arguments.monto#
		Respuesta: #return_status.respuesta#
		Error: #return_status.error# - #return_status.mensaje#
		Num aut: #return_status.autorizacion#
		">

	<cfreturn return_status>
	
</cffunction>
</cfcomponent>