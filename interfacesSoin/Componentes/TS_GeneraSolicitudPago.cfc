<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion  = Session.Dsn>
	<cfset GvarEcodigo   = Session.Ecodigo>	
	<cfset GvarUsuario   = Session.Usuario>
	<cfset GvarUsucodigo = Session.Usucodigo>
	<cfset GvarEcodigoSDC= Session.EcodigoSDC>
	<cfset GvarEnombre   = Session.Enombre>
	<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
	<cfset GvarCuentaManual = true> 
		
	<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
	
	<cffunction name="TS_GeneraSolicitud" access="public" returntype="string" output="no">
	<cfargument name="query" required="yes" type="query">
	
		<cfoutput query="query">										
			<!--- Variables Validadas de Solicitud de Pago que se generará --->
			<cfset Documento                = '#Arguments.Documento#-#query.DConsecutivo#'>
			<cfset ValidTesoreria			= getValidTesoreria(#GvarEcodigo#)>	
			<cfset ValidNumPago 			= getValidNumPago(#GvarEcodigo#)>
			<cfset ValidCentroFun 			= getValidCentroFun(#query.CFuncional#,#GvarEcodigo#)>
			<cfif query.Empleado neq "">
				<cfset ValidBeneficiario 		= getValidBeneficiario(#query.Empleado#,#GvarEcodigo#)>
			</cfif>
			<cfif query.SNcodigo neq "">
				<cfset ValidSocio		 		= getValidSocio(#query.SNcodigo#,#GvarEcodigo#)>
			</cfif>
			<cfset ValidIdConcepto 		    = getValidIdConcepto(#query.CConcepto#,#GvarEcodigo#)>
			<cfset ValidMoneda 		        = getValidMoneda(#query.Miso4217#,#GvarEcodigo#)>
			<!--- JMRV 14/10/2014 INICIO--->
			<cfif isdefined("query.Forma_Pago") and query.Forma_Pago neq "">
				<cfset Forma_Pago		 	= getValidForma_Pago(#query.Forma_Pago#)>
			</cfif>
			<cfif isdefined("Forma_Pago") and Forma_Pago eq 2 and isdefined("ValidBeneficiario")>
				<cfset Cta_Forma_Pago		= getValidCta_Forma_Pago(true,#ValidBeneficiario#)>
			<cfelseif isdefined("Forma_Pago") and Forma_Pago eq 2 and isdefined("ValidSocio")>
				<cfset Cta_Forma_Pago		= getValidCta_Forma_Pago(false,#ValidSocio#)>
			</cfif>
			<!--- JMRV 14/10/2014 FIN--->
							
			<cftry>
				<cfif not query.Gasto>
					<!--- Inserta Documento en Cuentas por Cobrar --->
					<cfquery name="rsInsert" datasource="#GvarConexion#">
						insert into TESsolicitudPago 
								(TESid, 
								EcodigoOri, 
								TESSPnumero, 
								TESSPtipoDocumento, 
								TESSPestado, 
								TESSPfechaPagar, 
								McodigoOri, 
								TESSPtipoCambioOriManual, 
								CFid, 
								TESSPtotalPagarOri, 
								TESSPfechaSolicitud,
								UsucodigoSolicitud, 
								TESBid, 
								SNcodigoOri,
								TESOPobservaciones,
								BMUsucodigo)
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidTesoreria#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidNumPago#">,
								0, <!----???---->
								0,
								<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidMoneda#">,
								1, <!-----tipo de cambio--->
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidCentroFun#">,
								round(#query.Total_Linea#,2),
								<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#GvarUsucodigo#">,
								<cfif isdefined("ValidBeneficiario")>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValidBeneficiario#">,		<!--- JMRV. Cambio de integer a numeric --->
								<cfelse>
									null,
								</cfif>
								<cfif isdefined("ValidSocio")>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidSocio#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Observaciones#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#GvarUsucodigo#">)
								
								<cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#GvarConexion#" verificar_transaccion="false" name="rsInsert">

					<!--- JMRV. 14/10/2014 INICIO--->
					<cfif isdefined("Forma_Pago") and Forma_Pago NEQ ''>
						<cfquery name="rsInsertaFormaPago" datasource="#GvarConexion#">
							insert into TESOPformaPago (TESOPFPtipoId, TESOPFPid, TESOPFPtipo, TESOPFPcta)
							values (5, (select TESSPid from TESsolicitudPago where TESSPnumero = #ValidNumPago# and EcodigoOri = #GvarEcodigo#),
								#Forma_Pago#, <cfif Forma_pago eq 2 and isdefined("Cta_Forma_Pago")> #Cta_Forma_Pago# <cfelse> null </cfif>)
						</cfquery>
					</cfif>
					<!--- JMRV 14/10/2014 FIN--->
										
					<!--- Insertar Detalle de Solicitud de Pago--->
					<cfquery datasource="#Gvarconexion#">
						insert into TESdetallePago 
										(TESDPestado, 
										EcodigoOri, 
										TESid, 
										TESSPid, 
										TESDPtipoDocumento, 
										TESDPidDocumento, 
										TESDPmoduloOri,
										TESDPdocumentoOri, 
										TESDPreferenciaOri,
										TESDPfechaVencimiento, 
										TESDPfechaSolicitada, 
										TESDPfechaAprobada, 
										Miso4217Ori, 
										TESDPmontoVencimientoOri, 
										TESDPmontoSolicitadoOri, 
										TESDPmontoAprobadoOri, 
										TESDPdescripcion, 
										CFcuentaDB, 
										OcodigoOri, 
										TESRPTCid,
										CFid, 
										TESRPTCietu, 
										Rlinea,
										Cid)
								values (1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidTesoreria#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
								0,   <!-----tipo de dcto ????---->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Modulo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(Left(Documento,20)," ","","All")#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(Left(Arguments.Documento,25)," ","","All")#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Miso4217#">,
								round(#query.Total_Linea#,2),
								round(#query.Total_Linea#,2),
								round(#query.Total_Linea#,2),																
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Descripcion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#query.CFcuenta#">,
								0,
								1, <!----Tipo de cambio--->
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidCentroFun#">,
								0,
								0,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidIdConcepto#">)			
							<cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#GvarConexion#" verificar_transaccion="false" name="rsInsertD">
				</cfif>
						
				<cfif isdefined('rsInsert.identity') and query.Gasto >
					<!--- Insertar los Gastos del detalle de la Solicitud de Pago--->
					<cfquery datasource="#Gvarconexion#">
							insert into TESgastosPago
										(TESSPid,
										 TESDPid,
										 EcodigoOri,
										 OcodigoOri,
										 TESGPdescripcion,
										 TESGPmovimiento,
										 CFcuenta,
										 Miso4217Ori,
										 TESGPmontoOri,
										 TESGPtipoCambio,
										 TESGPmonto) 
								values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertD.identity#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Descripcion#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Tipo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#query.CFcuenta#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Miso4217#">,
										round(#query.Total_Linea#,2),
										1, 
										round(#query.Total_Linea#,2))
						</cfquery>
					</cfif>
									
					<cfif isdefined("rsInsert.identity") and rsInsert.identity NEQ ''>
						<cfset Solicitud = #rsInsert.identity#>
					<cfelse>
						<cfset Solicitud = 0>
					</cfif>
						
					<cfif Solicitud NEQ 0>			
					<!---Actualiza el id de la solicitud que se haya generado--->	 
				   		<cfquery datasource="#session.DSN#">
							update #sifinterfacesdb#..ID926 
							set Id_Solicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Solicitud#">	<!--- JMRV. Cambio de integer a numeric --->
							where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#query.ID#">
							and DConsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#query.DConsecutivo#">	<!--- JMRV. Cambio de integer a numeric --->
						</cfquery>
					</cfif>
			<cfcatch>
			<cfif isdefined("rsInsert.identity") and rsInsert.identity NEQ 0>
				<cfquery datasource="#GvarConexion#">
					delete TESdetallePago where TESSPid = #rsInsert.identity#
				</cfquery>			
				<cfquery datasource="#GvarConexion#">
					delete TESsolicitudPago where TESSPid = #rsInsert.identity#
				</cfquery>
				<!----SE BORRA EL REGISTRO QUE SE HAYA INSERTADO EN LA DEL DETALLE DEL GASTO---->
				<cfif isdefined("rsInsert.identity") and rsInsert.identity GT 0>
					<cfquery datasource="#GvarConexion#">
						delete TESgastosPago where TESSPid = #rsInsert.identity#
					</cfquery>
				</cfif>
			</cfif>
			
			<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
			<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
			<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>
			</cftry>
		</cfoutput>
	</cffunction>
							
							
	<!---
		DESDE AQUI COMIENZAN LAS VALIDACIONES DE LA SOLICITUD DE PAGO
	--->
	<!---
		Metodo: 
			getValidTesoreria
		Resultado:
			Obtiene la tesoreria que se encuentra activa para la empresa.
	--->
	<cffunction name="getValidTesoreria" access="private" returntype="numeric" output="no">
		<cfargument name="Ecodigo" required="true" type="numeric">
		
		<cfquery name="rsTesoreria" datasource="#GvarConexion#">
			 select TESid
            from TESempresas 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<cfif isdefined("rsTesoreria") and rsTesoreria.recordcount GT 0>
			<cfreturn rsTesoreria.TESid>
		<cfelse>
			<cfthrow message="No existe la Tesoreria para esta empresa por lo que no se puede generar la Solicitud de Pago">
		</cfif>
	</cffunction>
	
	<!---
		Metodo: 
			getValidNumeroPago
		Resultado:
			Obtiene el Id que se va a generar para la solicitud de pago.
	--->
	<cffunction name="getValidNumPago" access="private" returntype="any" output="no">
		<cfargument name="Ecodigo" required="true" type="numeric">
		
		<cfquery name="rsMaxIdTES" datasource="#GvarConexion#">
			select isnull(max(TESSPnumero),0) + 1 as IdSol
            from TESsolicitudPago
            where EcodigoOri= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			
		</cfquery>
		
		<cfreturn rsMaxIdTES.IdSol>
	</cffunction>
	
	<!---
		Metodo: 
			getValidCentroFun
		Resultado:
			Obtiene el id del centro funcional
	--->
	<cffunction access="private" name="getValidCentroFun" output="no" returntype="any">
		<cfargument name="CFuncional" 		     required="yes" type="string">
		<cfargument name="Ecodigo" 		     required="yes" type="numeric">
		
		<!---Obtiene el CFid--->
			<cfquery name="rsCFuncional" datasource="#GvarConexion#" >
				 select CFid
					 from CFuncional
				  where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFuncional#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			 <cfif isdefined("rsCFuncional") and rsCFuncional.recordcount GT 0>
					<cfreturn rsCFuncional.CFid>
			  <cfelse>
			  		<cfthrow message="El Centro Funcional #Arguments.Oficina# no esta dado de alta en el SIF.">		
			  </cfif>
	</cffunction>

	<!---
		Metodo: 
			getValidBeneficiario
		Resultado:
			Devuelve el CBid de la tabla de Beneficiarios de Tesoreria.
			Si no se encuentra un registro para el codigo aborta el proceso.	
	--->
	
	<cffunction access="private" name="getValidBeneficiario" output="no" returntype="numeric">
		<cfargument name="Beneficiario" required="yes" type="string"> <!--- JMRV --->
		<cfargument name="Ecodigo" required="yes" type="numeric">

			<cfquery name="rsBeneficiario" datasource="#GvarConexion#">
				select TESBid, TESBeneficiario
				from TESbeneficiario
				where TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Beneficiario#">
				<!---  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ecodigo#"> checar--->
				  and TESBactivo  = 1
			</cfquery>
			
			<cfif rsBeneficiario.recordcount GT 0>
				<cfreturn rsBeneficiario.TESBid>
			<cfelse>	
				<cfthrow message="El beneficiario #Arguments.Beneficiario# no existe o no se encuentra como activo en la Tesorería del SIF">
			</cfif> 		
	</cffunction>
	
	<!--- JMRV. Inicio. --->
	<!---
		Metodo: 
			getValidSocio
		Resultado:
			Valida si existe el socio de negocios.
			Si no se encuentra un registro para el codigo aborta el proceso.	
	--->
	
	<cffunction access="private" name="getValidSocio" output="no" returntype="numeric">
		<cfargument name="Socio" required="yes" type="numeric">
		<cfargument name="Ecodigo" required="yes" type="numeric">

		<cfquery name="rsSocio" datasource="#GvarConexion#">
			select SNid, SNidentificacion, SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Socio#">					
		</cfquery>
						
		<cfif rsSocio.recordcount EQ 0>
			<cfthrow message="El socio de negocios #Arguments.Socio# no existe">
		<cfelse>
			<cfreturn Arguments.Socio>
		</cfif>		
	</cffunction>
	<!--- JMRV. Fin. --->
	
	
		<!---
		Metodo: 
			getValidIdConcepto
		Resultado:
			Devuelve el Cid de la tabla de Conceptos.
			Si no se encuentra un registro para el codigo aborta el proceso.	
	--->
	
	<cffunction access="private" name="getValidIdConcepto" output="no" returntype="numeric">
		<cfargument name="CCodigo" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">

			<cfquery name="rsCid" datasource="#GvarConexion#">
				select Cid, Ccodigo 
				from Conceptos 
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			
			<cfif rsCid.recordcount GT 0>
				<cfreturn rsCid.Cid>
			<cfelse>	
				<cfthrow message="El concepto de servicio #Arguments.CCodigo# no existe en el SIF">
			</cfif> 		
	</cffunction>
	
	<!---
		Metodo: 
			getValidMoneda
		Resultado:
			Devuelve el codigo de la Moneda.	
	--->
	
	<cffunction access="private" name="getValidMoneda" output="no" returntype="any">
		<cfargument name="Miso4217" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		
			<cfquery name="rsMon" datasource="#session.DSN#">
	   			select Mcodigo
				from Monedas
				where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			    and Miso4217  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Miso4217#">
		   </cfquery>
	   
	   		 <cfif isdefined("rsMon") and rsMon.recordcount GT 0>
	   			<cfreturn rsMon.Mcodigo>
			<cfelse>	
				<cfthrow message="No se ha podido obtener el codigo de moneda #Arguments.Miso4217#">
			</cfif>
	</cffunction>

	<!---
		Metodo: 
			getValidForma_Pago
		Resultado:
			Devuelve una forma de pago.	
	--->
	<cffunction access="private" name="getValidForma_Pago" output="no" returntype="any">
		<cfargument name="Forma_Pago" required="yes" type="numeric">
		
	   		 <cfif Arguments.Forma_Pago gte 0 and Arguments.Forma_Pago lte 3>
	   			<cfreturn Arguments.Forma_Pago>
			<cfelse>	
				<cfreturn 0><!--- Forma de pago default --->
			</cfif>
	</cffunction>

	<!---
		Metodo: 
			getValidCta_Forma_Pago
		Resultado:
			Devuelve una cuenta valida para la forma de pago 2(TEF), si no es correcta la cuenta envia un mensaje de error.	
	--->
	
	<cffunction access="private" name="getValidCta_Forma_Pago" output="no" returntype="any">
		<cfargument name="Beneficiario" required="yes" type="boolean">
		<cfargument name="Identificador" required="yes" type="numeric">
		
		<cfif Beneficiario>
			<cfquery name="rsCtaDestino" datasource="#GvarConexion#">
				select TESTPid
				from TEStransferenciaP	 
				where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Identificador#">
				and TESTPestado = 1
			</cfquery>	
		<cfelse>
			<cfquery name="rsSocio" datasource="#GvarConexion#">
				select SNid
				from SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Identificador#">					
			</cfquery>
			<cfquery name="rsCtaDestino" datasource="#GvarConexion#">
				select TESTPid
				from TEStransferenciaP	 
				where SNidP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.SNid#">
				and TESTPestado = 1
			</cfquery>	
		</cfif>	
		<cfif rsCtaDestino.recordcount EQ 0>
			<cfthrow message="La cuenta destino para el tipo de pago por TEF no existe">
		<cfelse>
			<cfreturn rsCtaDestino.TESTPid>
		</cfif>	
	</cffunction>
		
</cfcomponent>

