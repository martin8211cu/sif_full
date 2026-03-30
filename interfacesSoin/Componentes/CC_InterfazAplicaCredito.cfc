<cfcomponent>
	<!--- Métodos para inicializar y cambiar el contexto del componente
	     Init: Define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="EcodigoSDC" required="no" type="numeric" default="0">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Usulogin" required="no" type="string" default="#Session.Usulogin#">
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
				<cfthrow message="CM_InterfazNeteo: El valor del par&aacute;metro EcodigoSDC es incorrecto o no corresponde con el Código de Empresa de la Sesion. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Request.CC_InterfazAplicaCredito.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CC_InterfazAplicaCredito.Initialized = true>
			<cfset Request.CC_InterfazAplicaCredito.GvarConexion = Arguments.Conexion>
			<cfset Request.CC_InterfazAplicaCredito.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CC_InterfazAplicaCredito.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CC_InterfazAplicaCredito.GvarUsulogin = Arguments.Usulogin>
			<cfset Request.CC_InterfazAplicaCredito.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Usulogin" required="no" type="string" default="#Session.Usulogin#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CC_InterfazAplicaCredito.GvarConexion = Arguments.Conexion>
		<cfset Request.CC_InterfazAplicaCredito.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CC_InterfazAplicaCredito.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CC_InterfazAplicaCredito.GvarUsulogin = Arguments.Usulogin>
		<cfset Request.CC_InterfazAplicaCredito.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>

	<!--- Esta funcion sirve para aplicar el documento de neteo invocando el procedimiento de aplicación --->
	<cffunction name="Aplica_Documento" access="public" output="false" returntype="boolean">
		<cfargument name="idDocumentoNeteo" required="yes" type="string">

		<!--- 
			<cfset var Doc = getNotNull_vIntegridad(Arguments.idDocumentoNeteo,'idDocumentoNeteo','Aplica_Documento')>
			<cfinvoke 
				component="sif.Componentes.CC_AplicaDocumentoNeteo" 
				method="CC_AplicaDocumentoNeteo" 
				returnvariable="resultado"
				idDocumentoNeteo="#Arguments.idDocumentoNeteo#"
				/> 
		--->
		<cfreturn true>
	</cffunction>

	<!--- Esta funcion sirve para insertar el Encabezado del documento de Crédito en EFavor --->
	<cffunction name="Alta_DocumentoFavor" access="public" returntype="numeric">	
		<cfargument name="Modulo" type="string" required="true">
		<cfargument name="Moneda" type="string" required="true">
		<cfargument name="Transaccion" type="string" required="true">
		<cfargument name="Documento" type="string" required="true">
		<cfargument name="SocioExterno" type="string" required="true">
		<cfargument name="FechaAplicacion" type="string" required="yes">
		<cfargument name="MontoOrigen" type="numeric" required="yes">
		
		<cfset var Mcodigo = obtenerMoneda(getNotNull_vIntegridad(Arguments.Moneda,'Moneda','Alta_DocumentoFavor'))>
		<cfset var CodigoTrans = obtenerCodigoTrans(Arguments.Modulo, getNotNull_vIntegridad(Arguments.Transaccion,'CodigoTransaccionExterno','Alta_DocumentoFavor'))>
		<cfset var Socio = obtenerSocio(getNotNull_vIntegridad(Arguments.SocioExterno,'SocioExterno','Alta_DocumentoFavor'))>
		<cfset var DocumentoNC = validaDocumento(Modulo, Transaccion,Socio, getNotNull_vIntegridad(Arguments.Documento,'Documento','Alta_DocumentoFavor'),CodigoTrans) >		
		
		<cfif not isdate(Arguments.FechaAplicacion)>
			<cfset LvarFechaAplicacion = now()>
		<cfelse>
			<cfset LvarFechaAplicacion = Arguments.FechaAplicacion>
		</cfif>
		<cfset LvarEFtipoCambio = obtenerTipoCambio(Mcodigo, LvarFechaAplicacion, Arguments.Modulo )>
		
		<cfset LvarLoginUsuario = " ">
		<cfquery name="rsUsuarioLogin" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select Usulogin
			from Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CC_InterfazAplicaCredito.GvarUsucodigo#">
		</cfquery>
		
		<cfif rsUsuarioLogin.Recordcount GT 0>
			<cfset LvarLoginUsuario = rsUsuarioLogin.Usulogin>
		</cfif>

		<cfquery datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			insert into EFavor 
				(Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, EFtipocambio, EFtotal, EFfecha, EFusuario, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#CodigoTrans#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#DocumentoNC#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Socio#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#LvarEFtipocambio#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#MontoOrigen#">, <!---Monto Total--->
				<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaAplicacion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarLoginUsuario#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CC_InterfazAplicaCredito.GvarUsucodigo#">
				) 
		</cfquery>
		<cfreturn 0>
	</cffunction>
	<!--- Esta funcion sirve para insertar el Detalle del documento de Crédito en DFavor --->
	<cffunction name="Alta_DocumentoDet" access="public" returntype="boolean">	
		<cfargument name="Modulo" 					type="string" required="true">
		<cfargument name="CodigoTransaccionNC" 		type="string" required="true">
		<cfargument name="DocumentoOrig" 			type="string" required="true">
		<cfargument name="SocioExterno" 			type="string" required="true">
		<cfargument name="TransaccionFactura" 		type="string" required="true">
		<cfargument name="Documento" 				type="string" required="true">
		<cfargument name="CodigoMonedaDestino"		type="string" required="true">
		<cfargument name="Monto" 					type="numeric" required="true">
		<cfargument name="MontoNC"					type="numeric" required="yes">
		
		<cfset var ModuloIns             = "">
		<cfset var CodigoTransNC         = "">
		<cfset var CodigoTransFactura    = "">
		<cfset var Socio                 = "">
		<cfset var Dmonto                = "">
		<cfset var DmontoNC              = "">
		<cfset var Ddocumento            = "">
		
		<!--- Valida si existen los campos antes de insertar. --->
		<cfset ModuloIns          = getNotNull_vIntegridad(Arguments.Modulo,'Modulo','Alta_DocumentoDet')>
		<cfset CodigoTransNC      = obtenerCodigoTrans(ModuloIns, getNotNull_vIntegridad(Arguments.CodigoTransaccionNC,'CodigoTransaccionNC','Alta_DocumentoDet'))>
		<cfset CodigoTransFactura = obtenerCodigoTrans(ModuloIns, getNotNull_vIntegridad(Arguments.TransaccionFactura,'CodigoTransaccionFactura','Alta_DocumentoDet'))>
		
		<cfset Socio = obtenerSocio(getNotNull_vIntegridad(Arguments.SocioExterno,'SocioExterno','Alta_DocumentoDet'))>
		<cfset Dmonto       = getNotNull_vIntegridad(Arguments.Monto,'Monto','Alta_DocumentoDet')>
		<cfset DmontoNC     = getNotNull_vIntegridad(Arguments.MontoNC,'MontoNC','Alta_DocumentoDet')>
		<cfset Ddocumento   = validaDocumento(ModuloIns, CodigoTransFactura, Socio, getNotNull_vIntegridad(Arguments.Documento,'Documento','Alta_DocumentoDet'),'Alta_DocumentoDet')>
		
		<cfif len(Trim(CodigoMonedaDestino)) GT 0>
			<cfset MonedaDoc 	= validaMoneda(obtenerMoneda(CodigoMonedaDestino), ModuloIns, CodigoTransFactura, Socio, getNotNull_vIntegridad(Arguments.Documento,'Documento','Alta_DocumentoDet'))>
		<cfelse>
			<cfset MonedaDoc 	= validaMoneda(CodigoMonedaDestino, ModuloIns, CodigoTransFactura, Socio, getNotNull_vIntegridad(Arguments.Documento,'Documento','Alta_DocumentoDet'))>
		</cfif>
		<cfif Dmonto EQ 0>
			<cfthrow message="El monto en moneda del Documento no puede ser cero.Proceso Cancelado!">
		</cfif>

		<!--- Insertar. Alta en Detalle de Documento Neteo --->
		<cfif Trim(ModuloIns) EQ 'CC'>	
			<cfquery datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				insert into DFavor 
					(Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, SNcodigo, Mcodigo, DFmonto, DFtotal, DFmontodoc, DFtipocambio, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#CodigoTransNC#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.DocumentoOrig#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CodigoTransFactura#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ddocumento#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Socio#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#MonedaDoc#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#DmontoNC#">, <!---Monto moneda Pago--->
					<cfqueryparam cfsqltype="cf_sql_money" value="#DmontoNC#">, <!---Total moneda Pago--->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Dmonto#">,   <!---Monto moneda Documento--->
					<cfqueryparam cfsqltype="cf_sql_float" value="#DmontoNC/ Dmonto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CC_InterfazAplicaCredito.GvarUsucodigo#">
						)
			</cfquery>
		</cfif>
		
		<cfreturn true>
	</cffunction>

	<!--- Valida que el campo no sea vacío. --->
	<cffunction access="private" name="getNotNull_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default="">
		
		<cfif len(trim(Arguments.Value)) EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro #Arguments.Name# es Requerido y no puede ser vac&iacute;o. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>
