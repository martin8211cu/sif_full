<cfcomponent>
	<!---
		Modificado por danim, 30-Oct-2007
		Agrego la funcionalidad para que los pagos cuyo MontoPago sea menor a cero
		aparezcan correctamente en CxC de la siguiente manera:
			1.	Se genera un documento en C/C (EDocumentosCxC/DDocumentosCxC) de
				tipo 'PC' (Pago con cheque) con una linea de servicio y la cuenta de bancos
			2.	Se aplica este documento
			3.	Se genera una relación de aplicación de documentos a favor
				para anular este documento 'PC' con el anticipo o NC cuyo importe
				se está reembolsando.
		This.Ccodigo es el concepto de servicios para la línea de DDocumentosCxC
		This.CFcodigo es el centro funcional para la línea de DDocumentosCxC
		This.CCTreembolso es el tipo doc para en documento en EDocumentosCxC
	--->

	<cfset This.Ccodigo  = '10'>  <!--- Concepto de servicios para reembolsos --->
	<cfset This.CFcodigo = 'RAIZ'>  <!--- Centro Funcional de servicios para reembolsos --->
    <cfset This.CCTreembolso = 'PC'>

	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="EcodigoSDC" 	required="no" type="numeric" 	default="0">
		<cfargument name="Conexion" 	required="no" type="string" 	default="#Session.Dsn#">
		<cfargument name="Ecodigo" 		required="no" type="numeric" 	default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 	required="no" type="string" 	default="#Session.Usucodigo#">
		<cfargument name="Usuario" 		required="no" type="string" 	default="#Session.Usuario#">

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
				<cfthrow message="CM_InterfazDocumentos: El valor del par&aacute;metro EcodigoSDC es incorrecto o no corresponde con el Código de Empresa de la Sesion. Proceso Cancelado!">
			</cfif>
		</cfif>

		<cfif not isdefined("Request.CP_InterfazPagos.Initialized")>
			<cfset Request.CP_InterfazPagos.Initialized  = true>
			<cfset Request.CP_InterfazPagos.GvarConexion  = Session.Dsn>
			<cfset Request.CP_InterfazPagos.GvarEcodigo   = Session.Ecodigo>	
			<cfset Request.CP_InterfazPagos.GvarUsuario   = Session.Usuario>
			<cfset Request.CP_InterfazPagos.GvarUsucodigo = Session.Usucodigo>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="Procesa_Pago" access="public" returntype="boolean">
		<cfargument name="query" required="yes" type="query">
		<cfif ( query.MontoPago LT 0 ) And ( query.TipoCobroPago is 'C' ) >
			<cfreturn Procesa_Reembolso(query)>
		<cfelse>
			<cfreturn Procesa_Pago_Normal(query)>
		</cfif>
	</cffunction>
	
	<cffunction name="Procesa_Pago_Normal" access="private" returntype="boolean">
		<cfargument name="query" required="yes" type="query">
		
		<cfoutput query="query" group="ID">
			<cfset  CodigoAnticipos	   = 'AN'> <!---Codigo de las transacciones de Anticipos, que se crean cuando sobra dinero del pago(Hay que evaluar como no dejar quemado este codigo)--->
			<cfset  LTipoCP 		   = getTipoCP(query.TipoCobroPago,'getTipoCP')>
			<cfset  LBid 			   = getBid(query.CodigoBanco,'getBid')>         						    <!--- Cod banco --->
			<cfset  LcuentaFinan 	   = getCBcc_vIntegridad(query.CuentaBancaria,LBid,'getCBcc_vIntegridad')>	<!--- cuenta --->
			<cfset  LFecha 			   = getFecha_vIntegridad(query.FechaTransaccion,'getFecha_vIntegridad')>	<!--- fecha --->
			<cfset  LTipoPago 		   = getTipPago_vIntegridad(query.TipoPago,'getTipPago_vIntegridad')>		<!--- tipo de pago --->
			<cfset  LMcodigo 		   = getMcodigobyMiso(query.CodigoMonedaPago,'getMcodigobyMiso')>			<!--- moneda --->
			<cfset  LTipoCambio 	   = getTipoCambio(query.CodigoMonedaPago,'getMcodigobyMiso',LFecha)>		<!--- Tipo de cambio --->
			<cfset  rsSNpago		   = getSNegocios(query.NumeroSocio,'getSNegocios')>						<!--- Socio de negocios --->
			<cfset  rsSNdoc			   = getSNegocios(query.NumeroSocioDocumento,'getSNegocios')>				<!--- Socio de negocios --->

			<cfif LtipoCP EQ 'C'>
				<cfif not len(rsSNpago.SNcuentaCxC) or rsSNpago.SNcuentaCxC LT 1>
					<cfthrow message="Error.  No se ha definido la cuenta de CxC del Socio de Negocios: #query.NumeroSocio#" detail="Debe definir la cuenta en el catalogo de socios">
					<cfabort>
				</cfif>
			<cfelse>
				<cfif not len(rsSNpago.SNcuentaCxP) or rsSNpago.SNcuentaCxP LT 1>
					<cfthrow message="Error.  No se ha definido la cuenta de CxP del Socio de Negocios: #query.NumeroSocio#" detail="Debe definir la cuenta en el catalogo de socios">
					<cfabort>
				</cfif>
<!---        Inicia cambio para procesar pago de anticipos CxP  --->
				<cfif query.Anticipo NEQ 0>
                    <cfquery name="rsSaldoDocumento" datasource="#session.DSN#">
                        select EDsaldo
                        from EDocumentosCP
                        where Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(query.DocumentoL)#">
                    </cfquery>
					<cfset LvarSaldoActual = 0.00>
					<cfif isdefined('rsSaldoDocumento') and rsSaldoDocumento.recordcount GT 0>
                        <cfset LvarSaldoActual = rsSaldoDocumento.EDsaldo>
                        <cfif #LvarSaldoActual# lt abs(#query.MontoPago#)>
                            <cfthrow message="Error. El saldo del anticipo #trim(query.DocumentoL)# #LvarSaldoActual# es menor al saldo del documento #abs(query.MontoPago)#" detail="El saldo del documento debe ser menor o igual al saldo del Anticipo">
                            <cfabort>
                        </cfif>
                    </cfif>
                </cfif>
