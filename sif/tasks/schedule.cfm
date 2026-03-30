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
<cfapplication name="SIF_ASP"
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">
<cf_templatecss>
<cfparam name="url.Tipo" default="">
<cfset LvarDir = GetDirectoryFromPath(expandPath("/sif/tasks/"))>
<cfif isdefined("url.ver")>
	<cfoutput>
	<cfset LvarTarea=url.ver>
	<cfdirectory action="list" name="rsFile" directory="#LvarDir#" filter="#LvarTarea#_Resultado.html">
	<font color="##0000FF" size="+6">
		VER RESULTADO DE LA ULTIMA EJECUCION DE LA TAREA #LvarTarea# EL #rsFile.DATELASTMODIFIED#
	</font>
	<BR><BR>
	<input type="button" value="Regresar" onclick="location.href='#cgi.SCRIPT_NAME#'" />
	<BR><BR>
	<cfinclude template="/sif/tasks/#LvarTarea#_Resultado.html">
	<BR><BR>
	</cfoutput>
	<cfabort>
</cfif>
<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset servidor_principal = Politicas.trae_parametro_global("servidor.principal")>
<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="localhostname"/>
<cfset es_principal =
	(servidor_principal EQ '0') OR
	(Len(Trim(servidor_principal)) EQ 0) OR
	(UCase(Trim(servidor_principal)) EQ UCase(Trim(localhostname)))>
<!---
<cfset es_principal =true>
--->

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
<cfset LvarHostname = hostname>

<cfoutput>
	HTTP Host: #hostname#
	<br>
	servidor_principal: #servidor_principal#
	<br>
	localhostname: #localhostname#
	<br>
	es_principal: #es_principal#
</cfoutput>

<cfif Len(hostname) is 0>
	<cfoutput> === ERROR === no se ha especificado el hostname </cfoutput>
	<cfabort>
</cfif>

<cfset LvarScheduleFile = "#LvarDir#Schedule.wddx">
<cfset LvarScheduleWDDX = "">
<cftry>
	<cffile action="read" file="#LvarScheduleFile#" variable="LvarScheduleWDDX" >
	<cfwddx action="wddx2cfml" input="#LvarScheduleWDDX#"  output="LvarScheduleAnterior">
<cfcatch type="any">
	<cfset url.Programar = "">
</cfcatch>
</cftry>

<cfset LvarSchedule = structNew()>
<cfset LvarSchedule.Borrar	= structNew()>
<cfset LvarSchedule.Todos	= structNew()>
<cfset LvarSchedule.Main	= structNew()>


<!--- Tareas obsoletas que deben borrarse --->
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "MonitorMemoria">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "MonitorAccesos">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "BorraImagenes">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "SYS_BorraImagenes">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "schedule">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "Afiliacion">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "EnviarSMS">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "CM_CorreoVencimientoContratos.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "recordatorioAlertaAcciones.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "ConsolidacionOrdenesDeCompra.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "RH_CorreosCierreEval180.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "RH_ProcesoAgrupaMarcas.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "monitor_empresastats.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "RH_ProcesoGeneraMarcasFeriados.cfm">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "Correo">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "RecordatorioAgenda">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "UsuarioProcesos">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "Vacaciones">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "BorrarHistoria">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "GeneraDepreciacion">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "GeneraRevaluacion">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "AplicaDepreciacion">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "AplicaRevaluacion">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "TriggerBitacora">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "MonitorDebug">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "MonitorEmpresas">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "Cumpleanos">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "RecordatorioControlTiempos">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "CalcularAnexos">
<cfinvoke method = "sbAddTask" 		tipo = "Borrar"			tarea = "RH_AsignarDiasEnfermedad.cfm">


