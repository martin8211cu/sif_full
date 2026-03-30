<!--- Este archivo crea dos lista de los servicios y logines corespondientes que no fueron tomados en cuenta en session.saci.cambioPQ.logConservar por que son aceptadas por el paquete nuevo y no generan conflictos 
	 Este codigo es usado en 3 archivos gestion-paquetes-cambio-tarea.cfm, gestion-paquetes-app.cfm y gestion-paquetes-cambio-seguimiento.cfm--->
<!--- selecciona los logines por conservar que no fueron tomados en cuenta en session.saci.cambioPQ.logConservar por que son aceptadas por el paquete nuevo y no generan conflictos--->
<cfquery name="rsConservar" datasource="#session.DSN#">
	select b.LGnumero, b.LGlogin, e.TScodigo, '1' as conservar
	from ISBproducto a
		inner join ISBlogin b
			on b.Contratoid=a.Contratoid
			and b.Habilitado=1
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.PQcodigo=a.PQcodigo
			and c.TScodigo in(select x.TScodigo from ISBservicioTipo x where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			and c.Habilitado=1
		inner join ISBservicio e
			on e.PQcodigo=c.PQcodigo
			and e.TScodigo=c.TScodigo
			and e.Habilitado =1		
	where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
	and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
	and a.CTcondicion = '1' 
	order by b.LGnumero
</cfquery>

<cfset servConservar = "">																	<!---Variables donde van a quedar los servicios por conservar que no fueron tomados en cuenta--->
<cfset logConservar = "">		

<cfif rsConservar.RecordCount GT 0>
	<cfset LogB = ListToArray(session.saci.cambioPQ.logBorrar.login,",")>						<!---coloca los servicio por logines en arreglos para compararlos con los servicios actuales--->
	<cfset SerB = ListToArray(session.saci.cambioPQ.logBorrar.servicios,",")>
	
	<cfset LogC = ListToArray(session.saci.cambioPQ.logConservar.login,",")>
	<cfset SerC = ListToArray(session.saci.cambioPQ.logConservar.servicios,",")>
	
	<cfset LogPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.login,",")>
	<cfset SerPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.servicios,",")>
	
	<cfloop query="rsConservar">
		
		<cfset log_act= rsConservar.LGlogin>
		<cfset serv_act= rsConservar.TScodigo>
		<cfset noincluir= '0'>
		
		<cfloop index="cont" from = "1" to = "#ArrayLen(LogB)#">
			<cfif log_act EQ LogB[cont] and serv_act EQ SerB[cont]> <cfset noincluir= '1'> </cfif>
		</cfloop>
		
		<cfloop index="cont" from = "1" to = "#ArrayLen(LogC)#">
			<cfif log_act EQ LogC[cont] and serv_act EQ SerC[cont]> <cfset noincluir= '1'> </cfif>
		</cfloop>

		<cfloop index="cont" from = "1" to = "#ArrayLen(LogPA)#">
			<cfif log_act EQ LogPA[cont] and serv_act EQ SerPA[cont]> <cfset noincluir= '1'> </cfif>
		</cfloop>
		
		<cfif noincluir EQ '0'>
			<cfset servConservar = servConservar & IIF(len(trim(servConservar)), DE(","), DE("") ) & serv_act>	
			<cfset logConservar = logConservar & IIF(len(trim(logConservar)), DE(","), DE("") ) & log_act>
		</cfif>
	</cfloop>
	
</cfif>