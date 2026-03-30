<cfcomponent displayname="Conexion a CREDOMATIC">

<cffunction name="autorizar" >
	<cfargument name="config"  type="string"  required="yes">
	<cfargument name="tarjeta" type="struct"  required="yes">
	<cfargument name="monto"   type="numeric" required="yes">
	<cfargument name="moneda"  type="string"  required="yes">
	<cfargument name="control" type="string"  required="yes">


	<cfset mes = NumberFormat(Arguments.tarjeta.tc_vence_mes, '00')>
	<cfset ano = NumberFormat(Arguments.tarjeta.tc_vence_ano mod 100, '00')>
	<cfset monto_exe = Round(Arguments.monto * 100)>
	
	
	<cfset return_status = StructNew()>
	<cfset return_status.error = -1>
	<cfset return_status.mensaje = "Transacción no iniciada">
	<cfset return_status.autorizacion = "">
	
	<cfset exename="#ExpandPath('/autorizaciones/credomatic/newcli.exe')#">
	<cfset exeargs="aut #Arguments.tarjeta.tc_numero# #mes# #ano# #monto_exe# #Arguments.control# " &
		"-C#Arguments.tarjeta.tc_digito# -P#ExpandPath('/autorizaciones/credomatic/')#">
	
	<cfexecute name="#exename#"
		arguments="#exeargs#"
		variable="respuesta"
		timeout="30">
	</cfexecute>
	<cfset return_status.autorizador = '/credomatic/'>
	
	<!---
	<cfset respuesta="0000-INET0123456789012345">
	<cfset return_status.autorizador = 'PRUEBAS'>
	--->
	
	<cfset return_status.respuesta = respuesta>
	
	<cfif REFind("^\d{4}-", respuesta)>
		<cfset return_status.error = Int(Mid(respuesta,1,4))>
		<cfif return_status.error IS 0>
			<!--- Transaccion OK, informar status --->
			<cfset return_status.mensaje = "Transacción recibida y aprobada.">
			<cfset return_status.autorizacion = Mid(respuesta,6,Len(respuesta))>
		<cfelseif return_status.error IS 1>
			<cfset return_status.mensaje = "Host inalcanzable">
		<cfelseif return_status.error IS 10>
			<cfset return_status.mensaje = "Monto no valido. El monto es demasiado grande.">
		<cfelseif return_status.error IS 12>
			<cfset return_status.mensaje = "ID de transacción Invalido">
		<cfelseif return_status.error IS 13>
			<cfset return_status.mensaje = "Terminal Invalida">
		<cfelseif return_status.error IS 14>
			<cfset return_status.mensaje = "Comercio Invalido">
		<cfelseif return_status.error IS 17>
			<cfset return_status.mensaje = "Malfuncionamiento del Sistema">
		<cfelseif return_status.error IS 18>
			<cfset return_status.mensaje = "Transaccion no soportada">
		<cfelseif return_status.error IS 20>
			<cfset return_status.mensaje = "Tarjeta Invalida">
		<cfelseif return_status.error IS 21>
			<cfset return_status.mensaje = "Tarjeta Expirada">
		<cfelseif return_status.error IS 9999>
			<cfset return_status.mensaje = "Transacción recibida y declinada">
		<cfelse>
			<cfset return_status.mensaje = "Error numero " & return_status.error>
		</cfif>
	<cfelse>
		<cfif Len(Trim(respuesta))>
			<cfset return_status.error = -2>
			<cfset return_status.mensaje = respuesta>
		<cfelse>
			<cfset return_status.error = -3>
			<cfset return_status.mensaje = "Sin respuesta">
		</cfif>
	</cfif>
	
	<cflog application="no" file="autorizaciones_credomatic" text="
	#return_status.autorizador#
	Tarjeta: #Arguments.tarjeta.tc_numero# #Arguments.tarjeta.tc_nombre# #Arguments.tarjeta.tc_vence_mes#/#Arguments.tarjeta.tc_vence_ano# #Arguments.monto#
	Invocacion: #exename# #exeargs#
	Respuesta: #return_status.respuesta#
	Error: #return_status.error# - #return_status.mensaje#
	Num aut: #return_status.autorizacion#
	">

	<cfreturn return_status>
	

</cffunction>
</cfcomponent>