<!---        Termina cambio para procesar pago de anticipos CxP  --->
			</cfif>
            

			<!--- ************************************************************ C X C ************************************************************ --->
			<cfif isdefined("LTipoCP") and LTipoCP EQ 'C'>
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
					  <cfqueryparam cfsqltype="cf_sql_integer"	value="#Request.CP_InterfazPagos.GvarEcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char"    	value="RE"> 
					, <cfqueryparam cfsqltype="cf_sql_char"    	value="#trim(query.NumeroDocumento)#">  
					, <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LMcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_float" 	value="#LTipoCambio#">
					, 0
					, <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LCcuenta#">
					, <cfqueryparam cfsqltype="cf_sql_money" 	value="#query.MontoPago#">
					, <cfqueryparam cfsqltype="cf_sql_date"    	value="#LFecha#"> 
					, <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(query.TransaccionOrigen)#"> 
					, 'Documento Generado por la Interfaz de Pago de SOIN, Doc. Num: ' + <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(query.NumeroDocumento)#">  
					,  <cfqueryparam cfsqltype="cf_sql_integer" value="#LOcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsSNpago.SNcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Session.Usuario#">
					)
				</cfquery>
			<!--- ************************************************************ C X P ************************************************************ --->
			<cfelseif isdefined("LTipoCP") and LTipoCP EQ 'P'>
				<cfset LvTipoPago = query.TipoPago>
				<cfset LBTid = getCodBTid('RE', 'getCodBTid')>
				<cfquery name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					insert into EPagosCxP 
						(
							  Ecodigo
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
							, EPselect
						)
					values (
							  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LOcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNpago.SNcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">
							, <cfqueryparam cfsqltype="cf_sql_char"    value="RE"> 
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LcuentaFinan.CBid#"> 
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LBTid#">  
							, 'Documento Generado por la Interfaz de Pago de SOIN, Doc. Num: ' + <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(query.NumeroDocumento)#">  
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#query.NumeroDocumento#">
							, <cfqueryparam cfsqltype="cf_sql_float"   value="#LTipoCambio#">
							, <cfqueryparam cfsqltype="cf_sql_money"   value="#query.MontoPago#">  
							, <cfqueryparam cfsqltype="cf_sql_char"    value="#LTipoPago#"> 
							, <cfqueryparam cfsqltype="cf_sql_date"    value="#LFecha#"> 
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							, 0
						)
					<cf_dbidentity1 datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
				<cfif len(insertE.identity) eq 0 or insertE.identity eq 0>
					<cfthrow message="Error: No se pudo insertar el documento de pago de cxp. Proceso Cancelado!">
				</cfif>
			</cfif>
			<!--- Control de Diferencias entre Pagos realizados y Saldo de Documentos, para generar anticipos por dicha diferencia --->
			<cfoutput>
<!---        Inicia cambio para procesar pago de anticipos CxP  --->
				<cfif LtipoCP EQ 'P'>	
                    <cfquery name="rsEdocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
                        select CPTcodigo
                        from EDocumentosCP
                        where 
                            Ddocumento		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(query.DocumentoL)#">
                            and SNcodigo	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsSNdoc.SNcodigo#">
                            and CPTcodigo	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#CodigoAnticipos#"> 
                            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
                    </cfquery>
<!---    <cflog file="raul" text="#trim(query.DocumentoL)#">
    <cflog file="raul" text="#rsSNdoc.SNcodigo#">
--->    
                    <cfif rsEdocumentos.RECORDCOUNT EQ 1>
                        <cfset query.Anticipo = 0>
                    </cfif>
<!---    <cflog file="raul" text="#query.Anticipo#">
--->    
                </cfif>
