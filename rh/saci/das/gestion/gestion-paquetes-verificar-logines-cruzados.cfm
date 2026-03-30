<!---Pone en una lista llamada: "loginMasBorrar" los logines que presentan inconsistencias por que estan divididos entre diferentes listas--->
<!---NOTA: este archivo devuelve un la variable "loginMasBorrar" la lista de los logines que estan defectuosos por estar un mismo login en listas diferentes(por ej: login1 esta en el la lista de logines por conservar y tambien esta en la lista de logines por borrar)este archivo podria ser un componente--->
<!---Realiza una comparacion entre las variable de session que contienen las listas de logines y servicios por conservar, borrar, y paquetes adicionales, genera la lista, y elimina de la session los logines y servicios que se encuentran en esa lista--->

<cfif (isdefined("session.saci.cambioPQ.logConservar.login") and len(trim(session.saci.cambioPQ.logConservar.login)))or( isdefined("logConservar") and ListLen(logConservar))>
	
	<cfset mensaje = -1>
	
	<cfset listCons2 = "">
	<cfif isdefined("logConservar")><cfset listCons2 = logConservar></cfif>
	<cfset listCons  = session.saci.cambioPQ.logConservar.login>
	<cfset listBorrar  = session.saci.cambioPQ.logBorrar.login>
	<cfset listPQnuevo = session.saci.cambioPQ.pqAdicional.logMover.login>
	
	<!---determina si existen mas logines que se deben borra por conflitos (esto se da si por ejemplo existe un login que posee servicios por conservar, posee seervicios por borrar o agragregados a paquetes adicionales)--->
	<cfset loginMasBorrar="">
	<cfloop list="#listCons#" delimiters="," index="logi">
		<cfif ListFindNoCase(listPQnuevo, logi, ',') neq 0>
			<cfset loginMasBorrar= loginMasBorrar & IIF(len(trim(loginMasBorrar)), DE(","), DE("")) & logi>
		</cfif>	
	</cfloop>
	<cfloop list="#listCons2#" delimiters="," index="logi">
		<cfif ListFindNoCase(listPQnuevo, trim(logi), ',') neq 0>
			<cfset loginMasBorrar= loginMasBorrar & IIF(len(trim(loginMasBorrar)), DE(","), DE("")) & logi>
		</cfif>	
	</cfloop>
	<!---<cfloop list="#listBorrar#" delimiters="," index="logi">
		<cfif ListFindNoCase(listPQnuevo, logi, ',') neq 0>
			<cfset loginMasBorrar= loginMasBorrar & IIF(len(trim(loginMasBorrar)), DE(","), DE("")) & logi>
		</cfif>	
	</cfloop>--->
	<!---<cfdump var="#session.saci.cambioPQ#">--->
	<!---si existen conflictos, ponemos el login con todos sus servicios en los logines por borrar--->
	<cfif len(trim(loginMasBorrar))>
		
		<cfset arrCodPA	= ListToArray(session.saci.cambioPQ.pqAdicional.cod)>
		<cfset arrLogPA	= ListToArray(session.saci.cambioPQ.pqAdicional.logMover.login)>
		<cfset arrServPA= ListToArray(session.saci.cambioPQ.pqAdicional.logMover.servicios)>
		
		<cfset logMas = "">	<cfset servMas = ""><cfset logBor = ""> <cfset servBor = ""> <cfset codPA = ""> <cfset logPA = ""> <cfset servPA = "">
		<cfset servMasBorrar = "">						
		
		<cfloop list="#loginMasBorrar#" delimiters="," index="logi">	
			<cfloop index="i" from = "1" to ="#ArrayLen(arrLogPA)#">
				<cfif trim(arrLogPA[i]) EQ trim(logi)>
					<cfset logMas = logMas & IIF(len(trim(logMas)),DE(','),DE('')) & arrLogPA[i] >
					<cfset servMas = servMas & IIF(len(trim(servMas)),DE(','),DE('')) & arrServPA[i] >
					<cfset servMasBorrar = servMasBorrar & IIF(len(trim(servMasBorrar)),DE(','),DE('')) & arrServPA[i] >						
				<cfelse>	
					<cfset codPA = codPA & IIF(len(trim(codPA)),DE(','),DE('')) & arrCodPA[i] >
					<cfset logPA = logPA & IIF(len(trim(logPA)),DE(','),DE('')) & arrLogPA[i] >
					<cfset servPA = servPA & IIF(len(trim(servPA)),DE(','),DE('')) & arrServPA[i] >
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfset session.saci.cambioPQ.logBorrar.login = session.saci.cambioPQ.logBorrar.login & IIF(len(trim(session.saci.cambioPQ.logBorrar.login)),DE(','),DE('')) & logMas>
		<cfset session.saci.cambioPQ.logBorrar.servicios = session.saci.cambioPQ.logBorrar.servicios & IIF(len(trim(session.saci.cambioPQ.logBorrar.servicios)),DE(','),DE('')) & servMas>
		
		<cfset session.saci.cambioPQ.pqAdicional.cod = codPA>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.login = logPA>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = servPA>
		
		<cfset mensaje = 1>
	</cfif>
	
</cfif>

