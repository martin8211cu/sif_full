<!---<cfdump var="#session.Tesoreria#">
<cf_dump var="#form#">
--->
<cfparam name="modo" default="ALTA">
<cfset var = 0>
<cfset LvarPagina = "TCEPago.cfm">
			<cfif isdefined("Form.chk")>
            	<cfset LvarCPDDids 	= "">
                <cfloop index="LvarLin2" list="#Form.chk#" delimiters=",">
                    <cfset LvarDet2 		= #ListToArray(LvarLin2, "|")#>
                    <cfset LvarCPDDids 	= ListAppend(LvarCPDDids,LvarDet2[1])>
                </cfloop>
                <cfloop list="#LvarCPDDids#" index="i">
                   <cfset repetidos = 0>
				   <cfloop list="#LvarCPDDids#" index="p">
                   		<cfif #i# eq #p#>
                        	<cfif repetidos gt 0>
                   				<cf_errorCode	code = "80201" msg = "No es posible agregar m&aacute;s de un Estado de Cuenta para la misma Tarjeta y Moneda">
                            </cfif>
                            <cfset repetidos = 1>
                        </cfif>
                   </cfloop>
                </cfloop>

            	<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
					<cfset LvarDet 		= #ListToArray(LvarLin, "|")#>
                    <cfset LvarCBid 	= LvarDet[1]>
                    <cfset LvarSaldo 	= LvarDet[2]>
                    <cfset LvarVenta 	= LvarDet[3]>
                    <cfset LvarECid 	= LvarDet[4]>
                    <cfset LvarVenta2 	= LvarDet[5]>
                    <cfset valor = #LvarSaldo# * #LSNumberFormat(LvarVenta2, '9.9999')#>
                    <cftransaction>
                        <cfquery name="insertDetTCE" datasource="#session.DSN#">
                            insert into CBDPagoTCEdetalle (CBPTCid,
                            CBid,
                            CBDPTCmonto,
                            CBDPTCtipocambio,
                            ECid,
                            BMUsucodigo)
                            values (
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBid#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#valor#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#LvarVenta#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarECid#">,
                            #session.Usucodigo#
                            )
                        </cfquery>
                    </cftransaction>
                </cfloop>
			<cfelseif isdefined("form.btnGenerarOPTCE") >
            	<cfset LvarPagina = "TCEPago-list.cfm">
				<cfset tmpArray="#form.CBidOri.split(',')#"/>
				<cfset Miso = #tmpArray[3]#>
                <cfset CBPTCid = #form.CBPTCid#>
                <cfset TESOPtotalPago = #form.montot#>
                <cftransaction>
                	<cfset OPTCE = sbGeneraOP_TCE(#form.CBPTCid#,'#Miso#',#TESOPtotalPago#)>
                </cftransaction>
                <cfset session.pago.OPnum = OPTCE>
                <cflocation addtoken="no" url="#LvarPagina#">

			<cfelseif isdefined("Form.Alta")>
                <cftransaction>
                	<cfquery name="TCEInsert" datasource="#session.DSN#">
                        insert into CBEPagoTCE (CBPTCdescripcion,
                        CBPTCfecha,
                        CBid,
                        TESid,
                        TESMPcodigo,
                        TESTPid,
                        TESBid,
                        CBPTCtipocambio,
                        CBPTCestatus,
                        BMUsucodigo)
                        values (
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Form.Descripcion)#" len="50">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.FechaSolicitada)#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBidc#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria['TESid']#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TESMPcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CtaDestino#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Emisor#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#Form.TESTIDtipoCambioDst#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="10">,
                        #session.Usucodigo#
                        )
                         <cf_dbidentity1 datasource="#session.DSN#">
                    </cfquery>
                    <cf_dbidentity2 datasource="#session.DSN#" name="TCEInsert">
    				<cfset var = TCEInsert.identity >
                </cftransaction>
                <cfset modo="CAMBIO">

			<cfelseif isdefined("Form.Baja")>
            	<cfset LvarPagina = "TCEPago-list.cfm">
                <cftransaction>
                    <cfquery name="TCEDetalleDetele" datasource="#session.DSN#">
                        delete from CBDPagoTCEdetalle
                        where CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
                    </cfquery>

                    <cfquery name="TCEEncabezadoDetele" datasource="#session.DSN#">
                        delete from CBEPagoTCE
                        where CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
                    </cfquery>
                </cftransaction>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio") or isdefined("Form.AltaD") or isdefined("Form.BorrarD") and len(trim(#Form.BorrarD#)) gt 0>
               		<cfif isdefined("Form.AltaD")>


               		<cfelseif isdefined("Form.BorrarD") and Len(Trim(#Form.BorrarD#)) NEQ 0>
                        <cfquery name="deletDetTCE" datasource="#session.DSN#">
                            delete from CBDPagoTCEdetalle
                            where CBDPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBDPTCid#">
                        </cfquery>

				   <cfelseif isdefined("Form.Cambio")>
                   <cftransaction>
                   <cfquery name="CuentasTCpdate" datasource="#session.DSN#">
                        update CBEPagoTCE set
                            CBPTCdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Trim(Form.Descripcion)#" len="50">,
                            CBPTCfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.FechaSolicitada)#">,
                            CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBidc#">,
                            TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria['TESid']#">,
                            TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TESMPcodigo#">,
                            TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CtaDestino#">,
                            TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Emisor#">,
                            CBPTCtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.TESTIDtipoCambioDst#">
                        where CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
                    </cfquery>
                </cftransaction>
                </cfif>
                  <cfset modo="CAMBIO">
		  </cfif>
<cfif isdefined("Form.chk")>
	<script language="JavaScript" type="text/javascript">
    	window.opener.location.reload();
        window.close();
    </script>
</cfif>
<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq "ALTA">
		<input name="CBidOri" type="hidden" value="<cfif isdefined("Form.CBidOri")><cfoutput>#Form.CBidOri#</cfoutput></cfif>">
		<input name="Descripcion" type="hidden" value="<cfif isdefined("Form.Descripcion")><cfoutput>#Form.Descripcion#</cfoutput></cfif>">
    </cfif>
	<cfif modo eq "CAMBIO" and var gt 0>
    	<input name="CBPTCid" type="hidden" value="<cfoutput>#var#</cfoutput>">
    <cfelseif modo eq "CAMBIO">
    	<input name="CBPTCid" type="hidden" value="<cfoutput>#Form.CBPTCid#</cfoutput>">
    </cfif>
    <!---<cf_dump var="#modo#">--->
    <input name="desde" type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">
</form>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

<!--- sbGenerarOP_TCE: genera la solicitud, orden y detalle de pago para los estados de cuentas de las tarjetas de creditos --->
<cffunction name="sbGeneraOP_TCE" output="true" access="public" returntype="numeric">
    <cfargument name="CBPTCid" type="numeric"	required="yes" >
    <cfargument name="Miso4217" type="string"	required="yes">
    <cfargument name="TESOPtotalPago" type="numeric"	required="yes">
    <cfargument name="TESSPid" type="numeric"	default="-1">

    <cftry>
        <cfquery name="rsLote" datasource="#Session.DSN#">
            select pt.CBPTCdescripcion, pt.CBPTCfecha, pt.CBid, pt.TESid, pt.TESMPcodigo,
            pt.TESTPid, pt.TESBid, pt.CBPTCtipocambio, pt.CBPTCestatus, m.Mcodigo
            from CBEPagoTCE pt
            inner join TEStransferenciaP a
            on a.TESTPid = pt.TESTPid
            inner join Monedas m
            on m.Miso4217 = a.Miso4217
            and m.Ecodigo = #session.Ecodigo#
            where pt.TESid    = #session.Tesoreria.TESid#
               and pt.CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CBPTCid#">
        </cfquery>

        <cfif rsLote.CBPTCestatus EQ 10 AND Arguments.TESSPid NEQ -1>
            <!--- Regenera OP --->
        <cfelseif rsLote.CBPTCestatus GT 11>
            <cfthrow message="La transferencia ya fue enviada al proceso de abono">
        </cfif>

        <cfquery name="rsSQL" datasource="#Session.DSN#">
            select count(1) as cantidad
              from CBDPagoTCEdetalle
               where CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CBPTCid#">
        </cfquery>
        <cfif rsSQL.cantidad EQ 0>
            <cfthrow message="No se puede enviar al proceso de pago, necesita incluir Estados de Cuenta">
        </cfif>

        <!--- rsTESB : Asocia el TESbeneficiario--->
        <cfquery name="rsTESB" datasource="#Session.DSN#">
            select TESBid, TESBeneficiarioId, TESBeneficiario
            from TESbeneficiario
            where TESBid = #rsLote.TESBid#
        </cfquery>

        <cflock type="exclusive" name="TesOrdPago" timeout="3">
            <cfquery name="rsTESOP" datasource="#session.dsn#">
                select coalesce(max(TESOPnumero)+1,1) as SiguienteOP
                  from TESordenPago
                 where TESid = #session.Tesoreria.TESid#
            </cfquery>
            <cfquery name="insert" datasource="#session.dsn#">
                insert into TESordenPago
                        (
                         TESid, TESOPnumero, TESOPestado,
                         TESBid, TESTPid, TESOPbeneficiarioId, TESOPbeneficiario,
                         TESOPfechaPago,
                         EcodigoPago, CBidPago, TESMPcodigo,
                         Miso4217Pago, TESOPtipoCambioPago, TESOPtotalPago,
                         TESOPfechaGeneracion, UsucodigoGenera
                        )
                values (
                         #session.Tesoreria.TESid#,
                         #rsTESOP.SiguienteOP#,
                         10,
                         #rsLote.TESBid#,
                         #rsLote.TESTPid#,
                         <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#rsTESB.TESBeneficiarioId#">,
                         <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#rsTESB.TESBeneficiario#">,
                         <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
                         #session.Ecodigo#, #rsLote.CBid#,
                         <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" value="#rsLote.TESMPcodigo#">,
                         <cf_jdbcQuery_param cfsqltype="cf_sql_char" value="#Arguments.Miso4217#">,
                         <cfqueryparam cfsqltype="cf_sql_float"				value="#rsLote.CBPTCtipocambio#">,
                         <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#Arguments.TESOPtotalPago#">,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                         #session.usucodigo#
                        )
                <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESOPid">
        </cflock>

        <cfif Arguments.TESSPid NEQ -1>
            <cfset LvarTESSPid = Arguments.TESSPid>
            <cfquery datasource="#session.dsn#">
                update TESsolicitudPago
                   set TESOPid 	= #LvarTESOPid#
                 where TESSPid 	= #LvarTESSPid#
            </cfquery>
            <cfquery datasource="#session.dsn#">
                update TESdetallePago
                   set TESOPid 	= #LvarTESOPid#
                 where TESSPid 	= #LvarTESSPid#
            </cfquery>
        <cfelse>
            <cflock type="exclusive" name="TesSolPago" timeout="3">
            	<cfquery name="rsCFuncional" datasource="#session.dsn#">
                	select CFid
                    from CFuncional
                    where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    	and CFcodigo = CFpath
                </cfquery>

                <cfquery name="rsNewSol" datasource="#session.dsn#">
                    select coalesce(max(TESSPnumero),0) + 1 as newSol
                    from TESsolicitudPago
                    where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                </cfquery>

                <cfquery datasource="#session.dsn#" name="insert">
                    insert into TESsolicitudPago (
                        TESid,
                        EcodigoOri, TESSPnumero, TESSPtipoDocumento, TESSPestado,
                        TESBid,
                        TESSPfechaPagar, McodigoOri,
                        TESSPtipoCambioOriManual, TESSPtotalPagarOri, TESSPfechaSolicitud,
                        UsucodigoSolicitud, BMUsucodigo, TESSPfechaAprobacion, UsucodigoAprobacion,
                        TESOPid,
                        NAP, CFid
                        )
                    values (
                        #session.Tesoreria.TESid#,
                        <cfqueryparam cfsqltype="cf_sql_integer" 			value="#session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" 			value="#rsNewSol.newSol#">,
                        11, 10,
                        <cfqueryparam cfsqltype="cf_sql_numeric"			value="#rsLote.TESBid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp"	value="#rsLote.CBPTCfecha#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"			value="#rsLote.Mcodigo#">,

                        <cfqueryparam cfsqltype="cf_sql_float"				value="#rsLote.CBPTCtipocambio#">,
                        <cfqueryparam cfsqltype="cf_sql_money"				value="#Arguments.TESOPtotalPago#">,

                        <cfqueryparam cfsqltype="cf_sql_timestamp" 			value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#session.usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#session.usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" 			value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#session.usucodigo#">,
                        #LvarTESOPid#,
                        0,
                        #rsCFuncional.CFid#
                    )
                    <cf_dbidentity1 datasource="#session.DSN#" name="insert">
                </cfquery>
                <cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
            </cflock>

			<cfquery name="rsDetallePago" datasource="#session.dsn#">
				select
                    #session.Tesoreria.TESid#,
                    cb.Ocodigo as OcodigoOri,
                    #rsCFuncional.CFid#,
                    11,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESOPid#">,
                    11, cd.CBPTCid, cd.CBDPTCid,
                    'TEOP', '#Arguments.CBPTCid#', 'Abono TCE',
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"		value="Abono TCE: #rsLote.CBPTCdescripcion#" len="50">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<!--- <cfif len(rsCformatoCuentaBanco.CFormatoTCE) GT 0 and LvarCFcuenta NEQ 0>
						#LvarCFcuenta#,
					<cfelse>
						(select min(CFcuenta) from CFinanciera where Ccuenta = cb.Ccuenta) as CFcuentaDB,
					</cfif> --->

                    m.Miso4217,
                    cd.CBDPTCtipocambio,
                    cbe.CBPTCtipocambio,
                    (ec.ECsaldofin * -1),
                    (ec.ECsaldofin * -1),
                    (ec.ECsaldofin * -1),
                    ((ec.ECsaldofin * -1) * cd.CBDPTCtipocambio),
                    (cd.CBDPTCtipocambio / cbe.CBPTCtipocambio),
                    ((ec.ECsaldofin * -1) * (cd.CBDPTCtipocambio / cbe.CBPTCtipocambio)),
                    ((ec.ECsaldofin * -1) * cd.CBDPTCtipocambio)

                    from CBDPagoTCEdetalle cd
                    inner join CBEPagoTCE cbe
                    on cbe.CBPTCid = cd.CBPTCid
                    inner join CuentasBancos cb
                    on cb.CBid = cd.CBid
                    and cb.Ecodigo = #session.Ecodigo#
                    inner join ECuentaBancaria ec
                    on ec.ECid = cd.ECid
                    inner join Monedas m
                    on m.Mcodigo = cb.Mcodigo
                    where cd.CBPTCid = <cfqueryparam value="#Arguments.CBPTCid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfloop query="rsDetallePago">

				<cfquery name="rsCformatoCuentaBanco" datasource="#session.dsn#">
					select right(('0000'+convert(varchar,ltrim(rtrim(cf.CFcodigo)))),4) as CFcodigo,
						ef.CFid, cb.CFormatoTCE, cb.CBdescripcion
					from CBDPagoTCEdetalle cd
					inner join CuentasBancos cb on cb.CBid = cd.CBid
					inner join CBTarjetaCredito cbtc ON cbtc.Bid = cb.Bid and cbtc.CBTCid = cb.CBTCid
					inner join EmpleadoCFuncional ef on ef.DEid = cbtc.DEid
					inner join CFuncional cf on cf.CFid = ef.CFid
					where cd.CBDPTCid = <cfqueryparam value="#CBDPTCid#" cfsqltype="cf_sql_numeric">
						and getdate() between ef.ECFdesde and ef.ECFhasta
				</cfquery>

				<cfset LvarCFcuenta = 0 />
				<cfset LvarFlagCuenta = false />

				<cfif rsCformatoCuentaBanco.recordCount GT 0 and len(trim(rsCformatoCuentaBanco.CFormatoTCE)) GT 0>

					<cfif find("?",rsCformatoCuentaBanco.CFormatoTCE)>
						<cfset Comodin = '?'>
						<cfinvoke component="sif.Componentes.AplicarMascara" method="AplicarMascara" returnvariable="Cuenta">
							<cfinvokeargument name="cuenta" value="#rsCformatoCuentaBanco.CFormatoTCE#">
							<cfinvokeargument name="valor"   value="#rsCformatoCuentaBanco.CFcodigo#">
							<cfinvokeargument name="sustitucion" value="#Comodin#">
						</cfinvoke>
					<cfelseif find("!",rsCformatoCuentaBanco.CFormatoTCE)>
						<cfset Comodin = '!'>
						<cfinvoke component="sif.Componentes.AplicarMascara" method="AplicarMascara" returnvariable="Cuenta">
							<cfinvokeargument name="cuenta" value="#rsCformatoCuentaBanco.CFormatoTCE#">
							<cfinvokeargument name="valor"   value="#rsCformatoCuentaBanco.CFcodigo#">
							<cfinvokeargument name="sustitucion" value="#Comodin#">
						</cfinvoke>
					<cfelse>
						<cfset Cuenta = #rsCformatoCuentaBanco.CFormatoTCE# />
					</cfif>

					<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
						method="fnGeneraCuentaFinanciera"
						returnvariable="Lvar_MsgError">
						<cfinvokeargument name="Lprm_CFformato"	value="#Cuenta#"/>
						<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
						<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
						<cfinvokeargument name="Lprm_NoCrear" value="false"/>
						<cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
						<cfinvokeargument name="Lprm_debug" value="false"/>
						<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_DSN" value="#Session.DSN#">
					</cfinvoke>

					<cfif isdefined('Lvar_MsgError') AND (Lvar_MsgError NEQ "" AND Lvar_MsgError NEQ "OLD" AND Lvar_MsgError NEQ "NEW")>
						<cfthrow message="Error: #rsCformatoCuentaBanco.CBdescripcion# #Lvar_MsgError#" />
					<cfelseif isdefined('Lvar_MsgError') AND (Lvar_MsgError EQ "NEW" OR Lvar_MsgError EQ "OLD")>
						<cfquery name="rsCFCuenta" datasource="#Session.DSN#">
							select CFcuenta, Ccuenta,CPcuenta,CFformato from CFinanciera where Ecodigo =
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Cuenta#">
						</cfquery>
						<cfif rsCFCuenta.recordcount gt 0>
							<cfset LvarCFcuenta = #rsCFCuenta.CFcuenta# />
						</cfif>

					</cfif>
				</cfif>

				<cfquery name="insertdetalle" datasource="#session.dsn#">
					<!--- Validar cuenta leer si el campo cformatotce tiene valor --->
					<!--- si tiene valor, sustituir los comodines de cf --->
					insert into TESdetallePago (
						TESid, OcodigoOri, CFid, TESDPestado, EcodigoOri,
						TESSPid, TESOPid, TESDPtipoDocumento, TESDPidDocumento,
						TESSPlinea, TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
						TESDPdescripcion, TESDPfechaVencimiento, TESDPfechaSolicitada,
						TESDPfechaAprobada, TESDPfechaPago, EcodigoPago, CFcuentaDB,
						Miso4217Ori, TESDPtipoCambioOri, TESDPtipoCambioSP, TESDPmontoVencimientoOri,
						TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, TESDPmontoAprobadoLocal,
						TESDPfactorConversion, TESDPmontoPago, TESDPmontoPagoLocal )
					select
						#session.Tesoreria.TESid#, cb.Ocodigo as OcodigoOri, #rsCFuncional.CFid#, 11,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESOPid#">, 11,
						cd.CBPTCid, cd.CBDPTCid, 'TEOP', '#Arguments.CBPTCid#', 'Abono TCE',
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar"		value="Abono TCE: #rsLote.CBPTCdescripcion#" len="50">,
						<cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
						<cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
						<cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
						<cf_jdbcQuery_param cfsqltype="cf_sql_date" 	value="#rsLote.CBPTCfecha#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfif len(trim(rsCformatoCuentaBanco.CFormatoTCE)) GT 0 and LvarCFcuenta NEQ 0>
							#LvarCFcuenta#,
						<cfelse>
							(select min(CFcuenta) from CFinanciera where Ccuenta = cb.Ccuenta) as CFcuentaDB,
						</cfif>
						m.Miso4217, cd.CBDPTCtipocambio, cbe.CBPTCtipocambio,
						(ec.ECsaldofin * -1), (ec.ECsaldofin * -1),
						(ec.ECsaldofin * -1), ((ec.ECsaldofin * -1) * cd.CBDPTCtipocambio),
						(cd.CBDPTCtipocambio / cbe.CBPTCtipocambio),
						((ec.ECsaldofin * -1) * (cd.CBDPTCtipocambio / cbe.CBPTCtipocambio)),
						((ec.ECsaldofin * -1) * cd.CBDPTCtipocambio)
						from CBDPagoTCEdetalle cd
							inner join CBEPagoTCE cbe on cbe.CBPTCid = cd.CBPTCid
							inner join CuentasBancos cb on cb.CBid = cd.CBid and cb.Ecodigo = #session.Ecodigo#
							inner join ECuentaBancaria ec on ec.ECid = cd.ECid
							inner join Monedas m on m.Mcodigo = cb.Mcodigo
						where cd.CBDPTCid = <cfqueryparam value="#CBDPTCid#" cfsqltype="cf_sql_numeric">
				</cfquery>

			</cfloop>

        </cfif>

        <cfquery name="updatePagoTCE" datasource="#Session.DSN#">
            update CBEPagoTCE
               set CBPTCestatus = 11,
               CBPTCorden = #rsTESOP.SiguienteOP#
             where TESid 	= #rsLote.TESid#
               and CBPTCid = <cfqueryparam value="#Arguments.CBPTCid#" cfsqltype="cf_sql_numeric">
        </cfquery>
        <cfreturn rsTESOP.SiguienteOP>
    <cfcatch type="any">
        <cftransaction action="rollback" />
        <cfrethrow>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="CompareFormato" output="no" returnType="boolean" access="private">
	<cfargument name="strFormatoDB" required="yes" type="string" />
	<cfargument name="strFormatoTCE" required="yes" type="string" />
	<cfset result = true>
	<cfset a = #trim(Arguments.strFormatoDB)#>
	<cfset b = #trim(Arguments.strFormatoTCE)#>

	<cfset arrA = a.split("-") />
	<cfset arrB = b.split("-") />
	<!--- verificanndo la cantidad de rublos --->
	<cfif ArrayLen(arrA) eq ArrayLen(arrB)>
		<!--- iterando sobre los rublos --->
		<cfloop from = "1" to = "#ArrayLen(arrA)#" index = "i">
			<cfset rubloA = "#arrA[i]#" />
			<cfset rubloB = "#arrB[i]#" />
			<!--- comparando tamaño del rublo --->
			<cfif len(rubloA) EQ len(rubloB)>
				<cfif findoneof("!?",rubloA) EQ 0>
					<cfif Compare(rubloA,rubloB) NEQ 0>
						<cfset result = false>
						<cfbreak>
					</cfif>
				</cfif>
			<cfelse>
				<cfset result = false>
				<cfbreak>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset result = false>
	</cfif>
	<cfreturn result>
</cffunction>


