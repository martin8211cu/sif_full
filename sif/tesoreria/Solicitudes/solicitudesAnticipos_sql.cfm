<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif IsDefined("form.Aprobar") or IsDefined("form.GenerarOP")>
	<cfinclude template="solicitudesAprobar_sql.cfm">
</cfif>

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfif IsDefined("form.Cambio")>
	<cf_cboCFid>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="TESsolicitudPago"
				redirect="solicitudesAnt#LvarTipoAnticipo#.cfm"
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
					<cfif isdefined('form.McodigoOri') and len(trim(form.McodigoOri))>
						<cfif LvarTipoAnticipo EQ "POS">
							, CDCcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CDCcodigo#">
							, SNcodigoOri 	= null
							, TESBid 		= null
						<cfelse>
							, CDCcodigo 	= null
							, SNcodigoOri 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">
							, TESBid 		= null
						</cfif>
					, McodigoOri = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
					</cfif>
					<cfif isdefined('form.TESSPtipoCambioOriManual') and len(trim(form.TESSPtipoCambioOriManual))>
						, TESSPtipoCambioOriManual = <cfqueryparam cfsqltype="cf_sql_money" value="#form.TESSPtipoCambioOriManual#">
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
					<!--- , TESSPobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESSPobservaciones)#"> --->
					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">

					, TESOPobservaciones 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPobservaciones)#"		null="#rtrim(form.TESOPobservaciones) EQ ""#">
					, TESOPinstruccion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPinstruccion)#"		null="#rtrim(form.TESOPinstruccion) EQ ""#">
					, TESOPbeneficiarioSuf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPbeneficiarioSuf)#"	null="#rtrim(form.TESOPbeneficiarioSuf) EQ ""#">
			where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set  TESid = #session.Tesoreria.TESid#
			   		<!--- CFid y OcodigoOri mantienen la del documento referenciado --->
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
	</cftransaction>
		
	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESdetallePago
		where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>

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
<cfelseif IsDefined("form.Alta")>
	<cfif NOT isdefined("session.Tesoreria.TESid")>
		<cf_errorCode	code = "50741" msg = "No existe la Tesoreria para esta empresa actual o no se logro calcular el numero para la nueva solicitud de pago">
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
            where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>	
    
        <cftransaction>
            <cfquery datasource="#session.dsn#" name="insert">
                insert into TESsolicitudPago (
                    TESid, CFid,
                    EcodigoOri, TESSPnumero, 
                    TESSPtipoDocumento, TESSPestado, 
                    CDCcodigo, SNcodigoOri, TESBid,
                    TESSPfechaPagar, McodigoOri,
                    TESSPtipoCambioOriManual, TESSPtotalPagarOri, <!--- TESSPobservaciones, ---> TESSPfechaSolicitud,
                    UsucodigoSolicitud, BMUsucodigo
                    , TESOPobservaciones 	
                    , TESOPinstruccion 		
                    , TESOPbeneficiarioSuf 	
						  ,ProcessId

                    )
                values (
                    #session.Tesoreria.TESid#, #session.Tesoreria.CFid#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">,
                    <cfif LvarTipoAnticipo EQ "POS">4<cfelse>3</cfif>,		/* 3 o 4 Devolución de Anticipos CxC o POS */
                    0, 	/* Estado En Preparacion */
                    <cfif LvarTipoAnticipo EQ "POS">
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CDCcodigo#">,
                        null,
                        null,
                    <cfelse>
                        null,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">,
                        null,
                    </cfif>
                    <cfqueryparam value="#LSparseDateTime(form.TESSPfechaPagar)#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
                    <cfif isdefined('form.TESSPtipoCambioOriManual') and len(trim(form.TESSPtipoCambioOriManual))>
                        <cfqueryparam cfsqltype="cf_sql_money" value="#form.TESSPtipoCambioOriManual#">,
                    <cfelse>
                        1,
                    </cfif>
                    <cfif isdefined('form.TESSPtotalPagarOri') and len(form.TESSPtotalPagarOri) NEQ 0>
                        <cfqueryparam cfsqltype="cf_sql_money" value="#form.TESSPtotalPagarOri#">,
                    <cfelse>
                        0.00,
                    </cfif> 
                    <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESSPobservaciones#">, --->
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
                )
                <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
        </cftransaction>
	</cflock>
	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
