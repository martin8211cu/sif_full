<!---
	Este programa actualiza las tareas programadas de coldfusion.
	Este programa también corre como tarea programada (diaria), de 
	manera que cualquier actualización que se realice a este archivo
	tendrá efecto como máximo al día siguiente de la actualización.
	
	Hay tres tipos de tareas programadas:
		* Las que se deben ejecutar en todos los servidores, eg. en 
		  el ambiente de desarrollo, donde hay múltiples servidores 
		  en las PC de cada programador.  Las tareas  de  este  tipo
		  se ejecutarán tantas veces como servidores haya.
		* Las que solamente se ejecutan en el servidor principal,   
		  como el envío de correo, que consume una cola y ejecutarla
		  en múltiples servidores causaría bloqueos.
		* Las que no se deben ejecutar (!).  En esta  categoría  van
		  las tareas obsoletas, es decir, que antes  sí estaban pero
		  se deban eliminar

	Si agrega una  nueva tarea,  tenga el cuidado de colocarla en la
	sección adecuada, y usar en el action ya sea "update",  para las
	tareas comunes a todos los servidores, o #solo_principal#, para 
	las que se deban ejecutar en el servidor principal solamente.
		
--->
<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset servidor_principal = Politicas.trae_parametro_global("servidor.principal")>
<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="localhostname"/>
<cfset es_principal =
	(servidor_principal EQ '0') OR
	(Len(Trim(servidor_principal)) EQ 0) OR
	(UCase(Trim(servidor_principal)) EQ UCase(Trim(localhostname)))>
<cfif es_principal>
	<cfset schedule_action = 'update'>
<cfelse>
	<cfset schedule_action = 'delete'>
</cfif>

<cfset req = GetHTTPRequestData().headers>
	
	<cfset hostname = "">
	<cfif StructKeyExists(req,"X-Forwarded-Host")>
		<cfset hostname = req["X-Forwarded-Host"]>
	</cfif>
	<cfif Len(hostname) EQ 0>
		<cfset hostname = req["Host"]>
	</cfif>
	<cfif ListLen(hostname) GT 1>
		<cfset hostname = Trim(ListGetAt(hostname, 1))>
	</cfif>

	
<cfoutput>
	HTTP Host: #hostname#
	<br />
	servidor_principal: #servidor_principal#
	<br />
	localhostname: #localhostname#
	<br />
	es_principal: #es_principal#
</cfoutput>


<cfif Len(hostname) is 0>
	<cfoutput> === ERROR === no se ha especificado el hostname </cfoutput>
<cfelse>

	<!--- Tareas viejas que se deben eliminar --->
	<!---<cfschedule 
		action="delete" 
		task="Nombre"
		url="http://#hostname#/cfmx/saci/tasks/nombre.cfm"
		interval="90"
		operation="httprequest"
		startdate="08/08/2003"
		starttime="12:00:00 AM">--->
	
	<!--- Tareas comunes que se deben ejecutar en todos los servidores --->
	<cfschedule
		action="update"
		task="isb_tasacion"
		url="http://#hostname#/cfmx/saci/tasks/tasacion.cfm"
		interval="60"
		operation="httprequest"
		startdate="08/08/2003"
		starttime="12:00:00 AM"
		requesttimeout="600">

	<!--- Tareas que solo corren en un servidor (el principal) --->
	<cfschedule
		action="#schedule_action#"
		task="isb_rs_monitor"
		url="http://#hostname#/cfmx/saci/tasks/rs_monitor.cfm"
		interval="300"
		operation="httprequest"
		startdate="08/08/2003"
		starttime="12:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_prospectacion"
		url="http://#hostname#/cfmx/saci/tasks/prospectacion.cfm"
		interval="86400"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="12:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_fact900_enviar"
		url="http://#hostname#/cfmx/saci/tasks/isb_fact900_enviar.cfm"
		interval="86400"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="05:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_fact900_recibir"
		url="http://#hostname#/cfmx/saci/tasks/isb_fact900_recibir.cfm"
		interval="3600"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="01:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_tareaProgramada"
		url="http://#hostname#/cfmx/saci/tasks/isb_tareaProgramada.cfm"
		interval="3600"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="01:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_bloqueoLoginExpirado"
		url="http://#hostname#/cfmx/saci/tasks/isb_bloqueoLoginExpirado.cfm"
		interval="3600"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="01:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_inhabAgentes"
		url="http://#hostname#/cfmx/saci/tasks/isb_inhabAgentes.cfm"
		interval="86400"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="02:00:00 AM"
		requesttimeout="600">

	<cfschedule
		action="#schedule_action#"
		task="isb_jmstask"
		url="http://#hostname#/cfmx/saci/tasks/isb_jmstask.cfm"
		interval="60"
		operation="httprequest"
		startdate="01/01/2006"
		starttime="02:00:00 AM"
		requesttimeout="3650">
</cfif>

<br />
Listo.
