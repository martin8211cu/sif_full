<cfif isdefined("LvarPorCFuncional")>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CF">
<cfelse>
	<cfset LvarTipoDocumento = 0>
	<cfset LvarSufijoForm = "">
</cfif>
<cfif isdefined("LvarFiltroPorUsuario") and #LvarFiltroPorUsuario#>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CFusuario">
</cfif>
<cfparam name="form.CPDCid" default="">
<cfif IsDefined("form.Aprobar") or IsDefined("form.GenerarOP")>
	<cfset sbVerificaCuentas()>
	<cfinclude template="solicitudesAprobar_sql.cfm">
</cfif>

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>
<!---►►Modificacion del Encabezado de la Solicitud◄◄--->
<cfif IsDefined("form.Cambio")>
	<cfset CBidPago = -1>
	<cfif isdefined("form.CBidPago") AND #form.CBidPago# neq "">
		<cfset arrFormCbId = listToArray (#form.CBidPago#, ",",false,true)>
		<cfif ArrayLen(arrFormCbId) EQ 4>
			<cfset CBidPago = arrFormCbId[1]>
		</cfif>
	</cfif>

	<cfset TESMPcodigo = -1>
	<cfif isdefined("form.TESMPcodigo") AND #form.TESMPcodigo# NEQ "">
		<cfset TESMPcodigo = #form.TESMPcodigo#>
	</cfif>

	<cf_cboCFid>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="TESsolicitudPago"
		redirect="solicitudesManual#LvarSufijoForm#.cfm"
		timestamp="#form.ts_rversion#"
		field1="TESSPid"
		type1="numeric"
		value1="#form.TESSPid#"
		>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
				set TESid = #session.Tesoreria.TESid#, CFid = #session.Tesoreria.CFid#
					, TESSPfechaPagar = <cfqueryparam value="#LSparseDateTime(form.TESSPfechaPagar)#" cfsqltype="cf_sql_timestamp">
					<cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
						, SNcodigoOri	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">
						, TESBid		= null
						, CDCcodigo		= null
				<cfelseif isdefined('form.TESBid') and len(trim(form.TESBid))>
						, SNcodigoOri	= null
						, TESBid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
						, CDCcodigo		= null
				<cfelseif isdefined('form.CDCcodigo') and len(trim(form.CDCcodigo))>
						, SNcodigoOri	= null
						, TESBid		= null
						, CDCcodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
					</cfif>
					<cfif isdefined('form.McodigoOri') and len(trim(form.McodigoOri))>
						, McodigoOri = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
					</cfif>
					<cfif isdefined('form.TESSPtipoCambioOriManual') and len(trim(form.TESSPtipoCambioOriManual))>
						, TESSPtipoCambioOriManual = #form.TESSPtipoCambioOriManual#
				<cfelse>
						, TESSPtipoCambioOriManual = 1
					</cfif>
					, TESSPtotalPagarOri =
						coalesce(
						( select sum(TESDPmontoSolicitadoOri)
							from TESdetallePago
						   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
						)
						, 0)

					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">

					, TESOPobservaciones 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPobservaciones)#"		null="#rtrim(form.TESOPobservaciones) EQ ""#">
					, TESOPinstruccion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPinstruccion)#"		null="#rtrim(form.TESOPinstruccion) EQ ""#">
					, TESOPbeneficiarioSuf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPbeneficiarioSuf)#"	null="#rtrim(form.TESOPbeneficiarioSuf) EQ ""#">
					<cfif isdefined("form.chkPT")>
						,PagoTercero = 1
					<cfelse>
						,PagoTercero = 0
					</cfif>
					<cfif isdefined("CBidPago") AND isdefined("TESMPcodigo") AND #CBidPago# NEQ -1 AND #TESMPcodigo# NEQ -1>
						,CBidPago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CBidPago#">
						,TESMPcodigoPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TESMPcodigo#">
					<cfelse>
					    ,CBidPago = NULL
					    ,TESMPcodigoPago = NULL
					</cfif>
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set  TESid = #session.Tesoreria.TESid#
				<cfif NOT isdefined("LvarPorCFuncional")>
					, CFid = #session.Tesoreria.CFid#
					, OcodigoOri=(select Ocodigo from CFuncional where Ecodigo=#session.Ecodigo# AND CFid=#session.Tesoreria.CFid#)
				</cfif>
				<cfif isdefined("form.chkPT")>
					,PagoTercero = 1
				<cfelse>
					,PagoTercero = 0
				</cfif>
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
		<cf_cboFormaPago TESOPFPtipoId="5" TESOPFPid="#form.TESSPid#" SQL="update">
	</cftransaction>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
	<!---►►Eliminacion de la Solicitud◄◄--->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESdetallePago
		where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	<!---ERBG corrección SC183340 INICIA--->
	<cfquery datasource="#session.dsn#">
        delete TESsolicitudFirmas
        where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
            and (
                 select count(1)
                  from TESsolicitudPago
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = TESsolicitudFirmas.TESSPid
                   and TESSPestado = 0
                ) <> 0
    </cfquery>
	<!---ERBG corrección SC183340 FIN--->
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
			set TESSPidDuplicado = null
		 where EcodigoOri = #session.Ecodigo#
		   and TESSPidDuplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		   and TESSPestado in (3,13,23,103)
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from TESsolicitudPago
		where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	<!---SML 16/01/2015. Inicio Eliminar del repositorio todos los CFDI relacionado a la Liquidacion antes de aprobarla--->
	<cfquery name="EliminaDet" datasource="#session.dsn#">
		delete from CERepoTMP
		where ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	<!---SML 16/01/2015. Fin Eliminar del repositorio todos los CFDI relacionado a la Liquidacion antes de aprobarla--->
	<cf_cboFormaPago TESOPFPtipoId="5" TESOPFPid="#form.TESSPid#" SQL="delete">
	<!---►►Agregar el Encabezado de la Solicitud◄◄--->
<cfelseif IsDefined("form.Alta")>
	<cfif NOT isdefined("session.Tesoreria.TESid")>
		<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
	</cfif>

	<cfset CBidPago = -1>
	<cfif isdefined("form.CBidPago") AND #form.CBidPago# neq "">
		<cfset arrFormCbId = listToArray (#form.CBidPago#, ",",false,true)>
		<cfif ArrayLen(arrFormCbId) EQ 4>
			<cfset CBidPago = arrFormCbId[1]>
		</cfif>
	</cfif>
	<cfset TESMPcodigo = -1>
	<cfif isdefined("form.TESMPcodigo") AND #form.TESMPcodigo# NEQ "">
		<cfset TESMPcodigo = #form.TESMPcodigo#>
	</cfif>

	<cfquery name="rsObtieneTramite" datasource="#session.dsn#">
		select
			a.ProcessId
				from TESTramiteSolPago a
				inner join CFuncional cf
					on cf.CFid = a.CFid
				inner join WfProcess tr
					on tr.ProcessId = a.ProcessId
				where a.Ecodigo = #session.Ecodigo#
                and a.CFid = #session.Tesoreria.CFid#
		</cfquery>
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<cfquery name="rsNewSol" datasource="#session.dsn#">
            select coalesce(max(TESSPnumero),0) + 1 as newSol
            from TESsolicitudPago
            where EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
		<cftransaction>
			<cfquery datasource="#session.dsn#" name="insert">
                insert into TESsolicitudPago (
                    TESid, CFid,
                    EcodigoOri, TESSPnumero, TESSPtipoDocumento, TESSPestado,
                    SNcodigoOri, TESBid,
                    TESSPfechaPagar, McodigoOri,
                    TESSPtipoCambioOriManual, TESSPtotalPagarOri, TESSPfechaSolicitud,
                    UsucodigoSolicitud, BMUsucodigo

                    , TESOPobservaciones
                    , TESOPinstruccion
                    , TESOPbeneficiarioSuf
						  ,ProcessId
					<cfif isdefined("form.chkPT")>
						,PagoTercero
					</cfif>
					<cfif isdefined("CBidPago") AND isdefined("TESMPcodigo") AND #CBidPago# NEQ -1 AND #TESMPcodigo# NEQ -1>
						,CBidPago, TESMPcodigoPago
					</cfif>
                    )
                values (
                    #session.Tesoreria.TESid#, #session.Tesoreria.CFid#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">,
                    #LvarTipoDocumento#,
                    0,
                    <cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#"> ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    <cfelse>
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
                    </cfif>
                    <cfqueryparam value="#LSparseDateTime(form.TESSPfechaPagar)#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
                    <cfif isdefined('form.TESSPtipoCambioOriManual') and len(trim(form.TESSPtipoCambioOriManual))>
                        #form.TESSPtipoCambioOriManual#,
                    <cfelse>
                        1,
                    </cfif>
                    #form.TESSPtotalPagarOri#,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">

                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPobservaciones)#"		null="#rtrim(form.TESOPobservaciones) EQ ""#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPinstruccion)#"		null="#rtrim(form.TESOPinstruccion) EQ ""#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPbeneficiarioSuf)#"	null="#rtrim(form.TESOPbeneficiarioSuf) EQ ""#">
						  <cfif #rsObtieneTramite.recordcount# gt 0>
						  ,#rsObtieneTramite.ProcessId#
						  <cfelse>
						  ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						  </cfif>
					<cfif isdefined("form.chkPT")>
						,1
					</cfif>
					<cfif isdefined("CBidPago") AND isdefined("TESMPcodigo") AND #CBidPago# NEQ -1 AND #TESMPcodigo# NEQ -1>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#CBidPago#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#TESMPcodigo#">
					</cfif>
                )
                <cf_dbidentity1 datasource="#session.DSN#" name="insert">
            </cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
		</cftransaction>
	</cflock>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
	<!---►►Duplicar la Solicitud◄◄--->
<cfelseif IsDefined("form.Duplicar")>
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<cfquery name="rsNewSol" datasource="#session.dsn#">
            select (max(coalesce(TESSPnumero,0)) + 1) as newSol
            from TESsolicitudPago
            where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
		<cftransaction>
			<cfquery name="rsInserta" datasource="#session.dsn#">
				select TESid, CFid,
				  TESSPtipoDocumento,
				  SNcodigoOri, TESBid,
				  TESSPfechaPagar,
				  McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri,
				  TESSPmsgRechazo,
				  TESOPobservaciones,
				  TESOPinstruccion,
				  TESOPbeneficiarioSuf
				from TESsolicitudPago
			  where EcodigoOri = #session.Ecodigo#
				 and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		  </cfquery>
			<cfquery datasource="#session.dsn#" name="insert">
                insert into TESsolicitudPago (
                    TESid,
					CFid,
                    EcodigoOri,
					TESSPnumero,
                    TESSPtipoDocumento,
					TESSPestado,
                    SNcodigoOri,
					TESBid,
                    TESSPfechaPagar,
                    McodigoOri,
					TESSPtipoCambioOriManual,
					TESSPtotalPagarOri,
                    TESSPmsgRechazo,
                    TESSPfechaSolicitud,
					UsucodigoSolicitud,
                    BMUsucodigo,
					TESOPobservaciones,
					TESOPinstruccion,
					TESOPbeneficiarioSuf
                    )
                values (
					#rsInserta.TESid#,
					#rsInserta.CFid#,
					<cf_jdbcquery_param  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">,
					#rsInserta.TESSPtipoDocumento#,
					0,
					<cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsInserta.SNcodigoOri#"              voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsInserta.TESBid#"                   voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#rsInserta.TESSPfechaPagar#">,
					#rsInserta.McodigoOri#,
					<cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsInserta.TESSPtipoCambioOriManual#" voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsInserta.TESSPtotalPagarOri#">,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#rsInserta.TESSPmsgRechazo#"          voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cf_jdbcQuery_param cfsqltype="cf_sql_clob"              value="#rsInserta.TESOPobservaciones#"       voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#rsInserta.TESOPinstruccion#"         voidNull>,
					<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#rsInserta.TESOPbeneficiarioSuf#"     voidNull>
				)
                <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
			<cfquery datasource="#session.dsn#">
                insert INTO TESdetallePago
                    (
                     TESid, CFid, OcodigoOri,
                     TESDPestado, EcodigoOri, TESSPid,
                     TESDPtipoDocumento, TESDPidDocumento,
                     TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
                     SNcodigoOri, TESDPfechaVencimiento,
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori,
                     TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, TESDPimpNCFOri,
                     TESDPdescripcion, CFcuentaDB, TESRPTCid, Icodigo,
                     FPAEid,CFComplemento, Cid
                    )
                select
                    TESid, CFid, OcodigoOri,
                    0,
                    EcodigoOri,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                     TESDPtipoDocumento, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                     TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
                     SNcodigoOri, TESDPfechaVencimiento,
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori,
                     TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, TESDPimpNCFOri,
                     TESDPdescripcion, CFcuentaDB, TESRPTCid, Icodigo,
					 FPAEid,CFComplemento
                     ,Cid

                  from TESdetallePago
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
            </cfquery>
			<cfquery datasource="#session.dsn#">
                update TESsolicitudPago
                    set TESSPidDuplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
            </cfquery>
		</cftransaction>
	</cflock>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
	<!---►►Aprobacion de la Solicitud◄◄--->
<cfelseif IsDefined("form.AAprobar")>
	<cfset sbVerificaCuentas()>
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
			set TESSPestado  = 1
		 where EcodigoOri = #session.Ecodigo#
		   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TESdetallePago
			set TESDPestado  = 1
		 where EcodigoOri = #session.Ecodigo#
		   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	<!--- Envío a Trámite por Centro Funcional --->
	<!--- SPM = Solicitud de Pago Manual ---->
	<cfinvoke	component		= "sif.tesoreria.Componentes.TESaplicacion"
		method			= "sbTramiteSP"
		TESSPid			= "#form.TESSPid#"
		TipoSol     	= "SPM"
		/>
	<!--- Impresión de la SP --->
	<cf_SP_imprimir location="solicitudesManual#LvarSufijoForm#.cfm">
	<!---►►Nueva Solicitud◄◄--->
<cfelseif IsDefined("form.Nuevo")>
	<!---►►Nuevo Detalle de la Solicitud◄◄--->
<cfelseif IsDefined("form.NuevoDet")>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
	<!---►►Modificacion del Detalle de la Solicitud◄◄--->
<cfelseif IsDefined("form.CambioDet")>
	<cfparam name="form.Cid" 			default="">
	<cfparam name="form.ActividadId" 	default="-1">
	<cfparam name="form.Actividad" 		default="">
	<cfif isdefined('form.Icodigo') and len(form.Icodigo)>
		<cfquery name="rsObtieneCuentaImpuesto" datasource="#session.dsn#">
			select min(cf.CFcuenta) as CFcuenta
			from Impuestos im
				inner join CFinanciera cf
					on cf.Ccuenta = coalesce(im.CcuentaCxPAcred,im.Ccuenta)
			where im.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and im.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
		</cfquery>
		<cfset form.CFcuentaDBd = rsObtieneCuentaImpuesto.CFcuenta>
	</cfif>
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
	</cfquery>
	<cftransaction>
		<cfquery name="rsEsDistribucion" datasource="#session.dsn#">
        Select CPDCid from TESdetallePago
           where TESDPid     = <cfqueryparam value="#form.TESDPid#"  cfsqltype="cf_sql_numeric" >
      </cfquery>
		<cfif len(trim(rsEsDistribucion.CPDCid)) gt 0>
			<cfset EsDistribucion = true>
		<cfelse>
			<cfset EsDistribucion = false>
		</cfif>
		<cfif EsDistribucion >
			<cfquery datasource="#session.DSN#">
				delete from TESdetallePago
				 where CPDClinea = (
				 					Select CPDClinea
									  from TESdetallePago
									 where TESDPid = <cfqueryparam value="#form.TESDPid#"  cfsqltype="cf_sql_numeric" >
									)
			</cfquery>
			<cfset form.CPDCid = rsEsDistribucion.CPDCid>
			<cfset fnAltaDetalle()>
		<cfelse>
			<cfparam name="form.CPDDid" default="">
			<cfparam name="form.TIPODBCR" default="1">
			<!--- Definicion de iva y ieps --->
			<cfset LvarIcodigo  = ''>
			<cfset LvarIcodieps = ''>
			<cfif isdefined('form.Icodigo') and len(trim(form.Icodigo))>
				<cfset LvarIcodigo  = form.Icodigo>
				<cfset LvarIcodieps = form.Icodigo>
				<cfquery name ="rsEvaluaIeps" datasource ="#session.dsn#">
				select Icodigo
					from Impuestos
				where Ecodigo = #session.Ecodigo#
				    and ieps = 1
				    and Icodigo = '#form.Icodigo#'
		 	 </cfquery>
				<cfif 	rsEvaluaIeps.recordcount gt 0 >
					<cfset LvarIcodigo = ''>
				</cfif>
				<cfif LvarIcodigo neq ''>
					<cfquery name ="rsEvaluaIva" datasource ="#session.dsn#">
					select Icodigo
						from Impuestos
					where Ecodigo = #session.Ecodigo#
					    and (ieps != 1 or  ieps is null)
					    and Icodigo = '#form.Icodigo#'
				</cfquery>
					<cfif 	rsEvaluaIva.recordcount gt 0 >
						<cfset LvarIcodieps = ''>
					</cfif>
				</cfif>
			</cfif>
			<!-------------------------------------------------------->
			<cfquery datasource="#session.dsn#">
                update TESdetallePago
                   set

				   		  TESDPmontoVencimientoOri	= #form.TIPODBCR * form.TESDPmontoSolicitadoOri#
                        , TESDPmontoSolicitadoOri	= #form.TIPODBCR * form.TESDPmontoSolicitadoOri#
                        , TESDPmontoAprobadoOri		= #form.TIPODBCR * form.TESDPmontoSolicitadoOri#
				   		, TESDPimpNCFOri	 		= #form.TIPODBCR * form.TESDPimpNCFOri#
                   <cfif isdefined('form.TESDPdocumentoOri') and len(trim(form.TESDPdocumentoOri))>
                        , TESDPdocumentoOri=<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESDPdocumentoOri#">
                    </cfif>
                    <cfif isdefined('form.TESDPreferenciaOri')>
                        , TESDPreferenciaOri=<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESDPreferenciaOri#">
                    </cfif>
                    <cfif isdefined('form.TESDPdescripcion') and len(trim(form.TESDPdescripcion))>
                        , TESDPdescripcion=<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#">
                    </cfif>
					<cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
						, SNcodigoOri	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">
					</cfif>
				   <cfif len(trim(#form.CPDDid#)) eq 0>
                   		<cfif isdefined("LvarPorCFuncional")>
                            ,CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CFid#">
                            ,OcodigoOri=(select Ocodigo from CFuncional where CFid=#form.CFid#)
                        </cfif>

                        	, CFcuentaDB = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CFcuentaDBd#">

                        	, Icodigo 	 = <cfif len(trim(LvarIcodigo))>
                        				   		<cfqueryparam cfsqltype="cf_sql_char"    value="#form.Icodigo#">
										   <cfelse>
					   					   		<CF_jdbcquery_param cfsqltype="cf_sql_char"  value="null">
										   </cfif>

                        	, codIEPS    = <cfif len(trim(LvarIcodieps))>
					   							<cfqueryparam cfsqltype="cf_sql_char"    value="#form.Icodigo#">
										   <cfelse>
					   							<CF_jdbcquery_param cfsqltype="cf_sql_char"  value="null">
										   </cfif>

                        	, Cid 		 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Cid#"     null="#trim(form.Cid)     EQ ''#">
                         <cfif isdefined('form.chkEspecificarcuenta')>
                            , TESDPespecificacuenta= 1
                        <cfelse>
                            , TESDPespecificacuenta= 0
                        </cfif>
                   </cfif>
	                   ,TESRPTCid	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
                       ,FPAEid        = <cf_jdbcquery_param value="#form.ActividadId#" cfsqltype="cf_sql_numeric" null="#form.ActividadId eq -1#" voidnull>
					   ,CFComplemento = <cf_jdbcquery_param value="#form.Actividad#"   cfsqltype="cf_sql_varchar" null="#trim(form.Actividad) EQ ''#" voidnull>
					   ,PagoTercero = (select PagoTercero from TESsolicitudPago where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">)
                where TESDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDPid#">
            </cfquery>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
				set TESSPtotalPagarOri =
						coalesce(
						( select sum(TESDPmontoSolicitadoOri)
							from TESdetallePago
						   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
						)
						, 0)
					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
		<!--- Se actualiza el CFDI --->
		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
			<cfinvokeargument name="idDocumento" 	value="#form.TESSPid#">
			<cfinvokeargument name="idLinea" 		value="#form.TESDPid#">
			<!--- <cfinvokeargument name="SNcodigo" 		value="#Form.SNcodigo#"> --->
			<cfinvokeargument name="origen"			value="TES">
		</cfinvoke>
	</cftransaction>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#&TESDPid=#URLEncodedFormat(form.TESDPid)#">
<cfelseif IsDefined("form.BajaDet")>
	<cfquery name="rsEsDistribucion" datasource="#session.dsn#">
    Select CPDCid from TESdetallePago
       where TESDPid     = <cfqueryparam value="#form.TESDPid#"  cfsqltype="cf_sql_numeric" >
    </cfquery>
	<cfif len(trim(rsEsDistribucion.CPDCid)) gt 0>
		<cfset EsDistribucion = true>
	<cfelse>
		<cfset EsDistribucion = false>
	</cfif>
	<cfquery datasource="#session.dsn#">
		delete from TESdetallePago
	<cfif EsDistribucion>
            where CPDClinea	= (  Select CPDClinea from TESdetallePago
                                  where TESDPid     = <cfqueryparam value="#form.TESDPid#"  cfsqltype="cf_sql_numeric" >
                              )
            <cfelse>
            where TESDPid 		= <cfqueryparam value="#form.TESDPid#"				cfsqltype="cf_sql_numeric" >
            </cfif>
        </cfquery>
	<!---SML 16/01/2015. Inicio Eliminar del repositorio todos los CFDI relacionado a una Solicitud Pago Manual antes de aprobarla--->
	<cfquery name="EliminaDet" datasource="#session.dsn#">
		delete from CERepoTMP
		where ID_Linea = <cfqueryparam value="#form.TESDPid#" cfsqltype="cf_sql_numeric" >
	</cfquery>
	<!---SML 16/01/2015. Fin Eliminar del repositorio todos los CFDI relacionado a una Solicitud Pago Manual antes de aprobarla--->
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
			set TESSPtotalPagarOri =
					coalesce(
					( select sum(TESDPmontoSolicitadoOri)
					    from TESdetallePago
					   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
					)
					, 0)
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
	</cfquery>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.AltaDet")>
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
	</cfquery>
	<cfif isdefined('form.Icodigo') and len(form.Icodigo)>
		<cfquery name="rsObtieneCuentaImpuesto" datasource="#session.dsn#">
			select min(cf.CFcuenta) as CFcuenta
			from Impuestos im
				inner join CFinanciera cf
					on cf.Ccuenta = coalesce(im.CcuentaCxPAcred,im.Ccuenta)
			where im.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and im.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
		</cfquery>
		<cfset form.CFcuentaDBd = rsObtieneCuentaImpuesto.CFcuenta>
	</cfif>
	<!---Inserto las lineas del detalle--->
	<cfset IDLvarTESDPid = fnAltaDetalle()>
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
			set TESSPtotalPagarOri =
					coalesce(
					( select sum(TESDPmontoSolicitadoOri)
					    from TESdetallePago
					   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
					)
					, 0)
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
	</cfquery>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#&TESDPid=#URLEncodedFormat(IDLvarTESDPid)#">
	<!--- <cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#"> --->
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cfif isdefined("url.SP") AND url.SP EQ "GENCF">
	<cfparam name="url.actividad" default="">
	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
	<cfset LvarCFformato = mascara.fnComplementoItem(session.Ecodigo, url.CFid, url.SNid, "S", "", url.Cid, "", "",url.actividad)>
	<!--- Obtener Cuenta --->
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
		method="fnGeneraCuentaFinanciera"
		returnvariable="LvarError">
		<cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
		<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
	</cfinvoke>
	<cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
		<!--- trae el id de la cuenta financiera --->
		<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
            select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
            from CFinanciera a
                inner join CPVigencia b
                     on a.CPVid     = b.CPVid
                    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.CPVdesde and b.CPVhasta
            where a.Ecodigo   = #session.Ecodigo#
              and a.CFformato = '#LvarCFformato#'
        </cfquery>
	</cfif>
	<cfoutput>
		<script language="javascript" type="text/javascript">
        <cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
            window.parent.fnSetCuenta ("","","#LvarCFformato#","#JSStringFormat(LvarError)#");
        <cfelseif rsTraeCuenta.CFcuenta EQ "">
            window.parent.fnSetCuenta ("","","#LvarCFformato#","No existe Cuenta de Presupuesto");
        <cfelse>
            window.parent.fnSetCuenta ("#rsTraeCuenta.CFcuenta#","#rsTraeCuenta.Ccuenta#","#trim(rsTraeCuenta.CFformato)#","#trim(rsTraeCuenta.CFdescripcion)#");
        </cfif>
    </script>
	</cfoutput>
	<cfabort>
</cfif>
<cfif IsDefined("form.Nuevo")>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?Nuevo=1">
<cfelse>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm">
</cfif>

<cffunction name="sbVerificaCuentas" access="private" output="true" returntype="void">
	<cfset var rsSQL = "">
	<cfquery name="rsSQL" datasource="#session.dsn#">
	 	select dp.CFcuentaDB, c.CFformato,
		<cfif isdefined("LvarPorCFuncional")>
			dp.OcodigoOri as Ocodigo, dp.CFid
	<cfelse>
			cf.Ocodigo, sp.CFid
		</cfif>
		  from TESdetallePago dp
		  	inner join CFinanciera c
				on c.CFcuenta = dp.CFcuentaDB
		<cfif NOT isdefined("LvarPorCFuncional")>
		  	inner join TESsolicitudPago sp
				inner join CFuncional cf
					on cf.CFid = sp.CFid
				on sp.TESSPid = dp.TESSPid
		</cfif>
		 where dp.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		   and Icodigo is null
		   and codIEPS is null
	 </cfquery>
	<cfsavecontent variable="LvarEncabezado">
	 <cf_templatecss>
	 <table border="0" align="center">
	 	<tr>
			<td colspan="3" align="center">
				<input type="button" value="Regresar" onclick=
					"
						location.href='solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#';
					"
				 />
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	 	<tr>
			<td colspan="3" align="center" style="border:solid 1px ##CCCCCC">
				<strong>VERIFICACION DE CUENTAS DE LA SOLICITUD DE PAGO</strong>
			</td>
		</tr>
	 	<tr>
			<td>
				<strong>CUENTA</strong>&nbsp;&nbsp;
			</td>
			<td>
				<strong>TIPO CONTROL</strong>&nbsp;&nbsp;
			</td>
			<td>
				<strong>ERROR</strong>
			</td>
		</tr>
	</cfsavecontent>

	<cfloop query="rsSQL">
		<cfinvoke component		 = "sif.Componentes.PC_VerificaCuentasFinancieras"
		method			 = "VerificaCFcuenta"
		returnvariable	 = "LvarMSG"
		Ecodigo			= "#session.Ecodigo#"
		CFcuenta			= "#rsSQL.CFcuentaDB#"
		Ocodigo			= "#rsSQL.Ocodigo#"
		TypeError		= "table"
		Efecha			= "#now()#"
		datasource		= "#session.dsn#"
		MaxErrors 		= "20">

		<cfif LvarMSG NEQ "OK">
		#LvarEncabezado#
		<cfset LvarXError = true>
		<cfset LvarEncabezado = "">
		#LvarMSG#
		</cfif>
		</cfloop>
		<cfif isdefined("LvarXError")>
		</table>
		<cfabort>
		</cfif>
</cffunction>


<cffunction name="fnAltaDetalle">
	<cfset LvarTESMonto=   #form.TIPODBCR# * #form.TESDPmontoSolicitadoOri#>
	<cfif not isdefined('form.Cid')>
		<cfset form.Cid = "">
	</cfif>
	<cfquery name="rsSP" datasource="#session.dsn#">
		select coalesce(sn.SNid, -1) as SNid
		  from TESsolicitudPago sp
			left join SNegocios sn
				 on sn.SNcodigo	= sp.SNcodigoOri
				and sn.Ecodigo 	= sp.EcodigoOri
		 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
	</cfquery>
	<cfif isdefined("LvarPorCFuncional")>
		<!--- Manual por Centro Funcional: TESid de la SP. CFid y OcodigoOri digitados --->
		<cfif form.CPDCid EQ "">
			<cfset LvarCFid = form.CFid>
		<cfelse>
			<cfset LvarCFid = "">
		</cfif>
	<cfelse>
		<!--- Manual sin Centro Funcional: TESid, CFid y OcodigoOri de la SP --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select sp.CFid, cf.Ocodigo
			  from TESsolicitudPago sp
				inner join CFuncional cf
				   on cf.CFid = sp.CFid
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
		<cfset LvarCFid = rsSQL.CFid>
	</cfif>
	<cftransaction>
		<cfinvoke 	component="sif.Componentes.PRES_Distribucion"
			method="GenerarDistribucion"
			returnVariable="qryDistribucion"
			CFid="#LvarCFid#"
			Cid="#form.Cid#"
			CPDCid="#form.CPDCid#"
			Cantidad="1"
			Monto="#LvarTESMonto#"
			>
		<cfset LvarTESDPid_1 = "">
		<cfloop query="qryDistribucion">
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select cf.Ocodigo
				  from CFuncional cf
				 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryDistribucion.CFid#">
			</cfquery>
			<cfif form.CPDCid EQ "">
				<cfset LvarCFcuentaDB= form.CFcuentaDBd>
			<cfelse>
				<cfset LvarCFcuentaDB= qryDistribucion.IdCuenta>
			</cfif>
			<!--- Definicion de iva y ieps --->
			<cfset LvarIcodigo  = ''>
			<cfset LvarIcodieps = ''>
			<cfif isdefined('form.Icodigo') and len(trim(form.Icodigo))>
				<cfset LvarIcodigo  = form.Icodigo>
				<cfset LvarIcodieps = form.Icodigo>
				<cfquery name ="rsEvaluaIeps" datasource ="#session.dsn#">
				select Icodigo
					from Impuestos
				where Ecodigo = #session.Ecodigo#
				    and ieps = 1
				    and Icodigo = '#form.Icodigo#'
		 	 </cfquery>
				<cfif 	rsEvaluaIeps.recordcount gt 0 >
					<cfset LvarIcodigo = ''>
				</cfif>
				<cfif LvarIcodigo neq ''>
					<cfquery name ="rsEvaluaIva" datasource ="#session.dsn#">
				select Icodigo
					from Impuestos
				where Ecodigo = #session.Ecodigo#
				    and (ieps != 1 or  ieps is null)
				    and Icodigo = '#form.Icodigo#'
			</cfquery>
					<cfif 	rsEvaluaIva.recordcount gt 0 >
						<cfset LvarIcodieps = ''>
					</cfif>
				</cfif>
			</cfif>
			<!-------------------------------------------------------->
			<cfquery name="insertd"  datasource="#session.dsn#">
			insert INTO TESdetallePago
				(
					TESid, CFid, OcodigoOri,
					TESDPestado, EcodigoOri, TESSPid, TESDPtipoDocumento, TESDPidDocumento,
					TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
					SNcodigoOri, TESDPfechaVencimiento,
					TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori,
					TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, TESDPimpNCFOri,
					TESDPdescripcion, CFcuentaDB,TESRPTCid, Icodigo,codIEPS,Cid,CPDCid,TESDPespecificacuenta,PagoTercero
				)
			values (
					#session.Tesoreria.TESid#,
					<cfif len(trim(qryDistribucion.CFid))>
						<cfqueryparam value="#qryDistribucion.CFid#" cfsqltype="cf_sql_numeric">
					<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					</cfif>,
						#rsSQL.Ocodigo#,
						0,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">,
						#LvarTipoDocumento#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">,
						'TESP',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdocumentoOri#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPreferenciaOri#">,
						<cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam value="#form.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#form.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#form.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#sigMoneda.Miso4217#">,
						round(#qryDistribucion.monto#,2),
						round(#qryDistribucion.monto#,2),
						round(#qryDistribucion.monto#,2),
						round(#form.TESDPimpNCFOri * qryDistribucion.monto/form.TESDPmontoSolicitadoOri#,2),
						<cfif isdefined('form.TESDPdescripcion') and len(trim(form.TESDPdescripcion))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDB#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
						<cfif len(trim(LvarIcodigo))>
						   <cfqueryparam cfsqltype="cf_sql_char"    value="#form.Icodigo#">,
						<cfelse>
						   <CF_jdbcquery_param cfsqltype="cf_sql_char"  value="null"> ,
						</cfif>
						<cfif len(trim(LvarIcodieps))>
						   <cfqueryparam cfsqltype="cf_sql_char"    value="#form.Icodigo#">,
						<cfelse>
						   <CF_jdbcquery_param cfsqltype="cf_sql_char"  value="null"> ,
						</cfif>
						<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric" null="#form.Cid EQ ""#">
					<cfif form.CPDCid EQ "">
						,<CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">
				<cfelse>
						,#form.CPDCid#
					</cfif>
					<cfif isdefined('form.chkEspecificarcuenta')>
						,  1
				<cfelse>
						, 0
					</cfif>
					 ,(select PagoTercero from TESsolicitudPago where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">)
					)
				<cf_dbidentity1 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid">
			<!--- Se asocia el CFDI --->
			<cfif isdefined("form.ce_nombre_xTMP") and form.ce_nombre_xTMP NEQ "">
				<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
					<cfinvokeargument name="Documento" 		value="#form.TESDPdocumentoOri#">
					<cfinvokeargument name="idDocumento" 	value="#form.TESSPid#">
					<cfinvokeargument name="idLinea" 		value="#LvarTESDPid#">
					<cfinvokeargument name="cod" 			value="#form.ce_nombre_xTMP#">
					<!--- <cfinvokeargument name="SNcodigo" 		value="#Form.SNcodigo#"> --->
					<cfinvokeargument name="origen"			value="#form.ce_origen#">
				</cfinvoke>
			</cfif>
			<cfquery name="getContE" datasource="#Session.DSN#">
				select ERepositorio from Empresa
				where Ereferencia = #Session.Ecodigo#
			</cfquery>

			<cfif form.CPDCid NEQ "">
				<cfif LvarTESDPid_1 EQ "">
					<cfset LvarTESDPid_1 = LvarTESDPid>
				</cfif>
				<cfquery datasource="#session.DSN#">
					update TESdetallePago
					   set CPDClinea	= #LvarTESDPid_1#
					 where TESDPid	= #LvarTESDPid#
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
	<cfreturn LvarTESDPid />
</cffunction>