<cfelseif IsDefined("form.Duplicar")>
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
        <cfquery name="rsNewSol" datasource="#session.dsn#">
            select (max(coalesce(TESSPnumero,0)) + 1) as newSol
            from TESsolicitudPago
            where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>	
        <cftransaction>
		
			<cfquery datasource="#session.dsn#" name="selectInsert">
				select 
                    TESid, 
					CFid,
                    TESSPtipoDocumento, 
                    CDCcodigo, 
					SNcodigoOri,
                    TESSPfechaPagar, 
                    McodigoOri,	
					TESSPtipoCambioOriManual, 
					TESSPtotalPagarOri, 
                    TESSPmsgRechazo 
                    , TESOPobservaciones 	
                    , TESOPinstruccion 		
                    , TESOPbeneficiarioSuf 	
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
                    CDCcodigo, 
					SNcodigoOri,
                    TESSPfechaPagar, 
                    McodigoOri,	
					TESSPtipoCambioOriManual, 
					TESSPtotalPagarOri, 
                    TESSPmsgRechazo, 
                    TESSPfechaSolicitud, 
					UsucodigoSolicitud, 
                    BMUsucodigo
                    , TESOPobservaciones 	
                    , TESOPinstruccion 		
                    , TESOPbeneficiarioSuf 	
                    )
                VALUES(
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.TESid#"                    voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.CFid#"                     voidNull>,
				   #session.Ecodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsNewSol.newSol#"              			voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInsert.TESSPtipoDocumento#"       voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.CDCcodigo#"                voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInsert.SNcodigoOri#"              voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectInsert.TESSPfechaPagar#"          voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.McodigoOri#"               voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectInsert.TESSPtipoCambioOriManual#" voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectInsert.TESSPtotalPagarOri#"       voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectInsert.TESSPmsgRechazo#"          voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
				   #session.Usucodigo#,
				   #session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_clob"              value="#selectInsert.TESOPobservaciones#"       voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectInsert.TESOPinstruccion#"         voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectInsert.TESOPbeneficiarioSuf#"     voidNull>
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
                     TESDPfechaVencimiento, 
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
                     TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
                     TESDPdescripcion, CFcuentaDB, TESRPTCid
                    )
                select
                    TESid, CFid, OcodigoOri, 
                    0,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                     TESDPtipoDocumento, TESDPidDocumento,
                     TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
                     TESDPfechaVencimiento, 
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
                     TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
                     TESDPdescripcion, CFcuentaDB, TESRPTCid
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
	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
<cfelseif IsDefined("form.AAprobar")>
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
	<!--- DAnt = Devoluciones de Anticipos --->
	<cfinvoke	component		= "sif.tesoreria.Componentes.TESaplicacion"
				method			= "sbTramiteSP" 
				TESSPid			= "#form.TESSPid#" 
				TipoSol     	= "DAnt"
	/>
 
	<!--- Impresión de la SP --->
	<cf_SP_imprimir location="solicitudesAnt#LvarTipoAnticipo#.cfm">
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.NuevoDet")>		<!--- DETALLES --->
	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.CambioDet")>
	<cfif form.TESDPmontoSolicitadoOri GT form.TESDPmontoVencimientoOri>
		<cf_errorCode	code = "50788" msg = "No se puede solicitar un monto mayor al saldo">
	</cfif>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set TESDPmontoSolicitadoOri=<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">,
				   TESDPdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#">
			where TESDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDPid#">
		</cfquery>
		
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
	</cftransaction>

	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#&TESDPid=#URLEncodedFormat(form.TESDPid)#">