<!---        Termina cambio para procesar pago de anticipos CxP  --->             
            
            
            
				<!--- Inserta todos los detalles del pago(No es un Anticipo)--->
				<cfif query.Anticipo EQ 0>
					<cfset  LCodTran   = getCodTran(query.CodigoTransaccionL,LTipoCP, false,'getCodTran')>				<!--- Cod transaccion --->
					<cfset  LDocumento = getDoc(query.DocumentoL, query.TipoCobroPago, LCodTran, rsSNdoc.SNcodigo, false, 'getDoc')>		<!--- Documento a pagar --->
					<cfset  LMontoPago = getMontoDoc(query.MontoPagoDocumentoL, LDocumento.Doc, query.TipoCobroPago, LDocumento.CodigoTransaccion,'getMontoDoc')> 	<!---Valida que el monto de cada linea del pago no sea mayor al saldo de la Factura --->
					<!--- El monto de los anticipos por diferencia se debe de obtener en la moneda del recibo, por lo que hay que hacer conversión de datos 
						LmontoPago:                    Monto del Pago en la moneda de la factua
						LMontoPagoRec :                Monto del Pago en la moneda del recibo
						LvarMontoAnticiposDiferencia:  Monto del Anticipo generado por las diferencias entre el monto de la factura y el saldo de la factura
					--->
					<cfif query.MontoPagoDocumentoL GT LmontoPago>
						<cfset LmontoPagoRec = numberformat(query.MontoPagoL * (LMontoPago / query.MontoPagoDocumentoL), "9.00")>
					<cfelseif query.MontoPagoDocumentoL LTE LmontoPago>
						<cfset LmontoPago = query.MontoPagoDocumentoL>
						<cfset LmontoPagoRec = query.MontoPagoL>
					</cfif>
					<!--- 
						<cfset  LExisteDoc = getExisteDoc(query.DocumentoL,query.TipoCobroPago, LCodTran,'getExisteDoc')>
					--->
					<cfset  LvTipoPago = query.TipoPago>															<!--- tipo de pago --->
					<!--- ************************************************************ C X C ************************************************************ --->
					<cfif isdefined("LTipoCP") and LTipoCP EQ 'C'>
						<!--- Insertar detalle---> 
						<cfif LmontoPagoRec eq 0>
							<cfset LvarTipoconversion = 1>	
						<cfelse>
							<cfset LvarTipoconversion = LmontoPago/LmontoPagoRec>
						</cfif>
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
								, <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(query.NumeroDocumento)#">
								, <cfqueryparam cfsqltype="cf_sql_char"    value="RE">
								, <cfqueryparam cfsqltype="cf_sql_char"    value="#LDocumento.CodigoTransaccion#">
								, <cfqueryparam cfsqltype="cf_sql_char"    value="#LDocumento.Doc#">
								<!--- , <cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#"> --->
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LDocumento.Mcodigo#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LDocumento.Cuenta#">
								, <cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(LmontoPagoRec,"9.00")#">

								, <cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(LmontoPago,"9.00")#">
								, <cfqueryparam cfsqltype="cf_sql_float"   value="#LvarTipoconversion#"><!--- Tipo de Cambio entre el documento de pago y el documento --->
								, <cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(LmontoPagoRec,"9.00")#">
								, 0
								, 1
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
								)
						</cfquery>						
					<!--- ************************************************************ C X P ************************************************************ --->
					<cfelseif isdefined("LTipoCP") and LTipoCP EQ 'P'>
						<cfif LmontoPagoRec eq 0>
							<cfset LvarTipoconversion = 1>	
						<cfelse>
							<cfset LvarTipoconversion = LmontoPago/LmontoPagoRec>
						</cfif>
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
							values (
							  <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertE.identity#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LDocumento.doc#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LDocumento.Cuenta#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
							, null
							, <cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(LmontoPagoRec,"9.00")#">
							, <cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(LmontoPagoRec,"9.00")#">
							, <cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(LmontoPago,"9.00")#">
							, <cfqueryparam cfsqltype="cf_sql_float"   value="#LvarTipoconversion#"><!--- Tipo de Cambio entre el documento de pago y el documento --->
							, <cfqueryparam cfsqltype="cf_sql_money" value="#query.MontoRetencion#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CP_InterfazPagos.GvarUsucodigo#">
							)
						</cfquery>
					</cfif>
				<cfelse>
					<cfset  LCodTranAnt	= getCodTran(query.CodigoTransaccionL,LTipoCP, true, 'getCodTran')>					<!--- Cod transaccion --->
					<cfset  getDoc(query.DocumentoL, query.TipoCobroPago, LCodTranAnt, rsSNpago.SNcodigo, true, 'getDoc')>	<!--- Documento a pagar --->
					
					<cfset NC_Ccuenta = getNC_CcuentaCP(rsSNpago.SNcodigo,LTipoCP,LCodTranAnt)>
					
					<cfif isdefined("LTipoCP") and LTipoCP EQ 'C'>
						<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_AltaAnticipo" returnvariable="LineAnticipo">
						   	<cfinvokeargument name="Conexion"       value="#Request.CP_InterfazPagos.GvarConexion#">
						   	<cfinvokeargument name="Ecodigo"        value="#Request.CP_InterfazPagos.GvarEcodigo#">
						   	<cfinvokeargument name="CCTcodigo"      value="RE">
							<cfinvokeargument name="Pcodigo"        value="#trim(query.NumeroDocumento)#">
							<cfinvokeargument name="NC_Ddocumento"  value="#query.DocumentoL#">
							<cfinvokeargument name="NC_Ccuenta"     value="#NC_Ccuenta#">
							<cfinvokeargument name="NC_fecha"       value="#LFecha#">
							<cfinvokeargument name="id_direccion"   value="#rsSNpago.id_direccion#">
							<cfinvokeargument name="NC_total"       value="#query.MontoPagoL#">
							<cfinvokeargument name="NC_CCTcodigo"   value="#LCodTranAnt#">
                        </cfinvoke>
					<cfelseif isdefined("LTipoCP") and LTipoCP EQ 'P'>
						<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_AltaAnticipo" returnvariable="LineAnticipo">
						   	<cfinvokeargument name="Conexion"       value="#Request.CP_InterfazPagos.GvarConexion#">
						   	<cfinvokeargument name="IDpago"       	value="#insertE.identity#">
						   	<cfinvokeargument name="NC_CPTcodigo"   value="#LCodTranAnt#">
						   	<cfinvokeargument name="NC_Ddocumento"  value="#query.DocumentoL#">
						   	<cfinvokeargument name="NC_Ccuenta"     value="#NC_Ccuenta#">
							<cfinvokeargument name="NC_fecha"     	value="#LFecha#">
							<cfinvokeargument name="id_direccion"   value="#rsSNpago.id_direccion#">
						   	<cfinvokeargument name="NC_total"       value="#query.MontoPagoL#">
						</cfinvoke>
					</cfif>
				</cfif>
			</cfoutput>
		</cfoutput>
		
		<!--- Procesar el monto de los anticipos. Validar el Tipo de Transacción --->
		
		<!--- OJO. Mauricio Esquivel  27 / Febrero / 2006.  Cambio particular para PMI.  Hay que cambiar el tipo de transaccion fijo 'AN' por el correcto --->
			<cfif isdefined("LTipoCP") and LTipoCP EQ 'C'>
				<!---Crea un Anticipo con la Diferencia del cobro para cuentas por cobrar - Lineas de detalle -Anticipos--->
				<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoTotales" returnvariable="rsAPagosCxCTotal">
					<cfinvokeargument name="Conexion" 	    value="#Request.CP_InterfazPagos.GvarConexion#">
					<cfinvokeargument name="Ecodigo" 	    value="#Request.CP_InterfazPagos.GvarEcodigo#">
					<cfinvokeargument name="CCTcodigo"      value="RE">
					<cfinvokeargument name="Pcodigo"       	value="#trim(query.NumeroDocumento)#">
				</cfinvoke>
				<cfif rsAPagosCxCTotal.DisponibleAnticipos GT 0>
					<cfset NC_Ccuenta = getNC_CcuentaCP(rsSNpago.SNcodigo,LTipoCP,CodigoAnticipos)>
					<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_AltaAnticipo" returnvariable="LineAnticipo">
						<cfinvokeargument name="Conexion"       value="#Request.CP_InterfazPagos.GvarConexion#">
						<cfinvokeargument name="Ecodigo"        value="#Request.CP_InterfazPagos.GvarEcodigo#">
						<cfinvokeargument name="CCTcodigo"      value="RE">
						<cfinvokeargument name="Pcodigo"        value="#trim(query.NumeroDocumento)#">
						<cfinvokeargument name="NC_Ddocumento"  value="#query.NumeroDocumento#">
						<cfinvokeargument name="NC_Ccuenta"     value="#rsSNpago.SNcuentacxc#">
						<cfinvokeargument name="NC_fecha"       value="#LFecha#">
						<cfinvokeargument name="id_direccion"   value="#rsSNpago.id_direccion#">
						<cfinvokeargument name="NC_total"       value="#rsAPagosCxCTotal.DisponibleAnticipos#">
						<cfinvokeargument name="NC_CCTcodigo"   value="#CodigoAnticipos#">
					</cfinvoke>
				</cfif>
			<!---Crea un Anticipo con la Diferencia del Pago para cuentas por Pagar - Lineas de detalle -Anticipos--->
			<cfelseif isdefined("LTipoCP") and LTipoCP EQ 'P'>
				<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoTotales" returnvariable="rsAPagosCxPTotal">
					<cfinvokeargument name="Conexion" 	    value="#Request.CP_InterfazPagos.GvarConexion#">
					<cfinvokeargument name="IDpago" 	    value="#insertE.identity#">
				</cfinvoke>
				<cfif rsAPagosCxPTotal.DisponibleAnticipos GT 0>
					<cfset NC_Ccuenta = getNC_CcuentaCP(rsSNpago.SNcodigo,LTipoCP,CodigoAnticipos)>
					<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_AltaAnticipo" returnvariable="LineAnticipo">
						<cfinvokeargument name="Conexion"       value="#Request.CP_InterfazPagos.GvarConexion#">
						<cfinvokeargument name="IDpago"       	value="#insertE.identity#">
						<cfinvokeargument name="NC_CPTcodigo"   value="#CodigoAnticipos#">
						<cfinvokeargument name="NC_Ddocumento"  value="#query.NumeroDocumento#">
						<cfinvokeargument name="NC_Ccuenta"     value="#rsSNpago.SNcuentacxp#">
						<cfinvokeargument name="NC_fecha"     	value="#LFecha#">
						<cfinvokeargument name="id_direccion"   value="#rsSNpago.id_direccion#">
						<cfinvokeargument name="NC_total"       value="#rsAPagosCxPTotal.DisponibleAnticipos#">
					</cfinvoke>
				</cfif>
			</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="Procesa_Reembolso" access="public" returntype="boolean">
		<cfargument name="query" required="yes" type="query">
		<!--- 
		<cfargument name="ID" 					type="numeric"required="true">
		<cfargument name="EcodigoSDC" 			type="string" required="true">
		<cfargument name="TipoCobroPago" 		type="string" required="true">
		<cfargument name="CodigoBanco" 			type="string" required="true">
		<cfargument name="CuentaBancaria" 		type="string" required="true">
		<cfargument name="FechaTransaccion" 	type="date"   required="true">
		<cfargument name="TipoPago" 			type="string" required="true">
		<cfargument name="ConDetalle" 			type="numeric" default="0" required="true">
		<cfargument name="NumeroDocumento" 		type="string" required="true">
		<cfargument name="NumeroSocio" 			type="string" required="false">
		<cfargument name="NumeroSocioDocumento" type="string" required="false">
		<cfargument name="MontoPago" 			type="string" required="false">
		<cfargument name="TipoCambio" 			type="string" default="~" required="false">		
		<cfargument name="CodigoMonedaPago" 	type="string" default="~" required="false">		
		<cfargument name="CodigoMonedaDoc" 		type="string" default="~" required="false">
		<cfargument name="TransaccionOrigen" 	type="string" default="~" required="false">	
		<cfargument name="BMUsucodigo" 			type="string" default="~" required="false">	 
		--->
		
		<cfoutput query="query" group="ID">
			<cfset  LTipoCP = getTipoCP(query.TipoCobroPago,'getTipoCP')>
			<cfset  LBid = getBid(query.CodigoBanco,'getBid')>												<!--- Cod banco --->
			<cfset  LcuentaFinan = getCBcc_vIntegridad(query.CuentaBancaria,LBid,'getCBcc_vIntegridad')>	<!--- cuenta --->
			<cfset  LFecha = getFecha_vIntegridad(query.FechaTransaccion,'getFecha_vIntegridad')>			<!--- fecha --->
			<cfset  LTipoPago = getTipPago_vIntegridad(query.TipoPago,'getTipPago_vIntegridad')>			<!--- tipo de pago --->
			<cfset  LMcodigo = getMcodigobyMiso(query.CodigoMonedaPago,'getMcodigobyMiso')>					<!--- moneda --->
			<cfset  LTipoCambio = getTipoCambio(query.CodigoMonedaPago,'getMcodigobyMiso',LFecha)>			<!--- Tipo de cambio --->
            <cfset  L_Cid     = getCid(This.Ccodigo, 'getCid')>
            <cfset  L_CFid    = getCFident(This.CFcodigo, 'getCFident')>
            <cfset  L_Icodigo = getIcodigo('getIcodigo')><!--- trae tasa cero --->

			<cfset  rsSNpago		= getSNegocios(query.NumeroSocio,'getSNegocios')>						<!--- Socio de negocios --->
			<cfset  rsSNdoc			= getSNegocios(query.NumeroSocioDocumento,'getSNegocios')>				<!--- Socio de negocios --->

			<cfif LTipoCP NEQ 'C'>
            	<cfthrow message="Error. El reembolso de documentos de anticipos y notas de crédito solamente aplica para CxC.">
            </cfif>
			<cfif not len(rsSNpago.SNcuentaCxC) or rsSNpago.SNcuentaCxC LT 1>
				<cfthrow message="Error.  No se ha definido la cuenta de CxC del Socio de Negocios: #query.NumeroSocio#" detail="Debe definir la cuenta en el catalogo de socios">
				<cfabort>
			</cfif>

			<!--- ************************************************************ C X C ************************************************************ --->
            <cfquery name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#">
                insert into EDocumentosCxC (
                    Ecodigo, Ocodigo, CCTcodigo, EDdocumento,
                    SNcodigo, Mcodigo, EDtipocambio, Icodigo,
                    Ccuenta, Rcodigo, EDdescuento, EDporcdesc,
                    EDimpuesto, EDtotal, EDfecha, EDtref,
                    EDdocref, EDusuario, EDselect, EDvencimiento,
                    Interfaz, EDreferencia, DEidVendedor, DEidCobrador,
                    id_direccionFact, id_direccionEnvio, CFid, DEdiasVencimiento,
                    DEordenCompra, DEnumReclamo, DEobservacion, DEdiasMoratorio,
                    BMUsucodigo, EDtipocambioVal, EDtipocambioFecha) 
                values (
                    <!---Ecodigo, Ocodigo, CCTcodigo, EDdocumento,--->
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#LOcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char"    value="#This.CCTreembolso#">,
                    <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(query.NumeroDocumento)#">,
                    
                    <!---SNcodigo, Mcodigo, EDtipocambio, Icodigo,--->
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNpago.SNcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#LTipoCambio#">,
                    null,
                    
                    <!---Ccuenta, Rcodigo, EDdescuento, EDporcdesc,--->
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNpago.SNcuentaCxC#">,
                    null,
                    0,
                    0,
                    
                    <!---EDimpuesto, EDtotal, EDfecha, EDtref,--->
                    0,
                    <cfqueryparam cfsqltype="cf_sql_money"   value="#-query.MontoPago#">,
                    <cfqueryparam cfsqltype="cf_sql_date"    value="#LFecha#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(query.TransaccionOrigen)#">,
                    
                    <!---EDdocref, EDusuario, EDselect, EDvencimiento,--->
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(query.TransaccionOrigen)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
                    0,
                    <cfqueryparam cfsqltype="cf_sql_date"    value="#LFecha#">,
                     
                    <!---Interfaz, EDreferencia, DEidVendedor, DEidCobrador,--->
                    1,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(query.TransaccionOrigen)#">,
                    null,
                    null,
                    
                    <!---id_direccionFact, id_direccionEnvio, CFid, DEdiasVencimiento,--->
                    <cfif isdefined("rsSNpago.id_direccion") and len(trim(rsSNpago.id_direccion))>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNpago.id_direccion#">
                        <cfelse>
                        null
                    </cfif>,
                    <cfif isdefined("rsSNpago.id_direccion") and len(trim(rsSNpago.id_direccion))>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNpago.id_direccion#">
                        <cfelse>
                        null
                    </cfif>,
                    null,<!--- CFid es null en el encabezado --->
                    0,
    
                    <!---DEordenCompra, DEnumReclamo, DEobservacion, DEdiasMoratorio,--->
                    null,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_char"    value="Documento Generado por la Interfaz de Pago de SOIN, Doc. Num: #Trim(query.NumeroDocumento)#">,
                    0,
                    <!---BMUsucodigo, EDtipocambioVal, EDtipocambioFecha--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    null,
                    null
                )
                <cf_dbidentity1 datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 name="insertE" datasource="#Request.CP_InterfazPagos.GvarConexion#" verificar_transaccion="false">
			<cfif len(insertE.identity) eq 0 or insertE.identity eq 0>
                <cfthrow message="Error: No se pudo insertar el documento de pago de Cuentas por Cobrar. Proceso cancelado.">
            </cfif>
            <cfquery datasource="#Request.CP_InterfazPagos.GvarConexion#">
            	insert into DDocumentosCxC (
                    EDid, Aid, Cid, Alm_Aid,
                    Ccuenta, Ecodigo, DDdescripcion, DDdescalterna,
                    Dcodigo, DDcantidad, DDpreciou, DDdesclinea,
                    DDporcdesclin, DDtotallinea, DDtipo, BMUsucodigo,
                    Icodigo, CFid, DocrefIM, CCTcodigoIM,
                    cantdiasmora, OCid, OCTid, OCIid)
                values (
                    <!--- EDid, Aid, Cid, Alm_Aid, --->
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertE.identity#">,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#L_Cid#">,
                    null,
                    
                    <!--- Ccuenta, Ecodigo, DDdescripcion, DDdescalterna, --->
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">,
                    'Reembolso de anticipo/nota de crédito',
                    null,
                  
                    <!--- Dcodigo, DDcantidad, DDpreciou, DDdesclinea, --->
                    null,
                    1,
                    <cfqueryparam cfsqltype="cf_sql_money"   value="#-query.MontoPago#">,
                    0,
                    
                    <!--- DDporcdesclin, DDtotallinea, DDtipo, BMUsucodigo, --->
                    0,
                    <cfqueryparam cfsqltype="cf_sql_money"   value="#-query.MontoPago#">,
                    'S',<!--- servicios --->
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    
                    <!--- Icodigo, CFid, DocrefIM, CCTcodigoIM, --->
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#L_Icodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#L_CFid#">,
                    null,
                    null,
                    
                    <!--- cantdiasmora, OCid, OCTid, OCIid --->
                    null,
                    null,
                    null,
                    null
                )
            </cfquery>

            <cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
            	method="PosteoDocumento"
                EDid="#insertE.identity#"
                Ecodigo="#Request.CP_InterfazPagos.GvarEcodigo#"
                usuario="#session.Usuario#"
                debug="N"
				USA_tran="false"
                Conexion="#Request.CP_InterfazPagos.GvarConexion#" >
            </cfinvoke>
			
            
			<cfoutput>
				<!--- Inserta un documento a favor con un detalle por cada NC pagada --->
            
				<cfset  LCodTran   = getCodTran(query.CodigoTransaccionL,LTipoCP, false,'getCodTran')>				<!--- Cod transaccion --->
                <cfset  LDocumento = getDoc(query.DocumentoL, query.TipoCobroPago, LCodTran, rsSNdoc.SNcodigo, false, 'getDoc')>		<!--- Documento a pagar --->
				
                <cfset  LMontoPago = getMontoDoc(query.MontoPagoDocumentoL, LDocumento.Doc, query.TipoCobroPago, LDocumento.CodigoTransaccion,'getMontoDoc')> 	<!--- monto a pagar. Equivale a Saldo --->
                <!---
                    LmontoPago:                    Monto del Pago en la moneda de la factua
                    LMontoPagoRec :                Monto del Pago en la moneda del recibo
                --->
                <cfif query.MontoPagoDocumentoL GT LmontoPago>
                    <cfset LmontoPagoRec = numberformat(query.MontoPagoL * (LMontoPago / query.MontoPagoDocumentoL), "9.00")>
                <cfelseif query.MontoPagoDocumentoL LTE LmontoPago>
                    <cfset LmontoPago = query.MontoPagoDocumentoL>
                    <cfset LmontoPagoRec = query.MontoPagoL>
                </cfif>
                <!--- 
                    <cfset  LExisteDoc = getExisteDoc(query.DocumentoL,query.TipoCobroPago, LCodTran,'getExisteDoc')>
                --->
                <cfset  LvTipoPago = query.TipoPago><!--- tipo de pago --->

				<cfquery datasource="#Request.CP_InterfazPagos.GvarConexion#">
					insert into EFavor (
						Ecodigo, CCTcodigo, Ddocumento, SNcodigo,
						Mcodigo, Ccuenta, CFid, EFtipocambio,
						EFtotal, EFfecha, EFselect, EFusuario,
						BMUsucodigo)
					values (
						<!---Ecodigo, CCTcodigo, Ddocumento, SNcodigo,--->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#LDocumento.CodigoTransaccion#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#trim(LDocumento.Doc)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNdoc.SNcodigo#">,
						
						<!---Mcodigo, Ccuenta, CFid, EFtipocambio,--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#L_CFid#">,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#LTipoCambio#">,
						
						<!---EFtotal, EFfecha, EFselect, EFusuario,--->
						<cfqueryparam cfsqltype="cf_sql_money"   value="#-LmontoPagoRec#">,
						<cfqueryparam cfsqltype="cf_sql_date"    value="#LFecha#">,
						0, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
						
						<!---BMUsucodigo--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
				</cfquery>

				<!--- Insertar detalle---> 
				<cfif LmontoPagoRec eq 0>
					<cfset LvarTipoconversion = 1>	
				<cfelse>
					<cfset LvarTipoconversion = LmontoPago/LmontoPagoRec>
				</cfif>
				<cfquery name="insertD"  datasource="#Request.CP_InterfazPagos.GvarConexion#">
					insert into DFavor (
						Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo,
						DRdocumento, SNcodigo, Ccuenta, Mcodigo,
						CFid, DFmonto, DFtotal, DFmontodoc,
						DFtipocambio, BMUsucodigo)
					values (
						<!---Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo,--->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#LDocumento.CodigoTransaccion#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#LDocumento.Doc#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#This.CCTreembolso#">,
						
						<!---DRdocumento, SNcodigo, Ccuenta, Mcodigo,--->
						<cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(query.NumeroDocumento)#">,
						<cfqueryparam cfsqltype="cf_sql_integer"    value="#rsSNdoc.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LDocumento.Cuenta#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LDocumento.Mcodigo#">,
						
						<!---CFid, DFmonto, DFtotal, DFmontodoc,--->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#L_CFid#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(-LmontoPagoRec,"9.00")#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(-LmontoPagoRec,"9.00")#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#NumberFormat(-LmontoPago,"9.00")#">,
						
						<!---DFtipocambio, BMUsucodigo--->
						<cfqueryparam cfsqltype="cf_sql_float"   value="#LvarTipoconversion#">, <!--- Tipo de Cambio entre el documento de pago y el documento --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					)
				</cfquery>
			</cfoutput>
		</cfoutput>
		<cfreturn true>
	</cffunction>
	
	<!--- FUNCIONES PRIVADAS --->
	
	<cffunction access="private" name="getCFident" output="false" returntype="numeric">
		<cfargument name="CFcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rsCFun" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select CFid
			from CFuncional
			where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CFcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
		</cfquery>
		<cfif rsCFun.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del centro funcional #Arguments.CFcodigo# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rsCFun.CFid>	
	</cffunction>
	
	<cffunction access="private" name="getCid" output="false" returntype="numeric">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rsConcepto" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select Cid
			from Conceptos
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Ccodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
		</cfquery>
		<cfif rsConcepto.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del Concepto #Arguments.Ccodigo# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rsConcepto.Cid>	
	</cffunction>
	
	<cffunction access="private" name="getIcodigo" output="false" returntype="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rsImpuesto0" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select min(Icodigo) as Icodigo
			from Impuestos
			where Iporcentaje = 0
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
		</cfquery>
		<cfif rsImpuesto0.RECORDCOUNT EQ 0 or len(rsImpuesto0.Icodigo) is 0>
			<cfthrow message="#Arguments.InvokerName#: No se ha definido un impuesto con tasa cero">
		</cfif>
		<cfreturn rsImpuesto0.Icodigo>	
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

		<cfquery name="TransfiereCodigoMoneda" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.vMcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
		</cfquery> 


		<cfquery name="rsTC" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select h.TCcompra as TCcompra
			from Htipocambio h
			where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			 and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TransfiereCodigoMoneda.Mcodigo#">
			 and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lvDfecha#">
			 and h.Hfecha = (
			 select max(h2.Hfecha)
			 from Htipocambio h2
			 where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			   and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TransfiereCodigoMoneda.Mcodigo#">
			   and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lvDfecha#">)
		</cfquery>	

		<cfif isdefined('rsTC') and rsTC.recordCount GT 0 and rsTC.TCcompra GT 0>
			<cfset retTC = rsTC.TCcompra>
		</cfif>
		<cfreturn retTC>
	</cffunction>

	<cffunction access="private" name="getFecha_vIntegridad" output="false" returntype="date">
		<cfargument name="fecha" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
	
		<cfif isdefined("Arguments.fecha") and not isdate(Arguments.fecha)>
			<cfthrow message="La fecha de la función #Arguments.InvokerName# no es del formato correcto. Proceso Cancelado!">
		<cfelseif  isdefined("Arguments.fecha")>
			<cfreturn Arguments.fecha>
		</cfif>	
	</cffunction>	
	<!---Valida el Tipo de Cobro C= Cuentas por Cobrar, P = Cuentas por Pagar--->
	<cffunction access="private" name="getTipoCP" output="false" returntype="string">
		<cfargument name="TipoCobroPago" required="yes" type="string">
		<cfargument name="InvokerName"   required="no"  type="string" default=""><!--- Nombre del método que lo invoca --->
	
		<cfif isdefined("Arguments.TipoCobroPago") and Arguments.TipoCobroPago EQ 'C'>
			<cfreturn Arguments.TipoCobroPago>
		<cfelseif isdefined("Arguments.TipoCobroPago") and Arguments.TipoCobroPago EQ 'P'>	
			<cfreturn Arguments.TipoCobroPago>
		<cfelseif  isdefined("Arguments.TipoCobroPago")>
			<cfthrow message="El tipo de pago: #Arguments.TipoCobroPago# de la función #Arguments.InvokerName# no es el correcto. Proceso Cancelado!">
		<cfelse>
			<cfthrow message="El tipo de pago: #Arguments.TipoCobroPago# de la función #Arguments.InvokerName# no es el correcto. Proceso Cancelado!">		
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
			<cfthrow message="#Arguments.InvokerName#: El valor del Banco #Arguments.CodigoBanco# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rsBancos.Bid>		
	</cffunction>
	
	<cffunction access="private" name="getCBcc_vIntegridad" output="false" returntype="query">
		<cfargument name="Cuenta" required="no" type="string">
		<cfargument name="Banco" required="yes" type="numeric">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
	
		<cfif isdefined('Arguments.Cuenta') and Arguments.Cuenta NEQ ''>				
			<cfquery name="rsCuentasBancos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				Select CBcc, Ocodigo, Ccuenta, CBid
				from CuentasBancos
				where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					and Bid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Banco#">	
					and CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cuenta#">	
			</cfquery>
		</cfif>
		<cfif isdefined("rsCuentasBancos") and rsCuentasBancos.recordCount EQ 0>
				<cfthrow message="El valor de la cuenta #Arguments.Cuenta# pasado a la función #Arguments.InvokerName# no existe. Proceso Cancelado!">
		<cfelseif isdefined("rsCuentasBancos") and rsCuentasBancos.recordCount NEQ 0>
			<cfset  LCBcc = rsCuentasBancos.CBcc>
			<cfset  LOcodigo = rsCuentasBancos.Ocodigo>
			<cfset  LCcuenta = rsCuentasBancos.Ccuenta>
		<cfelse>
			<cfthrow message="El valor de la cuenta #Arguments.Cuenta# pasado a la función #Arguments.InvokerName# no existe. Proceso Cancelado!">
		</cfif>			
		<cfreturn #rsCuentasBancos#>
	</cffunction>	

	<cffunction access="private" name="getTipPago_vIntegridad" output="false" returntype="string">
		<cfargument name="TipPago" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif isdefined("Arguments.TipPago") and Arguments.TipPago EQ 'C'>
			<cfreturn Arguments.TipPago>
		<cfelseif isdefined("Arguments.TipPago") and Arguments.TipPago EQ 'T'>	
			<cfreturn Arguments.TipPago>
		<cfelseif  isdefined("Arguments.TipPago")>
			<cfthrow message="El tipo de pago: #Arguments.TipPago# de la función #Arguments.InvokerName# no es el correcto. Proceso Cancelado!">
		</cfif>	
	</cffunction>	
	
	<cffunction access="private" name="getSNegocios" output="false" returntype="query">
		<cfargument name="SNnumero" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select SNid, SNcodigo, id_direccion, SNcuentacxp, SNcuentacxc
			from SNegocios a
			where SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
		</cfquery>
		<cfif rs.recordcount eq 0>
			<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#" maxrows="1">
				select SNid, SNcodigo, id_direccion, SNcuentacxp, SNcuentacxc
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNnumero#">
			</cfquery>
		</cfif>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoProveedor no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
        <cfif rs.RECORDCOUNT gt 1>
			<cfthrow message="#Arguments.InvokerName#: Existe mas de un socio de negocio para la misma empresa con el mismo código externo: #Arguments.SNnumero#. Proceso Cancelado!">
		</cfif>
		<cfreturn rs>
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
		<cfargument name="esAnticipo" required="yes" type="boolean">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
			<cfquery name="rsT" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select CCTcodigo as codigo, CCTafectacostoventas, CCTtipo, case CCTtipo when 'C' then 'D' else 'C' end as CCTtipoinverso, 
					coalesce(CCTpago,0) as CCTpago, CCTdescripcion as Descripcion
				from CCTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and rtrim(CCTcodigoext) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoTran)#">
			</cfquery>
			<cfif not rsT.recordcount>
				<cfquery name="rsT" datasource="#Request.CP_InterfazPagos.GvarConexion#" maxrows="1">
					select CCTcodigo as codigo, CCTafectacostoventas, CCTtipo, case CCTtipo when 'C' then 'D' else 'C' end as CCTtipoinverso,
						coalesce(CCTpago,0) as CCTpago, CCTdescripcion as Descripcion
				from CCTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoTran)#">
				</cfquery>
			</cfif>
		<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>
			<cfquery name="rsT" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select CPTcodigo as codigo, CPTafectacostoventas, CPTtipo, case CPTtipo when 'C' then 'D' else 'C' end as CPTtipoinverso,
					coalesce(CPTpago,0) as CPTpago, CPTdescripcion as Descripcion
				from CPTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and rtrim(CPTcodigoext) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoTran)#">
			</cfquery>
			<cfif not rsT.recordcount>
				<cfquery name="rsT" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select CPTcodigo as codigo, CPTafectacostoventas, CPTtipo, case CPTtipo when 'C' then 'D' else 'C' end as CPTtipoinverso,
							coalesce(CPTpago,0) as CPTpago, CPTdescripcion as Descripcion
					from CPTransacciones
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					  and rtrim(CPTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoTran)#">
				</cfquery>
			</cfif>
		</cfif>			
		<cfdump var="#rsT#">
		<cfif rsT.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor de la transacción #Arguments.CodigoTran# no existe el el módulo #Arguments.TipoMovCP#, en la Base de Datos. Proceso Cancelado!">
		<cfelseif REfindNoCase("TESORER[IÍ]A",rsT.Descripcion)>
			<cfthrow message="#Arguments.InvokerName#: La transacción #Arguments.CodigoTran# no puede ser de Tesorería. Proceso Cancelado!">
		</cfif>
		<cfif esAnticipo>
			<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
				<cfif NOT (rsT.CCTtipo EQ "C" OR rsT.CCTpago NEQ "1")>
					<cfthrow message="#Arguments.InvokerName#: La transacción de Anticipo #Arguments.CodigoTran# debe ser tipo Crédito y no puede ser de Pago. Proceso Cancelado!">
				</cfif>
			<cfelse>
				<cfif NOT (rsT.CPTtipo EQ "D" OR rsT.CCTpago NEQ "1")>
					<cfthrow message="#Arguments.InvokerName#: La transacción de Anticipo #Arguments.CodigoTran# debe ser tipo Débito y no puede ser de Pago. Proceso Cancelado!">
				</cfif>
			</cfif>
		</cfif>
		<cfreturn rsT.codigo>		
	</cffunction>
	
	<cffunction access="private" name="getCodBTid" output="false" returntype="numeric">
		<cfargument name="CPTcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select coalesce(min(BTid),0) as BTid
			from CPTransacciones
			where CPTcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			  and CPTpago = 1
		</cfquery>
		<cfif rs.recordcount eq 0>
			<cfset BTid = rs.BTid>
		<cfelse>
			<cfquery name="rs2" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select coalesce(min(BTid),0) as BTid
				from CPTransacciones
				where CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigo)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and CPTpago = 1
			</cfquery>
			<cfif rs2.recordcount gt 0>
				<cfset BTid = rs2.BTid>
			</cfif>
		</cfif>
		<cfif not isdefined('BTid') or ( isdefined('BTid') and  BTid EQ 0)>
			<cfthrow message="#Arguments.InvokerName#: El valor de la transacción #Arguments.CPTcodigo# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn BTid>		
	</cffunction>
	
	<cffunction access="private" name="getDoc" output="false" returntype="query">
		<cfargument name="NumDoc" required="yes" type="string">
		<cfargument name="TipoMovCP" required="yes" type="string">
		<cfargument name="CodTran" required="yes" type="string">
		<cfargument name="SNcodigo" required="yes" type="numeric">
		<cfargument name="esAnticipo" required="yes" type="boolean">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
			<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select Ddocumento as Doc, Ccuenta as Cuenta, CCTcodigo as CodigoTransaccion, Mcodigo
				  from Documentos
				 where Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.NumDoc)#">
				   and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Request.CP_InterfazPagos.GvarEcodigo#">
				   and CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char"		value="#Arguments.CodTran#"> 
			</cfquery>
			<cfif rsDocumentos.recordCount EQ 0>
				<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select Ddocumento as Doc, Ccuenta as Cuenta, CCTcodigo as CodigoTransaccion, Mcodigo
					  from Documentos
					 where Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.NumDoc)#">
					   and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Request.CP_InterfazPagos.GvarEcodigo#">
					   and SNcodigo     = <cfqueryparam cfsqltype="cf_sql_integer"	value="#Arguments.SNcodigo#">
				</cfquery>
			</cfif>
			<cfif rsDocumentos.recordCount EQ 0>
				<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select Ddocumento as Doc, Ccuenta as Cuenta, CCTcodigo as CodigoTransaccion, Mcodigo
					  from Documentos
					 where Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char"		value="#trim(Arguments.NumDoc)#">
					   and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Request.CP_InterfazPagos.GvarEcodigo#">
				</cfquery>
			</cfif>
			<cfif rsDocumentos.recordCount GT 1>
				<cfthrow message="Se encontró más de un documento número #Arguments.NumDoc# y no es posible determinar el Documento correcto!">
			</cfif>
		<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>			
			<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select IDdocumento as Doc, Ccuenta as Cuenta, CPTcodigo as CodigoTransaccion, Mcodigo
				  from EDocumentosCP
				 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Request.CP_InterfazPagos.GvarEcodigo#">
				   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(Arguments.NumDoc)#">
				   and SNcodigo		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.SNcodigo#">
				   and CPTcodigo	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.CodTran#"> 
			</cfquery>
			<cfif rsDocumentos.recordCount EQ 0>
				<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select IDdocumento as Doc, Ccuenta as Cuenta, CPTcodigo as CodigoTransaccion, Mcodigo
					  from EDocumentosCP
					 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Request.CP_InterfazPagos.GvarEcodigo#">
					   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(Arguments.NumDoc)#">
					   and SNcodigo		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.SNcodigo#">
				</cfquery>
			</cfif>
			<cfif rsDocumentos.recordCount EQ 0>
				<cfquery name="rsDocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select IDdocumento as Doc, Ccuenta as Cuenta, CPTcodigo as CodigoTransaccion, Mcodigo
					  from EDocumentosCP
					 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Request.CP_InterfazPagos.GvarEcodigo#">
					   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#trim(Arguments.NumDoc)#">
				</cfquery>
			</cfif>
			<cfif rsDocumentos.recordCount GT 1>
				<cfthrow message="Se encontró más de un documento número #Arguments.NumDoc# para otros Socios de Negocio">
			</cfif>
		<cfelse>
			<cfthrow message="#Arguments.InvokerName#:  Proceso Cancelado!">
		</cfif>
		<cfif Arguments.esAnticipo>
			<cfif rsDocumentos.RECORDCOUNT GT 0>
				<cfthrow message="#Arguments.InvokerName#: El Documento de Anticipo #trim(Arguments.NumDoc)# #Arguments.CodTran# ya existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
		<cfelse>
			<cfif rsDocumentos.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.SNcodigo# #Arguments.InvokerName#: El Documento #trim(Arguments.NumDoc)# #Arguments.CodTran# no existe en la Base de Datos. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfreturn rsDocumentos>		
	</cffunction>
	
	<!--- Comprueba que el monto no del doc no sea mayor que el saldo --->
	<cffunction access="private" name="getMontoDoc" output="false" returntype="numeric">
		<cfargument name="montoDoc" required="yes" type="numeric">
		<cfargument name="NumDoc" required="yes" type="string">
		<cfargument name="TipoMovCP" required="yes" type="string">
		<cfargument name="CodTran" required="yes" type="string">

		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
			<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
				<cfquery name="rsEdocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select CCTcodigo as CodTran, Ddocumento as NumDoc, round( round(coalesce(Dsaldo,0),2) * round(coalesce(Dtipocambio,1),2) ,2) as saldo
					from Documentos
					where Ddocumento	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.NumDoc#">
					  and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Request.CP_InterfazPagos.GvarEcodigo#">
					  and CCTcodigo		=  <cfqueryparam cfsqltype="cf_sql_char"	value="#Arguments.CodTran#"> 
				</cfquery>
			<cfelseif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'P'>			
				<cfquery name="rsEdocumentos" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select CPTcodigo as CodTran, Ddocumento as NumDoc, round(coalesce(EDsaldo,0),2) as saldo
					from EDocumentosCP
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NumDoc#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				</cfquery>
			<cfelse>
				<cfthrow message="#Arguments.InvokerName#: #Arguments.CodTran# #Arguments.NumDoc#. Proceso Cancelado!">	
			</cfif>

			<cfif rsEdocumentos.RECORDCOUNT EQ 0>
				<cfthrow message="#Arguments.InvokerName#: El Documento no existe en la Base de Datos. Proceso Cancelado!">
