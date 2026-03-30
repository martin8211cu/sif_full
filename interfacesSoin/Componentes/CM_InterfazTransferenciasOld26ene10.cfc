<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: Define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="EcodigoSDC" required="no" type="numeric" default="0">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Usulogin" required="no" type="string" default="#Session.Usulogin#">
		<cfargument name="Usuario" required="no" type="string" default="#Session.usuario#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<!---- Si se recibe el EcodigoSDC se busca el Ecodigo que corresponda en minisif ---->
		<cfif Arguments.EcodigoSDC GT 0>
			<cfquery name="rsEcodigo" datasource="#Arguments.Conexion#">
				select Ereferencia
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
				  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!---- Si existe el Ecodigo en minisif ----->
			<cfif rsEcodigo.recordcount NEQ 0 and rsEcodigo.Ereferencia NEQ ''>
				<cfset Arguments.Ecodigo = rsEcodigo.Ereferencia>
			<cfelse>
				<cfthrow message="CM_InterfazTransferencias: El valor del par&aacute;metro EcodigoSDC es incorrecto o no corresponde con el Código de Empresa de la Sesion. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Request.CM_InterfazTransferencias.Initialized")>
			<cfset Request.CM_InterfazTransferencias.Initialized = true>
			<cfset Request.CM_InterfazTransferencias.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazTransferencias.GvarEcodigo = Arguments.Ecodigo>
			<cfset Request.CM_InterfazTransferencias.GvarEcodigoSDC = Arguments.EcodigoSDC>	
			<cfset Request.CM_InterfazTransferencias.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazTransferencias.GvarUsulogin = Arguments.Usulogin>
			<cfset Request.CM_InterfazTransferencias.GvarUsuario = Arguments.Usuario>
			<cfset Request.CM_InterfazTransferencias.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>

	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Usulogin" required="no" type="string" default="#Session.Usulogin#">		
		<cfargument name="Usuario" required="no" type="string" default="#Session.usuario#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazTransferencias.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazTransferencias.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazTransferencias.GvarUsuario = Arguments.Usuario>
		<cfset Request.CM_InterfazTransferencias.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazTransferencias.GvarUsulogin = Arguments.Usulogin>				
		<cfset Request.CM_InterfazTransferencias.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>

	<!--- Funcion para insertar el encabezado de Transferencias en la tabla ETraspasos --->
	<cffunction name="Alta_ETransferencias" access="public" returntype="numeric">	
		<cfargument name="ETdescripcion" type="string" required="true">
		<cfargument name="ETfecha" type="string" required="false">
		<cfargument name="BMUsucodigo" type="string" required="false">
		<cfargument name="NumeroDocumento" type="string" required="false">
		<cfset var vETperiodo = getETperiodo('Alta_ETransferencias')>
		<cfset var vETmes = getETmes('Alta_ETransferencias')>
		<cfset var vETdescripcion = Arguments.ETdescripcion>
		<cfset var vETfecha = Request.CM_InterfazTransferencias.GvarFecha>
		<cfif isdefined('Arguments.ETfecha') and len(trim(Arguments.ETfecha))>
			<cfset vETfecha = Arguments.ETfecha>				
		</cfif>
		<cfif len(trim(vETdescripcion)) EQ 0>
			<cfset vETdescripcion = " ">
		</cfif>
		<cfif isdefined('Arguments.NumeroDocumento') and len(trim(Arguments.NumeroDocumento))>
			<cfset LvarNumeroDocumento = Arguments.NumeroDocumento>
		<cfelse>
			<cfset LvarNumeroDocumento = "0">
		</cfif>
		<!--- Insertar. Alta en ETraspasos --->
		<cfquery name="insertTrasp" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			insert into ETraspasos( Ecodigo, ETperiodo, ETmes, ETusuario, ETdescripcion, ETfecha, BMUsucodigo)
				 values ( <cfqueryparam value="#Request.CM_InterfazTransferencias.GvarEcodigo#"    cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#vETperiodo#"	 cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#vETmes#"         cfsqltype="cf_sql_integer">, 
							<cfqueryparam value="#Request.CM_InterfazTransferencias.GvarUsuario#"    cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#vETdescripcion#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#vETfecha#" cfsqltype="cf_sql_timestamp">,
						<cfif isdefined("Arguments.BMUsucodigo") and Arguments.BMUsucodigo NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
						<cfelse>
							null
						</cfif>									  
						)
			<cf_dbidentity1 datasource="#Request.CM_InterfazTransferencias.GvarConexion#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#Request.CM_InterfazTransferencias.GvarConexion#" verificar_transaccion="false" name="insertTrasp">
		<cfif isdefined('insertTrasp') and insertTrasp.identity NEQ ''>
			<cfreturn insertTrasp.identity>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>

	<!--- Funcion para insertar el encabezado de Transferencias en la tabla ETraspasos --->
	<cffunction name="Alta_DTransferencias" access="public" returntype="numeric">	
		<cfargument name="ETid" type="string" required="true">
		<cfargument name="CuentaBancariaOrigen" type="string" required="true">		
		<cfargument name="CuentaBancariaDestino" type="string" required="true">				
		<cfargument name="MontoOrigen" type="string" required="true">				
		<cfargument name="MontoDestino" type="string" required="true">	
		<cfargument name="CodigoMonedaOrigen" type="string" required="true">	
		<cfargument name="MontoComision" type="string" required="true">						
		<cfargument name="CodigoBancoOrigen" type="string" required="false">								
		<cfargument name="CodigoBancoDestino" type="string" required="true">								
		<cfargument name="BMUsucodigo" type="string" required="false">
		<cfargument name="CodigoMonedaDestino" type="string" required="false">
		<cfargument name="NumeroDocumento" type="string" required="false">
		<cfargument name="FechaDocumento" type="string" required="false">
		<cfset var vDTmontoori = 0>		
		<cfset var vDTmontodest = 0>				
		<cfset var vTCambio = 1>
		<cfset var vDTmontolocal = 0>		
		<cfset var vDTmontocomori = 0>	
		<cfset var vDTmontocomloc = 0>
		<cfset var vDTtipocambiof = 0>				
		<cfset var vBTidori = '~'>
		<cfset var vBTiddest = '~'>
		<cfset var vCodBancoOrigen = ''>		
		<cfset var vDTdocumento = ''>
		<cfset var vDTreferencia = ''>
		<cfset rsMovimientoOri = transaccion(160,'Alta_ETransferencias')>		
		<cfif isdefined('Arguments.CodigoBancoOrigen') and trim(Arguments.CodigoBancoOrigen) NEQ ''>
			<cfset vCodBancoOrigen = Arguments.CodigoBancoOrigen>		
		<cfelse>
			<cfset vCodBancoOrigen = '***'>				
		</cfif>
		<cfif isdefined('rsMovimientoOri') and rsMovimientoOri.recordCount GT 0>
			<cfset vBTidori = rsMovimientoOri.Pvalor>
		</cfif>
		<cfset rsMovimientoDest = transaccion(170,'Alta_ETransferencias')>
		<cfif isdefined('rsMovimientoDest') and rsMovimientoDest.recordCount GT 0>
			<cfset vBTiddest = rsMovimientoDest.Pvalor>
		</cfif>
		<cfset vBTidori = getBT_vIntegridad(vBTidori,'BTidori','Alta_ETransferencias')>		
		<cfset vBTiddest = getBT_vIntegridad(vBTiddest,'BTiddest','Alta_ETransferencias')>				
		<cfif isdefined('Arguments.MontoOrigen') and len(trim(Arguments.MontoOrigen)) and Arguments.MontoOrigen GT 0>
			<cfset vDTmontoori = Arguments.MontoOrigen>				
		</cfif>		
		<cfif isdefined('Arguments.MontoDestino') and len(trim(Arguments.MontoDestino)) and Arguments.MontoDestino GT 0>
			<cfset vDTmontodest = Arguments.MontoDestino>				
		</cfif>		

		<cfif isdefined("Arguments.FechaDocumento") and len(trim(Arguments.FechaDocumento))>
			<cfset LVarFechaDoc = Arguments.FechaDocumento>
		<cfelse>
			<cfset LVarFechaDoc = Now()>
		</cfif>
		<cfif isdefined('Arguments.CodigoMonedaOrigen') and len(trim(Arguments.CodigoMonedaOrigen))>
			<cfset vTCambio = getTipoCambio(Arguments.CodigoMonedaOrigen,'Alta_ETransferencias',LVarFechaDoc)>
			<cfset vDTmontolocal = vTCambio * vDTmontoori>
		</cfif>
		<cfif isdefined('Arguments.MontoComision') and len(trim(Arguments.MontoComision)) and Arguments.MontoComision GT 0>
			<cfset vDTmontocomori = Arguments.MontoComision>				
			<cfset vDTmontocomloc = vTCambio * vDTmontocomori>							
		</cfif>		
		<cfif vDTmontoori GT 0>
			<cfset vDTtipocambiof = vDTmontodest/vDTmontoori>
		</cfif>		
		<cfif isdefined('Arguments.NumeroDocumento') and len(trim(Arguments.NumeroDocumento))>
			<cfset vDTdocumento = Arguments.NumeroDocumento>
		<cfelse>
			<cfset vDTdocumento = 'Mov: #Arguments.ETid#'> 
		</cfif>
		<cfif vTCambio EQ 0>
					<cfthrow message="No es posible determinar el Tipo de Cambio vigente para la moneda: #Arguments.CodigoMonedaOrigen#">
					<cfabort>
		</cfif>
		<cfset vDTreferencia =  'Ban Orig: #vCodBancoOrigen#' & '/' & Arguments.CuentaBancariaOrigen>
		<cfset vETdescripcion = vDTdocumento & ' Orig: #vCodBancoOrigen#' & ' / ' & Arguments.CuentaBancariaOrigen & ' / ' & 'Dest: #Arguments.CodigoBancoDestino#' & ' / ' & Arguments.CuentaBancariaDestino>
		<cfquery name="updTraspasos" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			update ETraspasos
			set ETdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#vETdescripcion#"> || rtrim(ETdescripcion)
			where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
		</cfquery>
		<!--- Insertar. Alta en DTraspasos --->
		<cfif round(vDTmontoori*100) EQ 0.00 OR round(vDTmontodest*100) EQ 0.00> 
			<cfthrow message="Documento '#Mid(vDTreferencia,1,25)# - #Mid(vDTdocumento,1,20)#' intenta grabar montos menores a 0.01 o cero. Montos Origen=#vDTmontoori#, Destino=#vDTmontodest#, Local=#vDTmontolocal#">
		</cfif>
		
		<cfquery name="insertTraspD" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			insert into DTraspasos 
				( 
					ETid, CBidori, CBiddest, BTidori, BTiddest, 
					DTmontoori, DTmontodest, DTmontolocal, 
					DTmontocomori, DTmontocomloc, 
					DTdocumento, DTreferencia, DTtipocambio, DTtipocambiof, BMUsucodigo) 
			values ( 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#getCBid_Cuenta(vCodBancoOrigen,Arguments.CuentaBancariaOrigen,'Alta_ETransferencias','CodigoBancoOrigen','CuentaBancariaOrigen', Arguments.CodigoMonedaOrigen)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#getCBid_Cuenta(Arguments.CodigoBancoDestino,Arguments.CuentaBancariaDestino,'Alta_ETransferencias','CodigoBancoOrigen','CuentaBancariaOrigen', Arguments.CodigoMonedaDestino)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vBTidori#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vBTiddest#">,
					
					round(#vDTmontoori#,2),
					round(#vDTmontodest#,2),
					round(#vDTmontolocal#,2),
					
					round(#vDTmontocomori#,2),
					round(#vDTmontocomloc#,2),

					<cfqueryparam cfsqltype="cf_sql_char"    value="#Mid(vDTdocumento,1,20)#">,
					<cfqueryparam cfsqltype="cf_sql_char"    value="#Mid(vDTreferencia,1,25)#">,					
					<cfqueryparam cfsqltype="cf_sql_float"   value="#vTCambio#">,
					<cfqueryparam cfsqltype="cf_sql_float"   value="#vDTtipocambiof#">,
					<cfif isdefined("Arguments.BMUsucodigo") and Arguments.BMUsucodigo NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
					<cfelse>
						null
					</cfif>							
					)
                    <cf_dbidentity1 datasource="#Request.CM_InterfazTransferencias.GvarConexion#" verificar_transaccion="false">
        </cfquery>
        <cf_dbidentity2 datasource="#Request.CM_InterfazTransferencias.GvarConexion#" verificar_transaccion="false" name="insertTraspD">

		<cfif isdefined('insertTraspD') and insertTraspD.identity NEQ ''>
			<cfreturn insertTraspD.identity>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>								

	<!--- Funcion para la aplicacion de las Transferencias --->
	<cffunction name="Aplica_Transferencia" access="public" returntype="boolean">
		<cfargument name="ETid" type="string" required="true">

		<!--- <cflog file="logint14LPostea" text="Aplica Transferencia LvarPosteo 1 #Request.CM_InterfazTransferencias.GvarEcodigo# #Arguments.ETid# #Request.CM_InterfazTransferencias.GvarUsucodigo# #Request.CM_InterfazTransferencias.GvarUsulogin#"> --->

		<cfif len(trim(Arguments.ETid))>
			<cfinvoke component="sif.Componentes.CP_MBPosteoTransferencias" method="PosteoTransferencias">
				<cfinvokeargument name="Ecodigo" value="#Request.CM_InterfazTransferencias.GvarEcodigo#"/>
				<cfinvokeargument name="ETid" value="#Arguments.ETid#"/>
				<cfinvokeargument name="usuario" value="#Request.CM_InterfazTransferencias.GvarUsucodigo#"/>	
				<cfinvokeargument name="LoginUsuario" value="#Request.CM_InterfazTransferencias.GvarUsulogin#"/>
				<cfinvokeargument name="debug" value="N"/>											
				<cfinvokeargument name="trans" value="N"/>				
			</cfinvoke>			
		<cfelse>
			<cfthrow message="Aplica_Transferencia: El valor del par&aacute;metro 'ETid=#Arguments.ETid#' es inv&aacute;lido. Proceso Cancelado!">		
		</cfif>
		<cfreturn true>
	</cffunction>	

	<!---****************  FUNCIONES DE VALIDACIÓN  *******************---->
	<!--- Se validan los campos necesarios para hacer cualquier modificación en la base de datos de SIF --->
	<cffunction access="private" name="getCBid_Cuenta" output="false" returntype="numeric">
		<cfargument name="vCodBanco" required="yes" type="string">
		<cfargument name="vCuentaBancaria" required="yes" type="string">		
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		<cfargument name="FieldName" required="no" type="string" default="CodigoBanco">	<!--- Nombre del método que lo invoca --->
		<cfargument name="FieldNameCuenta" required="no" type="string" default="CuentaBancaria">	<!--- Nombre del método que lo invoca --->
		<cfargument name="vCodigoMoneda" required="no" type="string" default="CodigoMoneda">	<!--- Codigo de la moneda de la transaccion --->
		<cfset var retCBidCuenta = -1>
		<cfif isNumeric(Arguments.vCodBanco)>
			<cfquery name="rsBanco" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				select Bid
				from Bancos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
				  and Iaba=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.vCodBanco#">
			</cfquery>
		<cfelse>
			<cfset Arguments.vCodBanco = "">
		</cfif>
		<cfif isdefined('rsBanco') and rsBanco.recordCount GT 0>
			<cfquery name="rsIdCuenta" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				select cb.CBid, cb.Mcodigo, m.Miso4217
				from CuentasBancos cb, Monedas m
				where cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
				  and cb.Bid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBanco.Bid#">
				  and cb.CBcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.vCuentaBancaria#">
				  and m.Mcodigo = cb.Mcodigo
			</cfquery>		
			<cfif isdefined('rsIdCuenta') and rsIdCuenta.recordCount GT 0>
				<cfset retCuenta = rsIdCuenta.CBid>
			<cfelse>
				<cfthrow message="#Arguments.InvokerName#: La Cuenta Bancaria '#FieldNameCuenta#' con el valor '#Arguments.vCuentaBancaria#' y perteneciente al Banco con codigo: '#Arguments.vCodBanco#' no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfif isdefined('rsIdCuenta') and rsIdCuenta.Miso4217 NEQ Arguments.vCodigoMoneda>
				<cfthrow message="#Arguments.InvokerName#: La Cuenta Bancaria '#FieldNameCuenta#' con el valor '#Arguments.vCuentaBancaria#' tiene la moneda : '#rsIdCuenta.Miso4217#' y la transaccion especifica '#Arguments.vCodigoMoneda#'">
			</cfif>
		<cfelse>
			<cfthrow message="#Arguments.InvokerName#: El Banco '#FieldName#' con el valor '#Arguments.vCodBanco#' no existe en la Base de Datos. Proceso Cancelado!">		
		</cfif>
		<cfreturn retCuenta>
	</cffunction>	
	
	<cffunction access="private" name="getTipoCambio" output="false" returntype="numeric">
		<cfargument name="vMcodigo" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		<!--- Fecha del documento para busqueda de tipo de cambio --->
		<cfargument name="vDfecha" required="no" type="string">
		<cfset var retTC = 1>
		<cfif isdefined('Arguments.vDfecha') and len(trim(Arguments.vDfecha))>
			<cfset lvDfecha = Arguments.vDfecha>
		<cfelse>
			<cfset lvDfecha = Now()>
		</cfif> 
		<cfquery name="TransfiereCodigoMoneda" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.vMcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
		</cfquery> 
		<cfquery name="rsMaxFecha" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select max(Hfecha) as maxFecha
			from Htipocambio
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TransfiereCodigoMoneda.Mcodigo#">
			and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lvDfecha#">
		</cfquery>		
		<cfif isdefined('rsMaxFecha') and rsMaxFecha.recordCount GT 0>
			<cfquery name="rsTC" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				select TCcompra
				from Htipocambio
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TransfiereCodigoMoneda.Mcodigo#">
				and Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#rsMaxFecha.maxFecha#">
			</cfquery>			
		</cfif>
		<cfif isdefined('rsTC') and rsTC.recordCount GT 0 and rsTC.TCcompra GT 0>
			<cfset retTC = rsTC.TCcompra>
		</cfif>
		<cfreturn retTC>
	</cffunction>

	<cffunction access="private" name="getBT_vIntegridad" output="false" returntype="string">
		<cfargument name="vBT" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">   <!---- Nombre del campo ---->		
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		<cfif len(trim(Arguments.vBT)) EQ 0 or Arguments.vBT EQ '~'>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro '#Arguments.Name#' es Requerido. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.vBT)>
	</cffunction>

	<!--- Valida que el campo no sea vacío --->
	<cffunction access="private" name="getNotNull_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="string"> 	<!---- Campo en minisif ----->
		<cfargument name="Name" required="yes" type="string">   <!---- Nombre del campo ---->
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		<cfif len(trim(Arguments.Value)) EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro #Arguments.Name# es Requerido y no puede ser vac&iacute;o. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>

	<!--- Validación del periodo, que exista y sea valido --->
	<cffunction access="private" name="getETperiodo" output="false" returntype="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			and Pcodigo=50
		</cfquery>				
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del Periodo no existe en la tabla 'Parametros'. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Pvalor>
	</cffunction>

	<!--- Validación del mes, que exista y sea valido --->
	<cffunction access="private" name="getETmes" output="false" returntype="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			and Pcodigo=60
		</cfquery>				
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del Mes no existe en la tabla 'Parametros'. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Pvalor>
	</cffunction>		

	<!---  Recupera el tipo de transaccion --->
	<cffunction name="transaccion" access="private" returntype="query">
		<cfargument name="pcodigo" type="numeric" required="true" default="0">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rsTransaccion" datasource="#Request.CM_InterfazTransferencias.GvarConexion#" >
			select 
			<cf_dbfunction name="to_number" args="a.Pvalor"> as Pvalor, 
			b.BTdescripcion		
			from Parametros a, BTransacciones b 		
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pcodigo#">
			  and a.Mcodigo='MB'
			  and a.Ecodigo=b.Ecodigo
			  and b.BTid=<cf_dbfunction name="to_number" args="a.Pvalor">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del Tipo de Transaccion con el codigo '#Arguments.pcodigo#' no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn #rsTransaccion#>
	</cffunction>

	<!--- Aplicar mascara para procesamiento contable --->
	<cffunction access="private" name="CGAplicarMascara"  output="false" returntype="string">
		<cfargument name="formato" required="yes" type="string">
		<cfargument name="complemento" required="yes" type="string">
		<cfset contador = 0>
		<cfloop condition="#Find('?',formato)#">
			<cfset contador = contador + 1>
			<cfif len(Mid(complemento,contador,1))>
				<cfset formato = replace(formato,'?',Mid(complemento,contador,1))>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn formato>
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaCostoConcepto
		Resultado:
			Devuelve el id de cuenta contable asciado al Concepto/Servicio con los comodines
	--->
	<cffunction access="private" name="obtieneCuentaCostoConcepto" output="false" returntype="string">
		<cfargument name="LparamCodCid"        required="yes" type="string">
		<cfargument name="LparamCuentaBanco"   required="yes" type="string">
		<cfargument name="LparamModulo"        required="yes" type="string">
		<cfargument name="metodoInvocador"     required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<!--- 1. Obtiene el Formato --->
		<cfquery name="data" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select Cformato as Formato
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.LparamCodCid#">
		</cfquery>
		<cfif data.recordcount eq 0 >
			<cfthrow message="#Arguments.metodoInvocador#: No ha sido definida la contra cuenta contable para el concepto #arguments.LparamCodCid#. Proceso Cancelado!">
		</cfif>
		<!--- 2. Obtiene el complemento del Socio --->
		<cfquery name="rsCuentaBancaria" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select CBcc as cuentac
			from CuentasBancos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			  and CBcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.LparamCuentaBanco#">
		</cfquery>
		<cfif rsCuentaBancaria.recordcount eq 0 >
			<cfthrow message="#Arguments.metodoInvocador#: No ha sido definido el complemento de la cuenta bancaria #arguments.LparamCuentaBanco#. Proceso Cancelado!">
		</cfif>
		<!--- 3.Aplica Máscara --->
		<cfset LvarFormato = data.Formato>
		<cfif len(trim(rsCuentaBancaria.cuentac))>
			<cfset LvarFormato = CGAplicarMascara(LvarFormato, rsCuentaBancaria.cuentac)>
		</cfif>
		<cfif Find('?',LvarFormato) GT 0>
			<cfthrow message="Error! No se pudo determinar la contra cuenta contable! Proceso Cancelado!">
		</cfif>
		<!--- 4. Genera Cuenta Financiera --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(LvarFormato,4)#"/>							
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(LvarFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Conexion" value="#Request.CM_InterfazTransferencias.GvarConexion#"/>
			<cfinvokeargument name="ecodigo" value="#Request.CM_InterfazTransferencias.GvarEcodigo#"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Cuenta #LvarFormato#: #LvarERROR#">
		</cfif>
		<!--- 5. Obtiene la Cuenta Asociada al Formato de Cuenta Financiera --->
		<cfquery name="rsCuenta" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select Ccuenta
			from CFinanciera
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
			and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarFormato#">
		</cfquery>
		<cfif len(trim(rsCuenta.Ccuenta))>
			<cfset LRetCcuenta = rsCuenta.Ccuenta>
		<cfelse>
			<cfthrow message="Cuenta #LvarFormato#: Cuenta Inválida! Proceso Cancelado!">
		</cfif>
		<cfreturn LRetCcuenta >
	</cffunction>


	<!--- **************************************ESTIMACION************************************************************ --->
	<cffunction name="Aplica_TransferenciaEstimacion" access="public" returntype="boolean">
		<cfargument name="CodigoBancoOrigen" type="string" required="true">
		<cfargument name="CuentaBancariaOrigen" type="string" required="true">
		<cfargument name="TipoMovimientoOrigen" type="string" required="true">
		<cfargument name="CodigoMonedaOrigen" type="string" required="true">
		<cfargument name="MontoOrigen" type="string" required="true">
		<cfargument name="MontoComision" type="string" required="true">
		<cfargument name="CodigoBancoDestino" type="string" required="true">
		<cfargument name="CuentaBancariaDestino" type="string" required="true">
		<cfargument name="TipoMovimientoDestino" type="string" required="true">
		<cfargument name="CodigoMonedaDestino" type="string" required="true">
		<cfargument name="MontoDestino" type="string" required="true">
		<cfargument name="FechaValor" type="string" required="true">
		<cfargument name="Observacion" type="string" required="true">
		<cfargument name="FechaAplicacion" type="string" required="true">
		<cfargument name="ConceptoComision" type="string" required="true">
		<cfargument name="Estimacion" type="string" required="true">
		<cfargument name="BMUsucodigo" type="string" required="true">
		<cfargument name="IndMovConta" type="string" required="no" default="0">
		<cfargument name="NumeroDocumento" type="string" requiered="no" default="0">
		<cfargument name="Debug" type="boolean" required="no" default="false">
		<cfif len(trim(TipoMovimientoDestino)) eq 0>
			<cfthrow message="Aplica_Transferencia. El Tipo de Movimiento Destino está vacio. Proceso Cancelado!">
		</cfif>
		<cfset lvarEstimacion = 0>
		<cfset lvarEtiqueta = "Intereses">
		<cfif (isdefined('Arguments.TipoMovimientoDestino') and Arguments.TipoMovimientoDestino eq "CB")>
			<cfset lvarEtiqueta = "Comisiones">
		<cfelseif (isdefined('Arguments.TipoMovimientoDestino') and Arguments.TipoMovimientoDestino eq "IV")>
			<cfset lvarEtiqueta = "IVA comision bancaria">
		</cfif>
		
		<cfif (isdefined('Arguments.IndMovConta') and Arguments.IndMovConta eq "1") or Arguments.Estimacion eq "1">
			<cfset lvarEstimacion = 1>
			<cfset lvarEtiqueta = "Intereses No Devengados">
		</cfif>
		<cfif isdefined('Arguments.NumeroDocumento') and len(trim(Arguments.NumeroDocumento))>
			<cfset lvarDocumento = Arguments.NumeroDocumento>
			<cfset lvarDescripcionAsiento = "Bancos: " & trim(lvarEtiqueta) & " - " & trim(#Arguments.NumeroDocumento#) & " - " & trim(#Arguments.Observacion#)>
		<cfelse>
			<cfset lvarDocumento = lvarEtiqueta>
			<cfset lvarDescripcionAsiento = "Bancos: " & trim(lvarEtiqueta) & " - " & trim(#Arguments.Observacion#)>
		</cfif>
		<!---
			Validar que las transacciones de Origen y Destino sean consistentes 
			Esto es:  La transaccion origen y la destino deben tener movimientos diferentes (Debito / Credito)
		--->
		<cfquery name="rsExiste" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select count(1) as rcount
			from Empresas e, BTransacciones t1, BTransacciones t2 
			where e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazTransferencias.GvarEcodigoSDC#">
				and t1.Ecodigo = e.Ecodigo
				and t1.BTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoMovimientoOrigen#">
				and t1.Ecodigo = e.Ecodigo
				and t2.BTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoMovimientoDestino #">
				and t1.BTtipo = t2.BTtipo
		</cfquery>
		<cfif rsExiste.rcount gt 0>
			<cfthrow message="Aplica_TransferenciaEstimacion. Los movimientos están incorrectos. Proceso Cancelado!">
		</cfif>
		<!---  Creación de la tabla INTARC ---->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />
		<!---  Cuentas contables de la cuenta Origen  --->
		<cfif len(Arguments.MontoOrigen) and len(trim(Arguments.CodigoBancoOrigen)) and len(trim(Arguments.CuentaBancariaOrigen))>
			<cfquery datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				insert #INTARC#
					(INTORI, INTREL, INTDOC, INTREF, 
					INTMON, INTTIP, INTDES, INTFEC, 
					INTCAM, 
					Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, 
					INTMOE)
				select
					'ESBA', 0, <cfqueryparam cfsqltype="cf_sql_char" value="#lvarDocumento#"> ,<cfqueryparam cfsqltype="cf_sql_char" value="#lvarEtiqueta#"> ,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoOrigen#">, 
					t1.BTtipo, 
					<cfif len(trim(arguments.Observacion))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observacion#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_char" value="#lvarEtiqueta#">
					</cfif>,  
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Arguments.FechaAplicacion,'yyyymmdd')#">, 
					coalesce(
						(select max(TCcompra) from Htipocambio tc 
						where tc.Ecodigo = e.Ecodigo 
							and tc.Mcodigo = c.Mcodigo 
							and tc.Hfecha = (select max(Hfecha) from Htipocambio tc1
							where tc1.Ecodigo = e.Ecodigo
								and tc1.Mcodigo = c.Mcodigo
								and tc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaValor#">)
						), 1.0),
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Year(Arguments.FechaAplicacion)#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Month(Arguments.FechaAplicacion)#">, 
					<cfif lvarEstimacion eq 1>
						coalesce(c.Ccuentaint,
					</cfif>
				
						c.Ccuenta
					
					<cfif lvarEstimacion eq 1>
						)
					</cfif>
					
					, c.Mcodigo, c.Ocodigo, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoOrigen#">
				from Empresas e, BTransacciones t1, Bancos b, CuentasBancos c
				where e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazTransferencias.GvarEcodigoSDC#">
					and t1.Ecodigo = e.Ecodigo
					and t1.BTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoMovimientoOrigen#">
					and b.Ecodigo = e.Ecodigo
					and b.Iaba = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoBancoOrigen#">
					and c.Bid = b.Bid
					and c.CBcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CuentaBancariaOrigen#">
			</cfquery>
		</cfif>
		<!--- Cuentas contables de la cuenta origen. Comision cobrada --->
		<cfif len(Arguments.MontoComision) and len(trim(Arguments.CodigoBancoOrigen)) and len(trim(Arguments.CuentaBancariaOrigen))>
			<cfquery datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				insert #INTARC# 
					(INTORI, INTREL, INTDOC, INTREF, 
					INTMON, INTTIP, INTDES, INTFEC, 
					INTCAM, 
					Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, 
					INTMOE)
				select
					'ESBA', 0, <cfqueryparam cfsqltype="cf_sql_char" value="#lvarDocumento#"> ,<cfqueryparam cfsqltype="cf_sql_char" value="#lvarEtiqueta#"> ,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoComision#">, 
					t1.BTtipo, 
					<cfif len(trim(arguments.Observacion))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observacion#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_char" value="#lvarEtiqueta#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Arguments.FechaAplicacion,'yyyymmdd')#">, 
					coalesce(
						(select max(TCcompra) from Htipocambio tc 
						where tc.Ecodigo = e.Ecodigo 
							and tc.Mcodigo = c.Mcodigo 
							and tc.Hfecha = (select max(Hfecha) from Htipocambio tc1
							where tc1.Ecodigo = e.Ecodigo
								and tc1.Mcodigo = c.Mcodigo
								and tc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaValor#">)
						), 1.0),
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Year(Arguments.FechaAplicacion)#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Month(Arguments.FechaAplicacion)#">, 
					c.Ccuentacom, c.Mcodigo, c.Ocodigo, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoComision#">
				from Empresas e, BTransacciones t1, Bancos b, CuentasBancos c
				where e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazTransferencias.GvarEcodigoSDC#">
					and t1.Ecodigo = e.Ecodigo
					and t1.BTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoMovimientoOrigen#">
					and b.Ecodigo = e.Ecodigo
					and b.Iaba = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoBancoOrigen#">
					and c.Bid = b.Bid
					and c.CBcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CuentaBancariaOrigen#">
			</cfquery>
		</cfif>
		<!---  Cuentas contables de la cuenta destino --->
		<cfif len(Arguments.MontoDestino)>
			<cfquery datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				insert #INTARC# 
					(INTORI, INTREL, INTDOC, INTREF, 
					INTMON, INTTIP, INTDES, INTFEC, 
					INTCAM, 
					Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, 
					INTMOE)
				select
					'ESBA', 0, <cfqueryparam cfsqltype="cf_sql_char" value="#lvarDocumento#"> ,<cfqueryparam cfsqltype="cf_sql_char" value="#lvarEtiqueta#"> ,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoDestino#">, 
					t1.BTtipo, 
					<cfif len(trim(arguments.Observacion))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observacion#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_char" value="#lvarEtiqueta#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Arguments.FechaAplicacion,'yyyymmdd')#">, 
					coalesce(
						(select max(TCcompra) from Htipocambio tc 
						where tc.Ecodigo = e.Ecodigo 
							and tc.Mcodigo = c.Mcodigo 
							and tc.Hfecha = (select max(Hfecha) from Htipocambio tc1
							where tc1.Ecodigo = e.Ecodigo
								and tc1.Mcodigo = c.Mcodigo
								and tc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaValor#">)
						), 1.0),
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Year(Arguments.FechaAplicacion)#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Month(Arguments.FechaAplicacion)#">, 
					
					<cfif lvarEstimacion eq 1>
						coalesce(c.Ccuentaint,
					</cfif>
					c.Ccuenta
					<cfif lvarEstimacion eq 1>
						)
					</cfif>
					
					, c.Mcodigo, c.Ocodigo, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoDestino#">
				from Empresas e, BTransacciones t1, Bancos b, CuentasBancos c
				where e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazTransferencias.GvarEcodigoSDC#">
					and t1.Ecodigo = e.Ecodigo
					and t1.BTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoMovimientoDestino#">
					and b.Ecodigo = e.Ecodigo
					and b.Iaba = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoBancoDestino#">
					and c.Bid = b.Bid
					and c.CBcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CuentaBancariaDestino#">
			</cfquery>
		</cfif>
		<!---  Cuentas contables de la cuenta de comision cuando la cuenta origen es nula --->
		<cfif len(Arguments.MontoDestino) gt 0 and len(trim(CuentaBancariaOrigen)) eq 0>

			<cfset LvarCuentaConcepto = obtieneCuentaCostoConcepto(Arguments.ConceptoComision, Arguments.CuentaBancariaDestino, "CuentaComision", "Aplica_TransferenciaEstimacion")>

			<cfif len(LvarCuentaConcepto) eq 0>
				<cfthrow message="Aplica_TransferenciaEstimacion. Error generando la cuenta del concepto ' #Arguments.ConceptoComision# ' para la cuenta ' #Arguments.cuentaBancariaDestino# '!">			
			</cfif> 

			<cfquery datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
					insert #INTARC# (
						INTORI, 
						INTREL, 
						INTDOC, 
						INTREF, 
						INTMON, 
						INTTIP, 
						INTDES, 
						INTFEC, 
						INTCAM, 
						Periodo, 
						Mes, 
						Ccuenta, 
						Mcodigo, 
						Ocodigo, 
						INTMOE)
					
					select 
						'ESBA', 
						0, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#lvarDocumento#"> ,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarEtiqueta#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoDestino#">, 
						case when t1.BTtipo = 'D' then 'C' else 'D' end, 
						<cfif len(trim(arguments.Observacion))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observacion#">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarEtiqueta#">
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Arguments.FechaAplicacion,'yyyymmdd')#">, 
						coalesce(
								(select max(TCcompra) from Htipocambio tc 
								where tc.Ecodigo = e.Ecodigo 
									and tc.Mcodigo = c.Mcodigo 
									and tc.Hfecha = (select max(Hfecha) from Htipocambio tc1
									where tc1.Ecodigo = e.Ecodigo
										and tc1.Mcodigo = c.Mcodigo
										and tc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaValor#">)
								), 1.0),
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Year(Arguments.FechaAplicacion)#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Month(Arguments.FechaAplicacion)#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaConcepto#">,
						c.Mcodigo,
						c.Ocodigo, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.MontoDestino#">
					from Empresas e, BTransacciones t1, Bancos b, CuentasBancos c
					where e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazTransferencias.GvarEcodigoSDC#">
					  and t1.Ecodigo = e.Ecodigo
					  and t1.BTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoMovimientoDestino#">
					  and b.Ecodigo = e.Ecodigo
					  and b.Iaba = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoBancoDestino#">
					  and c.Bid = b.Bid
					  and c.CBcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CuentaBancariaDestino#">
			</cfquery>

		</cfif>
		<!---- Carga del periodo --->
		<cfquery name="rsPeriodo" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
			from Parametros
			Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
				and Mcodigo = 'GN'
				and Pcodigo = 50		
		</cfquery>			
		<cfif isdefined("rsPeriodo")>
			<cfset Periodo =  rsPeriodo.Periodo>
		<cfelse>
			<cfthrow message="Aplica_TransferenciaEstimacion. No se ha definido el Periodo de Auxiliares. Proceso Cancelado!">
		</cfif>
		<!---- Carga del mes --->
		<cfquery name="rsMes" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
			from Parametros
			Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazTransferencias.GvarEcodigo#">
				and Mcodigo = 'GN'
				and Pcodigo = 60		
		</cfquery>			
		<cfif isdefined("rsMes")>
			<cfset Mes =  rsMes.Mes>			
		<cfelse>
			<cfthrow message="Aplica_TransferenciaEstimacion. No se ha definido el Mes de Auxiliares. Proceso Cancelado!">
		</cfif>

		<!--- Transforma las lineas de Impuesto a moneda local --->
		<cfquery datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			update #INTARC#
			set INTMOE  = round(INTMOE * INTCAM, 2)
			  , INTCAM	= 1
			  , INTMON  = round(INTMOE * INTCAM, 2)
			  , Mcodigo	= (select Mcodigo from Empresas where Ecodigo = #session.Ecodigo#)
			where INTDES = 'IVA comision bancaria'
		</cfquery>

		<!--- Actualizar el campo de monto en moneda local de acuerdo con el tipo de cambio --->
		<cfquery name="rsINTARCPre" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
			select count(1) as Cantidad
			from #INTARC#
		</cfquery>
		<cfset IDcontable = 0>
		<!--- Generar el asiento con GeneraAsiento desde INTARC  --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
			<cfinvokeargument name="Ecodigo" value="#Request.CM_InterfazTransferencias.GvarEcodigo#"/>
			<cfinvokeargument name="Conexion" value="#Request.CM_InterfazTransferencias.GvarConexion#"/>
			<cfinvokeargument name="Oorigen" value="ESBA"/>
			<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
			<cfinvokeargument name="Emes" value="#Mes#"/>
			<cfinvokeargument name="Efecha" value="#Arguments.FechaValor#"/>
			<cfinvokeargument name="Edescripcion" value="#lvarDescripcionAsiento#"/>
			<cfinvokeargument name="Edocbase" value="null"/>
			<cfinvokeargument name="Ereferencia" value="null"/>
			<cfinvokeargument name="debug" value="0"/>
		</cfinvoke>
		<cfif IDcontable LT 1>
			<cfquery name="rsINTARCPost" datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				select count(1) as Cantidad
				from #INTARC#
			</cfquery>
			<cfthrow message="Aplica_TransferenciaEstimacion. Error al procesar la póliza No. #IDcontable#- Registros: #rsINTARCPost.Cantidad# de #rsINTARCPre.Cantidad#. Proceso Cancelado!">
		</cfif>
		<cfif lvarEstimacion eq 1>
			<!--- Ajustar los registros en INTARC --->
			<cfquery datasource="#Request.CM_InterfazTransferencias.GvarConexion#">
				update #INTARC#
				set 
					INTDES  = 'Reversion Estimación: ' || INTDES,
					Periodo = case when Mes = 12 then Periodo + 1 else Periodo end,
					Mes     = case when Mes = 12 then 1 else Mes + 1 end,
					INTTIP  = case when INTTIP = 'D' then 'C' else 'D' end 
			</cfquery>
			<cfset IDcontable = 0>
			<cfset lvarMes = Mes + 1>
			<cfset lvarPeriodo = Periodo>
			<cfif lvarMes GT 12>
				<cfset lvarMes = 1>
				<cfset lvarPeriodo = lvarPeriodo + 1>
			</cfif>
			<cfset LvarFechaValorsigMes = CreateDate(LvarPeriodo,LvarMes,01)>
			<!--- Generar el asiento con GeneraAsiento desde INTARC  --->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
				<cfinvokeargument name="Ecodigo" value="#Request.CM_InterfazTransferencias.GvarEcodigo#"/>
				<cfinvokeargument name="Conexion" value="#Request.CM_InterfazTransferencias.GvarConexion#"/>
				<cfinvokeargument name="Oorigen" value="ESBA"/>
				<cfinvokeargument name="Eperiodo" value="#lvarPeriodo#"/>
				<cfinvokeargument name="Emes" value="#lvarMes#"/>
				<cfinvokeargument name="Efecha" value="#LvarFechaValorsigMes#"/>
				<cfinvokeargument name="Edescripcion" value="#lvarDescripcionAsiento#"/>
				<cfinvokeargument name="Edocbase" value="null"/>
				<cfinvokeargument name="Ereferencia" value="null"/>
				<cfinvokeargument name="debug" value="#Arguments.debug#"/>
			</cfinvoke>
			<cfif IDcontable LT 1>
				<cfthrow message="Aplica_TransferenciaEstimacion. Error al procesar la póliza. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif Arguments.debug>
			<cfthrow message="Aplica_TransferenciaEstimacion. Todo Finálizó con Éxito, pero esta en Modo DEBUG.">
		</cfif>
		<cfreturn true>
	</cffunction>
</cfcomponent>