<!--- Tareas que corren en todos los servidores --->
<cfinvoke method = "sbAddTask" 		tipo = "Todos"			tarea = "SYS_Schedule"
		texto		= "Asegura que esta Programación de Tareas Automáticas se actualice una vez al día en el Servidor"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/schedule.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "02:00:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Todos"			tarea = "SYS_MonitorAccesos"
		texto		= "Busca la información de accesos a los componentes del sistema para almacenar información de auditoría de accesos y tiempos de respuesta de las peticiones de páginas (requests)."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/monitor_accesos.cfm"
		activar		= "1"
		frecuencia	= "m" n="1"
		horaInicial	= "00:00:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Todos"			tarea = "SYS_MonitorMemoria"
		texto		= "Obtener información de utilización de la memoria del servidor y grabarla en la base de datos para bitácoras de comportamiento del computador."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/monitor_memoria.cfm"
		activar		= "1"
		frecuencia	= "m" n="5"
		horaInicial	= "06:01:00 AM"
		horaFinal	= "10:01:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Todos"			tarea = "SYS_BorraTemp"
		texto		= "Elimina los archivos generados en el directorio temporal de Coldfusion, así como tablas de trabajo temporales en la base de datos"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/BorraTemp.cfm"
		activar		= "1"
		frecuencia	= "m" n="7"
		horaInicial	= "06:00:00 AM"
		horaFinal	= "10:00:00 PM"
	>

<!--- Tareas que solo corren en el servidor principal --->
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_Correo"
		texto		= "Envía los correos electrónicos de la cola de correo"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/Correo.cfm"
		activar		= "1"
		frecuencia	= "s" n="90"
		horaInicial	= "00:00:00 AM"
	>
<!---
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_EnviaSMS"
		texto		= "Envía los mensajes de texto de la cola de msgs"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/EnviarSMS.cfm"
		activar		= "0"
		frecuencia	= "s" n="90"
		horaInicial	= "02:00:00 AM"
	>
--->
	<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_UsuarioProcesos"
		texto		= "Verifica y reconstruye información en la tabla de control de permisos por usuario"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/UsuarioProcesos.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "02:05:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_BorrarHistoria"
		texto		= "Elimina información histórica de la base de datos 'aspmonitor' según políticas establecidas en el portal"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/BorrarHistoria.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "02:20:00 AM"
	>

<!--- *** --->
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_TriggerBitacora"
		texto		= "Reconstruye los triggers de aquellas tablas que se les definió auditoría en los parámetros del Portal"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/TriggerBitacora.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "02:35:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_RecordatorioAgenda"
		texto		= "Envia un correo a los usuarios notificándoles actividades programadas en la angenda en las próximas 2 horas."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/RecordatorioAgenda.cfm"
		activar		= "1"
		frecuencia	= "m" n="2"
		horaInicial	= "06:04:00 AM"
		horaFinal	= "10:04:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_MonitorDebug"
		texto		= "Transfiere la información de la tablas 'MonDebugIxxxx' a las tablas 'MonDebugQxxxx' en la base de datos 'aspmonitor'"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/monitor_debug.cfm"
		activar		= "0"
		frecuencia	= "m" n="11"
		horaInicial	= "00:00:00 AM"
	>

<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "SYS_RepositorioCE"
		texto		= "Verifica la carpeta del repositorio en busca de nuevos archivos para ser subidos"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/Repositorio.cfm"
		activar		= "1"
		frecuencia	= "m" n="60"
		horaInicial	= "00:00:00 AM"
	>

<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. --->
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "TransferenciaPoliza_EmpresaAEmpresa"
		texto		= "Transferencia de polizas SES Mexico"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/PolizaEmpresaAEmpresa.cfm"
		activar		= "0"
		frecuencia	= "daily"
		horaInicial	= "00:00:00 AM"
	>
<!--- JMRV Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->

