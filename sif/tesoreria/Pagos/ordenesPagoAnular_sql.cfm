<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 30 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de ordenes de pago
----------->
<cf_navegacion name="TESOPid">
<cf_navegacion name="TESMPcodigo">

<cfif isdefined('Form.Anular')>
	<cftransaction>
		<cfquery name="rsOP" datasource="#session.DSN#">
			select op.TESOPid, op.CBidPago, op.TESMPcodigo, mp.TESTMPtipo, op.TESCFDnumFormulario, op.TESTDid, op.TESOPestado,
			tsr.TESTDreferencia, op.TESOPnumero
			  from TESordenPago op
			  	inner join TESmedioPago mp
				 	 on mp.TESid 		= op.TESid
					and mp.CBid			= op.CBidPago
					and mp.TESMPcodigo	= op.TESMPcodigo
				left join TEStransferenciasD tsr
					on tsr.TESOPid=op.TESOPid
			 where op.TESid = #session.Tesoreria.TESid#
			   and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESOPid#">
		</cfquery>
		<cfif rsOP.TESTMPtipo EQ "1">
			<!--- Anular cheque --->
			<cfquery datasource="#session.DSN#">
				update TEScontrolFormulariosD
				   set TESCFDestado 		= 3, <!--- ANULADO --->
					   TESCFDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
					   UsucodigoAnulacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   TESCFDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.CBidPago#">
				   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESMPcodigo#">
				   and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOP.TESCFDnumFormulario#">		  
				   and TESOPid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			</cfquery>
			<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
			<cfquery datasource="#session.DSN#">
				update TEScontrolFormulariosB
				   set TESCFBultimo = 0
				where TESid				   = #session.Tesoreria.TESid#
				   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.CBidPago#">
				   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESMPcodigo#">
				   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESCFDnumFormulario#">
			</cfquery>
			<!--- INSERTA UN REGISTRO CON LE MOVIMIENTO REALIZADO EN LA BITACORA DE FORMULARIOS --->	
			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosB
					(
						TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
						TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
					)
				select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1)
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						,1
						,#session.Usucodigo#
						,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
						,#session.Usucodigo#
						,#session.Usucodigo#
				  from TEScontrolFormulariosD
				 where TESid			   = #session.Tesoreria.TESid#
				   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.CBidPago#">
				   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESMPcodigo#">
				   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESCFDnumFormulario#">
				   and TESOPid 			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			</cfquery>
		<cfelseif rsOP.TESTMPtipo EQ "2" OR rsOP.TESTMPtipo EQ "3" OR rsOP.TESTMPtipo EQ "4">
			<!--- Anular transferencia --->
			<cfquery datasource="#session.DSN#">
				update TEStransferenciasD
				   set TESTDestado = 3, <!--- ANULADA --->
					   TESTDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
					   UsucodigoAnulacion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   TESTDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.CBidPago#">
				   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESMPcodigo#">
				   and TESTDid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESTDid#">		  
				   and TESOPid 			   	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			</cfquery>
		<cfelseif rsOP.TESTMPtipo EQ "5">
			<!--- Anular TCE --->
			<cfquery datasource="#session.DSN#">
				update TEStransferenciasD
				   set TESTDestado = 3, <!--- ANULADA --->
					   TESTDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
					   UsucodigoAnulacion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   TESTDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.CBidPago#">
				   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESMPcodigo#">
				   and TESTDid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESTDid#">		  
				   and TESOPid 			   	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50751" msg = "Tipo Medio de Pago incorrecto">
		</cfif>

		<cfif NOT (rsOP.TESOPestado EQ 12 OR rsOP.TESOPestado EQ 110)>
        	<cfthrow message="La OP num. #form.TESOPid# no está emitida">
		</cfif>

		<!--- MODIFICAR ESTADO DE LA ORDEN DE PAGO Y LA SOLICITUD DE PAGO --->
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set  TESSPestado 		= 13	/* TESSPestado = 13: OP ANULADA */
				  , TESSPmsgRechazo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">
				  , TESSPfechaRechazo	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				  , UsucodigoRechazo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			   and TESSPestado 	= #rsOP.TESOPestado#
		</cfquery>	
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set TESDPestado	= 13 /* Orden de Pago Cancelada */
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			   and TESDPestado 	= #rsOP.TESOPestado#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set TESOPestado	= 13, /* Orden de Pago Cancelada */
				   TESOPmsgRechazo 		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
				   UsucodigoCancelacion	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				   TESOPfechaCancelacion  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">			   
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.TESOPid#">
			   and TESOPestado 	= #rsOP.TESOPestado#
		</cfquery>	

		<cfif rsOP.TESOPestado EQ 12>
            <cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
                        method="sbReversarOrdenPago">
                <cfinvokeargument name="TESOPid"         value="#form.TESOPid#"/>
                <cfinvokeargument name="AnularOP"        value="yes"/>
                <cfinvokeargument name="AnularSP"        value="yes"/>
                <cfinvokeargument name="TESOPmsgrechazo" value="#form.TESOPmsgrechazo#"/>
            </cfinvoke>
		</cfif>


		<!--- JARR Cancelacion de Mov de Conciliacion en Mlibros y Cdlibros --->
		<cfquery name="rsOPML" datasource="#session.DSN#">
			select tsr.TESTDreferencia, ml.MLid
			from TEStransferenciasD tsr
				inner join MLibros ml
				on ml.MLdescripcion like '%EmiteOP.'+ <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESOPnumero#">+'%'
				and ml.MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOP.TESTDreferencia#">
			 where tsr.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESOPid#">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update MLibros
				set MLconciliado = 'S'
			where MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOPML.MLid#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update CDLibros
				set CDLconciliado = 'S',
					CDLmanual = 'S',
					CDLPreconciliado = 'P'
			where MLid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOPML.MLid#">
		</cfquery>
		<!--- TErmina --->
	</cftransaction>
	<script language="javascript">
		alert("El Pago se REVERSO contablemente\nEl formulario del Cheque o Transferencia fue ANULADO\nLa Órden de Pago quedó ANULADA\nLas Solictudes de Pago quedaron RECHAZADAS");
	</script>
</cfif>
<script language="javascript">
	location.href="ordenesPagoAnular.cfm";
</script>


