<cfsetting  requesttimeout="36000">
<cfparam name="url.CE" default="-1">
<cfparam name="url.NI" default="-1">
<cfparam name="url.ID" default="-1">
<cfparam name="url.SVR" default="-1">

<cftry>
	<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
	<cfif url.SVR NEQ "-1">
		<cfset application.Interfaz.serverId = getTickCount()>
		<cfheader name="IserverId" value="#application.Interfaz.serverId#">
	</cfif>
	<cfif url.CE NEQ "-1" AND url.NI EQ "-1" and url.ID EQ "-1">
		<cfset LobjColaProcesos.sbActivarCola (url.CE)>
	<cfelseif url.CE NEQ "-1" AND url.NI NEQ "-1" and url.ID EQ "-1">
		<cfset LobjColaProcesos.sbActivarColaInterfaz(url.CE, url.NI)>
	<cfelseif url.CE NEQ "-1" AND url.NI NEQ "-1" AND url.ID NEQ "-1">
		<cfset LobjColaProcesos.sbActivarColaProceso(url.CE, url.NI, url.ID)>
	<cfelse>
		<cfset LvarError = "La Tarea Asíncrona de Activación de Interfaces SOIN no puede ser invocada directamente">
	</cfif>
<cfcatch type="any">
	<cfif NOT LobjColaProcesos.fnIsBug(cfcatch)>
		<cfset LvarError = "#cfcatch.Message# #cfcatch.Detail#">
	<cfelse>
		<cfthrow object="#cfcatch#">
	</cfif>
</cfcatch>
</cftry>


<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>
			Tarea Asíncrona de Interfaz de Sistemas Externos a SOIN
		</title>
	</head>
	<body>
		<p style="color: ##0000FF;font-size: 36px;">Tarea Asíncrona de Interfaces SOIN </p>
		<p>La Tarea Asíncrona de Activación de Interfaces SOIN esta iniciado la Cola de Procesos pendientes</p>
		<cfif isdefined("LvarError") and LvarError NEQ "">
			<BR><BR><font color="##FF0000">#LvarError#</font>
		<cfelse>
		<p>Cola de Procesos pendientes activada con exito</p>
		</cfif>
	</body>
</html>
</cfoutput>