<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_RecordatorioAcciones"
		texto		= "Alerta sobre la posible expiración de acciones de personal (vencimiento de una acción)."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/recordatorioAlertaAcciones.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:00:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_RecordatorioControlTiempos"
		texto		= "Genera correo indicando que no se ha llenado la información de control de tiempos.  Esto aplica para aquellos clientes que utilicen el control de tiempos para sus funcionarios."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/recordatorioControlTiempos.cfm"
		activar		= "1"
		frecuencia	= "weekly"
		horaInicial	= "03:05:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_CorreosCierreEvaluacion_180"
		texto		= "Envío de los correos de evaluaciones 180 generadas, para que los evaluadores procedan a contestar en Autogestión."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/RH_CorreosCierreEval180.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:10:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_AgrupacionMarcas"
		texto		= "Toma datos importados por el sistema de control de tiempos (marcas) y resume la información de marcas de entradas y salidas para un colaborador."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/RH_ProcesoAgrupaMarcas.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:15:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_GeneraMarcasFeriados"
		texto		= "Toma datos importados del sistema de control de tiempos (marcas) y genera las marcas y montos a pagar para los días en que las marcas coinciden con los feriados."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/RH_ProcesoGeneraMarcasFeriados.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:20:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_Vacaciones"
		texto		= "Revisa para los colaboradores si están cumpliendo una anualidad de vacaciones, dependiendo del régimen al que se encuentren asociados."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/Vacaciones.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:25:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_Cumpleanos"
		texto		= "Genera correo de felicitación para todas aquellas personas que cumplen años."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/cumpleannos.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:30:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_AsignarDiasEnfermedad"
		texto		= "Asigna los días adicionales de enfermedad especificados en el régimen de vacaciones"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/RH_AsignarDiasEnfermedad.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:35:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "RH_MonitorEmpresas"
		texto		= "Recopila y almacena los indicadores de análisis del Portal por empresa"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/monitor_empresastats.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "03:40:00 AM"
	>


<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "AF_GeneraDepreciacion"
		texto		= "Genera el cálculo de la depreciación de Activos Fijos cuando el usuario programa el cálculo en el Sistema de Activos Fijos."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/GeneraDepreciacion.cfm"
		activar		= "1"
		frecuencia	= "h" n="1"
		horaInicial	= "06:00:00 AM"
		horaFinal	= "10:00:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "AF_GeneraRevaluacion"
		texto		= "Genera el cálculo de la depreciación de Activos Fijos cuando el usuario programa este proceso en el Sistema de Activos Fijos."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/GeneraRevaluacion.cfm"
		activar		= "1"
		frecuencia	= "h" n="1"
		horaInicial	= "06:05:00 AM"
		horaFinal	= "10:05:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "AF_AplicaDepreciacion"
		texto		= "Aplica el cálculo de la depreciación de Activos Fijos cuando el usuario programa este proceso en el Sistema de Activos Fijos."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/AplicaDepreciacion.cfm"
		activar		= "1"
		frecuencia	= "h" n="1"
		horaInicial	= "06:10:00 AM"
		horaFinal	= "10:10:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "AF_AplicaRevaluacion"
		texto		= "Aplica el cálculo de la revaluación de Activos Fijos cuando el usuario programa este proceso en el Sistema de Activos Fijos."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/AplicaRevaluacion.cfm"
		activar		= "1"
		frecuencia	= "h" n="1"
		horaInicial	= "06:15:00 AM"
		horaFinal	= "10:15:00 PM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "AN_CalcularAnexos"
		texto		= "Ejecuta el proceso de cálculo de valores para aquellos anexos que el usuario lo ha programado en el sistema de Anexos Financieros."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/CalcularAnexos.cfm"
		activar		= "1"
		frecuencia	= "h" n="1"
		horaInicial	= "06:20:00 AM"
		horaFinal	= "10:20:00 PM"
	>


<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "CM_CorreoVencimientoContratos"
		texto		= "Envia un correo a los responsables de administración de contratos recordando el vencimiento de los contratos de compras que deban ser atendidos."
		url			= "http://#LvarHostname#/cfmx/sif/tasks/CM_CorreoVencimientoContratos.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "04:00:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "CM_ConsolidacionOrdenesDeCompra"
		texto		= "Agrupa diferentes órdenes de compra para un mismo proveedor en el sistema de Compras"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/ConsolidacionOrdenesDeCompra.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "04:15:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "AF_EmpleadoCFuncional"
		texto		= "Sincroniza EmpleadoCFuncional desde RH o CF"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/EmpleadoCFuncional.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "05:00:00 AM"
	>
