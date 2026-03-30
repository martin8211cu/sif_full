<cfapplication name="SIF_ASP" 
	sessionmanagement="yes"
	clientmanagement="no"
	setclientcookies="no">

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo"
	datasource="aspmonitor">
</cfinvoke>

<!---
	falta que expire las sesiones por timeout, según las políticas del portal,
	insertando en KillSession las sessiones que haya que matar.
 --->

<cfif isdefined('url.show')>
	<a href="monitor_accesos.cfm">Vaciar cola</a> | <a href="monitor_accesos.cfm?show=1"><strong>Mostrar cola</strong></a><br />
<cfelse>
	<a href="monitor_accesos.cfm"><strong>Vaciar cola</strong></a> | <a href="monitor_accesos.cfm?show=1">Mostrar cola</a><br />
</cfif>

<cfif IsDefined('url.show')>
	<cfif IsDefined('Server.monitor_accesos')>
		<cfoutput>
			Tama&ntilde;o de la cola: #Server.monitor_accesos.size()#<br>
			#Server.monitor_accesos.toString()#
		</cfoutput>
	<cfelse>
		No hay cola.
	</cfif>
	<hr>aborted: url.show definido<cfabort>
</cfif>

<cfif Not IsDefined('Application.srvprocid') Or Not REFind('^[0-9]+$', Application.srvprocid)>
	<hr>aborted: Application.srvprocid =
		<cfif IsDefined('Application.srvprocid')>
			<cfoutput>#Application.srvprocid#</cfoutput>
		<cfelse>
			NOT DEFINED
		</cfif>
	<cfabort>
</cfif>

<cflock timeout="1" throwontimeout="no" name="sif_tasks_monitor_accesos_cfm" type="exclusive">
<!---
	este cflock es para evitar bloqueos en la base de datos causados por que esta tarea corra dos veces a la vez.
	se le pone throwontimeout="yes" para que no salga en las tablas MonDebugException ni en MonErrores
--->
<cfset monitor_accesos_task_StartTime = Now()>
<cfset monitor_accesos_task_size      = 0>

<cfinvoke component="home.Componentes.aspmonitor" method="VaciarCola" ></cfinvoke>

<cfquery datasource="aspmonitor">
	update MonServerProcess
	set last_access = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	where srvprocid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Application.srvprocid#">
</cfquery>

<cfset monitor_accesos_task_FinishTime = Now()>
<cfif monitor_accesos_task_size>
	<cfset millis = monitor_accesos_task_FinishTime.getTime() - monitor_accesos_task_StartTime.getTime()>
	<cfoutput>
		<br>
		#monitor_accesos_task_size# Registros afectados.
		Duracion: #NumberFormat(millis)# ms.
		Promedio: #NumberFormat(monitor_accesos_task_size / millis * 1000,',0.0')# registros por segundo
		<cflog file="monitor_accesos" text="#monitor_accesos_task_size# registros, #NumberFormat(millis)# ms, #NumberFormat(monitor_accesos_task_size / millis * 1000,',0.0')# reg/s">
	</cfoutput>
</cfif>

</cflock>
<!--- aquí no puede haber nada más, vea que el cflock ya no está tirando excepciones --->