<cfelseif IsDefined("form.BajaDet")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from TESdetallePago
			where TESDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDPid#">
		</cfquery>
		
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
	</cftransaction>

	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.btnSeleccionar")>
	<!--- AltaDet --->
	<cfif isdefined("form.chk")>
		<cfset form.TESSPid = listFirst(form.chk,"|")>
		<cfset form.chk		= replace(form.chk, "#form.TESSPid#|", "", "ALL")>

		<cfif LvarTipoAnticipo EQ "POS">
			<cfquery name="rsDoc" datasource="#session.dsn#">
				select 	pos.FAX14DOC, 
						pos.FAM01COD, 
						pos.CFcuenta,
						c.FAM01CODD, c.Ocodigo
				  from FAX014 pos
					left join FAM001 c
						 on c.FAM01COD = pos.FAM01COD
						 and c.Ecodigo = pos.Ecodigo
				 where pos.Ecodigo = #session.Ecodigo#
				   and pos.FAX14ID in (#form.chk#)
				   and (pos.FAM01COD is null or c.Ocodigo is null or pos.CFcuenta is null)
			</cfquery>

			<cfloop query="rsDoc">
				<cfif rsDOC.FAM01COD EQ "">
					<cf_errorCode	code = "50789"
									msg  = "El adelanto '@errorDat_1@' no tiene definida una Caja Origen para obtener la Oficina para el movimiento"
									errorDat_1="#rsDoc.FAX14DOC#"
					>
				<cfelseif rsDOC.Ocodigo EQ "">
					<cfif rsDOC.FAM01CODD EQ "">
						<cf_errorCode	code = "50790"
										msg  = "La Caja Origen 'ID=@errorDat_1@' del Adelanto '@errorDat_2@' no tiene definida una Oficina para el movimiento"
										errorDat_1="#rsDOC.FAM01COD#"
										errorDat_2="#rsDoc.FAX14DOC#"
						>
					<cfelse>
						<cf_errorCode	code = "50791"
										msg  = "La Caja Origen '@errorDat_1@' del Adelanto '@errorDat_2@' no tiene definida una Oficina para el movimiento"
										errorDat_1="#rsDOC.FAM01CODD#"
										errorDat_2="#rsDoc.FAX14DOC#"
						>
					</cfif>
				<cfelseif rsDoc.CFcuenta EQ "">
					<cf_errorCode	code = "50792"
									msg  = "El adelanto '@errorDat_1@' no tiene definida la Cuenta Financiera"
									errorDat_1="#rsDoc.FAX14DOC#"
					>
				</cfif>
			</cfloop>
		<cfelse>
			<cfquery name="rsDoc" datasource="#session.dsn#">
				select cxp.DdocumentoId, cxp.Ccuenta
				  from Documentos cxp
				 where cxp.Ecodigo	= #session.Ecodigo#
				   and cxp.DdocumentoId in (#form.Chk#)
				   and Ccuenta is null
			</cfquery>
			<cfloop query="rsDoc">
				<cfif rsDoc.Ccuenta EQ "">
					<cf_errorCode	code = "50793"
									msg  = "El adelanto '@errorDat_1@' no tiene definida la Cuenta Contable"
									errorDat_1="#rsDoc.DdocumentoId#"
					>
				</cfif>
			</cfloop>
		</cfif>
	
	
		<cftransaction>
			<!--- TESid de la SP --->
			<cfquery name="rsSP" datasource="#session.dsn#">
				select sp.TESid
				  from TESsolicitudPago sp
				 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
			</cfquery>

			<cfquery datasource="#session.dsn#" name="TESDP">
				insert INTO TESdetallePago 
					(
					 TESDPestado, EcodigoOri, TESSPid, 
					 TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, 
	
					 TESid, CFid, OcodigoOri,

					 TESDPtipoDocumento, TESDPidDocumento,
					 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri, 
					 TESDPfechaVencimiento, 
					 TESDPmontoVencimientoOri, 
					 TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
					 TESDPdescripcion, CFcuentaDB, TESRPTCid
					)
				select 
					0,	/* En SP preparacion */
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">,
					sp.TESSPfechaPagar,
					sp.TESSPfechaPagar,
					mo.Miso4217,
				<cfif LvarTipoAnticipo EQ "POS">
					#rsSP.TESid#, c.CFid, c.Ocodigo,
					
					4,
					pos.FAX14ID,
					'PV',	
					pos.FAX14DOC,
					pos.FAX14TDC,
					pos.FAX14FEC,
					pos.FAX14MON-pos.FAX14MAP-pos.TESDPaprobadoPendiente,
					pos.FAX14MON-pos.FAX14MAP-pos.TESDPaprobadoPendiente,
					pos.FAX14MON-pos.FAX14MAP-pos.TESDPaprobadoPendiente,
					'Devolución de ' #LvarCNCT# ta.Descripcion #LvarCNCT# ' ' #LvarCNCT# pos.FAX14DOC, 
					pos.CFcuenta, 
					(select min(TESRPTCid) from TESRPTconcepto where CEcodigo = #session.CEcodigo# and TESRPTCdevoluciones = 1)
				  from FAX014 pos
					inner join TESsolicitudPago sp
						inner join Monedas mo
							 on mo.Ecodigo = sp.EcodigoOri
							and mo.Mcodigo = sp.McodigoOri
						 on sp.EcodigoOri 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and sp.TESSPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
					left join FAM001 c
						 on c.FAM01COD = pos.FAM01COD
						and c.Ecodigo 	= pos.Ecodigo
					left outer join FATiposAdelanto ta
						 on ta.IdTipoAd	= pos.IdTipoAd
						and ta.Ecodigo	= pos.Ecodigo
				 where pos.Ecodigo	= #session.Ecodigo#
				   and pos.FAX14ID in (#form.Chk#)
				   and not exists(
						select 1 from TESdetallePago dp
						 where dp.EcodigoOri = pos.Ecodigo
						   and dp.TESDPestado in (0,1)
						   and dp.TESDPidDocumento = pos.FAX14ID
					)
				<cfelse>
					#rsSP.TESid#, cxp.CFid, cxp.Ocodigo,

					3,
					cxp.DdocumentoId,
					'CCFC',	
					cxp.Ddocumento,
					cxp.CCTcodigo,
					cxp.Dfecha,
					cxp.Dsaldo-cxp.TESDPaprobadoPendiente,
					cxp.Dsaldo-cxp.TESDPaprobadoPendiente,
					cxp.Dsaldo-cxp.TESDPaprobadoPendiente,
					'Devolución de ' #LvarCNCT# ta.CCTdescripcion #LvarCNCT# ' ' #LvarCNCT# cxp.Ddocumento,
					( select min(CFcuenta) from CFinanciera cf where cf.Ccuenta = cxp.Ccuenta ),
					(select min(TESRPTCid) from TESRPTconcepto where CEcodigo = #session.CEcodigo# and TESRPTCdevoluciones = 1)
				  from Documentos cxp
					inner join TESsolicitudPago sp
						inner join Monedas mo
							 on mo.Ecodigo = sp.EcodigoOri
							and mo.Mcodigo = sp.McodigoOri
						 on sp.EcodigoOri 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and sp.TESSPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
					inner join CCTransacciones ta
						 on ta.Ecodigo		= cxp.Ecodigo
						and ta.CCTcodigo	= cxp.CCTcodigo
				 where cxp.Ecodigo	= #session.Ecodigo#
				   and cxp.DdocumentoId in (#form.Chk#)
				   and not exists(
						select 1 from TESdetallePago dp
						 where dp.EcodigoOri = cxp.Ecodigo
						   and dp.TESDPestado in (0,1)
						   and dp.TESDPidDocumento = cxp.DdocumentoId
					)
				</cfif>
			</cfquery>
			
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
		</cftransaction>
	</cfif>

	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfif IsDefined("form.Nuevo")>
	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm?Nuevo=1">
<cfelse>
	<cflocation url="solicitudesAnt#LvarTipoAnticipo#.cfm">
</cfif>



