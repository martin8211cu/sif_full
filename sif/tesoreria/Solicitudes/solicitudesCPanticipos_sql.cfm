<cfif IsDefined("form.Aprobar") or IsDefined("form.GenerarOP")>
	<cfinclude template="solicitudesAprobar_sql.cfm">
</cfif>

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfif IsDefined("form.Cambio")>
	<cf_cboCFid>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="TESsolicitudPago"
				redirect="solicitudesCPanticipos.cfm"
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
					, SNcodigoOri	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">
					<cfif isdefined('form.McodigoOri') and len(trim(form.McodigoOri))>
						, McodigoOri = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
					</cfif>
					, TESSPtipoCambioOriManual = <cfqueryparam cfsqltype="cf_sql_money" value="#form.TESSPtipoCambioOriManual#">
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
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set  TESid = #session.Tesoreria.TESid#
					, CFid = #session.Tesoreria.CFid#
					, OcodigoOri=(select Ocodigo from CFuncional where Ecodigo=#session.Ecodigo# AND CFid=#session.Tesoreria.CFid#)
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
	</cftransaction>

	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
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
                    EcodigoOri, TESSPnumero, TESSPtipoDocumento, TESSPestado, 
                    SNcodigoOri, 
                    TESSPfechaPagar, McodigoOri,
                    TESSPtipoCambioOriManual, TESSPtotalPagarOri, TESSPfechaSolicitud,
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
                    2,   <!--- Anticipos CxP --->
                    0, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#"> , 
                    <cfqueryparam value="#LSparseDateTime(form.TESSPfechaPagar)#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#form.TESSPtipoCambioOriManual#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#form.TESSPtotalPagarOri#">,
                    <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESSPobservaciones#">, --->
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPobservaciones)#"		null="#rtrim(form.TESOPobservaciones) EQ ""#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPinstruccion)#"		null="#rtrim(form.TESOPinstruccion) EQ ""#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPbeneficiarioSuf)#"	null="#rtrim(form.TESOPbeneficiarioSuf) EQ ""#">
						  <cfif #rsObtieneTramite.recordcount# gt 0>
						  ,#rsObtieneTramite.ProcessId#
						  <cfelse>
						  ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						  </cfif>
                )
                <cf_dbidentity1 datasource="#session.DSN#" name="insert">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
        </cftransaction>
	</cflock>
	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
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
                    SNcodigoOri, 
					TESBid, 
                    TESSPfechaPagar, 
                    McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri, 
                    <!--- TESSPobservaciones, ---> TESSPmsgRechazo
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
                    SNcodigoOri, 
					TESBid, 
                    TESSPfechaPagar, 
                    McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri, 
                    <!--- TESSPobservaciones, ---> TESSPmsgRechazo, 
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
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsNewSol.newSol#"             			 voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInsert.TESSPtipoDocumento#"       voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInsert.SNcodigoOri#"              voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.TESBid#"                   voidNull>,
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
                     SNcodigoOri, TESDPfechaVencimiento, 
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
                     TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
                     TESDPdescripcion, CFcuentaDB, TESRPTCid
                     ,id_direccion
					 ,TESRPTCietu 	
                    )
                select
                     TESid, CFid, OcodigoOri,
                     0,
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                     TESDPtipoDocumento, TESDPidDocumento,
                     TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
                     SNcodigoOri, TESDPfechaVencimiento, 
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
                     TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
                     TESDPdescripcion, CFcuentaDB, TESRPTCid
                     ,id_direccion
					 ,TESRPTCietu
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
	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
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
	<!--- APCP = Anticipos a Proveedores CxP --->
	<cfinvoke	component		= "sif.tesoreria.Componentes.TESaplicacion"
				method			= "sbTramiteSP" 
				TESSPid			= "#form.TESSPid#" 
				TipoSol     	= "APCP"
	/>
 	
	<!--- Impresión de la SP --->
	<cf_SP_imprimir location="solicitudesCPanticipos.cfm">
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.NuevoDet")>		<!--- DETALLES --->
	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.CambioDet")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
				update TESdetallePago 
				   set
						TESDPdocumentoOri		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdocumentoOri#">,
						TESDPreferenciaOri		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPreferenciaOri#">,
						TESDPmontoVencimientoOri=<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">,
						TESDPmontoSolicitadoOri=<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">,
						TESDPmontoAprobadoOri=<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">
					<cfif isdefined('form.TESDPdescripcion') and len(trim(form.TESDPdescripcion))>
						, TESDPdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#">
					<cfelse>
						, TESDPdescripcion=null
					</cfif>
					, TESRPTCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
					, CFcuentaDB=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaDB#">
					, id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#" null="#trim(form.id_direccion) EQ ''#">
					, TESRPTCietu  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCietu#">
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
			

	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#&TESDPid=#URLEncodedFormat(form.TESDPid)#">
<cfelseif IsDefined("form.BajaDet")>
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

	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.AltaDet")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		from HEDocumentosCP
		where SNcodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">
		  and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdocumentoOri#">
		  and CPTcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPreferenciaOri#">
		  and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cf_errorCode	code = "50797"
						msg  = "Documento de Anticipo @errorDat_1@-@errorDat_2@ ya existe en Cuentas por Pagar"
						errorDat_1="#form.TESDPreferenciaOri#"
						errorDat_2="#form.TESDPdocumentoOri#"
		>
	</cfif>
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
	</cfquery>

	<!--- TESid, CFid y OcodigoOri de la SP --->
	<cfquery name="rsSP" datasource="#session.dsn#">
		select sp.TESid, sp.CFid, cf.Ocodigo
		  from TESsolicitudPago sp
			inner join CFuncional cf
			   on cf.CFid = sp.CFid
		 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
	</cfquery>
			
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			insert INTO TESdetallePago 
				(
					TESid, CFid, OcodigoOri,
					TESDPestado, EcodigoOri, TESSPid, 
					TESDPtipoDocumento, TESDPidDocumento,
					TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri, 
					SNcodigoOri, TESDPfechaVencimiento, 
					TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
					TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
					TESDPdescripcion, CFcuentaDB, TESRPTCid,
					id_direccion
					,TESRPTCietu
				)
			values (
					#rsSP.TESid#, #rsSP.CFid#, #rsSP.Ocodigo#,
					0,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">,
					2,  <!--- Anticipos CxP --->
					0,	<!--- El IDdocumento se actualiza cuando se genera el Anticipo en EDocumentosCP --->
					
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
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">,			
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESDPmontoSolicitadoOri#">,			
					<cfif isdefined('form.TESDPdescripcion') and len(trim(form.TESDPdescripcion))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#">, 
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaDB#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#" null="#trim(form.id_direccion) EQ ''#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCietu#">
				)
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

	<cflocation url="solicitudesCPanticipos.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfif IsDefined("form.Nuevo")>
	<cflocation url="solicitudesCPanticipos.cfm?Nuevo=1">
<cfelse>
	<cflocation url="solicitudesCPanticipos.cfm">
</cfif>