<!--- RBG Inicia Cambio para pago de Anticipo CxP  --->
			<cfelseif isdefined("rsEdocumentos")>
            		    <cfif isdefined("Arguments.TipoMovCP") and (Arguments.TipoMovCP EQ 'C' or (Arguments.TipoMovCP EQ 'P' and rsEdocumentos.CodTran NEQ 'AN'))>
			        <cfif rsEdocumentos.saldo LT Arguments.montoDoc>
				    <cfthrow message="#Arguments.InvokerName#: El Saldo del Documento #rsEdocumentos.CodTran# #trim(rsEdocumentos.NumDoc)# (#numberFormat(rsEdocumentos.saldo,",9.99")#) es menor que el monto del pago (#numberFormat(Arguments.montoDoc,",9.99")#). Proceso Cancelado!"> 
				</cfif>
                	    </cfif>
<!--- RBG Termina  Cambio para pago de Anticipo CxP  --->
             		</cfif>
		<cfreturn rsEdocumentos.saldo>		
	</cffunction>
	
	<!--- 5.2 Obtiene el monto total del pago  --->
	<cffunction access="private" name="getMontoTotal" output="false" returntype="numeric">
		<cfargument name="IDpago" type="numeric" required="yes">
		<cfargument name="CodTran" type="string" required="yes">
		<cfargument name="NumDoc" type="string" required="yes">
		<cfargument name="TipoMovCP" required="yes" type="string">
		<cfset var result = 0.00>
		<cfif isdefined("Arguments.TipoMovCP") and Arguments.TipoMovCP EQ 'C'>
			<cfquery name="rs" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select coalesce(sum(DPtotal),0) as total  
				from DPagos 
			 	where Ecodigo = <cfqueryparam value="#Request.CP_InterfazPagos.GvarEcodigo#" cfsqltype="cf_sql_integer">
				  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodTran#"> 
				  and Pcodigo =  <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.NumDoc)#"> 
			</cfquery>	
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
			<cfreturn result>
		<cfelse>
			<cfthrow message="El documento genero los siguientes errores CodTran: #Arguments.CodTran# NumDoc:#trim(Arguments.NumDoc)#, IDpago : #Arguments.IDpago# . Proceso Cancelado!">	
		</cfif>
		
	</cffunction>
	<!---=================Obtención de la cuenta para el registro del Anticipo de cuentas por Cobrar y Cuentas por Pagar========================
	Parametro: 
			2500--> Orden de las cuentas para Anticipos(CXP/CXC)
	Valores: 
			  1 --> Configuración Default
						1-Cta de Excepción por Transacciones
						2-Cta predeterminada para el Socio
			  2 --> Configuración Avanzada
						1-Cta de Excepción por Transacciones
						2-Cta Parámetro de cuenta de Anticipos
						3-Cta predeterminada para el Socio
	================================================================================================--->
	<cffunction access="private" name="getNC_CcuentaCP" output="false" returntype="numeric">
		<cfargument name="SNcodigo"   required="yes" type="numeric">
		<cfargument name="Modulo"     required="yes" type="string">
		<cfargument name="Trancodigo" required="yes" type="string">
		<cfset Ccuenta = "">
		<!---Paso 1= Busca la Cuenta de Excepción para la Transacciones de Anticipo--->
		<cfif Arguments.Modulo EQ 'C'>
			<cfquery name="rsCuentaTransacciones" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select coalesce(c.Ccuenta,0) as Ccuenta
				from SNCCTcuentas sc 
					inner join CFinanciera c
					 on sc.Ecodigo  = c.Ecodigo 
					and sc.CFcuenta = c.CFcuenta
				where sc.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and sc.SNcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
				  and sc.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.Trancodigo)#">
       		 </cfquery>
			 <cfif rsCuentaTransacciones.recordcount EQ 1 and rsCuentaTransacciones.Ccuenta NEQ 0>
			 	<cfset Ccuenta = rsCuentaTransacciones.Ccuenta>
			 </cfif>
		<cfelseif  Arguments.Modulo EQ 'P'>
			<cfquery name="rsCuentaTransacciones" datasource="#Request.CP_InterfazPagos.GvarConexion#">
				select coalesce(c.Ccuenta,0) as Ccuenta
				from SNCPTcuentas sc 
					inner join CFinanciera c
						on sc.Ecodigo  = c.Ecodigo 
					   and sc.CFcuenta = c.CFcuenta
				where sc.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CP_InterfazPagos.GvarEcodigo#">
				  and sc.SNcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
				  and sc.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.Trancodigo)#">
       		</cfquery>
			 <cfif rsCuentaTransacciones.recordcount EQ 1 and rsCuentaTransacciones.Ccuenta NEQ 0>
			 	<cfset Ccuenta = rsCuentaTransacciones.Ccuenta>
			 </cfif>
		<cfelse>
			<cfthrow message="La Interfaz no tienen implementado el modulo #Arguments.Modulo#">
		</cfif>
		<cfif LEN(TRIM(Ccuenta))>
			<cfreturn Ccuenta>
		</cfif>
		<!---Paso 2 = Si no la encontro en el paso 1 y esta trabajando con configuración Avanzada, se busca la Cuenta Parámetro de cuenta de Anticipos --->
		<cfquery name="parametro2500" datasource="#Request.CP_InterfazPagos.GvarConexion#">
			select coalesce(Pvalor, '1') as valor 
				from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CP_InterfazPagos.GvarEcodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2500"> 
		</cfquery>
		<cfif parametro2500.valor EQ 2>
			<cfif Arguments.Modulo EQ 'C'>
				<cfquery name="parametro180" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select Pvalor Ccuenta 
						from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="180"> 
				</cfquery>
				<cfif parametro180.recordcount GT 0 and LEN(TRIM(parametro180.Ccuenta))>
					<cfset Ccuenta = parametro180.Ccuenta>
				</cfif>
			<cfelse>
				<cfquery name="parametro190" datasource="#Request.CP_InterfazPagos.GvarConexion#">
					select Pvalor Ccuenta 
						from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="190"> 
				</cfquery>
				<cfif parametro190.recordcount GT 0 and LEN(TRIM(parametro190.Ccuenta))>
					<cfset Ccuenta = parametro190.Ccuenta>
				</cfif>
			</cfif>
			<cfif LEN(TRIM(Ccuenta))>
				<cfreturn Ccuenta>
			</cfif>
		</cfif>
			<!---Paso 3: si no la encotro en el Paso 1 y 2, toma la cuenta predeterminada para el Socio de Negocio--->
			<cfif Arguments.Modulo EQ 'C'>
				<cfquery name="rsCuentaSocio" datasource="#Request.CP_InterfazPagos.GvarConexion#" maxrows="1">
					select SNcuentacxc Ccuenta
					from SNegocios
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
				</cfquery>
				<cfif rsCuentaSocio.recordcount GT 0 and LEN(TRIM(rsCuentaSocio.Ccuenta))>
					<cfset Ccuenta = rsCuentaTransacciones.Ccuenta>
				</cfif>
			<cfelse>
				<cfquery name="rsCuentaSocio" datasource="#Request.CP_InterfazPagos.GvarConexion#" maxrows="1">
					select SNcuentacxp Ccuenta
					from SNegocios
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CP_InterfazPagos.GvarEcodigo#">
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"    value="#Arguments.SNcodigo#">
				</cfquery>
				<cfif rsCuentaSocio.recordcount GT 0 and LEN(TRIM(rsCuentaSocio.Ccuenta))>
					<cfset Ccuenta = rsCuentaTransacciones.Ccuenta>
				</cfif>
			</cfif>
		
		<cfif NOT LEN(TRIM(Ccuenta))>
			<cfthrow message="No se puedo Obtener Ninguna cuenta para Anticipos">
		</cfif>
		<cfreturn Ccuenta>
	</cffunction>
</cfcomponent>
