

<!--- Primero que nada veamos si hay pago en línea pendiente, en este caso procedemos al pago --->
<cfif IsDefined('url.pagoenlinea')>
	<cfset StructAppend(form, session.pagando)>
</cfif>
<!--- Calcular monto total del pago requerido --->

<cfif not isdefined("Eliminar")>

	<cfset listaPaq = session.saci.cambioPQ.PQnuevo>
	<cfif isdefined('session.saci.cambioPQ.pqAdicional.cod')>
		<cfset listaPaq = listaPaq & "," & session.saci.cambioPQ.pqAdicional.cod>
	</cfif>
	<cfset monto_total = 0>
	<cfset paquetes_pago = ''>
	<cfset moneda_pago = ''>
	
	<cfloop list="#listaPaq#" index="curr_paq">
		<cfif isdefined("form.Gtipo_#curr_paq#") and isdefined("form.Gmonto_#curr_paq#") and form['Gtipo_#curr_paq#'] is 11 And form['Gmonto_#curr_paq#'] NEQ 0>
			<cfset monto_total = monto_total + form['Gmonto_#curr_paq#']>
			<cfif Len(moneda_pago) is 0>
				<cfset moneda_pago = form['Miso4217_#curr_paq#']>
			<cfelseif moneda_pago neq form['Miso4217_#curr_paq#']>
				<cfthrow message="Por favor realice todos los pagos en una sola moneda">
			</cfif>
			<cfset paquetes_pago = ListAppend(paquetes_pago, curr_paq)>
		</cfif>
	</cfloop>
	
	<cfif monto_total NEQ 0>
		<!--- Login principal o primero --->
		<cfquery name="login_principal" datasource="#session.DSN#">
			select top 1 LGlogin
			from ISBlogin
			where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
			order by case when Habilitado=1 then 0 else 1 end, LGprincipal desc, LGnumero
		</cfquery>				
		<!--- 11 = PAGO-EN-LINEA --->
		<!--- ver si el pago se realizó --->
		<cfquery datasource="#session.dsn#" name="pagado">
			select PTmonto, PTid, PTcodAutorizacion
			from ISBpago
			where PTlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#login_principal.LGlogin#">
			  and PTusado = 0
			  and PTautorizado = 1
			  and PTmonto >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#monto_total#">
			  <cfif IsDefined('url.pagoenlinea')>
				and PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pagoenlinea#">
			  </cfif>
			order by PTmonto
		</cfquery>
		<cfif pagado.RecordCount is 0>
			<cfif IsDefined('url.pagoenlinea')>
				<cfset ExtraParams = "recargaok=0">
				<cfinclude template="#NEXTPAGE#">
				<!--- Se supone que de aquí no pasa, pero pongo el cfthrow por lo que potis --->
				<cfthrow message="El pago para #form.tj# por #form.costo_total# no fue aceptado.">
			</cfif>
			<!--- guardar el form en session, y mandar a pagar --->
			<cfset session.pagando = StructNew()>
			<cfset StructAppend(session.pagando, form)>
			<cfinvoke component="saci.pagos.vpos" method="send" returnvariable="vpos_struct"
				monto="#monto_total#"
				moneda="#moneda_pago#"
				origen="SACI"
				tipoTransaccion="AUCP"
				login="#login_principal.LGlogin#"
				descripcion="Paquete #paquetes_pago#" />
			<cflocation url="../../pagos/vpos-request.cfm?datos=#vpos_struct.datos#&validar=#vpos_struct.validar#" addtoken="no">
		<cfelse>
			<!--- pasar el núm de referencia de la autorización --->
			<cfloop list="#listaPaq#" index="curr_paq">
				<cfif form['Gtipo_#curr_paq#'] is 11 And form['Gmonto_#curr_paq#'] NEQ 0>
					<cfset form['Gref_#curr_paq#'] = 'Aut #pagado.PTcodAutorizacion#, Tran #pagado.PTid#'>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>
