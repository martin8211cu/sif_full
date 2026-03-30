<cfif IsDefined("form.AnularEspecial")>
	<cftransaction>
		<cfquery name="rsCtaTraslado" datasource="#session.DSN#">
			select CFformato, CPcuenta
			  from CFinanciera
			where Ecodigo		= #session.Ecodigo#
			  and CFcuenta		= #form.CFcuenta#
		</cfquery>
		<cfif rsCtaTraslado.CPcuenta NEQ "">
			<cfthrow message="La cuenta '#rsCtaTraslado.CFformato#' no puede tener control de presupuesto">
		</cfif>
		<cfset form.TESOPmsgrechazo = 'TRASLADO MONTO A #rsCtaTraslado.CFformato#: #form.TESOPmsgrechazo#'>
		<cfquery name="rsConsulta" datasource="#session.DSN#">
			select TESOPid
			from TEScontrolFormulariosD
			where TESid					= #session.Tesoreria.TESid#
			  and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
			  and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			  and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
		</cfquery>
		<cfquery name="rsOP" datasource="#session.DSN#">
			select TESOPestado
			  from TESordenPago
             where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
               and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
		</cfquery>
        <cfif rsOP.TESOPestado NEQ 12>
        	<cfthrow message="La OP num. #rsTESOP.TESOPnumero# debe estar en estado '12=Emitida y Aplicada' para poderla trasladar a otra cuenta">
        </cfif>
		<!--- Anular cheque --->
		<cfquery datasource="#session.DSN#">
			update TEScontrolFormulariosD
			   set TESCFDestado = 3, <!--- ANULADO --->
				   TESCFDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
				   UsucodigoAnulacion	= #session.Usucodigo#,
				   TESCFDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 where TESid				= #session.Tesoreria.TESid#
			   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
			   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">		  
		</cfquery>
		<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
		<cfquery datasource="#session.DSN#">
			update TEScontrolFormulariosB
			   set TESCFBultimo = 0
			where TESid				   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>
		<!--- INSERTA UN REGISTRO CON LE MOVIMIENTO REALIZADO EN LA BITACORA DE FORMULARIOS --->	
		<cfquery datasource="#session.dsn#">
			insert into TEScontrolFormulariosB
				(
					TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
					TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
				)
			select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1)
					,NULL
					,1
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  from TEScontrolFormulariosD
			 where TESid			   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>

		<cfset form.TESOPmsgrechazo = 'CHEQUE ANULADO #form.TESCFDnumFormulario# Y #form.TESOPmsgrechazo#'>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select min(EcodigoOri) as EcodigoOri, max(EcodigoOri) as EcodigoOri2
			  from TESsolicitudPago
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESSPestado 	= 12
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set  TESSPestado 		= 13	/* TESSPestado = 13: OP ANULADA */
				  , TESSPmsgRechazo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">
				  , TESSPfechaRechazo	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				  , UsucodigoRechazo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  , CFcuentaTraslado	= 
				  		<cfif rsSQL.EcodigoOri EQ rsSQL.EcodigoOri2>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">
						<cfelse>
							case when EcodigoOri = #rsSQL.EcodigoOri# 
								then <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">
								else coalesce (
									(
										select CFcuenta
										  from CFinanciera
										 where Ecodigo	 = TESsolicitudPago.EcodigoOri
										   and CFformato = (select CFformato from CFinanciera where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">)
									 )
									 , 1/0)		<!--- No quitar este error, es para saber que no hay cuenta en la otra empresa --->
							end
						</cfif>
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESSPestado 	= 12
		</cfquery>	
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set TESDPestado	= 13 /* Orden de Pago Cancelada */
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESDPestado 	= 12
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set TESOPestado	= 13, /* Orden de Pago Cancelada */
				   TESOPmsgRechazo 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
				   UsucodigoCancelacion	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				   TESOPfechaCancelacion  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">			   
				  , CFcuentaTraslado	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESOPestado 	= 12
		</cfquery>	

		<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
					method="sbReversarOrdenPago">
			<cfinvokeargument name="TESOPid" 	value="#rsConsulta.TESOPid#"/>
			<cfinvokeargument name="AnularOP"	value="yes"/>
			<cfinvokeargument name="AnularSP"	value="yes"/>
		</cfinvoke>
	</cftransaction>
	<script language="javascript">
		alert("El Pago se TRASLADÓ contablemente a la Cuenta #rsCtaTraslado.CFformato#\nEl formulario del Cheque fue ANULADO\nLa Órden de Pago quedó ANULADA\nLas Solictudes de Pago quedaron RECHAZADAS");
	</script>
</cfif>
<script language="javascript">
	location.href="anulacionCheques2.cfm";
</script>
