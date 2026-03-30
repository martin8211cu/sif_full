<!--- 
	Creado por: Gustavo Fonseca H.
		Fecha: 28-6-2005
		Motivo: Mantenimiento de Instrucciones de Pago. 
--->

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
				2,
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
	<cflocation url="impresion_Instrucciones_Pagos.cfm?TESTLid=#URLEncodedFormat(LvarTESTLid)#&CBid=#URLEncodedFormat(form.CBid)#">
<cfelseif IsDefined("form.btnSeleccionarOP")>
	<cfif isdefined("form.chk")>
		<cfquery name="rsTESTL" datasource="#session.dsn#">
			select CBid, TESMPcodigo
			  from TEStransferenciasL
			 where TESid	= #session.Tesoreria.TESid#
			   and TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		</cfquery>	
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set 	TESTLid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">,
					CBidPago	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.CBid#">,
					TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">,
					TESOPestado = 11
			 where TESid		= #session.Tesoreria.TESid#
			   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
			   and TESTLid		IS null
			   and TESCFLid		IS null
			   and TESOPestado = 11 <!--- En Emisión OP --->
			   and TESOPid in (#form.chk#)
		</cfquery>
	</cfif>
	<cflocation url="impresion_Instrucciones_Pagos.cfm?TESTLid=#form.TESTLid#">
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
	<cflocation url="impresion_Instrucciones_Pagos.cfm">
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
	<cflocation url="impresion_Instrucciones_Pagos.cfm?TESTLid=#url.TESTLid#">
<cfelseif IsDefined("form.btnInicioImpresion")>
	<!--- PASAR DE ESTADO 0 a 2 (el 1 n/a) --->
	<cfquery name="rsTESTL" datasource="#session.dsn#">
		select TESTLestado
		  from TEStransferenciasL
		 where TESid	= #session.Tesoreria.TESid#
		   and TESTLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cfif rsTESTL.TESTLestado NEQ "0">
		<cf_errorCode	code = "50766" msg = "Se esta tratando de Iniciar al Impresión de un Lote que no está en Estado 0=Preparacion">
	</cfif>

	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEStransferenciasL
			   set TESTLestado = 2
			 where TESid			= #session.Tesoreria.TESid#
			   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
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
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					,TESordenPago.TESOPid
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
					,0	/* En Emision */
					,#session.Usucodigo#
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,#session.Usucodigo#
			  from TESordenPago
			 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">	
			   and TESMPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESMPcodigo#">	
			   and TESTLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESTLid#">	
		</cfquery>
	</cftransaction>
	<cflocation url="impresion_Instrucciones_Pagos.cfm?TESTLid=#form.TESTLid#&Imprima=1">
<cfelseif IsDefined("form.btnResultado")>
	<!--- PASAR DE ESTADO 2 a 0,3--->
	<cfquery name="rsTESTL" datasource="#session.dsn#">
		select 	  CBid
				, TESMPcodigo
				, TESid
				, TESMPcodigo
				, TESTLestado
				, TESTMPtipo
				, TESTLfecha
				, Usucodigo
		  from TEStransferenciasL
		 where TESid			= #session.Tesoreria.TESid#
		   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
	</cfquery>
	<cfif rsTESTL.TESTLestado NEQ "2"> <!--- Despues de Impresion --->
		<cf_errorCode	code = "50779" msg = "Se esta tratando de Completar la Emisión de un Lote de Impresión de Instrucciones de Pago que no se ha impreso (Estado=2)">
	</cfif>

	<cftransaction>
		<!--- PASAR ESTADO DE OP, SP, DP a 12=OP aplicada --->
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			select TESOPid , TESTDid
			  from TEStransferenciasD
			 where TESid			= #session.Tesoreria.TESid#
			   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
			   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
			   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
		</cfquery>

		<cfloop query="rsTESTD">
			<cfset LvarRef = "form.TESTDreferencia_#rsTESTD.TESTDid#">
			<cfif isdefined(LvarRef)>
				<cfset LvarRef = evaluate(LvarRef)>
				<cfquery datasource="#session.dsn#">
					update TEStransferenciasD
					   set TESTDreferencia		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRef#" null="#trim(LvarRef) EQ ''#">
					 where TESid		= #session.Tesoreria.TESid#
					   and CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
					   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
					   and TESTDid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTD.TESTDid#">
				</cfquery>
			</cfif> 
		</cfloop>
	</cftransaction>

	<cftransaction>
		<!--- PASAR DE ESTADO 2 a 3: Se completa la impresión del Lote y se realiza la aplicación de documentos --->

		<cfset LvarCancelarMsg 	= form.TESTDmsgAnulacion>

		<cfquery name="rsTESTD" datasource="#session.dsn#">
			select TESOPid , TESTDid, TESTDreferencia
			  from TEStransferenciasD
			 where TESid			= #session.Tesoreria.TESid#
			   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
			   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
			   and TESTLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
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
					   set TESTDestado 			= 1	/* Instrucción Emitida = Impresa con Referencia */
						 , UsucodigoEmision		= #session.Usucodigo#
						 , TESTDfechaEmision	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where TESid		= #session.Tesoreria.TESid#
					   and CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTL.CBid#">
					   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.TESMPcodigo#">
					   and TESTDid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESTD.TESTDid#">
				</cfquery>
		
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado 	= 12	/* Orden de Pago Emitida */
					 where TESid 		= #session.Tesoreria.TESid#
					   and TESOPid 		= #rsTESTD.TESOPid#
					   and TESSPestado 	= 11
				</cfquery>	
				<cfquery datasource="#session.dsn#">
					update TESdetallePago 
					   set TESDPestado	= 12
					 where TESid 		= #session.Tesoreria.TESid#
					   and TESOPid 		= #rsTESTD.TESOPid#
					   and TESDPestado 	= 11
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESordenPago
					   set TESOPestado			= 12
						 , CBidPago				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESTL.CBid#">
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
		<cfelse>
			<cfset LvarTESTLid = form.TESTLid>
		</cfif>

	</cftransaction>
	
	<cfif isdefined("LvarTESTLid")>
		<cflocation url="impresion_Instrucciones_Pagos.cfm?TESTLid=#LvarTESTLid#">
	<cfelse>
		<cflocation url="impresion_Instrucciones_Pagos.cfm">
	</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cflocation url="impresion_Instrucciones_Pagos.cfm">



