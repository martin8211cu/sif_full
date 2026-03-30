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
	order by   b.LGlogin
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
		<cfset logConserv = "">
		<cfset servConserv= "">
		<cfset logBorrar 	= session.saci.cambioPQ.logBorrar.login>
		<cfset servBorrar 	= session.saci.cambioPQ.logBorrar.servicios>
		<cfset PQAdic 		= session.saci.cambioPQ.pqAdicional.cod>
		<cfset logPQAdic 	= session.saci.cambioPQ.pqAdicional.logMover.login>
		<cfset servPQAdic 	= session.saci.cambioPQ.pqAdicional.logMover.servicios>
		
		<cfloop query="rsServicios">
			<cfif isdefined("Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#")>	
				
				<cfif Evaluate('Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#') EQ 2>				<!---servio por borrar--->
					<cfif logBorrar EQ "" and servBorrar EQ "">
						<cfset logBorrar = rsServicios.LGlogin>
						<cfset servBorrar = rsServicios.TScodigo>
					<cfelse>
						<cfset logBorrar = logBorrar &","& rsServicios.LGlogin>
						<cfset servBorrar = servBorrar &","& rsServicios.TScodigo>
					</cfif>
					<cfset rsServicios.conservar='0'>
				
				<cfelseif Evaluate('Form.r_#rsServicios.LGnumero#_#rsServicios.TScodigo#') EQ 3>			<!---Paquete Adicional--->
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
		
		<cfquery name="rsServConservar" dbtype="query">												
			select * from rsServicios where conservar='1'
		</cfquery>
		<cfset logConserv = ValueList(rsServConservar.LGlogin,",")>											<!---Servicios por conservar--->
		<cfset servConserv= ValueList(rsServConservar.TScodigo,",")>
			
		<!-------------------------------------------Verificaciones--------------------------------------------------------------------->
		<cfset temp_logConservar=session.saci.cambioPQ.logConservar.login>									<!---Estas variables de session se usan en gestion-paquetes-verificar-servicios-minmax.cfm por lo tanto hago lo siguiente para no perder el valor original--->
		<cfset temp_servConservar=session.saci.cambioPQ.logConservar.servicios>
		<cfset temp_logBorrar=session.saci.cambioPQ.logBorrar.login>
		<cfset temp_servBorrar=session.saci.cambioPQ.logBorrar.servicios>
		<cfset temp_codPA=session.saci.cambioPQ.pqAdicional.cod>
		<cfset temp_logPA=session.saci.cambioPQ.pqAdicional.logMover.login>
		<cfset temp_servPA=session.saci.cambioPQ.pqAdicional.logMover.servicios>
		
		<cfset session.saci.cambioPQ.logBorrar.login = logBorrar>
		<cfset session.saci.cambioPQ.logBorrar.servicios = servBorrar>
		<cfset session.saci.cambioPQ.logConservar.login = logConserv>
		<cfset session.saci.cambioPQ.logConservar.servicios = servConserv>
		<cfset session.saci.cambioPQ.pqAdicional.cod =PQAdic>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.login = logPQAdic>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = servPQAdic>
			
		<cfset mensajeError="">
		<cfinclude template="/saci/das/gestion/gestion-paquetes-servicios-sinTomar.cfm">					<!---verifica si existen servicios por conservar que no hayan sido tomados en cuenta y los pone en las listas servConservar y logConservar--->
		<cfinclude template="/saci/das/gestion/gestion-paquetes-verificar-servicios-minmax.cfm">			<!---Revisa que los servicios por conservar cumplan con el minimo y maximo de servicios requeridos--->
		
		<cfset session.saci.cambioPQ.logConservar.login = temp_logConservar>
		<cfset session.saci.cambioPQ.logConservar.servicios = temp_servConservar>
		<cfset session.saci.cambioPQ.logBorrar.login = temp_logBorrar>
		<cfset session.saci.cambioPQ.logBorrar.servicios = temp_servBorrar>
		<cfset session.saci.cambioPQ.pqAdicional.cod = temp_codPA>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.login = temp_logPA>
		<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = temp_servPA>
		
		<cfif not len(mensajeError)>																		<!---solo actualiza las varibles en session si existe al menos un login por conservar que cumpla con el minimo o maximo de servicios permitidos por el nuevo paquete--->
			<!--------------------------------------Actualizacion de la extructura en session------------------------------------------>
			<!---Servicios por borrar--->
			<cfset session.saci.cambioPQ.logBorrar.login = logBorrar>
			<cfset session.saci.cambioPQ.logBorrar.servicios = servBorrar>
			<!---Servicios por conservar--->
			<cfset session.saci.cambioPQ.logConservar.login = logConserv>
			<cfset session.saci.cambioPQ.logConservar.servicios = servConserv>
			<!---Paquetes adicionales--->
			<cfset session.saci.cambioPQ.pqAdicional.cod =PQAdic>
			<cfset session.saci.cambioPQ.pqAdicional.logMover.login = logPQAdic>
			<cfset session.saci.cambioPQ.pqAdicional.logMover.servicios = servPQAdic>
		</cfif>
		
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

