<cffunction name="Alta_Pagos" access="public" returntype="query">
		<cfargument name="EcodigoSDC" type="string" required="true">
		<cfargument name="TipoCobroPago" type="string" required="true">
		<cfargument name="CodigoBanco" type="string" required="true">
		<cfargument name="CuentaBancaria" type="string" required="true">
		<cfargument name="FechaTransaccion" type="date" required="true">
		<cfargument name="TipoPago" type="numeric" required="true">
		<cfargument name="NumeroDocumento" type="string" required="true">
		<cfargument name="NumeroSocio" type="string" required="false">
		<cfargument name="NumeroSocioDocumento" type="string" required="false">
		<cfargument name="CodigoTransaccion" type="string" required="false">
		<cfargument name="Documento" type="string" required="false">
		<cfargument name="MontoPago" type="string" required="false">
		<cfargument name="MontoPagoDocumento" type="string" default="~" required="false">
		<cfargument name="TipoCambio" type="string" default="~" required="false">		
		<cfargument name="CodigoMonedaPago" type="string" default="~" required="false">		
		<cfargument name="CodigoMonedaDoc" type="string" default="~" required="false">
		<cfargument name="TransaccionOrigen" type="string" default="~" required="false">	
		<cfargument name="BMUsucodigo" type="string" default="~" required="false">	

		<!--- Obtiene Ids --->
		<cfset var LTipoCP = getTipoCP(Arguments.TipoCobroPago,'Alta_Pagos')>
		<cfset var LBid = getBid(Arguments.CodigoBanco,'Alta_Pagos')>
		<!--- Valida Campos --->
		<cfset var LcuentaFinan = getCBcc_vIntegridad(Arguments.CuentaBancaria,Arguments.FechaTransaccion,'Alta_Pagos')>
		<cfset var LFecha = getFecha_vIntegridad(Arguments.FechaTransaccion,'Alta_Pagos')>
		<cfset var LTipoPago = getTipPago_vIntegridad(Arguments.TipoPago,'Alta_Pagos')>
		<cfset var LMcodigo = getMcodigobyMiso(Arguments.CodigoMonedaPago,'Alta_Pagos')>
		<cfset var LSNcodigo = getSNcodigo(Arguments.NumeroSocio,'Alta_Pagos')>
		<cfset var LSNcodigoDoc = getSNcodigo(Arguments.NumeroSocioDocumento,'Alta_Pagos')>
		<cfset var LCodTran = getCodTran(Arguments.CodigoTransaccion,LTipoCP, 'Alta_Pagos')>
		<cfset var LDocumento = getDoc(Arguments.Documento, 'Alta_Pagos')>
		<cfset var LMontoPago = getMontoDoc(Arguments.MontoPago, LDocumento, 'Alta_Pagos')>
		<cfset var LExisteDoc = getExisteDoc(Arguments.Documento, 'Alta_Pagos')>
		

		<cfif isdefined("LExisteDoc") and LExisteDoc EQ 1>
			<cfset existPago = true>
		<cfelse>
			<cfset existPago = false>
		</cfif>
		<cfif not existPago >		
			<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
				<cfquery name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					insert into Pagos 
					(Ecodigo
					, CCTcodigo
					, Pcodigo
					, Mcodigo
					, Ptipocambio
					, Seleccionado
					, Ccuenta
					, Ptotal
					, Pfecha
					, Preferencia
					, Pobservaciones
					, Ocodigo
					, SNcodigo
					, Pusuario)
               		values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char"    value="#LCodTran#"> 
					, <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.NumeroDocumento)#">  
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">
					, 0
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">
					, 0
					, <cfqueryparam cfsqltype="cf_sql_date"    value="#LFecha#"> 
					, <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.TransaccionOrigen)#"> 
					, 'Documento Generado por la Interfaz de Pago de SOIN, Doc. Num: ' || <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.NumeroDocumento)#">  
					,  <cfqueryparam cfsqltype="cf_sql_integer" value="#LOcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSNcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
					)
					<cf_dbidentity1 datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
			
				<!--- Insertar detalle---> 
				<cfquery name="insertD"  datasource="#Request.CP_InterfazPagos.GvarConexion#">
						insert into DPagos
							(Ecodigo
							, Pcodigo
							, CCTcodigo
							, Doc_CCTcodigo
							, Ddocumento
							, Mcodigo
							, Ccuenta
							
							, DPmonto
							, DPmontodoc
							, DPtipocambio
							, DPtotal
							, DPmontoretdoc
							, PPnumero
							, BMUsucodigo)
						values (
						  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.NumeroDocumento)#"> 
						, <cfqueryparam cfsqltype="cf_sql_char"    value="#LCodTran#"> 
						, <cfqueryparam cfsqltype="cf_sql_char"    value="#LCodTran#"> 
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#"> 
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoPago#">  
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoPago#">  
						, 0
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoPagoDocumento#">  
						, 0
						, 1 				
						,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
						)
				</cfquery>
				<cfquery  name="rsPagos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select Ecodigo, CCTcodigo, Pcodigo, #Arguments.TipoMovCP# as TipoCP
					from Pagos
					where Ecodigo = <cfqueryparam value="#Request.CP_InterfazPagos.GvarEcodigo#" cfsqltype="cf_sql_integer">
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
					  and Pcodigo =  <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.NumeroDocumento)#">  
				</cfquery>	
			
			<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>
				<cfquery name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					insert into EPagosCxP 
						(Ecodigo
					, Ocodigo
					, Mcodigo
					, SNcodigo
					, Ccuenta
					, CPTcodigo
					, CBid
					, BTid
					, EPbeneficiario
					, EPdocumento
					, EPtipocambio
					, EPtotal
					, EPtipopago
					, EPfecha
					, EPusuario
					, EPselect)
					values (
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#LOcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSNcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">
					, <cfqueryparam cfsqltype="cf_sql_char"    value="#LCodTran#"> 
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LBid#"> 
					, ''
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">
					, 0
					, <cfqueryparam cfsqltype="cf_sql_money"   value="#Arguments.MontoPago#">  
					, <cfqueryparam cfsqltype="cf_sql_char"    value="#LTipoPago#"> 
					, <cfqueryparam cfsqltype="cf_sql_date"    value="#LFecha#"> 
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
					, 0)
					<cf_dbidentity1 datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
				</cfquery>
				
				<cf_dbidentity2 name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
			
				<!--- Insertar detalle---> 
				<cfquery name="insertD"  datasource="#Request.CP_InterfazPagos.GvarConexion#">
						insert into DPagosCxP
							(IDpago
							, IDdocumento
							, Ccuenta
							, Ecodigo
							, Dcodigo
							, DPmonto
							, DPtotal
							, DPmontodoc
							, DPtipocambio
							, DPmontoretdoc
							, BMUsucodigo
							)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertE.identity#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LDocumento#"> 
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#"> 
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						, null
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoPago#">  
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoPago#">  
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.MontoPagoDocumento#">  
						, 0
						, 0
						,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
						)
				</cfquery>	
				
				<!--- Actualizar EPtotal--->
				<cfquery datasource="#Request.CP_InterfazPagos.GvarConexion#">
						update EPagosCxP
						set EPtotal = <cfqueryparam value="#getMontoTotal(insertE.identity)#" cfsqltype="cf_sql_money">
						where IDpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertE.identity#">
						  and Ecodigo = <cfqueryparam value="#Request.CP_InterfazPagos.GvarEcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery  name="rsPagos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select IDpago, Ecodigo, CPTcodigo, Pcodigo, #Arguments.TipoMovCP# as TipoCP
					from EPagosCxP
					where IDpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertE.identity#">
						  and Ecodigo = <cfqueryparam value="#Request.CP_InterfazPagos.GvarEcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			
		</cfif>
	</cfif>
	<cfreturn rsPagos>
