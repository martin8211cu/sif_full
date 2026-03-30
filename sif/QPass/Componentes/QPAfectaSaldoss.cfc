<cfcomponent output="yes">
	<!--- Proceso de Cálculo de Movimientos y Afectacion de Saldos de Cuentas para modulo Quick Pass --->
	
	<!---
		Documentación:
			El proceso ejecuta por un tiempo máximo de 15 minutos.
			Se dispara mediante una tarea programada automática que debe de ejecutarse cada minuto durante el horario de operación
			definido para la entidad bancaria o entidad administradora de los dispositivos.
			
			Si transcurridos 15 minutos el proceso no ha terminado, automáticamente se "sale" del proceso
			para permitir que otro proceso automático inicie su funcionamiento.
			
			Se controla si el proceso se está ejecutando mediante una bandera a nivel del scope "application"
			
			Si la bandera indica que está operando, y tiene menos de 15 minutos de haber arrancado, se sale de la función. 
			En caso de que esté "operando" hace más de 15 minutos, se permite la ejecución del proceso nuevamente
	--->
	
	<cffunction name="ProcesaMovimientos" access="public" returntype="any" output="no">
		<cfargument name="Conexion" type="string" required="yes">

		<cfsetting requesttimeout="900">
        <cfapplication name="SIF_ASP" 
            sessionmanagement="Yes"
            clientmanagement="No"
            setclientcookies="Yes"
            sessiontimeout=#CreateTimeSpan(0,10,0,0)#>


		<cfquery name="rs" datasource="#Arguments.Conexion#">
        	select * from DContables a inner join DContables b on b.Ecodigo = a.Ecodigo
        </cfquery>
        <cfloop query="rs">
	        
	            <cfoutput>#rs.Edocumento#</cfoutput>
            
        </cfloop>
        
		<cfobject name="thread" class="java.lang.Thread" action="create" type="java">
		<cfset thread.sleep(1200000)> <!--- 1000 = 1 segundo --->

		<cfreturn #rs.recordcount#>
	</cffunction>
</cfcomponent>