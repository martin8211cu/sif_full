<cfcomponent extends="base">
	<cffunction name="AddVentaServicios" returntype="numeric" hint="regresa el nuevo S01CON generado" output="false">
		<!--- Lee los datos de isb y los guarda en SACISIIC --->
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="login_principal" type="string" required="yes">
		<cfargument name="S01CON_principal" type="numeric" default="0" hint="S01CON del login principal (para logines adicionales)">
	
<!---
	TipoVenta:
		--**  (1 Venta de Servicios a Cuenta Existente de Cliente Existente)
		--**  (2 Venta de Servicios a Cuenta Nueva de Cliente Existente)
		--**  (3 Venta de Servicios a Cuenta Nueva de Cliente Nuevo)
		1,2 => Cliente Existente == !ClienteNuevo
		2,3 => Cuenta Nueva
--->
		<cfset locales = StructNew()>
		<!--- defaults --->
		<cfset leerDatosLogin(Arguments.LGnumero)>
		<cfquery datasource="SACISIIC" name="SSXFID">
			select FIDEST
			from SSXFID
			where FIDCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
		</cfquery>
		
		<cfquery datasource="SACISIIC" name="ClienteNuevo">
			select CLTSIS, CLTCOD
			from SSMCLT
			where CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.Pid#">
		</cfquery>
		<cfquery datasource="SACISIIC" name="CuentaNueva">
			select count(1) as cant
			from SSXSSC
			where SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">
		</cfquery>
		<cfset locales.CLTCOD = ClienteNuevo.CLTCOD>
		<cfset locales.CLTSIS = ClienteNuevo.CLTSIS>
		<cfset ClienteNuevo = Len(locales.CLTCOD) EQ 0>
		<cfset CuentaNueva = CuentaNueva.cant EQ 0>

		<!---
			Validar los datos de la cuenta.
			Se hace fuera de la transacción porque los mensajes se guardan
			en #session.dsn#, y la transacción opera en SACISIIC
		 --->
		<cfif ListFind('3,9,10', ISBgarantia.Gtipo)>
			<!--- Validar SSXDEP (INSCOD,DEPDOC,DEPFED) --->
			<cfif Len(ISBcuentaCobro.INSCOD) is 0>
				<cfset control_mensaje ( 'SIC-0012', 'La institución del depósito de garantía es requerida' )>
			</cfif>
			<cfif Len(ISBgarantia.Gref) is 0>
				<cfset control_mensaje ( 'SIC-0012', 'La referencia del depósito de garantía es requerida' )>
			</cfif>
			<cfif Len(ISBgarantia.Ginicio) is 0>
				<cfset control_mensaje ( 'SIC-0012', 'La fecha del depósito de garantía es requerida' )>
			</cfif>
		</cfif>
		<cfif ListFind('2,3', ISBcuentaCobro.CTcobro)>
			<!--- Validar SSMCOB (IFCCOD,COBIDE,COBANO,COBMES) --->
			<cfif Len(ISBcuentaCobro.IFCCOD) is 0>
				<cfset control_mensaje ( 'SIC-0013', 'La institución de la forma de cobro es requerida' )>
			</cfif>
			<cfif Len(Trim(ISBcuentaCobro.CTbcoRef)) is 0>
				<cfset control_mensaje ( 'SIC-0013', 'La tarjeta o cuenta de la forma de cobro es requerida' )>
			</cfif>
			<cfif Len(ISBcuentaCobro.CTanoVencimiento) is 0>
				<cfset control_mensaje ( 'SIC-0013', 'El año de vencimiento de la tarjeta de la forma de cobro es requerida' )>
			</cfif>
			<cfif Len(ISBcuentaCobro.CTmesVencimiento) is 0>
				<cfset control_mensaje ( 'SIC-0013', 'El mes de vencimiento de la tarjeta de la forma de cobro es requerida' )>
			</cfif>
		</cfif>
		<cftransaction>
		
		<!--- Registro de Cliente en SACISIIC --->
		<cfif ClienteNuevo>
			<cfquery datasource="SACISIIC" name="Alta_SSMCLT">
				declare @CLTCOD int
				exec sp_Alta_SSMCLT  
					@CLTCOD = @CLTCOD output,
					@CLTSIS = 1,<!--- SACI=1/SIIC=0 --->
					@CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.Pid#">,
					@CLTRSO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.PrazonSocial#">,
					@CLTPUB = 'V',<!--- V=Privado/P=Publico--->
					@CLTIMP = 'S',
					@GRUCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.GCcodigo#">,
					@CLTPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.BMUsulogin#">,
					@CLTTIP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.Ppersoneria#">
				select @CLTCOD as CLTCOD
			</cfquery>
			<cfset locales.CLTCOD = Alta_SSMCLT.CLTCOD>
			<cfset locales.CLTSIS = 1>
		</cfif>
		
		<cfif CuentaNueva>
	
			<!--- Registro de Cuenta en SACISIIC --->
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSMCUE 
					@CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">,
					@CUESIS = 1,<!--- SACI=1/SIIC=0 --->
					@CUENOM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.PrazonSocial#">,
					@CLTCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#locales.CLTCOD#">,
					@ACTCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpersona.AEactividad#">,
					<cfif ISBpersona.Pfisica eq 0>
						@CUEGER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ISBRepresentante.Papellido & ' ' & ISBRepresentante.Papellido2 & ' ' & ISBRepresentante.Pnombre)#">,
					<cfelse>
						@CUEGER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ISBpersona.Papellido & ' ' & ISBpersona.Papellido2 & ' ' & ISBpersona.Pnombre)#">,
					</cfif>
					@CUEDIR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBLocalizacion.Pdireccion#">,
					@CUEAPT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ISBLocalizacion.Papdo)#-#ISBLocalizacion.CPid#">,
					@CUETEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBLocalizacion.Ptelefono1#">,
					@CUETL2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBLocalizacion.Ptelefono2#">,
					@CUEFAX = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBLocalizacion.Pfax#">,
					@PRVCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBLocalizacion.provincia#">,
					@CANCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBLocalizacion.canton#">,
					@DISCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBLocalizacion.distrito#">,
					
					@CUETIP = <cfif ISBcuenta.CTcobrable is 'S'>'S'<cfelse>'C'</cfif>,
					@CLACOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CCclaseCuenta#">,
					@CUEFAP = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBcuenta.CTapertura#" null="#Len(ISBcuenta.CTapertura) is 0#">,
					@VENCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.VENCOD#">,
					@CUEOBS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuenta.CTobservaciones#">,
					@CUEPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuenta.BMUsulogin#">,
					@CLTSIS = <cfqueryparam cfsqltype="cf_sql_integer" value="#locales.CLTSIS#">
			</cfquery>
	
			<!--- Registro de Mecanismo de Envío de la Facturación en SACISIIC --->
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSMENV  
					@CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">,
					@CUESIS = 1,<!--- SACI=1/SIIC=0 --->
					@ENVTIP = <cfif ISBcuentaNotifica.CTtipoEnvio is '1'>'A'<cfelse>'D'</cfif>,<!--- Apartado o Dirección: 1/2 = A/D --->
					<cfif ISBcuentaNotifica.CTtipoEnvio is '1'>
						@ENVDIR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaNotifica.CTatencionEnvio#">,
					<cfelse>
						@ENVDIR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaNotifica.CTdireccionEnvio#">,
					</cfif>
					@ENVAPT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaNotifica.CTapdoPostal#">,
					@ZOPCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuentaNotifica.CPid#" null="#Len(ISBcuentaNotifica.CPid) is 0#">,
					@ENVCOP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaNotifica.CTcopiaModo#">,
					@ENVICO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaNotifica.CTcopiaDireccion#">,
					@ENVCAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaNotifica.CTcopiaDireccion2#">
			</cfquery>
	
			<!--- Registro de Forma de Cobro de la Facturación en SACISIIC --->
			<cfif ListFind('2,3', ISBcuentaCobro.CTcobro)>
				<!--- seleccionaron cargo a tarjeta o cuenta bancaria --->
				<cfquery datasource="SACISIIC">
					exec sp_Alta_SSMCOB  
						@CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">,
						@CUESIS = 1,<!--- SACI=1/SIIC=0 --->
						@COBCOI = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuentaCobro.CTcobro#" null="#Len(ISBcuentaCobro.CTcobro) is 0#">,
						@IFCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuentaCobro.IFCCOD#" null="#Len(ISBcuentaCobro.IFCCOD) is 0#">,
						@COBIDE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuentaCobro.CTbcoRef#">,
						@COBEST = 'A',
						@COBANO = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuentaCobro.CTanoVencimiento#" null="#Len(ISBcuentaCobro.CTanoVencimiento) is 0#">,
						@COBMES = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuentaCobro.CTmesVencimiento#" null="#Len(ISBcuentaCobro.CTmesVencimiento) is 0#">
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- Registro de Perfil / login de internet en SACISIIC --->
		<cfquery datasource="SACISIIC" name="existeSSXINT">
			select count(1) as cant
			from SSXINT
			where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
		</cfquery>
		<cfif not existeSSXINT.cant>
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXINT  
					@SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">,
					
					<cfif Len(ISBpaqinterfaz.PQinterfaz) And Not ISBlogin.LGprincipal> 
						@CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaqinterfaz.PQinterfaz#" null="#Len(Trim(ISBpaqinterfaz.PQinterfaz)) is 0#">,
					<cfelse>
						@CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.CINCAT#">,
					</cfif>					
					@SERGUI = <cfif ISBlogin.LGmostrarGuia is 1>'S'<cfelse>'N'</cfif>, 
					@INTNOM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.Papellido# #ISBpersona.Papellido2# #ISBpersona.Pnombre#">,
					@INTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.Pid#">,
					@INTOBS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBcuenta.CTobservaciones#">,
					@INTVEN = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.VENCOD#">,
					@INTSOB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.Snumero#">,
					@SERTIP = <cfif ISBcuenta.CTcobrable is 'S'>'S'<cfelse>'F'</cfif>,<!--- Servicio/Cobrable (saci) --> Servicio/Facturable (siic) --->
					@INTCON = '***',<!--- contraseña: no se manda --->
					@INTTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGtelefono#">,
					@INTPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.BMUsulogin#">,
					
					<cfif Len(ISBpaqinterfaz.PQinterfaz) And Not ISBlogin.LGprincipal> 
						@INTPAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LGserids_padre#" null="#Len(Trim(LGserids_padre)) is 0#">					
					<cfelseif Len(ISBproducto.MRidMayorista)>
						<!---es cable modem--->
						@INTPAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBproducto.CNnumero#">
					<cfelse>
						<!--- revisar login padre --->
						@INTPAD = null
					</cfif>
			</cfquery>
		</cfif>
		
		<!--- Registro de Tabla de Equivalencias en SACISIIC --->
		<cfquery datasource="SACISIIC" name="existeSSXSSC">
			select count(1) as cant
			from SSXSSC
			where SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">
			  and  SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
		</cfquery>
		<cfif existeSSXSSC.cant>
			<cfquery datasource="SACISIIC">
				update SSXSSC
				set CLTRSO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.PrazonSocial#">
				, SERIDS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGserids#">
				
				<cfif Len(ISBpaqinterfaz.PQinterfaz) And  Not ISBlogin.LGprincipal>
				, CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaqinterfaz.PQinterfaz#" null="#Len(Trim(ISBpaqinterfaz.PQinterfaz)) is 0#">
				<cfelse>
				, CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.CINCAT#">
				</cfif>
				, SSCFAP = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBproducto.CNapertura#" null="#Len(ISBproducto.CNapertura) is 0#">
				, SSCINC = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBcuenta.CTdesde#" null="#Len(ISBcuenta.CTdesde) is 0#">
				, SSCFIN = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBcuenta.CThasta#" null="#Len(ISBcuenta.CThasta) is 0#">
				, SSCPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.BMUsulogin#">
				where SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">
				  and  SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
			</cfquery>
		<cfelse>
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXSSC
					@RETORNO = 0,
					@SSCCOD = null,
					@CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CUECUE#" null="#ISBcuenta.CUECUE is 0#">,
					@CUENOM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.PrazonSocial#">, 
					@CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpersona.Pid#">, 
					@SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.CTid#">,
					@SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">,
					@SERIDS = null,
					<cfif Len(ISBpaqinterfaz.PQinterfaz) And  Not ISBlogin.LGprincipal > 
						@CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaqinterfaz.PQinterfaz#" null="#Len(ISBpaqinterfaz.PQinterfaz) is 0#">, 
					<cfelse>
						@CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.CINCAT#" null="#Len(ISBproducto.CINCAT) is 0#">,
					</cfif>
					@ESCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.ECestado#" null="#Len(ISBcuenta.ECestado) is 0#">,
					@CONCGO = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBcuenta.ECsubEstado#" null="#Len(ISBcuenta.ECsubEstado) is 0#">,
					@VENCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.VENCOD#">,
					@SSCFAP = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBproducto.CNapertura#" null="#Len(ISBproducto.CNapertura) is 0#">, 
					@SSCINC = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBcuenta.CTdesde#" null="#Len(ISBcuenta.CTdesde) is 0#">,
					@SSCFIN = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ISBcuenta.CThasta#" null="#Len(ISBcuenta.CThasta) is 0#">,
					@SSCPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.BMUsulogin#">
			</cfquery>
		</cfif>
		
		<!---
			Equivalencias
			FIDCOD = ISBgarantia.Gtipo
			DEPMON = ISBgarantia.Gmonto
			SSCCTA = ISBcuenta.CTid
		--->
		<cfset locales.S01COF = 0>
		
		<!--- Registro de Tarea a músico SIIC en SACISIIC --->
		
		<cfif Arguments.S01CON_principal And Len(Arguments.login_principal)>
			<cfset locales.S01VA1 = '5*' & Arguments.login_principal & '*' & ISBlogin.LGlogin & '*' & Arguments.S01CON_principal>
			<cfset locales.S01COF = -500>
		<cfelseif ClienteNuevo>
			<cfset locales.S01VA1 = '3*' & locales.CLTCOD & '*' & ISBcuenta.CTid & '*' & ISBlogin.LGlogin & '*1'>
		<cfelseif CuentaNueva>
			<cfset locales.S01VA1 = '2*' & locales.CLTCOD & '*' & ISBcuenta.CTid & '*' & ISBlogin.LGlogin & '*' & locales.CLTSIS>
		<cfelse>
			<cfset locales.S01VA1 = '1*' & locales.CLTCOD & '*' & ISBcuenta.CUECUE & '*' & ISBlogin.LGlogin & '*0'>
		</cfif>
		<cfif ListFind('1,2,3', Left(locales.S01VA1,1))>
			<cfif (SSXFID.FIDEST is 'E') And Len(ISBgarantia.Gmonto)>
				<cfset locales.S01COF = -30000>
			</cfif>
		</cfif>
				
		<cfif Len(ISBproducto.MRidMayorista) And ListFind('1,2', Left(locales.S01VA1, 1))>
			<!---es cable modem--->
			<cfset locales.S01VA1 = locales.S01VA1  & '*' & ISBproducto.CNnumero>
		<cfelseif Len(ISBpaqinterfaz.PQinterfaz) And ListFind('1', Left(locales.S01VA1, 1))>
			<!--- es paquete de correo --->
			<cfset locales.S01VA1 = locales.S01VA1  & '*' & LGserids_padre>
		<cfelse>
			<!--- dejar el S01VA1 hasta donde iba --->
		</cfif>
		
		<cfif ISBproducto.AAinterno>
			<cfset locales.S01VA2 = 0>
		<cfelse>
			<cfset locales.S01VA2 = #ISBproducto.VENCOD#>
		</cfif>
		<cfquery datasource="SACISIIC" name="Alta_SSXS01_Q">
			declare @S01CON int
			exec sp_Alta_SSXS01  
				@RETORNO = 0,
				@S01CON = @S01CON output,
				@S01ACC = 'N',
				@S01COF = #locales.S01COF#,
				@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#locales.S01VA1#">,
				@S01VA2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#locales.S01VA2#">,
				@SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
			select @S01CON as S01CON
		</cfquery>
		<cfset S01CON_new = Alta_SSXS01_Q.S01CON>
		
		<!--- Cambia el estado del sobre utilizado en SACISIIC --->
		<cfquery datasource="SACISIIC">
			update SSXSOB 
			set SOBEST = 1
			 , SOBDUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBproducto.Vid#">
			where SOBCON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.Snumero#"> 
		</cfquery>
		
		<!--- Si el depósito de garantía que se ingresó en la venta 
			de servicios es de tipo cajas de RACSA, se envía una tarea de bloqueo en SACISIIC --->
		<cfif (SSXFID.FIDEST is 'E') And Len(ISBgarantia.Gmonto) And ISBgarantia.Gmonto GT 0 and ISBlogin.LGprincipal>
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXS02 
					@RETORNO = 0,
					@S02ACC = 'L',
					@S02COF = 0,
					@S02VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="*#ISBlogin.LGlogin#">,
					@S02VA2 = '0',
					@S02ORT = 0
			</cfquery>
		</cfif>

		<!--- Registro de Pago Adelantado en SACISIIC --->
		<!--- esto no aplica: Funcionalidad que estaba en el SP pero no se usaba
		<cfif FIPCOD != null And FIPCOD != 0>
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXPAD
					  @PADMON = @PADMON
					, @PADMOD = @PADMOD
					, @SERIDS = @SERIDS
					, @SERCLA = @SERCLA
					, @INSCOD = @INSCODT
					, @PADDOC = @PADDOC
					, @PADFED = @PADFED
					, @FIPCOD = @FIPCOD
					, @MAAT 	= 1
					, @RETORNO = 0
			</cfquery>
		</cfif>
		--->


   <cfif Not ISBlogin.LGprincipal>	
		<!--- Registro de Depósito de Garantía en SACISIIC --->
		<cfquery datasource="SACISIIC">
			exec sp_Alta_SSXDEP
				  @DEPMON = 
					<cfif Len(ISBgarantia.Gmonto)>
						<cfqueryparam cfsqltype="cf_sql_float" value="0">
					<cfelse> 0 </cfif>
				, @DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
				, @SERIDS = null
				, @SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#" null="#Len(ISBlogin.LGlogin) is 0#">
				, @INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
				, @DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
				, @DEPFED =
					<cfif Len(ISBgarantia.Ginicio)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
					<cfelse> NULL </cfif>
					
				, @FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
					<cfelse> 1 </cfif>
				, @MAAT 	= 1
				, @RETORNO = 0
		</cfquery>
	<cfelse>
				<cfquery datasource="SACISIIC" name="depositos">
				exec sp_Alta_SSXDEP
				<!---El monto se indica en la interfaz SACI-03-H029b--->
				@DEPMON = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBgarantia.Gmonto#"> 
				, @DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
				, @SERIDS = null
				, @SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#" null="#Len(ISBlogin.LGlogin) is 0#">
				, @INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
				, @DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
				, @DEPFED =
				<cfif Len(ISBgarantia.Ginicio)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
				<cfelse> NULL </cfif>
				
				, @FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
				<cfelse> 1 </cfif>
				, @MAAT 	= 1
				, @RETORNO = 1				
			</cfquery>
	
	</cfif>
		</cftransaction>

		<cfif ISBlogin.LGprincipal and isdefined('depositos')>	
		<cfquery datasource="#session.dsn#" name="actualizaISBgarantia">
				Update ISBgarantia Set DEPNUM = <cfqueryparam cfsqltype="cf_sql_float" value="#depositos.DEPNUM#">
				Where Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gid#">
		</cfquery>
		</cfif>
		
		<cfset control_mensaje( 'SIC-0001', 'S01CON:#S01CON_new#' )>
		
		<cfreturn S01CON_new>
	</cffunction>
	
	<!--- leerDatosLogin --->
	<cffunction name="leerDatosLogin" returntype="void" output="false">
		<cfargument name="LGnumero" type="numeric" required="yes">
		
		<cfquery datasource="#session.dsn#" name="ISBlogin">
			select *, u.Usulogin as BMUsulogin
			from ISBlogin l
				left join Usuario u
					on u.Usucodigo = l.BMUsucodigo
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="ISBpaqinterfaz">
		select coalesce(paq.CINCAT,0) as PQinterfaz
		    from ISBserviciosLogin sl
    			inner join ISBservicio sp
    				on sl.PQcodigo = sp.PQcodigo
    			and sl.TScodigo = sp.TScodigo
    			inner join ISBpaquete paq
    				on paq.PQcodigo = sp.PQinterfaz
		where sl.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
		
		<cfif ISBlogin.RecordCount is 0>
			<cfthrow message="No existe el login #Arguments.LGnumero#">
		</cfif>
		<cfset accesos = getTStipos(Arguments.LGnumero)>
		<cfquery datasource="#session.dsn#" name="LGserids_padre">
			select LGserids
			from ISBlogin 
			  where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
				and LGserids is not null
				and LGserids != ''
				and LGprincipal = 1
			order by LGnumero
		</cfquery>
		<cfset LGserids_padre = LGserids_padre.LGserids>
		
		<cfquery datasource="#session.dsn#" name="ISBproducto">
			select p.*, pq.CINCAT, pq.MRidMayorista, a.AAinterno,
				case when ven.AGid is null or ven.AGid = 199 then 0 else ven.AGid end as VENCOD
			from ISBproducto p
				left join ISBpaquete pq
					on pq.PQcodigo = p.PQcodigo
				left join ISBvendedor ven
					on ven.Vid = p.Vid
				inner join ISBagente a
					on a.AGid = ven.AGid	
			where p.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
		</cfquery>
		<cfif ISBproducto.RecordCount is 0>
			<cfthrow message="No existe el producto #ISBlogin.Contratoid#">
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="ISBgarantia">
			select g.Gtipo, g.Gmonto, g.Gref, g.Ginicio, g.Miso4217, ef.INSCOD, g.DEPNUM, g.Gid
			from ISBgarantia g
				left join ISBentidadFinanciera ef
					on ef.EFid = g.EFid
			where g.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="ISBcuenta">
			select c.*,
				coalesce (c.GCcodigo, 1) as GCcodigo,
				ce.ECestado, ce.ECsubEstado, ce.ECnombre,
				cc.CCnombre, gc.GCnombre, u.Usulogin as BMUsulogin
			from ISBcuenta c
				left join ISBcuentaEstado ce
					on ce.ECidEstado = c.ECidEstado
				left join ISBclaseCuenta cc
					on cc.CCclaseCuenta = c.CCclaseCuenta
				left join ISBgrupoCobro gc
					on gc.GCcodigo = c.GCcodigo
				left join Usuario u
					on u.Usucodigo = c.BMUsucodigo
			where c.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBproducto.CTid#">
		</cfquery>
		<cfif ISBcuenta.RecordCount is 0>
			<cfthrow message="No existe la cuenta #ISBproducto.CTid#">
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="ISBcuentaNotifica">
			select p.*, cp.CPnombre,
				coalesce ( loc3.LCcod, '9') as provincia,
				coalesce ( loc2.LCcod, '99') as canton,
				coalesce ( loc1.LCcod, '99') as distrito
			from ISBcuentaNotifica p
				left join OficinaPostal cp
					on cp.CPid = p.CPid
				left join Localidad loc1
					on loc1.LCid = p.LCid
				left join Localidad loc2
					on loc2.LCid = loc1.LCidPadre
				left join Localidad loc3
					on loc3.LCid = loc2.LCidPadre
			where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBproducto.CTid#">
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="ISBcuentaCobro">
			select cc.*,
				mt.MTnombre, ef.IFCCOD, ef.INSCOD
			from ISBcuentaCobro cc
				left join ISBentidadFinanciera ef
					on ef.EFid = cc.EFid
				left join ISBtarjeta mt
					on mt.MTid = cc.MTid
			where cc.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBproducto.CTid#">
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="ISBLocalizacion">
			select loc.CPid, loc.Papdo, loc.LCid, loc.Pdireccion,
					loc.Pbarrio, loc.Ptelefono1, loc.Ptelefono2, loc.Pfax,
					loc.Pemail,
					coalesce ( loc3.LCcod, '9') as provincia,
					coalesce ( loc2.LCcod, '99') as canton,
					coalesce ( loc1.LCcod, '99') as distrito,
					cp.CPnombre
			from ISBlocalizacion loc
					left join OficinaPostal cp
						on cp.CPid = loc.CPid
					left join Localidad loc1
						on loc1.LCid = loc.LCid
					left join Localidad loc2
						on loc2.LCid = loc1.LCidPadre
					left join Localidad loc3
						on loc3.LCid = loc2.LCidPadre

			where loc.RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBproducto.CTid#">
			and Ltipo = 'C'
		</cfquery>
	
		<cfif ISBLocalizacion.RecordCount is 0>
			<cfthrow message="No existen datos de localización para la cuenta #ISBproducto.CTid#">
		</cfif>

		<cfquery datasource="#session.dsn#" name="ISBRepresentante">
		Select Pnombre,
				Papellido,Papellido2
			from ISBpersona p
			left join ISBpersonaRepresentante r
			on p.Pquien = r.Pcontacto
		Where r.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBcuenta.Pquien#">
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="es_agente">
			select AGid
			from ISBagente
			where CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBproducto.CTid#">
		</cfquery>
		
		<cfif es_agente.RecordCount>
			<cfquery datasource="#session.dsn#" name="ISBpersona">
				select 
					p.Pquien, p.Ppersoneria, p.Pid, p.Pnombre,
					p.Papellido, p.Papellido2, p.Ppais,
					p.Pobservacion, p.Pprospectacion, p.Ecodigo, p.AEactividad,
					loc.CPid, loc.Papdo, loc.LCid, loc.Pdireccion,
					loc.Pbarrio, loc.Ptelefono1, loc.Ptelefono2, loc.Pfax,
					loc.Pemail, coalesce (ag.AAregistro, p.Pfecha) as Pfecha, cp.CPnombre,
					case
						when tp.Pfisica = 0 then
							p.PrazonSocial
						else
							p.Papellido || ' ' || p.Papellido2 || ' ' || p.Pnombre
					end as PrazonSocial,
					coalesce ( loc3.LCcod, '9') as provincia,
					coalesce ( loc2.LCcod, '99') as canton,
					coalesce ( loc1.LCcod, '99') as distrito,
					tp.Pfisica,
					u.Usulogin as BMUsulogin
				from ISBpersona p
					left join ISBagente ag
						on ag.Pquien = p.Pquien
					left join ISBlocalizacion loc
						on loc.RefId = ag.AGid
						and loc.Ltipo = 'A'
					left join ISBtipoPersona tp
						on tp.Ppersoneria = p.Ppersoneria
					left join OficinaPostal cp
						on cp.CPid = loc.CPid
					left join Localidad loc1
						on loc1.LCid = loc.LCid
					left join Localidad loc2
						on loc2.LCid = loc1.LCidPadre
					left join Localidad loc3
						on loc3.LCid = loc2.LCidPadre
					left join Usuario u
						on u.Usucodigo = p.BMUsucodigo
				where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBcuenta.Pquien#">
			</cfquery>
		
		<cfelse>
		
			<cfquery datasource="#session.dsn#" name="ISBpersona">
				select 
					p.Pquien, p.Ppersoneria, p.Pid, p.Pnombre,
					p.Papellido, p.Papellido2, p.Ppais,
					p.Pobservacion, p.Pprospectacion, p.Ecodigo, p.AEactividad,
					p.CPid, p.Papdo, p.LCid, p.Pdireccion,
					p.Pbarrio, p.Ptelefono1, p.Ptelefono2, p.Pfax,
					p.Pemail, p.Pfecha, cp.CPnombre,
					case
						when tp.Pfisica = 0 then
							p.PrazonSocial
						else
							p.Papellido || ' ' || p.Papellido2 || ' ' || p.Pnombre
					end as PrazonSocial,
					coalesce ( loc3.LCcod, '9') as provincia,
					coalesce ( loc2.LCcod, '99') as canton,
					coalesce ( loc1.LCcod, '99') as distrito,
					tp.Pfisica,
					u.Usulogin as BMUsulogin
				from ISBpersona p
					left join ISBtipoPersona tp
						on tp.Ppersoneria = p.Ppersoneria
					left join OficinaPostal cp
						on cp.CPid = p.CPid
					left join Localidad loc1
						on loc1.LCid = p.LCid
					left join Localidad loc2
						on loc2.LCid = loc1.LCidPadre
					left join Localidad loc3
						on loc3.LCid = loc2.LCidPadre
					left join Usuario u
						on u.Usucodigo = p.BMUsucodigo
				where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBcuenta.Pquien#">
			</cfquery>
		
		</cfif>
		<cfset control_mensaje( 'QRY-0001', 'LGnumero=#Arguments.LGnumero#, #ISBlogin.RecordCount# rows' )>
	</cffunction>
	
</cfcomponent>