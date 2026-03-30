<cf_dbfunction name="op_concat" returnvariable="_CAT">
<!---
	Modificador por: Ana Villavicencio
	Fecha: 04 de agosto del 2005
	Motivo: Se agrego la moneda dentro de la ruta para volver  a la lista de facturas para la solicitud de pago.
	Linea: 399
 --->

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>
<cf_dbfunction name="op_concat" returnvariable="_CAT">
<cfif isdefined("FechaPago_SP")>
	<cf_navegacion name="FechaPago_SP" session="SP" default="" navegacion="">
</cfif>

<cfif IsDefined("form.Aprobar") or IsDefined("form.GenerarOP")>
	<cfinclude template="solicitudesAprobar_sql.cfm">
</cfif>
<cfif not isdefined('form.Cambio') and isdefined('url.Cambio')>
	<cfset form.Cambio = url.Cambio>
</cfif>
<cfif IsDefined("url.Creditos")>
	<cfinclude template="solicitudesCP_CRs.cfm">
	<cfabort>
<cfelseif IsDefined("form.btnAgregarCR")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into TESdetallePago
			(
			 TESid, CFid, OcodigoOri,
			 TESDPestado, TESSPid, TESOPid,
			 TESDPtipoDocumento, TESDPidDocumento,
			 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
			 SNcodigoOri,
			 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada,
			 EcodigoOri, EcodigoPago, Miso4217Ori,
			 TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri, Rmonto,
			 Rcodigo,
			 TESDPdescripcion,
			 CFcuentaDB, TESRPTCid, BMUsucodigo,
			 TESDPtipoCambioOri
			)
		Select
			 TESid, CFid, OcodigoOri,
			 TESDPestado, TESSPid, TESOPid,
			 TESDPtipoDocumento, TESDPid,
			 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
			 SNcodigoOri,
			 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada,
			 EcodigoOri, EcodigoPago, Miso4217Ori
				, -<cfqueryparam cfsqltype="cf_sql_money" 		 value="#replace(form.monto,',','','ALL')#">
				, -<cfqueryparam cfsqltype="cf_sql_money" 	 	 value="#replace(form.monto,',','','ALL')#">
				, -<cfqueryparam cfsqltype="cf_sql_money" 		 value="#replace(form.monto,',','','ALL')#">
				, 0
				,<cfqueryparam  cfsqltype="cf_sql_varchar"  	 value="#form.Rcodigo#">
				, <cfqueryparam  cfsqltype="cf_sql_varchar"  	 value="- Credito: #form.descripcion#">
				, <cfqueryparam  cfsqltype="cf_sql_numeric"  	 value="#form.CFcuenta#">
				, null, #session.Usucodigo#,
				TESDPtipoCambioOri
		    from TESdetallePago
		   WHERE TESDPid = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#form.TESDPid#">
	</cfquery>
	<script language="javascript">
		window.opener.document.form1.Cambio.click();
		window.opener.document.form1.submit();
		window.close();
	</script>
	<cfabort>
