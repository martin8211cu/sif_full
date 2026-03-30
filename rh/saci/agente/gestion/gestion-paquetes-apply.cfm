<cfif isdefined("form.Terminar")>

	<cfif session.saci.cambioPQ.PQnuevo NEQ session.saci.cambioPQ.PQanterior>	
		<!--- Vuelve a realizar la validacion para verificar que no hayan servicios inconsistentes entre los servicios por conservar--->
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
					<cfif isdefined("session.saci.cambioPQ.logBorrar.servicios") and len(trim(session.saci.cambioPQ.logBorrar.servicios))>
					and e.TScodigo not in (<cfqueryparam list="yes" cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.logBorrar.servicios#">)	
					</cfif>
					<cfif isdefined("session.saci.cambioPQ.pqAdicional.logMover.servicios") and len(trim(session.saci.cambioPQ.pqAdicional.logMover.servicios))>
					and e.TScodigo not in (<cfqueryparam list="yes" cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.pqAdicional.logMover.servicios#">)	
					</cfif>
				where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.cambioPQ.contrato#">
				and a.CTcondicion = '1'),0)
				as ServActuales, 
				coalesce((select sum(b.SVcantidad) 
				from ISBpaquete a
				inner join ISBservicio b
					on b.PQcodigo = a.PQcodigo
					and b.TScodigo=x.TScodigo
					and b.Habilitado =1	
				where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
					and a.Habilitado=1),0) 
				as ServPermitidos
			from ISBservicioTipo x
			where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset ListVerificar="">
		<cfloop query="rsServicios">
			<cfif rsServicios.ServActuales GT rsServicios.ServPermitidos>
				<cfif ListVerificar EQ "">
					<cfset ListVerificar= rsServicios.TScodigo>
				<cfelse>	
					<cfset ListVerificar= ListVerificar&","&rsServicios.TScodigo>
				</cfif>
			</cfif>
		</cfloop>
		<cfif Listlen(ListVerificar)GT 0>
			<cfset StructDelete(Session.saci, "cambioPQ")>
			<cfthrow message="Aún existen servicios inconsitentes, por favor verificar.">
		<cfelse>
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
						<cfif isdefined("session.saci.cambioPQ.pqAdicional.logMover.servicios") and len(trim(session.saci.cambioPQ.pqAdicional.logMover.servicios))>
						and c.TScodigo not in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#session.saci.cambioPQ.pqAdicional.logMover.servicios#">)
						</cfif>
						<cfif isdefined("session.saci.cambioPQ.logBorrar.servicios") and len(trim(session.saci.cambioPQ.logBorrar.servicios))>
						and c.TScodigo not in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#session.saci.cambioPQ.logBorrar.servicios#">)
						</cfif>
					inner join ISBservicio e
						on e.PQcodigo=c.PQcodigo
						and e.TScodigo=c.TScodigo
						and e.Habilitado =1		
				where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
				and a.CTcondicion = '1' 
			</cfquery>
				
			<!---Completa los servicios a conservar que vamos a usar en el archivo XML que seguidamente se va a generar--->
			<cfset servConservar = ValueList(rsConservar.TScodigo)>
			<cfset logConservar = ValueList(rsConservar.LGlogin)>
			<cfset session.saci.cambioPQ.logConservar.login = session.saci.cambioPQ.logConservar.login &','& logConservar>
			<cfset session.saci.cambioPQ.logConservar.servicios = session.saci.cambioPQ.logConservar.servicios &','& servConservar>
			
			<!---Componente que genera el XML para el cambio de Paquete--->
			<!---<cfinclude template="generadorXML.cfm">--->
			<cfinvoke component="saci.comp.generadorXML" method="CambioPaquete" returnvariable="PaqueteXML">
				<cfinvokeargument name="cambioPQ" value="#session.saci.cambioPQ#">
			</cfinvoke>	
			
			<!---Validacion de los datos XML--->
			<cfsavecontent variable="xsd"><cfinclude template="/saci/xsd/cambioPaquete.xsd"></cfsavecontent>
			<cfset result = XMLValidate(PaqueteXML, xsd)>
			
			<!---Agrega el cambio de Paquete--->
			<cfif result.status>		
				<cfquery name="rsConservar" datasource="#session.DSN#">
					select TPid,TPinsercion,TPtipo
					from ISBtareaProgramada 
					where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
							and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
							and TPestado = 'P'
							and TPtipo = 'CP'
				</cfquery>
				<cfif isdefined("rsConservar.TPid") and len(trim(rsConservar.TPid))>
					<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
						method="Cambio">
						<cfinvokeargument name="TPid" value="#rsConservar.TPid#">
						<cfinvokeargument name="CTid" value="#form.CTid#">
						<cfinvokeargument name="Contratoid" value="#form.Contratoid#">
						<cfinvokeargument name="TPinsercion" value="#rsConservar.TPinsercion#">
						<!---FALTA: LA FECHA PROGRAMADA DEBE CALCULARSE Y ASIGNARSE, POR AHORA SOLO SE REGISTRA LA FECHA ACTUAL--->
						<cfinvokeargument name="TPfecha" value="#now()#">
						<cfinvokeargument name="TPfechaReal" value="">
						<cfinvokeargument name="TPdescripcion" value="Cambio de paquete">
						<cfinvokeargument name="TPxml" value="#PaqueteXML#">
						<cfinvokeargument name="TPestado" value="P">
						<cfinvokeargument name="TPtipo" value="#rsConservar.TPtipo#">
					</cfinvoke>
				<cfelse>	
					<cfinvoke component="saci.comp.ISBtareaProgramada" returnvariable="idTareaProg"
						method="Alta">
						<cfinvokeargument name="CTid" value="#form.CTid#">
						<cfinvokeargument name="Contratoid" value="#form.Contratoid#">
						<cfinvokeargument name="TPinsercion" value="#now()#">
						<!---FALTA: LA FECHA PROGRAMADA DEBE CALCULARSE Y ASIGNARSE, POR AHORA SOLO SE REGISTRA LA FECHA ACTUAL--->
						<cfinvokeargument name="TPfecha" value="#now()#">
						<cfinvokeargument name="TPfechaReal" value="">
						<cfinvokeargument name="TPdescripcion" value="Cambio de paquete">
						<cfinvokeargument name="TPxml" value="#PaqueteXML#">
						<cfinvokeargument name="TPestado" value="P">
						<cfinvokeargument name="TPtipo" value="CP">
					</cfinvoke>	
				</cfif>
				<cfset StructDelete(Session.saci, "cambioPQ")>
			<cfelse>
				<cfset StructDelete(Session.saci, "cambioPQ")>
				<cfthrow message="Error: Los Datos para el archivo XML son incorrectos">
			</cfif>
		</cfif>
	<cfelse>
		<cfset StructDelete(Session.saci, "cambioPQ")>
	</cfif>
<cfelse>
	<cfset StructDelete(Session.saci, "cambioPQ")>
</cfif>

<cfinclude template="gestion-redirect.cfm">