<cfinvoke method = "sbAddTask" 		tipo = "Main"			tarea = "CG_ReglasContablesReciclaje"
		texto		= "Elimina las reglas contables de la tabla HPCReglas, cuya fecha de vencimiento supera los 60 días"
		url			= "http://#LvarHostname#/cfmx/sif/tasks/BorrarReglasContables.cfm"
		activar		= "1"
		frecuencia	= "daily"
		horaInicial	= "05:15:00 AM"
	>

<cfif isdefined("form.ACTUALIZAR")>
	<cfset sbActualizarScheduleTasks("borrar")>
	<cfset sbActualizarScheduleTasks("main")>
	<cfset sbActualizarScheduleTasks("todos")>
	<cfset session.schedule_message = "<br><br><strong>ScheduledTasks de Coldfusion Actualizado</strong>">
	<cfset sbActualizar()>
	<cflocation url			= "#cgi.SCRIPT_NAME#?Programar">
<cfelseif isdefined("url.Programar")>
	<cfparam name="session.schedule_message" default="">
	<cfoutput>#session.schedule_message#</cfoutput>
	<cfset session.schedule_message = "">
	<cfset sbPintarForm()>
<cfelse>
	<cfset sbActualizarScheduleTasks("borrar")>
	<cfset sbActualizarScheduleTasks("main")>
	<cfset sbActualizarScheduleTasks("todos")>
	<BR><BR><strong>ScheduledTasks de Coldfusion Actualizado</strong><BR>
</cfif>

