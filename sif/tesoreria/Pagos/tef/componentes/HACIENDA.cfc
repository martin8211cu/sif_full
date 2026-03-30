<cfcomponent output="no">
	<cffunction name="Verificar" output="no" access="public" returntype="void">
		<cfargument name="TESTLid"		type="numeric">
		<cfargument name="TESTLdatos"	type="string">
		<cfargument name="TESTGid"		type="numeric">

		<cfset LvarCC = listGetAt(Arguments.TESTLdatos,1)>
		<cfif not isnumeric(LvarCC)>
			<cfthrow message="El consecutivo para generacion no es numerico">
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			SELECT b.BcodigoACH, b.Bdescripcion
			 FROM TEStransferenciasL tl
				inner join CuentasBancos cb
					 on cb.CBid = tl.CBid
				inner join Bancos b
					 on b.Bid = cb.Bid
			where tl.TESid	 = #session.Tesoreria.TESid#
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
			  and tl.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
		</cfquery>

		<cfset LvarEEE 		= rsSQL.BcodigoACH>			<!--- Viene de Bancos --->
		<cfif trim(LvarEEE) EQ "">
			<cfthrow message="Falta registrar Código Nacional de Banco para Transferencias Interbancarias en el Banco '#rsSQL.Bdescripcion#'">
		</cfif>
		<cfif not isnumeric(LvarEEE)>
			<cfthrow message="Código Nacional de Banco para Transferencias Interbancarias en el Banco '#rsSQL.Bdescripcion#' no es numérico: #LvarEEE#">
		</cfif>
		<cfif LvarEEE GT 999>
			<cfthrow message="Código Nacional de Banco para Transferencias Interbancarias en el Banco '#rsSQL.Bdescripcion#' mayor a 999: #LvarEEE#">
		</cfif>


		<cfset LvarIDneg	= fnLeerDato(Arguments.TESTGid,"Identificacion")>	<!--- Viene de Parametros de Ecodigo --->
		<cfif REfind("3-\d\d\d-\d\d\d\d\d\d",LvarIDneg) EQ 0>
			<cfthrow message="Identificación de Empresa en Parámetros Generación TRE no cumple estandar: 3-NNN-NNNNNN: #LvarIDneg#">
		</cfif>
		<cfset LvarNomNeg	= fnLeerDato(Arguments.TESTGid,"Nombre Empresa")>	<!--- Viene de Parametros de Ecodigo --->
		<cfset LvarServicio	= fnLeerDato(Arguments.TESTGid,"Servicio Pagos")>	<!--- Viene de Parametros de Ecodigo --->
		<cfset LvarCostos	= fnLeerDato(Arguments.TESTGid,"CentroCosto")>		<!--- Viene de Parametros de Ecodigo --->

		<cf_dbfunction name="OP_concat" returnvariable="_cat">
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			SELECT 
				td.TESTDid,
				op.TESOPid, 
				op.TESOPnumero, 
				op.TESOPbeneficiarioId,
				op.TESOPbeneficiario #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, 
				op.Miso4217Pago, 
				op.TESOPtotalPago,
				op.TESOPinstruccion,
				cta.TESTPcuenta,
				b.Bdescripcion, b.BcodigoACH
			 FROM TESordenPago op
				inner join CuentasBancos cb
					 on cb.CBid = op.CBidPago
				inner join TEStransferenciasD td
					 on td.TESid 	= op.TESid
					and td.TESOPid 	= op.TESOPid
					and td.TESTLid	= op.TESTLid
				inner join TEStransferenciaP cta
					 on cta.TESid 	= op.TESid
					and cta.TESTPid	= op.TESTPid
				inner join Bancos b
					 on b.Bid = cta.Bid
			where op.TESid	   = #session.Tesoreria.TESid#	
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
			  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
			order by op.TESOPnumero
		</cfquery>

		<cfset LvarFecha	= createODBCDate(now())>
		<cfset LvarSS		= "31">						<!--- Tipo Servicio:	Servicio SINPE de Creditos Directos --->
		<cfset LvarSesion	= "1">						<!--- Tipo Sesion:		Sesion de Cobro (puede ser de devoluciones) --->
		<cfset LvarMotivo	= "1">						<!--- Cod. Motivo:		Es el pago (puede ser el motivo de devolucion) --->

 		<cfloop query="rsTESTD">
			<cfset LvarCta = fnVerificaCC(rsTESTD.TESTPcuenta,rsTESTD.BcodigoACH,rsTESTD.Bdescripcion,rsTESTD.TESOPbeneficiarioId)>
			<cfset LvarRef = FnGeneraCodReferencia(rsTESTD.TESOPnumero)>
			<cfset fnMoneda(rsTESTD.Miso4217Pago)>
		</cfloop>
	</cffunction>
		
	<cffunction name="fnLeerDato" output="no" returntype="string">
		<cfargument name="TESTGid"		type="numeric">
		<cfargument name="TESTGdato">
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select TESTGvalor
			  from TEStransferenciaG2
			 where TESTGid		= #Arguments.TESTGid#
			   and Ecodigo		= #session.Ecodigo#
			   and TESTGdato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdato#">
			   and TESTGtipo	= 'E'
			 order by TESTGsec
		</cfquery>
		<cfif trim(rsSQL.TESTGvalor) EQ "">
			<cfthrow message="No se ha parametrizado '#Arguments.TESTGdato#' en parámetros Generación TRE">
		</cfif>

		<cfreturn trim(rsSQL.TESTGvalor)>
	</cffunction>

	<cffunction name="Generar" output="no" access="public" returntype="struct">
		<cfargument name="TESTLid"			type="numeric">
		
		<cfset LvarResult = structNew()>
		<cfset LvarResult.FileName = DateFormat(LvarFecha, "YYYYMMDD") & "-" & LvarEEE & numberFormat(LvarSS, "00") & NumberFormat(LvarSesion, "00") & NumberFormat(LvarCC, "00") & ".Datos">
		<cfset LvarResult.File = expandPath("./") & getTickCount() & ".tmp">

		<cfset LvarResult.HayError = false>
		<cfset LvarError = "">