<cfelseif IsDefined("form.Cambio")>
	<cf_cboCFid>
	<cfset form.PASO = 10>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="TESsolicitudPago"
			redirect="solicitudesCP.cfm"
			timestamp="#form.ts_rversion#"
			field1="TESSPid"
			type1="numeric"
			value1="#form.TESSPid#"
	>
	<cftransaction>
		<cfif isdefined("TESDPid")>
			<!--- CambioDet con SP Encabezado --->
			<cfloop index="LvarID" list="#form.TESDPid#">
				<cfif isdefined('form.TESDPmontoSolicitadoOri_#LvarID#')>
					<cfquery datasource="#session.dsn#">
						update TESdetallePago
							set TESDPfechaSolicitada 	= <cfqueryparam cfsqltype="cf_sql_date"  value="#LSparseDateTime(form.TESSPfechaPagar)#">
							  , TESDPmontoSolicitadoOri	= <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#replace(evaluate('form.TESDPmontoSolicitadoOri_#LvarID#'),',','','ALL')#">
						 where EcodigoOri = #session.Ecodigo#
						   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
						   and TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
						   and TESDPestado = 0
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cfset sbCalculaAfectacionesPago(form.TESSPid,false)>
		<cfquery name="TESDP" datasource="#session.dsn#">
			select
			 coalesce(round(sum(TESDPmontoSolicitadoOri - coalesce(Rmonto,0)),2),0) as total
			  from TESdetallePago
			 where EcodigoOri = #session.Ecodigo#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESDPestado = 0
			   and RlineaId is NULL
		</cfquery>
		<cfset CBidPago = "">
		<cfif isDefined("form.CBidPago") AND #form.CBidPago# NEQ "">
			<cfset arrCBidPago = listToArray (#form.CBidPago#, ",",false,true)>
			<cfset CBidPago = arrCBidPago[1]>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
				set
					TESid = #session.Tesoreria.TESid#, CFid = #session.Tesoreria.CFid#
					, TESSPfechaPagar  = <cfqueryparam value="#LSparseDateTime(form.TESSPfechaPagar)#" cfsqltype="cf_sql_timestamp">
					, TESSPtotalPagarOri = <cfqueryparam cfsqltype="cf_sql_money" value="#TESDP.total#">
					, TESOPobservaciones 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPobservaciones)#"		null="#rtrim(form.TESOPobservaciones) EQ ""#">
					, TESOPinstruccion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPinstruccion)#"		null="#rtrim(form.TESOPinstruccion) EQ ""#">
					, TESOPbeneficiarioSuf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.TESOPbeneficiarioSuf)#"	null="#rtrim(form.TESOPbeneficiarioSuf) EQ ""#">
					<cfif #CBidPago# NEQ "">
					, CBidPago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CBidPago#">
					</cfif>
					<cfif #form.TESMPcodigo# NEQ "">
					, TESMPcodigoPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TESMPcodigo#">
					</cfif>
			 where EcodigoOri = #session.Ecodigo#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESSPestado = 0
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
				set TESid = #session.Tesoreria.TESid#
			 where EcodigoOri = #session.Ecodigo#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESDPestado = 0
		</cfquery>
        <cf_cboFormaPago TESOPFPtipoId="5" TESOPFPid="#form.TESSPid#" SQL="update">
	</cftransaction>
<cfelseif IsDefined("form.Baja")>
	<cfset form.PASO = 0>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from TESdetallePagoCPC
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and (
					 select count(1)
					  from TESdetallePago
					 where EcodigoOri = #session.Ecodigo#
					   and TESSPid = TESdetallePagoCPC.TESSPid
					   and TESDPestado = 0
					) <> 0
		</cfquery>

		<cfquery datasource="#session.dsn#">
			delete from TESdetallePago
			 where EcodigoOri = #session.Ecodigo#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESDPestado = 0
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
				set TESSPidDuplicado = null
			 where EcodigoOri = #session.Ecodigo#
			   and TESSPidDuplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESSPestado in (3,13,23,103)
		</cfquery>
        <!---ERBG corrección SC182785 INICIA--->
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
        <!---ERBG corrección SC182785 FIN--->
		<cfquery datasource="#session.dsn#">
			delete from TESsolicitudPago
			 where EcodigoOri = #session.Ecodigo#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESSPestado = 0
		</cfquery>

		<cf_cboFormaPago TESOPFPtipoId="5" TESOPFPid="#form.TESSPid#" SQL="delete">
	</cftransaction>