<cffunction name="sbAddTask">
	<cfargument name="tipo"			required="yes">
	<cfargument name="tarea"		required="yes">
	<cfargument name="activar"		default="1">
	<cfargument name="url"			default="">
	<cfargument name="frecuencia"	default="s">
	<cfargument name="n"			default="1">
	<cfargument name="horaInicial"	default="00:00:00 AM">
	<cfargument name="horaFinal"	default="">
	<cfargument name="fechaInicial" default="01/01/2000">
	<cfargument name="guardar" 		default="0">

	<cfif NOT structKeyExists(LvarSchedule[Arguments.tipo],Arguments.tarea)>
		<cfset structInsert(LvarSchedule[Arguments.tipo],Arguments.tarea, structNew())>
	</cfif>
	<cfif NOT structKeyExists(LvarSchedule[Arguments.tipo],"atributos")>
		<cfset LvarSchedule[Arguments.tipo].atributos = "">
	</cfif>

	<cfif lcase(Arguments.tipo) eq "borrar">
		<cfset LvarSchedule[Arguments.tipo][Arguments.tarea] = "obsoleto">
	<cfelseif lcase(Arguments.Tipo) EQ "main" AND NOT es_principal>
		<cfset LvarSchedule[Arguments.tipo][Arguments.tarea] = "no_principal">
	<cfelse>
		<cfset LvarStruct = StructNew()>
		<cfloop collection="#Arguments#" item="LvarAttrs">
			<cfset LvarAttrs = trim(LvarAttrs)>
			<cfif isdefined("Arguments.#LvarAttrs#")>
				<cfif NOT structKeyExists(LvarSchedule[Arguments.tipo],"orden")>
					<cfset LvarSchedule[Arguments.tipo].atributos = LvarSchedule[Arguments.tipo].atributos & LvarAttrs & ",">
				</cfif>
				<cfif Arguments.tarea EQ "SYS_Schedule" AND listFindNoCase("Texto,Activar,Frecuencia,n",LvarAttrs) OR listFindNoCase("tipo,tarea,url,texto",LvarAttrs)>
					<cfset LvarValor = Arguments[LvarAttrs]>
				<cfelseif isdefined("form.ACTUALIZAR")>
					<cfif listFindNoCase("horaInicial,horaFinal",LvarAttrs)>
						<cfif form["#Arguments.tarea#_#LvarAttrs#_HH"] EQ "">
							<cfset form["#Arguments.tarea#_#LvarAttrs#"] = "">
						<cfelse>
							<cfif form["#Arguments.tarea#_#LvarAttrs#_MM"] GT 59>
								<cfset form["#Arguments.tarea#_#LvarAttrs#_MM"] = "00">
							<cfelse>
								<cfset form["#Arguments.tarea#_#LvarAttrs#_MM"] = numberFormat(form["#Arguments.tarea#_#LvarAttrs#_MM"],"99")>
							</cfif>
							<cfset form["#Arguments.tarea#_#LvarAttrs#"] = "#form["#Arguments.tarea#_#LvarAttrs#_HH"]#:#form["#Arguments.tarea#_#LvarAttrs#_MM"]#:00 #form["#Arguments.tarea#_#LvarAttrs#_AM"]#">

							<cfif lcase(LvarAttrs) EQ "horafinal">
								<cfif form["#Arguments.tarea#_horaInicial_AM"] EQ "PM">
									<cfset LvarHoraIni = createTime(form["#Arguments.tarea#_horaInicial_HH"]+12,form["#Arguments.tarea#_horaInicial_MM"],0)>
								<cfelse>
									<cfset LvarHoraIni = createTime(form["#Arguments.tarea#_horaInicial_HH"],form["#Arguments.tarea#_horaInicial_MM"],0)>
								</cfif>
								<cfif form["#Arguments.tarea#_horaFinal_AM"] EQ "PM">
									<cfset LvarHoraFin = createTime(form["#Arguments.tarea#_horaFinal_HH"]+12,form["#Arguments.tarea#_horaFinal_MM"],0)>
								<cfelse>
									<cfset LvarHoraFin = createTime(form["#Arguments.tarea#_horaFinal_HH"],form["#Arguments.tarea#_horaFinal_MM"],0)>
								</cfif>
								<cfif LvarHoraFin LT LvarHoraIni>
									<cfset form["#Arguments.tarea#_horaFinal"] = "">
								</cfif>
							</cfif>
						</cfif>
					<cfelseif listFindNoCase("activar,guardar",LvarAttrs)>
						<cfparam name="form.#Arguments.tarea#_#LvarAttrs#" default="0">
					<cfelseif listFindNoCase("fechainicial",LvarAttrs) and trim(form["#Arguments.tarea#_fechaInicial"]) EQ "">
						<cfset form["#Arguments.tarea#_fechaInicial"] = Arguments.fechaInicial>
					</cfif>
					<cfset LvarValor = form["#Arguments.tarea#_#LvarAttrs#"]>
				<cfelseif isdefined ("LvarScheduleAnterior.#Arguments.tipo#.#Arguments.tarea#.#LvarAttrs#")>
					<cfset LvarValor = LvarScheduleAnterior[Arguments.tipo][Arguments.tarea][LvarAttrs]>
				<cfelse>
					<cfset LvarValor = Arguments[LvarAttrs]>
				</cfif>
				<cfif structKeyExists(LvarSchedule[Arguments.tipo][Arguments.tarea],LvarAttrs)>
					<cfset structUpdate(LvarSchedule[Arguments.tipo][Arguments.tarea],LvarAttrs, LvarValor)>
				<cfelse>
					<cfset structInsert(LvarSchedule[Arguments.tipo][Arguments.tarea],LvarAttrs, LvarValor)>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<cfif NOT structKeyExists(LvarSchedule[Arguments.tipo],"orden")>
		<cfset LvarSchedule[Arguments.tipo].orden = "">
	</cfif>
	<cfset LvarSchedule[Arguments.tipo].orden = LvarSchedule[Arguments.tipo].orden & Arguments.Tarea & ",">
</cffunction>

