<!----- 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Componente de la Interfaz: interfazSoin13 para cargar los saldos despreciables que se encuentran en la tabla IE13 publica.
	Creado por: Angélica Loría Chavarría
	Fecha: 07/12/2004
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
------>
<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="EcodigoSDC" required="no" type="string" default="0">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">

		<!---- Si se recibe el EcodigoSDC se busca el Ecodigo que corresponda en SIF ---->
		<cfif Arguments.EcodigoSDC GT 0>
			<cfquery name="rsEcodigo" datasource="#Arguments.Conexion#">
				select Ereferencia
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
				  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>
			<!---- Si existe el Ecodigo en SIF ----->
			<cfif rsEcodigo.recordcount NEQ 0 and rsEcodigo.Ereferencia NEQ ''>
				<cfset Arguments.Ecodigo = rsEcodigo.Ereferencia>
			<cfelse>
				<cfthrow message="CM_InterfazSaldosDespreciables: El valor del par&aacute;metro EcodigoSDC es incorrecto o no corresponde con el Código de Empresa de la Sesion. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Request.CM_InterfazSaldosDespreciables.Initialized")>
			<cfset Request.CPCC_InterfazSaldosDespreciables.Initialized = true>
			<cfset Request.CM_InterfazSaldosDespreciables.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazSaldosDespreciables.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazSaldosDespreciables.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazSaldosDespreciables.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazSaldosDespreciables.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazSaldosDespreciables.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazSaldosDespreciables.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazSaldosDespreciables.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>
	
	<!---- ******** Funcion para ALTA de encabezado ******** ------>
	<cffunction name="Alta_SaldosDespreciables" access="public" returntype="query">
		<cfargument name="EcodigoSDC" type="string" required="true">
		<cfargument name="ModuloOrigen" type="string" required="true"> 				<!---- Determina si es CxC (cc)o CxP (cp)----->
		<cfargument name="NumeroSocio" type="string" required="true">				<!---- Codigo externo para traer el SNcodigo del encabezado ----->		
		<cfargument name="CodigoMoneda" type="string" required="true"> 				<!---- Miso4217  para obtener el Mcodigo ---->
		<cfargument name="MontoEliminado" type="string" required="false">			<!---- Monto de la eliminacion ---->
		<cfargument name="Observacion" type="string" required="false">				<!---- Observaciones de tabla DocumentoNeteo ---->
		<cfargument name="CodigoTransaccionElim" type="string" required="false"> 	<!---- Obtengo el CCTcodigo para DocumentoNeteo (encabezado) ----->
		<cfargument name="DocumentoEliminacion" type="string" required="false">	<!---- Validar que no exista en DocumentoNeteo si no se inserta en campo DocumentoNeteo (encabezado)  ---->
		<cfargument name="BMUsucodigo" type="string" default="~" required="false">		
		<!----
		<cfargument name="FechaAplicacion" type="date" required="true"> 			<!---- Fecha de aplicacion de la eliminacion --->		
		<cfargument name="CodigoTransaccion" type="varchar" required="true"> 		<!---- Codigo para traer CPTcodigo de CPTransacciones para el detalle (DocumentoNeteoDCxC)----->
		<cfargument name="Documento" type="varchar" required="true">				<!---- Campo para validar en tabla Documentos o EDocumentosCP para detalle (DocumentoNeteoDCxC) ---->
		<cfargument name="TransaccionOrigen" type="varchar" required="false">		<!---- Rerefencia de tabla detalle ---->
		---->
		
		<!---- ******************** VALIDACIONES ******************** ----->
		<!---- Valida que no exista ya el documento ---->
		<cfquery name="rsExiste" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
			select 1
			from DocumentoNeteo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	 
			and DocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.DocumentoEliminacion#">	 	 
		</cfquery>
		<cfif isdefined("rsExiste") and rsExiste.RecordCount GT 0>
			<cfthrow message="CM_InterfazSaldosDespreciables: El Documento que desea insertar ya existe.   El proceso ha sido cancelado.">
		</cfif>

		<!---- Busca la el Mcodigo segun el MISO4217 recibido en el campo CodigoMoneda ---->
		<cfquery name="rsMcodigo" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
			select Mcodigo 
			from Monedas
			where ltrim(rtrim(Miso4217)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoMoneda#">	 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
		</cfquery>					
		
		<!---- Busca el SNcodigo segun el NumeroSocio recibido para la tabla DocumentoNeteo ---->
		<cfquery name="rsSNcodigo" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
			select SNcodigo
			from SNegocios
			where ltrim(rtrim(SNcodigoext)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumeroSocio#">	 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
		</cfquery>
										
		<!---- Trae el codigo de la transacción ---->
		<cfif isdefined("Arguments.CodigoTransaccionElim") and Len(trim(Arguments.CodigoTransaccionElim))><!---- NEQ ''>---->
			<cfquery name="rsCodigoTransaccionCC" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
				select CCTcodigo
				from CCTransacciones
				where ltrim(rtrim(CCTcodigoext)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoTransaccionElim#">	 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
			</cfquery>
			<cfif isdefined("rsCodigoTransaccionCC") and rsCodigoTransaccionCC.CCTcodigo EQ ''>
				<cfthrow message="CM_InterfazSaldosDespreciables: El campo CodigoTransaccionElim (Código de Transacción a eliminar) no existe.   El proceso ha sido cancelado.">			
			</cfif> 	
		<cfelse>		
			<cfthrow message="CM_InterfazSaldosDespreciables: El campo CodigoTransaccionElim (Código de Transacción a eliminar) es requerido.   El proceso ha sido cancelado.">
		</cfif>

		<!--- Alta DocumentoNeteo --->
		<cfquery name="insertEncab" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
			insert into DocumentoNeteo 
					(Ecodigo, 
					Mcodigo, 
					CCTcodigo, 
					DocumentoNeteo, 
					SNcodigo, 
					Dmonto, 
					BMUsucodigo, 
					Observaciones, 
					Aplicado) 				
			values 
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">, 								
				<cfif isdefined ("rsMcodigo.Mcodigo") and len(trim(rsMcodigo.Mcodigo))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMcodigo.Mcodigo#">, 
				<cfelse>
					null,
				</cfif>								
				<cfif isdefined("rsCodigoTransaccionCC.CCTcodigo") and len(trim(rsCodigoTransaccionCC.CCTcodigo))> 
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigoTransaccionCC.CCTcodigo#">, 
				<cfelse>
					null,
				</cfif>				
				<cfif isdefined("Arguments.DocumentoEliminacion") and len(trim(Arguments.DocumentoEliminacion))>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.DocumentoEliminacion#">, 
				<cfelse>
					null,
				</cfif>				
				<cfif isdefined("rsSNcodigo.SNcodigo") and len(trim(rsSNcodigo.SNcodigo))> 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSNcodigo.SNcodigo#">, 
				<cfelse>
					null,
				</cfif>				
				<cfif isdefined("Arguments.MontoEliminado") and len(trim(Arguments.MontoEliminado))>
					<cfqueryparam cfsqltype="cf_sql_double"  value="#Arguments.MontoEliminado#">, 
				<cfelse>
					null,
				</cfif>				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSaldosDespreciables.GvarUsucodigo#">, 												
				<cfif isdefined("Arguments.Observacion") and len(trim(Arguments.Observacion))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Observacion#">, 
				<cfelse>
					null,
				</cfif>		
				0)
				<cf_dbidentity1 datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="insertEncab" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#" verificar_transaccion="false">

		<cfquery name="rsEncabezado" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
			select 	idDocumentoNeteo,
					Ecodigo,  
					Mcodigo, 
					CCTcodigo, 
					DocumentoNeteo, 
					SNcodigo, 
					Dmonto, 
					BMUsucodigo, 
					Observaciones, 
					Aplicado
			from DocumentoNeteo
			where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertEncab.identity#">
		</cfquery>
		
		<cfreturn rsEncabezado>
	</cffunction>

	<!---- ******** Funcion para ALTA de detalles (DocumentoNeteoDCxC (cuando es CC) DocumentoNeteoDCxP (cuando es CP) ******** ------>
	<cffunction name="Alta_DetSaldosDespreciables" access="public" returntype="boolean"><!----returntype="query">---->
		<cfargument name="idDocumentoNeteo" type="String" required="false">			<!---- ID del encabezado generado anteriormente (DocumentoNeteo)---->
		<cfargument name="EcodigoSDC" type="String" required="true">
		<cfargument name="ModuloOrigen" type="String" required="true"> 				<!---- Determina si es CxC (cc)o CxP (cp)----->
		<cfargument name="CodigoTransaccion" type="String" required="true"> 		<!---- Codigo para traer CPTcodigo de CPTransacciones para el detalle (DocumentoNeteoDCxC)----->
		<cfargument name="Documento" type="String" required="true">					<!---- Campo para validar en tabla Documentos o EDocumentosCP para detalle (DocumentoNeteoDCxC) ---->
		<cfargument name="TransaccionOrigen" type="String" required="false">		<!---- Rerefencia de tabla detalle ---->		
		<cfargument name="MontoEliminado" type="String" required="false">			<!---- Monto de la eliminacion ---->
		<cfargument name="BMUsucodigo" type="String" default="~" required="false">		
		<!-----
		<cfargument name="FechaAplicacion" type="date" required="true"> 			<!---- Fecha de aplicacion de la eliminacion --->		
		<cfargument name="NumeroSocio" type="varchar" required="true">				<!---- Codigo externo para traer el SNcodigo del encabezado ----->
		<cfargument name="CodigoTransaccionElim" type="varchar" required="false"> 	<!---- Obtengo el CCTcodigo para DocumentoNeteo (encabezado) ----->
		<cfargument name="DocumentoEliminacion" type="varchar" required="false">	<!---- Validar que no exista en DocumentoNeteo si no se inserta en campo DocumentoNeteo (encabezado)  ---->
		<cfargument name="CodigoMoneda" type="char" required="true"> 				<!---- Miso4217  para obtener el Mcodigo ---->
		<cfargument name="Observacion" type="varchar" required="false">				<!---- Observaciones de tabla DocumentoNeteo ---->
		----->
		
		<!---- ******************** VALIDACIONES ******************** ----->
		<cfif isdefined("Arguments.ModuloOrigen") and len(trim(Arguments.ModuloOrigen))>		
			<!---- Si el modulo origen es CXC ---->
			<cfif Ucase(Ltrim(Rtrim(Arguments.ModuloOrigen))) EQ 'CC'>
				<!---- Se obtiene el CCTcodigo  para CXC segun el codigo externo recibido ---->
				<cfquery name="rsCodigoTransaccionCC" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
					select CCTcodigo
					from CCTransacciones
					where ltrim(rtrim(CCTcodigoext)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoTransaccion#">	 
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
				</cfquery>		
				<!---- Si no existe el código de la transacción  ------>
				<cfif rsCodigoTransaccionCC.RecordCount EQ 0>
					<cfthrow message="El código de transaccion no existe.  El proceso ha sido cancelado.">				
				<cfelseif isdefined("rsCodigoTransaccionCC.CCTcodigo") and len(trim(rsCodigoTransaccionCC.CCTcodigo))>
					<!---- Si existe el codigo de transacción trae el saldo del documento segun el argumento Documento y CCTcodigo del query anterior ---->
					<cfquery name="rsVerificaCC" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
						select round(Dsaldo,2) as Dsaldo
						from Documentos
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
							and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigoTransaccionCC.CCTcodigo#">	 
							and ltrim(rtrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Documento#">	 	
					</cfquery>
					<!---- Si no existe el documento mensaje de error ---->
					<cfif rsVerificaCC.RecordCount EQ 0>
						<cfthrow message="CM_InterfazSaldosDespreciables: El documento no existe.  El proceso ha sido cancelado.">
					<cfelse>
						<!---- Si el monto eliminado es mayor que el del saldo del documento ----->
						<cfif Arguments.MontoEliminado GT rsVerificaCC.Dsaldo>
							<cfthrow message="CM_InterfazSaldosDespreciables: El saldo del documento es inferior al que se va a eliminar.  El proceso ha sido cancelado.">
						</cfif>					
					</cfif>					
				</cfif>
			<!---- Si el modulo origen es CXP ---->
			<cfelseif Ucase(Ltrim(Rtrim(Arguments.ModuloOrigen))) EQ 'CP'>	
				<!---- Se obtiene el CPTcodigo  para CXP segun el codigo externo recibido ---->
				<cfquery name="rsCodigoTransaccionCP" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
					select CPTcodigo
					from CPTransacciones
					where ltrim(rtrim(CPTcodigoext)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoTransaccion#">	 
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
				</cfquery>
				<!---- Si no existe el código de la transacción  ------>
				<cfif rsCodigoTransaccionCP.RecordCount EQ 0>
					<cfthrow message="CM_InterfazSaldosDespreciables: El código de transaccion no existe.  El proceso ha sido cancelado.">					
				<cfelseif isdefined("rsCodigoTransaccionCP.CPTcodigo") and len(trim(rsCodigoTransaccionCP.CPTcodigo))>
					<!---- Si existe el codigo de transacción trae el saldo del documento segun el argumento Documento y CPTcodigo del 
					query anterior ademas del id del documento ---->
					<cfquery name="rsVerificaCP" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
						select round(EDsaldo,2) as Dsaldo, IDdocumento
						from EDocumentosCP
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">	
						  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigoTransaccionCP.CPTcodigo#">	 
						  and ltrim(rtrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Documento#">	
					</cfquery>
					<cfif rsVerificaCP.RecordCount EQ 0>
						<cfthrow message="CM_InterfazSaldosDespreciables: El documento no existe.  El proceso ha sido cancelado.">
					<cfelse>
						<!---- Si el monto a eliminar (MontoEliminado) es mayor que el saldo del documento ---->
						<cfif Arguments.MontoEliminado GT rsVerificaCP.Dsaldo>
							<cfthrow message="CM_InterfazSaldosDespreciables: El saldo del documento es inferior al que se va a eliminar.  El proceso ha sido cancelado.">
						</cfif>
					</cfif>	
				</cfif>
			</cfif>					
		</cfif>	
		
		<cfif isdefined("Arguments.ModuloOrigen") and Ucase(Ltrim(rtrim(Arguments.ModuloOrigen))) EQ 'CC'>										
			<!--- Alta DocumentoNeteoDCxC  --->						
			<cfquery name="insert" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
				insert into DocumentoNeteoDCxC 
						(idDocumentoNeteo, 
						Ecodigo, 
						CCTcodigo, 
						Ddocumento, 
						Dmonto, 
						BMUsucodigo, 
						Referencia) 				
				values 
					(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumentoNeteo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSaldosDespreciables.GvarEcodigo#">, 				
					<cfif isdefined("rsCodigoTransaccionCC.CCTcodigo") and len(trim(rsCodigoTransaccionCC.CCTcodigo))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigoTransaccionCC.CCTcodigo#">, 
					<cfelse>
						null,
					</cfif>					
					<cfif isdefined("Arguments.Documento") and len(trim(Arguments.Documento))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Documento#">, 
					<cfelse>
						null,
					</cfif>					
					<cfif isdefined("Arguments.MontoEliminado") and len(trim(Arguments.MontoEliminado))>
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoEliminado#">, 
					<cfelse>
						null,
					</cfif>					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSaldosDespreciables.GvarUsucodigo#">, 													
					<cfif isdefined("Arguments.TransaccionOrigen") and len(trim(Arguments.TransaccionOrigen))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TransaccionOrigen#"> 
					<cfelse>
						null
					</cfif>		
					)
			</cfquery>
			
		<cfelseif isdefined("Arguments.ModuloOrigen") and Ucase(Ltrim(Rtrim(Arguments.ModuloOrigen))) EQ 'CP'>
			<!--- Alta DocumentoNeteoDCxP --->
			<cfquery name="insert" datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
				insert into DocumentoNeteoDCxP 
						(idDocumentoNeteo,
						idDocumento, 						 
						CPTcodigo, 
						Ddocumento, 
						Dmonto, 
						BMUsucodigo, 
						Referencia) 				
				values 
					(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocumentoNeteo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaCP.IDdocumento#">,
					<cfif isdefined("rsCodigoTransaccionCP.CPTcodigo") and len(trim(rsCodigoTransaccionCP.CPTcodigo))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsCodigoTransaccionCP.CPTcodigo#">, 
					<cfelse>
						null,
					</cfif>					
					<cfif isdefined("Arguments.Documento") and len(trim(Arguments.Documento))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Documento#">, 
					<cfelse>
						null,
					</cfif>					
					<cfif isdefined("Arguments.MontoEliminado") and len(trim(Arguments.MontoEliminado))>
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoEliminado#">, 
					<cfelse>
						null,
					</cfif>					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSaldosDespreciables.GvarUsucodigo#">, 													
					<cfif isdefined("Arguments.TransaccionOrigen") and len(trim(Arguments.TransaccionOrigen))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TransaccionOrigen#"> 
					<cfelse>
						null
					</cfif>		
					)
			</cfquery>
		</cfif>	
		<cfreturn true>
	</cffunction>


	
	<!--- ******************** Función para aplicar documentos ***********************----->
	<cffunction access="public" name="aplicar" output="false" >
		<cfargument name="idDocumentoNeteo" required="yes" type="string">
		<cfargument name="Ecodigo" 	   		required="yes" type="string" default="#session.Ecodigo#">
		<cfargument name="usuario" 			required="no"  type="string" default="#session.Usucodigo#">
		<cfargument name="login" 			required="no"  type="string" default="#session.Ulogin#">
			
			<cfquery datasource="#Request.CM_InterfazSaldosDespreciables.GvarConexion#">
				execute CC_AplicaDocumentoNeteo 
					@idDocumentoNeteo = #Arguments.idDocumentoNeteo#,						
					@Ecodigo = 	#Arguments.Ecodigo#,
					@debug =	'N',
					@usuario =	#Arguments.usuario#,
					@login =	#Arguments.login#															
			</cfquery>		
	</cffunction>

	
	
</cfcomponent>