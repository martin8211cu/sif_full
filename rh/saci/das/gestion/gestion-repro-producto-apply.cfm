<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&cue=#Form.cue#&pkg_rep=#Form.pkg_rep#&cpaso=#Form.cpaso#">

<cffunction name="existeLogPrinc" output="true" returntype="boolean" access="remote">
	<cfargument name="logPrinc" type="numeric" required="Yes" displayname="Agente">
	
	<cfset existe = false>
	<cfset cksLogs= form.LogsRep>
	
	<cfif ListFindNoCase(cksLogs, Arguments.logPrinc,',') NEQ 0>
		<cfset existe = true>
	</cfif>
	
	<cfreturn existe>
</cffunction>

<cfif isdefined("form.Reactivar")>
	<cfset ExtraParams = "">
	
	<!---1 valida que se reprograme al menos un login para el paquete--->
	<cfif not isdefined("form.LogsRep") or not ListLen(form.LogsRep)>
		<cfthrow message="Debe elegir al menos un login para reprogramar el paquete.">
	</cfif>
	
	<cfset cks= form.LogsRep>
	<cftransaction>
		<cfquery name="rsPQ" datasource="#session.DSN#">
			select a.PQcodigo,b.PQnombre, a.Contratoid, b.PQtelefono   
			from ISBproducto a
				inner join ISBpaquete b
					on b.PQcodigo=a.PQcodigo
					and b.Habilitado=1
			where
				a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
				and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
		</cfquery>
		
		<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
		<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	
			<cfinvokeargument name="Pcodigo" value="40">
		</cfinvoke>		
		
		<cfquery name="rsLog" datasource="#session.DSN#">
			select distinct  b.LGnumero,b.LGlogin
				,b.LGrealName,b.LGmailQuota,b.LGroaming,b.LGprincipal,b.Habilitado,b.LGbloqueado,b.LGtelefono,b.LGmostrarGuia
				, coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#"> and x.TScodigo = 'CABM' and x.Habilitado = 1), 0)as Cantidad_CABM
			from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid=a.Contratoid
					and b.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
					and b.Habilitado=2
					<!---and datediff( day, b.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
			where
				a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
				and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#">
		</cfquery>
		
		<cfif isdefined('rsLog') and rsLog.recordCount GT 0>
			<cfquery name="rsLogPrinc" dbtype="query">
				Select LGnumero,LGlogin
				from rsLog
				where LGprincipal = 1
			</cfquery>
		</cfif>
		
		<!---2 Validar que la cantidad de servicios asignados a cada producto sea la correcta --->
		<cfquery name="chkServicios" datasource="#Session.DSN#">
			select x.TScodigo,
				x.TSnombre,
				coalesce((	select count(1)	from ISBproducto a
					inner join ISBlogin b
						on b.Contratoid = a.Contratoid	and b.Habilitado = 2	and b.LGnumero in (<cfqueryparam  list="yes" cfsqltype="cf_sql_numeric" value="#Form.logsRep#">)
					inner join ISBserviciosLogin c
						on c.LGnumero = b.LGnumero	and c.PQcodigo = a.PQcodigo	and c.TScodigo = x.TScodigo	and c.Habilitado = 1
					inner join ISBservicio e
						on e.PQcodigo = c.PQcodigo	and e.TScodigo = c.TScodigo	and e.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cue#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.pkg_rep#">
						and a.CTcondicion not in ('C')), 0) as ServReprogramar, 
				coalesce((	select count(1)	from ISBproducto a
					inner join ISBlogin b
						on b.Contratoid = a.Contratoid	and b.Habilitado = 1
					inner join ISBserviciosLogin c
						on c.LGnumero = b.LGnumero	and c.PQcodigo = a.PQcodigo	and c.TScodigo = x.TScodigo	and c.Habilitado = 1
					inner join ISBservicio e
						on e.PQcodigo = c.PQcodigo	and e.TScodigo = c.TScodigo	and e.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cue#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.pkg_rep#">
						and a.CTcondicion not in ('C')), 0) as ServActivos, 			<!---servicios que posee el producto actual en captura--->
				coalesce((	select sum(b.SVcantidad)	from ISBproducto a
					inner join ISBservicio b
						on b.PQcodigo = a.PQcodigo	and b.TScodigo=x.TScodigo	and b.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cue#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.pkg_rep#">
						and a.CTcondicion not in ('C')), 0) as ServPermitidos,		<!---servicios maximos que permite el paquete actual en captura--->
				coalesce((	select sum(b.SVminimo) from ISBproducto a
					inner join ISBservicio b
						on b.PQcodigo = a.PQcodigo	and b.TScodigo=x.TScodigo	and b.Habilitado = 1
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cue#">
						and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.pkg_rep#">
						and a.CTcondicion not in ('C')), 0) as ServMinimos			<!---servicios minimos que permite el paquete actual en captura--->
			from ISBservicioTipo x
			where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfset muchosServ = "">
		<cfset pocosServ = "">
		<cfloop query="chkServicios">
			<cfset actu = chkServicios.ServActivos + chkServicios.ServReprogramar>
			<cfset permit= chkServicios.ServPermitidos>
			<cfset mini = chkServicios.ServMinimos >
			
			<cfif actu GT permit>	<cfset muchosServ = muchosServ &' '& IIF(muchosServ neq "", DE(","), DE(""))&' '&chkServicios.TScodigo>	</cfif>
			<cfif  mini GT actu>	<cfset pocosServ = pocosServ &' '& IIF(pocosServ neq "", DE(","), DE(""))&' '&chkServicios.TScodigo>	</cfif>
		</cfloop>
		
		<cfset errorMens= "">
		<cfif len(trim(muchosServ))>
			<cfset errorMens= errorMens & " Se asignó una cantidad de servicios mayor a la permitida en la configuración de los servicios #muchosServ#.">
		</cfif>
		<cfif len(trim(pocosServ))>
			<cfset errorMens= errorMens & " Se asignó una cantidad de servicios mínima a la permitida en la configuración de los servicios #pocosServ#.">
		</cfif>
		<cfif len(trim(errorMens))>	<cfthrow message="Error: #errorMens#">	</cfif>
		<!--- 2 fin --->
		
		<cfset existePrinc = false>
		<cfset canAltaGaran = 0>		
		<cfif isdefined('rsLogPrinc') and rsLogPrinc.recordCount GT 0>
			<cfset existePrinc = existeLogPrinc(rsLogPrinc.LGnumero)>
		</cfif>
		
		
		<cfif not existePrinc>
			<cfquery name="rsLogPrincipal" datasource="#session.DSN#">
				select  b.LGnumero,b.LGlogin
				from ISBproducto a
					inner join ISBlogin b
						on b.Contratoid=a.Contratoid
							and b.LGprincipal=1
				where
					a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
					and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
					and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#">					
			</cfquery>
		</cfif>

		<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="VendedorGenerico"
							Pcodigo="222" />
		<cfquery name="rsAgenteGenerico" datasource="#session.dsn#">
			select a.AGid
			from ISBagente a
			  inner join ISBvendedor b
				on a.AGid = b.AGid
			Where b.Vid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#VendedorGenerico#">
		</cfquery>
		
		<cfset AgenteId = -1>
		<cfif rsAgenteGenerico.RecordCount gt 0>
			<cfset AgenteId = rsAgenteGenerico.AGid>
		</cfif>
		
		<cfset validate = true>
		
		<cfloop query="rsLog">
			<cfset current ="">
			<cfset login = "">
			<cfset loginid = "">			
			<cfset current = rsLog.CurrentRow>
			
			<cfset loginid = Form['LGnumero#current#']>
			<cfif isdefined("Form.Login#current#") and Len(Trim(Form['Login#current#']))>
				<cfset login = Form['Login#current#']>			
			</cfif>
			
			<cfif Len(Trim(login))>
				<cfif ListFindNoCase(cks, loginid,',') NEQ 0>
					
					<!---Validaciones del SOBRE--->
					
					<!---validaciones para Restablecer el sobre asociado al login
						1.Que el sobre se encuentre disponible  (mensCod=17)
							ISBsobre.Sestado = 0
						2.Que se encuentre asignado al agente genérico (RACSA)  (mensCod=19)
							ISBsobre.Sdonde = 1 (Asignado al Agente)
							ISBsobre.AGid = 199 (ver parámetro, Vendedor Genérico para ventas de DSO y
												Registro de Agentes)
						3.El sobre digitado debe contener como mínimo las claves para los servicios asociados al login.  (mensCod=18)
							ISBsobre.Sgenero = A (acceso)
							ISBsobre.Sgenero = C (correo)
							ISBsobre.Sgenero = M (ambos acceso y correo)
					--->
					
					<!---1--->
					<cfquery name="rs" datasource="#session.dsn#">
						select count(1) as r 
							from ISBsobres 
						where Snumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero' & current]#">
						and Sestado = '0'
					</cfquery>
					
					<cfif rs.r eq 0>
						<cfset validate = false>
						<cfset ExtraParams = 'MsgError=1041'>
					</cfif>
					
					<!---2--->
					<cfif validate>
						<cfquery name="rs" datasource="#session.dsn#">
							select count(1) as r 
								from ISBsobres 
							where Snumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero' & current]#">
							and Sdonde = '1'
							and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AgenteId#">
						</cfquery>
						
						<cfif rs.r eq 0>
							<cfset validate = false>
							<cfset ExtraParams = 'MsgError=1041'>
						</cfif>
					</cfif>
					
					<!---3--->
					<cfif validate>
					
						<cfset tipo = "X">		
						<cfquery name="rsTipo" datasource="#session.dsn#">
							select b.TStipo from ISBserviciosLogin a
								inner join ISBservicioTipo b
								on a.TScodigo = b.TScodigo
							where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#loginid#">
						</cfquery>
						
						<cfif rsTipo.RecordCount gt 0>			
							<cfif rsTipo.RecordCount eq 1>
								<cfset tipo = "M,#rsTipo.TStipo#">
							<cfelse>
								<cfset tipo = "M">
							</cfif>
						</cfif>
						
						<cfquery name="rs" datasource="#session.dsn#">
							select count(1) as r 
								from ISBsobres 
							where Snumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero' & current]#">
							and Sgenero in (<cfqueryparam cfsqltype="cf_sql_char" value="#tipo#" list="yes" separator=",">)
						</cfquery>
						
						<cfif rs.r eq 0>
							<cfset validate = false>
							<cfset ExtraParams = 'MsgError=1041'>
						</cfif>
					</cfif>
						
					<!---FIN Validaciones del SOBRE--->
					
					
					<cfif validate>
						<cfinvoke component="saci.comp.ISBlogin" method="ReprogramarLogin">	<!---Reactiva el login--->
							<cfinvokeargument name="LGnumero" value="#loginid#"/>
							<cfinvokeargument name="LGlogin"  value="#login#">
							<cfinvokeargument name="Snumero" value="#Form['Snumero' & current]#">
							<cfinvokeargument name="MStexto" value="Reprogramacion de Login">
						</cfinvoke>
					</cfif>
					
					<cfif existePrinc>
						<cfif rsLog.LGprincipal EQ 1>
							<!--- Solo se inserta un registro en ISBgarantia por paquete reprogramado
								y se inserta solo el equivalente al login principal --->
							<cfinclude template="../../utiles/depoGaran-apply.cfm">										
						</cfif>
					<cfelse>
						<cfif isdefined('form.montoApagar') and form.montoApagar GT 0 and canAltaGaran EQ 0>
							<cfif isdefined('rsLogPrincipal') and rsLogPrincipal.recordCount GT 0>
								<cfset loginid = rsLogPrincipal.LGnumero>
							<cfelse>
								<cfthrow message="No existe el login principal del contrato seleccionado para el paquete: #rsPQ.PQcodigo#.">
							</cfif>
						
							<!--- Cuando el login principal ya fue reprogramado no va a existir en la lista de logines a reprogramar,
								por esa razon se va a insertar un registro en ISBgarantia solamente si el monto a pagar es mayor a cero.
								y solo el equivalente al login principal --->							
							<cfinclude template="../../utiles/depoGaran-apply.cfm">																
							<cfset canAltaGaran = canAltaGaran + 1>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			
		</cfloop>
		
		<!--- Asignar el subscriptor si viene asignado --->
		<cfif isdefined("form.CNsuscriptor") and Len(Trim(form.CNsuscriptor))>
			<cfinvoke component="saci.comp.ISBproducto" method="CambioSuscriptor">
				<cfinvokeargument name="Contratoid" value="#form.pkg_rep#">
				<cfinvokeargument name="CNsuscriptor" value="#form.CNsuscriptor#">
				<cfif isdefined("form.CNnumero") and Len(Trim(form.CNnumero))>
				<cfinvokeargument name="CNnumero" value="#form.CNnumero#">
				</cfif>
			</cfinvoke>
		</cfif>
		<!---Reactiva el producto--->
		<cfinvoke component="saci.comp.ISBproducto" method="Reprogramar">
			<cfinvokeargument name="Contratoid" value="#form.pkg_rep#"/>
		</cfinvoke>
		
	</cftransaction>
	
	<cfquery datasource="#session.dsn#" name="ISBgarantia">
		select g.Gtipo, g.Gmonto, g.Gref, g.Ginicio, g.Miso4217, ef.INSCOD, g.DEPNUM, g.Gid
		from ISBgarantia g
		left join ISBentidadFinanciera ef
			on ef.EFid = g.EFid
		where g.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
	</cfquery>

	<cfif isdefined('ISBgarantia') and ISBgarantia.RecordCount gt 0 and isdefined('rsLogPrinc') and rsLogPrinc.recordCount GT 0>				
				
				<cfquery datasource="SACISIIC" name="depositos">
				exec sp_Alta_SSXDEP
				<!---El monto se indica en la interfaz SACI-03-H029b--->
				@DEPMON = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBgarantia.Gmonto#"> 
				, @DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
				, @SERIDS = null
				, @SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLogPrinc.LGlogin#" null="#Len(rsLogPrinc.LGlogin) is 0#">
				, @INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
				, @DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
				, @DEPFED =
				<cfif Len(ISBgarantia.Ginicio)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
				<cfelse> NULL </cfif>
				
				, @FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
				<cfelse> 1 </cfif>
				, @MAAT 	= 1
				, @RETORNO = 1				
			</cfquery>
		
		<cfif isdefined('depositos')>	
			<cfquery datasource="#session.dsn#" name="actualizaISBgarantia">
					Update ISBgarantia Set DEPNUM = <cfqueryparam cfsqltype="cf_sql_float" value="#depositos.DEPNUM#">
					Where Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gid#">
			</cfquery>
		</cfif>
	
	</cfif>		
	
	<cfset form.Contratoid="">
	
	<cfif not isdefined("ExtraParams") and not len(ExtraParams)>
		<cfset form.pkg_rep="">
	</cfif>
	
</cfif>

<cfinclude template="gestion-redirect.cfm">