<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&ppaso=#Form.ppaso#&lpaso=#Form.lpaso#&cpaso=#Form.cpaso#&cue=#Form.cue#&pkg=#Form.pkg#">
<cfif isdefined("form.Aceptar")>
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
					and e.TScodigo  in (<cfqueryparam list="yes" cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.logConservar.servicios#">)	
					</cfif>
					<cfif isdefined("session.saci.cambioPQ.logBorrar.servicios") and len(trim(session.saci.cambioPQ.logBorrar.servicios))>
					and e.TScodigo not in (<cfqueryparam list="yes" cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.logBorrar.servicios#">)	
					</cfif>
					<cfif isdefined("session.saci.cambioPQ.pqAdicional.logMover.servicios") and len(trim(session.saci.cambioPQ.pqAdicional.logMover.servicios))>
					and e.TScodigo not in (<cfqueryparam list="yes" cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.pqAdicional.logMover.servicios#">)	
					</cfif>
				where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.cambioPQ.contrato#">
				and a.CTcondicion = '1'),0)
				as ServActivos, 
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
			<cfif rsServicios.ServActivos GT rsServicios.ServPermitidos>
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
			
			<!---selecciona los logines por conservar que no fueron tomados en cuenta en session.saci.cambioPQ.logConservar por que son aceptadas por el paquete nuevo y no generan conflictos--->
			<!---Los pone en una lista llamada: "servConservar" y los logines que pertenecen respectivamente los pone en la lista "logConservar"--->
			<cfinclude template="/saci/das/gestion/gestion-paquetes-servicios-sinTomar.cfm">
			
			<!---Elimina de las listas los logines en memoria que presentan inconsistencias por que estan divididos entre diferentes listas (por ej: login1 esta en el la lista de logines por conservar y tambien esta en la lista de logines por borrar) y despues los agrega a la lista de los servicios por borrar. NOTA: se actualiza la lista de servicios por conservar no tomados en cuenta(logConservar y servConservar) en caso de que esten definidos. Deja en una lista llamada "loginMasBorrar" los logines que presentan inconsistencias --->
			<cfinclude template="/saci/das/gestion/gestion-paquetes-verificar-logines-cruzados.cfm">
			
			<!---Revisa que los servicios por conservar cumplan con el minimo y maximo de servicios requeridos--->
			<cfset mensajeError="">
			<cfinclude template="/saci/das/gestion/gestion-paquetes-verificar-servicios-minmax.cfm">
			
			<!--- presenta un error en caso de que no existan servicios por conservar para el nuevo paquete ,o el o los logines que por conservar no cumplen con minimo y maximo de los servicios requeridos por el paquete--->
			<cfif listLen(mensajeError)>
				<cfset StructDelete(Session.saci, "cambioPQ")>
				<cfthrow message="Error revise los siguientes mensajes:#mensajeError#">
			</cfif>
			
			<!---Completa los servicios a conservar que vamos a usar en el archivo XML que seguidamente se va a generar--->
			<cfif listLen(servConservar)>
				<cfset session.saci.cambioPQ.logConservar.login = session.saci.cambioPQ.logConservar.login &','& logConservar>
				<cfset session.saci.cambioPQ.logConservar.servicios = session.saci.cambioPQ.logConservar.servicios &','& servConservar>
			</cfif>
			
			<!---Verifica el nuevo paquete requiere o posee servicios de cable Modem--->
			<cfset session.saci.cambioPQ.CNsuscriptor = "">
			<cfset session.saci.cambioPQ.CNnumero = "">
			<cfquery name="rsCABM" datasource="#session.DSN#">
				select coalesce(sum(x.SVcantidad),0) as cant 
				from ISBservicio x 
				where x.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
					and x.TScodigo = 'CABM' 
					and x.Habilitado = 1
			</cfquery>
			<cfif rsCABM.cant GT 0>
				<cfset session.saci.cambioPQ.CNsuscriptor = form.CNsuscriptor>
				<cfset session.saci.cambioPQ.CNnumero = form.CNnumero>
			</cfif>
			
			<!---Verifica si el nuevo paquete requiere telefonos para sus logines y los agrega en la extructura en session--->
			<cfset session.saci.cambioPQ.logConservar.telefono = "">
			<cfquery name="rsPQ" datasource="#session.DSN#">
				select PQtelefono
				from ISBpaquete 
				where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
				and Habilitado=1
			</cfquery>
			<cfif rsPQ.PQtelefono EQ 1>
				<cfset logTel= "">
				<cfloop index="lo" list="#session.saci.cambioPQ.logConservar.login#" delimiters=",">
					<cfset logTel= logTel & IIF(len(trim(logTel)),DE(','),DE('')) & Evaluate("form.LGtelefono#lo#")>
				</cfloop>
				<cfset session.saci.cambioPQ.logConservar.telefono = logTel>
			</cfif>
			<!--- Genera tarea programada o ejecuta de inmediato el cambio--->
			<cfif isdefined("form.radio")>
				<cfif isdefined('form.cue') and form.cue NEQ ''>
					<cfset form.CTid = form.cue>
				</cfif>			
				<cfset loginid = "">
				<cfquery name="rsLog" datasource="#session.DSN#">
					select b.LGnumero,b.LGprincipal
					from ISBproducto a
						inner join ISBlogin b
							on b.Contratoid=a.Contratoid
								and b.Habilitado=1
					where a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.cambioPQ.contrato#">
						and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
						and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
				</cfquery>					
				<cfif isdefined('rsLog') and rsLog.recordCount GT 0>
					<cfquery name="rsLogLP" dbtype="query">
						Select LGnumero
						from rsLog
						where LGprincipal = 1
					</cfquery>
					
					<cfif isdefined('rsLogLP') and rsLogLP.recordCount GT 0>
						<cfset loginid = rsLogLP.LGnumero>
					<cfelse>
						<cfthrow message="No existe el login principal del contrato seleccionado para el paquete: #session.saci.cambioPQ.PQanterior#.">
					</cfif>
				</cfif>				

				<cfset listaPaq = session.saci.cambioPQ.PQnuevo>
				<cfif isdefined('session.saci.cambioPQ.pqAdicional.cod')>
					<cfset listaPaq = listaPaq & "," & session.saci.cambioPQ.pqAdicional.cod>
				</cfif>
				<cfset arrPaq = ListToArray(listaPaq,",")>
				<cfset cargaSufijo = "">				
				<cfloop index="cont" from = "1" to = "#ArrayLen(arrPaq)#">
					<!--- Se inserta un registro en ISBgarantia por cada uno de los paquetes. El paquete por el que se va  acambiar y los paquetes adicionales --->
					<cfset cargaSufijo = "_" & arrPaq[cont]>		

					<!--- Insercion de los datos del deposito de garantia --->
					<cfinclude template="../../utiles/depoGaran-apply.cfm">	
					<cfif form['Gtipo#cargaSufijo#'] is 11 and form['Gmonto#cargaSufijo#'] neq 0>
						<!--- Marcar ISBpago como utilizada --->
						<cfquery datasource="#session.dsn#">
							update ISBpago
							set PTusado = 1
							where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pagado.PTid#">
						</cfquery>
					</cfif>
				</cfloop>
				
				<cfif form.radio EQ 1>
					<cfinclude template="/saci/das/gestion/gestion-paquetes-app-generaTarea.cfm"><!---genera tarea programada--->
				
				<cfelseif form.radio EQ 2>
					<cfinvoke component="saci.comp.ISBtareaProgramadaCP" method="cambioPaquete"><!---ejecuta el cambio de paquete--->
						<cfinvokeargument name="CTid"		value="#form.cue#">
						<cfinvokeargument name="Contratoid"	value="#form.pkg#">
						<cfinvokeargument name="str"		value="#session.saci#">
						
					</cfinvoke>
					<cfset StructDelete(Session.saci, "cambioPQ")>
				</cfif>	
			</cfif>
			
		</cfif>
	<cfelse>
		<cfset StructDelete(Session.saci, "cambioPQ")>
	</cfif>
<cfelseif isdefined("Eliminar")>
	<!---Elimimnacion de la tarea programada--->
	<cfquery name="rsTarea" datasource="#session.DSN#">
		select TPid
		from ISBtareaProgramada 
		where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
				and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
				and TPestado = 'P'
				and TPtipo = 'CP'
	</cfquery>

	<cfif rsTarea.recordCount GT 0>
		<!---Datos del login--->
		<cfquery name="rsLog" datasource="#session.DSN#">
			Select lo.LGlogin
			from ISBtareaProgramada tp
				inner join ISBlogin lo
					on lo.Contratoid=tp.Contratoid
						and lo.LGprincipal=1			
			where tp.TPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTarea.TPid#">
		</cfquery>	

		<cftransaction>
			<!---Datos del login--->
			<cfquery name="rsLog" datasource="#session.DSN#">
				Select lo.LGnumero
					, lo.LGlogin
					, tp.TPdescripcion
				from ISBtareaProgramada tp
					inner join ISBlogin lo
						on lo.Contratoid=tp.Contratoid
							and lo.LGprincipal=1			
				where tp.TPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTarea.TPid#">
			</cfquery>		
		
			<cfinvoke component="saci.comp.ISBtareaProgramada" method="Baja">
				<cfinvokeargument name="TPid" value="#rsTarea.TPid#">
			</cfinvoke>
	
			<cfif rsLog.recordCount GT 0>
				<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		<!---registro en la bitacora del borrado realizado --->
					<cfinvokeargument name="LGnumero" value="#rsLog.LGnumero#">
					<cfinvokeargument name="LGlogin" value="#rsLog.LGlogin#">
					<cfinvokeargument name="BLautomatica" value="false">				
					<cfinvokeargument name="BLobs" value="Eliminación de tarea programa: #rsLog.TPdescripcion#">
					<cfinvokeargument name="BLfecha" value="#now()#">
				</cfinvoke>			
			</cfif>		
		</cftransaction>
	</cfif>
<cfelse><!---Cancelar--->
	<cfset StructDelete(Session.saci, "cambioPQ")>
</cfif>

<cfif isdefined("form.cancelar") or isdefined("form.Eliminar")>
	<cfset ExtraParams = "">
<cfelse>
	<cfset ExtraParams = "recargaok=1">
</cfif>


<cfinclude template="#NEXTPAGE#">