<cffunction name="sbPintarForm">
	<BR><BR>
	<form name="form1" action="" method="post">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<td nowrap><strong>Ver:</strong></td>
				<td nowrap>
					<cfoutput>
					<select name="tipo" onchange="location.href='#cgi.SCRIPT_NAME#?Programar&Tipo='+this.value;">
						<option value="" <cfif url.Tipo EQ "">selected</cfif>>Todas las Frecuencias</option>
						<option value="C" <cfif url.Tipo EQ "C">selected</cfif>>Frecuencias Cíclicas</option>
						<option value="1" <cfif url.Tipo EQ "1">selected</cfif>>Frecuencias una vez</option>
					</select>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td align="center" nowrap><strong>Activar</strong></td>
				<td align="center" nowrap><strong>Tarea</strong></td>
				<td align="center" nowrap><strong>Frecuencia</strong></td>
				<td align="center" nowrap><strong>Tiempo (n)</strong></td>
				<td align="center" nowrap><strong>A partir del</strong></td>
				<td align="center" nowrap><strong>Hora Inicial</strong></td>
				<td align="center" nowrap><strong>Hora Final</strong></td>
				<td align="center"><strong>Guardar<BR>Resultado</strong></td>
				<td><strong>Ver&nbsp;Ultimo<BR>Resultado</strong></td>
			</tr>
			<cfset sbPintar("todos")>
			<cfset sbPintar("main")>
			<tr><td>&nbsp;</td></tr>
		<cfif url.Tipo EQ "">
			<tr>
				<td align="center" colspan="8">
					<input type="submit" name="ACTUALIZAR" value="Actualizar">
				</td>
			</tr>
		</cfif>
		</table>
	</form>
</cffunction>