<!--- Verifica que el Documento exista --->
	<!---<cffunction access="private" name="VerificarDocumento" output="false" returntype="string">
		<cfargument name="Documento" type="string" required="yes">
		<cfargument name="Transaccion" type="string" required="yes">
		
		<cfquery name="rsTransaccion" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select Ddocumento 
				from Documentos 
				where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">
				and CCTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Transaccion#">
		</cfquery>
		<cfif rsTransaccion.recordcount gt 0 and len(trim(rsSocio.SNcodigo)) NEQ 0>
			<cfreturn trim(Arguments.Documento)>
		<cfelse>
			<cfthrow message="El documento de #Arguments.Documento# con transacción #Arguments.Transaccion# no existe, proceso cancelado!">
		</cfif>
	</cffunction>
--->
	<!--- Obtener el Código de Transacción Inteno según el Código de Transacción Externo --->
	<cffunction access="private" name="obtenerCodigoTrans" output="false" returntype="string">
		<cfargument name="Modulo" type="string" required="yes">
		<cfargument name="CodigoTransaccionExterno" type="string" required="yes">

		<cfset var CodigoTrans = Arguments.CodigoTransaccionExterno>
		<cfif Trim(Arguments.Modulo) EQ 'CC'>
			<cfquery name="rsTransaccion" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				select min(CCTcodigo) as CodigoTrans
				from CCTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
				and CCTcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoTransaccionExterno#">
			</cfquery>
		<cfelseif Trim(Arguments.Modulo) EQ 'CP'>
			<cfquery name="rsTransaccion" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				select min(CPTcodigo) as CodigoTrans
				from CPTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
				and CPTcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoTransaccionExterno#">
			</cfquery>
		</cfif>
		<cfif rsTransaccion.recordcount gt 0>
			<cfset CodigoTrans = rsTransaccion.CodigoTrans>
		<cfelse>
			<cfthrow message="Error en Interfaz 12. CodigoTransaccion es inválido, El Código de Transacción no corresponde con ninguna Transacción de la Empresa #Request.CC_InterfazAplicaCredito.GvarEcodigo# para el Módulo #Arguments.Modulo#. Proceso Cancelado!.">
		</cfif>
		<cfreturn CodigoTrans>
	</cffunction>
	
	<!--- Obtener el Socio de Negocio Interno según el código de Socio de Negocio Externo --->
	<cffunction access="private" name="obtenerSocio" output="false" returntype="string">
		<cfargument name="SocioExterno" type="string" required="yes">
		<cfset var Socio = "-1">
		<cfset Arguments.SocioExterno = trim(Arguments.SocioExterno)>
		<cfquery name="rsSocio" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select min(SNcodigo) as SNcodigo
			from SNDirecciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
			and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SocioExterno#">
		</cfquery>
		<cfif rsSocio.recordCount and len(trim(rsSocio.SNcodigo)) NEQ 0>
			<cfset Socio = rsSocio.SNcodigo>
			<cfreturn Socio>
		</cfif>
		<cfquery name="rsSocio" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select min(SNcodigo) as SNcodigo
			from SNDirecciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
			and SNDcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SocioExterno#">
		</cfquery>
		<cfif rsSocio.recordCount and len(trim(rsSocio.SNcodigo)) NEQ 0>
			<cfset Socio = rsSocio.SNcodigo>
			<cfreturn Socio>
		</cfif>
		<cfquery name="rsSocio" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select min(SNcodigo) as SNcodigo
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
			and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SocioExterno#">
		</cfquery>
		<cfif rsSocio.recordCount and len(trim(rsSocio.SNcodigo)) NEQ 0>
			<cfset Socio = rsSocio.SNcodigo>
			<cfreturn Socio>
		</cfif>
		<cfquery name="rsSocio" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select min(SNcodigo) as SNcodigo
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
			and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SocioExterno#">
		</cfquery>
		<cfif rsSocio.recordCount and len(trim(rsSocio.SNcodigo)) NEQ 0>
			<cfset Socio = rsSocio.SNcodigo>
			<cfreturn Socio>
		</cfif>
		<cfif Socio EQ '-1'>
			<cfthrow message="No se puede encontrar un socio de negocio asociado al código de socio externo. Proceso Cancelado!">
		</cfif>
		<cfreturn Socio>
	</cffunction>

	<!--- Obtener la Moneda según el código ISO --->
	<cffunction access="private" name="obtenerMoneda" output="false" returntype="string">
		<cfargument name="MonedaABA" type="string" required="yes">

		<cfquery name="rsMoneda" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
			select Mcodigo
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
			and Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MonedaABA#">
		</cfquery>
		
		<cfif rsMoneda.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 12. CodigoMoneda es inválido, El Código de la Moneda (#Arguments.MonedaABA#) no corresponde con ninguna modeda en la Empresa #Request.CC_InterfazAplicaCredito.GvarEcodigo#. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsMoneda.Mcodigo>
	</cffunction>

	<!--- VALIDACION DE DOCUMENTO(los saldos se validan en el posteo)--->
	<cffunction access="private" name="validaDocumento" output="false" returntype="string">
		<cfargument name="Modulo" type="string" required="yes">
		<cfargument name="CodigoTransaccion" type="string" required="yes">
		<cfargument name="Socio" type="string" required="yes">
		<cfargument name="Ddocumento" type="string" required="yes">
		<cfargument name="InvokerName" required="no" type="string" default="">
		
		

<!---<cfthrow message = "valores. SNcodigo #CheckDocumento.RECORDCOUNT#" > --->

		<cfif Trim(Modulo) EQ 'CC'>
			<cfquery name="checkDocumento" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				select round(Dsaldo, 2) as saldo
				from Documentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Socio#">
				and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoTransaccion#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ddocumento#">
			</cfquery>
		<cfelseif Trim(Modulo) EQ 'CP'>
			<cfquery name="checkDocumento" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				select round(EDsaldo, 2) as saldo
				from EDocumentosCP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Socio#">
				and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoTransaccion#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ddocumento#">
			</cfquery>
		</cfif>
		
				
		<cfif not isdefined("checkDocumento") or checkDocumento.recordcount EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El Documento #Arguments.Ddocumento# no existe entre los documentos posteados en la Base de Datos. Proceso Cancelado!">
		</cfif>
		
		<!---<cfthrow message = "ya salio #Request.CC_InterfazAplicaCredito.GvarConexion# registros  #Registros#">--->
				<cfreturn Arguments.Ddocumento>
	</cffunction>
	
		<!--- OBTENER LA MONEDA--->
	<cffunction access="private" name="validaMoneda" output="false" returntype="string">
		<cfargument name="MonedaDetalle" type="string" required="no">
		<cfargument name="Modulo" type="string" required="yes">
		<cfargument name="CodigoTransaccion" type="string" required="yes">
		<cfargument name="Socio" type="string" required="yes">
		<cfargument name="Ddocumento" type="string" required="yes">
		
		<cfif Trim(Modulo) EQ 'CC'>
			<cfquery name="checkMoneda" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				select Mcodigo as moneda
				from Documentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Socio#">
				and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoTransaccion#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ddocumento#">
			</cfquery>
		<cfelseif Trim(Modulo) EQ 'CP'>
			<cfquery name="checkMoneda" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
				select Mcodigo as moneda
				from EDocumentosCP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Socio#">
				and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoTransaccion#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ddocumento#">
			</cfquery>
		</cfif>
		<cfif Len(trim(#Arguments.MonedaDetalle#)) GT 0>
			<cfif #Arguments.MonedaDetalle# NEQ #checkMoneda.moneda#>
				<cfthrow message="La Moneda del detalle(#Arguments.MonedaDetalle#), no es igual a la moneda del documento #Arguments.Ddocumento# (#checkMoneda.moneda#)">
			<cfelse>
				<cfreturn #Arguments.MonedaDetalle#>
			</cfif>	
		<cfelse>
			<cfif checkDocumento.RECORDCOUNT EQ 0 or len(trim(checkMoneda.moneda)) EQ 0>
				<cfthrow message="El Documento #Arguments.Ddocumento# no tiene definida una moneda. Proceso Cancelado!">
			<cfelse>
				<cfreturn checkMoneda.moneda>
			</cfif>
		</cfif>
		
	</cffunction>
	
	<!--- Validar las monedas en caso de aplicación 1 a 1 --->
	<cffunction access="public" name="validaMonedas" output="false" returntype="boolean">
		<cfargument name="MonedaOrigen" type="string" required="yes">
		<cfargument name="MonedaDestino" type="string" required="yes">

		<cfset result = true>
		<cfif Trim(Arguments.MonedaOrigen) NEQ Trim(Arguments.MonedaDestino)>
			<cfset result = false>
			<cfthrow message="La Moneda Origen y Moneda Destino deben iguales. Proceso Cancelado!">
		</cfif>
		<cfreturn result>
		
	<!---Obtener el tipo de Cambio--->		
	</cffunction>
	<cffunction access="private" name="obtenerTipoCambio" output="false" returntype="numeric"> 
	  <cfargument name="Mcodigo" required="yes" type="numeric">
	  <cfargument name="Fecha" required="no" type="date" default="#now()#">
	  <cfargument name="origen" required="no" type="string" default="CC">
	  <cfset var retTC = 1.00>
	  <cfquery name="rsTC" datasource="#Request.CC_InterfazAplicaCredito.GvarConexion#">
		   select 
		   		coalesce(h.TCcompra,1) as TCcompra,
				coalesce(h.TCventa,1)  as TCventa
		   from Htipocambio h
		   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
		     and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		     and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		     and h.Hfecha = (
		     select max(h2.Hfecha)
		     from Htipocambio h2
		     where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CC_InterfazAplicaCredito.GvarEcodigo#">
		       and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		       and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">)
 
 	 </cfquery>
	 <cfif isdefined('rsTC') and rsTC.recordCount GT 1>
	 	<cfthrow message="Hay mas de un tipo de cambio definido para la fecha de aplicacion">
	 </cfif>
 	 <cfif isdefined('rsTC') and rsTC.recordCount EQ 1>
		<cfif Arguments.origen eq 'CC'>
			<cfset retTC = rsTC.TCcompra>
	 	<cfelseif Arguments.origen eq 'CP'>
 		 	<cfset retTC = rsTC.TCventa>
	 	</cfif>
	 </cfif>
 	 <cfreturn retTC>
  </cffunction>
  
  	<!---Validacion de los Modulos--->
	<cffunction access="public" name="validaModulos" output="false" returntype="boolean">
		<cfargument name="ModuloOrigen" type="string" required="yes">
		<cfargument name="ModuloDestino" type="string" required="yes">

		<cfset result = true>
		<cfif Trim(Arguments.ModuloOrigen) NEQ 'CC' and Trim(Arguments.ModuloOrigen) NEQ 'CP'>
			<cfset result = false>
			<cfthrow message="El Modulo Origen debe ser CC o CP. Proceso Cancelado!">
		</cfif>
		<cfif Trim(Arguments.ModuloDestino) NEQ 'CC' and Trim(Arguments.ModuloDestino) NEQ 'CP'>
			<cfset result = false>
			<cfthrow message="El Modulo Destino debe ser CC o CP. Proceso Cancelado!">
		</cfif>
		<cfreturn result>
		
	</cffunction>

</cfcomponent>