<cfelseif IsDefined("form.Duplicar")>
	<cfset form.PASO = 10>
    <cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
        <cfquery name="rsNewSol" datasource="#session.dsn#">
            select (max(coalesce(TESSPnumero,0)) + 1) as newSol
            from TESsolicitudPago
            where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cftransaction>
            <cfquery datasource="#session.dsn#" name="insert">
                select
                    TESid, CFid,
                    TESSPtipoDocumento,
                    SNcodigoOri,
                    TESSPfechaPagar,
                    McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri,
                    TESSPmsgRechazo,
                    TESOPobservaciones,
                    TESOPinstruccion,
                    TESOPbeneficiarioSuf
                  from TESsolicitudPago
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
                   and TESSPestado in (3,13,23,103)
            </cfquery>
            <cfquery datasource="#session.dsn#" name="insert">
                insert into TESsolicitudPago (
                    TESid, CFid,
                    EcodigoOri, TESSPnumero,
                    TESSPtipoDocumento, TESSPestado,
                    SNcodigoOri,
                    TESSPfechaPagar,
                    McodigoOri,	TESSPtipoCambioOriManual, TESSPtotalPagarOri,
                    TESSPmsgRechazo,
                    TESSPfechaSolicitud, UsucodigoSolicitud,
                    BMUsucodigo
                    , TESOPobservaciones
                    , TESOPinstruccion
                    , TESOPbeneficiarioSuf
                    )
                values (
                    #insert.TESid#,
					#insert.CFid#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">,
                    #insert.TESSPtipoDocumento#, 0,
                    #insert.SNcodigoOri#,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#insert.TESSPfechaPagar#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#insert.McodigoOri#">,
                    <cfqueryparam cfsqltype="cf_sql_float" 		value="#insert.TESSPtipoCambioOriManual#" null="#insert.TESSPtipoCambioOriManual EQ ""#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	scale="2" value="#insert.TESSPtotalPagarOri#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#insert.TESSPmsgRechazo#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
                    #session.Usucodigo#,
                    #session.Usucodigo#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#insert.TESOPobservaciones#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#insert.TESOPinstruccion#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#insert.TESOPbeneficiarioSuf#">
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
                     TESDPmoduloOri, TESDPdocumentoOri, SNcodigoOri, TESDPfechaVencimiento,
                     TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri,
                     TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
					 TESDPdescripcion, CFcuentaDB, TESRPTCid, Rcodigo, Rmonto, TESDPreferenciaOri
				)
			select
				TESid, CFid, OcodigoOri,
				0,
				#session.Ecodigo#,
				#LvarTESSPid#,
				 TESDPtipoDocumento, TESDPidDocumento,
				 TESDPmoduloOri, TESDPdocumentoOri, SNcodigoOri, TESDPfechaVencimiento,
				 TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri,
				 TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
				 TESDPdescripcion, CFcuentaDB, TESRPTCid, Rcodigo, Rmonto, TESDPreferenciaOri
			  from TESdetallePago
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
                   and TESDPestado in (3,13,23,103)
				   and MlineaId IS NULL
				   and RlineaId IS NULL
            </cfquery>

            <cfquery datasource="#session.dsn#">
                update TESsolicitudPago
                    set TESSPidDuplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
                 where EcodigoOri = #session.Ecodigo#
                   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
                   and TESSPestado in (3,13,23,103)
            </cfquery>
        </cftransaction>
    </cflock>

	<cfset form.TESSPid = LvarTESSPid>
<cfelseif IsDefined("form.AAprobar")>
	<cfset form.PASO = 0>
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
			set TESSPestado  = 1
		 where EcodigoOri = #session.Ecodigo#
		   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		   and TESSPestado = 0
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TESdetallePago
			set TESDPestado  = 1
		 where EcodigoOri = #session.Ecodigo#
		   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		   and TESDPestado = 0
	</cfquery>

	<!--- Envío a Trámite por Centro Funcional --->
	<!--- PDCP = Pago Documentos CxP --->
	<cfinvoke	component		= "sif.tesoreria.Componentes.TESaplicacion"
				method			= "sbTramiteSP"
				TESSPid			= "#form.TESSPid#"
				TipoSol     	= "PDCP"
	/>

	<!--- Impresión de la SP --->
	<cf_SP_imprimir location="solicitudesCP.cfm?PASO=0">