</cffunction>
		<!--- 6 Validaciones de integridad de las tablas referenciadas por el pago. --->
		<cffunction access="private" name="getFecha_vIntegridad" output="false" returntype="date">
			<cfargument name="fecha" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
	
			<cfif isdefined("Arguments.fecha") and not isdate(Arguments.fecha)>
				<cfthrow message="La fecha de la función #Arguments.InvokerName# no es del formato correcto. Proceso Cancelado!">
			<cfelseif  isdefined("Arguments.fecha")>
				<cfreturn Arguments.fecha>
			</cfif>	
		</cffunction>	
		<cffunction access="private" name="getTipoCP" output="false" returntype="string">
			<cfargument name="TipPago" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
	
			<cfif isdefined("Arguments.TipoCobroPago") and (Arguments.TipoCobroPago NEQ 'C' or Arguments.TipoCobroPago NEQ 'P')>
				<cfthrow message="El tipo de pago de la función #Arguments.InvokerName# no es el correcto. Proceso Cancelado!">
			<cfelseif  isdefined("Arguments.TipoCobroPago")>
				<cfreturn Arguments.TipoCobroPago>
			</cfif>	
		</cffunction>	
	
		<cffunction access="private" name="getBid" output="false" returntype="numeric">
			<cfargument name="CodigoBanco" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
			<cfquery name="rsBancos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select Bid
				from Bancos
				where Iaba = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoBanco)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			</cfquery>
			<cfif rsBancos.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El valor del Banco no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfreturn rsBancos.Bid>		
		</cffunction>

		<cffunction access="private" name="getCBcc_vIntegridad" output="false" returntype="query">
			<cfargument name="Cuenta" required="no" type="string">
			<cfargument name="fechaSolic" required="yes" type="date">		
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
	
			<cfif isdefined('Arguments.Cuenta') and Arguments.Cuenta NEQ ''>				
				<cfquery name="rsCuentasBancos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					Select CBcc, Ocodigo, Ccuenta
					from CuentasBancos
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBancos.Bid#">	
				</cfquery>
	
				<cfif rsCuentasBancos.recordCount EQ 0>
					<cfthrow message="El valor de la cuenta pasado a la función #Arguments.InvokerName# no existe. Proceso Cancelado!">
				</cfif>			
			</cfif>
			
			<cfreturn #rsCuentasBancos#>
		</cffunction>	
		<cfif isdefined("rsCuentasBancos") and rsCuentasBancos.RecordCount NEQ 0>
			<cfset  LCBcc = rsCuentasBancos.CBcc>
			<cfset  LOcodigo = rsCuentasBancos.Ocodigo>
			<cfset  LCcuenta = rsCuentasBancos.Ccuenta>
		<cfelse>
			<cfset  LCBcc = ''>
			<cfset  LOcodigo = 0>
			<cfset  LCcuenta = ''>
		</cfif>
		
		<cffunction access="private" name="getTipPago_vIntegridad" output="false" returntype="string">
			<cfargument name="TipPago" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
	
			<cfif isdefined("Arguments.TipPago") and (Arguments.TipPago NEQ 'T' or Arguments.TipPago NEQ 'C')>
				<cfthrow message="El tipo de pago de la función #Arguments.InvokerName# no es el correcto. Proceso Cancelado!">
			<cfelseif  isdefined("Arguments.TipPago")>
				<cfreturn Arguments.TipPago>
			</cfif>	
		</cffunction>	
		
		<cffunction access="private" name="getSNcodigo" output="false" returntype="numeric">
			<cfargument name="SNnumero" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
			<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select SNcodigo
				from SNegocios a
				where SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNnumero#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			</cfquery>
			<cfif rs.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoProveedor no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfreturn rs.SNcodigo>
		</cffunction>
		
		<cffunction access="private" name="getMcodigobyMiso" output="false" returntype="string">
			<cfargument name="Miso" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
			<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select Mcodigo
				from Monedas
				where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Miso)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			</cfquery>
			<cfif rs.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoMoneda no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfreturn rs.Mcodigo>
		</cffunction>
		
		<cffunction access="private" name="getCodTran" output="false" returntype="string">
			<cfargument name="CodigoTran" required="yes" type="string">
			<cfargument name="TipoMovCP" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
			
			<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
				<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select CCTcodigo as codigo
					from CCTransacciones
					where CCTcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoTran)#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				</cfquery>
			<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>
				<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select CPTcodigo as codigo
					from CPTransacciones
					where CPTcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoTran)#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				</cfquery>
			</cfif>			
			
			<cfif rs.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El valor de la transacción no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfreturn rs.codigo>		
		</cffunction>
		<cffunction access="private" name="getDoc" output="false" returntype="numeric">
			<cfargument name="NumDoc" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
				<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
					<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select Ddocumento as Doc
						from Documentos
						where Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.NumDoc)#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
					</cfquery>
				<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>			
					<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select IDdocumento as Doc
						from EDocumentosCP
						where Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.NumDoc)#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
					</cfquery>
				</cfif>
			<cfif rsDocumentos.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El Documento no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfreturn rsDocumentos.Doc>		
		</cffunction>
		
		<cffunction access="private" name="getExisteDoc" output="false" returntype="numeric">
			<cfargument name="NumDoc" required="yes" type="string">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
				<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
					<cfquery name="rsBMovimientos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select 1 as doc 
						from BMovimientos 
						   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						   and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
						   and Ddocumento =  <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.NumDoc)#">
					</cfquery>
				<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>
					<cfquery name="rsBMovimientos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select 1 as doc 
						from BMovimientosCxP 
						   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						   and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
						   and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.NumDoc)#">
					</cfquery>
				</cfif>
			<cfif rsBMovimientos.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El Documento no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
			<cfreturn rsBMovimientos.doc>		
		</cffunction>
		
		<!--- Comprueba que el monto no del doc no sea mayor que el saldo --->
		<cffunction access="private" name="getMontoDoc" output="false" returntype="numeric">
			<cfargument name="montoDoc" required="yes" type="numeric">
			<cfargument name="NumDoc" required="yes" type="numeric">
			<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
				<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
					<cfquery name="rsEdocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select Dsaldo as saldo
						from Documentos
						where Ddocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NumDoc#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						  and CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
					</cfquery>
				<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>			
					<cfquery name="rsEdocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select EDsaldo as saldo
						from EDocumentosCP
						where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NumDoc#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
						  and CPTcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#LCodTran#"> 
					</cfquery>
				</cfif>
				<cfif rsEdocumentos.RECORDCOUNT EQ 0>
					<cfthrow message="#Arguments.InvokerName#: El Documento no existe en la Base de Datos. Proceso Cancelado!">
				<cfelseif isdefined("rsEdocumentos") and rsEdocumentos.saldo LT Arguments.montoDoc>
					<cfthrow message="#Arguments.InvokerName#: El Documento #trim(Arguments.NumDoc)# no tiene saldo disponible. Proceso Cancelado!">
				</cfif>

			<cfreturn rsEdocumentos.saldo>		
		</cffunction>
		
		<!--- 5.2 Obtiene el monto total del pago  --->
		<cffunction access="private" name="getMontoTotal" output="false" returntype="numeric">
			<cfargument name="IDpago" type="numeric" required="yes">
			<cfset var result = 0.00>
			<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
				

			<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>			
				<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
						select coalesce(sum(DPmonto),0) as total
						from EPagosCxP a
						
						inner join DPagosCxP b
						on a.Ecodigo=b.Ecodigo
						   and a.IDpago=b.IDpago
						where a.IDpago= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDpago#" >
						  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				</cfquery>
			</cfif>

			<cfif rs.recordcount GT 0 and rs.total GT 0.00>
				<cfset result = rs.total>
			</cfif>
			<cfreturn result>
		</cffunction>
