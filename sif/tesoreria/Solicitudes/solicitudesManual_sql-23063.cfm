<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-6-2005
		Motivo: Se eliminó el campo TESSPobservaciones de la pantalla por lo que también se elimina del SQL.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 8-7-2005.
		Motivo: Se modifica para que a la hora de agregar un Beneficiario nuevo en el colis se abra en un pop up la ventana de mantenimiento
		de beneficiarios y que al agregar se cierra la ventana y se regresan los datos del beneficiario al conlis inicial.
 --->

<cfif isdefined("LvarPorCFuncional")>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CF">
<cfelse>
	<cfset LvarTipoDocumento = 0>
	<cfset LvarSufijoForm = "">
</cfif>

<cfif IsDefined("form.Aprobar") or IsDefined("form.GenerarOP")>
	<cfset sbVerificaCuentas()>
	<cfinclude template="solicitudesAprobar_sql.cfm">
</cfif>

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfif IsDefined("form.Cambio")>
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
						, TESSPtipoCambioOriManual = 0
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
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set  TESid = #session.Tesoreria.TESid#
				<cfif NOT isdefined("LvarPorCFuncional")>
					, CFid = #session.Tesoreria.CFid#
					, OcodigoOri=(select Ocodigo from CFuncional where Ecodigo=#session.Ecodigo# AND CFid=#session.Tesoreria.CFid#)
				</cfif>
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
	</cftransaction>
	
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
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
                    )
                values (
                    #session.Tesoreria.TESid#, #session.Tesoreria.CFid#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">,
                    #LvarTipoDocumento#, 
                    0, 
                    <cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#"> , null, 
                    <cfelse>
                        null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">,
                    </cfif>
                    <cfqueryparam value="#LSparseDateTime(form.TESSPfechaPagar)#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
                    <cfif isdefined('form.TESSPtipoCambioOriManual') and len(trim(form.TESSPtipoCambioOriManual))>
                        #form.TESSPtipoCambioOriManual#,
                    <cfelse>
                        0,
                    </cfif>
                    #form.TESSPtotalPagarOri#,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
    
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPobservaciones)#"		null="#rtrim(form.TESOPobservaciones) EQ ""#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPinstruccion)#"		null="#rtrim(form.TESOPinstruccion) EQ ""#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPbeneficiarioSuf)#"	null="#rtrim(form.TESOPbeneficiarioSuf) EQ ""#">
                )
                <cf_dbidentity1 datasource="#session.DSN#" name="insert">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESSPid">
        </cftransaction>
     </cflock>
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(LvarTESSPid)#">
<cfelseif IsDefined("form.Duplicar")>
	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
        <cfquery name="rsNewSol" datasource="#session.dsn#">
            select (max(coalesce(TESSPnumero,0)) + 1) as newSol
            from TESsolicitudPago
            where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>	
        <cftransaction>
            <cfquery datasource="#session.dsn#" name="insert">
                insert into TESsolicitudPago (
                    TESid, CFid,
                    EcodigoOri, TESSPnumero, 
                    TESSPtipoDocumento, TESSPestado, 
                    SNcodigoOri, TESBid, 
                    TESSPfechaPagar, 
                    McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri, 
                    TESSPmsgRechazo, 
                    TESSPfechaSolicitud, UsucodigoSolicitud, 
                    BMUsucodigo
    
                    , TESOPobservaciones
                    , TESOPinstruccion
                    , TESOPbeneficiarioSuf
                    )
                select 
                    TESid, CFid,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">,
                    TESSPtipoDocumento, 0, 
                    SNcodigoOri, TESBid, 
                    TESSPfechaPagar, 
                    McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri, 
                    TESSPmsgRechazo, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
    
                    , TESOPobservaciones
                    , TESOPinstruccion
                    , TESOPbeneficiarioSuf
                  from TESsolicitudPago
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
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
                     TESDPdescripcion, CFcuentaDB, TESRPTCid, Icodigo
                    )
                select
                    TESid, CFid, OcodigoOri,
                    0,
                    EcodigoOri,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                     TESDPtipoDocumento, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">,
                     TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
                     SNcodigoOri, TESDPfechaVencimiento, 
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
                     TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
                     TESDPdescripcion, CFcuentaDB, TESRPTCid, Icodigo
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
	<!--- Impresión de la SP --->
	<cf_SP_imprimir location="solicitudesManual#LvarSufijoForm#.cfm">
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.NuevoDet")>		<!--- DETALLES --->
	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.CambioDet")>
	<cfif isdefined('form.Icodigo') and len(form.Icodigo)>
		<cfquery name="rsObtieneCuentaImpuesto" datasource="#session.dsn#">
			select cf.CFcuenta
			from Impuestos im
				inner join CFinanciera cf
					on cf.Ccuenta = im.Ccuenta
			where im.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and im.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
		</cfquery>
		<cfset form.CFcuentaDBd = rsObtieneCuentaImpuesto.CFcuenta>
	</cfif>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set	
				<cfif isdefined("LvarPorCFuncional")>
					CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					OcodigoOri=(select Ocodigo from CFuncional where CFid=#form.CFid#),
				</cfif>
					  TESDPmontoVencimientoOri=#form.TIPODBCR * form.TESDPmontoSolicitadoOri#
					, TESDPmontoSolicitadoOri=#form.TIPODBCR * form.TESDPmontoSolicitadoOri#
					, TESDPmontoAprobadoOri=#form.TIPODBCR * form.TESDPmontoSolicitadoOri#
				<cfif isdefined('form.TESDPdocumentoOri') and len(trim(form.TESDPdocumentoOri))>
					, TESDPdocumentoOri=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdocumentoOri#">
				</cfif>
				<cfif isdefined('form.TESDPreferenciaOri')>
					, TESDPreferenciaOri=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPreferenciaOri#" null="#form.TESDPreferenciaOri EQ ""#">
				</cfif>
				<cfif isdefined('form.TESDPdescripcion') and len(trim(form.TESDPdescripcion))>
					, TESDPdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#" null="#form.TESDPdescripcion EQ ""#">
				</cfif>
				, TESRPTCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
				, CFcuentaDB=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaDBd#">
				, Icodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#form.Icodigo#" null="#trim(form.Icodigo) EQ ''#">

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

	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#&TESDPid=#URLEncodedFormat(form.TESDPid)#">
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

	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelseif IsDefined("form.AltaDet")>
	<cfquery name="sigMoneda" datasource="#session.dsn#">
		select Miso4217
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
	</cfquery>

	<cfif isdefined("LvarPorCFuncional")>
		<!--- Manual por Centro Funcional: TESid de la SP. CFid y OcodigoOri digitados --->
		<cfquery name="rsSP" datasource="#session.dsn#">
			select sp.TESid, cf.CFid, cf.Ocodigo
			  from TESsolicitudPago sp
				inner join CFuncional cf
				   on cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
	<cfelse>
		<!--- Manual sin Centro Funcional: TESid, CFid y OcodigoOri de la SP --->
		<cfquery name="rsSP" datasource="#session.dsn#">
			select sp.TESid, sp.CFid, cf.Ocodigo
			  from TESsolicitudPago sp
				inner join CFuncional cf
				   on cf.CFid = sp.CFid
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#" null="#Len(form.TESSPid) Is 0#">
		</cfquery>
	</cfif>

	<cfif isdefined('form.Icodigo') and len(form.Icodigo)>
		<cfquery name="rsObtieneCuentaImpuesto" datasource="#session.dsn#">
			select cf.CFcuenta
			from Impuestos im
				inner join CFinanciera cf
					on cf.Ccuenta = im.Ccuenta
			where im.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and im.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
		</cfquery>
		<cfset form.CFcuentaDBd = rsObtieneCuentaImpuesto.CFcuenta>
	</cfif>

			
	<cfquery datasource="#session.dsn#">
		insert INTO TESdetallePago 
			(
				TESid, CFid, OcodigoOri,
				TESDPestado, EcodigoOri, TESSPid, TESDPtipoDocumento, TESDPidDocumento,
				TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri, 
				SNcodigoOri, TESDPfechaVencimiento, 
				TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri, 
				TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, 
				TESDPdescripcion, CFcuentaDB,TESRPTCid, Icodigo
			)
		values (
				#rsSP.TESid#, #rsSP.CFid#, #rsSP.Ocodigo#,
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
				#form.TIPODBCR * form.TESDPmontoSolicitadoOri#,
				#form.TIPODBCR * form.TESDPmontoSolicitadoOri#,			
				#form.TIPODBCR * form.TESDPmontoSolicitadoOri#,
				<cfif isdefined('form.TESDPdescripcion') and len(trim(form.TESDPdescripcion))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESDPdescripcion#">, 
				<cfelse>
					null,
				</cfif>			
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaDBd#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
				<cfqueryparam cfsqltype="cf_sql_char"    value="#form.Icodigo#" null="#trim(form.Icodigo) EQ ''#">
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

	<cflocation url="solicitudesManual#LvarSufijoForm#.cfm?TESSPid=#URLEncodedFormat(form.TESSPid)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
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
		<cfinvoke 	component		 = "sif.Componentes.PC_VerificaCuentasFinancieras"
					method			 = "VerificaCFcuenta"
					returnvariable	 = "LvarMSG"
					
					Ecodigo			= "#session.Ecodigo#"
					CFcuenta		= "#rsSQL.CFcuentaDB#"
					Ocodigo			= "#rsSQL.Ocodigo#"
					TypeError		= "table"
					Efecha			= "#now()#"
					datasource		= "#session.dsn#"
					MaxErrors = "20">
		
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