<cfelseif IsDefined("form.btnBorrarDet") and len(trim(form.btnBorrarDet))>
	<cfset form.PASO = 10>
	<cfquery datasource="#session.dsn#">
		delete from TESdetallePagoCPC
		 where TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarDet#">
		   and (
				 select count(1)
				  from TESdetallePago
				 where EcodigoOri = #session.Ecodigo#
				   and TESSPid = TESdetallePagoCPC.TESSPid
				   and TESDPid = TESdetallePagoCPC.TESDPid
				   and TESDPestado = 0
				) <> 0
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from TESdetallePago
		 where EcodigoOri = #session.Ecodigo#
		   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		   and TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarDet#">
		   and TESDPestado = 0
	</cfquery>
	<cfset sbCalculaAfectacionesPago(form.TESSPid)>
<cfelseif IsDefined("form.Nuevo")>
	<!--- Tratar como form.nuevo --->
	<cfset form.PASO = 0>
<!--- Comunes --->
<cfelseif IsDefined("form.btnLista_Solicitudes")>
	<cfset form.PASO = 0>
<cfelseif IsDefined("form.btnSel")>
	<cfset form.PASO = 1>
<!--- solicitudesCP_lista1Sel.cfm --->
<cfelseif IsDefined("form.btnSeleccionar") OR IsDefined("form.btnSiguiente")>
	<!--- AltaDet (sin Solicitud de Pago) --->
	<cfif IsDefined("form.btnSeleccionar")>
		<cfset form.PASO = 1>
	<cfelse>
		<cfset form.PASO = 2>
	</cfif>
	<cfif isdefined("form.chk")>
    	<cfif NOT Isdefined('session.Tesoreria.TESid')>
        	<cfthrow message="No se ha podido recuperar la tesoreria">
        </cfif>
		<cfloop index="LvarID" list="#form.chk#">
			<cfquery datasource="#session.dsn#">
				insert into TESdetallePago
					(
					 TESid, CFid, OcodigoOri,
					 TESDPestado, TESSPid, TESOPid,
					 TESDPtipoDocumento, TESDPidDocumento,
					 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
					 SNcodigoOri,
					 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada,
					 EcodigoOri, EcodigoPago, Miso4217Ori,
					 TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
					 TESDPdescripcion,
					 CFcuentaDB, TESRPTCid, BMUsucodigo,
					 Rcodigo, Rmonto,
					 TESDPtipoCambioOri
					)
				select
					  #session.Tesoreria.TESid#, cxp.CFid, cxp.Ocodigo
					, 0 , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">
					, 1, IDdocumento
					, 'CPFC', Ddocumento, cxp.CPTcodigo
					, cxp.SNcodigo
				<cfif form.FechaPago_SP EQ "">
					, Dfechavenc , Dfechavenc , Dfechavenc
				<cfelse>
					, Dfechavenc
					, <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaPago_SP)#">
					, <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaPago_SP)#">
				</cfif>
					, cxp.Ecodigo, cxp.Ecodigo, Miso4217
					, (cxp.EDsaldo - (isnull(cxp.EDmontoretori,0) + isnull(cxp.EDretencionVariable,0) - isnull((
													     select sum(isnull(abs(dp.TESDPmontoSolicitadoOri),0)) as monto 
														 from TESdetallePago dp
														 where dp.TESDPdocumentoOri=cxp.Ddocumento
														 and dp.TESDPidDocumento=cxp.IDdocumento
														 and dp.TESDPtipoDocumento=1
														 and dp.RlineaId is not null
														 and dp.TESDPestado =12
														 ),0) )- TESDPaprobadoPendiente), 

					(cxp.EDsaldo - (isnull(cxp.EDmontoretori,0) + isnull(cxp.EDretencionVariable,0) - isnull((
													     select sum(isnull(abs(dp.TESDPmontoSolicitadoOri),0)) as monto 
														 from TESdetallePago dp
														 where dp.TESDPdocumentoOri=cxp.Ddocumento
														 and dp.TESDPidDocumento=cxp.IDdocumento
														 and dp.TESDPtipoDocumento=1
														 and dp.RlineaId is not null
														 and dp.TESDPestado =12
														 ),0)  )- TESDPaprobadoPendiente), 
					(cxp.EDsaldo - (isnull(cxp.EDmontoretori,0) + isnull(cxp.EDretencionVariable,0) - isnull((
													     select sum(isnull(abs(dp.TESDPmontoSolicitadoOri),0)) as monto 
														 from TESdetallePago dp
														 where dp.TESDPdocumentoOri=cxp.Ddocumento
														 and dp.TESDPidDocumento=cxp.IDdocumento
														 and dp.TESDPtipoDocumento=1
														 and dp.RlineaId is not null
														 and dp.TESDPestado =12
														 ),0)   )- TESDPaprobadoPendiente)

					, tt.CPTdescripcion #_CAT# ': ' #_CAT# cxp.Ddocumento
					, (select min(CFcuenta) from CFinanciera where Ccuenta = cxp.Ccuenta)
					, TESRPTCid
					, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, cxp.Rcodigo, 0,
					coalesce(Dtipocambio,1)
				  from EDocumentosCP cxp
				  	inner join CPTransacciones tt
						 on tt.Ecodigo 		= cxp.Ecodigo
						and tt.CPTcodigo 	= cxp.CPTcodigo
						and tt.CPTtipo 		= 'C'
				  	inner join Monedas m
						 on m.Mcodigo 	= cxp.Mcodigo
				 where cxp.Ecodigo = #session.Ecodigo#
				   and cxp.IDdocumento = #LvarID#
				   and <!--- Que el documento no esté En preparacion SP o enviada a aprobacion SP --->
						(
							Select count(1)
							  from TESdetallePago dp
							 where dp.EcodigoOri		= cxp.Ecodigo
							   and dp.TESDPtipoDocumento = 1
							   and dp.TESDPidDocumento 	= cxp.IDdocumento
							   and dp.TESDPestado 		in (0,1)
						)	= 0
			</cfquery>
		</cfloop>
	</cfif>
