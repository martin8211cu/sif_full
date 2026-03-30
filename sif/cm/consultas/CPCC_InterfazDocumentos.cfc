<cfcomponent>
	<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
	
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="EcodigoSDC" required="no" type="numeric" default="0">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Usuario" required="no" type="string" default="#Session.Usuario#">

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
				<cf_errorCode	code = "50851" msg = "CM_InterfazDocumentos: El valor del parámetro EcodigoSDC no existe. Proceso Cancelado!">
			</cfif>
		<cfelse>
			<cf_errorCode	code = "50851" msg = "CM_InterfazSociosDocumentos: El valor del parámetro EcodigoSDC no existe. Proceso Cancelado!">
		</cfif>

		<cfif not isdefined("Request.CPCC_InterfazDocumentos.Initialized")>
			<cfset Request.CPCC_InterfazSolicitudes.Initialized  = true>
			<cfset Request.CPCC_InterfazDocumentos.GvarConexion  = Arguments.Conexion>
			<cfset Request.CPCC_InterfazDocumentos.GvarEcodigo   = Arguments.Ecodigo>	
			<cfset Request.CPCC_InterfazDocumentos.GvarUsuario   = Arguments.Usuario>
			<cfset Request.CPCC_InterfazDocumentos.GvarUsucodigo = Arguments.Usucodigo>
		</cfif>
		<cfreturn true>
	</cffunction>

	<!---
		Metodo: 
			insertar_DocumentoCC
		Resultado:
			Inserta el encabezado de Documentos de CxC.
			Retorna el Id generado.
	--->
	<cffunction name="insertar_DocumentoCC" access="public" returntype="numeric">
		<cfargument type="numeric" 	name="Ecodigo"	 		  required="yes" default="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		<cfargument type="string" 	name="Ocodigo" 			  required="yes" >
		<cfargument type="string"   name="CCTcodigo" 		  required="yes" >
		<cfargument type="string" 	name="EDdocumento"        required="yes" >
		<cfargument type="string" 	name="SNcodigo" 		  required="yes" >
		<cfargument type="string" 	name="Mcodigo" 			  required="yes" >
	 	<cfargument type="string" 	name="Ccuenta"			  required="yes" >
		<cfargument type="string" 	name="Rcodigo" 			  required="yes" >
		<cfargument type="string" 	name="EDfecha"  		  required="yes" >
		<cfargument type="string" 	name="EDfechavencimiento" required="yes" >
		<cfargument type="string"  	name="VoucherNo"		  required="yes" >
		<cfargument type="string" 	name="Usuario"			  required="yes" default="#session.Usuario#">
		<cfargument type="numeric" 	name="Usucodigo"		  required="yes" default="#session.Usucodigo#">
		
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" >
			insert EDocumentosCxC( Ecodigo, 
								   Ocodigo, 
								   CCTcodigo, 
								   EDdocumento, 
								   SNcodigo, 
								   Mcodigo, 
								   EDtipocambio, 
								   Icodigo, 
								   Ccuenta, 
								   Rcodigo, 
								   EDdescuento, 
								   EDporcdesc, 
								   EDimpuesto, 
								   EDtotal, 
								   EDfecha, 
								   EDtref, 
								   EDdocref, 
								   EDusuario, 
								   BMUsucodigo, 
								   EDvencimiento, 
								   Interfaz, 
								   EDreferencia )
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(arguments.CCTcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.EDdocumento)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
					 1,
					 null,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
					 <cfif len(trim(arguments.Rcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.Rcodigo)#"><cfelse>null</cfif>,
					 0,
					 0,
					 0,
					 0,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.EDfecha)#">,
					 null,
					 null,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Request.CPCC_InterfazDocumentos.GvarUsuario#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.EDfechavencimiento)#">,
					 1,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VoucherNo#"> )
			<cf_dbidentity1 datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" verificar_transaccion="false">
		</cfquery>	
		<cf_dbidentity2 datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#"  verificar_transaccion="false" name="data">

		<cfreturn data.identity > 
	</cffunction>

	<!---
		Metodo: 
			insertar_DocumentoCP
		Resultado:
			Inserta el encabezado de Documentos de CxP.
			Retorna el Id generado.
	--->
	<cffunction name="insertar_DocumentoCP" access="public" returntype="numeric">
		<cfargument type="numeric" 	name="Ecodigo"	 		  required="yes" default="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		<cfargument type="numeric" 	name="Ocodigo" 			  required="yes" >
		<cfargument type="string"   name="CPTcodigo" 		  required="yes" >
		<cfargument type="string" 	name="EDdocumento"        required="yes" >
		<cfargument type="numeric" 	name="SNcodigo" 		  required="yes" >
		<cfargument type="numeric" 	name="Mcodigo" 			  required="yes" >
	 	<cfargument type="numeric" 	name="Ccuenta"			  required="yes" >
		<cfargument type="string" 	name="Rcodigo" 			  required="yes" >
		<cfargument type="string" 	name="EDfecha"  		  required="yes" >
		<cfargument type="string" 	name="EDfechavencimiento" required="yes" >
		<cfargument type="string"  	name="VoucherNo"		  required="yes" >
		<cfargument type="string" 	name="Usuario"			  required="yes" default="#session.Usuario#">
		<cfargument type="numeric" 	name="Usucodigo"		  required="yes" default="#session.Usucodigo#">

		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" >
			insert into EDocumentosCxP( Ecodigo, 
										Ocodigo, 
										CPTcodigo,
										EDdocumento, 
										SNcodigo, 
										Mcodigo, 
										EDtipocambio, 
										Icodigo, 
										Ccuenta, 
										Rcodigo, 
										EDdescuento, 
										EDporcdescuento, 
										EDimpuesto, 
										EDtotal, 
										EDfecha, 
										EDdocref, 
										EDusuario,
										BMUsucodigo,
										EDvencimiento, 
										Interfaz, 
										EDreferencia )
										
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(arguments.CPTcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.EDdocumento)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
					 1,
					 null,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
					 <cfif len(trim(arguments.Rcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.Rcodigo)#"><cfelse>null</cfif>,
					 0,
					 0,
					 0,
					 0,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.EDfecha)#">,
					 null,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Request.CPCC_InterfazDocumentos.GvarUsuario#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CPCC_InterfazDocumentos.GvarUsucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.EDfechavencimiento)#">,
					 1,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VoucherNo#"> )
			<cf_dbidentity1 datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" verificar_transaccion="false">
		</cfquery>	
		<cf_dbidentity2 datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#"  verificar_transaccion="false" name="data">

		<cfreturn data.identity > 
	</cffunction>

	<!---
		Metodo: 
			insertar_Documento
		Resultado:
			Hace los llamados a las validaciones.	
			Hace los llamados a los metodos de insercion de CxC y CxP.
			Retorna el Id generado.
	--->
	<cffunction name="insertar_Documento" access="public" returntype="numeric">
		<cfargument name="EcodigoSDC" 	 	type="string" 	 required="true"> 
		<cfargument name="NumeroSocio" 	 	type="string" 	 required="true">
		<cfargument name="Modulo" 	 		type="string" 	 required="true">
		<cfargument name="CodigoTransacion" type="string" 	 required="true">
		<cfargument name="Documento" 	 	type="string" 	 required="true">
		<cfargument name="Estado" 	 		type="string" 	 required="true">
		<cfargument name="CodigoMoneda" 	type="string" 	 required="true">
		<cfargument name="FechaDocumento" 	type="string" 	 required="true">
		<cfargument name="FechaVencimiento" type="string" 	 required="true">
		<cfargument name="VoucherNo" 	 	type="string" 	 required="true">
		<cfargument name="CodigoRetencion" 	type="string" 	 required="false">
		<cfargument name="CodigoOficina" 	type="string" 	 required="false">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfset LvarSNcodigo = obtieneSocio(arguments.NumeroSocio,'insertar_Documento') >
		<cfset LvarMcodigo  = obtieneMoneda(arguments.CodigoMoneda, 'insertar_Documento') >
		<cfset LvarOcodigo  = obtieneOficina(arguments.CodigoOficina, 'insertar_Documento') >

		<cfset LvarRcodigo = '' >
		<cfif existeRetencion(arguments.CodigoRetencion) >
			<cfset LvarRcodigo = trim(arguments.CodigoRetencion) >
		</cfif>

		<cfset LvarID = '' >
		<!--- Insercion de datos y validaciones especificas segun el modulo --->
		<cfif trim(arguments.modulo) eq 'CC'>
			<cfif not len(trim(LvarSNcodigo.SNcuentacxc))>
				<cf_errorCode	code = "50853"
								msg  = "@errorDat_1@: La cuenta de CxC para el Socios de Negocios no ha sido definida. Proceso Cancelado!"
								errorDat_1="#Arguments.metodoInvocador#"
				>
			</cfif>
			<cfset LvarTransaccion = obtieneTransaccionCC(arguments.CodigoTransacion, 'insertar_Documento') >
			
			<!--- Inserta Documento de CxC--->
			<cfset LvarID = insertar_DocumentoCC(  Request.CPCC_InterfazDocumentos.GvarEcodigo,
												   LvarOcodigo,
												   LvarTransaccion,
												   arguments.Documento,
												   LvarSNcodigo.SNcodigo,
												   LvarMcodigo,
												   LvarSNcodigo.SNcuentacxc,
												   LvarRcodigo,
												   arguments.FechaDocumento,
												   arguments.FechaVencimiento,
												   arguments.VoucherNo,
												   Request.CPCC_InterfazDocumentos.GvarUsuario,
												   Request.CPCC_InterfazDocumentos.GvarUsucodigo ) >
		<cfelse>
			<cfif not len(trim(LvarSNcodigo.SNcuentacxp))>
				<cf_errorCode	code = "50854"
								msg  = "@errorDat_1@: La cuenta de CxP para el Socios de Negocios no ha sido definida. Proceso Cancelado!"
								errorDat_1="#Arguments.metodoInvocador#"
				>
			</cfif>
			<cfset LvarTransaccion = obtieneTransaccionCP(arguments.CodigoTransacion, 'insertar_Documento') >

			<!--- Inserta Documento de CxP--->
			<cfset LvarID = insertar_DocumentoCP(  Request.CPCC_InterfazDocumentos.GvarEcodigo,
														LvarOcodigo,
														LvarTransaccion,
														arguments.Documento,
														LvarSNcodigo.SNcodigo,
														LvarMcodigo,
														LvarSNcodigo.SNcuentacxc,
														LvarRcodigo,
														arguments.FechaDocumento,
														arguments.FechaVencimiento,
														arguments.VoucherNo,
														Request.CPCC_InterfazDocumentos.GvarUsuario,
														Request.CPCC_InterfazDocumentos.GvarUsucodigo ) >
		</cfif>

		<cfreturn LvarID >
	</cffunction>
	
	<!---
		Metodo: 
			insertar_DetallesDocumentoCC
		Resultado:
			Inserta el detalle de Documentos de CxC
	--->
	<cffunction name="insertar_DetallesDocumentoCC" access="public">
		<cfargument type="numeric" 	name="EDid" 			required="yes">
		<cfargument type="string" 	name="TipoItem" 		required="yes">
		<cfargument type="string" 	name="CodigoItem" 		required="yes">
		<cfargument type="string" 	name="Alm_Aid" 			required="yes">
		<cfargument type="string" 	name="Ccuenta" 			required="yes">
		<cfargument type="string" 	name="DDdescripcion" 	required="yes">
		<cfargument type="string" 	name="DDdescalterna" 	required="yes">
		<cfargument type="string" 	name="Dcodigo" 			required="yes">
		<cfargument type="string" 	name="DDcantidad" 		required="yes">
		<cfargument type="string" 	name="DDpreciou" 		required="yes">
		<cfargument type="string" 	name="DDdesclinea" 		required="yes">
		<cfargument type="string" 	name="DDporcdesclin"	required="yes">
		<cfargument type="string" 	name="DDtotallinea"		required="yes">
		<cfargument type="string" 	name="Icodigo" 			required="yes">
		
		<!--- Total de la linea (incluye descuento e impuestos) --->
		<cfset LvarTotal = arguments.DDcantidad*DDpreciou >
		<cfif len(trim(arguments.DDdesclinea))>
			<cfset LvarTotal = LvarTotal - arguments.DDdesclinea >
		</cfif>

		<cfset LvarMontoImpuesto = 0 >
		<cfif len(trim(arguments.Icodigo))>
			<cfquery name="dataImpuesto" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
				select coalesce(Iporcentaje,0) as Iporcentaje
				from Impuestos
				where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.Icodigo)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			</cfquery> 
			<cfset LvarMontoImpuesto =  (LvarTotal*dataImpuesto.Iporcentaje)/100 >
		</cfif>
		<cfset LvarTotal = LvarTotal + LvarMontoImpuesto >

		<cfquery datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" >
			insert into DDocumentosCxC(	EDid, 
										Aid, 
										Cid, 
										Alm_Aid, 
										Ccuenta, 
										Ecodigo, 
										DDdescripcion, 
										DDdescalterna, 
										Dcodigo, 
										DDcantidad, 
										DDpreciou, 
										DDdesclinea, 
										DDporcdesclin, 
										DDtotallinea, 
										DDtipo, 
										BMUsucodigo, 
										Icodigo )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EDid#">,
					 <cfif trim(arguments.TipoItem) eq 'A'><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CodigoItem#"><cfelse>null</cfif>,
					 <cfif trim(arguments.TipoItem) eq 'S'><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CodigoItem#"><cfelse>null</cfif>,
					 <cfif trim(arguments.TipoItem) eq 'A'><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Alm_Aid#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Ccuenta#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.DDdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.DDdescalterna#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.Dcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.DDcantidad#">,
					 #LvarOBJ_PrecioU.enCF(arguments.DDpreciou)#,
					 <cfqueryparam cfsqltype="cf_sql_money" 	value="#arguments.DDdesclinea#">,
					 <cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.DDporcdesclin#">,
					 <cfqueryparam cfsqltype="cf_sql_money" 	value="#LvarTotal#">,
					 <cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(arguments.TipoItem)#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Request.CPCC_InterfazDocumentos.GvarUsucodigo#">,
					 <cfif len(trim(arguments.Icodigo)) ><cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.Icodigo#"><cfelse>null</cfif> )
		</cfquery>
	</cffunction>

	<cffunction name="insertar_DetallesDocumentoCP" access="public">
		<cfargument type="numeric" 	name="EDid" 			required="yes">
		<cfargument type="string" 	name="TipoItem" 		required="yes">
		<cfargument type="string" 	name="CodigoItem" 		required="yes">
		<cfargument type="string" 	name="Alm_Aid" 			required="yes">
		<cfargument type="string" 	name="Ccuenta" 			required="yes">
		<cfargument type="string" 	name="DDdescripcion" 	required="yes">
		<cfargument type="string" 	name="DDdescalterna" 	required="yes">
		<cfargument type="string" 	name="Dcodigo" 			required="yes">
		<cfargument type="string" 	name="DDcantidad" 		required="yes">
		<cfargument type="string" 	name="DDpreciou" 		required="yes">
		<cfargument type="string" 	name="DDdesclinea" 		required="yes">
		<cfargument type="string" 	name="DDporcdesclin"	required="yes">
		<cfargument type="string" 	name="DDtotallinea"		required="yes">
		<cfargument type="string" 	name="Icodigo" 			required="yes">
		<cfargument type="string" 	name="DDembarque"		required="yes">
		<cfargument type="string" 	name="DDfembarque"		required="yes">
		
		<!--- Total de la linea (incluye descuento e impuestos) --->
		<cfset LvarTotal = arguments.DDcantidad*DDpreciou >
		<cfif len(trim(arguments.DDdesclinea))>
			<cfset LvarTotal = LvarTotal - arguments.DDdesclinea >
		</cfif>

		<cfset LvarMontoImpuesto = 0 >
		<cfif len(trim(arguments.Icodigo))>
			<cfquery name="dataImpuesto" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
				select coalesce(Iporcentaje,0) as Iporcentaje
				from Impuestos
				where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Icodigo)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			</cfquery> 
			<cfset LvarMontoImpuesto =  (LvarTotal*dataImpuesto.Iporcentaje)/100 >
		</cfif>
		<cfset LvarTotal = LvarTotal + LvarMontoImpuesto >
		
		<cfquery datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" >
			insert into DDocumentosCxP(	IDdocumento, 
										Aid, 
										Cid, 
										Alm_Aid, 
										Ccuenta, 
										Ecodigo, 
										DDdescripcion, 
										DDdescalterna, 
										Dcodigo, 
										DDcantidad, 
										DDpreciou, 
										DDdesclinea, 
										DDporcdesclin, 
										DDtotallinea, 
										DDtipo, 
										BMUsucodigo, 
										Icodigo,
										DDtransito,
										DDembarque,
										DDfembarque )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EDid#">,
					 <cfif trim(arguments.TipoItem) eq 'A'><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CodigoItem#"><cfelse>null</cfif>,
					 <cfif trim(arguments.TipoItem) eq 'S'><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CodigoItem#"><cfelse>null</cfif>,
					 <cfif trim(arguments.TipoItem) eq 'A'><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Alm_Aid#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Ccuenta#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.DDdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.DDdescalterna#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.Dcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.DDcantidad#">,
					 #LvarOBJ_PrecioU.enCF(arguments.DDpreciou)#,
					 <cfqueryparam cfsqltype="cf_sql_money" 	value="#arguments.DDdesclinea#">,
					 <cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.DDporcdesclin#">,
					 <cfqueryparam cfsqltype="cf_sql_money" 	value="#LvarTotal#">,
					 <cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(arguments.TipoItem)#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Request.CPCC_InterfazDocumentos.GvarUsucodigo#">,
					 <cfif len(trim(arguments.Icodigo)) ><cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.Icodigo#"><cfelse>null</cfif>,
					 1,
					 <cfif len(trim(arguments.DDembarque))><cfqueryparam cfsqltype="cf_sql_varchar"	value="#arguments.DDembarque#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(arguments.DDfembarque)#"> )
		</cfquery>
	</cffunction>

	<!---
		Metodo: 
			insertar_DetallesDocumento
		Resultado:
			Hace los llamados a las validaciones.	
			Hace los llamados a los metodos de insercion de detalles de CxC y CxP.
	--->
	<cffunction name="insertar_DetallesDocumento" access="public">
		<cfargument name="LvarID" 				type="numeric" required="yes" >	
		<cfargument name="Modulo" 				type="string"  required="yes" > 
		<cfargument name="TipoItem" 			type="string"  required="yes" > 
		<cfargument name="CodigoItem"			type="string"  required="yes" > 
		<cfargument name="NombreBarco"			type="string"  required="yes" >
		<cfargument name="PrecioUnitario"		type="string"  required="yes" > 
		<cfargument name="CodigoUnidadMedida"	type="string"  required="yes" >
		<cfargument name="CantidadTotal"		type="string"  required="yes" > 
		<cfargument name="CantidadNeta"			type="string"  required="yes" > 
		<cfargument name="CodEmbarque"			type="string"  required="yes" > 
		<cfargument name="NumeroBOL"			type="string"  required="yes" > 
		<cfargument name="FechaBOL"				type="string"  required="yes" > 
		<cfargument name="TripNo"				type="string"  required="yes" > 
		<cfargument name="ContractNo"			type="string"  required="yes" > 
		<cfargument name="CodigoImpuesto"		type="string"  required="yes" > 
		<cfargument name="ImporteImpuesto"		type="string"  required="yes" > 
		<cfargument name="ImporteDescuento"		type="string"  required="yes" > 
		<cfargument name="CodigoAlmacen"		type="string"  required="yes" > 
		<cfargument name="CodigoDepartamento"	type="string"  required="yes" >
		<cfargument name="metodoInvocador"      type="string"  required="no" default=""><!--- Nombre del método que lo invoca --->
		
		<!--- Validaciones --->
		<cfset LvarListaTipos = 'A,S' >
		<cfif findNoCase(trim(arguments.TipoItem), LvarListaTipos, 0) eq 0 >
			<cf_errorCode	code = "50855"
							msg  = "@errorDat_1@: El valor del parámetro TipoItem es inválido. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>

		<cfset LvarDepto = obtieneDepto(arguments.CodigoDepartamento, 'insertar_DetallesDocumento') >		

		<cfset LvarAlm_Aid = '' >
		<cfif trim(arguments.TipoItem) eq 'A'>
			<cfset LvarCodigoItem = obtieneArticulo( arguments.CodigoItem, 'insertar_DetallesDocumento' ) >
			<cfset LvarAlm_Aid = obtieneAlmacen(arguments.CodigoAlmacen, 'insertar_DetallesDocumento') >
			<cfset LvarCcuenta = obtieneCuentaArticulo( LvarCodigoItem.id, LvarAlm_Aid, arguments.CodigoItem, arguments.CodigoAlmacen, 'insertar_DetallesDocumento' ) >
		<cfelse>
			<cfset LvarCodigoItem = obtieneConcepto( arguments.CodigoItem, 'insertar_DetallesDocumento' ) >
			<cfset LvarCcuenta = obtieneCuentaConcepto( LvarCodigoItem.id, LvarDepto, arguments.CodigoItem, 'insertar_DetallesDocumento' ) >
		</cfif>
		
		<cfset LvarImporteDescuento = 0 >
		<cfif len(trim(arguments.ImporteDescuento))>
			<cfset LvarImporteDescuento = arguments.ImporteDescuento >
		</cfif>
		<cfset LvarTotalLinea = (arguments.CantidadTotal*arguments.PrecioUnitario)-LvarImporteDescuento >
		<cfset LvarIcodigo = obtieneImpuesto( arguments.CodigoImpuesto, LvarTotalLinea, arguments.ImporteImpuesto, 'insertar_DetallesDocumento' ) >		
		
		<cfset LvarDescuento = 0 >
		<cfif len(trim(arguments.ImporteDescuento))>
			<cfset LvarDescuento = arguments.ImporteDescuento >
		</cfif>
		
		<!--- total sin descuento ni impuestos --->
		<cfset LvarTotal_Linea = arguments.CantidadTotal*arguments.PrecioUnitario >
		
	  	<cfset LvarPorc_Descuento = obtienePorcentajeDescuento(LvarTotal_Linea, LvarDescuento, 'insertar_DetallesDocumento') >
		
		<cfif trim(arguments.Modulo) eq 'CC' >
			<cfset insertar_DetallesDocumentoCC( arguments.LvarID,
												 arguments.TipoItem,
												 LvarCodigoItem.id,
												 LvarAlm_Aid,
												 LvarCcuenta,
												 LvarCodigoItem.descripcion,
												 LvarCodigoItem.descripcion,
												 LvarDepto,
												 arguments.CantidadTotal,
												 arguments.PrecioUnitario,
												 LvarImporteDescuento,
												 LvarPorc_descuento,
												 LvarTotalLinea,
												 LvarIcodigo) >
		<cfelse>
			<cfset LvarUcodigo = '' >
			<cfif trim(arguments.TipoItem) eq 'A'>
				<cfif existeUnidad(trim(arguments.CodigoUnidadMedida), 'insertar_DetallesDocumento') >
					<cfset LvarUcodigo = trim(arguments.CodigoUnidadMedida) >
				</cfif>
			</cfif>
			
			<cfset insertar_DetallesDocumentoCP( arguments.LvarID,
												 arguments.TipoItem,
												 LvarCodigoItem.id,
												 LvarAlm_Aid,
												 LvarCcuenta,
												 LvarCodigoItem.descripcion,
												 LvarCodigoItem.descripcion,
												 LvarDepto,
												 arguments.CantidadTotal,
												 arguments.PrecioUnitario,
												 LvarImporteDescuento,
												 LvarPorc_Descuento,
												 LvarTotal_Linea,
												 LvarIcodigo,
												 arguments.CodEmbarque,
												 arguments.FechaBOL ) >

		</cfif>
	</cffunction>	

	<!---
		Metodo: 
			aplicaDocumento
		Resultado:
			Aplica el documento de Cxc o CxP generado.
	--->
	<cffunction access="public" name="aplicaDocumento" output="false" >
		<cfargument name="Modulo" 		   required="yes" type="string">
		<cfargument name="IDdocumento" 	   required="yes" type="string">
		<cfargument name="metodoInvocador" required="no"  type="string" default=""> <!--- Nombre del método que lo invoca --->

		<cfif trim(arguments.modulo) eq 'CC'>
			<!--- <cfquery name="rs" datasource="minisif">
				select * from EDocumentosCxP where IDcontable=#arguments.IDdocumento#
			</cfquery>
			 <cfdump var="#rs#"> --->
			<cfquery datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
				exec CC_PosteoDocumentosCxC @EDid = #arguments.IDdocumento#,
											@Ecodigo = #Request.CPCC_InterfazDocumentos.GvarEcodigo#,
											@usuario = '#Request.CPCC_InterfazDocumentos.GvarUsuario#',
											@debug = 'N'
			</cfquery>
			<!--- <cfquery name="rs" datasource="minisif">
				select * from EDocumentosCxP where EDid=#arguments.IDdocumento#
			</cfquery>
			<cfdump var="#rs#"> --->
		<cfelse>
			<!--- <cfquery name="rs" datasource="minisif">
				select * from EDocumentosCxP where EDid=#arguments.IDdocumento#
			</cfquery>
			<cfdump var="#rs#"> --->
			<cfquery datasource="#Session.DSN#">
				exec CP_PosteoDocumentosCxP 
					@IDdoc = #arguments.IDdocumento#,
					@Ecodigo = #Request.CPCC_InterfazDocumentos.GvarEcodigo#,
					@usuario = '#Request.CPCC_InterfazDocumentos.GvarUsuario#',
					@debug = 'N'
			</cfquery>
			<!--- <cfquery name="rs" datasource="minisif">
				select * from EDocumentosCxP where IDcontable=#arguments.IDdocumento#
			</cfquery>
			<cfdump var="#rs#"> --->
		</cfif>
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezadoCC
		Resultado:
			Hace calculos adicionales para el encabezado del Documento CxC.
	--->
	<cffunction access="private" name="actualizarEncabezadoCC" output="false" >
		<cfargument name="IDdocumento" 	   required="yes" type="string">
		<cfargument name="metodoInvocador" required="no"  type="string" default=""> <!--- Nombre del método que lo invoca --->
		
		<!--- Total del documento --->
		<cfquery name="dataTotal" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select sum(DDcantidad*DDpreciou) as total
			from DDocumentosCxC
			where EDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarTotal = 0 >
		<cfif dataTotal.recordcount gt 0 and len(trim(dataTotal.total))>
			<cfset LvarTotal = dataTotal.total >
		</cfif>

		<!--- Descuento total del documento --->
		<cfquery name="dataDescuento" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select sum(DDdesclinea) as descuento
			from DDocumentosCxC
			where EDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarDescuento = 0 >
		<cfif dataDescuento.recordcount gt 0 and len(trim(dataDescuento.descuento))>
			<cfset LvarDescuento = dataDescuento.descuento >
		</cfif>

		<!--- porcentaje de descuento --->
		<cfset LvarPorcentaje = (100*LvarDescuento)/LvarTotal >
		
		<!--- Total del Documento. Se basa en que las lineas ya tienen aplicado descuento e impuestos--->
		<cfquery name="dataTotalCalculado" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select sum(DDtotallinea) as total
			from DDocumentosCxC
			where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfset LvarTotalCalculado = 0 >
		<cfif dataTotalCalculado.recordcount gt 0 and len(trim(dataTotalCalculado.total))>
			<cfset LvarTotalCalculado = dataTotalCalculado.total >
		</cfif>
		
		<!--- Modifica el encabezado --->
		<cfquery datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			update EDocumentosCxC
			set EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDescuento#">,
				EDporcdesc = <cfqueryparam cfsqltype="cf_sql_float" value="#LvarPorcentaje#">,		
				EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalCalculado#">
			where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezadoCP
		Resultado:
			Hace calculos adicionales para el encabezado del Documento CxP.
	--->
	<cffunction access="private" name="actualizarEncabezadoCP" output="false" >
		<cfargument name="IDdocumento" 	   required="yes" type="string">
		<cfargument name="metodoInvocador" required="no"  type="string" default=""> <!--- Nombre del método que lo invoca --->

		<!--- Total del documento para calculo de descuento --->
		<cfquery name="dataTotal" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select sum(DDcantidad*DDpreciou) as total
			from DDocumentosCxP
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarTotal = 0 >
		<cfif dataTotal.recordcount gt 0 and len(trim(dataTotal.total))>
			<cfset LvarTotal = dataTotal.total >
		</cfif>

		<!--- Descuento total del documento --->
		<cfquery name="dataDescuento" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select sum(DDdesclinea) as descuento
			from DDocumentosCxP
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarDescuento = 0 >
		<cfif dataDescuento.recordcount gt 0 and len(trim(dataDescuento.descuento))>
			<cfset LvarDescuento = dataDescuento.descuento >
		</cfif>

		<!--- porcentaje de descuento --->
		<cfset LvarPorcentaje = (100*LvarDescuento)/LvarTotal >

		<!--- Total del Documento. Se basa en que las lineas ya tienen aplicado descuento e impuestos--->
		<cfquery name="dataTotalCalculado" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select sum(DDtotallinea) as total
			from DDocumentosCxP
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfset LvarTotalCalculado = 0 >
		<cfif dataTotalCalculado.recordcount gt 0 and len(trim(dataTotalCalculado.total))>
			<cfset LvarTotalCalculado = dataTotalCalculado.total >
		</cfif>

		<!--- Modifica el encabezado --->
		<cfquery datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			update EDocumentosCxP
			set EDdescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDescuento#">,
				EDporcdescuento = <cfqueryparam cfsqltype="cf_sql_float" value="#LvarPorcentaje#">,
				EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalCalculado#">
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezado
		Resultado:
			Aplica el documento de Cxc o CxP generado.
	--->
	<cffunction access="public" name="actualizarEncabezado" output="false" >
		<cfargument name="Modulo" 		   required="yes" type="string">
		<cfargument name="IDdocumento" 	   required="yes" type="string">
		<cfargument name="metodoInvocador" required="no"  type="string" default=""> <!--- Nombre del método que lo invoca --->

		<cfif trim(arguments.modulo) eq 'CC'>
			<cfset actualizarEncabezadoCC(arguments.IDdocumento,'actualizarEncabezado') >
		<cfelse>
			<cfset actualizarEncabezadoCP(arguments.IDdocumento,'actualizarEncabezado') >
		</cfif>
	</cffunction>

	<!---
		Metodo: 
			obtieneMoneda
		Resultado:
			Devuelve el id asociado al codigo Miso de la moneda dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="obtieneMoneda" output="false" returntype="string">
		<cfargument name="miso" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""> <!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0 >
			<cf_errorCode	code = "50856"
							msg  = "@errorDat_1@: El valor del parámetro CodigoMoneda no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data.Mcodigo>
	</cffunction>

	<!---
		Metodo: 
			obtieneArticulo
		Resultado:
			Devuelve el id asociado al codigo de articulo dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="obtieneArticulo" output="false" returntype="query">
		<cfargument name="Acodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Aid as id, Adescripcion as descripcion
			from Articulos
			where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Acodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50857"
							msg  = "@errorDat_1@: El valor del parámetro CodigoArticulo no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data >
	</cffunction>

	<!---
		Metodo: 
			obtieneAlmacen
		Resultado:
			Devuelve el id asociado al codigo de almacen dado por la interfaz.
			Si no se encuentra un registro para el codigo, devuelve cualquier almacen.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="obtieneAlmacen" output="false" returntype="string">
		<cfargument name="Almcodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Aid
			from Almacen
			where Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Almcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount eq 0 >
			<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" maxrows="1">
				select Aid
				from Almacen
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			</cfquery>
		</cfif>
		
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50858"
							msg  = "@errorDat_1@: No se pudo recuperar el código de Almacén. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data.Aid>
	</cffunction>

	<!---
		Metodo: 
			obtieneDepto
		Resultado:
			Devuelve el id asociado al codigo de Departamento dado por la interfaz.
			Si no se encuentra un registro para el codigo, devuelve cualquier departamento.
	--->
	<cffunction access="private" name="obtieneDepto" output="false" returntype="string">
		<cfargument name="Deptocodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Dcodigo
			from Departamentos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.Deptocodigo)#">
		</cfquery>
		<cfif data.recordcount eq 0 >
			<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" maxrows="1">
				select Dcodigo
				from Departamentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			</cfquery>
		</cfif>
		
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50859"
							msg  = "@errorDat_1@: No se pudo recuperar el código de Departamento. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>

		<cfreturn data.Dcodigo >
	</cffunction>

	<!---
		Metodo: 
			obtieneConcepto
		Resultado:
			Devuelve el id asociado al codigo de Servicio dado por la interfaz.
			Si no se encuentra un registro para el codigo, devuelve cualquier Servicio.
	--->
	<cffunction access="private" name="obtieneConcepto" output="false" returntype="query">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Cid as id, Cdescripcion as descripcion
			from Conceptos
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Ccodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50860"
							msg  = "@errorDat_1@: El valor del parámetro CodigoServicio no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data >
	</cffunction>

	<!---
		Metodo: 
			existeImpuesto
		Resultado:
			Devuelve true si el id asociado al codigo de impuesto dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="existeImpuesto" output="false" returntype="boolean">
		<cfargument name="Icodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Icodigo
			from Impuestos
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cfreturn false >
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<!---
		Metodo: 
			obtieneImpuestoImporte
		Resultado:
			Obtiene el codigo de impuesto a partir del monto de impuestos.
	--->
	<cffunction access="private" name="obtieneImpuestoImporte" output="false" returntype="string">
		<cfargument name="importe" required="yes" type="string">
		<cfargument name="total" 			required="yes" type="string"> <!--- cantidad*precio-descuento --->
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfset LvarIcodigo = '' >
		<cfif len(trim(importe)) and len(trim(total))>
			<cfset LvarImporte = arguments.importe >

			<cfset porcentaje = (LvarImporte*100)/arguments.total >
			<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#" maxrows="1">
				select Icodigo
				from Impuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
				and Iporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#porcentaje#">
			</cfquery>
			<cfif data.recordcount gt 0 >
				<cfset LvarIcodigo = data.Icodigo >
			</cfif>
		</cfif>
		<cfreturn LvarIcodigo >
	</cffunction>
	
	<!---
		Metodo: 
			obtieneImpuestoImporte
		Resultado:
			Obtiene el codigo de impuesto a partir del monto de impuestos.
	--->
	<cffunction access="private" name="obtieneImpuesto" output="false" returntype="string">
		<cfargument name="Icodigo" 		   required="no" type="string" default="" >
		<cfargument name="total" 		   required="no" type="string"> <!--- cantidad*precio-descuento --->
		<cfargument name="importe" 		   required="no" type="string"> 
		<cfargument name="metodoInvocador" required="no" type="string" default=""> <!--- Nombre del método que lo invoca --->
		
		<cfif len(trim(arguments.Icodigo))>
			<cfif existeImpuesto(arguments.Icodigo, 'obtieneImpuesto') >
				<cfreturn trim(arguments.Icodigo) >
			<cfelse>
				<cf_errorCode	code = "50861"
								msg  = "@errorDat_1@: El valor del parámetro Icodigo no existe en la Base de Datos. Proceso Cancelado!"
								errorDat_1="#Arguments.metodoInvocador#"
				>
			</cfif>
		<cfelse>		
			<cfif not len(trim(arguments.importe)) or arguments.importe eq 0 >
				<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
					select Icodigo
					from Impuestos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
					  and Icodigo = 'IE'
				</cfquery>
				<cfif len(trim(data.Icodigo)) >
					<cfreturn data.Icodigo >
				<cfelse>
					<cf_errorCode	code = "50862"
									msg  = "@errorDat_1@: No se puede asignar un codigo de impuesto a los datos. El impuesto default no esta definido. Proceso Cancelado!"
									errorDat_1="#Arguments.metodoInvocador#"
					>
				</cfif>
			<cfelse>
				<cfset LvarIcodigo = obtieneImpuestoImporte(arguments.importe, arguments.total, 'obtieneImpuesto') >
				<cfif not len(trim(LvarIcodigo))>
					<cf_errorCode	code = "50863"
									msg  = "@errorDat_1@: No se encontro un Código de Impuesto equivalente al Importe de Impuestos dado por la tabla ID10. Proceso Cancelado!"
									errorDat_1="#Arguments.metodoInvocador#"
					>
				<cfelse>
					<cfreturn LvarIcodigo >
				</cfif>
			</cfif>
		</cfif>	
		<cfreturn trim(LvarIcodigo) >
	</cffunction>

	<!---
		Metodo: 
			existeUnidad
		Resultado:
			Devuelve true si el id asociado al codigo de Unidad dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="existeUnidad" output="false" returntype="boolean">
		<cfargument name="Ucodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Ucodigo
			from Unidades
			where Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cfreturn false >
		<cfelse>	
			<cfreturn true >
		</cfif>
	</cffunction>

	<!---
		Metodo: 
			existeRetencion
		Resultado:
			Devuelve true si el id asociado al codigo de Retencion dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="existeRetencion" output="false" returntype="boolean">
		<cfargument name="Rcodigo" required="yes" type="string">
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Rcodigo
			from Retenciones
			where Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cfreturn false >
		<cfelse>
			<cfreturn true >
		</cfif>
	</cffunction>

	<!---
		Metodo: 
			obtieneSocio
		Resultado:
			Devuelve el id asociado al codigo de socio dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="obtieneSocio" output="false" returntype="query">
		<cfargument name="SNnumero" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select SNcodigo, SNcuentacxc, SNcuentacxp
			from SNegocios
			where SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50864"
							msg  = "@errorDat_1@: El valor del parámetro CodigoSocio no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data >
	</cffunction>
	
	<!---
		Metodo: 
			obtieneOficina
		Resultado:
			Devuelve el id asociado al codigo de Oficina dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="obtieneOficina" output="false" returntype="numeric">
		<cfargument name="Ocodigo" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Ocodigo
			from Oficinas
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			and Oficodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Ocodigo)#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50865"
							msg  = "@errorDat_1@: El valor del parámetro CodigoOficina no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data.Ocodigo>
	</cffunction>

	<!---
		Metodo: 
			obtieneTransaccionCC
		Resultado:
			Devuelve el id asociado al codigo de transaccion de cc dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="obtieneTransaccionCC" output="false" returntype="string">
		<cfargument name="CCTcodigoext" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select CCTcodigo 
			from CCTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			  and CCTcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigoext)#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50866"
							msg  = "@errorDat_1@: El valor del parámetro CCTcodigoext no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data.CCTcodigo>
	</cffunction>

	<!---
		Metodo: 
			obtieneTransaccionCP
		Resultado:
			Devuelve el id asociado al codigo de transaccion de cp dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="obtieneTransaccionCP" output="false" returntype="string">
		<cfargument name="CPTcodigoext" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select CPTcodigo 
			from CPTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			  and CPTcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigoext)#">
		</cfquery>
		<cfif data.recordcount EQ 0>
			<cf_errorCode	code = "50867"
							msg  = "@errorDat_1@: El valor del parámetro CPTcodigoext no existe en la Base de Datos. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
			>
		</cfif>
		<cfreturn data.CPTcodigo>
	</cffunction>
	
	<!---
		Metodo: 
			obtienePorcentajeDescuento
		Resultado:
			Devuelve el porcentaje de descuento asociado al descuento aplicado al a linea
	--->
	<cffunction access="private" name="obtienePorcentajeDescuento" output="false" returntype="string">
		<cfargument name="LparamTotal" 	   required="yes" type="string">
		<cfargument name="LparamDescuento" required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfset LvarPorcentaje = ( 100*LparamDescuento )/arguments.LparamTotal >

		<cfreturn LvarPorcentaje >
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaArticulo
		Resultado:
			Devuelve el id de cuenta contable asciado al Articulo/Almacen
	--->
	<cffunction access="private" name="obtieneCuentaArticulo" output="false" returntype="string">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">
		<cfargument name="LparamCodAid"   	   required="yes" type="string">
		<cfargument name="LparamCodAlm_Aid"   required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select IACcodigo 
			from Existencias 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#">
			and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAid#">
			and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAlm_Aid#">
		</cfquery>
		<cfif data.recordcount eq 0 >
			<cf_errorCode	code = "50868"
							msg  = "@errorDat_1@: No ha sido definida la cuenta contable para el artículo @errorDat_2@ y el almacén @errorDat_3@. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
							errorDat_2="#arguments.LparamCodAid#"
							errorDat_3="#LparamCodAlm_Aid#"
			>
		</cfif>
		<cfreturn data.IACcodigo >
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaConcepto
		Resultado:
			Devuelve el id de cuenta contable asciado al Concepto/Servicio
	--->
	<cffunction access="private" name="obtieneCuentaConcepto" output="false" returntype="string">
		<cfargument name="LparamCid"   	   required="yes" type="string">
		<cfargument name="LparamDcodigo"   required="yes" type="string">
		<cfargument name="LparamCodCid"    required="yes" type="string">
		<cfargument name="metodoInvocador" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfquery name="data" datasource="#Request.CPCC_InterfazDocumentos.GvarConexion#">
			select Ccuenta 
			from CuentasConceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CPCC_InterfazDocumentos.GvarEcodigo#" >
			  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.LparamDcodigo#" >
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.LparamCodCid)#" >
			  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamCid#" >
		</cfquery>

		<cfif data.recordcount eq 0 >
			<cf_errorCode	code = "50869"
							msg  = "@errorDat_1@: No ha sido definida la cuenta contable para el servicio @errorDat_2@ y el departamento @errorDat_3@. Proceso Cancelado!"
							errorDat_1="#Arguments.metodoInvocador#"
							errorDat_2="#arguments.LparamCodCid#"
							errorDat_3="#arguments.LparamDcodigo#"
			>
		</cfif>
		<cfreturn data.Ccuenta >
	</cffunction>

</cfcomponent>