<!---
		<cfset sbCreateElement(0,"<!-- SOIN SIF - Sistema Integrado Financiero -->")>
		<cfset sbCreateElement(0,"<!-- Modulo de Tesoreria -->")>
		<cfset sbCreateElement(0,"<!-- CCD Compensacion de Creditos Directos del SINPE -->")>
		<cfset sbCreateElement(0,"<!-- Camara Saliente -->")>
--->
		<cfset sbCreateElement(0,"<SINPEDOCUMENTOXML>")>

		<!--- ENCABEZADO --->
		<cfset sbCreateElement(1,"<ENCABEZADO>")>
  
		<cfset LvarLin = "<CICLO">
		<cfset LvarLin &= fnAgregaAtributo ("Fecha", 		DateFormat(LvarFecha, "YYYY-MM-DD"))>
		<cfset LvarLin &= fnAgregaAtributo ("CodServicio",	LvarSS)>
		<cfset LvarLin &= fnAgregaAtributo ("NumSesion",	LvarSesion)>
		<cfset LvarLin &= "/>">
		<cfset sbCreateElement(2,LvarLin)>

		<cfset LvarLin = "<ENTIDAD">
		<cfset LvarLin &= fnAgregaAtributo ("CodEntidad",	LvarEEE)>
		<cfset LvarLin &= fnAgregaAtributo ("Consecutivo",	LvarCC)>
		<cfset LvarLin &= "/>">
		<cfset sbCreateElement(2,LvarLin)>

		<cfset sbCreateElement(1,"</ENCABEZADO>")>

		<!--- ORDENES DE PAGO --->
		<cfset sbCreateElement(1,"<CREDITOS>")>
 		<cfloop query="rsTESTD">
			<cfset LvarCta = fnVerificaCC(rsTESTD.TESTPcuenta,rsTESTD.BcodigoACH,rsTESTD.Bdescripcion,rsTESTD.TESOPbeneficiarioId)>
			<cfset LvarLin = "<CREDITO">
			<cfset LvarLin &= fnAgregaAtributo ("CodEntidadOrigen",		LvarEEE)>
			<cfset LvarLin &= fnAgregaAtributo ("CodEntidadDestino",	mid(LvarCta,1,3))>
			<cfset LvarLin &= fnAgregaAtributo ("CodMotivo",			LvarMotivo)>
			<cfset LvarLin &= fnAgregaAtributo ("CodMoneda",			fnMoneda(Miso4217Pago))>
			<cfif findNoCase("##Oficina##",LvarServicio)>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					SELECT upper(min(o.Odescripcion)) as Oficina
					 FROM TESordenPago op
					 	inner join TESdetallePago dp
							 on dp.TESOPid = op.TESOPid
						inner join CFuncional cf
							 on cf.CFid = dp.CFid
						inner join Oficinas o
							 on o.Ecodigo = cf.Ecodigo
							and o.Ocodigo = cf.Ocodigo							 
					where op.TESOPid = #rsTESTD.TESOPid#	
				</cfquery>
				<cfset LvarServicio1 = replaceNoCase(LvarServicio,"##oficina##",rsSQL.Oficina)>
			<cfelse>
				<cfset LvarServicio1 = LvarServicio>
			</cfif>
			<cfset LvarLin &= fnAgregaAtributo ("Servicio", 			LvarServicio1)>
			<cfset LvarRef = FnGeneraCodReferencia(rsTESTD.TESOPnumero)>
			<cfset LvarLin &= fnAgregaAtributo ("CodReferencia", 		LvarRef)>
			<cfset LvarLin &= fnAgregaAtributo ("IdNegocio",			LvarIDneg)>
			<cfset LvarLin &= fnAgregaAtributo ("NomNegocio",			LvarNomNeg)>
			<cfset LvarLin &= fnAgregaAtributo ("CentroCosto",			LvarCostos)>

			<cfset LvarLin &= fnAgregaAtributo ("IdDestino",			rsTESTD.TESOPbeneficiarioId)>
			<cfset LvarLin &= fnAgregaAtributo ("CuentaCliente",		LvarCta)>
			<cfset LvarLin &= fnAgregaAtributo ("Monto",				NumberFormat(rsTESTD.TESOPtotalPago, ",0.00"))>
	
			<cfset LvarDesGen	= trim(rsTESTD.TESOPinstruccion)>
			<cfif LvarDesGen EQ "">
				<cfset LvarDesGen = "PAGO FACTURA">
			</cfif>
			<cfset LvarLin &= fnAgregaAtributo ("DesGeneral",			LvarDesGen)>
			<cfset LvarLin &= "/>">
			<cfset sbCreateElement(2,LvarLin)>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update TEStransferenciasD
				   set TESTDreferencia = '#LvarRef#'
				 where TESTDid = #rsTESTD.TESTDid#
			</cfquery>
		</cfloop>

		<!--- RESUMEN --->
		<cfquery name="rsRESUMEN" dbtype="query">
			select count(1) as cantidad,
			       sum(TESOPtotalPago) as total
			  from rsTESTD
		</cfquery>
		<cfset LvarLin = "<RESUMEN">
		<cfset LvarLin &= fnAgregaAtributo ("CantidadDatos",	NumberFormat(rsRESUMEN.cantidad, ",0"))>
		<cfset LvarLin &= fnAgregaAtributo ("SumatoriaMontos",	NumberFormat(rsRESUMEN.total, ",0.00"))>
		<cfset LvarLin &= "/>">
		<cfset sbCreateElement(2,LvarLin)>
  
		<!--- FINAL --->
		<cfset sbCreateElement(1,"</CREDITOS>")>
		<cfset sbCreateElement(0,"</SINPEDOCUMENTOXML>")>

		<cfif LvarResult.HayError>
			<cfset LvarResult.FileName = "Errores_en_texto.txt">
		</cfif>
		<cfreturn LvarResult>
	</cffunction>
	
	<cffunction name="sbCreateElement" output="no" access="private" returntype="void">
		<cfargument name="nivel"			type="numeric">
		<cfargument name="texto"			type="string">
		
		<cfset var LvarTexto = "">
		<cfif Arguments.nivel GT 0>
			<cfset LvarTexto &= repeatstring(chr(9),Arguments.nivel)>
		</cfif>
		<cfset LvarTexto &= Arguments.texto>
		<cffile action="append" file="#LvarResult.File#" output="#LvarTexto#" addnewline="yes">
	</cffunction>

	<cffunction name="fnAgregaAtributo" output="no" access="private" returntype="string">
		<cfargument name="nombre"			type="string">
		<cfargument name="valor"			type="string">
		
		<cfreturn " #Arguments.nombre#='#trim(Arguments.valor)#'">
	</cffunction>

	<cffunction name="FnVerificaCC" output="no" access="private" returntype="string">
		<cfargument name="CC"			type="string">
		<cfargument name="BCO"			type="string">
		<cfargument name="Banco"		type="string">
		<cfargument name="Bene"			type="string">		


		<cfset var LvarCta = trim(Arguments.CC)>
		<cfset var LvarBco = trim(Arguments.Bco)>
		<cfset var LvarBene = trim(Arguments.Bene)>

		<cfif len(LvarCta) NEQ 17>
		  <cfthrow message="Cuenta Cliente debe ser de 17 caracteres: #LvarCta#  Beneficiario: #LvarBene#">
		</cfif>
		
		<cfif trim(LvarBCO) EQ "">
			<cfthrow message="No se ha registrado el Código Nacional de Banco para Transferencias Interbancarias en el Banco Destino '#Arguments.Banco#'">
		</cfif>
		<cfif not isnumeric(LvarBCO)>
			<cfthrow message="Código Nacional de Banco para Transferencias Interbancarias en el Banco Destino '#Arguments.Banco#' no es numérico: #LvarBco#">
		</cfif>
		<cfif LvarBCO GT 999>
			<cfthrow message="Código Nacional de Banco para Transferencias Interbancarias en el Banco Destino '#Arguments.Banco#' mayor a 999: #LvarBco#">
		</cfif>

		<cfset LvarBCO = right("000#LvarBco#",3)>
		<cfif left(LvarCta,3) NEQ LvarBco>
		  <cfthrow message="Cuenta Cliente '#LvarCta#' no empieza con el Código Nacional de Banco para Transferencias Interbancarias en el Banco '#Arguments.Banco#': #LvarBCO#">
		</cfif>

		<cfset LvarDV  = mid (LvarCta,17,1)>
		<cfset LvarCta = mid (LvarCta,1,16)>
		<cfset LvarDVG = fnDigitoVerificador(LvarCta)>
		<cfif LvarDV NEQ LvarDVG>
		  <cfthrow message="Digito Verificador de Cuenta Cliente '#Arguments.CC#' debe ser #LvarDVG#">
		</cfif>
		
		<cfreturn "#LvarCta##LvarDVG#">
	</cffunction>

	<cffunction name="FnGeneraCodReferencia" output="no" access="private" returntype="string">
		<cfargument name="OP"			type="numeric">

		<cfset var LvarOP	= trim(Arguments.OP)>
		<cfset var LvarRef	= trim(Arguments.OP)>

		<cfif len(LvarOP) GT 9>
			<cfthrow message="Numero de Orden de Pago no puede ser mayor a 999,999,999: #LvarOP#">
		</cfif>

		<cfif LvarSS GT 99>
			<cfthrow message="Prefijo YYYYMMDDEEESSCC para Referencia: Servicio mayor a 99: #LvarSS#">
		</cfif>
		<cfif LvarCC GT 99>
			<cfthrow message="Prefijo YYYYMMDDEEESSCC para Referencia: Consecutivo mayor a 99: #LvarCC#">
		</cfif>

		<cfset LvarOP  = Right("000000000" & LvarOP, 9)>
		<cfset LvarRef = dateformat(LvarFecha,"YYYYMMDD") & numberFormat(LvarEEE,"000") & numberFormat(LvarSS,"00") & numberFormat(LvarCC,"00") & LvarOP>
		<cfset LvarDVG = fnDigitoVerificador(LvarRef)>

		<cfreturn LvarRef & LvarDVG>
	</cffunction>

	<cffunction name="fnDigitoVerificador" output="no" access="private" returntype="string">
		<cfargument name="dato"			type="numeric">

		<cfset var MODULO	= 11>
		<cfset var PESOS	= "1234567891234567891234567891234567">
		<cfset var LONGMAX	= len(PESOS)+1>
  
		<cfset var LvarHileraPesos	= "">
		<cfset var LvarSumaDigitos 	= 0>
		<cfset var LvarDato			= trim(Arguments.dato)>
		<cfset var LvarLongitud		= Len(LvarDato)>
		<cfset var i          		= 0>

		<cfset var LvarPesos = Mid(PESOS, LONGMAX - LvarLongitud, LONGMAX)>

		<cfloop index="i" from="1" to="#LvarLongitud#">
			<cfset LvarSumaDigitos += Val(Mid(LvarDato, i, 1)) * Val(Mid(LvarPesos, i, 1))>
		</cfloop>
		<cfset LprmDigito = LvarSumaDigitos Mod MODULO>
		<cfIf LprmDigito EQ 10>
			<cfset LprmDigito = 1>
		</cfIf>
		<cfreturn LprmDigito>
	</cffunction>

	<cffunction name="fnMoneda" output="no" access="private" returntype="string">
		<cfargument name="Miso4217"			type="string">
		<cfif Arguments.Miso4217 EQ "CRC">
			<cfreturn "1">
		<cfelseif Arguments.Miso4217 EQ "USD">
			<cfreturn "2">
		<cfelseif Arguments.Miso4217 EQ "EUR">
			<cfreturn "3">
		<cfelse>
			<cfthrow message="Codigo de moneda no permitido: #Arguments.Miso4217#">
		</cfif>
	</cffunction>
</cfcomponent>