<!--- solicitudesCP_lista2Gen.cfm --->
<cfelseif IsDefined("form.btnCambiarSel")>
	<!--- CambioDet sin SP Encabezado --->
	<cfset form.PASO = 2>

	<cfif isdefined("TESDPid")>
		<cfloop index="LvarID" list="#form.TESDPid#">
			<cfset montoSolicitadoVar = evaluate('form.TESDPmontoSolicitadoOri_#LvarID#')>
			<cfquery datasource="#session.dsn#">
				update TESdetallePago
					<!--- set TESDPmontoSolicitadoOri	= <cfqueryparam cfsqltype="cf_sql_money" value="#evaluate('form.TESDPmontoSolicitadoOri_#LvarID#')#"> --->
					set TESDPmontoSolicitadoOri	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(montoSolicitadoVar,',','','ALL')#">
				<cfif form.FechaPago EQ "">
					  , TESDPfechaSolicitada 	= <cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDatetime(evaluate('form.TESDPfechaSolicitada_#LvarID#'))#">
				<cfelse>
					  , TESDPfechaSolicitada 	= <cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDatetime(form.FechaPago)#">
				</cfif>
				 where EcodigoOri = #session.Ecodigo#
				   and TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
				   and TESSPid is null
				   and TESDPestado = 0
			</cfquery>
		</cfloop>
	</cfif>
<cfelseif IsDefined("form.btnBorrarSel") and len(trim(form.btnBorrarSel))>
	<cfset form.PASO = 2>
	<cfquery name="rsTES" datasource="#session.dsn#">
		delete from TESdetallePago
		 where EcodigoOri = #session.Ecodigo#
		   and TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarSel#">
		   and TESSPid is null
		   and TESDPestado = 0
	</cfquery>
<cfelseif IsDefined("form.btnBorrarTodos") and #form.btnBorrarTodos# EQ 'OK'>
	<cfset form.PASO = 2>
	<cfquery name="rsTES" datasource="#session.dsn#">
		delete from TESdetallePago
		 where EcodigoOri = #session.Ecodigo#
			and BMUsucodigo = #session.Usucodigo#
		   and TESSPid is null
		   and TESDPestado = 0
	</cfquery>
