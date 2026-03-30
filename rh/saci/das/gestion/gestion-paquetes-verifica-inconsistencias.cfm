
<cfif isdefined("form.ListVerificar") and len(trim(form.ListVerificar))>
	<cfset ListVerificar=form.ListVerificar>
</cfif>	
<!---Genera o modifica las varibles en session para el cambio de paquete --->
<cfinclude template="/saci/das/gestion/gestion-paquetes-memoria.cfm">


<!---<!---Los pone en una lista llamada: "servConservar" y los logines que pertenecen respectivamente los pone en la lista "logConservar"--->
<cfif isdefined("session.saci.cambioPQ")> <cfinclude template="/saci/das/gestion/gestion-paquetes-servicios-sinTomar.cfm"> </cfif>
--->
<cfif isdefined("logConservar") and not listlen(logConservar) and isdefined("session.saci.cambioPQ") and not listLen(session.saci.cambioPQ.logConservar.login)>
	<cfset ListVerificar=form.ListVerificar>
	<cfset url.PQnuevo=session.saci.cambioPQ.PQnuevo>
	Debe haber al menos un login en el paquete seleccionado.
<cfelse>				

	<cfif isdefined("session.saci.cambioPQ.logConservar.login") and len(trim(session.saci.cambioPQ.logConservar.login))>
		
		<cfset ListVerificar="">
		<cfset ListsinVerificar="">
		<!---query que da como resultado los servicios actuales del paquete actual y los servicios actuales del paquete nuevo y la cantidad de servicios que permite cada uno por tipo --->
		<cfquery name="rsServicios" datasource="#session.DSN#">
			select x.TScodigo,
				coalesce((select count(1)
				from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid=a.Contratoid
					and b.Habilitado=1
					<cfif isdefined("session.saci.cambioPQ.logConservar.login") and len(trim(session.saci.cambioPQ.logConservar.login))>
					and b.LGlogin in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#session.saci.cambioPQ.logConservar.login#">)
					</cfif>
				inner join ISBserviciosLogin c
					on c.LGnumero=b.LGnumero
					and c.PQcodigo=a.PQcodigo
					and c.TScodigo =x.TScodigo
					and c.Habilitado=1
				inner join ISBservicio e
					on e.PQcodigo=c.PQcodigo
					and e.TScodigo=c.TScodigo
					and e.Habilitado =1
					<cfif isdefined("session.saci.cambioPQ.logConservar.servicios") and len(trim(session.saci.cambioPQ.logConservar.servicios))>
					and e.TScodigo in (<cfqueryparam list="yes" cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.logConservar.servicios#">)	
					</cfif>
				where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				<cfif isdefined("session.saci.cambioPQ.contrato") and len(trim(session.saci.cambioPQ.contrato))>
					and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.cambioPQ.contrato#">
				<cfelse>
					and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
				</cfif>
				and a.CTcondicion = '1'),0)
				as ServActivos, 
				coalesce((select sum(b.SVcantidad) 
				from ISBpaquete a
				inner join ISBservicio b
					on b.PQcodigo = a.PQcodigo
					and b.TScodigo=x.TScodigo
					and b.Habilitado =1	
				where a.Habilitado=1
					<cfif isdefined("session.saci.cambioPQ.PQnuevo") and len(trim(session.saci.cambioPQ.PQnuevo))>
					and a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
					<cfelse>
					and a.PQcodigo = (select distinct v.PQcodigo from ISBproducto v where v.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">)
					</cfif>),0) 
				as ServPermitidos
			from ISBservicioTipo x
			where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<!---crea la lista de los servicios que causan conflicto con el nuevo paq y a la pasa a ListVerificar--->
		<cfloop query="rsServicios">
			<cfif rsServicios.ServActivos GT rsServicios.ServPermitidos>								
				<cfif rsServicios.TScodigo neq 'CABM'> 
					<cfif ListVerificar EQ "">
						<cfset ListVerificar= rsServicios.TScodigo>
					<cfelse>	
						<cfset ListVerificar= ListVerificar&","&rsServicios.TScodigo>
					</cfif>
				<cfelse>					
					<cfif ListsinVerificar EQ "">
						<cfset ListsinVerificar= rsServicios.TScodigo>
					<cfelse>	
						<cfset ListsinVerificar= ListsinVerificar&","&rsServicios.TScodigo>
					</cfif>
				
				</cfif>
			</cfif>
		</cfloop>

		
		<cfif Listlen(ListVerificar)GT 0>
			<!---<cfset url.PQnuevo=form.PQcodigo2>	--->
			<cfset url.PQnuevo=session.saci.cambioPQ.PQnuevo>	
		<cfelse>
			<cfset session.saci.cambioPQ.estado=1>
			<cfset url.PQnuevo=form.PQcodigo2>
		</cfif>
	
	<cfelse>
		<cfset session.saci.cambioPQ.estado=1>
		<cfset url.PQnuevo=form.PQcodigo2>
	</cfif>

</cfif>
