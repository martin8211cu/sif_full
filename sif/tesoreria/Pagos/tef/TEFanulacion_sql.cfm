<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 27 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de cheques
----------->

<cfif IsDefined("form.Anular")>
	<cftransaction>
		<cfquery name="rsConsulta" datasource="#session.DSN#">
			select tef.TESOPid, tef.TESTDreferencia, 
				case TESTMPtipo
					when 1 then 'CHK'
					when 2 then 'TRI'
					when 3 then 'TRE'
					when 4 then 'TRM'
					when 5 then 'TCE'
				end tipo
			  from TEStransferenciasD tef
					inner join TESmedioPago mp
					  on mp.TESid 		= tef.TESid
					 and mp.CBid 		= tef.CBid
					 and mp.TESMPcodigo = tef.TESMPcodigo
			 where tef.TESid		= #session.Tesoreria.TESid#	
			   and tef.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
			   and tef.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and tef.TESTDid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTDid#">	
		</cfquery>
		<!--- Anular TEF --->
		<cfquery datasource="#session.DSN#">
			update TEStransferenciasD
			   set TESTDestado = 3, <!--- ANULADO --->
				   TESTDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPmsgrechazo#">,
				   UsucodigoAnulacion	= #session.Usucodigo#,
				   TESTDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 where TESid		= #session.Tesoreria.TESid#	
			   and CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
			   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESTDid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTDid#">	
		</cfquery>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
					method="sbReversarOrdenPago">
			<cfinvokeargument name="TESOPid" 	value="#rsConsulta.TESOPid#"/>
			<cfinvokeargument name="AnularOP"	value="no"/>
		</cfinvoke>

		<!--- MODIFICAR ESTADO DE LA ORDEN Y LA SOLICITUD DE PAGO --->
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
			   set TESOPestado			=11,	<!--- O.P. en Emision --->
				   TESOPmsgRechazo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConsulta.tipo# ANULADO #rsConsulta.TESTDreferencia#: #form.TESOPmsgrechazo#">
					,TESTLid = null
					,TESCFLid = null
					<!--- Limpia el numero de cheque anulado en la orden de pago, para que no de problemas en la impresion de cheques --->
					<!--- No se puede limpiar antes del sbReversarOrdenPago porque se requiere en el proceso --->
					,TESTDid = null
			 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.TESOPid#">
			   and TESOPestado 	= 110
		</cfquery>	
	</cftransaction>
	<script language="javascript">
		alert("El Pago se REVERSO contablemente \nEl Registro del <cfoutput>#rsConsulta.tipo#</cfoutput> fue ANULADO\nLa Órden de Pago quedó EN EMISION lista para volverse a Pagar");
	</script>
</cfif>
<script language="javascript">
	location.href="TEFanulacion.cfm";
</script>