<cfelseif IsDefined("form.btnGenerarSel")>
	<!--- Alta y asociar detalles seleccionados --->

	<cfset form.PASO = 0>
	<cfif isdefined("TESDPid")>
		<cftransaction>
			<cf_dbtemp name="tTESDPidV1" returnvariable="tablaTESDPid" datasource="#session.dsn#">
				<cf_dbtempcol name="TESDPid" type="numeric" mandatory="yes">
			</cf_dbtemp>
			<cfloop index="LvarTESDPid" list="#form.TESDPid#">
				<cfquery name="rsTESDP" datasource="#session.dsn#">
					insert into #tablaTESDPid# (TESDPid) values (#LvarTESDPid#)
				</cfquery>
			</cfloop>
			<cfquery name="rsTESDP" datasource="#session.dsn#">
				select  dp.SNcodigoOri, dp.TESDPfechaSolicitada, m.Mcodigo, dp.Miso4217Ori
						, coalesce(TESOPFPtipo,0) as TESOPFPtipo, coalesce(TESOPFPcta,0) as TESOPFPcta
						, sum(TESDPmontoSolicitadoOri) as Total
				  from TESdetallePago dp
					inner join Monedas m
						 on m.Ecodigo	= dp.EcodigoOri
						and m.Miso4217	= dp.Miso4217Ori
					left join TESOPformaPago f
						 on f.TESOPFPtipoId = 4  <!----- CxP--->
					    and dp.TESDPtipoDocumento = 1
					    and f.TESOPFPid	 = dp.TESDPidDocumento
						and f.TESOPFPtipo in (1,2,3)
				 where dp.EcodigoOri = #session.Ecodigo#
				   and dp.TESDPid in (select TESDPid from #tablaTESDPid#)
				   and dp.TESSPid is null
				   and dp.TESDPestado = 0
				   and dp.BMUsucodigo = #session.Usucodigo#
				group by dp.SNcodigoOri, dp.TESDPfechaSolicitada, m.Mcodigo, dp.Miso4217Ori
						, coalesce(f.TESOPFPtipo,0), coalesce(f.TESOPFPcta,0)
			</cfquery>
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

			<cfloop query="rsTESDP">
				<!--- *INICIO* OBTIENE LA INFO DEL SOCIO DE NEGOCIO --->
				<cfset CtaOrigen = 0>
				<cfset MedPagoOrigen = "">
				<cfif len(trim(#rsTESDP.SNcodigoOri#))>
					<cfquery name="rsGetInfoSN" datasource="#session.dsn#">
						SELECT SNCBidPago_Origen, SNMedPago_Origen
						FROM SNegocios
						WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESDP.SNcodigoOri#">
				        AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>

					<cfif #rsGetInfoSN.recordcount# GT 0 AND len(trim(rsGetInfoSN.SNCBidPago_Origen))>
						<cfset CtaOrigen = #rsGetInfoSN.SNCBidPago_Origen#>
					</cfif>
					<cfif #rsGetInfoSN.recordcount# GT 0 AND len(trim(rsGetInfoSN.SNMedPago_Origen))>
						<cfset MedPagoOrigen = #rsGetInfoSN.SNMedPago_Origen#>
					</cfif>
				</cfif>
				<!--- *FIN* OBTIENE LA INFO DEL SOCIO DE NEGOCIO --->

	            <cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
                    <cfquery name="rsTESSP" datasource="#session.dsn#">
                        select coalesce(max(TESSPnumero)+1,1) as SiguienteSP
                          from TESsolicitudPago
                         where EcodigoOri = #session.Ecodigo#
                    </cfquery>
                    <cfquery name="insert" datasource="#session.dsn#">
                        insert into TESsolicitudPago
                            (
                             TESid, CFid,
                             EcodigoOri, TESSPnumero, TESSPtipoDocumento, TESSPestado, SNcodigoOri,
                             TESSPfechaPagar,
                             McodigoOri, TESSPtotalPagarOri,
                             TESSPfechaSolicitud, UsucodigoSolicitud
									  ,ProcessId, CBidPago, TESMPcodigoPago

                            )
                        values
                            (
                                #session.Tesoreria.TESid#, #session.Tesoreria.CFid#,
                                #session.Ecodigo#, #rsTESSP.SiguienteSP#,
                                1, <!--- Tipo CxP --->
                                0, <!--- Estado en preparación SP --->
                                #rsTESDP.SNcodigoOri#,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#rsTESDP.TESDPfechaSolicitada#">,
								#rsTESDP.Mcodigo#, #rsTESDP.total#,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, #session.usucodigo#
								<cfif #rsObtieneTramite.recordcount# gt 0>
						        ,#rsObtieneTramite.ProcessId#
						      <cfelse>
						        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						      </cfif>
						      <cfif CtaOrigen NEQ 0>
							      ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#CtaOrigen#">
							  <cfelse>
							      ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
							  </cfif>
						      <cfif MedPagoOrigen NEQ "">
							      ,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#MedPagoOrigen#">
							  <cfelse>
							      ,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
							  </cfif>
                            )
                        <cf_dbidentity1 datasource="#session.DSN#">
                    </cfquery>
                    <cf_dbidentity2 datasource="#session.DSN#" name="insert">
				</cflock>

				<cfquery datasource="#session.dsn#">
					update TESdetallePago
					   set  TESid = #session.Tesoreria.TESid#,
					   		TESSPid = #insert.identity#
					 where EcodigoOri = #session.Ecodigo#
					   and TESDPid in (select TESDPid from #tablaTESDPid#)
					   and TESSPid is null
					   and TESDPestado = 0
					   and SNcodigoOri			= #rsTESDP.SNcodigoOri#
					   and TESDPfechaSolicitada = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsTESDP.TESDPfechaSolicitada#">
					   and BMUsucodigo = #session.Usucodigo#
					   and Miso4217Ori			= '#rsTESDP.Miso4217Ori#'
					   <!--- Incluye las SPs que coincida con Forma de Pago --->
					   and (
					   			select count(1)
								  from TESOPformaPago f
								 where f.TESOPFPtipoId = 4  <!----- CxP--->
								   and TESdetallePago.TESDPtipoDocumento = 1
								   and f.TESOPFPid	 = TESdetallePago.TESDPidDocumento
							<cfif rsTESDP.TESOPFPtipo EQ 1 OR rsTESDP.TESOPFPtipo EQ 2 OR rsTESDP.TESOPFPtipo EQ 3>
								   and f.TESOPFPtipo = #rsTESDP.TESOPFPtipo#
								<cfif rsTESDP.TESOPFPtipo EQ "2">
								   and f.TESOPFPcta	 = #rsTESDP.TESOPFPcta#
								</cfif>
					   		) > 0
							<cfelse>
								   and f.TESOPFPtipo in (1,2,3)
					   		) = 0
							</cfif>
				</cfquery>

				<cfif rsTESDP.TESOPFPtipo EQ "1" OR rsTESDP.TESOPFPtipo EQ "2" OR rsTESDP.TESOPFPtipo EQ "3">
					<cfquery datasource="#session.dsn#">
						insert into TESOPformaPago (TESOPFPtipoId, TESOPFPid, TESOPFPtipo, TESOPFPcta)
						values (
							5,
							#insert.identity#,
							#rsTESDP.TESOPFPtipo#,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESDP.TESOPFPcta#" null="#rsTESDP.TESOPFPtipo NEQ 2#">
						)
					</cfquery>
				</cfif>
				<cfset sbCalculaAfectacionesPago(insert.identity)>
			</cfloop>
		</cftransaction>
	</cfif>
<cfelseif isdefined("form.btnSeleccionarDoc") or isdefined("form.btnVolver")>
	<!--- AltaDet (con Solicitud de Pago) --->
	<cfif IsDefined("form.btnSeleccionarDoc")>
		<cfset form.PASO = 3>
	<cfelse>
		<cfset form.PASO = 10>
	</cfif>
	<cfif isdefined("form.chk")>
		<!--- TESid de la SP --->
		<cfquery name="rsSP" datasource="#session.dsn#">
			select TESid
			  from TESsolicitudPago
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		</cfquery>
		<cftransaction>
			<cfloop index="LvarID" list="#form.chk#">
				<cfquery datasource="#session.dsn#">
					insert into TESdetallePago
						(
						 TESid, CFid, OcodigoOri,
						 TESDPestado, TESSPid, TESOPid,
						 TESDPtipoDocumento, TESDPidDocumento,
						 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
						 SNcodigoOri,
						 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada,
						 EcodigoOri, EcodigoPago, Miso4217Ori,
						 TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
						 TESDPdescripcion,
						 CFcuentaDB, TESRPTCid, BMUsucodigo
						 ,Rcodigo, Rmonto
						)
					select
						  #rsSP.TESid#, cxp.CFid, cxp.Ocodigo
						, 0 , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						, 1, IDdocumento
						, 'CPFC', Ddocumento, cxp.CPTcodigo
						, cxp.SNcodigo
						, Dfechavenc , Dfechavenc , Dfechavenc
						, cxp.Ecodigo, cxp.Ecodigo, Miso4217
						, (EDsaldo - TESDPaprobadoPendiente), (EDsaldo - TESDPaprobadoPendiente), (EDsaldo - TESDPaprobadoPendiente)
						, tt.CPTdescripcion #_CAT# ': ' #_CAT# cxp.Ddocumento
						, (select min(CFcuenta) from CFinanciera where Ecodigo = cxp.Ecodigo and Ccuenta = cxp.Ccuenta)
						, TESRPTCid, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						, cxp.Rcodigo, 0
					  from EDocumentosCP cxp
						inner join CPTransacciones tt
							 on tt.Ecodigo 		= cxp.Ecodigo
							and tt.CPTcodigo 	= cxp.CPTcodigo
							and tt.CPTtipo 		= 'C'
						inner join Monedas m
							 on m.Mcodigo 	= cxp.Mcodigo
					 where cxp.Ecodigo = #session.Ecodigo#
					   and cxp.IDdocumento = #LvarID#
					   and <!--- Que el documento no esté En preparacion SP o enviada a aprobacion SP --->
							(
								Select count(1)
								  from TESdetallePago dp
								 where dp.EcodigoOri		= cxp.Ecodigo
								   and dp.TESDPtipoDocumento = 1
								   and dp.TESDPidDocumento 	= cxp.IDdocumento
								   and dp.TESDPestado 		in (0,1)
							)	= 0
				</cfquery>
			</cfloop>
			<cfset sbCalculaAfectacionesPago(form.TESSPid)>
		</cftransaction>
	</cfif>
</cfif>

<cfif Form.PASO EQ 10 AND isdefined("Form.TESSPid")>
	<cflocation url="solicitudesCP.cfm?PASO=#Form.PASO#&TESSPid=#Form.TESSPid#">
<cfelseif Form.PASO EQ 3 AND isdefined("Form.TESSPid")>
	<cflocation url="solicitudesCP.cfm?PASO=#Form.PASO#&TESSPid=#Form.TESSPid#&Mcodigo=#form.Mcodigo#">
<cfelse>
	<cflocation url="solicitudesCP.cfm?PASO=#Form.PASO#">
</cfif>

<cffunction name="sbCalculaAfectacionesPago" access="private" returntype="void">
	<cfargument name="TESSPid"	type="numeric">
	<cfargument name="update"	type="boolean" default="yes">

	<cfinvoke 	component="sif.tesoreria.Componentes.TESafectaciones"
				method="sbCalculaAfectacionesPago"
				TESSPid		= "#Arguments.TESSPid#"
				updateSP	= "#Arguments.update#"
	>
</cffunction>
