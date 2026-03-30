<!--- 
	Creado por: Gustavo Fonseca H.
		Fecha: 28-6-2005
		Motivo: Mantenimiento de Instrucciones de Pago. 
--->

<cf_navegacion name="TEF" navegacion>
<cfset LvarCFM = #form.TEF# & ".cfm">
<cfif form.TEF EQ "TRI">
	<cfset LvarTESMPtipo = "2">
	<cfset LvarUrlGenerar = "Imprima">
	<cfset LvarTipoLote	= "Lote de Impresión de Instrucciones de Pago">
	<cfset LvarAccion	= "Impresión">
	<cfset LvarAccion2	= "Impreso">
<cfelse>
	<cfset LvarTESMPtipo = "3">
	<cfset LvarUrlGenerar = "Genere">
	<cfset LvarTipoLote	= "Lote de Generación de Transferencias Electrónicas">
	<cfset LvarAccion	= "Generación">
	<cfset LvarAccion2	= "Generado">
</cfif>

<cfif IsDefined("form.btnCrear")>
	<cftransaction>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into TEStransferenciasL (
				TESid,
				CBid,
				TESMPcodigo,
				TESTLestado,
				TESTLfecha,
				TESTMPtipo,
				Usucodigo,
				BMUsucodigo)
			values (
				#session.Tesoreria.TESid#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTESMPtipo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESTLid">
		<cfif form.chkTipo NEQ 3>
			<cfquery datasource="#session.dsn#">
				update TESordenPago
				   set 	TESTLid 	= #LvarTESTLid#,
						TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">,
						TESOPestado = 11 <!--- En Emisión OP --->
				 where TESid		= #session.Tesoreria.TESid#
				   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				   and TESTLid		IS null
				   and TESCFLid		IS null
				   and TESOPestado = 11 <!--- En Emisión OP --->
				   and (
						TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				<cfif form.chkTipo EQ 2>
						OR	TESMPcodigo	is null
				</cfif>
					   )
			</cfquery>
		</cfif>
	</cftransaction>
	<cflocation url="#LvarCFM#?TESTLid=#URLEncodedFormat(LvarTESTLid)#&CBid=#URLEncodedFormat(form.CBid)#">
<cfelseif IsDefined("form.btnCancelar")>
	<cfquery datasource="#session.dsn#">
		update TESordenPago
		   set TESTDid = NULL
		 where TESid			= #session.Tesoreria.TESid#
		   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from TEStransferenciasD
		 where TESid			= #session.Tesoreria.TESid#
		   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TEStransferenciasL
		   set TESTLestado = 0
		 where TESid			= #session.Tesoreria.TESid#
		   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cflocation url="#LvarCFM#?TESTLid=#URLEncodedFormat(form.TESTLid)#">
<cfelseif IsDefined("form.btnSeleccionarOP")>
	<cfif isdefined("form.chk") and trim(form.chk) NEQ "">
		<cfquery name="rsTESTL" datasource="#session.dsn#">
			select CBid, TESMPcodigo
			  from TEStransferenciasL
			 where TESid	= #session.Tesoreria.TESid#
			   and TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		</cfquery>	
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set 	TESTLid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">,
					CBidPago	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">,
					TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">,
					TESOPestado = 11
			 where TESid		= #session.Tesoreria.TESid#
			   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
			   and TESTLid		IS null
			   and TESCFLid		IS null
			   and TESOPestado = 11 <!--- En Emisión OP --->
			   and TESOPid in (0#form.chk#)
		</cfquery>
	</cfif>
	<cflocation url="#LvarCFM#?TESTLid=#form.TESTLid#">
<cfelseif IsDefined("form.btnEliminar")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set 	TESTLid 	= null,
					TESOPestado = 11
			 where TESid		= #session.Tesoreria.TESid#
			   and TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
			   and TESOPestado = 11
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from TEStransferenciasL
			 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		</cfquery>
	</cftransaction>
	<cflocation url="#LvarCFM#">
<cfelseif IsDefined("form.btnModificar")>
	<cfquery datasource="#session.dsn#">
		update TEStransferenciasL
		   set 	TESTLfecha 	= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSparseDateTime(form.TESTLfecha)#">
		 where TESid		= #session.Tesoreria.TESid#
		   and TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cflocation url="#LvarCFM#?TESTLid=#form.TESTLid#">
<cfelseif IsDefined("url.btnExcluirOP")>
	<cfquery datasource="#session.dsn#">
		update TESordenPago
		   set 	TESTLid 	= null,
				TESOPestado = 11
		 where TESid		= #session.Tesoreria.TESid#
		   and TESOPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESOPid#">
		   and TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESTLid#">
		   and TESOPestado = 11
	</cfquery>
	<cflocation url="#LvarCFM#?TESTLid=#url.TESTLid#">
<cfelseif IsDefined("form.btnGenerar")>
	<!--- PASAR DE ESTADO 0 a 2 (el 1 n/a) --->
	<cfquery name="rsTESTL" datasource="#session.dsn#">
		select tl.TESTLestado, tl.CBid, tl.TESMPcodigo, mp.FMT01COD
		  from TEStransferenciasL tl
			inner join TESmedioPago mp
			<cfif form.TEF EQ "TRE">
				<!--- Formato Generación TEF --->
				left join TEStransferenciaG tg 
					on tg.TESTGid = mp.TESTGid
			<cfelse>
				<!--- Formato Impresion TEF --->
				left join FMT001 fi
					on fi.FMT01COD = mp.FMT01COD
			</cfif>
				<!--- Formato Impresion eMail --->
				left join FMT001 fm
					on fm.FMT01COD = mp.FMT01CODemail
				 on mp.TESid		= tl.TESid
				and mp.CBid			= tl.CBid
				and mp.TESMPcodigo 	= tl.TESMPcodigo
		 where tl.TESid		= #session.Tesoreria.TESid#
		   and tl.TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>

	<cfif rsTESTL.TESTLestado NEQ "0">
		<cf_errorCode	code = "50766" msg = "Se esta tratando de Iniciar la Generación de un Lote que no está en Estado 0=Preparacion">
	</cfif>

	<cftransaction>
		<cfparam name="form.TESTLdatos" default="">
		<cfquery datasource="#session.dsn#">
			update TEStransferenciasL
			   set TESTLestado = 2
				,TESTLreferencia = 			null
				,TESTLreferenciaComision = 	null
				,TESTLtotalDebitado = 		<cfqueryparam cfsqltype="cf_sql_money"		value="0">
				,TESTLtotalComision = 		<cfqueryparam cfsqltype="cf_sql_money"		value="0">
				,TESTLcantidad = 			<cfqueryparam cfsqltype="cf_sql_integer"	value="0">
				,TESTLmsg = 				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="">
				,TESTLdatos = 				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESTLdatos#">
			 where TESid	= #session.Tesoreria.TESid#
			   and TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			insert into TEStransferenciasD
				(
					 TESid
					,CBid
					,TESMPcodigo
					,TESOPid
					,TESTLid
					,TESTDestado
					,UsucodigoEmision
					,TESTDfechaEmision
					,BMUsucodigo
				)
			select 
					 #session.Tesoreria.TESid#
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CBid#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					,TESordenPago.TESOPid
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
					,0	/* En Emision */
					,#session.Usucodigo#
					,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
					,#session.Usucodigo#
			  from TESordenPago
			 where TESid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">	
			   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESMPcodigo#">	
			   and TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESTLid#">	
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set TESTDid = (select TESTDid from TEStransferenciasD where TESTLid = TESordenPago.TESTLid AND TESOPid = TESordenPago.TESOPid)
			 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">	
			   and TESMPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESMPcodigo#">	
			   and TESTLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESTLid#">	
		</cfquery>

		<cfif form.TEF EQ "TRE">
			<cfinvoke 	component="sif.tesoreria.Pagos.tef.componentes.TRE" 
						method="Verificar">
				<cfinvokeargument name="TESTLid"	value="#form.TESTLid#"/>
			</cfinvoke>
		</cfif>
	</cftransaction>
	<cfif LvarUrlGenerar EQ "Genere">
		<cfset session.SecGenerar = getTickCount()>
		<cfset LvarSecGenerar = session.SecGenerar>
	<cfelse>
		<cfset LvarSecGenerar = 1>
	</cfif>
	<cflocation url="#LvarCFM#?TESTLid=#form.TESTLid#&#LvarUrlGenerar#=#LvarSecGenerar#">
<cfelseif IsDefined("form.btnReGenerar")>
	<!--- PASAR DE ESTADO 0 a 2 (el 1 n/a) --->
	<cfquery name="rsTESTL" datasource="#session.dsn#">
		select tl.TESTLestado, tl.CBid, tl.TESMPcodigo, mp.FMT01COD
		  from TEStransferenciasL tl
			inner join TESmedioPago mp
				<!--- Formato Generación TEF --->
				left join TEStransferenciaG tg 
					on tg.TESTGid = mp.TESTGid
				<!--- Formato Impresion TEF --->
				left join FMT001 fi
					on fi.FMT01COD = mp.FMT01COD
				<!--- Formato Impresion eMail --->
				left join FMT001 fm
					on fm.FMT01COD = mp.FMT01CODemail
				 on mp.TESid		= tl.TESid
				and mp.CBid			= tl.CBid
				and mp.TESMPcodigo 	= tl.TESMPcodigo
		 where tl.TESid		= #session.Tesoreria.TESid#
		   and tl.TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cfif rsTESTL.TESTLestado NEQ "2">
		<cfthrow message="Se esta tratando de Re#LvarAccion# un Lote que no está en Estado 2=En Emsión">
	</cfif>
	<cfif LvarUrlGenerar EQ "Genere">
		<cfset session.SecGenerar = getTickCount()>
		<cfset LvarSecGenerar = session.SecGenerar>
	<cfelse>
		<cfset LvarSecGenerar = 1>
	</cfif>
	<cflocation url="#LvarCFM#?TESTLid=#form.TESTLid#&#LvarUrlGenerar#=#LvarSecGenerar#">
<cfelseif IsDefined("url.OP") AND url.OP EQ "Genere">
	<cfif IsDefined("url.Genere") AND IsDefined("session.SecGenerar") and url.Genere EQ session.SecGenerar>
		<cfset structDelete(session,"SecGenerar")>
		<cfinvoke 	component		= "sif.tesoreria.Pagos.tef.componentes.TRE" 
					method			= "Generar"
					returnVariable	= "LvarResult"
					
					TESTLid	= "#url.TESTLid#"
		/>
		<cfif LvarResult.Msg EQ "OK">
			<cfheader name="Content-Disposition" value="Attachment;filename=#LvarResult.FileName#">
			<cfheader name="Expires" value="1">
			<cfset LvarFile = ExpandPath("PDtoCF.zip")>
			<cfcontent type="application/zip" file="#LvarResult.File#" deletefile="yes">
        <cfelse>
        	<cfthrow message="#LvarResult.Msg#">
		</cfif>
	</cfif>
	<cfabort>
<cfelseif IsDefined("url.OP") AND url.OP EQ "NCHK">
	<cfquery name="rsTESTD" datasource="#session.dsn#">
		select tl.TESTLestado, td.TESTDestado
		  from TEStransferenciasD td
		  	inner join TEStransferenciasL tl
				on tl.TESTLid = td.TESTLid
		  where td.TESTDid	= #url.TESTDid#
			and tl.TESid	= #session.Tesoreria.TESid#
	</cfquery>
	<cfif rsTESTD.TESTLestado NEQ "2">
		<cfthrow message="Se esta tratando de Excluir una Orden de Pago a un Lote que no está en Estado 2=En Emsión">
	</cfif>

	<cfif rsTESTD.TESTDestado EQ "3">
		<cfquery datasource="#session.dsn#">
			update TEStransferenciasD
			   set TESTDestado = 0
			 where TESTDid	= #url.TESTDid#
			   and TESid	= #session.Tesoreria.TESid#
		</cfquery>
		<cflocation url="/cfmx/sif/imagenes/checked.gif">
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update TEStransferenciasD
			   set TESTDestado = 3
			 where TESTDid	= #url.TESTDid#
			   and TESid	= #session.Tesoreria.TESid#
		</cfquery>
		<cflocation url="/cfmx/sif/imagenes/unchecked.gif">
	</cfif>		
<cfelseif IsDefined("form.btnVerificar")>
	<cfparam name="form.tipoConfirmacion" default="0">
	<cfquery name="rsTESTD" datasource="#session.dsn#">
		select td.TESTDid, td.TESTDestado, td.TESTDreferencia
		  from TEStransferenciasD td
			inner join TESordenPago op
         		on op.TESid 	= td.TESid
        		and op.TESOPid 	= td.TESOPid
        		and op.TESTLid	= td.TESTLid
		 where td.TESid			= #session.Tesoreria.TESid#
		   and td.TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		order by op. TESOPnumero
	</cfquery>
	<cfset LvarRefs = true>
	<!---
		TESTGtipoConfirma:
			1: Una sola confirmación por Lote
			2: Una confirmación por OP
		form.tipoConfirmacion:
			0: TESTGtipoConfirma = 1: Una sola confirmación por Lote
			M: Manual por OP
			A: Automática (Ref - Sec)
			S: Consecutivo (Secuencia)
		TESTDestado:
			0: En Emisión
			1: Impreso
			2: Entregado
			3: Anulado
	--->
	<cfloop query="rsTESTD">
		<cfset LvarUpd = true>
		<cfif rsTESTD.TESTDestado EQ 3>
			<cfset LvarRef = "N/A">
		<cfelseif form.tipoConfirmacion EQ 0>
			<cfset LvarUpd = true>
			<cfset LvarRef = "#form.TESTLreferencia#">
		<cfelseif form.tipoConfirmacion EQ "M">
			<cfset LvarRef = "form.TESTDreferencia_#rsTESTD.TESTDid#">
			<cfif isdefined(LvarRef)>
				<cfset LvarUpd = true>
				<cfset LvarRef = evaluate(LvarRef)>
				<cfif LvarRef EQ "N/A">
					<cfset LvarRef = "">
				</cfif>
				<cfif LvarRef EQ "">
					<cfset LvarRefs = false>
				</cfif>
			<cfelse>
				<cfset LvarUpd = false>
			</cfif>
		<cfelseif form.tipoConfirmacion EQ "A">
			<cfset LvarUpd = true>
			<cfset LvarRef = "#form.TESTLreferencia#-#rsTESTD.currentRow#">
		<cfelse>
			<cfset LvarUpd = true>
			<cfset LvarRef = "#form.TESTLreferencia+rsTESTD.currentRow-1#">
		</cfif>

		<cfif LvarUpd>
			<cfquery datasource="#session.dsn#">
				update TEStransferenciasD
				   set TESTDreferencia	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRef#" null="#trim(LvarRef) EQ ''#">
				 where TESTDid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTD.TESTDid#">
			</cfquery>
		</cfif> 
	</cfloop>

	<cfif trim(form.TESTLreferenciaComision) EQ "" OR form.TESTLreferenciaComision EQ 0>
		<cfset form.TESTLreferenciaComision = "">
	<cfelseif form.tipoConfirmacion EQ "A">
		<cfset form.TESTLreferenciaComision = "#form.TESTLreferencia#-#rsTESTD.recordCount+1#">
	<cfelseif form.tipoConfirmacion EQ "S">
		<cfset form.TESTLreferenciaComision = "#form.TESTLreferencia+rsTESTD.recordCount#">
	</cfif>


	<cfset LvarMSG = "OK">
	<cfif NOT LvarRefs>
		<cfset LvarMSG = "Falta indicar Referencias de Confirmación por OP">
	</cfif>
	<cfquery name="rsTESTDs" datasource="#session.dsn#">
		select count(1) as cantidad
		     , sum(TESOPtotalPago) as monto
		  from TEStransferenciasD tr
		  	inner join TESordenPago op
				 on op.TESid 	= tr.TESid
				and op.TESOPid 	= tr.TESOPid
				and op.TESTLid	= tr.TESTLid
		 where tr.TESid		= #session.Tesoreria.TESid#
		   and tr.TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		   and tr.TESTDestado <> 3
	</cfquery>
	<cfif LvarMSG EQ "OK" AND rsTESTDs.cantidad NEQ form.TESTLcantidad>
		<cfset LvarMSG = "La cantidad de OPs confirmadas (CONF=#rsTESTDs.cantidad#) no corresponde con la 'Cantidad Transferencias confirmadas' indicada (#form.TESTLcantidad#)">
	</cfif>
	<cfset LvarDebitado = replace(form.TESTLtotalDebitado,",","","ALL")>
	<cfset LvarComision = replace(form.TESTLtotalComision,",","","ALL")>
	<cfif LvarComision EQ "">
		<cfset LvarComision = 0>
	</cfif>
	<cfif LvarMSG EQ "OK" AND NumberFormat(rsTESTDs.monto,"0.00") NEQ NumberFormat(LvarDebitado - LvarComision,"0.00")>
		<cfset LvarMSG = "El monto total de OPs confirmadas (CONF) no corresponde con el 'Monto total Debitado' menos 'Monto total Comisiones' indicados">
	</cfif>

	<cfif LvarMSG EQ "OK" AND form.TESTLreferenciaComision NEQ "" AND LvarComision EQ 0>
		<cfset LvarMSG = "Se indicó 'No.Referencia Comisión' pero no se indicó 'Monto Total Comisiones'">
	</cfif>
	<cfif LvarMSG EQ "OK" AND form.TESTLreferenciaComision EQ "" AND LvarComision GT 0>
		<cfset LvarMSG = "No se indicó 'No.Referencia Comisión' pero se indicó 'Monto Total Comisiones'">
	</cfif>

	<cfquery name="rsTESTL" datasource="#session.dsn#">
		update TEStransferenciasL
		   set   TESTLreferencia = 			<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESTLreferencia#">
				,TESTLreferenciaComision = 	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESTLreferenciaComision#">
				,TESTLtotalDebitado = 		<cfqueryparam cfsqltype="cf_sql_money"		value="#LvarDebitado#">
				,TESTLtotalComision = 		<cfqueryparam cfsqltype="cf_sql_money"		value="#LvarComision#">
				,TESTLcantidad = 			<cfqueryparam cfsqltype="cf_sql_integer"	value="#form.TESTLcantidad#">
				,TESTLmsg = 				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarMSG#">
		 where TESid	= #session.Tesoreria.TESid#
		   and TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	
	<cflocation url="#LvarCFM#?TESTLid=#form.TESTLid#&tipoConfirmacion=#form.tipoConfirmacion#">
<cfelseif IsDefined("form.btnVolver")>
	<cfquery name="rsTESTL" datasource="#session.dsn#">
		update TEStransferenciasL
		   set   TESTLmsg = null
		 where TESid	= #session.Tesoreria.TESid#
		   and TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>

	<cflocation url="#LvarCFM#?TESTLid=#form.TESTLid#">
<cfelseif IsDefined("form.btnEmitir")>
	<!--- PASAR DE ESTADO 2 a 0,3--->
	<cfquery name="rsTESTL" datasource="#session.dsn#">
		select 	  tl.CBid
				, tl.TESMPcodigo
				, tl.TESid
				, tl.TESMPcodigo
				, tl.TESTLestado
				, tl.TESTMPtipo
				, tl.TESTLfecha
				, tl.Usucodigo
                , mp.TESenviaCorreo 
		  from TEStransferenciasL tl
          inner join TESmedioPago mp
			on mp.TESid		= tl.TESid
			and mp.CBid			= tl.CBid
			and mp.TESMPcodigo 	= tl.TESMPcodigo 
		 where tl.TESid			= #session.Tesoreria.TESid#
		   and tl.TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cfif rsTESTL.TESTLestado NEQ "2"> <!--- Despues de Impresion --->
		<cfthrow message="Se esta tratando de Completar la Emisión de un #LvarTipoLote# que no se ha #LvarAccion2# (Estado=2)">
	</cfif>

	<cftransaction>
		<!--- Las OPs de Transferencias no confirmadas se pasan a un nuevo lote --->
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			select TESOPid , TESTDid
			  from TEStransferenciasD
			 where TESid			= #session.Tesoreria.TESid#
			   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
			   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
			   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
			   and TESTDestado		= 3
		</cfquery>

		<cfif rsTESTD.recordCount GT 0>
			<cfquery name="insert" datasource="#session.dsn#">
				insert into TEStransferenciasL (
					TESid,
					CBid,
					TESMPcodigo,
					TESTLestado,
					TESTLfecha,
					TESTMPtipo,
					Usucodigo,
					BMUsucodigo)
				values (
					#session.Tesoreria.TESid#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTESTL.TESTMPtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESTLid">

			<cfloop query="rsTESTD">
				<cfquery datasource="#session.dsn#">
					update TESordenPago
					   set TESTLid	 	= #LvarTESTLid#
						 , TESTDid		= NULL
					 where TESOPid		= #rsTESTD.TESOPid#
				</cfquery>
			</cfloop>
		</cfif>

		<!--- PASAR DE ESTADO 2 a 3: Se completa la impresión del Lote y se realiza la aplicación de documentos --->
		<cfset LvarCancelarMsg 	= form.TESTDmsgAnulacion>

		<cfquery name="rsTESTD" datasource="#session.dsn#">
			select TESOPid , TESTDid, TESTDreferencia
			  from TEStransferenciasD
			 where TESid			= #session.Tesoreria.TESid#
			   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
			   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
			   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
			   and TESTDestado		<> 3
		</cfquery>
		<cfset LvarHay = false>
		<cfset LvarListo = true>
		<cfloop query="rsTESTD">
			<cfset LvarHay = true>
			<cfif rsTESTD.TESTDreferencia EQ "">
				<cfset LvarListo = false>
			</cfif>
		</cfloop>

		<cfif LvarHay and LvarListo>
			<!--- PASAR ESTADO DE OP, SP, DP a 12=OP aplicada --->
			<cfquery datasource="#session.dsn#">
				update TEStransferenciasL
				   set TESTLestado 		= 3	/* Lote Emitido */
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
				   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
			</cfquery>

			<cfloop query="rsTESTD">
				<cfquery datasource="#session.dsn#">
					update TEStransferenciasD
					   set TESTDestado 			= 1	/* Transferencia Emitida = Impresa/Generada con Referencia */
						 , UsucodigoEmision		= #session.Usucodigo#
						 , TESTDfechaEmision	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where TESid		= #session.Tesoreria.TESid#
					   and CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
					   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
					   and TESTDid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTD.TESTDid#">
				</cfquery>
		
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado 	= 110	/* Orden de Pago Emitida */
					 where TESid 		= #session.Tesoreria.TESid#
					   and TESOPid 		= #rsTESTD.TESOPid#
					   and TESSPestado 	= 11
				</cfquery>	
				<cfquery datasource="#session.dsn#">
					update TESdetallePago 
					   set TESDPestado	= 110
					 where TESid 		= #session.Tesoreria.TESid#
					   and TESOPid 		= #rsTESTD.TESOPid#
					   and TESDPestado 	= 11
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESordenPago
					   set TESOPestado			= 110
						 , CBidPago				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
						 , TESMPcodigo		 	= '#trim(rsTESTL.TESMPcodigo)#'
						 , TESTDid 				= #rsTESTD.TESTDid#
						 , TESOPfechaEmision	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						 , UsucodigoEmision		= #session.Usucodigo#
					 where TESid 		= #session.Tesoreria.TESid#
					   and TESOPid 		= #rsTESTD.TESOPid#
					   and TESOPestado 	= 11
				</cfquery>	
			</cfloop>

			<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
						method="sbAplicarLoteTransferencias">
				<cfinvokeargument name="TESTLid" value="#form.TESTLid#"/>
                
			</cfinvoke>
            
            
            <!---Si se definio en Medios de Pago que envia correo--->
			<cfif rsTESTL.TESenviaCorreo eq 1>
				
				<!---Mails--->
                <cfloop query="rsTESTD">
                    <cfset LvarTESOPid=#rsTESTD.TESOPid#>
                    <cfset enviadoPor = "#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# ">
    
                    <cfsavecontent variable="contenido">
                        <cfinclude template="correoEmision.cfm">
                    </cfsavecontent>
                    
                    <cfquery name="rsEmail" datasource="#session.dsn#">
                    	select coalesce (TESBemail, SNCemail ) as email, TESOPnumero
                        from  TESordenPago a
                        	left join TESbeneficiario b
                            	on b.TESBid = a.TESBid 
                        	left join SNegocios sn
                            	inner join SNContactos snc
                                	on snc.SNcodigo= sn.SNcodigo
                                	and SNCarea = 2 <!---que sean del area de tesoreria--->
                                on sn.SNid = a.SNid
                            where TESOPid =  #LvarTESOPid#   
                    </cfquery>    
                    
                   <cfloop query="rsEmail"> 
						<cfif len(trim(rsEmail.email))> 
                            <cfquery name="rsInserta" datasource="#Session.DSN#">
                                insert into SMTPQueue ( SMTPremitente, 	SMTPdestinatario, 	SMTPasunto, 
                                                        SMTPtexto, 		SMTPintentos, 		SMTPcreado, 
                                                        SMTPenviado, 	SMTPhtml, 			BMUsucodigo ) 
                                values ( <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#enviadoPor#">, <!---agarra el nombre y apellidos de session--->
                                        <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsEmail.email#">, 
                                        <cfqueryparam cfsqltype="cf_sql_varchar" 	value="Generacion de transferencia bancaria">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#contenido#">,
                                        0,	#now()#,	#now()#,	1,
                                        #Session.Usucodigo#
                                        ) 
                            </cfquery>
                              
                        </cfif>    
                	</cfloop>
                </cfloop>
        	</cfif>        
		<cfelse>
			<cfset LvarTESTLid = form.TESTLid>
        </cfif>

    </cftransaction>
	
	<cfif isdefined("LvarTESTLid")>
		<cflocation url="#LvarCFM#?TESTLid=#LvarTESTLid#">
	<cfelse>
		<cflocation url="#LvarCFM#">
	</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cflocation url="#LvarCFM#">



