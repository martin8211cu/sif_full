<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: Define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="EcodigoSDC" required="no" type="numeric" default="0">
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
			</cfquery>
			<!---- Si existe el Ecodigo en minisif ----->
			<cfif rsEcodigo.recordcount NEQ 0 and rsEcodigo.Ereferencia NEQ ''>
				<cfset Arguments.Ecodigo = rsEcodigo.Ereferencia>
			<cfelse>
				<cf_errorCode	code = "50851" msg = "CM_InterfazSociosNegocio: El valor del parámetro EcodigoSDC no existe. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Request.CM_InterfazSociosNegocio.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazSociosNegocio.Initialized = true>
			<cfset Request.CM_InterfazSociosNegocio.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazSociosNegocio.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazSociosNegocio.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazSociosNegocio.GvarUsulogin = Arguments.Usulogin>
			<cfset Request.CM_InterfazSociosNegocio.GvarUsuario = Arguments.Usuario>
			<cfset Request.CM_InterfazSociosNegocio.GvarFecha = Arguments.Fecha>	
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
		<cfset Request.CM_InterfazSociosNegocio.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazSociosNegocio.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazSociosNegocio.GvarUsuario = Arguments.Usuario>
		<cfset Request.CM_InterfazSociosNegocio.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazSociosNegocio.GvarUsulogin = Arguments.Usulogin>				
		<cfset Request.CM_InterfazSociosNegocio.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>

	<!--- Funcion para insertar el encabezado de Transferencias en la tabla ETraspasos --->
	<cffunction name="Alta_ETransferencias" access="public" returntype="numeric">	
		<cfargument name="ETdescripcion" type="string" required="true">
		<cfargument name="ETfecha" type="string" required="false">
		<cfargument name="BMUsucodigo" type="string" required="false">

		<!--- "getNotNull_vIntegridad" -- Valida que los campos (requeridos) no sean nulos (vacios) antes de insertar. --->
		<cfset var vETperiodo = getETperiodo('Alta_ETransferencias')>
		<cfset var vETmes = getETmes('Alta_ETransferencias')>		
		<cfset var vETdescripcion = getNotNull_vIntegridad(Arguments.ETdescripcion,'Descripcion','Alta_ETransferencias')>
		<cfset var vETfecha = Request.CM_InterfazSociosNegocio.GvarFecha>
		<cfif isdefined('Arguments.ETfecha') and len(trim(Arguments.ETfecha))>
			<cfset vETfecha = Arguments.ETfecha>				
		</cfif>
		
		<!--- Insertar. Alta en ETraspasos --->
		<cfquery name="insertTrasp" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			insert into ETraspasos( Ecodigo, ETperiodo, ETmes, ETusuario, ETdescripcion, ETfecha, BMUsucodigo)
						 values ( <cfqueryparam value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#"    cfsqltype="cf_sql_integer">,
								  <cfqueryparam value="#vETperiodo#"	 cfsqltype="cf_sql_integer">,
								  <cfqueryparam value="#vETmes#"         cfsqltype="cf_sql_integer">, 
								  <cfqueryparam value="#Request.CM_InterfazSociosNegocio.GvarUsuario#"    cfsqltype="cf_sql_varchar">,
								  <cfqueryparam value="#vETdescripcion#" cfsqltype="cf_sql_varchar">,
								  <cfqueryparam value="#vETfecha#" cfsqltype="cf_sql_timestamp">,
								<cfif isdefined("Arguments.BMUsucodigo") and Arguments.BMUsucodigo NEQ ''>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">,
								<cfelse>
									null,						
								</cfif>									  
								)
			<cf_dbidentity1 datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
		</cfquery>	
		<cf_dbidentity2 datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#" name="insertTrasp">

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
		<cfargument name="BMUsucodigo" type="string" required="false">
