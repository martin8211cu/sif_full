<!---Consulta de todos los servicios existentes actualmente para cada login asociado al paquete--->
<cfquery name="rsServicios" datasource="#session.DSN#">
	select b.LGnumero, b.LGlogin, e.TScodigo, '1' as conservar
	from ISBproducto a
		inner join ISBlogin b
			on b.Contratoid=a.Contratoid
			and b.Habilitado=1
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.PQcodigo=a.PQcodigo
			and c.TScodigo in(select x.TScodigo from ISBservicioTipo x where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			<cfif isdefined("session.saci.cambioPQ") and isdefined("ListVerificar") and len(trim(ListVerificar))>
			and c.TScodigo in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#ListVerificar#">)
			</cfif>
			and c.Habilitado=1
		inner join ISBservicio e
			on e.PQcodigo=c.PQcodigo
			and e.TScodigo=c.TScodigo
			and e.Habilitado =1		
	where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
	and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#"> 
	and a.CTcondicion = '1'
</cfquery>
<cfif rsServicios.recordCount GT 0>
	
	<!---Validar que si el contrato es diferente al que esta en session tons eliminar la session--->
	<cfif isdefined("session.saci.cambioPQ") and form.Contratoid NEQ session.saci.cambioPQ.contrato>
		<cfset StructDelete(Session.saci, "cambioPQ")>
	</cfif>
	
	<cfif not isdefined("session.saci.cambioPQ")>
		<!---Crea la extructura en memoria que contentiene los valores necesarios en el proceso de verificacion del proceso de cambio de paquete---------------------------------------------------------------->
		<cfset session.saci.cambioPQ = StructNew()>
		<cfset session.saci.cambioPQ.contrato = form.Contratoid>
		<cfset session.saci.cambioPQ.PQanterior = form.PQcodigo1>
		<cfset session.saci.cambioPQ.PQnuevo = form.PQcodigo2>
		<cfset session.saci.cambioPQ.estado = 0>
		
		<cfif not isdefined("session.saci.cambioPQ.logBorrar")><cfset session.saci.cambioPQ.logBorrar = StructNew()></cfif>
			<cfset session.saci.cambioPQ.logBorrar.login = ''>
			<cfset session.saci.cambioPQ.logBorrar.servicios = ''>
		<cfif not isdefined("session.saci.cambioPQ.logConservar")><cfset session.saci.cambioPQ.logConservar = StructNew()></cfif>
			<cfset logines = ValueList(rsServicios.LGlogin,",")>
			<cfset servicios = ValueList(rsServicios.TScodigo,",")>
			<cfset session.saci.cambioPQ.logConservar.login = logines>
			<cfset session.saci.cambioPQ.logConservar.servicios = servicios>
		<cfif not isdefined("session.saci.cambioPQ.pqAdicional")><cfset session.saci.cambioPQ.pqAdicional = StructNew()></cfif>
			<cfset session.saci.cambioPQ.pqAdicional.cod = ''>
			<cfif not isdefined("session.saci.cambioPQ.pqAdicional.logMover")><cfset session.saci.cambioPQ.pqAdicional.logMover = StructNew()></cfif>
				<cfset session.saci.cambioPQ.pqAdicional.logMover.login = ''>
				<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = ''>
	<cfelse>
		<!---Actualizacion de los valores en la extructura en memoria que contentiene los valores necesarios en el proceso de verificacion del proceso de cambio de paquete---------------------------------------------------------------->
		<cfset logBorrar = "">
		<cfset servBorrar = "">
		<cfset PQAdic = "">
		<cfset logPQAdic = "">
		<cfset servPQAdic = "">
		<cfloop query="rsServicios">
			<cfif isdefined("Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#")>	
				
				<cfif Evaluate('Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#') EQ 2>		<!---servio por borrar--->
					<cfif logBorrar EQ "" and servBorrar EQ "">
						<cfset logBorrar = rsServicios.LGlogin>
						<cfset servBorrar = rsServicios.TScodigo>
					<cfelse>
						<cfset logBorrar = logBorrar &","& rsServicios.LGlogin>
						<cfset servBorrar = servBorrar &","& rsServicios.TScodigo>
					</cfif>
					<cfset rsServicios.conservar='0'>
				
				<cfelseif Evaluate('Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#') EQ 3>	<!---Paquete Adicional--->
					<cfif isdefined('Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#') and len(trim(Evaluate('Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#')))>
						<cfif (PQAdic EQ "") and (logPQAdic EQ "") and (servPQAdic EQ "")>						
							<cfset PQAdic = Evaluate('Form.PQcodigo_#rsServicios.LGnumero#_#rsServicios.TScodigo#')>
							<cfset logPQAdic = rsServicios.LGlogin>
							<cfset servPQAdic = rsServicios.TScodigo>
						<cfelse>
							<cfset PQAdic = PQAdic &","& Evaluate('Form.PQcodigo_#rsServicios.LGnumero#_#rsServicios.TScodigo#')>
							<cfset logPQAdic = logPQAdic &","& rsServicios.LGlogin>
							<cfset servPQAdic = servPQAdic &","& rsServicios.TScodigo>
							
						</cfif>
					</cfif>
					<cfset rsServicios.conservar='0'>
				</cfif>
				
			</cfif>
			
		</cfloop>
		
		<!---Actualizacion de la estructura en session--->
		<!---Servicios por borrar--->
		<cfset session.saci.cambioPQ.logBorrar.login = logBorrar>
		<cfset session.saci.cambioPQ.logBorrar.servicios = servBorrar>
		<!---Servicios por conservar--->
		<cfquery name="rsServConservar" dbtype="query">
			select * from rsServicios where conservar='1'
		</cfquery>
		<cfset logConservar = ValueList(rsServConservar.LGlogin,",")>
		<cfset servConservar = ValueList(rsServConservar.TScodigo,",")>
		<cfset session.saci.cambioPQ.logConservar.login = logConservar>
		<cfset session.saci.cambioPQ.logConservar.servicios = servConservar>
		<!---Paquetes adicionales--->
		<cfset session.saci.cambioPQ.pqAdicional.cod =PQAdic>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.login = logPQAdic>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = servPQAdic>
	</cfif>

<cfelse>
	<!---Caso en que el paquete actual a evaluar no posee logines --->	
	
	<!---Validar que si el contrato es diferente al que esta en session tons eliminar la session--->
	<cfif isdefined("session.saci.cambioPQ") and form.Contratoid NEQ session.saci.cambioPQ.contrato>
		<cfset StructDelete(Session.saci, "cambioPQ")>
	</cfif>
	
	<cfif not isdefined("session.saci.cambioPQ")>
		
		<cfset session.saci.cambioPQ = StructNew()>
		<cfset session.saci.cambioPQ.contrato = form.Contratoid>
		<cfset session.saci.cambioPQ.PQanterior = form.PQcodigo1>
		<cfset session.saci.cambioPQ.PQnuevo = form.PQcodigo2>
		<cfset session.saci.cambioPQ.estado = 0>
		
		<cfset session.saci.cambioPQ.logBorrar = StructNew()>
			<cfset session.saci.cambioPQ.logBorrar.login = ''>
			<cfset session.saci.cambioPQ.logBorrar.servicios = ''>
		<cfset session.saci.cambioPQ.logConservar = StructNew()>
			<cfset logines = ValueList(rsServicios.LGlogin,",")>
			<cfset servicios = ValueList(rsServicios.TScodigo,",")>
			<cfset session.saci.cambioPQ.logConservar.login = logines>
			<cfset session.saci.cambioPQ.logConservar.servicios = servicios>
		<cfset session.saci.cambioPQ.pqAdicional = StructNew()>
			<cfset session.saci.cambioPQ.pqAdicional.cod = ''>
			<cfset session.saci.cambioPQ.pqAdicional.logMover = StructNew()>
				<cfset session.saci.cambioPQ.pqAdicional.logMover.login = ''>
				<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = ''>
	</cfif>
</cfif>