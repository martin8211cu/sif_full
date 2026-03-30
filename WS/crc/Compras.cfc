<cfcomponent displayname="Compras" rest="true" restPath="/compras" produces="application/json">

	<cfset dsn     = "minisif">
	<cfset ecodigo = 2>

	<cffunction name="verificarMedioPago" restPath="/verificar" access="remote" returnformat="JSON"  produces="application/json" httpMethod="GET" returntype="struct">

		<cfargument name="Tipo_Transaccion" required="no"  type="string" restArgName="Tipo_Transaccion" restArgSource="query" default="">
		<cfargument name="Num_Tarjeta" required="no"  type="string" restArgName="Num_Tarjeta" restArgSource="query"  default=""> 
		<cfargument name="Num_Folio"   required="no"  type="string" restArgName="Num_Folio"   restArgSource="query"  default="">
		<cfargument name="Cod_ExtTienda"  required="no"  type="string" restArgName="Cod_ExtTienda"  restArgSource="query"  default=""> 
		<cfargument name="CodExtDist"  required="no"  type="string" restArgName="CodExtDist"  restArgSource="query"  default=""> 	
		<cfargument name="token" 	   required="no"  type="string" restArgName="token"  restArgSource="query"  default=""> 

		<cfset CRCChequearProducto = createObject("component","crc.Componentes.compra.CRCChequearProducto")>
		<cfset CRCChequearProducto.init(dsn,ecodigo)>

		<cfset result = CRCChequearProducto.chequear(Tipo_Transaccion = arguments.Tipo_Transaccion,
													  Num_Tarjeta     = arguments.Num_Tarjeta,
													  Num_Folio       = arguments.Num_Folio,
													  Cod_ExtTienda   = arguments.Cod_ExtTienda,
													  CodExtDist      = arguments.CodExtDist, 
													  token           = arguments.token)>  

		<cfreturn result>

	</cffunction>
	


	<cffunction name="registrarCompra" restPath="/registrarCompra" access="remote" returnformat="JSON"  produces="application/json" httpMethod="POST" returntype="struct">

		<cfargument name="Fecha_Transaccion" required="no"  type="string" restArgName="Fecha_Transaccion" restArgSource="query" default="">
		<cfargument name="Monto" 		     required="no"  type="string" restArgName="Monto" restArgSource="query" default="">
		<cfargument name="Tipo_Transaccion"  required="no"  type="string" restArgName="Tipo_Transaccion" restArgSource="query" default="">
		<cfargument name="Num_Tarjeta"       required="no"  type="string" restArgName="Num_Tarjeta" restArgSource="query" default=""> 
		<cfargument name="Cod_Tienda" 	     required="no"  type="string" restArgName="Cod_Tienda"  restArgSource="query" default="">
		<cfargument name="Cod_ExtTienda" 	 required="no"  type="string" restArgName="Cod_ExtTienda" restArgSource="query" default="">
		<cfargument name="Num_Ticket" 	     required="no"  type="string" restArgName="Num_Ticket"  restArgSource="query" default="">
		<cfargument name="Num_Folio" 		 required="no"  type="string" restArgName="Num_Folio"   restArgSource="query" default="">
		<cfargument name="CodExtDist" 		 required="no"  type="string" restArgName="CodExtDist"  restArgSource="query" default="">
                          
		<cfargument name="Cliente" 			 required="no"  type="string" restArgName="Cliente" restArgSource="query" default="">
		<cfargument name="Observaciones"     required="no"  type="string" restArgName="Observaciones" restArgSource="query" default=""> 
		<cfargument name="Parcialidades"  	 required="no"  type="string" restArgName="Parcialidades" restArgSource="query" default="">
		<cfargument name="Fecha_Inicio_Pago" required="no"  type="string" restArgName="Fecha_Inicio_Pago" restArgSource="query" default="">
		<cfargument name="CURP" 			 required="no"  type="string" restArgName="CURP"        restArgSource="query" default="">
		<cfargument name="GeneraContraVale"  required="no"  type="string" restArgName="GeneraContraVale"  restArgSource="query" default="">
		<cfargument name="token" 	         required="no"  type="string" restArgName="token"  restArgSource="query"  default=""> 		
		<cfargument name="cadenaEmpresa"     required="no"  type="string" restArgName="cadenaEmpresa" restArgSource="query"  default=""> 	
		<cfargument name="sucursal" 	     required="no"  type="string" restArgName="sucursal"  restArgSource="query"  default=""> 
		<cfargument name="caja" 	         required="no"  type="string" restArgName="caja"  restArgSource="query"  default=""> 		
 		 
	 <cftry>
		<cfset cRCTransaccionCompra = createObject("component","crc.Componentes.compra.CRCTransaccionCompra")>
		<cfset cRCTransaccionCompra.init(dsn,ecodigo)>
		<cfset result = cRCTransaccionCompra.procesarCompra( Fecha_Transaccion = arguments.Fecha_Transaccion,
															  Monto             = arguments.Monto,
															  Tipo_Transaccion  = arguments.Tipo_Transaccion,
															  Num_Tarjeta       = arguments.Num_Tarjeta,
															  Cod_Tienda        = arguments.Cod_Tienda,
															  Cod_ExtTienda     = arguments.Cod_ExtTienda, 
															  Num_Ticket        = arguments.Num_Ticket,
															  Num_Folio         = arguments.Num_Folio,
															  CodExtDist        = arguments.CodExtDist,
															  Cliente           = arguments.Cliente,
															  Observaciones     = arguments.Observaciones,
															  Parcialidades     = arguments.Parcialidades,
															  Fecha_Inicio_Pago = arguments.Fecha_Inicio_Pago,
															  CURP              = arguments.CURP,
															  GeneraContraVale  = arguments.GeneraContraVale,
															  token             = arguments.token,
															  cadenaEmpresa     = arguments.cadenaEmpresa,
															  sucursal          = arguments.sucursal,
															  caja              = arguments.caja 
															  )>  		
		<cfreturn result>
 
		<cfcatch>
			<cfset result = structNew()>
			<cfset result.codigo  = #cfcatch.ErrorCode#> 
			<cfset result.mensaje = #cfcatch.message#> 
			<cfreturn result>
		</cfcatch>

	</cftry>	  
	 
	</cffunction>	

 
	<cffunction name="reverso" restPath="/reverso" access="remote" returnformat="JSON"  produces="application/json" httpMethod="POST" returntype="struct"> 
		<cfargument name="cadenaEmpresa" required="no"  type="string" restArgName="cadenaEmpresa"  restArgSource="query"  default="">  
		<cfargument name="sucursal" required="no"  type="string" restArgName="sucursal"  restArgSource="query"  default=""> 		
		<cfargument name="caja" 	required="no"  type="string" restArgName="caja"      restArgSource="query"  default=""> 
		<cfargument name="ticket" 	required="no"  type="string" restArgName="ticket"    restArgSource="query"  default=""> 
		<cfargument name="token" 	required="no"  type="string" restArgName="token"     restArgSource="query"  default=""> 

		<cftry>

			<cfset cRCTransaccionCompra = createObject("component","crc.Componentes.compra.CRCTransaccionCompra")>
			<cfset cRCTransaccionCompra.init(dsn,ecodigo)>
			<cfset result = cRCTransaccionCompra.reverso( cadenaEmpresa = arguments.cadenaEmpresa,
														  sucursal      = arguments.sucursal,
														  caja          = arguments.caja,
														  ticket        = arguments.ticket,
														  token 		= arguments.token)>  		
			<cfreturn result>

			<cfcatch>
				<cfset result = structNew()>
				<cfset result.codigo  = #cfcatch.ErrorCode#> 
				<cfset result.mensaje = #cfcatch.message#> 
				<cfreturn result>
			</cfcatch>

		</cftry>
	</cffunction>

	<cffunction name="cancelacion" restPath="/cancelacion" access="remote" returnformat="JSON"  produces="application/json" httpMethod="POST" returntype="struct"> 
		<cfargument name="consecutivoTransaccion"  required="no"  type="string" restArgName="consecutivoTransaccion"  restArgSource="query"  default=""> 		 
		<cfargument name="token" required="no"  type="string" restArgName="token"  restArgSource="query"  default=""> 

		<cftry>

			<cfset cRCTransaccionCompra = createObject("component","crc.Componentes.compra.CRCTransaccionCompra")>
			<cfset cRCTransaccionCompra.init(dsn,ecodigo)>
			<cfset result = cRCTransaccionCompra.cancelacion( consecutivoTransaccion = arguments.consecutivoTransaccion,
														  	  token = arguments.token)>  		
			<cfreturn result>

			<cfcatch>
				<cfset result = structNew()>
				<cfset result.codigo  = #cfcatch.ErrorCode#> 
				<cfset result.mensaje = #cfcatch.message#> 
				<cfreturn result>
			</cfcatch>

		</cftry>

	</cffunction>	

	<cffunction name="timbra" restPath="/timbra" access="remote" returnformat="JSON"  produces="application/json" httpMethod="POST" returntype="struct"> 
        <cfargument  name="xml33" required="true" type="string" restArgName="xml33"  restArgSource="form">
        <cfargument  name="dev" required="false" type="boolean" default=false restArgName="dev"  restArgSource="form">
        
        <cftry>

			<cfset result = StructNew()>

        	<cfset result.ok = true>
			
			<cfif true>
				<cfset LvarUrl="https://test02.cfdinova.com.mx/axis2/services/TimbradorIntegradores?wsdl">
				<cfset LvarToken="tokjtzqUlkiDW"> 
				<cfset LvarUsuario="usrQbCPTx7OC5"> 
				<cfset LvarPassword="pswVgaTUEvh71"> 
				<cfset LvarCuenta="cta7demTmKhj2"> 
			<cfelse>
				<cfset LvarUrl = "http://www.tusfacturas.com.mx:59080/axis2/services/TimbradorIntegradores?wsdl">
				<cfset LvarToken="tokhlOxMGKK9L"> 
				<cfset LvarUsuario="usrpFpou3rJya"> 
				<cfset LvarPassword="pswRugju3hNCP"> 
				<cfset LvarCuenta="ctaro3iK0qUVk">
			</cfif>
			
			<cfinvoke webservice="#LvarUrl#" method="get" returnvariable="xmlTimbrado">
				<cfinvokeargument name="cad" value = "#arguments.xml33#"/>
				<cfinvokeargument name="tk" value = "#Lvartoken#"/>
				<cfinvokeargument name="user" value = "#LvarUsuario#"/>
				<cfinvokeargument name="pass" value = "#LvarPassword#"/>
				<cfinvokeargument name="cuenta" value = "#LvarCuenta#"/>
			</cfinvoke>  	

			<cfset match = REMatch("<ERROR codError='\d+'.*?>.*?<\/ERROR>",xmlTimbrado)>
			
            <cfif ArrayIsEmpty(match) eq false>
                <cfset match2 = REMatch("codError='\d+'",xmlTimbrado)>
				<cfset result.ok = false>
                <cfset result.message="No se ha creado el XML [#match2[1]#] #match[1]#">
			<cfelse>
				<cfset result.xml = xmlTimbrado>
            </cfif>

			<cfreturn result>

		<cfcatch>
			<cfset result = structNew()>
			<cfset result.codigo  = #cfcatch.ErrorCode#> 
			<cfset result.mensaje = #cfcatch.message#> 
			<cfreturn result>
		</cfcatch>

		</cftry>     
        

    </cffunction>


</cfcomponent>