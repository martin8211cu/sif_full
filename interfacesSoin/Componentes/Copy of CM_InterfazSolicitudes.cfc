<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfif not isdefined("Request.CM_InterfazSolicitudes.Initialized")>
			<cfset Request.CM_InterfazSolicitudes.Initialized = true>
			<cfset Request.CM_InterfazSolicitudes.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazSolicitudes.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazSolicitudes.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazSolicitudes.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<!--- 4 Métodos para actualizar la base de datos de SIF --->
	<!--- 4.1 Alta de una solicitud validando la integridad de los datos de entrada
		Respeta las siguientes reglas de las solicitudes de compras:
			4.1.1 ESnumero se calcula.
			4.1.2 Guarda el Ecodigo definido para el componente.
			4.1.3 Guarda el Usucodigo y la ESfecha definidos para el componente.
			4.1.4 Requiere los datos:
				 CFid (Centro Funcional), 
				 CMSid (Solicitante), 
				 CMTScodigo (Tipo de Solicitud), 
				 Mcodigo (Moneda), 
				 EStipocambio (Tipo de Cambio), 
				 ESfecha (Fecha),
				 ESobservacion (Descripción).
		 	4.1.6 EStotalest es asignado en 0.00, se calcula en los demás métodos.
			4.1.7 ESestado es asignado en 0.
			4.1.8 Interfaz es asignado en 1.
			4.1.9 Otros campos de la tabla, no tomados en cuenta en este insert: 
					(CMCid, CMTOcodigo, Rcodigo, NAP, NRP, NAPcancel, Usucodigomod, fechamod, ESreabastecimiento, 
					ESImpresion, ESOtipocambio, ESOobs, ESOplazoint, ESOporcant, ESjustificacion)
				Descripcion de estos campos y justificacion para no incluirlos:
					Al Aplicar: 
						CMCid (Comprador), NAP, NRP, ESImpresion ('I' cuando Aplica o 'R' cuando reimprime),  
					Al Cancelar: 
						NAPcancel, ESjustificacion, 
					Antes de Aplicar una solicitud de tipo compra directa:
						CMTOcodigo (Tipo de Orden de Compra), Rcodigo (Retencion), ESOtipocambio, ESOobs, ESOplazoint, ESOporcant, 
					Al Modificar: 
						Usucodigomod, fechamod, 
					Sin Uso:
						SNcodigo (Socio de Negocios), 				 
			 			CMElinea (Especialización),
						ESreabastecimiento.
	--->
	<cffunction name="Alta_ESolicitudCompraCM" access="public" returntype="query">
		<cfargument name="CFcodigo" type="string" required="true">
		<cfargument name="CMScodigo" type="string" required="true">
		<cfargument name="CMTScodigo" type="string" required="true">
		<cfargument name="Miso" type="string" required="true">
		<cfargument name="EStipocambio" type="numeric" required="true">
		<cfargument name="ESfecha" type="date" required="true">
		<cfargument name="ESObservacion" type="string" required="true">
		<cfargument name="CMTOcodigo" type="string" required="false">
		<cfargument name="Rcodigo" type="string" required="false">
		<cfargument name="SNnumero" type="string" required="false">
		<cfargument name="ESOporcant" type="string" required="false">
		<cfargument name="ESOtipocambio" type="string" required="false">

		<!--- Obtiene ids --->
		<cfset var LCFid = getCFidbyCFcodigo(Arguments.CFcodigo,'Alta_ESolicitudCompraCM')>
		<cfset var LCMSid = getCMSidbyCMScodigo(Arguments.CMScodigo,'Alta_ESolicitudCompraCM')>
		<cfset var LMcodigo = getMcodigobyMiso(Arguments.Miso,'Alta_ESolicitudCompraCM')>
		<cfset var LESnumero = getNextESnumero()>
		<cfset var LCMTScodigo = getCMTScodigo_vIntegridad(Arguments.CMTScodigo,'Alta_ESolicitudCompraCM')>
		<cfset var LEStipocambio = getEStipocambio_vIntegridad(LMcodigo,Arguments.EStipocambio,'Alta_ESolicitudCompraCM')>
		<cfset LCFid = getCFid_vCMTScodigo(LCFid,LCMTScodigo,'Alta_ESolicitudCompraCM')>
		<cfif isCompraDirecta(LCMTScodigo)>
			<cfset LCMTOcodigo = getCMTOcodigo_vIntegridad(Arguments.CMTOcodigo,'Alta_ESolicitudCompraCM')>
			<cfset LRcodigo = getRcodigo_vIntegridad(Arguments.Rcodigo,'Alta_ESolicitudCompraCM')>
			<cfset LSNcodigo = getSNcodigobySNnumero(Arguments.SNnumero,'Alta_ESolicitudCompraCM')>
			<cfset LESOplazoint = getNumeric(Arguments.ESOporcant,'Alta_ESolicitudCompraCM')>
			<cfset LESOporcant = getNumeric(Arguments.ESOtipocambio,'Alta_ESolicitudCompraCM')>
		</cfif>
		<!--- Alta --->
		<cfquery name="insert" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			insert into ESolicitudCompraCM 
				(Ecodigo, 
				ESnumero, 
				CFid, 
				CMSid, 
				CMTScodigo, 
				Mcodigo, 
				EStipocambio, 
				ESfecha, 
				ESobservacion, 
				BMUsucodigo, Usucodigo, ESfalta, EStotalest, ESestado, Interfaz
				<cfif isCompraDirecta(LCMTScodigo)>
				, SNcodigo
				, CMTOcodigo
				, Rcodigo
				, ESOtipocambio
				, ESOobs
				, ESOplazoint
				, ESOporcant
				</cfif>
				)
			values 
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LESnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCFid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCMSid#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#LCMTScodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#LEStipocambio#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.ESfecha#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ESobservacion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazSolicitudes.GvarFecha#">, 
				0.00, 0, 1
				<cfif isCompraDirecta(LCMTScodigo)>
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSNcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#LCMTOcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#LRcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_money" value="#LEStipocambio#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ESobservacion#">
				, <cfqueryparam cfsqltype="cf_sql_money" value="#LESOplazoint#">
				, <cfqueryparam cfsqltype="cf_sql_money" value="#LESOporcant#">
				</cfif>
				)
				<!--- <cf_dbidentity1 datasource="#Request.CM_InterfazSolicitudes.GvarConexion#"> --->
		</cfquery>
		<!--- <cf_dbidentity2 name="insert" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#"> --->
		<!--- Consulta resultados --->
		<cfquery name="result" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select ESidsolicitud, Ecodigo, ESnumero, CFid, CMSid, CMTScodigo, Mcodigo, 
				EStipocambio, ESfecha, ESobservacion, CMElinea, BMUsucodigo, Usucodigo, ESfalta, 
				EStotalest, ESestado, Interfaz, NAP, NRP, case ESestado when 20 then 'A' else 'R' end as EstadoResultante
				, SNcodigo, CMTOcodigo, Rcodigo, ESOtipocambio, ESOobs, ESOplazoint, ESOporcant
			from ESolicitudCompraCM
			where ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LESnumero#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<!--- Retorna resultados --->
		<cfreturn result>
	</cffunction>
	<!--- 4.2 Alta de detalle de una solicitud validando la integridad de los datos de entrada.
		Respeta las siguientes reglas de los detalles de las solicitudes de compras: 
			4.1.1 DSconsecutivo se calcula.
			4.1.2 Guarda el Ecodigo definido para el componente.
			4.1.3 Guarda el Usucodigo y la ESfecha definidos para el componente.
			4.1.4 Requiere los datos:
				ESidsolicitud, 
				ESnumero, 
				DScant, 
				Aid (Requerido solo si DStipo es A), 
				Alm_Aid (Requerido solo si DStipo es A), 
				Cid (Requerido solo si DStipo es S), 
				ACcodigo (Requerido solo si DStipo es F), 
				ACid (Requerido solo si DStipo es F), 
				Icodigo, 
				Ucodigo,
				DSdescripcion,
				DSmontoest, 
				DStotallinest, 
				DSfechareq, 
				CFid,
				DSdescalterna,
				DSobservacion.
				 
			4.1.6 Otros campos de la tabla, no tomados en cuenta en este insert: 
				Por defecto
					DScantsurt (cantidad surtida),
				Al Aplicar
					CMCid (comprador), 
					CFcuenta, 
					DSreflin, 
					DSformatocuenta, 
				Sin Uso:
					DSespecificacuenta, 
					CFidespecifica.				
	--->
	<cffunction name="Alta_DSolicitudCompraCM" access="public" returntype="query">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="ESnumero" type="numeric" required="true">
		<cfargument name="DScant" type="numeric" required="true">
		<cfargument name="Icodigo" type="string" required="true">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="DSdescripcion" type="string" required="true">
		<cfargument name="DSdescalterna" type="string" required="true">
		<cfargument name="DSobservacion" type="string" required="true">			
		<cfargument name="DSmontoest" type="numeric" required="true">
		<cfargument name="DStipo" type="string" required="true">
		<cfargument name="Acodigo" type="string" required="true">
		<cfargument name="Almcodigo" type="string" required="true">
		<cfargument name="Ccodigo" type="string" required="true">
		<cfargument name="ACcodigodesc" type="string" required="true">
		<cfargument name="ACiddesc" type="string" required="true">
		<cfargument name="DStotallinest" type="numeric" required="true">
		<cfargument name="DSfechareq" type="date" required="true">
		<cfargument name="CFcodigo" type="string" required="true">
		<cfargument name="CodigoCentroFuncional" type="string" required="false">		
		
		<!--- Obtiene Ids --->
		<cfset var LCFid = getCFidbyCFcodigo(Arguments.CFcodigo,'Alta_DSolicitudCompraCM')>
		<cfset var LESidsolicitud = getESidsolicitud_vIntegridad(Arguments.ESidsolicitud,'Alta_DSolicitudCompraCM')>
		<cfset var LDSconsecutivo = getNextDSconsecutivo(Arguments.ESidsolicitud,'Alta_DSolicitudCompraCM')>
		<cfset var LDStipo = getDStipo_vIntegridad(Arguments.DStipo,'Alta_DSolicitudCompraCM')>
		<cfswitch expression="#LDStipo#">
		<cfcase value="A">
			<cfset LAid = getAidbyAcodigo(Arguments.Acodigo,'Alta_DSolicitudCompraCM')>
			<cfset LAlm_Aid = getAlm_AidbyAlmcodigo(Arguments.Almcodigo,'Alta_DSolicitudCompraCM')>
		</cfcase>
		<cfcase value="S">
			<cfset LCid = getCidbyCcodigo(Arguments.Ccodigo,'Alta_DSolicitudCompraCM')>
		</cfcase>
		<cfcase value="F">
			<cfset LACcodigo = getACcodigobyACcodigodesc(Arguments.ACcodigodesc,'Alta_DSolicitudCompraCM')>
			<cfset LACid = getACidbyACcodigodesc(Arguments.ACiddesc,Arguments.ACcodigodesc,'Alta_DSolicitudCompraCM')>
		</cfcase>
		</cfswitch>
		<!--- Alta Detalle --->
		<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			insert into DSolicitudCompraCM 
				(Ecodigo, 
				ESidsolicitud, 
				ESnumero, 
				DSconsecutivo, 
				DScant, 
				DStipo, 
				<cfswitch expression="#LDStipo#">
				<cfcase value="A">
				Aid, 
				Alm_Aid, 
				</cfcase>
				<cfcase value="S">
				Cid, 
				</cfcase>
				<cfcase value="F">
				ACcodigo, 
				ACid, 
				</cfcase>
				</cfswitch>
				Icodigo, 
				Ucodigo, 
				CFid, 
				DSdescripcion, 
				DSdescalterna, 
				DSobservacion, 
				DSmontoest, 
				DStotallinest, 
				DSfechareq, 
				BMUsucodigo,
				CodigoCentroFuncional)
			values 
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LESidsolicitud#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LDSconsecutivo#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#getPositive_vIntegridad(Arguments.DScant,'CantidadSolicitada','Alta_DSolicitudCompraCM')#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#LDStipo#">, 
				<cfswitch expression="#LDStipo#">
				<cfcase value="A">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LAid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LAlm_Aid#">, 
				</cfcase>
				<cfcase value="S">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCid#">, 
				</cfcase>
				<cfcase value="F">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LACcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LACid#">, 
				</cfcase>
				</cfswitch>
				<cfqueryparam cfsqltype="cf_sql_char" value="#getIcodigo_vIntegridad(Arguments.Icodigo,'Alta_DSolicitudCompraCM')#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#getUcodigo_vIntegridad(Arguments.Ucodigo,'Alta_DSolicitudCompraCM')#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCFid#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getNotNull_vIntegridad(Arguments.DSdescripcion,'DescripcionBien','Alta_DSolicitudCompraCM')#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DSdescalterna#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DSobservacion#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#getPositive_vIntegridad(Arguments.DSmontoest,'PrecioUnitario','Alta_DSolicitudCompraCM')#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#getDStotallinest(Arguments.DStotallinest,Arguments.DScant,Arguments.DSmontoest,'Alta_DSolicitudCompraCM')#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DSfechareq#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">,
				<cfif isdefined('Arguments.CodigoCentroFuncional') and Arguments.CodigoCentroFuncional NEQ ''>
					<cfqueryparam cfsqltype="cf_sql_char" value="#getCFuncional(Arguments.CodigoCentroFuncional,'Alta_DSolicitudCompraCM')#">,
				<cfelse>
					null
				</cfif>)
		</cfquery>
		<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				update ESolicitudCompraCM
				set EStotalest = <cfqueryparam value="#getMontoTotal(LESidsolicitud)#" cfsqltype="cf_sql_money">
				where ESidsolicitud = <cfqueryparam value="#LESidsolicitud#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam value="#Request.CM_InterfazSolicitudes.GvarEcodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<!--- Consulta resultados --->
		<cfquery name="result" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Ecodigo, 
				ESidsolicitud, 
				ESnumero, 
				DSconsecutivo, 
				DScant, 
				DStipo, 
				Aid, 
				Alm_Aid, 
				Cid, 
				ACcodigo, 
				ACid, 
				Icodigo, 
				Ucodigo, 
				CFid, 
				DSdescripcion, 
				DSdescalterna, 
				DSobservacion, 
				DSmontoest, 
				DStotallinest, 
				DSfechareq, 
				BMUsucodigo
			from DSolicitudCompraCM
			where ESidsolicitud = <cfqueryparam value="#LESidsolicitud#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam value="#Request.CM_InterfazSolicitudes.GvarEcodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn result>
	</cffunction>
	
	<!--- 4.4 Aplicación de una solicitud de compra validando los requisitos para que dicha solicitud pueda ser aplicada. 
		Retorna:
			>=	0 				Aplicada
			<	0 				Registrada con rechazo presupuestario.
			cadena vacía 		Registrada en trámite.
	--->
	<cffunction name="Aplica_ESolicitudCompraCM" access="public" returntype="string">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfset var LESidsolicitud = getESidsolicitud_vIntegridad(Arguments.ESidsolicitud,'Cancelacion_ESolicitudCompraCM')>
		<cfset var LvarNAP = "">
		<!--- Si el tipo de solicitud genera trámite, LvarNAP se mantiene como una cadena vacía, si no, se intenta aplicar y devuelve 
		un valor numérico positivo indicando la aplicación correcta de la solicitud o un negativo indicando rechazo presupuestario. --->
		<!--- Inicio --->
		<!--- Si el monto NO excede el monto máximo permitido, para el centro funcional, para el  tipo de solicicitud. --->
		<cfif monto_permitido_by_CF_CMTS(LESidsolicitud)>
			<!--- Si tiene trámite --->
			<cfset tramite = getTramite(LESidsolicitud)>
			<cfif len(tramite.id_tramite) GT 0>
				<!--- Genera trámite --->
				<cfinvoke 
					component="home.Componentes.Seguridad" 
					method="init" 
					returnvariable="sec"/>
				

				<!--- a quien le vamos a notificar, si es necesario, sobre el avance del trámite, en su rol de solicitante --->
				<cfif IsDefined('datos_sujeto.Usucodigo') and Len(datos_sujeto.Usucodigo) >
					<cfset SubjectId = datos_sujeto.Usucodigo >
				<cfelse>
					<cfset SubjectId = 0>
				</cfif>

				<!--- Iniciar trámite solamente si no ha sido iniciado --->
				<cfset dataItems = StructNew()>
				<cfset dataItems.ESidsolicitud = LESidsolicitud >
				<cfset dataItems.Ecodigo       = Request.CM_InterfazSolicitudes.GvarEcodigo >
				<cfset descripcion_tramite     = 'Aprobación de Solicitud de Compra No. ' & tramite.ESnumero & '<br>Solicitada por: ' & tramite.CMSnombre >
				
				<cfinvoke 
					component="sif.Componentes.Workflow.Management" 
					method="startProcess" 
					ProcessId="#tramite.id_tramite#"
					RequesterId="#session.usucodigo#"
					SubjectId="#SubjectId#"
					Description="#descripcion_tramite#"
					DataItems="#dataItems#"
					returnvariable="processInstanceId"
					transaccionactiva="#true#"/>
					
				<cfinvoke 
					component="sif.Componentes.CM_AplicaSolicitud" 
					method="cambiarEstado"
					ESidsolicitud = "#LESidsolicitud#"
					Ecodigo = "#Request.CM_InterfazSolicitudes.GvarEcodigo#"
					estado="10"/>
					
			<!--- Si NO tiene trámite --->
			<cfelse>
				<!--- Aplica --->
				<cfinvoke 
					component="sif.Componentes.CM_AplicaSolicitud" 
					method="CM_AplicaSolicitud"
					ESidsolicitud = "#LESidsolicitud#"
					Ecodigo = "#Request.CM_InterfazSolicitudes.GvarEcodigo#"
					returnvariable="LvarNAP"/>
			</cfif>
		<!--- Fin --->
		</cfif>
		<cfreturn LvarNAP>
	</cffunction>
	<!--- Funciones necesarias para aplicar (privadas) --->
	<cffunction name="monto_permitido_by_CF_CMTS" access="private" output="false" returntype="boolean">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfset var result = true>
		<!--- Obtiene moneda y monto maximo del Tipo de Solicitud--->
		<cfquery name="rsresult" datasource="#session.DSN#">
			select 
			  a.Mcodigo as Mcodigoa,
			  a.EStotalest as Montoa,
			  a.EStipocambio as TCa,
			  b.Mcodigo as Mcodigob, 
			  b.CMTSmontomax as Montob,
			  null as TCb
			from ESolicitudCompraCM a
			  inner join CMTSolicitudCF b on a.CMTScodigo = b.CMTScodigo and a.CFid = b.CFid and a.Ecodigo = b.Ecodigo
			where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getESidsolicitud_vIntegridad(Arguments.ESidsolicitud,'Alta_DSolicitudCompraCM')#">
			  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>

		<!--- Caso 1: moneda de la solicitud es igual a moneda del tipo de Solicitud --->
		<cfif rsresult.Mcodigoa eq rsresult.Mcodigob>
			<cfif rsresult.Montoa GT rsresult.Montob>
				<cfset result = false >
			</cfif>

		<!--- Caso 2 monedas diferentes. Se compara en moneda local --->
		<cfelse>
			<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
				select Mcodigo from Empresas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
			</cfquery>

			<cfset MontoLa = rsresult.Montoa * rsresult.TCa>
			
			<cfset TCb = 1 >
			<cfquery name="rsTCb" datasource="#session.DSN#">
				select tc.TCventa
				from Htipocambio tc
				where tc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
				  and tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsresult.Mcodigob#">
				  and tc.Hfecha = (
					select max(Hfecha) 
					from Htipocambio tc1 
					where tc1.Ecodigo = tc.Ecodigo 
					  and tc1.Mcodigo = tc.Mcodigo
					  and tc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					  )
			</cfquery>

			<cfif rsTCb.recordcount GT 0 and len(trim(rsTCb.TCventa))>
				<cfset TCb = rsTCb.TCventa >
			<cfelse>
				<cfquery name="rsMonedab" datasource="#session.DSN#">
					select Mnombre 
					from Monedas 
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
					and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsresult.Mcodigob#">
				</cfquery>
				<cfthrow message="Debe definir el tipo de cambio actual para la moneda #rsMonedab.Mnombre#, Proceso Cancelado!">
			</cfif>

			<cfset MontoLb = rsresult.Montob * TCb>

			<cfif MontoLa GT MontoLb>
				<cfset result = false>
			</cfif>
		</cfif>
		<cfif result NEQ true>
			<cfthrow message="El monto de la solicitud ha excedido el monto máximo definido en el tipo de Solicitud para el centro funcional.">
		</cfif>
		<cfreturn result>
	</cffunction>
	<cffunction name="getTramite" access="private" output="false" returntype="query">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfquery name="result" datasource="#session.DSN#">
			select 
			  a.ESnumero, 
			  a.CFid,
			  a.CMSid,
			  b.id_tramite, 
			  c.CMSnombre
			from ESolicitudCompraCM a
			  inner join CMTiposSolicitud b on a.CMTScodigo = b.CMTScodigo and a.Ecodigo = b.Ecodigo
			  inner join CMSolicitantes c on a.CMSid = c.CMSid and a.Ecodigo = c.Ecodigo
			where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getESidsolicitud_vIntegridad(Arguments.ESidsolicitud,'Alta_DSolicitudCompraCM')#">
			  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfreturn result>
	</cffunction>
	
	<!--- 4.4 Cancelación de una solicitud de compra validando los requisitos para que dicha solicitud pueda ser cancelada. --->
	<cffunction name="Cancelacion_ESolicitudCompraCM" access="public" returntype="boolean">
		<cfargument name="ESnumero" type="numeric" required="true">
		<cfargument name="ESjustificacion" type="string" required="true">
		<cfargument name="Solicitante" type="string" required="true">
		<cfset var LCMSid = getCMSidbyCMScodigo(Arguments.Solicitante,'Cancelacion_ESolicitudCompraCM')>
		<cfset var LESidsolicitud = getESidsolicitudbyESnumero(Arguments.ESnumero,'Cancelacion_ESolicitudCompraCM')>
		<cfinvoke 
			component="sif.Componentes.CM_CancelaSolicitud"
			method="CM_getSolicitudesACancelar"
			Solicitante="#LCMSid#"
			Conexion="#Request.CM_InterfazSolicitudes.GvarConexion#"
			Ecodigo="#Request.CM_InterfazSolicitudes.GvarEcodigo#"
			returnvariable="solicitudes"/>
		<cfquery name="rs" dbtype="query">
			select ESidsolicitud
			from solicitudes
			where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LESidsolicitud#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="La Solicitud #Arguments.ESnumero# (NumeroSolicitud) no puede ser cancelada por el solicitante #Arguments.Solicitante#. Revise que el solicitante pueda cancelar esta solicitud, y que la solicitud pueda ser cancelada."/>
		</cfif>
		<cfinvoke 
			component="sif.Componentes.CM_CancelaSolicitud"
			method="CM_CancelaSolicitud"
			ESidsolicitud="#LESidsolicitud#"
			ESjustificacion="#getNotNull_vIntegridad(Arguments.ESjustificacion,'Observaciones','Cancelacion_ESolicitudCompraCM')#"
			Solicitante="#LCMSid#"
			Conexion="#Request.CM_InterfazSolicitudes.GvarConexion#"
			Ecodigo="#Request.CM_InterfazSolicitudes.GvarEcodigo#"
			returnvariable="result"/>
		<cfreturn result>
	</cffunction>
	
	<!--- 5 Métodos Privados del Componente --->
	<!--- 5.1 Obtiene el siguiente ESnumero de una solicitud de compra --->
	<cffunction access="private" name="getNextESnumero" output="false" returntype="numeric">
		<cfset var nextnumero = 1>
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select coalesce(max(ESnumero),0) + 1 as nextnumero
			from ESolicitudCompraCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.recordcount GT 0 and rs.nextnumero GT 1>
			<cfset nextnumero = rs.nextnumero>
		</cfif>
		<cfreturn nextnumero>
	</cffunction>
	<!--- 5.2 Obtiene el monto total de una solicitud de compra --->
	<cffunction access="private" name="getMontoTotal" output="false" returntype="numeric">
		<cfargument name="ESidsolicitud" type="numeric" required="yes">
		<cfset var result = 0.00>
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select coalesce(sum(DScant*DSmontoest)+sum((Iporcentaje*DSmontoest*DScant)/100),0) as total
				from ESolicitudCompraCM a
				
				inner join DSolicitudCompraCM b
				on a.Ecodigo=b.Ecodigo
				   and a.ESidsolicitud=b.ESidsolicitud
				
				inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				   and b.Icodigo=c.Icodigo
				
				where b.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESidsolicitud#" >
				  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.recordcount GT 0 and rs.total GT 0.00>
			<cfset result = rs.total>
		</cfif>
		<cfreturn result>
	</cffunction>
	<!--- 5.3 Obtiene el siguiente DSconsecutivo de un detalle de una solicitud de compra --->
	<cffunction access="private" name="getNextDSconsecutivo" output="false" returntype="numeric">
		<cfargument name="ESidsolicitud" type="numeric" required="yes">
		<cfset var nextnumero = 1>
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select coalesce(max(DSconsecutivo),0) + 1 as nextnumero
			from DSolicitudCompraCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
			and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESidsolicitud#">
		</cfquery>
		<cfif rs.recordcount GT 0 and rs.nextnumero GT 1>
			<cfset nextnumero = rs.nextnumero>
		</cfif>
		<cfreturn nextnumero>
	</cffunction>

	<!--- 6 Validaciones de integridad de las tablas referenciadas por la solicitud de compra. --->
	<cffunction access="private" name="getCFidbyCFcodigo" output="false" returntype="numeric">
		<cfargument name="CFcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CFid
			from CFuncional
			where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CFcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del CodigoCentroFuncional no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CFid>		
	</cffunction>
	<cffunction access="private" name="getCFid_vCMTScodigo" output="false" returntype="numeric">
		<cfargument name="CFid" required="yes" type="numeric">
		<cfargument name="CMTScodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CFid
			from CMTSolicitudCF 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		  	and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CMTScodigo#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del CodigoCentroFuncional no está permitido para el CodigoTipoSolicitud en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CFid>		
	</cffunction>
	<cffunction access="private" name="getCMSidbyCMScodigo" output="false" returntype="numeric">
		<cfargument name="CMScodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CMSid
			from CMSolicitantes
			where CMScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CMScodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoSolicitante no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CMSid>
	</cffunction>
	<cffunction access="private" name="getCMTScodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="CMTScodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CMTScodigo
			from CMTiposSolicitud
			where CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CMTScodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoTipoSolicitud no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CMTScodigo>
	</cffunction>
	<cffunction access="private" name="isCompraDirecta" output="false" returntype="boolean">
		<cfargument name="CMTScodigo" required="yes" type="string">
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CMTScompradirecta
			from CMTiposSolicitud
			where CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CMTScodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfreturn rs.CMTScompradirecta>
	</cffunction>
	<cffunction access="private" name="getMcodigobyMiso" output="false" returntype="string">
		<cfargument name="Miso" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoMoneda no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Mcodigo>
	</cffunction>
	<cffunction access="private" name="getEStipocambio_vIntegridad" output="false" returntype="numeric">
		<cfargument name="Mcodigo" required="yes" type="numeric">
		<cfargument name="EStipocambio" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<!--- Obtiene la moneda local, si la moneda es la moneda local, entonces valida que el tipo de cambio sea 1, sino valida que sea mayor que 0 --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.EStipocambio#">,4) as EStipocambio
			from Empresas 
			where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 1 and Arguments.EStipocambio neq 1.00>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoCambio es incorrecto porque para la Moneda Local debe ser siempre 1.00. Proceso Cancelado!">
		<cfelseif rs.RECORDCOUNT EQ 0 and Arguments.EStipocambio lte 0.00>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoCambio es incorrecto porque debe ser siempre mayor que 0.00. Proceso Cancelado!">
		<cfelseif rs.RECORDCOUNT EQ 0 >
			<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.EStipocambio#">,4) as EStipocambio
				from dual
			</cfquery>
		</cfif>
		<cfreturn rs.EStipocambio>
	</cffunction>
	<cffunction access="private" name="getESidsolicitudbyESnumero" output="false" returntype="string">
		<cfargument name="ESnumero" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select ESidsolicitud
			from ESolicitudCompraCM
			where ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro NumeroSolicitud no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.ESidsolicitud>
	</cffunction>
	<cffunction access="private" name="getESidsolicitud_vIntegridad" output="false" returntype="string">
		<cfargument name="ESidsolicitud" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select ESidsolicitud
			from ESolicitudCompraCM
			where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESidsolicitud#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro NumeroSolicitud no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.ESidsolicitud>
	</cffunction>
	<cffunction access="private" name="getNotNull_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif len(trim(Arguments.Value)) EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro #Arguments.Name# es Requerido y no puede ser vacío. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>
	<cffunction access="private" name="getPositive_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="numeric">
		<cfargument name="Name" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif len(trim(Arguments.Value)) EQ 0 OR Arguments.Value LTE 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro #Arguments.Name# es Requerido y debe ser mayor que 0. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>
	<cffunction access="private" name="getDStipo_vIntegridad" output="false" returntype="string">
		<cfargument name="DStipo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif NOT (Arguments.DStipo EQ 'A' OR Arguments.DStipo EQ 'S' OR Arguments.DStipo EQ 'F')>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoBien no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.DStipo)>
	</cffunction>
	<cffunction access="private" name="getAidbyAcodigo" output="false" returntype="string">
		<cfargument name="Acodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Aid
			from Articulos
			where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Acodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoArtiulo no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Aid>
	</cffunction>
	<cffunction access="private" name="getAlm_AidbyAlmcodigo" output="false" returntype="string">
		<cfargument name="Almcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Aid
			from Almacen
			where Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Almcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoAlmacen no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Aid>
	</cffunction>
	<cffunction access="private" name="getCidbyCcodigo" output="false" returntype="string">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Cid
			from Conceptos
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Ccodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoServicio no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Cid>
	</cffunction>
	<cffunction access="private" name="getACcodigobyACcodigodesc" output="false" returntype="string">
		<cfargument name="ACcodigodesc" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select ACcodigo
			from ACategoria
			where ACcodigodesc = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.ACcodigodesc)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoCategoria no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.ACcodigo>
	</cffunction>
	<cffunction access="private" name="getACidbyACcodigodesc" output="false" returntype="string">
		<cfargument name="ACcodigodesc" required="yes" type="string">
		<cfargument name="ACcodigodesccat" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select ACcodigo
			from ACategoria
			where ACcodigodesc = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.ACcodigodesccat)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT GT 0>
			<cfquery name="rsb" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select ACid
				from AClasificacion
				where ACcodigodesc = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.ACcodigodesc)#">
				  and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rs.ACcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoClase no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rsb.ACid>
	</cffunction>
	<cffunction access="private" name="getIcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="Icodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Icodigo
			from Impuestos
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoImpuesto no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Icodigo>
	</cffunction>
	<cffunction access="private" name="getUcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="Ucodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Ucodigo
			from Unidades
			where Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoUnidadMedida no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Ucodigo>
	</cffunction>
	<cffunction access="private" name="getCMTOcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="CMTOcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CMTOcodigo
			from CMTipoOrden
			where CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CMTOcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoOrdenCompra no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CMTOcodigo>
	</cffunction>
	<cffunction access="private" name="getRcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="Rcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Rcodigo
			from Retenciones
			where Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro Retencion no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Rcodigo>
	</cffunction>
	<cffunction access="private" name="getSNcodigobySNnumero" output="false" returntype="numeric">
		<cfargument name="SNnumero" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select SNcodigo
			from SNegocios a
			where SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoProveedor no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.SNcodigo>
	</cffunction>
	<cffunction access="private" name="getDStotallinest" output="false" returntype="numeric">
		<cfargument name="DStotallinest" required="yes" type="numeric">
		<cfargument name="DScant" required="yes" type="numeric">
		<cfargument name="DSmontoest" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DStotallinest#">,2) as DStotallinest
			from dual
			where round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DStotallinest#">,2) = 
				round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DScant#">*<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DSmontoest#">,2)
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TotalLinea es Inválido, debe ser iagual a 'CantidadSolicitada * PrecioUnitario'. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.DStotallinest>
	</cffunction>
	<cffunction access="private" name="getNumeric" output="false" returntype="numeric">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif not isNumeric(Arguments.Value)>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro #Arguments.Name# debe ser Numérico. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.Value>
	</cffunction>
	
	<cffunction access="private" name="getCFuncional" output="false" returntype="numeric">
		<cfargument name="CentroFunc" required="yes" type="string">
		<cfargument name="idSolic" required="yes" type="numeric">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select *
			from CMTSolicitudCF
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
				and CFid=(
					Select CFid
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
						and CFcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CentroFunc#">
					)
				and CMTScodigo = (
					Select CMTScodigo
					from ESolicitudCompraCM
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
						and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idSolic#">
				)
		</cfquery>
		
		
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoProveedor no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.SNcodigo>
	</cffunction>
	
</cfcomponent>