<cffunction name="sbPintar" output="true">
	<cfargument name="Tipo" required="yes">

	<cfif lcase(Arguments.Tipo) EQ "main" AND NOT es_principal>
		<cfreturn>
	</cfif>
	<cfloop list="#LvarSchedule[Arguments.Tipo].orden#" index="LvarTarea">
		<cfset LvarTask = LvarSchedule[Arguments.Tipo][LvarTarea]>
		<cfif url.Tipo EQ "C">
			<cfset LvarPintar = NOT listfind("daily,weekly,monthly",LvarTask.frecuencia)>
		<cfelseif url.Tipo EQ "1">
			<cfset LvarPintar = listfind("daily,weekly,monthly",LvarTask.frecuencia)>
		<cfelse>
			<cfset LvarPintar = true>
		</cfif>
		<cfif LvarPintar>
			<tr>
				<td align="center">
					<input type="checkbox" name="#LvarTarea#_activar" value="1"
						<cfif LvarTask.Activar EQ "1">checked</cfif>
						<cfif LvarTarea EQ "SYS_Schedule">disabled</cfif>
					>
				</td>
				<td style="cursor:help; background-color:##EEEEEE; border:solid 1px ##FFFFFF" onclick="alert('#LvarTarea#:\n#jsStringFormat(LvarTask.Texto)#');">
					<input type="hidden" name="tareas" value="#LvarTarea#">
					<strong>#LvarTarea#</strong>
				</td>
				<td>
					<select name="#LvarTarea#_Frecuencia" onchange="document.form1.#LvarTarea#_nt.value = this.value.substring(0,2);if (this.value.length > 2) {document.form1.#LvarTarea#_n.value = '1'; document.form1.#LvarTarea#_n.readOnly = true; document.form1.#LvarTarea#_n.style.border='solid 1px ##CCCCCC'; document.form1.#LvarTarea#_n.tabIndex = -1;} else {document.form1.#LvarTarea#_n.readOnly = false; document.form1.#LvarTarea#_n.style.border='solid 1px ##000000'; document.form1.#LvarTarea#_n.tabIndex = this.tabIndex;}"
						<cfif LvarTarea EQ "SYS_Schedule">disabled</cfif>
					>
					  <option value="s"			<cfif LvarTask.Frecuencia EQ "s">selected</cfif>		>Cada n segundos</option>
					  <option value="m"			<cfif LvarTask.Frecuencia EQ "m">selected</cfif>		>Cada n minutos</option>
					  <option value="h"			<cfif LvarTask.Frecuencia EQ "h">selected</cfif>		>Cada n horas</option>
					  <option value="daily"		<cfif LvarTask.Frecuencia EQ "daily">selected</cfif>	>Una vez diaria a las</option>
					  <option value="weekly"	<cfif LvarTask.Frecuencia EQ "weekly">selected</cfif>	>Una vez semanal a las</option>
					  <option value="monthly"	<cfif LvarTask.Frecuencia EQ "monthly">selected</cfif>	>Una vez mensual a las</option>
					</select>
				</td>
				<td nowrap="nowrap">
					<cfset LvarReadOnly = not find(LvarTask.Frecuencia,"s,m,h")>
					<cf_inputNumber name="#LvarTarea#_n" value="#LvarTask.n#" enteros="3" readonly = "#LvarReadOnly#">
					<input type="text" size="1" maxlength="2" style="border:none" name="#LvarTarea#_nt" value="#mid(LvarTask.Frecuencia,1,2)#" disabled>
					&nbsp;
				</td>
				<td>
					<cf_sifcalendario2 name="#LvarTarea#_fechaInicial" value="#LvarTask.fechaInicial#">
				</td>
				<td nowrap="nowrap">
					&nbsp;
					&nbsp;
					<cfset LvarHH = mid(LvarTask.horaInicial,1,2)>
					<cfset LvarMM = mid(LvarTask.horaInicial,4,2)>
					<cfset LvarAM = findNoCase("AM",LvarTask.horaInicial)>
					<select name="#LvarTarea#_horaInicial_HH">
						<cfloop index="LvarH" from="0" to="11">
							<cfset LvarH2 = numberFormat(LvarH,"00")>
							<option value="#LvarH2#" <cfif LvarHH EQ LvarH2>selected</cfif>>#LvarH2#</option>
						</cfloop>
					</select>:<select name="#LvarTarea#_horaInicial_MM">
						<cfloop index="LvarH" from="0" to="55" step="5">
							<cfset LvarH2 = numberFormat(LvarH,"00")>
							<cfif LvarMM GTE LvarH2 AND LvarMM LT LvarH2+5>
								<cfset LvarMM = LvarH2>
							</cfif>
							<option value="#LvarH2#" <cfif LvarMM EQ LvarH2>selected</cfif>>#LvarH2#</option>
						</cfloop>
					</select><select name="#LvarTarea#_horaInicial_AM">
						<option value="AM" <cfif LvarAM>selected</cfif>>AM</option>
						<option value="PM" <cfif NOT LvarAM>selected</cfif>>PM</option>
					</select>
					&nbsp;
				</td>
				<td nowrap="nowrap">
					&nbsp;
					<cfset LvarHH = mid(LvarTask.horaFinal,1,2)>
					<cfset LvarMM = mid(LvarTask.horaFinal,4,2)>
					<cfset LvarAM = findNoCase("AM",LvarTask.horaFinal)>
					<select name="#LvarTarea#_horaFinal_HH" onchange="if (this.value==''){if (document.form1.#LvarTarea#_horaFinal_MM.selectedIndex!=0)document.form1.#LvarTarea#_horaFinal_MM.selectedIndex=0;if (document.form1.#LvarTarea#_horaFinal_AM.selectedIndex!=0)document.form1.#LvarTarea#_horaFinal_AM.selectedIndex=0;} else {if (document.form1.#LvarTarea#_horaFinal_MM.selectedIndex==0)document.form1.#LvarTarea#_horaFinal_MM.selectedIndex=1;if (document.form1.#LvarTarea#_horaFinal_AM.selectedIndex==0)document.form1.#LvarTarea#_horaFinal_AM.selectedIndex=1;}">
						<option value=""></option>
						<cfloop index="LvarH" from="0" to="11">
							<cfset LvarH2 = numberFormat(LvarH,"00")>
							<option value="#LvarH2#" <cfif LvarHH EQ LvarH2>selected</cfif>>#LvarH2#</option>
						</cfloop>
					</select>:<select name="#LvarTarea#_horaFinal_MM" onchange="if (document.form1.#LvarTarea#_horaFinal_HH.selectedIndex==0) this.selectedIndex = 0;" style="border:none;">
						<option value=""></option>
						<cfloop index="LvarH" from="0" to="55" step="5">
							<cfset LvarH2 = numberFormat(LvarH,"00")>
							<cfif LvarMM GTE LvarH2 AND LvarMM LT LvarH2+5>
								<cfset LvarMM = LvarH2>
							</cfif>
							<option value="#LvarH2#" <cfif LvarMM EQ LvarH2>selected</cfif>>#LvarH2#</option>
						</cfloop>
					</select><select name="#LvarTarea#_horaFinal_AM" onchange="if (document.form1.#LvarTarea#_horaFinal_HH.selectedIndex==0) this.selectedIndex = 0;">
						<option value="" <cfif LvarTask.horaFinal EQ "">selected</cfif>></option>
						<option value="AM" <cfif LvarTask.horaFinal NEQ "" AND LvarAM>selected</cfif>>AM</option>
						<option value="PM" <cfif LvarTask.horaFinal NEQ "" AND NOT LvarAM>selected</cfif>>PM</option>
					</select>
					&nbsp;
				</td>
				<td align="center">
					<input name="#LvarTarea#_guardar" value="1" type="checkbox" <cfif LvarTask.guardar EQ "1">checked</cfif>>
				</td>
				<td align="left">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<cfif fileExists("#LvarDir##LvarTarea#_Resultado.html")>
						<cfdirectory action="list" name="rsFile" directory="#LvarDir#" filter="#LvarTarea#_Resultado.html">
						<a href="?ver=#LvarTarea#"><img src="/cfmx/sif/imagenes/iindex.gif" title="el #rsFile.DATELASTMODIFIED#" style="cursor:pointer; border:none;"></a>
					</cfif>
				</td>
			</tr>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="sbActualizarScheduleTasks">
	<cfargument name="Tipo" required="yes">
	<cfset LvarUpdate = lcase(Arguments.Tipo) EQ "todos" OR lcase(Arguments.Tipo) EQ "main" AND es_principal>
	<cfloop list="#LvarSchedule[Arguments.Tipo].orden#" index="LvarTarea">
		<cfset LvarTask = LvarSchedule[Arguments.Tipo][LvarTarea]>
		<cfif LvarUpdate AND LvarTask.Activar EQ "1">
			<cfif LvarTask.Frecuencia EQ "s">
				<cfset LvarInterval = LvarTask.n>
			<cfelseif LvarTask.Frecuencia EQ "m">
				<cfset LvarInterval = LvarTask.n*60>
			<cfelseif LvarTask.Frecuencia EQ "h">
				<cfset LvarInterval = LvarTask.n*3600>
			<cfelse>
				<cfset LvarInterval = LvarTask.Frecuencia>
				<cfset LvarTask.HoraFinal = "">
			</cfif>
			<cfschedule
				task		= "#LvarTarea#"
				action		= "update"
				operation	= "HTTPrequest"

				url			= "#LvarTask.URL#"
				interval	= "#LvarInterval#"
				startdate	= "#LSParseDateTime(LvarTask.FechaInicial)#"
				starttime	= "#LvarTask.HoraInicial#"
				endtime		= "#LvarTask.HoraFinal#"
				publish		= "#LvarTask.Guardar EQ "1"#"
				path		= "#LvarDir#"
				file		= "#LvarTarea#_Resultado.html"
			>
		<cfelse>
			<cftry>
				<cfschedule
					action="delete"
					task="#LvarTarea#"
				>
				<cfcatch>
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="sbActualizar">
	<cfset var LvarScheduleWDDX = structNew()>
	<cfwddx action="cfml2wddx" input="#LvarSchedule#"  output="LvarScheduleWDDX">
	<cffile action="write" file="#LvarScheduleFile#" output="#LvarScheduleWDDX#">
</cffunction>
