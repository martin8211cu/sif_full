<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 27 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de cheques
----------->

<cfif IsDefined("form.Anular")>
	<cftransaction>
		<cfquery name="rsConsulta" datasource="#session.DSN#">
			select TESOPid
			from TEScontrolFormulariosD
			where TESid					= #session.Tesoreria.TESid#
			  and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
			  and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			  and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
		</cfquery>
		<cfquery name="rsOP" datasource="#session.DSN#">
			select TESOPestado, TESOPnumero
			  from TESordenPago
             where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
               and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
		</cfquery>
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
					,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
					,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1)
					,<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					,1
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  from TEScontrolFormulariosD
			 where TESid			   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>

		<cfif rsOP.TESOPestado EQ 12>
            <cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
                        method="sbReversarOrdenPago">
                <cfinvokeargument name="TESOPid" 	value="#rsConsulta.TESOPid#"/>
				<cfinvokeargument name="AnularOP"	value="no"/>
            </cfinvoke>
		<cfelseif rsOP.TESOPestado NEQ 110>
        	<cfthrow message="La OP num. #rsOP.TESOPnumero# no está emitida">
		</cfif>
        
		<!--- MODIFICAR ESTADO DE LA ORDEN DE COMPRA Y LA SOLICITUD DE LA  ORDEN --->
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set TESSPestado 	= 11	<!--- O.P. en Emision --->
			 where TESid 		= #session.Tesoreria.TESid#
			   and TESOPid 		= #rsConsulta.TESOPid#
			   and TESSPestado 	= 110
		</cfquery>	

		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set TESDPestado	= 11	<!--- O.P. en Emision --->
			 where TESid 		= #session.Tesoreria.TESid#
			   and TESOPid 		= #rsConsulta.TESOPid#
			   and TESDPestado 	= 110
		</cfquery>
        
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set TESOPestado	= 11,	<!--- O.P. en Emision --->
				   TESOPmsgRechazo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="CHEQUE ANULADO #form.TESCFDnumFormulario#: #form.TESOPmsgrechazo#">
					,TESTLid = null
					,TESCFLid = null
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESOPestado 	= 110
		</cfquery>	

		<!--- Limpia el numero de cheque anulado en la orden de pago, para que no de problemas en la impresion de cheques --->
		<!--- No se puede limpiar antes del sbReversarOrdenPago porque se requiere en el proceso --->
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set TESCFDnumFormulario = null
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESOPestado 	= 11
		</cfquery>	
	</cftransaction>
	<script language="javascript">
		<cfif rsOP.TESOPestado NEQ 110>
			alert("El Formulario del Cheque fue ANULADO\nLa Órden de Pago quedó EN EMISION lista para volverse a Pagar");
		<cfelse>
			alert("El Pago se REVERSO contablemente \nEl Formulario del Cheque fue ANULADO\nLa Órden de Pago quedó EN EMISION lista para volverse a Pagar");
		</cfif>
	</script>
</cfif>
<script language="javascript">
	location.href="anulacionCheques.cfm";
</script>
