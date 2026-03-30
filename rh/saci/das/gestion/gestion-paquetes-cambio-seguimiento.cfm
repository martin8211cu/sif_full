<!---selecciona los logines por conservar que no fueron tomados en cuenta en session.saci.cambioPQ.logConservar por que son aceptadas por el paquete nuevo y no generan conflictos--->
<!---Los pone en una lista llamada: "servConservar" los logines que pertenecen respectivamente los pone en la lista "logConservar"--->
<cfinclude template="/saci/das/gestion/gestion-paquetes-servicios-sinTomar.cfm">

<!---Completa los servicios a conservar que vamos a usar en el archivo XML que seguidamente se va a generar--->
<cfif listLen(servConservar)>
	<cfset session.saci.cambioPQ.logConservar.login = session.saci.cambioPQ.logConservar.login &','& logConservar>
	<cfset session.saci.cambioPQ.logConservar.servicios = session.saci.cambioPQ.logConservar.servicios &','& servConservar>
</cfif>

<!---coloca los servicio por logines en arreglos para recorrerlos y mostrarlos en pantalla--->
<cfset arrLogB = ListToArray(session.saci.cambioPQ.logBorrar.login,",")>
<cfset arrSerB = ListToArray(session.saci.cambioPQ.logBorrar.servicios,",")>

<cfset arrLogC = ListToArray(session.saci.cambioPQ.logConservar.login,",")>
<cfset arrSerC = ListToArray(session.saci.cambioPQ.logConservar.servicios,",")>

<cfset arrPqPA = ListToArray(session.saci.cambioPQ.pqAdicional.cod,",")>
<cfset arrLogPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.login,",")>
<cfset arrSerPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.servicios,",")>

<!---Trae los logines del paquete actual para ser mostrados en pantalla--->
<cfquery name="rsServLog" datasource="#session.DSN#">
	select distinct  b.LGnumero,b.LGlogin,c.TScodigo   
	from ISBproducto a
		inner join ISBlogin b
			on b.Contratoid=a.Contratoid
			and b.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
			and b.Habilitado=1
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.Habilitado=1
			and c.PQcodigo=a.PQcodigo
			and c.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
	where
		a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
		and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
	order by b.LGnumero
</cfquery>

<cfoutput>
<!---Pintado del estado actual de la tarea--->
<table  width="100%"border="0" cellpadding="2" cellspacing="0">
		<!---Paquete Actual --->
		<tr class="tituloAlterno"><td colspan="2">Configuraci&oacute;n del Paquete Actual</td></tr>
		<tr><td>
				<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
				&nbsp;#session.saci.cambioPQ.PQanterior#-#rsPQanterior.PQnombre#
			</td>
		</tr>
		<cfif rsServLog.RecordCount GT 0>
			<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
			<cfloop  query="rsServLog">
				<tr><td>#rsServLog.LGlogin#</td><td>#rsServLog.TScodigo#</td></tr>
			</cfloop>
		</cfif>
		<!---Paquete Nuevo --->
		<tr class="tituloAlterno"><td colspan="2">Configuraci&oacute;n del(os) Nuevo(s) Paquete(s)</td></tr>
		<tr><td>
				<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
				&nbsp;#session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#
			</td>
		</tr>
		<!---Servicios por conservar --->
		<cfif ArrayLen(arrLogC)>
			<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
			<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogC)#">
				<cfif ListContains(ListVerificar, arrSerC[cont], ',') EQ 0 >
				<tr><td>#arrLogC[cont]#</td><td>#arrSerC[cont]#</td></tr>
				</cfif>
			</cfloop>
		</cfif>
		<!---Paquetes Adicionales--->
		<cfif ArrayLen(arrPqPA)>					
			<cfloop index="cont" from = "1" to = "#ArrayLen(arrPqPA)#">	
				<cfquery name="rsPQadicional" datasource="#session.DSN#">
					select PQnombre
					from ISBpaquete 
					where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arrPqPA[cont]#">
					and Habilitado=1
				</cfquery>
				<tr><td>
							<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
							&nbsp;#arrPqPA[cont]#-#rsPQadicional.PQnombre#
					</td>
				</tr>
				<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
				<cfloop index="cont2" from = "1" to = "#ArrayLen(arrLogPA)#">
					<tr><td>#arrLogPA[cont2]#</td><td>#arrSerPA[cont2]#</td></tr>
				</cfloop>
			</cfloop>
		</cfif>
</table>
</cfoutput>