<!--- 		<cfargument name="CodigoMonedaDestino" type="string" required="true">				 --->

		<!--- "getNotNull_vIntegridad" -- Valida que los campos (requeridos) no sean nulos (vacios) antes de insertar. --->
		<cfset var vDTmontoori = 0>		
		<cfset var vDTmontodest = 0>				
		<cfset var vTCambio = 0>
		<cfset var vDTmontolocal = 0>		
		<cfset var vDTmontocomori = 0>	
		<cfset var vDTmontocomloc = 0>
		<cfset var vDTtipocambiof = 0>				
		<cfset var vBTidori = '~'>
		<cfset var vBTiddest = '~'>
		<cfset rsMovimiento = transaccion(160,'Alta_ETransferencias')>		
		
		<cfif isdefined('rsMovimiento') and rsMovimiento.recordCount GT 0>
			<cfset vBTidori = rsMovimiento.Pvalor>				
			<cfset vBTiddest = rsMovimiento.BTdescripcion>
		</cfif>
		<cfset vBTidori = getBT_vIntegridad(vBTidori,'BTidori','Alta_ETransferencias')>		
		<cfset vBTiddest = getBT_vIntegridad(vBTiddest,'BTiddest','Alta_ETransferencias')>				
		<cfif isdefined('Arguments.MontoOrigen') and len(trim(Arguments.MontoOrigen)) and Arguments.MontoOrigen GT 0>
			<cfset vDTmontoori = Arguments.MontoOrigen>				
		</cfif>		
		<cfif isdefined('Arguments.MontoDestino') and len(trim(Arguments.MontoDestino)) and Arguments.MontoDestino GT 0>
			<cfset vDTmontodest = Arguments.MontoDestino>				
		</cfif>		
		<cfif isdefined('Arguments.CodigoMonedaOrigen') and len(trim(Arguments.CodigoMonedaOrigen))>
			<cfset vTCambio = getTipoCambio(Arguments.CodigoMonedaOrigen,'Alta_ETransferencias')>				
			<cfset var vDTmontolocal = vTCambio * vDTmontoori>
		</cfif>
		<cfif isdefined('Arguments.MontoComision') and len(trim(Arguments.MontoComision)) and Arguments.MontoComision GT 0>
			<cfset vDTmontocomori = Arguments.MontoComision>				
			<cfset vDTmontocomloc = vTCambio * vDTmontocomori>							
		</cfif>		
		<cfif vDTmontoori GT 0>
			<cfset var vDTtipocambiof = vDTmontodest/vDTmontoori>
		</cfif>		
		
		<!--- Insertar. Alta en DTraspasos --->
		<cfquery name="insertTrasp" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			insert into DTraspasos ( ETid, CBidori, CBiddest, BTidori, BTiddest, DTmontoori, DTmontodest, DTmontolocal, DTmontocomori,
						DTmontocomloc, DTdocumento, DTreferencia, DTtipocambio, DTtipocambiof, BMUsucodigo) 
		   values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CuentaBancariaOrigen#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CuentaBancariaDestino#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vBTidori#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vBTiddest#">,
					<cfqueryparam cfsqltype="cf_sql_money"   value="#vDTmontoori#">,
					<cfqueryparam cfsqltype="cf_sql_money"  value="#vDTmontodest#">,
					<cfqueryparam cfsqltype="cf_sql_money"  value="#vDTmontolocal#">,
					<cfqueryparam cfsqltype="cf_sql_money"  value="#vDTmontocomori#">,
					<cfqueryparam cfsqltype="cf_sql_money"  value="#vDTmontocomloc#">,
					<cfqueryparam cfsqltype="cf_sql_char"    value="#***#">,DTdocumento
					null,
					<cfqueryparam cfsqltype="cf_sql_float"   value="#vTCambio#">,
El TC lo estoy calculando con el 
codigo de la moneda origen					
					<cfqueryparam cfsqltype="cf_sql_float"   value="#vDTtipocambiof#">
					
					)
		</cfquery>		

		<cfif isdefined('insertTrasp') and insertTrasp.identity NEQ ''>
			<cfreturn insertTrasp.identity>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>								
	
	
	<!--- Funcion para la aplicacion de las Transferencias --->
	<cffunction name="Aplica_Transferencia" access="public" returntype="boolean">
		<cfargument name="ETid" type="string" required="true">

		<cfif len(trim(Arguments.ETid))>
			<cfinvoke component="sif.Componentes.CP_MBPosteoTransferencias" method="PosteoTransferencias">
				<cfinvokeargument name="Ecodigo" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#"/>
				<cfinvokeargument name="ETid" value="#Arguments.ETid#"/>
				<cfinvokeargument name="usuario" value="#Request.CM_InterfazSociosNegocio.GvarUsuario#"/>	
				<cfinvokeargument name="LoginUsuario" value="#Request.CM_InterfazSociosNegocio.GvarUsulogin#"/>		
				<cfinvokeargument name="debug" value="N"/>							
			</cfinvoke>			
		<cfelse>
			<cf_errorCode	code = "50845"
							msg  = "Aplica_Transferencia: El valor del parámetro 'ETid=@errorDat_1@' es inválido. Proceso Cancelado!"
							errorDat_1="#Arguments.ETid#"
			>		
		</cfif>
		
		<cfreturn true>
	</cffunction>	
	

