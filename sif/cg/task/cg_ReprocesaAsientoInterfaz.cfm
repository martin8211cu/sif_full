<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Reprocesa Asiento</title>
</head>

<cfparam name="url.ID" type="integer" default="-1">

<cfif isdefined("url.ID") and isnumeric("#url.ID#") and url.ID GT 0>
	<cfset GvarID = url.ID>
	<p>Procesando Asiento:  <cfoutput>#GvarID#</cfoutput></p>
	<cfquery name="rsVerificaAsientoProcesado" datasource="#session.dsn#">
		select ECIid, IDcontable, PeriodoAsiento, MesAsiento
		from EContablesInterfaz18
		where ID = #GvarID#
	</cfquery>

	<cfif isdefined("rsVerificaAsientoProcesado") and len(rsVerificaAsientoProcesado.IDcontable) GT 0>
		<br />
		<p>El Asiento ya fue procesado en Documentos Contables!</p> 
		<br />
		<p>NO se reprocesa el asiento para evitar duplicados</p>
	<cfelse>	
		<cfinclude template="/interfacesSoin/componentesInterfaz/interfazSoin18.cfm">
		<cfset fnProcesaQuery()>
		<br />
		<p>Asiento Procesado</p> 
	</cfif>
</cfif>
<body>
</body>
</html>
