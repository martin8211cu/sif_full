<!---
	Realiza un cargo a una tarjeta de crédito
	a través de credomatic.
	
	Atributos:
		monto   Monto por cargar a la tarjeta
		tarjeta Número de tarjeta
		nombre  Nombre del tarjetahabiente impreso en la tarjeta
		vence   Fecha de vencimiento (mm/yy)
		cvc     ccv/cvc/ digitos verificadores de la tarjeta

	Resultado:
		La variable cf_tarjeta_cobro contiene el resultado de la operacion.
		cf_tarjeta_cobro.error:        0 = ok, otra cosa es error
		cf_tarjeta_cobro.mensaje:      Contiene el mensaje correspondiente al numero de error
		                               Este mensaje es específico del autorizador
		cf_tarjeta_cobro.autorizacion: Contiene el numero de autorizacion, si aplica
		cf_tarjeta_cobro.autorizador:  Nombre del autorizador (Credomatic, ATH, etc)
		cf_tarjeta_cobro.respuesta:    Respuesta completa del emisor a esta transacción

	Ejemplo:
--->
<cfparam name="Attributes.monto"   type="numeric">
<cfparam name="Attributes.moneda"  type="string">
<cfparam name="Attributes.tarjeta" type="string">
<cfparam name="Attributes.nombre"  type="string">
<cfparam name="Attributes.vence"   type="string">
<cfparam name="Attributes.cvc"     type="string">
<cfparam name="Attributes.orden"   type="string" default="">

<cfset mes = Left(Attributes.vence,2)>
<cfset ano = Right(Attributes.vence,2)>
<cfset monto = Round(Attributes.monto * 100)>

<!---
<cfoutput>
Cobrando #Attributes.monto# (#monto#) #Attributes.moneda# de la tarjeta #Attributes.tarjeta#
que vence el #Attributes.vence# (#mes#/#ano#)
a nombre de #Attributes.nombre#
</cfoutput>
--->


<cfset return_status = StructNew()>
<cfset return_status.error = -1>
<cfset return_status.mensaje = "Transacción no iniciada">
<cfset return_status.autorizacion = "">

<cfset exename="#ExpandPath('/autorizaciones/credomatic/newcli.exe')#">
<cfset exeargs="aut #Attributes.tarjeta# #mes# #ano# #monto# #Attributes.orden# " &
	"-C#Attributes.cvc# -P#ExpandPath('/autorizaciones/credomatic/')#">

<cfexecute name="#exename#"
	arguments="#exeargs#"
	variable="respuesta"
	timeout="30">
</cfexecute>
<cfset return_status.autorizador = 'CREDOMATIC'>

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

<cfset Caller.cf_tarjeta_cobro = return_status>

<cflog application="no" file="autorizaciones" text="
#return_status.autorizador#
Tarjeta: #Attributes.tarjeta# #Attributes.nombre# #Attributes.vence# #Attributes.monto#
Invocacion: #exename# #exeargs#
Respuesta: #return_status.respuesta#
Error: #return_status.error# - #return_status.mensaje#
Num aut: #return_status.autorizacion#
">