<!---****************  FUNCIONES DE VALIDACIÓN  *******************---->
	<!--- Se validan los campos necesarios para hacer cualquier modificación en la base de datos de SIF --->
	<cffunction access="private" name="getTipoCambio" output="false" returntype="numeric">
		<cfargument name="vMcodigo" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		<cfset var retTC = 0>
		
		<cfquery name="rsMaxFecha" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select max(Hfecha) as maxFecha
			from Htipocambio
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.vMcodigo#">
			and Hfecha <= <cf_dbfunction name='now'>
		</cfquery>		
		
		<cfif isdefined('rsMaxFecha') and rsMaxFecha.recordCount GT 0>
			<cfquery name="rsTC" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
				select TCventa
				from Htipocambio
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.vMcodigo#">
				and Hfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsMaxFecha.maxFecha#">
			</cfquery>			
		</cfif>
		
		<cfif isdefined('rsTC') and rsTC.recordCount GT 0 and rsTC.TCventa GT 0>
			<cfset retTC = rsTC.TCventa>
		</cfif>
		
		<cfreturn retTC>
	</cffunction>


	<cffunction access="private" name="getBT_vIntegridad" output="false" returntype="string">
		<cfargument name="vBT" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">   <!---- Nombre del campo ---->		
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		
		<cfif len(trim(Arguments.vBT)) EQ 0 or Arguments.vBT EQ '~'>
			<cf_errorCode	code = "50846"
							msg  = "@errorDat_1@: El valor del parámetro '@errorDat_2@' es Requerido. Proceso Cancelado!"
							errorDat_1="#Arguments.InvokerName#"
							errorDat_2="#Arguments.Name#"
			>
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
			<cf_errorCode	code = "50846"
							msg  = "@errorDat_1@: El valor del parámetro @errorDat_2@ es Requerido y no puede ser vacío. Proceso Cancelado!"
							errorDat_1="#Arguments.InvokerName#"
							errorDat_2="#Arguments.Name#"
			>
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>
		
	<!--- Validación del periodo, que exista y sea valido --->
	<cffunction access="private" name="getETperiodo" output="false" returntype="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		
		<cfquery name="rs" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
			and Pcodigo=50
		</cfquery>				
		
		<cfif rs.RECORDCOUNT GT 0>
			<cf_errorCode	code = "50848"
							msg  = "@errorDat_1@: El valor del Periodo no existe en la tabla 'Parametros'. Proceso Cancelado!"
							errorDat_1="#Arguments.InvokerName#"
			>
		</cfif>
		<cfreturn rs.Pvalor>
	</cffunction>
			
	<!--- Validación del mes, que exista y sea valido --->
	<cffunction access="private" name="getETmes" output="false" returntype="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		
		<cfquery name="rs" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
			and Pcodigo=60
		</cfquery>				
		
		<cfif rs.RECORDCOUNT GT 0>
			<cf_errorCode	code = "50849"
							msg  = "@errorDat_1@: El valor del Mes no existe en la tabla 'Parametros'. Proceso Cancelado!"
							errorDat_1="#Arguments.InvokerName#"
			>
		</cfif>
		<cfreturn rs.Pvalor>
	</cffunction>		

	<!---  Recupera el tipo de transaccion --->
	<cffunction name="transaccion" access="private" returntype="query">
		<cfargument name="pcodigo" type="numeric" required="true" default="0">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		
		<cfquery name="rsTransaccion" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#" >
			select 
			<cf_dbfunction name="to_number" args="a.Pvalor"> as Pvalor, 
			b.BTdescripcion		
			from Parametros a, BTransacciones b 		
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
			  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pcodigo#">
			  and a.Mcodigo='MB'
			  and a.Ecodigo=b.Ecodigo
			  and b.BTid=<cf_dbfunction name="to_number" args="a.Pvalor">
		</cfquery>
		
		<cfif rs.RECORDCOUNT GT 0>
			<cf_errorCode	code = "50850"
							msg  = "@errorDat_1@: El valor del Tipo de Transaccion con el codigo '@errorDat_2@' no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.InvokerName#"
							errorDat_2="#Arguments.pcodigo#"
			>
		</cfif>
				
		<cfreturn #rsTransaccion#>
	</cffunction>


</cfcomponent>


